Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E4F39FCD7
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 09:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778577598; cv=none; b=Ohdm1rkeyQSDrxeldYuOI3yk1HC1L8oFuAx2YCRDm6XBm4Jt24R0ZA4Wxxl7rGbnEAXuNTuk5MvZPPNtzNNbkVKu0qTegR079r3RwgsPy6eAKHVw7GN+IO1BUFD1n+H+PaqLDO33KKsP7eM3WxsDGMjWF3W5S4kEY5nBdUJ7nSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778577598; c=relaxed/simple;
	bh=Fy8VLmJhhlDFk3MGXVWcL95dWMZyWIQQD7km2kpTJgk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=S80dBLik+FnB9BONa5JwHyvhNRQs8XJ0d1xjKtdIgcqgQx2gnre0JrtGdxh5Eelqf2FEGA76J4E1foLzwTBn0R/J4wCg+Byp/6yjGxlsm54oKiJ4QBEIaztLGaeOsCLWgYWP8qsaPOq0cZXIhd9WyBIgJxBRROYVqjP37tyhYJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxh/LSW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxh/LSW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC373C2BCF5;
	Tue, 12 May 2026 09:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778577597;
	bh=Fy8VLmJhhlDFk3MGXVWcL95dWMZyWIQQD7km2kpTJgk=;
	h=From:To:Cc:Subject:Date:From;
	b=mxh/LSW9voVeGmFkSE7ECQfDrkUDFHojwxqAfS5HlEepbREu0HouyLeSf7OJFUz6B
	 4uaHd77C96sNQEHrEg2+4VV4WUuBHJ/qF7x+a4dNXqkXVfvijgtyMo4h1z9BbH/EJR
	 x7bZ+fiR8oEwdyRFcZErVuQnrnCezfyWGqMb9dVC0bprNpUa/F4Z6BpCd+nc+0eAFk
	 wwqFSJd8VdorhzVIfJe0htxoNgh9ScebC5+SixA3rhM8CZ72ASLmImmcKJ0BC7G/B4
	 StgbplLjFNxAvuQiUMv9cgfTPO9Segjpyhtqz+b/Vi5fjvF/fVaqnd1r1vUbr4RKzD
	 nVRAwKm2fLSeg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: fix use-after-free in lbmIODone and double bio submission
Message-ID: <f755a426-7bd5-49df-a141-93f77550143b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 09:19:57 +0000 (UTC)

jfs: fix use-after-free in lbmIODone and double bio submission

A KASAN use-after-free crash can occur in the JFS log manager due to a
race condition that results in submitting concurrent bios for the same
log buffer and prematurely freeing the buffer's page while the second
bio is still in flight. When a partial page write is initiated by
`lmGCwrite()`, a bio is submitted but the buffer remains on the write
queue. If a concurrent full page write is then triggered by
`lmNextPage()`, `lbmWrite()` blindly overwrites the buffer's flags and
submits a second bio for the same buffer. Upon completion of the first
bio, `lbmIODone()` reads the overwritten flags, assumes the buffer is
fully processed, and frees it, leaving the second bio to operate on
freed memory. Furthermore, `lbmIODone()` had a pre-existing
use-after-free vulnerability where it accessed the buffer to set the
`lbmDONE` flag after potentially freeing it via `lbmfree()` or
`lmPostGC()`.

This patch fixes both issues. First, `lbmWrite()` is updated to check if
the buffer is already under I/O; if so, it simply ORs the new flags and
returns, preventing the double bio submission. Second, `lbmIODone()` is
refactored to avoid accessing the buffer after it might have been freed.
The `lbmDONE` flag is now set before calling `lbmfree()` or waking up
waiters, and the function returns immediately. In the `lbmGC` branch,
the buffer's flags are saved before calling `lmPostGC()` and evaluated
afterwards to correctly handle sequential bios without triggering a
use-after-free.

Fixes: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+f5a5b157b7336d1fda1d@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=f5a5b157b7336d1fda1d
Link: https://syzkaller.appspot.com/ai_job?id=af144476-5512-4b41-bd21-48f1f6bdd669
To: <jfs-discussion@lists.sourceforge.net>
To: <shaggy@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 306165e61..d7d60fa7d 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2019,6 +2019,16 @@ static void lbmWrite(struct jfs_log * log, struct lbuf * bp, int flag,
 
 	LCACHE_LOCK(flags);		/* disable+lock */
 
+	/*
+	 * If the buffer is already under I/O, we should not submit it again.
+	 * Just OR the flags so that lbmIODone can handle the new state.
+	 */
+	if (bp->l_wqnext != NULL && (bp->l_flag & lbmWRITE)) {
+		bp->l_flag |= flag;
+		LCACHE_UNLOCK(flags);
+		return;
+	}
+
 	/*
 	 * initialize buffer for device driver
 	 */
@@ -2191,11 +2201,13 @@ static void lbmIODone(struct bio *bio)
 	 */
 	if (bp->l_flag & lbmREAD) {
 		bp->l_flag &= ~lbmREAD;
+		bp->l_flag |= lbmDONE;
 
 		/* wakeup I/O initiator */
 		LCACHE_WAKEUP(&bp->l_ioevent);
 
-		goto out;
+		LCACHE_UNLOCK(flags);
+		return;
 	}
 
 	/*
@@ -2218,8 +2230,10 @@ static void lbmIODone(struct bio *bio)
 	log->clsn = (bp->l_pn << L2LOGPSIZE) + bp->l_ceor;
 
 	if (bp->l_flag & lbmDIRECT) {
+		bp->l_flag |= lbmDONE;
 		LCACHE_WAKEUP(&bp->l_ioevent);
-		goto out;
+		LCACHE_UNLOCK(flags);
+		return;
 	}
 
 	tail = log->wqueue;
@@ -2271,17 +2285,38 @@ static void lbmIODone(struct bio *bio)
 	 * leave buffer for i/o initiator to dispose
 	 */
 	if (bp->l_flag & lbmSYNC) {
+		bp->l_flag |= lbmDONE;
 		/* wakeup I/O initiator */
 		LCACHE_WAKEUP(&bp->l_ioevent);
+		LCACHE_UNLOCK(flags);
+		return;
 	}
 
 	/*
 	 *	Group Commit pageout:
 	 */
 	else if (bp->l_flag & lbmGC) {
+		int flags_before = bp->l_flag;
 		LCACHE_UNLOCK(flags);
 		lmPostGC(bp);
 		LCACHE_LOCK(flags);		/* disable+lock */
+
+		if (flags_before & lbmFREE) {
+			LCACHE_UNLOCK(flags);
+			lbmWrite(log, bp, lbmWRITE | lbmRELEASE | lbmFREE, 1);
+			return;
+		}
+		if (flags_before & lbmRELEASE) {
+			LCACHE_UNLOCK(flags);
+			return;
+		}
+		if (bp->l_flag & lbmWRITE) {
+			LCACHE_UNLOCK(flags);
+			return;
+		}
+		bp->l_flag |= lbmDONE;
+		LCACHE_UNLOCK(flags);
+		return;
 	}
 
 	/*
@@ -2293,12 +2328,11 @@ static void lbmIODone(struct bio *bio)
 	else {
 		assert(bp->l_flag & lbmRELEASE);
 		assert(bp->l_flag & lbmFREE);
+		bp->l_flag |= lbmDONE;
 		lbmfree(bp);
+		LCACHE_UNLOCK(flags);
+		return;
 	}
-
-out:
-	bp->l_flag |= lbmDONE;
-	LCACHE_UNLOCK(flags);
 }
 
 int jfsIOWait(void *arg)


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
