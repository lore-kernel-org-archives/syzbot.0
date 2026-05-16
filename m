Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AC1224F3
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 14:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778942071; cv=none; b=QQOvMrYBHznl/jRXZscivEW1Umbcob+9caPNkccYT3Q0GQgrPXwovD1CpuOwgbNcQ7MYf8Vr+vpaTA9CG0Eh/+orpXaoRis0Wkxbh4c5U/+aGakQS9gx4fE/wal2hLUhDPxkZutBTiCu6XKM8VsUfLHbYPfsPy8orh/yib3RF0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778942071; c=relaxed/simple;
	bh=yLbTr3JTtT+v2TkUD3ARWFZ/aGtbFzRnoImGmSSX7/s=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=oaD7snZ1E2N7AVvUUxacmfdFa6H4yQSL4CVQyhgUT4hiUQIJxOU+QjgntADz9UlxzhohNf41MTd9Sd4oEFAkOYsp4rbHY6WuOIy6VpAYFGFnvBBGFTaFvSYR/CQYUAXkhXNVLkygebPsby+yJCWAI6CpyTTJHhF8SPA8l9LFG4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8VaQVYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8VaQVYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373C9C19425;
	Sat, 16 May 2026 14:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778942071;
	bh=yLbTr3JTtT+v2TkUD3ARWFZ/aGtbFzRnoImGmSSX7/s=;
	h=From:To:Cc:Subject:Date:From;
	b=F8VaQVYM8Xz7syxN4ebw3Iu0mrIbeKT7yjLQpQtKCqV0bvkjqnQngGvgArHpjgrAH
	 ByLNgEJV+po3E1LuEQm8CHE3y7UmQMotM6EIhlAJyHpr7dcYZqrPAiUqfZWD6IraPe
	 e9EKwr8BgMIQeEZneAk4YbtMPY6hCojqYxj9fVACi1EelrsRRdagJOctkUfIUtROmi
	 9Ej4e37adEC5ajSXy71n+Cdk16REmsshImog1u/XMrLMEo5R70IgZIOKYc+u/ARTrs
	 jgxbUH2qlnFhRlcdcM6tnLIAGz83vzts+PtLbJA4Mp3Xjfk0sicxaQs757roCSmXHF
	 pkzlYB55DWXMw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: cdc-wdm: close race between workqueue and release
Message-ID: <97986988-6374-4e40-aa96-662939fabe88@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 16 May 2026 14:34:31 +0000 (UTC)

The crash "URB submitted while active" occurs because the
`desc->response` URB is submitted by `wdm_rxwork` when it is already in
an active state. This happens because `wdm_release` fails to cancel
pending workqueue items (`desc->rxwork` and `desc->service_outs_intr`)
during its cleanup phase. When the character device is closed and there
are no other openers, `wdm_release` calls `poison_urbs()` to kill active
URBs, clears the `WDM_RESPONDING` flag, and calls `unpoison_urbs()`.
Because `wdm_release` does not call `cancel_work_sync()` for the work
items, they can run concurrently with the cleanup process. If a work
item executes after the URBs are unpoisoned, it can successfully submit
the URB. If another work item then runs, it will see the
`WDM_RESPONDING` flag as cleared, set it, and attempt to submit the URB
again, leading to the crash.

To fix this, cancel the pending workqueue items after poisoning the URBs
and before clearing the `WDM_RESPONDING` flag or unpoisoning the URBs.
This ensures that any running work item will either fail to submit the
URB (because it is poisoned) or finish executing before the cleanup
proceeds. The same omission is present in `wdm_wwan_port_stop`, so apply
the same fix there to prevent data leaks or crashes across WWAN
sessions.

Fixes: 01e01f5c89773c600a9f0b32c888de0146066c3a ("usb: cdc-wdm: fix reading stuck on device close")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+c6a1953c27ace6cc34e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c6a1953c27ace6cc34e5
Link: https://syzkaller.appspot.com/ai_job?id=99107a5d-cc34-46f2-a7ce-bb797b331fd3
To: <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 7556c0dac..d4318395d 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -769,6 +769,8 @@ static int wdm_release(struct inode *inode, struct file *file)
 		if (!test_bit(WDM_DISCONNECTING, &desc->flags)) {
 			dev_dbg(&desc->intf->dev, "wdm_release: cleanup\n");
 			poison_urbs(desc);
+			cancel_work_sync(&desc->rxwork);
+			cancel_work_sync(&desc->service_outs_intr);
 			spin_lock_irq(&desc->iuspin);
 			desc->resp_count = 0;
 			clear_bit(WDM_RESPONDING, &desc->flags);
@@ -863,6 +865,8 @@ static void wdm_wwan_port_stop(struct wwan_port *port)
 
 	/* Stop all transfers and disable WWAN mode */
 	poison_urbs(desc);
+	cancel_work_sync(&desc->rxwork);
+	cancel_work_sync(&desc->service_outs_intr);
 	desc->manage_power(desc->intf, 0);
 	clear_bit(WDM_READ, &desc->flags);
 	unpoison_urbs(desc);


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
