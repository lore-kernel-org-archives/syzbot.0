Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EDA2D8370
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 17:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782494307; cv=none; b=gdWDIA9oMtavH8qbT3WemeGc9SqvhaZtjKIYwd2X+L4SRylitXmCj5rQ6VPFg2FpKKs/TTCmUZ5C4fBQyI4J5pipasq+MF+4BRjr6vdvpBfy6/LNcwh6cron5LM6ElFesZUITEi1gdwbq+mUlSrCKxofWXkPPf2IeSmoNLI/0gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782494307; c=relaxed/simple;
	bh=0PJVp1Kj2dC6/iK5nFolvtVMfdl5xscpI2LaYQwVeTU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Content-Type; b=loH9fyyDNs6fypJeykr/4SGTarkySV5g95v4BIJG1o5DwTQgc0YivW4r4XmlnVbzsRNr8Z1Qdv4yfXtLXCfHn8NXOz1erlBGli9qlo/kSzdG2Pr1o1zno+xpWbDVc6uEGFCfyYPSMZ18/csusr7Bw9pGzXZq4qbXVV4To/q52TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DBjsKLt0; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DBjsKLt0"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-46c3018dd9eso767814f8f.3
        for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 10:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782494304; x=1783099104; darn=lists.linux.dev;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oSfnpZ0q8UAMS6XZxV7qFWvUKHSCDvdilDktcf4LOjA=;
        b=DBjsKLt0HEXL5uy6XGFjJjzDDCLE81uQu6giLMlrcbHJf4tUpbBNRbMXm64MIT5w3O
         Jb41J4pMpnog80Vj7KrwVt+wL9DUmrRRV25jr3jxyfFK4RQVHaXpwqIRIte50p4hTvOr
         Kb3o/oEXmxrRQ/zj7F96tbH6nukyuzZYaQVQY5IWyiC4rPRjk6AWXBIOCa0mQ2rMMjxp
         uGVmF8saFJwCe6x7SFPuzE6iw0ZM5tfREdQHWlNioq/6hau/P3InS4Y4Ze88Tq0/wksW
         hGn0oqXfcnkjwkWVNkAsA8bZRqWVnIj9Ja00djNV5Qnu5wbxxFl+Vytz8Tkv8CRbhhyd
         8iXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782494304; x=1783099104;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oSfnpZ0q8UAMS6XZxV7qFWvUKHSCDvdilDktcf4LOjA=;
        b=SRiy9VXhx1zZqL9/dLQaZt2zx/2odbWmss3iAgTqtDEaono7GiVmUpRT+QXX4yd32T
         ElS8NHNekoOx2V1RrbdcObFwvZcvmNwQ8VRfqgkfIHxDY2A4c5vbNluwCIy546+dxGG2
         zg7vGxfShPJ0hd9CplxuN6GuW7QXClZEkTsTlBX1BUsijUK6VGGwXN32ynaxpE8CiW/U
         zLS7ix0RhsMvoB4WElrS4v1NO0tbJ7jz+SY80oxbwAc2VuINhKTgET7BnARdr6n7PXdo
         hto82DYUbYc4sda9Sf1soz/nk6VOyi5k4BdnTeoakMkFR3hVJEcAXZArzN6XFMOVN248
         iBYQ==
X-Gm-Message-State: AOJu0Yz2ACorvnVdvOiH4kKDvWbLS+c77OSy2GM/mrAYh836PPQ8FYOX
	/li7Wk7LC9Y6iHKf1vIK90DQo7SZ0/71SaM2q6lX1xve/E/omnkmwLYI2XoNlaA5w0wYx6vau9T
	W5X7JSHHwNPa2UhHqKQNuZTiY4vCVeu+6yl3ySSmt3xdhQHW0WLQhORoPsOQkelxu+aPMF5PSi5
	NVJ4YBcy8EtaVMHnhMWDeNPBSWbzg95UCdVOzl
X-Received: from wmla10.prod.google.com ([2002:a05:600d:238a:b0:492:413d:b354])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:46c3:b0:492:3da4:81ef
 with SMTP id 5b1f17b1804b1-49266881aefmr108293285e9.18.1782494304250; Fri, 26
 Jun 2026 10:18:24 -0700 (PDT)
Date: Fri, 26 Jun 2026 17:18:23 +0000
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626171823.1551544-1-nogikh@google.com>
Subject: [PATCH RFC v2] TEST netdevsim: remove debugfs files before freeing net_device
From: Aleksandr Nogikh <nogikh@google.com>
To: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

A KASAN slab-use-after-free was detected in debugfs_u32_get() when reading
a debugfs file associated with a netdevsim port.

BUG: KASAN: slab-use-after-free in debugfs_u32_get+0x6c/0x70
Read of size 4 at addr ffff88810cd6db00

Call Trace:
 debugfs_u32_get+0x6c/0x70
 simple_attr_read+0x227/0x490
 debugfs_attr_read+0x76/0x130
 vfs_read+0x213/0xa80

The root cause is that the net_device (and its embedded netdevsim private
data) is freed before its associated debugfs files are removed. When a user
reads a debugfs file like rx_max_pending, debugfs_u32_get() dereferences a
pointer to the freed memory. This happens because nsim_destroy() calls
free_netdev() but does not remove the debugfs files created by
nsim_ethtool_init() or nsim_bpf_init(). These files are only removed later
when nsim_dev_port_debugfs_exit() is called. A similar issue exists in the
error path of nsim_create().

To fix this, swap the teardown order in __nsim_dev_port_del() and the
__nsim_dev_port_add() error path so that nsim_dev_port_debugfs_exit() is
called before nsim_destroy(). This ensures the debugfs directory is
recursively removed before the net_device is freed. Additionally, remove
explicit debugfs_remove() calls from various subsystem teardown functions
(like nsim_psp_uninit, nsim_ipsec_teardown, etc.) since the parent
directory is now removed earlier, which would otherwise lead to a
use-after-free of the dentry itself. Finally, ensure the debugfs directory
is removed before free_netdev() is called in the nsim_create() error path.

Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Closes: https://syzkaller.appspot.com/bug?extid=6c25f4750230faf70be9
Link: https://syzkaller.appspot.com/ai_job?id=f0f1a72a-a527-478e-a31c-7b83cdfee8d1

---
v2:
- Removed unused dentry pointers (pp_dfs, qr_dfs, vlan_dfs) from struct netdevsim.
- Updated nsim_create() to create debugfs files without storing their dentries.
- Added IS_ERR_OR_NULL check for ns in __nsim_dev_port_add() error path.

v1:
https://lore.kernel.org/all/d0941a03-e111-4b0d-b50d-19352a8ef7e2@mail.kernel.org/T/
---
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f00fc2f9e..4c2c9aa1e 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1516,17 +1516,17 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 		err = devl_rate_leaf_create(&nsim_dev_port->devlink_port,
 					    nsim_dev_port, NULL);
 		if (err)
-			goto err_nsim_destroy;
+			goto err_port_debugfs_exit;
 	}
 
 	list_add(&nsim_dev_port->list, &nsim_dev->port_list);
 
 	return 0;
 
-err_nsim_destroy:
-	nsim_destroy(nsim_dev_port->ns);
 err_port_debugfs_exit:
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
+	if (!IS_ERR_OR_NULL(nsim_dev_port->ns))
+		nsim_destroy(nsim_dev_port->ns);
 err_port_resource_unregister:
 	if (nsim_dev_port_is_pf(nsim_dev_port))
 		devl_port_resources_unregister(devlink_port);
@@ -1544,8 +1544,8 @@ static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
 	list_del(&nsim_dev_port->list);
 	if (nsim_dev_port_is_vf(nsim_dev_port))
 		devl_rate_leaf_destroy(&nsim_dev_port->devlink_port);
-	nsim_destroy(nsim_dev_port->ns);
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
+	nsim_destroy(nsim_dev_port->ns);
 	if (nsim_dev_port_is_pf(nsim_dev_port))
 		devl_port_resources_unregister(devlink_port);
 	devl_port_unregister(devlink_port);
diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index 36a1be492..0bc9f42a5 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -292,5 +292,4 @@ void nsim_ipsec_teardown(struct netdevsim *ns)
 	if (ipsec->count)
 		netdev_err(ns->netdev, "tearing down IPsec offload with %d SAs left\n",
 			   ipsec->count);
-	debugfs_remove_recursive(ipsec->pfile);
 }
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index a75076891..240107369 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -1154,16 +1154,17 @@ struct netdevsim *nsim_create(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_free_netdev;
 
-	ns->pp_dfs = debugfs_create_file("pp_hold", 0600, nsim_dev_port->ddir,
-					 ns, &nsim_pp_hold_fops);
-	ns->qr_dfs = debugfs_create_file("queue_reset", 0200,
-					 nsim_dev_port->ddir, ns,
-					 &nsim_qreset_fops);
-	ns->vlan_dfs = debugfs_create_file("vlan", 0400, nsim_dev_port->ddir,
-					   ns, &nsim_vlan_fops);
+	debugfs_create_file("pp_hold", 0600, nsim_dev_port->ddir, ns,
+			    &nsim_pp_hold_fops);
+	debugfs_create_file("queue_reset", 0200, nsim_dev_port->ddir, ns,
+			    &nsim_qreset_fops);
+	debugfs_create_file("vlan", 0400, nsim_dev_port->ddir, ns,
+			    &nsim_vlan_fops);
 	return ns;
 
 err_free_netdev:
+	debugfs_remove_recursive(nsim_dev_port->ddir);
+	nsim_dev_port->ddir = NULL;
 	free_netdev(dev);
 	return ERR_PTR(err);
 }
@@ -1174,10 +1175,6 @@ void nsim_destroy(struct netdevsim *ns)
 	struct netdevsim *peer;
 	u16 vid;
 
-	debugfs_remove(ns->vlan_dfs);
-	debugfs_remove(ns->qr_dfs);
-	debugfs_remove(ns->pp_dfs);
-
 	if (ns->nb.notifier_call)
 		unregister_netdevice_notifier_dev_net(ns->netdev, &ns->nb,
 						      &ns->nn);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index d909c4160..29cbf004a 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -153,9 +153,6 @@ struct netdevsim {
 	} udp_ports;
 
 	struct page *page;
-	struct dentry *pp_dfs;
-	struct dentry *qr_dfs;
-	struct dentry *vlan_dfs;
 
 	struct nsim_ethtool ethtool;
 	struct netdevsim __rcu *peer;
diff --git a/drivers/net/netdevsim/psp.c b/drivers/net/netdevsim/psp.c
index 6936ecb81..2f27a2114 100644
--- a/drivers/net/netdevsim/psp.c
+++ b/drivers/net/netdevsim/psp.c
@@ -227,7 +227,6 @@ static void __nsim_psp_uninit(struct netdevsim *ns, bool teardown)
 
 void nsim_psp_uninit(struct netdevsim *ns)
 {
-	debugfs_remove(ns->psp.rereg);
 	mutex_destroy(&ns->psp.rereg_lock);
 	__nsim_psp_uninit(ns, true);
 }
diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/udp_tunnels.c
index 89fff76e5..a69b15f12 100644
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -188,9 +188,6 @@ int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
 
 void nsim_udp_tunnels_info_destroy(struct net_device *dev)
 {
-	struct netdevsim *ns = netdev_priv(dev);
-
-	debugfs_remove_recursive(ns->udp_ports.ddir);
 	kfree(dev->udp_tunnel_nic_info);
 	dev->udp_tunnel_nic_info = NULL;
 }


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6

