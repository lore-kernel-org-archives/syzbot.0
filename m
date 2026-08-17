Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE10E221F39
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 01:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786928647; cv=none; b=KxC6I3O72d2pSVsUXhOEj9W6TwwG+DR1FFZlDAj1UMY2sSTIKgW1TyJLR4W4T0FNj7EXHEmiPzlLAk48TATfQRt5cErw83yXBOp4fJtjRLgiuyCrHtYUmaOA5Anly3yaADHMaihsL2fEEmPTXz5tUY4bozXx+qrDcqTalW4qlGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786928647; c=relaxed/simple;
	bh=T4N0U70q6zo2iN/euHR2r1B1Uplyo63lkRQJ6OudFi8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=JKlyyMagw0E6Tjf2WjnU70VRH/J1ukIsSMa8i8u+B+Vxn+9aR+gkkgx+otAddTbH2ddWE3bZpqnoA/wcJKdIooyvenO4ZHkPWkyj8cMidsbsLgIcNsbdSy+2odyPlKf0LjFBX4iAXhZCTO+nv/Ksv81KQzaR1xO0C8sa6WL4Awg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErBG9T2a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErBG9T2a"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 809BA1F000E9;
	Mon, 17 Aug 2026 01:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786928645;
	bh=0aLjGyF0UWpStY9IC9YV+2Cd7mir/foXV6NtRfLd9+A=;
	h=From:To:Cc:Subject:Date;
	b=ErBG9T2afiIoPveRhqapMQPktB+C/4XiSthvmHEUPiQ/EbPXYO4nIWSGpJo4EeAfh
	 NqF9VaSkx4/WhPik/920GITFYCq7tnr0x99coeqY7GDRakfDPWhY48wDcS0bNME8Dg
	 mP3wHZap+6zJPvCPNwzIvf0H5Kq1FI4IhtUniBCRs/0yALM8aQ4aE6Lh5ltUVYzyL/
	 hkHelTgECFPUfdiUwm8SC1Xjz0vuIRqON5L8jQGj32GvcDHdOp6sDSBzQ7APDeY+Li
	 V8TDcnhGilNqVbQvpmXGOyFoxaRBEKi6RPxfD/CsRxQRu19klknExl0xFZ0DRhTVYl
	 WfbDSd+bYqTeQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] XArray: fix index jumping backwards in xas_find()
Message-ID: <e62bb2ac-6ecf-41a2-823f-c13547d5db78@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 17 Aug 2026 01:04:05 +0000 (UTC)

A bug in the XArray iterator xas_find() causes the iterator's index
(xas->xa_index) to jump backwards when iterating over a multi-index entry
(like a THP) that resides in a non-leaf node and is concurrently split.

When iterating over a multi-index entry in a non-leaf node, xas_load() sets
xas->xa_offset to the base offset of the entry, but leaves xas->xa_index at
the requested index. When the caller subsequently wants to advance to the
next entry, xas_find() is called. xas_find() attempts to synchronize
xas->xa_offset with xas->xa_index before advancing. However, the fixup
logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
Because the THP resides in a non-leaf node, the fixup is skipped.

As a result, xas_find() simply increments xas->xa_offset and recalculates
xas->xa_index based on this new offset. This causes xas->xa_index to jump
backwards. If the THP was concurrently split, the entry at the new offset
is a node pointer, so xas_find() descends into it and returns the folio at
the backwards index. The caller (filemap_map_pages()) then calculates the
PTE pointer based on this backwards index, resulting in an out-of-bounds
memory access.

For example, a KASAN slab-out-of-bounds read can be triggered in ptep_get()
via filemap_map_pages():

BUG: KASAN: slab-out-of-bounds in ptep_get include/linux/pgtable.h:495
[inline]
BUG: KASAN: slab-out-of-bounds in filemap_map_folio_range mm/filemap.c:3820
[inline]
BUG: KASAN: slab-out-of-bounds in filemap_map_pages+0x1100/0x2090
mm/filemap.c:3955
Read of size 8 at addr ffff88811b3b4a00 by task syz-executor411/5876

To fix this, remove the !xas->xa_node->shift restriction and use the
get_offset() helper to correctly calculate the offset for any node shift.
This ensures that xas->xa_offset is correctly synchronized with
xas->xa_index before advancing, regardless of the node's depth in the tree.

Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
Link: https://syzkaller.appspot.com/ai_job?id=608570d2-1765-472d-a79b-ea5b0b3a226a
To: "Andrew Morton" <akpm@linux-foundation.org>
To: <linux-fsdevel@vger.kernel.org>
To: <linux-mm@kvack.org>
To: "Matthew Wilcox" <willy@infradead.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b49165..5695618bf 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1406,9 +1406,8 @@ void *xas_find(struct xa_state *xas, unsigned long max)
 		entry = xas_load(xas);
 		if (entry || xas_not_node(xas->xa_node))
 			return entry;
-	} else if (!xas->xa_node->shift &&
-		    xas->xa_offset != (xas->xa_index & XA_CHUNK_MASK)) {
-		xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+	} else if (xas->xa_offset != get_offset(xas->xa_index, xas->xa_node)) {
+		xas->xa_offset = get_offset(xas->xa_index - 1, xas->xa_node) + 1;
 	}
 
 	xas_next_offset(xas);


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
