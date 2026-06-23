Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50443C1F59;
	Tue, 23 Jun 2026 12:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782217854; cv=none; b=L0DzyZub42bnFMqWD9h5NB/SkTWlo0CS0xk9pl6FjYhUsR3jWwTgoWNDPtYVSi3dxQfRyAAA+U0sZaBvx5y4Dd1MPLR+oylo2B/tKz4deWEG314VRktvy1yiNwCK5X+ucHe7YpE7iUPJXKj/TiWzXTZCsLJCaz/UkwVkY9LAxb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782217854; c=relaxed/simple;
	bh=9/dTWoMG0BpeBx8z+g8hQ2GlkALZZgyUJnD8mZC+oAY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=NpLVO9Pj7496N5hnaHQTJKxZkJ3ubY7lZ9iQd5oQxb1Ru8Xdspsk/3X4M2XiG+3x8solkclXpcsjeur7hG+7cN8Lb1KMROuA0ytSdrG0xkYuPjOZahFb2xsCHjv0OYg8K6MdoiKYZwx4QZQ1TrJGvH34UXPXNRK4uNg1yqlfCUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMLI/yuA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMLI/yuA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 69A391F000E9;
	Tue, 23 Jun 2026 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782217852;
	bh=owsaOZSiAJjW9UM6j5mxbBTKwXapR9Zn0mMY8wjCVxQ=;
	h=From:To:Cc:Subject:Date;
	b=WMLI/yuAGfeRb4dASHFu3ni9akBuuYYOWFiFH1YVV3xCms6bl5+Np4JOkLv4q4mdc
	 ecJC4JJOT925wu1f7Zivm/Vjmn+RB8Oxsrdu2npvtdvU4UUHz4ImqAJ7TlrQBmoptX
	 aOzRDNweYBkWtnZ6jDjJUqXWW5wg8PZxLCYTSpnjvz9jruNZrbI5I+i3+8scg5PR9u
	 1rEJY+1GncZCDZSNXwJQGLK5FiHqRmOuEc7FT9ZJF2XzDS7PwAtYn6mRckfvhtghIj
	 uKNUBnbB5NqyH7te9kTRfoPLW6uAdOWK7JOptOjw4gnH5X631i/vVZ10xKp5bKo6xn
	 PKNfQUdwLybog==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, "Jan Kara" <jack@suse.com>, <linux-kernel@vger.kernel.org>
Cc: syzbot@lists.linux.dev
Subject: [PATCH] udf: Mark LVID buffer as uptodate before marking it dirty
Message-ID: <6ffb2ca8-e22f-4fd6-9f37-7202ec0878bd@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 23 Jun 2026 12:30:52 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

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
Link: https://syzkaller.appspot.com/ai_job?id=05f8e20f-f080-4c7f-a206-08dbc15cb4a1
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/fs/udf/super.c b/fs/udf/super.c
index cad2e15d6..7fa2e52cf 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2040,6 +2040,17 @@ static int udf_load_vrs(struct super_block *sb, struct udf_options *uopt,
 	return 0;
 }
 
+static void udf_mark_buffer_dirty(struct buffer_head *bh)
+{
+	/*
+	 * We set buffer uptodate unconditionally here to avoid spurious
+	 * warnings from mark_buffer_dirty() when previous EIO has marked
+	 * the buffer as !uptodate
+	 */
+	set_buffer_uptodate(bh);
+	mark_buffer_dirty(bh);
+}
+
 static void udf_finalize_lvid(struct logicalVolIntegrityDesc *lvid)
 {
 	struct timespec64 ts;
@@ -2075,7 +2086,7 @@ static void udf_open_lvid(struct super_block *sb)
 		UDF_SET_FLAG(sb, UDF_FLAG_INCONSISTENT);
 
 	udf_finalize_lvid(lvid);
-	mark_buffer_dirty(bh);
+	udf_mark_buffer_dirty(bh);
 	sbi->s_lvid_dirty = 0;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	/* Make opening of filesystem visible on the media immediately */
@@ -2108,14 +2119,8 @@ static void udf_close_lvid(struct super_block *sb)
 	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_INCONSISTENT))
 		lvid->integrityType = cpu_to_le32(LVID_INTEGRITY_TYPE_CLOSE);
 
-	/*
-	 * We set buffer uptodate unconditionally here to avoid spurious
-	 * warnings from mark_buffer_dirty() when previous EIO has marked
-	 * the buffer as !uptodate
-	 */
-	set_buffer_uptodate(bh);
 	udf_finalize_lvid(lvid);
-	mark_buffer_dirty(bh);
+	udf_mark_buffer_dirty(bh);
 	sbi->s_lvid_dirty = 0;
 	mutex_unlock(&sbi->s_alloc_mutex);
 	/* Make closing of filesystem visible on the media immediately */
@@ -2397,7 +2402,7 @@ static int udf_sync_fs(struct super_block *sb, int wait)
 		 * Blockdevice will be synced later so we don't have to submit
 		 * the buffer for IO
 		 */
-		mark_buffer_dirty(bh);
+		udf_mark_buffer_dirty(bh);
 		sbi->s_lvid_dirty = 0;
 	}
 	mutex_unlock(&sbi->s_alloc_mutex);


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
