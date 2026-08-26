Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812193B14A7
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 08:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787732263; cv=none; b=LZvTZTcAL9ZjSIWYHN9v8YMyU826jwfCGJPGsMY3XeXpgbgLwiG/DKE5ExIipF6rOEpcb/SWXC7JjkJ2TazslgP6lxdzK3XmEpGDH25MiQuTZDmb3MRT1R5Dh0C/kYzbgFLWe4gmQEvZGImJszYmdtWsAXXSiEE2wDGyTTAxTac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787732263; c=relaxed/simple;
	bh=jkpcA3M5XCE6rqbOvA1lzZXOtjTHA09o7yc/a7RGy1E=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=pGzaXY2195fVGiwBBvWfooAHlWOFoVMi7VR/ee9jCiflkydym5MDcZBRKL+12EFVinoqw9sN8X2GLma+Zvbp5B5iSvxbYaiEvO0+w7NodkpWcFaYeE7W1KwUmTFb3Stx0LDY5BE4IiAdg1Q9fRy3Ssk1kItvoSLMf97urg28xlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XM6xwK2E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XM6xwK2E"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D8EA41F000E9;
	Wed, 26 Aug 2026 08:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787732258;
	bh=iDRwgIuoMqUb4wf4AgXlt1XZ8PBHeu9HstHpL4GH6oM=;
	h=From:To:Cc:Subject:Date;
	b=XM6xwK2E6XrLSb69UgVyWr0VAJBxuFOrGYJOy4apDiSI34s3wD9b7Py12Y/Q82kea
	 Ondxz+M9dmPmXgSEsPK21rdIZ8OZG5Ayh+7Nu/LQZQbGMU6wUoyk8JjLHF4NXK7Aip
	 I+FwevtvKvREWtcV+ayPMEVeqU+BNobX5wr9qyKpIyJ+eV2ryRVw0XB59BIuSsc8qt
	 6nVoRc3Ot2iXRtajZAUKT0OMCOxepNVF6kbY63o27SUwfG3dKq+Bj9RWA/GUcqdW4r
	 7pFWtoiWsNwZADWx+Rqv0K3VzKU0YbXxlWlU7Heu60PrA1Cs1gQw0oCqFqK13WHC7Q
	 fP72L6g46SHSw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] HID: amd_sfh: Validate PCI BAR size before mapping
Message-ID: <2d083f63-913d-45c5-b770-c88ee06589ba@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 26 Aug 2026 08:17:37 +0000 (UTC)

The amd_sfh driver maps PCI BAR 2 using pcim_iomap_regions() and
subsequently accesses MMIO registers at offsets up to 0x10958 (e.g.,
AMD_P2C_MSG3 at 0x1068C). However, the driver never validates that the BAR
size is large enough to cover these accesses. If the driver is bound to a
device with a smaller BAR 2, this leads to an out-of-bounds memory access
and a page fault during the probe function.

For example, a page fault can occur when reading from privdata->mmio +
AMD_P2C_MSG3 in mp2_select_ops():

  BUG: unable to handle page fault for address: ffffc9000390368c
  PGD 100000067 P4D 100000067 PUD 1012c1067 PMD 105b64067 PTE 0
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:readl arch/x86/include/asm/io.h:59 [inline]
  RIP: 0010:mp2_select_ops drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:282
  [inline]
  RIP: 0010:amd_mp2_pci_probe+0x337/0x5f0
  drivers/hid/amd-sfh-hid/amd_sfh_pcie.c:487
  Call Trace:
   <TASK>
   local_pci_probe drivers/pci/pci-driver.c:332 [inline]
   pci_call_probe drivers/pci/pci-driver.c:394 [inline]
   __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
   pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489

Fix this by verifying that the length of BAR 2 is at least 128KB before
attempting to map it. Since the maximum accessed offset is 0x10958, and PCI
BAR sizes are powers of 2, any legitimate hardware will have a BAR size of
at least 128KB.

Fixes: 4f567b9f8141 ("SFH: PCIe driver to add support of AMD sensor fusion hub")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4eadd4dfe9e66522bae8
Link: https://syzkaller.appspot.com/ai_job?id=ae80612d-4fc5-4b7a-83bb-894e0a14dc5e
To: "Basavaraj Natikar" <basavaraj.natikar@amd.com>
To: "Benjamin Tissoires" <bentiss@kernel.org>
To: "Jiri Kosina" <jikos@kernel.org>
To: <linux-input@vger.kernel.org>
To: "Sandeep Singh" <sandeep.singh@amd.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>

---
v2:
- Define AMD_SFH_MIN_BAR_SIZE macro instead of hardcoded 128 * 1024
- Use AMD_SFH_MIN_BAR_SIZE in amd_sfh1_1_init()

v1:
https://lore.kernel.org/all/f83daf97-4762-4a67-bac7-615b34d1b661@mail.kernel.org/T/
---
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_common.h b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
index 78f830c13..c0c324565 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_common.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
@@ -17,6 +17,8 @@
 #define PCI_DEVICE_ID_AMD_MP2		0x15E4
 #define PCI_DEVICE_ID_AMD_MP2_1_1	0x164A
 
+#define AMD_SFH_MIN_BAR_SIZE		(128 * 1024)
+
 #define AMD_C2P_MSG(regno) (0x10500 + ((regno) * 4))
 #define AMD_P2C_MSG(regno) (0x10680 + ((regno) * 4))
 
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 4b81cebdc..d870585a0 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -451,6 +451,11 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	if (rc)
 		return rc;
 
+	if (pci_resource_len(pdev, 2) < AMD_SFH_MIN_BAR_SIZE) {
+		dev_err(&pdev->dev, "BAR 2 is too small\n");
+		return -EINVAL;
+	}
+
 	rc = pcim_iomap_regions(pdev, BIT(2), DRIVER_NAME);
 	if (rc)
 		return rc;
diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
index b0bab2a1d..0afc596b5 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_init.c
@@ -388,12 +388,12 @@ int amd_sfh1_1_init(struct amd_mp2_dev *mp2)
 	int rc;
 
 	phy_base <<= 21;
-	if (!devm_request_mem_region(dev, phy_base, 128 * 1024, "amd_sfh")) {
+	if (!devm_request_mem_region(dev, phy_base, AMD_SFH_MIN_BAR_SIZE, "amd_sfh")) {
 		dev_dbg(dev, "can't reserve mmio registers\n");
 		return -ENOMEM;
 	}
 
-	mp2->vsbase = devm_ioremap(dev, phy_base, 128 * 1024);
+	mp2->vsbase = devm_ioremap(dev, phy_base, AMD_SFH_MIN_BAR_SIZE);
 	if (!mp2->vsbase) {
 		dev_dbg(dev, "failed to remap vsbase\n");
 		return -ENOMEM;


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
