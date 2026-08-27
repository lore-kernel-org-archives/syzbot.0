Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA18333F5BE
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 07:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787814465; cv=none; b=AxkkL36tXzW3z++CD9aDkXl3aHcFcHwEaxlk1avLDGQXtPmRe410KKb1gCIYSg386SLcx3kuFIV4zvFUS+IuECx+8Q8mdZ97sc0jSvdl3SVT+PxgXebo7B7Py1w1I83MAg9iyd5RjJCQEnW/yBjETfnOogyz2PHG6dQUpYVRd8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787814465; c=relaxed/simple;
	bh=QbPCyScwELYSWUK6XKQmMzPXKoPS3fzZJrTF3UqRp6I=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qlQoDolM7JAfEuDIbTbvPdCMc/2cOl2V6joOVzAqbOM8xWJcPU6n8F37WBSPt9fW57SthzJzytPV3zGcV0G/0vwOihxs1Fo8UrC3N7ReA/ZuXLrcLRcKhLYDd2cOPTXtNkOvjiEgRFgBm1YIZ7082pDNcncZ6qOyZkGpEVtAujA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7ee1e335245so2492307a34.1
        for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 00:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787814463; x=1788419263;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qIYbJ/Nh4+sGVmd8cf4dzYU/ojdee6wKOrg3W1+Wsd4=;
        b=qmlmlgdLyonp/F45r4b9pf5jnIRjSC9CQX3DdFauUNT78VF8R4SXBpIlv0POQh3scJ
         3pZ5DWQBRlP58BtewUXWnxrnl+SSkfYxLjoFcbu0JgqeaFaLbySYA0buHac7zZo/gkFD
         qy2jK3OGfc/nE72RkiDkqNpr/eLK6ZqfcwfBGGgsLVHr0tEgWk/SqKHzm8sXGWFw0kYA
         tjUONUMwOk9osO95Pa7IQgjlxqtWTWjPrhScyPPjeXewzcmD3gubsDhN5/rFsHHGrS7M
         bILWFbeZT1gm6Xa+iezCUebcBlkLyCVCy3MVXZpiDmF4LlfjlHmbvRI4nMMX8yHC3io/
         Qavw==
X-Gm-Message-State: AFuF++mt3BAV8/IrNSqCv2YYUEuyS2mfg1tEKCgQkxOJ5rjaeo5HPT4m
	laSw3MF8lPwtyYoCHiqcUXz9uIHOJOOQKmAlCxgNY4vJ5clar/VqHxZSF0fZWz9B/Enz+UklEID
	g/5YUE4UiSlHSk+6GHXDrzO1GVQbSzLuvA2Mvq5Apco7iEO4bkqXPz8PRnTk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8590:20b0:6b1:464d:4d1d with SMTP id
 006d021491bc7-6b1a03c6c50mr9814220eaf.11.1787814462856; Thu, 27 Aug 2026
 00:07:42 -0700 (PDT)
Date: Thu, 27 Aug 2026 00:07:42 -0700
In-Reply-To: <20260826225614.486112-1-slava@dubeyko.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8fe23e.50659fcc.60cd.000f.GAE@google.com>
Subject: [syzbot ci] Re: hfsplus: convert regular file I/O to iomap-based operations
From: syzbot ci <syzbot+ci21077433d711a695@syzkaller.appspotmail.com>
To: frank.li@vivo.com, glaubitz@physik.fu-berlin.de, hch@lst.de, 
	linux-fsdevel@vger.kernel.org, slava@dubeyko.com, vdubeyko@coreweave.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] hfsplus: convert regular file I/O to iomap-based operations
https://lore.kernel.org/all/20260826225614.486112-1-slava@dubeyko.com
* [PATCH v2 1/7] hfs/hfsplus: exchange hardcoded number of extents on named constants
* [PATCH v2 2/7] hfsplus: rework hfsplus_get_block() logic
* [PATCH v2 3/7] hfsplus: take the bitmap page lock for allocate/free
* [PATCH v2 4/7] hfsplus: add iomap operations for regular file data
* [PATCH v2 5/7] hfsplus: move file related operations to file.c
* [PATCH v2 6/7] hfsplus: introduce iomap-based file_operations
* [PATCH v2 7/7] hfsplus: switch address_space_operations on iomap-based support

and found the following issue:
WARNING in iomap_iter

Full report is available here:
https://ci.syzbot.org/series/21631741-87b3-4cdc-90a9-ac84e2b3d36c

***

WARNING in iomap_iter

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      5870ce43c013ad564b3b83bae330b160e056df67
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/c6a44359-3e63-48aa-be4b-563b7e0cf103/config
syz repro: https://ci.syzbot.org/findings/eadf0b2b-9eed-4d75-809d-bfcd1608c785/syz_repro

------------[ cut here ]------------
iter->iomap.offset + iter->iomap.length <= iter->pos
WARNING: fs/iomap/iter.c:32 at iomap_iter_done fs/iomap/iter.c:32 [inline], CPU#1: syz.1.18/5854
WARNING: fs/iomap/iter.c:32 at iomap_iter+0x976/0xf80 fs/iomap/iter.c:114, CPU#1: syz.1.18/5854
Modules linked in:
CPU: 1 UID: 0 PID: 5854 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:iomap_iter_done fs/iomap/iter.c:32 [inline]
RIP: 0010:iomap_iter+0x976/0xf80 fs/iomap/iter.c:114
Code: ff ff ff e9 86 fa ff ff e8 57 d4 5b ff 90 0f 0b 90 e9 09 fd ff ff e8 49 d4 5b ff 90 0f 0b 90 e9 3a fd ff ff e8 3b d4 5b ff 90 <0f> 0b 90 e9 95 fd ff ff e8 2d d4 5b ff 90 0f 0b 90 e9 c5 fd ff ff
RSP: 0018:ffffc900036ff7e8 EFLAGS: 00010293
RAX: ffffffff826b2d75 RBX: ffffc900036ff940 RCX: ffff88810a7ebb80
RDX: 0000000000000000 RSI: 0000000000005405 RDI: 0000000000005400
RBP: ffffc900036ff948 R08: ffffc900036ff770 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffffff82b1d450 R12: 0000000000005405
R13: 1ffff920006dff28 R14: 1ffff920006dff29 R15: 0000000000005400
FS:  00007f9b7a8b06c0(0000) GS:ffff8882a8f52000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe0db470000 CR3: 000000010d3a2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 iomap_file_buffered_write+0x262/0xbb0 fs/iomap/buffered-io.c:1308
 hfsplus_file_write_iter+0x717/0xa90 fs/hfsplus/file.c:236
 do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
 vfs_writev+0x343/0x990 fs/read_write.c:1058
 do_pwritev fs/read_write.c:1154 [inline]
 __do_sys_pwritev2 fs/read_write.c:1212 [inline]
 __se_sys_pwritev2+0x177/0x2a0 fs/read_write.c:1203
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9b7999e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9b7a8b0028 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f9b79c25fa0 RCX: 00007f9b7999e0d9
RDX: 0000000000000001 RSI: 0000200000000100 RDI: 0000000000000004
RBP: 00007f9b79a35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000005405 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9b79c26038 R14: 00007f9b79c25fa0 R15: 00007ffff695e668
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
