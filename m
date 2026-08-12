Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0FF46F484
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 14:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546561; cv=none; b=ldGvfgu6u8iuBHrQZGNCxH2nQlCjtokwumxvELSefjDmXlQx/uXKu4JvLjjaF5JlG4mUbhy7jpNR+zRXWaSlBhzQF4INp9W4LKvzPdLtBetk11o2YgabJxgzoc7/UOO5RbhvHqyJkMBBiKauhoQ9QBL8aUSCuy+zw8qtxYQJiHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546561; c=relaxed/simple;
	bh=lTxi9fgAf+DeTWMw3uzo5Nfi9Xo1HMJECfAiJeIXex8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=PNUFtB6RTUI37sKGRwRN0tY4L7Sx5nfxLNsQmHJWWjIoR6OvUqyP2F7ZHoNz/bz0STlzFd+6xhKFriupkkTDvOkQYaw4BOQn6VVeu5ixepypJhLTWJqwfhW2uRicGPptSM9p04CVlrYTcT1ntDgBGigDaPjFCjHaWRQO+kFtbnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TL4PpMMU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TL4PpMMU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 25E851F000E9;
	Wed, 12 Aug 2026 14:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786546550;
	bh=NUUD5Bd6rEVEnLw3O2Wm0l6/x2RsqzaR5Xb29k3kqhY=;
	h=From:To:Cc:Subject:Date;
	b=TL4PpMMUIefj+VhDdPtKigoGRVenBHmxf0Kf2mZT/mlcKklz+OOLRfuVJMNT4xh48
	 ri7udSSEfASFbA18Hzca/FLuxC1vebvN9lex7S10KSqUgaJI1VFzoh0KXsf83gfEef
	 7jJDxi81SXZ2x27JnLdjTy1VY1uNvLw4zphm/ibGZZJMZq5Z9CkYOmUj4hSlmd257H
	 J2AXogxIUUmS8PgdZS9c0uJnMxUVKr6t24KxnlE5gp94mJP2padUPO+BPJHQv9K1x7
	 PLdh5dLm1rKFvrWhMf9i8j8uBRnJSOALKFd3QfgpaeId7fLBoKYa9X9yeNwnIVI6Tl
	 1ic94uW+K6NOw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: nogikh@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] PCI: devres: Add pcim_ioremap_region() and update ALSA drivers
Message-ID: <4a23b584-9829-4091-961b-e2ca126de7b7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 12 Aug 2026 14:55:50 +0000 (UTC)

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

To fix this issue, introduce `pcim_ioremap_region()` in the PCI devres API,
which uses `pci_ioremap_bar()` to ensure that only MMIO regions are mapped.
Switch ALSA PCI drivers expecting MMIO regions to use
`pcim_ioremap_region()` instead of `pcim_iomap_region()`.

Fixes: 3fcaf24e5dce ("ALSA: hda: Allocate resources with device-managed APIs")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=10cd2d1efe8eeb604bee
Link: https://syzkaller.appspot.com/ai_job?id=4b8631e4-d809-4d13-954c-5333d467e539
To: "Bjorn Helgaas" <bhelgaas@google.com>
To: "Mark Brown" <broonie@kernel.org>
To: "Clemens Ladisch" <clemens@ladisch.de>
To: "Liam Girdwood" <lgirdwood@gmail.com>
To: <linux-parisc@vger.kernel.org>
To: <linux-pci@vger.kernel.org>
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
v2:
- Introduced pcim_ioremap_region() in PCI devres to request and map MMIO BARs specifically.
- Updated ALSA PCI drivers to use pcim_ioremap_region() instead of performing manual pci_resource_is_mem() checks.

v1:
https://lore.kernel.org/all/ceeaac79-e6f5-4a49-b72f-c3fda07d5d7c@mail.kernel.org/T/
---
diff --git a/drivers/pci/devres.c b/drivers/pci/devres.c
index f075e7881..faa678ff5 100644
--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -639,6 +639,55 @@ void __iomem *pcim_iomap_region(struct pci_dev *pdev, int bar,
 }
 EXPORT_SYMBOL(pcim_iomap_region);
 
+/**
+ * pcim_ioremap_region - Request and ioremap a PCI BAR
+ * @pdev: PCI device to map IO resources for
+ * @bar: Index of a BAR to map
+ * @name: Name of the driver requesting the resource
+ *
+ * Returns: __iomem pointer on success, an IOMEM_ERR_PTR on failure.
+ *
+ * Mapping and region will get automatically released on driver detach. If
+ * desired, release manually only with pcim_iounmap_region().
+ */
+void __iomem *pcim_ioremap_region(struct pci_dev *pdev, int bar,
+				  const char *name)
+{
+	int ret;
+	struct pcim_addr_devres *res;
+
+	if (!pci_bar_index_is_valid(bar))
+		return IOMEM_ERR_PTR(-EINVAL);
+
+	res = pcim_addr_devres_alloc(pdev);
+	if (!res)
+		return IOMEM_ERR_PTR(-ENOMEM);
+
+	res->type = PCIM_ADDR_DEVRES_TYPE_REGION_MAPPING;
+	res->bar = bar;
+
+	ret = pci_request_region(pdev, bar, name);
+	if (ret != 0)
+		goto err_region;
+
+	res->baseaddr = pci_ioremap_bar(pdev, bar);
+	if (!res->baseaddr) {
+		ret = -EINVAL;
+		goto err_iomap;
+	}
+
+	devres_add(&pdev->dev, res);
+	return res->baseaddr;
+
+err_iomap:
+	pci_release_region(pdev, bar);
+err_region:
+	pcim_addr_devres_free(res);
+
+	return IOMEM_ERR_PTR(ret);
+}
+EXPORT_SYMBOL(pcim_ioremap_region);
+
 /**
  * pcim_iounmap_region - Unmap and release a PCI BAR
  * @pdev: PCI device to operate on
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 64b308b6e..e7a2ece13 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -2506,6 +2506,8 @@ int pcim_request_all_regions(struct pci_dev *pdev, const char *name);
 void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long maxlen);
 void __iomem *pcim_iomap_region(struct pci_dev *pdev, int bar,
 				const char *name);
+void __iomem *pcim_ioremap_region(struct pci_dev *pdev, int bar,
+				  const char *name);
 void pcim_iounmap_region(struct pci_dev *pdev, int bar);
 void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
 void __iomem * const *pcim_iomap_table(struct pci_dev *pdev);
diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 28c55c5a2..5da0ac1ed 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -1926,7 +1926,7 @@ static int azx_first_init(struct azx *chip)
 	if (chip->driver_type == AZX_DRIVER_ZHAOXINHDMI)
 		bus->polling_mode = 1;
 
-	bus->remap_addr = pcim_iomap_region(pci, 0, "ICH HD audio");
+	bus->remap_addr = pcim_ioremap_region(pci, 0, "ICH HD audio");
 	if (IS_ERR(bus->remap_addr))
 		return PTR_ERR(bus->remap_addr);
 
diff --git a/sound/pci/ad1889.c b/sound/pci/ad1889.c
index f4ec404c0..a2570a148 100644
--- a/sound/pci/ad1889.c
+++ b/sound/pci/ad1889.c
@@ -804,7 +804,7 @@ snd_ad1889_create(struct snd_card *card, struct pci_dev *pci)
 	chip->irq = -1;
 
 	/* (1) PCI resource allocation */
-	chip->iobase = pcim_iomap_region(pci, 0, card->driver);
+	chip->iobase = pcim_ioremap_region(pci, 0, card->driver);
 	if (IS_ERR(chip->iobase))
 		return PTR_ERR(chip->iobase);
 
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index b738295b4..b9fcd913f 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1531,7 +1531,7 @@ static int snd_atiixp_init(struct snd_card *card, struct pci_dev *pci)
 	chip->card = card;
 	chip->pci = pci;
 	chip->irq = -1;
-	chip->remap_addr = pcim_iomap_region(pci, 0, "ATI IXP AC97");
+	chip->remap_addr = pcim_ioremap_region(pci, 0, "ATI IXP AC97");
 	if (IS_ERR(chip->remap_addr))
 		return PTR_ERR(chip->remap_addr);
 	chip->addr = pci_resource_start(pci, 0);
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 8aaeb197c..f65480483 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1163,7 +1163,7 @@ static int snd_atiixp_init(struct snd_card *card, struct pci_dev *pci)
 	chip->card = card;
 	chip->pci = pci;
 	chip->irq = -1;
-	chip->remap_addr = pcim_iomap_region(pci, 0, "ATI IXP MC97");
+	chip->remap_addr = pcim_ioremap_region(pci, 0, "ATI IXP MC97");
 	if (IS_ERR(chip->remap_addr))
 		return PTR_ERR(chip->remap_addr);
 	chip->addr = pci_resource_start(pci, 0);
diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index bb0294579..a773e8a56 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -160,7 +160,7 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci)
 	// (1) PCI resource allocation
 	// Get MMIO area
 	//
-	chip->mmio = pcim_iomap_region(pci, 0, KBUILD_MODNAME);
+	chip->mmio = pcim_ioremap_region(pci, 0, KBUILD_MODNAME);
 	if (IS_ERR(chip->mmio))
 		return PTR_ERR(chip->mmio);
 
diff --git a/sound/pci/aw2/aw2-alsa.c b/sound/pci/aw2/aw2-alsa.c
index 60a87322e..27fd45d64 100644
--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -224,7 +224,7 @@ static int snd_aw2_create(struct snd_card *card,
 	chip->irq = -1;
 
 	/* (1) PCI resource allocation */
-	chip->iobase_virt = pcim_iomap_region(pci, 0, "Audiowerk2");
+	chip->iobase_virt = pcim_ioremap_region(pci, 0, "Audiowerk2");
 	if (IS_ERR(chip->iobase_virt))
 		return PTR_ERR(chip->iobase_virt);
 	chip->iobase_phys = pci_resource_start(pci, 0);
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 383def1f2..55f6b79bd 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -690,7 +690,7 @@ static int snd_bt87x_create(struct snd_card *card,
 	chip->irq = -1;
 	spin_lock_init(&chip->reg_lock);
 
-	chip->mmio = pcim_iomap_region(pci, 0, "Bt87x audio");
+	chip->mmio = pcim_ioremap_region(pci, 0, "Bt87x audio");
 	if (IS_ERR(chip->mmio))
 		return PTR_ERR(chip->mmio);
 
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index f51f4bb63..f000dca94 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -1298,12 +1298,12 @@ static int snd_cs4281_create(struct snd_card *card,
 	}
 	chip->dual_codec = dual_codec;
 
-	chip->ba0 = pcim_iomap_region(pci, 0, "CS4281");
+	chip->ba0 = pcim_ioremap_region(pci, 0, "CS4281");
 	if (IS_ERR(chip->ba0))
 		return PTR_ERR(chip->ba0);
 	chip->ba0_addr = pci_resource_start(pci, 0);
 
-	chip->ba1 = pcim_iomap_region(pci, 1, "CS4281");
+	chip->ba1 = pcim_ioremap_region(pci, 1, "CS4281");
 	if (IS_ERR(chip->ba1))
 		return PTR_ERR(chip->ba1);
 	chip->ba1_addr = pci_resource_start(pci, 1);
diff --git a/sound/pci/cs5530.c b/sound/pci/cs5530.c
index 292b65aa7..7cf74e779 100644
--- a/sound/pci/cs5530.c
+++ b/sound/pci/cs5530.c
@@ -91,7 +91,7 @@ static int snd_cs5530_create(struct snd_card *card,
 	chip->card = card;
 	chip->pci = pci;
 
-	mem = pcim_iomap_region(pci, 0, "CS5530");
+	mem = pcim_ioremap_region(pci, 0, "CS5530");
 	if (IS_ERR(mem))
 		return PTR_ERR(mem);
 	chip->pci_base = pci_resource_start(pci, 0);
diff --git a/sound/pci/lola/lola.c b/sound/pci/lola/lola.c
index 34a3ba17d..ec2938c4b 100644
--- a/sound/pci/lola/lola.c
+++ b/sound/pci/lola/lola.c
@@ -579,14 +579,14 @@ static int lola_create(struct snd_card *card, struct pci_dev *pci, int dev)
 		chip->sample_rate_min = 16000;
 	}
 
-	iomem = pcim_iomap_region(pci, 0, DRVNAME);
+	iomem = pcim_ioremap_region(pci, 0, DRVNAME);
 	if (IS_ERR(iomem))
 		return PTR_ERR(iomem);
 
 	chip->bar[0].remap_addr = iomem;
 	chip->bar[0].addr = pci_resource_start(pci, 0);
 
-	iomem = pcim_iomap_region(pci, 2, DRVNAME);
+	iomem = pcim_ioremap_region(pci, 2, DRVNAME);
 	if (IS_ERR(iomem))
 		return PTR_ERR(iomem);
 
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index d8bbedbc8..9b3758ca1 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -6511,7 +6511,7 @@ static int snd_hdspm_create(struct snd_card *card,
 
 	pci_set_master(hdspm->pci);
 
-	hdspm->iobase = pcim_iomap_region(pci, 0, "hdspm");
+	hdspm->iobase = pcim_ioremap_region(pci, 0, "hdspm");
 	if (IS_ERR(hdspm->iobase))
 		return PTR_ERR(hdspm->iobase);
 
diff --git a/sound/soc/loongson/loongson_i2s_pci.c b/sound/soc/loongson/loongson_i2s_pci.c
index f5b560465..32fc0f544 100644
--- a/sound/soc/loongson/loongson_i2s_pci.c
+++ b/sound/soc/loongson/loongson_i2s_pci.c
@@ -41,7 +41,7 @@ static int loongson_i2s_pci_probe(struct pci_dev *pdev,
 	i2s->dev = dev;
 	pci_set_drvdata(pdev, i2s);
 
-	i2s->reg_base = pcim_iomap_region(pdev, 0, DRIVER_NAME);
+	i2s->reg_base = pcim_ioremap_region(pdev, 0, DRIVER_NAME);
 	if (IS_ERR(i2s->reg_base)) {
 		dev_err(dev, "iomap_region failed\n");
 		return PTR_ERR(i2s->reg_base);


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
