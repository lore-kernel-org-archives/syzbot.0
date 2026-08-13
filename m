Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7E812E1DC
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 20:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786653850; cv=none; b=XMpj3XSkCLeEXpxoAvR3CVu+GlHffSxWLwSVFG4gusWdmEO5sfhD9KbDeocWv5A8ajOnrR3ZteSDD/QbIaOR3KuNj1etvA3aXy8KiUAq9D/r9G4CnEYZU/kfDa2m4BtrNvYdhlpe+QmRMrLNj1O6Zp60CiV5TzG35XlrPFFM6cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786653850; c=relaxed/simple;
	bh=ghFpRDZ2baDIGmfGQQGc27pzwmKfJjcw5t9am0U40nE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=K4K2tC5bO6S1lS92inCnd84ysxyyeWksPWzdBZIDot9XTCO86MPQEsJpBoiKUt0J5iyQ9On3lEfsH8OvZyX+Pw/UN7Vl3ZLihE3h4w350YwPRfVpHCQKUZPnz45eEZIYXS+f5bg8ANwUBujYXc1Zzy1BPKAuAkly4LH0aA+JyOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZwCEu/XX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZwCEu/XX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1F1FD1F00A3A;
	Thu, 13 Aug 2026 20:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786653849;
	bh=5h83w4XR561HXdtiwGt3+f10EAUNz8TryYFXmNM0AJE=;
	h=From:To:Cc:Subject:Date;
	b=ZwCEu/XXF+eSf9yU9Vr+qqBTEhqgaQxH0QqMJsTl9zr8Bupq7gCKAi7DkyNb5BpOH
	 9dBTtKOiPkanpPbqrf2lPW2RyJEoN6Ojgk4/BewkUsUmCbXmumsuurpRYzHPr3Ug2L
	 93HuopVSGBGCSsdmYNfIXlDRoaH0yaZ5qO4Cvf+XZQqZJcd4JSEL86KRw5S5YF3jfm
	 qkzhJteP7aqpLdvT3pobfFMn8q5IadDkjeQh/hAyuXOY+w/91SYoDb+TpBaDZRHkhe
	 NrXPjxFnWL+EsfWPGxJGez1Exyz7a7SU/nA5B2MZCnqnr3avUdSNvCFsAenlD16S6h
	 /GGOp0u5Knr1Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] HID: amd_sfh: Validate PCI BAR size before mapping
Message-ID: <f83daf97-4762-4a67-bac7-615b34d1b661@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 13 Aug 2026 20:44:09 +0000 (UTC)

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
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+4eadd4dfe9e66522bae8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4eadd4dfe9e66522bae8
Link: https://syzkaller.appspot.com/ai_job?id=7a94b74c-2359-4cbe-b08b-2c52f3bf9755
To: "Basavaraj Natikar" <basavaraj.natikar@amd.com>
To: "Benjamin Tissoires" <bentiss@kernel.org>
To: "Jiri Kosina" <jikos@kernel.org>
To: <linux-input@vger.kernel.org>
To: "Sandeep Singh" <sandeep.singh@amd.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 4b81cebdc..c1dbee87c 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -451,6 +451,11 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	if (rc)
 		return rc;
 
+	if (pci_resource_len(pdev, 2) < 128 * 1024) {
+		dev_err(&pdev->dev, "BAR 2 is too small\n");
+		return -EINVAL;
+	}
+
 	rc = pcim_iomap_regions(pdev, BIT(2), DRIVER_NAME);
 	if (rc)
 		return rc;


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
