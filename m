Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D56B47ECE7
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779201663; cv=pass; b=p+eE+G7yxs1r97/ynyeAOvhGu2S6yq6x0EJjpbkzinkvsrj7WPhk6IJON1/+Cu1kjCCbZQbcuevmIfuUeTGcN+C44v8lUfsMO2W7rUiimGbm35FO5dUofAv46/sompwDEyEecBMU7/qEnQ/YM6DDQxCPaVKFfPpaDgzCh4bLSmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779201663; c=relaxed/simple;
	bh=7arhaTjLECl4VAokmI0wAwOedMMKplP2ZRQGYMUBRIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1T4OeSjQycOkUAOwsf958PV44YftXFMvOI1ZvoYtYqGX9vB15kOr2rgsQo2Ld0c09wdEFNw1bf3dqB5grxqOlw72PXP8dHriRcuI9OhuIIChxhKbAAITkslsi+1PFWgpvHomFdKwdsOKIzhdL3fqsywHpO1lnoSiTAkTve7rOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=axThyOMn; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="axThyOMn"
Received: by smtp.kernel.org (Postfix)
	id C5B7FC2BCB8; Tue, 19 May 2026 14:41:02 +0000 (UTC)
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DA8EBC2BCB3
	for <syzbot@kernel.org>; Tue, 19 May 2026 14:41:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org DA8EBC2BCB3
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-439bdb1d75bso2356948fac.1
        for <syzbot@kernel.org>; Tue, 19 May 2026 07:41:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779201661; cv=none;
        d=google.com; s=arc-20240605;
        b=bygS+Ab9PR2jz1u89raiw/AtkcuYe5gepF8DRSTpZ3/KkT6t4HSaoXTXQMcYZB5PTB
         hQbiF27shGzFU1LFXmsQD+XN4LMJFoFRpYOHQxmjiOGrUcO1Mx4V5pbmT2+IYbFLgkHY
         zV/1469JDnLUS7kt8FZkHYyOet42abe6rXFiYfQKW2Y2LYaltdcR2jHhJfvJjcmN6qHl
         NgtfHIKwYBstzSym+U0wJrI5QLjTTYpMAAiaKMCvDCSPIvKESdjmWFDcEGyp75aESAYS
         QjAu/UtTmLsZCSefEKxoBeKKVPo++pvZp8jsVeL/A1HDfiQo4Jkw6yxXH3rlPLK0WoNj
         pGxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dJxwDDgX1uOcnO6b3gPXFzOLYsj+FNocHTIQS11UDCk=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=J+Nq+V9tOS3RU085L6VyvcMdXtf9ly/4U2tA3k1S3Pdw1CC4rAQW+EDhF/JBfoqc4l
         Phtd5NsW4d0hQeUVelwLwLfyE3DWJ3e9n10YID2CgZrpf4LpO5X9c8PPDlE2zSouoSlB
         PQxc1c6iD/6aUhLvtuuvErwE0JQ7FggY54aIrmmmuDNBofNN67m6ugHBiE/Y/DKM5kYP
         C+n9HtbuoTC65QwY1g7fveS9CSyLT1omsJFQwD6LDS2z6p6mUJJzgcpVxvUbYsDGXyxL
         gbMaqCov65EhK7uT9/TSoBmOTCJn1w15M8V9UlG8YpT/Q708DT23PG7uYEma7YsO85Qn
         gHLg==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779201661; x=1779806461; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJxwDDgX1uOcnO6b3gPXFzOLYsj+FNocHTIQS11UDCk=;
        b=axThyOMnDMJ7dh/l8mzmxSRmK22g98qVOz8PD3tQnSNxQ/8kAWCFBKBSOmlA75C5Ht
         v7tFBEOdIIbXFw7LVoD8PpgSIWHXriFmRdjoW0d9jPO/360n7jpstSgC+bVajuRhalyW
         P2KyuB+op1pdRcmcn5p/gZywvnQMxumy9PLEgg8us2UKXLOl8dfBEbzLTBnDXFEgkXV8
         2Q06LdSPqyfqUi4z3DYEw97cC9Mp0SZcC87N7MsA7XHqi6bR8pwkseEp0pt+3KTI4Y8x
         3ZV4qn06tIVgSYYFB1vgyZ59oj4mOKCWGktVBmcRg2zYCIQmF/kUp3XDjaNWFMPvB47C
         FJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779201661; x=1779806461;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dJxwDDgX1uOcnO6b3gPXFzOLYsj+FNocHTIQS11UDCk=;
        b=XfMZE8nKus/MtzmOPJEeh70Zyzl/XFempY/epOShsyEqA0w1t68N7gmX8jyuYjvsqc
         KE76DyXCaB2DJIXO73Y3rgHqn65uVt1DsfbAAWHtHc/0AKhOUn9MtJ20g3T+bd+7hT8z
         ztBhDWpLdcaKVNQgoh9Vu8kpim4UVzGwNbZyWSUdWv1wKEKwMM1s1ADJ5koZsblCWRXV
         6+IdNFMJiTLOgxi9F1TVYF/hwYiAiC1WPUAvlN93yI9Se/WMdfUOR2jXLrkh/YecI3Jm
         rlOMWzAOcS6hbMwNLpM24O+ly3QZK+gxRiyzeFxUxmcyZ7E5sBD21ZM8NUH+IOT6aIk2
         10gg==
X-Gm-Message-State: AOJu0YwhDjrMUkTHy8zA50PDT2yK30HWu6TJAHLWbqNh8sr1nk9xUEwL
	xGsUvjw6wMgxE4oX4d1s4zhSPu1Fil8qSt5/xOPns1OSpJuEMcD4s6LKAzlCzbi4rY05ptGkaNV
	EL9YDApkNGgnBAWQ9G/dy0WAUHvw3/6K7MfqjyPajHuj57Tgf1M3evBS5
X-Gm-Gg: Acq92OEDi6SS62yVfmufcdAAMegpyRexeSQSuDQab/3iQqHJ0+E+Bso05VXy3gQxDGw
	P21lvMNYX011qa979gbO2RHp4vrEYn3u+krco+Y4x3VEjQWoxQyoWWzbU4qqYc58RmG/lhD1S55
	iWfMJMq11p7Dc6Ac1VWon3eFJCZVADWxOHJOSEvfo5Bu4D6+0byX1oNQJM3fmIMwGvnDjLEe9wt
	f0qFrfkKIPc+mHv7r2aaxrCnbXOkmsFGWs++Z4doVz2GXE+tkCdJDLt+eQDwRMoTXRPlRIoalak
	jbXL0F3ajMVvNJBJb1eoK6ehp3/di7+azavzs51EUuDZZJ8ZqNDsrv9Yz4YzDHi9ukT5tkNG9HT
	HSKGKZu/VLGx2XQ==
X-Received: by 2002:a05:6820:1746:b0:684:bf61:ed25 with SMTP id
 006d021491bc7-69c942e1b26mr12664094eaf.19.1779201660359; Tue, 19 May 2026
 07:41:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ea8bba94-ca4f-4a7b-9181-a858d92b6ca9@mail.kernel.org>
In-Reply-To: <ea8bba94-ca4f-4a7b-9181-a858d92b6ca9@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 16:40:48 +0200
X-Gm-Features: AVHnY4LWPyQFPVR6X6YvMsbwYcj8kmOo8P49rQCFYQr8h75glkRc_NEE_-cd9z0
Message-ID: <CANp29Y5AR7a+jhG5rUkkn8hopL1+MsOf+X+yjBtJ9r1a1B4jCA@mail.gmail.com>
Subject: Re: [PATCH RFC] HID: mcp2221: fix OOB read in mcp2221_raw_event()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 1:39=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> syzbot reported a slab-out-of-bounds read in mcp2221_raw_event(). This
> happens because the driver does not validate the size of the incoming
> HID report and blindly processes it based on the command byte data[0],
> without verifying if the report is actually a response to the command
> the driver just sent.
>
> If the device sends an MCP2221_GPIO_SET (0x50) input report before any
> GPIO operations are performed (or if a malicious device injects one),
> mcp->gp_idx is still 0. The expression mcp->gp_idx - 1 results in -1,
> causing the code to access data[-1], which reads out of the bounds of
> the URB transfer buffer.
>
> To fix this, ensure that the report size is at least 64 bytes (the
> expected report size for MCP2221). Also, verify that the incoming report
> matches the currently pending command by checking data[0] !=3D
> mcp->txbuf[0]. Since mcp->txbuf[0] and mcp->gp_idx are always set
> together when sending GPIO commands, this check inherently guarantees
> that mcp->gp_idx is valid and correctly initialized for the specific
> command being processed, preventing the out-of-bounds access.
>
> Fixes: 328de1c519c5 ("HID: mcp2221: add GPIO functionality support")
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Reported-by: syzbot+1018672fe70298606e5f@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3D1018672fe70298606e5f
> Link: https://syzkaller.appspot.com/ai_job?id=3D770c0407-c1fc-4070-a4e7-4=
ccade9bc122
> To: <bentiss@kernel.org>
> To: <gupt21@gmail.com>
> To: <jikos@kernel.org>
> To: <linux-i2c@vger.kernel.org>
> To: <linux-input@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
> index e4ddd8e92..7f4f2110b 100644
> --- a/drivers/hid/hid-mcp2221.c
> +++ b/drivers/hid/hid-mcp2221.c
> @@ -861,6 +861,12 @@ static int mcp2221_raw_event(struct hid_device *hdev=
,
>         u8 *buf;
>         struct mcp2221 *mcp =3D hid_get_drvdata(hdev);
>
> +       if (unlikely(size < 64))
> +               return 1;

But this size parameter is not used anywhere?
Also, is there some const or maybe sizeof we can use instead of a raw
numeric value?


> +
> +       if (data[0] !=3D mcp->txbuf[0])
> +               return 1;
> +

Does this change contribute to fixing the problem?
Is there any race scenario that can make these differ?

>         switch (data[0]) {
>
>         case MCP2221_I2C_WR_DATA:
>
>
> base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patche=
s.md for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/ea8bba94-ca4f-4a7b-9181-a858d92b6ca9%40mail.kernel.org=
.
