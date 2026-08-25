Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3EA401494
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 12:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787659678; cv=none; b=uXobrpcu6CIiuxcAvrfGjGfSshnDWEsnNi3d8jJ5KHt25xZet8oz6tFoVJ9oHy5BIsnvSHxUPnMD5ahauYNAxZOlavpssVcAvs6ddYIkF3vk8v18VDj4hDsuexZ59bGS1oHN2AVz4AkcAJUVoDRns01aWEiEFRswkR5ywWFZts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787659678; c=relaxed/simple;
	bh=6XYYwrw5I4/VJMBNXqCDxibwYzR9UjgLa3qxbfPXvEA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DRjXPhdc+09PKsNo0Cua2F6iAb9Km0TwV9wnXIsmwkfZvBmogevPhnHke+qvNPH3O9Gvtu4u7PAF24W+yJept3LyAtTL7HqwoZvk7Y3UNPJGM//EehcO6gZB5YA702w2hW3IvtZ1vAdHDhnPWL/l/1Sg44aBIV2GqnIxhq2oO5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=ouInsyUQ; arc=none smtp.client-ip=217.74.67.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="ouInsyUQ"
Received: from localhost (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue, 25 Aug 2026 14:07:45 +0200 (CEST)
From: Slawomir Stepien <sst@poczta.fm>
To: syzkaller-bugs@googlegroups.com,
	sst@poczta.fm,
	airlied@gmail.com,
	airlied@redhat.com,
	dri-devel@lists.freedesktop.org,
	kraxel@redhat.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	simona@ffwll.ch,
	tzimmermann@suse.de,
	virtualization@lists.linux.dev
Cc: jani.nikula@intel.com,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	syzbot+2442951a6abb004df963@syzkaller.appspotmail.com
Subject: [PATCH v2] drm/cirrus-qemu: Validate BAR0 size during probe
Date: Tue, 25 Aug 2026 14:07:29 +0200
Message-ID: <20260825120729.493611-1-sst@poczta.fm>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1787659667; bh=SOCo4mafwNDw5JOKkR3x/JLutK9fHb/X8EWCgU8SQA8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=ouInsyUQ8NjNoY97pVtVgVjXytaeyhAxNRn7Bb3wxgkaVqKVyIlSMGqa+9UPw575w
	 aiRH5+RyZDYoLK385C/Z+QbNAAlQ3iOhX/SMvW39gG4OMtmb8y1T4BqpgRfTYKI/Sz
	 +c0CsAx3ZDfswGIvRtAnxORYYsgR4FfdPcOy7vcU=

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
is not less than `CIRRUS_VRAM_SIZE`, returning `-ENODEV` if it is less.

Fixes: ab3e023b1b4c ("drm/cirrus: rewrite and modernize driver.")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+2442951a6abb004df963@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2442951a6abb004df963
Link: https://syzkaller.appspot.com/ai_job?id=ba262a3a-bccf-4ad8-a1b0-583c55d34fd6
Signed-off-by: Slawomir Stepien <sst@poczta.fm>
---
v2:
* move the check before aperture_remove_conflicting_pci_devices() as suggested by sashiko.
* check if the pci_resource_len() for BAR0 is less than CIRRUS_VRAM_SIZE as suggested by Thomas. The
  qemu emulates 4, (8 and 16 MB for compatibility) - never less than 4MB.

v1:
* https://lore.kernel.org/all/b11f8965-5896-4119-98b7-6bd0eb9fa139@mail.kernel.org/T/
---
 drivers/gpu/drm/tiny/cirrus-qemu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/tiny/cirrus-qemu.c b/drivers/gpu/drm/tiny/cirrus-qemu.c
index 075221b431d3..3bf23fcf6574 100644
--- a/drivers/gpu/drm/tiny/cirrus-qemu.c
+++ b/drivers/gpu/drm/tiny/cirrus-qemu.c
@@ -582,6 +582,9 @@ static int cirrus_pci_probe(struct pci_dev *pdev,
 	struct cirrus_device *cirrus;
 	int ret;
 
+	if (pci_resource_len(pdev, 0) < CIRRUS_VRAM_SIZE)
+		return -ENODEV;
+
 	ret = aperture_remove_conflicting_pci_devices(pdev, cirrus_driver.name);
 	if (ret)
 		return ret;
-- 
2.55.0

