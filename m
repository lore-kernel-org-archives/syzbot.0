Received: from mail-oo1-f66.google.com (mail-oo1-f66.google.com [209.85.161.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDCE33263B
	for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772127421; cv=none; b=pHkJ8E7310cSTedwq8mUININOX9nHSQwPPCXfKsofNPbHfRqBpLUfxO9sv831JCXu1jygoqLmERvXPMTUSVdWi7NwfqPogz/gXcw2R0cY9tzI7LMbaa571rY4HrXtUIg9dKOouR/Al8Bb3rdpN12QRvO7+WmILyJyua19yxuSFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772127421; c=relaxed/simple;
	bh=jBHJftfdEkpRGk+uQ6hJRnGlz9WKhhl/hRUdy9lkVYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5EufeMKh0lxJg54XQFUtYjWDFbjnDcBPoyElbn7D90e/Djvlz5sUhGSwxQquA1IQxm4RIK1BEfVh8tnpim5c1ytkTbBshouyPhmQnPCHpz140dOP3wKiR5IifWLX2/KpolGKAG659bT4yJXOpw3GmKpym4cLmroTfJC46wUPnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SOmqcwRw; arc=none smtp.client-ip=209.85.161.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SOmqcwRw"
Received: by mail-oo1-f66.google.com with SMTP id 006d021491bc7-6799774d0fcso504874eaf.3
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 09:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772127419; x=1772732219; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GOMTBEWuH4423HNvztxgpl6z8fS+IchghXHf7LurYSw=;
        b=SOmqcwRwEoZvWHuTKgiErSqPbtgL4HDlAsD78RLrQC9KT06/IJf2QUTG/SuoYQJfoI
         w1LPdmEDf7YdM+JMUpa41hBBMY6+Vho5BNWmUqeiDRlyZVsSdZu9QJv5UeN5QPqIZG4v
         C/wTk/lJIbg7o+C3j1BpngwtwwNwSdHgYBsUYFUcw3t8dDhMaXVjqjNlLkRub9+xPVsN
         6XPP0CPeIHn8wmvTU2HehiQxsQjUUbBgjP0w4zi642GWVMnkbRFeyeClaXJDRBA3h/e5
         J6cDXV0kyqzaY84BQOUqiR9F+Fp4Bb19yMC2fRL0K/dN0pICP1tey/g6E4Z7qp1wxTYO
         ZB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772127419; x=1772732219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GOMTBEWuH4423HNvztxgpl6z8fS+IchghXHf7LurYSw=;
        b=DgLC6GAePl95oKBpoNn0H/kGxQJ/Jb1iZ63viUQ6aaf7a4GSjpku7fHVb7atAiL/+z
         Qa/he70fFa8Dsi/i1OdtuLHDdEjxKmOQAeGJHDm17GKXymLFx8N9QyA/QYFL/od/5yAF
         oTrjRc2I1NnLjWzIruXGhqMN6YZqmqd34mTga/h/vWWFjBjNli4em4etCYK7cf/Bdyvt
         BpTerhaxngOca8yvfM0/W3mWaNT4ZE+zEDFOdEN24736wdkwsblKQ6z6perflaeyx3sh
         ImQzOA4SkUdgZ5obspmP+KD2cZI8jU1DkScYb8HoL8ze3XdG0mY6lke744Vo00nZeFRu
         G1eQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV0naQzOSpeql9fG2fjzIZsSalvvCK3USWyijflcxBmUDO4pyeDPkFvmeU7Qntr8HquZSRnns=@lists.linux.dev
X-Gm-Message-State: AOJu0YyP0WlIyG5eYcE1qPyVVuYLZwJevhyNZJep09IVUAIN+Swetwzb
	/uT6qTOwT30K9DYoNQ+mrSulC60wjq/c6qVWrM0bNQyyycY+qCrQYnPB
X-Gm-Gg: ATEYQzwVtohA8O8bb3au0V+XrB8j3oa3MxVkcV0PXoOC6txBREEjYufnfB7elYW4Grq
	3iYmNbum2jTwhhvF5Gb1J6nNue3bjI7UUuvL41qkWJo9UZYrMXP3p5D1/lmphGSYKfKjJ+OI+L9
	gw2bEhVb7yiyPb2JKSOf/dfVUwaOyhfz1MFL97zTejkKiXn7rPkLK5+XSMkr/4rRZOHChZaMZk5
	UeMz9UewJD/mHIP7wRhbLcSlr4v036ivQmHOT5aBSDUNOpxmXrF6cMNXGf4aV8DJifAei8bfGoo
	Pz+w2f8RMONgGdygDjVKEaSkaEz5ICg0S3+RCjPyNoN4HMMFEVfAa/wo8ehlUNvBkX2T6zGPFmu
	d+JCpz00W/1Pg1HEDlkIboTI6MB+pqSnmxtRAIsmwJIbiyLkCFcuvWFwczplZrvRCvFjBZi1rCV
	7MpD3hZe3iAM9yL9Gcyq0rda0B9qjuIh0Vj/w+wDW/0tI=
X-Received: by 2002:a05:6820:290f:b0:679:e85c:10e3 with SMTP id 006d021491bc7-679fadb9741mr58740eaf.2.1772127419115;
        Thu, 26 Feb 2026 09:36:59 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cf2572bsm2264925fac.2.2026.02.26.09.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 09:36:58 -0800 (PST)
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
To: syzbot+ci3826af8b4f91bf97@syzkaller.appspotmail.com
Cc: andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kernel-team@meta.com,
	kkd@meta.com,
	martin.lau@kernel.org,
	memxor@gmail.com,
	paulmck@kernel.org,
	syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	yatsenko@meta.com
Subject: [syzbot ci] Re: Close race in freeing special fields and map value
Date: Thu, 26 Feb 2026 09:36:57 -0800
Message-ID: <20260226173657.1285415-1-memxor@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <69a01309.050a0220.2fcbed.0007.GAE@google.com>
References: <69a01309.050a0220.2fcbed.0007.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test
---

diff --git a/include/linux/bpf_mem_alloc.h b/include/linux/bpf_mem_alloc.h
index 7517eaf94ac9..4ce0d27f8ea2 100644
--- a/include/linux/bpf_mem_alloc.h
+++ b/include/linux/bpf_mem_alloc.h
@@ -14,7 +14,7 @@ struct bpf_mem_alloc {
 	struct obj_cgroup *objcg;
 	bool percpu;
 	struct work_struct work;
-	void (*dtor)(void *obj, void *ctx);
+	void (*dtor_ctx_free)(void *ctx);
 	void *dtor_ctx;
 };

@@ -35,7 +35,9 @@ int bpf_mem_alloc_percpu_init(struct bpf_mem_alloc *ma, struct obj_cgroup *objcg
 int bpf_mem_alloc_percpu_unit_init(struct bpf_mem_alloc *ma, int size);
 void bpf_mem_alloc_destroy(struct bpf_mem_alloc *ma);
 void bpf_mem_alloc_set_dtor(struct bpf_mem_alloc *ma,
-			    void (*dtor)(void *obj, void *ctx), void *ctx);
+			    void (*dtor)(void *obj, void *ctx),
+			    void (*dtor_ctx_free)(void *ctx),
+			    void *ctx);

 /* Check the allocation size for kmalloc equivalent allocator */
 int bpf_mem_alloc_check_size(bool percpu, size_t size);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 74f7a6f44c50..582f0192b7e1 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -125,6 +125,11 @@ struct htab_elem {
 	char key[] __aligned(8);
 };

+struct htab_btf_record {
+	struct btf_record *record;
+	u32 key_size;
+};
+
 static inline bool htab_is_prealloc(const struct bpf_htab *htab)
 {
 	return !(htab->map.map_flags & BPF_F_NO_PREALLOC);
@@ -459,28 +464,80 @@ static int htab_map_alloc_check(union bpf_attr *attr)

 static void htab_mem_dtor(void *obj, void *ctx)
 {
-	struct bpf_htab *htab = ctx;
+	struct htab_btf_record *hrec = ctx;
 	struct htab_elem *elem = obj;
 	void *map_value;

-	if (IS_ERR_OR_NULL(htab->map.record))
+	if (IS_ERR_OR_NULL(hrec->record))
 		return;

-	map_value = htab_elem_value(elem, htab->map.key_size);
-	bpf_obj_free_fields(htab->map.record, map_value);
+	map_value = htab_elem_value(elem, hrec->key_size);
+	bpf_obj_free_fields(hrec->record, map_value);
 }

 static void htab_pcpu_mem_dtor(void *obj, void *ctx)
 {
-	struct bpf_htab *htab = ctx;
 	void __percpu *pptr = *(void __percpu **)obj;
+	struct htab_btf_record *hrec = ctx;
 	int cpu;

-	if (IS_ERR_OR_NULL(htab->map.record))
+	if (IS_ERR_OR_NULL(hrec->record))
 		return;

 	for_each_possible_cpu(cpu)
-		bpf_obj_free_fields(htab->map.record, per_cpu_ptr(pptr, cpu));
+		bpf_obj_free_fields(hrec->record, per_cpu_ptr(pptr, cpu));
+}
+
+static void htab_dtor_ctx_free(void *ctx)
+{
+	struct htab_btf_record *hrec = ctx;
+
+	btf_record_free(hrec->record);
+	kfree(ctx);
+}
+
+static int htab_set_dtor(const struct bpf_htab *htab, void (*dtor)(void *, void *))
+{
+	u32 key_size = htab->map.key_size;
+	const struct bpf_mem_alloc *ma;
+	struct htab_btf_record *hrec;
+	int err;
+
+	/* No need for dtors. */
+	if (IS_ERR_OR_NULL(htab->map.record))
+		return 0;
+
+	hrec = kzalloc(sizeof(*hrec), GFP_KERNEL);
+	if (!hrec)
+		return -ENOMEM;
+	hrec->key_size = key_size;
+	hrec->record = btf_record_dup(htab->map.record);
+	if (IS_ERR(hrec->record)) {
+		err = PTR_ERR(hrec->record);
+		kfree(hrec);
+		return err;
+	}
+	ma = htab_is_percpu(htab) ? &htab->pcpu_ma : &htab->ma;
+	/* Kinda sad, but cast away const-ness since we change ma->dtor. */
+	bpf_mem_alloc_set_dtor((struct bpf_mem_alloc *)ma, dtor, htab_dtor_ctx_free, hrec);
+	return 0;
+}
+
+static int htab_map_check_btf(const struct bpf_map *map, const struct btf *btf,
+			      const struct btf_type *key_type, const struct btf_type *value_type)
+{
+	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
+
+	if (htab_is_prealloc(htab))
+		return 0;
+	/*
+	 * We must set the dtor using this callback, as map's BTF record is not
+	 * populated in htab_map_alloc(), so it will always appear as NULL.
+	 */
+	if (htab_is_percpu(htab))
+		return htab_set_dtor(htab, htab_pcpu_mem_dtor);
+	else
+		return htab_set_dtor(htab, htab_mem_dtor);
 }

 static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
@@ -595,17 +652,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 						 round_up(htab->map.value_size, 8), true);
 			if (err)
 				goto free_map_locked;
-			/* See comment below */
-			bpf_mem_alloc_set_dtor(&htab->pcpu_ma, htab_pcpu_mem_dtor, htab);
-		} else {
-			/*
-			 * Register the dtor unconditionally.  map->record is
-			 * set by map_create() after map_alloc() returns, so it
-			 * is always NULL at this point.  The dtor checks
-			 * IS_ERR_OR_NULL(htab->map.record) and becomes a no-op
-			 * for maps without special fields.
-			 */
-			bpf_mem_alloc_set_dtor(&htab->ma, htab_mem_dtor, htab);
 		}
 	}

@@ -2318,6 +2364,7 @@ const struct bpf_map_ops htab_map_ops = {
 	.map_seq_show_elem = htab_map_seq_show_elem,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
+	.map_check_btf = htab_map_check_btf,
 	.map_mem_usage = htab_map_mem_usage,
 	BATCH_OPS(htab),
 	.map_btf_id = &htab_map_btf_ids[0],
@@ -2340,6 +2387,7 @@ const struct bpf_map_ops htab_lru_map_ops = {
 	.map_seq_show_elem = htab_map_seq_show_elem,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
+	.map_check_btf = htab_map_check_btf,
 	.map_mem_usage = htab_map_mem_usage,
 	BATCH_OPS(htab_lru),
 	.map_btf_id = &htab_map_btf_ids[0],
@@ -2519,6 +2567,7 @@ const struct bpf_map_ops htab_percpu_map_ops = {
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
+	.map_check_btf = htab_map_check_btf,
 	.map_mem_usage = htab_map_mem_usage,
 	BATCH_OPS(htab_percpu),
 	.map_btf_id = &htab_map_btf_ids[0],
@@ -2539,6 +2588,7 @@ const struct bpf_map_ops htab_lru_percpu_map_ops = {
 	.map_seq_show_elem = htab_percpu_map_seq_show_elem,
 	.map_set_for_each_callback_args = map_set_for_each_callback_args,
 	.map_for_each_callback = bpf_for_each_hash_elem,
+	.map_check_btf = htab_map_check_btf,
 	.map_mem_usage = htab_map_mem_usage,
 	BATCH_OPS(htab_lru_percpu),
 	.map_btf_id = &htab_map_btf_ids[0],
diff --git a/kernel/bpf/memalloc.c b/kernel/bpf/memalloc.c
index 137e855c718b..682a9f34214b 100644
--- a/kernel/bpf/memalloc.c
+++ b/kernel/bpf/memalloc.c
@@ -102,7 +102,8 @@ struct bpf_mem_cache {
 	int percpu_size;
 	bool draining;
 	struct bpf_mem_cache *tgt;
-	struct bpf_mem_alloc *ma;
+	void (*dtor)(void *obj, void *ctx);
+	void *dtor_ctx;

 	/* list of objects to be freed after RCU GP */
 	struct llist_head free_by_rcu;
@@ -261,15 +262,14 @@ static void free_one(void *obj, bool percpu)
 	kfree(obj);
 }

-static int free_all(struct llist_node *llnode, bool percpu,
-		    struct bpf_mem_alloc *ma)
+static int free_all(struct bpf_mem_cache *c, struct llist_node *llnode, bool percpu)
 {
 	struct llist_node *pos, *t;
 	int cnt = 0;

 	llist_for_each_safe(pos, t, llnode) {
-		if (ma->dtor)
-			ma->dtor((void *)pos + LLIST_NODE_SZ, ma->dtor_ctx);
+		if (c->dtor)
+			c->dtor((void *)pos + LLIST_NODE_SZ, c->dtor_ctx);
 		free_one(pos, percpu);
 		cnt++;
 	}
@@ -280,7 +280,7 @@ static void __free_rcu(struct rcu_head *head)
 {
 	struct bpf_mem_cache *c = container_of(head, struct bpf_mem_cache, rcu_ttrace);

-	free_all(llist_del_all(&c->waiting_for_gp_ttrace), !!c->percpu_size, c->ma);
+	free_all(c, llist_del_all(&c->waiting_for_gp_ttrace), !!c->percpu_size);
 	atomic_set(&c->call_rcu_ttrace_in_progress, 0);
 }

@@ -312,7 +312,7 @@ static void do_call_rcu_ttrace(struct bpf_mem_cache *c)
 	if (atomic_xchg(&c->call_rcu_ttrace_in_progress, 1)) {
 		if (unlikely(READ_ONCE(c->draining))) {
 			llnode = llist_del_all(&c->free_by_rcu_ttrace);
-			free_all(llnode, !!c->percpu_size, c->ma);
+			free_all(c, llnode, !!c->percpu_size);
 		}
 		return;
 	}
@@ -421,7 +421,7 @@ static void check_free_by_rcu(struct bpf_mem_cache *c)
 	dec_active(c, &flags);

 	if (unlikely(READ_ONCE(c->draining))) {
-		free_all(llist_del_all(&c->waiting_for_gp), !!c->percpu_size, c->ma);
+		free_all(c, llist_del_all(&c->waiting_for_gp), !!c->percpu_size);
 		atomic_set(&c->call_rcu_in_progress, 0);
 	} else {
 		call_rcu_hurry(&c->rcu, __free_by_rcu);
@@ -546,7 +546,6 @@ int bpf_mem_alloc_init(struct bpf_mem_alloc *ma, int size, bool percpu)
 			c->objcg = objcg;
 			c->percpu_size = percpu_size;
 			c->tgt = c;
-			c->ma = ma;
 			init_refill_work(c);
 			prefill_mem_cache(c, cpu);
 		}
@@ -569,7 +568,6 @@ int bpf_mem_alloc_init(struct bpf_mem_alloc *ma, int size, bool percpu)
 			c->objcg = objcg;
 			c->percpu_size = percpu_size;
 			c->tgt = c;
-			c->ma = ma;

 			init_refill_work(c);
 			prefill_mem_cache(c, cpu);
@@ -622,7 +620,6 @@ int bpf_mem_alloc_percpu_unit_init(struct bpf_mem_alloc *ma, int size)
 		c->objcg = objcg;
 		c->percpu_size = percpu_size;
 		c->tgt = c;
-		c->ma = ma;

 		init_refill_work(c);
 		prefill_mem_cache(c, cpu);
@@ -631,7 +628,7 @@ int bpf_mem_alloc_percpu_unit_init(struct bpf_mem_alloc *ma, int size)
 	return 0;
 }

-static void drain_mem_cache(struct bpf_mem_cache *c, struct bpf_mem_alloc *ma)
+static void drain_mem_cache(struct bpf_mem_cache *c)
 {
 	bool percpu = !!c->percpu_size;

@@ -642,13 +639,13 @@ static void drain_mem_cache(struct bpf_mem_cache *c, struct bpf_mem_alloc *ma)
 	 * Except for waiting_for_gp_ttrace list, there are no concurrent operations
 	 * on these lists, so it is safe to use __llist_del_all().
 	 */
-	free_all(llist_del_all(&c->free_by_rcu_ttrace), percpu, ma);
-	free_all(llist_del_all(&c->waiting_for_gp_ttrace), percpu, ma);
-	free_all(__llist_del_all(&c->free_llist), percpu, ma);
-	free_all(__llist_del_all(&c->free_llist_extra), percpu, ma);
-	free_all(__llist_del_all(&c->free_by_rcu), percpu, ma);
-	free_all(__llist_del_all(&c->free_llist_extra_rcu), percpu, ma);
-	free_all(llist_del_all(&c->waiting_for_gp), percpu, ma);
+	free_all(c, llist_del_all(&c->free_by_rcu_ttrace), percpu);
+	free_all(c, llist_del_all(&c->waiting_for_gp_ttrace), percpu);
+	free_all(c, __llist_del_all(&c->free_llist), percpu);
+	free_all(c, __llist_del_all(&c->free_llist_extra), percpu);
+	free_all(c, __llist_del_all(&c->free_by_rcu), percpu);
+	free_all(c, __llist_del_all(&c->free_llist_extra_rcu), percpu);
+	free_all(c, llist_del_all(&c->waiting_for_gp), percpu);
 }

 static void check_mem_cache(struct bpf_mem_cache *c)
@@ -687,6 +684,9 @@ static void check_leaked_objs(struct bpf_mem_alloc *ma)

 static void free_mem_alloc_no_barrier(struct bpf_mem_alloc *ma)
 {
+	/* We can free dtor ctx only once all callbacks are done using it. */
+	if (ma->dtor_ctx_free)
+		ma->dtor_ctx_free(ma->dtor_ctx);
 	check_leaked_objs(ma);
 	free_percpu(ma->cache);
 	free_percpu(ma->caches);
@@ -758,7 +758,7 @@ void bpf_mem_alloc_destroy(struct bpf_mem_alloc *ma)
 			c = per_cpu_ptr(ma->cache, cpu);
 			WRITE_ONCE(c->draining, true);
 			irq_work_sync(&c->refill_work);
-			drain_mem_cache(c, ma);
+			drain_mem_cache(c);
 			rcu_in_progress += atomic_read(&c->call_rcu_ttrace_in_progress);
 			rcu_in_progress += atomic_read(&c->call_rcu_in_progress);
 		}
@@ -773,7 +773,7 @@ void bpf_mem_alloc_destroy(struct bpf_mem_alloc *ma)
 				c = &cc->cache[i];
 				WRITE_ONCE(c->draining, true);
 				irq_work_sync(&c->refill_work);
-				drain_mem_cache(c, ma);
+				drain_mem_cache(c);
 				rcu_in_progress += atomic_read(&c->call_rcu_ttrace_in_progress);
 				rcu_in_progress += atomic_read(&c->call_rcu_in_progress);
 			}
@@ -1022,9 +1022,31 @@ int bpf_mem_alloc_check_size(bool percpu, size_t size)
 	return 0;
 }

-void bpf_mem_alloc_set_dtor(struct bpf_mem_alloc *ma,
-			    void (*dtor)(void *obj, void *ctx), void *ctx)
+void bpf_mem_alloc_set_dtor(struct bpf_mem_alloc *ma, void (*dtor)(void *obj, void *ctx),
+			    void (*dtor_ctx_free)(void *ctx), void *ctx)
 {
-	ma->dtor = dtor;
+	struct bpf_mem_caches *cc;
+	struct bpf_mem_cache *c;
+	int cpu, i;
+
+	ma->dtor_ctx_free = dtor_ctx_free;
 	ma->dtor_ctx = ctx;
+
+	if (ma->cache) {
+		for_each_possible_cpu(cpu) {
+			c = per_cpu_ptr(ma->cache, cpu);
+			c->dtor = dtor;
+			c->dtor_ctx = ctx;
+		}
+	}
+	if (ma->caches) {
+		for_each_possible_cpu(cpu) {
+			cc = per_cpu_ptr(ma->caches, cpu);
+			for (i = 0; i < NUM_CACHES; i++) {
+				c = &cc->cache[i];
+				c->dtor = dtor;
+				c->dtor_ctx = ctx;
+			}
+		}
+	}
 }
