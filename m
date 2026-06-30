Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507761B87C0
	for <syzbot@lists.linux.dev>; Tue, 30 Jun 2026 03:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782788746; cv=none; b=nauy/LBe+sAppJAYEYeQ1cxRwyqPHuTfQkv+7k4cIr4jf2rGyB4RvXxN+F5Fd3ZhATuX7+GM0n9nrVubzzxddh3LtBEBsPp1cEk1sZ1HqFOimWqzMErmnuRl2U04EW2eM28uMelbP/FIDV/iaVmUc1S/l1uaAhTEO+yVZVHxQ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782788746; c=relaxed/simple;
	bh=gZGEgMQsqYkk4U6xVt2LXnjcjO41Y9xmH3s6kEZs9wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLK1es+a7eG6SbMXJCXUcbPO04rZuCKGPSPYb1ouKvnMWa1uhHC2Hd1+uV+5gH+55qj5XZcXUK5NhAC1xm2VLC3L78txRgDHtUFSL3C5zXN6+UDlciigjI9DHuuTsC+aAjznQ/K0wp6rJVk5TjGZP8HH/+dLRquTAnbVVfB6frk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QuYTrdk9; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QuYTrdk9"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c89636920a3so1372451a12.1
        for <syzbot@lists.linux.dev>; Mon, 29 Jun 2026 20:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782788744; x=1783393544; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lYUwa5SWJODh41lHbkqVdEqGxK3t/Ss9xv0IBj7fNXs=;
        b=QuYTrdk9yiwf/ea2SpTJQuk390xoZjtuvGS+dEDwXCJ/XtWceujhLkrH/27ca+lQWe
         8o4PVRhPzvbeCI22cclldCRnKVrCTcW4Iic+22Vk3MZyYofLNlf7Ui9EDZqPrx39QUFR
         hNRJU5ltp8064sMz2s3ziNyESwue4XO9De01dF30WEkl+QrCe0I/RYNbYjnFSNdhimaE
         o2XMbEmPol8/E0yXl7T7A21vaYcgBlLbE7+soOlAmaSpc9Im7lHf0V9P0ugETp6Gue4B
         KZWiMHQK7SIrxBs2O5cLCrsvmdOdAqG6CwF6Q475AwRFkgPCBCOUP4pD9Eiq3g3TePRG
         GLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782788744; x=1783393544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lYUwa5SWJODh41lHbkqVdEqGxK3t/Ss9xv0IBj7fNXs=;
        b=sgcyqB+le/6Hbf0mxr78NETyIJkdtEh8XV2ZgiXSDgmAZ3kPURVVl6a/jtN6VBiB+5
         cA4IneM7uugUzjlrhsga3ej5boiTAhxZfFT1zWwj//UFNcolaQKlsm+ZxRa14aenWZEa
         TZ8g3BeEstNw9ANEZclNdON4SxpC6wdCZfKdZrldTEWEpzIoOO58wtoZmxKqgSn7cFcG
         lhHBtw18Cwzv3h3hT0CEGO01LhnYiPX9cNAFgV3ExTPvXB17F6VlG6q6LzUb9g6sTrjm
         bj3f7TXJtKwcqvwOx8Ii2uHwBjPb/f95uOV54MTcxB4Q7DpOQLfn1sEzR1MJ41AyNgCa
         FHjA==
X-Forwarded-Encrypted: i=1; AFNElJ/vu44djlDNDFSlX3ZO5+BqXR3ygW1b9P+mM1jV2NwlPy+9cgLFXoRskoD6zzaSkQjYiuwPN6U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMX4Altobij+yD3KsHJLIy4wlwzFNbT3Wl1rqKRhd3ZeFrXQxI
	O1VlxE4y2wLmW+SoowrZY0RvNbPaNzvv5TPinZfaiWbuOWtJAy0zgAfy
X-Gm-Gg: AfdE7cnJo1SW1sBxwr6Zd6tEa2JXXwslMOn0XE40uQJter+GbcmMPIr+3j4YoTMRj1n
	Xkpi0NPLoi/rirkXN2mre5HNHPfUhVNU9sFcouxmyZh1ntwhCaPF20WPUwxgM1QyjdYHUKuR1R+
	ttVcLHVaqOVzMoDUz5ZcN8QI4XRYgMaMvzmO4uQadNKV0t9Xi8jLALQONbkttX/FLlI5Bm7fOz3
	WuV5vbnZDft8PKadxQzhG4myeHmjR4v+I4qF2okZeSUIotPkSmCmZuagN/BIc/X+qYVNuNc/HUZ
	MItIvGWGL3fzDRnneuaHofKFzGxEI09feuHzAvP2vBnPO0BZs09yyq16KVZey7pjto5hygULqWL
	lWmrWNLfw6arc/4L4IcCmxCDxQe6HQYSe+vKW0dEfIEBdLIyD0HStmSpEa0wVqgc=
X-Received: by 2002:a05:6a20:2447:b0:3bf:866b:b74a with SMTP id adf61e73a8af0-3bfc5273c06mr1526316637.35.1782788744402;
        Mon, 29 Jun 2026 20:05:44 -0700 (PDT)
Received: from nineveh.sos.local ([131.191.24.68])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9bbf95aa99sm638053a12.17.2026.06.29.20.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 20:05:43 -0700 (PDT)
From: Jeremy Bingham <jbingham@gmail.com>
To: syzbot+cie60057db19604ba2@syzkaller.appspotmail.com
Cc: brauner@kernel.org,
	hch@infradead.org,
	jack@suse.cz,
	jbingham@gmail.com,
	jkoolstra@xs4all.nl,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	syzkaller@googlegroups.com,
	viro@zeniv.linux.org.uk
Subject: Re: [syzbot ci] Re: minix: convert to iomap and add direct I/O
Date: Mon, 29 Jun 2026 20:05:35 -0700
Message-ID: <20260630030535.3309854-1-jbingham@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: 6a42024c.9dc7bc9d.3393b4.0006.GAE@google.com
References: <6a42024c.9dc7bc9d.3393b4.0006.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test

minix: add the same dentry check as ext4_get_link to minix_get_link

It turns out that minix_get_link does need to have both the sb_bread and
the sb_getblk paths, like ext4_get_link does. It working with just the
sb_bread one initially was deceptive.
---
 fs/minix/namei.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index e245f55a68ff..a4caaa3f7c9a 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -393,12 +393,23 @@ const char *minix_get_link(struct dentry *dentry, struct inode *inode,
 	else
 		blk = v2_block_to_cpu(*(v2_i_data(inode)));
 
-	bh = sb_bread(sb, blk);
-	if (IS_ERR(bh))
-		return ERR_CAST(bh);
-	if (!bh) {
-		pr_err("bad symlink on inode %llu", inode->i_ino);
-		return ERR_PTR(-EFSCORRUPTED);
+	/* This tried dodging the dentry check that ext4 does, but it turns out
+	 * that it's necessary after all.
+	 */
+	if (!dentry) {
+		bh = sb_getblk(sb, blk);
+		if (!bh || !buffer_uptodate(bh)) {
+			brelse(bh);
+			return ERR_PTR(-ECHILD);
+		}
+	} else {
+		bh = sb_bread(sb, blk);
+		if (IS_ERR(bh))
+			return ERR_CAST(bh);
+		if (!bh) {
+			pr_err("bad symlink on inode %llu", inode->i_ino);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
 	}
 
 	set_delayed_call(callback, minix_free_link, bh);
-- 
2.47.3

