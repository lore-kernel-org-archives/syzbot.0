Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793985809;
	b=mSGesLZBnMJbd6f5AJNbhkkoLjg5aJwqBwaKcxkPLfm6PxArKbH3sPyUoS/5DXrC6vPN
	 d6aW5Qi2wB3hkF13xZkBhrCA9TeYH4VPz6Efvfp52LIcFNYk/K09qEu6gkph4+DdhWFG3
	 7V2EsBpTIunlQn5qeOLWzYMDQWwK9Ljpy1SY6jCH21N3A7qG0qz7T/HaITe719pjDOueN
	 V8WoKXtIVc46Pg+BDUCUZ7iLtHqLMIVptR1nTVsRJl6c96hLzDLnHMc8qah3qR3wt9JtU
	 RvKLnHc8r47ffiUse+4md5s/XrTrhQV2rW2ITu78lIX7SxBV/AKEv42Tu9FnX5CjDew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793985809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=v3nLpNI7mKb1gW/hYGpvqcUqV/MxhDw44L2GTtvVy68=;
	b=EZvlqySMCmCbA5RXSzFqAH+0AATmlM6sIyjIkteH2hs1Z1pzAprKOjMy+MqhaaYH0g4x
	 EnVYCUC50NzyArWt77aFzAwaEigHAWhjfS6SkR9ksoCnFPx+cDa/aCzZ/kvnIRlOb9NK5
	 e4638uSlN8VLN8uZFjOlZ5CXnj2A7jUnvEjDUuHRAZF2GyMTBXvHXl3QjYpnCJkCEweLc
	 ZKHGWGaWC6KrOUt9MXTIc9v7cQhRJ2IUyyo+4qYMgPDlYhah73OBzMW33m/eBWiaQO5s8
	 RFZ+N2pnu+4A4PBhxWC6CE9CCLbKFJbErW7mHz0Siv63LjWylJt302i/UTQBQzOKlZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aknGGOFJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2559E606A32C
	for <syzbot@lists.linux.dev>; Fri,  6 Nov 2026 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aknGGOFJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A20F81F0089F;
	Fri,  6 Nov 2026 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793985808;
	bh=v3nLpNI7mKb1gW/hYGpvqcUqV/MxhDw44L2GTtvVy68=;
	h=From:To:Cc:Subject:Date;
	b=aknGGOFJiDdVOnd61RicwsDcX+gBhx3ojVPuNRvgkJoXemUaubDylD5dMqPzfgbor
	 /sz5Wmnw5zL2E4Rp/GQ4lAoSjF1GteMqsZvrrDY4stLLyt6FBLD94yoZmMUBQRforF
	 9oSscyygVko3ejVHhP5XiQq2jqM0akV0xIbqTnqavGB5Rw6ej0aQNcN8nx9+awKvuo
	 x1HPtjDqxQ7/Ec05DJ0zfVeVYjFRhnMJNXRHqbo1sS+EkTKRmRp4gdBaDcxsHxQ52R
	 P+M5kUntHEaOQRmZqpL4gezOiEYL3sCgg0o4t4CaCx7iaUbtFO9GbPWA7hdKUscoI0
	 FlgfPQVg8uaLA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] iommu: Fix dev_iommu memory leak in iommu_mock_device_add()
Message-ID: <02910c7b-2c00-42ce-b14e-eebae17b6067@mail.kernel.org>
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
Date: Fri,  6 Nov 2026 17:23:28 +0000 (UTC)

In iommu_mock_device_add(), iommu_fwspec_init() allocates dev->iommu via
dev_iommu_get(). If an error occurs before device_add() is invoked, the
function returns early without freeing dev->iommu. Because device_add() was
never called on the mock device, subsequent cleanup via put_device() does
not trigger bus release notifications, and dev->iommu is permanently
leaked:

  dev_iommu_get drivers/iommu/iommu.c:408 [inline]
  iommu_fwspec_init+0xe2/0x1e0 drivers/iommu/iommu.c:3086
  iommu_mock_device_add+0x31/0x110 drivers/iommu/iommu.c:385

Fix this by jumping to the error cleanup path on failure in
iommu_mock_device_add(), ensuring dev_iommu_free() is called if dev->iommu
is set.

Fixes: 2a918911ed3d ("iommufd: Register iommufd mock devices with fwspec")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+fe84fc6a684e0beb86e2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fe84fc6a684e0beb86e2
Link: https://syzkaller.appspot.com/ai_job?id=6848de3a-be64-4f80-b509-bec63672a688
To: <iommu@lists.linux.dev>
To: "Joerg Roedel (AMD)" <joro@8bytes.org>
To: "Will Deacon" <will@kernel.org>
To: "Guixin Liu" <kanie@linux.alibaba.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Robin Murphy" <robin.murphy@arm.com>

---
v2:
- Free dev->iommu on early error in iommu_mock_device_add() instead of modifying iommu_fwspec_init()
- Update the commit message to explain the leak on early return and trim the kmemleak report

v1:
https://lore.kernel.org/all/57f56c9f-1822-4606-98fd-ebb96dbf8de8@mail.kernel.org/T/
---
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b486b8bbd..47b684497 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -386,10 +386,16 @@ int iommu_mock_device_add(struct device *dev, struct iommu_device *iommu)
 	mutex_unlock(&iommu_probe_device_lock);
 
 	if (rc)
-		return rc;
+		goto err_free;
 
 	rc = device_add(dev);
 	if (rc)
+		goto err_free;
+
+	return 0;
+
+err_free:
+	if (dev->iommu)
 		dev_iommu_free(dev);
 	return rc;
 }


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
