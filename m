Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CCC1D5170
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 21:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226599; cv=none; b=g+s5PfO5Hm01m4eRJtruECs+0z1Wy8W3Hz+jnQkqTPZuxSxtl9dtqML4ey1PrR2Ej6wP/EKF2H8nUC9KDCNhNuFmgvUgDIXYzWN1FIbIS025pJxPQbnn7j/lLn5IcLA+f3TqgXguACAZgcPMj1Rs6eENyvsJyFgca1SCWBjN6jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226599; c=relaxed/simple;
	bh=LSr2PDWI5zVp5KtkZTDe21I4nRXASzFCPNDKJb8VuD4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=a6g3N98LK20nPYBQC5a8P1Fal6eK8ymHkfllseKOifcEvP9xCbmxtL6ZQVF15dKXcMc0VmmOYNFBjWIC7IspNbx0dTB8n3URV6CG+hGY8ZUPE+sgxuoA3U8cOdkdACnM5NUC0yQ2VxjpL58i2luTTW+HF1F+9xXm1scFuuuV+dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCZcqCtn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCZcqCtn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4E0A51F000E9;
	Tue, 19 May 2026 21:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779226598;
	bh=/+h+pNKrYRdHv7eT8BoI0WG9q4LDZwp3aWRwwBiTv0M=;
	h=From:To:Cc:Subject:Date;
	b=cCZcqCtnaWSM7tyE0K0rIaWshBzSU9XX0czKgkUPijNaUn4PC42Ypc3JWLvhHSxyK
	 kUcbzSLLeWRFkkmdAredsOk5OkcG4dQJB4rbsl145CivXLXC/znwEGPICwqGJHQKLy
	 7CXP6I9WGP9G00YVbLkpz4Jk+X9j8d0M7v2QJPJ0xMZ9iWan85M4nBN9VkxPO+nVpU
	 eY7wm22NmJMZGD/IOZEe4GFjz9KzNy4RODYxfqqlpTNi9XQ4kepTok34Gw/oAbwZbp
	 Xu2ik63L2zMkXUN9E6XF7+DaupYif7RIQScduhLACygpVeAM+eAnvTthoyc8WXv4N8
	 8lCNoL+zr9URA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] jfs: fix slab-use-after-free in lbmIODone
Message-ID: <6fef35ba-faae-40b7-9ec2-387ae5b24666@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 21:36:38 +0000 (UTC)

A KASAN slab-use-after-free was reported in lbmIODone(). The root cause
is a race condition between lbmRead() and the bio completion handler
lbmIODone(). In lbmRead(), wait_event() is used to wait for the I/O
completion locklessly. When the READ bio completes, lbmIODone() clears
the lbmREAD flag and wakes up the waiter before setting the lbmDONE flag
and releasing the LCACHE_LOCK. Because wait_event() evaluates its
condition locklessly, lbmRead() can wake up and return immediately after
the wakeup, before lbmIODone() has finished its execution.

The caller of lbmRead() (e.g., lmLogShutdown()) can then reuse the same
buffer for a WRITE bio. Meanwhile, the original lbmIODone() resumes and
erroneously sets the lbmDONE flag on the reused buffer. This causes a
subsequent lbmIOWait() on the new WRITE bio to return early and free the
buffer. When the WRITE bio actually completes, lbmIODone() accesses the
freed buffer, triggering the use-after-free.

Fix this by replacing the lockless wait_event() in lbmRead() with
lbmIOWait(bp, 0). lbmIOWait() properly synchronizes with lbmIODone() by
acquiring LCACHE_LOCK before checking the condition, ensuring lbmRead()
will block until lbmIODone() has completely finished. As an added
benefit, lbmIOWait() correctly returns -EIO if the bio completes with an
error, whereas the previous implementation unconditionally returned 0.

Fixes: 22cad8bc1d36 ("jfs: fix array-index-out-of-bounds in dbFindLeaf")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+1afe7ef2d0062e19eeb3@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=1afe7ef2d0062e19eeb3
Link: https://syzkaller.appspot.com/ai_job?id=6a34b414-433f-4b06-ae87-9e8836b3b11b
To: <jfs-discussion@lists.sourceforge.net>
To: <shaggy@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Fixed an array-index-out-of-bounds in dbFindLeaf by correcting the boundary check

v1:
https://lore.kernel.org/all/b0890704-e83c-4e0f-a7f4-5fa40dfee9c8@mail.kernel.org/T/
---
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a841cf21d..cbdcc8d05 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3058,7 +3058,7 @@ static int dbFindLeaf(dmtree_t *tp, int l2nb, int *leafidx, bool is_ctl)
 			/* sufficient free space found.  move to the next
 			 * level (or quit if this is the last level).
 			 */
-			if (x + n > max_size)
+			if (x + n >= max_size)
 				return -ENOSPC;
 			if (l2nb <= tp->dmt_stree[x + n])
 				break;
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 306165e61..cf62a8564 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1984,9 +1984,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 		submit_bio(bio);
 	}
 
-	wait_event(bp->l_ioevent, (bp->l_flag != lbmREAD));
-
-	return 0;
+	return lbmIOWait(bp, 0);
 }
 
 


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
