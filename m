Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB5952F276
	for <syzbot@lists.linux.dev>; Tue, 22 Sep 2026 22:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790117643; cv=none; b=BGyjSp14E4fq4xzWGxaGyEW//8DXqK7ZNe2kFPRHo8wwYOYr62H1rbKPoiw96Fiiuzf3sbOzGMAoU7uZZI+KRYPtje+MI32R9OLDUHyu7tEzT3yp9j5yYfQtQblPJta48ueC9ZpqNjSmd1vos3GY8u3VdE23aPRwjj2DcwtOT9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790117643; c=relaxed/simple;
	bh=pu+0VFsTVVEShC2ATr0Rj6MeeQesu3+HKJtp2LDt9vg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=So92tzSxrMXjDRRmPCiQFIP4N6ApOBh8iAZAFtllHXPKVNEzNBtHtfnavxPMjpN4s7c/vyEOKsNaDY6k5a04WsG6Y+fLuX8aRGwcOFjlw7fVNLnwpjnq6YmTe92MNAyPnwwsJCdXXRpSqNMeSrP915PlCktZVDClc9JI8JsgaRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zd58uXdr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zd58uXdr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CF2251F000FF;
	Tue, 22 Sep 2026 22:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790117638;
	bh=aXaTHzd5tBhRBdMM4TSl8z01IjFGvbYY/dIAB0rwijE=;
	h=From:To:Cc:Subject:Date;
	b=Zd58uXdr0vOXBJU7zWb4MRJI1l07nqSAisZQVVVGQ7CPQUzv8NcODTipMdVkxQZu5
	 YELG3pZPLGVFaLJojmbU4zbybs0Z/4GlPdYr8xRyNHWR7M+99wOMpyiFjYzlWxLhtC
	 6yhhd5hmQDGKI/AvhHUre+Oe/vSin8b+nKNhU6GxY0IUkd840yj565iH090rpy124U
	 udOCN9r0SM5RgQxeMeoOBvkUOg/bP9gSI0egbJ/5zbYp2RK1KpgBUlBxyKyVtH2tjJ
	 RZSCvC4mUQyDiUlrda6Cq0g03o6Yi8F1jQOBV1MhLwAxvYk9xcdIxU1++0bpA9sber
	 52/AvmxzG3mtQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: vivid: reject binding to foreign platform devices
Message-ID: <5d9741ff-fba2-4cc7-aafd-3e89d95a6884@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 22 Sep 2026 22:53:58 +0000 (UTC)

The vivid driver is designed as a virtual test driver that instantiates and
manages its own static platform device, vivid_pdev. It maintains global
state across device instances, including the global vivid_devs array and
n_devs counter.

However, userspace can bind arbitrary platform devices to the vivid
platform driver via sysfs using driver_override and bind. When a foreign
platform device is bound to the driver, vivid_probe() runs again for that
device and overwrites entries in the global vivid_devs array. If an unbind
is performed concurrently on one of the devices, vivid_remove() cleans up
the instance and sets the corresponding vivid_devs entry to NULL. When
vivid_probe() continues its execution to configure menu controls, it
accesses vivid_devs[i]->has_vid_out, dereferencing the NULL pointer and
triggering a general protection fault:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000be7: 0000 [#1] SMP KASAN NOPTI
KASAN: probably user-memory-access in range
[0x0000000000005f38-0x0000000000005f3f]
RIP: 0010:vivid_probe+0x6421/0x70c0
drivers/media/test-drivers/vivid/vivid-core.c:2119
Call Trace:
 <TASK>
 platform_probe+0xf9/0x190 drivers/base/platform.c:1507
 really_probe+0x254/0xae0 drivers/base/dd.c:706
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
 device_driver_attach+0xe0/0x1d0 drivers/base/dd.c:1203
 bind_store+0x1d0/0x220 drivers/base/bus.c:267
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fix this by moving vivid_pdev and vivid_pdev_release() above vivid_probe(),
and checking whether the probed platform device is vivid_pdev at the
beginning of vivid_probe(). If it is not, return -ENODEV to reject the
probe attempt and prevent binding to unintended devices.

Fixes: f46d740fb025 ("[media] vivid: turn this into a platform_device")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+caaca441bae2799984d3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=caaca441bae2799984d3
Link: https://syzkaller.appspot.com/ai_job?id=4b91af24-1dbf-4056-9c38-21b8f3a7585f
To: "Hans Verkuil" <hverkuil@kernel.org>
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Hans Verkuil" <hans.verkuil@cisco.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index 62cfb5feb..c108af6b9 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -2071,6 +2071,15 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	return ret;
 }
 
+static void vivid_pdev_release(struct device *dev)
+{
+}
+
+static struct platform_device vivid_pdev = {
+	.name		= "vivid",
+	.dev.release	= vivid_pdev_release,
+};
+
 /* This routine allocates from 1 to n_devs virtual drivers.
 
    The real maximum number of virtual drivers will depend on how many drivers
@@ -2079,9 +2088,13 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
  */
 static int vivid_probe(struct platform_device *pdev)
 {
-	const struct font_desc *font = find_font("VGA8x16");
+	const struct font_desc *font;
 	int ret = 0, i;
 
+	if (pdev != &vivid_pdev)
+		return -ENODEV;
+
+	font = find_font("VGA8x16");
 	if (font == NULL) {
 		pr_err("vivid: could not find font\n");
 		return -ENODEV;
@@ -2226,15 +2239,6 @@ static void vivid_remove(struct platform_device *pdev)
 	}
 }
 
-static void vivid_pdev_release(struct device *dev)
-{
-}
-
-static struct platform_device vivid_pdev = {
-	.name		= "vivid",
-	.dev.release	= vivid_pdev_release,
-};
-
 static struct platform_driver vivid_pdrv = {
 	.probe		= vivid_probe,
 	.remove		= vivid_remove,


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
