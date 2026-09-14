Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B85034750B
	for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 06:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789368061; cv=none; b=sGLx4xHYGE7MP/KYbc8vwZCCmZElMow9fsbKJSycU37WfzlM9fFERt33kro6HPOJ7xAHFDEW2HUakgR20zahDc1hwtoGRjGUjtApQEeK7dPlFUTZZ25CNcJYWCjwx5lL8QstOsKcdDzv7f8a6jPzAK3S52t37X/6ht3VDV2zNW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789368061; c=relaxed/simple;
	bh=QO7dVWJRLZKDWl34KsraszC5WM8oAwV+eN5oExcOgIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+Wh4J4gMjyKf05XjZqCc4Fwht9oDFLYbg6pTsmVkh9FBzXiXdPhq+2arpkfozO2X41E5PCaEewxQDjekq9UawXQ0bfZPf/bPipZ2kqSThmKRUWeMyG6PDS9UY/hqBKbN/ctUoBBrtud2+jRZnt9XzFy5+KW+N+u9nIzmukhs84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=rDOyyIj6; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="rDOyyIj6"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 14 Sep 2026 08:40:45 +0200 (CEST)
Date: Mon, 14 Sep 2026 08:40:42 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Basavaraj Natikar <bnatikar@amd.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	Basavaraj Natikar <basavaraj.natikar@amd.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, linux-input@vger.kernel.org,
	Sandeep Singh <sandeep.singh@amd.com>, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] HID: amd_sfh: Validate PCI BAR size before mapping
Message-ID: <aqeW6o0kFhxTaloK@nr200>
References: <94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org>
 <7f8690bc-17c7-45e7-bacd-a341b2ef0a4b@amd.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f8690bc-17c7-45e7-bacd-a341b2ef0a4b@amd.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789368047; bh=35Na2uDYoTkrNh01Rjn3p8QVuDGTu1Bb9xs9LnADGw8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=rDOyyIj6aTEe/GmaUS69QFeQXd+EWa2i7Izyyemz+sGAYy7KNqoyYiR5PC6iI1DKJ
	 /rHPq6Liim32PymGFsviz84lD8MGPRBBqZHTMltuAVFJ+FiaYrvdItet0TPEy+Nvqm
	 FB73zZPNYyNHbjc1hSVOpBuqrswDqDK+tM2OWFD8=

On wrz 11, 2026 21:33, Basavaraj Natikar wrote:
> 
> On 8/27/2026 12:06 PM, syzbot wrote:
> > [You don't often get email from syzbot@kernel.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > 
> > From: Slawomir Stepien <sst@poczta.fm>
> > 
> > The amd_sfh driver maps PCI BAR 2 using pcim_iomap_regions() and
> > subsequently accesses MMIO registers at offsets up to 0x10958 (e.g.,
> > AMD_P2C_MSG3 at 0x1068C). However, the driver never validates that the BAR
> > size is large enough to cover these accesses. If the driver is bound to a
> > device with a smaller BAR 2, this leads to an out-of-bounds memory access
> > and a page fault during the probe function.
> > 
> > For example, a page fault can occur when reading from privdata->mmio +
> > AMD_P2C_MSG3 in mp2_select_ops():
> > 
> >    BUG: unable to handle page fault for address: ffffc9000390368c
> >    PGD 100000067 P4D 100000067 PUD 1012c1067 PMD 105b64067 PTE 0
> >    Oops: Oops: 0000 [#1] SMP KASAN NOPTI
> >    RIP: 0010:readl arch/x86/include/asm/io.h:59 [inline]
> >    RIP: 0010:mp2_select_ops drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:282
> >    [inline]
> >    RIP: 0010:amd_mp2_pci_probe+0x337/0x5f0
> >    drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:487
> >    Call Trace:
> >     <TASK>
> >     local_pci_probe drivers/pci/pci-driver.c:332 [inline]
> >     pci_call_probe drivers/pci/pci-driver.c:394 [inline]
> >     __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
> >     pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489
> > 
> > Fix this by verifying that the length of BAR 2 is at least 128KB before
> > attempting to map it. Since the maximum accessed offset is 0x10958, and PCI
> > BAR sizes are powers of 2, any legitimate hardware will have a BAR size of
> > at least 128KB.
> > 
> > Fixes: 4f567b9f8141 ("SFH: PCIe driver to add support of AMD sensor fusion hub")
> > Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> > Reported-by: syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=4eadd4dfe9e66522bae8
> > Link: https://syzkaller.appspot.com/ai_job?id=3bc1c45c-548f-4ab5-8243-d2c8ec321d6c
> > Signed-off-by: Slawomir Stepien <sst@poczta.fm>
> > 
> > ---
> > diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_common.h b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> > index 78f830c13..c0c324565 100644
> > --- a/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> > +++ b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> > @@ -17,6 +17,8 @@
> >   #define PCI_DEVICE_ID_AMD_MP2          0x15E4
> >   #define PCI_DEVICE_ID_AMD_MP2_1_1      0x164A
> > 
> > +#define AMD_SFH_MIN_BAR_SIZE           (128 * 1024)
> 
> Please use SZ_128K instead of the open-coded (128 * 1024), A short comment noting the value
> must cover the highest register offset (0x10958) would also help future readers.
> 
> With that:
> Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

Sure, will send v2, thanks!

-- 
Slawomir Stepien
