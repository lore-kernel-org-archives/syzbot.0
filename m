Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A432C94A
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673957; cv=pass; b=MpWJqJlt2qOMwv47TYxFE9ZUPB36Od8iYOpNNgmlDnKoR4qpBUlp3YAYRuFLHR/iAG7UGO9oZJGIBfNN+2PF7KD4am6P1cg7V/BJIfrcw7acYNQnNf3I+chfMgxxC4OMQFdLe6Vsp0nJnb3O3niSzjuqC8s0QJwWdYKidql79Yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673957; c=relaxed/simple;
	bh=kVogqUFwtjLSa4c45TsHXSyyWh/R+nlCt0qi+aqLqnw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HgjMjaPYRPtNexOlrvQUrOFp+QVPDGXQjElmvhsIJ3UgWgyULuGx3F1WBUlLd677+qh5acf7gd4sgIAQgnNDfLuJJlnxFMiaweOuXMuGDrNPvKguvGI4UduHUBdsTPDFyM+CBmgl33mFTvR3r4pypgwNP5SbmIFCoufy/mAfCtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ayzMVUMn; arc=pass smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ayzMVUMn"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d6efd73032so6763885ad.0
        for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 09:05:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787673955; cv=none;
        d=google.com; s=arc-20260327;
        b=HcmwQRAlUpQd1uiImLPTXatJ4jeMc0YPDTG2Nrdd6KzJq15ytJ73EeR8+0Xdza87Xe
         3shUIkmZoLljnEeQSsYbptFM9Fkxsl9eda6rUcp5qKhDxqhypt6BMVuKIfFQTcIbrSJU
         Yhp/ThKibjKfu4751v80+2oqTEQRN4q2RhTeCUw4bX1I0eZ4Rmh8d65KLbcKmjRXDyLi
         /Rirp1wWw5kqw8rug5m8vnmCyfKxWBWJi6dI6cih62hTwReCxA8y9Aipm/CUfjVDKCft
         YVxfskwm7yZG48m4sR5VAMHYpU3yunE3iKm/v/yX4uL8Ba6PDzwh1pqDEyBCCT+5IiV8
         JYXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jVkwnJ4ts/h3JHrU3tTh7fUTnWDaQPiPepTt5b/8vig=;
        fh=i2Pt0OoFzNKs4Qjzy3w4ZPsH0mbSuI3m/n3ovv5Gt/Y=;
        b=oHiHGaIksV+nCfeIBGGYyPe/kMgaKHJQ34J/nskD/ILvqseqbvHHUQo4Cg+8V70lkN
         5OkZH2ZVXUHs3vSNYeE3IMhOHmkxS5TyXpOF7TRIibiqgbUBpRECaVm4iKRuCE50yqqd
         0iVASjzTBbOQOKs7Ybo7JLDk5L7iymQ23aHTUuVxAO0AgDNfIxaReF4D41nN7EWtPfzG
         9Nriw+it9S52V2c0gc5yUFvbRWnZvnZtVOAFQ3EGEx972R+xfYboOTPGY6aBaycMN1jJ
         2eVwbM8qV0LVtJv43c7qgC9uDCF5EulAuR0oMvCdxzKU4N7RDaDQdkds5n5bPDCVyKmi
         I7gA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787673955; x=1788278755; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jVkwnJ4ts/h3JHrU3tTh7fUTnWDaQPiPepTt5b/8vig=;
        b=ayzMVUMnTFXZd/bMLD6uAEGhwXO7kDKvivMZ1oyenuIYMaWG9Kr1GR/WXb4s2+vRLf
         0QI7/QR7MLjMjdZZHTBUooHpHNJ0qdLw9aA974RUGEieySz1XGFiN5kOyIM21HyD5EP+
         XY4mvLt/UxeR5YM0SmLls/98iTWfifYpxP81vGeu6UtvwlKvWGISEEw/2yZf9FDbFJjn
         tAgKxkgiA8k6l7Iz5ISkycazbUj/QkoleqIar+yRULnKYK/cpkz+OAjz0rI5ktMgfSv9
         hl5PSeogjNXllyPFs6srZ8J0q+4K9+TslH5F2ZXCOh5pWSeCUaYx9R5j6dOqw5wFK+2L
         4aYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787673955; x=1788278755;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jVkwnJ4ts/h3JHrU3tTh7fUTnWDaQPiPepTt5b/8vig=;
        b=HVGMv1Ftt2USBlxfSEHjrUrmQoP0WWWlS8Isq4dpgcnoNxeWe6bAAQWWKCAKHffESG
         lkNbmJYhnRvgvHE8SOosVE972RSDdV5k/pFRbPY5yfZ0KxdZTBZ4O1+sJvdQ8Y/oBJGl
         vaDPzUgWDfmqtVPrZDCvc+KQU/WyI03iH0zNIMZAku7zH6w2ZKuMlzozUEr3okrzn4s3
         Y7Upx+ariwOiuEdXIa/9Ik5WU+1Maq4ij0iouszgCyCIHYO246Y2XPHhkCmmnE9o2qAZ
         f2Lz/3YDCUUG5+kSFPo1+ZG7Vf4OZsgtVD7l8gZOm9ofXulBbmmEGY7mFYaoeyBRoj/F
         8OeQ==
X-Forwarded-Encrypted: i=1; AHgh+RqqkRfZqkLGz621aRm9YcrRSFe0DY7s8hu2avlaD0oPDOz5iSMNjkoJ0nYmKFH3q3c32DYhThw=@lists.linux.dev
X-Gm-Message-State: AFuF++k5CKf4+aeDDaAnK7Mt69F/6HF6sFy7xhjrgz3r+xfpDfWgEa7v
	NMLeBc8P7dVK/Z1XfLpe+FuE8POJYh+HiSDByfc/pOXy0mVbaC82HfZDmqBSDG6NtA96hoef9W2
	u9P5P1sdN+uWtT+VrkoccsPhor9dgv2bSvFds3jwhsKBuwh+YQobr2A==
X-Gm-Gg: AR+sD13fJBCWG+xKb+9XtCVaaSQfz8dugyDRDv+5ITIfXDs0R/kMA5ANTrnDGID0taz
	pCWx1ffmvh2btrDQRtiUSUvXMy9/O+VZKoBSPFGXiH/vB1F76JZKvMyO2LFS+Zgrm3xJ1z/RW1n
	FtVnhzEAgDLzSx/iW8CSAFEDwCYHGFDIgyX6FLBDPzvdgUi8FQm/9CnvisuFc+WpTBYfs3o7r68
	sx5KFOExB+Hu1f1wGKsJyb3eyDVKTIjOk+PzHjccaBwRsqaAG8ikxOuOea9JFR+sij9BxYa7s8w
	UKh50ZUmNzRSTE9+JAoAVRBm1gEyvf6ymUoCKLj8d+3lzHhYrbnsI+iQJ3cuVlzce+TPKiy69fK
	ZVWA1I7e2mYI=
X-Received: by 2002:a17:90b:2245:b0:38f:cfe2:fd3a with SMTP id
 98e67ed59e1d1-39645acceabmr10121844a91.15.1787673954196; Tue, 25 Aug 2026
 09:05:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <8f0f37a9-953e-4b36-8ce5-37a811dbea49@mail.kernel.org>
In-Reply-To: <8f0f37a9-953e-4b36-8ce5-37a811dbea49@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Tue, 25 Aug 2026 18:05:15 +0200
X-Gm-Features: AcwNN1UQC7MAFlDSfUFa-FVF__x3qrmqm4pwZpwQB1HP4MQ-TLDSYac_b6NGXN4
Message-ID: <CANpmjNMv7Fko9Ur1LPe-ts9-xfCog+rSNcyJ=Jf8ysfmH4gt_Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2] thunderbolt: Validate BAR 0 resource type and size
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#syz upstream

On Tue, 25 Aug 2026 at 17:50, syzbot <syzbot@kernel.org> wrote:
>
> The thunderbolt driver can crash with a page fault if it binds to an
> arbitrary PCI device (e.g., via sysfs driver_override) that has an I/O port
> BAR at index 0 instead of an MMIO BAR.
>
> The driver maps this BAR without validating its type or size. When it
> attempts to read a Thunderbolt register at a large offset, the resulting
> I/O port cookie overflows the reserved PIO space on x86. This causes the
> generic ioread32() function to misinterpret the out-of-bounds I/O port
> cookie as a valid MMIO virtual address, leading to a direct dereference of
> an unmapped physical-like address and a page fault:
>
>   BUG: unable to handle page fault for address: 00000000000556c0
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   ...
>   Call Trace:
>    <TASK>
>    nhi_probe+0xcc/0x870 drivers/thunderbolt/nhi.c:1198
>    nhi_pci_probe+0x46b/0x580 drivers/thunderbolt/pci.c:479
>    local_pci_probe drivers/pci/pci-driver.c:332 [inline]
>    pci_call_probe drivers/pci/pci-driver.c:394 [inline]
>    __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
>    pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489
>
> To fix this, add explicit validation in nhi_pci_probe() to ensure that BAR
> 0 is an MMIO resource and is large enough to contain all the NHI registers
> before attempting to map it. The NHI register space extends up to offset
> 0x39944 (REG_FW_STS), so checking for a minimum size of 0x40000 (256 KB) is
> appropriate.
>
> Fixes: 16603153666d ("thunderbolt: Add initial cactus ridge NHI support")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+97999b836ee62ddb0181@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=97999b836ee62ddb0181
> Link: https://syzkaller.appspot.com/ai_job?id=2570f821-2184-40c8-8bd7-344a30c18a13
> To: "Yehezkel Bernat" <YehezkelShB@gmail.com>
> To: "Andreas Noever" <andreas.noever@gmail.com>
> To: <linux-usb@vger.kernel.org>
> To: "Mika Westerberg" <westeri@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Define NHI_MIN_BAR_SIZE macro in nhi_regs.h instead of using a hardcoded value
>
> v1:
> https://lore.kernel.org/all/3b721f07-79ad-423c-9bd3-f945e97a1d9b@mail.kernel.org/T/
> ---
> diff --git a/drivers/thunderbolt/nhi_regs.h b/drivers/thunderbolt/nhi_regs.h
> index d6a197fab..1feb0bfb0 100644
> --- a/drivers/thunderbolt/nhi_regs.h
> +++ b/drivers/thunderbolt/nhi_regs.h
> @@ -140,6 +140,9 @@ struct ring_desc {
>  #define REG_FW_STS_ICM_EN_INVERT       BIT(1)
>  #define REG_FW_STS_ICM_EN              BIT(0)
>
> +/* Minimum BAR size to contain NHI registers */
> +#define NHI_MIN_BAR_SIZE               0x40000
> +
>  /* ICL NHI VSEC registers */
>
>  /* FW ready */
> diff --git a/drivers/thunderbolt/pci.c b/drivers/thunderbolt/pci.c
> index bbd186c29..fa69e4609 100644
> --- a/drivers/thunderbolt/pci.c
> +++ b/drivers/thunderbolt/pci.c
> @@ -466,6 +466,14 @@ static int nhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>         nhi->dev = dev;
>         nhi->ops = (const struct tb_nhi_ops *)id->driver_data ?: &pci_nhi_default_ops;
>
> +       /* Ensure BAR 0 is an MMIO resource */
> +       if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM))
> +               return dev_err_probe(dev, -EINVAL, "BAR 0 is not an MMIO resource\n");
> +
> +       /* Ensure BAR 0 is large enough to contain the NHI registers */
> +       if (pci_resource_len(pdev, 0) < NHI_MIN_BAR_SIZE)
> +               return dev_err_probe(dev, -EINVAL, "BAR 0 is too small\n");
> +
>         nhi->iobase = pcim_iomap_region(pdev, 0, "thunderbolt");
>         res = PTR_ERR_OR_ZERO(nhi->iobase);
>         if (res)
>
>
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
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
