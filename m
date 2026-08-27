Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFCB3655FA;
	Thu, 27 Aug 2026 06:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787812615; cv=none; b=V84eLuqfDzpv4GuOHRiBn8/Z3jYKJTi57yIs9wyb4Kf1+7735Qkio74ZPebkwX2qdFJq2VtsKV3wpQOOhWwjQ2hOTW4Nx7EhoX6/3YO8jMrCoqE340+SM/ekUcuauYKSuPmJrPwcoJIVtB3ITQB9z+0TxaBQhOf1FO4t7kWlyKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787812615; c=relaxed/simple;
	bh=obqsZ4uc1rQY9yfVPhKm+FWc6uLw7m/hLiUV6KnEyz8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Jrc7k2Bsj/sSdJMOnS+Bhv1IbZ+AlBtlkA09oGpT7P7ilpoxJ1uZD0byhGKMIa4vajz/X79TN6URj8Z6uT+kbjbb8ZLxJPigHXpnc5daRIbNT2Diosw1OMiEYG5xuufD2Naqos4xSxuyNv6oZh8wsjGsc+qIsS09BAfmYjm9uwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VtKl8EWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VtKl8EWi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 61C941F00A3A;
	Thu, 27 Aug 2026 06:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787812612;
	bh=vDITXMHkUeseGMzoeKaLCCD7eXKdPq/heHr+EsapH3g=;
	h=From:To:Cc:Subject:Date;
	b=VtKl8EWiIKdzcH8n/jvyzIr+eEVUllRBxh/h9K3xFMCPZ6hS6QKmJ8qskKFYWkTZc
	 JPgfVWYrRvsDQIlbCPjEOA1B7Sr3uScF4nWnvbjbPByd7RBgesrfzYKJiMbHb3G7AU
	 ZG5c+zMM741+0wTGh6QDsiRNiO1zIXEUmZ/FOilBX/EccdzJqTHL7YptC0n2Dau7ka
	 LMTBk+qDJbT9Vb5upxNdT1pjDXmrRwTygYGlALVVEcije4wppgWIE80T/Hy1YC4WLD
	 3kcHdFWVju8h2DmkEIwhPGMAzltEM1sKoP8ZwTXK+DAApyLko+UW2NCjtzjP3WCYV7
	 Fhuj1ly8cBglA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>, "Basavaraj Natikar" <basavaraj.natikar@amd.com>, "Benjamin Tissoires" <bentiss@kernel.org>, "Jiri Kosina" <jikos@kernel.org>, <linux-input@vger.kernel.org>, "Sandeep Singh" <sandeep.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] HID: amd_sfh: Validate PCI BAR size before mapping
Message-ID: <94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 27 Aug 2026 06:36:52 +0000 (UTC)

From: Slawomir Stepien <sst@poczta.fm>

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
Link: https://syzkaller.appspot.com/ai_job?id=3bc1c45c-548f-4ab5-8243-d2c8ec321d6c
Signed-off-by: Slawomir Stepien <sst@poczta.fm>

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
index 4b81cebdc..039b6ac32 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -451,6 +451,16 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	if (rc)
 		return rc;
 
+	if (!(pci_resource_flags(pdev, 2) & IORESOURCE_MEM)) {
+		dev_err(&pdev->dev, "BAR 2 is not IORESOURCE_MEM\n");
+		return -ENODEV;
+	}
+
+	if (pci_resource_len(pdev, 2) < AMD_SFH_MIN_BAR_SIZE) {
+		dev_err(&pdev->dev, "BAR 2 is too small\n");
+		return -EINVAL;
+	}
+
 	rc = pcim_iomap_regions(pdev, BIT(2), DRIVER_NAME);
 	if (rc)
 		return rc;


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
