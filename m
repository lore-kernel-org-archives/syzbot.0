Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272783859EE
	for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 08:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787907076; cv=pass; b=jY6ZlsZHHOEqQ0GYtv0d0+94dqXY+fZ0QEOlurtNXCSc4MNfi0fMNJ5QJzQzWBM5rUc5y2RMTjUvAn7mr69GGGNf7a2RHb0Gi5odtxwv4/2V86Q3NluzkczQ7Bh0dNef9v+3cM3VKts1xXa/ue4nkXoaka1V9hBg/WXNOoOkgcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787907076; c=relaxed/simple;
	bh=+RpXC5IrDYbd3IqOrq8t8BZVgCmJRT/wR85XrsGG5Zs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u9WsTxa2I601aNyZcYsxUzIwoxSpGS4vsZzLuY5WDGPa9ubmSSFL4tXJ6dGtN3nSHf3bVvGHGTCpIvMM2yveKmJLaCLJoWXo8UgBASZsCad3lufVUi9zJiKPSzAifJweOAr3MveY+lWlAB+MZrv3CpwISNmfF6MQEVYXzQQd9lk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wV6KX/56; arc=pass smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wV6KX/56"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7f4dedd67b8so949207a34.1
        for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 01:51:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787907074; cv=none;
        d=google.com; s=arc-20260327;
        b=NQAhyN8de7XV1kM3+0qUXFrafqYBMDcXSYgE34jrN1ZodwfIakpt5xoGNV+d/4QcL8
         TCC7E9dWscnvSUmuOrRY9Uz7DiUGoum/BH2Ii6DCZwJZxizpmnpob0hJ6KMJDEhd3wfP
         sXnAyIvJLFjJ7fSbbn/iELLel/cTWyYY+iH+14yy2/iOkf0XooHnM0zbzSV0k0RnwYxc
         5sDsu48bIa3JVTw+ShuP/yMjKv3dzMdMmMyiNBwM/KzebbUgKDoaqHxVvHoWNJ0odIG8
         nHCAjADVEQNPchvuQfxrZ3L901AaqkHdDmPY3Iz9Zr8DMLIkxcYiBlv3unKbyoYm/ZHB
         ay/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zXi6dUE0MZtrYQB+oobrBWUTV5di5k4cBoCK5N0mTSQ=;
        fh=egrBamdVajWxNwOK1HuMj6ogm/A4yqD5F2xnt5gfGyg=;
        b=hw1mzrh48AVox/Ml6sSx6RIRyXD7/8S1YL2yVekVQBupkA5ghpXushhZ/t2AdaV2oN
         yw+M+D0aqF+6chcBQoUqUSLQDgfh5cpK03y9lp8yAhf687+IER3fJLGbPbqAC6qK8pX2
         ITTUj4Sq/oqWM0DD24ZG3S3t5nY8uujLxNLGwqLRmAaL7wP1mCToWSWUOGRO13rN7UAt
         Q9MoK+BJ4oXvROzX3/uFrPzJACc5OBGD5CddJp6aM+8CwfOPbeJiazJXrlewYxfCeK7j
         6g/cDfLVbKS9Ilbo+IoFKUYtDBpFrazJ2/fTFo0IJsmLHAAAkLgFMIMkvBVhlSbHevjg
         kkGg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787907074; x=1788511874; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zXi6dUE0MZtrYQB+oobrBWUTV5di5k4cBoCK5N0mTSQ=;
        b=wV6KX/56nHOpnqLbeNnEZeVtcbh4MuQPZwv3NHMSXydUUC185NbGTU5BeGT7ZrrOUQ
         pIRdDLywXqYyvMZJVbnVUlhklhL4paixAm7/fOJEYOZmgGHGv2EaDwpXq7Z46p5CHi/u
         uPEkBKnt8Qmi/rAoKYWb31LxCHm0HKwM2jaOGjwypFGJLc5OBPi8FR5Di9Vni4qfjhNV
         ImWWgojp7e9n8hd+leIFq/GOZE1JmvnamEora44MqZFa+0/ajLe95ZUgQiAfGCKnTUGW
         SZC0xJKQiXPsadHJB3zwfPv0OjQc/cVgJe9/GRDgYU5YqP/74y0B7I6+P43aFr+Cs+hx
         T+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787907074; x=1788511874;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zXi6dUE0MZtrYQB+oobrBWUTV5di5k4cBoCK5N0mTSQ=;
        b=mpW7hCjjWb9W7eYlk7mxqCX1w9T2FDJFUNi53gsuuqKP79Aqs01OkWneEHD45t0K8Y
         mEosNYB9+k+ZznzMhJyG//KQi1xYziHB72pWlsCeAmXt+dX3IMtS6F3zHyL0AXSFct62
         Q4dDlFMTQpneAKFnIsQHbch4IMcpqNDfdrILPEQyiGIHzxzjudgJwPtawlHHoKSwoEz1
         Yxw20Ah7FWo3s2sE5Kt5crJEH6FLzdXuwtFSSjwvbiifkhPxvZAUmkoFKDW5Ssu8pwdh
         QthfBFe6lV8TlrMmCxuhT2Q3GoQwsqmo87EBXcsKwRhb7vYkRnnkkfIDIFLk2Kd5unZX
         xGVw==
X-Forwarded-Encrypted: i=1; AHgh+RoQLIWzYU7astJ0z1qlc+6jzj8hi8+uNvrRzFJeaPnr+GJMSFgo1dwSxl0DLEBG5XVnSyFE8gM=@lists.linux.dev
X-Gm-Message-State: AFuF++kAG+FdBO4m0GAQTWFbEVgQxQju9hGvTSn6g+PRRMc7wov6nP2U
	y/8olwCPXaQx+gk8uY2ShnwAt55qeIpH/V+F1WHC1FPOSd5tCb0kmSNeLh2tLYydEBhwfcWef5x
	69MrW83hdIbW/ReNIbdWg7eClxAZ8BY2oTYn6CQo+
X-Gm-Gg: AR+sD13oF1OCkf1zYuk6TlSTp1+aqCS1OBolecV43GrDzWwJKKn7EsOem6r29moRG9j
	nFaf0O4qpKGShsRIkJfjZs47/6t46fIJezGTeOzrOM4rjEABMpV6zcLDvxpNXd3VCkEIysChJd2
	tSNJjtdEK3DhwWwlu9wPaeDBAfgpA9KTmnHX5abPE6bHvr+Gc+2SISUudcmjkxt5jJfzqvQyxkb
	2Vz4Yhqq0COkkZuEejY8uPlSfTmwxtCUMboMzgcTEFgkXwET6yqlDsziA44tAh1J8Rp/kB8+MIW
	GCETVkGSf4nRtua4Zm7znDSROcHJE80EW1MHhcAU1uXCPEe8cyd5Y7+wzbZTjsIjkVUvoSFSe4a
	wctS5C1Xqfb7Kdmk4a3cY6q79xRoDWyS0Py+FrVwqCa17Tpd1ybeYKdSeBZu3xuGSFbvR4sAg0r
	Yr1fE0RPHUOle7FzLkfdPXo0g=
X-Received: by 2002:a05:6830:6d0e:b0:7dc:d967:63de with SMTP id
 46e09a7af769-7f4f23b74aamr6941386a34.3.1787907073389; Fri, 28 Aug 2026
 01:51:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <23adcd6c-80ac-4fad-9c84-fcb66d5cfd6a@mail.kernel.org>
In-Reply-To: <23adcd6c-80ac-4fad-9c84-fcb66d5cfd6a@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 28 Aug 2026 10:51:00 +0200
X-Gm-Features: AcwNN1XtoPE4AHh0-wysdZKFA6CUY5tFP9vwHKFu1uNZwAepWbLdMRo3jd90cpc
Message-ID: <CANp29Y4JEinWnDeb3j2CXgKafMQWMSjQPciQNz=Bkr7tKhfrwg@mail.gmail.com>
Subject: Re: [PATCH RFC] Bluetooth: hci_core: Fix race condition during device registration
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Aug 27, 2026 at 11:26=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> In hci_register_dev(), the power_on work item is queued to
> hdev->req_workqueue before initializing hdev->adv_monitors_idr and
> registering the MSFT extension via msft_register(). For devices marked wi=
th
> quirks such as HCI_QUIRK_RAW_DEVICE, the HCI_UNCONFIGURED flag is set on
> the device. When the power_on work item runs concurrently on another CPU,
> hci_power_on() detects that the device is unconfigured and immediately
> invokes hci_dev_do_close(), which calls msft_do_close().
>
> Concurrently, msft_register() allocates the msft structure and exposes it
> to hdev->msft_data prior to calling mutex_init(&msft->filter_lock). If
> msft_do_close() executes while hdev->msft_data is already assigned but th=
e
> mutex has not yet been initialized, mutex_lock(&msft->filter_lock) operat=
es
> on an uninitialized mutex, triggering a DEBUG_LOCKS warning:
>
> DEBUG_LOCKS_WARN_ON(lock->magic !=3D lock)
> WARNING: kernel/locking/mutex.c:625 at __mutex_lock_common
> kernel/locking/mutex.c:625 [inline]
> WARNING: kernel/locking/mutex.c:625 at __mutex_lock+0x12d8/0x1550
> kernel/locking/mutex.c:821
> ...
> Call Trace:
>  <TASK>
>  msft_do_close+0x308/0x7b0 net/bluetooth/msft.c:693
>  hci_dev_close_sync+0x86b/0x10a0 net/bluetooth/hci_sync.c:5522
>  hci_dev_do_close net/bluetooth/hci_core.c:499 [inline]
>  hci_power_on+0x32c/0x750 net/bluetooth/hci_core.c:937
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Fix this by moving the queue_work() call in hci_register_dev() to after
> idr_init(&hdev->adv_monitors_idr) and msft_register(hdev) so that device
> structures and extensions are fully initialized before asynchronous tasks
> can access them. Additionally, assign hdev->msft_data in msft_register()
> only after mutex_init(&msft->filter_lock) has completed.
>
> Fixes: 9e14606d8f38 ("Bluetooth: msft: Extended monitor tracking by addre=
ss filter")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+14ce1b05b7d5a989abbe@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D14ce1b05b7d5a989abbe
> Link: https://syzkaller.appspot.com/ai_job?id=3D2bc9e8aa-ca6d-43e2-be2c-f=
d5d9f649d7e
> To: <linux-bluetooth@vger.kernel.org>
> To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
> To: "Marcel Holtmann" <marcel@holtmann.org>
> To: "Hilda Wu" <hildawu@realtek.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 5ba9fe826..771b73c99 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -2629,11 +2629,11 @@ int hci_register_dev(struct hci_dev *hdev)
>         if (error)
>                 BT_WARN("register suspend notifier failed error:%d\n", er=
ror);
>
> -       queue_work(hdev->req_workqueue, &hdev->power_on);
> -
>         idr_init(&hdev->adv_monitors_idr);
>         msft_register(hdev);
>
> +       queue_work(hdev->req_workqueue, &hdev->power_on);
> +
>         return id;
>
>  err_wqueue:
> diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> index d7badce87..255163033 100644
> --- a/net/bluetooth/msft.c
> +++ b/net/bluetooth/msft.c
> @@ -764,8 +764,8 @@ void msft_register(struct hci_dev *hdev)
>
>         INIT_LIST_HEAD(&msft->handle_map);
>         INIT_LIST_HEAD(&msft->address_filters);
> -       hdev->msft_data =3D msft;
>         mutex_init(&msft->filter_lock);
> +       hdev->msft_data =3D msft;
>  }
>
>  void msft_release(struct hci_dev *hdev)
>
>
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/23adcd6c-80ac-4fad-9c84-fcb66d5cfd6a%40mail.kernel.org=
.
