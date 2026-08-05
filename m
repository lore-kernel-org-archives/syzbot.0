Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1608B45DF65
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 12:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785932600; cv=none; b=CWGDJkP2wMR7B9DON6PpBm9JFxPX0RlKOsII4Is0IIR1GDMSga9AXRWG3V/6fki42LDwyhcL5RNjm76a99D+gRkNkF6TTUhzrclCZ0Be6CFqSH+OmwEL6vBiKaH+XWpzOhz4krptRzhyPUSek/bHNQ4n4kkPzBYfs4twmcubBww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785932600; c=relaxed/simple;
	bh=rIpxpteKMHOhRaEos7rTkuFxeQjxq4hzWnHrXGsBOTc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=D4eJhDhllbGe6VP1tlt2jXQ/rLI4hzQnG2U/ldBLJJArzUp+Ke1ZOugjNP9KBmvLmc0x4QYAImC3GtdrPyFld17KVobOYg4cEqLHSxqX4d6H6FqBYWd+yaDOliasYLYTeCFBuL9Uh7Su5TJo7gaZ5B2bcV5Ur3LUYqGWPbSag/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQBKUnLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQBKUnLj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CAD281F000E9;
	Wed,  5 Aug 2026 12:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785932598;
	bh=oER2ViWZ/5rCIN4k3xM2KdjxaGJU70zaKxvx+V+Dnl8=;
	h=From:To:Cc:Subject:Date;
	b=XQBKUnLjiFtm5BdbATe5ROED5rN8wHYh/sfeXWH7lBFTF92KgdpiF9tYf9eLk4DXT
	 xn9jTwOFWPsA5olqGzzq+lWYqL2BXmUZqgLwDTuKIcNvC4dThMwxg7gLiihp5KXM+I
	 ikNimo0uzfU+cmHolV4h9f1IHI6Ktq/OhPFffh+euvdoA+JPKKIQr4rPEWDkv8xsVw
	 8t/tFCwtZRZlgoL6af2LGvqNShrIGR1PzvwYR0TdfUr9hpAUBDMTSxqv1WZGD+KKIw
	 la6HvJgwL+SbwvHLzhaHbb/BoyB1JSNd5d+hmv7Y9X83UT4qHM573LlxvkLlZR63TP
	 V9cIyMjmWr9mw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: mass_storage: defer file open to workqueue
Message-ID: <dba5bf38-fc4a-4f36-9069-397e269115ce@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  5 Aug 2026 12:23:18 +0000 (UTC)

When a user writes a file path to a configfs attribute (e.g., the
lun.0/file attribute of the USB mass storage gadget) and the provided path
happens to reside on the same configfs filesystem, it triggers a lockdep
warning about a possible recursive locking on the sb_writers percpu rwsem.

Because configfs attributes are regular files, the VFS layer acquires the
sb_writers freeze protection lock for the configfs superblock when the
write() syscall is issued. When the driver's store method subsequently
calls filp_open() to open the backing file, filp_open() attempts to acquire
the sb_writers lock again for the target path's superblock. If the target
path is also on configfs, it results in a recursive lock on the same
superblock, which lockdep correctly flags as a potential deadlock.

Fix this lock inversion by deferring the execution of fsg_lun_open() to a
system workqueue. By executing the file opening in a separate worker
thread, it escapes the lockdep context of the write() syscall and does not
inherit the sb_writers lock held by vfs_write(). The store method uses
flush_work() to wait for completion and return the synchronous error code,
preserving the existing API behavior.

The lockdep warning is as follows:

WARNING: possible recursive locking detected
task is trying to acquire lock:
ffff8881899b0500 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90
fs/namespace.c:494

but task is already holding lock:
ffff8881899b0500 (sb_writers#12){.+.+}-{0:0}, at: file_start_write
include/linux/fs.h:2733 [inline]
ffff8881899b0500 (sb_writers#12){.+.+}-{0:0}, at: vfs_write+0x231/0xbb0
fs/read_write.c:683

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
  lock(sb_writers#12);
  lock(sb_writers#12);

 *** DEADLOCK ***

Call Trace:
 <TASK>
 sb_start_write+0x4d/0x1c0 include/linux/fs/super.h:125
 mnt_want_write+0x41/0x90 fs/namespace.c:494
 path_openat+0xa7b/0x3850 fs/namei.c:4860
 do_file_open+0x23e/0x4a0 fs/namei.c:4892
 filp_open+0x16d/0x1d0 fs/open.c:1343
 fsg_lun_open+0x6c/0xe00 drivers/usb/gadget/function/storage_common.c:194
 fsg_store_file+0x19e/0x400
 drivers/usb/gadget/function/storage_common.c:455
 configfs_write_iter+0x33a/0x430 fs/configfs/file.c:229
 vfs_write+0x61e/0xbb0 fs/read_write.c:687
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 </TASK>

Fixes: ef0aa4b92cf1 ("usb: gadget: f_mass_storage: add configfs support")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+da381387152f0dd8bedf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=da381387152f0dd8bedf
Link: https://syzkaller.appspot.com/ai_job?id=43881a07-9f58-4a9b-b110-6696a48ed088
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Andrzej Pietrasiewicz" <andrzej.p@samsung.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/function/storage_common.c b/drivers/usb/gadget/function/storage_common.c
index 75831f2c7..45842f8e0 100644
--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -24,6 +24,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/kstrtox.h>
+#include <linux/workqueue.h>
 #include <linux/usb/composite.h>
 
 #include "storage_common.h"
@@ -434,6 +435,21 @@ ssize_t fsg_store_nofua(struct fsg_lun *curlun, const char *buf, size_t count)
 }
 EXPORT_SYMBOL_GPL(fsg_store_nofua);
 
+struct fsg_lun_open_work {
+	struct work_struct	work;
+	struct fsg_lun		*curlun;
+	const char		*filename;
+	int			rc;
+};
+
+static void fsg_lun_open_work_func(struct work_struct *work)
+{
+	struct fsg_lun_open_work	*fwork;
+
+	fwork = container_of(work, struct fsg_lun_open_work, work);
+	fwork->rc = fsg_lun_open(fwork->curlun, fwork->filename);
+}
+
 ssize_t fsg_store_file(struct fsg_lun *curlun, struct rw_semaphore *filesem,
 		       const char *buf, size_t count)
 {
@@ -451,8 +467,17 @@ ssize_t fsg_store_file(struct fsg_lun *curlun, struct rw_semaphore *filesem,
 	/* Load new medium */
 	down_write(filesem);
 	if (count > 0 && buf[0]) {
+		struct fsg_lun_open_work fwork;
+
+		fwork.curlun = curlun;
+		fwork.filename = buf;
+		INIT_WORK_ONSTACK(&fwork.work, fsg_lun_open_work_func);
+		schedule_work(&fwork.work);
+		flush_work(&fwork.work);
+		destroy_work_on_stack(&fwork.work);
+		rc = fwork.rc;
+
 		/* fsg_lun_open() will close existing file if any. */
-		rc = fsg_lun_open(curlun, buf);
 		if (rc == 0)
 			curlun->unit_attention_data =
 					SS_NOT_READY_TO_READY_TRANSITION;


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
