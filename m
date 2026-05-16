Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF45A35F8C9
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 21:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778967332; cv=none; b=SmNZq+vL7Zl0r7wudkHdMYxPoiN0HmATlxk81MBLyOr2rZAWJ8kJQ3okhI1RfooUCM5ftX6tf9GR8E5Pb+tADgJHFd5K5Q5XhQB8EOql47t3RAhbbhwstBnSD/eQq6+M5DHbnbgSP4H9jO3DGiI4cPqXiIMrQMJM+jndaWA83fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778967332; c=relaxed/simple;
	bh=ej3SMcylPoZd51fQzu6JMFLQvE4yMp/hhrrSpZilKJE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=DsFvA5/TId/GjM/NaqLCLeOEM/J4dFKKRDSOYzOwjFnW9yk/4QIDrAROqP4/nPp2kfwsg90KVpVSzop1Afwh3EZY0ZqKl2H7A3pYvilw1wxa65/zAekNDI7LcxE/spsq05azmPt5mIFiCbn7dERQnu4RI2vpAdhnFRezaDZBgMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQhFRRVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQhFRRVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4AAC2BCB8;
	Sat, 16 May 2026 21:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778967331;
	bh=ej3SMcylPoZd51fQzu6JMFLQvE4yMp/hhrrSpZilKJE=;
	h=From:To:Cc:Subject:Date:From;
	b=iQhFRRVb2Bk8Q6kOXNpekeV1UlkuycV+NZGnog/cDk+HaTwdcb+jowWovvzxCKAmk
	 ho7WpbACQFAzLuOi+FVfcpcRZrjBDm2tUjwdqSq3U/F85wAAS1kZr381Sa39CYRWG6
	 EYykw7KmZAmhjpkP0vbEhYu5Uw2m+EgHg/4H44t5pgzEoAjTlaXJ533Ls8ryCqnGzI
	 6b7gUWzRkVxRh5TgWpCp+s4SFFKzzUmBtKePRLRepaU98dgMOh2GxtjSfCWVbuqMkh
	 xJYqwFD8SJXw9579hLlpNH/cYzYga046ODAKlWerkRnrrbrugRde1N6ekaDwAbGSAQ
	 BkIS9kJX0jv1g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] bpf: Fix null-ptr-deref in bpf_get_local_storage() on link update
Message-ID: <75f75da5-db7a-46b3-aa48-814d51a3e703@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 16 May 2026 21:35:31 +0000 (UTC)

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

Fixes: 4b82b181a26cff8bf7adc3a85a88d121d92edeaf ("bpf: Allow pre-ordering for bpf cgroup progs")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+4fe468a3f7fac86ea2c9@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=4fe468a3f7fac86ea2c9
Link: https://syzkaller.appspot.com/ai_job?id=ff8236be-bfa9-48fc-9c7e-9939ad17d937
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
v2:
- Dropped changes to __cgroup_bpf_attach() to reduce patch size.
- Added trampoline link and unlink handling for BPF_LSM_CGROUP programs in __cgroup_bpf_replace().
- Refactored error paths in __cgroup_bpf_replace() to use goto labels.

v1:
https://lore.kernel.org/all/6c0af3f2-ec3b-4331-a453-970522943a07@mail.kernel.org/T/
---
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 876f6a81a..a78b70e58 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -918,51 +918,6 @@ static int cgroup_bpf_attach(struct cgroup *cgrp,
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
@@ -978,10 +933,14 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
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
@@ -1001,11 +960,44 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	if (!found)
 		return -ENOENT;
 
+	err = bpf_cgroup_storages_alloc(storage, new_storage,
+					link->link.attach_type, new_prog, cgrp);
+	if (err)
+		return err;
+
+	bpf_cgroup_storages_assign(save_storage, pl->storage);
+	bpf_cgroup_storages_assign(pl->storage, storage);
+
+	if (link->link.attach_type == BPF_LSM_CGROUP) {
+		err = bpf_trampoline_link_cgroup_shim(new_prog, atype,
+						      link->link.attach_type);
+		if (err)
+			goto cleanup_storage;
+	}
+
 	cgrp->bpf.revisions[atype] += 1;
+
 	old_prog = xchg(&link->link.prog, new_prog);
-	replace_effective_prog(cgrp, atype, link);
+
+	err = update_effective_progs(cgrp, atype);
+	if (err)
+		goto cleanup_trampoline;
+
+	bpf_cgroup_storages_link(new_storage, cgrp, link->link.attach_type);
+	if (link->link.attach_type == BPF_LSM_CGROUP)
+		bpf_trampoline_unlink_cgroup_shim(old_prog);
 	bpf_prog_put(old_prog);
 	return 0;
+
+cleanup_trampoline:
+	xchg(&link->link.prog, old_prog);
+	cgrp->bpf.revisions[atype] -= 1;
+	if (link->link.attach_type == BPF_LSM_CGROUP)
+		bpf_trampoline_unlink_cgroup_shim(new_prog);
+cleanup_storage:
+	bpf_cgroup_storages_assign(pl->storage, save_storage);
+	bpf_cgroup_storages_free(new_storage);
+	return err;
 }
 
 static int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *new_prog,


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
