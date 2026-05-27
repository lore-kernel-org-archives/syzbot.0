Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA753BB66C
	for <syzbot@lists.linux.dev>; Wed, 27 May 2026 20:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779912993; cv=pass; b=mhq4cRiLn8X0DvMRBF6HUZXMz82p1iIhdO8u5bppFMX4IY6E573Ug0O08LwTWA+gNFhpEx8t0JGkZ7lOXXO7qLjyzT3uXZ7DscNONEzRUl/eUi1cCFMA3Kxc+/Es7cGYGBse6xwmfZKXWbL4OzEx/gzo85CoOm8akrQ/AlxNOw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779912993; c=relaxed/simple;
	bh=8s9JnDM5AgEg8YhkMe0PjIMuXzeDzCtZOcV7tOJ1hd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pu6FTZhlkA+eyEEkKSmjkcm23ZTKfXHzq4Dk31g0i/eoaa6GO1JtL826QhtZNYk5phy/KObiWC3zPWQXcMyNBuPoKgUAC839W3Msog7zgVRJv/doJVWqyPO7BheQUs/e3TNZEoUK/6rUsfulL7XZfOh6R0fOdx4/Dwj0iJwTXiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eJ0xnpCB; arc=pass smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eJ0xnpCB"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-479fc1fc048so8789951b6e.1
        for <syzbot@lists.linux.dev>; Wed, 27 May 2026 13:16:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779912991; cv=none;
        d=google.com; s=arc-20240605;
        b=Deo4F6qrVA/yOqEKMwXlcthvFvuZ3SPIGKcmA2Z6k8SX1oqnop92bqlh/c2sSRJAWS
         V7DDjgAV1SORxMmhLTYHvi98+MTeLxXKgmjG5/nbMMAa8DKyoQAPbKYwCbEysGpjpPv9
         fOY0eY7RnT68a8xHRIYGVCcvn340NmfpEYHLpLhABJ87vlrS6Kln5/UNFMnRvs2E1C13
         WwVgYQLOUm1Gsx0QyMtwHeqaBhu5g/rByVyL/kUF+opofMSYjeUi9s75LrdTu+KNxYRz
         oFktxluxgBD9KNBVSIeKO+0NUCzpfZZS5zo02Bb8m3MqvC3OynhOBBA5BMqco3cSFQ+q
         WH1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=geweKKoYgABexEjpym9S7E8zkrHinFQegGcmQRe3sCU=;
        fh=grYO1o58O9Xtes6zvzk3V0mj2EZsg96lWAON9j3UDT8=;
        b=cM79/sO/ecUipLxo/1LKkjo2BzRzOtZ6CWdD4DYtRorSXco9c50RvuXYJpNMopSAMR
         Co/gebnX022eK1l5BZTncmrNDeHwLwvkYbwc+gkp+ijqY96o2muFbOfvEEbc0sXv9j5h
         lYJC4fcUONtr70JzOGOD85rQBqLtqHPYH0DLFapl1k8P0loYeeUwB8QZa6eSE72onwo+
         /dYPO2q3LktE5MZE+Y92Osu2GZOKWnGdOblHTuMUJ7ovu1Hchp7wP6dhU9KkAzo6I3NR
         NWWqxh2UT4WDmJMX1uH2YE4QGKIXzuy0sI4q7jww6ZJHrmhOZqkTpY4f6MfAupug3mU9
         Zr+Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779912991; x=1780517791; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=geweKKoYgABexEjpym9S7E8zkrHinFQegGcmQRe3sCU=;
        b=eJ0xnpCBADT0YYwEdsa6rj9OgZWzSNgHc2Mn1rE+Nz9E0Eu6fVT+ZpW0y4wfL1CMNO
         QvkHPAvTAwSA91e6XOhbN0h+glx84Twmn+ewG7I2HMJQu2bfZxK0mgQCB4w7R9vchb3o
         n3aWbFg8szoIrpOv5GnUK+ZkkhTeQidiTBBeuJ1XcLBCZ2WeJgIaWZ3fa9XPywz/vPb4
         AH1orCz4ihy7VIzEw766Sz26v0v8OQcK30Oe7BTJzN0nx6M2+O6pTQ3hlb0NJ/rfTiaY
         GaE047Jj7p6Dpee1ulxcNZqNmjWzC+4csItIo1HEeUgubxVP3/NI61eb/C1CUKkhXKzA
         Kq5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779912991; x=1780517791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=geweKKoYgABexEjpym9S7E8zkrHinFQegGcmQRe3sCU=;
        b=eAo33e1SxQDniN1z7YQDeXhomWJ7ANSo6pJ73DG/ZzlBeWSYm6wJObgPkOt+WlXHpu
         oUYlEjQ0tsDmPyMm/bj5C81HC+JTCBrJaqanwYur9UGcV2+t3PuRDtxJhruqyEi1a6sJ
         eTunSppgqfkb25l1FHKEIYy8hzqMNSMcKvOCatGc9UHdwW2RsPdp7URuawKtdvQDgLok
         gla90oGgzCW+0HSip43HbxnRwD2Chk64+QAieR7d9sUvQL+kgo9u4b+xXdj7NSWdCUCK
         xVEQLq4wKB8+uqQpqjnEFsgo+ipTqp9CH/zcUkfI9xwmu/sH5jG1ucInWJv53hHviczo
         z2pw==
X-Forwarded-Encrypted: i=1; AFNElJ+y0zhAmQIn/ZFFMN0eSCEnpMdFS9n0XXWuEIefOyoGKfypXMfX24VrtKM4KZOXPcAl0cbODRo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLqH+RZPTJ1bl0Ta/wixtnnT+kWLNUSAgGkguT2rHAg/KcD7kY
	LAWMbvSUZOgISMebugWijTZUbzUnLkJii6mezJLel9u7a+V+mxaky9GBzT4XK3LQjdSiBUWLtLF
	4lQOQjIPPZS8dO43VXGOwoRWrX1wRO8vC//iRJZpQ
X-Gm-Gg: Acq92OFSJ52GYhYfWzjs0InMwu1A/a94p0SrHL3eLMy6yqyOpNG/BQCcLunNFxYdBMK
	MMJiHTqilNjG2ymMDgSNj3xVI58IgNqlPk41bUlpjXPwDoZHqrgryWPUuV7Jxsm8CzAPUNzrV9I
	JHnZkNBJenj0Kr1OxrNOswSvL7mKk61IuFmo7I8dzfKdL2nRgNDDVpmySeJcuxEf8Hqv6UmYmzB
	v1pTMPt2HfR1vi/D9vRzTlOsh/8cGEDTZ+di3XKxhw5cnoyjZZ0pKr607sthrLH8Ph71LXwyprL
	sabyPff15lqANJtJ1YlLNY/NVLy6ebBkN5Ii3+QqOXZ+FFzrX4ZSVViuP6yfNYEcYzYG1enHqvA
	CjOXJ3s8=
X-Received: by 2002:a05:6808:17a5:b0:479:f58a:c5d5 with SMTP id
 5614622812f47-4854a3d68e1mr13245805b6e.45.1779912990378; Wed, 27 May 2026
 13:16:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <127f2164-d295-47e9-95c4-31959dcc8460@mail.kernel.org>
In-Reply-To: <127f2164-d295-47e9-95c4-31959dcc8460@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 27 May 2026 22:16:19 +0200
X-Gm-Features: AVHnY4JU1QYhAKkoONVnzc0zK83r6Gchf1RecQ66z043YabKirKHwCvEt2_H_2Y
Message-ID: <CANp29Y7H5X0mNv1hFTpOEKnwiOHuqjVHZuVv6x-Nma6Pwca-xw@mail.gmail.com>
Subject: Re: [PATCH RFC v2] ieee802154: fix kernel-infoleak in dgram_recvmsg()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, May 23, 2026 at 5:49=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> KMSAN reported a kernel-infoleak in move_addr_to_user():
>
> BUG: KMSAN: kernel-infoleak in instrument_copy_to_user
> include/linux/instrumented.h:131 [inline]
> BUG: KMSAN: kernel-infoleak in _inline_copy_to_user
> include/linux/uaccess.h:205 [inline]
> BUG: KMSAN: kernel-infoleak in _copy_to_user+0xcc/0x120
> lib/usercopy.c:26
>  instrument_copy_to_user include/linux/instrumented.h:131 [inline]
>  _inline_copy_to_user include/linux/uaccess.h:205 [inline]
>  _copy_to_user+0xcc/0x120 lib/usercopy.c:26
>  copy_to_user include/linux/uaccess.h:236 [inline]
>  move_addr_to_user+0x2e7/0x440 net/socket.c:302
>  ____sys_recvmsg+0x232/0x610 net/socket.c:2925
>  ...
>  Uninit was stored to memory at:
>  ieee802154_addr_to_sa include/net/ieee802154_netdev.h:369 [inline]
>  dgram_recvmsg+0xa09/0xbe0 net/ieee802154/socket.c:739
>
> The issue occurs because the `pan_id` field of `struct ieee802154_addr`
> is left uninitialized when the address mode is `IEEE802154_ADDR_NONE`.
> The execution flow is as follows:
>
> 1. `__ieee802154_rx_handle_packet()` declares a local `struct
> ieee802154_hdr hdr` on the stack.
> 2. `ieee802154_hdr_pull()` calls `ieee802154_hdr_get_addr()` to parse
> the source and destination addresses into this structure.
> 3. If the address mode is `IEEE802154_ADDR_NONE`,
> `ieee802154_hdr_get_addr()` previously only set the `mode` field,
> leaving the `pan_id` field containing uninitialized stack memory.
> 4. This uninitialized `pan_id` is later copied into a `struct
> sockaddr_ieee802154` in `dgram_recvmsg()` via `ieee802154_addr_to_sa()`.
> 5. Finally, `move_addr_to_user()` copies the socket address structure to
> user space, leaking the uninitialized bytes.
>
> Fix this by using `memset` to zero out the address structure in
> `ieee802154_hdr_get_addr()` when the mode is `IEEE802154_ADDR_NONE`.
>
> Fixes: 94b4f6c21cf5 ("ieee802154: add header structs with endiannes and o=
perations")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+346474e3bf0b26bd3090@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D346474e3bf0b26bd3090
> Link: https://syzkaller.appspot.com/ai_job?id=3Da507a109-d683-4a2c-bc03-9=
3394f491b17
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
> v2:
> - Zero out the entire address structure using memset when the mode is IEE=
E802154_ADDR_NONE.
> - Include the KMSAN error report in the commit description.
> - Add a step-by-step explanation of how the uninitialized memory is propa=
gated to user space.
>
> v1:
> https://lore.kernel.org/all/3d57ee87-f29b-43a2-8e22-2ca4d86cb799@mail.ker=
nel.org/T/
> ---
> diff --git a/net/ieee802154/header_ops.c b/net/ieee802154/header_ops.c
> index 41a556be1..a9f0c8df5 100644
> --- a/net/ieee802154/header_ops.c
> +++ b/net/ieee802154/header_ops.c
> @@ -173,10 +173,13 @@ ieee802154_hdr_get_addr(const u8 *buf, int mode, bo=
ol omit_pan,
>  {
>         int pos =3D 0;
>
> -       addr->mode =3D mode;
> -
> -       if (mode =3D=3D IEEE802154_ADDR_NONE)
> +       if (mode =3D=3D IEEE802154_ADDR_NONE) {
> +               memset(addr, 0, sizeof(*addr));
> +               addr->mode =3D IEEE802154_ADDR_NONE;
>                 return 0;
> +       }
> +
> +       addr->mode =3D mode;
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
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/127f2164-d295-47e9-95c4-31959dcc8460%40mail.kernel.org=
.
