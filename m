Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2F5399377
	for <syzbot@lists.linux.dev>; Thu, 16 Jul 2026 21:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784237474; cv=none; b=XlYJrfJgOmjRUUWxRBslzwC2SiWoa8UyO8HcvVsARSWMTE9CYU/vkkFvdcfRUehiES5flR3cHL0dlJJn06Nvob/pwL/m8L7esuXd96j4+dySwGbkHNrj8/j1jMDqwe+kY/XrqZpKuswDBRLuovvii+9Vt36vStaHllvxFYHsF1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784237474; c=relaxed/simple;
	bh=bhvo7HJDRU7VocgX77YllWoflHAruE07zKM3AnmAqnA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=K4ckFEOSosNPs7pV1KiKVRqUyZQD5yRV5Jaypgr2CiiIDrcUSlwWkKeyk+W5XXALt1d3EXo+OWtd30SZ7CjElUgRJzArdEcP68Nx48D3OabReXSGtx5Ztq6GTaIjvHKhRBg0PoTGFxiUiCIOm1uowCxtR+Iyjt8ujG2hWkwbpA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e9f6a49e69so4749246a34.0
        for <syzbot@lists.linux.dev>; Thu, 16 Jul 2026 14:31:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784237472; x=1784842272;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A5pq07RMCZNLLVlyb02KtB10VIXllMIlLBPo5lICvqE=;
        b=IJ4s/DqoX5+WcIJ8va2rKj+wZHCrfLKpj7VqJrs2+XyGvCyCrNteU/GN0jqGhCSasi
         cknMafOxfWVwXVLkRbqp5DyvH1eIt9F9Jpjuxi+jPN+n08JWIi8+G5ok80aM92KBq3YH
         Lz6nAzZsV1YzAlMRuPWob+h2Mye8zU7L87y1jrXnVIZDRhhoayHEFliJpHtdvhzDEiCZ
         2EVOwEL3lFc6UV1Ubnz91kcHyvq98vcYIazLNdD5/C8Sobgof8+hXAnUH1JPaq5FDosw
         dHebuNy3qflPBeiOtE1z2ZayyRddE9KDfOHCuOIfjDbYxIZFwT1mspHJEZ16JtLK+FBS
         UIoQ==
X-Gm-Message-State: AOJu0Yxa3iXUPfNvl9+XDB8QwM3vpTfE7WoamQlCRNwoCfcAEHintjJ/
	rv7BxNzjGgFnEEkIPKpNVsQyNVTlRaO8sBCu6eATADk0yhzYnrEYnFAkQCX/kAWoGSrH+7D9kfq
	r/W6D2hpMW4oGsrbNW2bwGcCYkdsQovsff67PBYxot1Qd7fZXBPzThUacXcc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f48:b0:6a3:7822:9390 with SMTP id
 006d021491bc7-6a4705a8acemr625143eaf.25.1784237472223; Thu, 16 Jul 2026
 14:31:12 -0700 (PDT)
Date: Thu, 16 Jul 2026 14:31:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a594da0.42649fcc.a68e.05cd.GAE@google.com>
Subject: [moderation/CI] Re: fs: Fix missed inode write during fsync
From: syzbot ci <syzbot+cib6966372cefae766@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] fs: Fix missed inode write during fsync
https://lore.kernel.org/all/20260716145359.28639-1-jack@suse.cz
* [PATCH v4 01/21] affs: Drop support for metadata bh tracking
* [PATCH v4 02/21] fs: Fix possible UAF in mark_buffer_write_io_error()
* [PATCH v4 03/21] fs: Fix missed inode writeback when racing with __writeback_single_inode
* [PATCH v4 04/21] ext4: Allocate mapping_metadata_bhs struct on demand
* [PATCH v4 05/21] fs: Provide way for filesystem to wait for metadata writeback
* [PATCH v4 06/21] ext2: Fix lost inode updates for IS_SYNC inodes
* [PATCH v4 07/21] ext2: Drop __ext2_write_inode()
* [PATCH v4 08/21] ext2: Avoid unnecessary inode buffer writeback for sync(2)
* [PATCH v4 09/21] ext2: Fix data integrity writeout issues
* [PATCH v4 10/21] udf: Fix data integrity writeout issues
* [PATCH v4 11/21] udf: Use sync_inode_metadata() to writeout IS_SYNC inode
* [PATCH v4 12/21] udf: Drop udf_sync_inode()
* [PATCH v4 13/21] udf: Use sync_inode_metadata() in udf_evict_inode()
* [PATCH v4 14/21] udf: Fold udf_update_inode() into udf_write_inode()
* [PATCH v4 15/21] bfs: Fix data integrity writeout issues
* [PATCH v4 16/21] minix: Fix data integrity writeout issues
* [PATCH v4 17/21] ext4: Fix data integrity writeout issues in nojournal mode
* [PATCH v4 18/21] fat: Fix missed inode writeback during fsync(2)
* [PATCH v4 19/21] fat: Remove some superfluous sync_dirty_buffer() calls
* [PATCH v4 20/21] fat: Replace fat_sync_inode() with sync_inode_metadata()
* [PATCH v4 21/21] vfs: Remove mmb_fsync()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/e6aa6f56-8c07-45cd-b1f0-7496a7e04c37

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      37e2f878a7a660a216cc7a60459995fefd150f25
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/2ee33f91-1593-4a29-b326-61478d582a3c/config

fs/bfs/inode.c:180:43: error: no member named 'ino' in 'struct inode'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[aivazian.tigran@gmail.com brauner@kernel.org dsterba@suse.com hirofumi@mail.parknet.co.jp jack@suse.cz linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org sashiko-bot@kernel.org stable@vger.kernel.org tytso@mit.edu]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

