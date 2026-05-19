Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DD03793B6
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 09:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779183998; cv=none; b=uAC8JWZMUd73v8opxEMW2OXwYDco9nxU9GJtvCXFKMR5OYe1TaCLmK0ahgw/fa4cYDb/6EyaeXkWSCecX1t3WHiMWY7i/eGx6yDfvLSxj+EG8jfHnJU7U5EFwLp6tWYnyFIRZhnVJH4FB1IkD0kBaRhz59Smhi+J1vR7IPZBFFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779183998; c=relaxed/simple;
	bh=4dGr8+pqnhmX2RyflQCVLPppc7TZO9F5qElCbyi+XfQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=EGlueYvubAuAdoRYOKuf3MEIjmVZoN1WwWoSUsNmIEvfDcoiWf7hFiZkA53LYpoOPfq7ipW/WI6IXpbbQK5A5YhHG43LtQhhX0r8HIZc1GZcTbKOq57mZGVUcN4yuIAsgN+BKtPQSexlWeYqFQUw5/P2Dtu5lWruwn9DPj/zGa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsUhEfH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsUhEfH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4994CC2BCB3;
	Tue, 19 May 2026 09:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779183998;
	bh=4dGr8+pqnhmX2RyflQCVLPppc7TZO9F5qElCbyi+XfQ=;
	h=From:To:Cc:Subject:Date:From;
	b=AsUhEfH0WayCJkruSkF4UaKfOliEPy0R7qoHWFy4sARKOyxUUcp9jWVyQLIv53i/L
	 eU0cQh3ChjqkzdJe4BSs7HC68HJE9FeQ8OhGvXc6jejH95sAAGVufCtVfQEis4HXuf
	 rqButLqh/r4VA8SKwiRsmx6Asag2LUbBZN96MjU7c0VeLm4EF5KuMOVf99THubfrUp
	 Yj/Mn5R2xic20HOsLSCMoRtAoZ1NM5z9VSg5dKrdLio7XlxstN+PbRChkdGtGuwwPL
	 84W1wFk01+AT2+Pb4xKUK0uB+glaOHTsF7B17BBBxc9nQOwUNOJs0C9D7wUm/7E+f5
	 1RKhg7MwX9FFg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] blktrace: handle tracepoint registration failures properly
Message-ID: <d0f6ed08-78cc-4d4f-89d6-dd6ef9efa35d@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 09:46:38 +0000 (UTC)

Syzbot reported a kernel panic caused by a WARN_ON() in
blk_register_tracepoints() when tracepoint registration fails due to a
memory allocation failure (simulated by fault injection). WARN_ON() must
not be used for conditions that can legitimately happen, such as memory
allocation failures.

Simply removing the WARN_ON() is not sufficient. If the error is
silently ignored, some tracepoints will be left unregistered. Later,
when tracing is stopped, blk_unregister_tracepoints() will
unconditionally call unregister_trace_*() for all tracepoints. Calling
unregister_trace_*() on a tracepoint that has no probes registered
triggers a WARN_ON_ONCE() inside tracepoint_remove_func(), which would
again cause a panic.

To fix this, properly handle the registration errors by unregistering
the successfully registered tracepoints in reverse order, and then
propagate the error up the call stack so that the blk_trace setup is
cleanly aborted. Modify blk_register_tracepoints(), get_probe_ref(), and
blk_trace_setup_finalize() to return an int error code. Update
blk_trace_setup(), blk_trace_setup2(), compat_blk_trace_setup(), and
blk_trace_setup_queue() to check the return value and clean up allocated
resources if tracepoint registration fails.

Fixes: 5f3ea37c7716db4e894a480e0c18b24399595b6b ("blktrace: port to tracepoints")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+8672dcb9d10011c0a160@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=8672dcb9d10011c0a160
Link: https://syzkaller.appspot.com/ai_job?id=1da237ef-86bc-4b27-8e1c-efa09d2b8eb4
To: <axboe@kernel.dk>
To: <linux-block@vger.kernel.org>
To: <linux-trace-kernel@vger.kernel.org>
To: <mhiramat@kernel.org>
To: <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <mathieu.desnoyers@efficios.com>

---
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 8cd2520b4..dbee58c6e 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -60,7 +60,7 @@ static struct tracer_flags blk_tracer_flags = {
 static DEFINE_MUTEX(blk_probe_mutex);
 static int blk_probes_ref;
 
-static void blk_register_tracepoints(void);
+static int blk_register_tracepoints(void);
 static void blk_unregister_tracepoints(void);
 
 static void record_blktrace_event(struct blk_io_trace *t, pid_t pid, int cpu,
@@ -485,12 +485,18 @@ static void blk_trace_free(struct request_queue *q, struct blk_trace *bt)
 	kfree(bt);
 }
 
-static void get_probe_ref(void)
+static int get_probe_ref(void)
 {
+	int ret = 0;
+
 	mutex_lock(&blk_probe_mutex);
-	if (++blk_probes_ref == 1)
-		blk_register_tracepoints();
+	if (++blk_probes_ref == 1) {
+		ret = blk_register_tracepoints();
+		if (ret)
+			blk_probes_ref--;
+	}
 	mutex_unlock(&blk_probe_mutex);
+	return ret;
 }
 
 static void put_probe_ref(void)
@@ -727,12 +733,13 @@ static struct blk_trace *blk_trace_setup_prepare(struct request_queue *q,
 	return ERR_PTR(ret);
 }
 
-static void blk_trace_setup_finalize(struct request_queue *q,
-				     char *name, int version,
-				     struct blk_trace *bt,
-				     struct blk_user_trace_setup2 *buts)
+static int blk_trace_setup_finalize(struct request_queue *q, char *name,
+				    int version, struct blk_trace *bt,
+				    struct blk_user_trace_setup2 *buts)
 
 {
+	int ret;
+
 	strscpy_pad(buts->name, name, BLKTRACE_BDEV_SIZE2);
 
 	/*
@@ -755,8 +762,12 @@ static void blk_trace_setup_finalize(struct request_queue *q,
 	bt->pid = buts->pid;
 	bt->trace_state = Blktrace_setup;
 
+	ret = get_probe_ref();
+	if (ret)
+		return ret;
+
 	rcu_assign_pointer(q->blk_trace, bt);
-	get_probe_ref();
+	return 0;
 }
 
 int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
@@ -792,7 +803,12 @@ int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		blk_debugfs_unlock(q, memflags);
 		return PTR_ERR(bt);
 	}
-	blk_trace_setup_finalize(q, name, 1, bt, &buts2);
+	ret = blk_trace_setup_finalize(q, name, 1, bt, &buts2);
+	if (ret) {
+		blk_trace_free(q, bt);
+		blk_debugfs_unlock(q, memflags);
+		return ret;
+	}
 	strscpy(buts.name, buts2.name, BLKTRACE_BDEV_SIZE);
 	blk_debugfs_unlock(q, memflags);
 
@@ -810,6 +826,7 @@ static int blk_trace_setup2(struct request_queue *q, char *name, dev_t dev,
 	struct blk_user_trace_setup2 buts2;
 	struct blk_trace *bt;
 	unsigned int memflags;
+	int ret;
 
 	if (copy_from_user(&buts2, arg, sizeof(buts2)))
 		return -EFAULT;
@@ -827,7 +844,12 @@ static int blk_trace_setup2(struct request_queue *q, char *name, dev_t dev,
 		blk_debugfs_unlock(q, memflags);
 		return PTR_ERR(bt);
 	}
-	blk_trace_setup_finalize(q, name, 2, bt, &buts2);
+	ret = blk_trace_setup_finalize(q, name, 2, bt, &buts2);
+	if (ret) {
+		blk_trace_free(q, bt);
+		blk_debugfs_unlock(q, memflags);
+		return ret;
+	}
 	blk_debugfs_unlock(q, memflags);
 
 	if (copy_to_user(arg, &buts2, sizeof(buts2))) {
@@ -846,6 +868,7 @@ static int compat_blk_trace_setup(struct request_queue *q, char *name,
 	struct compat_blk_user_trace_setup cbuts;
 	struct blk_trace *bt;
 	unsigned int memflags;
+	int ret;
 
 	if (copy_from_user(&cbuts, arg, sizeof(cbuts)))
 		return -EFAULT;
@@ -869,7 +892,12 @@ static int compat_blk_trace_setup(struct request_queue *q, char *name,
 		blk_debugfs_unlock(q, memflags);
 		return PTR_ERR(bt);
 	}
-	blk_trace_setup_finalize(q, name, 1, bt, &buts2);
+	ret = blk_trace_setup_finalize(q, name, 1, bt, &buts2);
+	if (ret) {
+		blk_trace_free(q, bt);
+		blk_debugfs_unlock(q, memflags);
+		return ret;
+	}
 	blk_debugfs_unlock(q, memflags);
 
 	if (copy_to_user(arg, &buts2.name, ARRAY_SIZE(buts2.name))) {
@@ -1324,49 +1352,109 @@ void blk_add_driver_data(struct request *rq, void *data, size_t len)
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
 
-static void blk_register_tracepoints(void)
+static int blk_register_tracepoints(void)
 {
 	int ret;
 
 	ret = register_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
-	WARN_ON(ret);
+	if (ret)
+		return ret;
 	ret = register_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_issue;
 	ret = register_trace_block_rq_merge(blk_add_trace_rq_merge, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_merge;
 	ret = register_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_requeue;
 	ret = register_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_complete;
 	ret = register_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_bio_complete;
 	ret = register_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_backmerge;
 	ret = register_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_frontmerge;
 	ret = register_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_bio_queue;
 	ret = register_trace_block_getrq(blk_add_trace_getrq, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_getrq;
 	ret = register_trace_blk_zone_append_update_request_bio(
 		blk_add_trace_zone_update_request, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_zone_append;
 	ret = register_trace_disk_zone_wplug_add_bio(blk_add_trace_zone_plug,
 						     NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_zone_wplug_add;
 	ret = register_trace_blk_zone_wplug_bio(blk_add_trace_zone_unplug,
 						NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_zone_wplug;
 	ret = register_trace_block_plug(blk_add_trace_plug, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_plug;
 	ret = register_trace_block_unplug(blk_add_trace_unplug, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_unplug;
 	ret = register_trace_block_split(blk_add_trace_split, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_split;
 	ret = register_trace_block_bio_remap(blk_add_trace_bio_remap, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_bio_remap;
 	ret = register_trace_block_rq_remap(blk_add_trace_rq_remap, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto err_rq_remap;
+
+	return 0;
+
+err_rq_remap:
+	unregister_trace_block_bio_remap(blk_add_trace_bio_remap, NULL);
+err_bio_remap:
+	unregister_trace_block_split(blk_add_trace_split, NULL);
+err_split:
+	unregister_trace_block_unplug(blk_add_trace_unplug, NULL);
+err_unplug:
+	unregister_trace_block_plug(blk_add_trace_plug, NULL);
+err_plug:
+	unregister_trace_blk_zone_wplug_bio(blk_add_trace_zone_unplug, NULL);
+err_zone_wplug:
+	unregister_trace_disk_zone_wplug_add_bio(blk_add_trace_zone_plug, NULL);
+err_zone_wplug_add:
+	unregister_trace_blk_zone_append_update_request_bio(
+		blk_add_trace_zone_update_request, NULL);
+err_zone_append:
+	unregister_trace_block_getrq(blk_add_trace_getrq, NULL);
+err_getrq:
+	unregister_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
+err_bio_queue:
+	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge,
+					      NULL);
+err_frontmerge:
+	unregister_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
+err_backmerge:
+	unregister_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
+err_bio_complete:
+	unregister_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
+err_complete:
+	unregister_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
+err_requeue:
+	unregister_trace_block_rq_merge(blk_add_trace_rq_merge, NULL);
+err_merge:
+	unregister_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
+err_issue:
+	unregister_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
+
+	tracepoint_synchronize_unregister();
+	return ret;
 }
 
 static void blk_unregister_tracepoints(void)
@@ -1916,8 +2004,11 @@ static int blk_trace_setup_queue(struct request_queue *q,
 
 	blk_trace_setup_lba(bt, bdev);
 
+	ret = get_probe_ref();
+	if (ret)
+		goto free_bt;
+
 	rcu_assign_pointer(q->blk_trace, bt);
-	get_probe_ref();
 	return 0;
 
 free_bt:


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
