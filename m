Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FE41DD0EF
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 06:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787726340; cv=none; b=RIGEHn9stmtDro2ZhyUHhXrXZZEEb3vfvRMG/kShzwHnzEue6eJqLRFl8aGyABCLUNxzUtkICU+puN7QdWKCxM9MPLUzAae6yKw28wqstxbDyG6tw+CFUIu846ZV0tOlgVeGJ94h+dr3WuZTV3zGVflI2mYqOpWC1keOPCnoD3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787726340; c=relaxed/simple;
	bh=KXmKL8KJ+ycCnq/XMq3Uum6Poztcc258idf2uxMQ/0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Si7iumughkYAcJF8fxecYZ23wELukdS0gvNa6rzAm1jZSRZSGOdGUdaXTVslRFY2QlEaJWZvdUsX2pLi5k3w+z9mYPuEe1GzneLekrIOyFwZPTyo+X4Un5RQURAK1tAyyPe6StpWDvoYjCiPI8mpFM4GlwE86UcWPE5yTKxaGRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=H1bsou50; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="H1bsou50"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Wed, 26 Aug 2026 08:38:51 +0200 (CEST)
Date: Wed, 26 Aug 2026 08:38:50 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] HID: amd_sfh: Validate PCI BAR size before mapping
Message-ID: <ao6J-ny1hTVozayZ@nr200>
References: <f83daf97-4762-4a67-bac7-615b34d1b661@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f83daf97-4762-4a67-bac7-615b34d1b661@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1787726332; bh=JO+WoPSuAqo24O08LwH4q8QMXVBhfgSHMD5N0uX/8MQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=H1bsou50f3FkhfUDp0A/q6M/MYefGy12spXySlihwYm48W/n7eFrUEXgl/2VVqNEe
	 DnNvAVjLXPpMRhCI5YtSZtg6TWBMjVSp7YTV1kdqy+bVPS+CaVHyphGiVkmcgQahNU
	 9uzsqhkdch+9ogco6RJ/Xx64AAWHFrPX80hfwXv0=

On sie 13, 2026 20:44, 'syzbot' via syzkaller-upstream-moderation wrote:
> The amd_sfh driver maps PCI BAR 2 using pcim_iomap_regions() and
> subsequently accesses MMIO registers at offsets up to 0x10958 (e.g.,
> AMD_P2C_MSG3 at 0x1068C). However, the driver never validates that the BAR
> size is large enough to cover these accesses. If the driver is bound to a
> device with a smaller BAR 2, this leads to an out-of-bounds memory access
> and a page fault during the probe function.
> 
> For example, a page fault can occur when reading from privdata->mmio +
> AMD_P2C_MSG3 in mp2_select_ops():
> 
>   BUG: unable to handle page fault for address: ffffc9000390368c
>   PGD 100000067 P4D 100000067 PUD 1012c1067 PMD 105b64067 PTE 0
>   Oops: Oops: 0000 [#1] SMP KASAN NOPTI
>   RIP: 0010:readl arch/x86/include/asm/io.h:59 [inline]
>   RIP: 0010:mp2_select_ops drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:282
>   [inline]
>   RIP: 0010:amd_mp2_pci_probe+0x337/0x5f0
>   drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:487
>   Call Trace:
>    <TASK>
>    local_pci_probe drivers/pci/pci-driver.c:332 [inline]
>    pci_call_probe drivers/pci/pci-driver.c:394 [inline]
>    __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
>    pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489
> 
> Fix this by verifying that the length of BAR 2 is at least 128KB before
> attempting to map it. Since the maximum accessed offset is 0x10958, and PCI
> BAR sizes are powers of 2, any legitimate hardware will have a BAR size of
> at least 128KB.
> 
> Fixes: 4f567b9f8141 ("SFH: PCIe driver to add support of AMD sensor fusion hub")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4eadd4dfe9e66522bae8
> Link: https://syzkaller.appspot.com/ai_job?id=7a94b74c-2359-4cbe-b08b-2c52f3bf9755
> To: "Basavaraj Natikar" <basavaraj.natikar@amd.com>
> To: "Benjamin Tissoires" <bentiss@kernel.org>
> To: "Jiri Kosina" <jikos@kernel.org>
> To: <linux-input@vger.kernel.org>
> To: "Sandeep Singh" <sandeep.singh@amd.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> index 4b81cebdc..c1dbee87c 100644
> --- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> +++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> @@ -451,6 +451,11 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
>  	if (rc)
>  		return rc;
>  
> +	if (pci_resource_len(pdev, 2) < 128 * 1024) {

Put this 128 * 1024 as some nice #define.

> +		dev_err(&pdev->dev, "BAR 2 is too small\n");
> +		return -EINVAL;
> +	}
> +
>  	rc = pcim_iomap_regions(pdev, BIT(2), DRIVER_NAME);
>  	if (rc)
>  		return rc;
> 
> 
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58

-- 
Slawomir Stepien
