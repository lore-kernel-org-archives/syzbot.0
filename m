Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D558740B119
	for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 08:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789374548; cv=none; b=LxwswzV8Dvtkpae/yWOVh7VlbeRNDvoxNdO/utKLTde1/V0deDu/LWeMCYAUbHDqQp78iyFqBbk3ED3pWUon1odqGogcnwD0VQlCaBaP8ZFJBe1mRpPNqxjbM6QzN7jG8ny4TtGrts+ptCoKwMEYPF0TtQB6B33Zna1bqRXjoL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789374548; c=relaxed/simple;
	bh=jnFFH0krT0X5/tnQTm7G5nPnyYVbfQAv8TIN0avP+l0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=feM/kIML9VW+84Q4eHyvdZPIg3Z45T7BX82/JpXXwMIEspi3mtDCBH0CRKTHvEOc23BGetOM8XHsndah+OypSke9TfJfZQyFjVN62PW+N0CTIcwNrrYKZCQam5fsYm2KG/FiZn5WvpltRyqXw0GRChjaKrDmi0lvtvjLUMVQRDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/UegGpP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/UegGpP"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9B7871F000FF;
	Mon, 14 Sep 2026 08:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789374545;
	bh=LLLHLLb4zSb9ABoX0eTxPUu1sCkR3/nrxqWgntUbY0g=;
	h=From:To:Cc:Subject:Date;
	b=F/UegGpPbgspwsOXk9ZiyJ5juCvegv7EqkTfa5KzLODTsVuLz63NMElQvieWsjJ1j
	 MbyIQdw0cxkWQxnuYH9QHRD3ph6+mcBTd+Zi3Te0eTxVsGDoqazwYmrmvF2u3CqTO5
	 TS20jOCY0Sm48+AdbrNMdUvsuhwOTZ2HO8woj+D+CinN9lr4DkIrkSYqdt9gmXwGD8
	 39+riuw0EyAXqJ2DGsbBJpDxPTlxLUwnFS60IxEcd2JCZr7ExBrlywhqAaA02n3m5V
	 hhMqc4Mztb1LrF7J9xPQYFkZ0RL2dlYrgrW966lUvPAqzrYPIlI12xG6RFEEGAobNY
	 pnDMoKfu7GEfQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] scsi: sg: Fix shift-out-of-bounds in sg_build_indirect()
Message-ID: <4c6c124f-f448-4854-b8dd-9bfc194fa944@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 14 Sep 2026 08:29:05 +0000 (UTC)

Writing an invalid value such as 0 or a negative number to
/sys/module/sg/parameters/scatter_elem_sz causes a shift-out-of-bounds bug
during subsequent device operations. When opening a device via sg_open(),
the driver calls sg_build_indirect() to allocate scatter-gather buffers. In
sg_build_indirect(), scatter_elem_sz is read into the local snapshot
variable num. Because PAGE_SIZE is unsigned, comparing num against
PAGE_SIZE results in an unsigned comparison that bypasses negative values.
Furthermore, even if the condition is met, the code updates the global
scatter_elem_sz and scatter_elem_sz_prev variables but leaves the local
snapshot variable num unupdated before get_order(). As a result, an invalid
value such as 0 remains in num and is passed to order = get_order(num).
Calling get_order(0) is undefined and underflows to 52 on 64-bit systems,
causing ret_sz = 1 << (PAGE_SHIFT + order) to compute 1 << 64. Shifting a
32-bit int by 64 bits triggers a UBSAN shift-out-of-bounds warning:

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

Fix this by casting PAGE_SIZE to int so that the comparison is signed and
negative values do not bypass the check, and by updating the local snapshot
variable num to PAGE_SIZE when num < (int)PAGE_SIZE before get_order() is
called.

Fixes: 10db10d144c0 ("sg: convert the indirect IO path to use the block layer")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
Link: https://syzkaller.appspot.com/ai_job?id=e273ef4c-bec0-4d7e-af59-32e327619af1
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Doug Gilbert" <dgilbert@interlog.com>
To: <linux-scsi@vger.kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>
To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Drop module_param_cb() setter callback and range validation at sysfs boundary.
- Cast PAGE_SIZE to int in sg_build_indirect() to prevent negative values from bypassing the check.
- Update local snapshot variable num to PAGE_SIZE when num is less than PAGE_SIZE.
- Update commit description to explain the unsigned comparison and unupdated local variable, and remove claims regarding parameter data races.

v1:
https://lore.kernel.org/all/30c58052-61b7-4425-9fd7-c188a0bef4ea@mail.kernel.org/T/
---
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e..39c8e52fa 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1875,9 +1875,10 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 
 	num = scatter_elem_sz;
 	if (unlikely(num != scatter_elem_sz_prev)) {
-		if (num < PAGE_SIZE) {
+		if (num < (int)PAGE_SIZE) {
 			scatter_elem_sz = PAGE_SIZE;
 			scatter_elem_sz_prev = PAGE_SIZE;
+			num = PAGE_SIZE;
 		} else
 			scatter_elem_sz_prev = num;
 	}


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
