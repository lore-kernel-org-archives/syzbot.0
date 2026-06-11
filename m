Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7101A3D47A7
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781179701; cv=none; b=lQaJXu+WD8DQz1lqI2+6b91kDMQOqUo5KL1DcARa5FPNvicvelCcvlhR3U7plNnuZIPeM/lKVFovxkdq7+/RGIrjHstsFxCdUm3QYC7wyawY8RuxUAKJrljYwmzmA/JgGPcmI6F5ZdcWObUKph3aCuF1BB+wDY06k5ozbr9f+3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781179701; c=relaxed/simple;
	bh=nTpGAk8WaFGlNDfWwgVJfDj2MLZFlF2JO5bqSk7mX+M=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=YuGTfCyLMxSaouVpyFOkkOeQK0YOxsUbKuRAXEVUNXIcS133yiXhhRFnK/mPjK5u5ySGenNLAvcQTLwhJov80o8iqEAO6vJp2SaXEzI1ZNiAPWJ7NgyDrjxHPzObdI1Ft7jivOIMku+ctZOpZjNBFWpuJyUyTDgpC5ZfuK42xdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0QRCPYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0QRCPYM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 131871F00893;
	Thu, 11 Jun 2026 12:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781179700;
	bh=g2w+/xoTzBMUO6U95E0s1k50m+CupO983YYNMw43aSU=;
	h=From:To:Cc:Subject:Date;
	b=b0QRCPYMJYjXE1OVGRG3Lg5LYjVxFuz5yWscV4EITjaXXx0hO/AprpklXS3/wc0hd
	 XCCgmi9f4VGIwZJBiszDWHpfDSXffqv1ErRH8+ipqGVYPXIqVfaRyR/uwfOKFJkDHz
	 71LtvdoCvOezwMrZ141XpL4v7RzQN/oRyDjmnkC9ELj76kHbMUp6zUxQlbmaDnPV2u
	 3yv0V5hwCUm51Z+oonZV/ZBc00noL7sqRWDmvkBnsLU+NZTHfngUooFe5J6fHIWQHe
	 GXHVHlloEBbaY07MstnfFjRH9IaCCYSFEfxdSBXo78mGrSpIo5dczgeekku8r9orRK
	 QQl0C7TVxOPcQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] hfs/hfsplus: remove WARN_ON() and fix error handling in hfs_bnode_create
Message-ID: <4822d036-ffeb-41e0-b202-02e203a6f5b4@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 11 Jun 2026 12:08:20 +0000 (UTC)

When a new btree node needs to be allocated, the filesystem scans the
allocation bitmap to find a free bit. If the filesystem image is corrupted,
the bitmap might incorrectly indicate that an already-used node is free.
This causes hfs_bnode_create() to find that the node is already present in
the in-memory hash table. When this happens, it prints a critical message
and hits a WARN_ON(1).

A corrupted filesystem should fail gracefully with an error code. WARN_ON()
must not be used for conditions that can legitimately happen due to
corrupted images, and pr_err() should be used instead.

Recently, commit d8a73cc46c84 ("hfsplus: return error when node already
exists in hfs_bnode_create") changed hfs_bnode_create() in
fs/hfsplus/bnode.c to return ERR_PTR(-EEXIST) instead of returning the
existing node, but left the WARN_ON(1) in place. Furthermore, the exact
same bug exists in the older hfs filesystem (fs/hfs/bnode.c), which was not
fixed by that commit. In fs/hfs/bnode.c, hfs_bnode_create() still triggers
the WARN_ON(1) and returns the existing node without incrementing its
refcount, which leads to a BUG_ON(!atomic_read(&node->refcnt)) in
hfs_bnode_put() and corrupts the btree in memory.

Fix this by removing the WARN_ON(1) in both fs/hfs/bnode.c and
fs/hfsplus/bnode.c, downgrading the log message from pr_crit() to pr_err(),
and changing the return value in fs/hfs/bnode.c to ERR_PTR(-EEXIST) to
align with the hfsplus implementation.

hfsplus: new node 0 already hashed?
WARNING: fs/hfsplus/bnode.c:634 at hfsplus_bnode_create+0x45d/0x4f0
fs/hfsplus/bnode.c:634
...
Call Trace:
 <TASK>
 hfs_bnode_split+0xd2/0x1090 fs/hfsplus/brec.c:248
 hfsplus_brec_insert+0x3bc/0xd70 fs/hfsplus/brec.c:100
 hfsplus_create_cat+0xa64/0x11f0 fs/hfsplus/catalog.c:308
 hfsplus_mknod+0x186/0x3f0 fs/hfsplus/dir.c:538
 hfsplus_mkdir+0x2c/0x40 fs/hfsplus/dir.c:579
 vfs_mkdir+0x40b/0x630 fs/namei.c:5271
 filename_mkdirat+0x289/0x520 fs/namei.c:5304
 __do_sys_mkdirat fs/namei.c:5325 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5322
 </TASK>

Fixes: d8a73cc46c84 ("hfsplus: return error when node already exists in hfs_bnode_create")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+2bf21610eea63cb2ce93@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2bf21610eea63cb2ce93
Link: https://syzkaller.appspot.com/ai_job?id=7b105f12-f88e-46a6-9fc6-e0df3a1532e4
To: "Yangtao Li" <frank.li@vivo.com>
To: "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>
To: <linux-fsdevel@vger.kernel.org>
To: "Viacheslav Dubeyko" <slava@dubeyko.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index 13d58c51f..3c49f6c64 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -516,9 +516,8 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
 	node = hfs_bnode_findhash(tree, num);
 	spin_unlock(&tree->hash_lock);
 	if (node) {
-		pr_crit("new node %u already hashed?\n", num);
-		WARN_ON(1);
-		return node;
+		pr_err("new node %u already hashed?\n", num);
+		return ERR_PTR(-EEXIST);
 	}
 	node = __hfs_bnode_create(tree, num);
 	if (!node)
diff --git a/fs/hfsplus/bnode.c b/fs/hfsplus/bnode.c
index f8b5a8ae5..2375b8f21 100644
--- a/fs/hfsplus/bnode.c
+++ b/fs/hfsplus/bnode.c
@@ -630,8 +630,7 @@ struct hfs_bnode *hfs_bnode_create(struct hfs_btree *tree, u32 num)
 	node = hfs_bnode_findhash(tree, num);
 	spin_unlock(&tree->hash_lock);
 	if (node) {
-		pr_crit("new node %u already hashed?\n", num);
-		WARN_ON(1);
+		pr_err("new node %u already hashed?\n", num);
 		return ERR_PTR(-EEXIST);
 	}
 	node = __hfs_bnode_create(tree, num);


base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
