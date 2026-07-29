Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A35B42A795
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 08:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785313046; cv=none; b=gE/IuzM7vx6HxjYmJulsSGuliM5EicXAOeHUw7xatZXygQss4FCrSfMxMMA/KsPH2uoRkOl8kcLfbCDd7bafB2UoVVzjU/RtdsPGz2F252h2TDTalTwzPjtVJc+cF9HZKYbcOPnQy8kVn5DhqxSjRf5eXKf0uJVboB5H8z4KB38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785313046; c=relaxed/simple;
	bh=lxgJQR4KdPY6IyUgR+akOc1VoNhhkyfOuSIKmN+BdCs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=WjhYX2A/p0P92EGFphbD+CR8tg7i0AReIm71P8cZXwfPzpgXx6g2vMsDbMQrCk98hJnvoM5Cdt6VFSnQ5SRcxdSV0t8XXSc7YE6m1X7e9oV5dgTcxJDSwz/xD+ulqL3VwAkT69m+FYy/jWo8cvmXIFweXms68yQqFPnWTfxBv+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iu0Z5ssy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iu0Z5ssy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8A6C21F000E9;
	Wed, 29 Jul 2026 08:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313044;
	bh=pYakC2y1aRvKswQ5jgz8injNjlomUg05/sfjrqpWj08=;
	h=From:To:Cc:Subject:Date;
	b=Iu0Z5ssy03eTYf9/Yu/c8Xb1cmxUo9BoupVB3MRgYBkm5lP2YwTHR4FdtSxIa87AR
	 vtCidvFFKmXEr/I/L5TTz/AonRUPSiBEb1+qd5F+j7fpH/YLC89BYZa48gUcFTVaiI
	 3wQPwLyMg8vsWGebeJb4NObdjHCZzzSxZAC1kX638jOmIThTrIyfgPN1MegX90nHSL
	 7DLSkOTeUEh3kDcpgG6ZmazwdSG659MuxbJR3Xc2Zprzy4R4jORFTGXLFTWuk53+6Y
	 CjrDqcIOeKASiA633nIzY6wNVxI339uPFmigpy7rk1PKyfpo+N+LkQ9j4oz4iNJOVW
	 zcEYEdhJ/it7w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: midi2: Fix null-pointer dereference in f_midi2_free_ep_reqs
Message-ID: <8e3a30ca-25ad-44cf-9fa2-b4d70f4572ab@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 08:17:24 +0000 (UTC)

A null-pointer dereference occurs in f_midi2_free_ep_reqs() when attempting
to clean up an endpoint that was never initialized.

When configuring the MIDI 2.0 gadget via configfs and setting the block
direction to SNDRV_UMP_DIR_INPUT, the initialization of the midi1_ep_out
endpoint is explicitly skipped during the gadget bind phase
(f_midi2_bind()). As a result, the usb_ep->card field remains NULL.

Later, when the host sets the alternate setting, f_midi2_set_alt()
unconditionally stops both the IN and OUT endpoints by calling
f_midi2_stop_eps(), which in turn calls f_midi2_free_ep_reqs() for both
endpoints. When f_midi2_free_ep_reqs() is called for the uninitialized
midi1_ep_out, it attempts to dereference usb_ep->card to determine the
number of requests to free, leading to a crash.

Fix this by using usb_ep->num_reqs instead of usb_ep->card->info.num_reqs
in f_midi2_free_ep_reqs(). usb_ep->num_reqs is correctly set during
f_midi2_init_ep() and remains 0 if the endpoint was never initialized,
safely avoiding the loop. For consistency, apply the same change to
f_midi2_alloc_ep_reqs().

Oops: general protection fault, probably for non-canonical address
0xdffffc00000000ee: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000770-0x0000000000000777]
...
RIP: 0010:f_midi2_free_ep_reqs drivers/usb/gadget/function/f_midi2.c:1166
[inline]
RIP: 0010:f_midi2_stop_eps+0x28e/0x4d0
drivers/usb/gadget/function/f_midi2.c:1246
...
Call Trace:
 <TASK>
 f_midi2_set_alt+0x11c/0xf00 drivers/usb/gadget/function/f_midi2.c:1296
 composite_setup+0x1ffd/0x3480 drivers/usb/gadget/composite.c:1933
 configfs_composite_setup+0xbd/0x100 drivers/usb/gadget/configfs.c:1877

Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+bbb6dad313f4aaa8da6b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bbb6dad313f4aaa8da6b
Link: https://syzkaller.appspot.com/ai_job?id=8ce30b1a-8cf7-4e38-bcf7-1f69e6f6313f
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
