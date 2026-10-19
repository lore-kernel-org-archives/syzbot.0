Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792434995;
	b=29mpaDR5z3o7ujQYQuIn14U9lEgS21HscARQpuvCyFSm2ZNHe2sGckvwMJD5RSIZtEG3
	 g+vAf5Zx68ipIHF4oZoTagaKYxQWQ+t2s1iM3GS6Se4WD/Gz0gVVkEXQ3Hlm7kgw9ler8
	 SlxnkMxJmnwwNifeAZM2MU93MSzyscw9uzRVTHQCfo0CpwIN6wU2398BPmttfIlMqH0PG
	 +jIpuXwqHqr2SJmbAlLbMusqBKOJ7KO8B/oGMAhoW/5gqpLEZwAkk1WUZr80KpYtAD5D2
	 ejvHiFaMd9u83OBR6yAcnjyRu1dyVDnEc8Tj5bimiYXmRjGCMF8yhBkO29sIKbTfBeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792434995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=9PH4KLZ3tyAygUBEXzTve3wmVml1VbKtFpV4n07IzGk=;
	b=nW6TuwP2VpP+40vTJC3Cv0uiUNcHmMfX6P/3Oix3XYwFj8W3d+z9pzOKG/UBhuvkP+/1
	 oEZZ11A202Jy3an7r7s/0Avcu6XKzw5KbvjmHdY+dHYe0qaprsBgDhHs4eW1hzBJh9Tq0
	 SPejpc1yGMHmHve6JtOW207RSAX2Q68meS7B7+kw7OlZPCniI1XkbFXOZiiqfYQgD5LbR
	 /RCK/or2trghjm22BIFCUJMaACQqm8pKnUMjYc44rk8G1Bm6zMrZn6y48mJsLBlyd0gwf
	 +FhsAC4sMP8EP6QV9cvZJEQpy157Gy5MA44fhGuSXZQ1GbrpeX8gqx6CQmbUhsEElRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eaws6XP9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7E7EB606A31B
	for <syzbot@lists.linux.dev>; Mon, 19 Oct 2026 18:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eaws6XP9
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EFE941F000C4;
	Mon, 19 Oct 2026 18:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792434995;
	bh=9PH4KLZ3tyAygUBEXzTve3wmVml1VbKtFpV4n07IzGk=;
	h=From:To:Cc:Subject:Date;
	b=Eaws6XP9CfRgqeXNAnyWmGzaT5sY/uKAxr7ZsA9jt4XkTSpx5gSonNCFulOXaCA4P
	 lRoteJ//J8Wex7yMAXHD5Cd5hfO0dfcBkhja8tFWSW8DYEWf8G9GRalW9XUoASwoET
	 H4KSN0C/Fuh4H02uUMLadze8/ujn0z1tnWp45NhD32EIyvbIr/oTEAj4VLdrC86xcn
	 1BGp3B8kFsGBVxjFaovyc78uEetVxLGBk5njjNhkrUTxFH/fmtMaHMLgLWVcnMaxmh
	 ShtYpPjgmlo+SQ1j0xnUuTAhBjejPNopBXVAJKgm0R10pQHqwjbHFqauRu/hZzB4bh
	 AxgZ2ycR7lvMg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fs/qnx6: fix divide-by-zero in qnx6_mmi_fill_super()
Message-ID: <55af487d-2039-414c-bd3c-13e61d9be43f@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 19 Oct 2026 18:36:34 +0000 (UTC)

When mounting a qnx6 filesystem with the "mmi_fs" option on a device
containing invalid or all-zero superblock data with MS_SILENT (SB_SILENT)
set, a divide error occurs in qnx6_mmi_fill_super():

Oops: divide error: 0000 [#1] SMP
RIP: 0010:qnx6_mmi_fill_super+0x228/0x870 fs/qnx6/super_mmi.c:68
Call Trace:
 <TASK>
 qnx6_fill_super+0x174/0x1380 fs/qnx6/inode.c:318
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1872
 vfs_get_tree+0x92/0x2a0 fs/super.c:1932
 fc_mount fs/namespace.c:1282 [inline]
 do_new_mount_fc fs/namespace.c:3898 [inline]
 do_new_mount+0x325/0xb00 fs/namespace.c:3974
 do_mount fs/namespace.c:4338 [inline]
 __do_sys_mount fs/namespace.c:4556 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4533
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

This happens due to two issues in qnx6_mmi_fill_super(). First, when
validating the first superblock magic number (sb1->sb_magic), the goto
statement was mistakenly placed inside the "if (!silent)" block. The silent
flag is only intended to suppress error messages during filesystem probing;
placing "goto out;" inside the condition allowed execution to continue
despite a magic mismatch when silent was non-zero. If the device data is
zeroed, the subsequent CRC-32 check over zero bytes also matches a zero
checksum. Second, qnx6_mmi_fill_super() calculated the secondary superblock
offset by dividing QNX6_SUPERBLOCK_AREA by sb1->sb_blocksize before
verifying or setting the block size via sb_set_blocksize(). With an invalid
or zeroed superblock, sb1->sb_blocksize is zero, resulting in a
divide-by-zero crash.

Fix this by moving "goto out;" outside of the "if (!silent)" block so that
magic mismatches are always fatal, and reordering sb_set_blocksize() and
the buffer head reload before calculating the offset. In addition, compute
the superblock offset using bit shifts with s->s_blocksize_bits, aligning
the implementation with qnx6_fill_super().

Fixes: 5d026c724220 ("fs: initial qnx6fs addition")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+6a0633f11d3fb88860bf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6a0633f11d3fb88860bf
Link: https://syzkaller.appspot.com/ai_job?id=e9b52e1b-22e1-4fdd-8fb9-02e15cff1d49
To: <linux-kernel@vger.kernel.org>
To: "Kai Bankett" <chaosman@ontika.net>
Cc: "Kees Cook" <kees@kernel.org>

---
diff --git a/fs/qnx6/super_mmi.c b/fs/qnx6/super_mmi.c
index b8afb6f38..fe02e51e1 100644
--- a/fs/qnx6/super_mmi.c
+++ b/fs/qnx6/super_mmi.c
@@ -51,10 +51,9 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 	sb1 = (struct qnx6_mmi_super_block *)bh1->b_data;
 	sbi = QNX6_SB(s);
 	if (fs32_to_cpu(sbi, sb1->sb_magic) != QNX6_SUPER_MAGIC) {
-		if (!silent) {
+		if (!silent)
 			pr_err("wrong signature (magic) in superblock #1.\n");
-			goto out;
-		}
+		goto out;
 	}
 
 	/* checksum check - start at byte 8 and end at byte 512 */
@@ -64,10 +63,6 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 		goto out;
 	}
 
-	/* calculate second superblock blocknumber */
-	offset = fs32_to_cpu(sbi, sb1->sb_num_blocks) + QNX6_SUPERBLOCK_AREA /
-					fs32_to_cpu(sbi, sb1->sb_blocksize);
-
 	/* set new blocksize */
 	if (!sb_set_blocksize(s, fs32_to_cpu(sbi, sb1->sb_blocksize))) {
 		pr_err("unable to set blocksize\n");
@@ -80,6 +75,10 @@ struct qnx6_super_block *qnx6_mmi_fill_super(struct super_block *s, int silent)
 		goto out;
 	sb1 = (struct qnx6_mmi_super_block *)bh1->b_data;
 
+	/* calculate second superblock blocknumber */
+	offset = fs32_to_cpu(sbi, sb1->sb_num_blocks) +
+		(QNX6_SUPERBLOCK_AREA >> s->s_blocksize_bits);
+
 	/* read second superblock */
 	bh2 = sb_bread(s, offset);
 	if (!bh2) {


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
