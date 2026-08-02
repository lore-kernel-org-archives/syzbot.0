Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5701B345ECE
	for <syzbot@lists.linux.dev>; Sun,  2 Aug 2026 21:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785704987; cv=none; b=Cg14/xIQJvdVLXo04DVqtTB1BlP9JjPRyztw+O0ST5BfYNzF2EbAlNmSH1engbf/3LH+ONqLVQISf+ng5skkKHdBKztzrbecxuTqN46Oiwvn3kODoliBX0akOIdQyYqT4j0Ad5yoCziMMgSb++pn2chOSGlFDjWA8epI1SiWAxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785704987; c=relaxed/simple;
	bh=Bg0jaRUoh32BBcJW01lEm63ua8H/IPNU6+W6LfJDsWA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=cDc0daon0dvv9LUX49swpQWThddx4AHEsUUQI4sqmXk1CRqLUilRK6B5D4DdQ7EWd+kslfyIQ1ioOXpd/l/N0biUgmygc9XRI2TL+VB4LrKoDbLAYvOdQnkgIrSEFSj7gp8ERlegaui75Q1WUYPEIlcaS8PNzRqVuDQt8QkMZvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QtCQI+cT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QtCQI+cT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 721AB1F000E9;
	Sun,  2 Aug 2026 21:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785704980;
	bh=synrRhSk3FsLNmLl2t2u/Rfz3RijNhPagJHvawdX950=;
	h=From:To:Cc:Subject:Date;
	b=QtCQI+cTY15x+d2fj5ccTAUM12UGXMGoxXw7aIzzUELZMEuv+RASQkvNe+Tj2saBn
	 rPayeOBmDyuXpJhxv9huQSg4sJmCk6SlLUsYqIWy1toORk15KJSidx8P0PU8DfwGG8
	 dlkWzkBt4voCXOvWaFo+DMqsibewyGQcFNSKzNWI0h3TC+ZGnhi+anP39zEFs0prdU
	 OBK1OTut6qCAKqHZHgSSqqPDg7b0Loh1ihlzAUQPU2NADintvADLyaK19wPwpze8Bd
	 14SQuN8UuevmS+O7c5V7j7nnNIthKxXJAeV/NUU8raOI/FXF1JV5Ua1NZId0Pj/XZz
	 aI0Xi9wUvqtPg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] drm/vblank: Replace WARN with drm_err for vblank wait timeouts
Message-ID: <7527aaed-dcb2-4bde-a807-1677dcd0af99@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun,  2 Aug 2026 21:09:40 +0000 (UTC)

On PREEMPT_RT kernels, a user-space task with elevated Real-Time (RT)
priority can starve essential kernel threads. For example, the VKMS driver
simulates vblank interrupts using hrtimers. On PREEMPT_RT, these timers run
in the per-CPU timer threads at a low RT priority. If a user-space task
elevates its priority above the timer thread and monopolizes the CPU, the
timer thread is starved and the vblank hrtimer never fires.

This leads to a timeout when a worker thread waits for the vblank event.
For instance, a console update triggers a framebuffer update, scheduling
drm_fb_helper_damage_work() on the system workqueue. The worker thread
eventually calls drm_crtc_wait_one_vblank() to synchronize the screen
update with the vblank interval. Due to the starved timer, the wait times
out and triggers a drm_WARN. A similar issue exists in
drm_atomic_helper_wait_for_vblanks() where a WARN is triggered upon
timeout.

WARN macros must not be used for conditions that can legitimately happen,
and pr_err or drm_err should be used instead if necessary. Since this
timeout is an expected consequence of RT scheduling starvation rather than
a kernel bug, replace the warnings with drm_err(). This ensures the timeout
is still logged for diagnostic purposes without triggering an unnecessary
backtrace.

Fixes: 74afeb812850 ("drm/vblank: Add vblank timer")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f59157955aba9d0cb43b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f59157955aba9d0cb43b
Link: https://syzkaller.appspot.com/ai_job?id=396433fb-a59e-4936-97d4-4d2e7ced2ee9
To: "David Airlie" <airlied@gmail.com>
To: <dri-devel@lists.freedesktop.org>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 51f39edc3..0266beff9 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1918,8 +1918,9 @@ drm_atomic_helper_wait_for_vblanks(struct drm_device *dev,
 						drm_crtc_vblank_count(crtc),
 					 msecs_to_jiffies(1000));
 
-		WARN(!ret, "[CRTC:%d:%s] vblank wait timed out\n",
-		     crtc->base.id, crtc->name);
+		if (!ret)
+			drm_err(dev, "[CRTC:%d:%s] vblank wait timed out\n",
+				crtc->base.id, crtc->name);
 
 		drm_crtc_vblank_put(crtc);
 	}
diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
index f90fb2d13..7f7f4dd35 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -1326,7 +1326,8 @@ int drm_crtc_wait_one_vblank(struct drm_crtc *crtc)
 				 last != drm_vblank_count(dev, pipe),
 				 msecs_to_jiffies(1000));
 
-	drm_WARN(dev, ret == 0, "vblank wait timed out on crtc %i\n", pipe);
+	if (ret == 0)
+		drm_err(dev, "vblank wait timed out on crtc %i\n", pipe);
 
 	drm_vblank_put(dev, pipe);
 


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
