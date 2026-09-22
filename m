Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6793E530DE9
	for <syzbot@lists.linux.dev>; Tue, 22 Sep 2026 10:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072100; cv=none; b=BdZffeFr5JJUVnen1LBYj5VHk+iPdhQth/dJ+q9Mi0udrXt0mk8vmWuQAn6tEdINskG3cjxA0cMcwtPYCTAbvMhXa3zKjMgaM/EJLw4N0MTsIlLV7JuHkP2KWJ3rbZLBL15W/ivrwZIR/sC0GweuA7Lyy5Uirwpo4VR//Q/nqRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072100; c=relaxed/simple;
	bh=3xJ0tNDd0tJbYRQiM5yOBKxz1wKJRqfoFoRnuUpBJJc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=FP/rZe4BWdh0lysX7gU3BqQZeg47sa0UiQsaELhyjnCq7qEJ4FE7tBUbgpZ0ki+YFnX3d5kH00BCQ0GCg43AIVUK/pgcUFgsYsXTafHgqpseN8iQbnh+J+5zAqteDsULaWNymMa9NFB/KwVM667YMw+uC1xTQwkHW6LbkN91qTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B4FI+QhF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B4FI+QhF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2527A1F000FF;
	Tue, 22 Sep 2026 10:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790072099;
	bh=VQtiYLy3J/OZoeyIItwAuT2WuX/+6ZDk3kuCCxWXvZ8=;
	h=From:To:Cc:Subject:Date;
	b=B4FI+QhF7Cq8shy9XTctleRLXC11+3aKJlCaeD/soQeKMcP8Zk49KLG9QhvcbSc+I
	 hDowf+LDII8UjqoORMTSoEH8X/NSRnB/eNYNItAFzKSp8yewlsDi2d+eB5eoe6ENkX
	 DM7/mS/btPAMWB3pYTBsE2cvBHF6lxsG9fu5H5OeJuvjbQXuVw420b6+JMVUFpFDWV
	 6AyAN66Hm6yEcdTEXo03xeD3H2qVb7V8grfgzZsiewU3QGKnr6VpvV6qX5htmyZcNB
	 UF2oC8ATyVNFGlcRPKzmX6zIRR6bfyrI9qZLf10mbk1FL5QSdmG6fwBudgvLVzyClk
	 bA4fTG0lv5pGg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fs/ntfs3: hold invalidate_lock around size changes in ntfs_setattr
Message-ID: <b78d7df0-1bce-4161-a252-e20c40b12310@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 22 Sep 2026 10:14:59 +0000 (UTC)

A race condition exists between file size changes in ntfs_setattr() and
concurrent page faults in filemap_fault(). When a file containing resident
(inline) data is extended, ntfs_setattr() calls truncate_setsize(), which
immediately updates inode->i_size to the new size before ntfs_set_size()
updates the underlying NTFS attribute size. Because ntfs_setattr() does not
hold filemap_invalidate_lock, a concurrent page fault can call
filemap_fault() (which acquires filemap_invalidate_lock_shared()) and
invoke ntfs_read_folio(). In ntfs_iomap_begin(), the resident attribute
size has not yet been updated, leaving iomap->length set to the old
attribute size. When iomap_read_inline_data() subsequently computes size as
i_size_read(iter->inode) - iomap->offset, size exceeds iomap->length,
triggering a warning:

size > iomap->length
WARNING: fs/iomap/buffered-io.c:431 at iomap_read_inline_data+0xa7b/0xc40
fs/iomap/buffered-io.c:431
Call Trace:
 <TASK>
 iomap_read_folio_iter+0x30d/0xe80 fs/iomap/buffered-io.c:571
 iomap_read_folio+0x58b/0x970 fs/iomap/buffered-io.c:676
 ntfs_read_folio+0x3f1/0x4b0 fs/ntfs3/inode.c:856
 filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2520
 filemap_fault+0xd06/0x13b0 mm/filemap.c:3689
 __do_fault+0x138/0x2a0 mm/memory.c:5565
 do_read_fault mm/memory.c:6000 [inline]
 do_fault mm/memory.c:6134 [inline]
 do_pte_missing+0x2313/0x3260 mm/memory.c:4700
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0x1a2c/0x3770 mm/memory.c:6876
 do_user_addr_fault+0xa4f/0x1340 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
 </TASK>

Fix this by acquiring filemap_invalidate_lock(inode->i_mapping) around
truncate_setsize() and ntfs_set_size(), releasing it afterwards and on the
error rollback path. This serializes file size updates against concurrent
page faults and page cache reads, ensuring readers cannot observe an
inconsistent state where inode->i_size has been updated before the
underlying filesystem attribute layout and size updates are complete.

Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+079e16bc964fb91acb4a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=079e16bc964fb91acb4a
Link: https://syzkaller.appspot.com/ai_job?id=f1473b28-efba-4427-995b-64ef3decdc90
To: "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>
To: <ntfs3@lists.linux.dev>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 2abf334bf..80518de36 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -736,13 +736,16 @@ int ntfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		newsize = attr->ia_size;
 
 		if (newsize != oldsize) {
+			filemap_invalidate_lock(inode->i_mapping);
 			truncate_setsize(inode, newsize);
 
 			err = ntfs_set_size(inode, newsize);
 			if (err) {
 				i_size_write(inode, oldsize);
+				filemap_invalidate_unlock(inode->i_mapping);
 				goto out;
 			}
+			filemap_invalidate_unlock(inode->i_mapping);
 
 			ni->std_fa |= FILE_ATTRIBUTE_ARCHIVE;
 			ni->ni_flags |= NI_FLAG_UPDATE_PARENT;


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
