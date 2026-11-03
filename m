Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793742232;
	b=f3RzP2Sx9y2/qZGeOxoDn63yzAjSyUsOzw67C2FEF83GxBtR9PnhPkt82c1u9P+HKa19
	 sEf/eUv55npJuOcvc4lDaFFNdObQJNOwx5KufxtNdDYZtgpSZ4APjL2SnzOmCWmZAZoEb
	 cUITNzFqGp36CYPtncDwujs3YnNLuGPZTndrpfxH2djuqXHiNIQQWtRUDre67ZzdxJcb4
	 k8ZT2P/Qi5qBKHExwQcYOcfE0c66ydKAa0I0JhUUi5pxYR6LE42AerXeNJTsvOnpOivtp
	 U42vqWjX3EDiBLAbNwyp03lMm/lB4ZEftDbn8Y48hBqSRBCl8Lqc4+RBhCWW/gjJJ8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793742232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=LvdZWVpaWuUhgg1vkmg/bCURAbnQK/+nQia+4t1gAiA=;
	b=PDWl6k1PW7JUf2wFChl0WkK7+IL3OgLpD6YxED63gySgO8YLdp+xuXZPCF9cfYCT7DMh
	 lnkGU9zT6Xq0T1d93facw2mQ3mBUtBJ81tpqzi+bPKTgqEgeIjyd2Nje+75Dha0ZDVUtw
	 AHxGDlHCzRjA+vhUoB89Mg/a4s9G6xg0MsRd6SHhqglPdcUplrVEmPhn8eE3OKQvC5bfy
	 Dh91fK6d0Dp2UFMUtfT4aqLeR5K4L2xjaXp+qfnMax4T2OihelsrAihWKfGJ5vrbvBKlz
	 b+kMqb1eK89DF0ehDr9sbAKmR0XmsoO2a1DUEsPnUztwr8SIQMqlNmo4Y8Wrd5qjUSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m4b+oEPu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 51E34606EEB9
	for <syzbot@lists.linux.dev>; Tue,  3 Nov 2026 21:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m4b+oEPu
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ECAA71F00A15;
	Tue,  3 Nov 2026 21:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793742232;
	bh=LvdZWVpaWuUhgg1vkmg/bCURAbnQK/+nQia+4t1gAiA=;
	h=From:To:Cc:Subject:Date;
	b=m4b+oEPuJ9XuPcRjhG8tukkHfPnFa0CI9dWtOQiPq237TGtB/oJHO0bIgQqF4H8Ca
	 ORAzGrO87TlZMDN/tbnkqO9AHxbvy/DbJ0GliS7Y2wc82VNaxBaELAZcmcz1dEf5BE
	 7AeRVr9n0teJ6vtbgq373B4qaGtkPGmZKds9Gv6CjqPu9LUeS/r0nflAFoVANohG7G
	 QCTViArK/82jzvXW7b7xBdq/KcXBdt+1YlhDb4q1ejoAfBo1t5sFWIuh9852YuEXOS
	 Ec3CVSrvXCOIxn01moFKuGAw9qXJ6EQr4NPyXuR4ZVrob2QQTe3HsV8fEIbGtpJK8o
	 drY5/W7RWFHOQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] dm: fix use-after-free when upgrading device access mode
Message-ID: <02bb631b-9504-41c5-82ad-d85b3793f594@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  3 Nov 2026 21:43:51 +0000 (UTC)

In Device Mapper tables, struct dm_dev_internal held a direct pointer
dd->dm_dev pointing to the struct dm_dev embedded inside a
per-mapped-device struct table_device. When a device was opened more than
once within the same dm_table with a mode requiring an upgrade (for
instance, opened read-only and later opened read-write), dm_get_device()
invoked upgrade_mode(). In upgrade_mode(), dm_get_table_device() allocated
or found a new struct table_device (new_dev), replaced dd->dm_dev with
new_dev, and immediately freed the old struct table_device via
dm_put_table_device(md, old_dev).

However, upgrade_mode() is only reached when dd already exists in the
table's device list (dd->count >= 1), meaning an earlier caller or target
in the table still holds a pointer to old_dev. Freeing old_dev leaves the
earlier caller with a dangling pointer. When that caller subsequently
cleans up via dm_put_device(ti, old_dev), dm_put_device() searches for
dd->dm_dev == d. Because dd->dm_dev was overwritten with new_dev, the
lookup fails to match, prompting an error message that reads d->name from
the freed table_device and triggering a slab-use-after-free:

BUG: KASAN: slab-use-after-free in string_nocheck lib/vsprintf.c:650
[inline]
BUG: KASAN: slab-use-after-free in string+0x216/0x2d0 lib/vsprintf.c:732
Read of size 1 at addr ffff888186f917b4

Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 string_nocheck lib/vsprintf.c:650 [inline]
 string+0x216/0x2d0 lib/vsprintf.c:732
 vsnprintf+0x74a/0xef0 lib/vsprintf.c:2948
 _printk+0xdd/0x130 kernel/printk/printk.c:2504
 pool_ctr+0x752/0xd60 drivers/md/dm-thin.c:3431
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Allocated by task:
 open_table_device drivers/md/dm.c:733 [inline]
 dm_get_table_device+0x23e/0x730 drivers/md/dm.c:821
 dm_get_device+0x327/0x760 drivers/md/dm-table.c:388
 pool_ctr+0x4ae/0xd60 drivers/md/dm-thin.c:3329
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task:
 close_table_device drivers/md/dm.c:798 [inline]
 dm_put_table_device+0x255/0x2a0 drivers/md/dm.c:841
 upgrade_mode drivers/md/dm-table.c:326 [inline]
 dm_get_device+0x56f/0x760 drivers/md/dm-table.c:399
 pool_ctr+0x585/0xd60 drivers/md/dm-thin.c:3336
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Furthermore, because the lookup failed, dm_put_device() returned early
without decrementing dd->count, leaking dd and new_dev.

This issue could be reproduced via dm-thin targets because pool_ctr() and
thin_ctr() relied on strcmp() checks (e.g., !strcmp(argv[0], argv[1])) to
ensure conflicting devices were not specified. These string checks are
easily bypassed when the same underlying block device is passed using
different string representations (such as a device path "/dev/ram1" vs.
major:minor "1:1" or symlinks). When creating a thin pool in read-only
mode, pool_ctr() opened the metadata device as BLK_OPEN_READ and the data
device as BLK_OPEN_READ | BLK_OPEN_WRITE. Bypassing the string check caused
dm_get_device() to invoke upgrade_mode() on the shared dev_t, freeing the
metadata device structure while pool_ctr() still held it.

Fix this by:
1. Embedding struct dm_dev dm_dev by value into struct dm_dev_internal and
adding a table_dev pointer to track the underlying struct table_device.
Callers of dm_get_device() receive &dd->dm_dev, ensuring a stable pointer
lifetime within the table. In upgrade_mode(), switch dd->table_dev to
new_dev while updating dd->dm_dev.mode and dd->dm_dev.bdev_file in-place.
2. In dm_put_device(), match against &dd->dm_dev == d and release
dd->table_dev when the reference count drops to zero.
3. In dm-thin, replace the fragile strcmp() checks in pool_ctr() and
thin_ctr() with checks comparing the opened block devices
(metadata_dev->bdev == data_dev->bdev and tc->origin_dev->bdev ==
tc->pool_dev->bdev) so that identical underlying devices are rejected
regardless of how their paths are specified.

Fixes: 86f1152b117a ("dm: allow active and inactive tables to share dm_devs")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+9519233e6d144970bbc2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9519233e6d144970bbc2
Link: https://syzkaller.appspot.com/ai_job?id=b87c5628-c40e-46ad-909b-3df7926caa9a
To: "Alasdair Kergon" <agk@redhat.com>
To: "Benjamin Marzinski" <bmarzins@redhat.com>
To: <dm-devel@lists.linux.dev>
To: "Mikulas Patocka" <mpatocka@redhat.com>
To: "Mike Snitzer" <snitzer@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 8f945f0ae..2147f6220 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1794,7 +1794,7 @@ static void retrieve_deps(struct dm_table *table,
 	deps->count = count;
 	count = 0;
 	list_for_each_entry(dd, dm_table_get_devices(table), list)
-		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
+		deps->dev[count++] = huge_encode_dev(dd->dm_dev.bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
 }
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a483f49dd..1753bee01 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -171,8 +171,8 @@ static void free_devices(struct list_head *devices, struct mapped_device *md)
 		struct dm_dev_internal *dd =
 		    list_entry(tmp, struct dm_dev_internal, list);
 		DMWARN("%s: dm_table_destroy: dm_put_device call missing for %s",
-		       dm_device_name(md), dd->dm_dev->name);
-		dm_put_table_device(md, dd->dm_dev);
+		       dm_device_name(md), dd->dm_dev.name);
+		dm_put_table_device(md, dd->table_dev);
 		kfree(dd);
 	}
 }
@@ -218,7 +218,7 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry(dd, l, list)
-		if (dd->dm_dev->bdev->bd_dev == dev)
+		if (dd->dm_dev.bdev->bd_dev == dev)
 			return dd;
 
 	return NULL;
@@ -315,14 +315,16 @@ static int upgrade_mode(struct dm_dev_internal *dd, blk_mode_t new_mode,
 	int r;
 	struct dm_dev *old_dev, *new_dev;
 
-	old_dev = dd->dm_dev;
+	old_dev = dd->table_dev;
 
-	r = dm_get_table_device(md, dd->dm_dev->bdev->bd_dev,
-				dd->dm_dev->mode | new_mode, &new_dev);
+	r = dm_get_table_device(md, dd->dm_dev.bdev->bd_dev,
+				dd->dm_dev.mode | new_mode, &new_dev);
 	if (r)
 		return r;
 
-	dd->dm_dev = new_dev;
+	dd->table_dev = new_dev;
+	dd->dm_dev.mode |= new_mode;
+	dd->dm_dev.bdev_file = new_dev->bdev_file;
 	dm_put_table_device(md, old_dev);
 
 	return 0;
@@ -385,24 +387,25 @@ int dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
 		if (!dd)
 			return -ENOMEM;
 
-		r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev);
+		r = dm_get_table_device(t->md, dev, mode, &dd->table_dev);
 		if (r) {
 			kfree(dd);
 			return r;
 		}
 
+		dd->dm_dev = *dd->table_dev;
 		refcount_set(&dd->count, 1);
 		list_add(&dd->list, &t->devices);
 		goto out;
 
-	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
+	} else if (dd->dm_dev.mode != (mode | dd->dm_dev.mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
 			return r;
 	}
 	refcount_inc(&dd->count);
 out:
-	*result = dd->dm_dev;
+	*result = &dd->dm_dev;
 	return 0;
 }
 EXPORT_SYMBOL(dm_get_device);
@@ -458,7 +461,7 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry(dd, devices, list) {
-		if (dd->dm_dev == d) {
+		if (&dd->dm_dev == d) {
 			found = 1;
 			break;
 		}
@@ -469,7 +472,7 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 		return;
 	}
 	if (refcount_dec_and_test(&dd->count)) {
-		dm_put_table_device(ti->table->md, d);
+		dm_put_table_device(ti->table->md, dd->table_dev);
 		list_del(&dd->list);
 		kfree(dd);
 	}
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 358ed77ff..9ee45dc02 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3307,13 +3307,6 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	as.argc = argc;
 	as.argv = argv;
 
-	/* make sure metadata and data are different devices */
-	if (!strcmp(argv[0], argv[1])) {
-		ti->error = "Error setting metadata or data device";
-		r = -EINVAL;
-		goto out_unlock;
-	}
-
 	/*
 	 * Set default pool features.
 	 */
@@ -3331,7 +3324,6 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Error opening metadata block device";
 		goto out_unlock;
 	}
-	warn_if_metadata_device_too_big(metadata_dev->bdev);
 
 	r = dm_get_device(ti, argv[1], BLK_OPEN_READ | BLK_OPEN_WRITE, &data_dev);
 	if (r) {
@@ -3339,6 +3331,14 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto out_metadata;
 	}
 
+	/* make sure metadata and data are different devices */
+	if (metadata_dev->bdev == data_dev->bdev) {
+		ti->error = "Error setting metadata or data device";
+		r = -EINVAL;
+		goto out;
+	}
+	warn_if_metadata_device_too_big(metadata_dev->bdev);
+
 	if (kstrtoul(argv[2], 10, &block_size) || !block_size ||
 	    block_size < DATA_DEV_BLOCK_SIZE_MIN_SECTORS ||
 	    block_size > DATA_DEV_BLOCK_SIZE_MAX_SECTORS ||
@@ -4204,12 +4204,6 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	tc->sort_bio_list = RB_ROOT;
 
 	if (argc == 3) {
-		if (!strcmp(argv[0], argv[2])) {
-			ti->error = "Error setting origin device";
-			r = -EINVAL;
-			goto bad_origin_dev;
-		}
-
 		r = dm_get_device(ti, argv[2], BLK_OPEN_READ, &origin_dev);
 		if (r) {
 			ti->error = "Error opening origin device";
@@ -4225,6 +4219,12 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	tc->pool_dev = pool_dev;
 
+	if (tc->origin_dev && tc->origin_dev->bdev == tc->pool_dev->bdev) {
+		ti->error = "Error setting origin device";
+		r = -EINVAL;
+		goto bad_common;
+	}
+
 	if (read_dev_id(argv[1], (unsigned long long *)&tc->dev_id, 0)) {
 		ti->error = "Invalid device id";
 		r = -EINVAL;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1881d8611..575979168 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1588,7 +1588,7 @@ static void __send_empty_flush(struct clone_info *ci)
 			 */
 			clone = alloc_tio(ci, NULL, 0, &len, GFP_NOIO);
 			atomic_add(1, &ci->io->io_count);
-			bio_set_dev(clone, dd->dm_dev->bdev);
+			bio_set_dev(clone, dd->dm_dev.bdev);
 			clone->bi_end_io = clone_endio;
 			dm_submit_bio_remap(clone, NULL);
 		}
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 7a795979e..eaf05816c 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -41,7 +41,8 @@
 struct dm_dev_internal {
 	struct list_head list;
 	refcount_t count;
-	struct dm_dev *dm_dev;
+	struct dm_dev dm_dev;
+	struct dm_dev *table_dev;
 };
 
 struct dm_table;


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
