Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A4E35AC00;
	Tue, 25 Aug 2026 07:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643374; cv=none; b=BFjAewbq5n4pM57ypZz9KW5memnNNBebOVLcbbNc7WvjIC+m5v3oqA2L2psXXzpjFlrQTqbCTye1F5dgSAK/8xl6jo1p6Z7HY097W3SZwRjtyEWMlGsF29CC3DEX7LQnTnwZeLSunHoQWc8UJHES/nljvsAXUY9IwsBfdbO5CHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643374; c=relaxed/simple;
	bh=NuVNzdcKYmjOrNH/56kv+1PZFsaRb8w1TmOct1QPtYs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ijBLIuWb4rrFzJuNEG8QCspyTxuptkK1P2C0efeUnbkigsI7SsbJIDgcgcLSPcRB8ejDNrZa5QcFdOfBFbivJz88OGB/91S6xsHjt9Ji+ulG3eImU6cUgXl5VgkLkdq8GjvKAeW1cSuSUHqYYAgeiVPI+/PXp79G1n7CyLIskl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QirhcMGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QirhcMGi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 428D81F000E9;
	Tue, 25 Aug 2026 07:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787643372;
	bh=epJ5FHpWt7Wp8xRAAUYzuBydWavuFMODafsLE/Yalh4=;
	h=From:To:Cc:Subject:Date;
	b=QirhcMGiw4UtOye4lJJTl8L9ZWpb5MyN5CQiIkbIYwU7mcbfuzIM3xiT4SY2UfKsR
	 dMftTrAtVHkx2EhsIG/uyArika0FeiOleqO4qvA3t5V6o7xOiGyAXj0hTD8GqF9uh4
	 zdlgS6HRu5+9cimTzomgxvJUVEUOzP0gEhEmKbvHkEZMiZN+swiQBpG5EC+xB0XbzR
	 J6LYKnSXOhjFs9RKarnxZVixAbbuz7mMIF3sHE3fj0aExLYzFGPK3l7DboBGdVk4bs
	 GCLxYthxhUA/ziFY/UbihbEP1e53TZljIe/Ma6G3A1d24hVqA3QyIEuVuXXDNGWKqG
	 Lae4LUys1mkFg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>, "David Airlie" <airlied@gmail.com>, "Dave Airlie" <airlied@redhat.com>, <dri-devel@lists.freedesktop.org>, "Gerd Hoffmann" <kraxel@redhat.com>, "Maarten Lankhorst" <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>, "Simona Vetter" <simona@ffwll.ch>, "Thomas Zimmermann" <tzimmermann@suse.de>, <virtualization@lists.linux.dev>
Cc: jani.nikula@intel.com, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] drm/cirrus-qemu: Validate BAR0 size during probe
Message-ID: <b11f8965-5896-4119-98b7-6bd0eb9fa139@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 25 Aug 2026 07:36:12 +0000 (UTC)

From: Slawomir Stepien <sst@poczta.fm>

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
Signed-off-by: Slawomir Stepien <sst@poczta.fm>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
