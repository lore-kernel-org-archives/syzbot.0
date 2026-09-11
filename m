Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB35384CC4;
	Fri, 11 Sep 2026 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138274; cv=none; b=ciZpM+6H1NcDNFPKd6YZbNpCVatY30aIPF6fXQFk1FOzd/47dVIPKNfF5PfpgDJrahQbizfMs7S+I4Wu/gp7Vj37bfrg0/46LQ0TGy13zft/qii4C44u+hpYss6NBfM7AxflC9CjH5E4ONy/aLebe7Jf8inYMZ3WqH2U+oTA9vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138274; c=relaxed/simple;
	bh=7LMRweeILDSHzT25PGcExpHA7cHGgyL4pkca/4lRCF0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TV5SWv3vvc6rBW1HspqwVwSHcGgFKyZ/Wki48jE+lzLmaX5m77fDLgdQBLBg9l5RfkJqrALLigN+Fq/ClX1OLXzAJQV2W5jZG24naNCM68oxR25CVs083wmPamwlwMYbeKBh4/4w1/Bb5DU1QWoZ2JDn0yHuVkYLp6XwUKe6Z4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B+4WhgNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B+4WhgNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6571F000FF;
	Fri, 11 Sep 2026 14:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138270;
	bh=+ZV6YNue20TnIjTpwuwmCKzHqMlJIZt+sj+pIvAVlmM=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=B+4WhgNhc/4iBsmFs/bl4lC5x8EVnEpW8EFo7GszeK0xB3vt/ULe99Ps90dhPsQ+3
	 w3iyOzW1NpwtSiNUW69q0v0ogRz+xuACTf5KYsnlVfniOjr+kt6301qV+KW5dQO489
	 yaGzZO4G4kK+uFv5IVfWFJlK4JSQVvHSXqAwdm/56ZzYlTWUk9Lqmn6qNfcuDr/b8c
	 VRrrOgg+UGqMmpt0dF5yoIVxE06vsP84nTS1tg/9GLh0sG+rLXZTKLAIqdnp5XZipo
	 Hdk3C3reckHvzp8SmL5p8c0gDYD9BtTDugRjs4VXSgTjDjU9YlUQVyurx/pUAu0tTD
	 oyHT+DuSruOOg==
Date: Fri, 11 Sep 2026 16:51:08 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: syzbot <syzbot@kernel.org>
cc: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>, 
    Basavaraj Natikar <basavaraj.natikar@amd.com>, 
    Benjamin Tissoires <bentiss@kernel.org>, linux-input@vger.kernel.org, 
    Sandeep Singh <sandeep.singh@amd.com>, linux-kernel@vger.kernel.org, 
    syzbot@lists.linux.dev
Subject: Re: [PATCH] HID: amd_sfh: Validate PCI BAR size before mapping
In-Reply-To: <94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org>
Message-ID: <nqs64qn0-3723-8rq0-p3r8-oo7p5rn97480@xreary.bet>
References: <94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 27 Aug 2026, syzbot wrote:

> From: Slawomir Stepien <sst@poczta.fm>
> 
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
> Signed-off-by: Slawomir Stepien <sst@poczta.fm>

Basavaraj, can you please review this one as well?

Thanks.

> 
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
> -- 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> The person who has signed off on the patch is responsible for
> addressing comments.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 

-- 
Jiri Kosina
SUSE Labs

