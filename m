Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AF33F54BF
	for <syzbot@lists.linux.dev>; Tue, 22 Sep 2026 19:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790104260; cv=none; b=e6Y0OSjuqpNPIhbpeYyBtDslrDFKG59YyoxM+x6qjloUb/LdaQofg6+szXOcvfw2/5V5TQVd4FoyPdvgi6lrGOIvE1EPVIQiW7Rnl5rS/c4aBotOYFqghvemJJRVrrYsUEW36jARkyVS5/56A4iF8V0cL0MBmyDDbbc6hXVPXe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790104260; c=relaxed/simple;
	bh=dT56cSWqZFn+KkHpiqXEMUDHgK5ESKjHi1UVgjvfJKc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=kthX5V87WGQ/IwIG2PGRiJziYfdOwXVqTfZhTMb8Uc9smrzLmziQw1T+EfWmIlqlgj4C/m9mpQe1ItjDmkKnSayqfqZ58oTnBMv4pjWm+j4hPHrElSJo2MB85xYhrS5JXU4XsluuFXC82PGAmuOTpcbBxbznIPWgDXQgBk8a9cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LdBkJjmV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LdBkJjmV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C5F8F1F000FF;
	Tue, 22 Sep 2026 19:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790104258;
	bh=+u8p6g0Cf8p5+wp4S0Sx/vDaFqYVO6Itt3VSxngRp/8=;
	h=From:To:Cc:Subject:Date;
	b=LdBkJjmVVN7xKkXd3WKFiVCeJZyNMSaE3yCMhgQ5x2KNDZtfff9MorLPAac5tHKUE
	 pLXcllqSTFmUDZD8h4H1kJ/PfMCuk0dBuT4Slv/5UrC5DH8AynsnuI3QN9HiWCzpCH
	 zzLHiYiHwN7OARMivjuey2gnfYLSv1RLwPssCQl89TXQlLt8dBa0MGb0vaRHEp8Sjx
	 LbY0pw82k13YVqLaOYNbjIRODkEho+ERh6iwR4H7pSbCW2Fceuis0H5TJw/zCLkP5k
	 ik9DqaMyJH7MczWZ2jDm6tEmJ4MVq0hxNRfp6Le2+xV/p0g+qXX8U0fR3xzdJf6cw1
	 Ie7gKGFcXX9Tg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fat: set buffer uptodate before dirtying in vfat_update_dotdot_de()
Message-ID: <012d4ac1-83f3-48af-8781-00fbbc4adc93@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 22 Sep 2026 19:10:58 +0000 (UTC)

During a directory rename operation (such as rename or rename-exchange),
vfat_update_dotdot_de() is invoked to update the ".." directory entry to
point to the new parent directory. In vfat_update_dotdot_de(), the buffer
head is dirtied via mmb_mark_buffer_dirty(), and if synchronous directory
operations are enabled (such as when mounted with MS_SYNCHRONOUS where
IS_DIRSYNC() is true), sync_dirty_buffer() is immediately called to write
the buffer to disk. If writing the buffer fails due to an I/O error on the
underlying block device, the block layer completion handler clears the
BH_Uptodate flag on the buffer head, and sync_dirty_buffer() returns an
error.

When vfat_rename_exchange() or vfat_rename() encounters an error during the
rename sequence, it jumps to an error rollback path to restore the original
".." entry by calling vfat_update_dotdot_de() again with the same buffer
head. When vfat_update_dotdot_de() calls mmb_mark_buffer_dirty(),
mark_buffer_dirty() checks whether the buffer is uptodate and triggers a
warning because BH_Uptodate was cleared by the earlier write error:

!buffer_uptodate(bh)
WARNING: fs/buffer.c:991 at mark_buffer_dirty+0x299/0x410 fs/buffer.c:991
Call Trace:
 <TASK>
 mmb_mark_buffer_dirty+0x2c/0x1f0 fs/buffer.c:624
 vfat_update_dotdot_de+0x90/0x1c0 fs/fat/namei_vfat.c:917
 vfat_rename_exchange fs/fat/namei_vfat.c:1140 [inline]
 vfat_rename2+0xe3e/0x1c90 fs/fat/namei_vfat.c:1171
 vfs_rename+0xbd9/0xef0 fs/namei.c:6208
 filename_renameat2+0x533/0x9a0 fs/namei.c:6326
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

The in-memory data in the buffer head remains valid because it was
originally read successfully from disk and only modified in memory; the I/O
failure only indicates that writing it to the media failed. Fix this by
calling set_buffer_uptodate() in vfat_update_dotdot_de() prior to marking
the buffer dirty. This ensures that BH_Uptodate is set before
mark_buffer_dirty() is called, preventing the spurious warning during error
rollback.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b0aebd03565f5774f7f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0aebd03565f5774f7f8
Link: https://syzkaller.appspot.com/ai_job?id=047c8bd2-3171-476a-9977-78f4bc3e39b3
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
To: <linux-kernel@vger.kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>

---
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index da3e89c0b..b84228e7f 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -914,6 +914,12 @@ static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
 				 struct msdos_dir_entry *dotdot_de)
 {
 	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
+	/*
+	 * If a previous sync failed, the block layer's end-io handler clears
+	 * BH_Uptodate. Set it uptodate before marking dirty to prevent
+	 * mark_buffer_dirty() from warning during error rollback.
+	 */
+	set_buffer_uptodate(dotdot_bh);
 	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
 	if (IS_DIRSYNC(dir))
 		return sync_dirty_buffer(dotdot_bh);


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
