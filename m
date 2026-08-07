Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED8D282F1E
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 10:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786098661; cv=none; b=aXOhVzef9JGexZ/jeS7JezHlBXEJF7ZFg4nGIgbh72DSiOKX238KE5QLEmReSwk/1EvV2Bn8a1JAZm04Dub//EbVQSOHsdyoabl5YWccC0Zcob9TWQBrsrj/dT4j6YFmcveOp0LazQs5biYcm4ftqEpTn2xhFlFcZ8BprL85I6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786098661; c=relaxed/simple;
	bh=Wfg8+lLRj4S7/zx1EfrIt/yvG0MDvYp8OA9vlHNG38M=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jMILOcLwmdCGPCQLGB8beqAnAjM1PVTiqFGlPW+a2y3UjzsNpRqRn+tGJiNflc5cfNPM/HukF+qudca7O3DhfLDVMPMpvSDlgVMAm7V01AGqkExadTxwisU0K0pl/4/oKTHAGlUgTk+6ArgTwFO3P037PhWOMMGJ7Fw+TfGw/c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpIFK1Kj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpIFK1Kj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7EA1B1F000E9;
	Fri,  7 Aug 2026 10:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786098656;
	bh=ZZeau0AWMCEwTm0yEBwbB0wi/zo4GjnScrZvPWa8ZuE=;
	h=From:To:Cc:Subject:Date;
	b=bpIFK1Kj5jEL8GT7tlOV2nBgfH6HYFt11j9MjINUHpkRIcns2kLCXn7+A4aLYuDF0
	 HJMl3TpwOiruB/tn6yZy84yb5tow3TcM3uMF0WnCqt2F9OYr9wLVYkBEU7VjC9PZq6
	 bEBoiYhdMFGA5C5sQJhABfPmpRqofad3DcoPOI1KNP65niAsLUY7UlUvqAWh21pw3P
	 xsCQBvmrM7He/WaBtwcEeBLoLZjyX9zFdQUH6WYFTLIWDIe5gMhsJ1B0b5opXYoZ5L
	 UoQWWyknp9kM263s8tVnV/dzK5ZOt9JqpoQl0L3/6JFJlSbA7t8rzyvCegMhBhw/pr
	 ezrM/7/4y+4Jg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] drm/client: Avoid warning on vblank timeout during modeset client waits
Message-ID: <d0de0809-9381-4925-b5d6-2499dab9e3ce@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 10:30:56 +0000 (UTC)

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

[   12.345678] faux_driver vkms: [drm] vblank wait timed out on crtc 0
[   12.345679] WARNING: drivers/gpu/drm/drm_vblank.c:1329 at
drm_crtc_wait_one_vblank+0x3bc/0x560
[   12.345680] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted
[   12.345681] Workqueue: events drm_fb_helper_damage_work
[   12.345682] RIP: 0010:drm_crtc_wait_one_vblank+0x51a/0x560
[   12.345683] Call Trace:
[   12.345684]  <TASK>
[   12.345685]  drm_client_modeset_wait_for_vblank+0xc5/0xf0
[   12.345686]  drm_fb_helper_fb_dirty [inline]
[   12.345687]  drm_fb_helper_damage_work+0x6cf/0xf00
[   12.345688]  process_one_work kernel/workqueue.c:3322 [inline]
[   12.345689]  process_scheduled_works+0xa8e/0x14e0
[   12.345690]  worker_thread+0x92d/0xe10
[   12.345691]  kthread+0x388/0x470
[   12.345692]  ret_from_fork+0x514/0xb70
[   12.345693]  ret_from_fork_asm+0x1a/0x30
[   12.345694]  </TASK>

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
Link: https://syzkaller.appspot.com/ai_job?id=be2179ac-d334-4861-a28c-7b1d32526126
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
Cc: <linux-kernel@vger.kernel.org>

---
v4:
- Keep vblank reference acquisition in the public drm_crtc_wait_one_vblank() wrapper instead of moving it to drm_crtc_wait_one_vblank_internal().
- Update the commit description to explain how this prevents enable_vblank() errors from being mislabeled as wait timeouts.

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
index f90fb2d13..923e20053 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -1297,6 +1297,23 @@ void drm_crtc_vblank_put(struct drm_crtc *crtc)
 }
 EXPORT_SYMBOL(drm_crtc_vblank_put);
 
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
@@ -1311,26 +1328,20 @@ int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
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
