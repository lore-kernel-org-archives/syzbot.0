Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822733B42D8
	for <syzbot@lists.linux.dev>; Sun,  2 Aug 2026 21:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785705674; cv=none; b=CyGeC3+AU7MQ6KO2dxsJ0ed/QSKuAB6DKK46eTLZlFY+H5sVMJ7SCPnIZDd5Q4+3gaMb8nI2EIFN9HUu4gyO228VrMkCNtop0b17Pd6h1+OXnL5FFWtKB2qoTXbmu+rEftL+BAnAKDfA2RWML4HjIkZSPhsxH8cUJ0ghRiutJGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785705674; c=relaxed/simple;
	bh=2alo3ztX/owlnwJzM5A57JRvFiroyl831EfoufofeeI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=omCmSsqxRKDUFkpODWvhSs6/m/VGML6eC+K5vDEvScNBc91Zj0SgkJ/FfiertlqWOfmssDK3XXA/8SFi7FtlVDNPRWinNNY9cEMIjEyjy0DgX5GWhPjMUM6FOfVhyVlbC9S0aWC0tj8OfTXLymRTx2lt2bwSE1o2Nw9cf6uJc1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDTmeIC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDTmeIC9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 769BE1F000E9;
	Sun,  2 Aug 2026 21:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785705670;
	bh=oTYOeOvPbLL+Q00jQr8LcOoGzQGbgoTMNilAmpqduBQ=;
	h=From:To:Cc:Subject:Date;
	b=lDTmeIC9WLP6PKrBaVYpX0gSQYv8H5uF90exVnliOY0279WOevNMd8UmSsVbt4I7w
	 /1hpTsoqLhgrOVe2QHjRXw6lcquH2vPVxHerRlogeYuDMlkMPlAR/RD8id+w3fqpJ/
	 witntEqaRBC4o5VUVx5Jp5YLYP8XpAGNBNog5/gVh8gE/tdB7CGEaJRwGcBcYDeeo+
	 9Xe5DUa9cS/f0hgYdDcWbu4aEE/h65+YgAK/Lo8+s60tKu1AVpWa3s8scVBMokP4Oa
	 I0zt0rklCrJK2ZBi9QH2HmS41aSmGe/GZp3vD2ywo9T8aG+zNajkLu1n0BLbdJxOeN
	 mDfw+JcDBgBIA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] rhashtable: use unique lockdep classes for bucket locks
Message-ID: <fbb936dc-916f-4cb5-bd46-a43c4710d586@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun,  2 Aug 2026 21:21:10 +0000 (UTC)

Lockdep reports an inconsistent lock state (`{INITIAL USE} -> {IN-NMI}`)
when a BPF program deletes an element from a `BPF_MAP_TYPE_RHASH` map in
NMI context:

  inconsistent {INITIAL USE} -> {IN-NMI} usage.
  ...
  Possible unsafe locking scenario:

        CPU0
        ====
   lock(rhashtable_bucket);
   <Interrupt>
     lock(rhashtable_bucket);

  *** DEADLOCK ***

The `{INITIAL USE}` of the lock is registered during process creation when
`pidfs_add_pid()` inserts a new PID into the `pidfs_ino_ht` rhashtable and
acquires the bucket lock in normal process context. Later, a BPF program
attached to a hardware breakpoint executes in NMI context and calls
`bpf_map_delete_elem()` on a `BPF_MAP_TYPE_RHASH` map. This calls
`rhashtable_remove_fast()`, which acquires the bucket lock in NMI context,
triggering the lockdep warning.

This is a false positive caused by all `rhashtable` instances in the kernel
sharing the exact same lock class for their bucket locks. The bucket table
allocation function `bucket_table_alloc()` initializes the lockdep map for
the bucket locks using a single static key. Thus, lockdep assumes that the
bucket lock acquired by the BPF program in NMI context is the same lock
acquired by `pidfs` in normal process context, leading to a perceived
deadlock.

In reality, they operate on completely different `rhashtable` instances.
Furthermore, a real deadlock on the same `BPF_MAP_TYPE_RHASH` instance is
explicitly prevented by the BPF subsystem using
`bpf_disable_instrumentation()`, which increments the per-CPU
`bpf_prog_active` counter and prevents reentrancy.

To fix this, update the `rhashtable` API to allow different lock classes
for the bucket locks of different `rhashtable` instances. Extend the
initialization macros to generate a unique static `lock_class_key` for the
bucket locks and pass it down to `bucket_table_alloc()`.

For BPF maps, use `__lockdep_no_track__` to completely bypass lockdep
tracking for the bucket locks. This avoids issues with shared global keys
like `__lockdep_no_validate__` (which can cause invalid wait context
warnings if previously registered as a mutex by another subsystem) while
relying on BPF's internal NMI deadlock prevention mechanism.

Fixes: 16b4d3e2fb24 ("bpf: Implement resizable hashmap basic functions")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+2fb31ade2d0e920fea9a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2fb31ade2d0e920fea9a
Link: https://syzkaller.appspot.com/ai_job?id=31a9ea31-9998-4618-b127-6dbc2e463ee9
To: "Andrew Morton" <akpm@linux-foundation.org>
To: "Andrii Nakryiko" <andrii@kernel.org>
To: "Alexei Starovoitov" <ast@kernel.org>
To: <bpf@vger.kernel.org>
To: "Daniel Borkmann" <daniel@iogearbox.net>
To: "Eduard Zingerman" <eddyz87@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
To: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Thomas Graf" <tgraf@suug.ch>
To: "Mykyta Yatsenko" <yatsenko@meta.com>
Cc: "Emil Tsalapatis" <emil@etsalapatis.com>
Cc: "Jiri Olsa" <jolsa@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Martin KaFai Lau" <martin.lau@linux.dev>
Cc: "Song Liu" <song@kernel.org>
Cc: "Yonghong Song" <yonghong.song@linux.dev>

---
diff --git a/include/linux/rhashtable-types.h b/include/linux/rhashtable-types.h
index 57c11ec9d..059f21e37 100644
--- a/include/linux/rhashtable-types.h
+++ b/include/linux/rhashtable-types.h
@@ -94,6 +94,9 @@ struct rhashtable {
 	struct mutex                    mutex;
 	spinlock_t			lock;
 	atomic_t			nelems;
+#ifdef CONFIG_LOCKDEP
+	struct lock_class_key	*dep_key;
+#endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 	struct alloc_tag		*alloc_tag;
 #endif
@@ -138,23 +141,27 @@ struct rhashtable_iter {
 
 int __rhashtable_init_noprof(struct rhashtable *ht,
 		    const struct rhashtable_params *params,
-		    struct lock_class_key *key);
+		    struct lock_class_key *key,
+		    struct lock_class_key *bucket_key);
 #define rhashtable_init_noprof(ht, params)				\
 ({									\
 	static struct lock_class_key __key;				\
+	static struct lock_class_key __bucket_key;			\
 									\
-	__rhashtable_init_noprof(ht, params, &__key);			\
+	__rhashtable_init_noprof(ht, params, &__key, &__bucket_key);	\
 })
 #define rhashtable_init(...)	alloc_hooks(rhashtable_init_noprof(__VA_ARGS__))
 
 int __rhltable_init_noprof(struct rhltable *hlt,
 		  const struct rhashtable_params *params,
-		  struct lock_class_key *key);
+		  struct lock_class_key *key,
+		  struct lock_class_key *bucket_key);
 #define rhltable_init_noprof(hlt, params)				\
 ({									\
 	static struct lock_class_key __key;				\
+	static struct lock_class_key __bucket_key;			\
 									\
-	__rhltable_init_noprof(hlt, params, &__key);			\
+	__rhltable_init_noprof(hlt, params, &__key, &__bucket_key);	\
 })
 #define rhltable_init(...)	alloc_hooks(rhltable_init_noprof(__VA_ARGS__))
 
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 9f394e1aa..d7e2a601c 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2822,7 +2822,19 @@ static struct bpf_map *rhtab_map_alloc(union bpf_attr *attr)
 		params.obj_cmpfn = rhtab_key_cmp_long;
 	}
 
-	err = rhashtable_init(&rhtab->ht, &params);
+#ifdef CONFIG_LOCKDEP
+#define bpf_rhashtable_init(ht, params)					\
+	({								\
+		static struct lock_class_key __key;			\
+									\
+		__rhashtable_init_noprof(ht, params, &__key,		\
+					 &__lockdep_no_track__);	\
+	})
+#else
+#define bpf_rhashtable_init(ht, params) rhashtable_init_noprof(ht, params)
+#endif
+	err = alloc_hooks(bpf_rhashtable_init(&rhtab->ht, &params));
+#undef bpf_rhashtable_init
 	if (err)
 		goto free_rhtab;
 
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index d459bef24..f872136ca 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -205,7 +205,12 @@ static struct bucket_table *bucket_table_alloc(struct rhashtable *ht,
 	if (tbl == NULL)
 		return NULL;
 
-	lockdep_init_map(&tbl->dep_map, "rhashtable_bucket", &__key, 0);
+#ifdef CONFIG_LOCKDEP
+	if (ht->dep_key)
+		lockdep_init_map(&tbl->dep_map, "rhashtable_bucket", ht->dep_key, 0);
+	else
+#endif
+		lockdep_init_map(&tbl->dep_map, "rhashtable_bucket", &__key, 0);
 
 	tbl->size = size;
 
@@ -1162,7 +1167,8 @@ static u32 rhashtable_jhash2(const void *key, u32 length, u32 seed)
  */
 int __rhashtable_init_noprof(struct rhashtable *ht,
 		    const struct rhashtable_params *params,
-		    struct lock_class_key *key)
+		    struct lock_class_key *key,
+		    struct lock_class_key *bucket_key)
 {
 	struct bucket_table *tbl;
 	size_t size;
@@ -1176,6 +1182,10 @@ int __rhashtable_init_noprof(struct rhashtable *ht,
 	spin_lock_init(&ht->lock);
 	memcpy(&ht->p, params, sizeof(*params));
 
+#ifdef CONFIG_LOCKDEP
+	ht->dep_key = bucket_key;
+#endif
+
 	alloc_tag_record(ht->alloc_tag);
 
 	if (params->min_size)
@@ -1237,11 +1247,12 @@ EXPORT_SYMBOL_GPL(__rhashtable_init_noprof);
  */
 int __rhltable_init_noprof(struct rhltable *hlt,
 			   const struct rhashtable_params *params,
-			   struct lock_class_key *key)
+			   struct lock_class_key *key,
+			   struct lock_class_key *bucket_key)
 {
 	int err;
 
-	err = __rhashtable_init_noprof(&hlt->ht, params, key);
+	err = __rhashtable_init_noprof(&hlt->ht, params, key, bucket_key);
 	hlt->ht.rhlist = true;
 	return err;
 }


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
