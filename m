Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1043D382288
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 21:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778621693; cv=none; b=HJu4E8oPQxpOuAoQxezW4ngXtTy/mjMSqijqEMstrJ2gJJ3WfBT42RjlQZb2GobFwgYOtPS2NSypCagUhETaHxvv//7Aa2XrWJOHDmLnturtJcUsAXPMpJTQCRFB1XVVxAGrE+ojwGNv8OsGdwWOK39cED3Ceut0/AUEEBtOu64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778621693; c=relaxed/simple;
	bh=I9VNQQWeEfTCTrGHBYaDgsOp6d4TYpgSJCSFU65fmeE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=shO7oUeClN8j3syz4CP3/L1vZHtXoEkDnALUK7yzA7OnB5Bf6zvpZfmYJu0/KvSvEKhOXmCyd+Qqji86DqV47Tvf4Xp+u5U+vgMSzRQR11H2VIt0ez2MId8EEgOW/yomBZZX7JA68zgYCcBF059H1tsrjlSzc1Ds7U0jgQIbVGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZYa5xcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZYa5xcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D420AC2BCB0;
	Tue, 12 May 2026 21:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778621692;
	bh=I9VNQQWeEfTCTrGHBYaDgsOp6d4TYpgSJCSFU65fmeE=;
	h=From:To:Cc:Subject:Date:From;
	b=IZYa5xcq1UQ965WxawAFEpdDbXaCgNhPt99uMzpeNaPtqj4VBbo30dWpEz/zzy0Jf
	 sSX2QbIDv+p6H/neHvZNXx7l4B/4ZEdTxMRxiJiqQQZa5MrcpYNsvNSJgOYouygsdH
	 CLBmRSIiTOlatGThdaJQ5euZg3eKmHEIGXMTlThBQ2kpG8xet76Eh3o4bk7LSfZCCN
	 mQ0OQtuizJJ3WFRLTTr5K4g4usAZFi5H1sQmRalYzyn/6r5Jonpud9pWo2otK49t24
	 jBwQYAEPH+DpaiiOrEwjrHaKhVPUA4/Jgdd1/udqlcPZJl6uy6339HJXGymwO9qObr
	 iDGd8pmSFv5TA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write
Message-ID: <1500143f-7374-4e4a-9260-3961428b155d@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 21:34:52 +0000 (UTC)

A circular locking dependency (AB-BA deadlock) was detected between the
ORPHAN_DIR_SYSTEM_INODE and EXTENT_ALLOC_SYSTEM_INODE locks in OCFS2.

The first path, ocfs2_wipe_inode(), acquires the lock for
ORPHAN_DIR_SYSTEM_INODE to prevent concurrent recovery from truncating
the same file. While holding this lock, it calls ocfs2_xattr_remove() to
free extended attributes, which in turn calls ocfs2_xattr_free_block().
To free the extent, ocfs2_xattr_free_block() acquires the lock for
EXTENT_ALLOC_SYSTEM_INODE. This establishes the lock order:
ORPHAN_DIR_SYSTEM_INODE -> EXTENT_ALLOC_SYSTEM_INODE.

The second path, ocfs2_dio_end_io_write(), is called when a direct IO
write finishes to mark unwritten extents as written and update the inode
size. It calls ocfs2_lock_allocators(), which acquires the lock for
EXTENT_ALLOC_SYSTEM_INODE and stores it in meta_ac. After performing the
necessary transactions and committing them, if the file was orphaned, it
calls ocfs2_del_inode_from_orphan() to remove the file from the orphan
directory. This function acquires the lock for ORPHAN_DIR_SYSTEM_INODE.
However, meta_ac (and thus the EXTENT_ALLOC_SYSTEM_INODE lock) is not
freed until the very end of ocfs2_dio_end_io_write(), after
ocfs2_del_inode_from_orphan() returns. This establishes the reverse lock
order: EXTENT_ALLOC_SYSTEM_INODE -> ORPHAN_DIR_SYSTEM_INODE, leading to
a potential deadlock.

To fix this, release the allocator locks (data_ac and meta_ac) before
calling ocfs2_del_inode_from_orphan() in ocfs2_dio_end_io_write(). The
allocator locks are only needed for the transaction that marks extents
as written and updates the inode size. Once the transaction is
committed, data_ac and meta_ac are no longer needed. By calling
ocfs2_free_alloc_context() on data_ac and meta_ac right after the
transaction is committed and before ocfs2_del_inode_from_orphan(), we
release EXTENT_ALLOC_SYSTEM_INODE before acquiring
ORPHAN_DIR_SYSTEM_INODE, breaking the circular dependency and preventing
the deadlock.

Fixes: d647c5b2fbf81560818dacade360abc8c00a9665 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+7df4afa14aeda476a7a1@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=7df4afa14aeda476a7a1
Link: https://syzkaller.appspot.com/ai_job?id=4acc303c-bf15-4295-b70b-d13d7ef6a323
To: <linux-kernel@vger.kernel.org>
Cc: <jlbec@evilplan.org>
Cc: <joseph.qi@linux.alibaba.com>
Cc: <mark@fasheh.com>
Cc: <ocfs2-devel@lists.linux.dev>

---
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6ec198bda..74b41709b 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2372,6 +2372,15 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 unlock:
 	up_write(&oi->ip_alloc_sem);
 
+	if (data_ac) {
+		ocfs2_free_alloc_context(data_ac);
+		data_ac = NULL;
+	}
+	if (meta_ac) {
+		ocfs2_free_alloc_context(meta_ac);
+		meta_ac = NULL;
+	}
+
 	/* everything looks good, let's start the cleanup */
 	if (!ret && dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
