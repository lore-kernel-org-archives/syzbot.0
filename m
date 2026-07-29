Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA4D3054C7;
	Wed, 29 Jul 2026 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340829; cv=none; b=r02eyI7Zjk2uF7c3lqVj8h3C2gw3JRr5C3PRfXXu9VDA9LZOUNlUW/T+4II8xleoIFLWl543LSXn1LksQQeH+vWwPMb0Ok/rKfAUNlx2XaYi3c1afdmkdJldZaaP5uHhGcf5qdFj+PwsbxNd0mYUbHPsArksPxjYBPVce6xSo88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340829; c=relaxed/simple;
	bh=F33ada4OmlS+8/2MgZh5k8anahQVk85omhHgDq3n/Ek=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=vAr43BUuDv6qVbhhta+YofF6vW6ZQfWobSZ0NOeS14vIFBgIJs0srLULkVW2j6E6S4iVdIunMZg9xLBEuDIEb9QLmzgttFGPngDRRQLaROqTvESTriKUBkTa8wV6nIowwp+k3lMlH++ANpcFX2E/UaEas6hagLbeM6TyA2abEG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKiBLzdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKiBLzdh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7A3561F000E9;
	Wed, 29 Jul 2026 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785340827;
	bh=Iu9fxVl0EBhvOLnfdANvBli5d6rGsACH+DRmq4nb+p0=;
	h=From:To:Cc:Subject:Date;
	b=mKiBLzdhNCB3W5UWhc55ZCgpjIfEArFl8rAYPYTASHXc0mx/YlR8E2EDGXPX0glug
	 tiqk2BdG6oIzk1XP2gJVaQPJ+eoprgxTZaieoy9ukV2xEgfQSJQsZZ4nMfnXMjtD+J
	 GKARTxKcCek8NVGjLqyeC5dZe4ILIEFTWrWp1KJLxhtK4KNS2NBU1xg5vx/KhV5dTo
	 nZYc/jbIfqBqs7kYtreiCxG0KxjHw9Jd+6eix+9DUmBRlvsB/JqWglF4KM8Upjv7hq
	 nWjupaSCYIj+lwOjqdmjT1ksITs9D7VH60lfdL/91PVxXVxlDarAGdVrYNmj+RLAKI
	 Sjuei2XPKj09w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>, "Julian Scheel" <julian@jusst.de>
Cc: christophe.jaillet@wanadoo.fr, kees@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] usb: gadget: f_uac1, f_uac2: fix invalid free and memory leak
Message-ID: <b1b92444-7b06-4ce1-abf7-66145a4e8939@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 16:00:27 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

The `UAC1_RATE_ATTRIBUTE` and `UAC2_RATE_ATTRIBUTE` macros generate store
functions that use `strsep()` to parse a comma-separated list of sample
rates. The `strsep()` function modifies the pointer passed to it, advancing
it past the delimiter.

This causes two issues. First, if `kstrtou32()` fails (e.g., due to an
invalid token), the code jumps to the `end` label and calls
`kfree(split_page)`. Since `split_page` has been advanced by `strsep()`,
this results in an invalid free. Second, if the loop completes
successfully, `strsep()` sets `split_page` to `NULL`. The subsequent
`kfree(split_page)` becomes a no-op, leaking the memory allocated by
`kstrdup()`.

KASAN reports the invalid free as follows:

BUG: KASAN: invalid-free in f_uac2_opts_p_srate_store+0x225/0x2b0
drivers/usb/gadget/function/f_uac2.c:2087
Free of addr ffff888192cb7806 by task syz.0.17/6182
Call Trace:
 kfree+0x173/0x6c0 mm/slub.c:6692
 f_uac2_opts_p_srate_store+0x225/0x2b0
 drivers/usb/gadget/function/f_uac2.c:2087
 flush_write_buffer fs/configfs/file.c:207 [inline]
 configfs_write_iter+0x33a/0x430 fs/configfs/file.c:229
 vfs_write+0x61e/0xbb0 fs/read_write.c:687
 ksys_write+0x156/0x270 fs/read_write.c:739
The buggy address is located 6 bytes inside of
 32-byte region [ffff888192cb7800, ffff888192cb7820)

Fix this by keeping the original pointer returned by `kstrdup()` in a
separate variable `page_alloc` and passing a temporary pointer `split_page`
to `strsep()`. This ensures that the correct pointer is passed to
`kfree()`. Additionally, add a check to handle `kstrdup()` allocation
failures.

Fixes: a7339e4f5788 ("usb: gadget: f_uac2: Support multiple sampling rates")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+bfca46c96ddf3b7d5c55@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bfca46c96ddf3b7d5c55
Link: https://syzkaller.appspot.com/ai_job?id=705307cf-805c-4e75-8f76-2a0acc541cb8
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/function/f_uac1.c
index 85c502e98..f4b7bbd93 100644
--- a/drivers/usb/gadget/function/f_uac1.c
+++ b/drivers/usb/gadget/function/f_uac1.c
@@ -1594,6 +1594,7 @@ static ssize_t f_uac1_opts_##name##_store(struct config_item *item,	\
 					  const char *page, size_t len)	\
 {									\
 	struct f_uac1_opts *opts = to_f_uac1_opts(item);		\
+	char *page_alloc = NULL;					\
 	char *split_page = NULL;					\
 	int ret = -EINVAL;						\
 	char *token;							\
@@ -1608,7 +1609,12 @@ static ssize_t f_uac1_opts_##name##_store(struct config_item *item,	\
 									\
 	i = 0;								\
 	memset(opts->name##s, 0x00, sizeof(opts->name##s));		\
-	split_page = kstrdup(page, GFP_KERNEL);				\
+	page_alloc = kstrdup(page, GFP_KERNEL);				\
+	if (!page_alloc) {						\
+		ret = -ENOMEM;						\
+		goto end;						\
+	}								\
+	split_page = page_alloc;					\
 	while ((token = strsep(&split_page, ",")) != NULL) {		\
 		ret = kstrtou32(token, 0, &num);			\
 		if (ret)						\
@@ -1619,7 +1625,7 @@ static ssize_t f_uac1_opts_##name##_store(struct config_item *item,	\
 	};								\
 									\
 end:									\
-	kfree(split_page);						\
+	kfree(page_alloc);						\
 	mutex_unlock(&opts->lock);					\
 	return ret;							\
 }									\
diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 897787d08..336aeaec9 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -2012,6 +2012,7 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 					  const char *page, size_t len)	\
 {									\
 	struct f_uac2_opts *opts = to_f_uac2_opts(item);		\
+	char *page_alloc = NULL;					\
 	char *split_page = NULL;					\
 	int ret = -EINVAL;						\
 	char *token;							\
@@ -2026,7 +2027,12 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 									\
 	i = 0;								\
 	memset(opts->name##s, 0x00, sizeof(opts->name##s));		\
-	split_page = kstrdup(page, GFP_KERNEL);				\
+	page_alloc = kstrdup(page, GFP_KERNEL);				\
+	if (!page_alloc) {						\
+		ret = -ENOMEM;						\
+		goto end;						\
+	}								\
+	split_page = page_alloc;					\
 	while ((token = strsep(&split_page, ",")) != NULL) {		\
 		ret = kstrtou32(token, 0, &num);			\
 		if (ret)						\
@@ -2037,7 +2043,7 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 	};								\
 									\
 end:									\
-	kfree(split_page);						\
+	kfree(page_alloc);						\
 	mutex_unlock(&opts->lock);					\
 	return ret;							\
 }									\


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
