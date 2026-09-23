Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C473EFFA9
	for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 20:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790194137; cv=none; b=KGovIOXWPrkdPzLLxueJGnSzyWZsNEQCGSFoOIoxn713MnnrDZrRhUpS02+oo/QIJAKjNgRavqpnHhG7OBHCUSEbJeaarOWJ1ascD89jfBtLgCIBHznB+OEPbYz7P7Wgtl7XHhRQVxtHb15PQZg42evFnFuogVCCdv/Bf30R5Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790194137; c=relaxed/simple;
	bh=05/ewmglut3dJtPOb+/JKharCE2L24JiSB3ICvLne6A=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=HYd69zBe0AwVAeAqknOdecbNk4DZM5381YEuvIhvzR44TIr9ewPMns2li7y0Ara0eXHnPVul/D9XpEEltKObgZzQCjv7l4QX+6Vve1kCrSQd+UEbCvtg2Bsh8UtfBVb9TSqsjp2EGPVQ3V/UOIJ9VZsKxMhUZVqxE/+NbOIpkQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+ByGm04; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+ByGm04"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A2A061F000FF;
	Wed, 23 Sep 2026 20:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790194132;
	bh=8+zJJjZkJZm6cu5KXT3pia+Z3hpAN6aAHIvESKG55SE=;
	h=From:To:Cc:Subject:Date;
	b=N+ByGm049q4KA31Q/OC+ZsCXFpJ6yBa/Slx5UhK6M45+irx0oVbHieoJ19Bc7S6kL
	 kbO2T+80D2DQZoye4EBohlWNdm588xIWlXCx7jHjgKa7jGMgYQzkOteAdHqMXFJ2xn
	 N8UUWIBS8LOi+WYd1G9Ghh+bb/5vLpAAGeR8lh+pn6cbJWuPKjs/ZDLc9NJ4+VZz6/
	 ynYOPt9dei95Hwj+5kAJM224OvYafAntYm/D+OdU1iLU/vn3pVYt+ey3EC3aaxehtQ
	 /MkRFdgKUim/T+E9mtH4v7Tt4TZpYz+40Qf3ya9GjzXR/4Hvxen1o10FeCyLKO6OfI
	 Qvdp4ABqDG9Bw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] udmabuf: use __GFP_NOWARN for page and folio array allocations
Message-ID: <c326ba91-aa20-4792-9fc3-776c2183f4e4@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 23 Sep 2026 20:08:52 +0000 (UTC)

In udmabuf, the module parameter size_limit_mb defaults to INT_MAX. When
creating a udmabuf via the UDMABUF_CREATE or UDMABUF_CREATE_LIST ioctl, the
page limit pglimit is calculated from this parameter, allowing buffer sizes
that require billions of pages. If userspace requests an excessively large
buffer such that the tracking array size (pgcnt * sizeof(struct page *))
exceeds INT_MAX, init_udmabuf() and udmabuf_create() attempt to allocate
the tracking arrays (ubuf->pages, ubuf->pinned_folios, and folios) using
kvmalloc_objs().

Because kvmalloc_objs() uses GFP_KERNEL without __GFP_NOWARN,
__kvmalloc_node_noprof() detects that the requested allocation size exceeds
INT_MAX and triggers a kernel warning:

 WARNING: mm/slub.c:7022 at __kvmalloc_node_noprof+0x798/0x820
 Call Trace:
  <TASK>
  init_udmabuf drivers/dma-buf/udmabuf.c:193 [inline]
  udmabuf_create+0x2dc/0xf50 drivers/dma-buf/udmabuf.c:386
  udmabuf_ioctl_create drivers/dma-buf/udmabuf.c:465 [inline]
  udmabuf_ioctl+0x1f3/0x300 drivers/dma-buf/udmabuf.c:496
  __do_compat_sys_ioctl fs/ioctl.c:695 [inline]
  __se_compat_sys_ioctl fs/ioctl.c:638 [inline]
  __ia32_compat_sys_ioctl+0x5ea/0x950 fs/ioctl.c:638
  do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
  __do_fast_syscall_32+0x27a/0x6a0 arch/x86/entry/syscall_32.c:291
  do_fast_syscall_32+0x33/0x70 arch/x86/entry/syscall_32.c:316
  entry_SYSENTER_compat_after_hwframe+0x84/0x8e
  </TASK>

Since the allocation size is directly derived from userspace input,
oversized allocation requests can legitimately occur. Suppress the warning
by passing GFP_KERNEL | __GFP_NOWARN to kvmalloc_objs() for ubuf->pages,
ubuf->pinned_folios, and folios. This allows kvmalloc() to gracefully
return NULL when an oversized allocation is requested, which udmabuf
already properly handles by returning -ENOMEM.

Fixes: 44e9eb5a7621 ("dma-buf/udmabuf: Disable the size limit by default")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+bfeed181d1ce9ec87a8f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bfeed181d1ce9ec87a8f
Link: https://syzkaller.appspot.com/ai_job?id=125a628a-1b8a-4e38-9df0-56f407c0031f
To: =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
To: <dri-devel@lists.freedesktop.org>
To: "Gerd Hoffmann" <kraxel@redhat.com>
To: <linaro-mm-sig@lists.linaro.org>
To: <linux-media@vger.kernel.org>
To: "Sumit Semwal" <sumit.semwal@linaro.org>
To: "Vivek Kasireddy" <vivek.kasireddy@intel.com>
To: "Robert Mader" <robert.mader@collabora.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index df6dd0046..d905ed407 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -190,11 +190,11 @@ static void unpin_all_folios(struct udmabuf *ubuf)
 
 static __always_inline int init_udmabuf(struct udmabuf *ubuf, pgoff_t pgcnt)
 {
-	ubuf->pages = kvmalloc_objs(*ubuf->pages, pgcnt);
+	ubuf->pages = kvmalloc_objs(*ubuf->pages, pgcnt, GFP_KERNEL | __GFP_NOWARN);
 	if (!ubuf->pages)
 		return -ENOMEM;
 
-	ubuf->pinned_folios = kvmalloc_objs(*ubuf->pinned_folios, pgcnt);
+	ubuf->pinned_folios = kvmalloc_objs(*ubuf->pinned_folios, pgcnt, GFP_KERNEL | __GFP_NOWARN);
 	if (!ubuf->pinned_folios)
 		return -ENOMEM;
 
@@ -387,7 +387,7 @@ static long udmabuf_create(struct miscdevice *device,
 	if (ret)
 		goto err;
 
-	folios = kvmalloc_objs(*folios, max_nr_folios);
+	folios = kvmalloc_objs(*folios, max_nr_folios, GFP_KERNEL | __GFP_NOWARN);
 	if (!folios) {
 		ret = -ENOMEM;
 		goto err;


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
