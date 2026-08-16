Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4203E49D0
	for <syzbot@lists.linux.dev>; Sun, 16 Aug 2026 22:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786920787; cv=none; b=O4y/ggCHSpRhDe921IGWMdag7BTsm/HfzD1vTuOhWnfAhOhT026DY1V1BG44Wq7Itu8yKkhRiqkDmqeB98IhaqNzh6DCLO+zuPdQPRWS5lUnsKGrf7xh+5Ki5VpGT90x/jGjEkbd2tKVF/89kJkSSgk6JmiZdNfC0Wv0uNovY5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786920787; c=relaxed/simple;
	bh=MdWbbp8yuEPNWRHoAh8XQFiVbywTmFnqppHov+vWmdg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=LWRiIM9h83GLaaNc0X2xCbmXeUnubYx+ANYFCyks7K8zVfCx27AWdsTo4fSzITY3Puu10Cq8luwiQ4jm7ROl8+B+b2kuJ4E+9ltv6UxKDa/zk6TzmbR2M9lwbMozHB4d5es8BZkRkiIbVvFffZd506FvNRKtiUeAzCg9PGvvr/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TE73oErU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TE73oErU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 74C3E1F000E9;
	Sun, 16 Aug 2026 22:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786920785;
	bh=+SKbABiRQvgQ8/XbRkZRuPcsgnT+KVBhI27/0LdC5Qg=;
	h=From:To:Cc:Subject:Date;
	b=TE73oErUcPmiI3RCm4NQwsclzYaXzeL519F8VcBbzrs+6hBCnL1ZsGdq0n90H1J2K
	 e4dCHzC0ydOsPTDLhb604kBSAj8TkbTYxY4/O9GXI//Vv51lmG1f107yDoSzRiXRla
	 wJSlC41nb4e3DyQNkTaYZGvL93LDXcM/yFVOQP8iBJcQfUv9O3bLAIZY9YjT7u/+8E
	 a1/ZkKSTba5hMV4XQUKkuq5zxF6lwgYl79GCFDynl4Sm3CZLSQPGxFBQk0w3XrYWPR
	 p1MwM0YQafNSMeJ4JNyNEFCjZL0HqwmVflM9fbSN4XFMb5C4QEtkn5EpxB93gDPNPo
	 psBSOBxBxUYoA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] e1000e: reject non-PCIe devices and check reset_hw() return value
Message-ID: <c7465765-2009-4803-b5de-69a84efcdeb6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 16 Aug 2026 22:53:05 +0000 (UTC)

When forcing the e1000e driver to bind to an incompatible non-PCIe device
(such as the e1000 82540EM) via sysfs driver_override, a mismatch in
hardware register layouts occurs. This causes the driver to blindly retry
NVM reads and wait for a hardware response that never comes. When multiple
threads attempt this concurrently, they serialize on the device lock, and
the cumulative wait time easily exceeds the kernel's hung task timeout,
leading to a system crash:

INFO: task syz.2.41:7507 blocked for more than 143 seconds.
...
Call Trace:
 <TASK>
 __schedule+0x17e7/0x5630 kernel/sched/core.c:7234
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
 device_lock include/linux/device.h:1104 [inline]
 __device_driver_lock drivers/base/dd.c:1171 [inline]
 device_driver_attach+0xd5/0x1d0 drivers/base/dd.c:1202
 bind_store+0x1d0/0x220 drivers/base/bus.c:267
...
NMI backtrace for cpu 1
...
RIP: 0010:e1000e_poll_eerd_eewr_done
drivers/net/ethernet/intel/e1000e/nvm.c:133 [inline]
RIP: 0010:e1000e_read_nvm_eerd+0xdf/0x300
drivers/net/ethernet/intel/e1000e/nvm.c:311
...
Call Trace:
 <TASK>
 e1000_read_nvm drivers/net/ethernet/intel/e1000e/e1000.h:588 [inline]
 e1000e_validate_nvm_checksum_generic+0xcb/0x3e0
 drivers/net/ethernet/intel/e1000e/nvm.c:553
 e1000_validate_nvm_checksum_82571+0x176/0x290
 drivers/net/ethernet/intel/e1000e/82571.c:787
 e1000_validate_nvm_checksum drivers/net/ethernet/intel/e1000e/e1000.h:577
 [inline]
 e1000_probe+0x12f8/0x2b20 drivers/net/ethernet/intel/e1000e/netdev.c:7590
 local_pci_probe drivers/pci/pci-driver.c:332 [inline]
 pci_call_probe drivers/pci/pci-driver.c:394 [inline]
 __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
 pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 device_driver_attach+0xe0/0x1d0 drivers/base/dd.c:1203
 bind_store+0x1d0/0x220 drivers/base/bus.c:267

Fix this by adding an early sanity check in e1000_probe() to reject
non-PCIe devices using pci_is_pcie(). Additionally, check the return value
of adapter->hw.mac.ops.reset_hw() and abort the probe with -EIO if it
fails. This prevents the driver from proceeding to the NVM checksum
validation loop, which is responsible for the massive delay.

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+8ce4dba751e79facdc38@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8ce4dba751e79facdc38
Link: https://syzkaller.appspot.com/ai_job?id=bf813674-8b64-4b49-ac67-92a88e64885d
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "Tony Nguyen" <anthony.l.nguyen@intel.com>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: <intel-wired-lan@lists.osuosl.org>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Przemek Kitszel" <przemyslaw.kitszel@intel.com>
To: "Auke Kok" <auke-jan.h.kok@intel.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 844f31ab3..6d087a414 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7393,6 +7393,9 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int bars, i, err;
 	s32 ret_val = 0;
 
+	if (!pci_is_pcie(pdev))
+		return -ENODEV;
+
 	if (ei->flags2 & FLAG2_DISABLE_ASPM_L0S)
 		aspm_disable_flag = PCIE_LINK_STATE_L0S;
 	if (ei->flags2 & FLAG2_DISABLE_ASPM_L1)
@@ -7581,7 +7584,12 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* before reading the NVM, reset the controller to
 	 * put the device in a known good starting state
 	 */
-	adapter->hw.mac.ops.reset_hw(&adapter->hw);
+	err = adapter->hw.mac.ops.reset_hw(&adapter->hw);
+	if (err) {
+		dev_err(&pdev->dev, "Hardware Error\n");
+		err = -EIO;
+		goto err_hw_init;
+	}
 
 	/* systems with ASPM and others may see the checksum fail on the first
 	 * attempt. Let's give it a few tries


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
