Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1958A49E5C0
	for <syzbot@lists.linux.dev>; Tue,  1 Sep 2026 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788287391; cv=none; b=esqk6BhyHAgQYO/B6MJSr5Ogfwy7IhngizVaSQqvPYw11KL4qjBS48KoSHKVP0OKCgh/WaSkElxf6QyBc+Hn8ZSkzNPrMdSo2g7KLuricS0QuXOFMzsQrTcSBDznJcByGPpO8DpQcXlLvyWqQcdznucSy1aFtuLPho/c8LEVP54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788287391; c=relaxed/simple;
	bh=vGk5aKaDOsNix82gp0chmsQz9wsPGi8RCcHToECmlRE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=HF7hhVbmmXc3ZFum0v5ZN2Nql8Lndtr6cuFU4u2lwBzAknII+5+rtv/YULj3DqXL+vts3RGziJKZVUh/daN3x/dcTd7AhgucS3c+p3SCBx9s4PY9L/f0GLPU+k5IyT9Qttv2u6tobcD8dKjpEhugWCJZRbYhWJiSeG0AXty4PfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnpYMu4d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnpYMu4d"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E34861F000E9;
	Tue,  1 Sep 2026 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788287382;
	bh=yTiulQIlNuu715y1c5xlkLwqz/hJnTIaFYfWhaV4MuM=;
	h=From:To:Cc:Subject:Date;
	b=WnpYMu4dRcI+mCIdAVVWdI8gk9GSF7lTrTos4R0frBnNw8THaxwHYbbQkvAg7j8T9
	 1B/gtWi4ygsOuQlfS6ssmZxrzblu8PqCXNklCbAuZlDa84+TjGQ7hvn+A+NdtkU1ix
	 2tRuvBXdhlYPqbCp7KkDBee5BcCn1PQ2D+cZ+Kz3zx8sqPpRV6NjCh3axLbXbxHTG4
	 +uIHj2kSU+JxfkysDL5939rxrU0EAtmnAWPG90XYrDR1FdvOcVUax6fgCtbZ8FvFil
	 0L+xfnwKlW3xeFQphndLAWkjcY9dE7RCoz5kPF8qYjUMAPIAdBaQWkF5bQ/nYTI7LV
	 pMyb/KtafvvWg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] drm/atomic: Cache new_active to avoid UAF in wait_for_vblanks
Message-ID: <622952fb-4d78-43c4-8ef6-a3ea282bf365@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  1 Sep 2026 18:29:41 +0000 (UTC)

In DRM atomic modesetting, non-blocking atomic commits defer the execution
of commit_tail to a workqueue worker. Once
drm_atomic_helper_commit_hw_done() is called during commit_tail, hardware
programming is marked as complete, allowing subsequent commits waiting in
drm_atomic_helper_wait_for_dependencies() to proceed. The subsequent commit
can then swap CRTC states and free the previous state (which was the
non-blocking commit's new_crtc_state) once its commit cycle completes.
Consequently, accessing new_crtc_state after
drm_atomic_helper_commit_hw_done() is unsafe.

However, drm_atomic_helper_wait_for_vblanks() is called after
drm_atomic_helper_commit_hw_done() and iterates over CRTCs using
for_each_oldnew_crtc_in_state(), directly dereferencing
new_crtc_state->active. If the commit worker is preempted immediately after
calling drm_atomic_helper_commit_hw_done(), a concurrent commit can run to
completion and free the state in drm_atomic_commit_default_clear(). When
the worker resumes and runs drm_atomic_helper_wait_for_vblanks(), accessing
new_crtc_state->active triggers a slab-use-after-free:

==================================================================
BUG: KASAN: slab-use-after-free in
drm_atomic_helper_wait_for_vblanks+0x317/0x8f0
drivers/gpu/drm/drm_atomic_helper.c:1905
Read of size 1 at addr ffff88819b694c09 by task kworker/u10:4/87

Workqueue: events_unbound commit_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 drm_atomic_helper_wait_for_vblanks+0x317/0x8f0
 drivers/gpu/drm/drm_atomic_helper.c:1905
 drm_atomic_helper_commit_tail+0x2e9/0x510
 drivers/gpu/drm/drm_atomic_helper.c:2003
 commit_tail+0x2b1/0x3c0 drivers/gpu/drm/drm_atomic_helper.c:2080
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3470
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3551
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 11498:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
 drm_atomic_helper_crtc_duplicate_state+0x72/0xb0
 drivers/gpu/drm/drm_atomic_state_helper.c:204
 drm_atomic_get_crtc_state+0x1b3/0x570 drivers/gpu/drm/drm_atomic.c:462
 page_flip_common+0x56/0x2a0 drivers/gpu/drm/drm_atomic_helper.c:3947
 drm_atomic_helper_page_flip+0xa5/0x160
 drivers/gpu/drm/drm_atomic_helper.c:4008
 drm_mode_page_flip_ioctl+0xe2d/0x13d0 drivers/gpu/drm/drm_plane.c:1543
 drm_ioctl+0x70e/0xba0 drivers/gpu/drm/drm_ioctl.c:914
 do_syscall_64+0x155/0x510 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 11498:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kfree+0x1c5/0x650 mm/slub.c:6792
 drm_atomic_commit_default_clear+0x47f/0xf00
 drivers/gpu/drm/drm_atomic.c:311
 drm_atomic_commit_clear drivers/gpu/drm/drm_atomic.c:394 [inline]
 __drm_atomic_commit_free+0xb4/0x230 drivers/gpu/drm/drm_atomic.c:411
 drm_atomic_commit_put include/drm/drm_atomic.h:713 [inline]
 drm_client_modeset_commit_atomic+0x6ec/0x7e0
 drivers/gpu/drm/drm_client_modeset.c:1110
 drm_client_modeset_commit_locked+0xcb/0x4d0
 drivers/gpu/drm/drm_client_modeset.c:1207
 drm_client_modeset_commit+0x4a/0x70
 drivers/gpu/drm/drm_client_modeset.c:1233
 drm_release+0x32d/0x400 drivers/gpu/drm/drm_file.c:441
 do_syscall_64+0x155/0x510 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
==================================================================

Fix this by caching new_crtc_state->active into a new new_active field in
struct __drm_crtcs_state during drm_atomic_get_crtc_state(),
drm_atomic_helper_setup_commit(), and drm_atomic_helper_swap_state().
drm_atomic_helper_wait_for_vblanks() can then check
state->crtcs[i].new_active using for_each_old_crtc_in_state() without
dereferencing new_crtc_state after hw_done.

Fixes: 415c3ac3f256 ("drm/atomic: Fix atomic helpers to use the new iterator macros, v3.")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+0f999d26a4fd79c3a23b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0f999d26a4fd79c3a23b
Link: https://syzkaller.appspot.com/ai_job?id=401dc2f0-db02-4684-b99f-d615bff63626
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index e5c8ef06c..73c667af5 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -315,6 +315,7 @@ void drm_atomic_commit_default_clear(struct drm_atomic_commit *state)
 		state->crtcs[i].state_to_destroy = NULL;
 		state->crtcs[i].old_state = NULL;
 		state->crtcs[i].new_state = NULL;
+		state->crtcs[i].new_active = false;
 
 		if (state->crtcs[i].commit) {
 			drm_crtc_commit_put(state->crtcs[i].commit);
@@ -466,6 +467,7 @@ drm_atomic_get_crtc_state(struct drm_atomic_commit *state,
 	state->crtcs[index].state_to_destroy = crtc_state;
 	state->crtcs[index].old_state = crtc->state;
 	state->crtcs[index].new_state = crtc_state;
+	state->crtcs[index].new_active = crtc_state->active;
 	state->crtcs[index].ptr = crtc;
 	crtc_state->state = state;
 
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 285aac355..94f23320e 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1890,7 +1890,7 @@ drm_atomic_helper_wait_for_vblanks(struct drm_device *dev,
 				   struct drm_atomic_commit *state)
 {
 	struct drm_crtc *crtc;
-	struct drm_crtc_state *old_crtc_state, *new_crtc_state;
+	struct drm_crtc_state *old_crtc_state;
 	int i, ret;
 	unsigned int crtc_mask = 0;
 
@@ -1901,8 +1901,8 @@ drm_atomic_helper_wait_for_vblanks(struct drm_device *dev,
 	if (state->legacy_cursor_update)
 		return;
 
-	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
-		if (!new_crtc_state->active)
+	for_each_old_crtc_in_state(state, crtc, old_crtc_state, i) {
+		if (!state->crtcs[i].new_active)
 			continue;
 
 		ret = drm_crtc_vblank_get(crtc);
@@ -2530,6 +2530,8 @@ int drm_atomic_helper_setup_commit(struct drm_atomic_commit *state,
 	funcs = state->dev->mode_config.helper_private;
 
 	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
+		state->crtcs[i].new_active = new_crtc_state->active;
+
 		commit = kzalloc_obj(*commit);
 		if (!commit)
 			return -ENOMEM;
@@ -3333,6 +3335,7 @@ int drm_atomic_helper_swap_state(struct drm_atomic_commit *state,
 		new_crtc_state->state = NULL;
 
 		state->crtcs[i].state_to_destroy = old_crtc_state;
+		state->crtcs[i].new_active = new_crtc_state->active;
 		crtc->state = new_crtc_state;
 
 		if (new_crtc_state->commit) {
diff --git a/include/drm/drm_atomic.h b/include/drm/drm_atomic.h
index 88087910a..b1a488b91 100644
--- a/include/drm/drm_atomic.h
+++ b/include/drm/drm_atomic.h
@@ -215,6 +215,17 @@ struct __drm_crtcs_state {
 
 	s32 __user *out_fence_ptr;
 	u64 last_vblank_count;
+
+	/**
+	 * @new_active:
+	 *
+	 * Caches &drm_crtc_state.active of @new_state for use by
+	 * drm_atomic_helper_wait_for_vblanks() after
+	 * drm_atomic_helper_commit_hw_done() is called. This ensures that a
+	 * concurrent commit won't free the CRTC state before active status
+	 * is inspected.
+	 */
+	bool new_active;
 };
 
 struct __drm_connnectors_state {


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
