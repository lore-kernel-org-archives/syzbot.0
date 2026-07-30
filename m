Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C392C3750CF
	for <syzbot@lists.linux.dev>; Thu, 30 Jul 2026 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424326; cv=none; b=e0p0PGILqzIOvP7sQp3QQOJZEY5PszriEO2nWaF+cYD1LOCwUq9ObiHE0EjH5lhQpESdVtT2/LO4z+4EWRucj+LrOJHXw6QexUt5ZMbOwS8ALsVwamktdz9Yq4GGkbFCVWd8hq5Ht0Lc+J/4UmZhA3gve1pgvG3OTWzkYMXISv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424326; c=relaxed/simple;
	bh=f744/0nqxzA7DyY4C/46tLx3kMmk5gHV/IExdjYsScc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=PtKP6x9jpMZrfQYzHtNsK0TTewHG3sQJKqXNHz+gdTk+ywtjFxJDNFqCUKrc4LwdquCt1lRB1VSePKvdafPgFl0OQSGMupIlAM+kJllRwKMQBJxsotvQhOAAaV1dKNXuz0YD1aFQM7kIdFZEOlMP42kGBtwl8Lj88gbbg8WWUGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4X/TjsM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4X/TjsM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 760031F00A3A;
	Thu, 30 Jul 2026 15:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785424324;
	bh=U8H+MHA3u5eYK1LhnmWfHLgHZt+eGDnQbL5pikwkTw4=;
	h=From:To:Cc:Subject:Date;
	b=Q4X/TjsMBCmQYb0Z+JzoyK/i0myPV0W2WuZHKhXC5V2aOPjLTjJRfabnTH9FnBPa4
	 ltc578/C68g9acLh1wxWc+vpBXm6WsCqeKm1UezQm9CJDZsVLO79x4+6w+QFidgtvj
	 c9Iaj/2GjMv2pkcuHkpKS/5ihbWhAnEjoy2vb/ftQ+eahYtrD4yaZmzzyAvdMbgSyx
	 RaCaGsz9HIst9pRunUmqHiuWWIkyptospjD0GK5wKdqkRRDs3oHSRxS8oej0kAXkGa
	 feWNw4l2+sYddlt2dy7C785Lg4eoIJB3AwsqABgqms6hfy9XAs61uHMRJGhRCDZI6E
	 TiRSugYqOApjg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: midi2: Fix memory leak in configfs default groups
Message-ID: <67862448-cd60-416f-b63f-bbd295ceeba1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 30 Jul 2026 15:12:04 +0000 (UTC)

When a USB function instance for midi2 is allocated, it dynamically
allocates ep_opts and block_opts structures and adds them as default groups
(ep.0 and block.0). While configfs removes the dentries for default groups
when the parent directory is removed, it does not automatically drop their
reference counts. This responsibility lies with the driver.

Because f_midi2_free_inst() and f_midi2_ep_opts_release() do not clean up
their default groups, the ep_opts and block_opts structures are leaked when
the function instance is destroyed.

Fix this by explicitly calling configfs_remove_default_groups() in the
respective release functions. This ensures that the reference counts of the
default groups are properly dropped, triggering the existing release
callbacks (f_midi2_ep_opts_release and f_midi2_block_opts_release) to
safely free the dynamically allocated memory.

Kmemleak reports:

BUG: memory leak
unreferenced object 0xffff88810aacb200 (size 512):
  comm "syz.0.19", pid 6225, jiffies 4294944049
  hex dump (first 32 bytes):
    08 b2 ac 0a 81 88 ff ff 65 70 2e 30 00 00 00 00  ........ep.0....
    00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00  ................
  backtrace (crc f2efe6a4):
    ...
    f_midi2_ep_opts_create drivers/usb/gadget/function/f_midi2.c:2504
    [inline]
    f_midi2_alloc_inst+0x80/0x2c0
    drivers/usb/gadget/function/f_midi2.c:2666
    ...

BUG: memory leak
unreferenced object 0xffff8881083d9e00 (size 256):
  comm "syz.0.19", pid 6225, jiffies 4294944049
  hex dump (first 32 bytes):
    08 9e 3d 08 81 88 ff ff 62 6c 6f 63 6b 2e 30 00  ..=.....block.0.
    00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00  ................
  backtrace (crc cc37bc9e):
    ...
    f_midi2_block_opts_create drivers/usb/gadget/function/f_midi2.c:2342
    [inline]
    f_midi2_alloc_inst+0x16a/0x2c0
    drivers/usb/gadget/function/f_midi2.c:2673
    ...

Fixes: 29ee7a4dddd5 ("usb: gadget: midi2: Add configfs support")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+eaa106d192c9daf37f95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=eaa106d192c9daf37f95
Link: https://syzkaller.appspot.com/ai_job?id=9087164f-64c8-456d-abd0-052d4a7f1ddd
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Takashi Iwai" <tiwai@suse.de>
Cc: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/function/f_midi2.c b/drivers/usb/gadget/function/f_midi2.c
index 19fdac024..ec4266ecc 100644
--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -2473,6 +2473,7 @@ static void f_midi2_ep_opts_release(struct config_item *item)
 {
 	struct f_midi2_ep_opts *opts = to_f_midi2_ep_opts(item);
 
+	configfs_remove_default_groups(to_config_group(item));
 	kfree(opts->info.ep_name);
 	kfree(opts->info.product_id);
 	kfree(opts);
@@ -2639,6 +2640,7 @@ static void f_midi2_free_inst(struct usb_function_instance *f)
 
 	opts = container_of(f, struct f_midi2_opts, func_inst);
 
+	configfs_remove_default_groups(&opts->func_inst.group);
 	kfree(opts->info.iface_name);
 	kfree(opts);
 }


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
