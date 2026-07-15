Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837DD42255C
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784107180; cv=none; b=PXVZE2g7n1OMM7salp2ltXPXI/OjDAM/yQmimOR66W6HDNCck/dccsMWYDD1/8GeBqpYW3h3Ia3DCu/f8I8DYr3Q1S6LAITVOPtmlj0AazFLLFdl0R3qnWmYJn7ea2c++15PItwm+wpY2QCOOWF16GWtGJHxUmD/F6V3ufsgEqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784107180; c=relaxed/simple;
	bh=0n/cGs8YufaXy65NbG7BxqoaDwtDe8FUi1LGs5c3hHc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=PU3zW2jUUBbL+zM4ERYM8y2K4EgPgYqyY4x6TbPMKi2pIythqvlOyY0hQtzbCnNdzf3rZaq7yexhKexZSzsHI/UBPBwlNDAzcK/z3yJQbFfXTEHJvNnNwjnswUGFLIVOg7VRVql3oU4FLw0Gkf7YHs+xVB//F3jgZ6neDz/+pLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eke11PAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eke11PAe"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EB19C1F000E9;
	Wed, 15 Jul 2026 09:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784107177;
	bh=gxxI/cYZ9Tryk56pGcQ1sNc8dPuNKVyELqS4IXkzsoI=;
	h=From:To:Cc:Subject:Date;
	b=Eke11PAe3wcYCtRYMhVXG3Vrbm7MYHoOkgpjS8pDeS+lWrCp5xVwaooVGG6TpW81L
	 1D4/vLSpN0vBDPrdjfCuWkSo4tZfg1hmGQcSByN9Faf1utLJoBav8U8o4NNenjkOGw
	 CRUMoLPo4ERxeNn0SOGuBJ4th4tOLoyHxL8lRNuOcMq/EEVc3lJAm+4B9a5V102sWm
	 acFWgksY1eSj4f+PiVKnAKJVUAyJYdtrAAz7pZ+gTGNE0FsF8kuCOh7SXZuVXPrVgF
	 ATrxoev0WX9dTQXgrm01C5PYx8d224xsCLcc+5ahIHxHeN+yCKBXSkhnkhCc437a1t
	 MPksDaQJZ684A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: gadget: uvc: configfs: prevent null-ptr-deref and double free
Message-ID: <6da89a3d-66d2-4d82-879b-0cd7f4c969fa@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 15 Jul 2026 09:19:36 +0000 (UTC)

From: glider@google.com

If uvcg_config_create_children() fails in uvcg_attach_configfs(), the error
path calls config_group_put(&opts->func_inst.group). This drops the
reference count of the group to 0, triggering its release function,
uvc_func_item_release().

uvc_func_item_release() then calls
usb_put_function_instance(&opts->func_inst). However, at this point, the
usb_function_instance is not fully initialized. Specifically, fi->fd is
NULL because it is only assigned in try_get_usb_function_instance() after
alloc_inst() (which is uvc_alloc_inst()) returns successfully.
usb_put_function_instance() immediately dereferences fi->fd, resulting in a
null-pointer dereference.

Furthermore, if the null-pointer dereference didn't occur,
usb_put_function_instance() would proceed to call fi->free_func_inst(fi),
which maps to uvc_free_inst(). This function calls kfree(opts). After
config_group_put() returns, uvcg_attach_configfs() returns the error code
back to uvc_alloc_inst(), which then also calls kfree(opts), leading to a
double free.

Fix this by replacing config_group_put() with uvcg_config_remove_children()
in the error path of uvcg_attach_configfs(). This safely removes any
partially allocated configfs groups from the default_groups list and frees
them, without triggering the parent's release function. The parent opts
structure will then be safely and correctly freed by the existing
kfree(opts) in uvc_alloc_inst().

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 5875 Comm: syz-executor234 Not tainted
RIP: 0010:usb_put_function_instance+0x54/0xb0
drivers/usb/gadget/functions.c:76
Call Trace:
 <TASK>
 config_item_cleanup fs/configfs/item.c:128 [inline]
 config_item_release+0x13a/0x2d0 fs/configfs/item.c:137
 config_group_put include/linux/configfs.h:102 [inline]
 uvcg_attach_configfs+0x56/0x60
 drivers/usb/gadget/function/uvc_configfs.c:3832
 uvc_alloc_inst+0x6f9/0xa90 drivers/usb/gadget/function/f_uvc.c:999
 try_get_usb_function_instance drivers/usb/gadget/functions.c:28 [inline]
 usb_get_function_instance+0xe3/0x2f0 drivers/usb/gadget/functions.c:44
 function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
 configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360

Fixes: efbf0af70b4f ("usb: gadget: uvc: configfs: Allocate groups dynamically")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Link: https://syzkaller.appspot.com/ai_job?id=48ba7a22-ac64-47f1-9ab8-a7f7b0f6e195
Signed-off-by: glider@google.com
To: <glider@google.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Andy Shevchenko" <andriy.shevchenko@intel.com>
Cc: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Akash Kumar" <quic_akakum@quicinc.com>
Cc: "Randy Dunlap" <rdunlap@infradead.org>

---
diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 70a1415ea..da0fc8084 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -3829,7 +3829,7 @@ int uvcg_attach_configfs(struct f_uvc_opts *opts)
 	ret = uvcg_config_create_children(&opts->func_inst.group,
 					  &uvc_func_type);
 	if (ret < 0)
-		config_group_put(&opts->func_inst.group);
+		uvcg_config_remove_children(&opts->func_inst.group);
 
 	return ret;
 }


base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
