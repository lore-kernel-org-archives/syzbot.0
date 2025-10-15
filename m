Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A88327B34D
	for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 18:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760554039; cv=none; b=nvju16idrrextZC3l48B5hgh8vsCf7Iznjx+G+qALDXPmARwd6YImF7ywqFTHQW5KdI6dg6yaTwCMBDALeNcnCUcPPx7VgD8CCxapau5EbJW+D2Z/D0dBpj+e3l1i5+1ja5vaWB8CurifcrqF4LX4jLwGLWTYbzIBATEzhG+N6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760554039; c=relaxed/simple;
	bh=HHX7GSHxmnjGTUsk+R3olZrhoT3lOXEtIKPbaY1UK9k=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Abubut3x+y+J7fOjZ6PsJdto5U7VY8/8MuP6zhiXF6s4t7FLV7CDn6aStvxm/KBYx3D2wp53SaazpDxaED1/B/1th2CJdkIGDb5XDtD4czypKsvjk0EpwM7gKIXNv+MAunAFGiPJAVhZ/40h7Fx1tQdnoHeJqPLln6PEhbn9zKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42fa6ace903so118550385ab.3
        for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 11:47:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554037; x=1761158837;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tXhwfDe5x5DiOvEHEE1cuwjprX0AALWQhFCn8f5jiQw=;
        b=BsLTPNHgDkqffPAtBYHam+pUwCvnceHDooXVdhLKlyldU5QRs5CdjschnEm8VsGGrZ
         1sOM2BbalLQrqH8K/KfPGCcQvtbHSNoD+VfISJ06e9fluRn4B0Qy2OSmAfMIUnpKOEm+
         xCmkzt06yOP1gStiF7MYE3TDmp79n12gUO+fKCcNksPn3Wy4ymjutwdc7xPosM/U6SZf
         el6YQj7Qy21Ls6fMz4aPrz4F/rZSzVqPkgoNx8Zk42ehV6YxUq/D1W0G/w8YyzUEJczF
         wFTjs84dTjlvOUjNt+j1oQzRGo9mGhHCZRxc3FwmZo1BDPqOyMTe8JQvZ2IaPMo1CmJX
         /1vg==
X-Gm-Message-State: AOJu0YwF0B/hgy9Me/tJijzOryISRuq8WDrjIty2rpBwM4eLwuDrdLo7
	XM/Y7UAmMzv9L/SC1AfeqV0x+QkkSbq+a1mAW24Fy2rlW/WA0whjDz6wTS0BuMR5cUX5D8t4NAn
	5ipGfycvKFCIpQBIp36JbMfA6Nel5mdwwmZVCQyMruLnP4qa4rV5dAqhPQtY=
X-Google-Smtp-Source: AGHT+IG0/Sg8YvnECSK7GV2NJsTOXSLgXIRXiVuzVAgRUG1C8KfWcQJ5eUQr5G0dAEr10p0umA0y5+yLQeAuCnx18GqAJ1pXvjgJ
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2197:b0:430:b32d:c197 with SMTP id
 e9e14a558f8ab-430b32dc94bmr22039435ab.27.1760554037558; Wed, 15 Oct 2025
 11:47:17 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:47:17 -0700
In-Reply-To: <20251015125945.481950-1-hao.ge@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68efec35.050a0220.91a22.02cb.GAE@google.com>
Subject: [syzbot ci] Re: slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
From: syzbot ci <syzbot+cib7b0db858ede4f18@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, ast@kernel.org, cl@gentwo.org, gehao@kylinos.cn, 
	hao.ge@linux.dev, harry.yoo@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rientjes@google.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
https://lore.kernel.org/all/20251015125945.481950-1-hao.ge@linux.dev
* [PATCH v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab

and found the following issue:
kernel BUG in __free_slab

Full report is available here:
https://ci.syzbot.org/series/61ff4fe1-2e84-410d-ad85-42ead772d9c8

***

kernel BUG in __free_slab

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e5875084-ea86-418c-979d-5b00cded86ca/config
syz repro: https://ci.syzbot.org/findings/1f8913d8-6d9a-448a-9419-90b758c82c3b/syz_repro

 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
kernel BUG at mm/slab.h:544!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:slab_obj_exts mm/slab.h:543 [inline]
RIP: 0010:free_slab_obj_exts mm/slub.c:2178 [inline]
RIP: 0010:unaccount_slab mm/slub.c:3186 [inline]
RIP: 0010:__free_slab+0x1b8/0x1e0 mm/slub.c:3286
Code: e8 2d 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 1b 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 9d 66 95 8d e8 09 8a 0c ff 90 <0f> 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 f7 89 0c ff 90 0f 0b 48 89
RSP: 0000:ffffc900001478b0 EFLAGS: 00010246
RAX: 680205e52e87ff00 RBX: ffffea00044c3c80 RCX: 680205e52e87ff00
RDX: 0000000000000000 RSI: ffffffff8d7e835a RDI: ffffffff8bc076e0
RBP: 0000000000000001 R08: ffffffff8f9e1177 R09: 1ffffffff1f3c22e
R10: dffffc0000000000 R11: fffffbfff1f3c22f R12: ffffffff821b61b0
R13: ffffffff81a82877 R14: ffff888160415a00 R15: ffffea00044c3c98
FS:  0000000000000000(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fef42bb12f8 CR3: 000000000df38000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:622
 run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
 smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:slab_obj_exts mm/slab.h:543 [inline]
RIP: 0010:free_slab_obj_exts mm/slub.c:2178 [inline]
RIP: 0010:unaccount_slab mm/slub.c:3186 [inline]
RIP: 0010:__free_slab+0x1b8/0x1e0 mm/slub.c:3286
Code: e8 2d 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 1b 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 9d 66 95 8d e8 09 8a 0c ff 90 <0f> 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 f7 89 0c ff 90 0f 0b 48 89
RSP: 0000:ffffc900001478b0 EFLAGS: 00010246
RAX: 680205e52e87ff00 RBX: ffffea00044c3c80 RCX: 680205e52e87ff00
RDX: 0000000000000000 RSI: ffffffff8d7e835a RDI: ffffffff8bc076e0
RBP: 0000000000000001 R08: ffffffff8f9e1177 R09: 1ffffffff1f3c22e
R10: dffffc0000000000 R11: fffffbfff1f3c22f R12: ffffffff821b61b0
R13: ffffffff81a82877 R14: ffff888160415a00 R15: ffffea00044c3c98
FS:  0000000000000000(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fef42bb12f8 CR3: 000000000df38000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
