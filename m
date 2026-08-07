Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D476449B21
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 06:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786083669; cv=none; b=TJAYNAdgN31zph+4OMtd2oX/jHXTBnVKlzi0PM2bCo9XF+ifeUlWcm35mbVg1khmkxZyXjlqyTp6X3DjcGc+Ab7ze1NMel/itscQdjU0oOgNQJaVjCAsCFgznEOBBQ7WBi8H6DUlvd/FkN8RD8gMP2MwTWgtvuVS/ZikFXQ3PsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786083669; c=relaxed/simple;
	bh=KLjsD/LdOEbFSUlHICodEQ9ZiMjhYuAOFwdSAQ3bXxQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=rmzlzXtpEF1KCmjdq7d4s0pnx1qYpWitcv8OelPke85b0JFN6oku7e8fx0CxMDE7KAqh+YCLlGutSjphjnKERKqkgKgjhFfQLEXlizqw6SO6e5tX+ZL+03OfBRgKTT6B4szbZPIUW9VSbUxUia7y70DCmFNdn6nKuu3iR8rm7aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n63PMwXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n63PMwXA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B6DBC1F000E9;
	Fri,  7 Aug 2026 06:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786083667;
	bh=2r7bTDs1NG2Lwy5/c3rw5VgxlQ6g8Dp7NT777G6OWUY=;
	h=From:To:Cc:Subject:Date;
	b=n63PMwXArsRuWhlGGAN/gbTb4BnCp6AkypgLYL2Es347PkamXGbYU3+FsALWbqmPA
	 LvIZ6vuz5oesiCJupKHQMcwNWKYXpK2z3T0hGYiAA2RVrTlWkcJ9Uy487xi/X9fTSa
	 Z+gOqcRI49g35i1sYUrwM07cX0/X31TNIjU/pOzMHsdOKWhbYDvSEak85Ida5SPuZT
	 tXR0r6q03Gf/DrcAJ9GQSjRaDgB/jpkpoSMtyEX7V5l4Kfish5Kxkf0ZObZGfybBGl
	 8iYbPcrCbnPRDXqVC7XZG1n4H6e5ZLO9s6UvWufDPlGjqKUx64KSUxbPs0VSfe4oOt
	 s8qav7JjGluqA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: rc: fix use-after-free in probe error path
Message-ID: <2dca4c07-9078-4e58-a99d-43b7a3b3a9b7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 06:21:07 +0000 (UTC)

In redrat3_dev_probe() and streamzap_probe(), if an error occurs after the
RC device has been successfully registered, the error handling path frees
the parent device structure without unregistering the RC device. This
leaves a dangling RC device registered in sysfs.

When userspace (e.g., udevd) subsequently reads the uevent file of the
dangling RC device, it triggers a use-after-free because the device name
points to the already freed parent structure memory. This results in the
following KASAN report:

BUG: KASAN: slab-use-after-free in string_nocheck lib/vsprintf.c:648
[inline]
BUG: KASAN: slab-use-after-free in string+0x216/0x2d0 lib/vsprintf.c:730
Read of size 1 at addr ffff8881fa2d0758 by task udevd/5037

Call Trace:
 string_nocheck lib/vsprintf.c:648 [inline]
 string+0x216/0x2d0 lib/vsprintf.c:730
 vsnprintf+0x74a/0xef0 lib/vsprintf.c:2945
 add_uevent_var+0x1ce/0x460 lib/kobject_uevent.c:682
 rc_dev_uevent+0x164/0x1a0 drivers/media/rc/rc-main.c:1632
 dev_uevent+0x537/0x870 drivers/base/core.c:2779
 uevent_show+0x1a0/0x310 drivers/base/core.c:2826
 dev_attr_show+0x58/0xc0 drivers/base/core.c:2487
 sysfs_kf_seq_show+0x331/0x490 fs/sysfs/file.c:65

Fix this by adding the missing rc_unregister_device() calls in the error
handling paths of both drivers, ensuring the sysfs interface is safely torn
down before the parent structure is destroyed.

Fixes: 8a21ec9bb3ec ("[media] redrat3: fix error paths in probe")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+237c754233330b2bf565@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=237c754233330b2bf565
Link: https://syzkaller.appspot.com/ai_job?id=aadad1ed-bce5-4fa8-8017-ddbb8433853a
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Sean Young" <sean@mess.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 3f828a564..d2a805dbd 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1111,13 +1111,16 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	/* might be all we need to do? */
 	retval = redrat3_enable_detector(rr3);
 	if (retval < 0)
-		goto led_free;
+		goto rc_free;
 
 	/* we can register the device now, as it is ready */
 	usb_set_intfdata(intf, rr3);
 
 	return 0;
 
+rc_free:
+	rc_unregister_device(rr3->rc);
+	rc_free_device(rr3->rc);
 led_free:
 	led_classdev_unregister(&rr3->led);
 redrat_free:
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 307985d74..41195ad82 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -365,6 +365,7 @@ static int streamzap_probe(struct usb_interface *intf,
 
 	return 0;
 rc_submit_fail:
+	rc_unregister_device(sz->rdev);
 	rc_free_device(sz->rdev);
 	usb_set_intfdata(intf, NULL);
 rc_dev_fail:


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
