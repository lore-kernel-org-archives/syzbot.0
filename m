Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572C1219EB
	for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 08:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769761912; cv=none; b=ObiPPNCba6H6dNaEaIf11rCCmsGX7e61gJXULtzRKFPFT1LWxzH2MJhTEfesRtCAryrNZ4m5khjCcvPwUBsxu3DRdelTFxp0cQESQsboUnrs5EDe+RKXmavT8mYBWvtNRkrKO+uvD9NPP37kZtpMn14qxyno87tWdyRWoVkkRrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769761912; c=relaxed/simple;
	bh=YU7/wkKzuuQCI6bvgdtYKVjSj/E7eIhhueeWD+eXM6c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=fVWiwgPzbFUZRHX3cA+TgKKBQ2bpIMagNnH7CKkPhniHDr34elH9V44akT+gQUGAjF8wGXV1giAX3UEramNis0H54r91LVr1+hmmktM/hIAUd+qa/KPMeQYv6kvl/35g/h5vWkQcb9xhQkY2HcrgH6rVJwviWogOD0kQDfRIQXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6630d586952so2276219eaf.3
        for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 00:31:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769761910; x=1770366710;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KcM/GiMNg1PUtlOyGHg72Bipk65lKR6+3aFwSUFp3i8=;
        b=sHWlxCd/ZznjRiVHpo9tLqsL3bwZvW7fuXzICybiJiA8BLYXfTEvTHE4OzJW0iO0cv
         u6fEhLgrckQPjVsMhsotm2AsZhc292VsK7AVArPoIIvGnxXpgLgQ7LJM5teuyHeBIl0l
         eSTbR2tyRTS10tPDGGxVpJ1uuCr/ppXrrH1W/PnZZ0CEelT/5VTgxsxC9xzpkELGE+C3
         ZFpD9Vx153HZNAcgyCpNLp8xV/UNmXUA4VU8+KoSBDCvoIg3GUwKtyG3I2pbjWMOKn86
         dS9SZp2FRWFeHNaasAs0A4KN7Aq2DDlDotRGBj0FavZNJ72lGbjtWh14LnMbM3SJkWdu
         zXFg==
X-Gm-Message-State: AOJu0YzucvKTumqW/35zkKnpV5wFhMt9GOpTtiVkhjsMcR86av471AqO
	NN/p/ioOeowN+U1NUTVPr4K0/gRh/pny8JEyQcbTlEatNABDikRziwKYW9nLLUHfSOWL87T3T9l
	h65Uz2nUgilkLUmRo8NfTfboKzTjV5BglptuwFPizadUpo2jM+9qSauu44/0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:814:b0:662:f543:5d49 with SMTP id
 006d021491bc7-6630f3d4566mr820510eaf.84.1769761910286; Fri, 30 Jan 2026
 00:31:50 -0800 (PST)
Date: Fri, 30 Jan 2026 00:31:50 -0800
In-Reply-To: <20260130163131090fO6cBknp_D-VbYYkMaKcS@zte.com.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697c6c76.a00a0220.35f26.0013.GAE@google.com>
Subject: Forwarded: [PATCH] mm/madvise: prefer VMA lock for MADV_REMOVE
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+ci5295199f57663826@syzkaller.appspotmail.com>, 
	wang.yaxin@zte.com.cn
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: [PATCH] mm/madvise: prefer VMA lock for MADV_REMOVE
Author: wang.yaxin@zte.com.cn

From: Jiang Kun <jiang.kun2@zte.com.cn>

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable

MADV_REMOVE currently runs under the process-wide mmap_read_lock() and
temporarily drops and reacquires it around filesystem hole punching. For
single-VMA, local-mm, non-UFFD-armed ranges we can validate the range under
the per-VMA read lock.

Calling into the filesystem (vfs_fallocate()) while holding a VMA lock may
create lock ordering issues involving inode locks, mmap_lock and vm_lock.
To avoid that, drop the VMA lock before invoking vfs_fallocate(), while
pinning the file with get_file(). The mmap_lock fallback path retains the
existing userfaultfd coordination and lock drop/reacquire behaviour.

Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
Signed-off-by: Yaxin Wang <wang.yaxin@zte.com.cn>
---
 mm/madvise.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 6bf7009fa5ce..7e71227a86d5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1015,7 +1015,8 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	unsigned long start = madv_behavior->range.start;
 	unsigned long end = madv_behavior->range.end;

-	mark_mmap_lock_dropped(madv_behavior);
+	if (madv_behavior->lock_mode == MADVISE_MMAP_READ_LOCK)
+		mark_mmap_lock_dropped(madv_behavior);

 	if (vma->vm_flags & VM_LOCKED)
 		return -EINVAL;
@@ -1039,15 +1040,21 @@ static long madvise_remove(struct madvise_behavior *madv_behavior)
 	 * mmap_lock.
 	 */
 	get_file(f);
-	if (userfaultfd_remove(vma, start, end)) {
-		/* mmap_lock was not released by userfaultfd_remove() */
-		mmap_read_unlock(mm);
+	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
+		vma_end_read(vma);
+		madv_behavior->vma = NULL;
+	} else {
+		if (userfaultfd_remove(vma, start, end)) {
+			/* mmap_lock was not released by userfaultfd_remove() */
+			mmap_read_unlock(mm);
+		}
 	}
 	error = vfs_fallocate(f,
 				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				offset, end - start);
 	fput(f);
-	mmap_read_lock(mm);
+	if (madv_behavior->lock_mode == MADVISE_MMAP_READ_LOCK)
+		mmap_read_lock(mm);
 	return error;
 }

@@ -1685,7 +1692,8 @@ int madvise_walk_vmas(struct madvise_behavior *madv_behavior)
 	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK &&
 	    try_vma_read_lock(madv_behavior)) {
 		error = madvise_vma_behavior(madv_behavior);
-		vma_end_read(madv_behavior->vma);
+		if (madv_behavior->vma)
+			vma_end_read(madv_behavior->vma);
 		return error;
 	}

@@ -1754,7 +1762,6 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 		return MADVISE_NO_LOCK;

 	switch (madv_behavior->behavior) {
-	case MADV_REMOVE:
 	case MADV_WILLNEED:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
@@ -1762,6 +1769,7 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
 		return MADVISE_MMAP_READ_LOCK;
+	case MADV_REMOVE:
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
 	case MADV_DONTNEED:
-- 
2.43.5
