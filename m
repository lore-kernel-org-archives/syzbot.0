Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B79B15A86D
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779464925; cv=pass; b=h/iiNT6c3SZISd/8/2eB/4N1WuMM/yTPVrbHwISKlnEojY0Kc9GMseJtEtcBspFMJq7DQKJEZ7bq3iHyb2j1uP3cTIJmlKNYjIR8ObCqNnTMGyYaObLoTJYaUqy4Rpx5nfmuKCb7vEmf5+qaQx3hUloHPFjFix4yP+XsJJ4IhoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779464925; c=relaxed/simple;
	bh=b/hDyBlX1ea11t9exifZ4hLzaw8rskTVHq5v75b64NY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M7IIM0agJxFtHKDAPxx3c3Ku2TpcCsDUB+p35N99hurD2bMgxw9YcAKNbscfNkEp2eWI27FV/gZskGib6fjI1CEtqzO8r4G7mcWcVx8vmyPf8SKINhV3w/lAzWkkF+FFqwj5fWpKS+xU4/MrrQSHXXJWagSz/yDgZEl+asucFuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GAeXyw09; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GAeXyw09"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-69d7c1e2a48so1060899eaf.1
        for <syzbot@lists.linux.dev>; Fri, 22 May 2026 08:48:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779464922; cv=none;
        d=google.com; s=arc-20240605;
        b=EQN6ujuu72tktQuxlCPOUYBKTt9wSV59AWWZUPSBwlj7mGYqQJ/BX7xU4lA4dEWoJG
         I7Q58ugADS+QxYFF0+nrz/JpmPafW102X+BUkW15w5VpC0/Ys34/ndSv1CB3lWCBu/s1
         +STpIq+urGyxXVmD+8FissDYP4s34cMBP3eEi9ZfhoP9X4VbN1jjO0CJXaKNaXrNvYL3
         fDgfpLSd0E97foeDYzrnaOr1kg1U879Sutqqr2b9xJK1sPX3Un+yxRUYcpEFdxSS1kHh
         AWJhEChndM88WA7MZ4zxn6Gdg1nQtaGr2nirrAft5+lL7MplbrTUOXIvsuDao01m/CSu
         dsdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BZ3gPEiHoBx/V/zApiKhzA5TeozVnyVFO98qaBjC8YQ=;
        fh=8VUbZaavEg9Fi41rU7mKZH/4HeDliW1vb9HiIJkUDG4=;
        b=Hz4qhxaT4uY31OVAch4zlNeNQM/n2OuQsEHdTzRsHzbQS/LjJDeFo1lyKZnGlKJ6Se
         bHL5s8afOOhUSCMh94ci/j5vtSNln/SP8D3H2vBbzuZ30L/4LkP1QcUl4gKGQHW+U6cK
         efpUhltu6L+y7LGoHzhM7ppbHk0iR2h7wjZVBoofUPSY045Ugf5yG4JHAlmc3frxl1ue
         HShU50dhXRNhQs77zr84HC120F08pZaknf9Vh32q9lh30YSc/syYrLZysBPdy/446+o8
         3qO1dOXDoakNdI7BNVm6fhJ+2LxEn6w4zX089l0Xsd0k//c6yxEF0/TZyk27XUtXeLhp
         wo6A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779464922; x=1780069722; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ3gPEiHoBx/V/zApiKhzA5TeozVnyVFO98qaBjC8YQ=;
        b=GAeXyw09C7seOPjAEziEydZncoU423fleScdXmylRVq4lzoEtpZVoTGlWLptAKOhyT
         dt+LKYvUCurukF1PByhtV0QRprUge9rjru+4PFRCEVLPQPQckhDOB5lGcyFB8NVotL3s
         hmh76axs6gN+Z0sMVfmyp09zkqlYDZ+BDbKUQqSAtQyarChyIXMole//PPAQlGQlKFLE
         2HOLBAyF6npEJ03ONcSRpKSzFh/IOgfDR+eWGwzquJl2kNBGGDgE8WaMwLacsj2ZgZT5
         HFkqfZ7ZDDiXSgzmj6vR1TG7t5/ovSRNh9QR6q7rrAtrITi3NeheUvTZzrAAPNGL47Vs
         2eTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779464922; x=1780069722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BZ3gPEiHoBx/V/zApiKhzA5TeozVnyVFO98qaBjC8YQ=;
        b=jX4AuUc8YKAh2iDT+OH4Mb3GcF/UAMpHEOX3oWiiRb0fdKNDe0Qp/4LvU8yMUBYarM
         J7eJjJTxeVJzeljWWJdRF5WTSpf67wNbftrSrykTN9E8/jk2S1+aG5VPjX3lTSmmTx+t
         x3J64MqZOL8LGL6QcW42Dr7hOFt0vNubNrECjEuBThYAD5hmWQsWok3sBfwy4cwjPK/w
         i3sLKGoeUxq+yro2D0rzU7ukwCzLgfV076hNho5qyy6JdrhccJEtw232pbjrtnwYaXtq
         EFknkU5Fnlr31xH2OeNM7nmJbNko8B//ULuvxDeHH3m8W3mlzgv5VxgPVhfRZth9nZAP
         BbuQ==
X-Forwarded-Encrypted: i=1; AFNElJ/oOPi5BZhao63IGywmd5u8zyuNxYSx1+N7y9NjLW3Xonr1HW07B03CXWBip0iv/hHlh3chcGY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzE43p8HFRnfs6fb3jLt2F0vPXd8HYTYCf3brAjT0xW+0B0wQcV
	XjacCwaGXxucj6HJUGy71kKl28l64hZbWReH6bAyzRvlTBUAkOpRG3LK6bV1qXZZbVNjVNqY6ij
	ES1uh0EngAax7/Rfc+dxaBJlwFLxNdnRl8YqOhuOL
X-Gm-Gg: Acq92OGyzBo+amFnPFUAXP62k5LIe+pZzwqIlm5mosAe9IbUlZA0SUCnPgRfUrrv0NQ
	CwlyONUc6DnN3eGyxi7JY2gU0EM2uFXq8vnhQTAFx9FUJfsdVI7HLjL+HpYkxx3IJ5j6bZ7jdxL
	59sDtErHGVW+6V4yazBZvZ8XOM+Bt6yEwjNlgJ9bbiLpOwM/q2LEuEju672q5MYeMzE+dzixfCY
	K5NiqdyB4o5uLeGM6QpwaJe5rFHZDzIGAMiS6yLd5k6UOSQDO5NyPilG3A1pBHA+eZ/4H0jf8XU
	EaAS8/96DQGelu7rCsuxYYr+rvIFzDmT5xyu6NBgxXOrr8PS3r2yH42kUQXQemGCxv8VqUz4f54
	Jj3kJ
X-Received: by 2002:a05:6820:138b:b0:694:85a9:d8a9 with SMTP id
 006d021491bc7-69d7ecb59dbmr2106805eaf.46.1779464922126; Fri, 22 May 2026
 08:48:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <3d57ee87-f29b-43a2-8e22-2ca4d86cb799@mail.kernel.org>
In-Reply-To: <3d57ee87-f29b-43a2-8e22-2ca4d86cb799@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 22 May 2026 17:48:30 +0200
X-Gm-Features: AVHnY4L1hI4U1OEMUFZgs9hH18zgmrmwRNDUiBAqrGKbTqlemceeELmlPCW6Ers
Message-ID: <CANp29Y7LzexM3-TP1FQL-=hVW5mE3HOTSFQgbsHZTUJNh75otg@mail.gmail.com>
Subject: Re: [PATCH RFC] ieee802154: fix kernel-infoleak in dgram_recvmsg()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 22, 2026 at 9:31=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> KMSAN reports a kernel-infoleak in dgram_recvmsg(). The issue occurs
> because the `pan_id` field of the IEEE 802.15.4 MAC header is
> unconditionally copied to a socket address structure and subsequently
> leaked to user space during a `recvmsg` syscall.
>
> In `dgram_recvmsg()`, the kernel zeroes out a `struct
> sockaddr_ieee802154` and then populates it using
> `ieee802154_addr_to_sa()`. Inside `ieee802154_addr_to_sa()`, the
> `pan_id` is unconditionally copied from the source address to the socket
> address.
>
> The source of the uninitialized memory is a local, uninitialized `struct
> ieee802154_hdr hdr` variable in `__ieee802154_rx_handle_packet()`. The
> header is parsed by `ieee802154_parse_frame_start()`, which eventually
> calls `ieee802154_hdr_get_addr()` to extract the destination and source
> addresses. If the address mode is `IEEE802154_ADDR_NONE`, the function
> returns early and leaves `addr->pan_id` uninitialized (containing stack
> garbage).
>
> To fix this issue, explicitly initialize `addr->pan_id` to `0` when the
> address mode is `IEEE802154_ADDR_NONE` in `ieee802154_hdr_get_addr()`.
> This ensures that no uninitialized stack memory is ever propagated or
> copied to user space.

Please include the original KMSAN error in the description (truncated
to save space).
Also prepare a clearer step-by-step explanation of why the memory was
left uninitialized and how execution reached the point of accessing
the uninitialized part.

>
> Fixes: 94b4f6c21cf5 ("ieee802154: add header structs with endiannes and o=
perations")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+346474e3bf0b26bd3090@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D346474e3bf0b26bd3090
> Link: https://syzkaller.appspot.com/ai_job?id=3Dafe5d617-6767-4025-9746-4=
1a5ff62a35f
> To: "Alexander Aring" <alex.aring@gmail.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <linux-wpan@vger.kernel.org>
> To: "Miquel Raynal" <miquel.raynal@bootlin.com>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Stefan Schmidt" <stefan@datenfreihafen.org>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
> index 41a556be1..8f2ec62de 100644
> --- a/net/ieee802154/header_ops.c
> +++ b/net/ieee802154/header_ops.c
> @@ -175,8 +175,10 @@ ieee802154_hdr_get_addr(const u8 *buf, int mode, boo=
l omit_pan,
>
>         addr->mode =3D mode;
>
> -       if (mode =3D=3D IEEE802154_ADDR_NONE)
> +       if (mode =3D=3D IEEE802154_ADDR_NONE) {
> +               addr->pan_id =3D 0;
>                 return 0;

I think it may be more reliable to zero whole of addr on
IEEE802154_ADDR_NONE (except mode, of course).

> +       }
>
>         if (!omit_pan) {
>                 memcpy(&addr->pan_id, buf + pos, 2);
>
>
> base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patche=
s.md for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
