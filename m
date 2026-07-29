Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA513B058D
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 15:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338069; cv=none; b=J/lfbvvgII73C2XIvK2veqm1R24sjTa5Mi0Co4pt6bl45HZm1Ztin3cyoeofEg9YGeuPmVif84S/6V+WZdb27+88uLOmG0djXNBMq3m809dMQwbuvuPbH7swnNezBI6RodyE/pwqBtafP1KqJKdRaBWzBMtXYE9Ph+cVX7XL3kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338069; c=relaxed/simple;
	bh=aFZALc48F1HG2dscCslvObYKL8Sjpy44oHbXR8+9MN8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=At7Tc/IgkA6KGmhhzWWKaPSQwRma6iDmGKWQXns1DwpMbRhb/AFGbU3utecU/CRU/cYwaCv5gKKHU1sQQK453CLkdfc3CccNuuU0HQZFQHSRSXJwfY97t4yjmDDirRfZnvWUoqYak1xBNbFOlLVlHrPVcbBmAVG1FlUZXFjzsQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZWT4/o1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZWT4/o1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7D4501F000E9;
	Wed, 29 Jul 2026 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785338067;
	bh=m4vrVZ60mgNHmxoIPhlEVWzETDT0MJVwZmr4jY47TZU=;
	h=From:To:Cc:Subject:Date;
	b=kZWT4/o1WRwIbHfb7TTF79I8BYI6KpNB3Wu0QQWI11saERfTHVwrGRQTd7OKnCm2Q
	 mwgXEvjC3IQY5dWP2VYukk4c4hDKC1eqOedZ0MBpQqhqsYVqzni/7ADpGsNMj9gg+I
	 Hc2102z98ViQTf4CFxQKH+L8dh4k7IcjQ/+9Hv1Mt23Uf74hlSQsbJx0+uVUYsGxbe
	 TT8LcSDBqE0b/4YYGqxWgORqji+4KTfTCttdTu66iFqw3cDof9b+A5LMsAHKkMVbrd
	 VJnNbCdJplinN4zs6okkAkGIgjCBR6Mw3uzFi3/vcAQuYeHfiWb6gwXZmVXAsHbcRF
	 ZPCUyCqbeWDUg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: f_uac1, f_uac2: fix invalid free and memory leak
Message-ID: <c0546d86-1fb7-46c5-a37d-645407387aeb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 15:14:27 +0000 (UTC)

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
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Julian Scheel" <julian@jusst.de>
Cc: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
