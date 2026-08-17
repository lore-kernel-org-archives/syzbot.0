Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21965C613
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 01:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786931857; cv=none; b=GxxFG5QvV6dYIQ9AqBPAELoXBmP+rN4TPRucCQd0hAY6u95A1qG4VOehGRA6RpcxsLqmZj2y0MqQyvzNdFtwHd/yClJ+EPqGQwp5bnNi/uk7DZrM+63wCZPGyj209OXiryABOfR4v4oG9iButEFmAhWeHhVrKTV6LD2uOwPMbrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786931857; c=relaxed/simple;
	bh=abnta/0jDim48Z4xJsvj44591yNz2CIXhexkm4mJzW4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=OOXPHkN2bDP9ii6dWLCf1FtePBcZdj18aO53lXEbOCsVFuOTlHL4kpetHUoGb92YxT1OQ3fcYIHtUpwoS+1sGvQlhvHJqum9pHbb+iXgqIuuilp1cDEr72m0I7Hx878mRJ0t4ffsY6FWTxyXwIEhq13pP44OZQyZSu1+ewIX/vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zkg2+xVH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zkg2+xVH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 861EC1F000E9;
	Mon, 17 Aug 2026 01:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786931855;
	bh=wa/Vl/8PoPBy3v7OjdXjYjCStcpxxORpcNyFegBjNmA=;
	h=From:To:Cc:Subject:Date;
	b=Zkg2+xVHeFXsz/Mw2/K4vI3y5xNFfxdJMKkRr6q2+6Y2DIh6ssN6xbjHrczy3IxhH
	 S+ww3bvcvcpWnIjdeukil7RF9ojcMW3fqkRBZca4rWpawUJlrhh6WYLxbQCLVSyPTa
	 XBznyCSAYn0f4w6zLxf2yQ4+VKPmnspLzZbhMqyz/sEmjAVAlYFsRUY4LZa0btQ6dQ
	 2mfMJIXCwMOj5qN9YmwyvwLG+QXUIfnWaj68XmMjwkEnRr0zTHWBMOFD525kgLDfor
	 FZIReYdMpp5CBhU6kxJqCv6pV2vlDlF5HuzaUSVsYjgL+4Le80UAgFFR9KGVtWan9l
	 d25L3Lcp7OQNQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fbdev: fbcon: Fix out-of-bounds read when changing font charcount
Message-ID: <0b636a40-f697-4654-97dd-c677de68e151@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 17 Aug 2026 01:57:35 +0000 (UTC)

The root cause of this KASAN slab-out-of-bounds read is that fbcon fails to
reallocate the rotated font buffer (par->rotated.buf) when the font
character count changes but the font dimensions (width and height) remain
the same.

When a user changes the font via ioctl(KDFONTOP), fbcon_do_set_font() is
called. If the user first sets a 256-character font, enables rotation, and
then sets a 512-character font with the exact same width and height, resize
evaluates to false. The function then directly calls update_screen(vc).
Notice that fbcon_do_set_font() never calls par->bitops->rotate_font() to
update the rotated font buffer for the new font. As a result,
par->rotated.buf remains sized for the old 256-character font.

When update_screen(vc) is called, it eventually reaches cw_putcs_aligned(),
which attempts to read the glyphs from the rotated buffer. Since
vc->vc_font.charcount is now 512, vc->vc_hi_font_mask is set, making
charmask equal to 0x1ff (511). If the text buffer contains a character with
an index >= 256, src will point out of bounds of the old par->rotated.buf
(which only holds 256 glyphs). The subsequent read in
__fb_pad_aligned_buffer() triggers the KASAN slab-out-of-bounds crash.

BUG: KASAN: slab-out-of-bounds in __fb_pad_aligned_buffer
include/linux/fb.h:646 [inline]
BUG: KASAN: slab-out-of-bounds in fb_pad_aligned_buffer+0x583/0x5f0
drivers/video/fbdev/core/fbmem.c:96
Read of size 1 at addr ffff888127cc5200 by task syz-executor109/5910
Call Trace:
 <TASK>
 __fb_pad_aligned_buffer include/linux/fb.h:646 [inline]
 fb_pad_aligned_buffer+0x583/0x5f0 drivers/video/fbdev/core/fbmem.c:96
 cw_putcs_aligned drivers/video/fbdev/core/fbcon_cw.c:105 [inline]
 cw_putcs+0x14fa/0x18e0 drivers/video/fbdev/core/fbcon_cw.c:159
 fbcon_putcs+0x3c5/0x5a0 drivers/video/fbdev/core/fbcon.c:1392
 con_putc drivers/tty/vt/vt.c:330 [inline]
 hide_softcursor drivers/tty/vt/vt.c:872 [inline]
 hide_cursor+0x358/0x490 drivers/tty/vt/vt.c:884
 redraw_screen+0x1f2/0x1020 drivers/tty/vt/vt.c:985
 fbcon_do_set_font+0xd30/0x1930 drivers/video/fbdev/core/fbcon.c:2441
 fbcon_set_font+0x6f5/0x970 drivers/video/fbdev/core/fbcon.c:2518
 con_font_set drivers/tty/vt/vt.c:4992 [inline]
 con_font_op+0xc37/0xfe0 drivers/tty/vt/vt.c:5032
 vt_k_ioctl drivers/tty/vt/vt_ioctl.c:474 [inline]
 vt_ioctl+0x1ba8/0x20e0 drivers/tty/vt/vt_ioctl.c:745

To fix this, fbcon_do_set_font() must call par->bitops->rotate_font() to
update the rotated font buffer before calling vc_resize() or
update_screen(). If vc_resize() fails and the old font is restored in the
error path, rotate_font() must be called again to restore the rotated
buffer.

This pattern of updating the rotated font buffer was previously established
in fbcon_modechanged() by commit ef7656e85f1a ("fbdev: Fix out-of-bounds
access when rotating console after font resize"). The fix applies this
exact idiom to fbcon_do_set_font(). By placing it before vc_resize() and
update_screen(), we ensure the buffer is correctly sized before any
rendering occurs. Checking con_is_visible(vc) is also correct here, as
hidden consoles will have their rotation state updated later via
fbcon_switch() when they become visible.

Furthermore, by calling rotate_font() again in the err_out path, we ensure
that if vc_resize() fails, the rotated buffer is restored to match the old
vc->vc_font. Without this, restoring a 512-character font to a
256-character font on failure would leave the rotated buffer sized for 512
characters, which wastes memory; or worse, restoring a 256-character font
to a 512-character font would leave the buffer too small, causing an
out-of-bounds read later.

Fixes: e4fc27618b75 ("[PATCH] fbcon: Console Rotation - Prepare fbcon for console rotation")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+bf4020519fbd94b2355d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bf4020519fbd94b2355d
Link: https://syzkaller.appspot.com/ai_job?id=59f0d7d9-607c-4497-b2e2-0b16693f9502
To: "Helge Deller" <deller@gmx.de>
To: <dri-devel@lists.freedesktop.org>
To: <linux-fbdev@vger.kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index 23b3c536d..c74a4905b 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2425,6 +2425,13 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 	else if (!vc->vc_hi_font_mask && charcount == 512)
 		set_vc_hi_font(vc, true);
 
+	if (con_is_visible(vc)) {
+		if (par->bitops->rotate_font && par->bitops->rotate_font(info, vc)) {
+			par->rotate = FB_ROTATE_UR;
+			set_blitting_type(vc, info);
+		}
+	}
+
 	if (resize) {
 		int cols, rows;
 
@@ -2459,6 +2466,13 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h, int charcount,
 	else if (!old_hi_font_mask && vc->vc_hi_font_mask)
 		set_vc_hi_font(vc, false);
 
+	if (con_is_visible(vc)) {
+		if (par->bitops->rotate_font && par->bitops->rotate_font(info, vc)) {
+			par->rotate = FB_ROTATE_UR;
+			set_blitting_type(vc, info);
+		}
+	}
+
 	font_data_put(data);
 
 	return ret;


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
