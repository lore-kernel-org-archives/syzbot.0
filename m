Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800001799F
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338128; cv=none; b=IFMHt43KTdscBB7YbRg1awltdRvrk6nWS6QhPTnkqs4yeYuiRzzjucPuM6168wO4B3boe07vtWX2vx0lWSz9ptDt1MVaMZ37Gt19yPPrQQayNckB4q3jZjbcMsRbaElCg+/p2lKjCCybv6f+ahR4rGCDje1VRHGOhdAlgWt/4ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338128; c=relaxed/simple;
	bh=JAGbmwgP3762lNLnpsCHLhiqmqqWOITXU6q5y3xTmrk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=sbfB85HT9wql2I8RvYV82aCarnVn+PUwdOLtCwXgbwD87cCH3k4R/4uZdaRakT2V/C3IfzlSsU1xQ1YV//AtjGDD8btFyj0B6t84S9Yx/IWvY0FrcKAnlrk3LML82nz6+KmHHIoe0pFIPVWNyExFRcMCpSAkomZQk+qpgzDtJVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aI+l4JMg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aI+l4JMg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4ABF81F00A3A;
	Wed, 29 Jul 2026 15:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785338127;
	bh=1A9TX9BELipIuQ2A0WBhwrqesyxhxnmB+1DCeAeS5RQ=;
	h=From:To:Cc:Subject:Date;
	b=aI+l4JMgctT49H8/MbhHoTM3jHuJ4xmQCAUEKWbdwHMNEenbnlA5u7cvy3tjwIACy
	 BdpIDJiahgjA/smEe7ANfs3wQR208OZMwycn5fzjqA1gyniAU88kuKYDG6bZaA2tJg
	 uFLgS/V5TzA+QUC6c4d1dmYs+iHT0trwnSabgSkHcoxOO4Ri5RyNa7tF2dsVzyX14+
	 j4Qk2RAH96fPvpC/KsdI/BGrW2M+A8xawz4geCZxY2Ox/bvWQyQQWN3LtstpLeTtEQ
	 +tAsGAYx0Yonss7qW991VpXVM4Ww0aYuE7kQf+2W5+y0vKgXPvB5/foDU/tG8choUA
	 qGvZb3c5iHAGw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: dvb-core: fix memory leaks in dvb_dmxdev_filter_start()
Message-ID: <c71917b4-2e14-4f8d-ae14-926519cb7b14@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 15:15:27 +0000 (UTC)

When starting a PES filter with multiple PIDs, dvb_dmxdev_filter_start()
iterates over all feeds and calls dvb_dmxdev_start_feed() for each of them.
If dvb_dmxdev_start_feed() succeeds for the first feed but fails for a
subsequent feed (e.g., due to running out of hardware feeds), it attempts
to clean up by calling dvb_dmxdev_filter_stop().

However, dvb_dmxdev_filter_stop() checks if the filter state is at least
DMXDEV_STATE_GO. Since dvb_dmxdev_filter_start() only sets the state to
DMXDEV_STATE_GO at the end of the function, the state is still
DMXDEV_STATE_SET during the error path. As a result,
dvb_dmxdev_filter_stop() immediately returns 0 and does not stop the feeds
that were already successfully started. This leaves the successfully
started feeds running indefinitely, leading to memory leaks of structures
like vidtv_mux and its associated channels, services, and PSI descriptors.

BUG: memory leak
unreferenced object 0xffff888184ec5120 (size 32):
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 48 19 02 0c 10 34 56 85  ........H....4V.
    81 88 ff ff 0a 70 3f 56 85 81 88 ff ff 00 00 00  .....p?V........
  backtrace (crc b14a33fd):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4597 [inline]
    slab_alloc_node mm/slub.c:4917 [inline]
    __kmalloc_cache_noprof+0x1be/0x3f0 mm/slub.c:5485
    _kmalloc_noprof include/linux/slab.h:988 [inline]
    _kzalloc_noprof include/linux/slab.h:1309 [inline]
    vidtv_psi_service_desc_init+0x7a/0x1b0
    drivers/media/test-drivers/vidtv/vidtv_psi.c:233
    vidtv_channel_s302m_init+0xd3/0x2c0
    drivers/media/test-drivers/vidtv/vidtv_channel.c:83
    vidtv_channels_init+0x20/0x40
    drivers/media/test-drivers/vidtv/vidtv_channel.c:528
    vidtv_mux_init+0x117/0x830
    drivers/media/test-drivers/vidtv/vidtv_mux.c:521
    vidtv_start_streaming
    drivers/media/test-drivers/vidtv/vidtv_bridge.c:194 [inline]
    vidtv_start_feed+0x1d3/0x260
    drivers/media/test-drivers/vidtv/vidtv_bridge.c:239
    dmx_ts_feed_start_filtering+0xaf/0x110
    drivers/media/dvb-core/dvb_demux.c:747
    dvb_dmxdev_start_feed drivers/media/dvb-core/dmxdev.c:658 [inline]
    dvb_dmxdev_filter_start+0x1d4/0x650 drivers/media/dvb-core/dmxdev.c:769

To fix this, temporarily set the filter state to DMXDEV_STATE_GO before
calling dvb_dmxdev_filter_stop() on the error path in
dvb_dmxdev_filter_start(). This ensures that the cleanup function actually
stops the successfully started feeds.

Additionally, this patch addresses several other related issues in the
error handling paths:
- In dvb_dmxdev_start_feed(), explicitly set feed->ts = NULL if an error
occurs and the feed is released to prevent dangling pointers.
- In dvb_dmxdev_add_pid(), if dvb_dmxdev_start_feed() fails, remove the
feed from the list and free it.
- In dvb_dmxdev_remove_pid(), always remove and free the feed, even if
feed->ts is NULL.
- In dvb_dmxdev_filter_start() for DMXDEV_TYPE_SEC, if (*secfeed)->set()
fails, set *secfeed = NULL. If start_filtering() fails, explicitly release
the filter, restart the feed, and set the pointers to NULL before returning
the error.
- Update dvb_dmxdev_feed_stop(), dvb_dmxdev_filter_stop(), and
dvb_dmxdev_remove_pid() to check if feed->ts != NULL before dereferencing
it.

Fixes: 1cb662a31449 ("V4L/DVB (12275): Add two new ioctls: DMX_ADD_PID and DMX_REMOVE_PID")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e180aa47a45c517e59f5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e180aa47a45c517e59f5
Link: https://syzkaller.appspot.com/ai_job?id=408080dd-bb67-4039-8125-ce147d3d3315
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Andreas Oberritter" <obi@linuxtv.org>
Cc: "Hans Verkuil" <hverkuil@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 3c8bc75e4..99d438411 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -490,8 +490,10 @@ static int dvb_dmxdev_feed_stop(struct dmxdev_filter *dmxdevfilter)
 		dmxdevfilter->feed.sec->stop_filtering(dmxdevfilter->feed.sec);
 		break;
 	case DMXDEV_TYPE_PES:
-		list_for_each_entry(feed, &dmxdevfilter->feed.ts, next)
-			feed->ts->stop_filtering(feed->ts);
+		list_for_each_entry(feed, &dmxdevfilter->feed.ts, next) {
+			if (feed->ts)
+				feed->ts->stop_filtering(feed->ts);
+		}
 		break;
 	default:
 		return -EINVAL;
@@ -572,8 +574,10 @@ static int dvb_dmxdev_filter_stop(struct dmxdev_filter *dmxdevfilter)
 		dvb_dmxdev_feed_stop(dmxdevfilter);
 		demux = dmxdevfilter->dev->demux;
 		list_for_each_entry(feed, &dmxdevfilter->feed.ts, next) {
-			demux->release_ts_feed(demux, feed->ts);
-			feed->ts = NULL;
+			if (feed->ts) {
+				demux->release_ts_feed(demux, feed->ts);
+				feed->ts = NULL;
+			}
 		}
 		break;
 	default:
@@ -652,12 +656,14 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 	ret = tsfeed->set(tsfeed, feed->pid, ts_type, ts_pes, timeout);
 	if (ret < 0) {
 		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
+		feed->ts = NULL;
 		return ret;
 	}
 
 	ret = tsfeed->start_filtering(tsfeed);
 	if (ret < 0) {
 		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
+		feed->ts = NULL;
 		return ret;
 	}
 
@@ -726,6 +732,7 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
 				pr_err("DVB (%s): could not set feed\n",
 				       __func__);
 				dvb_dmxdev_feed_restart(filter);
+				*secfeed = NULL;
 				return ret;
 			}
 		} else {
@@ -758,8 +765,13 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
 		filter->todo = 0;
 
 		ret = filter->feed.sec->start_filtering(filter->feed.sec);
-		if (ret < 0)
+		if (ret < 0) {
+			filter->feed.sec->release_filter(filter->feed.sec, filter->filter.sec);
+			dvb_dmxdev_feed_restart(filter);
+			filter->feed.sec = NULL;
+			filter->filter.sec = NULL;
 			return ret;
+		}
 
 		dvb_dmxdev_filter_timer(filter);
 		break;
@@ -768,6 +780,7 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
 		list_for_each_entry(feed, &filter->feed.ts, next) {
 			ret = dvb_dmxdev_start_feed(dmxdev, filter, feed);
 			if (ret < 0) {
+				dvb_dmxdev_filter_state_set(filter, DMXDEV_STATE_GO);
 				dvb_dmxdev_filter_stop(filter);
 				return ret;
 			}
@@ -884,6 +897,7 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 			      struct dmxdev_filter *filter, u16 pid)
 {
 	struct dmxdev_feed *feed;
+	int ret;
 
 	if ((filter->type != DMXDEV_TYPE_PES) ||
 	    (filter->state < DMXDEV_STATE_SET))
@@ -901,8 +915,14 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 	feed->pid = pid;
 	list_add(&feed->next, &filter->feed.ts);
 
-	if (filter->state >= DMXDEV_STATE_GO)
-		return dvb_dmxdev_start_feed(dmxdev, filter, feed);
+	if (filter->state >= DMXDEV_STATE_GO) {
+		ret = dvb_dmxdev_start_feed(dmxdev, filter, feed);
+		if (ret < 0) {
+			list_del(&feed->next);
+			kfree(feed);
+			return ret;
+		}
+	}
 
 	return 0;
 }
@@ -917,10 +937,12 @@ static int dvb_dmxdev_remove_pid(struct dmxdev *dmxdev,
 		return -EINVAL;
 
 	list_for_each_entry_safe(feed, tmp, &filter->feed.ts, next) {
-		if ((feed->pid == pid) && (feed->ts != NULL)) {
-			feed->ts->stop_filtering(feed->ts);
-			filter->dev->demux->release_ts_feed(filter->dev->demux,
-							    feed->ts);
+		if (feed->pid == pid) {
+			if (feed->ts != NULL) {
+				feed->ts->stop_filtering(feed->ts);
+				filter->dev->demux->release_ts_feed(filter->dev->demux,
+								    feed->ts);
+			}
 			list_del(&feed->next);
 			kfree(feed);
 		}


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
