Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4C331ECF
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 08:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487326; cv=none; b=gvYiYslucf8X29Ld4r993t1HdU+MftyeRUIrNz5CaGaXscv0RFH+0mM3iynEiP3ZVOi0OH86TR4kFRwWeYEwFP5IC9Z/m+/X9nRqpwvoPzgDTRK5hVkAftNbfOMPGZ+AdkwXi6OU1UM+lxwDOmVxKY5BgHdfGXh9rOAfEJ5BTz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487326; c=relaxed/simple;
	bh=SDeNmkLveDOcooWNCrbeaQqzkzAaWrmP/Jyq5s4rf/U=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=BqUQdJyOXLjV27WMpKXBSCKp9zzj9j2gu8BHrmjZpJtB5xM/aflt0ho+2cClkE+AGPW8EiyOGobYVE8bsY7ap/53ucVbf9rDj+iW/dWMARXZjXqe/UzTwUgCRiSJuUZbYedNPB32Us1xWM96v5VRaE6J9Za4xtHyC/7SuUv9g4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkVO725b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkVO725b"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F3F171F000E9;
	Fri, 31 Jul 2026 08:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487325;
	bh=10+aDNAFyYCXsfEJQp0zLKxb4beflCtTw+vWUJojFQs=;
	h=From:To:Cc:Subject:Date;
	b=WkVO725bCr+/5C7Y/ArjJCIYHyXq+vjIVqE2Zhi6n+qJi/oQrcN23Tn6wQ69Qgv5V
	 MD9qdWtszMmZMQmmS61Ju9Hf+D5jjoObaapaivIti800ej6yeS+s4vpDnGcJG1I8Ge
	 17wbmGfO1tOhOwBhflSRkYS4YS0qKjK1nyDcenX8IeDXzAgjI0CJQkG40h/IOApcIU
	 YplPEvTKyANDnAxbZZ7W4ttotwubCiCRh0n4CnDkoK9YNoHrR3loplVEi6Dug9CKsg
	 Gk5xwSZSDVrn+6TdQ9A5H2LmQMCC/eAOj2tsVqy5Ullb66wrcyMI39P7KbHFNLq2Ix
	 PTXW3sYdoBAMg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: f_uac1, f_uac2: fix memory leak and invalid free
Message-ID: <3a95db7e-c37a-418a-8ba8-092b4c1e75f6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 08:42:04 +0000 (UTC)

In the UAC1_RATE_ATTRIBUTE and UAC2_RATE_ATTRIBUTE macros, the store
functions duplicate the input string using kstrdup(). The duplicated string
is then parsed using strsep(), which modifies the pointer to point to the
next token.

When the loop finishes successfully, the pointer becomes NULL, and calling
kfree() on it does nothing, resulting in a memory leak. If an error occurs
during parsing (e.g., kstrtou32() fails), the pointer is advanced to the
middle of the allocated block. Calling kfree() on this modified pointer
leads to an invalid free.

BUG: memory leak
unreferenced object 0xffff8881a08a76c0 (size 64):
  comm "syz.0.18", pid 6226, jiffies 4294944138
  hex dump (first 32 bytes):
    34 34 31 30 30 00 34 38 30 30 30 00 38 38 32 30  44100.48000.8820
    30 00 39 36 30 30 30 00 31 37 36 34 30 30 00 31  0.96000.176400.1
  backtrace (crc 9bbd8bc9):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4597 [inline]
    slab_alloc_node mm/slub.c:4917 [inline]
    __do_kmalloc_node mm/slub.c:5333 [inline]
    __kmalloc_node_track_caller_noprof+0x309/0x4e0 mm/slub.c:5471
    __kmemdup_nul mm/util.c:64 [inline]
    kstrdup+0x3e/0xc0 mm/util.c:84
    f_uac2_opts_c_srate_store+0xeb/0x1a0
    drivers/usb/gadget/function/f_uac2.c:2091
    flush_write_buffer fs/configfs/file.c:207 [inline]
    configfs_write_iter+0x115/0x170 fs/configfs/file.c:229
    new_sync_write fs/read_write.c:595 [inline]
    vfs_write+0x3a0/0x640 fs/read_write.c:687

To fix this, use a separate pointer to keep track of the original memory
block returned by kstrdup() so it can be correctly passed to kfree().
Additionally, add a check for kstrdup() failure and return -ENOMEM instead
of relying on strsep() to handle the NULL pointer and returning -EINVAL.

Fixes: a7339e4f5788 ("usb: gadget: f_uac2: Support multiple sampling rates")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+ebd045a6645cfb713c95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ebd045a6645cfb713c95
Link: https://syzkaller.appspot.com/ai_job?id=cd9711f3-2259-4827-9de9-96cca016901b
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Julian Scheel" <julian@jusst.de>
Cc: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/function/f_uac1.c
index 85c502e98..05684d9f3 100644
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
+	page_alloc = kstrdup(page, GFP_KERNEL);			\
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
index 897787d08..201a38815 100644
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
+	page_alloc = kstrdup(page, GFP_KERNEL);			\
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
