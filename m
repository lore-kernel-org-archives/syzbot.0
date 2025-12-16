Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FE43A1E87
	for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 13:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765893485; cv=none; b=c/a1ho68rGwhQHOqPB+CcNYX94gxE6B5OUzqh+vZ69E6/Uh71Knypc67fmajoR1nTkONNOCb1GBlPKZIMIOx7CjsFp9+qfwATwiF6KmGmOsxafPQ4OYYa2iS2qmC8/3R5JEYJaX0b2atCQO8uOrJnkPuLY27EYUvBrBysBp4COo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765893485; c=relaxed/simple;
	bh=v0gRJ/iUcaG+NjAQDBjqxyhU2MisJyjS27UBw8VmtYw=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=WG/2uATW3ab7gQIzxTMEtbwHiqjaZMU72pWLCdKN6vByTmzo4Ce2MBXry4/NGL9Okd0NdyeOBCBWdTTWxKs/ivQfvpYgNmCqxCgDEd4xhx0ejnlI/K0I9IUMUM6nLNMRBy3Py5cMNYnIl4Ecwd5VuDv8P/iD9a+aHuA0+XqUUtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=EbsJs+3Z; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="EbsJs+3Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1765893474; bh=iXRrlaHLTWoP05X1daQo0hZEfeEwAupxcEuPUUwBHLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbsJs+3ZoFfr9lr7AkVODaWpboi7RYfxBfhwXSclB68vE9+cErzLr7hHDYF0yV48F
	 1wCTBaKq+jytXtVVTwvkGyORAUdjowXGe0oB8111uzGb2WF521Y+ehtcjsqTdXYhiY
	 ALSug+ey3HJM9xRXDRLor0TNXQxDuk/i1+9KyKcc=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id E73A50AF; Tue, 16 Dec 2025 21:57:51 +0800
X-QQ-mid: xmsmtpt1765893471twc5zwyl8
Message-ID: <tencent_48DDBA00BB1033889E551BDE4B721B042508@qq.com>
X-QQ-XMAILINFO: ODukwAJJE14znYh97sEsMeLf2aaOGGvmrn9g4Q1/VvW+aczWl0WSo7QIcoXLoT
	 bHLhGYQ+8Q48ULFs4I6hk7o70NErDuuwjaGjEexyufP/9UOBTkE8eIq1E8UozR9e13VaxFNn9HNy
	 z7qcAoyj281e+QZsiounnur7FIQWYdzsAy+M66ukaZPDMFbuAapYvaAZcqGZPjvvjUkyKaBo8I5J
	 17atyTCeUUJQ5SDhS9jy4/W4c7oDxbJbvkT4NJD7BY9P3XS2Pz48v5ZahHAbVm2y36C0OdfQG7Cj
	 CaG4WYllIm/wqJo5TJxwYaKFYEItx513EcVekjFhc1Yj1WAb7w4DNw6RmruL52gtNicNRHmLRORW
	 FJUaF/kdrBtwBxuHVqL+m7PIRfjOZTGFb7IpRkZV9HR9cVhKeTVd/xxwCl3OJWClNaNBmV3N96Oj
	 c/7gXmmwEo4V6UyGY01e04Nf7kw2ubROia6+zDIydJPbnlqVmUKyCci9KCp8bAIgUFzIZ6F3uPvj
	 feSxXTGV3no79A/O7lv4B+IdS64KD5uIA8oh2f2C8IodeSvkFif7w8cby5TqlP1131C8bOX3iD6/
	 U8gaA6yIQiIjhYdnCxQ5RVBQp0jMCKnFPQ4Nxvb4HsJxG/kjcNGOQsi57QmGLceQ28OIZqnMoiKI
	 XKiid9VBpZLUcmVNIdmXpjHh5sMKP0o0z079hsaaVg0SPxknXdvXv0mbuaAAMsHZrtrk+a9koRHp
	 UYYm676ScyqT1fs7utDcWdZd7qnA/4fCMqsDRycoGX+jz0bLZEOQ0T7Kk6Z1VfYsyniLL9IbIuG1
	 OuJcp9wuW56B3vRjyHrnI1B9BoZwXD6f1wgyE5A/su8aftmdHa8IjUCeBsYwSWsBk2dl3rpejOvN
	 VZ0mS8hOfma31hAojgiMY5YjLoeFavWtJ1cEs61voDknohZM4M8DKtbYiFEnsrm8E0ctlxfJLe6O
	 6+kkBO+0QEt1mW5e7aIDurnW0s79oVO09TYUJLxYysUZeh6dfue3wcEkCE5uFnFRxKnw4QGzwql6
	 hLxvBHiCmOl1TqQtBMs0OpA/F/xC4=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+ci1f1a4e9c887bc6ea@syzkaller.appspotmail.com
Cc: axboe@kernel.dk,
	eadavis@qq.com,
	jfs-discussion@lists.sourceforge.net,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	shaggy@kernel.org,
	syzbot@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH v2] jfs: Extend the done of the window period
Date: Tue, 16 Dec 2025 21:57:51 +0800
X-OQ-MSGID: <20251216135750.31446-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <69415e37.050a0220.1ff09b.001d.GAE@google.com>
References: <69415e37.050a0220.1ff09b.001d.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In lbmRead(), the I/O event waited for by wait_event() finishes before
it goes to sleep, and the lbmIODone() prematurely sets the flag to
lbmDONE, thus ending the wait. This causes wait_event() to return before
lbmREAD is cleared (because lbmDONE was set first), the premature return
of wait_event() leads to the release of lbuf before lbmIODone() returns,
thus triggering the use-after-free vulnerability reported in [1].

Moving the operation of setting the lbmDONE flag to after clearing lbmREAD
in lbmIODone() avoids the use-after-free vulnerability reported in [1].

[1]
BUG: KASAN: slab-use-after-free in rt_spin_lock+0x88/0x3e0 kernel/locking/spinlock_rt.c:56
Call Trace:
 blk_update_request+0x57e/0xe60 block/blk-mq.c:1007
 blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1169
 blk_complete_reqs block/blk-mq.c:1244 [inline]
 blk_done_softirq+0x10a/0x160 block/blk-mq.c:1249

Allocated by task 6101:
 lbmLogInit fs/jfs/jfs_logmgr.c:1821 [inline]
 lmLogInit+0x3d0/0x19e0 fs/jfs/jfs_logmgr.c:1269
 open_inline_log fs/jfs/jfs_logmgr.c:1175 [inline]
 lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1069
 jfs_mount_rw+0xe9/0x670 fs/jfs/jfs_mount.c:257
 jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532

Freed by task 6101:
 kfree+0x1bd/0x900 mm/slub.c:6876
 lbmLogShutdown fs/jfs/jfs_logmgr.c:1864 [inline]
 lmLogInit+0x1137/0x19e0 fs/jfs/jfs_logmgr.c:1415
 open_inline_log fs/jfs/jfs_logmgr.c:1175 [inline]
 lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1069
 jfs_mount_rw+0xe9/0x670 fs/jfs/jfs_mount.c:257
 jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532

Reported-by: syzbot+1d38eedcb25a3b5686a7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1d38eedcb25a3b5686a7
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
v1 -> v2: fix potential deadlock

 fs/jfs/jfs_logmgr.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index b343c5ea1159..0db4bc9f2d6c 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2180,8 +2180,6 @@ static void lbmIODone(struct bio *bio)
 
 	LCACHE_LOCK(flags);		/* disable+lock */
 
-	bp->l_flag |= lbmDONE;
-
 	if (bio->bi_status) {
 		bp->l_flag |= lbmERROR;
 
@@ -2196,12 +2194,10 @@ static void lbmIODone(struct bio *bio)
 	if (bp->l_flag & lbmREAD) {
 		bp->l_flag &= ~lbmREAD;
 
-		LCACHE_UNLOCK(flags);	/* unlock+enable */
-
 		/* wakeup I/O initiator */
 		LCACHE_WAKEUP(&bp->l_ioevent);
 
-		return;
+		goto out;
 	}
 
 	/*
@@ -2225,8 +2221,7 @@ static void lbmIODone(struct bio *bio)
 
 	if (bp->l_flag & lbmDIRECT) {
 		LCACHE_WAKEUP(&bp->l_ioevent);
-		LCACHE_UNLOCK(flags);
-		return;
+		goto out;
 	}
 
 	tail = log->wqueue;
@@ -2278,8 +2273,6 @@ static void lbmIODone(struct bio *bio)
 	 * leave buffer for i/o initiator to dispose
 	 */
 	if (bp->l_flag & lbmSYNC) {
-		LCACHE_UNLOCK(flags);	/* unlock+enable */
-
 		/* wakeup I/O initiator */
 		LCACHE_WAKEUP(&bp->l_ioevent);
 	}
@@ -2290,6 +2283,7 @@ static void lbmIODone(struct bio *bio)
 	else if (bp->l_flag & lbmGC) {
 		LCACHE_UNLOCK(flags);
 		lmPostGC(bp);
+		LCACHE_LOCK(flags);		/* disable+lock */
 	}
 
 	/*
@@ -2302,9 +2296,11 @@ static void lbmIODone(struct bio *bio)
 		assert(bp->l_flag & lbmRELEASE);
 		assert(bp->l_flag & lbmFREE);
 		lbmfree(bp);
-
-		LCACHE_UNLOCK(flags);	/* unlock+enable */
 	}
+
+out:
+	bp->l_flag |= lbmDONE;
+	LCACHE_UNLOCK(flags);
 }
 
 int jfsIOWait(void *arg)
-- 
2.43.0

