Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B543309DDF
	for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 11:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762773371; cv=none; b=TZ8KAp5VWHWeLAUtAWE45iZEtiK+SdDlDWVKYLilNV3USbEcKVsj68WdvVcQMokBMzN8hOS6Z0D/qY58bASEDFdpRMn4sbvCEGHU6gzuyF9bkbh7cGW8xU/wHBpEohEjUvupfVN/3N4ZmP8gvVcPTuAgi4vAOY9DMsjMf+4PVkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762773371; c=relaxed/simple;
	bh=ceymkfrnA3MJEC9817EDAGtXIqp3D3ouo3FE26VPORM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rLv9b4XcyIWp3ACKVgdtA6s5JndzOhTkEOQi1FHLV3TxClrDpjWTh4ygur1S0siU4SO/A0X1dQZLuwp0d1d5YynaqxkwEoVnq3xHyCMD+iZ+RQ6EzpBf1THH4RnH6m9vr605hgfKtGFy7QTLMowzZK+/UiNGq+gG+wMoc124ddQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34361025290so1807412a91.1
        for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 03:16:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762773368; x=1763378168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oRSXEGDPXpNtVK5+kTNlEj4aQG5TyKfDyS+DDaGalzc=;
        b=eJq7r/+vFEIKMs+NCeFXsH2NJwgKEyGtFSHTna552WgI97kI1KHfNaAuXaYuYW2pcW
         8M0jGYbDP42JbwCMxWH8GFPXqxp9L9mfvw9S3b2yXAcjogcCQZGxm/kG+n9vgZjx/L76
         vd0YkDFGhqw+AuXAk+aEpxHrqJqjB8Al+Ydpv0WsqHX+9GRRy/affKL8l7wriZXYejPr
         Vv/Ms3H/hjSkS2lqkT8sGQUfJU1IczAS1UgwBY/NgQ0PHN3zVlcphtJTUdBCsAKwzLGn
         Ps/XyWS755tQtTseZ6Efwu+3tt4O6vehBWAI4y6U90Af4AEqDRPVEXJmP+oM0JIS1g0L
         /9cg==
X-Forwarded-Encrypted: i=1; AJvYcCXvcFdIJU3fbH2d3bAFGouiwzNFl4yLfWvhX/VRbu3CvLN9LyNO5kOW1Uw9e7/03559f/oe7Bs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4XCBlc+3JwGrmI23TuvYa5bTC0cs4uFVG1qQb1xE4mE/eW2d1
	ZoIzKi5UFP0VO0ayVTqLso+/nt0jakTvGF8d40b71TIo8KTKGaYeLnDf
X-Gm-Gg: ASbGncseiy9U7P6XwEALhXldHqwjCphFngvgZfOdeY1gqs3stHoVwwrKhu8HM32wd7o
	qzLLtjI8dk17yqqHNn3OtkL5ppNsLW4jBcCuEomo3Bs8eXB3urnM9i4ivDqr8MZGo+LsjzrYRPv
	OhiJnRohubDKXvQ+XSVu8co9637/GnMzyYrpZmxWvQrrcLUVN/b2aNUy+WgRGRzBcKRAQfnHDDc
	IhldDRNtOPdIx4zIMTMlsaApy5Oj0e0HdoMKYZR08nmyeBlxF4sF4fkTFZ+lXzsXY46s/8KHWxQ
	3k8x6i3bpSeWn/E29f6KtJYhBKvXiRRwObacGl7ptLp7x2pAP7DjSZDDlQ0imVTGqzvRiP0FF9s
	m9wg1UYhqy2FwQDla2CTKLl6p9XlwHdZgEMh/0wONaXTYBhN75FF8YD3SOf8GwU6MTopvFqwvp2
	Wp1RfPE0w=
X-Google-Smtp-Source: AGHT+IFmx5F0C1FFfC1T3kTAEofW5SYHF07alyTgfqPESgG9ejsnGcr8FXW/IACqi7z7O6oK12Ycjg==
X-Received: by 2002:a17:90b:1f8e:b0:33e:2934:6e11 with SMTP id 98e67ed59e1d1-3436cb898dcmr10302982a91.11.1762773367674;
        Mon, 10 Nov 2025 03:16:07 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([2403:2c80:17::10:4006])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bad33c801d1sm8989478a12.7.2025.11.10.03.16.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Nov 2025 03:16:06 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com,
	syzbot+ci5a676d3d210999ee@syzkaller.appspotmail.com,
	david@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	syzkaller-bugs@googlegroups.com,
	syzbot@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA unmap paths
Date: Mon, 10 Nov 2025 19:15:53 +0800
Message-ID: <20251110111553.88384-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lance Yang <lance.yang@linux.dev>

The hugetlb VMA unmap path contains several potential deadlocks, as
reported by syzbot. These deadlocks occur in __hugetlb_zap_begin(),
move_hugetlb_page_tables(), and the retry path of
hugetlb_unmap_file_folio() (affecting remove_inode_hugepages() and
unmap_vmas()), where vma_lock is acquired before i_mmap_lock. This lock
ordering conflicts with other paths like hugetlb_fault(), which establish
the correct dependency as i_mmap_lock -> vma_lock.

Possible unsafe locking scenario:

CPU0                                 CPU1
----                                 ----
lock(&vma_lock->rw_sema);
                                     lock(&i_mmap_lock);
                                     lock(&vma_lock->rw_sema);
lock(&i_mmap_lock);

Resolve the circular dependencies reported by syzbot across multiple call
chains by reordering the locks in all conflicting paths to consistently
follow the established i_mmap_lock -> vma_lock order.

Reported-by: syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/69113a97.a70a0220.22f260.00ca.GAE@google.com/
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
V1 -> V2:
  - Update changelog
  - Resolve three related deadlock scenarios reported by syzbot
    https://lore.kernel.org/linux-mm/6911ad38.a70a0220.22f260.00dc.GAE@google.com/
  - https://lore.kernel.org/linux-mm/20251110051421.29436-1-lance.yang@linux.dev/

 fs/hugetlbfs/inode.c | 2 +-
 mm/hugetlb.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3919fca56553..d1b0b5346728 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -447,8 +447,8 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 		 * a reference.  We must 'open code' vma locking as we do
 		 * not know if vma_lock is still attached to vma.
 		 */
-		down_write(&vma_lock->rw_sema);
 		i_mmap_lock_write(mapping);
+		down_write(&vma_lock->rw_sema);
 
 		vma = vma_lock->vma;
 		if (!vma) {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b1f47b87ae65..f0212d2579f6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5110,8 +5110,8 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_start(&range);
 	last_addr_mask = hugetlb_mask_last_page(h);
 	/* Prevent race with file truncation */
-	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
+	hugetlb_vma_lock_write(vma);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
@@ -5327,9 +5327,9 @@ void __hugetlb_zap_begin(struct vm_area_struct *vma,
 		return;
 
 	adjust_range_if_pmd_sharing_possible(vma, start, end);
-	hugetlb_vma_lock_write(vma);
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
+	hugetlb_vma_lock_write(vma);
 }
 
 void __hugetlb_zap_end(struct vm_area_struct *vma,
-- 
2.49.0

