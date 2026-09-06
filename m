Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0B2357D0D
	for <syzbot@lists.linux.dev>; Sun,  6 Sep 2026 23:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788739087; cv=none; b=FbLbSaVyOT6t9g4WDITCRwJg+2d1oT3Gi+nINVXb+SHEgsmagPuUSHyut+mPTz04ZV+QEsKjPGCPZpoPNGbTBghjfkPOi+B249rALY3Rm+LUmiMlqrT+f4mIfViBO7fYx6pes/xeBM0d+XDJwOiGaYSRwMYR8If+TIKug6tDzes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788739087; c=relaxed/simple;
	bh=X4ViS0nv4SHI62kOF1eHxQK6QR8DGVh3xR988SEvrTw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=MuAOSmM6NEx2uUItkKdKuUuuOQzVRCAk1mFwai0a4IGvpInriE2Isz3YwC5Znk3DWA30Jw7HTO9yYkjEJWN9KHRCGgn0l2zpIRDsvpOIWi7Xx0tdRlWQWCWyOS1BrXnRC0+NpaTRPqeCjO9BjqyT48CbqFPkvfKT1xWb9Cokg1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iiFPz90W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiFPz90W"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5A8A31F00A3A;
	Sun,  6 Sep 2026 23:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788739085;
	bh=HRYgUdiT+mB01iJ4c0Y36CoigpS3p61piY8jua9jTkE=;
	h=From:To:Cc:Subject:Date;
	b=iiFPz90WdcsiNa8h/1qPg6MxEouReRPjbReUXoYxROhlDUNV5i0xeVVdqFlIlY8Au
	 rSnzZEPxI+RbOwC3AFtalftBl/km0Xt9E3F6GLVF+EPRT/F3r01snKbb6GagTVpsv7
	 RFcft6FnrPYcSaF7kzISY2bJvj3jTgwZFMTjWK+SNOhQTCejqOsparAbzuXjSNwOXU
	 bIn9y3FL3Iq6NNcVLNlwUQvh0J1YQ+NAT0Ps8Lx/KDYoxjX/9gH62KmBhumwKzJxbb
	 hr9SMWGz/IEiJ8RXmnlNI7fPvqFJB8o6JmIBUOSICBJ6OijCl0/HdOinTxTH3CiXx5
	 H0jcms7MjKpPw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] md: defer bitmap sysfs removal to mddev_unlock()
Message-ID: <d5840b4d-cf46-48be-8004-3c274af89dcf@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun,  6 Sep 2026 23:58:05 +0000 (UTC)

A circular locking dependency is detected by lockdep between kernfs active
protection (kn->active) and mddev->reconfig_mutex when tearing down bitmap
sysfs attribute groups:

  WARNING: possible circular locking dependency detected
  task is trying to acquire lock:
  (&mddev->reconfig_mutex){+.+.}-{4:4}, at: mddev_suspend_and_lock
  drivers/md/md.h:1019 [inline]
  (&mddev->reconfig_mutex){+.+.}-{4:4}, at: location_store+0xb8/0x938
  drivers/md/md-bitmap.c:2636

  but task is already holding lock:
  (kn->active#62){++++}-{0:0}, at: kernfs_fop_write_iter+0x1f0/0x3b8
  fs/kernfs/file.c:337

  which lock already depends on the new lock.

  the existing dependency chain (in reverse order) is:

  -> #1 (kn->active#62){++++}-{0:0}:
         kernfs_drain+0x1cc/0x4d0 fs/kernfs/dir.c:532
         __kernfs_remove+0x354/0x718 fs/kernfs/dir.c:1579
         sysfs_remove_group+0x98/0x160 fs/sysfs/group.c:328
         md_bitmap_sysfs_del drivers/md/md.c:707 [inline]
         md_bitmap_destroy+0x1b0/0x230 drivers/md/md.c:6635
         __md_stop+0x54/0x154 drivers/md/md.c:7089
         do_md_stop+0x284/0xe6c drivers/md/md.c:7193
         array_state_store+0x6ac/0xce8 drivers/md/md.c:-1
         sysfs_kf_write+0xe0/0x108 fs/sysfs/file.c:145
         kernfs_fop_write_iter+0x260/0x3b8 fs/kernfs/file.c:345

  -> #0 (&mddev->reconfig_mutex){+.+.}-{4:4}:
         __mutex_lock+0x164/0xf14 kernel/locking/mutex.c:821
         mddev_suspend_and_lock drivers/md/md.h:1019 [inline]
         location_store+0xb8/0x938 drivers/md/md-bitmap.c:2636
         md_attr_store+0x304/0x438 drivers/md/md.c:6158
         sysfs_kf_write+0xe0/0x108 fs/sysfs/file.c:145
         kernfs_fop_write_iter+0x260/0x3b8 fs/kernfs/file.c:345

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    rlock(kn->active#62);
                                 lock(&mddev->reconfig_mutex);
                                 lock(kn->active#62);
    lock(&mddev->reconfig_mutex);

   *** DEADLOCK ***

When a thread writes to a bitmap sysfs attribute such as
/sys/block/mdX/md/bitmap/location via location_store(), kernfs holds active
protection (a read lock on kn->active) and location_store() calls
mddev_suspend_and_lock(), attempting to acquire mddev->reconfig_mutex.
Concurrently, when another thread stops the array via array_state_store(),
it acquires mddev->reconfig_mutex and calls do_md_stop() -> __md_stop() ->
md_bitmap_destroy() -> md_bitmap_sysfs_del(), which invokes
sysfs_remove_group() and sysfs_unmerge_group() under reconfig_mutex. Kernfs
file removal waits for active references (kn->active) to drain, creating an
AB-BA deadlock with location_store(). Similarly, location_store()
synchronously called sysfs_unmerge_group() on md_bitmap_internal_group
under reconfig_mutex, risking deadlocks with concurrent accesses to bitmap
attributes such as backlog_store().

Fix this by deferring bitmap sysfs attribute removal and unmerging outside
reconfig_mutex in mddev_unlock(), following the existing deferred removal
mechanism used for mddev->to_remove:

- Add to_unmerge and to_remove_groups fields to struct mddev to queue
attribute groups for deferred teardown.
- In mddev_unlock(), if to_remove, to_unmerge, or to_remove_groups are set,
set mddev->sysfs_active = 1, release reconfig_mutex, and call
sysfs_unmerge_group(), md_bitmap_sysfs_del(), and sysfs_remove_group()
outside the mutex before clearing mddev->sysfs_active.
- In md_bitmap_destroy(), assign mddev->to_remove_groups =
mddev->bitmap_ops->groups instead of calling md_bitmap_sysfs_del() directly
under the mutex.
- In md_bitmap_set_none(), assign mddev->to_unmerge =
mddev->bitmap_ops->groups[1] before destroying the bitmap.
- In location_store(), check mddev->sysfs_active and return -EBUSY if sysfs
namespace removal is active, and defer unmerging md_bitmap_internal_group
via mddev->to_unmerge.
- Remove redundant md_bitmap_destroy() calls prior to md_bitmap_set_none()
in set_bitmap_file() and update_array_info().

Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops until creating bitmap")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+ab46e65f9ffd10729c79@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ab46e65f9ffd10729c79
Link: https://syzkaller.appspot.com/ai_job?id=4fb7d122-e26c-4a63-bf27-401d1dfa06de
To: <linux-raid@vger.kernel.org>
To: "Song Liu" <song@kernel.org>
To: "Yu Kuai" <yukuai@fygo.io>
To: "Yu Kuai" <yukuai3@huawei.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Li Nan" <magiclinan@didiglobal.com>
Cc: "Xiao Ni" <xiao@kernel.org>

---
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b8325cb09..3a97aa463 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2638,6 +2638,11 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		return rv;
 	noio_flags = memalloc_noio_save();
 
+	if (mddev->sysfs_active) {
+		rv = -EBUSY;
+		goto out;
+	}
+
 	if (mddev->pers) {
 		if (mddev->recovery || mddev->sync_thread) {
 			rv = -EBUSY;
@@ -2653,7 +2658,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 
-		sysfs_unmerge_group(&mddev->kobj, &md_bitmap_internal_group);
+		mddev->to_unmerge = &md_bitmap_internal_group;
 		md_bitmap_destroy_nosysfs(mddev);
 		mddev->bitmap_id = ID_BITMAP_NONE;
 		if (!mddev_set_bitmap_ops_nosysfs(mddev))
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63..e83caec09 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -694,17 +694,20 @@ static void md_bitmap_sysfs_add(struct mddev *mddev)
 		kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
 }
 
-static void md_bitmap_sysfs_del(struct mddev *mddev)
+static void md_bitmap_sysfs_del(struct mddev *mddev,
+				const struct attribute_group *const *groups)
 {
 	int nr_groups = 0;
 
-	for (nr_groups = 0; mddev->bitmap_ops->groups[nr_groups]; nr_groups++)
+	if (!groups)
+		return;
+
+	for (nr_groups = 0; groups[nr_groups]; nr_groups++)
 		;
 
 	while (--nr_groups >= 1)
-		sysfs_unmerge_group(&mddev->kobj,
-				    mddev->bitmap_ops->groups[nr_groups]);
-	sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->groups[0]);
+		sysfs_unmerge_group(&mddev->kobj, groups[nr_groups]);
+	sysfs_remove_group(&mddev->kobj, groups[0]);
 }
 
 bool mddev_set_bitmap_ops_nosysfs(struct mddev *mddev)
@@ -921,7 +924,7 @@ void mddev_unlock(struct mddev *mddev)
 	if (!list_empty(&mddev->deleting))
 		list_splice_init(&mddev->deleting, &delete);
 
-	if (mddev->to_remove) {
+	if (mddev->to_remove || mddev->to_unmerge || mddev->to_remove_groups) {
 		/* These cannot be removed under reconfig_mutex as
 		 * an access to the files will try to take reconfig_mutex
 		 * while holding the file unremovable, which leads to
@@ -935,12 +938,21 @@ void mddev_unlock(struct mddev *mddev)
 		 * is seen.
 		 */
 		const struct attribute_group *to_remove = mddev->to_remove;
+		const struct attribute_group *to_unmerge = mddev->to_unmerge;
+		const struct attribute_group *const *to_remove_groups = mddev->to_remove_groups;
+
 		mddev->to_remove = NULL;
+		mddev->to_unmerge = NULL;
+		mddev->to_remove_groups = NULL;
 		mddev->sysfs_active = 1;
 		mutex_unlock(&mddev->reconfig_mutex);
 
 		if (mddev->kobj.sd) {
-			if (to_remove != &md_redundancy_group)
+			if (to_unmerge)
+				sysfs_unmerge_group(&mddev->kobj, to_unmerge);
+			if (to_remove_groups)
+				md_bitmap_sysfs_del(mddev, to_remove_groups);
+			if (to_remove && to_remove != &md_redundancy_group)
 				sysfs_remove_group(&mddev->kobj, to_remove);
 			if (mddev->pers == NULL ||
 			    mddev->pers->sync_request == NULL) {
@@ -6632,13 +6644,19 @@ static void md_bitmap_destroy(struct mddev *mddev)
 {
 	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
 	    mddev->bitmap_ops->groups)
-		md_bitmap_sysfs_del(mddev);
+		mddev->to_remove_groups = mddev->bitmap_ops->groups;
 
 	md_bitmap_destroy_nosysfs(mddev);
 }
 
 static void md_bitmap_set_none(struct mddev *mddev)
 {
+	if (!mddev_is_dm(mddev) && mddev->bitmap_ops &&
+	    mddev->bitmap_ops->groups && mddev->bitmap_ops->groups[1])
+		mddev->to_unmerge = mddev->bitmap_ops->groups[1];
+
+	md_bitmap_destroy_nosysfs(mddev);
+
 	mddev->bitmap_id = ID_BITMAP_NONE;
 	if (!mddev_set_bitmap_ops_nosysfs(mddev))
 		return;
@@ -7868,12 +7886,10 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 				err = mddev->bitmap_ops->load(mddev);
 
 			if (err) {
-				md_bitmap_destroy(mddev);
 				md_bitmap_set_none(mddev);
 				fd = -1;
 			}
 		} else if (fd < 0) {
-			md_bitmap_destroy(mddev);
 			md_bitmap_set_none(mddev);
 		}
 	}
@@ -8187,7 +8203,6 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				rv = mddev->bitmap_ops->load(mddev);
 
 			if (rv) {
-				md_bitmap_destroy(mddev);
 				mddev->bitmap_info.offset = 0;
 				md_bitmap_set_none(mddev);
 			}
@@ -8216,7 +8231,6 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				put_cluster_ops(mddev);
 				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
-			md_bitmap_destroy(mddev);
 			mddev->bitmap_info.offset = 0;
 			md_bitmap_set_none(mddev);
 		}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b6d2e8929..c862d6519 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -608,6 +608,8 @@ struct mddev {
 	struct list_head		all_mddevs;
 
 	const struct attribute_group	*to_remove;
+	const struct attribute_group	*to_unmerge;
+	const struct attribute_group	*const *to_remove_groups;
 
 	struct bio_set			bio_set;
 	struct bio_set			sync_set; /* for sync operations like


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
