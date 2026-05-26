Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3202150997
	for <syzbot@lists.linux.dev>; Tue, 26 May 2026 05:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779774571; cv=none; b=KeiajMVJ+Uzvem0N/KaCxytbVEUYyWN6h9BkpMZTIzdlZkKPMchAoqJg/uQ7WPA1S+1BdeeAcxrqNcLwMX/tS//FgaQ1Txs4hcZ4aDg+ievxR8U5FJ2h6VPxAvMcjYKkVXFK3h2mZRfyRiZsZRUayF6WiBITFuPcG+0uoYYzKxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779774571; c=relaxed/simple;
	bh=x9Yj7aTg1GQQSh+x9b/Ecjqf4DMAz/ZV+Y+LafBK3r4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=LkvkoqVqZ0xlUPBfaW2cwRg1EH26jYlvBvc1CRg/s283w9yJsRpgWhQ1BiV7WaIv+eZhzRwkUTPuMno5ryxFGNg3X7OBhHQXEfqBKDZt8Fg0YEaW7a9CLC76Bvy8NYIWSKVy8sL4Qg5HAYrWV0ELF79wcE5HYj5y9o7Rig9Datk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e60dfcced4so6806360a34.2
        for <syzbot@lists.linux.dev>; Mon, 25 May 2026 22:49:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779774569; x=1780379369;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DzJWSIhvpEau2z8ZBB5xaqMPUjWo5NzLuDCqLRgBZ9U=;
        b=YRgASQevkSNokdjrX7ppfn/u+h9uuFhd4ZJwscpXF3ugRQ32Iz1V88FimahbzFPVui
         tPKEzX4sNbD10db/AnUbomeAEfvW5icrFFODkfWLyfjSpQV7Bi0EeRj5jHAA7m+sjX0p
         rUeVC8fxLcUtVadJlM4Ws15JEa3HwgA+f9fjOeveDALYPICICMmXJUdqMKJrruee6y3Q
         h6fcwnxWwklpuA8ALwo9numlr4eguW13xZW5lPI4YzcqvE7c5jY3ooLmS3kD+MneWi56
         qPRgux8SXwicuDQ6QHdJC9IWagWVIP01BsyFxR0hu3jmDYDaDdUcI8Uyg/LNyY+px3jL
         aChw==
X-Gm-Message-State: AOJu0Yw5f+OMcixGjro4q0RT5dCerrPtL0lddoORTqVE6x5A81qwDIfH
	5hcyo7WnDint/KfMQY7orCR4lg9a5yeqpQn6keXIn1yMpecjkgTlR9P2i5x3Fj7TKUQXUYsNgTP
	gWJY0ji//bNpv2FWiPxTigNhc4leVqeEdIB3twn53z9z67bpngx+qntXLTeo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e84b:0:b0:69d:9153:56ec with SMTP id
 006d021491bc7-69d91536352mr7102173eaf.41.1779774568882; Mon, 25 May 2026
 22:49:28 -0700 (PDT)
Date: Mon, 25 May 2026 22:49:28 -0700
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a153468.050a0220.7dd1.0004.GAE@google.com>
Subject: [syzbot ci] Re: Implement a new generic pagewalk API
From: syzbot ci <syzbot+ci07d784447d67ca63@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, david@redhat.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, osalvador@suse.de, vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] Implement a new generic pagewalk API
https://lore.kernel.org/all/20260525165528.184397-1-osalvador@suse.de
* [RFC PATCH v3 1/8] mm: Add softleaf_from_pud
* [RFC PATCH v3 2/8] mm: Add {pmd,pud}_huge_lock helper
* [RFC PATCH v3 3/8] mm: Implement folio_pmd_batch
* [RFC PATCH v3 4/8] mm: Implement pt_range_walk
* [RFC PATCH v3 5/8] mm: Make /proc/pid/smaps use the new generic pagewalk API
* [RFC PATCH v3 6/8] mm: Make /proc/pid/numa_maps use the new generic pagewalk API
* [RFC PATCH v3 7/8] mm: Make /proc/pid/pagemap use the new generic pagewalk API
* [RFC PATCH v3 8/8] mm: Make /proc/pid/clear_refs use the new generic pagewalk API

and found the following issue:
general protection fault in clear_refs_write

Full report is available here:
https://ci.syzbot.org/series/0beab2d0-9d88-4288-ac81-b294e51c057d

***

general protection fault in clear_refs_write

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8f20e88b-808c-4c60-9b8e-0af4c9fce5ff/config
syz repro: https://ci.syzbot.org/findings/634b1f0a-cf64-4607-928a-ef3ad40f765c/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5863 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:clear_soft_dirty_pmd fs/proc/task_mmu.c:1545 [inline]
RIP: 0010:clear_refs_pmd_range fs/proc/task_mmu.c:1581 [inline]
RIP: 0010:clear_refs_write+0xaa7/0x1590 fs/proc/task_mmu.c:1721
Code: 44 24 10 4c 8b bc 24 20 02 00 00 83 7c 24 28 04 0f 85 aa 05 00 00 48 8b 9c 24 08 02 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 58 <42> 80 3c 20 00 74 08 48 89 df e8 fa 2c c6 ff 4c 8b 23 4c 89 e6 48
RSP: 0018:ffffc900037bf960 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
RDX: ffffffff826b21ce RSI: ffffffff8eb17b50 RDI: 0000000000000001
RBP: ffffc900037bfc10 R08: ffff8881047c0000 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
R13: fffff520006f7f40 R14: ffff8881141c8308 R15: ffff8881141c8300
FS:  00007ff8ffc1d6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33e63fff CR3: 000000010476e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_loop_readv_writev fs/read_write.c:852 [inline]
 vfs_writev+0x4bd/0x990 fs/read_write.c:1061
 do_writev+0x154/0x2e0 fs/read_write.c:1105
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff8fed9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff8ffc1d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007ff8ff015fa0 RCX: 00007ff8fed9ce59
RDX: 0000000000000001 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007ff8fee32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff8ff016038 R14: 00007ff8ff015fa0 R15: 00007fffd02796e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:clear_soft_dirty_pmd fs/proc/task_mmu.c:1545 [inline]
RIP: 0010:clear_refs_pmd_range fs/proc/task_mmu.c:1581 [inline]
RIP: 0010:clear_refs_write+0xaa7/0x1590 fs/proc/task_mmu.c:1721
Code: 44 24 10 4c 8b bc 24 20 02 00 00 83 7c 24 28 04 0f 85 aa 05 00 00 48 8b 9c 24 08 02 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 58 <42> 80 3c 20 00 74 08 48 89 df e8 fa 2c c6 ff 4c 8b 23 4c 89 e6 48
RSP: 0018:ffffc900037bf960 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
RDX: ffffffff826b21ce RSI: ffffffff8eb17b50 RDI: 0000000000000001
RBP: ffffc900037bfc10 R08: ffff8881047c0000 R09: 0000000000000002
R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
R13: fffff520006f7f40 R14: ffff8881141c8308 R15: ffff8881141c8300
FS:  00007ff8ffc1d6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b34063fff CR3: 000000010476e000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	44 24 10             	rex.R and $0x10,%al
   3:	4c 8b bc 24 20 02 00 	mov    0x220(%rsp),%r15
   a:	00
   b:	83 7c 24 28 04       	cmpl   $0x4,0x28(%rsp)
  10:	0f 85 aa 05 00 00    	jne    0x5c0
  16:	48 8b 9c 24 08 02 00 	mov    0x208(%rsp),%rbx
  1d:	00
  1e:	48 89 d8             	mov    %rbx,%rax
  21:	48 c1 e8 03          	shr    $0x3,%rax
  25:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 fa 2c c6 ff       	call   0xffc62d33
  39:	4c 8b 23             	mov    (%rbx),%r12
  3c:	4c 89 e6             	mov    %r12,%rsi
  3f:	48                   	rex.W


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
