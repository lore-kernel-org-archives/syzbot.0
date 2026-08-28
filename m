Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBA73E1CED;
	Fri, 28 Aug 2026 08:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787907311; cv=none; b=sTQGzu5osfeUrwsslD4NYq39pYPfyFzSdtMTbxNXQvFTJsmCg9Vqpdhvz74ZtaSRW4t1qYUtq+/b7yTDQS6RsUh3fgq/TBLgenOtQn2m9LC2JAYG/TVJ4LbWg1ovd/cWqx19uhtfL9qQSRWZufoo2a2SbQTyB2LhEg5ZgNzxMO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787907311; c=relaxed/simple;
	bh=sNyIB/GT50g8rb6JAtiKZ2puJnLCBSlc8IgLMZWXwZg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=FyG3Fdv/O3am529NSuz+pQnnfdYDz7rwJZqYIl4mOGqNqPn85F4cosEyWpIETpw9yhU98XyFV1F8wvmaBzjeskbgZKbw5m4LMmGBFpOiOMyHj7N3mQYp+nllN8TV/CjZxe18DYt1XnTDl64vM46p+9PhLfsjL0qTfb5VvMVpgRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLL3C5H9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLL3C5H9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 180311F000E9;
	Fri, 28 Aug 2026 08:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787907309;
	bh=5BzL+9Md99aFW4pTj/6ay3UfAZXHl/2F0v7SSFjgOrA=;
	h=From:To:Cc:Subject:Date;
	b=mLL3C5H9RQ29Opb+VmilHMI1/BnLKoDKarw4wDdW5ECbykY48mVBux5S8ZYxNK22j
	 QcA91g3qOO3eBLaGSYd5uBs0vPA/wHTq4VTqH2EjTIpoYR59XaPTfBMbHhYuxWxfjb
	 9srq+Po3qKvTy7nPgFtTr15gpvcMujM7TPjwUi1vfCsgyyAjnjEC5H0oDjiqraBkMR
	 t9cj9rvK19vNz100hnZQtwEoSLqoqz3d3lXZGjwxgu5mgk41x1mwaZAhW7J/vC7UVR
	 un7AjwYDSgjvb2kuwUnq4L7Ve3Z1PLtWoOfqD5cmVIMOGzVSZAOND7bkYzMu/sH3Su
	 2FE6HbgFDiRDg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, <linux-bluetooth@vger.kernel.org>, "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>, "Marcel Holtmann" <marcel@holtmann.org>, "Hilda Wu" <hildawu@realtek.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] Bluetooth: hci_core: Fix race condition during device registration
Message-ID: <7f282e86-b9fa-4a3d-8dea-208975771b35@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 28 Aug 2026 08:55:09 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

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
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
