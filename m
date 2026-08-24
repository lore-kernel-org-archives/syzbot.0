Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8D241D640
	for <syzbot@lists.linux.dev>; Mon, 24 Aug 2026 13:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787577127; cv=none; b=VOhPDvd7W/HWiEVCt5N2BZRBIDPtsQ0VJt26hGnUuh1UVUnJODu/GRg+mZN5FiwRvxLFRIIG0aj/lwsBhku5QEvARpE1Hv/3wfGGGfcjMZkx+QjchC8MtjDnezmAEqfzuZOPBqPur3dKULJAABtvZfx9f2TI61BMOqdjmPL0/hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787577127; c=relaxed/simple;
	bh=0pI04r9RWK9ZhO4UcWbMMotb9KnpCOPF8Ttxo3Lm+2s=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=iUBaOHdBWGCOP9nXe24b9l7EZ5VHcYH6dR9ZErRGYf94pGTDaAjVWp5yAFU6C3teH11mxma+4rXPCa2LQhGePP0290+KA5ZsZjyJvJynRlX2LgF11irF9OgYl4iQORub9mmJET0t2J0rnlJxfCbqcrVc6wJUv5WsmNARjAzct/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OoVz5CwV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OoVz5CwV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D9A2B1F000E9;
	Mon, 24 Aug 2026 13:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787577126;
	bh=K5xZnW9CHZrkUNytRb5ALtMaheWxIzor2o49rx+noQ0=;
	h=From:To:Cc:Subject:Date;
	b=OoVz5CwVaGOIjoQnX0K0WaX0PjStVuqHDFVqFt0vCejxWtfbE0fy7H1QWqbZHLzgJ
	 hqV/D75TT08Po5V1YGn8FGeGAFi7oPpSg106Fyk3BVH4QdWd0vRpUOd2uoXKgAcE/e
	 kbMGsnd80uSqXRprN2gjRXrfjB7iBMe8n3xp7SmiJlLWH0m0ZopiW2PPLzJ2U4OWrt
	 bswy3snIY8XrKSE2fX2qETGkhDHLken4/gHht1HERaACKoPf/jEErVgSOrICmVibrA
	 W9aMINaWjS8li/yIFltfk4dHhgEZz0uK4g/WZb3q9jzcHfauAMWNoEVXQOTNenXvig
	 B/cAiyacam6KQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] drm/cirrus-qemu: Validate BAR0 size during probe
Message-ID: <6e3c9a45-9c40-4717-9474-7abd0880ad79@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 24 Aug 2026 13:12:05 +0000 (UTC)

The `cirrus-qemu` driver relies on `CIRRUS_VRAM_SIZE` (4 MB) to validate
framebuffer sizes. However, during PCI probe, the driver mapped BAR0
without verifying that its size matches `CIRRUS_VRAM_SIZE`.

If a PCI device with a BAR0 smaller than 4 MB is bound to the driver, the
mapped VRAM will be smaller than expected. Because validation checks assume
4 MB VRAM, framebuffers larger than the mapped memory can be created.

When the display plane is updated (e.g. during release),
`cirrus_primary_plane_helper_atomic_update()` copies the framebuffer to
VRAM using `drm_fb_memcpy()`. Writing past the end of the mapped I/O memory
causes a supervisor write page fault:

BUG: unable to handle page fault for address: ffffc9000389c000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
...
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

Fix this by validating in `cirrus_pci_probe()` that the PCI BAR0 resource
length equals `CIRRUS_VRAM_SIZE`, returning `-ENODEV` if it does not match.

Fixes: ab3e023b1b4c ("drm/cirrus: rewrite and modernize driver.")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+2442951a6abb004df963@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2442951a6abb004df963
Link: https://syzkaller.appspot.com/ai_job?id=ba262a3a-bccf-4ad8-a1b0-583c55d34fd6
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

---
v2:
- Reject device in probe if PCI BAR0 resource length does not equal CIRRUS_VRAM_SIZE instead of dynamically tracking VRAM size.
- Retain CIRRUS_VRAM_SIZE and keep atomic check and mode validation hooks unchanged.

v1:
https://lore.kernel.org/all/6e0e7e49-c50d-472e-9cc2-ceaf814e0fc7@mail.kernel.org/T/
---
diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
index 075221b43..70c995025 100644
--- a/drivers/gpu/drm/tiny/cirrus-qemu.c
+++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
@@ -602,6 +602,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
 
 	dev = &cirrus->dev;
 
+	if (pci_resource_len(pdev, 0) != CIRRUS_VRAM_SIZE)
+		return -ENODEV;
+
 	cirrus->vram = devm_ioremap(&pdev->dev, pci_resource_start(pdev, 0),
 				    pci_resource_len(pdev, 0));
 	if (cirrus->vram == NULL)


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
