Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1913A6B8A
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 11:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787053327; cv=none; b=deiEvzuglpWHapVQ4g5ZRIDnr4KTnNZqlwAXxXjnWrD766o6nXXSXhmWea2q1wGDRwk3cpA7/kSBUZNhPVnpJ2Z4Xh3funTmQ3CyMl+HhLOqCI1kaQHd9/3Y9e6caq+G0L7zCsY0EUuve9tmYgbLp4ewbbR/k8BnGfRNEifnsk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787053327; c=relaxed/simple;
	bh=iRA/ItbE8J8cKIyLTlBZVh7Bq5g3O6C9qFJT4SeiX4k=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=BgkRwl29mX4oussz8uB8/fj/AtkAJ5gxP11jII3M76VPLGYvHVkGoHpaIWftBGUWTFitIfTQxe9qAUXidjwllI3bI6Y/6q0ZkIjGfgbLc0abBs8Q46/FLKEIQz5Jw3chN17mQnUvlXK+zHmW87su9wi0D92vNg8eFvL0Sgi0QbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/PG5k81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/PG5k81"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 895631F000E9;
	Tue, 18 Aug 2026 11:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787053325;
	bh=SxhSXkKUR5WKgoJToIyBjlN6vfzjNh0bmiVVD9STJTA=;
	h=From:To:Cc:Subject:Date;
	b=O/PG5k81EUGlzB8rCtkIQbQ0t9yXC6ue/MH6xtrZuPai4f2ftt1vpxNtLEgEA8H7h
	 KRktRd5xSPRisx5ZikZtovNeZywQZS4J+yEUaC+TcgpOwyRX3b275EyocM/iPq3YSt
	 ze9aRX3Lqg2PKUm5Iloxi/C8Yuq9jXWaLJW6qWF9F7i63T5XLyynxrRT0UN8B9oDre
	 +oQdTEBMH1fNbcn1Sdn0bAzUcicVdoBb/iuAqtAjzd9yrpHXKssZCR8W0pQrlyu7/T
	 0WL9N0MVr5WKapv2pMYtPicwggUeV1FmvG5gFFXtwuxSCDs03mbWOL9121XpMe2HCW
	 AwpHJD8dQQ9VA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: mc, vivid: fix use-after-free in media_request_release()
Message-ID: <1e71dd15-e3b4-4fd8-ab69-a5f147387433@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 18 Aug 2026 11:42:05 +0000 (UTC)

A use-after-free bug occurs in media_request_release() when the vivid
driver is unbound while user-space still holds open file descriptors for
media requests. The root cause is that media_request objects do not hold a
reference to the media_device (or its container, v4l2_device), allowing the
device to be freed prematurely.

When the device is unbound, vivid_remove() unregisters the media device and
drops the reference to the v4l2_device. If there are no other open video
nodes, the v4l2_device is released, freeing the vivid_dev structure which
embeds the media_device. Later, when user-space closes the request file
descriptor, media_request_release() accesses the freed media_device to call
mdev->ops->req_free and decrement mdev->num_requests, leading to a KASAN
slab-use-after-free crash.

To fix this, implement the req_alloc and req_free callbacks in the vivid
driver to take and drop a reference to the v4l2_device (using
v4l2_device_get() and v4l2_device_put()), ensuring the device remains alive
as long as there are active requests.

Additionally, in mc-request.c, move the atomic_dec(&mdev->num_requests)
call before mdev->ops->req_free(req) in media_request_release(). This is
necessary because req_free() might drop the last reference to the
v4l2_device, causing the media_device to be freed immediately. Accessing
mdev->num_requests after req_free() would result in another use-after-free.

BUG: KASAN: slab-use-after-free in media_request_release
drivers/media/mc/mc-request.c:74 [inline]
BUG: KASAN: slab-use-after-free in kref_put include/linux/kref.h:65
[inline]
BUG: KASAN: slab-use-after-free in media_request_put+0xb5/0x1e0
drivers/media/mc/mc-request.c:83
Read of size 8 at addr ffff88818de003d0 by task syz-executor478/5852

Call Trace:
 media_request_release drivers/media/mc/mc-request.c:74 [inline]
 kref_put include/linux/kref.h:65 [inline]
 media_request_put+0xb5/0x1e0 drivers/media/mc/mc-request.c:83
 media_request_close+0x38/0x50 drivers/media/mc/mc-request.c:91
 __fput+0x418/0xa50 fs/file_table.c:512
 fput_close_sync+0x11f/0x240 fs/file_table.c:617
 __do_sys_close fs/open.c:1511 [inline]
 __se_sys_close fs/open.c:1496 [inline]
 __x64_sys_close+0x7e/0x110 fs/open.c:1496

Fixes: 10905d70d788 ("media: media-request: implement media requests")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+3910ee87c4ba0a51e3f9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3910ee87c4ba0a51e3f9
Link: https://syzkaller.appspot.com/ai_job?id=3e0de0f5-6fdc-4089-9f0c-90a26880ecf4
To: "Hans Verkuil" <hverkuil@kernel.org>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Sakari Ailus" <sakari.ailus@linux.intel.com>
To: "Hans Verkuil" <hans.verkuil@cisco.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/mc/mc-request.c b/drivers/media/mc/mc-request.c
index 13e776488..54bb08e65 100644
--- a/drivers/media/mc/mc-request.c
+++ b/drivers/media/mc/mc-request.c
@@ -71,11 +71,11 @@ static void media_request_release(struct kref *kref)
 
 	media_request_clean(req);
 
+	atomic_dec(&mdev->num_requests);
 	if (mdev->ops->req_free)
 		mdev->ops->req_free(req);
 	else
 		kfree(req);
-	atomic_dec(&mdev->num_requests);
 }
 
 void media_request_put(struct media_request *req)
diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index 62cfb5feb..2374f4865 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -869,6 +869,27 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 }
 
 #ifdef CONFIG_MEDIA_CONTROLLER
+static struct media_request *vivid_req_alloc(struct media_device *mdev)
+{
+	struct vivid_dev *dev = container_of(mdev, struct vivid_dev, mdev);
+	struct media_request *req;
+
+	req = kzalloc_obj(*req);
+	if (!req)
+		return NULL;
+
+	v4l2_device_get(&dev->v4l2_dev);
+	return req;
+}
+
+static void vivid_req_free(struct media_request *req)
+{
+	struct vivid_dev *dev = container_of(req->mdev, struct vivid_dev, mdev);
+
+	kfree(req);
+	v4l2_device_put(&dev->v4l2_dev);
+}
+
 static int vivid_req_validate(struct media_request *req)
 {
 	struct vivid_dev *dev = container_of(req->mdev, struct vivid_dev, mdev);
@@ -881,6 +902,8 @@ static int vivid_req_validate(struct media_request *req)
 }
 
 static const struct media_device_ops vivid_media_ops = {
+	.req_alloc = vivid_req_alloc,
+	.req_free = vivid_req_free,
 	.req_validate = vivid_req_validate,
 	.req_queue = vb2_request_queue,
 };


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
