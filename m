Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA482DBF75
	for <syzbot@lists.linux.dev>; Tue, 11 Aug 2026 01:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786410283; cv=none; b=eSR8AH5fpWTrl/RiNcP5U3MALM1/BOrZ5zgqCXk/QLdoC8rUUsiPsCymJK5P4pH+mq+146ZH0JwzlBB1MQrWoEaw8ryVdzN1LAAK2bhlLjNIH7D5RmZ+DCbKE+xfruL00ZrXT9IffqvjwiWAGVnlZXf51QSPYLtMAf/HOfiv7Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786410283; c=relaxed/simple;
	bh=Jsv2RRTLdgcKfF2A0ZFcJJhQRAe0Fh2DczLssMmy8h0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KXT5TgvqDHQ8DhKdYPMScuzS4SGHbJeB8RD5SucBPfkKcOJpzRxCKJkNr+ORvc3fNZEP3og0CnASKFwuJNU8pDjdExoxl+XqUrtIaA3zrU6FaIa8a93zrDsm1SXSGmou2Hb7qtW1vYIDKvvnp4j3k2KIkZS35aSAnZp3J9SDS1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gWt2FIum; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gWt2FIum"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 06F971F000E9;
	Tue, 11 Aug 2026 01:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786410281;
	bh=4QGYKomMadBqpBKNyVLlf1QO0xHLPysDNPBGJ7LycLU=;
	h=From:To:Cc:Subject:Date;
	b=gWt2FIumTiemORirJLNh1ea53T5KRnP1aZW3SraJlVal5/dnlgDKPOno/gwlRhgdX
	 rsE/HijYOTb0jGsbN99ZGPrAx+Ngipq8M3KNwZKaE2liRlfrlLw0mbnQYOcznTWhkl
	 KlFxyuIgHjKxCytF0+ji5sikDZE5qGH1WpX1ak+ilf1FCDrivRt95q2RnBWyugmqxE
	 iadGoipl3PuS6NWUts7SM3euqhzQmnttwKS0TOBMEV9a2FibJ5/tWxfGwA1afk7Wcg
	 FZ/LNGF5zfTbZlCnF+KMN37XeVuqwxxoAJU6maGKZDm1FA1DOm3um+3bg2UwdJqv9E
	 LKmevp+HymO0A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v6] drm/client: Avoid warning on vblank timeout during modeset client waits
Message-ID: <b2ad033b-a674-49fe-825e-fb7555a327b5@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 11 Aug 2026 01:04:40 +0000 (UTC)

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

Keeping the vblank reference acquisition (drm_vblank_get()) in the public
wrapper drm_crtc_wait_one_vblank() rather than moving it to the internal
helper prevents an enable_vblank() error from being mislabeled as a wait
timeout.

Fixes: d8c4bddcd8bc ("drm/fb-helper: Synchronize dirty worker with vblank")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f59157955aba9d0cb43b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f59157955aba9d0cb43b
Link: https://syzkaller.appspot.com/ai_job?id=f37d4830-e66f-4bce-be00-e7ac1d70c469
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
Cc: <linux-kernel@vger.kernel.org>

---
v6:
- Convert drm_crtc_wait_one_vblank_internal() comment block to kernel-doc format
- Remove the stack trace from the commit description

v5:
- Added a kernel-doc comment block for drm_crtc_wait_one_vblank_internal().
https://lore.kernel.org/all/f9f73e7b-aefb-4240-ab24-020df624047a@mail.kernel.org/T/

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
index f90fb2d13..9cac7013b 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -1297,6 +1297,32 @@ void drm_crtc_vblank_put(struct drm_crtc *crtc)
 }
 EXPORT_SYMBOL(drm_crtc_vblank_put);
 
+/**
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
