Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B8F55294B
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 15:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788880599; cv=pass; b=fjSJVusfiGXIAIASHzubx7OGxuUMJq078rGnR5KJqgZugbyn+GWFHdcMe4I/AdzK4cfe/W4KAaj6P05w4TUj7mxxs8RuYbL4YSgUjXljGMAx2hPZbXqghFrXOnNmcMLgUHwTNp1wQ/623uU3sb7Evwmf4qN529XQ7J9MJaq3TzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788880599; c=relaxed/simple;
	bh=Q6UUWgwUJzWXs2hh/hLZP6AD1nbUynZnWOedZPhXgfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XBejoSFX0+wYrCUg5xVc7UqneGMKMUr/GRF9X5HmslM4J42xNZsDgnG4+Y/U/kWwgtNyp05nbA1i7tBi6aj18n50f3TJ1NZ7xukxNO1W//waEf1/sQxyopVfjKQqFZs/SWMekz08QW9V+EredJpDMRr5pauSd9DQyxSfU8EZonk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OjQcFiHf; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OjQcFiHf"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6b1c75f0049so3606379eaf.3
        for <syzbot@lists.linux.dev>; Tue, 08 Sep 2026 08:16:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788880586; cv=none;
        d=google.com; s=arc-20260327;
        b=SadRR3E6Qog8cX0KHBKmlE4NlIrRkGZBcTevyutCJFv+Xan1qmnldYv7M0X7hz2+mk
         g3d2247827q/6cuKmlZLWVezH2Falf8UZa11EhcDE85mIYVqz61/S2xkH50+3jn+Sjuq
         e5cENUK68dh+wmQ0XKOikqtOhKaFJsi4v7BDaGzmMiDW9uQoFxEQXydMviT62C5lyK0y
         GXwGi3ep+LnAy07qfDtO57KFbhJuXQIRfG3/rKiKmehM6w3b1SFWUuhnyRHCn1b8P/Xl
         6lsK6RONKf9q4LKA+KRuyZLtmgrunyTM1zpmr+NOOaMv6QoN+ToxYenCafFyugeWtRtn
         c5Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eaJglp88bT1+WFdwcdYSXXUZTxyx+5GYn11aM2zEgbs=;
        fh=BkD3rflGJw9slclp3pp4LqXg4pCF7Le/KbvVc3j3EGE=;
        b=dVjEKQcLHnXtE1zkK+/JD2AIhYioHiC421GxQ9BixOUItMeDMQIp6KIzV+1/oRioGa
         /TmCDouzKM7gm78T6OPul7xIvqbbVVcBK1bDKLe1WMBIcmYFbESVCHUnUBIBHbLuKgar
         8tJ4X5tvHJvvorLja/S+JhNdWtlV2d9Wnqy8gyD2wCuQ2Zd0wMRGEPW1qSSc8hPhX0Ue
         bQi3yJgwljOmN6SYcc042oNxfg3CliWHzUlvWp2xJUi+ZIDFGl8xOR9TXWBYoz4bTDIH
         1Zl79OmxebNMIp2GP/znyOULcSTi42GjIw8/r8SuCxJv80bVZIXzbd+4PjY85C2LHXr4
         LpHw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788880586; x=1789485386; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eaJglp88bT1+WFdwcdYSXXUZTxyx+5GYn11aM2zEgbs=;
        b=OjQcFiHfbPJjREiomP3pqWbMUBVd1UBccw8lDkScBsnQW/+A9j6OQtNKWJbE9DVMIi
         cWYmE6VUCvml4vnj06bn4xuHI/4rIwiMXQQi0Tl9cVGDs6a3k1vem1o8a4wDfQBD1ncW
         E635dNcMXzoPqcYdovAIwOUlIb273HZx7421L4iTcBuBKBnFGZyiXbo/dzmqBG93xwA3
         qN1d3PtpOebl4vFLBo3QOFThHnRsaywUmdwsub4ZX+xWVWgQZhcQZd5QXS+ROy8K5vKv
         6iaBjcikdD3ZL1PBV14IE9pc2OvfaoskV5i41YRU9sftUEeByeD7Kae2cKF6TPA550yD
         0coQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880586; x=1789485386;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eaJglp88bT1+WFdwcdYSXXUZTxyx+5GYn11aM2zEgbs=;
        b=aZ6ydPsOKUDkaGZmAyN+xMNkRxgBWKOjyD+j2XgbEc3/Ffk6F9NxMKhj4OcHh/LK+M
         H+ZzADWEuKNGj/DfujgTgZCKhKSVCrUpoLXZW1PowMx+0tGsxqojQ4PfM8yhZ8x73xvT
         HlqkxvytdIM81xrFX9hztdfdaiTGhO2MncF1/rbXgI/WAEQ/EWaq4IX469m9MWDzGjx+
         jKv4vN3fktpQwtB8IY0nfumxlkWx77TDapspw+/K7tWKsJWC22P0tr1Se0PLAgPlYenR
         woPzZq/wDCivtrq7/HStI7frDlLYRsZoIg0Gpz5ppO0a8txcyx5e9koOQj2L1VFTjs0Z
         5TKQ==
X-Forwarded-Encrypted: i=1; AKwUvBwpeeVHZY+1yVSuW8cppV5lTJYs1C6g0BOiLFaUt/84WMVVJ313RK8FojDWQAe0RdOXQyAx1ds=@lists.linux.dev
X-Gm-Message-State: AFuF++kp6kpN2QDaEGy1q/A8sHDegBO3axjAkaBzmQU6G7Ol8Ao9HJ2D
	rZ2ioKhbqBFYJwEX8ur8QUYQKEVxpPrExP+ooNvHHoVerlB6/JUCCeW2bf7atyVfMVDQEw/Cgab
	MuDYzzgh3tW8M/NVe/uJd+g/a9pzGXYlq736YGbR6
X-Gm-Gg: AYBFou30e04J5mNCWv0FSP3VhQ5BmGlgUmS0yVzD9NBvAToeKNu6hvw9HgzZGywr5D0
	G/GWuMcy3o89P2gv/cW5LUScExwToS0DYdslGt1cp6nZor/A6IAin2NmSYKN7kxUta8dWuwLSiV
	0aoP1ZVb2lWhpfmaBDgMdlXqeeItMoX4siK4We7fYfHO1g9FlppGEoER1gGRiik4964W6qAz5Qc
	C4LKTDrBjhWt0ZRKIzFUQL3oOamjw/UQKIZk7HpkbyWqfPDImSnLmCjHZ57d0CkzewsFC9aSm5n
	2d3nJ98l3u1f9z1hxTp5HiOEahgrz5ojeBhhz8vVv+yQliaOpdX6/hgA35d+8WOaG4ZV9V7MMRI
	A7O3DoNWR
X-Received: by 2002:a05:6820:1890:b0:6b1:c40d:635c with SMTP id
 006d021491bc7-6b6fb8d5a72mr17927890eaf.15.1788880585868; Tue, 08 Sep 2026
 08:16:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cc8448ce-5426-472c-b0f4-84f9237eb50f@mail.kernel.org>
In-Reply-To: <cc8448ce-5426-472c-b0f4-84f9237eb50f@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Tue, 8 Sep 2026 17:15:48 +0200
X-Gm-Features: AcwNN1VzN1K3l585DZI8v-jNiYMuXNAsb0oPXlWHJKpv5jFQlea-DPAQjTqqLTE
Message-ID: <CANpmjNPhbJeXcWCXQB31dUmuAB1LUXPuT_bGKtSZXHNXO4kXWw@mail.gmail.com>
Subject: Re: [PATCH RFC v4] net: phy: fix suspicious RCU usage in phy_detach()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, nogikh@google.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Sept 2026 at 17:04, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> During device probe (for example, in ax88772_bind()), drivers may invoke
> phylink_connect_phy() before the net_device is registered (while
> dev->reg_state is NETREG_UNINITIALIZED) and without holding the RTNL lock.
>
> If connecting or bringing up the PHY fails inside phylink_connect_phy(),
> the error cleanup path invokes phy_detach(). In phy_detach(), dev->hwprov
> is dereferenced using rtnl_dereference(), which expects the RTNL lock to be
> held. Because the RTNL lock is not held, lockdep triggers a suspicious RCU
> usage warning:
>
> WARNING: suspicious RCU usage
> drivers/net/phy/phy_device.c:1944 suspicious rcu_dereference_protected()
> usage!
>
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6972
>  phy_detach+0x219/0x550 drivers/net/phy/phy_device.c:1944
>  phylink_connect_phy+0x1dc/0x300 drivers/net/phy/phylink.c:2251
>  ax88772_init_phy+0xe3/0x390 drivers/net/usb/asix_devices.c:714
>  ax88772_bind+0x9cb/0xe50 drivers/net/usb/asix_devices.c:925
>  usbnet_probe+0xab3/0x2ad0 drivers/net/usb/usbnet.c:1808
>  </TASK>
>
> Before a net_device is registered (dev->reg_state != NETREG_REGISTERED), it
> is not exposed to the rest of the network stack, so the probing context has
> exclusive access and holding the RTNL lock is not required. Fix this by
> using rcu_dereference_protected() in phy_detach() with a condition checking
> whether the RTNL lock is held or dev->reg_state != NETREG_REGISTERED. This
> allows safe cleanup on probe failure before device registration without
> requiring drivers to acquire the RTNL lock.
>
> Fixes: 35f7cad1743e ("net: Add the possibility to support a selected hwtstamp in netdevice")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+694b49f41098a5df4fd7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=694b49f41098a5df4fd7
> Link: https://syzkaller.appspot.com/ai_job?id=92beb335-2c44-4286-b46c-a3ab5fe10b00
> To: "Andrew Lunn" <andrew@lunn.ch>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Heiner Kallweit" <hkallweit1@gmail.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Kory Maincent" <kory.maincent@bootlin.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Russell King" <linux@armlinux.org.uk>
>
> ---
> v4:
> - Clarify in the commit description why dereferencing dev->hwprov without RTNL is safe before device registration.
>
> v3:
> - Check dev->reg_state != NETREG_REGISTERED instead of dev->reg_state == NETREG_UNINITIALIZED in phy_detach().
> https://lore.kernel.org/all/5e1c820e-982c-4c4b-ae8f-682ae1fe2da2@mail.kernel.org/T/
>
> v2:
> - Moved the fix to phy_detach() in phylib by allowing rcu_dereference_protected() when dev->reg_state is NETREG_UNINITIALIZED, instead of acquiring RTNL in asix.
> - Updated the commit subject and description to reflect the changes in phylib.
> https://lore.kernel.org/all/5a7201b1-c826-4855-9105-3caa58977bc3@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/2835933a-117e-405a-a369-86459e8c8299@mail.kernel.org/T/
> ---
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 94b2e85e0..ac09943e1 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1939,9 +1939,13 @@ void phy_detach(struct phy_device *phydev)
>                 struct hwtstamp_provider *hwprov;
>
>                 /* hwprov may technically be protected by ops lock but
> -                * not for devices with a phydev, see phy_link_topo_add_phy()
> +                * not for devices with a phydev, see phy_link_topo_add_phy().
> +                * RTNL is not held when cleaning up on probe failure before
> +                * device registration.
>                  */
> -               hwprov = rtnl_dereference(dev->hwprov);
> +               hwprov = rcu_dereference_protected(dev->hwprov,
> +                                                  lockdep_rtnl_is_held() ||
> +                                                  dev->reg_state != NETREG_REGISTERED);

This should use READ_ONCE() or use the helper dev_isalive() if that is
returning the appropriate boolean. The helper dev_isalive() also has
some commentary regarding locking requirements.

>                 /* Disable timestamp if it is the one selected */
>                 if (hwprov && hwprov->phydev == phydev) {
>                         rcu_assign_pointer(dev->hwprov, NULL);
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/cc8448ce-5426-472c-b0f4-84f9237eb50f%40mail.kernel.org.
