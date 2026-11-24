Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795543575;
	b=gQURQ43JotlEue66HhH32S8gtYWdT4XV7y1WNGVgtiCsKh91I70quxpzPDYZL5tLzDsh
	 IiDFo58+Q8jzbF8pNPHfm7G9jVuD88/NbKoF3jU0EcsfzMp35LKPsYysFHDKUk9/oP/Ta
	 eo1hghdxogxLvJb9nOzy9VdhpfACCCix+AY+Qj8zbfhF/E3zWzevGzLAOPZJkNm6z3R2N
	 PV8j/BuK5aEVom4ffL2OiNw8sMT89gOteJ+iN3E4BvSyTf7YWq7+abdhuou3jnIfj3tUy
	 8kwCB5lnHLGlI2tZ2yhmrk0OCaBcoi/ubdOEulb+afqpFFpZUdIeAdIfYqgV8oE6NDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795543575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=bB4zAJ3tizv0LFDqImNvtLJsWCUH2Tdufp1h3dmcb4I=;
	b=QWvPGV9VueSJAW0Ld1iMtS4YQXDXfTmWEwTjONX3Z0Vk7hAKgNGoOMRZ8wcEtH9SDFi5
	 o3Sre4UeQSR4MWibL8PfLFA9JQO8+TBnMXyBerD3YrrP/4L/kBtdV/4D6SfEFGLgJBTMv
	 O/rPQerM06OKCN53JLlzxtZqLTq/skdp/T26T5n4haE2AMzWXMeaNHHA+Puli0rIl/80y
	 Ua6U8c/GeQEBOYW80C0TacxUobgQxOSpV75n0+9IqfFzY9CMSH4taNvZ2u4G2RvlH5kX0
	 7u4vdtxKHL586bQi5A89W1b1fDG/bS+/+sDzeolKsxPyb3UUQMFHhObi+MpyFEG0A5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZI9punzE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3AC9A606A33B
	for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZI9punzE
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 437761F000C6;
	Tue, 24 Nov 2026 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795543574;
	bh=bB4zAJ3tizv0LFDqImNvtLJsWCUH2Tdufp1h3dmcb4I=;
	h=From:To:Cc:Subject:Date;
	b=ZI9punzEpc3BeVDkTwxBPGWHUxtKRjVqwDqVa9MujRmutaFin5ZUo18N7tgnA6j3C
	 GMrzcwI/koZKLe5+hR0BREWZMXtZ1DYMCalKIEqU+rrQPbj9yAR6bP5bzBIZRYrXGL
	 YuCDpeVGZIWHzp1eBetfT072ZeT1DlrYGxWCTKV0hrWUDldLC6kEGixfKfAiYeuQgL
	 ic8BMezIKjR2VeOwqpKTgSKSKICMdkhxOG9RTeZ8MZ7Dsy0iXA2HCKWyINPKwhFbsh
	 O3Lidpr9wiiVcY21SvW9Nl71eaeofAj+a9zy5Hsq70VEtdDuKjc+IIRYWhbnrPxGMB
	 mPb59Fjq65edw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] block: fix race in queue freeze lockdep tracking
Message-ID: <26b8e0d5-ee3e-4c15-8a1b-0e76ccecc501@mail.kernel.org>
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
Date: Tue, 24 Nov 2026 18:06:14 +0000 (UTC)

Under CONFIG_LOCKDEP, blk_freeze_set_owner() records q->mq_freeze_disk_dead
and q->mq_freeze_queue_dying under q->mq_freeze_lock when
q->mq_freeze_depth is 0, while blk_freeze_acquire_lock() and
blk_unfreeze_release_lock() read those fields outside q->mq_freeze_lock. In
__blk_mq_unfreeze_queue(), q->mq_freeze_depth is decremented to 0,
q->mq_freeze_owner is cleared, and q->mq_freeze_lock is unlocked before
blk_mq_unfreeze_queue_nomemrestore() or __del_gendisk() calls
blk_unfreeze_release_lock(). A concurrent queue freeze in that window can
observe !q->mq_freeze_depth and overwrite q->mq_freeze_disk_dead and
q->mq_freeze_queue_dying before the unfreezing task reads them. If those
flags change from false to true, rwsem_release() is skipped and the lockdep
maps remain leaked in current->held_locks after the queue is already
unfrozen; if they change from true to false, an unacquired lockdep map is
released.

For example, during device-mapper setup (DM_TABLE_LOAD ->
dm_setup_md_queue() -> add_disk() -> blk_register_queue() ->
wbt_init_enable_default() -> wbt_init() -> rq_qos_add()),
blk_mq_freeze_queue() acquires both &q->io_lockdep_map and
&q->q_lockdep_map, and rq_qos_add() then calls blk_mq_unfreeze_queue(). If
a concurrent DM_DEV_REMOVE runs dm_destroy() -> blk_mark_disk_dead() ->
blk_queue_start_drain() -> __blk_freeze_queue_start() after
__blk_mq_unfreeze_queue() drops q->mq_freeze_lock but before
blk_unfreeze_release_lock() runs, it overwrites q->mq_freeze_disk_dead and
q->mq_freeze_queue_dying to true. The first task then skips releasing both
lockdep maps and proceeds to blk_debugfs_lock() in
wbt_init_enable_default(), triggering a false-positive lockdep circular
locking dependency warning (or, on other paths such as elevator_change(), a
warning about returning to user space with a lock still held):

  WARNING: possible circular locking dependency detected
  task is trying to acquire lock:
  ffff88811dff7868 (&q->debugfs_mutex){+.+.}-{4:4}, at:
  wbt_init_enable_default+0x146/0x220
  but task is already holding lock:
  ffff88811dff7020 (&q->q_usage_counter(io)#215){++++}-{0:0}, at:
  rq_qos_add+0x15b/0x370
  Chain exists of:
    &q->debugfs_mutex --> fs_reclaim --> &q->q_usage_counter(io)#215

  WARNING: lock held when returning to user space!
   #0: ffff8881899d2f28 (&q->q_usage_counter(queue)#55){+.+.}-{0:0}, at:
   elevator_change+0x194/0x480

Fix this by replacing q->mq_freeze_disk_dead and q->mq_freeze_queue_dying
with a bitmask q->mq_freeze_lock_mask using BLK_FREEZE_LOCK_IO and
BLK_FREEZE_LOCK_QUEUE, and passing that bitmask by value out of the
q->mq_freeze_lock critical sections. In blk_freeze_set_owner(), if the
computed mask is 0 (disk dead or unregistered, and queue dying), return 0
without claiming q->mq_freeze_owner. In blk_unfreeze_check_owner(), copy
and clear q->mq_freeze_lock_mask along with q->mq_freeze_owner before
releasing q->mq_freeze_lock. Propagate the explicit owner and returned
local mask across __blk_freeze_queue_start(), blk_queue_start_drain(),
__blk_mq_unfreeze_queue(), __blk_mark_disk_dead(), and __del_gendisk(), and
pass the local mask directly to blk_freeze_acquire_lock() and
blk_unfreeze_release_lock() so no lockdep freeze state on struct
request_queue is read outside q->mq_freeze_lock.

Fixes: 6f491a8d4b92 ("block: track disk DEAD state automatically for modeling queue freeze lockdep")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon syzbot
Reported-by: syzbot+e2e1def00b1be94f0a22@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e2e1def00b1be94f0a22
Link: https://syzkaller.appspot.com/ai_job?id=128d9d0d-74a9-4272-a7bc-c572b13cc220
To: "Jens Axboe" <axboe@kernel.dk>
To: <linux-block@vger.kernel.org>
To: "Ming Lei" <ming.lei@redhat.com>

---
diff --git a/block/blk-core.c b/block/blk-core.c
index 2ee079c1c..8cd868574 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -322,20 +322,22 @@ void blk_put_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_put_queue);
 
-bool blk_queue_start_drain(struct request_queue *q)
+unsigned int blk_queue_start_drain(struct request_queue *q,
+				   struct task_struct *owner)
 {
 	/*
 	 * When queue DYING flag is set, we need to block new req
 	 * entering queue, so we call blk_freeze_queue_start() to
 	 * prevent I/O from crossing blk_queue_enter().
 	 */
-	bool freeze = __blk_freeze_queue_start(q, current);
+	unsigned int lock_mask = __blk_freeze_queue_start(q, owner);
+
 	if (queue_is_mq(q))
 		blk_mq_wake_waiters(q);
 	/* Make blk_queue_enter() reexamine the DYING flag. */
 	wake_up_all(&q->mq_freeze_wq);
 
-	return freeze;
+	return lock_mask;
 }
 
 /**
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 54ccfc43c..e0c0ed365 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -113,60 +113,72 @@ void blk_mq_in_driver_rw(struct block_device *part, unsigned int inflight[2])
 }
 
 #ifdef CONFIG_LOCKDEP
-static bool blk_freeze_set_owner(struct request_queue *q,
-				 struct task_struct *owner)
+static unsigned int blk_freeze_set_owner(struct request_queue *q,
+					 struct task_struct *owner)
 {
 	if (!owner)
-		return false;
+		return 0;
 
 	if (!q->mq_freeze_depth) {
+		unsigned int mask = 0;
+
+		if (q->disk && !test_bit(GD_DEAD, &q->disk->state) &&
+		    blk_queue_registered(q))
+			mask |= BLK_FREEZE_LOCK_IO;
+		if (!blk_queue_dying(q))
+			mask |= BLK_FREEZE_LOCK_QUEUE;
+		if (!mask)
+			return 0;
+
 		q->mq_freeze_owner = owner;
 		q->mq_freeze_owner_depth = 1;
-		q->mq_freeze_disk_dead = !q->disk ||
-			test_bit(GD_DEAD, &q->disk->state) ||
-			!blk_queue_registered(q);
-		q->mq_freeze_queue_dying = blk_queue_dying(q);
-		return true;
+		q->mq_freeze_lock_mask = mask;
+		return mask;
 	}
 
 	if (owner == q->mq_freeze_owner)
 		q->mq_freeze_owner_depth += 1;
-	return false;
+	return 0;
 }
 
 /* verify the last unfreeze in owner context */
-static bool blk_unfreeze_check_owner(struct request_queue *q)
+static unsigned int blk_unfreeze_check_owner(struct request_queue *q,
+					     struct task_struct *owner)
 {
-	if (q->mq_freeze_owner != current)
-		return false;
+	if (!owner || q->mq_freeze_owner != owner)
+		return 0;
 	if (--q->mq_freeze_owner_depth == 0) {
+		unsigned int mask = q->mq_freeze_lock_mask;
+
 		q->mq_freeze_owner = NULL;
-		return true;
+		q->mq_freeze_lock_mask = 0;
+		return mask;
 	}
-	return false;
+	return 0;
 }
 
 #else
 
-static bool blk_freeze_set_owner(struct request_queue *q,
-				 struct task_struct *owner)
+static unsigned int blk_freeze_set_owner(struct request_queue *q,
+					 struct task_struct *owner)
 {
-	return false;
+	return 0;
 }
 
-static bool blk_unfreeze_check_owner(struct request_queue *q)
+static unsigned int blk_unfreeze_check_owner(struct request_queue *q,
+					     struct task_struct *owner)
 {
-	return false;
+	return 0;
 }
 #endif
 
-bool __blk_freeze_queue_start(struct request_queue *q,
-			      struct task_struct *owner)
+unsigned int __blk_freeze_queue_start(struct request_queue *q,
+				      struct task_struct *owner)
 {
-	bool freeze;
+	unsigned int lock_mask;
 
 	mutex_lock(&q->mq_freeze_lock);
-	freeze = blk_freeze_set_owner(q, owner);
+	lock_mask = blk_freeze_set_owner(q, owner);
 	if (++q->mq_freeze_depth == 1) {
 		percpu_ref_kill(&q->q_usage_counter);
 		mutex_unlock(&q->mq_freeze_lock);
@@ -176,13 +188,14 @@ bool __blk_freeze_queue_start(struct request_queue *q,
 		mutex_unlock(&q->mq_freeze_lock);
 	}
 
-	return freeze;
+	return lock_mask;
 }
 
 void blk_freeze_queue_start(struct request_queue *q)
 {
-	if (__blk_freeze_queue_start(q, current))
-		blk_freeze_acquire_lock(q);
+	unsigned int lock_mask = __blk_freeze_queue_start(q, current);
+
+	blk_freeze_acquire_lock(q, lock_mask);
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
 
@@ -208,9 +221,10 @@ void blk_mq_freeze_queue_nomemsave(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_nomemsave);
 
-bool __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic)
+unsigned int __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic,
+				     struct task_struct *owner)
 {
-	bool unfreeze;
+	unsigned int lock_mask;
 
 	mutex_lock(&q->mq_freeze_lock);
 	if (force_atomic)
@@ -221,16 +235,17 @@ bool __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic)
 		percpu_ref_resurrect(&q->q_usage_counter);
 		wake_up_all(&q->mq_freeze_wq);
 	}
-	unfreeze = blk_unfreeze_check_owner(q);
+	lock_mask = blk_unfreeze_check_owner(q, owner);
 	mutex_unlock(&q->mq_freeze_lock);
 
-	return unfreeze;
+	return lock_mask;
 }
 
 void blk_mq_unfreeze_queue_nomemrestore(struct request_queue *q)
 {
-	if (__blk_mq_unfreeze_queue(q, false))
-		blk_unfreeze_release_lock(q);
+	unsigned int lock_mask = __blk_mq_unfreeze_queue(q, false, current);
+
+	blk_unfreeze_release_lock(q, lock_mask);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue_nomemrestore);
 
@@ -250,7 +265,7 @@ EXPORT_SYMBOL_GPL(blk_freeze_queue_start_non_owner);
 /* non_owner variant of blk_mq_unfreeze_queue */
 void blk_mq_unfreeze_queue_non_owner(struct request_queue *q)
 {
-	__blk_mq_unfreeze_queue(q, false);
+	__blk_mq_unfreeze_queue(q, false, NULL);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue_non_owner);
 
@@ -4499,7 +4514,7 @@ void blk_mq_destroy_queue(struct request_queue *q)
 	might_sleep();
 
 	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
-	blk_queue_start_drain(q);
+	blk_queue_start_drain(q, NULL);
 	blk_mq_freeze_queue_wait(q);
 
 	blk_sync_queue(q);
diff --git a/block/blk.h b/block/blk.h
index 105fff157..7d52051ae 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -55,10 +55,16 @@ const char *blk_status_to_tag(blk_status_t status);
 bool tag_to_blk_status(const char *tag, blk_status_t *status);
 enum req_op str_to_blk_op(const char *op);
 
-bool __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic);
-bool blk_queue_start_drain(struct request_queue *q);
-bool __blk_freeze_queue_start(struct request_queue *q,
-			      struct task_struct *owner);
+#define BLK_FREEZE_LOCK_IO	BIT(0)
+#define BLK_FREEZE_LOCK_QUEUE	BIT(1)
+
+unsigned int __blk_mq_unfreeze_queue(struct request_queue *q,
+				     bool force_atomic,
+				     struct task_struct *owner);
+unsigned int blk_queue_start_drain(struct request_queue *q,
+				   struct task_struct *owner);
+unsigned int __blk_freeze_queue_start(struct request_queue *q,
+				      struct task_struct *owner);
 int __bio_queue_enter(struct request_queue *q, struct bio *bio);
 void submit_bio_noacct_nocheck(struct bio *bio, bool split);
 int bio_submit_or_kill(struct bio *bio, unsigned int flags);
@@ -780,26 +786,30 @@ void blk_integrity_prepare(struct request *rq);
 void blk_integrity_complete(struct request *rq, unsigned int nr_bytes);
 
 #ifdef CONFIG_LOCKDEP
-static inline void blk_freeze_acquire_lock(struct request_queue *q)
+static inline void blk_freeze_acquire_lock(struct request_queue *q,
+					   unsigned int mask)
 {
-	if (!q->mq_freeze_disk_dead)
+	if (mask & BLK_FREEZE_LOCK_IO)
 		rwsem_acquire(&q->io_lockdep_map, 0, 1, _RET_IP_);
-	if (!q->mq_freeze_queue_dying)
+	if (mask & BLK_FREEZE_LOCK_QUEUE)
 		rwsem_acquire(&q->q_lockdep_map, 0, 1, _RET_IP_);
 }
 
-static inline void blk_unfreeze_release_lock(struct request_queue *q)
+static inline void blk_unfreeze_release_lock(struct request_queue *q,
+					     unsigned int mask)
 {
-	if (!q->mq_freeze_queue_dying)
+	if (mask & BLK_FREEZE_LOCK_QUEUE)
 		rwsem_release(&q->q_lockdep_map, _RET_IP_);
-	if (!q->mq_freeze_disk_dead)
+	if (mask & BLK_FREEZE_LOCK_IO)
 		rwsem_release(&q->io_lockdep_map, _RET_IP_);
 }
 #else
-static inline void blk_freeze_acquire_lock(struct request_queue *q)
+static inline void blk_freeze_acquire_lock(struct request_queue *q,
+					   unsigned int mask)
 {
 }
-static inline void blk_unfreeze_release_lock(struct request_queue *q)
+static inline void blk_unfreeze_release_lock(struct request_queue *q,
+					     unsigned int mask)
 {
 }
 #endif
diff --git a/block/genhd.c b/block/genhd.c
index 69204d44a..38ed000e9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -657,8 +657,11 @@ static void blk_report_disk_dead(struct gendisk *disk, bool surprise)
 	rcu_read_unlock();
 }
 
-static bool __blk_mark_disk_dead(struct gendisk *disk)
+static bool __blk_mark_disk_dead(struct gendisk *disk, unsigned int *lock_mask)
 {
+	struct task_struct *owner = NULL;
+	unsigned int mask;
+
 	/*
 	 * Fail any new I/O.
 	 */
@@ -667,6 +670,8 @@ static bool __blk_mark_disk_dead(struct gendisk *disk)
 
 	if (test_bit(GD_OWNS_QUEUE, &disk->state))
 		blk_queue_flag_set(QUEUE_FLAG_DYING, disk->queue);
+	else if (lock_mask)
+		owner = current;
 
 	/*
 	 * Stop buffered writers from dirtying pages that can't be written out.
@@ -676,7 +681,10 @@ static bool __blk_mark_disk_dead(struct gendisk *disk)
 	/*
 	 * Prevent new I/O from crossing bio_queue_enter().
 	 */
-	return blk_queue_start_drain(disk->queue);
+	mask = blk_queue_start_drain(disk->queue, owner);
+	if (lock_mask)
+		*lock_mask = mask;
+	return true;
 }
 
 /**
@@ -689,7 +697,7 @@ static bool __blk_mark_disk_dead(struct gendisk *disk)
 void blk_mark_disk_dead(struct gendisk *disk)
 {
 	blk_queue_flag_set(QUEUE_FLAG_DYING, disk->queue);
-	__blk_mark_disk_dead(disk);
+	__blk_mark_disk_dead(disk, NULL);
 	blk_report_disk_dead(disk, true);
 }
 EXPORT_SYMBOL_GPL(blk_mark_disk_dead);
@@ -699,6 +707,7 @@ static void __del_gendisk(struct gendisk *disk)
 	struct request_queue *q = disk->queue;
 	struct block_device *part;
 	unsigned long idx;
+	unsigned int lock_mask = 0;
 	bool start_drain;
 
 	might_sleep();
@@ -727,9 +736,8 @@ static void __del_gendisk(struct gendisk *disk)
 	 * Drop all partitions now that the disk is marked dead.
 	 */
 	mutex_lock(&disk->open_mutex);
-	start_drain = __blk_mark_disk_dead(disk);
-	if (start_drain)
-		blk_freeze_acquire_lock(q);
+	start_drain = __blk_mark_disk_dead(disk, &lock_mask);
+	blk_freeze_acquire_lock(q, lock_mask);
 	xa_for_each_start(&disk->part_tbl, idx, part, 1)
 		drop_partition(part);
 	mutex_unlock(&disk->open_mutex);
@@ -772,13 +780,13 @@ static void __del_gendisk(struct gendisk *disk)
 	 * If the disk does not own the queue, allow using passthrough requests
 	 * again.  Else leave the queue frozen to fail all I/O.
 	 */
-	if (!test_bit(GD_OWNS_QUEUE, &disk->state))
-		__blk_mq_unfreeze_queue(q, true);
-	else if (queue_is_mq(q))
+	if (!test_bit(GD_OWNS_QUEUE, &disk->state)) {
+		lock_mask = __blk_mq_unfreeze_queue(q, true,
+				start_drain ? current : NULL);
+		blk_unfreeze_release_lock(q, lock_mask);
+	} else if (queue_is_mq(q)) {
 		blk_mq_exit_queue(q);
-
-	if (start_drain)
-		blk_unfreeze_release_lock(q);
+	}
 }
 
 static void disable_elv_switch(struct request_queue *q)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 215753171..6de7e98ec 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -636,12 +636,7 @@ struct request_queue {
 #ifdef CONFIG_LOCKDEP
 	struct task_struct	*mq_freeze_owner;
 	int			mq_freeze_owner_depth;
-	/*
-	 * Records disk & queue state in current context, used in unfreeze
-	 * queue
-	 */
-	bool			mq_freeze_disk_dead;
-	bool			mq_freeze_queue_dying;
+	unsigned int		mq_freeze_lock_mask;
 #endif
 	wait_queue_head_t	mq_freeze_wq;
 	/*


base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
