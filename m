Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3472A3C197E
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779320482; cv=none; b=rVKQuiXPRnJJTVEuemNgqPd4evqBG3DQRRjAcl9CPvLUf5WMKVD0+1Pe7zoTqCh2vDkzuyiUOuV1udyM31Hs+tD6zsRRN+1odr6bmwEYqYH7cgj2pLWNN8M+eTFBhglm8bBv6d8gqG/35/zJPeFsAwn+ToWQc1+bLhgv066uk14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779320482; c=relaxed/simple;
	bh=yvg7RdNcnbTwU5u4waZpshsCVjfWUkW2KQWoXkdCxHM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Ll0jC7etHyrMYeGLoiWG7cWnCmAKwfv1KauLM89DLMS/Ii0DHzS3JVv4qNO4GVivHt3q/3NR6US67dJqGWRDjoqv4ZGhWF4JLdxb7VmwiV6MAY6TpXjqDEtSa9EDVfg305+UO3wKb8yaMN4YQbvu5lK3jcYCOiW1JKzeUZd47LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BePB8bTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BePB8bTB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B49991F000E9;
	Wed, 20 May 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779320480;
	bh=+pCJxscmesPn1lYAF5D7EG87KEmpT5o0gUx5JP+m3i0=;
	h=From:To:Cc:Subject:Date;
	b=BePB8bTBfGrNS+80yba012y554R0oJs5aFG+n+HuNO5nTc832pa3dPxvG1Thfzk3E
	 o6tXysHZgFQEBApoNqHztlibuLVMTfj+elPGLYBKJr5ryhttbUFVdcWr9QzycR0lez
	 a9Vig2aaUJjAub/+3jCrLVckpnqyh/EAHVCqBsQcNbqjNvn9kGbDaHCd00lEfa1m+D
	 mZq26twMApsQkMaFNKxdaNOlsbGQK2gLGGd/Qmh/d6dgLqEJUBIKMBb2mKqLvNJEUN
	 s90o/ny/o5GDWUPFckGY6et9VHDn2HrAT9t4xbSljRmVSu9epMa3rd+f154PtRshzQ
	 c9c10DBciqdeA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] scsi: sg: Fix shift-out-of-bounds in sg_build_indirect()
Message-ID: <86a900a2-03db-40ed-aa45-d8c847df4d90@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 20 May 2026 23:41:20 +0000 (UTC)

When the scatter_elem_sz module parameter is set to 0 (or a negative
value), sg_build_indirect() attempts to clamp it to PAGE_SIZE. However,
while the global variables are updated, the local variable num is not.
This results in num remaining 0. Calling get_order(0) underflows and
returns a very large order (e.g., 52). Subsequently, the expression 1 <<
(PAGE_SHIFT + order) evaluates to 1 << 64, which triggers a
shift-out-of-bounds undefined behavior.

Fix this by updating the local variable num to PAGE_SIZE during the
clamping process to ensure it is never 0 or negative when passed to
get_order(). Additionally, replace the unsafe 1 << (PAGE_SHIFT + order)
pattern with the safer and more idiomatic PAGE_SIZE << order throughout
the file. This prevents any potential undefined behavior if PAGE_SHIFT +
order equals or exceeds 31 (or 64 for 1UL), and ensures consistency
across sg_build_indirect(), sg_vma_fault(), sg_mmap(), sg_read_oxfer(),
and sg_link_reserve().

Fixes: 10db10d144c0 ("sg: convert the indirect IO path to use the block layer")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
Link: https://syzkaller.appspot.com/ai_job?id=9fc73d11-e044-468a-84ed-9ae3a79a07b0
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Doug Gilbert" <dgilbert@interlog.com>
To: <linux-scsi@vger.kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 74cd4e8a6..cb4450a89 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1232,7 +1232,7 @@ sg_vma_fault(struct vm_fault *vmf)
 				      "sg_vma_fault: offset=%lu, scatg=%d\n",
 				      offset, rsv_schp->k_use_sg));
 	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
+	length = PAGE_SIZE << rsv_schp->page_order;
 	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
@@ -1278,7 +1278,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	}
 
 	sa = vma->vm_start;
-	length = 1 << (PAGE_SHIFT + rsv_schp->page_order);
+	length = PAGE_SIZE << rsv_schp->page_order;
 	for (k = 0; k < rsv_schp->k_use_sg && sa < vma->vm_end; k++) {
 		len = vma->vm_end - sa;
 		len = (len < length) ? len : length;
@@ -1877,6 +1877,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 	num = scatter_elem_sz;
 	if (unlikely(num != scatter_elem_sz_prev)) {
 		if (num < PAGE_SIZE) {
+			num = PAGE_SIZE;
 			scatter_elem_sz = PAGE_SIZE;
 			scatter_elem_sz_prev = PAGE_SIZE;
 		} else
@@ -1885,7 +1886,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 
 	order = get_order(num);
 retry:
-	ret_sz = 1 << (PAGE_SHIFT + order);
+	ret_sz = PAGE_SIZE << order;
 
 	for (k = 0, rem_sz = blk_size; rem_sz > 0 && k < mx_sc_elems;
 	     k++, rem_sz -= ret_sz) {
@@ -1964,7 +1965,7 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
 
-	num = 1 << (PAGE_SHIFT + schp->page_order);
+	num = PAGE_SIZE << schp->page_order;
 	for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
 		if (num > num_read_xfer) {
 			if (copy_to_user(outp, page_address(schp->pages[k]),
@@ -2015,7 +2016,7 @@ sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size)
 			 "sg_link_reserve: size=%d\n", size));
 	rem = size;
 
-	num = 1 << (PAGE_SHIFT + rsv_schp->page_order);
+	num = PAGE_SIZE << rsv_schp->page_order;
 	for (k = 0; k < rsv_schp->k_use_sg; k++) {
 		if (rem <= num) {
 			req_schp->k_use_sg = k + 1;


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
