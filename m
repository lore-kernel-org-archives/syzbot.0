Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120ED239E60
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786039809; cv=none; b=pf/8mhvQtmMieUcT2Q25wYUedkVhLjL9lNoX7d0HnI37NgCb542ndv9pJRzdvWyJD9+QqkGKIUjj36I41F5xGk2QrsDsNOPH96yoqWul245Wv1Uo/NqaJiko5+PIPTQ3jk9RSsKgJk9qbsIURrfZbcE1byH+fZrlwHhuC1zXkQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786039809; c=relaxed/simple;
	bh=Fw3OTnBoM8r3KuFePDda//SqyEOCwBhMjcUC7v+TnkQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ghtOjwkZDlJi9471nxdZyLueO4qRwCe1U3f6Y32TE92b4Sy/WXVgB4+o0UyoIV+NBecQbN/dscTONIMMoInGRsB/je9oXHhhZhEWohMXQuRGAcKVB/ZdRC0L+oXiDGtcFDlwS5wrcGnB1LiZmf3xv6oP5qhq2Jyan+ulFLZLksQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tg6Y2n69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tg6Y2n69"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9CAFB1F000E9;
	Thu,  6 Aug 2026 18:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786039807;
	bh=NGvZej6WZ8clpXZNh47srPyfw4JkJ3UuJTAz6jayOf4=;
	h=From:To:Cc:Subject:Date;
	b=Tg6Y2n69qYojRgwTG+7hVW5pcjopXDJCqKJy4lLPgrKQvLuXU93T0iFROfyXpmkct
	 e9MdvIpKB7dhWMGcdkVJwZ+au6mjnha/mbgx1O5wuMuPJOGmUPc+BX0AM4IVDLQ/ky
	 vvC1EbZ480iE5pDiRORDWfhVp+iGC+QPc86GtGCypX0uFQE9dv36PmXOKtHZIRGAH0
	 ZZ/8d1oOYhvVuvnfiKXzkNAR4vUAP+lScjdNt0rWSSLSPITZHqLh2PfAPjUGdU29nL
	 yiDCGGySvyHN1RFlPrH8Q25/GfK+NC4QO0GrMJ06pxSiTWaF5IJ2Fm4u0zWmr+kOLc
	 UAbJiKbI1Gbzw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] drm/client: Avoid warning on vblank timeout during modeset client waits
Message-ID: <0bbd5c22-3a1c-4e66-9d45-932bb858d0af@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  6 Aug 2026 18:10:07 +0000 (UTC)

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
times out and triggers a warning in drm_crtc_wait_one_vblank().

Since this vblank wait in the client modeset path is only used for optional
client update throttling, a timeout is acceptable and does not indicate a
kernel bug. Therefore, a warning should not be triggered in this case.

Introduce drm_crtc_wait_one_vblank_internal(), which performs the vblank
wait without triggering a warning on timeout. This new function is used in
drm_client_modeset_wait_for_vblank() to avoid the warning, while keeping
the warning in drm_crtc_wait_one_vblank() for other callers where a timeout
might still indicate an actual issue.

Fixes: d8c4bddcd8bc ("drm/fb-helper: Synchronize dirty worker with vblank")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f59157955aba9d0cb43b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f59157955aba9d0cb43b
Link: https://syzkaller.appspot.com/ai_job?id=527b7209-9098-44da-8634-7792d361dea5
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Removed the raw kernel cut marker and full warning trace from the commit description.
- Replaced first-person phrasing with impersonal wording in the commit description.

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
index f90fb2d13..7758e8265 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -1297,17 +1297,7 @@ void drm_crtc_vblank_put(struct drm_crtc *crtc)
 }
 EXPORT_SYMBOL(drm_crtc_vblank_put);
 
-/**
- * drm_crtc_wait_one_vblank - wait for one vblank
- * @crtc: DRM crtc
- *
- * This waits for one vblank to pass on @crtc, using the irq driver interfaces.
- * It is a failure to call this when the vblank irq for @crtc is disabled, e.g.
- * due to lack of driver support or because the crtc is off.
- *
- * Returns: 0 on success, negative error on failures.
- */
-int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
+int drm_crtc_wait_one_vblank_internal(struct drm_crtc *crtc)
 {
 	struct drm_device *dev = crtc->dev;
 	int pipe = drm_crtc_index(crtc);
@@ -1326,12 +1316,30 @@ int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
 				 last != drm_vblank_count(dev, pipe),
 				 msecs_to_jiffies(1000));
 
-	drm_WARN(dev, ret == 0, "vblank wait timed out on crtc %i\n", pipe);
-
 	drm_vblank_put(dev, pipe);
 
 	return ret ? 0 : -ETIMEDOUT;
 }
+
+/**
+ * drm_crtc_wait_one_vblank - wait for one vblank
+ * @crtc: DRM crtc
+ *
+ * This waits for one vblank to pass on @crtc, using the irq driver interfaces.
+ * It is a failure to call this when the vblank irq for @crtc is disabled, e.g.
+ * due to lack of driver support or because the crtc is off.
+ *
+ * Returns: 0 on success, negative error on failures.
+ */
+int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
+{
+	int ret = drm_crtc_wait_one_vblank_internal(crtc);
+
+	drm_WARN(crtc->dev, ret == -ETIMEDOUT, "vblank wait timed out on crtc %i\n",
+		 drm_crtc_index(crtc));
+
+	return ret;
+}
 EXPORT_SYMBOL(drm_crtc_wait_one_vblank);
 
 /**


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
