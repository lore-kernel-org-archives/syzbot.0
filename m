Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEA517A31C
	for <syzbot@lists.linux.dev>; Sun, 10 May 2026 02:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778380238; cv=none; b=rdvMnNCxlkQTImScbVPoTp221DrK1kkDMWBHbAhVwIWa/JAeZmu6Q98BHL27LBJoTwycpIQ8GNRWk10GT+5sWwwfwtc9Q8kG9nP6lmdAZ7pSPMdx0mJp5RwkkmJk2TRGqnJQP31ZRcheNheD5DPCvn2LxeEv2u9j3Q8/yFglVNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778380238; c=relaxed/simple;
	bh=JaGb+/bvt1REfjo9zH0Ew/So+AUP7r3+5j1miYz1FHY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jgp+jtLt8ljTH9bPQ1hNGg55bDeY0qxHHx0f03l0I4iNWRngl8trjz1e18YYtBPJwdQNqCdvmZBrsdkSpxCyQorL/td6/ohxEkxEA90VTQ1sQDPSdqE9DCabJNauavKVywIw3Jqggb2E1u4oXisLoATCXmSrUG/daptGsS6dlwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmHR9clv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmHR9clv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F48C2BCB2;
	Sun, 10 May 2026 02:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778380238;
	bh=JaGb+/bvt1REfjo9zH0Ew/So+AUP7r3+5j1miYz1FHY=;
	h=From:To:Cc:Subject:Date:From;
	b=LmHR9clvS4KPdR3/l58JgBIYfWZJof9VvWPR3+CCCWLEGfsAZ2DmWWk0YTZ3+h1sl
	 KxEbZd+AjmyTVHTJ6O1HlbXdriwjd6IFQT9rM/7nxGzU/30xTaA8BEAyjngn37usbf
	 974fbPMMbJz6VBqD3Bvagix39DYDOzbG7yNnRzLxibVsEX0iphQZogXnj6TOZGWRxT
	 PZrfn0n/LfJuUsnBbbneM00/bDnfAUwvyZFPq2DihBB83kAb54m/iU7bLDnXeuXYCv
	 +mfdSwDrDKGLFX5FgHNT5+CGozjBJt7S4nx7HS6Gze6M4LXX+Rx0ir6DZfVhSE2RSO
	 C3opnuRDclgWw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: pvrusb2: fix missing cleanup in pvr2_send_request_ex
Message-ID: <8cbeab5b-2812-4567-845f-9baee48062fb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 10 May 2026 02:30:37 +0000 (UTC)

media: pvrusb2: fix missing cleanup in pvr2_send_request_ex

In pvr2_send_request_ex(), if usb_urb_ep_type_check() fails on the read
or write URB, the function returns directly without proper cleanup. This
skips the timer_destroy_on_stack() call, leaking a timer debug object if
CONFIG_DEBUG_OBJECTS_TIMERS is enabled.

Additionally, if the write URB was already submitted and the read URB
check fails, returning directly leaves the write URB active. The next
time pvr2_send_request_ex() is called, it attempts to reuse the active
write URB, triggering a "URB submitted while active" warning in
usb_submit_urb().

Fix this by replacing the direct returns with `goto done` and the
appropriate cleanup logic, matching the rest of the error handling in
the function.

Assisted-by: Gemini:gemini-3.1-pro-preview
To: <isely@pobox.com>
To: <linux-media@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <mchehab@kernel.org>

---
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 3c270ef00..dd504b1c4 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -3669,7 +3669,9 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
 				"Invalid write control endpoint");
-			return -EINVAL;
+			hdw->ctl_write_pend_flag = 0;
+			status = -EINVAL;
+			goto done;
 		}
 		status = usb_submit_urb(hdw->ctl_write_urb,GFP_KERNEL);
 		if (status < 0) {
@@ -3699,7 +3701,14 @@ status);
 			pvr2_trace(
 				PVR2_TRACE_ERROR_LEGS,
 				"Invalid read control endpoint");
-			return -EINVAL;
+			hdw->ctl_read_pend_flag = 0;
+			status = -EINVAL;
+			if (hdw->ctl_write_pend_flag) {
+				usb_unlink_urb(hdw->ctl_write_urb);
+				while (hdw->ctl_write_pend_flag)
+					wait_for_completion(&hdw->ctl_done);
+			}
+			goto done;
 		}
 		status = usb_submit_urb(hdw->ctl_read_urb,GFP_KERNEL);
 		if (status < 0) {


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
