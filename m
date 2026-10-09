Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3554370ADF
	for <syzbot@lists.linux.dev>; Fri,  9 Oct 2026 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791590216; cv=none; b=CJtSSfaTqVwy7JOFYTm5iU58Iihu/8c6pqmtOK/0mae7h5kL0gv7A5jPOX5UQx65ERtTSLWQnynKYkuL77pOvkn9ufQZ4XqYRzIq637W2eQZwYzBzAVdjYeI1NXYp6D5o2Xx0U7JTVfq5aSpDoM/HPfc6ldl1WOiek9y8xNJ5Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791590216; c=relaxed/simple;
	bh=0USePrZ/yczKbxArrUyh3VYFtOmatjpYDXThMruDDhI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ooCQTbAHkCLeQMGE8bcJ4wXDz4R1L30xmcjMgpDY10UYY+cVRGXNrNgFnBxtaUnJ3OexVfW2mJWlchAppnJtaDVGLYLZDd1IP6PM+ZIb9+5Nw7jmQDmzaPdhr3YILqhYb/mKHcUlaaXCL2qmS8G/15D99gH3ecykmazWWtw30ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jv+73NWY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jv+73NWY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0CDEA1F000FF;
	Fri,  9 Oct 2026 23:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791590215;
	bh=EbSmETMo4gzh599xUtVga5nAsYn31/UHYW60qWDVaXA=;
	h=From:To:Cc:Subject:Date;
	b=jv+73NWY/JP4PGVI8XQ8pkdM26cj6xv6w3YNzsS/V+OWnoNX33srbD3l5C4g/1Rtg
	 IOuS+TGGjotlYNM51bjcOexqQnVzepdl8fksmusxelxnJw25My4FZS5L0hN2afiUd3
	 uZOn0YIZGOutjnhYbEsQ5IbWnX3x450mutotJQRI0/0D5ONPwowLu8zmdeK1aE/PeB
	 haiWgrnN3141rLhZ09VZ/OLA2bod1mgddaA1wrbjZ9vqbQIId7wLA9eTljGxsyrknI
	 HVN3HHxZt0ZLT08lhrPJGTm2qS+hsDD7djaCkPEvmsCx7Be64Eeit2AcLQTMoLeWNP
	 1XzDm7cM1QaXg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] media: dvb_frontend: fix OOB read in dtv_property_process_get()
Message-ID: <a7a95e8f-6160-4bed-a950-43c578958049@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  9 Oct 2026 23:56:54 +0000 (UTC)

In dtv_property_process_get(), properties requested via the FE_GET_PROPERTY
ioctl are processed and copied back to userspace. In struct dtv_property,
member u is a union containing __u32 data, struct dtv_fe_stats st, and
struct buffer (which has __u8 data[32] followed by __u32 len at offset 32).
Commit 60f0618d157b ("media: dvb-core: frontend: make GET/SET safer")
introduced an out-of-bounds read and a data corruption issue due to
mishandling this union.

For commands that only set tvp->u.data (such as DTV_FREQUENCY),
tvp->u.buffer.len is never initialized by the kernel and retains whatever
value userspace passed into the ioctl. At the end of
dtv_property_process_get(), dev_dbg() unconditionally formatted the
property using "%*ph", passing tvp->u.buffer.len as the field width and
tvp->u.buffer.data as the buffer pointer. When dynamic debug is enabled and
userspace supplies a large length value, vsprintf() emits a field width out
of range warning, and hex_string() clamps the length to 64 bytes. Since
struct dtv_property is 76 bytes long and u.buffer.data starts at offset 16,
reading 64 bytes reaches offset 80 (4 bytes past the end of the slab
object), triggering a KASAN slab-out-of-bounds read:

field width 1163001896 out of range
WARNING: lib/vsprintf.c:2654 at vsnprintf+0xb9c/0xd10 lib/vsprintf.c:2918
Call trace:
 set_field_width lib/vsprintf.c:2654 [inline]
 vsnprintf+0xb9c/0xd10 lib/vsprintf.c:2918
 pointer+0x5e8/0x6b4 lib/vsprintf.c:2577
 vsnprintf+0x618/0xd10 lib/vsprintf.c:2953
 dev_vprintk_emit+0x2ec/0x3b4 drivers/base/core.c:5000
 dev_printk_emit+0xe0/0x130 drivers/base/core.c:5011
 __dynamic_dev_dbg+0x1b4/0x254 lib/dynamic_debug.c:904
 dtv_property_process_get+0x26bc/0x2838
 drivers/media/dvb-core/dvb_frontend.c:1595
 dvb_get_property drivers/media/dvb-core/dvb_frontend.c:2397 [inline]
 dvb_frontend_handle_ioctl+0x1644/0x2424
 drivers/media/dvb-core/dvb_frontend.c:2478
 dvb_frontend_do_ioctl+0x124/0x278
 drivers/media/dvb-core/dvb_frontend.c:2101
 dvb_usercopy+0x2a4/0x4d4 drivers/media/dvb-core/dvbdev.c:996
 dvb_frontend_ioctl+0x68/0x8c drivers/media/dvb-core/dvb_frontend.c:2115
BUG: KASAN: slab-out-of-bounds in hex_string+0x274/0x364
lib/vsprintf.c:1209
Read of size 1 at addr ffff0000c240314c

Additionally, commit 60f0618d157b added bounds checks that clamped
tvp->u.buffer.len in all eight DTV_STAT_* cases. However, DTV_STAT_*
commands populate tvp->u.st (struct dtv_fe_stats). In union u, u.buffer.len
is located at offset 32, which directly overlaps bytes 3 to 6 of
tvp->u.st.stat[3].uvalue (layer C statistics). Clamping and overwriting
tvp->u.buffer.len therefore silently corrupted the statistics returned to
userspace.

Fix this by formatting with "%*ph" using tvp->u.buffer.len and
tvp->u.buffer.data when tvp->cmd == DTV_ENUM_DELSYS, formatting tvp->u.st
for DTV_STAT_* commands, and formatting tvp->u.data as "= 0x%08x" for all
other commands. Furthermore, remove the bogus bounds clamping of
tvp->u.buffer.len and the unused len variable from all DTV_STAT_* cases to
prevent corruption of frontend statistics.

Fixes: 60f0618d157b ("media: dvb-core: frontend: make GET/SET safer")

Fixes: 60f0618d157b ("media: dvb-core: frontend: make GET/SET safer")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+6102f1c3a0ea8073fd64@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6102f1c3a0ea8073fd64
Link: https://syzkaller.appspot.com/ai_job?id=d2df895b-f169-41a7-b454-a604fb666c9b
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
Cc: "Hans Verkuil" <hverkuil+cisco@kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Ricardo Ribalda" <ribalda@chromium.org>

---
v2:
- Format tvp->u.st with "%*ph" for DTV_STAT_* commands in dev_dbg()

v1:
https://lore.kernel.org/all/2a5ea27d-445e-4ffe-9447-9d7bfccd4a36@mail.kernel.org/T/
---
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 0286da57f..7b9596396 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1348,7 +1348,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 				    struct file *file)
 {
 	int ncaps;
-	unsigned int len = 1;
 
 	switch (tvp->cmd) {
 	case DTV_ENUM_DELSYS:
@@ -1358,7 +1357,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 			ncaps++;
 		}
 		tvp->u.buffer.len = ncaps;
-		len = ncaps;
 		break;
 	case DTV_FREQUENCY:
 		tvp->u.data = c->frequency;
@@ -1536,51 +1534,27 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 	/* Fill quality measures */
 	case DTV_STAT_SIGNAL_STRENGTH:
 		tvp->u.st = c->strength;
-		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
-			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
-		len = tvp->u.buffer.len;
 		break;
 	case DTV_STAT_CNR:
 		tvp->u.st = c->cnr;
-		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
-			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
-		len = tvp->u.buffer.len;
 		break;
 	case DTV_STAT_PRE_ERROR_BIT_COUNT:
 		tvp->u.st = c->pre_bit_error;
-		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
-			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
-		len = tvp->u.buffer.len;
 		break;
 	case DTV_STAT_PRE_TOTAL_BIT_COUNT:
 		tvp->u.st = c->pre_bit_count;
-		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
-			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
-		len = tvp->u.buffer.len;
 		break;
 	case DTV_STAT_POST_ERROR_BIT_COUNT:
 		tvp->u.st = c->post_bit_error;
-		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
-			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
-		len = tvp->u.buffer.len;
 		break;
 	case DTV_STAT_POST_TOTAL_BIT_COUNT:
 		tvp->u.st = c->post_bit_count;
-		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
-			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
-		len = tvp->u.buffer.len;
 		break;
 	case DTV_STAT_ERROR_BLOCK_COUNT:
 		tvp->u.st = c->block_error;
-		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
-			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
-		len = tvp->u.buffer.len;
 		break;
 	case DTV_STAT_TOTAL_BLOCK_COUNT:
 		tvp->u.st = c->block_count;
-		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
-			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
-		len = tvp->u.buffer.len;
 		break;
 	default:
 		dev_dbg(fe->dvb->device,
@@ -1589,13 +1563,25 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	if (len < 1)
-		len = 1;
-
-	dev_dbg(fe->dvb->device,
-		"%s: GET cmd 0x%08x (%s) len %d: %*ph\n",
-		__func__, tvp->cmd, dtv_cmd_name(tvp->cmd),
-		tvp->u.buffer.len, tvp->u.buffer.len, tvp->u.buffer.data);
+	if (tvp->cmd == DTV_ENUM_DELSYS) {
+		dev_dbg(fe->dvb->device,
+			"%s: GET cmd 0x%08x (%s) len %d: %*ph\n",
+			__func__, tvp->cmd, dtv_cmd_name(tvp->cmd),
+			tvp->u.buffer.len, tvp->u.buffer.len,
+			tvp->u.buffer.data);
+	} else if (tvp->cmd >= DTV_STAT_SIGNAL_STRENGTH &&
+		   tvp->cmd <= DTV_STAT_TOTAL_BLOCK_COUNT) {
+		dev_dbg(fe->dvb->device,
+			"%s: GET cmd 0x%08x (%s) len %d: %*ph\n",
+			__func__, tvp->cmd, dtv_cmd_name(tvp->cmd),
+			(int)sizeof(tvp->u.st), (int)sizeof(tvp->u.st),
+			&tvp->u.st);
+	} else {
+		dev_dbg(fe->dvb->device,
+			"%s: GET cmd 0x%08x (%s) = 0x%08x\n",
+			__func__, tvp->cmd, dtv_cmd_name(tvp->cmd),
+			tvp->u.data);
+	}
 
 	return 0;
 }


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
