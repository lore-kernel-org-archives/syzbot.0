Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3683A2BB1D
	for <syzbot@lists.linux.dev>; Thu, 14 May 2026 00:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717110; cv=none; b=Ix//G7yiN7xZITWIYYmq/aEUc+tPCFUA2yGCdA1X1ljvnFboC+Aboo0lkqKxbGGx/ydXrcOTUzp2CSU2by9vzvq3ukmpitrnGDAhngkgN9/0nOJ6QhdMNMabIFZWH0DLOg4fNLPf8ZTK1fmdpdrLoKvdVfPH7GxV5jjVzJSICEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717110; c=relaxed/simple;
	bh=j2N3L13PpIxZVYn/FnSjJe1ysplVQeOCP5HX9JZVvo8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=l1mgHiy/VwK9sdlV2+/YtQ/vFYo9EkSkkAsXkCYPkTR3uUJ4Ur13tdy3kbgYHfo1OuS+3mXDj8FihlmCSzCauCLHU5w6CRkpp+xduhVBP90XypKLYfEHvjHf67aLHYVdjrqe38nYUcrpwpsiQl+0ca1DJGoCO0wULxqqMEFtQvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsC0JcYw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsC0JcYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4EBC32786;
	Thu, 14 May 2026 00:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778717110;
	bh=j2N3L13PpIxZVYn/FnSjJe1ysplVQeOCP5HX9JZVvo8=;
	h=From:To:Cc:Subject:Date:From;
	b=UsC0JcYw9Xj5m8TBv5QL8Rd0PkAzCyDiYdrPAPSSOOPE77SZFLIeoRr7707yUX4ba
	 loQWbIZJPkRrri2RTUK5zv58q85NAN3AT/lEYH8Batj0IelU9ORR/ePlScjoJ+/JW7
	 dCRbp7cPb6T/gqBQ/vPYybRWHVGeFXK1odMeABqDc3BfIMJdPjYfPAJxoW33gokdpu
	 tnnnXX6PFtXNUey9omVZl7dPof2Eo1eFGsZbSKA8eI/j/Px+PSkDyXfobZJ30Zs2T1
	 G3tV479xemUsHI1CG+gQAA7xQGMCwYSJowuA0cWi0Z/MQbz0ULV+DyoEKAAsdez2q+
	 /Ep8ffhSo3j2g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] bpf: Fix null-ptr-deref in bpf_get_local_storage() on link update
Message-ID: <6c0af3f2-ec3b-4331-a453-970522943a07@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 14 May 2026 00:05:09 +0000 (UTC)

The syzkaller reported a KASAN null-ptr-deref in
bpf_get_local_storage(). This occurs when a BPF program tries to access
its cgroup storage, but the storage pointer in the effective program
array is NULL.

The root cause is a bug in __cgroup_bpf_replace() which handles
BPF_LINK_UPDATE for cgroup links. When replacing a program that does not
use cgroup storage with one that does, __cgroup_bpf_replace() fails to
allocate the new cgroup storage. Furthermore, it uses
replace_effective_prog() which only updates the program pointer in the
effective array and ignores the cgroup_storage array. This leaves the
storage pointers as NULL, leading to a crash when the new program
executes and calls bpf_get_local_storage().

To fix this, rewrite __cgroup_bpf_replace() to properly allocate the new
cgroup storage, update the storage pointers, and rebuild the effective
arrays using update_effective_progs(). This ensures safe, RCU-protected
swapping of both the program and its storage. The
replace_effective_prog() function is fundamentally unsafe when cgroup
storage is involved and is removed entirely.

Additionally, fix a similar rollback bug in __cgroup_bpf_attach(). When
replacing an existing program (BPF_F_REPLACE), if
update_effective_progs() fails, the code restores the old program but
fails to restore the old storage pointers, leaving dangling pointers
after the new storage is freed. Save and restore the old storage
pointers to prevent a potential use-after-free.

Fixes: 0c991ebc8c69d29b7fc44db17075c5aa5253e2ab ("bpf: Implement bpf_prog replacement for an active bpf_cgroup_link")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+4fe468a3f7fac86ea2c9@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=4fe468a3f7fac86ea2c9
Link: https://syzkaller.appspot.com/ai_job?id=8b1e4143-642b-4b3e-8be9-194c7a66e24a
To: <bpf@vger.kernel.org>
To: <martin.lau@linux.dev>
Cc: <andrii@kernel.org>
Cc: <ast@kernel.org>
Cc: <daniel@iogearbox.net>
Cc: <eddyz87@gmail.com>
Cc: <jolsa@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <memxor@gmail.com>
Cc: <song@kernel.org>
Cc: <yonghong.song@linux.dev>

---
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 876f6a81a..625140a6e 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -792,6 +792,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	struct bpf_prog *old_prog = NULL;
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
+	struct bpf_cgroup_storage *save_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	struct bpf_prog *new_prog = prog ? : link->link.prog;
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog_list *pl;
@@ -844,6 +845,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 
 	if (pl) {
 		old_prog = pl->prog;
+		bpf_cgroup_storages_assign(save_storage, pl->storage);
 	} else {
 		pl = kmalloc_obj(*pl);
 		if (!pl) {
@@ -894,6 +896,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	if (old_prog) {
 		pl->prog = old_prog;
 		pl->link = NULL;
+		bpf_cgroup_storages_assign(pl->storage, save_storage);
 	}
 	bpf_cgroup_storages_free(new_storage);
 	if (!old_prog) {
@@ -918,51 +921,6 @@ static int cgroup_bpf_attach(struct cgroup *cgrp,
 	return ret;
 }
 
-/* Swap updated BPF program for given link in effective program arrays across
- * all descendant cgroups. This function is guaranteed to succeed.
- */
-static void replace_effective_prog(struct cgroup *cgrp,
-				   enum cgroup_bpf_attach_type atype,
-				   struct bpf_cgroup_link *link)
-{
-	struct bpf_prog_array_item *item;
-	struct cgroup_subsys_state *css;
-	struct bpf_prog_array *progs;
-	struct bpf_prog_list *pl;
-	struct hlist_head *head;
-	struct cgroup *cg;
-	int pos;
-
-	css_for_each_descendant_pre(css, &cgrp->self) {
-		struct cgroup *desc = container_of(css, struct cgroup, self);
-
-		if (percpu_ref_is_zero(&desc->bpf.refcnt))
-			continue;
-
-		/* find position of link in effective progs array */
-		for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
-			if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_MULTI))
-				continue;
-
-			head = &cg->bpf.progs[atype];
-			hlist_for_each_entry(pl, head, node) {
-				if (!prog_list_prog(pl))
-					continue;
-				if (pl->link == link)
-					goto found;
-				pos++;
-			}
-		}
-found:
-		BUG_ON(!cg);
-		progs = rcu_dereference_protected(
-				desc->bpf.effective[atype],
-				lockdep_is_held(&cgroup_mutex));
-		item = &progs->items[pos];
-		WRITE_ONCE(item->prog, link->link.prog);
-	}
-}
-
 /**
  * __cgroup_bpf_replace() - Replace link's program and propagate the change
  *                          to descendants
@@ -978,10 +936,14 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 				struct bpf_prog *new_prog)
 {
 	enum cgroup_bpf_attach_type atype;
+	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
+	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
+	struct bpf_cgroup_storage *save_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	struct bpf_prog *old_prog;
 	struct bpf_prog_list *pl;
 	struct hlist_head *progs;
 	bool found = false;
+	int err;
 
 	atype = bpf_cgroup_atype_find(link->link.attach_type, new_prog->aux->attach_btf_id);
 	if (atype < 0)
@@ -1001,9 +963,27 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	if (!found)
 		return -ENOENT;
 
+	err = bpf_cgroup_storages_alloc(storage, new_storage,
+					link->link.attach_type, new_prog, cgrp);
+	if (err)
+		return err;
+
+	bpf_cgroup_storages_assign(save_storage, pl->storage);
+	bpf_cgroup_storages_assign(pl->storage, storage);
 	cgrp->bpf.revisions[atype] += 1;
+
 	old_prog = xchg(&link->link.prog, new_prog);
-	replace_effective_prog(cgrp, atype, link);
+
+	err = update_effective_progs(cgrp, atype);
+	if (err) {
+		xchg(&link->link.prog, old_prog);
+		cgrp->bpf.revisions[atype] -= 1;
+		bpf_cgroup_storages_assign(pl->storage, save_storage);
+		bpf_cgroup_storages_free(new_storage);
+		return err;
+	}
+
+	bpf_cgroup_storages_link(new_storage, cgrp, link->link.attach_type);
 	bpf_prog_put(old_prog);
 	return 0;
 }


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
