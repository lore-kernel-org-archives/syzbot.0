Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75943F65EA
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 10:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785406506; cv=none; b=APAcDcjsbWQBn8n6Tgr3cJn7NGfnL+gosvNY1ZNHEowBxkZJ7kFtrjllOlYnrJGAPSY3wNgOmfRvURAMMr7HxHYI7WfYGlnikxYgtVu8WTdS9A4EiUpPlHYacNa3xdulVO8S4skNJ+OPerg6FfNSCBr/SEyGwlyVkjqBoVdU/0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785406506; c=relaxed/simple;
	bh=LmsSHPQdyj7V6b+f619YSzxWck2mhfYGvCs6bWTzIhc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=p3+96hBhWBHQ/+cgHK/V4tyaiq6cmNthDetQiyjlAJ8WKunBuTdun81SUeKYP0/aHC20JBwhUJhZ0z+3yRIj4qxG+6bVG7pvVIBfNvzUbSrG7QEVoQDwiExoOivXj60riyvFspDHEREpJKJE8BssKfqiNHehCVRwsoQOcGfYDp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NmrnYYAY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NmrnYYAY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5AFBD1F000E9;
	Thu, 30 Jul 2026 10:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785406504;
	bh=60bfhgC+dY8E7cFhv1nb15SSAiDqw0VDHUEjPVmuZK8=;
	h=From:To:Cc:Subject:Date;
	b=NmrnYYAY5aSiWLC25C5GKFeKLvxcFm7I85FAWQHZ0sEqWuW9RDcu2jEbOwgBc6SzC
	 Mn8NOYU0fbWpEjvmGykOwstGRaKXBfr/Ntai2RvY5Jd5671EIjVXgFbmZewo0IcfMt
	 EdRcIAsoTU6sI8uNonSLZc9LtXzLlVXPOlPwdezFpVlesH4Rmrij0RODG2b/QFk/5M
	 d8B66DspjGVsHLgby9vwDyOiMvUKida3McEGwj7kPUjF0gqr/H7Le/c+2jE5rJecQG
	 jJQkBkh/nwkfYRTdBUz8GE42N3R8/fbV6Xq1JJGRnAIFB5W+YpVrQl3w8LP0Uuy1Ok
	 xIGw3HPL3ru1w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: midi2: Fix NULL pointer deref in f_midi2_free_ep_reqs()
Message-ID: <bd23b61d-f4a6-452f-8ff4-7801875d5fb2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 30 Jul 2026 10:15:04 +0000 (UTC)

When the gadget is unbound, f_midi2_unbind() unconditionally attempts to
free both endpoints (midi1_ep_in and midi1_ep_out). However, if an endpoint
was never initialized during f_midi2_bind() (e.g., because the direction
attribute of the first block was set to SNDRV_UMP_DIR_INPUT, skipping
midi1_ep_out initialization), its usb_ep->card pointer remains NULL.

When f_midi2_free_ep() calls f_midi2_free_ep_reqs(), it attempts to
dereference usb_ep->card to read the number of requests, leading to a
crash:

Oops: general protection fault, probably for non-canonical address
0xdffffc00000000ee: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000770-0x0000000000000777]
RIP: 0010:f_midi2_free_ep_reqs drivers/usb/gadget/function/f_midi2.c:1166
[inline]
RIP: 0010:f_midi2_free_ep+0x52/0x2f0
drivers/usb/gadget/function/f_midi2.c:1208
Call Trace:
 f_midi2_unbind+0x9b/0x340 drivers/usb/gadget/function/f_midi2.c:2066
 purge_configs_funcs+0x248/0x3d0 drivers/usb/gadget/configfs.c:1600
 configfs_composite_unbind+0xa0/0x1b0 drivers/usb/gadget/configfs.c:1846
 gadget_unbind_driver+0x1cb/0x410 drivers/usb/gadget/udc/core.c:1724

To fix this, use usb_ep->num_reqs instead of usb_ep->card->info.num_reqs as
the loop boundary in f_midi2_free_ep_reqs() and f_midi2_alloc_ep_reqs().
For uninitialized endpoints, usb_ep->num_reqs is 0, which safely skips the
loop and avoids the crash. This also aligns with other cleanup functions
like f_midi2_drop_reqs() which already use usb_ep->num_reqs.

Fixes: 856fa444b098 ("usb: gadget: midi2: Dynamically create MIDI 1.0 altset descriptors")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+3451bfda4264c512ef27@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3451bfda4264c512ef27
Link: https://syzkaller.appspot.com/ai_job?id=87029043-73c1-4080-852b-012a419da14f
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/function/f_midi2.c b/drivers/usb/gadget/function/f_midi2.c
index 19fdac024..5e54cf994 100644
--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -1145,7 +1145,7 @@ static int f_midi2_alloc_ep_reqs(struct f_midi2_usb_ep *usb_ep)
 	if (!usb_ep->reqs)
 		return -EINVAL;
 
-	for (i = 0; i < midi2->info.num_reqs; i++) {
+	for (i = 0; i < usb_ep->num_reqs; i++) {
 		if (usb_ep->reqs[i].req)
 			continue;
 		usb_ep->reqs[i].req = alloc_ep_req(usb_ep->usb_ep,
@@ -1160,10 +1160,9 @@ static int f_midi2_alloc_ep_reqs(struct f_midi2_usb_ep *usb_ep)
 /* Free allocated requests */
 static void f_midi2_free_ep_reqs(struct f_midi2_usb_ep *usb_ep)
 {
-	struct f_midi2 *midi2 = usb_ep->card;
 	int i;
 
-	for (i = 0; i < midi2->info.num_reqs; i++) {
+	for (i = 0; i < usb_ep->num_reqs; i++) {
 		if (!usb_ep->reqs[i].req)
 			continue;
 		free_ep_req(usb_ep->usb_ep, usb_ep->reqs[i].req);


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
