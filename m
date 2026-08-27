Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1666047F791
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787844222; cv=none; b=CuFTC4NjlseH+2xoib4p2TPfTwukh//kidgdSvvmSzJVS0QIp1hTmB2t68f7mCBJhrS0U+7+zzlVsIgy7VwBTg40i7QhvUZGhYVywGkZq2p8Quxg3vC90tKhoZ0hVng+YCSXi9yIHr/J2O/Ep4YBCS4xjZSp3n+o2jkCV+N38Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787844222; c=relaxed/simple;
	bh=AZz43Wwy6LzT9a1NOq2FkpilXibjA7Wii4CLbG/1UiQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=r5/UxN03vBGlJF5nQKqsrYxp6kGh7Q3CenBAJwpcbwJ6ANrS4o+tEfOAcISUWyvVGwbZ10+DJFhOvDSnvsoGa4H9uJLnoBIz/3xvnHuSBunWtFzONJW1INmFClhK5XPPvnD8wHDCzXZoroIja1orgKnq1B0I8qCmuqBlwvb4OGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5d07Clm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5d07Clm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9AE691F00A3A;
	Thu, 27 Aug 2026 15:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787844220;
	bh=KLnVF4f/Q8c20UojoRNeZiCphGd7w8cw7HDrSaLGCcc=;
	h=From:To:Cc:Subject:Date;
	b=F5d07Clmyzt2ALRqdyXjtPltFwkjdXo3KdFuc3+hMQCWMRidYHU3Xi5+iVa24+i2a
	 4KfF6eM2+q2WkO0rvICh1M2RKe3SXZa3fNXYlO8k0feZha6iT2s1qgjX8ADNQKD33E
	 f/08HyRornOHp40U8ibu846I9Ww6VzPhHaJ/hWkKd4NFfjy64+XRbHf8SqMTnAWGUZ
	 V2ibsucjWCI2KO6A5WLtrvxy241DKF/gPw1ivbzUooUSulvNSNtq2/6y9sVRDdZNDD
	 /FE1nk5NQ2YKmlXfXvbX8fbbgils9LANlXVgslrBKxbtEANxxJ0qDb/fSChVBCuDZs
	 kTC42toxPNL4w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] xarray: fix index jumping backwards in xas_find()
Message-ID: <e2842b55-5d7f-47c1-bff1-28162cc1578d@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 27 Aug 2026 15:23:40 +0000 (UTC)

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
PTE pointer based on this backwards index, resulting in an invalid memory
access such as a use-after-free on a page-table page freed via
tlb_remove_table_rcu().

For example, a KASAN use-after-free read on a page-table page freed via
tlb_remove_table_rcu() can be triggered in ptep_get() via
filemap_map_pages():

BUG: KASAN: slab-use-after-free in ptep_get include/linux/pgtable.h:495
[inline]
BUG: KASAN: slab-use-after-free in filemap_map_folio_range
mm/filemap.c:3820 [inline]
BUG: KASAN: slab-use-after-free in filemap_map_pages+0x1100/0x2090
mm/filemap.c:3955
Read of size 8 at addr ffff888116c63a00

Call Trace:
 <TASK>
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 ptep_get include/linux/pgtable.h:495 [inline]
 filemap_map_folio_range mm/filemap.c:3820 [inline]
 filemap_map_pages+0x1100/0x2090 mm/filemap.c:3955
 do_fault_around mm/memory.c:5818 [inline]
 do_read_fault mm/memory.c:5851 [inline]
 do_fault mm/memory.c:5994 [inline]
 do_pte_missing+0x21ac/0x3260 mm/memory.c:4566
 handle_pte_fault mm/memory.c:6379 [inline]
 __handle_mm_fault mm/memory.c:6517 [inline]
 handle_mm_fault+0x1ad6/0x3070 mm/memory.c:6686
 do_user_addr_fault+0x744/0x1340 arch/x86/mm/fault.c:1394
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
 </TASK>

To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
xas->xa_node). If it does not and the node is a non-leaf node, set
xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before advancing.
Also add test cases in test_xarray to verify xas_find() behavior when
iterating over and splitting multi-index entries.

Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Assisted-by: Gemini:gemini-3.7-flash syzbot
Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
Link: https://syzkaller.appspot.com/ai_job?id=b8678dd0-4122-4e08-b590-12a929d4b350
To: "Andrew Morton" <akpm@linux-foundation.org>
To: <linux-fsdevel@vger.kernel.org>
To: <linux-mm@kvack.org>
To: "Matthew Wilcox" <willy@infradead.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Renamed xas_split to split and passed xa_mk_index(0) to xas_split_alloc() and xas_split() in test_xarray.
- Updated commit description to clarify that the use-after-free occurs on a page-table page freed via tlb_remove_table_rcu().
- Changed subject prefix to lowercase 'xarray:'.
- Corrected the quoted crash report in the commit description.

v2:
- Corrected offset synchronization for non-leaf nodes to use get_offset(xas->xa_index, xas->xa_node).
- Added check_multi_find_4() self-test in lib/test_xarray.c to test multi-index entry lookups and concurrent splitting.
- Updated the commit description to include the KASAN slab-use-after-free report.
https://lore.kernel.org/all/fc978b5d-df9f-4a06-89f5-d0fed8939e42@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/e62bb2ac-6ecf-41a2-823f-c13547d5db78@mail.kernel.org/T/
---
diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 5ca0aefee..cda7245e4 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1247,6 +1247,67 @@ static noinline void check_multi_find_3(struct xarray *xa)
 	}
 }
 
+static noinline void check_multi_find_4(struct xarray *xa)
+{
+#ifdef CONFIG_XARRAY_MULTI
+	XA_STATE(xas, xa, 100);
+	XA_STATE_ORDER(split, xa, 0, 0);
+	void *entry;
+	unsigned long i;
+
+	/* (1) Order-7 entry (0-127) with adjacent entry at 128, starting at 100 */
+	xa_store_order(xa, 0, 7, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, 128, GFP_KERNEL) != NULL);
+
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != 100);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(128));
+	XA_BUG_ON(xa, xas.xa_index != 128);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_erase_index(xa, 128);
+	xa_erase_index(xa, 0);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* (2) Splitting a multi-index entry after a lookup begins inside it */
+	xa_store_order(xa, 0, 7, xa_mk_index(0), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, 128, GFP_KERNEL) != NULL);
+
+	xas_set(&xas, 100);
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(0));
+	XA_BUG_ON(xa, xas.xa_index != 100);
+	rcu_read_unlock();
+
+	xas_split_alloc(&split, xa_mk_index(0), 7, GFP_KERNEL);
+	xas_lock(&split);
+	xas_split(&split, xa_mk_index(0), 7);
+	for (i = 0; i < 128; i++)
+		__xa_store(xa, i, xa_mk_index(i), 0);
+	xas_unlock(&split);
+
+	rcu_read_lock();
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != xa_mk_index(128));
+	XA_BUG_ON(xa, xas.xa_index != 128);
+
+	entry = xas_find(&xas, ULONG_MAX);
+	XA_BUG_ON(xa, entry != NULL);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+	XA_BUG_ON(xa, !xa_empty(xa));
+#endif
+}
+
 static noinline void check_find_1(struct xarray *xa)
 {
 	unsigned long i, j, k;
@@ -1370,6 +1431,7 @@ static noinline void check_find(struct xarray *xa)
 		check_multi_find_1(xa, i);
 	check_multi_find_2(xa);
 	check_multi_find_3(xa);
+	check_multi_find_4(xa);
 }
 
 /* See find_swap_entry() in mm/shmem.c */
diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b49165..980324d68 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1406,9 +1406,11 @@ void *xas_find(struct xa_state *xas, unsigned long max)
 		entry = xas_load(xas);
 		if (entry || xas_not_node(xas->xa_node))
 			return entry;
-	} else if (!xas->xa_node->shift &&
-		    xas->xa_offset != (xas->xa_index & XA_CHUNK_MASK)) {
-		xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+	} else if (xas->xa_offset != get_offset(xas->xa_index, xas->xa_node)) {
+		if (!xas->xa_node->shift)
+			xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
+		else
+			xas->xa_offset = get_offset(xas->xa_index, xas->xa_node);
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
