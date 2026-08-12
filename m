Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D38336EC5
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 13:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786540791; cv=none; b=AAeEggvIPJ6xW5Xi5KOQtnRxaFl4PbN4zXKLOnSONEr3z8J+IS4rXb+dVhaHpjm0JT/aEd/EXsTUHFCs5ZRrxENPNmEjRyaG9gX6akzFB7w1N06Uz2U6JeWsL+oyD3WyjPpkmvjPG+JrK+AyzJtd+ETh07niORXWh7BPTuR338Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786540791; c=relaxed/simple;
	bh=lxeoBx4xKjOaX3ydO8+DEN5sNcrLrOSJNJ/pe7Cjk/A=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=bNQKFO4qtSgFpdC9MRjPvvfB6ikaZUwJwdljED3tM0BKn85wJf5RS0fEgy9l7JB04Gx2xXA+fuI2vN7Xz1nb4GSNbV2Vb1C6/MPrsKauw89YBUyjgbrhvj/zMzCfNJJqw2pmgM+GsbWh+DqPdeQB0R1hOaWBNA5VsY5w2zfPqvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAdEOWts; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAdEOWts"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D8D31F000E9;
	Wed, 12 Aug 2026 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786540789;
	bh=O1hVvqUhAH6hTJtyb+60JHQvWG7/S+48x2aywEcmLTc=;
	h=From:To:Cc:Subject:Date;
	b=lAdEOWtsaryUUyrRy98bUSWPSZ0FTKtrcW3WRZIs04PZhdBR1vrAVPxyO4biFJVMb
	 IBQRCZqHIbtC51rzsBq2SmIXEsh5C0UL3+Um9bMDE3Zq9mjNgB8FNHA4V+ANuS4NJ0
	 jC9iJHsGeED9FKhY8iqG3wJqVqrIIjyb7b3brmxbEjVGyEfLHcrUCyFud4d1oolAHg
	 8rU1AMYQKu4Qc2y3Cp+qFY7Wk/0BOaMwBaBmvj1FyGccHDrQOUwMg8zCOwWFrzhjCt
	 wJ9mAv7m06CVoOizVV5baWXaj/QAKDBb8uLXySnaekneIHiGZ220ymOO8Pmtd0GorI
	 dB9pVSSd91sNA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ALSA: Validate MMIO BARs before mapping
Message-ID: <ceeaac79-e6f5-4a49-b72f-c3fda07d5d7c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 12 Aug 2026 13:19:49 +0000 (UTC)

The `snd_hda_intel` driver assumes PCI BAR 0 is a memory-mapped I/O (MMIO)
region, but it fails to verify this assumption before mapping and accessing
it. If a device with an I/O Port BAR at BAR 0 is bound to the driver (e.g.,
via the `new_id` sysfs interface), `pcim_iomap_region()` successfully maps
it and returns an I/O port cookie. The driver then attempts to read from
this address using MMIO accessors like `readw()`, which directly
dereferences the pointer. On x86, this results in a supervisor read access
page fault:

BUG: unable to handle page fault for address: 000000000001c094
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
RIP: 0010:readw arch/x86/include/asm/io.h:58 [inline]
RIP: 0010:snd_hdac_reg_readw include/sound/hdaudio.h:458 [inline]
RIP: 0010:snd_hdac_bus_parse_capabilities+0x47/0x750
sound/hda/core/controller.c:412
Call Trace:
 azx_first_init sound/hda/controllers/intel.c:1936 [inline]
 azx_probe_continue sound/hda/controllers/intel.c:2365 [inline]
 azx_probe_work+0x85e/0x2860 sound/hda/controllers/intel.c:1737

To fix this issue, verify that the BAR is an MMIO region using
`pci_resource_is_mem()` before attempting to map it. If the BAR is not an
MMIO region, log an error and abort the probe process with `-ENXIO`.

A subsystem-wide audit revealed that several other ALSA PCI drivers use
`pcim_iomap_region()` and subsequently use MMIO accessors on the returned
pointer without validating the resource type. To ensure comprehensive
protection, apply the same validation pattern to all vulnerable ALSA PCI
drivers, including `snd_ad1889`, `snd_atiixp`, `snd_atiixp_modem`,
`snd_au88x0`, `snd_aw2`, `snd_bt87x`, `snd_cs4281`, `snd_cs5530`,
`snd_lola`, `snd_hdspm`, and `loongson_i2s_pci`.

Fixes: 3fcaf24e5dce ("ALSA: hda: Allocate resources with device-managed APIs")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=10cd2d1efe8eeb604bee
Link: https://syzkaller.appspot.com/ai_job?id=dd4258ea-3be3-4977-b597-0fc0910b0f51
To: "Mark Brown" <broonie@kernel.org>
To: "Clemens Ladisch" <clemens@ladisch.de>
To: "Liam Girdwood" <lgirdwood@gmail.com>
To: <linux-parisc@vger.kernel.org>
To: <linux-sound@vger.kernel.org>
To: "Jaroslav Kysela" <perex@perex.cz>
To: "Takashi Iwai" <tiwai@suse.com>
To: "Binbin Zhou" <zhoubinbin@loongson.cn>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "Chandra Mohan Sundar" <chandramohan.explore@gmail.com>
Cc: "Kai Vehmanen" <kai.vehmanen@linux.intel.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Peter Ujfalusi" <peter.ujfalusi@linux.intel.com>
Cc: "Philipp Stanner" <phasta@kernel.org>
Cc: "Thomas Gleixner" <tglx@kernel.org>
Cc: =?utf-8?b?VXdlIEtsZWluZS1Lw7ZuaWcgKFRoZSBDYXBhYmxlIEh1Yik=?= <u.kleine-koenig@baylibre.com>
Cc: "Haotian Zhang" <vulab@iscas.ac.cn>

---
diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 28c55c5a2..22c2b5b42 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -1926,6 +1926,11 @@ static int azx_first_init(struct azx *chip)
 	if (chip->driver_type == AZX_DRIVER_ZHAOXINHDMI)
 		bus->polling_mode = 1;
 
+	if (!pci_resource_is_mem(pci, 0)) {
+		dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	bus->remap_addr = pcim_iomap_region(pci, 0, "ICH HD audio");
 	if (IS_ERR(bus->remap_addr))
 		return PTR_ERR(bus->remap_addr);
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index f4ec404c0..4f208f962 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -803,6 +803,11 @@ snd_ad1889_create(struct snd_card *card, struct pci_dev *pci)
 	chip->pci = pci;
 	chip->irq = -1;
 
+	if (!pci_resource_is_mem(pci, 0)) {
+		dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	/* (1) PCI resource allocation */
 	chip->iobase = pcim_iomap_region(pci, 0, card->driver);
 	if (IS_ERR(chip->iobase))
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index b738295b4..9b346b9b0 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1531,6 +1531,12 @@ static int snd_atiixp_init(struct snd_card *card, struct pci_dev *pci)
 	chip->card = card;
 	chip->pci = pci;
 	chip->irq = -1;
+
+	if (!pci_resource_is_mem(pci, 0)) {
+		dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	chip->remap_addr = pcim_iomap_region(pci, 0, "ATI IXP AC97");
 	if (IS_ERR(chip->remap_addr))
 		return PTR_ERR(chip->remap_addr);
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 8aaeb197c..32a80297a 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1163,6 +1163,12 @@ static int snd_atiixp_init(struct snd_card *card, struct pci_dev *pci)
 	chip->card = card;
 	chip->pci = pci;
 	chip->irq = -1;
+
+	if (!pci_resource_is_mem(pci, 0)) {
+		dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	chip->remap_addr = pcim_iomap_region(pci, 0, "ATI IXP MC97");
 	if (IS_ERR(chip->remap_addr))
 		return PTR_ERR(chip->remap_addr);
diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index bb0294579..9b2c9361a 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -157,6 +157,11 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci)
 	chip->card = card;
 	chip->irq = -1;
 
+	if (!pci_resource_is_mem(pci, 0)) {
+		dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	// (1) PCI resource allocation
 	// Get MMIO area
 	//
diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
index 60a87322e..c9c7129e4 100644
--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -223,6 +223,11 @@ static int snd_aw2_create(struct snd_card *card,
 	chip->pci = pci;
 	chip->irq = -1;
 
+	if (!pci_resource_is_mem(pci, 0)) {
+		dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	/* (1) PCI resource allocation */
 	chip->iobase_virt = pcim_iomap_region(pci, 0, "Audiowerk2");
 	if (IS_ERR(chip->iobase_virt))
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 383def1f2..e71fe10ce 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -690,6 +690,11 @@ static int snd_bt87x_create(struct snd_card *card,
 	chip->irq = -1;
 	spin_lock_init(&chip->reg_lock);
 
+	if (!pci_resource_is_mem(pci, 0)) {
+		dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	chip->mmio = pcim_iomap_region(pci, 0, "Bt87x audio");
 	if (IS_ERR(chip->mmio))
 		return PTR_ERR(chip->mmio);
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index f51f4bb63..792a63d36 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1298,6 +1298,11 @@ static int snd_cs4281_create(struct snd_card *card,
 	}
 	chip->dual_codec = dual_codec;
 
+	if (!pci_resource_is_mem(pci, 0) || !pci_resource_is_mem(pci, 1)) {
+		dev_err(card->dev, "Invalid PCI BARs: not MMIO regions\n");
+		return -ENXIO;
+	}
+
 	chip->ba0 = pcim_iomap_region(pci, 0, "CS4281");
 	if (IS_ERR(chip->ba0))
 		return PTR_ERR(chip->ba0);
diff --git a/sound/pci/cs5530.c b/sound/pci/cs5530.c
index 292b65aa7..dc5e30947 100644
--- a/sound/pci/cs5530.c
+++ b/sound/pci/cs5530.c
@@ -91,6 +91,11 @@ static int snd_cs5530_create(struct snd_card *card,
 	chip->card = card;
 	chip->pci = pci;
 
+	if (!pci_resource_is_mem(pci, 0)) {
+		dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	mem = pcim_iomap_region(pci, 0, "CS5530");
 	if (IS_ERR(mem))
 		return PTR_ERR(mem);
diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
index 34a3ba17d..fdef79879 100644
--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -579,6 +579,11 @@ static int lola_create(struct snd_card *card, struct pci_dev *pci, int dev)
 		chip->sample_rate_min = 16000;
 	}
 
+	if (!pci_resource_is_mem(pci, 0) || !pci_resource_is_mem(pci, 2)) {
+		dev_err(card->dev, "Invalid PCI BARs: not MMIO regions\n");
+		return -ENXIO;
+	}
+
 	iomem = pcim_iomap_region(pci, 0, DRVNAME);
 	if (IS_ERR(iomem))
 		return PTR_ERR(iomem);
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index d8bbedbc8..344008ff7 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6456,6 +6456,11 @@ static int snd_hdspm_create(struct snd_card *card,
 	int err;
 	unsigned long io_extent;
 
+	if (!pci_resource_is_mem(pci, 0)) {
+		dev_err(card->dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	hdspm->irq = -1;
 	hdspm->card = card;
 
diff --git a/sound/soc/loongson/loongson_i2s_pci.c b/sound/soc/loongson/loongson_i2s_pci.c
index f5b560465..5e634d467 100644
--- a/sound/soc/loongson/loongson_i2s_pci.c
+++ b/sound/soc/loongson/loongson_i2s_pci.c
@@ -41,6 +41,11 @@ static int loongson_i2s_pci_probe(struct pci_dev *pdev,
 	i2s->dev = dev;
 	pci_set_drvdata(pdev, i2s);
 
+	if (!pci_resource_is_mem(pdev, 0)) {
+		dev_err(dev, "Invalid PCI BAR 0: not an MMIO region\n");
+		return -ENXIO;
+	}
+
 	i2s->reg_base = pcim_iomap_region(pdev, 0, DRIVER_NAME);
 	if (IS_ERR(i2s->reg_base)) {
 		dev_err(dev, "iomap_region failed\n");


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
