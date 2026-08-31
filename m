Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEF93AE6F4
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214273; cv=none; b=FWV6uVK81h0rNuf0DMIDc/hzmG4fFwRIHUTxFUgcOH6uYFZhdzyEeH1BISnPo9+DDfgahfhgv309s4mjuI2HKH5K1xn47/MQnm6YAlvfQ41J7NnFpgowvnS7r3NJdoqf/y6rZP5TsX0LT74UqwylW6GvcJUrmj+aSiAlvJxb0g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214273; c=relaxed/simple;
	bh=oJWkAmCqI+OTEcH4FK+rkgTWGaQhgbCDBEECA64TuCQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=r+sRUZ8Jksf+OYBDbQmpDmBWcu3D0TLYVCCoqgp+lePwaCuIgqUwDRNeFVAKb4isAANezpDnKzuX0DIGRd38wNl1GD2dVG/g8Hz862Muc7VWM8Qy8R86Sy9irDV5ugCbdOju6Czp+1H1/K+uE+p5aK+nCCWRJdOHPwqNm5TF9uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSkm94YJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSkm94YJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AC6E71F00A3D;
	Mon, 31 Aug 2026 22:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214271;
	bh=+sTqaWAOtbnfR0uzFYKdsIhuAAG0bKW/eO3B0Umu2CI=;
	h=From:To:Cc:Subject:Date;
	b=DSkm94YJye4bDjSuHNxzMGhfN5QOG/YAXXSSV4M3BWb45RENll6siTOp+qC2UQSSQ
	 nngp/9JAf1wAKgW4kU+1gDTypxP4hI6ZoV8f5UusmxmR1mxFmfiO0QvKAuJsnPBVq/
	 YhflsoVWYFOqEaOU1XmM66brj6dGtW/eYKgN7wvLtJSW6LjkYCo2UD1RErS66Ruaiw
	 yfBkbm++ZYsRS5ipDDhJsw41Ms0IGCZzZeRFm6OcpSDMWqlt21mm/y53IutmntfoIc
	 ASaxLbTbtcFdssCwDgQ0AO3JilStp6RQ9SGlIwMk0Wgbb3rojvCd0ahB6fxMcTblwR
	 /CY+lLZME49xA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] blktrace: handle tracepoint registration failures
Message-ID: <b112c135-ed93-4de0-ba6b-dabe2296b519@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 31 Aug 2026 22:11:11 +0000 (UTC)

In blk_register_tracepoints(), register_trace_*() functions are called with
WARN_ON(ret). Tracepoint registration allocates memory for probe arrays and
can legitimately fail with -ENOMEM under memory pressure. WARN_ON() must
not be used for conditions that can legitimately happen.

WARNING: kernel/trace/blktrace.c:1332 at blk_register_tracepoints
kernel/trace/blktrace.c:1332 [inline]
WARNING: kernel/trace/blktrace.c:1332 at get_probe_ref+0x377/0x470
kernel/trace/blktrace.c:492
RIP: 0010:blk_register_tracepoints kernel/trace/blktrace.c:1332 [inline]
RIP: 0010:get_probe_ref+0x377/0x470 kernel/trace/blktrace.c:492
Call Trace:
 <TASK>
 blk_trace_setup_queue kernel/trace/blktrace.c:1920 [inline]
 sysfs_blk_trace_attr_store+0xb1d/0x11e0 kernel/trace/blktrace.c:2116
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_64+0x155/0x510 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Furthermore, blk_register_tracepoints() ignores registration errors and
continues, leaving tracepoints in a partially registered state. When
blktrace is later stopped, blk_unregister_tracepoints() unconditionally
attempts to unregister all tracepoints, which fails with -ENOENT and
triggers an additional warning in tracepoint_remove_func().

Fix this by removing WARN_ON() and properly handling registration failures
in blk_register_tracepoints(). If any registration fails, unwinding is
performed by unregistering previously registered tracepoints in reverse
order, synchronizing tracepoint unregistration, and returning the error
code. In addition, propagate the error through get_probe_ref(),
blk_trace_setup_finalize(), and the setup entry points (blk_trace_setup(),
blk_trace_setup2(), compat_blk_trace_setup(), and blk_trace_setup_queue()),
properly cleaning up allocated resources on failure.

Fixes: 5f3ea37c7716 ("blktrace: port to tracepoints")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c54ded83396afee31eb1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c54ded83396afee31eb1
Link: https://syzkaller.appspot.com/ai_job?id=b81a3c49-0fe5-44e7-bf10-a4e460a67fe2
To: "Jens Axboe" <axboe@kernel.dk>
To: <linux-block@vger.kernel.org>
To: <linux-trace-kernel@vger.kernel.org>
To: "Masami Hiramatsu" <mhiramat@kernel.org>
To: "Steven Rostedt" <rostedt@goodmis.org>
To: "Arnaldo Carvalho de Melo" <acme@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>

---
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 8cd2520b4..c2324298c 100644
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
@@ -727,12 +733,14 @@ static struct blk_trace *blk_trace_setup_prepare(struct request_queue *q,
 	return ERR_PTR(ret);
 }
 
-static void blk_trace_setup_finalize(struct request_queue *q,
-				     char *name, int version,
-				     struct blk_trace *bt,
-				     struct blk_user_trace_setup2 *buts)
+static int blk_trace_setup_finalize(struct request_queue *q,
+				    char *name, int version,
+				    struct blk_trace *bt,
+				    struct blk_user_trace_setup2 *buts)
 
 {
+	int ret;
+
 	strscpy_pad(buts->name, name, BLKTRACE_BDEV_SIZE2);
 
 	/*
@@ -755,8 +763,12 @@ static void blk_trace_setup_finalize(struct request_queue *q,
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
@@ -792,7 +804,12 @@ int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
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
 
@@ -810,6 +827,7 @@ static int blk_trace_setup2(struct request_queue *q, char *name, dev_t dev,
 	struct blk_user_trace_setup2 buts2;
 	struct blk_trace *bt;
 	unsigned int memflags;
+	int ret;
 
 	if (copy_from_user(&buts2, arg, sizeof(buts2)))
 		return -EFAULT;
@@ -827,7 +845,12 @@ static int blk_trace_setup2(struct request_queue *q, char *name, dev_t dev,
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
@@ -846,6 +869,7 @@ static int compat_blk_trace_setup(struct request_queue *q, char *name,
 	struct compat_blk_user_trace_setup cbuts;
 	struct blk_trace *bt;
 	unsigned int memflags;
+	int ret;
 
 	if (copy_from_user(&cbuts, arg, sizeof(cbuts)))
 		return -EFAULT;
@@ -869,7 +893,12 @@ static int compat_blk_trace_setup(struct request_queue *q, char *name,
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
@@ -1324,49 +1353,108 @@ void blk_add_driver_data(struct request *rq, void *data, size_t len)
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
 
-static void blk_register_tracepoints(void)
+static int blk_register_tracepoints(void)
 {
 	int ret;
 
 	ret = register_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out;
 	ret = register_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_rq_insert;
 	ret = register_trace_block_rq_merge(blk_add_trace_rq_merge, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_rq_issue;
 	ret = register_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_rq_merge;
 	ret = register_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_rq_requeue;
 	ret = register_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_rq_complete;
 	ret = register_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_bio_complete;
 	ret = register_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_bio_backmerge;
 	ret = register_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_bio_frontmerge;
 	ret = register_trace_block_getrq(blk_add_trace_getrq, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_bio_queue;
 	ret = register_trace_blk_zone_append_update_request_bio(
 		blk_add_trace_zone_update_request, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_getrq;
 	ret = register_trace_disk_zone_wplug_add_bio(blk_add_trace_zone_plug,
 						     NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_zone_update_request;
 	ret = register_trace_blk_zone_wplug_bio(blk_add_trace_zone_unplug,
 						NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_zone_plug;
 	ret = register_trace_block_plug(blk_add_trace_plug, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_zone_unplug;
 	ret = register_trace_block_unplug(blk_add_trace_unplug, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_plug;
 	ret = register_trace_block_split(blk_add_trace_split, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_unplug;
 	ret = register_trace_block_bio_remap(blk_add_trace_bio_remap, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_split;
 	ret = register_trace_block_rq_remap(blk_add_trace_rq_remap, NULL);
-	WARN_ON(ret);
+	if (ret)
+		goto out_bio_remap;
+
+	return 0;
+
+out_bio_remap:
+	unregister_trace_block_bio_remap(blk_add_trace_bio_remap, NULL);
+out_split:
+	unregister_trace_block_split(blk_add_trace_split, NULL);
+out_unplug:
+	unregister_trace_block_unplug(blk_add_trace_unplug, NULL);
+out_plug:
+	unregister_trace_block_plug(blk_add_trace_plug, NULL);
+out_zone_unplug:
+	unregister_trace_blk_zone_wplug_bio(blk_add_trace_zone_unplug, NULL);
+out_zone_plug:
+	unregister_trace_disk_zone_wplug_add_bio(blk_add_trace_zone_plug, NULL);
+out_zone_update_request:
+	unregister_trace_blk_zone_append_update_request_bio(
+		blk_add_trace_zone_update_request, NULL);
+out_getrq:
+	unregister_trace_block_getrq(blk_add_trace_getrq, NULL);
+out_bio_queue:
+	unregister_trace_block_bio_queue(blk_add_trace_bio_queue, NULL);
+out_bio_frontmerge:
+	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
+out_bio_backmerge:
+	unregister_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
+out_bio_complete:
+	unregister_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
+out_rq_complete:
+	unregister_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
+out_rq_requeue:
+	unregister_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
+out_rq_merge:
+	unregister_trace_block_rq_merge(blk_add_trace_rq_merge, NULL);
+out_rq_issue:
+	unregister_trace_block_rq_issue(blk_add_trace_rq_issue, NULL);
+out_rq_insert:
+	unregister_trace_block_rq_insert(blk_add_trace_rq_insert, NULL);
+	tracepoint_synchronize_unregister();
+out:
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


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
