Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB491D7E41
	for <syzbot@lists.linux.dev>; Thu,  2 Jul 2026 20:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783024316; cv=none; b=g6lbfh46723oM8f0OOdK90eP5RfkTmgHv1xZvOfH27xU+LtBxmRTDbNS+kLJweD+FsC0TH2u7eN5V+XdpxX2QjIvHsDtMAY0GY2vDipQvOMKywVg+PAbwBEH27x3Jn1exThLVuBJ24XPqwslrX0WQ0EWxKYd5poMDuot5kNZqmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783024316; c=relaxed/simple;
	bh=zmhfTwecQCvQHefKuiTSG5LbMwANEDxIdWaadLdupo8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=UMGXvgE3RJHkWJkLxm6rVyLBJqug5M1wDC0Ph+bOuYH9StkBXJroYIMPETJ2Di26zRnhInv1UvoqZdjuc7xipirUHwcRwVymV2H3twXmvQd0lnOyiyi4pR/Paf0/Rpvk7V4mw+CZwpKt5ToNZePAFQ0Q5FHcXn0PNDkPdvaKfrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-489677a16bbso1467384b6e.0
        for <syzbot@lists.linux.dev>; Thu, 02 Jul 2026 13:31:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783024314; x=1783629114;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8gUgUQWbJ1oSHweA7rNAj68WBZScQkJkHHmZL9QGa/8=;
        b=qGE+mhwuzuVDfVjp56O6IPUHF/K4zFUBfB+JmuAGYMo5+aQYVMKPicLKNywdToalGk
         dO3Vsa+ySteZCcN5qn4p98o+Jk8KtyxjCeA2S9sIwk9AWdIgl4C4sDJsQe/gVbprf3wf
         e/N/0B3e/fd1x/pwYwGwVH080HJ6xtzMZl+xEaJIIF1Qgu7K4yevBrZBu+n5JERjydBJ
         RwuaXnFiwItPL9vF6QCohN5gegaWU2NNv7qxTEC6KK5jwsx8z5lI5A4SjEEZ+dbUVixo
         scABbQtVzMyzAcDnD+89LfKyyJGcPjzfoKwKEPK5H3KTmXN8TxmPNwZIr5fUD5rfiAZ2
         iBaA==
X-Gm-Message-State: AOJu0Yw4sgeZS4YrwonaCzLmON23LNSy3NIv6eEjC4eTPT9AFbs2PNoW
	TLZYw6jrVauD6D+yDEnM6MhG81oAM+dc/u5YxRjt1pJCmZeP6YPHQxT2m9ngwavQBbs8HGoDz6Q
	c1eYF4ryEJiBDATpEGPOpE8+RYPo3MvhACJbCoSultFd5/mySPZgvcRjL/FI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:30a5:b0:492:285c:4da8 with SMTP id
 5614622812f47-4960ee7e630mr6021499b6e.13.1783024314242; Thu, 02 Jul 2026
 13:31:54 -0700 (PDT)
Date: Thu, 02 Jul 2026 13:31:54 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a46caba.7b9523b0.16a4a.0003.GAE@google.com>
Subject: [moderation/CI] Re: fs: Fix missed inode write during fsync
From: syzbot ci <syzbot+ci6479556fa4e328b6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] fs: Fix missed inode write during fsync
https://lore.kernel.org/all/20260702175436.12226-1-jack@suse.cz
* [PATCH v3 01/19] affs: Drop support for metadata bh tracking
* [PATCH v3 02/19] fs: Fix possible UAF in mark_buffer_write_io_error()
* [PATCH v3 03/19] fs: Fix missed inode writeback when racing with __writeback_single_inode
* [PATCH v3 04/19] ext4: Allocate mapping_metadata_bhs struct on demand
* [PATCH v3 05/19] ext2: Drop __ext2_write_inode()
* [PATCH v3 06/19] ext2: Avoid unnecessary inode buffer writeback for sync(2)
* [PATCH v3 07/19] fs: Provide way for filesystem to wait for metadata writeback
* [PATCH v3 08/19] ext2: Fix data integrity writeout issues
* [PATCH v3 09/19] udf: Fix data integrity writeout issues
* [PATCH v3 10/19] udf: Use sync_inode_metadata() to writeout IS_SYNC inode
* [PATCH v3 11/19] udf: Write all metadata for IS_SYNC inodes
* [PATCH v3 12/19] udf: Fold udf_update_inode() into udf_write_inode()
* [PATCH v3 13/19] bfs: Fix data integrity writeout issues
* [PATCH v3 14/19] minix: Fix data integrity writeout issues
* [PATCH v3 15/19] ext4: Fix data integrity writeout issues in nojournal mode
* [PATCH v3 16/19] fat: Fix missed inode writeback during fsync(2)
* [PATCH v3 17/19] fat: Remove some superfluous sync_dirty_buffer() calls
* [PATCH v3 18/19] fat: Replace fat_sync_inode() with sync_inode_metadata()
* [PATCH v3 19/19] vfs: Remove mmb_fsync()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a71b0842-80ca-4520-bf44-525b2ea88c3f

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      4a50a141f05a8d1737661b19ee22ff8455b94409
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/44a56ebd-5735-4ac4-8072-f7df3748e13e/config

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
[aivazian.tigran@gmail.com brauner@kernel.org dsterba@suse.com hirofumi@mail.parknet.co.jp jack@suse.cz linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org sashiko-bot@kernel.org tytso@mit.edu]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

