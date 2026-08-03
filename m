Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8666230D416;
	Mon,  3 Aug 2026 15:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785769542; cv=none; b=LSEgIds1cCrMAuSWEOs0HJtjiGAqusRdh/mLfMdSGTihxP7b5Avi2+k7H2XAxKgVf1WF6utqYCwwsl2/Rah22PjkQ870tFY/54670DpIRCjcHITf0eMcpVx4AcN4kkescDIXT5jrOB+ihQuwK3ehFhEZkIx+UMLWP4jrn7sp93s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785769542; c=relaxed/simple;
	bh=j3JqQziFSJ6RmPpcX7u8WR8MivZeywKVb1vMZQG565Q=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ctdpfgZxf7sjp2U2o0BE7wR/iBIsrPIF5lrzUYpB/CcDorBOrnpL8qI7rB2aF4txO50wiZPDqzTaJqSEmbQW0P02NIygKWBx0BibjfgkM9M3K5e882AlFY6zHF87QPnvnZwIbW8u2OYSpVXOpLetDdK8nrtlHlcxAroaGNtZR3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRu/pUn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRu/pUn/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 96F021F000E9;
	Mon,  3 Aug 2026 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785769541;
	bh=qXdj6PMUQgk/ZpPaBgGxf4NvtqzfJ8AmdBzhdA0qQf4=;
	h=From:To:Cc:Subject:Date;
	b=NRu/pUn/w35r08Kwv3FY4Of9tOnK9gtiIdmPuatMytvwzqD1m21kLNxQT8xyaJj1N
	 loEPn+W+wEF9R30nHJLxtOzWz52SL5cUPPMJxiBuTVOgTs81Fi8vKYSayL5rz5U3hv
	 VLTAM37k8F7OHlFo5SyvxoEzJXXQTiillxOvXVp7P0QRp37QfhMXe7OH72dhmQ4i7c
	 Rr9BRVgsKVu4oZOjyeVQn5L2OmRMaV65hfUxh0umnCG6LF8EWjs2tsNDG85t2OKlJ6
	 pXmY/sXmmY71Zx5W1lT4KCWynw0aYZrkM6DJoC8npzS+CsyuIpztcYKuu5nwKPv0tm
	 768hmnnL48w0g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>, "Shuah Khan" <shuah@kernel.org>, "Valentina Manea" <valentina.manea.m@gmail.com>, "Nobuo Iwata" <nobuo.iwata@fujixerox.co.jp>
Cc: i@zenithal.me, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] usbip: fix use-after-free in event_handler()
Message-ID: <ee9bc932-2fbf-4e8f-90e2-6cf604be9ff1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  3 Aug 2026 15:05:40 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

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
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
