Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529D1284693
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 12:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781873349; cv=none; b=Qodr//gxbo6kFdiKrycKw50EmfetoAbCehgPff7YWwGSJ1h6aRhIt+uYHGWJo8wRVKRAVfWj/bxyewO+i97GbD5BIkz8odbETCCgUh4Sn7eT4d5Xosab1H/Yf2OlR8jTGBGHRcP8svGcA+ycJitkNeJQXHqqxSIAqQNs7CIisGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781873349; c=relaxed/simple;
	bh=a6XIQnthZbs/TC128voHiTSsrVepdHUhap35ia6Gp7Y=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=GvsLuOZidD1RrsyvHZIiD5igbzdOCdmlVrlZyT1MrjcGKEEInhyb2qGoMK7lcOobipV5HqM7uycuO3u5wxsP5LcaHloYwxR76MupM8bgXEm6WpVVRCmTiAsuZ9gYYSJ82JuMvNVspfACA7/6LkfqTJc1vA/y9upmOJYzRNStmIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+FcK++o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+FcK++o"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D6CE01F000E9;
	Fri, 19 Jun 2026 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781873347;
	bh=e0KmfzoTUCBn9sx8DskqE+Wq68zNRxkrl7RCctHA+1E=;
	h=From:To:Cc:Subject:Date;
	b=H+FcK++oYVcPmbkWw7vFIQNcYtk90i6t4qP6I9+0N4IC1JW3GjHBFbCDOALyTz80k
	 dT1zczgi8G5zp6qLqnvuJcTXIiaOowuLBKavfM9TaruNBTKJXUUkL/9Mzn7mh3mlD+
	 xixLhxGZtTglutHSv9rJ/H324MQctoweeaFglxRVf3n0pkvjHZegXQfdf1ycjbOJgq
	 rbLxMhOTA7yGGpMn48vWqUBl+dubLqqT7bwqcwnji2XzT1fJAnyGaxdyrAnbwOBgaV
	 +3q3i0adgd8RHyu3bU/63tazAjRqGrDxonQcYf62SP8vabn7zVetHiHb8AbxUrB7yS
	 qYyGyTUzMoQmg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] netdevsim: fix UAF by explicitly cleaning up debugfs files
Message-ID: <ae062345-5029-4e41-9f06-20d8face5948@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 19 Jun 2026 12:49:07 +0000 (UTC)

A KASAN slab-use-after-free bug was detected in debugfs_u32_get(). The root
cause is a race condition between the destruction of a netdevsim device and
the access to its associated debugfs files.

When a netdevsim device is destroyed, the teardown happens in
__nsim_dev_port_del(), which calls nsim_destroy() and then
nsim_dev_port_debugfs_exit(). nsim_destroy() calls free_netdev(), which
frees the struct netdevsim memory. However, some debugfs files pointing to
fields inside this struct are only removed later in
nsim_dev_port_debugfs_exit(). This creates a use-after-free window where a
user space program can access the freed memory by reading from the debugfs
files. The same issue exists in the error path of nsim_create().

To fix this, explicitly remove the debugfs files and directories created
for the netdevsim instance during its teardown. This is done by adding or
updating teardown functions like nsim_ethtool_teardown() and
nsim_bpf_uninit() to remove their respective debugfs entries before the
underlying memory is freed. This approach ensures that the cleanup is
symmetrical and specifically targets the files associated with the
netdevsim instance being destroyed, without breaking the symmetry of
nsim_dev_port->ddir.

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
Link: https://syzkaller.appspot.com/ai_job?id=d4f60d9d-c966-4936-8994-4459d20c9153
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: <bpf@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Switched to a symmetrical cleanup approach by explicitly removing debugfs entries in teardown functions instead of recursive removal of the port directory.
- Added nsim_ethtool_teardown() to remove the ethtool debugfs directory.
- Updated nsim_bpf_uninit() to remove BPF-related debugfs files using debugfs_lookup_and_remove().
- Called nsim_ethtool_teardown() in nsim_destroy() and the error path of nsim_create().

v1:
https://lore.kernel.org/all/b2de6fa2-bc67-45a6-abb0-35868b40b0da@mail.kernel.org/T/
---
diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 8eebcc933..5b9b1da46 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -653,6 +653,15 @@ int nsim_bpf_init(struct netdevsim *ns)
 
 void nsim_bpf_uninit(struct netdevsim *ns)
 {
+	struct dentry *ddir = ns->nsim_dev_port->ddir;
+
+	debugfs_lookup_and_remove("bpf_map_accept", ddir);
+	debugfs_lookup_and_remove("bpf_xdpoffload_accept", ddir);
+	debugfs_lookup_and_remove("bpf_xdpdrv_accept", ddir);
+	debugfs_lookup_and_remove("bpf_tc_non_bound_accept", ddir);
+	debugfs_lookup_and_remove("bpf_tc_accept", ddir);
+	debugfs_lookup_and_remove("bpf_offloaded_id", ddir);
+
 	WARN_ON(ns->xdp.prog);
 	WARN_ON(ns->xdp_hw.prog);
 	WARN_ON(ns->bpf_offloaded);
diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index 36a201533..3a369040c 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -271,3 +271,8 @@ void nsim_ethtool_init(struct netdevsim *ns)
 	debugfs_create_u32("tx_max_pending", 0600, dir,
 			   &ns->ethtool.ring.tx_max_pending);
 }
+
+void nsim_ethtool_teardown(struct netdevsim *ns)
+{
+	debugfs_lookup_and_remove("ethtool", ns->nsim_dev_port->ddir);
+}
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index a75076891..9a7db40c9 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -1164,6 +1164,7 @@ struct netdevsim *nsim_create(struct nsim_dev *nsim_dev,
 	return ns;
 
 err_free_netdev:
+	nsim_ethtool_teardown(ns);
 	free_netdev(dev);
 	return ERR_PTR(err);
 }
@@ -1177,6 +1178,7 @@ void nsim_destroy(struct netdevsim *ns)
 	debugfs_remove(ns->vlan_dfs);
 	debugfs_remove(ns->qr_dfs);
 	debugfs_remove(ns->pp_dfs);
+	nsim_ethtool_teardown(ns);
 
 	if (ns->nb.notifier_call)
 		unregister_netdevice_notifier_dev_net(ns->netdev, &ns->nb,
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index d909c4160..75b724e18 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -171,6 +171,7 @@ void nsim_destroy(struct netdevsim *ns);
 bool netdev_is_nsim(struct net_device *dev);
 
 void nsim_ethtool_init(struct netdevsim *ns);
+void nsim_ethtool_teardown(struct netdevsim *ns);
 
 void nsim_udp_tunnels_debugfs_create(struct nsim_dev *nsim_dev);
 int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,


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
