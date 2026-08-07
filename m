Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10B414A0C
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 06:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786084269; cv=none; b=BWfymjXTSvjZl4OtGKfTzCv06oA6/IDvs56dnchPqSn0hpN9WBeXoI6dxCSMytael6z6Iifo1kdHK9uXfp3BWieX4/k35XBA2bKQjVVkBLYqe/g4NKZYOn1MLpLioTCCZKmbHwmgOnk0SQIL/nUy+xNQDBCcUm18cZZy4hcfJ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786084269; c=relaxed/simple;
	bh=CY8qWDDnR63b2gfRF7b0bLHINrxdvnTuoIFM46B9pSE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=qiHLNRux67J3Y9Pl0RIQw/48Y9Ssm4jCK1W1ADlUckGXPUtzZUpYwCSuId7upZXXp+nk6iFMMMnpnhFAMgufNDQktRkLr/ovGhoti9um7+/nLsMY6agdv0mTkrerPxMUTAkVRUHf3/ww+GgMDDCaH/GcaFVL3SN2U9DccutdzgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=De4mALkG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="De4mALkG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AFB1A1F00A3A;
	Fri,  7 Aug 2026 06:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786084267;
	bh=nWPxy0BDn7QW/hwyFwisvsIeKmZ3uS80KF4mqqT1HVw=;
	h=From:To:Cc:Subject:Date;
	b=De4mALkGOMQNLRCCP4eOoZOHGqZAkIXrVVfcfuP9tcFYieE/hQ9jn4j3zOTpRfmRb
	 r6AiWe+h4A8n51Ij9t/dd1Qqa7jrAGsbwiuXqtX6QXywxAUND9do79gtvR3NAgUmHb
	 HWDCIDUp17HXxzr6yEfwjy6Ib8/vbcq9MFOAkxEPtwjsP7CgapUw1vFWYwQ4z7pTB7
	 OcXim0FNDO7kdsuFdSWEINxgt6fQ6Z0UfPMnl95f//yNHZ5q7mFg5Ae/X3SIbKmCNo
	 GjSWsslfhwE+CMggJV9xOSislIKmkXoJDT2RnKCna5IgKgPuhX/3numzh1mcpsXytF
	 gkQNS8FNOl8nQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ALSA: drivers: Fix out-of-bounds array access in probe functions
Message-ID: <34c42cb8-c11e-4dd3-9016-b327fe40a2af@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 06:31:07 +0000 (UTC)

When a platform driver is forced to bind to a device with a negative ID
(e.g., PLATFORM_DEVID_NONE, which is -1), the device ID is used directly as
an index into static arrays without proper bounds checking. This results in
an out-of-bounds array access, as reported by UBSAN:

UBSAN: array-index-out-of-bounds in sound/drivers/dummy.c:1020:40
index -1 is out of range for type 'int[8]'
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 snd_dummy_probe+0x12c6/0x18f0 sound/drivers/dummy.c:1020
 platform_probe+0xf9/0x190 drivers/base/platform.c:1439

This issue affects several ALSA platform drivers that trust the device ID
without validation.

Fix this by adding explicit bounds checking for the device ID at the
beginning of the probe functions in the affected drivers. For the ALSA
drivers in sound/drivers/, ensure the ID is within the valid range of [0,
SNDRV_CARDS). For the ASoC bells driver, check the ID against the size of
the bells_cards array.

Fixes: 6e65c1cc4458 ("[ALSA] dummy - Use platform_device")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+2fb5d1f7cc4c1f132bcc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2fb5d1f7cc4c1f132bcc
Link: https://syzkaller.appspot.com/ai_job?id=420b7754-7b1e-46a8-bbc3-9b77df287d5d
To: "Mark Brown" <broonie@kernel.org>
To: "Liam Girdwood" <lgirdwood@gmail.com>
To: <linux-sound@vger.kernel.org>
To: "Jaroslav Kysela" <perex@perex.cz>
To: "Sylwester Nawrocki" <s.nawrocki@samsung.com>
To: "Takashi Iwai" <tiwai@suse.com>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: =?utf-8?q?C=C3=A1ssio_Gabriel?= <cassiogabrielcontato@gmail.com>
Cc: "Kees Cook" <kees@kernel.org>
Cc: "Len Bao" <len.bao@gmx.us>
Cc: <linux-kernel@vger.kernel.org>
Cc: =?utf-8?b?VXdlIEtsZWluZS1Lw7ZuaWcgKFRoZSBDYXBhYmxlIEh1Yik=?= <u.kleine-koenig@baylibre.com>

---
diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 06bfe09ea..9520d3431 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1802,6 +1802,9 @@ static int loopback_probe(struct platform_device *devptr)
 	int dev = devptr->id;
 	int err;
 
+	if (dev < 0 || dev >= SNDRV_CARDS)
+		return -ENODEV;
+
 	err = snd_devm_card_new(&devptr->dev, index[dev], id[dev], THIS_MODULE,
 				sizeof(struct loopback), &card);
 	if (err < 0)
diff --git a/sound/drivers/dummy.c b/sound/drivers/dummy.c
index 7283f0f18..41e79574c 100644
--- a/sound/drivers/dummy.c
+++ b/sound/drivers/dummy.c
@@ -1017,6 +1017,9 @@ static int snd_dummy_probe(struct platform_device *devptr)
 	int idx, err;
 	int dev = devptr->id;
 
+	if (dev < 0 || dev >= SNDRV_CARDS)
+		return -ENODEV;
+
 	err = snd_devm_card_new(&devptr->dev, index[dev], id[dev], THIS_MODULE,
 				sizeof(struct snd_dummy), &card);
 	if (err < 0)
diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
index c217c427b..a519ce9eb 100644
--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -89,6 +89,9 @@ static int snd_mpu401_probe(struct platform_device *devptr)
 	int err;
 	struct snd_card *card;
 
+	if (dev < 0 || dev >= SNDRV_CARDS)
+		return -ENODEV;
+
 	if (port[dev] == SNDRV_AUTO_PORT) {
 		dev_err(&devptr->dev, "specify port\n");
 		return -EINVAL;
diff --git a/sound/drivers/mts64.c b/sound/drivers/mts64.c
index 36e9eab20..3fff5cfc4 100644
--- a/sound/drivers/mts64.c
+++ b/sound/drivers/mts64.c
@@ -900,7 +900,7 @@ static int snd_mts64_probe(struct platform_device *pdev)
 	p = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
 
-	if (dev >= SNDRV_CARDS)
+	if (dev < 0 || dev >= SNDRV_CARDS)
 		return -ENODEV;
 	if (!enable[dev]) 
 		return -ENOENT;
diff --git a/sound/drivers/portman2x4.c b/sound/drivers/portman2x4.c
index dcc0899cf..0a7815880 100644
--- a/sound/drivers/portman2x4.c
+++ b/sound/drivers/portman2x4.c
@@ -697,7 +697,7 @@ static int snd_portman_probe(struct platform_device *pdev)
 	p = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, NULL);
 
-	if (dev >= SNDRV_CARDS)
+	if (dev < 0 || dev >= SNDRV_CARDS)
 		return -ENODEV;
 	if (!enable[dev]) 
 		return -ENOENT;
diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index 3c2896109..aec02a15a 100644
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -846,6 +846,9 @@ static int snd_serial_probe(struct platform_device *devptr)
 	int err;
 	int dev = devptr->id;
 
+	if (dev < 0 || dev >= SNDRV_CARDS)
+		return -ENODEV;
+
 	switch (adaptor[dev]) {
 	case SNDRV_SERIAL_SOUNDCANVAS:
 		ins[dev] = 1;
diff --git a/sound/drivers/virmidi.c b/sound/drivers/virmidi.c
index a204f42d1..0a9313eeb 100644
--- a/sound/drivers/virmidi.c
+++ b/sound/drivers/virmidi.c
@@ -75,6 +75,9 @@ static int snd_virmidi_probe(struct platform_device *devptr)
 	int idx, err;
 	int dev = devptr->id;
 
+	if (dev < 0 || dev >= SNDRV_CARDS)
+		return -ENODEV;
+
 	err = snd_devm_card_new(&devptr->dev, index[dev], id[dev], THIS_MODULE,
 				sizeof(struct snd_card_virmidi), &card);
 	if (err < 0)
diff --git a/sound/soc/samsung/bells.c b/sound/soc/samsung/bells.c
index fc4963d3b..3a0352499 100644
--- a/sound/soc/samsung/bells.c
+++ b/sound/soc/samsung/bells.c
@@ -470,6 +470,9 @@ static int bells_probe(struct platform_device *pdev)
 {
 	int ret;
 
+	if (pdev->id < 0 || pdev->id >= ARRAY_SIZE(bells_cards))
+		return -EINVAL;
+
 	bells_cards[pdev->id].dev = &pdev->dev;
 
 	ret = devm_snd_soc_register_card(&pdev->dev, &bells_cards[pdev->id]);


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
