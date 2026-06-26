Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6794137F8DA
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782494584; cv=pass; b=MwsyW5u6slVF+NekclXLWLc2Pirazs6kJgEaIz2+ZpbhxPXEzHgs7ro3ZCDuDO0Gw5wSgrpJsZCzonnONwGcBmPk0cVltKy7NcXHiWjcmCpMDh2zJHtwD3Egl/PNXftyCxsieF7FFCl1c+8vWkluXGpF9PYCyj8tYJZmB4S0Xbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782494584; c=relaxed/simple;
	bh=0PJVp1Kj2dC6/iK5nFolvtVMfdl5xscpI2LaYQwVeTU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=GpHSgRDeuWPRQeyN4WKLBUtJFOnHriy1H0U9EcqttFHObDSl2R66p7xUYGqrh52kHHV1xFawB+6YVYRoZDFYpZg5QW8uf4x+1zWEvMrFFlb3LQTvRQDVw7vTzeQbt4oAfGhJsiuBx9wcenZzbJSepGEbK8OuHaciPQAidhZpNPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J+Ukn/3p; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J+Ukn/3p"
Received: by smtp.kernel.org (Postfix)
	id 144BC1F00A3A; Fri, 26 Jun 2026 17:23:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.221.74
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1782494583;
	b=vZxokoY566lBN+276pxOuJVeaUOyawcnWOPIirWWBOEiQu/I+sX7yiRQYIy4MEZFWGFe
	 TAlhUahmldI59kcV36/q32V5Ciq9zoQqVP6FeP8zKiZUOXkv5lcfMA7p4Ye2TvmjSCjpX
	 pAAfRwEkQ8rkYqiUbn+LPF/w9n6hSuRwWYOO2TKR6nRhB3CBsbW6kZkETNXkwgPwtzg1q
	 OBYx2RiOuQGcVyKK2T5eBANP5EMXJZ8O78lnqiTZG1Lrhzzw02Fdr/r8aOuNirCfcp1xG
	 Cl7TezhUS3IyOstnaGm3tFmqoFdM3ujB5mV/UGgxCkLf3xN9yIiE/DDP3r3lsvBE87g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1782494583;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=oSfnpZ0q8UAMS6XZxV7qFWvUKHSCDvdilDktcf4LOjA=;
	b=sVHOKnYGYnMepRwDFyIMRuib47+8k7DY05vZ8bqxVk6LjLsDFBUX14Vc485eXUJbb4b2
	 dlA1iq2KOFOgDdpXCmLNo/GlSZ0Mh6wHA73C0synGO66MJMK2AoiAdF6aMuj9wyeVFVHw
	 /EpI3gn8ffVPHabj1qNN111w+BObGD9FwGOq+zBHguP1w0QABXGetqJQ95syPlryOD7ov
	 /TCpUWMC0NG4nj+vdXFH5nLti/7ZyzN9NV8z50mUzHu+qHlxQd+D9klTLsAZYOmcN0tYn
	 2ICY7iIIl7HYR6MJKG5LPRauCghXzvVZnInhSGRyeVb4nDc9qYbugnf3cfhlm8sGN6w==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="J+Ukn/3p";
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com;
	arc=none smtp.remote-ip=209.85.221.74
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 71EAE1F000E9
	for <syzbot@kernel.org>; Fri, 26 Jun 2026 17:23:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=J+Ukn/3p
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 71EAE1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-46dc84ca722so752347f8f.1
        for <syzbot@kernel.org>; Fri, 26 Jun 2026 10:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782494581; x=1783099381; darn=kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oSfnpZ0q8UAMS6XZxV7qFWvUKHSCDvdilDktcf4LOjA=;
        b=J+Ukn/3pAWsZw/anDknVu7DAmAeXp1jy3VUpwSQ8A3MLSrL0gy8td9dJw9JNcnFvLB
         UFgku1IzWoDOW0oqs/qwUxQTPl/8Wb5Nc3TbpNEPeHhlbRfOMGArAozDij9iSpOiTKQD
         cs/wu6wmQLhBY35FY5dbuYppx8SMMHRk+vHDORQpLmCtLycStah8eWcJ5LBQSyOA7ZTi
         Ga3X7f51Lr01T4pvB5kWQagECdt998JCU8v+Lc9mzjVIm3mWTOprFF8aX8S+fVL6lImA
         w4IiAzeRHnFzQ0F4rXeNq2Ska0sHcFQjaXpsBDjnRz+wTCtFFvnNxqopUQHEQ9GDgy6N
         8Chg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782494581; x=1783099381;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oSfnpZ0q8UAMS6XZxV7qFWvUKHSCDvdilDktcf4LOjA=;
        b=LS6YRioqcaNLfigfbCg7DNkPRjdm3r/lRsUxxEHpwzQjfK8GX91HtSeIHEnY/nfABE
         xDBptOQF3JI7TjLumLvlU5ezxqLGPaBYxEW5HIARNot4uzSUn9UXZn6q+SSlWozxGxlv
         ox93mSMPGKB5JIdQNgxNIbeugJoM9Z+BLd4ON0x1BRnQwHtwvwtP2Sq+zQsr+NPrLDer
         4JHvp7wkZDFWwe/R7W4JEKr4z19J7qGCllnWIn19xXPYyp5VjDo0WxwDn7GG1/oCg7Zm
         bnK/EhZhJ8xnYD/DiiSIfZ4wEvA9iNLMtynqloNzr3p4aYrDNtz/mvNf7W+7MwUhW24q
         wYKA==
X-Gm-Message-State: AOJu0YweVHtcHMCPX1w5P60rFSYoZGrAa4wdzAOs4XcfCER6b63nzZKo
	5MxPpZkVGxvcBpQw+oM879jvyddb4DYJUYnSE0t1zEwyiHkSJbNHRKnaQnRWwKjeNPj87rdYxoa
	EgM9MSvhxK4n8cbDwGoU78xDr6wQEI7e20d6IgKonPcVzaJ7A6xs9UX2U77DBCKQ0bL4PRi/Tl5
	EEQQzszj9iSI32Uo+hvdhECFeqdMgHWQ==
X-Received: from wmej9.prod.google.com ([2002:a05:600c:42c9:b0:490:b42f:2a6f])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3483:b0:490:b58a:dcc1
 with SMTP id 5b1f17b1804b1-492668ac06dmr104962185e9.29.1782494580561; Fri, 26
 Jun 2026 10:23:00 -0700 (PDT)
Date: Fri, 26 Jun 2026 17:22:59 +0000
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626172259.1553912-1-nogikh@google.com>
Subject: [PATCH RFC v2] TEST netdevsim: remove debugfs files before freeing net_device
From: Aleksandr Nogikh <nogikh@google.com>
To: syzbot@kernel.org
Cc: nogikh@google.com
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

