Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11B73939BD
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 13:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786111112; cv=none; b=ksC4ypSbNt4xMAgsJNUGaTvvrx+4KEHujfy6Ci8lQtNJTaV0q3bJXrkg2pEJBDz/kEnynevXXQZAsRevLOMgiYRBtEpqNog3MzfjAP7+Eg0OEyZK8wdjKd3FD4U0Y3P9qQVX2e5O21GbM6aL5anI7GY8mzPcgw8JdeIR/EwERX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786111112; c=relaxed/simple;
	bh=0dq58u7TPWpYQU1E/xDu8hyXYfIINAoaIFpfUhAp5gU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=XANCuCY7zZRzqIb1IyJC+05qti2Ie8AzL+0F2w19OYOMft4KmcvlV6l0aUAZGIODQKVn0as7YvO52yyhzyGvdxwtx3yCa1vsfeG9cVmV2+nEyHsj7MaMR4uA/cXtxeg4WjEvnFlGtfLPeIcG58MbHLAaSPY51HSuJlrHIq57nyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVKGzLc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVKGzLc2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 753321F00A3A;
	Fri,  7 Aug 2026 13:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786111106;
	bh=hinu+q6r2sTJjlAplumsvzre9JLx/ImymWiJeEWLdho=;
	h=From:To:Cc:Subject:Date;
	b=IVKGzLc2Mh0+llcPg/DgmoL45WGmzO+gsO+kyh+eHJ+3gaKoqMCCXtawztBt75udj
	 Jzzckp+8x2M8IJBFRDUMN/sM3Ctk/SzSGktVUXrGjQ/+ab08jAOcprDFo0ZpLEpvXr
	 zab4yLTfYnnU6eNp9OjXFA2APZUN4jzumXSL8ZmcZjn40BqxMYKPk0LvBGohYvw0S8
	 964jAKnf75S2KgFWveRK8A1EM15ELmBc7xneKy2adLOEu4b7tog/HxoswP9pxBeeaD
	 bzm9xgtlLSLdUAujtBeY81AvRX7XeNenR2xPBBTpQs5yOWtyUUVP5gPvT3ZAeDuL9M
	 fJxWbegmiPDKg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v5] drm/client: Avoid warning on vblank timeout during modeset client waits
Message-ID: <f9f73e7b-aefb-4240-ab24-020df624047a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 13:58:26 +0000 (UTC)

On PREEMPT_RT kernels, a user-space task with elevated Real-Time (RT)
priority can starve essential kernel threads. For example, the VKMS driver
simulates vblank interrupts using hrtimers. On PREEMPT_RT, these timers run
in the per-CPU timer threads at a low RT priority. If a user-space task
elevates its priority above the timer thread and monopolizes the CPU, the
timer thread is starved and the VKMS software vblank delivery is delayed
beyond the timeout.

This leads to a timeout when a worker thread waits for the vblank event.
For instance, a console update triggers a framebuffer update, scheduling
drm_fb_helper_damage_work() on the system workqueue. The worker thread
eventually calls drm_client_modeset_wait_for_vblank() to synchronize the
screen update with the vblank interval. Due to the starved timer, the wait
times out and triggers a warning in drm_crtc_wait_one_vblank():

WARNING: drivers/gpu/drm/drm_vblank.c:1329 at
drm_crtc_wait_one_vblank+0x3bc/0x560
Workqueue: events drm_fb_helper_damage_work
RIP: 0010:drm_crtc_wait_one_vblank+0x51a/0x560
Call Trace:
 <TASK>
 drm_client_modeset_wait_for_vblank+0xc5/0xf0
 drm_fb_helper_fb_dirty [inline]
 drm_fb_helper_damage_work+0x6cf/0xf00
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0
 worker_thread+0x92d/0xe10
 kthread+0x388/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Since this vblank wait in the client modeset path is only used for optional
client update throttling, a timeout is acceptable and does not indicate a
kernel bug. Therefore, a warning should not be triggered in this case.

Introduce drm_crtc_wait_one_vblank_internal(), which performs the vblank
wait without triggering a warning on timeout. This new function is used in
drm_client_modeset_wait_for_vblank() to avoid the warning, while keeping
the warning in drm_crtc_wait_one_vblank() for other callers where a timeout
might still indicate an actual issue.

Keeping the vblank reference acquisition (drm_vblank_get()) in the public
wrapper drm_crtc_wait_one_vblank() rather than moving it to the internal
helper prevents an enable_vblank() error from being mislabeled as a wait
timeout.

Fixes: d8c4bddcd8bc ("drm/fb-helper: Synchronize dirty worker with vblank")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f59157955aba9d0cb43b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f59157955aba9d0cb43b
Link: https://syzkaller.appspot.com/ai_job?id=99547107-9c8e-4e10-8b8a-950541b8fc0d
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
Cc: <linux-kernel@vger.kernel.org>

---
v5:
- Added a kernel-doc comment block for drm_crtc_wait_one_vblank_internal().

v4:
- Keep vblank reference acquisition in the public drm_crtc_wait_one_vblank() wrapper instead of moving it to drm_crtc_wait_one_vblank_internal().
- Update the commit description to explain how this prevents enable_vblank() errors from being mislabeled as wait timeouts.
https://lore.kernel.org/all/d0de0809-9381-4925-b5d6-2499dab9e3ce@mail.kernel.org/T/

v3:
- Removed the raw kernel cut marker and full warning trace from the commit description.
- Replaced first-person phrasing with impersonal wording in the commit description.
https://lore.kernel.org/all/0bbd5c22-3a1c-4e66-9d45-932bb858d0af@mail.kernel.org/T/

v2:
- Introduced drm_crtc_wait_one_vblank_internal() to allow waiting for vblank without warning on timeout.
- Updated drm_client_modeset_wait_for_vblank() to use the new internal function, avoiding warnings during optional client update throttling.
- Restored the warning in drm_crtc_wait_one_vblank() for other callers.
https://lore.kernel.org/all/5edd530e-c20d-42c4-bf55-0656081f030d@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/7527aaed-dcb2-4bde-a807-1677dcd0af99@mail.kernel.org/T/
---
diff --git a/drivers/gpu/drm/drm_client_modeset.c b/drivers/gpu/drm/drm_client_modeset.c
index 0080a8e95..7ff0f24a0 100644
--- a/drivers/gpu/drm/drm_client_modeset.c
+++ b/drivers/gpu/drm/drm_client_modeset.c
@@ -1328,7 +1328,7 @@ int drm_client_modeset_wait_for_vblank(struct drm_client_dev *client, unsigned i
 	 */
 	ret = drm_crtc_vblank_get(crtc);
 	if (!ret) {
-		drm_crtc_wait_one_vblank(crtc);
+		drm_crtc_wait_one_vblank_internal(crtc);
 		drm_crtc_vblank_put(crtc);
 	}
 
diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
index f893b1e3a..6fd33672d 100644
--- a/drivers/gpu/drm/drm_internal.h
+++ b/drivers/gpu/drm/drm_internal.h
@@ -115,6 +115,7 @@ void drm_vblank_disable_and_save(struct drm_device *dev, unsigned int pipe);
 int drm_vblank_get(struct drm_device *dev, unsigned int pipe);
 void drm_vblank_put(struct drm_device *dev, unsigned int pipe);
 u64 drm_vblank_count(struct drm_device *dev, unsigned int pipe);
+int drm_crtc_wait_one_vblank_internal(struct drm_crtc *crtc);
 
 /* drm_vblank_work.c */
 static inline void drm_vblank_flush_worker(struct drm_vblank_crtc *vblank)
diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
index f90fb2d13..e2bf5ed65 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -1297,6 +1297,32 @@ void drm_crtc_vblank_put(struct drm_crtc *crtc)
 }
 EXPORT_SYMBOL(drm_crtc_vblank_put);
 
+/*
+ * drm_crtc_wait_one_vblank_internal - wait for one vblank
+ * @crtc: DRM crtc
+ *
+ * This waits for one vblank to pass on @crtc, using the irq driver interfaces.
+ * Every caller must hold a vblank reference across the complete wait.
+ *
+ * Returns: 0 on success, negative error on failures.
+ */
+int drm_crtc_wait_one_vblank_internal(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	int pipe = drm_crtc_index(crtc);
+	struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(crtc);
+	int ret;
+	u64 last;
+
+	last = drm_vblank_count(dev, pipe);
+
+	ret = wait_event_timeout(vblank->queue,
+				 last != drm_vblank_count(dev, pipe),
+				 msecs_to_jiffies(1000));
+
+	return ret ? 0 : -ETIMEDOUT;
+}
+
 /**
  * drm_crtc_wait_one_vblank - wait for one vblank
  * @crtc: DRM crtc
@@ -1311,26 +1337,20 @@ int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
 {
 	struct drm_device *dev = crtc->dev;
 	int pipe = drm_crtc_index(crtc);
-	struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(crtc);
 	int ret;
-	u64 last;
 
 	ret = drm_vblank_get(dev, pipe);
 	if (drm_WARN(dev, ret, "vblank not available on crtc %i, ret=%i\n",
 		     pipe, ret))
 		return ret;
 
-	last = drm_vblank_count(dev, pipe);
-
-	ret = wait_event_timeout(vblank->queue,
-				 last != drm_vblank_count(dev, pipe),
-				 msecs_to_jiffies(1000));
+	ret = drm_crtc_wait_one_vblank_internal(crtc);
 
-	drm_WARN(dev, ret == 0, "vblank wait timed out on crtc %i\n", pipe);
+	drm_WARN(dev, ret == -ETIMEDOUT, "vblank wait timed out on crtc %i\n", pipe);
 
 	drm_vblank_put(dev, pipe);
 
-	return ret ? 0 : -ETIMEDOUT;
+	return ret;
 }
 EXPORT_SYMBOL(drm_crtc_wait_one_vblank);
 


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
