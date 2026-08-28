Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599F33B961F
	for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 20:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787949551; cv=none; b=ZdzRXImBq3VvS7YK2m5s4tRwikoiGSdTaKvC9rRBR4s2vUAfOl9h9q8hFtKk2XBodZq5EEFxn7g9U/JmBT2ggmzxJvb3eAafAKAzqDvqm86ZPTgP3KKlVWJ/5FeLh7kuCy4DwkrakSOR+y0TK/f4SFSyd+xe3bBiz8GPfo18XF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787949551; c=relaxed/simple;
	bh=sZUlGmXRgHVZfjh7874KKlH4nNv9G2WYy1PzX+ypYig=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=qSTibU+F5v1yTqth0YNue1MXa6MWmnTG6vuaCohL9EqUM2ZKieqTSaC2OXQmOKiGOlbyKoFQJWzi7bVmRFDHHrgzKkUweD7xJ1c31TiGnwBX6NHJo9DijaPuXukTyBZPFFuqF+8zBja5tTImJImmJcY8QSDkY7VQCTSl3sGbtNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChAWiVNK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChAWiVNK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E1CB11F000E9;
	Fri, 28 Aug 2026 20:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787949549;
	bh=TGKL52o9jeWwhNA7mANOGdxw8u7NziOtmCd8ycG/Sa8=;
	h=From:To:Cc:Subject:Date;
	b=ChAWiVNKh3k3BWVT2ebtp9xt0I7KdLovR330BbE79un6ulsyY4tjAed9M0P2HtlYW
	 HV5RifUAc+W9kQhFXqj2QIhrPWXeNtFWCopHBENkI+mv3xY8iJpTdnje6Bs/gD0CXt
	 GzoCJ9Qb4busZwTBfwNNcS3m/76ETWhD2JWJMpAIoZLItZDFw/NjEj1BPGuBqZnbRU
	 p4HoV1MOi4y/SoEFH5rcwlUriRvWgTnUdcgiiKSCQebT319V8y7yQE3cx5w4yOKPZW
	 EqMYPVRdm2T+MMM+qvmsJv0RNcQwTZfUz8X2mwhXoGdyXPgLKKURFQya7B44FmMpGp
	 seimfTtkWW4ww==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb-storage: alauda: Fix null-ptr-deref and divide-by-zero errors
Message-ID: <c8b7e322-fe84-4bcf-9eaa-b222cb88d678@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 28 Aug 2026 20:39:08 +0000 (UTC)

In alauda_read_data() and alauda_write_lba(), alauda_ensure_map_for_zone()
is called to ensure that the zone block mapping tables (lba_to_pba and
pba_to_lba) are initialized and populated. However,
alauda_ensure_map_for_zone() had a void return type and ignored the return
value of alauda_read_map(). When alauda_read_map() failed (such as on USB
transfer error or memory allocation failure),
MEDIA_INFO(us).lba_to_pba[zone] remained NULL. Subsequent accesses to
MEDIA_INFO(us).lba_to_pba[zone][lba_offset] resulted in a NULL pointer
dereference:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
RIP: 0010:alauda_read_data drivers/usb/storage/alauda.c:972 [inline]
RIP: 0010:alauda_transport+0xd68/0x43a0 drivers/usb/storage/alauda.c:1187
Call Trace:
 <TASK>
 usb_stor_invoke_transport+0x115/0x1a70 drivers/usb/storage/transport.c:611
 usb_stor_control_thread+0x44c/0x8f0 drivers/usb/storage/usb.c:462
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x491/0xad0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Additionally, commit 16637fea001a ("usb-storage: alauda: Check whether the
media is initialized") added the media_initialized flag to struct
alauda_info. Because Alauda card readers support two independent media
ports (xD and SmartMedia) mapped to LUN 0 and LUN 1, setting the flag on
the shared device structure upon initializing LUN 0 caused
alauda_check_media() to skip calling alauda_init_media() when handling
requests for LUN 1. Consequently, port 1's uzonesize remained 0, causing a
divide-by-zero error (lba / uzonesize) in alauda_read_data(),
alauda_write_lba(), and alauda_write_data(). Furthermore,
alauda_read_data() calculated lba / uzonesize and invoked
alauda_ensure_map_for_zone() before validating whether lba exceeded
max_lba.

Fix these issues by:
- Moving the media_initialized boolean from struct alauda_info to struct
alauda_media_info so that each port's initialization status is tracked
independently, and clearing it when media absence or removal is detected.
- Updating alauda_ensure_map_for_zone() to return an error status code,
verifying that mapping table pointers are non-NULL, and propagating the
result of alauda_read_map().
- Checking the return code of alauda_ensure_map_for_zone() in
alauda_read_data() and alauda_write_lba() and aborting the transfer on
failure.
- Adding sanity checks for uzonesize before division operations in
alauda_read_data(), alauda_write_lba(), and alauda_write_data(), and
performing the lba >= max_lba check before zone calculation in
alauda_read_data().
- Freeing top-level mapping arrays and resetting capacity and uzonesize in
alauda_free_maps(), and ensuring alauda_free_maps() is called on error
paths in alauda_init_media().

Fixes: e80b0fade09e ("[PATCH] USB Storage: add alauda support")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+ccc9a7cb39fa1af827ea@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ccc9a7cb39fa1af827ea
Link: https://syzkaller.appspot.com/ai_job?id=f19433e4-a93f-4b85-a1da-d33b9943d037
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
To: <usb-storage@lists.one-eyed-alien.net>
To: "Matthew Dharm" <mdharm-usb@one-eyed-alien.net>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 691fe4700..a2a333419 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -96,6 +96,8 @@ struct alauda_media_info {
 
 	u16 **lba_to_pba;		/* logical to physical block map */
 	u16 **pba_to_lba;		/* physical to logical block map */
+
+	bool media_initialized;
 };
 
 struct alauda_info {
@@ -105,8 +107,6 @@ struct alauda_info {
 	unsigned char sense_key;
 	unsigned long sense_asc;	/* additional sense code */
 	unsigned long sense_ascq;	/* additional sense code qualifier */
-
-	bool media_initialized;
 };
 
 #define short_pack(lsb,msb) ( ((u16)(lsb)) | ( ((u16)(msb))<<8 ) )
@@ -290,17 +290,25 @@ static void alauda_free_maps (struct alauda_media_info *media_info)
 	unsigned int num_zones = media_info->capacity >> shift;
 	unsigned int i;
 
-	if (media_info->lba_to_pba != NULL)
+	if (media_info->lba_to_pba != NULL) {
 		for (i = 0; i < num_zones; i++) {
 			kfree(media_info->lba_to_pba[i]);
 			media_info->lba_to_pba[i] = NULL;
 		}
+		kfree(media_info->lba_to_pba);
+		media_info->lba_to_pba = NULL;
+	}
 
-	if (media_info->pba_to_lba != NULL)
+	if (media_info->pba_to_lba != NULL) {
 		for (i = 0; i < num_zones; i++) {
 			kfree(media_info->pba_to_lba[i]);
 			media_info->pba_to_lba[i] = NULL;
 		}
+		kfree(media_info->pba_to_lba);
+		media_info->pba_to_lba = NULL;
+	}
+	media_info->capacity = 0;
+	media_info->uzonesize = 0;
 }
 
 /*
@@ -441,11 +449,15 @@ static int alauda_init_media(struct us_data *us)
 		+ MEDIA_INFO(us).blockshift + MEDIA_INFO(us).pageshift);
 	MEDIA_INFO(us).pba_to_lba = kcalloc(num_zones, sizeof(u16*), GFP_NOIO);
 	MEDIA_INFO(us).lba_to_pba = kcalloc(num_zones, sizeof(u16*), GFP_NOIO);
-	if (MEDIA_INFO(us).pba_to_lba == NULL || MEDIA_INFO(us).lba_to_pba == NULL)
+	if (MEDIA_INFO(us).pba_to_lba == NULL || MEDIA_INFO(us).lba_to_pba == NULL) {
+		alauda_free_maps(&MEDIA_INFO(us));
 		return USB_STOR_TRANSPORT_ERROR;
+	}
 
-	if (alauda_reset_media(us) != USB_STOR_XFER_GOOD)
+	if (alauda_reset_media(us) != USB_STOR_XFER_GOOD) {
+		alauda_free_maps(&MEDIA_INFO(us));
 		return USB_STOR_TRANSPORT_ERROR;
+	}
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
@@ -457,6 +469,7 @@ static int alauda_init_media(struct us_data *us)
 static int alauda_check_media(struct us_data *us)
 {
 	struct alauda_info *info = (struct alauda_info *) us->extra;
+	struct alauda_media_info *media_info = &MEDIA_INFO(us);
 	unsigned char *status = us->iobuf;
 	int rc;
 
@@ -470,7 +483,8 @@ static int alauda_check_media(struct us_data *us)
 	if ((status[0] & 0x80) || ((status[0] & 0x1F) == 0x10)
 		|| ((status[1] & 0x01) == 0)) {
 		usb_stor_dbg(us, "No media, or door open\n");
-		alauda_free_maps(&MEDIA_INFO(us));
+		alauda_free_maps(media_info);
+		media_info->media_initialized = false;
 		info->sense_key = 0x02;
 		info->sense_asc = 0x3A;
 		info->sense_ascq = 0x00;
@@ -478,12 +492,13 @@ static int alauda_check_media(struct us_data *us)
 	}
 
 	/* Check for media change */
-	if (status[0] & 0x08 || !info->media_initialized) {
+	if (status[0] & 0x08 || !media_info->media_initialized) {
 		usb_stor_dbg(us, "Media change detected\n");
-		alauda_free_maps(&MEDIA_INFO(us));
+		alauda_free_maps(media_info);
+		media_info->media_initialized = false;
 		rc = alauda_init_media(us);
 		if (rc == USB_STOR_TRANSPORT_GOOD)
-			info->media_initialized = true;
+			media_info->media_initialized = true;
 		info->sense_key = UNIT_ATTENTION;
 		info->sense_asc = 0x28;
 		info->sense_ascq = 0x00;
@@ -689,11 +704,16 @@ static int alauda_read_map(struct us_data *us, unsigned int zone)
  * Checks to see whether we have already mapped a certain zone
  * If we haven't, the map is generated
  */
-static void alauda_ensure_map_for_zone(struct us_data *us, unsigned int zone)
+static int alauda_ensure_map_for_zone(struct us_data *us, unsigned int zone)
 {
+	if (!MEDIA_INFO(us).lba_to_pba || !MEDIA_INFO(us).pba_to_lba)
+		return USB_STOR_TRANSPORT_ERROR;
+
 	if (MEDIA_INFO(us).lba_to_pba[zone] == NULL
 		|| MEDIA_INFO(us).pba_to_lba[zone] == NULL)
-		alauda_read_map(us, zone);
+		return alauda_read_map(us, zone);
+
+	return USB_STOR_TRANSPORT_GOOD;
 }
 
 /*
@@ -819,11 +839,19 @@ static int alauda_write_lba(struct us_data *us, u16 lba,
 	unsigned int zonesize = MEDIA_INFO(us).zonesize;
 	unsigned int pagesize = MEDIA_INFO(us).pagesize;
 	unsigned int blocksize = MEDIA_INFO(us).blocksize;
-	unsigned int lba_offset = lba % uzonesize;
+	unsigned int lba_offset;
 	unsigned int new_pba_offset;
-	unsigned int zone = lba / uzonesize;
+	unsigned int zone;
 
-	alauda_ensure_map_for_zone(us, zone);
+	if (!uzonesize)
+		return USB_STOR_TRANSPORT_ERROR;
+
+	lba_offset = lba % uzonesize;
+	zone = lba / uzonesize;
+
+	result = alauda_ensure_map_for_zone(us, zone);
+	if (result != USB_STOR_TRANSPORT_GOOD)
+		return result;
 
 	pba = MEDIA_INFO(us).lba_to_pba[zone][lba_offset];
 	if (pba == 1) {
@@ -927,6 +955,9 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 	struct scatterlist *sg;
 	int result;
 
+	if (!uzonesize)
+		return USB_STOR_TRANSPORT_ERROR;
+
 	/*
 	 * Since we only read in one block at a time, we have to create
 	 * a bounce buffer and move the data a piece at a time between the
@@ -950,11 +981,10 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 	sg = NULL;
 
 	while (sectors > 0) {
-		unsigned int zone = lba / uzonesize; /* integer division */
-		unsigned int lba_offset = lba - (zone * uzonesize);
+		unsigned int zone;
+		unsigned int lba_offset;
 		unsigned int pages;
 		u16 pba;
-		alauda_ensure_map_for_zone(us, zone);
 
 		/* Not overflowing capacity? */
 		if (lba >= max_lba) {
@@ -964,6 +994,13 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 			break;
 		}
 
+		zone = lba / uzonesize; /* integer division */
+		lba_offset = lba - (zone * uzonesize);
+
+		result = alauda_ensure_map_for_zone(us, zone);
+		if (result != USB_STOR_TRANSPORT_GOOD)
+			break;
+
 		/* Find number of pages we can read in this block */
 		pages = min(sectors, blocksize - page);
 		len = pages << pageshift;
@@ -1021,6 +1058,9 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 	u16 lba, max_lba;
 	int result;
 
+	if (!MEDIA_INFO(us).uzonesize)
+		return USB_STOR_TRANSPORT_ERROR;
+
 	/*
 	 * Since we don't write the user data directly to the device,
 	 * we have to create a bounce buffer and move the data a piece


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
