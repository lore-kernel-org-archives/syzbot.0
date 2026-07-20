Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFF6396591
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 14:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557528; cv=none; b=bC/7NsffOx1OjMyFEtqCNraelw0qKDeigKomPSsLoc+3mi9bmX6nwsre0KQm3O14EzJZuMwCizzoKV95Xpuy43/KvKB0OyzOjC1hTVpQVKROxpJtZqyH+yu7f3kXcaBYcGozZH7rMSyDIElu1Aox4Fbuz8i28/0SGhgQouXnBcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557528; c=relaxed/simple;
	bh=4L2nlBDtuU+AWA3oejs4GsBVwxQPXgHfbml2QoBML5U=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=fADDZGTZhctgzxtLipq0yO1BnoLTWTnbAcgNFeNCUXxZ3Sv7lyIdHWBzWJTQTZrle91I5i89DxTnQHjfO4Qu3kJ2rjXjY87VoPbFHB4KzQPZzZ1BCJe2nssidM+n6AF5bzR+XujaKKIwLKkDlhXW548bKlQxRJl5NbxqeVAb6uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czdpnxRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czdpnxRs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E6E01F000E9;
	Mon, 20 Jul 2026 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557527;
	bh=xidEuyzwb6XGiZQBYCThN/KtJR0cDJvzK7ZrewuN1Jc=;
	h=From:To:Cc:Subject:Date;
	b=czdpnxRsP+B2+KtOs4KjG0m7iLxZZlokjm8pifywHXo7kfTI/88Ot69OfNJlagTyW
	 0VTx7R74Hm6iv1GGni44aiWvWmsPsKATqjmTbClrgjdQelSV560bEZOs8E/FpNUdLk
	 ZC7ruCGrzzMsh0XIz5/0nWwhFpy6Jp2S91aKVXo7Hu+UyJ1vqhsZehffK5A7MD+KJ5
	 4mCKNdF7jXSfLMVIapiPztt+/k03qTEBghB0OgEofVWmLPzddQbxsjPRCyZHfmCdKM
	 4zAknNxGgeJfpWVNe/UT/dWDi67gdmYXL9icHKc61IionNOxLw3spgIslaYSdDhH/S
	 +O3UKdQdMhppA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fs: fix superblock freeze rollback on sync_blockdev failure
Message-ID: <fcc77fd9-e38f-49f9-8268-e86683444f29@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 20 Jul 2026 14:25:27 +0000 (UTC)

If sync_blockdev() fails during fs_bdev_freeze(), the superblock is left in
a frozen state, but the block device is not. When the filesystem is later
unmounted and destroyed, the s_writers.rw_sem per-CPU rw-semaphores are
freed while still held for write, triggering a warning in rcu_sync_dtor():

READ_ONCE(rsp->gp_state) == GP_PASSED
WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0xcd/0x180
kernel/rcu/sync.c:177, CPU#0: kworker/0:2/5024
Call Trace:
 <TASK>
 percpu_free_rwsem+0x43/0x80 kernel/locking/percpu-rwsem.c:42
 destroy_super_work+0x217/0x310 fs/super.c:284
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

This happens because of two issues. First, in fs_bdev_freeze(), if
freeze_super() succeeds but sync_blockdev() fails, thaw_super() is not
called to roll back the freeze. Second, in exfat, an I/O error during
sync_blockdev() triggers the error handler (__exfat_fs_error()), which
directly sets SB_RDONLY without holding the s_umount semaphore. If
thaw_super() is called after this, it sees the filesystem as read-only and
skips releasing the freeze semaphores.

Fix this by adding the missing thaw_super() rollback in fs_bdev_freeze()
when sync_blockdev() fails. Additionally, modify the exfat error handler to
set EXFAT_FLAGS_SHUTDOWN instead of directly setting SB_RDONLY, which
prevents confusing the VFS freeze logic and allows thaw_super() to
correctly release the semaphores.

Fixes: 49ef8832fb1a ("bdev: implement freeze and thaw holder operations")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+823cd0d24881f21ab9f1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=823cd0d24881f21ab9f1
Link: https://syzkaller.appspot.com/ai_job?id=431fcee8-0777-4619-a114-4a86af680864
To: "Christian Brauner" <brauner@kernel.org>
To: "Namjae Jeon" <linkinjeon@kernel.org>
To: <linux-fsdevel@vger.kernel.org>
To: "Sungjong Seo" <sj1557.seo@samsung.com>
To: "Alexander Viro" <viro@zeniv.linux.org.uk>
Cc: "Jan Kara" <jack@suse.cz>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yuezhang Mo" <yuezhang.mo@sony.com>

---
diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
index 6f11a96a4..dbb3b2907 100644
--- a/fs/exfat/misc.c
+++ b/fs/exfat/misc.c
@@ -41,7 +41,14 @@ void __exfat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
 		panic("exFAT-fs (%s): fs panic from previous error\n",
 			sb->s_id);
 	} else if (opts->errors == EXFAT_ERRORS_RO && !sb_rdonly(sb)) {
-		sb->s_flags |= SB_RDONLY;
+		set_bit(EXFAT_FLAGS_SHUTDOWN, &EXFAT_SB(sb)->s_exfat_flags);
+		/*
+		 * We have already set EXFAT_FLAGS_SHUTDOWN flag to stop all updates
+		 * to filesystem, so it doesn't need to set SB_RDONLY flag here
+		 * because the flag should be set covered w/ sb->s_umount semaphore
+		 * via remount procedure, otherwise, it will confuse code like
+		 * freeze_super() which will lead to deadlocks and other problems.
+		 */
 		exfat_err(sb, "Filesystem has been set read-only");
 	}
 }
diff --git a/fs/super.c b/fs/super.c
index a8fd61136..909d8b9ab 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1481,8 +1481,23 @@ static int fs_bdev_freeze(struct block_device *bdev)
 	else
 		error = freeze_super(sb,
 				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
-	if (!error)
+	if (!error) {
 		error = sync_blockdev(bdev);
+		if (error) {
+			if (sb->s_op->thaw_super)
+				(void)sb->s_op->thaw_super(
+					sb,
+					FREEZE_MAY_NEST |
+						FREEZE_HOLDER_USERSPACE,
+					NULL);
+			else
+				(void)thaw_super(
+					sb,
+					FREEZE_MAY_NEST |
+						FREEZE_HOLDER_USERSPACE,
+					NULL);
+		}
+	}
 	deactivate_super(sb);
 	return error;
 }


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
