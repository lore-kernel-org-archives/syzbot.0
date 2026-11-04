Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793750662;
	b=oYMLsB3I5sKulu1qX4w8yJkYSz1E5iw5YWAYzYsDHIdsfkMoJ12LQPvM5rKEsBywN5t8
	 AnfpvLC6q+4CRRDtC56MqrTBn3lN+qEDW+ARm1xnceaV2U+vu56BNYbOcTohV3Y5yL7Qw
	 mYSqugSxXTOafi8t+I9GOYmCNT5j4qUd2jaA13ei7DIVOdxLkvcu96Z2WWn6L6uzFM/ht
	 sm61n0/6KqZ+F/C8SVjtaSQnSBmKEifpVTFeYVwvXajlMYnAIn7GJW7ip2buAxvM25O9B
	 WhoIiigzYaaQIrVv1xcj7AsTicLl5FUawPaIF2hXNo4TUCwBFJC+KeCDxuw+lfaRaUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793750662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=hAlOijwFiTp4+ijl8gd1Pb1QeDuqJ/zidJMbSnXsThY=;
	b=omo1D4CFBkewFrh4/phApEluq5uHvt1afEz+aHqjpoPznao5ZuvdkQLsVCOceTdDxxjv
	 nucd+99zO+IyZx6cyPdN5jeyzI4MSQqYjga8lsjj4wGG4ZmnwlcXl9Ao7Jl5LHqw1Do1L
	 ZPOngPP5AcDR1hCHcmTZp1T9wi0iBTAom96dVSK8LMSr18bgxME9+K7aevxB3SrVMvX69
	 OsoVbzCC2xb0xnR24ylye9P1X86o5zZSysTFsSu0MZ/tKMxQ2Ax3npCUxco4AZ9gb8CSj
	 tsS6qSRcjLNWv0UfPyxMMpCYoLiCAXW646nBCZWlZdjBR2fF9eZ3lrY+4KL1DkrSPxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BU0ynHoz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 44A79606A324
	for <syzbot@lists.linux.dev>; Wed,  4 Nov 2026 00:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BU0ynHoz
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B770E1F000C1;
	Wed,  4 Nov 2026 00:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793750661;
	bh=hAlOijwFiTp4+ijl8gd1Pb1QeDuqJ/zidJMbSnXsThY=;
	h=From:To:Cc:Subject:Date;
	b=BU0ynHoz/PCCbABBRSPW1QK16gQ21l2iu+g/s+6Lq+u/m2BW60XExs0HGzriwh1ss
	 rFJYVDL8H4QdR9H2wN70ejYVL7ZGJgifpKBH8E0uy3b1DtcXhutH5HDgU4N0woxtQG
	 uN9yGLK+HqxxcJSdmq+oR3dvkWitudtl67iC9RpfIoRsvD8rBb7C/b3OXI2mRWJnB3
	 CItANnoQkHuIqq08C0Yr4yfZuOdjvA/o/++DNyTnWytZtVa8R9oKMBRj+aUoFZ3cBj
	 HagmKtlHDWUoGptXNnk7M5l2Fii24z0V5HkLj86IhE4vweB6CkVV/cr0a8gstgRdkq
	 uoD0AFcGn5U1A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] block: snapshot lock mask to fix queue freeze lockdep race
Message-ID: <7cd2180d-2f43-42de-908d-3fb3b1d88b69@mail.kernel.org>
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
Date: Wed,  4 Nov 2026 00:04:21 +0000 (UTC)

A race between queue freeze/unfreeze operations and concurrent queue death
or draining can cause lockdep to report a lock held when returning to user
space:

================================================
WARNING: lock held when returning to user space!
...
task is leaving the kernel with locks still held!
locks held:
  (&q->q_usage_counter(queue)){+.+.}-{0:0}, at: elevator_change+0x194/0x480
  block/elevator.c:668

The lockdep tracking for queue freeze and unfreeze previously stored
mq_freeze_queue_dying and mq_freeze_disk_dead directly in struct
request_queue. These fields were initialized under q->mq_freeze_lock on the
outermost freeze (when !q->mq_freeze_depth). During unfreeze,
__blk_mq_unfreeze_queue() decremented q->mq_freeze_depth to 0, cleared
q->mq_freeze_owner, and released q->mq_freeze_lock. Only after releasing
the mutex did blk_mq_unfreeze_queue_nomemrestore() call
blk_unfreeze_release_lock(q), which inspected q->mq_freeze_queue_dying and
q->mq_freeze_disk_dead without holding q->mq_freeze_lock.

If another thread concurrently initiates queue draining or marks the queue
dying (such as during device destruction via blk_mark_disk_dead()), it sets
QUEUE_FLAG_DYING and calls __blk_freeze_queue_start(). Because
q->mq_freeze_depth has already dropped to 0 and q->mq_freeze_lock is
unlocked, the second thread acquires q->mq_freeze_lock, sees depth 0, and
overwrites q->mq_freeze_queue_dying with true. When the unfreezing thread
subsequently executes blk_unfreeze_release_lock(), it observes
q->mq_freeze_queue_dying as true, skips releasing q->q_lockdep_map, and
exits back to user space with the lockdep map still held.

Additionally, blk_queue_start_drain() unconditionally passed current as the
freeze owner to __blk_freeze_queue_start(). Because draining a dying queue
is permanent and does not release lockdep maps, tracking freeze ownership
on dying queues can corrupt owner tracking if called in contexts that
already hold an outer freeze.

Fix these issues by replacing the mutable per-queue boolean flags with a
snapshotted lock mask returned by value. Define BLK_FREEZE_LOCK_IO and
BLK_FREEZE_LOCK_QUEUE bit flags and store unsigned int mq_freeze_lock_mask
in struct request_queue. In blk_freeze_set_owner() and
blk_unfreeze_check_owner(), compute and retrieve the lock mask while
holding q->mq_freeze_lock, returning it by value from
__blk_freeze_queue_start() and __blk_mq_unfreeze_queue(). Pass the lock
mask by value to blk_freeze_acquire_lock() and blk_unfreeze_release_lock(),
avoiding unlocked reads of mutable request_queue fields after dropping
q->mq_freeze_lock. In blk_queue_start_drain(), pass NULL as owner to
__blk_freeze_queue_start() when blk_queue_dying(q) is true, preventing
permanent dying drains from claiming freeze ownership. Finally, propagate
and consume the lock mask in __blk_mark_disk_dead() and __del_gendisk().

Fixes: f6661b1d0525 ("block: track queue dying state automatically for modeling queue freeze lockdep")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+48ca80a8587c1d97c433@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=48ca80a8587c1d97c433
Link: https://syzkaller.appspot.com/ai_job?id=d7e2d57f-b3c0-415a-afc4-2e2bcac48fe1
To: "Jens Axboe" <axboe@kernel.dk>
To: <linux-block@vger.kernel.org>
To: "Ming Lei" <ming.lei@redhat.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/block/blk-core.c b/block/blk-core.c
index 8836c7028..fc3ab62e8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -324,20 +324,21 @@ void blk_put_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_put_queue);
 
-bool blk_queue_start_drain(struct request_queue *q)
+unsigned int blk_queue_start_drain(struct request_queue *q)
 {
 	/*
 	 * When queue DYING flag is set, we need to block new req
 	 * entering queue, so we call blk_freeze_queue_start() to
 	 * prevent I/O from crossing blk_queue_enter().
 	 */
-	bool freeze = __blk_freeze_queue_start(q, current);
+	unsigned int lock_mask = __blk_freeze_queue_start(q,
+			blk_queue_dying(q) ? NULL : current);
 	if (queue_is_mq(q))
 		blk_mq_wake_waiters(q);
 	/* Make blk_queue_enter() reexamine the DYING flag. */
 	wake_up_all(&q->mq_freeze_wq);
 
-	return freeze;
+	return lock_mask;
 }
 
 /**
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d9ab295be..3f64a59e5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -113,60 +113,64 @@ void blk_mq_in_driver_rw(struct block_device *part, unsigned int inflight[2])
 }
 
 #ifdef CONFIG_LOCKDEP
-static bool blk_freeze_set_owner(struct request_queue *q,
-				 struct task_struct *owner)
+static unsigned int blk_freeze_set_owner(struct request_queue *q,
+					 struct task_struct *owner)
 {
+	unsigned int lock_mask = 0;
+
 	if (!owner)
-		return false;
+		return 0;
 
 	if (!q->mq_freeze_depth) {
 		q->mq_freeze_owner = owner;
 		q->mq_freeze_owner_depth = 1;
-		q->mq_freeze_disk_dead = !q->disk ||
-			test_bit(GD_DEAD, &q->disk->state) ||
-			!blk_queue_registered(q);
-		q->mq_freeze_queue_dying = blk_queue_dying(q);
-		return true;
+		if (q->disk && !test_bit(GD_DEAD, &q->disk->state) &&
+		    blk_queue_registered(q))
+			lock_mask |= BLK_FREEZE_LOCK_IO;
+		if (!blk_queue_dying(q))
+			lock_mask |= BLK_FREEZE_LOCK_QUEUE;
+		q->mq_freeze_lock_mask = lock_mask;
+		return lock_mask;
 	}
 
 	if (owner == q->mq_freeze_owner)
 		q->mq_freeze_owner_depth += 1;
-	return false;
+	return 0;
 }
 
 /* verify the last unfreeze in owner context */
-static bool blk_unfreeze_check_owner(struct request_queue *q)
+static unsigned int blk_unfreeze_check_owner(struct request_queue *q)
 {
 	if (q->mq_freeze_owner != current)
-		return false;
+		return 0;
 	if (--q->mq_freeze_owner_depth == 0) {
 		q->mq_freeze_owner = NULL;
-		return true;
+		return q->mq_freeze_lock_mask;
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
+static unsigned int blk_unfreeze_check_owner(struct request_queue *q)
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
@@ -176,13 +180,14 @@ bool __blk_freeze_queue_start(struct request_queue *q,
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
 
@@ -208,9 +213,9 @@ void blk_mq_freeze_queue_nomemsave(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_nomemsave);
 
-bool __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic)
+unsigned int __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic)
 {
-	bool unfreeze;
+	unsigned int lock_mask;
 
 	mutex_lock(&q->mq_freeze_lock);
 	if (force_atomic)
@@ -221,16 +226,17 @@ bool __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic)
 		percpu_ref_resurrect(&q->q_usage_counter);
 		wake_up_all(&q->mq_freeze_wq);
 	}
-	unfreeze = blk_unfreeze_check_owner(q);
+	lock_mask = blk_unfreeze_check_owner(q);
 	mutex_unlock(&q->mq_freeze_lock);
 
-	return unfreeze;
+	return lock_mask;
 }
 
 void blk_mq_unfreeze_queue_nomemrestore(struct request_queue *q)
 {
-	if (__blk_mq_unfreeze_queue(q, false))
-		blk_unfreeze_release_lock(q);
+	unsigned int lock_mask = __blk_mq_unfreeze_queue(q, false);
+
+	blk_unfreeze_release_lock(q, lock_mask);
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue_nomemrestore);
 
diff --git a/block/blk.h b/block/blk.h
index ed2172472..2c4d5ee7d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -55,10 +55,11 @@ const char *blk_status_to_tag(blk_status_t status);
 blk_status_t tag_to_blk_status(const char *tag);
 enum req_op str_to_blk_op(const char *op);
 
-bool __blk_mq_unfreeze_queue(struct request_queue *q, bool force_atomic);
-bool blk_queue_start_drain(struct request_queue *q);
-bool __blk_freeze_queue_start(struct request_queue *q,
-			      struct task_struct *owner);
+unsigned int __blk_mq_unfreeze_queue(struct request_queue *q,
+				     bool force_atomic);
+unsigned int blk_queue_start_drain(struct request_queue *q);
+unsigned int __blk_freeze_queue_start(struct request_queue *q,
+				      struct task_struct *owner);
 int __bio_queue_enter(struct request_queue *q, struct bio *bio);
 void submit_bio_noacct_nocheck(struct bio *bio, bool split);
 int bio_submit_or_kill(struct bio *bio, unsigned int flags);
@@ -777,27 +778,36 @@ blk_status_t bio_integrity_verify(struct bio *bio,
 void blk_integrity_prepare(struct request *rq);
 void blk_integrity_complete(struct request *rq, unsigned int nr_bytes);
 
+enum {
+	BLK_FREEZE_LOCK_IO	= (1 << 0),
+	BLK_FREEZE_LOCK_QUEUE	= (1 << 1),
+};
+
 #ifdef CONFIG_LOCKDEP
-static inline void blk_freeze_acquire_lock(struct request_queue *q)
+static inline void blk_freeze_acquire_lock(struct request_queue *q,
+					   unsigned int lock_mask)
 {
-	if (!q->mq_freeze_disk_dead)
+	if (lock_mask & BLK_FREEZE_LOCK_IO)
 		rwsem_acquire(&q->io_lockdep_map, 0, 1, _RET_IP_);
-	if (!q->mq_freeze_queue_dying)
+	if (lock_mask & BLK_FREEZE_LOCK_QUEUE)
 		rwsem_acquire(&q->q_lockdep_map, 0, 1, _RET_IP_);
 }
 
-static inline void blk_unfreeze_release_lock(struct request_queue *q)
+static inline void blk_unfreeze_release_lock(struct request_queue *q,
+					    unsigned int lock_mask)
 {
-	if (!q->mq_freeze_queue_dying)
+	if (lock_mask & BLK_FREEZE_LOCK_QUEUE)
 		rwsem_release(&q->q_lockdep_map, _RET_IP_);
-	if (!q->mq_freeze_disk_dead)
+	if (lock_mask & BLK_FREEZE_LOCK_IO)
 		rwsem_release(&q->io_lockdep_map, _RET_IP_);
 }
 #else
-static inline void blk_freeze_acquire_lock(struct request_queue *q)
+static inline void blk_freeze_acquire_lock(struct request_queue *q,
+					   unsigned int lock_mask)
 {
 }
-static inline void blk_unfreeze_release_lock(struct request_queue *q)
+static inline void blk_unfreeze_release_lock(struct request_queue *q,
+					    unsigned int lock_mask)
 {
 }
 #endif
diff --git a/block/genhd.c b/block/genhd.c
index 10ca8b4d6..e73349b74 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -657,13 +657,13 @@ static void blk_report_disk_dead(struct gendisk *disk, bool surprise)
 	rcu_read_unlock();
 }
 
-static bool __blk_mark_disk_dead(struct gendisk *disk)
+static unsigned int __blk_mark_disk_dead(struct gendisk *disk)
 {
 	/*
 	 * Fail any new I/O.
 	 */
 	if (test_and_set_bit(GD_DEAD, &disk->state))
-		return false;
+		return 0;
 
 	if (test_bit(GD_OWNS_QUEUE, &disk->state))
 		blk_queue_flag_set(QUEUE_FLAG_DYING, disk->queue);
@@ -699,7 +699,7 @@ static void __del_gendisk(struct gendisk *disk)
 	struct request_queue *q = disk->queue;
 	struct block_device *part;
 	unsigned long idx;
-	bool start_drain;
+	unsigned int lock_mask;
 
 	might_sleep();
 
@@ -727,9 +727,8 @@ static void __del_gendisk(struct gendisk *disk)
 	 * Drop all partitions now that the disk is marked dead.
 	 */
 	mutex_lock(&disk->open_mutex);
-	start_drain = __blk_mark_disk_dead(disk);
-	if (start_drain)
-		blk_freeze_acquire_lock(q);
+	lock_mask = __blk_mark_disk_dead(disk);
+	blk_freeze_acquire_lock(q, lock_mask);
 	xa_for_each_start(&disk->part_tbl, idx, part, 1)
 		drop_partition(part);
 	mutex_unlock(&disk->open_mutex);
@@ -777,8 +776,7 @@ static void __del_gendisk(struct gendisk *disk)
 	else if (queue_is_mq(q))
 		blk_mq_exit_queue(q);
 
-	if (start_drain)
-		blk_unfreeze_release_lock(q);
+	blk_unfreeze_release_lock(q, lock_mask);
 }
 
 static void disable_elv_switch(struct request_queue *q)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0c2010230..32a8e93c4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -637,11 +637,10 @@ struct request_queue {
 	struct task_struct	*mq_freeze_owner;
 	int			mq_freeze_owner_depth;
 	/*
-	 * Records disk & queue state in current context, used in unfreeze
+	 * Records lockdep locks acquired in owner context, used in unfreeze
 	 * queue
 	 */
-	bool			mq_freeze_disk_dead;
-	bool			mq_freeze_queue_dying;
+	unsigned int		mq_freeze_lock_mask;
 #endif
 	wait_queue_head_t	mq_freeze_wq;
 	/*


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
