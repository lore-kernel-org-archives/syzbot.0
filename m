Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DFC3BED30
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 11:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786360184; cv=none; b=BWLwxzWr0J8K6oETGnKKyj7+ymAm30p/nEt5rE0X+PUAqsZl8/FBYXJAMzNRjWmPgvMUHjcSfOCrrn/kr8xZN11/ZswRMfAhxMiAza/Xg+cB+j5m8vESjglIsEkypqp+2ROvTUcVYeiylA6mX4mXdNfau30/RYZJUYjD1oNDieI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786360184; c=relaxed/simple;
	bh=byzh+bt3m7RloNVhVLsgEfXRJ9MeWxcLl00cPv9jnnQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=qpU42YG8SB+6RpY4Au+ywQYjYR0vZN3R9G9y8CMrGz5BiTTFL2/7d3mdO7rlyKnNFvjnL2np/0foq2e/k3KvAYYkaRCJv0YVJK1L85wDUgOtWqvdVISgckKEX6U/c7sNwOxowW3Re/ah1KirccY5MnQwEo3jx/4/UADods7zSww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3CWiv02; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3CWiv02"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1D3AC1F000E9;
	Mon, 10 Aug 2026 11:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786360181;
	bh=7XaTWW2/m4KkU6dbe5N9MottBTQ17MJtPhD09Zavxqk=;
	h=From:To:Cc:Subject:Date;
	b=h3CWiv02N7KDSag/kaAGZSIpWOIPA4LXFuin9FZfStguDfq99IHXW8hxchHkTOxDH
	 ea3hcRbWKBV8X4o1q56KaGUsxzHmeV+sOxmiZgxIJCteFKmt38dEHU7bu0PeQSVx2I
	 dVUjeXvuLswGIMpTZz2qJkiYEfWpVDkZfEe/yZoAGI3inEyGqvwnUwZYGVk5kZoOaG
	 YTiY3m1hD6gdF08mWvGLhVJy2R7wUntORk//RY9O9DTMQpXPg/GVITHiKjGUCVimh6
	 XQ/OKHM8XwZufITZZ5hBwDAwFIEhfFmpFncpu9lEkxPHTMbsUpM/LPr3UChlLYoBcF
	 V5AM/9S6qMdMQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] drm/vblank: Fix integer overflow in frame duration calculation
Message-ID: <085d6b20-0682-4884-9420-7bfa4b4a1899@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 10 Aug 2026 11:09:41 +0000 (UTC)

A vblank wait timeout warning in drm_atomic_helper_wait_for_vblanks() can
occur due to an integer overflow in drm_calc_timestamping_constants().

When a display mode is set with extremely large crtc_htotal and crtc_vtotal
values and a low pixel clock, the calculated frame duration (framedur_ns)
can exceed INT_MAX. Because framedur_ns is declared as a 32-bit signed
integer, it overflows and becomes negative.

This negative frame duration cascades into a broken vblank timer. The timer
is scheduled with a negative interval, causing it to fire continuously
every 1 nanosecond. In the timer callback, drm_update_vblank_count()
attempts to calculate the number of elapsed vblanks. However,
DIV_ROUND_CLOSEST_ULL() casts the negative framedur_ns to a large positive
32-bit unsigned integer. Since the elapsed time is only 1 ns, the
calculated number of elapsed vblanks is 0. As the vblank counter never
increments, drm_atomic_helper_wait_for_vblanks() eventually times out,
triggering the following warning:

[CRTC:37:crtc-0] vblank wait timed out
WARNING: drivers/gpu/drm/drm_atomic_helper.c:1922 at
drm_atomic_helper_wait_for_vblanks+0x763/0x8f0
Call Trace:
 drm_atomic_helper_commit_tail+0x2e9/0x510
 commit_tail+0x2b1/0x3c0
 drm_atomic_helper_commit+0xa77/0xb10
 drm_atomic_commit+0x24e/0x2b0
 drm_atomic_helper_set_config+0xe2/0x160
 drm_mode_setcrtc+0xa70/0x1d20
 drm_ioctl_kernel+0x2df/0x3b0
 drm_ioctl+0x70e/0xba0

To fix this issue:
1. Upgrade framedur_ns and linedur_ns to 64-bit integers (s64) in struct
drm_vblank_crtc and related functions to prevent the initial integer
overflow.
2. Update math macros to handle 64-bit divisors, replacing
DIV_ROUND_CLOSEST_ULL() with DIV64_U64_ROUND_CLOSEST().
3. Use mul_u64_u32_div() in drm_crtc_next_vblank_start() and cast vpos to
s64 in drm_crtc_vblank_helper_get_vblank_timestamp_internal() to prevent
further overflows.
4. Reject display modes with a refresh rate of less than 0.5 Hz
(drm_mode_vrefresh(mode) == 0) in drm_mode_validate_basic(), as such modes
are practically invalid and can cause frame durations of over 2 seconds,
breaking various assumptions in the DRM core.
5. Increase the timeout in drm_atomic_helper_wait_for_vblanks() from 1
second to 10 seconds (matching drm_atomic_helper_wait_for_flip_done()).
This ensures that valid low-refresh-rate modes (e.g., 1 Hz) do not
spuriously time out due to minor scheduling delays.

Fixes: 3c184f69917d ("drm: Change {pixel,line,frame}dur_ns from s64 to int")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+45bc7264de77caad91cb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=45bc7264de77caad91cb
Link: https://syzkaller.appspot.com/ai_job?id=01a0eb26-8578-469f-bbd8-038dad2417b7
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
To: =?utf-8?q?Ville_Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 51f39edc3..ace907c80 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1916,7 +1916,7 @@ drm_atomic_helper_wait_for_vblanks(struct drm_device *dev,
 		ret = wait_event_timeout(*queue,
 					 state->crtcs[i].last_vblank_count !=
 						drm_crtc_vblank_count(crtc),
-					 msecs_to_jiffies(1000));
+					 msecs_to_jiffies(10000));
 
 		WARN(!ret, "[CRTC:%d:%s] vblank wait timed out\n",
 		     crtc->base.id, crtc->name);
diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 3f8e025fd..f4b86a58e 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -1640,6 +1640,9 @@ drm_mode_validate_basic(const struct drm_display_mode *mode)
 	if (mode->clock == 0)
 		return MODE_CLOCK_LOW;
 
+	if (drm_mode_vrefresh(mode) == 0)
+		return MODE_CLOCK_LOW;
+
 	if (mode->hdisplay == 0 ||
 	    mode->hsync_start < mode->hdisplay ||
 	    mode->hsync_end < mode->hsync_start ||
diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
index f90fb2d13..7b46b00dd 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -311,7 +311,7 @@ static void drm_update_vblank_count(struct drm_device *dev, unsigned int pipe,
 	u32 cur_vblank, diff;
 	bool rc;
 	ktime_t t_vblank;
-	int framedur_ns = vblank->framedur_ns;
+	s64 framedur_ns = vblank->framedur_ns;
 	u32 max_vblank_count = drm_max_vblank_count(dev, pipe);
 
 	/*
@@ -341,11 +341,11 @@ static void drm_update_vblank_count(struct drm_device *dev, unsigned int pipe,
 		 * frame/field duration.
 		 */
 
-		drm_dbg_vbl(dev, "crtc %u: Calculating number of vblanks."
-			    " diff_ns = %lld, framedur_ns = %d)\n",
+		drm_dbg_vbl(dev,
+			    "crtc %u: Calculating number of vblanks. diff_ns = %lld, framedur_ns = %lld)\n",
 			    pipe, (long long)diff_ns, framedur_ns);
 
-		diff = DIV_ROUND_CLOSEST_ULL(diff_ns, framedur_ns);
+		diff = DIV64_U64_ROUND_CLOSEST(diff_ns, framedur_ns);
 
 		if (diff == 0 && in_vblank_irq)
 			drm_dbg_vbl(dev, "crtc %u: Redundant vblirq ignored\n",
@@ -638,7 +638,7 @@ void drm_calc_timestamping_constants(struct drm_crtc *crtc,
 	struct drm_device *dev = crtc->dev;
 	unsigned int pipe = drm_crtc_index(crtc);
 	struct drm_vblank_crtc *vblank = drm_crtc_vblank_crtc(crtc);
-	int linedur_ns = 0, framedur_ns = 0;
+	s64 linedur_ns = 0, framedur_ns = 0;
 	int dotclock = mode->crtc_clock;
 
 	if (!drm_dev_has_vblank(dev))
@@ -649,7 +649,7 @@ void drm_calc_timestamping_constants(struct drm_crtc *crtc,
 
 	/* Valid dotclock? */
 	if (dotclock > 0) {
-		int frame_size = mode->crtc_htotal * mode->crtc_vtotal;
+		s64 frame_size = (s64)mode->crtc_htotal * mode->crtc_vtotal;
 
 		/*
 		 * Convert scanline length in pixels and video
@@ -677,7 +677,7 @@ void drm_calc_timestamping_constants(struct drm_crtc *crtc,
 		     "crtc %u: hwmode: htotal %d, vtotal %d, vdisplay %d\n",
 		     crtc->base.id, mode->crtc_htotal,
 		     mode->crtc_vtotal, mode->crtc_vdisplay);
-	drm_dbg_core(dev, "crtc %u: clock %d kHz framedur %d linedur %d\n",
+	drm_dbg_core(dev, "crtc %u: clock %d kHz framedur %lld linedur %lld\n",
 		     crtc->base.id, dotclock, framedur_ns, linedur_ns);
 }
 EXPORT_SYMBOL(drm_calc_timestamping_constants);
@@ -726,7 +726,8 @@ drm_crtc_vblank_helper_get_vblank_timestamp_internal(
 	bool vbl_status;
 	const struct drm_display_mode *mode;
 	int vpos, hpos, i;
-	int delta_ns, duration_ns;
+	int duration_ns;
+	s64 delta_ns;
 
 	if (pipe >= dev->num_crtcs) {
 		drm_err(dev, "Invalid crtc %u\n", pipe);
@@ -804,7 +805,7 @@ drm_crtc_vblank_helper_get_vblank_timestamp_internal(
 	 * since start of scanout at first display scanline. delta_ns
 	 * can be negative if start of scanout hasn't happened yet.
 	 */
-	delta_ns = div_s64(1000000LL * (vpos * mode->crtc_htotal + hpos),
+	delta_ns = div_s64(1000000LL * ((s64)vpos * mode->crtc_htotal + hpos),
 			   mode->crtc_clock);
 
 	/* Subtract time delta from raw timestamp to get final
@@ -1036,9 +1037,8 @@ int drm_crtc_next_vblank_start(struct drm_crtc *crtc, ktime_t *vblanktime)
 	if (!drm_crtc_get_last_vbltimestamp(crtc, vblanktime, false))
 		return -EINVAL;
 
-	vblank_start = DIV_ROUND_DOWN_ULL(
-			(u64)vblank->framedur_ns * mode->crtc_vblank_start,
-			mode->crtc_vtotal);
+	vblank_start = mul_u64_u32_div(vblank->framedur_ns, mode->crtc_vblank_start,
+				       mode->crtc_vtotal);
 	*vblanktime  = ktime_add(*vblanktime, ns_to_ktime(vblank_start));
 
 	return 0;
@@ -1549,7 +1549,7 @@ static void drm_vblank_restore(struct drm_device *dev, unsigned int pipe)
 {
 	ktime_t t_vblank;
 	struct drm_vblank_crtc *vblank;
-	int framedur_ns;
+	s64 framedur_ns;
 	u64 diff_ns;
 	u32 cur_vblank, diff = 1;
 	u32 max_vblank_count = drm_max_vblank_count(dev, pipe);
@@ -1571,11 +1571,11 @@ static void drm_vblank_restore(struct drm_device *dev, unsigned int pipe)
 
 	diff_ns = ktime_to_ns(ktime_sub(t_vblank, vblank->time));
 	if (framedur_ns)
-		diff = DIV_ROUND_CLOSEST_ULL(diff_ns, framedur_ns);
+		diff = DIV64_U64_ROUND_CLOSEST(diff_ns, framedur_ns);
 
 
 	drm_dbg_vbl(dev,
-		    "missed %d vblanks in %lld ns, frame duration=%d ns, hw_diff=%d\n",
+		    "missed %d vblanks in %lld ns, frame duration=%lld ns, hw_diff=%d\n",
 		    diff, diff_ns, framedur_ns, cur_vblank - vblank->last);
 	vblank->last = (cur_vblank - diff) & max_vblank_count;
 }
diff --git a/include/drm/drm_vblank.h b/include/drm/drm_vblank.h
index 2fcef9c0f..ed60f1bfc 100644
--- a/include/drm/drm_vblank.h
+++ b/include/drm/drm_vblank.h
@@ -227,13 +227,13 @@ struct drm_vblank_crtc {
 	 * drm_crtc_vblank_helper_get_vblank_timestamp() and computed by
 	 * drm_calc_timestamping_constants().
 	 */
-	int framedur_ns;
+	s64 framedur_ns;
 	/**
 	 * @linedur_ns: Line duration in ns, used by
 	 * drm_crtc_vblank_helper_get_vblank_timestamp() and computed by
 	 * drm_calc_timestamping_constants().
 	 */
-	int linedur_ns;
+	s64 linedur_ns;
 
 	/**
 	 * @hwmode:


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
