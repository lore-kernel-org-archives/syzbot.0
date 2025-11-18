Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8A9370310
	for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 20:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763497600; cv=none; b=JjqMUKtMsiFnUxHi/Wds93dxK3Uc73ke/8DZ6p3HuorMNSnHgrW1gONoIOtRW1o/vqXJfAPcLYRdYNCN9Y2U2CmfrM+OR16mD6PirRhF9pLVefls5HevDerHiVEZh4XSukua8BsCXhqyjrf3d3W9WkMSDmYsBk1kAyUr2wTzhk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763497600; c=relaxed/simple;
	bh=AuQCUcV7UKVzGoZPtKVXJdI1x7KxLgvVZY5oJtz17i4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=GZZVvSnwfWLV7pHKQNc4Eo0fbVtelePJYaU3VYWgRqMl5he+yL//3D0Z2p0pnmZh7QyhQSx5jsdF0+H8cG63c/bWtKbRUSh3ZntmrqlXtimZmOjHpwdMQ5FXrKwG4KhDyNrfGLp9E1NvPHlFJ+CjkHXU61a5EcmnLWSmRS36vGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-4348db9e727so45692375ab.2
        for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 12:26:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763497597; x=1764102397;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JdMqwjP4kEo3x++d5dCCOodbgzmXRG7NYlZ54HQq8ME=;
        b=Y3zgUAi5YtQbsXWdYBoU13TCFqXy16DT89F4ujVQBR53wHj4wdua0+kTnBnJHkIjws
         in5al8gyh25SM3CgfzG95PqJfWeabDBLyq9sJyOUvm9K6iYYo3dQmUXr4w7B7p4vwmXG
         eCbR8DsPbt+8xXrx+IhLoiRgdhl6SnrYSu6qcyXtnA3dkpxq364Ucm8QHFKhu00gmITG
         T7NJp8o19obGiPo8vdEWKLvcunilmOEmoZ9zdzbbj7x+YEw4qC3TwIiWqdkAMZoihvNl
         4gpbRSCo+ROD43fNyBlr1kikfhK1O94p5A1++rAkzkfDGECyW28DJ1r586kK/MZO+CUx
         h7+A==
X-Gm-Message-State: AOJu0YwgDWPiXlGiZ+FdZ33vK5i+gxTxKq5GP8T+byGuHAtSTGpfzARI
	9FvIKLfZCh4oBp1wB7p0s5k3ypOgAvBLbIlGTXgMWftAFVbxCay/L4NiIyRJIMwZBsio+hMahpV
	jQFhjDC7JZ3YrRw2Tk/pUdL5HzIhRNrimvZUjGWSuHjFJDGbGuCe3HatTQwE=
X-Google-Smtp-Source: AGHT+IE7pPltF6yGd3QCXBymB/J5aPtkmZFCPl8WZQKsmk/hXivGUfKH4t9ZeMriHBGGbbDbSKb9psrEJOvTgPMKle7ZQTFjjyPJ
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4c:0:b0:433:7896:2d45 with SMTP id
 e9e14a558f8ab-4348c93b6fcmr192670925ab.25.1763497597563; Tue, 18 Nov 2025
 12:26:37 -0800 (PST)
Date: Tue, 18 Nov 2025 12:26:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691cd67d.a70a0220.2ea503.0006.GAE@google.com>
Subject: [moderation/CI] Re: MAINTAINERS: add test_kho to KHO's entry
From: syzbot ci <syzbot+ci61b74c47bce6acac@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] MAINTAINERS: add test_kho to KHO's entry
https://lore.kernel.org/all/20251118182416.70660-1-pratyush@kernel.org
* [PATCH] MAINTAINERS: add test_kho to KHO's entry

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/15b7f6b8-363b-4b81-a373-0ff2621427cb

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      0c1c7a6a83feaf2cf182c52983ffe330ffb50280
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2531b0cd-79d1-4e45-86c3-c4d15fab7744/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#0: syz-executor/5923
Modules linked in:
CPU: 0 UID: 0 PID: 5923 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 c7 20 db 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 85 8d 6c ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc90003c87b00 EFLAGS: 00010246
RAX: 53760b09cb046a00 RBX: 0000000000000dc0 RCX: ffff88810be457c0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90003c87b98 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba708 R12: 1ffff92000790f60
R13: dffffc0000000000 R14: ffffc90003c87b20 R15: ffffc90003c87b30
FS:  000055555dc61500(0000) GS:ffff88818e8be000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ed63fff CR3: 0000000113a48000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __vmalloc_noprof+0xf2/0x120
 bpf_prog_alloc_no_stats+0x4a/0x4d0
 bpf_prog_alloc+0x3c/0x1a0
 bpf_prog_create_from_user+0xa7/0x440
 do_seccomp+0x7b1/0xd90
 __se_sys_prctl+0xc3c/0x1830
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f40c6590b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007ffdf8a5bd40 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007f40c662cf80 RCX: 00007f40c6590b0d
RDX: 00007ffdf8a5bda0 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007ffdf8a5bdb0 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007ffdf8a5c1d8 R14: 00007ffdf8a5c458 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org graf@amazon.com kexec@lists.infradead.org linux-kernel@vger.kernel.org linux-mm@kvack.org pasha.tatashin@soleen.com pratyush@kernel.org rppt@kernel.org stable@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

