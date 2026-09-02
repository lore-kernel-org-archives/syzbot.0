Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6693839B8
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788375365; cv=none; b=bhyEzvVbXzPcQyCJ7mxQmh8ZBvsu93aU5a+1Xk/A33x+JsE5gAjSM8+Q2gggODwEsV+W5Clly22SZdhWryzhZjm0fI1YYtjHOQP+HPygNYIvLDE6puyT0KbVJ7l8PM/roq+91cbn9u73JCI7Tx7MjKXdrapkVD7YGk+ZaZkt96Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788375365; c=relaxed/simple;
	bh=tfx0vE/ptQ0osinrq2xszWXgL24+hIy+1OCRW3RnfG4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=uynLB186WR3VFHe1c/Vr4FuBEmEuUgA79AS+fxpA5V4Rg4jg6lApgTTrl0jd20ALTivnM1jYvM6Wn9K1cA16T1CbFwVRog2nUcyMZGB6V15Gz8gxtxfHrxbeG9lfLH/2eVHaJd6TWIxgHbxjsMvIs4g1opsBH0Zs+xg9iCc4WVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yj/oMRaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yj/oMRaf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 94DEA1F000E9;
	Wed,  2 Sep 2026 18:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788375362;
	bh=ibissK6IPhEOL+RjNB5VYsc/DiRON4VJRbkoq4XyFlw=;
	h=From:To:Cc:Subject:Date;
	b=Yj/oMRafVh98NFHdwTWFuZUY9dlke/PcSVr0wWclF4I9kiXhlzevxX6RUrIa4j77m
	 wEX9CCd//wy7138vk3IKD7c1nyvgBoMvbxLDbJNmws/cwmFCuqP6mfmOlpXrEB2Kjy
	 axyFqhQtl/QZ4AlbwdnTmPyOvkJFbCK6Z+gjBWGOkhEgLbmqOSOWa8/N32Um3GqECA
	 vgS/rYdf+aBF+nI0MfjBZNS/WX3pCl2acpQx7otmE05ZeEHJuSdngAjWUAKxkiVKhB
	 zWzyrEUiaumwMA/6W6gjfK5a3YbaTQyYddA6M6PcJrrgqIg1U2HwPe/SW+tnxRbHr7
	 4QDRy6gX451Mw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] autofs: fix memory and pipe leaks on fill_super error paths
Message-ID: <f8aa6092-be10-4318-96f5-e3ea86e416c3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  2 Sep 2026 18:56:02 +0000 (UTC)

During autofs superblock initialization in autofs_fill_super(), two
resource leak issues can occur on error paths:

First, autofs_fill_super() allocates a root autofs_info structure via
autofs_new_ino() prior to allocating the root inode via autofs_get_inode().
If autofs_get_inode() fails (for instance, under memory pressure),
autofs_fill_super() returns -ENOMEM directly without freeing the allocated
autofs_info structure. Because the autofs_info has not yet been attached to
the root dentry (s->s_root->d_fsdata), standard VFS superblock cleanup
cannot free it, leading to a memory leak:

BUG: memory leak
unreferenced object 0xffff8881074fbc00 (size 192):
  backtrace (crc 69a9bad1):
    __kmalloc_cache_noprof+0x1b7/0x400 mm/slub.c:5559
    autofs_new_ino fs/autofs/inode.c:16 [inline]
    autofs_fill_super+0x74/0x280 fs/autofs/inode.c:321
    vfs_get_super fs/super.c:1405 [inline]
    get_tree_nodev+0x6f/0xc0 fs/super.c:1424
    vfs_get_tree+0x3a/0x130 fs/super.c:1947
    vfs_cmd_create+0x6d/0x110 fs/fsopen.c:231
    __se_sys_fsconfig+0x5b8/0x6f0 fs/fsopen.c:350
    do_syscall_64+0x126/0x350 arch/x86/entry/syscall_64.c:84
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Second, struct autofs_sb_info is initialized with the AUTOFS_SBI_CATATONIC
flag set in autofs_alloc_sbi(), and sbi->pipe is populated when parsing the
control pipe file descriptor. The AUTOFS_SBI_CATATONIC flag is cleared only
at the very end of autofs_fill_super(). If autofs_fill_super() fails before
clearing this flag, VFS superblock destruction calls autofs_kill_sb(),
which calls autofs_catatonic_mode(sbi). However, autofs_catatonic_mode()
checked if AUTOFS_SBI_CATATONIC was already set and returned immediately
without releasing sbi->pipe via fput(), resulting in a leaked pipe file
reference.

Fix these leaks by:
1. Reordering root inode and root dentry creation in autofs_fill_super() so
that autofs_new_ino() is called only after s->s_root is successfully
created. If autofs_get_inode() or d_make_root() fails, no autofs_info has
been allocated yet. Once autofs_new_ino() succeeds, it is immediately
attached to s->s_root->d_fsdata, ensuring that any subsequent failure in
autofs_fill_super() properly cleans it up via autofs_dentry_release()
during superblock teardown.
2. Updating autofs_catatonic_mode() to check and release sbi->pipe via
fput() and reset sbi->pipe and sbi->pipefd even if AUTOFS_SBI_CATATONIC is
already set.

Fixes: 66917f85db60 ("autofs: add: new_inode check in autofs_fill_super()")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+df1db6e034b3953e19f5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=df1db6e034b3953e19f5
Link: https://syzkaller.appspot.com/ai_job?id=fb78862e-8c53-4157-80dc-3813ad0b70f3
To: <autofs@vger.kernel.org>
To: "Ian Kent" <raven@themaw.net>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index c1e210cec..1e2078ee9 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -315,13 +315,6 @@ static int autofs_fill_super(struct super_block *s, struct fs_context *fc)
 	set_default_d_op(s, &autofs_dentry_operations);
 	s->s_time_gran = 1;
 
-	/*
-	 * Get the root inode and dentry, but defer checking for errors.
-	 */
-	ino = autofs_new_ino(sbi);
-	if (!ino)
-		return -ENOMEM;
-
 	root_inode = autofs_get_inode(s, S_IFDIR | 0755);
 	if (!root_inode)
 		return -ENOMEM;
@@ -332,10 +325,12 @@ static int autofs_fill_super(struct super_block *s, struct fs_context *fc)
 	root_inode->i_op = &autofs_dir_inode_operations;
 
 	s->s_root = d_make_root(root_inode);
-	if (unlikely(!s->s_root)) {
-		autofs_free_ino(ino);
+	if (unlikely(!s->s_root))
+		return -ENOMEM;
+
+	ino = autofs_new_ino(sbi);
+	if (!ino)
 		return -ENOMEM;
-	}
 	s->s_root->d_fsdata = ino;
 
 	if (ctx->pgrp_set) {
diff --git a/fs/autofs/waitq.c b/fs/autofs/waitq.c
index d46241342..a07ae8396 100644
--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -18,6 +18,11 @@ void autofs_catatonic_mode(struct autofs_sb_info *sbi)
 
 	mutex_lock(&sbi->wq_mutex);
 	if (sbi->flags & AUTOFS_SBI_CATATONIC) {
+		if (sbi->pipe) {
+			fput(sbi->pipe);
+			sbi->pipe = NULL;
+			sbi->pipefd = -1;
+		}
 		mutex_unlock(&sbi->wq_mutex);
 		return;
 	}
@@ -37,9 +42,11 @@ void autofs_catatonic_mode(struct autofs_sb_info *sbi)
 			kfree(wq);
 		wq = nwq;
 	}
-	fput(sbi->pipe);	/* Close the pipe */
-	sbi->pipe = NULL;
-	sbi->pipefd = -1;
+	if (sbi->pipe) {
+		fput(sbi->pipe);	/* Close the pipe */
+		sbi->pipe = NULL;
+		sbi->pipefd = -1;
+	}
 	mutex_unlock(&sbi->wq_mutex);
 }
 


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
