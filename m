Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFFA1C2AA
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 21:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787865970; cv=none; b=r+iSoWuGBLDhdC6sPtARA+ntvZGfKPnamS/oGjmPtGbtj1GWZqAc6pYgn56xUxFKJ9ier1DbfQk5IcoFllkXwh6zx9swyDi+eiG3yZuH4USMxbdc5CJHdmDx8egflZok6rKTbWLQngDwwhxER5q1F1c33gGgO7wUyLUkeCwEYPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787865970; c=relaxed/simple;
	bh=jNz37wbEvAnh8KBURzCereCofS/kTGJcj8XGFfpzzhY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=hsExuhh589vnJ0z40bC3SUb3wGgID0tDNkRHd62TSTcm3xcuKJmSkpLK4C4UqlnuuoRa7bdREELTArnb1Nayx8eawGdljP7ZKDaEK6BPDKmvv+46x3BZZJt3KcWKBaUu/cxa+rISHEug0vqbPQQ4Mt1hGq2cZF3qVZrAwDRlCYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjfCk2fr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjfCk2fr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EF69A1F000E9;
	Thu, 27 Aug 2026 21:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787865969;
	bh=Ia1qZXituNF2nKG6RgL8sFotb1Wq6YnLa37DQueRNTM=;
	h=From:To:Cc:Subject:Date;
	b=gjfCk2frQ7x+4jTDUR9ai9pdWzwFu4XO/3mxhYrEUo9l2lIdKywUPhGwlHmQuxkeC
	 xEJZsCpKS6bIkUxSLFdes1oaTQXJr+HWvOdhmuA5Ajx84QtYdA7fsF4S+hEwnwEPU5
	 8rah8uELo5Fl4hgMsGxauNfWQujbVLm8FrAqRXvb6PsrNw2QY+czgB8a8ebi9UZ9es
	 QKoPr0yTMGjZU2mTS5fQre+D6hK3PiDgrC/FBKbLBLcM7YwVdVhiU3iyeysKMQX8MM
	 hKfJEOHIeEwUR7DQyQywB+ZaRgQn95o6tvTUPu3+GARm+1bz75rjICXRA0ZgD/HOJq
	 FMR+SFD4OxBiw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Bluetooth: hci_core: Fix race condition during device registration
Message-ID: <23adcd6c-80ac-4fad-9c84-fcb66d5cfd6a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 27 Aug 2026 21:26:08 +0000 (UTC)

In hci_register_dev(), the power_on work item is queued to
hdev->req_workqueue before initializing hdev->adv_monitors_idr and
registering the MSFT extension via msft_register(). For devices marked with
quirks such as HCI_QUIRK_RAW_DEVICE, the HCI_UNCONFIGURED flag is set on
the device. When the power_on work item runs concurrently on another CPU,
hci_power_on() detects that the device is unconfigured and immediately
invokes hci_dev_do_close(), which calls msft_do_close().

Concurrently, msft_register() allocates the msft structure and exposes it
to hdev->msft_data prior to calling mutex_init(&msft->filter_lock). If
msft_do_close() executes while hdev->msft_data is already assigned but the
mutex has not yet been initialized, mutex_lock(&msft->filter_lock) operates
on an uninitialized mutex, triggering a DEBUG_LOCKS warning:

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: kernel/locking/mutex.c:625 at __mutex_lock_common
kernel/locking/mutex.c:625 [inline]
WARNING: kernel/locking/mutex.c:625 at __mutex_lock+0x12d8/0x1550
kernel/locking/mutex.c:821
...
Call Trace:
 <TASK>
 msft_do_close+0x308/0x7b0 net/bluetooth/msft.c:693
 hci_dev_close_sync+0x86b/0x10a0 net/bluetooth/hci_sync.c:5522
 hci_dev_do_close net/bluetooth/hci_core.c:499 [inline]
 hci_power_on+0x32c/0x750 net/bluetooth/hci_core.c:937
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fix this by moving the queue_work() call in hci_register_dev() to after
idr_init(&hdev->adv_monitors_idr) and msft_register(hdev) so that device
structures and extensions are fully initialized before asynchronous tasks
can access them. Additionally, assign hdev->msft_data in msft_register()
only after mutex_init(&msft->filter_lock) has completed.

Fixes: 9e14606d8f38 ("Bluetooth: msft: Extended monitor tracking by address filter")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+14ce1b05b7d5a989abbe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=14ce1b05b7d5a989abbe
Link: https://syzkaller.appspot.com/ai_job?id=2bc9e8aa-ca6d-43e2-be2c-fd5d9f649d7e
To: <linux-bluetooth@vger.kernel.org>
To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
To: "Hilda Wu" <hildawu@realtek.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5ba9fe826..771b73c99 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2629,11 +2629,11 @@ int hci_register_dev(struct hci_dev *hdev)
 	if (error)
 		BT_WARN("register suspend notifier failed error:%d\n", error);
 
-	queue_work(hdev->req_workqueue, &hdev->power_on);
-
 	idr_init(&hdev->adv_monitors_idr);
 	msft_register(hdev);
 
+	queue_work(hdev->req_workqueue, &hdev->power_on);
+
 	return id;
 
 err_wqueue:
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index d7badce87..255163033 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -764,8 +764,8 @@ void msft_register(struct hci_dev *hdev)
 
 	INIT_LIST_HEAD(&msft->handle_map);
 	INIT_LIST_HEAD(&msft->address_filters);
-	hdev->msft_data = msft;
 	mutex_init(&msft->filter_lock);
+	hdev->msft_data = msft;
 }
 
 void msft_release(struct hci_dev *hdev)


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
