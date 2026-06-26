Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC60F3FB07B
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 17:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782494480; cv=pass; b=OFrBY2xBMNKZPswdpBK6C4tE3hOu6BS44KupPW5J2ScNVnuv53mcosNMHf7rAuzpe8MYiVQ4eh4mo0V/L19qSaZNAyLwBN3+/cwbPqwVt2NlZcTuTJvRH4Qy/4OzdZkPqV6hXtnl++khTj3vxwsuqXw4PoOR5HCthHpsz5deafU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782494480; c=relaxed/simple;
	bh=0PJVp1Kj2dC6/iK5nFolvtVMfdl5xscpI2LaYQwVeTU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Content-Type; b=VKKb32BHOyTMU89V0+F66dext7ghYQi6ofHX46OCSQDZEt5xx82DVjLPCrt3QcB0vNqjZTqdWbsbkpXju/3z/TP9FALeX4mSBOrXdrX1vCLmpedGBu2vwTaUjXzra5V3vibkG73SOGemW8Sk5X0EjmEXbU4Obbrju/1H/97HwsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wr54I6kw; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wr54I6kw"
Received: by smtp.kernel.org (Postfix)
	id 9C8111F00A3A; Fri, 26 Jun 2026 17:21:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.221.74
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1782494478;
	b=fbN9qcg6YIT5+nJFWUbk2wLeELajFxTIZGVFhYj6XOAjmSopyLbjUo28BARSnqALUXFV
	 b9i4wNEMNlKJMZhBXc7EqbeoXgoNuQ48PMUqzGEI9VJkbJ5rcmH8FCBV00EmNbzebH1Df
	 voiNICkJlQHqgouMtoNaVGk7/MrO9GxD+lam0rUZuZorVBAIOfOV51Xkw+4XKqbg++DN5
	 h8LxIt4FIfjbSS07L9Tc7uYUc3LLi3irAfdvQRPDglItN/0S6yEF6OjJeifw8xp+JRVmq
	 NtSKlDsPylGEPb7AyZNLVp7OZHw9UGCXQz3jhgAiIBEs/XeezbmK3DF4cNYwCOtjpig==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1782494478;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Content-Type;
	bh=oSfnpZ0q8UAMS6XZxV7qFWvUKHSCDvdilDktcf4LOjA=;
	b=uKI/bU7k18H7sg6HruTfRWtHBsuwPVq29ATeREoOZBXUyTR20Sd5kDt6Zds8tpryDTQe
	 grM/6CPRSpbWr9G2zK94Q2xJAETZMmbsF6KrG1VQeuI7OJqzFwfc1L7BX65rcned3rQg1
	 BDqxfT2sVPudV/esMlbd93cauU8GDZKI0NgdOK2EStPc0rGecGpmxj+Iub1I+h48QjIWv
	 8XkOJQ485wA4j+BiTyLj9YinOqG2NoE+vlPi94BM/xYtxUY9TBFrtvnjuGq1wlxE2iIkk
	 MLnqj08UWVpmELWY8oVnRZVw+46733RbNsL7xeTwEG9NGCUwxxABDNlGkyem/PrgqWw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Wr54I6kw;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com;
	arc=none smtp.remote-ip=209.85.221.74
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ECAB51F000E9
	for <syzbot@kernel.org>; Fri, 26 Jun 2026 17:21:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Wr54I6kw
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org ECAB51F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4621b17733cso549000f8f.0
        for <syzbot@kernel.org>; Fri, 26 Jun 2026 10:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782494476; x=1783099276; darn=kernel.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oSfnpZ0q8UAMS6XZxV7qFWvUKHSCDvdilDktcf4LOjA=;
        b=Wr54I6kwWAgRTEuVJKD2X5yDJI/8G4Eo7W0WpPQ7EkwjH6E3R3gthlY6+MiRSKrxDK
         DTjJQuYFihpFyb2kSLZ00cbi7kbZ/+OMG792QhtejMOAG6FswsqbXbCDexpFwtDTwScA
         5795amjZv1koJPVDpTzHcYh4aPMAw3VGJlEnJWtV9awCht0u4et0v5cyXrpl4nuleouL
         /zRKSg3Rl8L/lLoS7PuSARs6B8YuVPzbct9eN040SPtH5eUB6LNmAb0PSXNlCnnb/L5i
         aRQxtLHOAxkZZw8wg17jjv9Z9VnHLaOsouqx1VnY1J7v1yHtEJNg1M+8hAwYz5Gz68wN
         +EVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782494476; x=1783099276;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oSfnpZ0q8UAMS6XZxV7qFWvUKHSCDvdilDktcf4LOjA=;
        b=GHG8Ikyv3BHctlQ7vusFt1xOxu6ES52i8dHJlzM5ftUlxRBqUL2dWbJ/lcVCEstBiW
         QZtbiJio19OG6BjXupuYHGcd59F+tOKRWWhF4A/ClN+S+nSSlWbjFLWeJgPmTKnTQHv7
         7h5b3VKCKRt5/3bEVRXCPqn4ORrajDiA/x7XkSgH6Qiv743o3YtT8hUlsQOUO1os+6Gi
         9bMWzq66cgP1QhKAPK+79+ZEFZu0UK1dsTajIKhCCc6rdeLyg32i4HlCOC60oeJ1K6BN
         0i2gbfVQDT0H+56YpXP7ExWrPeCAhgHWOBAyQLl7VOHu1f2YPCnXVOffW0/pivZO8uha
         tSgA==
X-Gm-Message-State: AOJu0YwJcM7FjfRiKs96ebuI8cdpOlK87PF/l6i5RzrA1ZyQRUr6TOzM
	Gh6Rdh5M1z4jDehU38zT47yPOb5U4TIs4Ge7b5FysmWDqub2jHsPKhDnfSsp07T4A6MzegpmBaY
	ayYIijR0RRiuT26sod1t2QXKRJV0QKdx+oleTFejKStPWWQnbxKW/UrQM+HCVzfqNcvK61Hrv+g
	bin6j4rkpA+vhm2JWh74c7hDSA6KTxEw==
X-Received: from wrph10.prod.google.com ([2002:adf:f4ca:0:b0:45e:edca:cb12])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:470b:b0:46d:28a7:3ce7
 with SMTP id ffacd0b85a97d-46dbed35effmr11771304f8f.7.1782494475440; Fri, 26
 Jun 2026 10:21:15 -0700 (PDT)
Date: Fri, 26 Jun 2026 17:21:14 +0000
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626172114.1552389-1-nogikh@google.com>
Subject: [PATCH RFC v2] TEST netdevsim: remove debugfs files before freeing net_device
From: Aleksandr Nogikh <nogikh@google.com>
To: syzbot@kernel.org
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

