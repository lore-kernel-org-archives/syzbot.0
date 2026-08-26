Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E7E3C9888
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787735997; cv=none; b=DED6aUy4pTAE6j7pv+IAVDFBre8JNBZpiRQLhmP6HeBN+PnlW6Jvvxo/q1Pw02UOWBSLVWUzzFrM79uiO/u0lxF3Q7yVWv38mgnhQXvft36a/9GaUx5MMQubxhCoI6J6Vq2d0iRmfjRHzFuESsokIoFadDHl+3rKF+zKfK7I8Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787735997; c=relaxed/simple;
	bh=HD3RZGVUzyvrlAS+pEutL8pf4u9B3qvCfj8L8TSRr4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y3ILn4nj0RRXQqCfjsfQca+tm/g7IpOYY/oX1qSLrBiK4irRDyIugpJPFnxt0MllDyWj5dgJSnqSUcp7siapAI5B0rYjjQNwuiT72W0XYCbYS06HYMFP5ZUUQs5eomdGHS2ghC/2JrxsB/EEJimb5EQY2Q6hIAgycmZnKJIgsJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=Jx9e0UCc; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="Jx9e0UCc"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Wed, 26 Aug 2026 11:19:44 +0200 (CEST)
Date: Wed, 26 Aug 2026 11:19:41 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] HID: amd_sfh: Validate PCI BAR size before mapping
Message-ID: <ao6vrY0xVCXXjiCM@nr200>
References: <2d083f63-913d-45c5-b770-c88ee06589ba@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d083f63-913d-45c5-b770-c88ee06589ba@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1787735985; bh=uqVWHxHc/bVIcCIUF0QBfQ5wu0ONgzbBbXE250uvQOM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=Jx9e0UCcxSDg8yLxg7XMfgZGhncN4XZZWkGsMrveyTdf7R4K/twQXYHqivsc7ImF+
	 uyDsaiAjujSUA0fmftmSDOB+GVp0SoF9g26y3mTN0yGVGQoeC9GDGx+Ytnmmzx5oya
	 yblWoseudiA0DKiCF7qpLpnw+2fsPCeag9Y8zvpc=

On sie 26, 2026 08:17, syzbot wrote:
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
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=4eadd4dfe9e66522bae8
> Link: https://syzkaller.appspot.com/ai_job?id=ae80612d-4fc5-4b7a-83bb-894e0a14dc5e
> To: "Basavaraj Natikar" <basavaraj.natikar@amd.com>
> To: "Benjamin Tissoires" <bentiss@kernel.org>
> To: "Jiri Kosina" <jikos@kernel.org>
> To: <linux-input@vger.kernel.org>
> To: "Sandeep Singh" <sandeep.singh@amd.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>
> 
> ---
> v2:
> - Define AMD_SFH_MIN_BAR_SIZE macro instead of hardcoded 128 * 1024
> - Use AMD_SFH_MIN_BAR_SIZE in amd_sfh1_1_init()
> 
> v1:
> https://lore.kernel.org/all/f83daf97-4762-4a67-bac7-615b34d1b661@mail.kernel.org/T/
> ---
> diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_common.h b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> index 78f830c13..c0c324565 100644
> --- a/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> +++ b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> @@ -17,6 +17,8 @@
>  #define PCI_DEVICE_ID_AMD_MP2		0x15E4
>  #define PCI_DEVICE_ID_AMD_MP2_1_1	0x164A
>  
> +#define AMD_SFH_MIN_BAR_SIZE		(128 * 1024)
> +
>  #define AMD_C2P_MSG(regno) (0x10500 + ((regno) * 4))
>  #define AMD_P2C_MSG(regno) (0x10680 + ((regno) * 4))
>  
> diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> index 4b81cebdc..d870585a0 100644
> --- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> +++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> @@ -451,6 +451,11 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
>  	if (rc)
>  		return rc;

Can you also add check for IORESOURCE_MEM using pci_resource_flags() here? Just to be safe.

> +	if (pci_resource_len(pdev, 2) < AMD_SFH_MIN_BAR_SIZE) {
> +		dev_err(&pdev->dev, "BAR 2 is too small\n");
> +		return -EINVAL;
> +	}
> +
>  	rc = pcim_iomap_regions(pdev, BIT(2), DRIVER_NAME);
>  	if (rc)
>  		return rc;
> diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
> index b0bab2a1d..0afc596b5 100644
> --- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
> +++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
> @@ -388,12 +388,12 @@ int amd_sfh1_1_init(struct amd_mp2_dev *mp2)
>  	int rc;
>  
>  	phy_base <<= 21;
> -	if (!devm_request_mem_region(dev, phy_base, 128 * 1024, "amd_sfh")) {
> +	if (!devm_request_mem_region(dev, phy_base, AMD_SFH_MIN_BAR_SIZE, "amd_sfh")) {

Hm this isn't the BAR2, so using here AMD_SFH_MIN_BAR_SIZE is misleading. Do you agree? Maybe leave
it as it is?

>  		dev_dbg(dev, "can't reserve mmio registers\n");
>  		return -ENOMEM;
>  	}
>  
> -	mp2->vsbase = devm_ioremap(dev, phy_base, 128 * 1024);
> +	mp2->vsbase = devm_ioremap(dev, phy_base, AMD_SFH_MIN_BAR_SIZE);

ditto

>  	if (!mp2->vsbase) {
>  		dev_dbg(dev, "failed to remap vsbase\n");
>  		return -ENOMEM;
> 
> 
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58

-- 
Slawomir Stepien
