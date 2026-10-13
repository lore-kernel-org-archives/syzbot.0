Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB49B54145F;
	Tue, 13 Oct 2026 19:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791920402; cv=none; b=qxeuMu5PPsOLSKbQamVIUgXvCocJXAGya1lxwk/o0elKSWRXUUQGWRG+KcNwzjGrGEwf2vyrn7tkYOnf+C+/wo/rnd7kGQz1Pel3pdGTApQnoaD9FQejl1kPEgWtZPblN6f0hsTW2af1xFdvaTvjFeWoRaVkConZOBnHPPwE/EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791920402; c=relaxed/simple;
	bh=MZg58M268Eh0VZqIkyS55G+P1rLcbo9ml1/whWRf554=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=sLKocZ7fUcZGdhkuVGyTC/iOcfm36d+xNiSZIy7k67z1hlvhqAbsGVcFjpkwYJ6sZ4IUx1MzzVYYy5RC/Sgf2IErm22b7rdzf6j7QKKFGbKbpETYOGzKdlv21Ki9XgylKEtC9f9WXl0BpPak+Gmh6/XmIh4ZNxIg7WdtsoP0YK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJh8OY5d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJh8OY5d"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0109B1F000FF;
	Tue, 13 Oct 2026 19:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791920400;
	bh=2qwfRg5DXWganUmwiKbDvHA+hLYxjOJ4/zQ8YVt+nQc=;
	h=From:To:Cc:Subject:Date;
	b=KJh8OY5dsfrlTbt0uZJ/ZgQGpO/tCEXqLvPkvaMtVhFsS402ePkcQ0P/m91P0jtnL
	 mU8rOj+SSPn8nTHhlls4+jy9HpL7NMS0pFQmooOiIaymZ0NZVUSsZ0RY3wbUXq3PvE
	 GfeUjzCPG7a2PkxsE3dKQh4QURT/EOvCwJ4inqOFkShTvZp6ZiRUvs/H6EAFwhiWAK
	 711Q7MIl66NZPQchto9gEL4vFkTtHRVqOIVXT68Om+PQ0+fsaD/SJj6GI15McWd+Dr
	 mdgC4pyxhZhAT5oeH5ieb1yFgZUtEYVdv+sEqAppozHdY5YP7FyiAqoQWf308JUMqi
	 VsVj5SwXECzEA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>, <ntfs3@lists.linux.dev>, "ZhengYuan Huang" <gality369@gmail.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] fs/ntfs3: use ni_lock_dir() in ntfs_readdir()
Message-ID: <09f6cbed-aafb-4e5b-8b0f-36d55a248644@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 13 Oct 2026 19:39:59 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

A circular locking dependency warning is detected by lockdep between
&ni->ni_lock and mapping.invalidate_lock when getdents64() writes into a
memory-mapped buffer while an operation such as fallocate() runs
concurrently on a regular file:

 WARNING: possible circular locking dependency detected
 task is trying to acquire lock:
 ffff88819b6dbb20 (mapping.invalidate_lock#3){++++}-{4:4}, at:
 filemap_fault+0x6e0/0x13c0 mm/filemap.c:3585
 but task is already holding lock:
 ffff88819b6997e8 (&ni->ni_lock/5){+.+.}-{4:4}, at:
 ntfs_readdir+0x717/0xf70 fs/ntfs3/dir.c:541
 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

  -> #1 (&ni->ni_lock/5){+.+.}-{4:4}:
        ni_lock fs/ntfs3/ntfs_fs.h:1247 [inline]
        ntfs_fallocate+0x56a/0x1080 fs/ntfs3/file.c:535
        vfs_fallocate+0x663/0x7f0 fs/open.c:338
        ioctl_preallocate fs/ioctl.c:289 [inline]
        file_ioctl+0x5db/0x7e0 fs/ioctl.c:332
        do_vfs_ioctl+0xc2a/0x1550 fs/ioctl.c:576

  -> #0 (mapping.invalidate_lock#3){++++}-{4:4}:
        filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
        filemap_fault+0x6e0/0x13c0 mm/filemap.c:3585
        __do_fault+0x138/0x2a0 mm/memory.c:5565
        handle_pte_fault mm/memory.c:6558 [inline]
        __handle_mm_fault mm/memory.c:6707 [inline]
        handle_mm_fault+0x100a/0x28a0 mm/memory.c:6876
        do_user_addr_fault+0x746/0x1340 arch/x86/mm/fault.c:1394
        exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
        filldir64+0x2bc/0x620 fs/readdir.c:-1
        dir_emit include/linux/fs.h:3610 [inline]
        ntfs_dir_emit fs/ntfs3/dir.c:388 [inline]
        ntfs_read_hdr+0x8a7/0xc10 fs/ntfs3/dir.c:429
        ntfs_readdir+0x9ab/0xf70 fs/ntfs3/dir.c:589
        iterate_dir+0x3ea/0x8a0 fs/readdir.c:114
        __do_sys_getdents64 fs/readdir.c:404 [inline]

The warning occurs because ntfs_fallocate() on a regular file acquires
mapping.invalidate_lock and then calls ni_lock(), which locks the regular
file inode's ni_lock with the default subclass NTFS_INODE_MUTEX_NORMAL
(subclass 5). Meanwhile, ntfs_readdir() on a directory inode also uses
ni_lock() with subclass 5, and while holding the lock across directory
traversal, calls dir_emit() to fill directory entries into the user buffer.
If that buffer is backed by a memory-mapped file, writing to it triggers a
page fault (filemap_fault()), which acquires the mapped file's
mapping.invalidate_lock. Because lockdep sees mapping.invalidate_lock ->
ni_lock (subclass 5) in fallocate and ni_lock (subclass 5) ->
mapping.invalidate_lock in readdir, it flags a circular locking dependency.

This is a false positive because the two operations involve distinct
inodes: readdir holds the mutex of the directory inode, while the page
fault acquires the invalidate_lock of the regular file whose pages back the
user buffer, so an actual deadlock cannot occur.

In ntfs3, directory inodes are intended to be locked with ni_lock_dir(),
which uses the lockdep subclass NTFS_INODE_MUTEX_PARENT (subclass 6). This
subclass hierarchy is already used by other directory operations like
ntfs_lookup(), ntfs_create_inode(), ntfs_link(), ntfs_unlink(), and
ntfs_rename(). Replace ni_lock() with ni_lock_dir() in ntfs_readdir() when
loading subrecords and when traversing directory metadata. This changes the
directory lock subclass to NTFS_INODE_MUTEX_PARENT (6), establishing the
hierarchy ni_lock_dir (subclass 6) -> mapping.invalidate_lock -> ni_lock
(subclass 5) and eliminating the false lockdep warning.

Fixes: d62cf685d12e ("fs/ntfs3: hold ni_lock across readdir metadata walk")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+7736960b837908f3a81d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
Link: https://syzkaller.appspot.com/ai_job?id=fae916f3-c2b4-47da-86b5-063a011b5c01
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index eb9152e9f..8bf62d2fb 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -522,7 +522,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 		 * Load all subrecords to avoid 'write' access to 'ni' during
 		 * directory reading.
 		 */
-		ni_lock(ni);
+		ni_lock_dir(ni);
 		if (!ni->mi_loaded && ni->attr_list.size) {
 			err = ni_load_all_mi(ni);
 			if (!err)
@@ -538,7 +538,7 @@ static int ntfs_readdir(struct file *file, struct dir_context *ctx)
 	 * once is not enough if concurrent writeback can still compact ATTR_LIST
 	 * entries and free the record that ntfs_read_hdr() is currently walking.
 	 */
-	ni_lock(ni);
+	ni_lock_dir(ni);
 
 	root = indx_get_root(&ni->dir, ni, NULL, NULL);
 	if (!root) {


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
