Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0215E439332;
	Wed, 29 Jul 2026 09:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785315896; cv=none; b=MFixuhVmsvziTZtG6N9egT83F30rFWIGqIvfBc4k83Y28G+wOR59Mva08KIbBiP96wvX5OSp0L/gOR9SoOS0EtG5+iJHhQGVCWpYUai0OXg755c44yPcGq+jFp6c5EOYsEkjXDv0JHQLuggiosHRqiHDEp2+6CRmSkjCtZcO5tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785315896; c=relaxed/simple;
	bh=+p8awnpXaesicgp/I7MDAs/q/AuXT9PbkNGvWWmvpVk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=EIJVye0LwgaADZlzbfjn/+jWms3bHE6snx/EYYF3qxQL1zNrCspH3iC/McCq8xbORMYqtFe5T8GKnIyi8Uc/gqY9YxRt+8BMe63cTPY7paIn1UhCx9Cb7Uf9Dw14gpn4R2GnwkMwFFaKClp8EgqCe5iFz9roqeww6prPOK4+Gfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eV9CfgHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eV9CfgHD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D11F1F000E9;
	Wed, 29 Jul 2026 09:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785315894;
	bh=49IBCpDlp5P7DDo8bEK/tW5M3Ngm2ifODSaPt1jNSDQ=;
	h=From:To:Cc:Subject:Date;
	b=eV9CfgHDqSKaWe9LUxx3a7MSBzMTNkbaMxDQJSHhgm2uUL5DbTH1L4iIgvOg0fHbu
	 hHoOs418/f4qt9l2koenEl0qjl+l9BRs899D+ynrwcBqekvgjznMKvEkhhlkOwKkm4
	 A8K05g+HEkz1pLwXMwqamv9hvddoR8eRH2MPLa/FqfB3ncuzywGVLntI+u8wbI4c2/
	 Dr4b+EmrcQ8Y3ZxvUvEzqndq70KD0B04jlch4PkDApzZhxKkR9kJIyHZoXGq8v403l
	 wrHrq0ouush1TvBvgKktYgTSrU9sLZyMjrkDvdrCwG2i5G+b1zuM3AJwOXDFu+D7iR
	 fN57lkmTuJRxA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>, "Takashi Iwai" <tiwai@suse.de>
Cc: christophe.jaillet@wanadoo.fr, kees@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] usb: gadget: midi2: Fix null-pointer dereference in f_midi2_free_ep_reqs
Message-ID: <cafe65f4-e1bb-46a3-901d-732814b861b2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 09:04:54 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

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
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
