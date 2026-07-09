Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9EE3F0747
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 12:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783598847; cv=none; b=Pp23QxQuVG/YsQoWWwnYvNwR1kKadbgg7Wf6P9nPJ93vMA3jTVKvfctm3NsHfX1wucC27fga6dMQd9/ywWYlFVwjLuU3HCJPNvG/USpHOhc8i47uR1keMqsXCmKUbOabD7v1C2OQpOzIK1oLpkaH3OCo9dzGDYtwL/S3U+7REPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783598847; c=relaxed/simple;
	bh=Yj7eZP3NjfSoBG+KpinZc8al4Mu+iRj1BVcKemJUwTI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=t7F5Ef5yeHu8W+rk2NuAV5B4+BBlsdzZ8NtGRjEiBOHA5No/7QYwuI5ynYkw5VBoti57LzvL57GwWL93JmcCjG8PnqoT4/fbcsAe0UFIkmg+3HptxIVL5knnCk0428FrfYxRLJhPlSw3QnfoRe/jY6mLzaxkScJ8wPPIRwTj4bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1fSscrF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1fSscrF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A65A11F000E9;
	Thu,  9 Jul 2026 12:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783598845;
	bh=jmqYXeTbZ593sQL3VChjh0Fzf2rH1J7UR+recY54xTU=;
	h=From:To:Cc:Subject:Date;
	b=Q1fSscrFfRFU2LSeM2T+FqUgMQQT4GVva85yhrMSYX6kHa9EiWx6S+Qp/zw4dOKBM
	 pApBgWQ4/Bj/n2CiBZwGKPM/6FI90D85wUkt8czcqSxMWRlV+kBA8Rkl1kGuEffN1t
	 3LqK3DnArhb6Zay7waRctgU6u2hLuBJGwmQtY7ba2xMzdQabMLq++aGYs58GyHkjnT
	 9/sQyzgyVIO6AmyDCfPuJZlHdt/BGKAuSwDnzSBc79TH0FpbIZcsXWFp1CUg+RBjYZ
	 cVB4DoU1/mxCkpIbKWVu297YrlXbg2gPATW3duIU66P5rXZE89AtekJtpACqldbLkJ
	 qaYwfHhKkzzHQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fs/ntfs3: handle partial allocation in attr_data_get_block_locked()
Message-ID: <69fc5364-da7a-4a91-bdff-078af00db6f6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  9 Jul 2026 12:07:25 +0000 (UTC)

When allocating clusters for a sparse or compressed attribute in
attr_data_get_block_locked(), the requested virtual cluster number (vcn0)
is aligned down to a frame boundary (vcn). The function then attempts to
allocate a full frame of clusters.

If the disk is nearly full and highly fragmented, attr_allocate_clusters()
might only manage to allocate a small fragment and return success with a
partial allocation length. If this partial allocation is so small that it
does not even reach the originally requested vcn0 (i.e., end <= vcn0), vcn0
remains unallocated (a sparse hole).

When the code subsequently calls run_lookup_entry() for vcn0, it finds the
original SPARSE_LCN entry, which triggers a WARN_ON(1).

Fix this by adding a check to verify if the partial allocation reached
vcn0. If it did not (vcn0 >= end), treat this as an -ENOSPC failure and
jump to the undo1 label. This safely rolls back the partial allocation,
restores the original size, and repacks the runs, leaving the inode in a
consistent state before returning the error to the caller.

WARNING: fs/ntfs3/attrib.c:1236 at attr_data_get_block_locked+0x1980/0x25d0
fs/ntfs3/attrib.c:1236
RIP: 0010:attr_data_get_block_locked+0x1980/0x25d0 fs/ntfs3/attrib.c:1236
Call Trace:
 <TASK>
 attr_data_get_block+0x1f1/0x2a0 fs/ntfs3/attrib.c:979
 ntfs_fallocate+0xd3d/0xf70 fs/ntfs3/file.c:670
 vfs_fallocate+0x663/0x7f0 fs/open.c:338
 ksys_fallocate fs/open.c:362 [inline]
 __do_sys_fallocate fs/open.c:367 [inline]
 __se_sys_fallocate fs/open.c:365 [inline]
 __x64_sys_fallocate+0xbf/0x110 fs/open.c:365
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fixes: 099ef9ab9203 ("fs/ntfs3: implement iomap-based file operations")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+7be6ad5cb228286af3e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7be6ad5cb228286af3e3
Link: https://syzkaller.appspot.com/ai_job?id=3c9dee6e-001d-4972-8bf6-f6c960708246
To: "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>
To: <ntfs3@lists.linux.dev>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index c621a4c58..786fd0ec0 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1227,6 +1227,10 @@ int attr_data_get_block_locked(struct ntfs_inode *ni, CLST vcn, CLST clen,
 	total_size = total_size0 + ((u64)*len << cluster_bits);
 
 	if (vcn != vcn0) {
+		if (vcn0 >= end) {
+			err = -ENOSPC;
+			goto undo1;
+		}
 		if (!run_lookup_entry(run, vcn0, lcn, len, NULL)) {
 			err = -EINVAL;
 			goto out;


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
