Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5391DDC35
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782300736; cv=none; b=NmXp+efMDeuLdcfpcRQZdlIEVj1BHTKp3B0pOAZT7H4PNrIraYBVrUqqC4p0CitC4FQfGxliuhGEq1Cb3glUIm85WCM1m8NUaV66AgKgV4VdIdFy18aeqLfyj5TafrEKX18MKmNCzYnv1l0vuNSDA6SdKvE81hPC4u+Zjb7yRi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782300736; c=relaxed/simple;
	bh=S8d3bxu4UZgbdnwLcW+Znj+vA9tBHSEVu77/9QNaVJk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=bIpuXvibsiUvMdhJAoSmX8ZPDSWzohL0ZoQwwwB2QSTA0w5OWhqxcbv+IxCLeLpeSMSzhWYnmuhnUZkkduvKiwg/KlnHtJuUHCqKhwSBZW0xUdimiSn8e9YVPCHEFsNLiqZsdJ8EiLTuoQcS8ROvY5jtzV1rIhVrbz/45Q19t1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KWsFKYVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KWsFKYVA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F07D21F000E9;
	Wed, 24 Jun 2026 11:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782300735;
	bh=wRCs+EDT7fB1fjxp50PpuEI2xnfsXIPuXaZLiM97b/w=;
	h=From:To:Cc:Subject:Date;
	b=KWsFKYVAAPGprqhXjsnkISCRDp3mbhVCw22bjlUiK9FpacWdT9a9wimYiiWT/YTtz
	 xVar8kxrz9z2zYlHk0vkEJi/jfEL2c113FZebxZaD5kQvhdZeMZqxNOLSFzSx1kuKK
	 /vdixNPkKWBXTyFEiUwTm+BlhoN6HwVDFRavU2SCnDD2s4ptggSuTkDx+EYyMmCYFF
	 1AHdbvpqE/9N7RIDwJOvtLAugAT+gPWnXGJllZVR1YDKrFTH415HSVFvhQ1rZZiSsW
	 J5RpPYRkkxBqI2J/Bnx07QdSGY3+zi5PDN8Yov5vLweyczQgJimF2ejhMMn0n9IfsB
	 dgl6V/Pu6O5+w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] udf: Replace WARN_ON with udf_warn in udf_truncate_extents()
Message-ID: <d9f03dae-fb04-4714-bfd1-96a003a697b9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 24 Jun 2026 11:32:14 +0000 (UTC)

A corrupted UDF image can present a file where the recorded i_size is
larger than the total length of its extents. When attempting to write to a
huge offset, the block allocation path tries to extend the file by adding
new extents. However, if the filesystem runs out of space, the error
cleanup path invokes udf_truncate_extents() to remove any partially added
extents beyond the original i_size.

Inside udf_truncate_extents(), inode_bmap() is called to find the extent
containing i_size. Since the total extent length is already smaller than
i_size, inode_bmap() reaches the end of the extents and returns 0. The code
then calculates byte_offset (which is strictly positive) and hits the
WARN_ON(byte_offset), producing the following trace:

WARNING: fs/udf/truncate.c:224 at udf_truncate_extents+0xd79/0xef0
fs/udf/truncate.c:224
Call Trace:
 <TASK>
 udf_do_extend_file+0xdc2/0x11e0 fs/udf/inode.c:621
 inode_getblk fs/udf/inode.c:842 [inline]
 udf_map_block+0xfc6/0x4280 fs/udf/inode.c:453
 __udf_get_block+0x52/0x250 fs/udf/inode.c:467
 __block_write_begin_int+0x6c2/0x1930 fs/buffer.c:2042
 block_write_begin+0x8d/0x120 fs/buffer.c:2153
 udf_write_begin+0x11a/0x270 fs/udf/inode.c:261
 generic_perform_write+0x2ad/0x8b0 mm/filemap.c:4325
 udf_file_write_iter+0x2a6/0x650 fs/udf/file.c:112
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61e/0xbb0 fs/read_write.c:688
 ksys_write+0x156/0x270 fs/read_write.c:740
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 </TASK>

The WARN_ON macro must not be used for conditions that can legitimately
happen, such as encountering a corrupted filesystem. Hitting this state is
a filesystem inconsistency, not a kernel bug. While panic_on_warn may be
set in some environments, WARNINGs are generally not fatal on production
systems, but they still incorrectly indicate a kernel bug. Therefore,
pr_err() (or in this case, udf_warn()) should be used instead if necessary.

Replace the WARN_ON with a udf_warn() call to log the inconsistency
gracefully. The function then safely returns 0, which is the correct
behavior since there are no extents beyond i_size to free.

Fixes: 7e49b6f2480c ("udf: Convert UDF to new truncate calling sequence")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+43fc5ba6dcb33e3261ca@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=43fc5ba6dcb33e3261ca
Link: https://syzkaller.appspot.com/ai_job?id=bab17bf0-0c15-4575-b262-063dfb760277
To: "Jan Kara" <jack@suse.com>
To: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 41b2bfd30..ef4a8d876 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -220,8 +220,14 @@ int udf_truncate_extents(struct inode *inode)
 	byte_offset = (offset << sb->s_blocksize_bits) +
 		(inode->i_size & (sb->s_blocksize - 1));
 	if (ret == 0) {
-		/* We should extend the file? */
-		WARN_ON(byte_offset);
+		if (byte_offset) {
+			/*
+			 * Extents are shorter than i_size. This can happen for corrupted
+			 * files. There is nothing to truncate.
+			 */
+			udf_warn(sb, "Extent length is shorter than i_size. "
+				     "Filesystem might be corrupted.\n");
+		}
 		return 0;
 	}
 	epos.offset -= adsize;


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
