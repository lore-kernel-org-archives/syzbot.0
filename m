Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74347143A
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 13:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665209; cv=none; b=PM8lh5Ne3pbRrz0qU5xoVOO0ikvnyEkp9hHGh/YFluE/mQ6yhSE7g1oomclNRuH2jpSnRSW6mupLCzy+HmlSRMBQIxPnDrsBfBSLGQFKjfSxCeAEHtrYlTw6VMt9gIa5jDzbuSbDbgpop5E6XT8yC26WeC5jPSPHP0nkbA118aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665209; c=relaxed/simple;
	bh=E2IWDhq9XKwemsASfgwkP09vl0u976uD1nOw2qQHPqc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=NNEmiIbPRzYIU/7H0TcVPAW/xhyo4lYy7VemW2UagasqftwU04/+46cUaApNwdkJBafVSlgBhHclEhllfQwlwAOgFpRo0vH7Y1gpG9KZLCMCj2Wxd4Jrw7M4cYsC5kOzXQwL+t8ubYQQMtXMuIqbf+UF+28BEATzvgDVmY0r/D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlQBOUYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlQBOUYg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5B94A1F00AC4;
	Tue, 25 Aug 2026 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787665207;
	bh=Kp2UyOfI254tm1tAGek6qwwWeFFrdy0kzSyseTumh5A=;
	h=From:To:Cc:Subject:Date;
	b=KlQBOUYgq2yiI379ONnztXts5MLEqSLKHoAk+vWCjsLGvBvcPSOsuzOp3/kIFvbEM
	 ZvWBTJ7aDNX25thq2Ll+gS5vx5sw2+cejW1GUyv+qMILVWbyZWew9DUK3+llsLqyko
	 Y/I5n8mZt6VbKMp0Gb+0Hq6ACh7c4CXHXGhi6jOcxdgPyF/yFwPjMl4/EemR634NS/
	 iRG8rBL9/IOpNujY/bDqhftYpKASzLAHR2ni3CWEhMF2lqSuQ6l1N4LURcbFM0HtAj
	 IoBhKA+GD76V9L1jLYJVM67EHZ5uibPdQAqLCWjtuJggyqjXzdjetJLH+0GWyfwF+m
	 BKsOJaV3u/9zg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] thunderbolt: Validate BAR 0 resource type and size
Message-ID: <3b721f07-79ad-423c-9bd3-f945e97a1d9b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 25 Aug 2026 13:40:07 +0000 (UTC)

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
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+97999b836ee62ddb0181@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=97999b836ee62ddb0181
Link: https://syzkaller.appspot.com/ai_job?id=94fb1c6e-d9bf-4502-b2ca-abddc1e16654
To: "Yehezkel Bernat" <YehezkelShB@gmail.com>
To: "Andreas Noever" <andreas.noever@gmail.com>
To: <linux-usb@vger.kernel.org>
To: "Mika Westerberg" <westeri@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/thunderbolt/pci.c b/drivers/thunderbolt/pci.c
index bbd186c29..052519bc7 100644
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
+	if (pci_resource_len(pdev, 0) < 0x40000)
+		return dev_err_probe(dev, -EINVAL, "BAR 0 is too small\n");
+
 	nhi->iobase = pcim_iomap_region(pdev, 0, "thunderbolt");
 	res = PTR_ERR_OR_ZERO(nhi->iobase);
 	if (res)


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
