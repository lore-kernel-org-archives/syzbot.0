Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE68449B2C;
	Mon, 14 Sep 2026 12:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789389745; cv=none; b=kqXEtFbj22LRAiKo0Gd54BUgD6a02iDBKRqxha4fWwofy3Vn3kjhTgVFqa5nukOhi4es7l8JPiM1BCEcVbA1afn4nIpTAWTlhmmYpLGZkV49IzPKSKnqBAlsO8KkR4aD/a5x5pckr+pKiJUD2V1b4rZ40iLfzz7/q7zxvMEaG90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789389745; c=relaxed/simple;
	bh=Kl4J1LlHokHPmWNl2gD976+s1iNSJ2iDVAA1R1NbBbE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=sAXJ+qC9cgUj/CLWatA0UdPccW4WQbR2xnhmNw3nA9jLsBBWkZUCdRx/h/G7qhL0psTf9pq6f3S4H02kEjtDlbKZ+i9dQVZOqCcVgP+eDfZrOK+yrc8JFXa8M7MC4a/PN2AT9+Thjlgud54jJMOuEKsDJIgEURnRj9/Kk0ddCig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsdR69Ps; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsdR69Ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BC71F000FF;
	Mon, 14 Sep 2026 12:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789389743;
	bh=ypyUzSZkWrNtmg8Vt9l1GzbP1/+6reR552f3AabCOgE=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=MsdR69PsHQJ12ZSFmO9f6NMgIK5i3afRKHHStNWVfnCTLlTCIjiI1N1ilQ4RAo9oJ
	 liVopCXKeAp8zyv2obW5gNvi03C5sp+2O0PnVUdqjQItnMu5tfDZjvAam5XaUyN1c3
	 /UNXur9RqLcd7k94ysWaSri+uBbUE8Eg836hLG1o9iJJYmy2jojYHRDGf+c/DAuOH5
	 SKltBeKtp+fn8maaqnGiideyn3Vu54DtkQN/CYiJj4BX2F1nKj6pPkd7Igz95imRm+
	 U+zYvLW+UoFcKpk0gKKlvAXqtnD+55/8jyPqkwcMVb6ZguZk7W/GkeTLyAPl568nWl
	 fnIJTxboPCo2A==
Date: Mon, 14 Sep 2026 14:42:20 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: Slawomir Stepien <sst@poczta.fm>
cc: syzkaller-bugs@googlegroups.com, 
    Basavaraj Natikar <Basavaraj.Natikar@amd.com>, bentiss@kernel.org, 
    linux-input@vger.kernel.org, sandeep.singh@amd.com, 
    linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
    syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] HID: amd_sfh: Validate PCI BAR size before mapping
In-Reply-To: <20260914095007.205287-1-sst@poczta.fm>
Message-ID: <rss2sn37-38o7-9o77-36n5-o06srs094p7q@xreary.bet>
References: <20260914095007.205287-1-sst@poczta.fm>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 14 Sep 2026, Slawomir Stepien wrote:

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
> Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
> ---
> v2:
> * Use SZ_128K for AMD_SFH_MIN_BAR_SIZE define
> * Add comment why we need 128K
> * Add 'Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>' since no logical changes
> 
> v1:
> * https://lore.kernel.org/all/94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org/

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

