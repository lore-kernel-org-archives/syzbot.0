Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282B648B389
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779122293; cv=pass; b=XxFpzR+nlTHp6ukHHRKHWg0hH2WNGMBUhUeDhEJ7HIvSKHGSv6njTKlM1gUOvo7KWszGHFJky4AFMP+uO6HCLeXTy0LgT4sVzLu+TCcOvH+78t46AS0dyvPzx5cIZXpnnB5DZVQrJpyDEWQ7Aw1a1XKDKsEiMzduThaw60krt6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779122293; c=relaxed/simple;
	bh=AWqBuAhn0sbuiaqBRHW9n/nJHhp1Llv45338C5kAJmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WCRxds0rNaIRiNk5XCNvtZiTb973yAzentbnLDFSEaGz6fXGm9DRrRFl+Broe/GwpC1go0Xi/IFcRtlX+NwnGWrzK/UCJL7JhPefEDmDymdV5nl3xVmntN5gg1RVM6ojLzz3Dz41Z/6TlwCAfQqaBIe9BgMabDPlcC744ChC1tI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hzpP1rL4; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hzpP1rL4"
Received: by smtp.kernel.org (Postfix)
	id A4174C2BCC9; Mon, 18 May 2026 16:38:12 +0000 (UTC)
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C47E7C2BCC6
	for <syzbot@kernel.org>; Mon, 18 May 2026 16:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C47E7C2BCC6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-435153d9b68so1763276fac.3
        for <syzbot@kernel.org>; Mon, 18 May 2026 09:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779122289; cv=none;
        d=google.com; s=arc-20240605;
        b=GS3VN8wmjNVxun5FoVy3QXHK+TqoRYlO8nle9dIlXgVti/gP8Jr7255LuucTbnNHx+
         +/kcjH6Gm5MxIpGf/DejFusILIMzpAALUt+NJLfxR0GukPxfDAJaUCvF3xu8tlIUpXFa
         wZDgYzTSyBNVgsxx+LOhsBHUIqgRC1X9LLOiOCBp+60WjMdOkYlGulVulY2axwXiPOPo
         XGSUo4uMHCs9BonyXH0QlyOWUtZ67glYaAilALPYvLLbv0SEntgWjWWedmcqZ0rxRndS
         oxc4dV/OgfwuKzBPM50uXmDYRkG4vAHxsK1I3RjMueYFoYozUJSMGKj5ZrOOLOKg7fOX
         3eeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q9HiZnNcBy5FC/KPnIZSyEgIawCMz7ojmWKKLb7XM5U=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=TpgCNqi7Q/3eZrqTGrVr8kgP3j16eIEECbFP712+nrL2axUw5ZoJArK9BeQTP7OmzL
         gk5RdCG1HLtPuaCV5Z8+GUnVidvjT52evGj6cqsxapGhOfjyVJPRGMbtfYCtiJnWpVeF
         nu/6zrYzB6oainpgvPEIhiBoQY2dtA00aTr2Tr8xVwJBkwbcJcIW2SaWeqJf6l5oSaS+
         IZ5/ql1RJzN3ythQDRpIKlmOm4IlplZ75NqAOmQfrCqUTZExmwEJ836vI+0tRehnhm60
         QfQ+F8+R/gMxqupdi3FLHl8J8M8WHD3bAud/fLKDf/65sDngYjp24AZjfuNvL2PaHJAR
         btLg==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779122289; x=1779727089; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q9HiZnNcBy5FC/KPnIZSyEgIawCMz7ojmWKKLb7XM5U=;
        b=hzpP1rL4dJ4zV8kcolMaAQh3pVvS1UsyjWNCLfq0qCMsOoFbHpUAhzNWWaS3kBUeIc
         kVYMm7VQYj0nN0EXT76mZMPfQ8DdHX/0VcDvlDOcmkpTpx0bkNiA1EbbjXjM6Bb6jzly
         IRBSR8neIyukykj8GeBoXQAoN2Ih2u5AS4KuVzlGNb41pDOauIRUWXBFQZ7Ao/M+guIl
         akxJ0AfxKRpFNRFgNAJypM8KEEGp6f6uVot5gKWwJGAg6Dj5uz/WQsoFFvWoqqYdyM/j
         3PejoTY4DHlenzZHiQnHj1K5K4ktpLoATAZD01mpBb+dEmcLUBehC2toSmgu5TKimbEB
         x/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779122289; x=1779727089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q9HiZnNcBy5FC/KPnIZSyEgIawCMz7ojmWKKLb7XM5U=;
        b=FzTaDkLCwpH7bwGDTzlKmAYWjAd0tlSDCZmFA/rI7gLOSlBFVr2F71d5IdL8kpm0Z/
         BHg+73LZuA9CjYc6AILD0uSly/dMqi82SbdfnNm6L2kbuWq/02fKF+s4AvUPiPViB08C
         k8m4Y0XQwIHeAm0t3dhf/6s9lIlYmCdXLAocuYJxs+gyFwkw7BTEDvnbdktLfxZVIS1D
         nDc7A5F+oYrVbzYR9uEKPLe/UR4+c3kj6YnrpGL/dH9RHYV97KEnw587wyb+QQ3nzLiS
         oC9Y8gYvPdOkIDniAOAiCsnunToMVSLpKcg4q745dzDpUAmwWfI4s2y6njklpY/7yv0U
         IEgA==
X-Gm-Message-State: AOJu0YzwBaBmQr0MbKoqBYltkpYDBRiUSlh0d0Enes2oowsBBeRxT4kl
	ET/Y+Ke1vgQ2bIMOkJkkPCjpZLsJ0w1vc4cODcs2lvXTeB7nlbA4o0ifJjMO7eM2F4ukDNPpTVm
	gpnGXYPsqrY2LFz+OkMDzzYr/WdrMKtpM5Z6AQhJ0z7h8XrqPxGN7xJ//
X-Gm-Gg: Acq92OFOImDLjBn4KdcLoURMSaIl4+m3Wo+2OanWz+FU9IS+OWP8u+eA0EqAOao5/zc
	/NVUibdZgyf7M9RPGKMeBl3UvlL2nuy+xJICV/Zx03Bpr8J70D0toFPVMVM+TAO1btK9Ul3S5ox
	6ZxRifMa3ofFDsUUfZgHm6qP88HZs1qASkLsIIK72ygQZkegbXkuqw8cWPVkyqWpLTTQVHnrVS9
	1h3U8M9NMkwtIoY/7M0C7fA54kK5/Z3yZ0bBUQO/WQYV+XN6VFiHKJ1hMwQnZri4/9XAvPd1kCL
	VAfDH2MOiymTnCAe2AGXwp7DKnfnDnWWF8MPXbtWKbki7LaLt84mwhv+lkqsyKWgZziiMSJGJ8r
	Lu3Tfyg==
X-Received: by 2002:a05:6870:e6cc:b0:417:5a8c:feba with SMTP id
 586e51a60fabf-43a2d9af606mr9467281fac.12.1779122288937; Mon, 18 May 2026
 09:38:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <97986988-6374-4e40-aa96-662939fabe88@mail.kernel.org>
In-Reply-To: <97986988-6374-4e40-aa96-662939fabe88@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 18 May 2026 18:37:57 +0200
X-Gm-Features: AVHnY4Ld4Ob6NkrYNriwO7cWHjjF-aqxe1C67m3yXwu2gyX-hOpaZhWH8khV-oQ
Message-ID: <CANp29Y64h5+uJC+sGyx+nnd3JnLR6R-TxWTjpo1cTm-AgbhODw@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: cdc-wdm: close race between workqueue and release
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a Tested-by from me. Also include crash stacktrace into the commit
description.

On Sat, May 16, 2026 at 4:34=E2=80=AFPM 'syzbot' via
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
> Fixes: 01e01f5c89773c600a9f0b32c888de0146066c3a ("usb: cdc-wdm: fix readi=
ng stuck on device close")
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Reported-by: syzbot+c6a1953c27ace6cc34e5@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Dc6a1953c27ace6cc34e5
> Link: https://syzkaller.appspot.com/ai_job?id=3D99107a5d-cc34-46f2-a7ce-b=
b797b331fd3
> To: <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
> index 7556c0dac..d4318395d 100644
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
> @@ -863,6 +865,8 @@ static void wdm_wwan_port_stop(struct wwan_port *port=
)
>
>         /* Stop all transfers and disable WWAN mode */
>         poison_urbs(desc);
> +       cancel_work_sync(&desc->rxwork);
> +       cancel_work_sync(&desc->service_outs_intr);
>         desc->manage_power(desc->intf, 0);
>         clear_bit(WDM_READ, &desc->flags);
>         unpoison_urbs(desc);
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
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/97986988-6374-4e40-aa96-662939fabe88%40mail.kernel.org=
.
