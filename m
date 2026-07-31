Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B60253340
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 08:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785486515; cv=none; b=acKfMcea+uGH6OL57XlxjxtqXqIbrZ8YIM8GmXlkZbHyw3m1g7wT9oYHZlDfOMYouSIhUV79MTUdNEgi0ZMQjRTrQgTmUnvM1/mCbkPkBbEFiV9QDYQY/ej8UKs9e+S6ADNMoLCZGwe4+clusmZpqB86G0vgr5rMYOhCFYRQbYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785486515; c=relaxed/simple;
	bh=t+AoDq3dLosN+anyInT2UoG1xNvqUYiL/3vnRScVoTo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Mwrg6S87tgsjnP7RNlBNTmddj8QP39GYY3uAiZ9mDzQaTGY3ilcjTZeFzVZ20FkhIwbgKRR9yiw1aNdSfLiyEHHR6CfUX3EegIWPY27e6fu8QBGwYxeF1OrgUBfV0d01GvG682CysfJtP1kFdC9bIejsgJDaZtVptscXCFqjZMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAhN7Y+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAhN7Y+e"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 60A391F000E9;
	Fri, 31 Jul 2026 08:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785486514;
	bh=k4CfFuM9AsH4ILlmi+wHzJdukpIvLAqIuKfMimhDHEQ=;
	h=From:To:Cc:Subject:Date;
	b=nAhN7Y+eJCBSUkZeYn5mG9bgQz0gWCXJ24mGLJXbw2HwU1c/JrAP1kh+YADt1Fjul
	 kEk9+ENyzf2aTi5sd6hGDGH96i0+cQTAOPiGzrVieK7pIGk7jaW/1je0lcTRpr0F9Z
	 3uFEHqOwPONg5YVOBt5fb4UnhXWNHmfxE/MHJWSvsL6wzwSBbIJLf5TrKxNWchO6LE
	 IjRhVXIWUSLGbMQI9pcbdZD5p16q6nmoTpO3hJm2VOdTcfEhzTYwkUdO25NNjlKt8G
	 cZIrl7Hmc8s/3KS/uT7pkiQg4wVV8itopHQuwS/NSzc+dMg0QbOzIJp7G4VmhJO3e2
	 WzpEkSqDD9g/A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: dvb-core: fix memory leak in dvb_dmxdev_filter_start error path
Message-ID: <f470778d-f931-4e3a-b653-d8d01b9a005c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 08:28:34 +0000 (UTC)

When starting a DVB demux PES filter with multiple PIDs,
`dvb_dmxdev_filter_start()` iterates over the feeds and calls
`dvb_dmxdev_start_feed()` for each. If starting a feed fails (e.g., due to
a signal interrupting a mutex lock), the code attempts to clean up by
calling `dvb_dmxdev_filter_stop()`. However, `dvb_dmxdev_filter_stop()` has
an early exit check that returns immediately if the filter state is less
than `DMXDEV_STATE_GO`. Since `dvb_dmxdev_filter_start()` only sets the
state to `DMXDEV_STATE_GO` at the very end of the function, the state is
still `DMXDEV_STATE_SET` during the error path. Consequently,
`dvb_dmxdev_filter_stop()` does nothing, leaving previously started feeds
running indefinitely. When the file descriptor is closed, the feeds are
permanently leaked.

This leads to memory leaks, as observed in the following kmemleak report:

BUG: memory leak
unreferenced object 0xffff88818bd15680 (size 32):
  comm "syz.0.17", pid 6220, jiffies 4294944052
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 48 19 02 0c 70 38 71 8b  ........H...p8q.
    81 88 ff ff 0a 20 b6 fe 8b 81 88 ff ff 00 00 00  ..... ..........
  backtrace (crc ab93546c):
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
    dvb_demux_do_ioctl+0x383/0x3b0 drivers/media/dvb-core/dmxdev.c:1065

To fix this, `dvb_dmxdev_filter_start()` is updated to manually stop and
release the previously started feeds in the error path, rather than relying
on `dvb_dmxdev_filter_stop()`.

Additionally, several related issues and edge cases in the same file are
addressed to ensure robust error handling:

1. In `dvb_dmxdev_start_feed()`, `feed->ts` is set to NULL in the error
paths after releasing the feed to prevent dangling pointers which could
lead to use-after-free or double-free bugs.
2. In `dvb_dmxdev_filter_start()` for the SEC case, a similar leak in the
error path is fixed by properly releasing the filter, restarting the feed,
and nullifying the pointers if `start_filtering()` fails.
3. In `dvb_dmxdev_add_pid()`, if adding a PID to an already running filter
fails to start the feed, the newly allocated feed is now removed from the
list and freed.
4. In `dvb_dmxdev_filter_stop()`, a NULL pointer check for `feed->ts` is
added before calling `release_ts_feed()` to prevent potential dereferences.
5. In `dvb_dmxdev_remove_pid()`, the logic is fixed to ensure the feed is
always removed from the list and freed, even if the filter hasn't been
started yet (where `feed->ts` is intentionally NULL).

Fixes: 1cb662a31449 ("V4L/DVB (12275): Add two new ioctls: DMX_ADD_PID and DMX_REMOVE_PID")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+070afba8f438130eca76@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=070afba8f438130eca76
Link: https://syzkaller.appspot.com/ai_job?id=98187064-a3c9-477c-97c8-4ae8278fe5f3
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Andreas Oberritter" <obi@linuxtv.org>
Cc: "Hans Verkuil" <hverkuil@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 3c8bc75e4..6d7c38722 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -572,8 +572,10 @@ static int dvb_dmxdev_filter_stop(struct dmxdev_filter *dmxdevfilter)
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
@@ -652,12 +654,14 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
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
 
@@ -758,8 +762,13 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
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
@@ -768,7 +777,15 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
 		list_for_each_entry(feed, &filter->feed.ts, next) {
 			ret = dvb_dmxdev_start_feed(dmxdev, filter, feed);
 			if (ret < 0) {
-				dvb_dmxdev_filter_stop(filter);
+				struct dmxdev_feed *f;
+
+				list_for_each_entry(f, &filter->feed.ts, next) {
+					if (f == feed)
+						break;
+					f->ts->stop_filtering(f->ts);
+					dmxdev->demux->release_ts_feed(dmxdev->demux, f->ts);
+					f->ts = NULL;
+				}
 				return ret;
 			}
 		}
@@ -901,8 +918,15 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 	feed->pid = pid;
 	list_add(&feed->next, &filter->feed.ts);
 
-	if (filter->state >= DMXDEV_STATE_GO)
-		return dvb_dmxdev_start_feed(dmxdev, filter, feed);
+	if (filter->state >= DMXDEV_STATE_GO) {
+		int ret = dvb_dmxdev_start_feed(dmxdev, filter, feed);
+
+		if (ret < 0) {
+			list_del(&feed->next);
+			kfree(feed);
+			return ret;
+		}
+	}
 
 	return 0;
 }
@@ -917,10 +941,12 @@ static int dvb_dmxdev_remove_pid(struct dmxdev *dmxdev,
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
