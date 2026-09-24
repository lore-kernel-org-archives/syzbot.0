Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C809429CD3
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 10:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244366; cv=none; b=MY4Yy9iFzXY4P29RiWKsx/H8ngivPo0ZbgJ0FPm+QIAR5Jc9OFMGk810qewM61cfX80bOPs23d11Q8e4czccbs6CAbZlaJgboFNAVP3NjFoMjvjoOKhbfpvHGXYe/uvoJgw3sjPQB71qtH29CI73M+KMIEtBWYEHyPd8Ojtq/7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244366; c=relaxed/simple;
	bh=q2ClYWS6pO3tGH8p2ZqQPNOBSUHZ2BLcaYZRgqf1B+k=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=QyiHy36dOQG4NpByVef8WMUylQ4zXaeF8GAj2RRTavWgMUSyv6ubUI15jPhDSkD/72wOPleiA3rupNlHnZ4ioWsU4vshV4NVNAG65aIb8W5XqXHj/vMBzgkOoGhtS9G1kO/uWOU8QCEK+kG3CTomy2GSIdLKFjgkQo9zjdlOe1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2Df8jOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2Df8jOw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DF7F61F00898;
	Thu, 24 Sep 2026 10:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244355;
	bh=fEZKMQhMPdPt/A+oalDHahx1hwlM364S7qAwtSOtq48=;
	h=From:To:Cc:Subject:Date;
	b=B2Df8jOwMbj+qDvN6OB/A6b2Vm0B1XBKzPuZobIvDTzNgw9AS+7YNEso374xc9CPV
	 3EaQ5IS+kl55rY5bU+jjQlQmrR9JvqtYI3sxjP1iWTcenR75zFrI+EN43Jp5rSBcBE
	 goBmH8amxhpYgdLdpX3ELAYNjQaz1dsU9wVd3W/mrGfD6bxzH+wZ+CfXZqurxJq6NQ
	 0F02AVVi/sb0cGpswfl2LJh77/By2+LlM5QQJBgIhO3q12PWClJD+0eDQRwnaDotC0
	 rRKbvmbEJOgaUk6fapjgjg2sfdf5hpVC3eFxL5FIhDnOiuli3Q+T7KUooxMR6MNfeM
	 0EqOHjgsMGKaQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] fat: validate VFAT dotdot buffers before dirtying
Message-ID: <56341edb-4dc2-4683-9776-641253569bb3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 24 Sep 2026 10:05:54 +0000 (UTC)

During directory rename operations with synchronous directory updates
enabled, vfat_update_dotdot_de() writes the ".." directory entry via
sync_dirty_buffer(). If this write fails due to an I/O error, the block
layer clears the BH_Uptodate flag. When rename enters its error rollback
path, it calls vfat_update_dotdot_de() again with the same buffer head,
which calls mmb_mark_buffer_dirty() and triggers a "!buffer_uptodate(bh)"
warning in mark_buffer_dirty().

Fix this by locking the buffer head in vfat_update_dotdot_de() and checking
buffer_uptodate() before modifying the entry. If the buffer is not
uptodate, unlock it and return -EIO, preventing mmb_mark_buffer_dirty()
from being called on a non-uptodate buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+b0aebd03565f5774f7f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b0aebd03565f5774f7f8
Link: https://syzkaller.appspot.com/ai_job?id=27914cea-b3da-4f37-a39a-cc2d26c706b7
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
To: <linux-kernel@vger.kernel.org>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>

---
v2:
- Lock the buffer head and return -EIO if it is not uptodate instead of calling set_buffer_uptodate().
- Update the patch subject to reflect buffer validation.
- Shorten the commit description and remove the stack trace.

v1:
https://lore.kernel.org/all/012d4ac1-83f3-48af-8781-00fbbc4adc93@mail.kernel.org/T/
---
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index da3e89c0b..1e7fd4003 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -913,8 +913,14 @@ static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
 				 struct buffer_head *dotdot_bh,
 				 struct msdos_dir_entry *dotdot_de)
 {
+	lock_buffer(dotdot_bh);
+	if (!buffer_uptodate(dotdot_bh)) {
+		unlock_buffer(dotdot_bh);
+		return -EIO;
+	}
 	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
 	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
+	unlock_buffer(dotdot_bh);
 	if (IS_DIRSYNC(dir))
 		return sync_dirty_buffer(dotdot_bh);
 	return 0;


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
