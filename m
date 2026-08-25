Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F49F3D5660
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 07:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643874; cv=none; b=QYqH0p1zJpHaFAPNbazD21ppuqO5yTn7BNdB9RAoVFR8hzov7/239un/rsVcCP9laCAhtoY010tHIcJFpFjjb8VBXmhUQhKK4ImzdnaKEG+1PiIMFtgNxb8XYrLEMRSwQ+gr0nFO6rbggMytTmSuCmTbslp20AlxwuaW3LV7cKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643874; c=relaxed/simple;
	bh=kswXbqvtM3fkfsSoyk71ibp4arhcbKszcGf6feY3EOw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nMBzoX9dHfhwOWCF2n8xPb1Axn09ZGtgU4BwRXxMjGyxyqjFmtIObpao8/wmSTqs1+0uTgV6o2cK2DFDf2EjQabchcUMY68pUN0OmJuVGfjJxN00ATr91XBmzC/i+vnRlewdTa0QehrZfavcXqR0QUknpzTbssTdDyng+sLzSjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGCjHLS3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGCjHLS3"
Received: by smtp.kernel.org (Postfix)
	id 4B8A61F00A3D; Tue, 25 Aug 2026 07:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4511F00A3A;
	Tue, 25 Aug 2026 07:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787643872;
	bh=1v15wX3K1rpZQVjcJAbATDns+WOWdbJyJzab9bw32gk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lGCjHLS3mfKXhp5ITzNBdFYEXsFT1wSsIz6JAKmkSBpZPVqbih+FV7wdEirEguMGN
	 iHvqN96NBCmubmnyFYWyYaj2Zqwo/xv3FgoIO4fQoV5ifaGx74rRLYRe2q66d1iQ+G
	 XRyIhtKukOJ6lo/ZwVcQ+V5rEOWxspmR+ZNO/kLAA0QtQB+jHU3CH2oaDO291IlYw6
	 3DHmvZEKLHIlAKYjt05X09nBcqB6gUR7HwowupOBijPJBR/Oz9Srlgumf2zwKDgydG
	 GdCobiVNHFuhkIAUHSP8bBHx4ytLjkusfoKyJTSjG5j/pxom4wqKXDJBZDiAgSH4Rb
	 LIhy8TGDj6byA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] drm/cirrus-qemu: Validate BAR0 size during probe
Reply-To: sashiko-reviews@lists.linux.dev
To: syzbot <syzbot@kernel.org>
Cc: dri-devel@lists.freedesktop.org
In-Reply-To: <b11f8965-5896-4119-98b7-6bd0eb9fa139@mail.kernel.org>
References: <b11f8965-5896-4119-98b7-6bd0eb9fa139@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 07:44:31 +0000
Message-Id: <20260825074432.0B4511F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The exact equality check for BAR0 size (`!=3D CIRRUS_VRAM_SIZE`) i=
ncorrectly rejects valid QEMU configurations with larger VRAM.
- [High] The VRAM size validation check is placed after `aperture_remove_co=
nflicting_pci_devices()`, meaning the firmware framebuffer is permanently d=
estroyed even if the driver ultimately fails to bind.
--

--- Patch [1]: [PATCH] drm/cirrus-qemu: Validate BAR0 size during probe ---
commit 75467ead62a494b6afbc057c666ab59f7e4b8915
Author: Slawomir Stepien <sst@poczta.fm>

drm/cirrus-qemu: Validate BAR0 size during probe

This commit adds a check during PCI probe to verify that the BAR0 resource
length equals CIRRUS_VRAM_SIZE. This is intended to prevent supervisor write
page faults caused by writing past the end of the mapped I/O memory when
smaller BARs are presented.

Link: https://syzkaller.appspot.com/ai_job?id=3Dba262a3a-bccf-4ad8-a1b0-583=
c55d34fd6

> diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/ci=
rrus-qemu.c
> index 075221b431d37..70c995025f508 100644
> --- a/drivers/gpu/drm/tiny/cirrus-qemu.c
> +++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
> @@ -602,6 +602,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
> =20
>  	dev =3D &cirrus->dev;
> =20
> +	if (pci_resource_len(pdev, 0) !=3D CIRRUS_VRAM_SIZE)
> +		return -ENODEV;
> +

[Severity: High]
Does this strict equality check unintentionally break valid QEMU
configurations that have more than 4 MB of VRAM?

When a VM is booted with a configuration like -device cirrus-vga,vgamem_mb=
=3D8,
the BAR0 size will be 8 MB. The check in cirrus_pci_probe() evaluates
to true (since 8 MB is not equal to 4 MB) and rejects the device by
returning -ENODEV.

Would it be safer to check if pci_resource_len(pdev, 0) < CIRRUS_VRAM_SIZE
instead of requiring an exact match?

[Severity: High]
Is it safe to place this validation check after the call to
aperture_remove_conflicting_pci_devices() earlier in cirrus_pci_probe()?

If this new size check fails (either due to a malformed device or a larger
valid VRAM size), cirrus_pci_probe() aborts with -ENODEV. However, because
aperture_remove_conflicting_pci_devices() was already executed at the start
of the probe function, the firmware framebuffers (like efifb or simplefb)
have been permanently destroyed.

Could this leave the system with a dead display output? Would it make sense
to move this PCI configuration check to the very beginning of the probe
function, before any destructive actions occur?

>  	cirrus->vram =3D devm_ioremap(&pdev->dev, pci_resource_start(pdev, 0),
>  				    pci_resource_len(pdev, 0));
>  	if (cirrus->vram =3D=3D NULL)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/b11f8965-5896-4119-=
98b7-6bd0eb9fa139@mail.kernel.org?part=3D1
