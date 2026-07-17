Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E483D669C;
	Fri, 17 Jul 2026 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784278699; cv=none; b=f8tBCCrsOdSgpNz7jSAtEmxom7o/7iWqhJEgOMVdT+9rsx3b5/lmC9v7CAr46ExKneIh7hPNHn5bEUumjpF01KjtkxwTw8MfI42sYx3gHrTt0C8yWx9PDSsIxsSGDZVSDptbYypv7yo97tOEIq1Tnp0tq8cFMytMswcgt/p0NDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784278699; c=relaxed/simple;
	bh=v9FWPyrWhZzWH9ElyAC5giLmIq3XG3HZyAdKDJy3ddQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=SKtmDUJvFogESCNUS7ReeFECzqzDjiPQtDBT9AurNjMbfgbcKYEJXIrndimY6a2TJdx4ygsxFKCfUENXttdRxpjTFcMujTBRU5WEUnotjnu2BivVJjnT0xEE7L77iDCz9PAVCGEfwf65SapuVj/c+khc1trRcYx+0uBDrUeDSLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j70V53lb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j70V53lb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0D9581F00A3A;
	Fri, 17 Jul 2026 08:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784278698;
	bh=3AogwMFEUrTVdFNcvpZMG2Wa3b83aj0rSoDs431W/To=;
	h=From:To:Cc:Subject:Date;
	b=j70V53lbHrUiduUA1sL8k2PHrCVe6Mx/3U9+bJNGDc3mEMFeyK366I73hdfUzuG/I
	 8gWrOgW/qG/gNdWrzXD4TAfBK3WnhMELyGKnXytOzbPZjRPZBFPC+q56VY7Bw7LGis
	 Gz/lfvA3ui+6Ed9uLYu8fWB8JowSH5N40JYK5QHo8djLQ4cFirM2QKovtShN3dO8Hy
	 F95h0gpQsW/+XYfRxZ8lVSm5wAackUtljnvUB3DJFnkeSLCgGSk53wlky83sccIw3j
	 9t+jA9Bh5eQTAbY4+xqvusZVTT9c1wptRhCz+KzWvqIvMlmmoFdl7YxWevHnRW6uUD
	 aa0OLNIqJdEww==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Kusaram Devineni <kusaram@devineni.in>, "Jens Axboe" <axboe@kernel.dk>, "Josef Bacik" <josef@toxicpanda.com>, <linux-block@vger.kernel.org>, <nbd@other.debian.org>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] nbd: fix I/O hang on dead socket and rate-limit console error
Message-ID: <c4c2aa69-a3bc-4d1b-96ed-64ae891f921e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 17 Jul 2026 08:58:18 +0000 (UTC)

From: Kusaram Devineni <kusaram@devineni.in>

When an NBD device is configured with a timeout of 0, a closed socket can
lead to a permanent I/O hang. The sequence is as follows: a request is sent
and marked in-flight, but then the socket becomes dead (e.g., due to a
connection failure). Since the socket is dead, no reply will ever arrive.
In nbd_xmit_timeout(), if the configured timeout is 0, the code currently
only checks if the socket has been replaced by comparing cookies. If the
cookie still matches, the request timer is unconditionally reset and the
request stays in-flight forever. This causes tasks to hang indefinitely in
TASK_UNINTERRUPTIBLE, triggering the hung task detector:

INFO: task udevd:5915 blocked in I/O wait for more than 143 seconds.
Call Trace:
 <TASK>
 schedule+0x164/0x2b0
 io_schedule+0x7f/0xd0
 folio_wait_bit_common+0x836/0xbc0
 do_read_cache_folio+0x1ac/0x590
 read_part_sector+0xb6/0x2b0
 adfspart_check_POWERTEC+0x9a/0x7a0
 bdev_disk_changed+0x851/0x17a0
 blkdev_get_whole+0x372/0x510
 bdev_open+0x324/0xd70
 ...
 </TASK>

Fix this by checking nsock->dead in addition to the cookie check in
nbd_xmit_timeout(). If the socket is dead, the command is requeued.
Requeuing returns the request to the existing fallback, reconnect, or
failure policy. For the reported configuration where no reconnect is
possible, this results in the request being properly failed, which
terminates the hung operation.

A secondary issue was observed where repeated attempts to connect to an
already-in-use NBD device cause console spam because the "nbd%d already in
use" error message in nbd_genl_connect() is not rate-limited. This can
delay console_unlock() and trigger NMI backtraces. This is fixed by
changing the pr_err() to pr_err_ratelimited().

Fixes: 2c272542baee ("nbd: requeue command if the soecket is changed")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+82de77d3f217960f087d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=82de77d3f217960f087d
Link: https://syzkaller.appspot.com/ai_job?id=40e56b38-627e-4b49-b7ac-d3a21e77dba2
Signed-off-by: Kusaram Devineni <kusaram@devineni.in>

---
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 8f10762e9..eedb1c870 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -523,7 +523,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req)
 			blk_rq_bytes(req), (req->timeout / HZ) * cmd->retries);
 
 		mutex_lock(&nsock->tx_lock);
-		if (cmd->cookie != nsock->cookie) {
+		if (cmd->cookie != nsock->cookie || nsock->dead) {
 			nbd_requeue_cmd(cmd);
 			mutex_unlock(&nsock->tx_lock);
 			mutex_unlock(&cmd->lock);
@@ -2172,7 +2172,7 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 		nbd_put(nbd);
 		if (index == -1)
 			goto again;
-		pr_err("nbd%d already in use\n", index);
+		pr_err_ratelimited("nbd%d already in use\n", index);
 		return -EBUSY;
 	}
 


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
