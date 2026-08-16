Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048893939A6
	for <syzbot@lists.linux.dev>; Sun, 16 Aug 2026 23:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786923757; cv=none; b=Q1ORCCMfhd9vhB7iYsDEC6134+7D8/oTb4IuniRXzvBe6qqa8648B3v1mqe9TRfb/NHXi48uTQEOusvcH9mCI0VGISJIY5JmCc+m1YCPcOFPPfykbAowCOJjX0Utu7k4WIUk+TsT8dwhDS84jlMhP8fYmi7i0SUmlPoTYlvGYpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786923757; c=relaxed/simple;
	bh=SJM6A67LC1n7d950lWoDa+Vs1jn0Z4k12BhD04CFcLM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=W5FX57+soGfivtzrh5GKEmM+TWwKjyDDgyPEOjx2waNXVPYAbcb29c3ag+HsP0xazfa0K5mCjFj7mIe8Dfv+ROol0qVUbrpWxlMOmNX0T+epLrBtxNI/T7Mn3vyzUqS8ZNj/YdgO7gOtc2GEHeYOUsy+kKLQx0fHZ53ZgwQv7/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buIQyaBf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buIQyaBf"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 728C81F000E9;
	Sun, 16 Aug 2026 23:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786923755;
	bh=W81uNy1k443RhA0Je1vgK8VEt0SsNalvoex/Uv0YCfw=;
	h=From:To:Cc:Subject:Date;
	b=buIQyaBfldmosZuVtLAsWn3sBw6wIItiXyN6sgfixwkh9wrBW5SqfMdQQIMyZNSv8
	 QOSEUJgpDvD24eMEkPLCNQ1pRRAyyWZULyLnlBephUucjUxPhz4/CHoVr3n9ZHbuaY
	 cFNE6xqsez/7u5zBHClCyfMno1YrPb64uJ2olZ9iZBnil/Wu4gtAEWNn8LryY4X5c3
	 mUMbt96fJABQc1f5a2KlJoKpSUpsyPGRUMhFbqZ05hvqYw0QUtDfqRvp/1tNxE3Fke
	 vprOOMr9nyiXLRl1VW3M6+GYCq6jsRiFJzjQmflZk/46uH5XpxppCT+6W6mSa2xkBU
	 ORBrhcJU2EKPQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] drm/cirrus-qemu: Use actual VRAM size to prevent out-of-bounds write
Message-ID: <6e0e7e49-c50d-472e-9cc2-ceaf814e0fc7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 16 Aug 2026 23:42:35 +0000 (UTC)

The `cirrus-qemu` driver previously relied on a hardcoded constant
`CIRRUS_VRAM_SIZE` (4 MB) to validate framebuffer sizes. However, during
device probe, the driver maps the VRAM using the actual size of the PCI
device's BAR0.

If a privileged user unbinds a random PCI device with a BAR0 smaller than 4
MB and binds the `cirrus-qemu` driver to it, the mapped VRAM will be
smaller than 4 MB. Because the validation checks still used the hardcoded 4
MB size, the driver would allow the creation of a framebuffer larger than
the actually mapped VRAM.

When the DRM device is closed, `drm_release()` triggers a full atomic
commit to restore the fbdev mode. This calls
`cirrus_primary_plane_helper_atomic_update()`, which uses `drm_fb_memcpy()`
to copy the framebuffer into the mapped VRAM. Since the mapped VRAM is
smaller than the framebuffer, `memcpy_toio()` writes past the end of the
mapped I/O memory, resulting in a supervisor write page fault:

BUG: unable to handle page fault for address: ffffc900033dd000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
...
RIP: 0010:rep_movs arch/x86/lib/iomem.c:13 [inline]
RIP: 0010:string_memcpy_toio arch/x86/lib/iomem.c:64 [inline]
RIP: 0010:memcpy_toio+0x7c/0xe0 arch/x86/lib/iomem.c:110
...
Call Trace:
 <TASK>
 iosys_map_memcpy_to include/linux/iosys-map.h:285 [inline]
 drm_fb_memcpy+0x325/0x5d0 drivers/gpu/drm/drm_format_helper.c:442
 cirrus_primary_plane_helper_atomic_update+0x98a/0xb00
 drivers/gpu/drm/tiny/cirrus-qemu.c:358
 drm_atomic_helper_commit_planes+0x626/0xea0
 drivers/gpu/drm/drm_atomic_helper.c:3038
 drm_atomic_helper_commit_tail+0x60/0x510
 drivers/gpu/drm/drm_atomic_helper.c:1989
 commit_tail+0x2b1/0x3c0 drivers/gpu/drm/drm_atomic_helper.c:2074
 drm_atomic_helper_commit+0xa77/0xb10
 drivers/gpu/drm/drm_atomic_helper.c:2312
...

To fix this, remove the hardcoded `CIRRUS_VRAM_SIZE` and dynamically track
the actual VRAM size in `struct cirrus_device`. Initialize this size from
the PCI resource length during probe, ensuring it is non-zero. Update the
validation hooks `cirrus_primary_plane_helper_atomic_check()` and
`cirrus_mode_config_mode_valid()` to use the dynamically tracked VRAM size,
ensuring that framebuffers strictly fit within the mapped memory.

Fixes: ab3e023b1b4c ("drm/cirrus: rewrite and modernize driver.")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+2442951a6abb004df963@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2442951a6abb004df963
Link: https://syzkaller.appspot.com/ai_job?id=0995d2c9-3eea-4945-84e7-ab3d2acd4f21
To: "David Airlie" <airlied@gmail.com>
To: "Dave Airlie" <airlied@redhat.com>
To: <dri-devel@lists.freedesktop.org>
To: "Gerd Hoffmann" <kraxel@redhat.com>
To: "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>
To: "Maxime Ripard" <mripard@kernel.org>
To: "Simona Vetter" <simona@ffwll.ch>
To: "Thomas Zimmermann" <tzimmermann@suse.de>
To: <virtualization@lists.linux.dev>
Cc: "Jani Nikula" <jani.nikula@intel.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Luca Ceresoli" <luca.ceresoli@bootlin.com>

---
diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
index 075221b43..7f8cb3264 100644
--- a/drivers/gpu/drm/tiny/cirrus-qemu.c
+++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
@@ -55,7 +55,6 @@
 #define DRIVER_MINOR 0
 
 #define CIRRUS_MAX_PITCH (0x1FF << 3)      /* (4096 - 1) & ~111b bytes */
-#define CIRRUS_VRAM_SIZE (4 * 1024 * 1024) /* 4 MB */
 
 struct cirrus_device {
 	struct drm_device	       dev;
@@ -68,6 +67,7 @@ struct cirrus_device {
 
 	/* HW resources */
 	void __iomem		       *vram;
+	size_t			       vram_size;
 	void __iomem		       *mmio;
 };
 
@@ -298,6 +298,7 @@ static const uint64_t cirrus_primary_plane_format_modifiers[] = {
 static int cirrus_primary_plane_helper_atomic_check(struct drm_plane *plane,
 						    struct drm_atomic_commit *state)
 {
+	struct cirrus_device *cirrus = to_cirrus(plane->dev);
 	struct drm_plane_state *new_plane_state = drm_atomic_get_new_plane_state(state, plane);
 	struct drm_framebuffer *fb = new_plane_state->fb;
 	struct drm_crtc *new_crtc = new_plane_state->crtc;
@@ -319,7 +320,7 @@ static int cirrus_primary_plane_helper_atomic_check(struct drm_plane *plane,
 	/* validate size constraints */
 	if (fb->pitches[0] > CIRRUS_MAX_PITCH)
 		return -EINVAL;
-	else if (fb->pitches[0] > CIRRUS_VRAM_SIZE / fb->height)
+	else if (fb->pitches[0] > cirrus->vram_size / fb->height)
 		return -EINVAL;
 
 	return 0;
@@ -514,6 +515,7 @@ static int cirrus_pipe_init(struct cirrus_device *cirrus)
 static enum drm_mode_status cirrus_mode_config_mode_valid(struct drm_device *dev,
 							  const struct drm_display_mode *mode)
 {
+	struct cirrus_device *cirrus = to_cirrus(dev);
 	const struct drm_format_info *format = drm_format_info(DRM_FORMAT_XRGB8888);
 	u64 pitch;
 
@@ -525,7 +527,7 @@ static enum drm_mode_status cirrus_mode_config_mode_valid(struct drm_device *dev
 		return MODE_BAD_WIDTH;
 	if (pitch > CIRRUS_MAX_PITCH)
 		return MODE_BAD_WIDTH; /* maximum programmable pitch */
-	if (pitch > CIRRUS_VRAM_SIZE / mode->vdisplay)
+	if (pitch > cirrus->vram_size / mode->vdisplay)
 		return MODE_MEM;
 
 	return MODE_OK;
@@ -602,8 +604,12 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
 
 	dev = &cirrus->dev;
 
+	if (pci_resource_len(pdev, 0) == 0)
+		return -ENODEV;
+
+	cirrus->vram_size = pci_resource_len(pdev, 0);
 	cirrus->vram = devm_ioremap(&pdev->dev, pci_resource_start(pdev, 0),
-				    pci_resource_len(pdev, 0));
+				    cirrus->vram_size);
 	if (cirrus->vram == NULL)
 		return -ENOMEM;
 


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
