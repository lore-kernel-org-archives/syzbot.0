Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1861F1DF980
	for <syzbot@lists.linux.dev>; Mon, 22 Dec 2025 18:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766427592; cv=none; b=Jhant7uAlZQ57wfO9yKl+IrqRV3ZXqjCnXcn45ygS6DplD6QVYbdZjVtURIwqpm/oo7ZSxVN1Nx7rUyMgahkbrM4oGvKqIuwvwGVeeiFbrIw9HH6ru+lQC/v/fdgdIvkN+hZpMTRB9h3Bib+ROTvONj0Vvi05lm3QcKKr7bBJqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766427592; c=relaxed/simple;
	bh=zoB9WTycZYlcT375LvPFZ8UwGumcL4DUERMOci3LrPU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ErW1XQSiYxfvfhzUKwNyV2myO+qyAZgk+zuYhCftFWQnpZ5CdXrQQlIINMYJKTsFkkuqY8TlPvow7QaWOl6++9mFG2OX2PWVOUOQA+a0m9rzArxybpU0q/Voa/aicJTRnqUXGdKfYcdaoD0xVPXu+qO7usW5DBVmhf0j0Qf6w2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7c6c91ba9caso6966200a34.0
        for <syzbot@lists.linux.dev>; Mon, 22 Dec 2025 10:19:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766427590; x=1767032390;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z2TcRgZTCUinqu6beTtdcmLThf3/z6J/gPH2H/hsi+I=;
        b=ZnVd76fmbtQKyzLiAgZN5/cVp0Mi7A574yEpRl/wt1fmd4rl9rIFihwXbfoNGWdl0o
         N1Xg7efACQX5DSXVgiTYzrRnLCBMDS6PttxwG3ygN0E5g8Xu7VVlfnBc89yqLis9gKQs
         7VxcHY0pj0otqyDcGDdiZbmt+Hil3DpJYgkoIElQntLf3+nsSRaAgEp2azGDhIJD34nV
         8+rI6cCIjI0lrBXbG0760hEu5TTEuMnj5Sj9qrYRIIRZgSD+IJC2eIvMcK5K++oiTwMS
         ksYd4yTRYC7/JF27olzxKBDnnXBqiULng++iwQiBAItwl0wYgNcc0YSsph503BkVuMde
         EhHg==
X-Gm-Message-State: AOJu0YxR6o6R14RNIWwq+JsnrEVK5F9BiPqn95j2OUwmbC7acRWrTZbQ
	lkUc9c8sRqGUlUfB9ewbBIqI7N92gmg/YMrfJyobYZdJcDLkKyZimICCjhPUEKhkJQqlf/EI99G
	qSyiIsmNTasGcF1hYR/zzsv3IWzLxOXUrsYvVpKs8rVfcfga/Uccd/Mx1p3g=
X-Google-Smtp-Source: AGHT+IFxasaWB9MgSl5+y7XGup7RicAWunj04sy0xZfJRhPWer8WAxDpYpkwxshH5gJ8A3Y/FxO5OeKfsZkO0/ecqO7DI5+17nZw
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f029:b0:65d:c57:70b3 with SMTP id
 006d021491bc7-65d0e94d36bmr6149049eaf.12.1766427590033; Mon, 22 Dec 2025
 10:19:50 -0800 (PST)
Date: Mon, 22 Dec 2025 10:19:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69498bc6.050a0220.19928e.0010.GAE@google.com>
Subject: [moderation/CI] Re: mm/fadvise: validate offset in generic_fadvise
From: syzbot ci <syzbot+cie835daeda3271b88@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/fadvise: validate offset in generic_fadvise
https://lore.kernel.org/all/20251222141817.13335-1-klourencodev@gmail.com
* [PATCH] mm/fadvise: validate offset in generic_fadvise

and found the following issue:
kernel BUG in txEnd

Full report is available here:
https://ci.syzbot.org/series/fc87bf1f-7746-42da-971b-80c1c5d45fa5

***

kernel BUG in txEnd

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      c642ecda5b136882e518d8303863473c0d21ab2f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/f150d8b9-3b52-4d7f-8778-6840ac1c08ab/config
syz repro: https://ci.syzbot.org/findings/e8d4e924-8db8-410f-aa5a-5372cef5866c/syz_repro

ERROR: (device loop0): xtTruncate: xt_getpage: xtree page corrupt
BUG at fs/jfs/jfs_txnmgr.c:529 assert(tblk->next == 0)
------------[ cut here ]------------
kernel BUG at fs/jfs/jfs_txnmgr.c:529!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6257 Comm: syz.0.86 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:txEnd+0x51f/0x530 fs/jfs/jfs_txnmgr.c:529
Code: e9 cc fe ff ff e8 51 24 75 fe 48 c7 c7 20 94 a5 8b 48 c7 c6 19 90 a5 8b ba 11 02 00 00 48 c7 c1 60 94 a5 8b e8 b2 12 db fd 90 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffc900035b73a0 EFLAGS: 00010246
RAX: 0000000000000036 RBX: ffff8881168ab000 RCX: a45a110d5a473f00
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: ffffc90002af1a22 R08: ffff88823c6247d3 R09: 1ffff110478c48fa
R10: dffffc0000000000 R11: ffffed10478c48fb R12: 1ffff9200055e349
R13: dffffc0000000000 R14: ffffc90002af1a48 R15: 00000000000000ca
FS:  00007f86e7afa6c0(0000) GS:ffff8882a9e32000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000005ff0 CR3: 0000000110ef0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 jfs_truncate_nolock+0x2b6/0x340 fs/jfs/inode.c:399
 jfs_truncate fs/jfs/inode.c:420 [inline]
 jfs_write_failed+0x119/0x190 fs/jfs/inode.c:295
 jfs_direct_IO+0x1f4/0x220 fs/jfs/inode.c:350
 generic_file_direct_write+0x1db/0x3e0 mm/filemap.c:4248
 __generic_file_write_iter+0x11d/0x230 mm/filemap.c:4417
 generic_file_write_iter+0x117/0x550 mm/filemap.c:4457
 iter_file_splice_write+0x972/0x10b0 fs/splice.c:738
 do_splice_from fs/splice.c:938 [inline]
 direct_splice_actor+0x101/0x160 fs/splice.c:1161
 splice_direct_to_actor+0x5a8/0xcc0 fs/splice.c:1105
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x181/0x270 fs/splice.c:1230
 do_sendfile+0x4da/0x7e0 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x13e/0x190 fs/read_write.c:1417
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f86e6b8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f86e7afa038 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f86e6de5fa0 RCX: 00007f86e6b8f7c9
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000004
RBP: 00007f86e6bf297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020fffe85 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f86e6de6038 R14: 00007f86e6de5fa0 R15: 00007ffff03138d8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:txEnd+0x51f/0x530 fs/jfs/jfs_txnmgr.c:529
Code: e9 cc fe ff ff e8 51 24 75 fe 48 c7 c7 20 94 a5 8b 48 c7 c6 19 90 a5 8b ba 11 02 00 00 48 c7 c1 60 94 a5 8b e8 b2 12 db fd 90 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffc900035b73a0 EFLAGS: 00010246
RAX: 0000000000000036 RBX: ffff8881168ab000 RCX: a45a110d5a473f00
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: ffffc90002af1a22 R08: ffff88823c6247d3 R09: 1ffff110478c48fa
R10: dffffc0000000000 R11: ffffed10478c48fb R12: 1ffff9200055e349
R13: dffffc0000000000 R14: ffffc90002af1a48 R15: 00000000000000ca
FS:  00007f86e7afa6c0(0000) GS:ffff8882a9e32000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000005ff0 CR3: 0000000110ef0000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org david@kernel.org k.lourenco@criteo.com klourencodev@gmail.com linux-mm@kvack.org]

If the report looks fine to you, reply with:
#syz upstream

