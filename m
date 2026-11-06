Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794007379;
	b=BokpbL2lY8wxyhd3XYK/q1q47gz/PFQT46tgF8vIQFxC6VnPG/AnRYSi+2fVDBC1G8uP
	 QD+d9vP1FOPdvgkokn1Y2kOYiaoUQoljjaLroIeGgoHBQFrCU2cdwq++TKG5ZyQXkTEob
	 BHhEegg5oWCPvCaF6h5XBYZ3Ndmux+nRyEKelfrmkhi90gVOT5mCPkg5e1lR88/c6lDo1
	 oKpfC2kls88jEojrozMSmZMMQMWOQhMFP/16quESTeeaxfR3AFIKeFM474OE3eB+9D7Ey
	 EteOxrzgxvVzn8b/eu8T+lZBXI6IqgdxdBCWrWxbj3uerqLMp8xWDXx5jZZL4mrw54Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794007379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=a613eMMKWFth7sgw3fKSigJfkmp0bZyTI6vpsKsRXmY=;
	b=1v8L4y7Q73j1Eq5sY+yAeuvL+MUxS+msFFyqvIJUKiznrjxhLfGATtpayjiVh44Sp2oJ
	 /BRu0Jk4CJql4lV4y0U9d82FDS/8cXRwkQJqDKiDY+YU5Eo0wZpbnDPw4e6KUY4AAwdeC
	 GLPr92f4eG6dvC0mkZlGGa7+LMYZwWXOZb0vyltwCKeJP5nlH4OoGv0OfCIE8Koo8JQsY
	 z6R/4qi+84RhXQOlI1fxTj7HCK7gpeKMe5bBFOtH/OgEKiEpv13ezMnVAzAt2jj/qKlZ6
	 5FeirbTorZxQ+9aV5xIvbIGe2HDRDXMtt4+BzyR6VAeIQaQmJXL61OyWxPOwi2xX2MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXmZ2qKC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 41E8B606A334
	for <syzbot@lists.linux.dev>; Fri,  6 Nov 2026 23:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MXmZ2qKC
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C421B1F008A5;
	Fri,  6 Nov 2026 23:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794007378;
	bh=a613eMMKWFth7sgw3fKSigJfkmp0bZyTI6vpsKsRXmY=;
	h=From:To:Cc:Subject:Date;
	b=MXmZ2qKC9WIsAtivK1OBfk9ide2rz+4oynIavhFqAEc0uZQ/frNCjLAUpiR1ywr1i
	 NmweaXnSnQ7ejiSTYPxRPFRbhWVYuauF/53FSEFnai19rmgcqk7ahqBKWyz2g/Y7TH
	 hOvNbcyq5H0ozt8d9qOIRzaII0R/l5RTWkqZVSEyexbZDMtLDu6f6e1VflbnuSgtQb
	 cDL5/+vVR/gY956r+6TZxb+P/mdfPGDTIN0D/W1P8ohVFIK9UldZyu5fThCGuieRed
	 j6JTa7E5VJ0dvLxHE7xpKJh02C4+/qT/yPsLJ5oto16/voJNs6pWlTiJzXxPMdSpsu
	 jhsAvtURs8l4g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] sched/core: Fix DL server picks and forced-idle accounting
Message-ID: <66907bc3-07d0-4208-b1cb-6552ed2887c0@mail.kernel.org>
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
Date: Fri,  6 Nov 2026 23:22:58 +0000 (UTC)

When core scheduling is enabled and a real-time task (such as SCHED_RR or
SCHED_FIFO) with a core cookie runs on one SMT sibling, while non-cookied
CFS tasks (such as the rcu_preempt kthread with cookie 0) are queued on
another sibling, the deadline server (rq->fair_server) fails to activate
and boost the CFS tasks. Because RT bandwidth throttling is disabled by
default, starvation prevention of CFS tasks relies entirely on the deadline
server. Under this scenario, the sibling CPU running the non-cookied CFS
tasks is forced into idle, and the CFS tasks starve indefinitely, resulting
in RCU preempt stalls:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	(detected by 1, t=10502 jiffies, g=30225, q=109 ncpus=2)
rcu: rcu_preempt kthread starved for 10477 jiffies! g30225 f0x2
RCU_GP_WAIT_FQS(5) ->state=R ->cpu=1
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27496 pid:16
tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5583 [inline]
 __schedule+0x17f9/0x5760 kernel/sched/core.c:7382
 schedule+0x164/0x2b0 kernel/sched/core.c:7474
 schedule_timeout+0x152/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x30c/0x1230 kernel/rcu/tree.c:2122
 rcu_gp_kthread+0x9c/0x340 kernel/rcu/tree.c:2330
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Two interacting issues in core scheduling prevent the deadline server from
mitigating this starvation.

First, when a sibling CPU enters forced idle because its runnable tasks do
not match the core cookie of the winning task, rq->curr runs rq->idle while
rq->nr_running remains positive. On every tick, update_curr_idle()
unconditionally calls dl_server_update_idle(&rq->fair_server, delta_exec).
Because fair_server operates in defer mode (dl_se->dl_defer == 1),
update_curr_dl_se() subtracts forced-idle runtime from the server. Once the
server's runtime is consumed, dl_runtime_exceeded() checks idle_rq(rq).
Because rq->nr_running > 0, idle_rq() evaluates to false, causing
update_curr_dl_se() to cancel the replenishment timer (dl_se->dl_timer),
advance the deadline and period by one second via
replenish_dl_new_period(), and restart the timer another 950ms in the
future. Repeated every 50ms of forced idle, this repeatedly pushes the
zero-laxity replenishment timer into the future, preventing fair_server
from ever firing and enqueuing onto dl_rq.

Second, commit bd9bbc96e835 ("sched: Rework dl_server") stopped setting
p->dl_server during pick_task(), deferring its assignment until
put_prev_set_next_task(). However, __task_prio() and prio_less() continued
to inspect p->dl_server. During pick_next_task(), when fair_server picks a
CFS task, the DL server is staged in rq->dl_server (and rq->core_dl_server)
while p->dl_server remains NULL. Consequently, __task_prio() evaluates the
boosted CFS candidate as standard fair priority (119) rather than deadline
priority (-1). The competing RT task on the sibling CPU wins core-wide
selection, and the fair candidate is discarded during cookie matching.
Furthermore, pick_next_task() unconditionally cleared rq_i->core_dl_server
even when cookie matching succeeded, failed to clear rq_i->dl_server when
cookie matching failed (leaking it to fallback idle or matched tasks), and
failed to update rq_i->donor->dl_server when a sibling CPU was already
running rq_i->core_pick.

Fix these problems by:
- Checking idle_rq() before calling dl_server_update_idle() in
update_curr_idle() and inside dl_server_update_idle(). During forced idle,
tasks are queued waiting to run, so forced-idle time is not charged against
deferred DL servers, allowing their zero-laxity timers to expire on
schedule.
- Introducing task_dl_server() to check whether a candidate task is the
active pick of an in-flight core selection (rq->core->core_pick_in_flight
&& rq->core_pick == p), returning rq->core_dl_server. Updating
__task_prio() and prio_less() to use task_dl_server() ensures DL server
picks are evaluated with deadline priority during core selection without
disturbing static core tree ordering.
- Correcting DL server lifecycle tracking in core scheduling: initializing
rq->core_pick and rq->core_dl_server to NULL in pick_task(), clearing
rq_i->core_dl_server and rq_i->dl_server only when cookie matching fails,
and updating rq_i->donor->dl_server and clearing rq_i->dl_server when a
sibling is already running rq_i->core_pick.

Fixes: bd9bbc96e835 ("sched: Rework dl_server")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+9431dc0c0741cff46a99@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9431dc0c0741cff46a99
Link: https://syzkaller.appspot.com/ai_job?id=b345cb31-2e9f-456a-92c3-61c605b1f4cd
To: "Juri Lelli" <juri.lelli@redhat.com>
To: <linux-kernel@vger.kernel.org>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Peter Zijlstra" <peterz@infradead.org>
To: "Vincent Guittot" <vincent.guittot@linaro.org>
Cc: "Ben Segall" <bsegall@google.com>
Cc: "Dietmar Eggemann" <dietmar.eggemann@arm.com>
Cc: "K Prateek Nayak" <kprateek.nayak@amd.com>
Cc: "Mel Gorman" <mgorman@suse.de>
Cc: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Valentin Schneider" <vschneid@redhat.com>

---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 04b62c16f..1f34d2ce0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -195,13 +195,24 @@ __read_mostly int scheduler_running;
 
 DEFINE_STATIC_KEY_FALSE(__sched_core_enabled);
 
+static inline const struct sched_dl_entity *
+task_dl_server(const struct task_struct *p)
+{
+	const struct rq *rq = task_rq(p);
+
+	if (rq->core->core_pick_in_flight && rq->core_pick == p)
+		return rq->core_dl_server;
+
+	return NULL;
+}
+
 /* kernel prio, less is more */
 static inline int __task_prio(const struct task_struct *p)
 {
 	if (p->sched_class == &stop_sched_class) /* trumps deadline */
 		return -2;
 
-	if (p->dl_server)
+	if (task_dl_server(p))
 		return -1; /* deadline */
 
 	if (rt_or_dl_prio(p->prio))
@@ -239,18 +250,13 @@ static inline bool prio_less(const struct task_struct *a,
 	if (pa == -1) { /* dl_prio() doesn't work because of stop_class above */
 		const struct sched_dl_entity *a_dl, *b_dl;
 
-		a_dl = &a->dl;
-		/*
-		 * Since,'a' and 'b' can be CFS tasks served by DL server,
-		 * __task_prio() can return -1 (for DL) even for those. In that
-		 * case, get to the dl_server's DL entity.
-		 */
-		if (a->dl_server)
-			a_dl = a->dl_server;
+		a_dl = task_dl_server(a);
+		if (!a_dl)
+			a_dl = &a->dl;
 
-		b_dl = &b->dl;
-		if (b->dl_server)
-			b_dl = b->dl_server;
+		b_dl = task_dl_server(b);
+		if (!b_dl)
+			b_dl = &b->dl;
 
 		return !dl_time_before(a_dl->deadline, b_dl->deadline);
 	}
@@ -6277,6 +6283,8 @@ static inline struct task_struct *pick_task(struct rq *rq, struct rq_flags *rf)
 	struct task_struct *p;
 
 	rq->dl_server = NULL;
+	rq->core_pick = NULL;
+	rq->core_dl_server = NULL;
 
 	for_each_active_class(class) {
 		p = class->pick_task(rq, rf);
@@ -6455,10 +6463,11 @@ pick_next_task(struct rq *rq, struct rq_flags *rf)
 				p = sched_core_find(rq_i, cookie);
 			if (!p)
 				p = idle_sched_class.pick_task(rq_i, rf);
-		}
 
-		rq_i->core_pick = p;
-		rq_i->core_dl_server = NULL;
+			rq_i->core_pick = p;
+			rq_i->core_dl_server = NULL;
+			rq_i->dl_server = NULL;
+		}
 
 		if (p == rq_i->idle) {
 			if (rq_i->nr_running) {
@@ -6526,8 +6535,10 @@ pick_next_task(struct rq *rq, struct rq_flags *rf)
 		WARN_ON_ONCE(!cookie_match(next, rq_i->core_pick));
 
 		if (rq_i->curr == rq_i->core_pick) {
+			rq_i->donor->dl_server = rq_i->core_dl_server;
 			rq_i->core_pick = NULL;
 			rq_i->core_dl_server = NULL;
+			rq_i->dl_server = NULL;
 			continue;
 		}
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c0ebdcde5..ee1cdce42 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1578,6 +1578,9 @@ static void update_curr_dl_se(struct rq *rq, struct sched_dl_entity *dl_se, s64
  */
 void dl_server_update_idle(struct sched_dl_entity *dl_se, s64 delta_exec)
 {
+	if (!idle_rq(dl_se->rq))
+		return;
+
 	if (dl_se->dl_server_active && dl_se->dl_runtime && dl_se->dl_defer)
 		update_curr_dl_se(dl_se->rq, dl_se, delta_exec);
 }
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index e0c10a5db..6ee4b43b1 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -573,6 +573,9 @@ static void update_curr_idle(struct rq *rq)
 
 	se->exec_start = now;
 
+	if (!idle_rq(rq))
+		return;
+
 	dl_server_update_idle(&rq->fair_server, delta_exec);
 #ifdef CONFIG_SCHED_CLASS_EXT
 	dl_server_update_idle(&rq->ext_server, delta_exec);


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
