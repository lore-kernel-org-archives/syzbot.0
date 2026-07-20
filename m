Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3E73DC87A
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784559669; cv=none; b=SWshjUapAI1qJyvTUAgyCGXT8XeT2ZRirrpizhaSpz87hlana7NFdFPwbYEyaBdD/biBHqf+3nTwtjXqW/61divcH+hggn7NZHEtUIMZ2Gz5wkF7y0tada9kmeiUYScSTagyyYlJA/+TLRiu7DAfGTLI7g1ndifU7XjeKv9aCfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784559669; c=relaxed/simple;
	bh=HFN+HeemPob2UZnIYj9j0sIVDenScztJ1lLtPmiNowA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Content-Type; b=HMUfSR3duPQ34p7oYh6MIy6xifr6MRFSk9+JanlOxZnXET9GzR7V7MoAAuqOESNSOKcQ396gk3Cga48Pc/1AFGz/87pT1t/Rw2NrHVC3layq1DlZJOe99CjvP7xpleL/X+i0rkRT+cUWo10lzaoAk3HahdcHJv69jBLgD9dYsBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--glider.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cu28jMbE; arc=none smtp.client-ip=209.85.218.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--glider.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cu28jMbE"
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15f0aea084so720091366b.0
        for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 08:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784559665; x=1785164465; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tLQp/CUq2IWxMACNptpVHnHh555NoaejCoYZMJqM1BA=;
        b=cu28jMbEoya7q0nFClGsshKTCQDcE2S0ZVWb8ECmDyz+TCarBkvJoS74En8+XDnUmc
         DId0AfpfbUEnNkUXnqOycoezS6oOFii6uc3FJTOpbimL/u8lJTE0VPWyj5Q9ReCupCUT
         IoACwosduuw5KRMvDa1kVkdo1uIt8aH8t55/kqlzNK9984mSwxs1hyFSZPH+GEAJzBI3
         D0b17waLGIF+bj2vB+fJdhXfYPAcOMTvTQzntj/7SywrgronYQg4Nzr1XJd71PLS7Wrb
         eBSyw6kqRfnQCTXwjzeHMmM4Srz3f9vnr07ppdTHrsfvXQUeD91LmbNGFM2h0jO8mCT8
         mrLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784559665; x=1785164465;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tLQp/CUq2IWxMACNptpVHnHh555NoaejCoYZMJqM1BA=;
        b=MVNvh77rSqVjIxj17FFc3kJOmtAxf6vo+kBMK7Welat/VebqXfzKDKuCNETw0hRmN6
         8ch3ulibOPw/DGN4xcCrzDmpOv02IUH+xtvzbAYtoF6rtHngMK5nwQzfZNjSy202alJq
         Lcn0amuKl9S+jamCUYQGy9D541jaDVFX72dV4pPgGhwgUC/xcCc9u3eY2s8SUjdiU14c
         IWrgTlwReOdKSyneb8HAoRerb/xQZT/oKCVkwq4Q8Xj7gZi7Z8Tb+P9+N5Wmqeuoh6Nr
         GT+eS5qF7GzLlMMlmZpuk9CXaumitOJIYHpe6x1zKV80cVmmoynsF/Hc3tB/Hh63HXdc
         Wu6w==
X-Gm-Message-State: AOJu0Yy5cOWklr2ajtHYKuonp7EIoC7gMaa0qQlrI6Kd3+Uz+BBc45ad
	YnrmkeVeDiOT2CHaRwC+QiI3+6mPyWoCys7xPLcGkFdlLQsUBwy/ESuEgklEtaeQ59Purk3v63E
	g9ov4GRkLuoXY8hpxTwjie/TKiOeSqRHJJJSszvNHmnOU3jDmTU7PBo7wK6C5PGlU03HbqIcaLU
	SNNk6OCm9e6oZj0nx217Mz8lOe5vhvVs2eV+b6
X-Received: from ejem10.prod.google.com ([2002:a17:906:2aca:b0:c12:6633:c1d5])
 (user=glider job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:7947:b0:c16:9043:7973
 with SMTP id a640c23a62f3a-c16b46aa99amr538342966b.4.1784559665067; Mon, 20
 Jul 2026 08:01:05 -0700 (PDT)
Date: Mon, 20 Jul 2026 15:01:04 +0000
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720150104.2634801-1-glider@google.com>
Subject: [PATCH v7] kcov: fix data corruption and race conditions on
 PREEMPT_RT by moving saved remote state to task_struct (v7)
From: Alexander Potapenko <glider@google.com>
To: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot is reporting KCOV state corruption on PREEMPT_RT kernels, for the te=
mporary storage used for saving/restoring remote KCOV state is currently al=
located as the per-CPU area.

On PREEMPT_RT kernels, softirq handlers run as preemptible task threads (e.=
g., ksoftirqd). If a softirq context preempts a task running a remote KCOV =
session, it safely saves the task's state into the per-CPU area.
However, if that softirq thread is subsequently preempted by a higher-prior=
ity softirq thread on the same CPU, the second softirq will overwrite the s=
ame per-CPU area, permanently destroying the original task's KCOV state.

Fix this data corruption by moving the temporary storage from the per-CPU a=
rea to the per-thread area. Since each softirq thread now owns its own task=
 context, nested softirq preemption no longer causes data overwrites.

Note that while the temporary storage is now on a per-thread basis, the per=
-CPU kcov_percpu_data.lock must be retained, for we need to ensure that kco=
v_remote_start() and kcov_remote_stop() operate atomically without racing a=
gainst asynchronous interrupts that manipulate the current task's KCOV stat=
e.

Fixes: 5ff3b30ab57d ("kcov: collect coverage from interrupts")

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/sched.h |  8 ++++
 kernel/kcov.c         | 90 ++++++++++++++++++++++---------------------
 lib/Kconfig.debug     |  5 ++-
 3 files changed, 58 insertions(+), 45 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 373bcc0598d1..7a53c15cecb5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1543,6 +1543,14 @@ struct task_struct {
=20
 	/* Collect coverage from softirq context: */
 	unsigned int			kcov_softirq;
+
+	/* Temporary storage for preempting remote coverage collection: */
+	unsigned int			kcov_saved_mode;
+	unsigned int			kcov_saved_size;
+	void				*kcov_saved_area;
+	struct kcov			*kcov_saved_kcov;
+	int				kcov_saved_sequence;
+
 #endif
=20
 #ifdef CONFIG_MEMCG_V1
diff --git a/kernel/kcov.c b/kernel/kcov.c
index 1df373fb562b..a7514303eff3 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -86,17 +86,12 @@ struct kcov_remote {
=20
 static DEFINE_SPINLOCK(kcov_remote_lock);
 static DEFINE_HASHTABLE(kcov_remote_map, 4);
-static struct list_head kcov_remote_areas =3D LIST_HEAD_INIT(kcov_remote_a=
reas);
+static struct list_head kcov_remote_areas[2] =3D {
+	LIST_HEAD_INIT(kcov_remote_areas[0]), LIST_HEAD_INIT(kcov_remote_areas[1]=
)
+};
=20
 struct kcov_percpu_data {
-	void			*irq_area;
 	local_lock_t		lock;
-
-	unsigned int		saved_mode;
-	unsigned int		saved_size;
-	void			*saved_area;
-	struct kcov		*saved_kcov;
-	int			saved_sequence;
 };
=20
 static DEFINE_PER_CPU(struct kcov_percpu_data, kcov_percpu_data) =3D {
@@ -132,12 +127,13 @@ static struct kcov_remote *kcov_remote_add(struct kco=
v *kcov, u64 handle)
 }
=20
 /* Must be called with kcov_remote_lock locked. */
-static struct kcov_remote_area *kcov_remote_area_get(unsigned int size)
+static struct kcov_remote_area *kcov_remote_area_get(unsigned int size, bo=
ol irq)
 {
 	struct kcov_remote_area *area;
 	struct list_head *pos;
+	struct list_head *list =3D &kcov_remote_areas[irq];
=20
-	list_for_each(pos, &kcov_remote_areas) {
+	list_for_each(pos, list) {
 		area =3D list_entry(pos, struct kcov_remote_area, list);
 		if (area->size =3D=3D size) {
 			list_del(&area->list);
@@ -149,11 +145,11 @@ static struct kcov_remote_area *kcov_remote_area_get(=
unsigned int size)
=20
 /* Must be called with kcov_remote_lock locked. */
 static void kcov_remote_area_put(struct kcov_remote_area *area,
-					unsigned int size)
+				 unsigned int size, bool irq)
 {
 	INIT_LIST_HEAD(&area->list);
 	area->size =3D size;
-	list_add(&area->list, &kcov_remote_areas);
+	list_add(&area->list, &kcov_remote_areas[irq]);
 	/*
 	 * KMSAN doesn't instrument this file, so it may not know area->list
 	 * is initialized. Unpoison it explicitly to avoid reports in
@@ -390,6 +386,12 @@ void kcov_task_init(struct task_struct *t)
 	kcov_task_reset(t);
 	t->kcov_remote =3D NULL;
 	t->kcov_handle =3D current->kcov_handle;
+	t->kcov_softirq =3D 0;
+	t->kcov_saved_mode =3D 0;
+	t->kcov_saved_size =3D 0;
+	t->kcov_saved_area =3D NULL;
+	t->kcov_saved_kcov =3D NULL;
+	t->kcov_saved_sequence =3D 0;
 }
=20
 static void kcov_reset(struct kcov *kcov)
@@ -836,17 +838,16 @@ static inline bool kcov_mode_enabled(unsigned int mod=
e)
 static void kcov_remote_softirq_start(struct task_struct *t)
 	__must_hold(&kcov_percpu_data.lock)
 {
-	struct kcov_percpu_data *data =3D this_cpu_ptr(&kcov_percpu_data);
 	unsigned int mode;
=20
 	mode =3D READ_ONCE(t->kcov_mode);
 	barrier();
 	if (kcov_mode_enabled(mode)) {
-		data->saved_mode =3D mode;
-		data->saved_size =3D t->kcov_size;
-		data->saved_area =3D t->kcov_area;
-		data->saved_sequence =3D t->kcov_sequence;
-		data->saved_kcov =3D t->kcov;
+		t->kcov_saved_mode =3D mode;
+		t->kcov_saved_size =3D t->kcov_size;
+		t->kcov_saved_area =3D t->kcov_area;
+		t->kcov_saved_sequence =3D t->kcov_sequence;
+		t->kcov_saved_kcov =3D t->kcov;
 		kcov_stop(t);
 	}
 }
@@ -854,17 +855,15 @@ static void kcov_remote_softirq_start(struct task_str=
uct *t)
 static void kcov_remote_softirq_stop(struct task_struct *t)
 	__must_hold(&kcov_percpu_data.lock)
 {
-	struct kcov_percpu_data *data =3D this_cpu_ptr(&kcov_percpu_data);
-
-	if (data->saved_kcov) {
-		kcov_start(t, data->saved_kcov, data->saved_size,
-				data->saved_area, data->saved_mode,
-				data->saved_sequence);
-		data->saved_mode =3D 0;
-		data->saved_size =3D 0;
-		data->saved_area =3D NULL;
-		data->saved_sequence =3D 0;
-		data->saved_kcov =3D NULL;
+	if (t->kcov_saved_kcov) {
+		kcov_start(t, t->kcov_saved_kcov, t->kcov_saved_size,
+			   t->kcov_saved_area, t->kcov_saved_mode,
+			   t->kcov_saved_sequence);
+		t->kcov_saved_mode =3D 0;
+		t->kcov_saved_size =3D 0;
+		t->kcov_saved_area =3D NULL;
+		t->kcov_saved_sequence =3D 0;
+		t->kcov_saved_kcov =3D NULL;
 	}
 }
=20
@@ -927,17 +926,17 @@ void kcov_remote_start(u64 handle)
 	sequence =3D kcov->sequence;
 	if (in_task()) {
 		size =3D kcov->remote_size;
-		area =3D kcov_remote_area_get(size);
+		area =3D kcov_remote_area_get(size, false);
 	} else {
 		size =3D CONFIG_KCOV_IRQ_AREA_SIZE;
-		area =3D this_cpu_ptr(&kcov_percpu_data)->irq_area;
+		area =3D kcov_remote_area_get(size, true);
 	}
 	spin_unlock(&kcov_remote_lock);
=20
-	/* Can only happen when in_task(). */
+	/* Allocate new buffer if we can sleep. */
 	if (!area) {
 		local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
-		area =3D vmalloc(size * sizeof(unsigned long));
+		area =3D in_task() ? vmalloc(size * sizeof(unsigned long)) : NULL;
 		if (!area) {
 			kcov_put(kcov);
 			return;
@@ -1079,11 +1078,9 @@ void kcov_remote_stop(void)
 		kcov_move_area(kcov->mode, kcov->area, kcov->size, area);
 	spin_unlock(&kcov->lock);
=20
-	if (in_task()) {
-		spin_lock(&kcov_remote_lock);
-		kcov_remote_area_put(area, size);
-		spin_unlock(&kcov_remote_lock);
-	}
+	spin_lock(&kcov_remote_lock);
+	kcov_remote_area_put(area, size, !in_task());
+	spin_unlock(&kcov_remote_lock);
=20
 	local_unlock_irqrestore(&kcov_percpu_data.lock, flags);
=20
@@ -1129,14 +1126,21 @@ static void __init selftest(void)
=20
 static int __init kcov_init(void)
 {
-	int cpu;
+	int cpu =3D num_possible_cpus();
+
+#ifdef CONFIG_PREEMPT_RT
+	/* Allocate some extra buffers in order to prepare for softirq preemption=
. */
+	cpu =3D cpu >=3D 4 ? cpu * 2 : cpu + 4;
+#endif
+	while (cpu--) {
+		void *area =3D vmalloc(CONFIG_KCOV_IRQ_AREA_SIZE * sizeof(unsigned long)=
);
+		unsigned long flags;
=20
-	for_each_possible_cpu(cpu) {
-		void *area =3D vmalloc_node(CONFIG_KCOV_IRQ_AREA_SIZE *
-				sizeof(unsigned long), cpu_to_node(cpu));
 		if (!area)
 			return -ENOMEM;
-		per_cpu_ptr(&kcov_percpu_data, cpu)->irq_area =3D area;
+		spin_lock_irqsave(&kcov_remote_lock, flags);
+		kcov_remote_area_put(area, CONFIG_KCOV_IRQ_AREA_SIZE, true);
+		spin_unlock_irqrestore(&kcov_remote_lock, flags);
 	}
=20
 	/*
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1244dcac2294..12786379bf1d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2247,10 +2247,11 @@ config KCOV_INSTRUMENT_ALL
 config KCOV_IRQ_AREA_SIZE
 	hex "Size of interrupt coverage collection area in words"
 	depends on KCOV
+	range 0x80 0x1000000
 	default 0x40000
 	help
-	  KCOV uses preallocated per-cpu areas to collect coverage from
-	  soft interrupts. This specifies the size of those areas in the
+	  KCOV uses preallocated areas to collect coverage from soft
+	  interrupts. This specifies the size of those areas in the
 	  number of unsigned long words.
=20
 config KCOV_SELFTEST
--=20
2.55.0.229.g6434b31f56-goog

