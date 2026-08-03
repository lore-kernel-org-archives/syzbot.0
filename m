Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7CC3DC4AF
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 09:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785749175; cv=none; b=qfagmMvczKQA3rW+48t/mfUL2nvkJv29ssZkwBnJpvFaGzQRh1Ee7gyb1H0GRnvKmiORYxYIZUVzZ6ZvZu5F/O/GX7JT9YZ6kqmPwn3Mz/XaK6WL31R4UPD/3SMu2XddUs0vSHQrgUSy/3ttA2QKtKt7XcaCkDMEydH1NGerMKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785749175; c=relaxed/simple;
	bh=/AHbSs+7RLE/O8H3yWEJA7w7lVuo8uTKOPnrhKw5uLM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=S1O9n+TCDauZMHoAevD80ujSGfC8o60DukIE2KxnbFIeHZnNMjt+YrfpgK7VU8zr6r+1wJ67zD2b6I73R66gh6qpHykdTYcEmLz80nXvE6evmqByfSuEGXNAlPWUM47ZzzoXUR28UWTMTCKtem2w08DF4G22MXGuGdv5BovxKnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=al9pPuYL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="al9pPuYL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 70DC91F00A3A;
	Mon,  3 Aug 2026 09:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749170;
	bh=a58LqytePNVqZmWaubr/UBreD97Q6dDEXQfqrli1VtE=;
	h=From:To:Cc:Subject:Date;
	b=al9pPuYLv7ddhW0MrgY08X6dr/SMumYBAR7Lv8PsjjaHh1EeiXObOUcltbcaHfRSL
	 atuVjhDfgGpvZlSyr7WGbyC7gXE2vbp9XrI6WIJ3WGx+CI2n5DthLlOhwF1BEaUZUE
	 fLZv8Ck31FND5zj2qRJKXndedCauESxp66nmmxUtUQe8YHEsGItyt7wC/F6kN16BTS
	 8zYw00cLBOMKdrlcmezjqWP/kk1w+UxV5nYaCdlG5joOhinFqJygvG5tKLv8WGllPZ
	 OeDhoeXE6RCKUyG6NHLIhnREg+YM83vSSxwzFGO0707OaAYCV7oF5TqXQn2fxcbEUJ
	 isQ4zT3c/syIw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usbip: fix use-after-free in event_handler()
Message-ID: <330619da-665c-4dd6-ac14-30e8bef174fd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  3 Aug 2026 09:26:10 +0000 (UTC)

The event_handler function in drivers/usb/usbip/usbip_event.c is a
workqueue item responsible for processing events for a struct usbip_device.
During device teardown, usbip_stop_eh() is called to wait for the event
handler to finish processing. However, usbip_stop_eh() uses
wait_event_interruptible() and ignores its return value. If the process
unbinding the driver receives a signal, wait_event_interruptible() returns
immediately, causing the teardown process to falsely assume the event
handler has finished. The teardown process then proceeds to free the
usbip_device memory. Meanwhile, the event_handler workqueue is still
running and attempts to access the freed usbip_device, resulting in a KASAN
slab-use-after-free crash.

BUG: KASAN: slab-use-after-free in __mutex_lock_common
kernel/locking/rtmutex_api.c:559 [inline]
BUG: KASAN: slab-use-after-free in mutex_lock_nested+0x5a/0x1d0
kernel/locking/rtmutex_api.c:578
Read of size 1 at addr ffff8881145245b0 by task kworker/u8:5/6177

Call Trace:
 <TASK>
 lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
 __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
 mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
 event_handler+0x1e3/0x4a0 drivers/usb/usbip/usbip_event.c:73
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

To fix this, change wait_event_interruptible() to wait_event() in
usbip_stop_eh(). This ensures that the teardown process strictly waits for
the event handler to finish its execution and drop all references to the
usbip_device before the memory is freed, preventing the use-after-free.
This change is safe from deadlocks because usbip_stop_eh() is never called
with locks held that the event_handler would need to acquire.

Fixes: bb7871ad99ea ("usbip: event handler as one thread")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f4518ac0a3dd3aafde38@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f4518ac0a3dd3aafde38
Link: https://syzkaller.appspot.com/ai_job?id=88101c8e-4da9-45de-b879-0549d6fe5649
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Shuah Khan" <shuah@kernel.org>
To: "Valentina Manea" <valentina.manea.m@gmail.com>
To: "Nobuo Iwata" <nobuo.iwata@fujixerox.co.jp>
Cc: "Hongren Zheng" <i@zenithal.me>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/usbip/usbip_event.c b/drivers/usb/usbip/usbip_event.c
index 0e00c2d00..81d761891 100644
--- a/drivers/usb/usbip/usbip_event.c
+++ b/drivers/usb/usbip/usbip_event.c
@@ -115,7 +115,7 @@ void usbip_stop_eh(struct usbip_device *ud)
 	if (pending)
 		usbip_dbg_eh("usbip_eh waiting completion %lx\n", pending);
 
-	wait_event_interruptible(ud->eh_waitq, !(ud->event & ~USBIP_EH_BYE));
+	wait_event(ud->eh_waitq, !(ud->event & ~USBIP_EH_BYE));
 	usbip_dbg_eh("usbip_eh has stopped\n");
 }
 EXPORT_SYMBOL_GPL(usbip_stop_eh);


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
