Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB83D33B6D6
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782150222; cv=none; b=PVZw0UtMtN3G0hXoe42jk/fcVxfWtXEpLgEVB9HeooecKUdPhbDpGhyspBpJaI9QsJRYqN1cQn7cB97R8SXgoAbKUnUlfArhVEW9yPqWifGlt3GfqHZEZ8Rra0etn4jUsk8cVWBYjVci38NSM6vw32MsKRg/aK1YoEGA5odE/WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782150222; c=relaxed/simple;
	bh=2Spvr3c1Dn8c8orEHOpKXlotmWh95Lyb/SH0U5oHlyM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=O285WBboaitAGNGaUb+Lf7vrS8oKnbGHcPwPrCdb+7e4cV6l56UzZTthgBAvOseY+o9ax+SDaDz1iZoPFYRArizko7s4tapZiK5em+neW0/ys6a6Gx8wMsPBJ0ZVrde6LiQ4FVHkN2Dn76Et0SjIm/jq15mGSIlxdbA/CrBVXio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AmELQ4Wm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AmELQ4Wm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 617B51F000E9;
	Mon, 22 Jun 2026 17:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782150219;
	bh=kdJ8m8NkDbNQi9YLsaAxHby765EehqwsR47xGETXQdI=;
	h=From:To:Cc:Subject:Date;
	b=AmELQ4WmZRuE/w6LD3SBo18HxWmdhbiJoHIyS15DGo9HEh3nJe2VPrQbds62wnvHB
	 gOnuXO3fPQXnOmi0n1/xmHyXXaBXHDyAdmt/Oh+u/bO5S3CE3+KAWQaITGXg+jz3x1
	 5OFs6GeuuTtOYLYXuHjJ3UpxFInUeOrYA3VMhM7HzW5cPi92/JVv7zUomm+L2dBnv5
	 Na2D0LBpQ2dDtg+Jb3jRenWA2s/r6rgrFMh2XPD4m+FfQzZFOAgaH6dpMn2FyooEBY
	 aCA+vk9b2+KtgXhEZD0xgXlUazSG9WhpdKYrR0Pwl31C0AiK/DcN/cInlQXJNvxopZ
	 ZPieYiS81xirg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] udf: Mark LVID buffer as uptodate before marking it dirty in open/sync
Message-ID: <4d9eb3b8-5227-4e03-81b0-c53b7a296eac@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 22 Jun 2026 17:43:39 +0000 (UTC)

When an I/O error occurs while writing the Logical Volume Integrity
Descriptor (LVID) buffer to the block device, the block layer's completion
handler (`end_buffer_write_sync()`) clears the `BH_Uptodate` flag on the
buffer. However, the buffer still contains valid LVID data in memory. If
the filesystem is subsequently remounted read-write or synced,
`udf_open_lvid()` or `udf_sync_fs()` will modify the LVID buffer and call
`mark_buffer_dirty()`. This triggers a spurious
`WARN_ON_ONCE(!buffer_uptodate(bh))` warning in `mark_buffer_dirty()`
because the buffer is not marked uptodate, even though its in-memory
contents are valid and are about to be overwritten.

To prevent this spurious warning, unconditionally set the `BH_Uptodate`
flag before calling `mark_buffer_dirty()` in `udf_open_lvid()` and
`udf_sync_fs()`. This acknowledges that the in-memory buffer is valid and
matches the workaround previously applied to `udf_close_lvid()` in commit
853a0c25baf9 ("udf: Mark LVID buffer as uptodate before marking it dirty").
Extending this workaround ensures consistent behavior across all LVID
updates.

Buffer I/O error on dev loop0, logical block 128, lost sync page write
------------[ cut here ]------------
!buffer_uptodate(bh)
WARNING: fs/buffer.c:1087 at mark_buffer_dirty+0x299/0x410 fs/buffer.c:1087
...
Call Trace:
 <TASK>
 udf_open_lvid+0x369/0x5b0 fs/udf/super.c:2078
 udf_reconfigure+0x336/0x540 fs/udf/super.c:679
 reconfigure_super+0x232/0x8f0 fs/super.c:1080
 vfs_cmd_reconfigure fs/fsopen.c:268 [inline]
 vfs_fsconfig_locked+0x171/0x320 fs/fsopen.c:297
 __do_sys_fsconfig fs/fsopen.c:463 [inline]
 __se_sys_fsconfig+0x6b9/0x810 fs/fsopen.c:350
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 </TASK>

Fixes: 853a0c25baf9 ("udf: Mark LVID buffer as uptodate before marking it dirty")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+0306b38d9ed6ef71467d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0306b38d9ed6ef71467d
Link: https://syzkaller.appspot.com/ai_job?id=83a8a238-e94a-44e6-8088-8640cf9cb7e0
To: "Jan Kara" <jack@suse.com>
To: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/udf/super.c b/fs/udf/super.c
index cad2e15d6..7a5e9bd11 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2075,6 +2075,12 @@ static void udf_open_lvid(struct super_block *sb)
 		UDF_SET_FLAG(sb, UDF_FLAG_INCONSISTENT);
 
 	udf_finalize_lvid(lvid);
+	/*
+	 * We set buffer uptodate unconditionally here to avoid spurious
+	 * warnings from mark_buffer_dirty() when previous EIO has marked
+	 * the buffer as !uptodate
+	 */
+	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 	sbi->s_lvid_dirty = 0;
 	mutex_unlock(&sbi->s_alloc_mutex);
@@ -2397,6 +2403,12 @@ static int udf_sync_fs(struct super_block *sb, int wait)
 		 * Blockdevice will be synced later so we don't have to submit
 		 * the buffer for IO
 		 */
+		/*
+		 * We set buffer uptodate unconditionally here to avoid spurious
+		 * warnings from mark_buffer_dirty() when previous EIO has marked
+		 * the buffer as !uptodate
+		 */
+		set_buffer_uptodate(bh);
 		mark_buffer_dirty(bh);
 		sbi->s_lvid_dirty = 0;
 	}


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
