Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9220E3C872A
	for <syzbot@lists.linux.dev>; Wed,  9 Sep 2026 19:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788982813; cv=none; b=uwTkPQJYyM/e782xgk5+bjur1nUEU52LwPHKRBwX+OUPdbountC2SH+AtjJ7At7HsAw3IJXIK/mO2sBUpJvd8s3dFJqu6czx2KPbww2iV15tcH7CKsJlc89tGpF1nTDV90eCRxnB2koW9oZl7CZjIhbPkTzRUeRsFrjhwXTDTfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788982813; c=relaxed/simple;
	bh=+GArvpOUjmpdJ48VG4Jzv9mX7mfysJirrLdiV9PO6vs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ILNv4Fmb4Y9y/visbgHmu/82cH5UE0Eof3NIn7Ctgi9JHUUGltRLPdgfHlaXJMlS1KCPfvA9Pzem/1D5i830yGUoLllicuxTXa744ksYafstmywC4EDHDQzbbDx7x6kfSr+Y64Sd/b0J40MLhXbvdIN/w4VaguPiKLZYBUsd/70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMvnUKEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMvnUKEr"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2622C1F00893;
	Wed,  9 Sep 2026 19:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788982811;
	bh=bpN93r17/4nADWY/aVZMjwxLvZa6oYPc7sANka+SKpE=;
	h=From:To:Cc:Subject:Date;
	b=nMvnUKErOkOsmhPwSp20Nhc0PtjjzByT71VtJp3Gm/g+Z/Hre1fkbHFk3/VYgNf8L
	 AOb4+P23j7gPPQ5tlqUCuRk9o3PTP5/zWhPKGxKe6C4ddQGKzmqrEr+JLI5tlNnSYD
	 Hx3A+ejWvmHU/+3LFXHkhJxkgfEDHWjUOAW4s9ppyGYtEU4XCLbd0/+hP/XV8uY8WM
	 Nzf/+OtVTfLBj3sRwGbcn9fRnnfEGHix7l8Ps+f/4gK0SYxXZ7Q60Lp/VE9WGtjBe1
	 u5Q8PtrbeV8ZirIjLBoSp2rKum/F1BGs+ggyueW4k/+8Q3Dh68iCn260nCt09JrsL0
	 06nPNiX7BqSWA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] scsi: sg: Validate scatter_elem_sz module parameter
Message-ID: <30c58052-61b7-4425-9fd7-c188a0bef4ea@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  9 Sep 2026 19:40:11 +0000 (UTC)

Writing an invalid value such as 0 to
/sys/module/sg/parameters/scatter_elem_sz causes a shift-out-of-bounds bug
during subsequent device operations. When opening a device via sg_open(),
the driver calls sg_build_indirect() to allocate scatter-gather buffers. In
sg_build_indirect(), the code checks if the local variable num is less than
PAGE_SIZE and updates the global scatter_elem_sz and scatter_elem_sz_prev
variables, but fails to update num. As a result, num remains 0 and is
passed to order = get_order(num). Calling get_order(0) is undefined and
underflows to 52 on 64-bit systems, causing ret_sz = 1 << (PAGE_SHIFT +
order) to compute 1 << 64. Shifting a 32-bit int by 64 bits triggers a
UBSAN shift-out-of-bounds warning:

UBSAN: shift-out-of-bounds in drivers/scsi/sg.c:1887:13
shift exponent 64 is too large for 32-bit type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
 sg_build_indirect+0x559/0x870 drivers/scsi/sg.c:1887
 sg_build_reserve drivers/scsi/sg.c:1997 [inline]
 sg_add_sfp drivers/scsi/sg.c:2177 [inline]
 sg_open+0x1128/0x18a0 drivers/scsi/sg.c:349
 chrdev_open+0x4d9/0x600 fs/char_dev.c:411
 do_dentry_open+0x816/0x1380 fs/open.c:996
 vfs_open+0x3b/0x340 fs/open.c:1101
 </TASK>

Additionally, excessively large values written to scatter_elem_sz can cause
order to exceed MAX_PAGE_ORDER, which can overflow signed 32-bit arithmetic
and trigger warnings in the page allocator. Mutating global variables
scatter_elem_sz and scatter_elem_sz_prev inside the I/O path without
locking also introduces data races between concurrent device accesses.

Fix this by replacing module_param_named() with module_param_cb() for
scatter_elem_sz, similar to def_reserved_size. The setter callback
scatter_elem_sz_set() validates that the input value is within [PAGE_SIZE,
PAGE_SIZE << MAX_PAGE_ORDER], rejecting invalid values with -ERANGE or
-EINVAL at the sysfs boundary. Remove scatter_elem_sz_prev and the runtime
parameter modification from sg_build_indirect(), compute the allocation
order directly from scatter_elem_sz, and simplify the per-element size
calculation using min(rem_sz, ret_sz).

Fixes: 10db10d144c0 ("sg: convert the indirect IO path to use the block layer")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
Link: https://syzkaller.appspot.com/ai_job?id=4512b081-e607-45b8-8a53-4eefe3737482
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Doug Gilbert" <dgilbert@interlog.com>
To: <linux-scsi@vger.kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e..4c82fc00d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -92,7 +92,6 @@ static int def_reserved_size = SG_DEF_RESERVED_SIZE;
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
-static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
 #define SG_SECTOR_SZ 512
 
@@ -1621,9 +1620,33 @@ sg_remove_device(struct device *cl_dev)
 	kref_put(&sdp->d_ref, sg_device_destroy);
 }
 
-module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
 module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
 
+static int scatter_elem_sz_set(const char *val, const struct kernel_param *kp)
+{
+	int size, ret;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtoint(val, 0, &size);
+	if (ret)
+		return ret;
+
+	if (size < PAGE_SIZE || size > (PAGE_SIZE << MAX_PAGE_ORDER))
+		return -ERANGE;
+
+	scatter_elem_sz = size;
+	return 0;
+}
+
+static const struct kernel_param_ops scatter_elem_sz_ops = {
+	.set	= scatter_elem_sz_set,
+	.get	= param_get_int,
+};
+
+module_param_cb(scatter_elem_sz, &scatter_elem_sz_ops, &scatter_elem_sz, 0644);
+
 static int def_reserved_size_set(const char *val, const struct kernel_param *kp)
 {
 	int size, ret;
@@ -1667,10 +1690,8 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
+	if (scatter_elem_sz < PAGE_SIZE)
 		scatter_elem_sz = PAGE_SIZE;
-		scatter_elem_sz_prev = scatter_elem_sz;
-	}
 
 	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), 
 				    SG_MAX_DEVS, "sg");
@@ -1873,36 +1894,19 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	if (mx_sc_elems < 0)
 		return mx_sc_elems;	/* most likely -ENOMEM */
 
-	num = scatter_elem_sz;
-	if (unlikely(num != scatter_elem_sz_prev)) {
-		if (num < PAGE_SIZE) {
-			scatter_elem_sz = PAGE_SIZE;
-			scatter_elem_sz_prev = PAGE_SIZE;
-		} else
-			scatter_elem_sz_prev = num;
-	}
-
-	order = get_order(num);
+	order = get_order(scatter_elem_sz);
 retry:
 	ret_sz = 1 << (PAGE_SHIFT + order);
 
 	for (k = 0, rem_sz = blk_size; rem_sz > 0 && k < mx_sc_elems;
 	     k++, rem_sz -= ret_sz) {
 
-		num = (rem_sz > scatter_elem_sz_prev) ?
-			scatter_elem_sz_prev : rem_sz;
+		num = min(rem_sz, ret_sz);
 
 		schp->pages[k] = alloc_pages(gfp_mask, order);
 		if (!schp->pages[k])
 			goto out;
 
-		if (num == scatter_elem_sz_prev) {
-			if (unlikely(ret_sz > scatter_elem_sz_prev)) {
-				scatter_elem_sz = ret_sz;
-				scatter_elem_sz_prev = ret_sz;
-			}
-		}
-
 		SCSI_LOG_TIMEOUT(5, sg_printk(KERN_INFO, sfp->parentdp,
 				 "sg_build_indirect: k=%d, num=%d, ret_sz=%d\n",
 				 k, num, ret_sz));


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
