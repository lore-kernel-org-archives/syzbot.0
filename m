Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA73433F8B4;
	Tue, 25 Aug 2026 16:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674181; cv=none; b=GpNPgTGWtFz2eKaKioZY45cW671ssnrOd8yOc0686LmK2dVtSGGJ61HS73WBpHMOTCCuvUkq1VsXsaA3gqQtgiyoObEYaHMsltLrK2Ow2rb6ucy7paQNV/3/97J2w1fkjUzjlNZl7zU2vWh7t1i43icBxNK3i3Y89gzQzdYulbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674181; c=relaxed/simple;
	bh=15gsy5bdbwhpf9Ije7bM1yVmEc5O16tDCToJXmaEDKI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Tc7f8ab2yGcwRd4LgQCELebqPEvoBP27lFmgDnWRBroaH+/jt5VEsBG8Wi6EupdWlo4jRWF4gdSvEprKgQKUqrAXmIvdsElBbthHCqpLDZlGAo5OfSr32Wa3P/0vS4Oicp63JRol+xq9L4pi0EOEbtukgdnu0yLSnw/YewLqHv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSqU7RNp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSqU7RNp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 72A161F000E9;
	Tue, 25 Aug 2026 16:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674177;
	bh=HsEQKxgCoRAngmSKNRX4u8BYNQTCdnaMB9VQlBfOhcM=;
	h=From:To:Cc:Subject:Date;
	b=RSqU7RNp1A5SMsyb34uxEbQmSnGbinyXC0ZEqhkYTwkwNIjVC5VnvqpVx5iDtp8pA
	 2EPAysUQaej8it6K7sTkoGikFkIhl4tF311sJ9I2+FnPwwbIz4SMhZdjxu+ATFW+jg
	 jGBifmExLbTrkH5ISI92GYlQiOx8SBYS4MQv5VhjLB/Ac/HoqgjPcw36cqoksVC1gf
	 A+/wWbpttFem+dIkUmcFWFcHATB/kHHCyYT0MMClGmUx2AXvsy6Lo77asjCKPgZoUp
	 ul6edX2eBDcc8sSzmEMv0pg4e2cfPbO1OUciremBfK+Uitn1E6jk6K4co/0MSuEC2F
	 AiE5XNZAsi14A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Marco Elver <elver@google.com>, "Yehezkel Bernat" <YehezkelShB@gmail.com>, "Andreas Noever" <andreas.noever@gmail.com>, <linux-usb@vger.kernel.org>, "Mika Westerberg" <westeri@kernel.org>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] thunderbolt: Validate BAR 0 resource type and size
Message-ID: <9e0d4fdc-4e1d-4195-80c0-7a70d34d1fc2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 25 Aug 2026 16:09:37 +0000 (UTC)

From: Marco Elver <elver@google.com>

The thunderbolt driver can crash with a page fault if it binds to an
arbitrary PCI device (e.g., via sysfs driver_override) that has an I/O port
BAR at index 0 instead of an MMIO BAR.

The driver maps this BAR without validating its type or size. When it
attempts to read a Thunderbolt register at a large offset, the resulting
I/O port cookie overflows the reserved PIO space on x86. This causes the
generic ioread32() function to misinterpret the out-of-bounds I/O port
cookie as a valid MMIO virtual address, leading to a direct dereference of
an unmapped physical-like address and a page fault:

  BUG: unable to handle page fault for address: 00000000000556c0
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  ...
  Call Trace:
   <TASK>
   nhi_probe+0xcc/0x870 drivers/thunderbolt/nhi.c:1198
   nhi_pci_probe+0x46b/0x580 drivers/thunderbolt/pci.c:479
   local_pci_probe drivers/pci/pci-driver.c:332 [inline]
   pci_call_probe drivers/pci/pci-driver.c:394 [inline]
   __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
   pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489

To fix this, add explicit validation in nhi_pci_probe() to ensure that BAR
0 is an MMIO resource and is large enough to contain all the NHI registers
before attempting to map it. The NHI register space extends up to offset
0x39944 (REG_FW_STS), so checking for a minimum size of 0x40000 (256 KB) is
appropriate.

Fixes: 16603153666d ("thunderbolt: Add initial cactus ridge NHI support")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+97999b836ee62ddb0181@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=97999b836ee62ddb0181
Link: https://syzkaller.appspot.com/ai_job?id=2570f821-2184-40c8-8bd7-344a30c18a13
Signed-off-by: Marco Elver <elver@google.com>

---
diff --git a/drivers/thunderbolt/nhi_regs.h b/drivers/thunderbolt/nhi_regs.h
index d6a197fab..1feb0bfb0 100644
--- a/drivers/thunderbolt/nhi_regs.h
+++ b/drivers/thunderbolt/nhi_regs.h
@@ -140,6 +140,9 @@ struct ring_desc {
 #define REG_FW_STS_ICM_EN_INVERT	BIT(1)
 #define REG_FW_STS_ICM_EN		BIT(0)
 
+/* Minimum BAR size to contain NHI registers */
+#define NHI_MIN_BAR_SIZE		0x40000
+
 /* ICL NHI VSEC registers */
 
 /* FW ready */
diff --git a/drivers/thunderbolt/pci.c b/drivers/thunderbolt/pci.c
index bbd186c29..fa69e4609 100644
--- a/drivers/thunderbolt/pci.c
+++ b/drivers/thunderbolt/pci.c
@@ -466,6 +466,14 @@ static int nhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	nhi->dev = dev;
 	nhi->ops = (const struct tb_nhi_ops *)id->driver_data ?: &pci_nhi_default_ops;
 
+	/* Ensure BAR 0 is an MMIO resource */
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM))
+		return dev_err_probe(dev, -EINVAL, "BAR 0 is not an MMIO resource\n");
+
+	/* Ensure BAR 0 is large enough to contain the NHI registers */
+	if (pci_resource_len(pdev, 0) < NHI_MIN_BAR_SIZE)
+		return dev_err_probe(dev, -EINVAL, "BAR 0 is too small\n");
+
 	nhi->iobase = pcim_iomap_region(pdev, 0, "thunderbolt");
 	res = PTR_ERR_OR_ZERO(nhi->iobase);
 	if (res)


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
