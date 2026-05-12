Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2A33C3C02
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 09:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778577658; cv=none; b=eca72c/NXJdZq9B98toIrWdOJbNgfBQXbB2zOplKCuTXqG1BO6we+vtlrlXqg7sfdncGWaANMeSEI4D+wjDvI6BF43kUvNjp5lEZ6eDVyqb+6YoZevPAIrw32nsKeCc7t3oCsWo3eluKPG4ZuxMj/4YlAYz/Sqj5NLUiEnqPkhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778577658; c=relaxed/simple;
	bh=7PXN4m3BWU4xk4wN9hFWYctgsHccxDsE58YANThp9xI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=DUgDCzAaYwlxSl7XUXgNNna3e9LGvuIPzLUTFLPwQzdChdSYk3zCxAvIeRYEpe4KNiz//NFY+dt1FuTGndtJ1wNg4eGoN7wuZbOohlgc8kTiLHat9fZL0YyqPESlpv+dBE2x4g4oumLWggAjPmAfaw7i0OR3koQBAgVkAAP2rTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQtdQ3ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQtdQ3ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC082C2BCB0;
	Tue, 12 May 2026 09:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778577657;
	bh=7PXN4m3BWU4xk4wN9hFWYctgsHccxDsE58YANThp9xI=;
	h=From:To:Cc:Subject:Date:From;
	b=VQtdQ3iazdLKoP++6VUrFldfErvst62uDYMcCan89/APhII/rM2D6UJ7FV4yMhMJX
	 I3eSRBU2oxQs+rBfbpt1n4VplSuM54xcYB9tqF9ut8oqly6rRaFfoYj9iSzJvCJ9jQ
	 bB1lhW0mjxpzXw06f3epwRgdEuy/ullTnnPYQJvj5qq1f3pC89yqmXYrSRwITLoilT
	 ZdLpm1xft6YSkI8ETVjvf+krMX6vBS6/IzlRkUINTx3HFnMr1lUefCZ9Xw0k4tXC9Z
	 EgV7fXJmdoLjARoXdyx+BjjU7Gkm3QMTDQ2s1HD6bK6PKytfhAPmjIGK2Gku6jV3hR
	 neuphgNapbCtQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: fix slab-use-after-free in lbmIODone
Message-ID: <b0890704-e83c-4e0f-a7f4-5fa40dfee9c8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 09:20:57 +0000 (UTC)

jfs: fix slab-use-after-free in lbmIODone

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

Fixes: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+1afe7ef2d0062e19eeb3@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=1afe7ef2d0062e19eeb3
Link: https://syzkaller.appspot.com/ai_job?id=5deba876-6901-4e25-bb74-5f9dc95dd56a
To: <jfs-discussion@lists.sourceforge.net>
To: <shaggy@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
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

See  for more information.
