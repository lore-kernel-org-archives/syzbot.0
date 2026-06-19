Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502FE331EA5
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 18:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781892549; cv=none; b=YcGlBeOXtjRtEzlVuSIlB2YDBFDZUTNf5IYOYLfJ+U1z++m4zdUSbZCco1iDGhLrTY9rigeaZOqrOZKXpmaZ7MO3BRJTteCLrbCfEwm4xJ7QDH9GYPfYytF8Td1KDmILr0YyoQhW0IcuURWC6olABLBsJk8AhYbuTF+mD6tlOpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781892549; c=relaxed/simple;
	bh=Taqzy9KZYbU7PCNT2FNQX7E/i3sQOq1xLsGEbeYpATA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=XNFbqk/AtR8iWV+lVqv4zQtfzHkOZAJBIX9rfZVpd4LIYPzies3GncCnBaNa2e5Cr/4P6+TN74/As0gI48FhyttQL+g3cgF1l8JLL5uo8bR4Ukvep9dX6cBRwdoCRUxxjcRBNTY1qQGhk6KjF3vOsrbGT8Tx6agqM3WyQbN8h8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfH+I4r2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfH+I4r2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D11461F000E9;
	Fri, 19 Jun 2026 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781892547;
	bh=pugCaXUL/8g4ckcB3aWDIhnMZPhqackrTyjsK+QoyRQ=;
	h=From:To:Cc:Subject:Date;
	b=RfH+I4r2WfDKGwYsvE0ulcLfT+83uryzeWayhbNdc2+TC7XW16+OIBjHNPcTEgO8c
	 ZBCBX/Yh8pB6POMmUq0pIY+NptPbBqzwc5jS80J/KixA/9OICi7Qw8MaPCX/veYeRL
	 F5ewkBsq6g9GIe961SN6KzsHgGJTOIRirnTTSO1GEbajsCqc7xPYSHkb2cGqUp8pkO
	 BPIS6d5+Qv75XP3f3mXPRgwDj+sbBzHGKXsyRIi+4Wkg8j54BWaOysxv4XZ1mi+EH1
	 5RUbIjxXg/Ry8Dlrbr46r1Nb3EgFWpNiKvTjN+jeE0YyIc0lzuiIegbYLYr+lDWDzG
	 SruoJIpW4mtig==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v3] netdevsim: fix UAF by swapping teardown order
Message-ID: <7baaf502-615e-419d-abec-6c130824d294@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 19 Jun 2026 18:09:07 +0000 (UTC)

A slab-use-after-free was detected in debugfs_u32_get(). The issue arises
because the netdevsim device's debugfs files are removed after the
underlying memory for the netdevsim instance has been freed.

In __nsim_dev_port_del(), nsim_destroy() is called before
nsim_dev_port_debugfs_exit(). nsim_destroy() eventually calls
free_netdev(), which frees the struct netdevsim. However, the debugfs files
associated with this device still exist and can be accessed until
nsim_dev_port_debugfs_exit() is called, leading to a UAF.

Fix this by swapping the order of cleanup: remove the debugfs entries first
using nsim_dev_port_debugfs_exit(), then proceed with nsim_destroy(). This
is a simpler and more robust fix. Since nsim_dev_port_debugfs_exit()
performs a recursive removal of the port's debugfs directory, manual
removals of individual debugfs files in sub-modules are now redundant and
have been removed.

Also updated the error paths in nsim_create() and __nsim_dev_port_add() to
follow the same pattern.

BUG: KASAN: slab-use-after-free in debugfs_u32_get+0x6c/0x70
fs/debugfs/file.c:657
Read of size 4 at addr ffff888196b7db00 by task syz.2.2765/11946

Call Trace:
 <TASK>
 debugfs_u32_get+0x6c/0x70 fs/debugfs/file.c:657
 simple_attr_read+0x227/0x490 fs/libfs.c:1368
 debugfs_attr_read+0x76/0x130 fs/debugfs/file.c:523
 vfs_read+0x213/0xa80 fs/read_write.c:572
 ksys_read+0x150/0x270 fs/read_write.c:717
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Freed by task 11226:
 kfree+0x1c5/0x640 mm/slub.c:6566
 device_release+0xc4/0x1f0 drivers/base/core.c:-1
 kobject_put+0x222/0x550 lib/kobject.c:737
 __nsim_dev_port_del+0x14e/0x200 drivers/net/netdevsim/dev.c:1547
 nsim_dev_reload_destroy+0x288/0x490 drivers/net/netdevsim/dev.c:1785

Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+6c25f4750230faf70be9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6c25f4750230faf70be9
Link: https://syzkaller.appspot.com/ai_job?id=32031d0e-0992-44c9-8801-560fddd81e41
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Swapped the order of nsim_dev_port_debugfs_exit() and nsim_destroy() in __nsim_dev_port_del() to ensure debugfs files are removed before the netdevsim structure is freed.
- Removed redundant debugfs cleanup calls in nsim_destroy(), nsim_ipsec_teardown(), nsim_psp_uninit(), and nsim_udp_tunnels_info_destroy() as they are now covered by the recursive removal of the port directory.
- Fixed debugfs cleanup in the error paths of nsim_create() and __nsim_dev_port_add().

v2:
- Switched to a symmetrical cleanup approach by explicitly removing debugfs entries in teardown functions instead of recursive removal of the port directory.
- Added nsim_ethtool_teardown() to remove the ethtool debugfs directory.
- Updated nsim_bpf_uninit() to remove BPF-related debugfs files using debugfs_lookup_and_remove().
- Called nsim_ethtool_teardown() in nsim_destroy() and the error path of nsim_create().
https://lore.kernel.org/all/ae062345-5029-4e41-9f06-20d8face5948@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/b2de6fa2-bc67-45a6-abb0-35868b40b0da@mail.kernel.org/T/
---
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f00fc2f9e..beecc0c6e 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1524,7 +1524,9 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	return 0;
 
 err_nsim_destroy:
+	nsim_dev_port_debugfs_exit(nsim_dev_port);
 	nsim_destroy(nsim_dev_port->ns);
+	goto err_port_resource_unregister;
 err_port_debugfs_exit:
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
 err_port_resource_unregister:
@@ -1544,8 +1546,8 @@ static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
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
index a75076891..6918679ca 100644
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
@@ -1174,10 +1176,6 @@ void nsim_destroy(struct netdevsim *ns)
 	struct netdevsim *peer;
 	u16 vid;
 
-	debugfs_remove(ns->vlan_dfs);
-	debugfs_remove(ns->qr_dfs);
-	debugfs_remove(ns->pp_dfs);
-
 	if (ns->nb.notifier_call)
 		unregister_netdevice_notifier_dev_net(ns->netdev, &ns->nb,
 						      &ns->nn);
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
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
