Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF66280CF6
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 05:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778909829; cv=pass; b=Zt8PNXq62hiKufC0NspPAvFMN4AF6sG9eFuAFwjgEuET1nQ2YqN3lwFTZpsKujrag4+I1Z9YVzhWUfDWD7U/Ux3MFhS371Ww7FcE1eutRDBazVxCmfMD9FNT4Mn37n+8LT7JG0H+VN725yHFPCtdb5oMMBkrclsu/34WeuNTOLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778909829; c=relaxed/simple;
	bh=xDFFrfH04SW56wfyCI91yEMphOP47TYuQiTHVR96chY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mwV1rfweEmeULlRroILls5s7yWURsNLVZYzeXo3jm/CqzRnaZNhKIyhPcD8LBIT+74O3f6Y+p7Od+YxMoFrLO+LgQuEUgifgNspjoOfQCYAPGtjRqpYDsExG+zQPr9G3uDMuJk6K/UrdDZiBi8CruoEFUC5aZdYByMQoNRjUZ3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=chOVqPNu; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="chOVqPNu"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-393c93a01abso6910381fa.1
        for <syzbot@lists.linux.dev>; Fri, 15 May 2026 22:37:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778909826; cv=none;
        d=google.com; s=arc-20240605;
        b=D6pJ/S4r+dO+MbvDaaFVBulAtF1McUdDNJB+2QNPvnrSrU9BSTXssgmr8dj1r6BEdQ
         42Kp+pI9EJTjT+oG4CQIfDUlKanYRBqAFo3i6a6QlxcBjuy7BD2Gu/DDSibWirJMCFqQ
         V2QSL+/uVRaLYHrekSEseYOb6CuH/iVCsWQy8QRh2jMDz33DcUJPJsmDCQZPW/LAoH8s
         7jRJEUi1Pp4Gt71Gmzc32BxPsU5ExCwO5//riFVnUfEo9wt5VmpJjTGoe5aBpxdCJAKe
         9M3BnyvpzXllwlzRPzCGMKYkTtWOexFAKy8/8mzE9eLlqrg86cxOlvOOE++TeKt/ICQn
         sD6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=A19/adej43L9FNJw/iBy3hGfz1wvpNOu/jtIHrEiu6M=;
        fh=fCmk2QinozzSnRwNWiLEczoKAfRYwkdcMAgUF3L1y8M=;
        b=jzVvleKTT1f4sAooB5wMB2K2694LEbUrLOvyftKkzm+I1Jnjk+l+iY13rhnUPcLYBc
         JNy/Jfp2yA/Htj51ZISW6324W9ujELDMJ3Djm9aojUWUtrv9Dc7ULCMDdNUnvnXUV5En
         JyMNJEdSR0SRsGsKRXNcT0eMiu/kMcEKnhtr5Y3ryFmlytvOquwn9j+hdnW1ZpObxz0P
         qRPAAFS8TYgZqtFpD2maUk6BoEoRaa5tL8QpDA9bo5vh5CtyUmXWfuXUTtd8FyNABm+S
         nrR/tthpsPzKIrlQk3cP+5rENTAlBmR5L1mHc0V2wvTdtz4HBPFi+3Fk54H3uUX/pvOS
         5B/Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778909826; x=1779514626; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A19/adej43L9FNJw/iBy3hGfz1wvpNOu/jtIHrEiu6M=;
        b=chOVqPNuX/cjIIctd96/0FlCSJm5c5lkI6jENH4MkBDqv8OZzWLhXuHdmLEStcAAQV
         EbaZyG8mxWUErzZXiCl5zBXmU86nr8drq/SAEEEAqGy0jcixuZWGe5T9qimYyXr7J77v
         3IK09OyuIHsFpnnnsOrpM2I7gn6sGRfVaUqsKbdGBXw55OSqmEPjvUv02eq7KlqoK8Or
         E8cjbSQyUP6z0VHcBAttalQSfAJtQe0s+qm0BvqGko5wqXudZP8AeWhBUZzPzh7xnqEd
         +GxaQohLVioNWBuWKMaeg+HZHZ9IHC+gOXYJLsKV/QQ1jH1pWvDKnh9OeTq+G+Oi9e3m
         LK9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778909826; x=1779514626;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A19/adej43L9FNJw/iBy3hGfz1wvpNOu/jtIHrEiu6M=;
        b=i4FBHOnfsTFsOk45+A0EAZU3Ft9yu5M2VejwATMOhChC/hyrTTalAh2M3CXevPd++S
         ehJdCOMWUuKLv2g4G67s4yIDFdiLjfm0ume60W8SJSSY7nG4ZUNk3swJSrL/2QqQkNJP
         Z3uOaUVIKEHM2aG7IW3AspSNJs0q3iuBOODf37couNAnn2ZgAI7vbMafqjgG6qCVBiJh
         PXMyiWku27Wbeqr/fMwgGOCNIyNMP6wUXxcQ8nlrsBhZnWDCnl7IS5lYp4EhEmTACIvK
         4UGy9V/IMm+r17UqCyQXHbbKP8O8/iCfLgGX+Wo3K+3wACYbTHY/nXQ1cOy0VQed0pXa
         Guvw==
X-Forwarded-Encrypted: i=1; AFNElJ8GXp2eSCIC4OFOhlC0o7idrbSb0yEjhCx05S0GnzeAO4UfJNhcv4/zL0qJr20B35EVMcjCP84=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWc/hmobQCMbbVnkqDk4egCJErC5iJwtc0iEUpvz/xJdw639Ve
	EMUEYGoRUTBwfSXCjdFe4Ex3CXM91v2/N7mIPEwLnKx9LIc92Z1ycg1onYitXQEoy34VESvV52F
	9H5BGhatGhN4iBSFw/DTJGF3pYGQLP7h3GU5deBBxUSc+bnWpDMSIfC3Urd8=
X-Gm-Gg: Acq92OF4c8Rb5mkMi8U8pV9pv/fXCEw2ed+80p1o9MgXXwkO1lLtTOCm1XoXEEn4YF7
	gvD+LHuLOlgWEXJaW6P7hbEO+Eq0sC2WCuQqtENk7EtdUeQurrcAdqYUC0KZBi7qxJaj0INDPki
	fHRduFS1bumUA6fI8OlBBuTIJV33rBv/pYmfLfa2bOxEV00Gc1n9/3r8TeIt0kklcUZs0t4s1Rn
	mG3yDDIb7paDERbUCVID03JrKJin5R37Uq3JjPWbfHBmRp7WDJu2Ug4PBo3pss4GIy8qyDhpVjP
	MMxo1hL+UVls3kZgVOPQxGGRoMzoxXlBycRzJ1c1lAhcNU7Waco37LKifh26Z+YfAEEcq8xDl/e
	mLZVkYqY=
X-Received: by 2002:a05:651c:b0a:b0:38e:9eb1:693b with SMTP id
 38308e7fff4ca-39561d56230mr25438161fa.3.1778909825575; Fri, 15 May 2026
 22:37:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cac82e3e-7e75-4dc6-b83b-5b54a3e692e7@mail.kernel.org>
In-Reply-To: <cac82e3e-7e75-4dc6-b83b-5b54a3e692e7@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 16 May 2026 07:36:54 +0200
X-Gm-Features: AVHnY4LrKNFGJrLnJELsDyHSHfvXcmuC-36Ci2KM88tLNJa-3JJiKpukc55onGc
Message-ID: <CACT4Y+b2BQdv_5Zv1Yvn9_LurOzj2kw-OKucjQKEoSvMtFCETw@mail.gmail.com>
Subject: Re: [PATCH RFC] Input: cm109 - prevent concurrent control URB submissions
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The fix is likely correct based on the old patch submitted in 2021
(which slipped through the cracks).
https://lore.kernel.org/all/20210804145801.2762-1-paskripkin@gmail.com/T/#maf0ce09938d2e5042b9c277819c9fece7cfcbabe

But need to double-check the logic, it's very complex. And check
commit description before submitting for real.

The Fixes commit it found is correct, it was just not included in the
formatted patch.

On Sun, 10 May 2026 at 22:39, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> Input: cm109 - prevent concurrent control URB submissions
>
> The cm109 driver uses two URBs to communicate with the device: urb_ctl
> (Control OUT) and urb_irq (Interrupt IN). These URBs are designed to run
> in a continuous, strictly alternating loop.
>
> However, the driver also supports sound events to toggle the buzzer.
> When a sound event is received, cm109_toggle_buzzer_async() is called.
> If urb_ctl is not currently pending, it immediately submits urb_ctl
> out-of-band to update the buzzer state. This breaks the strict
> alternation and causes both urb_irq and urb_ctl to be active
> concurrently.
>
> When urb_irq subsequently completes, cm109_urb_irq_callback() calls
> cm109_submit_ctl(). cm109_submit_ctl() blindly assumes urb_ctl is idle,
> updates the DMA buffer, and calls usb_submit_urb(dev->urb_ctl). Since
> urb_ctl is already active, the USB core catches it and triggers the
> "URB submitted while active" warning.
>
> To fix this, check if dev->ctl_urb_pending is already set in
> cm109_submit_ctl(). If it is, defer the submission by setting
> dev->buzzer_pending = 1 and return immediately.
>
> Additionally, update cm109_submit_buzz_toggle() to also copy the latest
> dev->keybit to HID_OR1 and HID_OR2, ensuring that the deferred key
> matrix column update is not lost. Since cm109_submit_ctl() and
> cm109_submit_buzz_toggle() now prepare the exact same data for urb_ctl,
> refactor cm109_submit_ctl() to simply call cm109_submit_buzz_toggle()
> after checking and updating the pending flags.
>
> Assisted-by: Gemini:gemini-3.1-pro-preview
> To: <linux-kernel@vger.kernel.org>
> Cc: <dmitry.torokhov@gmail.com>
> Cc: <linux-input@vger.kernel.org>
>
> ---
> diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
> index 353d3c1d3..0114d7293 100644
> --- a/drivers/input/misc/cm109.c
> +++ b/drivers/input/misc/cm109.c
> @@ -348,6 +348,9 @@ static void cm109_submit_buzz_toggle(struct cm109_dev *dev)
>         else
>                 dev->ctl_data->byte[HID_OR0] &= ~BUZZER_ON;
>
> +       dev->ctl_data->byte[HID_OR1] = dev->keybit;
> +       dev->ctl_data->byte[HID_OR2] = dev->keybit;
> +
>         error = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
>         if (error)
>                 dev_err(&dev->intf->dev,
> @@ -357,8 +360,6 @@ static void cm109_submit_buzz_toggle(struct cm109_dev *dev)
>
>  static void cm109_submit_ctl(struct cm109_dev *dev)
>  {
> -       int error;
> -
>         guard(spinlock_irqsave)(&dev->ctl_submit_lock);
>
>         dev->irq_urb_pending = 0;
> @@ -366,22 +367,15 @@ static void cm109_submit_ctl(struct cm109_dev *dev)
>         if (unlikely(dev->shutdown))
>                 return;
>
> -       if (dev->buzzer_state)
> -               dev->ctl_data->byte[HID_OR0] |= BUZZER_ON;
> -       else
> -               dev->ctl_data->byte[HID_OR0] &= ~BUZZER_ON;
> -
> -       dev->ctl_data->byte[HID_OR1] = dev->keybit;
> -       dev->ctl_data->byte[HID_OR2] = dev->keybit;
> +       if (dev->ctl_urb_pending) {
> +               dev->buzzer_pending = 1;
> +               return;
> +       }
>
>         dev->buzzer_pending = 0;
>         dev->ctl_urb_pending = 1;
>
> -       error = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
> -       if (error)
> -               dev_err(&dev->intf->dev,
> -                       "%s: usb_submit_urb (urb_ctl) failed %d\n",
> -                       __func__, error);
> +       cm109_submit_buzz_toggle(dev);
>  }
>
>  /*
>
>
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/cac82e3e-7e75-4dc6-b83b-5b54a3e692e7%40mail.kernel.org.
