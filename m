Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E5134C815
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787766723; cv=pass; b=kwZC2tXBJLIaGYk01AIN+Fq8K6u5G+gOqPZZS3M+e2LPPStWgIKVkKZCYI8zLaMEwajcwFt1r150UfVhJ7PBiLCWaCiZe1wQTJbvJOKeZB5kg47wXudulSefvMYcV/b72GWcS4M2KLafKF6WsWjlv8zEiIOLMlOpGdDpzM9j3xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787766723; c=relaxed/simple;
	bh=M45pHRuPXTyFkv/fQAdfKGzeKSO4qjhp192d3qN30hE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MvjZx6Z5RgWqm9OmeNWSsNsmQCnn2fOzzr2+4hxcEwY4/Hd3KFUNmfXGDd4Y3RBvkAgE36DBKs7nxKf5MPPhVn07/3OXr5eTXzIIQNNy+hCI/zHNGtZnbffn2X3777Rl9mbMMIrKaZurj51xh2F66wh4ST1hznLY8WLqKkai60k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ENxtldDV; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ENxtldDV"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-4634d881742so704589fac.2
        for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 10:51:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787766710; cv=none;
        d=google.com; s=arc-20260327;
        b=OOREMIqxNEEa6mtmB5GwHeWhhA7qAWhkekNwm2YPlUDUJ6B/rdaWjUQnuwf+RNLRXH
         DrQ0eM35IkgQC9X1KjJOicYzWy2xhlMn/7bBD0K/DknSXugFRT7zhFoAjNJz1sNG39lq
         dXUYXvedQLMH9tQ+rcE4x0MGkmdadUeT8LT2hMS0A5VTNiIWEvnWEQe5u2XOg9VXqIAT
         xOI0gsN5spZWpLJzoe3RADNyhfaaY9EZOk+3q3u7XXQeCSbmP+zGLzIrJvKX3TvM4Bq8
         vuXI2oJl6aXvS01KEYw/JlLkEtmWrmZ3RF7HEPjlEoLymKuM9Y/g7Kbg56djnhSD9ENE
         3AIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GWqmSVb+52l0QOOZolluQtwIIvaeXFF5EVprVYaZjd0=;
        fh=SdSt7IcltpbO03KZe9Su0zW7mFdE/y2lqr+KM5QwCzE=;
        b=CnSR6PjnZFOxs95pyxw+shSejJsw4/TgpgMzDpVzxo8ZtgUD2bamJiuXoUEH47cC+m
         Y+HfqdPH1eG06HairpYFPcGnE0ohKjIbeQVewF4aWYZKsu/x3IUF8tU7K30CCvd3+K6d
         YX+gfh80WVtrtOMi8InDZ0lIow8TJYv7aSPALRQ6vvrnpNhDKLZtwivkjoLqi2j9u7e1
         FTKt6FHQYWHdjwvjaaerrfIErGjNCwk8OJYMH9wZpSpLu5D4yZ/nVkXdbO6iQxucyrjc
         4goE39C5l/79rV0EYEcylPN5mXT6jIkUYLu6UBDgHEXYIPoOi62QDN3kH9j7ERdHqxsE
         p4mw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787766710; x=1788371510; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GWqmSVb+52l0QOOZolluQtwIIvaeXFF5EVprVYaZjd0=;
        b=ENxtldDVHWQm5PxmeMuTdpX/HA94nNep4Gy0fxzgVf5tjm8LKwUlnP90gH7TW7+nv2
         gfcRg+QBqmnuMSsSpgEeOIqdsRVjPgEN+UN+QyOOO9NqcDBf4RVW3NcLFctL+3HLBIxl
         tmgb6MC+APkXvqXf1wGxXpDbTaznV9i3uLQVirO7th3qibkDV+ilvecgbEb9mps3/XAv
         UqMyJdjqmzYLqMQsFpqlaRWFBOBqaErJWqfHq2nFUbn+MkYMMH7aeFN1Qrsmje2WcFEb
         pxWWzeKS3H1dlwrJdkgRFca2lq7Z6efjQBgGpIUEvGgfWqKxyXDiawGgl2xdwT+01pQR
         Lp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787766710; x=1788371510;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GWqmSVb+52l0QOOZolluQtwIIvaeXFF5EVprVYaZjd0=;
        b=Au9Lv81t2tVOpRIVDcPWc4Git9k31/hbyo4X2ngNPdriypdYAyf7cB+1hCRAqD/n9V
         p4VLgTyi9GK3O39WJYZorKc+pxiCh5X/snkd88gEyhxj1Ft1V/Bwwh1YUqv1ybeDZ11x
         0cmJptjdOuz+H8u4TRLv+vdCB5YKPdqI4aHC0bflNCitDGq82I+17VJKwuGd8tJLsCMN
         DdM7YbTSuhqXEeVYFv25jhPNKqU30bPzGVaRUUR0fyXexsnvF4ekeLV0AmOHOTOu2dwH
         y4dng1J7vVY95nF6lCQI14lmYKQit63EiBaifkn29T+KyAyrWhxVZCjM75JfZPFytYg1
         DH5A==
X-Forwarded-Encrypted: i=1; AHgh+Rophu/0NYxIEHe3KMZguOJ2TIMCg6JHeGCLbCM81C49AzpyFji121Ia1yfevrx3XEX1oMQz6K8=@lists.linux.dev
X-Gm-Message-State: AFuF++ly6R9Zej3GHehUgGD7W87N4NG7oz1p94IAj1Qwe1C7xSs8pQvJ
	0lDRu8O19RpZA+644Ia/jPHb3OTGrdmxc48wqnA//WLTa79y3njVDXV4Ku7bFOYkb0xHpqgCOJh
	+tcufcsx6C315ZwyL0AKw9iChfmunSPLLrcqxAXql
X-Gm-Gg: AR+sD12P1kR5RXmY67GSwUEtNG1kgN/AgKKZaq8Sudp32sGQFJTgAlZ2oH9P2nB3spa
	b1LXZBPomRR5+Qk7/QeaL7qMJHpxTI2C8YpNtBxbxJ/PJnCjSFffUIxItEg55PDhQBRDHD3K2yu
	wY2kXEm349jclYPMrMRRIu5NQrUiZ1W9J9LaPer9FFSBJbvdO0CJEfEbXmllfSsCa0M8E1Mz+RL
	2WXPLcPWf43HPm8FPUKGO0wlRTL+3ERDUHs4TY4tY54OWb3d6sx6o/T0i9ONqljwqRGuIDenEnP
	UHA+6hI/gXILm9fw+j31FHfAMDvTXc8N8m+o3p1BJD8uqHKGFXAPbLFKrr2YC4jK4b9J2uUW4Qm
	B2sHVdnAVNru9IFpUljTs618BkYzdGQ9Kqq2ugpCPIkiKXdcZfejytEWE6idhCW8sm1cMfvFjWO
	aeUIAoPL/6d+/6hrGFi1qq/jGToQ==
X-Received: by 2002:a05:6871:88f:b0:465:317d:1c68 with SMTP id
 586e51a60fabf-46597c55b14mr9883267fac.3.1787766709764; Wed, 26 Aug 2026
 10:51:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e55c153d-a839-41d7-8669-2015811b0ab1@mail.kernel.org>
In-Reply-To: <e55c153d-a839-41d7-8669-2015811b0ab1@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 26 Aug 2026 19:51:36 +0200
X-Gm-Features: AcwNN1U-Rmi2pyS4m-45TBKQMz1EzPG_ryQrboCY77FfSHVVmk3W8yfDl2iAZlg
Message-ID: <CANp29Y5r7daGYmd46Rpv3YV5SOiYRRK4JJGs30EB7tYL4WVuGw@mail.gmail.com>
Subject: Re: [PATCH RFC] NFC: nfcmrvl_usb: fix NULL pointer dereference in
 bulk completion
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If you change nfcmrvl_submit_bulk_urb() to accept both drv_data and
priv, would the code be simpler?

On Wed, Aug 26, 2026 at 5:23=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> In nfcmrvl_probe(), the driver calls nfcmrvl_nci_register_dev(), which
> creates and registers the NCI device via nci_register_device(). Once
> registered, the device is immediately exposed to userspace, which can bri=
ng
> the interface up via netlink. When the interface is opened,
> nfcmrvl_usb_nci_open() submits bulk RX URBs. However, nfcmrvl_probe()
> assigns drv_data->priv =3D priv only after nfcmrvl_nci_register_dev()
> returns. If an URB completes before drv_data->priv is assigned, the
> completion handler nfcmrvl_bulk_complete() dereferences drv_data->priv
> (which is still NULL) when allocating an skb, triggering a general
> protection fault.
>
> Additionally, nfcmrvl_bulk_complete() and nfcmrvl_resume() checked
> test_bit(NFCMRVL_NCI_RUNNING, &drv_data->flags) instead of &priv->flags.
> Since NFCMRVL_NCI_RUNNING and NFCMRVL_USB_BULK_RUNNING both share the val=
ue
> 1, this inadvertently tested drv_data->flags for NFCMRVL_USB_BULK_RUNNING=
,
> masking the issue on the first URB completion while failing on subsequent
> completions.
>
> KASAN report:
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000004: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> RIP: 0010:nfcmrvl_bulk_complete+0x107/0x600 drivers/nfc/nfcmrvl/usb.c:71
> Call Trace:
>  <IRQ>
>  __usb_hcd_giveback_urb+0x374/0x530 drivers/usb/core/hcd.c:1657
>  dummy_timer+0xa91/0x4cf0 drivers/usb/gadget/udc/dummy_hcd.c:2019
>  __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
>  __hrtimer_run_queues+0x3bc/0xa10 kernel/time/hrtimer.c:2096
>  hrtimer_run_softirq+0x17a/0x240 kernel/time/hrtimer.c:2113
>  handle_softirqs+0x225/0x840 kernel/softirq.c:622
>  </IRQ>
>
> Fix this by passing priv as the URB context in nfcmrvl_submit_bulk_urb()
> and retrieving priv directly from urb->context in nfcmrvl_bulk_complete()=
.
> Because priv is already initialized and valid when nfcmrvl_usb_nci_open()
> is called, this removes the reliance on drv_data->priv. Also, update
> nfcmrvl_bulk_complete() and nfcmrvl_resume() to test NFCMRVL_NCI_RUNNING
> against priv->flags.
>
> Fixes: f26e30cc6b50 ("NFC: nfcmrvl: Initial commit for Marvell NFC driver=
")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+59d5e6a8ed04e6a000c8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D59d5e6a8ed04e6a000c8
> Link: https://syzkaller.appspot.com/ai_job?id=3Dcf4896f2-e0ed-48cf-888c-6=
677fdcd9ee8
> To: "David Heidelberg" <david@ixit.cz>
> To: <oe-linux-nfc@lists.linux.dev>
> To: "Amitkumar Karwar" <akarwar@marvell.com>
> Cc: "Bartosz Golaszewski" <bartosz.golaszewski@oss.qualcomm.com>
> Cc: "Johan Hovold" <johan@kernel.org>
> Cc: "Jakub Kicinski" <kuba@kernel.org>
> Cc: "Linus Walleij" <linusw@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Jialu Xu" <xujialu@vimux.org>
>
> ---
> diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
> index 4babde8e4..ca20030bd 100644
> --- a/drivers/nfc/nfcmrvl/usb.c
> +++ b/drivers/nfc/nfcmrvl/usb.c
> @@ -56,26 +56,27 @@ static int nfcmrvl_inc_tx(struct nfcmrvl_usb_drv_data=
 *drv_data)
>
>  static void nfcmrvl_bulk_complete(struct urb *urb)
>  {
> -       struct nfcmrvl_usb_drv_data *drv_data =3D urb->context;
> +       struct nfcmrvl_private *priv =3D urb->context;
> +       struct nfcmrvl_usb_drv_data *drv_data =3D priv->drv_data;
>         int err;
>
>         dev_dbg(&drv_data->udev->dev, "urb %p status %d count %d\n",
>                 urb, urb->status, urb->actual_length);
>
> -       if (!test_bit(NFCMRVL_NCI_RUNNING, &drv_data->flags))
> +       if (!test_bit(NFCMRVL_NCI_RUNNING, &priv->flags))
>                 return;
>
>         if (!urb->status) {
>                 struct sk_buff *skb;
>
> -               skb =3D nci_skb_alloc(drv_data->priv->ndev, urb->actual_l=
ength,
> +               skb =3D nci_skb_alloc(priv->ndev, urb->actual_length,
>                                     GFP_ATOMIC);
>                 if (!skb) {
>                         nfc_err(&drv_data->udev->dev, "failed to alloc me=
m\n");
>                 } else {
>                         skb_put_data(skb, urb->transfer_buffer,
>                                      urb->actual_length);
> -                       if (nfcmrvl_nci_recv_frame(drv_data->priv, skb) <=
 0)
> +                       if (nfcmrvl_nci_recv_frame(priv, skb) < 0)
>                                 nfc_err(&drv_data->udev->dev,
>                                         "corrupted Rx packet\n");
>                 }
> @@ -100,8 +101,9 @@ static void nfcmrvl_bulk_complete(struct urb *urb)
>  }
>
>  static int
> -nfcmrvl_submit_bulk_urb(struct nfcmrvl_usb_drv_data *drv_data, gfp_t mem=
_flags)
> +nfcmrvl_submit_bulk_urb(struct nfcmrvl_private *priv, gfp_t mem_flags)
>  {
> +       struct nfcmrvl_usb_drv_data *drv_data =3D priv->drv_data;
>         struct urb *urb;
>         unsigned char *buf;
>         unsigned int pipe;
> @@ -124,7 +126,7 @@ nfcmrvl_submit_bulk_urb(struct nfcmrvl_usb_drv_data *=
drv_data, gfp_t mem_flags)
>                                drv_data->bulk_rx_ep->bEndpointAddress);
>
>         usb_fill_bulk_urb(urb, drv_data->udev, pipe, buf, size,
> -                         nfcmrvl_bulk_complete, drv_data);
> +                         nfcmrvl_bulk_complete, priv);
>
>         urb->transfer_flags |=3D URB_FREE_BUFFER;
>
> @@ -174,12 +176,12 @@ static int nfcmrvl_usb_nci_open(struct nfcmrvl_priv=
ate *priv)
>
>         drv_data->intf->needs_remote_wakeup =3D 1;
>
> -       err =3D nfcmrvl_submit_bulk_urb(drv_data, GFP_KERNEL);
> +       err =3D nfcmrvl_submit_bulk_urb(priv, GFP_KERNEL);
>         if (err)
>                 goto failed;
>
>         set_bit(NFCMRVL_USB_BULK_RUNNING, &drv_data->flags);
> -       nfcmrvl_submit_bulk_urb(drv_data, GFP_KERNEL);
> +       nfcmrvl_submit_bulk_urb(priv, GFP_KERNEL);
>
>         usb_autopm_put_interface(drv_data->intf);
>         return 0;
> @@ -400,6 +402,7 @@ static void nfcmrvl_play_deferred(struct nfcmrvl_usb_=
drv_data *drv_data)
>  static int nfcmrvl_resume(struct usb_interface *intf)
>  {
>         struct nfcmrvl_usb_drv_data *drv_data =3D usb_get_intfdata(intf);
> +       struct nfcmrvl_private *priv =3D drv_data->priv;
>         int err =3D 0;
>
>         nfc_info(&drv_data->udev->dev, "intf %p\n", intf);
> @@ -407,17 +410,17 @@ static int nfcmrvl_resume(struct usb_interface *int=
f)
>         if (--drv_data->suspend_count)
>                 return 0;
>
> -       if (!test_bit(NFCMRVL_NCI_RUNNING, &drv_data->flags))
> +       if (!test_bit(NFCMRVL_NCI_RUNNING, &priv->flags))
>                 goto done;
>
>         if (test_bit(NFCMRVL_USB_BULK_RUNNING, &drv_data->flags)) {
> -               err =3D nfcmrvl_submit_bulk_urb(drv_data, GFP_NOIO);
> +               err =3D nfcmrvl_submit_bulk_urb(priv, GFP_NOIO);
>                 if (err) {
>                         clear_bit(NFCMRVL_USB_BULK_RUNNING, &drv_data->fl=
ags);
>                         goto failed;
>                 }
>
> -               nfcmrvl_submit_bulk_urb(drv_data, GFP_NOIO);
> +               nfcmrvl_submit_bulk_urb(priv, GFP_NOIO);
>         }
>
>         spin_lock_irq(&drv_data->txlock);
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
-upstream-moderation/e55c153d-a839-41d7-8669-2015811b0ab1%40mail.kernel.org=
.
