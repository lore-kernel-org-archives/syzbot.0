Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D112C14A
	for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 01:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782522326; cv=none; b=VrX3cWdoGT26m/SyXe5FRZemNTgcrbrA6HvJIFArNvGvw4EkiJqJMaCwBOuF/M9BHznqcjSi8AHl9pZ2fEW/3QmkzD7gMgtyJThTeuwFVkwwNEPfZoUhPVu/aF2cFJsiqbWlW0Dabii6Sqte/zPPvNzrOtptoOME/f572bQoQAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782522326; c=relaxed/simple;
	bh=4GSGGaM5fWr0Bw0H6/RRwpTdRwlfkx6r7Bq9A/LLoYI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=DUhCN6eO8qMCKAwvtluHeyOxqCeGsR0aN7qoC/rkvlBgU+NecULhIIgE9kF3PSa0J/DsC2UeRciBBYbOKzXSAKE9Y66PMJCI9ormIAN2YfQWc3TrfD8Ry7MF+V8FEFYY0fwyENexYAtweVQIn5yYa+eXnL8Kouo45rh8bH6v72s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kbz1JCD3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kbz1JCD3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2198C1F000E9;
	Sat, 27 Jun 2026 01:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782522324;
	bh=OxtwbvOAwUF0HmbVkdRbOv3Pdtr9RNHFwQhkUT0O8ng=;
	h=From:To:Cc:Subject:Date;
	b=Kbz1JCD397HnV1t9siNMo81vFJJ2ZXanoajeHraHPMmKnKrZuUVXSXF0M/NNplU4u
	 5y+D7uYGfiSWBUXprHK9VIfTpsEB3zmDd0uHlYCCtQRFKdbHLU02nuH1uwPhObt/6i
	 lOL/H5mjOl7xByMacHH2ZUdT/ki7ERHDOqMBz/d8eF6/ahv/in0pMogcssK6wKcQDL
	 lrJdrda5B9cEQP/YWhRG098wmsQTlkG375vFl/bfiR1DxcWRDe/FisUTCbQF5T4XZ4
	 u/2P4LpekrwLfsyZQ8wMjtcBMrLMRnFeYRk98RbmAdqCp/edfji63u64OLnTNfhFxP
	 lhPQOHxhHYOjA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] block: fix sync_bdevs() deadlock and lockdep key exhaustion
Message-ID: <66224d90-79db-43d7-b736-c0119326465f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 27 Jun 2026 01:05:24 +0000 (UTC)

An analysis of a hung task panic reveals a userspace-kernel deadlock
involving the block layer's sync_bdevs() and an unresponsive block device
(e.g., NBD).

The execution path leading to the hang is as follows: first, an NBD device
is configured with a client socket, but the server end is deliberately
unresponsive. When the device is configured, udevd receives a KOBJ_CHANGE
uevent and attempts to probe the new device. It calls bdev_open(),
acquiring disk->open_mutex, and submits a read request which hangs
indefinitely due to the unresponsive server. Later, a global sync() is
called, executing sync_bdevs(). This function iterates over all block
devices and attempts to acquire disk->open_mutex for each. When
sync_bdevs() reaches the unresponsive NBD device, it blocks forever waiting
for the open_mutex held by udevd. This hangs the global sync() syscall,
eventually triggering the hung task panic.

Relevant lockdep output showing the deadlock:
1 lock held by udevd/5883:
 -> ffff88818e1fa350 (&disk->open_mutex){+.+.}-{4:4}, at:
 bdev_open+0xde/0xd70 block/bdev.c:953
1 lock held by task/6116:
 -> ffff88818e1f8350 (&disk->open_mutex){+.+.}-{4:4}, at:
 sync_bdevs+0x276/0x470 block/bdev.c:1296

Historically, open_mutex was added in sync_bdevs() by commit af309226db91
("block: protect iterate_bdevs() against concurrent close") to protect
against bdev->bd_disk becoming NULL. However, since commit 22ae8ce8b892
("block: simplify bdev/disk lookup in blkdev_get"), bdev->bd_disk is no
longer set to NULL on close. The gendisk outlives the block_device's inode,
and sync_bdevs() safely holds a reference to the inode. The bd_openers
check is atomic and does not require the mutex. Thus, the open_mutex can be
safely removed from sync_bdevs().

Additionally, creating thousands of NBD devices concurrently triggers a
"MAX_LOCKDEP_KEYS too low!" warning. Since commit f1be1788a32e ("block:
model freeze & enter queue as lock for supporting lockdep"),
blk_alloc_queue() dynamically registers io_lock_cls_key and q_lock_cls_key
for every request queue. Creating >4000 NBD devices exhausts lockdep's hard
limit of 8192 dynamic keys.

To resolve this lockdep exhaustion, we avoid dynamically registering
lockdep keys for every queue. Instead, we pass static lockdep keys from the
macro call sites of blk_alloc_disk(), blk_mq_alloc_disk(), and
blk_mq_alloc_queue(). This allows all queues created by the same driver to
share the same lock class for io_lock and q_lock, avoiding the exhaustion
of MAX_LOCKDEP_KEYS.

Fixes: 22ae8ce8b892 ("block: simplify bdev/disk lookup in blkdev_get")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+97bc0b256218ed6df337@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=97bc0b256218ed6df337
Link: https://syzkaller.appspot.com/ai_job?id=c9d18e22-1915-4593-b948-f528f9bcd781
To: "Andreas Hindborg" <a.hindborg@kernel.org>
To: "Jens Axboe" <axboe@kernel.dk>
To: <linux-block@vger.kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>
To: <rust-for-linux@vger.kernel.org>
Cc: "Alice Ryhl" <aliceryhl@google.com>
Cc: =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: "Boqun Feng" <boqun@kernel.org>
Cc: "Danilo Krummrich" <dakr@kernel.org>
Cc: "Daniel Almeida" <daniel.almeida@collabora.com>
Cc: "Gary Guo" <gary@garyguo.net>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Benno Lossin" <lossin@kernel.org>
Cc: "Trevor Gross" <tmgross@umich.edu>

---
diff --git a/block/bdev.c b/block/bdev.c
index bb0ffa3bb..cbe0af3fa 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1293,7 +1293,6 @@ void sync_bdevs(bool wait)
 		old_inode = inode;
 		bdev = I_BDEV(inode);
 
-		mutex_lock(&bdev->bd_disk->open_mutex);
 		if (!atomic_read(&bdev->bd_openers)) {
 			; /* skip */
 		} else if (wait) {
@@ -1307,7 +1306,6 @@ void sync_bdevs(bool wait)
 		} else {
 			filemap_fdatawrite(inode->i_mapping);
 		}
-		mutex_unlock(&bdev->bd_disk->open_mutex);
 
 		spin_lock(&blockdev_superblock->s_inode_list_lock);
 	}
diff --git a/block/blk-core.c b/block/blk-core.c
index 17450058e..6aedc2baf 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -261,8 +261,6 @@ static void blk_free_queue(struct request_queue *q)
 		blk_mq_release(q);
 
 	ida_free(&blk_queue_ida, q->id);
-	lockdep_unregister_key(&q->io_lock_cls_key);
-	lockdep_unregister_key(&q->q_lock_cls_key);
 	call_rcu(&q->rcu_head, blk_free_queue_rcu);
 }
 
@@ -390,7 +388,9 @@ static void blk_timeout_work(struct work_struct *work)
 {
 }
 
-struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id)
+struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id,
+				      struct lock_class_key *io_key,
+				      struct lock_class_key *q_key)
 {
 	struct request_queue *q;
 	int error;
@@ -449,12 +449,10 @@ struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id)
 				PERCPU_REF_INIT_ATOMIC, GFP_KERNEL);
 	if (error)
 		goto fail_stats;
-	lockdep_register_key(&q->io_lock_cls_key);
-	lockdep_register_key(&q->q_lock_cls_key);
-	lockdep_init_map(&q->io_lockdep_map, "&q->q_usage_counter(io)",
-			 &q->io_lock_cls_key, 0);
-	lockdep_init_map(&q->q_lockdep_map, "&q->q_usage_counter(queue)",
-			 &q->q_lock_cls_key, 0);
+	lockdep_init_map(&q->io_lockdep_map, "&q->q_usage_counter(io)", io_key,
+			 0);
+	lockdep_init_map(&q->q_lockdep_map, "&q->q_usage_counter(queue)", q_key,
+			 0);
 
 	/* Teach lockdep about lock ordering (reclaim WRT queue freeze lock). */
 	fs_reclaim_acquire(GFP_KERNEL);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a24175441..020345d6b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4437,8 +4437,11 @@ void blk_mq_release(struct request_queue *q)
 	blk_mq_sysfs_deinit(q);
 }
 
-struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
-		struct queue_limits *lim, void *queuedata)
+struct request_queue *__blk_mq_alloc_queue(struct blk_mq_tag_set *set,
+					   struct queue_limits *lim,
+					   void *queuedata,
+					   struct lock_class_key *io_key,
+					   struct lock_class_key *q_key)
 {
 	struct queue_limits default_lim = { };
 	struct request_queue *q;
@@ -4450,7 +4453,7 @@ struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
 	if (set->nr_maps > HCTX_TYPE_POLL)
 		lim->features |= BLK_FEAT_POLL;
 
-	q = blk_alloc_queue(lim, set->numa_node);
+	q = blk_alloc_queue(lim, set->numa_node, io_key, q_key);
 	if (IS_ERR(q))
 		return q;
 	q->queuedata = queuedata;
@@ -4461,7 +4464,7 @@ struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
 	}
 	return q;
 }
-EXPORT_SYMBOL(blk_mq_alloc_queue);
+EXPORT_SYMBOL(__blk_mq_alloc_queue);
 
 /**
  * blk_mq_destroy_queue - shutdown a request queue
@@ -4491,13 +4494,15 @@ void blk_mq_destroy_queue(struct request_queue *q)
 EXPORT_SYMBOL(blk_mq_destroy_queue);
 
 struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set,
-		struct queue_limits *lim, void *queuedata,
-		struct lock_class_key *lkclass)
+				    struct queue_limits *lim, void *queuedata,
+				    struct lock_class_key *lkclass,
+				    struct lock_class_key *io_key,
+				    struct lock_class_key *q_key)
 {
 	struct request_queue *q;
 	struct gendisk *disk;
 
-	q = blk_mq_alloc_queue(set, lim, queuedata);
+	q = __blk_mq_alloc_queue(set, lim, queuedata, io_key, q_key);
 	if (IS_ERR(q))
 		return ERR_CAST(q);
 
diff --git a/block/blk.h b/block/blk.h
index b998a7761..271a89adf 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -615,7 +615,9 @@ void bdev_set_nr_sectors(struct block_device *bdev, sector_t sectors);
 
 struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 		struct lock_class_key *lkclass);
-struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id);
+struct request_queue *blk_alloc_queue(struct queue_limits *lim, int node_id,
+				      struct lock_class_key *io_key,
+				      struct lock_class_key *q_key);
 
 int disk_scan_partitions(struct gendisk *disk, blk_mode_t mode);
 
diff --git a/block/genhd.c b/block/genhd.c
index 7d6854fd2..6ef999f6a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1506,13 +1506,15 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 }
 
 struct gendisk *__blk_alloc_disk(struct queue_limits *lim, int node,
-		struct lock_class_key *lkclass)
+				 struct lock_class_key *lkclass,
+				 struct lock_class_key *io_key,
+				 struct lock_class_key *q_key)
 {
 	struct queue_limits default_lim = { };
 	struct request_queue *q;
 	struct gendisk *disk;
 
-	q = blk_alloc_queue(lim ? lim : &default_lim, node);
+	q = blk_alloc_queue(lim ? lim : &default_lim, node, io_key, q_key);
 	if (IS_ERR(q))
 		return ERR_CAST(q);
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 18a2388ba..b79c88740 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -725,18 +725,34 @@ enum {
 };
 
 struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set,
-		struct queue_limits *lim, void *queuedata,
-		struct lock_class_key *lkclass);
-#define blk_mq_alloc_disk(set, lim, queuedata)				\
-({									\
-	static struct lock_class_key __key;				\
-									\
-	__blk_mq_alloc_disk(set, lim, queuedata, &__key);		\
-})
+				    struct queue_limits *lim, void *queuedata,
+				    struct lock_class_key *lkclass,
+				    struct lock_class_key *io_key,
+				    struct lock_class_key *q_key);
+#define blk_mq_alloc_disk(set, lim, queuedata)                              \
+	({                                                                  \
+		static struct lock_class_key __key;                         \
+		static struct lock_class_key __io_key;                      \
+		static struct lock_class_key __q_key;                       \
+                                                                            \
+		__blk_mq_alloc_disk(set, lim, queuedata, &__key, &__io_key, \
+				    &__q_key);                              \
+	})
 struct gendisk *blk_mq_alloc_disk_for_queue(struct request_queue *q,
 		struct lock_class_key *lkclass);
-struct request_queue *blk_mq_alloc_queue(struct blk_mq_tag_set *set,
-		struct queue_limits *lim, void *queuedata);
+struct request_queue *__blk_mq_alloc_queue(struct blk_mq_tag_set *set,
+					   struct queue_limits *lim,
+					   void *queuedata,
+					   struct lock_class_key *io_key,
+					   struct lock_class_key *q_key);
+#define blk_mq_alloc_queue(set, lim, queuedata)                      \
+	({                                                           \
+		static struct lock_class_key __io_key;               \
+		static struct lock_class_key __q_key;                \
+                                                                     \
+		__blk_mq_alloc_queue(set, lim, queuedata, &__io_key, \
+				     &__q_key);                      \
+	})
 int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 		struct request_queue *q);
 void blk_mq_destroy_queue(struct request_queue *);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 890128cde..00cb759ca 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -511,10 +511,8 @@ struct request_queue {
 	struct blk_mq_hw_ctx * __rcu *queue_hw_ctx __counted_by_ptr(nr_hw_queues);
 
 	struct percpu_ref	q_usage_counter;
-	struct lock_class_key	io_lock_cls_key;
 	struct lockdep_map	io_lockdep_map;
 
-	struct lock_class_key	q_lock_cls_key;
 	struct lockdep_map	q_lockdep_map;
 
 	struct request		*last_merge;
@@ -974,7 +972,9 @@ int bdev_disk_changed(struct gendisk *disk, bool invalidate);
 
 void put_disk(struct gendisk *disk);
 struct gendisk *__blk_alloc_disk(struct queue_limits *lim, int node,
-		struct lock_class_key *lkclass);
+				 struct lock_class_key *lkclass,
+				 struct lock_class_key *io_key,
+				 struct lock_class_key *q_key);
 
 /**
  * blk_alloc_disk - allocate a gendisk structure
@@ -988,12 +988,14 @@ struct gendisk *__blk_alloc_disk(struct queue_limits *lim, int node,
  *
  * Context: can sleep
  */
-#define blk_alloc_disk(lim, node_id)					\
-({									\
-	static struct lock_class_key __key;				\
-									\
-	__blk_alloc_disk(lim, node_id, &__key);				\
-})
+#define blk_alloc_disk(lim, node_id)                                         \
+	({                                                                   \
+		static struct lock_class_key __key;                          \
+		static struct lock_class_key __io_key;                       \
+		static struct lock_class_key __q_key;                        \
+                                                                             \
+		__blk_alloc_disk(lim, node_id, &__key, &__io_key, &__q_key); \
+	})
 
 int __register_blkdev(unsigned int major, const char *name,
 		void (*probe)(dev_t devt));
diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 912cb805c..d0b012c35 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -122,6 +122,8 @@ pub fn build<T: Operations>(
                 &mut lim,
                 data,
                 static_lock_class!().as_ptr(),
+                static_lock_class!().as_ptr(),
+                static_lock_class!().as_ptr(),
             )
         })?;
 


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
