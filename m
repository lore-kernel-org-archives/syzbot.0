Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E568A36197C
	for <syzbot@lists.linux.dev>; Wed, 22 Jul 2026 16:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784736268; cv=none; b=LfEQ/AtDD9lt7B8mTTz3CHBQ37ZGsfjS1puQcnBVjtXbmsBtc2v1YckpyFVJssKrGHyXH00//SpRVVOxP+gY3FU+l48y0zs2iYwK4AkgbED6nSk30R83TFsL9/+IjF1K6V3xbZfBkeZ519a5Y200MepqZNz5UY+nHgK/LZkdrPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784736268; c=relaxed/simple;
	bh=r4pSEgFeD3rt8Yb0ageGidBsORCHx6CcT0AbIhFC3Dw=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=aXb47I1oIYnvCxnK183QjgZ4tiwCppMpQEhY0ff8POyX0g7jEilx0xRTgkDVM05mifSRSJtf/98oGDFw8yws/qcCo26+z+sTRHcH4MHImiVmrwcs0ezb5bdvpd3a1wQsaqoszxSOfsIW4FRbq92yiIo/THSRw7CHQQCtQ6VX44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Il1KSRTa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Il1KSRTa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 654EA1F00A3A;
	Wed, 22 Jul 2026 16:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784736266;
	bh=k0DySdt4cFe6uLhk2SInCSD+zAIDy/ZuTxujlC8RHwc=;
	h=From:To:Cc:Subject:Date;
	b=Il1KSRTaZ+yoR+2hBjSEq7pw+9McoKKoV5iC23cPxz6oQhsdJFKu0R+qFipVThHAt
	 avFGPvH3/ZY7Khhi0J0WXtmzi+0xlAH8BbMJNtPZDwjECUng+1Lhm7SPEzExNrgaVJ
	 7+8yUrYaykZWsJsG2eVG4rQjM6Re0EucHNNo8nOuHrs3c/L0d1DgZkWaf6E9TbRBBn
	 WtVhcLChB6Umwc0zCEtGppNtznk0CctK54nwDbdGdO3QikxbzVapNdHaops2f+jLM7
	 RJ1tmKRRJyFYAxk01UD61MfNEVVzLkCIzlEWATsR+3kZ6wwlWzhcsbV8A9jMb+lC/k
	 +WIKnnjRzxggQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fbdev: core: Add bounds checking to drawing functions
Message-ID: <8fa4f66c-506a-4929-9906-9cec63760a7b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 22 Jul 2026 16:04:26 +0000 (UTC)

A vmalloc-out-of-bounds write can occur in the framebuffer drawing
functions. This happens when fbcon ignores a failure from vc_resize()
(e.g., due to a memory allocation failure) and proceeds to draw the console
using the old, larger dimensions that no longer fit within the new, smaller
framebuffer resolution. This mismatch causes the calculated drawing
coordinates to underflow, resulting in massive positive numbers.

Because the low-level drawing functions (fb_imageblit, fb_fillrect, and
fb_copyarea) previously lacked bounds checking, they blindly used these
invalid coordinates to calculate memory addresses, leading to a
vmalloc-out-of-bounds write.

While it might seem tempting to handle the error in fbcon_modechanged(),
doing so cleanly is difficult because the hardware resolution and rotation
state have already been altered by the time the failure occurs. Instead,
the most robust and idiomatic solution is to implement defense-in-depth by
adding bounds checking directly to the low-level drawing functions. This
protects all framebuffer drivers from out-of-bounds accesses, regardless of
whether the invalid coordinates come from fbcon or another source.

Add bounds checks at the beginning of the inline functions in
drivers/video/fbdev/core/fb_imageblit.h, fb_fillrect.h, and fb_copyarea.h.
These checks validate the destination coordinates (dx, dy) and dimensions
(width, height) against the virtual resolution of the framebuffer
(p->var.xres_virtual and p->var.yres_virtual). Because the coordinates and
dimensions are unsigned 32-bit integers (u32), any negative coordinate
resulting from an underflow will wrap around to a huge positive number. The
>= xres_virtual (or yres_virtual) checks safely and correctly catch these
underflows. If the bounds check fails, the function simply returns early,
dropping the invalid drawing operation and protecting kernel memory.

BUG: KASAN: vmalloc-out-of-bounds in fb_write_offset
drivers/video/fbdev/core/sysmem.h:30 [inline]
BUG: KASAN: vmalloc-out-of-bounds in fb_bitmap_2ppw
drivers/video/fbdev/core/fb_imageblit.h:364 [inline]
BUG: KASAN: vmalloc-out-of-bounds in fb_bitmap_imageblit
drivers/video/fbdev/core/fb_imageblit.h:462 [inline]
BUG: KASAN: vmalloc-out-of-bounds in fb_imageblit
drivers/video/fbdev/core/fb_imageblit.h:492 [inline]
BUG: KASAN: vmalloc-out-of-bounds in sys_imageblit+0xff5/0x1e40
drivers/video/fbdev/core/sysimgblt.c:24
Write of size 8 at addr ffffc90005101fc0 by task syz.0.17/6108

Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 fb_write_offset drivers/video/fbdev/core/sysmem.h:30 [inline]
 fb_bitmap_2ppw drivers/video/fbdev/core/fb_imageblit.h:364 [inline]
 fb_bitmap_imageblit drivers/video/fbdev/core/fb_imageblit.h:462 [inline]
 fb_imageblit drivers/video/fbdev/core/fb_imageblit.h:492 [inline]
 sys_imageblit+0xff5/0x1e40 drivers/video/fbdev/core/sysimgblt.c:24
 drm_fbdev_shmem_defio_imageblit+0x2c/0x110
 drivers/gpu/drm/drm_fbdev_shmem.c:39
 cw_putcs_aligned drivers/video/fbdev/core/fbcon_cw.c:111 [inline]
 cw_putcs+0x1626/0x18e0 drivers/video/fbdev/core/fbcon_cw.c:159
 fbcon_putcs+0x3c5/0x5a0 drivers/video/fbdev/core/fbcon.c:1392
 do_update_region+0x389/0x440 drivers/tty/vt/vt.c:656
 redraw_screen+0xa3d/0x1020 drivers/tty/vt/vt.c:1008
 fbcon_rotate drivers/video/fbdev/core/fbcon.c:230 [inline]
 rotate_store+0x32d/0x500 drivers/video/fbdev/core/fbcon.c:3171
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739

Fixes: eabb03293087 ("fbdev: Refactoring the fbcon packed pixel drawing routines")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+5a40432dfe8f86ee657a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5a40432dfe8f86ee657a
Link: https://syzkaller.appspot.com/ai_job?id=46e0f6f1-3c42-4372-a8ba-1f6573bdc0ae
To: "Helge Deller" <deller@gmx.de>
To: <dri-devel@lists.freedesktop.org>
To: <linux-fbdev@vger.kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Zsolt Kajtar" <soci@c64.rulez.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/video/fbdev/core/fb_copyarea.h b/drivers/video/fbdev/core/fb_copyarea.h
index 53f1d5385..f4fc86a51 100644
--- a/drivers/video/fbdev/core/fb_copyarea.h
+++ b/drivers/video/fbdev/core/fb_copyarea.h
@@ -386,6 +386,16 @@ static inline void fb_copyarea(struct fb_info *p, const struct fb_copyarea *area
 	struct fb_address src = dst;
 	bool rev_copy = (dy > sy) || (dy == sy && area->dx > area->sx);
 
+	if (area->dx >= p->var.xres_virtual ||
+	    area->dy >= p->var.yres_virtual ||
+	    area->sx >= p->var.xres_virtual ||
+	    area->sy >= p->var.yres_virtual ||
+	    area->width > p->var.xres_virtual - area->dx ||
+	    area->height > p->var.yres_virtual - area->dy ||
+	    area->width > p->var.xres_virtual - area->sx ||
+	    area->height > p->var.yres_virtual - area->sy)
+		return;
+
 	if (rev_copy) {
 		dy += height - 1;
 		sy += height - 1;
diff --git a/drivers/video/fbdev/core/fb_fillrect.h b/drivers/video/fbdev/core/fb_fillrect.h
index f366670a5..37f55adb2 100644
--- a/drivers/video/fbdev/core/fb_fillrect.h
+++ b/drivers/video/fbdev/core/fb_fillrect.h
@@ -261,6 +261,12 @@ static inline void fb_fillrect(struct fb_info *p, const struct fb_fillrect *rect
 	struct fb_address dst = fb_address_init(p);
 	struct fb_pattern pattern;
 
+	if (rect->dx >= p->var.xres_virtual ||
+	    rect->dy >= p->var.yres_virtual ||
+	    rect->width > p->var.xres_virtual - rect->dx ||
+	    rect->height > p->var.yres_virtual - rect->dy)
+		return;
+
 	fb_address_forward(&dst, rect->dy * bits_per_line + rect->dx * bpp);
 
 	pattern.pixels = pixel_to_pat(bpp, palette ? palette[rect->color] : rect->color);
diff --git a/drivers/video/fbdev/core/fb_imageblit.h b/drivers/video/fbdev/core/fb_imageblit.h
index 3b2bb4946..5ec17d7b9 100644
--- a/drivers/video/fbdev/core/fb_imageblit.h
+++ b/drivers/video/fbdev/core/fb_imageblit.h
@@ -486,6 +486,12 @@ static inline void fb_imageblit(struct fb_info *p, const struct fb_image *image)
 	struct fb_reverse reverse = fb_reverse_init(p);
 	const u32 *palette = fb_palette(p);
 
+	if (image->dx >= p->var.xres_virtual ||
+	    image->dy >= p->var.yres_virtual ||
+	    image->width > p->var.xres_virtual - image->dx ||
+	    image->height > p->var.yres_virtual - image->dy)
+		return;
+
 	fb_address_forward(&dst, image->dy * bits_per_line + image->dx * bpp);
 
 	if (image->depth == 1)


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
