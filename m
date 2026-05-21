Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD62743634C
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374104; cv=pass; b=dg90FNmTwbY8TdBYlrplaJAyltnZppGmRvhfeB0vaFQLqoQApiGsDFwfGuxv3YqeJG1t4SLSHmFkUYvhzc5WD6yFC5StvCJ+MjzpOqD0kH+OVWmd8J9yKZs2PYG6Vbi2E7VtVzTh9cjnubQOriT0jlg8SqWLiq2Qot5me2nZ6TE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374104; c=relaxed/simple;
	bh=jC6oCsoyo/ySqMEjwUdxnA2p9nnp3l+s8/a9rPocOf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JaASCakp8U4Xvx+NuesHFynRlrBdH4nc6iucUl2AAeMCcIMwNQNCplhM6lOTFeE5SBIxQRoA8TmSm/0hBrlXPTK9dPA00iSwwQgjDsLDQrSswPMlOswlZxn/McHcS9TLyTspQ9jTNeML35o4X8BEhS3ZFxY6D3laTQZIl3s5bkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hTTlFFGJ; arc=pass smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hTTlFFGJ"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3042a388168so729468eec.1
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 07:35:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779374102; cv=none;
        d=google.com; s=arc-20240605;
        b=aPh3kh3MP1rEw4Dpe/LyaMWxiystGV5UdYNxxFiKDk+X29bhlVoKZY68Gh4o7+69+X
         I9k9J+yLTHmncRQ7nCDB0+4SdZ21bLH04L18QbVzzYlQhoBznv1mLsfwu0UmAO+hG9jI
         0hXHjZRWQHIJNmstq14XGBuaIp1bH3ERhRXbiOGujHxBrEeS8aBC3nf0hV7BdoDw8xuu
         BQ0hWcurQj1ItW6jmtWmBuGAipHpNdab/0kcBj4XCl2eRleFL+PkXJ/tLoVJbPuLp8I2
         M3RycoXSwA4CLB9/swnKWDDTNIWY2nyCFqjCzn6MgBEgWOTiHqKq6SK4umzjPTOJutdp
         Dp5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PQxOV/8q7DyTi/N8dWrN6KY0WRRhAV8WOVFnnjO9kbk=;
        fh=HJK3QxysrWqXKSa5ETPaNUY1xG6hvbJyHNdFo/oSLPU=;
        b=Wt2KwJO5moeKscyWHSMpuXfei/YoIhbLMlf3dO0ZDTlkldQICKi6fbacpgDh4gwwhY
         BXB7OSe7PLfDT233eVzpeDEykpU7YzTAakl+mhoP0KBehjXk6QhgyUjmADRpsdKsbM39
         CHtZFv/9h16Ghuilg0yYzq6j8a7xcU5DEr0QvpG/GCo3a2UGe1PSJuIlQDS0F1RHALwe
         MuW7BhN6fp2Pj03OmoqalgZ7nWq/m8bpqO9sssh0vGkWsA2KmLAZuIx9wjg8eAL8O4Hv
         /ozFC+E5kA1RlE/0eV1Yn9bHcBrzT08YK1RJ9AuwwmOucMqPS0ysBZXMcfYPigaNo1o/
         fqrA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779374102; x=1779978902; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PQxOV/8q7DyTi/N8dWrN6KY0WRRhAV8WOVFnnjO9kbk=;
        b=hTTlFFGJjGZ4RMJmBuNEqJbYiEnWsIwbeqccMK+4SsXdV864+bevFUS8FKkbQmpE2I
         JVLhXnibSqow9v8nWGIuVMwDr8lDDRD2JMwDgUFhv62HgpJp2pIjf7qjiUVs0qXjk1AH
         3tbbGO1lO+C1QAVsBs5BubAc5gl0P9nkN7X3h546BE5YqOWFXNjnLdCz3Ewiv77Gkty4
         ZLno5qk2Q8TavvaZYW9YnDbdsdqlny/dfE2h3iboCfvN653QkyqbEXsh2d7IsL4G0UoN
         I30joo6fq0rh7jlVfuH4QmuYFQZmzXpVmH2FDr6FBwVoHONFbtpvxvl1chASzuRbM9A5
         cE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779374102; x=1779978902;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQxOV/8q7DyTi/N8dWrN6KY0WRRhAV8WOVFnnjO9kbk=;
        b=E+8QRuhOsJf8U/dpOj6cYr4NcC2QGk/7zTvFbfM+73CRnK8hE++uKjUJKA06HrGOOw
         P2pe+944fF7QmM0EmnF78P2rIEpOgDq/GkvVxXPEXLebzT52dk36R1oeiHz+KQr54euK
         vKv2B3DuKRLQaNuw8S5lZs4PGrKEHIPMvAHk1Bgg4wm4i/8Zs3VmZh5Rmmww1qmtHu7f
         EV9Ov9wV/hiSq5uunwVWQZTArpJJa5FHBGvQk8d5qXfa3ntzR8HEIxDZpgmFDHgeGl4P
         3erdXMcpTxjahssn53ug04cDUdkk9lZMT9MIkORMuos07tgKgn7CBcExI5JPF74t+YPi
         udfA==
X-Forwarded-Encrypted: i=1; AFNElJ9HyReBnIX7gCRWp5OYHqJGkIrrAeqva/UmqVScRhUWUtwbcpzYm8ZmlIf3RbZNs0kUmWI9Whg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyCxF69HWOIfIfyDYoQ8PRshKdVWQ0U65jNPNpRiTQ9Bnv8UQq
	idsUjyPRA7WEDZ+Spf6Ra6heS92b+gwF9XSb5xoPwWMp3OfBXFBsQaoi5MM2KMySuOh0eQX9E4C
	Bi6NDjhQoHI1/1ZlxVterQimQvd58w6/lT71lD7NL
X-Gm-Gg: Acq92OFaM3eMwqIXZWZIphbZ6gqFqAsgSWIAy2bl65S/OPJn8DH8E7BjO+mfijehHtU
	GMk+NaMcNcxN0Si9vSy0+Y5jR3PASN5wwDlBtSKkrBFcI2IJuYSmfKqFlAGlUEcm3/eKazD3nX7
	f+PJA9TzQ2OkvfFprodYvwy9Frbr2NoNxgPzaJLkB0Ir8poIG2o85Elj2s58FFP+ET9UC6GOx13
	2LxC70SvbQoWUSf8APWsgxZnLGsZh2MVO8HOVWpEjh4kn/gm9d+F56aYrhu2PdhVsTJhHkP1fw/
	ig4vPKk24yAjbrJC/A4ECR7QKm4QtJKc3W1Kh9/qNHkjTWc=
X-Received: by 2002:a05:7022:6629:b0:12c:9037:5115 with SMTP id
 a92af1059eb24-13634c6eda2mr1222714c88.13.1779374101313; Thu, 21 May 2026
 07:35:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e6a66888-9f57-4c38-9732-2563acc3ed73@mail.kernel.org>
In-Reply-To: <e6a66888-9f57-4c38-9732-2563acc3ed73@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Thu, 21 May 2026 16:34:24 +0200
X-Gm-Features: AVHnY4JX6CWVKHuIDw5pV1HC2Mswh3eqWBsfbSeqtRxxzWZYs-gIzhH1oA9djv8
Message-ID: <CANpmjNOg1L_nCDDVhDT-UYhk0oVOygB7k7zSLYEZX7dhkBfTsg@mail.gmail.com>
Subject: Re: [PATCH RFC v2] Input: cm109 - prevent concurrent control URB submissions
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sat, 16 May 2026 at 20:24, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
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
> Fixes: d8a43a83633a4770f00ee77079fbb7a2218cea2a ("Input: cm109 - use guard notation when acquiring mutex and spinlock")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+2d6d691af5ab4b7e66df@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=2d6d691af5ab4b7e66df
> Link: https://syzkaller.appspot.com/ai_job?id=ca80d200-7e54-4431-b367-300f0488c403
> To: <linux-kernel@vger.kernel.org>
> Cc: <dmitry.torokhov@gmail.com>
> Cc: <linux-input@vger.kernel.org>
>
> ---
> v2:
> - Reset `dev->ctl_urb_pending` to 0 if `usb_submit_urb()` fails in `cm109_submit_buzz_toggle()`.
>
> v1:
> https://lore.kernel.org/all/cac82e3e-7e75-4dc6-b83b-5b54a3e692e7@mail.kernel.org/T/
> ---
> diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
> index 353d3c1d3..8e51ad58f 100644
> --- a/drivers/input/misc/cm109.c
> +++ b/drivers/input/misc/cm109.c
> @@ -348,17 +348,20 @@ static void cm109_submit_buzz_toggle(struct cm109_dev *dev)
>         else
>                 dev->ctl_data->byte[HID_OR0] &= ~BUZZER_ON;
>
> +       dev->ctl_data->byte[HID_OR1] = dev->keybit;
> +       dev->ctl_data->byte[HID_OR2] = dev->keybit;
> +

This now affects all callers of cm109_submit_buzz_toggle() - why is
this correct?

>         error = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
> -       if (error)
> +       if (error) {
>                 dev_err(&dev->intf->dev,
>                         "%s: usb_submit_urb (urb_ctl) failed %d\n",
>                         __func__, error);
> +               dev->ctl_urb_pending = 0;

Callers of cm109_submit_buzz_toggle() set ctl_urb_pending=1 - on error
this now resets it again. This may be correct, change, but not
explained in the commit message.

> +       }
>  }
>
>  static void cm109_submit_ctl(struct cm109_dev *dev)
>  {
> -       int error;
> -
>         guard(spinlock_irqsave)(&dev->ctl_submit_lock);
>
>         dev->irq_urb_pending = 0;
> @@ -366,22 +369,15 @@ static void cm109_submit_ctl(struct cm109_dev *dev)
>         if (unlikely(dev->shutdown))
>                 return;

A previous patch attempt by other developers just added "||
unlikely(dev->ctl_urb_pending)" - why is that not the simplest
sufficient fix? This needs explanation in the commit message.

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
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/e6a66888-9f57-4c38-9732-2563acc3ed73%40mail.kernel.org.
