Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F789420468
	for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 09:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789379440; cv=none; b=PrWec69on8JFVZCx1O7U29bWp8XtsBfXn1gLBmAeNYrwLCxCLjIc9ihjVZk5Rbug2N/bZSwa1HmxRa8SN3x0P1LzryqF5NgAPs7km73djr1rs0v2EJX95UgYUawIHfTx9/f3qnIxoFx1MC8OzuQYf2XLeRVKc0XJJMMMsHdvN9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789379440; c=relaxed/simple;
	bh=lOn8gRXqvS7hF+moEVAKdLL/rL+TDs0AzKWVEtTpFUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o5Vl1Fwg3FKv0u+AJesUS8Ui0u28xDbbi4PaXvgehKIrCXIGm8GnepZ9CCyGAMU6cxwzDA3IbJj+dxtIxL+rnuVY7r9lv79BSIVa+9MpjUgKLa/aCaM7U22Aln6FKPrTJmcFqE32zPKXIm8WBDfTOLrKPN0ksiAgnVo1Sz5blcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=fHSPUpYi; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="fHSPUpYi"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 14 Sep 2026 11:50:33 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: syzkaller-bugs@googlegroups.com,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	bentiss@kernel.org,
	jikos@kernel.org,
	linux-input@vger.kernel.org,
	sandeep.singh@amd.com
Cc: linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	Slawomir Stepien <sst@poczta.fm>,
	syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com
Subject: [PATCH v2] HID: amd_sfh: Validate PCI BAR size before mapping
Date: Mon, 14 Sep 2026 11:50:07 +0200
Message-ID: <20260914095007.205287-1-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789379434; bh=FVa+YjjcW9hmFc3cvqqLFK8kvWsctFf1lA9TzHiUzRc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=fHSPUpYimmQJwRXJJMwauDMh4YC2dOr0lbSESJrhIuk8069d6i45hKt1PZOI12pY+
	 q1qx7CorWSJ+JFttOIXvJmOhobNi+64e6mlbODH/yJIsppO6DSOrYyen9Y2+hcTk+A
	 6kiugcgEwqnJcqWLRrfPnoWuJhJp/kjdFucx28HY=

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
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
---
v2:
* Use SZ_128K for AMD_SFH_MIN_BAR_SIZE define
* Add comment why we need 128K
* Add 'Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>' since no logical changes

v1:
* https://lore.kernel.org/all/94704655-d654-4500-8122-b80bea9bd908@mail.kernel.org/
---
 drivers/hid/amd-sfh-hid/amd_sfh_common.h |  4 ++++
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c   | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_common.h b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
index f8c6b7fc34fb..3d29119a3765 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_common.h
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_common.h
@@ -13,11 +13,15 @@
 #include <linux/auxiliary_bus.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/sizes.h>
 #include "amd_sfh_hid.h"
 
 #define PCI_DEVICE_ID_AMD_MP2		0x15E4
 #define PCI_DEVICE_ID_AMD_MP2_1_1	0x164A
 
+/* The BAR 2 size must cover the highest register offset (0x10958) */
+#define AMD_SFH_MIN_BAR_SIZE		SZ_128K
+
 #define AMD_C2P_MSG(regno) (0x10500 + ((regno) * 4))
 #define AMD_P2C_MSG(regno) (0x10680 + ((regno) * 4))
 
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index eda26a094d3f..061a63519d44 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -497,6 +497,16 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
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
-- 
2.55.0

