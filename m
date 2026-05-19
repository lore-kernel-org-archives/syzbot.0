Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5943DFC70
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 08:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779178421; cv=pass; b=QUGr9JTM+PDDhxL2LDBibHcJPLnnqPaHpxzRud8c0oJhvS09iF6mAvwnGt4XIrnETVshssH7nKz9oxqoSpmGB10iJHdEqTu2WgA6sGcaQjuzvMCPmnjOkBgE0ON+zP+Ap36rkVAACro0JtBkKnlMuFXiDcQ9bb3orkWUlb9CLaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779178421; c=relaxed/simple;
	bh=JoyKyclo3HiyeLkuQE996/3bHrLlMrqGkLdn/83tVbU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qv9R8sYCiu3+b98Y25C+7kKXOovX6FijkWXgZRr0Qdf4oIrF4IksfQ0ZTWdmEvkwfT1Y60st7OTxxpZ1ywuu+k0OIgX/V8ycSsE+Kf9VKYDV3xUVg+fGBzhOPmZcWPD1oMM7B9U1AuRCiKJBFo8f0o0QkNyBGQzJkpjKHvhdgF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GRWa1CMF; arc=pass smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GRWa1CMF"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43a86d544c2so1438046fac.0
        for <syzbot@lists.linux.dev>; Tue, 19 May 2026 01:13:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779178418; cv=none;
        d=google.com; s=arc-20240605;
        b=BnBTA/KQY18hiUfsBz/GuhM6PephiMy9c2HvvAB6Mi/d1Sdi3soEPbitlMIg2Sa/JE
         Juqg4p/ztjLb/is+luReSyWelewCBKSFpIt5NbTggjKMlxHVtnRTYHn1wiNaoTOxyxuP
         YLq2N57FsS7xu6hChcL/nIrfpxNiATmQF/tqMnteRz4fRutuNSvvGl0+BXu+JbJTMjmg
         zlOo7YtwwhfK3ymatTSaJa6XDCfMSNiKKOtv+MNQnPVHBaqkGALrDMMtdy896jjyC8JR
         QDQetzrQ0aJUFqb8s6c5V/8UB+03GJnE3cDfbTx+RaDwlEnAMMP7FX8BnkLhiM+8slc3
         K8qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Tay4PzBa/P2Jm9/JbwWU96JYaCIrFsqv5kafSGiUgO8=;
        fh=oDHgYt7fmVCmGr3ZiwUb8jf9fYJAgUP0s4wxUOF1BGc=;
        b=LyvZ9rqAZ1G1UKlDlLjYo+3Ud5atnZidQIAYq314mEKM+PRM2GCxDV17Axh+S4mEki
         XsWsfmGuX0GvZfzSQyIvvunO/3ZukzJI3YANjJNdgvGiY5sQfrWx20OTrDNmKwBpgbk2
         qVybgsE4HGKsX+DxdhYVjOGf1umr2ySRjFUtUWIzPw8WE1GY2DrlUS/r46WsXa4RWssF
         B+zvllIsB/jdXG6dHjBIDNMnvu4jNR4XJLbGjLTiubGLusXtWXsyxIC3vzJi30dLiScd
         HH/Uab51GunLFb9rBv+eHRx9dtirxLx4kYVuRV031/LbSqwLnkOvtcGum789FWbhhtYZ
         ft9w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779178418; x=1779783218; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tay4PzBa/P2Jm9/JbwWU96JYaCIrFsqv5kafSGiUgO8=;
        b=GRWa1CMFMsz0pDWFHJbq7+W7JsiNZzQWCThvIHV1i2J9l/t/caBnCwBgRt2Ia54DWc
         R2+36tAje3d69QsH6xB93/okAqub4d1pgudn3/+Ihb1prG+mV0SE2jsV2tzveepE72ZC
         1X/DCCW6tKFoVQLgU3XIDDN7vqz/lrs1AOnAgO1YXt8BgGX0kAu8ljl82Nu8TCOJYSSN
         kbjRAGkZCCRElz95Qj9sL7JDuWpTl0PwDIAEOYoS7R0M0ytrC5QG4JYBB9mdK/d2DSgd
         3AlC6ODae8e4+A0o5jMR/nckRzDpm3SKA3ebjiVVbX8txipFv1ARlz/cw6IlqoJtDtdQ
         3baw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779178418; x=1779783218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tay4PzBa/P2Jm9/JbwWU96JYaCIrFsqv5kafSGiUgO8=;
        b=Dwv3UQlH2qeUOvzrpx7jKP8V58ebEE2eP6FCVMRY2YJgG4s/ehnsw9kRuhmWlo+sUW
         ImPBJ5CSKsgJX1p4o/myW+jAVIJBl7GX6B1gCSCFt0FmE7o0gi+uO7RyfLBN0thKiIvV
         7nwE3fNG54XGHXnx9Jg4fsOQTbs/sYq+hclnVSFQIIWIeBSVDlBBMJEKkmmdCLpu3bh4
         o1+wAg0tCZOQOBV9Y1okDKRdMO/K0reanHeIHUrXB7oeF9LkhCPLsX3rPssPpprDnvdv
         Ijr09JQThz4WhQLbXiuP2+U1BPTaAXOKGIGHx9WrjdfiFyiuYVG4pHVa0365xUfsGs+J
         PhaQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Gqi2PLRRyraKIi46XGvbjHPl1zMdou98H0JqCgx5p/VABWCrk86Yt06sPJo+w0u87gWBNcWM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx67Rf4FM12Kd9gBoJDEjaK/AnGZDlLpKLgV3r8Jvt7AUmwc+LQ
	pjJ2ggrgYGQSkwYGOjo/Nh+G5LXGKBx0ulUqZ0E4Vh42D0muCG/NGNXIrM17mcgW4eJxtvUjwQl
	rHLYf4KCi2bIcw3ot63yDWh75GEJN8mICr8Vqswg8
X-Gm-Gg: Acq92OEUKtMdr3d+JuigZ49yw9GR+rEqnPgBICRcKZhrPB63MVV87/3QxV+bcq28nDd
	i2ZuDTi10PhAOwE3iejdNMA4ucTMQASZDoDy75MNM3h0q5x573EL4LBw+K127o42WikphT5qLH2
	JqogULaMd6wqh58OMgx5o4sLT2CgooKKbZ9N/KtyTaUub0GixGNO4BRUu8PHoQ4CWIP+mcUYOZo
	rTPt1MV45Y4XNyHz1Z9hdhyvsH6aJFfIHs2Utd3Cx4HDk/CSit3+pLaEEPfoc8aNP0r393PKJUX
	qJjG6aXLv7eyuPKg5USjEreF5UUvHRJjaiGNGr9f3EUHAs3yFRRrp9X86jSOphp+TTABJeP6jgR
	EnKzrqGjgNzJkg7Y=
X-Received: by 2002:a05:6871:b0f:b0:434:e6e8:bb5e with SMTP id
 586e51a60fabf-43a2dd512c8mr11838386fac.9.1779178418099; Tue, 19 May 2026
 01:13:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <3bb247d6-e412-46be-973c-5d2f9945ebe5@mail.kernel.org>
In-Reply-To: <3bb247d6-e412-46be-973c-5d2f9945ebe5@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 10:13:24 +0200
X-Gm-Features: AVHnY4I7dzqvwb_2voBGGv4i0HXynINAPLGO876xbtMZESOb0A4fCPkXWz4rSgA
Message-ID: <CANp29Y6xQkGZTWJg34Xj-ATO1cHu-rc-N36W+tQMEJ7g59FftQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] usb: cdc-wdm: close race between workqueue and release
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Now please delete my Tested-by and send a new version.

On Tue, May 19, 2026 at 12:50=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The crash "URB submitted while active" occurs because the
> `desc->response` URB is submitted by `wdm_rxwork` when it is already in
> an active state. This happens because `wdm_release` fails to cancel
> pending workqueue items (`desc->rxwork` and `desc->service_outs_intr`)
> during its cleanup phase. When the character device is closed and there
> are no other openers, `wdm_release` calls `poison_urbs()` to kill active
> URBs, clears the `WDM_RESPONDING` flag, and calls `unpoison_urbs()`.
> Because `wdm_release` does not call `cancel_work_sync()` for the work
> items, they can run concurrently with the cleanup process. If a work
> item executes after the URBs are unpoisoned, it can successfully submit
> the URB. If another work item then runs, it will see the
> `WDM_RESPONDING` flag as cleared, set it, and attempt to submit the URB
> again, leading to the crash.
>
> To fix this, cancel the pending workqueue items after poisoning the URBs
> and before clearing the `WDM_RESPONDING` flag or unpoisoning the URBs.
> This ensures that any running work item will either fail to submit the
> URB (because it is poisoned) or finish executing before the cleanup
> proceeds. The same omission is present in `wdm_wwan_port_stop`, so apply
> the same fix there to prevent data leaks or crashes across WWAN
> sessions.
>
> ------------[ cut here ]------------
> URB ffff888052781d00 submitted while active
> WARNING: drivers/usb/core/urb.c:379 at usb_submit_urb+0x7b/0x18b0
> drivers/usb/core/urb.c:379, CPU#0: kworker/0:3/5726
> Modules linked in:
> CPU: 0 UID: 0 PID: 5726 Comm: kworker/0:3 Not tainted syzkaller #1
> PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: events wdm_rxwork
> RIP: 0010:usb_submit_urb+0x7e/0x18b0 drivers/usb/core/urb.c:379
> Code: 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 57 eb 0c fb 49
> 83 3e 00 74 40 e8 7c da a2 fa 48 8d 3d a5 09 d9 08 48 89 de <67> 48 0f
> b9 3a b8 f0 ff ff ff eb 11 e8 61 da a2 fa eb 05 e8 5a da
> RSP: 0018:ffffc90003427a10 EFLAGS: 00010293
> RAX: ffffffff8720dc64 RBX: ffff888052781d00 RCX: ffff88801fe48000
> RDX: 0000000000000000 RSI: ffff888052781d00 RDI: ffffffff8ff9e610
> RBP: 0000000000000001 R08: ffffffff8fecf1f7 R09: 1ffffffff1fd9e3e
> R10: dffffc0000000000 R11: fffffbfff1fd9e3f R12: 0000000000000cc0
> R13: 1ffff1100a555e12 R14: ffff888052781d08 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88809893a000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f08959ea540 CR3: 000000001e4b2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  wdm_rxwork+0x101/0x1e0 drivers/usb/class/cdc-wdm.c:997
>  process_one_work kernel/workqueue.c:3302 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
>  worker_thread+0x8a2/0xda0 kernel/workqueue.c:3466
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> ----------------
>
> Tested-by: nogikh@google.com
>
> Fixes: 01e01f5c89773c600a9f0b32c888de0146066c3a ("usb: cdc-wdm: fix readi=
ng stuck on device close")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Tested-by: Aleksandr Nogikh <nogikh@google.com>
> Reported-by: syzbot+c6a1953c27ace6cc34e5@syzkaller.appspotmail.com
> Reported-by: syzbot <syzbot+c6a1953c27ace6cc34e5@syzkaller.appspotmail.co=
m>
> Link: https://syzkaller.appspot.com/bug?extid=3Dc6a1953c27ace6cc34e5
> Link: https://syzkaller.appspot.com/ai_job?id=3Deb69973c-340c-4ffd-bfad-1=
83f25211bed
> To: <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Added crash stacktrace to the commit description
> - Added Tested-by tag from nogikh@google.com
> - Cleared WDM_RESPONDING flag and resp_count under iuspin lock in wdm_wwa=
n_port_stop, wdm_suspend, and wdm_pre_reset
>
> v1:
> https://lore.kernel.org/all/97986988-6374-4e40-aa96-662939fabe88@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
> index 7556c0dac..ba5422d1d 100644
> --- a/drivers/usb/class/cdc-wdm.c
> +++ b/drivers/usb/class/cdc-wdm.c
> @@ -769,6 +769,8 @@ static int wdm_release(struct inode *inode, struct fi=
le *file)
>                 if (!test_bit(WDM_DISCONNECTING, &desc->flags)) {
>                         dev_dbg(&desc->intf->dev, "wdm_release: cleanup\n=
");
>                         poison_urbs(desc);
> +                       cancel_work_sync(&desc->rxwork);
> +                       cancel_work_sync(&desc->service_outs_intr);
>                         spin_lock_irq(&desc->iuspin);
>                         desc->resp_count =3D 0;
>                         clear_bit(WDM_RESPONDING, &desc->flags);
> @@ -863,6 +865,12 @@ static void wdm_wwan_port_stop(struct wwan_port *por=
t)
>
>         /* Stop all transfers and disable WWAN mode */
>         poison_urbs(desc);
> +       cancel_work_sync(&desc->rxwork);
> +       cancel_work_sync(&desc->service_outs_intr);
> +       spin_lock_irq(&desc->iuspin);
> +       desc->resp_count =3D 0;
> +       clear_bit(WDM_RESPONDING, &desc->flags);
> +       spin_unlock_irq(&desc->iuspin);
>         desc->manage_power(desc->intf, 0);
>         clear_bit(WDM_READ, &desc->flags);
>         unpoison_urbs(desc);
> @@ -1279,6 +1287,10 @@ static int wdm_suspend(struct usb_interface *intf,=
 pm_message_t message)
>                 poison_urbs(desc);
>                 cancel_work_sync(&desc->rxwork);
>                 cancel_work_sync(&desc->service_outs_intr);
> +               spin_lock_irq(&desc->iuspin);
> +               desc->resp_count =3D 0;
> +               clear_bit(WDM_RESPONDING, &desc->flags);
> +               spin_unlock_irq(&desc->iuspin);
>                 unpoison_urbs(desc);
>         }
>         if (!PMSG_IS_AUTO(message)) {
> @@ -1340,6 +1352,10 @@ static int wdm_pre_reset(struct usb_interface *int=
f)
>         poison_urbs(desc);
>         cancel_work_sync(&desc->rxwork);
>         cancel_work_sync(&desc->service_outs_intr);
> +       spin_lock_irq(&desc->iuspin);
> +       desc->resp_count =3D 0;
> +       clear_bit(WDM_RESPONDING, &desc->flags);
> +       spin_unlock_irq(&desc->iuspin);
>         return 0;
>  }
>
>
>
> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
