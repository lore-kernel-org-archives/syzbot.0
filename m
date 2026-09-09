Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A78F5A514C
	for <syzbot@lists.linux.dev>; Wed,  9 Sep 2026 21:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788989249; cv=none; b=oMOYA0b4tRJfyl/92wV4UDJqkIrVQdDXPxnh9EKJd6ANxSRk4AKyE4TXwixAtHpWW3ibrbvKP08z8dPT9/7Fb7NN0rTfCgBE21oo6SuogfdPcji+yOUGrVF9W+N2xYMYXCc0Dr37Di6m6m7nLUmH+FCjxbJFs1K+yZWwUM1Ysjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788989249; c=relaxed/simple;
	bh=J8oNc4lSd9++48nEHIPGRBg2Qo2NhnKV5NgfBcx3ob4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=su/nI+9Pb1F73x/Z802f5SY9ywCee7onbrKV0pCtD2jy5ZcOlP+g5SYKiWUKkQxA5IHXtsgdCnrUYc7cMenfwKuUOmUR5+werOlRlfYRiJKP54AZWIdF+xtzdOhheU/FtUYN02sG013WBG9GsWQoiXyp0m8AMHvsVHD+hZRolYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5NMuDpZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5NMuDpZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2BBAA1F00893;
	Wed,  9 Sep 2026 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788989231;
	bh=cxVzFkduDi+tx/RlMzm2QtqV1K5VKoWPgRovPmC02jM=;
	h=From:To:Cc:Subject:Date;
	b=b5NMuDpZZlOwo5g5XH6YZaaSO//RXyCOG0DIoHFjenFb7kd4ieizw1YZHz3giYjCg
	 1OYVWMC9ndD8Ts25ffXNz9OaYk/lADBUlhRixaUoGj2kP01X8bGVx12eVOBmw7TOU7
	 Tnujsm0Dw+k/H5dKUGEU98SZQXbVjzPzWxwzLxymeo7DjdZq57UG728b4o7/L0ctZx
	 loMmLuAAlFnhsxtJ2r65fDWryEsfwipqp4YDvCdJHTbCKmezSaONyiE4GgIsLBTaq0
	 7MCfkUuILyreE7dj7lj5Vfd1f9xx4AVvW3t+IM/ptbu7UsDcetL15kmxEj34jPk5oF
	 tzSvlIhZAwhVw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: v4l2-ctrls: Handle NULL master control in clustering helpers
Message-ID: <ba8b1584-f84e-4418-8b79-2d7f2b714c56@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  9 Sep 2026 21:27:11 +0000 (UTC)

The V4L2 control framework employs a deferred error handling mechanism for
control creation. Drivers can invoke multiple control creation helpers
(such as v4l2_ctrl_new_std()) without checking the return value of each
call. If an error occurs, such as a memory allocation failure during
v4l2_ctrl_handler_init() or v4l2_ctrl_new_*(), the handler records the
error in hdl->error, and subsequent control creation calls immediately
return NULL. Drivers check hdl->error once at the end of setup.

Drivers are documented and encouraged to cluster controls right after
creating them using helpers like v4l2_ctrl_cluster() or
v4l2_ctrl_auto_cluster(). However, v4l2_ctrl_cluster() checked
`WARN_ON(ncontrols == 0 || controls[0] == NULL)`. If an allocation failure
occurs prior to clustering, controls[0] is NULL. Because this condition can
legitimately happen when memory allocation fails under deferred error
handling, WARN_ON must not be used for conditions that can legitimately
happen, and pr_err should be used instead if necessary.

Additionally, on systems where panic_on_warn is not set and execution
continues after the warning, v4l2_ctrl_cluster() returns early, but
v4l2_ctrl_auto_cluster() proceeds to dereference master (controls[0]),
causing a NULL pointer dereference crash when evaluating master->minimum
and master->maximum. v4l2_ctrl_auto_cluster() also assigned `master =
controls[0]` unconditionally prior to checking ncontrols.

For instance, during hackrf_probe(), if handler initialization fails to
allocate memory, dev->rx_bandwidth_auto remains NULL. Calling
v4l2_ctrl_auto_cluster() with dev->rx_bandwidth_auto triggers the warning:

WARNING: drivers/media/v4l2-core/v4l2-ctrls-core.c:2525 at
v4l2_ctrl_auto_cluster+0x1c1/0x610
drivers/media/v4l2-core/v4l2-ctrls-core.c:2547
Call Trace:
 <TASK>
 hackrf_probe+0x80a/0x1360 drivers/media/usb/hackrf/hackrf.c:1430
 usb_probe_interface+0x788/0xe50 drivers/usb/core/driver.c:399
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
 __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
 bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
 __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
 </TASK>

Fix this by separating the checks in v4l2_ctrl_cluster(): retain
WARN_ON(ncontrols == 0) as passing zero controls indicates a driver bug,
but silently return when controls[0] is NULL, consistent with other control
helpers like v4l2_ctrl_activate() and __v4l2_ctrl_grab(). In
v4l2_ctrl_auto_cluster(), safely initialize master with `ncontrols ?
controls[0] : NULL` and return immediately if master is NULL before
dereferencing any of its fields.

Fixes: c817d927b0f7 ("[media] v4l2-ctrls: replace BUG_ON by WARN_ON")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+cf896de36144391bcde1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cf896de36144391bcde1
Link: https://syzkaller.appspot.com/ai_job?id=b5f6d956-eb5a-4244-a774-4b9f4cf9a078
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Hans Verkuil" <hverkuil+cisco@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Ming Qian" <ming.qian@oss.nxp.com>
Cc: "Nicolas Dufresne" <nicolas.dufresne@collabora.com>
Cc: "Pavan Bobba" <opensource206@gmail.com>

---
diff --git a/drivers/media/v4l2-core/v4l2-ctrls-core.c b/drivers/media/v4l2-core/v4l2-ctrls-core.c
index 5b8a594fb..e77ce7b56 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -2521,8 +2521,14 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 	bool has_volatiles = false;
 	int i;
 
-	/* The first control is the master control and it must not be NULL */
-	if (WARN_ON(ncontrols == 0 || controls[0] == NULL))
+	if (WARN_ON(ncontrols == 0))
+		return;
+
+	/*
+	 * The first control is the master control. If this is NULL then
+	 * there is nothing to do.
+	 */
+	if (controls[0] == NULL)
 		return;
 
 	for (i = 0; i < ncontrols; i++) {
@@ -2540,12 +2546,14 @@ EXPORT_SYMBOL(v4l2_ctrl_cluster);
 void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
 			    u8 manual_val, bool set_volatile)
 {
-	struct v4l2_ctrl *master = controls[0];
+	struct v4l2_ctrl *master = ncontrols ? controls[0] : NULL;
 	u32 flag = 0;
 	int i;
 
 	v4l2_ctrl_cluster(ncontrols, controls);
 	WARN_ON(ncontrols <= 1);
+	if (!master)
+		return;
 	WARN_ON(manual_val < master->minimum || manual_val > master->maximum);
 	WARN_ON(set_volatile && !has_op(master, g_volatile_ctrl));
 	master->is_auto = true;


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
