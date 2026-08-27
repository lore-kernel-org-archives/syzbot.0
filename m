Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE2F2D739B
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 06:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787813118; cv=none; b=uWe7wqLyXuaKhf/9qjG/Vz+CVHValZuKKuJKnVyeFTQAO5BuSIpz0PeCmqyQc/9i+glts+iOQ8IaInlgkXxSVoGn8XP/cua8fNiFo07Re4nLASKBB14CmuXUfFKli25Qmorc79SK6956rLLIH1RPrcibmVSE2N3gbeBDGtcNbYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787813118; c=relaxed/simple;
	bh=4oGra23Ny/UY+2c2Kz9G6GViHNBsQJpRG0EsawlFQNg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NO9hc56xp4NqagnROHrSrjQVX8r3ALpoH7nClv7kCQ0C+IpWWdNGxZqJBBxYY5TaN3KPW9pXQiNs4Kqrjmol9Aht3MTPgaFBWWsVEZP3pX0Z7RSdhYbcUF9SjixFmtizWG2HTEg1GtgVhTSOJSQEDy8zmqx1B7A7+W3cm6Xs664=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sl5YTUcI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sl5YTUcI"
Received: by smtp.kernel.org (Postfix)
	id 167D01F00A3A; Thu, 27 Aug 2026 06:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF38F1F000E9;
	Thu, 27 Aug 2026 06:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787813117;
	bh=Ww7dGg4mHhqKLzqFKonpFgSlFvH+vsDGDP7QD7dnwAs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sl5YTUcIKwezHlDHuZjikuqwL5mNaogj5RCTXi3iozTMPxnxXKzC0aTj9EfsCZUGh
	 tRnw/ifJbd8GxJJRFyHbQFas7GFLo4Ahxz8fo85w6H0ZInb6vfDStYMCWqiXRW2dEE
	 1cGDa6+MJY8NCuIgoyoguTZRyDJ/sjDsjiwqgEmTFTx20NON3nxzbpMnRqbZRvA8vb
	 3pYOMWYR6vnqKjPg3MTzVdAqw0cfGTp4yfR27mvaXy9jR/4CKDFtLE9YG0Ub5eJXru
	 OfqxcU+QjLNn3EjEDPFG5BXn+WHJA80b7hECjYSOcEB362zxrFXsirsrzDu3r6SAmP
	 uex+M9NOKm0jQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] HID: amd_sfh: Validate PCI BAR size before mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: syzbot <syzbot@kernel.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
In-Reply-To: <94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org>
References: <94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 06:45:16 +0000
Message-Id: <20260827064516.BF38F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] High Severity Finding: API Usage Violation. The transport driver u=
ses hid_input_report() instead of hid_safe_input_report(), risking out-of-b=
ounds reads.
--

commit daa6f21fdcd011d62323dd6e5390e89dbb4f38d2
Author: Slawomir Stepien <sst@poczta.fm>

    HID: amd_sfh: Validate PCI BAR size before mapping

This commit adds a check to verify that PCI BAR 2 is at least 128KB before
mapping it with pcim_iomap_regions(). This prevents an out-of-bounds memory
access during the probe function if the driver is bound to a device with a
smaller BAR 2.

Link: https://syzkaller.appspot.com/bug?extid=3D4eadd4dfe9e66522bae8
Link: https://syzkaller.appspot.com/ai_job?id=3D3bc1c45c-548f-4ab5-8243-d2c=
8ec321d6c

> diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_common.h b/drivers/hid/amd-s=
fh-hid/amd_sfh_common.h
> index 78f830c133e5c..c0c324565bee4 100644
> --- a/drivers/hid/amd-sfh-hid/amd_sfh_common.h
> +++ b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
[ ... ]
> @@ -17,6 +17,8 @@
>  #define PCI_DEVICE_ID_AMD_MP2		0x15E4
>  #define PCI_DEVICE_ID_AMD_MP2_1_1	0x164A
> =20
> +#define AMD_SFH_MIN_BAR_SIZE		(128 * 1024)
> +
>  #define AMD_C2P_MSG(regno) (0x10500 + ((regno) * 4))
>  #define AMD_P2C_MSG(regno) (0x10680 + ((regno) * 4))
> =20
> diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh=
-hid/amd_sfh_pcie.c
> index 4b81cebdc3359..039b6ac327d3d 100644
> --- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
> +++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
[ ... ]
> @@ -451,6 +451,16 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, c=
onst struct pci_device_id *i
>  	if (rc)
>  		return rc;
> =20
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
>  	rc =3D pcim_iomap_regions(pdev, BIT(2), DRIVER_NAME);
>  	if (rc)
>  		return rc;

[Severity: High]
This is a pre-existing issue, but does this driver use the correct input
reporting API?

In drivers/hid/amd-sfh-hid/amd_sfh_client.c:amd_sfh_work():

	if (node_type =3D=3D HID_FEATURE_REPORT) {
		report_size =3D mp2_ops->get_feat_rep(sensor_index, report_id,
						    cli_data->feature_report[current_index]);
		if (report_size)
			hid_input_report(cli_data->hid_sensor_hubs[current_index],
					 cli_data->report_type[current_index],
					 cli_data->feature_report[current_index], report_size, 0);

And later for HID_INPUT_REPORT:

		if (report_size)
			hid_input_report(cli_data->hid_sensor_hubs[current_index],
					 cli_data->report_type[current_index],
					 in_data->input_report[current_index], report_size, 0);

Also in amd_sfh_work_buffer():

			hid_input_report(cli_data->hid_sensor_hubs[i], HID_INPUT_REPORT,
					 in_data->input_report[i], report_size, 0);

Calling hid_input_report() instead of hid_safe_input_report() in a transport
driver can lead to out-of-bounds reads in the HID core if the hardware
supplies unvalidated report sizes. Should these be changed to use
hid_safe_input_report() to provide mandatory buffer boundary checks?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/94704655-d654-4500-=
8122-b80bea9bd908@mail.kernel.org?part=3D1
