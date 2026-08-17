Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA49418345
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 12:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786970765; cv=pass; b=OwcQzeGSbaK4yS9pJoQsqD3F1M3EuAo7v+GoXUAOGhuk0vKWCZePn/TM1OAlX03H38d1M9W9dN7IgkyfEWFcsrv3Lv/5zNQ+4oP4gtdrs2rjByxaUQ2Ug3YS5QYNzeUe17kkTz7wZdfP+WInmVpls6yQoDcMT7IIBjVtu3A0UfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786970765; c=relaxed/simple;
	bh=zEo9b41GTR6Cr3dXcKrYXfXJ0Rjfa2vTYkessrBPpKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sU5UcRN+D3yZnBwTe8HkWWOc2W/N6DwoIxoVXPg/SzKSCx9fPNQhewMmqKTYhMlbBD00zHbHzeKABKHiFPXb/UoGd0MUumzsV5w10ZHXyiQhw7HN8N2kWKL68omkp5SC63fC5kzz3S7XgccgDjfxoSVxBWeQkNZW2Qho75+hOmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d6VCYSO1; arc=pass smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d6VCYSO1"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-446f87b6de1so3319837fac.3
        for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 05:46:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786970762; cv=none;
        d=google.com; s=arc-20260327;
        b=G8msouF5tTUOBA+5udy8fa3EcGrikhJyq9DwZScwNoGeHT+5kCmPzvMIkMryTvBWkS
         uqQLzdmif2prQcrtYDD7GLky+iXl4QEimaK3lJ+SWD/PKbwMW/rDL1TdP3EpWMVa1Aqf
         IV5qcvx5A8xpEfh7yl903tAihvUjenY3GzuIWDsykjnwoQ+AYfhAqZTjRWgn93Ffyo43
         duXQF4cOs8MzDysDlnhdgK7rL9MGHu1wPk6ozyUuXuXB9g+I8UxCWYZJfm9gkWzpBJEF
         bEjHwfOGRyg0eMGxL8FQ7EfAHNDCnuvuK9Kcj8mND325bbxAuPQXIYn/fFs2nGWQCpAJ
         dPqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AbPFJkXAYN10OuubkONPhjTUUrN7o/IfKyiv6SqiWVo=;
        fh=OTVQzgbppZuzWX3eq9VdFdrkfDYz5rt7Qv6HhhtvR64=;
        b=UxO7o/aCBq7fH5szEu9zvqlD4zQvYerqsaZevADtAWFdXcNYbk8irowMUctiQth2mu
         4fHjJca7JffQKw4WdfB/mWhGpydzsYAFn5D8Io1AOwHrvPSJE+324ton4c5NMJZnXj8m
         H32OV4SJbxyNYIeA+BCJVPc6aVJZud5EEvsIz+MElm5fZJuXY8E+mestX+7eXZ/9dSEn
         +LZKnhYUzcmNwHhQI285qw4/UdkBbIM068mNygU1/obKgrvcx5cG4pfRiC5GaQlieF0s
         w3SkO8eipc3TyCrWWjbKfx4N0T+7VZFXAtFq5DQs48bAw4RFLrsoKC/uChnCq+MnS/um
         c57Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786970762; x=1787575562; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AbPFJkXAYN10OuubkONPhjTUUrN7o/IfKyiv6SqiWVo=;
        b=d6VCYSO1uccUm0quAxwlAy/x2+PTLqmzAYbUj4DvOdmM769g7Etfy9OmPauMiYrZDX
         4UIX8HIwakT+HZzAUq799gZ2EGyuchsSx6ch7AaQ6H3Weft6fsFyPfc+4Lt2fkHBKu25
         OfoFG6dC9yM3QsyE3ujeZlqPUfDpUwNoe0fD4p0ez2cFKqpEDBNzGEUz03laLKFu37DL
         BbAl06tf2uGSIvnm25EWQfRNNNS+0zQ5W+EeHiVBbSzZldON/FaWgrcgJTJDNVUxzu83
         YhMox1ccNYLpce748r92MGm8Drs0PINxhvVFCqhvU0jifIlHsMDd/1su54Mt5MZsfKLl
         yeXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970762; x=1787575562;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AbPFJkXAYN10OuubkONPhjTUUrN7o/IfKyiv6SqiWVo=;
        b=XcxH+owz8PBsBYCI9qZcnYrBf96CWHUhbCPfoRKHpcdqmFcINquZwy2kGPSh4ro877
         Z7OzftAPbEENs8N+nsMcVDdqflWnxC4Ow6BerXvfAR1mJpchw02xs/MJZKqHZVr81YQp
         evAvVS/XTW4HZUHW5kFdEmoZ0K+aIui+qWEGyCG0b/85W9OEBpW4NHICjWMT5Eka+Kvl
         dqT5hcxpTo3ScvRAHodmVqxVGB4sh/0GXmEdacjlDRAG9EQLcQeNcPjxlAvwAHDW/lUO
         k2RE8UZpATVdUtbO3/yIR6E/I30GEia1kL7r65KMuIgdjcLp7IJqVYf0jq45GzMkYG5i
         8sAg==
X-Forwarded-Encrypted: i=1; AHgh+RrIGE5DriBTm2DCvqJWHbkpXjYoisLChdQQavCaEChQ1RsFPs2qVRKfuXlhIvKqo1ikT0rXjgE=@lists.linux.dev
X-Gm-Message-State: AOJu0YymAADWaNxNWmdsM8HcItovTd8y+JBsjnDyAskwcnVcNkfpU9MV
	91WZkQUmGpJOGZ/7oHoy0nMWbdbtrV8eEDhyb94ne+wfHCbOn9WS4NavBMxH9UFgcVOJSYHQuoN
	EFKYBNu4wfNcdU9a1vQBI9bdAXeNde92IDeGuNXHk
X-Gm-Gg: AR+sD138KcJ/az+0Fkix5g1RwBNvL4s+ChKuRlhzuSAv+jqs21Xz0iJX+f8AGSsYdg3
	iDtFPG3GZmp99HoJDjbOA4TsAVNI3kpOCGlqnHqneysa2xkGwgrqFPwDqJKhcWy2gY/CbRr//HP
	RdP2dnxxo7mULVV6my+SKLx4KCnCM6/xvKA6yZG7a3ZGmspw7HYuaxQSaQmrkdhdx2f9UhpKLvK
	1jIQ0c9B4rcYu19TGF0uU0HYO1IH6CfgYGmm19U/VujoIuguQEmDE5M6hI6OV0fybczUVE+mGlH
	PXMuACH05P9Dcb+35Qr5BfTu2wwRvKPXGuBzbcgz8a5fDNKoMDUvVZzMxn1hHUhn+huaIAGs902
	KcuIYznKY4MMTNiwnY+PnTOr1jHiZlJkIaJwFPh+Uk9zBDPm168Mqd0qQN9Q406+RyNP65M7kje
	TmJUj7yTe/mYw=
X-Received: by 2002:a05:6870:ac23:b0:44b:7917:7173 with SMTP id
 586e51a60fabf-45f3571617dmr42254fac.7.1786970761077; Mon, 17 Aug 2026
 05:46:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <c7465765-2009-4803-b5de-69a84efcdeb6@mail.kernel.org>
In-Reply-To: <c7465765-2009-4803-b5de-69a84efcdeb6@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 17 Aug 2026 14:45:50 +0200
X-Gm-Features: AcwNN1UwsV5Znha9fod1WosY-IYpwnqDHdcILFVJlr0KqJ04Sr7komK7Frzu9bk
Message-ID: <CANp29Y5512qBVgXN-UPp6WgDoU03j_EkV-ChG9QhUee53XCeGA@mail.gmail.com>
Subject: Re: [PATCH RFC] e1000e: reject non-PCIe devices and check reset_hw()
 return value
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2026 at 12:53=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When forcing the e1000e driver to bind to an incompatible non-PCIe device
> (such as the e1000 82540EM) via sysfs driver_override, a mismatch in
> hardware register layouts occurs. This causes the driver to blindly retry
> NVM reads and wait for a hardware response that never comes. When multipl=
e
> threads attempt this concurrently, they serialize on the device lock, and
> the cumulative wait time easily exceeds the kernel's hung task timeout,
> leading to a system crash:
>
> INFO: task syz.2.41:7507 blocked for more than 143 seconds.
> ...
> Call Trace:
>  <TASK>
>  __schedule+0x17e7/0x5630 kernel/sched/core.c:7234
>  schedule+0x164/0x2b0 kernel/sched/core.c:7326
>  __mutex_lock_common kernel/locking/mutex.c:726 [inline]
>  __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
>  device_lock include/linux/device.h:1104 [inline]
>  __device_driver_lock drivers/base/dd.c:1171 [inline]
>  device_driver_attach+0xd5/0x1d0 drivers/base/dd.c:1202
>  bind_store+0x1d0/0x220 drivers/base/bus.c:267
> ...
> NMI backtrace for cpu 1
> ...
> RIP: 0010:e1000e_poll_eerd_eewr_done
> drivers/net/ethernet/intel/e1000e/nvm.c:133 [inline]
> RIP: 0010:e1000e_read_nvm_eerd+0xdf/0x300
> drivers/net/ethernet/intel/e1000e/nvm.c:311
> ...
> Call Trace:
>  <TASK>
>  e1000_read_nvm drivers/net/ethernet/intel/e1000e/e1000.h:588 [inline]
>  e1000e_validate_nvm_checksum_generic+0xcb/0x3e0
>  drivers/net/ethernet/intel/e1000e/nvm.c:553
>  e1000_validate_nvm_checksum_82571+0x176/0x290
>  drivers/net/ethernet/intel/e1000e/82571.c:787
>  e1000_validate_nvm_checksum drivers/net/ethernet/intel/e1000e/e1000.h:57=
7
>  [inline]
>  e1000_probe+0x12f8/0x2b20 drivers/net/ethernet/intel/e1000e/netdev.c:759=
0
>  local_pci_probe drivers/pci/pci-driver.c:332 [inline]
>  pci_call_probe drivers/pci/pci-driver.c:394 [inline]
>  __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
>  pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  device_driver_attach+0xe0/0x1d0 drivers/base/dd.c:1203
>  bind_store+0x1d0/0x220 drivers/base/bus.c:267
>
> Fix this by adding an early sanity check in e1000_probe() to reject
> non-PCIe devices using pci_is_pcie(). Additionally, check the return valu=
e
> of adapter->hw.mac.ops.reset_hw() and abort the probe with -EIO if it
> fails. This prevents the driver from proceeding to the NVM checksum
> validation loop, which is responsible for the massive delay.
>
> Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently f=
or ICH9 devices only)")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+8ce4dba751e79facdc38@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D8ce4dba751e79facdc38
> Link: https://syzkaller.appspot.com/ai_job?id=3Dbf813674-8b64-4b49-ac67-9=
2a88e64885d
> To: "Andrew Lunn" <andrew+netdev@lunn.ch>
> To: "Tony Nguyen" <anthony.l.nguyen@intel.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: <intel-wired-lan@lists.osuosl.org>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Przemek Kitszel" <przemyslaw.kitszel@intel.com>
> To: "Auke Kok" <auke-jan.h.kok@intel.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/eth=
ernet/intel/e1000e/netdev.c
> index 844f31ab3..6d087a414 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -7393,6 +7393,9 @@ static int e1000_probe(struct pci_dev *pdev, const =
struct pci_device_id *ent)
>         int bars, i, err;
>         s32 ret_val =3D 0;
>
> +       if (!pci_is_pcie(pdev))
> +               return -ENODEV;

Is it really correct to enforce it must only be a pci device here?

> +
>         if (ei->flags2 & FLAG2_DISABLE_ASPM_L0S)
>                 aspm_disable_flag =3D PCIE_LINK_STATE_L0S;
>         if (ei->flags2 & FLAG2_DISABLE_ASPM_L1)
> @@ -7581,7 +7584,12 @@ static int e1000_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
>         /* before reading the NVM, reset the controller to
>          * put the device in a known good starting state
>          */
> -       adapter->hw.mac.ops.reset_hw(&adapter->hw);
> +       err =3D adapter->hw.mac.ops.reset_hw(&adapter->hw);
> +       if (err) {
> +               dev_err(&pdev->dev, "Hardware Error\n");
> +               err =3D -EIO;
> +               goto err_hw_init;
> +       }

Can we return an actual error here?

>
>         /* systems with ASPM and others may see the checksum fail on the =
first
>          * attempt. Let's give it a few tries
>
>
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
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
-upstream-moderation/c7465765-2009-4803-b5de-69a84efcdeb6%40mail.kernel.org=
.
