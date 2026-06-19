Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57EF364EB1
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 09:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781860586; cv=none; b=NWpmVprlumfxx24FXTYNGWNN0E47c6lIoyVOZ4lF8bd14A+CIB8tPsGbOLbhgVRBYaqIazARKmlM5XZqt7y3+pB+tEMHWwX6XJQS+SI40apVzyR5RqRGtbNWVLv92hjmunMp5ufRS0P2WpCIIU1Kdr9sZ4ZcmmUx0Fc/cgfRzI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781860586; c=relaxed/simple;
	bh=xmoBVNqyOBEKDAyuZUrWKeOIrOFLF1SFhbMiBfwSfuU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=cnaRhIVI3+2AlAN497Z2au2GGohvMaRDDlw5pqgfamm3tro04b8AC2a+IiSRv+Ls4dKhzW2ToUOIw2nTpN/gxQAxd/sKLkfw+58o+KUQISBMhN1dMFH4BWnpOYc9FTpFGl1mGOLolkXSMwQhBM5i3T+mKzYFKEMk2yhTGBihQO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgQgag7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgQgag7/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E49511F000E9;
	Fri, 19 Jun 2026 09:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781860582;
	bh=ZRXH6p9OTvsmhLQS5eMzxE0K8nz/1EpNV4ywrksS35o=;
	h=From:To:Cc:Subject:Date;
	b=SgQgag7/prOIus5mC1k9XHhSZUGRqdsbr1j+rrDqpDD2P6V5r+WwJwbSzBYbilhur
	 IyRBCY6jKYV4hsWITtWTz66o0BMPfndXNBGZmZqFjVh5kA4SERMEVQOaOOkwmJJ1VO
	 szWOkDvUZZ49sMoszA3f/qoNVRuleRiFWgePcEyTKZzx65sYTCqdobs/z4cRarsS25
	 4gNU2YNvfjydSmbRf31p8X9oAhvwsFmVr21SuwibP763s88z8q0HTGPoEGfFXtbYMK
	 4JC/VGZAb9lpOH7//5r4Gi1d8nGpm3rq1bPJPV/C9Huoy4QHGLS8IjrdwBR+d+80A0
	 WbeQznMcF0t4A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] netdevsim: remove debugfs files before freeing netdev
Message-ID: <b2de6fa2-bc67-45a6-abb0-35868b40b0da@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 19 Jun 2026 09:16:21 +0000 (UTC)

A KASAN slab-use-after-free bug was detected in debugfs_u32_get(). The root
cause is a race condition between the destruction of a netdevsim port and
the cleanup of its associated debugfs files.

When a netdevsim port is destroyed, the teardown happens in
__nsim_dev_port_del(), which first calls nsim_destroy() and then
nsim_dev_port_debugfs_exit(). nsim_destroy() eventually calls
free_netdev(), which frees the struct netdevsim memory. However, the
debugfs files pointing to fields inside this struct are only removed later
in nsim_dev_port_debugfs_exit(). This creates a use-after-free window where
a user space program can access the freed memory by reading from the
debugfs files. The same issue exists in the error path of nsim_create().

To fix this, ensure that the debugfs directory nsim_dev_port->ddir is
recursively removed before the struct netdevsim memory is freed. Move the
debugfs_remove_recursive() call to the beginning of nsim_destroy() and the
error path of nsim_create(). Set nsim_dev_port->ddir to NULL to make the
subsequent call to nsim_dev_port_debugfs_exit() a safe no-op. Finally,
remove redundant debugfs_remove() calls for individual files and
subdirectories, as they are now handled by the recursive removal.

BUG: KASAN: slab-use-after-free in debugfs_u32_get+0x6c/0x70
fs/debugfs/file.c:657
Read of size 4 at addr ffff88810cd6db00 by task syz.3.8220/23584

Call Trace:
 debugfs_u32_get+0x6c/0x70 fs/debugfs/file.c:657
 simple_attr_read+0x227/0x490 fs/libfs.c:1368
 debugfs_attr_read+0x76/0x130 fs/debugfs/file.c:523
 vfs_read+0x213/0xa80 fs/read_write.c:572
 ksys_read+0x150/0x270 fs/read_write.c:717

Freed by task 22896:
 kfree+0x1c5/0x640 mm/slub.c:6566
 device_release+0xc4/0x1f0 drivers/base/core.c:-1
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x222/0x550 lib/kobject.c:737
 __nsim_dev_port_del+0x14e/0x200 drivers/net/netdevsim/dev.c:1547
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1561 [inline]
 nsim_dev_reload_destroy+0x288/0x490 drivers/net/netdevsim/dev.c:1785

Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+6c25f4750230faf70be9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6c25f4750230faf70be9
Link: https://syzkaller.appspot.com/ai_job?id=b0e49fe8-9a07-4af6-b52c-12fa3167dd55
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f00fc2f9e..3a79cef66 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -442,6 +442,7 @@ static int nsim_dev_port_debugfs_init(struct nsim_dev *nsim_dev,
 static void nsim_dev_port_debugfs_exit(struct nsim_dev_port *nsim_dev_port)
 {
 	debugfs_remove_recursive(nsim_dev_port->ddir);
+	nsim_dev_port->ddir = NULL;
 }
 
 static int nsim_dev_resources_register(struct devlink *devlink)
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
index a75076891..91e92456f 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -1164,6 +1164,8 @@ struct netdevsim *nsim_create(struct nsim_dev *nsim_dev,
 	return ns;
 
 err_free_netdev:
+	debugfs_remove_recursive(nsim_dev_port->ddir);
+	nsim_dev_port->ddir = NULL;
 	free_netdev(dev);
 	return ERR_PTR(err);
 }
@@ -1174,9 +1176,8 @@ void nsim_destroy(struct netdevsim *ns)
 	struct netdevsim *peer;
 	u16 vid;
 
-	debugfs_remove(ns->vlan_dfs);
-	debugfs_remove(ns->qr_dfs);
-	debugfs_remove(ns->pp_dfs);
+	debugfs_remove_recursive(ns->nsim_dev_port->ddir);
+	ns->nsim_dev_port->ddir = NULL;
 
 	if (ns->nb.notifier_call)
 		unregister_netdevice_notifier_dev_net(ns->netdev, &ns->nb,
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
index 89fff76e5..e9cdfe817 100644
--- a/drivers/net/netdevsim/udp_tunnels.c
+++ b/drivers/net/netdevsim/udp_tunnels.c
@@ -190,7 +190,6 @@ void nsim_udp_tunnels_info_destroy(struct net_device *dev)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
-	debugfs_remove_recursive(ns->udp_ports.ddir);
 	kfree(dev->udp_tunnel_nic_info);
 	dev->udp_tunnel_nic_info = NULL;
 }


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
