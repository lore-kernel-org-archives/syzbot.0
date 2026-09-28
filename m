Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB4030FF36
	for <syzbot@lists.linux.dev>; Mon, 28 Sep 2026 08:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790582789; cv=none; b=eyTHgJPtrO2u4jprWnJFjUR+mgQca5Mts+mM9qxzgiMg8ZnAwwBTMdWOVPTXTdxvtfHZiBjZ9rOvTQn3YbbYIILbYBloTIzqD6bKEmmL0oONhdKF+KmW2eSbCygZYsW9VxG74EXDrAfH6Y8cWXfFo/kwMF3Og18nwZnHoKsAEYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790582789; c=relaxed/simple;
	bh=JYr1MhGsil5zDb42OsKGbsnTyba+oKmAGcPJIIfhoUg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=l2SDnCE/WYq5j3+YR/MA+sy8wupTXzGOCBkzR0Kf0HIeIzV2ijtAbfE9Tvjacr9lkVFEfS+aQDr+2Qrx7CY2lPA2vi7txkmoMezy8Z0T4X6UYboPc9Da/sRGjBtQJ5fQzoZmstwXs2B7cs9nkTCVtFUrLaR0Wht6HT3UWwGCS0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHTV+JmT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHTV+JmT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E4AC81F000FF;
	Mon, 28 Sep 2026 08:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790582788;
	bh=2CblsuswwGBI0KC2r7PQ9mxbZ5x3VdtNpuJU8R08AuU=;
	h=From:To:Cc:Subject:Date;
	b=hHTV+JmTtVjTNPw+hH/60k3pACNCDGFY8ui4g/CpCX+kaQOu2tqQ+flZPWpkB5Jfa
	 qhzHHBTqPItEO3ykmiBxCeR5UMf0julikDa7eEt5R80ynG/uexsdhbNoeJvJ/SXYd/
	 1JwAo4Go1tNbQ9eCbA9D9GLiiwizo4c3j8XNhsV8s9rdA3JAvKuAS8nP/lwdMrKOar
	 1tYkKEqwaO/yHnsF7I531oUDuTZQjzRsyb+eCC/fQaZCFQ1O23OuWWE9oMWSSoXspp
	 Pifnl/FoShuy5Vgcc7j27SSF3ioD5CdJj3tjclwChY2hQq/3qPKWoHG44DW12S5pjI
	 VAuiRjiQsRw7A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] vmxnet3: remove adapter from device accessible structures
Message-ID: <ad322f0c-88c8-458d-aec0-bcb67dde3866@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 28 Sep 2026 08:06:27 +0000 (UTC)

In vmxnet3_probe_device(), the driver allocates struct net_device and its
private data (struct vmxnet3_adapter) via alloc_etherdev_mq(). Internally,
alloc_netdev_mqs() uses kvzalloc_flex() to allocate the netdev along with
its private data. The size of struct vmxnet3_adapter has grown to
approximately 46 KB, requiring an order-4 page allocation. Under memory
pressure or fragmentation, contiguous kmalloc allocation can fail and
kvzalloc_flex() falls back to a vmalloc() allocation.

Later in vmxnet3_probe_device(), the driver attempts to map the adapter for
DMA with dma_map_single(). Because dma_map_single() requires physically
contiguous memory, passing a vmalloc address triggers dev_WARN_ONCE in
dma_map_single_attrs() and returns DMA_MAPPING_ERROR, causing device probe
to fail with -EFAULT:

vmxnet3 0000:00:00.0: rejecting DMA map of vmalloc memory
WARNING: include/linux/dma-mapping.h:532 at
vmxnet3_probe_device+0xab8/0x2e70 drivers/net/vmxnet3/vmxnet3_drv.c:4047
RIP: 0010:vmxnet3_probe_device+0xb32/0x2e70
drivers/net/vmxnet3/vmxnet3_drv.c:4047
Call Trace:
 <TASK>
 pci_device_probe+0x48e/0xd10 drivers/pci/pci-driver.c:512
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 device_driver_attach+0xe0/0x1d0 drivers/base/dd.c:1203
 bind_store+0x1d0/0x220 drivers/base/bus.c:267
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

The mapped address was only used to populate devRead->misc.ddPA and
devRead->misc.ddLen in vmxnet3_setup_driver_shared() to expose
driver-private data to the hypervisor, but the device does not rely on them
for normal operation. A similar cleanup was done in commit de1da8bcf405
("vmxnet3: Remove buf_info from device accessible structures") for TX and
RX queue descriptors, where ddPA was set to ~0ULL and ddLen to 0.
Additionally, exposing guest driver state to the hypervisor is undesirable
in confidential computing environments.

Fix this by eliminating the DMA mapping and unmapping of struct
vmxnet3_adapter during probe and removal, setting devRead->misc.ddPA to
~0ULL and ddLen to 0 in vmxnet3_setup_driver_shared(), and removing the
unused adapter_pa field from struct vmxnet3_adapter.

Fixes: b0eb57cb97e7 ("VMXNET3: Add support for virtual IOMMU")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e39090bc9b3cf457717f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e39090bc9b3cf457717f
Link: https://syzkaller.appspot.com/ai_job?id=14d32c70-f1dc-48a8-b2a4-6b0e6f730dc1
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Ronak Doshi" <ronak.doshi@broadcom.com>
To: "Andy King" <acking@vmware.com>
Cc: "Broadcom internal kernel review list" <bcm-kernel-feedback-list@broadcom.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index f8df83f99..81f74bc67 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2921,8 +2921,8 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 	devRead->misc.driverInfo.vmxnet3RevSpt = cpu_to_le32(1);
 	devRead->misc.driverInfo.uptVerSpt = cpu_to_le32(1);
 
-	devRead->misc.ddPA = cpu_to_le64(adapter->adapter_pa);
-	devRead->misc.ddLen = cpu_to_le32(sizeof(struct vmxnet3_adapter));
+	devRead->misc.ddPA = cpu_to_le64(~0ULL);
+	devRead->misc.ddLen = cpu_to_le32(0);
 
 	/* set up feature flags */
 	if (adapter->netdev->features & NETIF_F_RXCSUM)
@@ -4044,14 +4044,6 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	}
 
 	spin_lock_init(&adapter->cmd_lock);
-	adapter->adapter_pa = dma_map_single(&adapter->pdev->dev, adapter,
-					     sizeof(struct vmxnet3_adapter),
-					     DMA_TO_DEVICE);
-	if (dma_mapping_error(&adapter->pdev->dev, adapter->adapter_pa)) {
-		dev_err(&pdev->dev, "Failed to map dma\n");
-		err = -EFAULT;
-		goto err_set_mask;
-	}
 	adapter->shared = dma_alloc_coherent(
 				&adapter->pdev->dev,
 				sizeof(struct Vmxnet3_DriverShared),
@@ -4313,8 +4305,6 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 			  sizeof(struct Vmxnet3_DriverShared),
 			  adapter->shared, adapter->shared_pa);
 err_alloc_shared:
-	dma_unmap_single(&adapter->pdev->dev, adapter->adapter_pa,
-			 sizeof(struct vmxnet3_adapter), DMA_TO_DEVICE);
 err_set_mask:
 	free_netdev(netdev);
 	return err;
@@ -4381,8 +4371,6 @@ vmxnet3_remove_device(struct pci_dev *pdev)
 	dma_free_coherent(&adapter->pdev->dev,
 			  sizeof(struct Vmxnet3_DriverShared),
 			  adapter->shared, adapter->shared_pa);
-	dma_unmap_single(&adapter->pdev->dev, adapter->adapter_pa,
-			 sizeof(struct vmxnet3_adapter), DMA_TO_DEVICE);
 	free_netdev(netdev);
 }
 
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 9f24d66db..2c2a446a8 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -438,7 +438,6 @@ struct vmxnet3_adapter {
 	struct Vmxnet3_CoalesceScheme *coal_conf;
 	bool   default_coal_mode;
 
-	dma_addr_t adapter_pa;
 	dma_addr_t pm_conf_pa;
 	dma_addr_t rss_conf_pa;
 	bool   queuesExtEnabled;


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
