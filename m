Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793832274;
	b=UMhO0l4wkrvxTUovSCyN+y/OfVBTJX+mi9ZRNm9r/X3MvhH4pdvhz86sl7xKQdcMh8EQ
	 aSXDXJj9v1r4GDfqmMhPVVQDXXggwlfix3xCycnSnOS7CkIFVENEZHgnOBrPgfCSEiRLp
	 9/xHgDx7nGMk0sZbLKLiIxxyd7ttRvXpZVPJRL/fvOtW09B9oXcuaEHHzEGQ6Sl4YafhB
	 bejurUJxr8v++pr0MEKBpUS5/qQiYUbv/oL4FARqaaKHhx7/a1a3O6wM6wrl5ViiwbGSj
	 k6cMGYBCmx1Jw1ZlmB9qFH1JaSi0D2lKMXLee8CZ4WAhgsihpytaVfnd1Y9UW2tNqwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793832274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=5Fz5BYd7ptM/1ttg1YkqyqQljOPjGmnIX6ueQmZSMPA=;
	b=u2LrphjtSnJD9umJQCGTIypqm4gwQKKLW9xJy3uIBiLYP47dC/MDX5L3Rqyt9R5CObkF
	 RL1XyFwDAKtjOdlN62u4K0VC7oTztwjXIurhXS8wX7wgGVWBdZ4F7xwlQ54MICJhhim/v
	 IRIYlgTDg7XcmFkAGt+YoocZGOU6DC4zf1FktrYFBAzi6TTLzKbPEARlkqqDBqH61lXdD
	 rL2f5SKG9xNz3ANZFCxItY/d7APmDsVb5rSp7JSPINcgCQlfK2J0oTNeTIZHDCFBMshap
	 I/7Tck3E9Y1CjxNaHkoSuoF13DRUBLFrVA/Po2HJ7Jpi7iDrLqrtZFYJOqjayrXrZmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUUuzHIn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 62E15606A31B
	for <syzbot@lists.linux.dev>; Wed,  4 Nov 2026 22:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUUuzHIn
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E13621F00A15;
	Wed,  4 Nov 2026 22:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793832274;
	bh=5Fz5BYd7ptM/1ttg1YkqyqQljOPjGmnIX6ueQmZSMPA=;
	h=From:To:Cc:Subject:Date;
	b=UUUuzHInLz6/FNBjnuisZYV9HcHTdBLqYUTUui/QsuWeXyjpy2BOgLa4o6u7SYIkC
	 YNd71J0cFIXd/7F8lSO317v7XJxK7kja6RUg/e2m989etTLNwEGczMvGCM7DX5KTpl
	 aMi6Hu9td9Hx5QaRC7RRMk0cbTeQc02rKN0uW9sSRdjTqPySFPK36tMZ0dYSqgHOHr
	 FN0DyWUeXkgkl/+D4OIveXybFPXJ3Z+99wmr+y5hZrhr8s2QciTWrI9fzoIuxfz80Y
	 IOqGx0F+vPokxpV2YPFfLuHQbA8h+uz09QsKBj6+pBuIAX+rpK4ue6SbHU9Z78KMLG
	 lCmYA74kKAO1g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] iommu: Fix dev_iommu memory leak in iommu_fwspec_init()
Message-ID: <57f56c9f-1822-4606-98fd-ebb96dbf8de8@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  4 Nov 2026 22:44:33 +0000 (UTC)

In iommu_fwspec_init(), dev_iommu_get() is called before allocating the
struct iommu_fwspec. When dev->iommu is NULL (such as during mock device
creation in iommu_mock_device_add()), dev_iommu_get() allocates and assigns
a struct dev_iommu to dev->iommu. If the subsequent allocation fwspec =
kzalloc_flex(*fwspec, ids, 1) fails, iommu_fwspec_init() returns -ENOMEM
without rolling back the newly allocated dev->iommu. In callers like
iommu_mock_device_add(), this failure results in an early exit before
device_add() is invoked, so subsequent cleanup via put_device() does not
trigger bus release notifications and dev->iommu is permanently leaked:

BUG: memory leak
unreferenced object 0xffff8881121d1340 (size 64):
  comm "syz-executor358", pid 6003, jiffies 4294942186
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    dev_iommu_get drivers/iommu/iommu.c:408 [inline]
    iommu_fwspec_init+0xe2/0x1e0 drivers/iommu/iommu.c:3086
    iommu_mock_device_add+0x31/0x110 drivers/iommu/iommu.c:385
    mock_dev_create drivers/iommu/iommufd/selftest.c:1026 [inline]
    iommufd_test_mock_domain drivers/iommu/iommufd/selftest.c:1068 [inline]
    iommufd_test+0x1e1b/0x30f0 drivers/iommu/iommufd/selftest.c:2104
    iommufd_fops_ioctl+0x2e8/0x3c0 drivers/iommu/iommufd/main.c:556
    vfs_ioctl fs/ioctl.c:51 [inline]
    __do_sys_ioctl fs/ioctl.c:597 [inline]
    __se_sys_ioctl+0xbc/0x130 fs/ioctl.c:583
    do_syscall_64+0x126/0x350 arch/x86/entry/syscall_64.c:84
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fix this by reordering the allocations in iommu_fwspec_init() so that
kzalloc_flex() is called before dev_iommu_get(). If allocating fwspec
fails, dev->iommu is left untouched. If dev_iommu_get() fails subsequently,
fwspec is freed with kfree() before returning -ENOMEM.

Fixes: 72acd9df18f1 ("iommu: Move iommu_fwspec to struct dev_iommu")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+fe84fc6a684e0beb86e2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fe84fc6a684e0beb86e2
Link: https://syzkaller.appspot.com/ai_job?id=54355447-b374-414a-9297-218fdbc7e977
To: <iommu@lists.linux.dev>
To: "Joerg Roedel (AMD)" <joro@8bytes.org>
To: "Will Deacon" <will@kernel.org>
To: "Joerg Roedel" <jroedel@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Robin Murphy" <robin.murphy@arm.com>

---
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b486b8bbd..8da858154 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3083,14 +3083,16 @@ int iommu_fwspec_init(struct device *dev, struct fwnode_handle *iommu_fwnode)
 	if (fwspec)
 		return iommu->ops == iommu_fwspec_ops(fwspec) ? 0 : -EINVAL;
 
-	if (!dev_iommu_get(dev))
-		return -ENOMEM;
-
 	/* Preallocate for the overwhelmingly common case of 1 ID */
 	fwspec = kzalloc_flex(*fwspec, ids, 1);
 	if (!fwspec)
 		return -ENOMEM;
 
+	if (!dev_iommu_get(dev)) {
+		kfree(fwspec);
+		return -ENOMEM;
+	}
+
 	fwnode_handle_get(iommu_fwnode);
 	fwspec->iommu_fwnode = iommu_fwnode;
 	dev_iommu_fwspec_set(dev, fwspec);


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
