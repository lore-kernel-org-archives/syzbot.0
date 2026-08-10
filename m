Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461563A7F4A
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 08:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786352295; cv=none; b=pS9P4zq3ui28Ql+BULqRKmPJ+6RnWJ5EZYFNjju22n1NZMd8aiGlYKKLTAbvCPHY2bacdrAYA7JIedFFwGlfMrbq9AP0TAyPENpt7+oqpMaRciW70YuuD/fA31Zw3BWRRoy82FE/MNccPAwiRSN1x4+t0XMiIHK80tVx1e+lsPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786352295; c=relaxed/simple;
	bh=E5zXS3Kqqb7CwM+0T0bL1MNJipOkT2/vfhJTw7iHQL0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g1OB6v7qraLDq6xmtgus428essE51w3GxW3KQB533U6ITBDAPoNWQ8fik2wjG4rkPt95XBGjfK+Z05768iXetrjh8v5lUshaszegfityaRx8vubWx/GbTtodh8KAP0+eNJ7Q0Ytoas7/W3QHmnKcp0O+8kOz9aVcejan2F3nTNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=xGPplLCO; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="xGPplLCO"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 10 Aug 2026 10:58:07 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: kuba@kernel.org,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot@lists.linux.dev,
	Slawomir Stepien <sst@poczta.fm>,
	syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com
Subject: [PATCH v2] netdevsim: drop the ability to change max_vfs via debugfs
Date: Mon, 10 Aug 2026 10:57:17 +0200
Message-ID: <20260810085717.570382-1-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1786352290; bh=xrTw5PAADgmBNSmc3t2wM6SDOYwJszQY+/tmBuBo4HU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=xGPplLCOSyvlmxlf8ZLiius2mOgEG6tyrxujq18bPdExT1nmi8VVBw2VTNnyW5TGZ
	 K3ylQnwEjNt+ZWzvA6ssR0e5baXpyityvoZDUP6n46d6FSoiYryaGbgUrogxm8OGzg
	 G4Yl75PI/S8AIQl6Js135GOkp79hTDCG72u5irhw=

This debugfs file isn't used by kernel's selftests, so drop it.

Reported-by: syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3147c5de186107ffc7a1
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Slawomir Stepien <sst@poczta.fm>
---
v2:
* Changed the approach as suggested by Jakub
* Subject line has changed

v1:
* https://lore.kernel.org/all/b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org/T/
---
 drivers/net/netdevsim/bus.c       |  3 --
 drivers/net/netdevsim/dev.c       | 79 +------------------------------
 drivers/net/netdevsim/netdevsim.h |  2 +-
 3 files changed, 3 insertions(+), 81 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 41483e371f05..5c55c308487b 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -443,8 +443,6 @@ static const struct bus_type nsim_bus = {
 	.num_vf		= nsim_num_vf,
 };
 
-#define NSIM_BUS_DEV_MAX_VFS 4
-
 static struct nsim_bus_dev *
 nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queues)
 {
@@ -464,7 +462,6 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queu
 	nsim_bus_dev->port_count = port_count;
 	nsim_bus_dev->num_queues = num_queues;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
-	nsim_bus_dev->max_vfs = NSIM_BUS_DEV_MAX_VFS;
 	/* Disallow using nsim_bus_dev */
 	smp_store_release(&nsim_bus_dev->init, false);
 
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index aed9ad5f1b43..4482f8c5417b 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -225,78 +225,6 @@ static const struct file_operations nsim_dev_trap_fa_cookie_fops = {
 	.owner = THIS_MODULE,
 };
 
-static ssize_t nsim_bus_dev_max_vfs_read(struct file *file, char __user *data,
-					 size_t count, loff_t *ppos)
-{
-	struct nsim_dev *nsim_dev = file->private_data;
-	char buf[11];
-	ssize_t len;
-
-	len = scnprintf(buf, sizeof(buf), "%u\n",
-			READ_ONCE(nsim_dev->nsim_bus_dev->max_vfs));
-
-	return simple_read_from_buffer(data, count, ppos, buf, len);
-}
-
-static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
-					  const char __user *data,
-					  size_t count, loff_t *ppos)
-{
-	struct nsim_vf_config *vfconfigs;
-	struct nsim_dev *nsim_dev;
-	char buf[10];
-	ssize_t ret;
-	u32 val;
-
-	if (*ppos != 0)
-		return 0;
-
-	if (count >= sizeof(buf))
-		return -ENOSPC;
-
-	ret = copy_from_user(buf, data, count);
-	if (ret)
-		return -EFAULT;
-	buf[count] = '\0';
-
-	ret = kstrtouint(buf, 10, &val);
-	if (ret)
-		return -EINVAL;
-
-	/* max_vfs limited by the maximum number of provided port indexes */
-	if (val > NSIM_DEV_VF_PORT_INDEX_MAX - NSIM_DEV_VF_PORT_INDEX_BASE)
-		return -ERANGE;
-
-	vfconfigs = kzalloc_objs(struct nsim_vf_config, val,
-				 GFP_KERNEL | __GFP_NOWARN);
-	if (!vfconfigs)
-		return -ENOMEM;
-
-	nsim_dev = file->private_data;
-	devl_lock(priv_to_devlink(nsim_dev));
-	/* Reject if VFs are configured */
-	if (nsim_dev_get_vfs(nsim_dev)) {
-		ret = -EBUSY;
-	} else {
-		swap(nsim_dev->vfconfigs, vfconfigs);
-		WRITE_ONCE(nsim_dev->nsim_bus_dev->max_vfs, val);
-		*ppos += count;
-		ret = count;
-	}
-	devl_unlock(priv_to_devlink(nsim_dev));
-
-	kfree(vfconfigs);
-	return ret;
-}
-
-static const struct file_operations nsim_dev_max_vfs_fops = {
-	.open = simple_open,
-	.read = nsim_bus_dev_max_vfs_read,
-	.write = nsim_bus_dev_max_vfs_write,
-	.llseek = generic_file_llseek,
-	.owner = THIS_MODULE,
-};
-
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 {
 	char dev_ddir_name[sizeof(DRV_NAME) + 10];
@@ -343,9 +271,6 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	debugfs_create_bool("fail_trap_policer_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_policer_counter_get);
-	/* caution, dev_max_vfs write takes devlink lock */
-	debugfs_create_file("max_vfs", 0600, nsim_dev->ddir,
-			    nsim_dev, &nsim_dev_max_vfs_fops);
 
 	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
 	if (IS_ERR(nsim_dev->nodes_ddir)) {
@@ -1673,7 +1598,7 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
 
 	nsim_dev->vfconfigs = kzalloc_objs(struct nsim_vf_config,
-					   nsim_bus_dev->max_vfs,
+					   NSIM_BUS_DEV_MAX_VFS,
 					   GFP_KERNEL | __GFP_NOWARN);
 	if (!nsim_dev->vfconfigs) {
 		err = -ENOMEM;
@@ -1872,7 +1797,7 @@ int nsim_drv_configure_vfs(struct nsim_bus_dev *nsim_bus_dev,
 		ret = -EBUSY;
 		goto exit_unlock;
 	}
-	if (nsim_bus_dev->max_vfs < num_vfs) {
+	if (num_vfs > NSIM_BUS_DEV_MAX_VFS) {
 		ret = -ENOMEM;
 		goto exit_unlock;
 	}
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 64f77f93d937..a0490d522778 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -472,6 +472,7 @@ nsim_psp_handle_ext(struct sk_buff *skb, struct skb_ext *psp_ext) {}
 int nsim_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		  void *type_data);
 
+#define NSIM_BUS_DEV_MAX_VFS 4
 struct nsim_bus_dev {
 	struct device dev;
 	struct list_head list;
@@ -480,7 +481,6 @@ struct nsim_bus_dev {
 	struct net *initial_net; /* Purpose of this is to carry net pointer
 				  * during the probe time only.
 				  */
-	unsigned int max_vfs;
 	unsigned int num_vfs;
 	bool init;
 };
-- 
2.55.0

