Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A73385D66
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780075867; cv=none; b=YwNFG1yPTNkV94yn7NXN5feJ4CliP604/HY9zI27Ww3Yw3pbr75ZtlEO7yFDKJl7MUY5cm7T/ZYRbQ+uC3KNZ6wZwTa3pQglpDD75JI7a2/vXpuM80ocs6hRzTVwOzXyZ95zdYi9DPwIXiVtOVyRdHFaCw9r+kSGnD3fQ27Z/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780075867; c=relaxed/simple;
	bh=NQcl378Ms5FvY+xNb1YdZCbPLGnNkVZkQJLPERy779U=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ogr4XHxabwLyscZuDslD0pXq83oRsVK1VXZWHZgiwAbXu5QlAm89mZoMKlDUcqTdyuQUM7tyNBFkfpv5Brs3cvJOFdIhdM3QDzY+14AnqeSSIWQIpfXVcd/ol3I70fxde2DfImQ8SQygtp9CBS21WMsAQAhbmJlyK+g+HuHH278=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Johnxcod; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Johnxcod"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 48A291F00893;
	Fri, 29 May 2026 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075866;
	bh=0kwsBtpzNRTLrhBhsTWlOk3vetJD2sejMjV1om/SYnQ=;
	h=From:To:Cc:Subject:Date;
	b=JohnxcodYUzoTiw0Ev0zp6WupwsLNU+WW8AlLiEEri/PPM9/bAZeqAbdcGDNP48Am
	 ZhwynXggI47q3OwJsd+m4Tu6PU4uEADxNilwLzSYZQ0KlPdwBcXXA5OhKqTkBGFM3Z
	 zLIzrxnhtsBOebZt85R+qIzewYTYDbVLt9HaCmuoKbK93fwEGijw3SMqAH++hbPDAb
	 DWNMWBGotCS5KfTMEIa1EGOSybWthAlhrjVfJeXtpJvAmyR7l9y36NotWsQMYsU6rj
	 RXiiQnr4k5fiZWXmMHl+hokEafI9hnsY34YDlSpbUfxDOIG+Au97mcIKbBfebWatkx
	 HZ/VqLWdYF0CA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write()
Message-ID: <008b2675-2e48-4150-a1ec-e68026253bad@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 29 May 2026 17:31:06 +0000 (UTC)

A circular locking dependency can occur involving three OCFS2 system inode
locks: INODE_ALLOC_SYSTEM_INODE, EXTENT_ALLOC_SYSTEM_INODE, and
ORPHAN_DIR_SYSTEM_INODE.

The circular dependency is formed by three separate code paths. First, in
ocfs2_mknod(), the code reserves an inode by acquiring the
INODE_ALLOC_SYSTEM_INODE lock, and then reserves metadata blocks by
acquiring the EXTENT_ALLOC_SYSTEM_INODE lock. Second, in
ocfs2_dio_end_io_write(), the code allocates metadata blocks for unwritten
extents, acquiring the EXTENT_ALLOC_SYSTEM_INODE lock. Later in the same
function, if the inode was orphaned, it calls
ocfs2_del_inode_from_orphan(), which acquires the ORPHAN_DIR_SYSTEM_INODE
lock. The allocation context is only freed at the end of the function,
meaning the EXTENT_ALLOC_SYSTEM_INODE lock is held while
ORPHAN_DIR_SYSTEM_INODE is acquired. Third, in ocfs2_wipe_inode(), the
ORPHAN_DIR_SYSTEM_INODE lock is acquired first to prevent races with
recovery completion, and then it calls ocfs2_remove_inode(), which acquires
the INODE_ALLOC_SYSTEM_INODE lock to free the inode.

This patch breaks the cycle by addressing the dependency in
ocfs2_dio_end_io_write(). The data_ac and meta_ac allocation contexts are
only needed for the transaction that marks the extents as written. Once the
transaction is committed and the allocation semaphore is released, these
contexts are no longer needed. We can safely free them, which releases the
EXTENT_ALLOC_SYSTEM_INODE lock, before calling
ocfs2_del_inode_from_orphan(). This ensures that the
EXTENT_ALLOC_SYSTEM_INODE lock is dropped before we attempt to acquire the
ORPHAN_DIR_SYSTEM_INODE lock, successfully breaking the circular
dependency.

Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoid credit exhaustion")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b225d4dfce6219600c42
Link: https://syzkaller.appspot.com/ai_job?id=c86e9953-fff6-40ca-b2f0-eff12366a33a
To: "Joel Becker" <jlbec@evilplan.org>
To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
To: "Mark Fasheh" <mark@fasheh.com>
To: <ocfs2-devel@lists.linux.dev>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 6ec198bda..4acdbb708 100644
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
@@ -2383,10 +2392,6 @@ static int ocfs2_dio_end_io_write(struct inode *inode,
 	ocfs2_inode_unlock(inode, 1);
 	brelse(di_bh);
 out:
-	if (data_ac)
-		ocfs2_free_alloc_context(data_ac);
-	if (meta_ac)
-		ocfs2_free_alloc_context(meta_ac);
 	ocfs2_run_deallocs(osb, &dealloc);
 	ocfs2_dio_free_write_ctx(inode, dwc);
 


base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
