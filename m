Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD7B22CBE6
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 06:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787812530; cv=none; b=pYumKeMhTWmeAr7mSfa/whP+xM8OAqyHa2CqzLKVN1aVB8JecfV2CWDMns5+DAeBBkEXRy9YNNsl6Rb5KdeG9hcQm5HaJdDsV4JtBJnOKFwaWAjgXQnAOuQRZ7A1cFvZdENr15oud02HFU9rsz/VS+AB9eOAnWruMxkClLb7tPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787812530; c=relaxed/simple;
	bh=64+EAApCG9OlWIgzQ8vGjp02wRoizxDXu5EaklukJzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSv1xa91VpqZYrRvl2NZcG5wp4stKqAIdVWGLHpdtHV1Q6941M+BGphhxJOlU18sNaETcgjX15VoKyGVaqm3aIW/x7h29U//zm7Xt0uGTanbTniheA27cYeedkSbSyDAv960Kie04SYXW4bfalzXyrMdED23ThD9EL3r9dNjaNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=sxdjCtUK; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="sxdjCtUK"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 27 Aug 2026 08:35:22 +0200 (CEST)
Date: Thu, 27 Aug 2026 08:35:19 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] HID: amd_sfh: Validate PCI BAR size before mapping
Message-ID: <ao_apyAjwGIHE-p9@nr200>
References: <ff58a23d-f6e2-4b2d-b374-06f7d0f1b264@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff58a23d-f6e2-4b2d-b374-06f7d0f1b264@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1787812523; bh=mB6IR3iMYDeqXciJKypX0SNWTuU2c7K/WZT81jRpzN4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=sxdjCtUKNOi7h3S0CFf2u0D4qBu87CnQPjNfTMZOIWh9jkIksgHKqicbNGyznhT55
	 9bPMhjRnP5nF1SanD1WeU2MRe01zjpQrseqyCAatQqDJj9qadzSx4yxj483Bum0fIm
	 NrqRA/wsh9Q/MAk60YT3419oztv/nFnRWE54fJpA=

#syz upstream

On sie 26, 2026 09:54, syzbot wrote:
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
> Link: https://syzkaller.appspot.com/ai_job?id=3bc1c45c-548f-4ab5-8243-d2c8ec321d6c
> To: "Basavaraj Natikar" <basavaraj.natikar@amd.com>
> To: "Benjamin Tissoires" <bentiss@kernel.org>
> To: "Jiri Kosina" <jikos@kernel.org>
> To: <linux-input@vger.kernel.org>
> To: "Sandeep Singh" <sandeep.singh@amd.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v3:
> - Check that BAR 2 is an MMIO resource (IORESOURCE_MEM).
> - Drop unrelated changes in sfh1_1/amd_sfh_init.c.
> 
> v2:
> - Define AMD_SFH_MIN_BAR_SIZE macro instead of hardcoded 128 * 1024
> - Use AMD_SFH_MIN_BAR_SIZE in amd_sfh1_1_init()
> https://lore.kernel.org/all/2d083f63-913d-45c5-b770-c88ee06589ba@mail.kernel.org/T/
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
> index 4b81cebdc..039b6ac32 100644
> --- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> +++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> @@ -451,6 +451,16 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
>  	if (rc)
>  		return rc;
>  
> +	if (!(pci_resource_flags(pdev, 2) & IORESOURCE_MEM)) {
> +		dev_err(&pdev->dev, "BAR 2 is not IORESOURCE_MEM\n");
> +		return -ENODEV;
> +	}
> +
> +	if (pci_resource_len(pdev, 2) < AMD_SFH_MIN_BAR_SIZE) {
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
