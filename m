Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E445339D6C8
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 09:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785748092; cv=none; b=umTlF2ISw6s75JtEWzhIywBTlHFEakqpQ92nRVnfPRBl5veKaHgY9+g4Bhawa/ETmE6LHvEvtIwfnGMLEpj+MGUiDeAnpmUfy5WPD2RUYzcysWNG/eBLeDtvbLL/sYooPd9culIeG17JvUvQGU1vSlSQArHmJ757mkGqaXTAcqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785748092; c=relaxed/simple;
	bh=Rk3T6U4+fLoe5B6qv970U9fO+ySoOp2PT3Uwjrlrx68=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=GpTmAghAo7BA5lQCRAHcG4DzKqG94CbZoiuu0x4pGJ0s781odkTE4kKyJ1ZirQ/kFBO5rh5BM8z65aMfSR7e+iLVRLZ+eTnyYYicmAjEHQ8kXPrsSh6Tvw41oe50jjSLZTamKKJQCzuoXFNpXBuiWaYhHtenQjTfdCyAAqerl8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDR8PjJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDR8PjJY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 83C3C1F000E9;
	Mon,  3 Aug 2026 09:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785748090;
	bh=wDU7z2ItcnJK4BHfvyBZ4buGzo2scvkrsyngtm/T2vk=;
	h=From:To:Cc:Subject:Date;
	b=fDR8PjJYoy3XWjkVjb8aMxm/iXy90WRGnIPLXkhH7luJksXa/ayXI4uFtwfn1If3g
	 WFjV2uP15QxV888kqRlAehTuAgGStJP/uv4MSMzbZa8lbYGHPZARoIhnyhtkLrthPE
	 1lg7UMQI7Gp3GIF/ooMsVruGawgWYmHcJ+8y6h8r/Un15v9i+jBKYst4KVPZiejDIH
	 aCH/x7HBXhmW2Ze/+l8UW+lWQb3ayRiFfgZSIHFWS0EdmVhj7prN3May1409blRWPL
	 KcCM3mc/PJ5Nx0wbP7TgX8FIL7DG4gCsgNyVHZquqVmSxJLwLoV+bR93ygvqdjLcAi
	 MuoyaXGi5JyvA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ihex: Fix integer underflow and out-of-bounds read
Message-ID: <3f9e6afb-f025-4ae5-a5d6-b8a9972a127a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon,  3 Aug 2026 09:08:10 +0000 (UTC)

When loading a 0-byte firmware, ihex_validate_fw() calculates the end
pointer by subtracting sizeof(*end) from fw->size. Since fw->size is 0,
this results in an integer underflow, making end a huge pointer far past
the end of the buffer. The validation loop then executes with a NULL rec
pointer, leading to a NULL pointer dereference when ihex_binrec_size()
attempts to read rec->len.

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
...
RIP: 0010:ihex_binrec_size include/linux/ihex.h:26 [inline]
RIP: 0010:__ihex_next_binrec include/linux/ihex.h:35 [inline]
RIP: 0010:ihex_validate_fw include/linux/ihex.h:54 [inline]
RIP: 0010:request_ihex_firmware include/linux/ihex.h:74 [inline]
RIP: 0010:emi26_load_firmware drivers/usb/misc/emi26.c:86 [inline]
RIP: 0010:emi26_probe+0x283/0x1690 drivers/usb/misc/emi26.c:232

Additionally, if a firmware file consists only of the 6-byte EOF record,
ihex_validate_fw() successfully validates it. However, when iterating over
the records, ihex_next_binrec() blindly advances past the current record.
If the current record is the EOF record, __ihex_next_binrec() advances the
pointer past the end of the firmware buffer, and the subsequent read of
rec->len results in an out-of-bounds read.

Fix both issues by adding a size check in ihex_validate_fw() to ensure the
firmware is at least large enough to contain a single IHEX record, and by
updating ihex_next_binrec() to check the current record's length before
advancing so it returns NULL immediately when encountering the EOF record.

Fixes: bacfe09dd754 ("ihex.h: binary representation of ihex records")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+baf3cbba7dd980984f0d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=baf3cbba7dd980984f0d
Link: https://syzkaller.appspot.com/ai_job?id=a0c10e66-d30e-44f1-8ad1-c7f25ff69b04
To: <linux-kernel@vger.kernel.org>
To: "David Woodhouse" <dwmw2@infradead.org>

---
diff --git a/include/linux/ihex.h b/include/linux/ihex.h
index b824877e6..4ee4b5960 100644
--- a/include/linux/ihex.h
+++ b/include/linux/ihex.h
@@ -38,9 +38,13 @@ __ihex_next_binrec(const struct ihex_binrec *rec)
 static inline const struct ihex_binrec *
 ihex_next_binrec(const struct ihex_binrec *rec)
 {
-	rec = __ihex_next_binrec(rec);
+	const struct ihex_binrec *next;
 
-	return be16_to_cpu(rec->len) ? rec : NULL;
+	if (!be16_to_cpu(rec->len))
+		return NULL;
+
+	next = __ihex_next_binrec(rec);
+	return be16_to_cpu(next->len) ? next : NULL;
 }
 
 /* Check that ihex_next_binrec() won't take us off the end of the image... */
@@ -48,6 +52,9 @@ static inline int ihex_validate_fw(const struct firmware *fw)
 {
 	const struct ihex_binrec *end, *rec;
 
+	if (fw->size < sizeof(*end))
+		return -EINVAL;
+
 	rec = (const void *)fw->data;
 	end = (const void *)&fw->data[fw->size - sizeof(*end)];
 


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
