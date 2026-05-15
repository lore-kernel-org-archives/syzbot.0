Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE943EDE47
	for <syzbot@lists.linux.dev>; Fri, 15 May 2026 22:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778883338; cv=none; b=FHNvk4smbbxljM/LO4UBE24aLVUXC/Zwf2HbJbMsFO2MVnt9N9I9anoarJHGn8HSDRz/V7FdYGEP8jfE8SH2xIOjOBpyUnlzR7B/tbLZfjx3ifSvwy5z7PK7S0K8VJVPDlgCd7+a3GKsBboMRpQuhREaNT+zJO9ny4r4RTFYEy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778883338; c=relaxed/simple;
	bh=l++xqrEvPtC84DNWhejYAsDSdfmwzY28AsDc61YHvRU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=EC42XZHL29YenvO4Er4ffO0WUfqYxOM7grgLMcGJYIOJKdGkCNJRXWyfxa1u+wFZQtvfsfP6ZEvkS05ZZMh6sum7wj6+wqIw+Uz4UuUn207pIFhIH0KW1gOs5A+DI1JMY7FziAWtPUmyITBhcRcpt4ArRhDiWGu6nxY6YIrkfKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7dee7dd974aso3608972a34.1
        for <syzbot@lists.linux.dev>; Fri, 15 May 2026 15:15:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778883336; x=1779488136;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pwW4SIb7zh4vGLvdR9TIlVnWjPU2DtKHkKqzrJlhFW0=;
        b=Q2OFqYOvSj0cXfJ8tuerdjT2F6fdqV22dF4hy8Z0Y5fNdAAg3UdyM7FN6Bbw9mbM6o
         /uOPXONanMZQeH/r0mFMvDnRuuotPOyE++/EzsDarR3W14h3ZIL6V4HeSQOdPgnF+r7p
         devfH8oW1wVyr889DA/K4ntPhTTCilzc2lDyZYKew4bYQNRsBMxTl1SySQ0FT1JAynxQ
         TmExsaM00hQjGrqkhz2YOy43AsHOp62wVxV77tb84PCnlqirkklp2EKAWDagwE+Ylvkn
         2IamlROMKRUw2PZz16l3lKcuin6xDg5iiHNZ3TEHA5U+OPqi3ikkotjQlJFSF0xx0MHs
         LiOw==
X-Gm-Message-State: AOJu0Yyo3cJdqNFd36sSX7IMHMP7ZR2Ty8nag/WWVu/qVgIwl3BHQMaz
	vM00uYSfi9EeE0y01E9x/VPOUcgZoZFQQ9AVlPIf1boHqTaXQKvFAnaV3+W44bHIdrlwUiiCs+5
	FOrJ0WhoEQPeiGfSeg0my1lijflw9z3ddEUjpsFEw8gEK/BdT7hr6P2mnBd8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6be1:b0:696:89f7:1614 with SMTP id
 006d021491bc7-69b87f42870mr4006454eaf.11.1778883336349; Fri, 15 May 2026
 15:15:36 -0700 (PDT)
Date: Fri, 15 May 2026 15:15:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a079b08.a00a0220.300e5b.0000.GAE@google.com>
Subject: [moderation/CI] Re: memcg: cache obj_stock by memcg, not by objcg pointer
From: syzbot ci <syzbot+ci0963b9a1e1f05606@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] memcg: cache obj_stock by memcg, not by objcg pointer
https://lore.kernel.org/all/20260515171953.2224503-1-shakeel.butt@linux.dev
* [PATCH] memcg: cache obj_stock by memcg, not by objcg pointer

and found the following issue:
WARNING in __refill_obj_stock

Full report is available here:
https://ci.syzbot.org/series/8efc6e46-4b2e-43ab-90a0-62552bdc14a6

***

WARNING in __refill_obj_stock

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      0cec77cfd5314c0b3b03530abe1a4b32e991f639
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/fda0a69d-af56-4b9f-8b30-b63ea475692=
3/config

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep=
_map))
WARNING: ./include/linux/memcontrol.h:380 at __refill_obj_stock+0x4fd/0x610=
, CPU#0: syz.1.48/5712
Modules linked in:

CPU: 0 UID: 0 PID: 5712 Comm: syz.1.48 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__refill_obj_stock+0x4fd/0x610
Code: 89 e7 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 d8 ba 00 00 48 83 =
c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 90 <0f> 0b 90 e9 a8 f=
b ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c 60
RSP: 0018:ffffc9000483f4b0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88810beb0f80 RCX: 0000000080000001
RDX: 0000000000000110 RSI: ffffffff8e21e93e RDI: ffffffff8c28b8e0
RBP: 0000000000000001 R08: ffffffff8239a83c R09: ffff88812103c600
R10: dffffc0000000000 R11: ffffed102d89bae9 R12: 1ffff110242078c8
R13: ffff88810beb0d80 R14: dffffc0000000000 R15: ffff88812103c600
FS:  0000000000000000(0000) GS:ffff88818dc89000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f80ad948060 CR3: 000000000e74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __memcg_slab_free_hook+0x2ed/0x4b0
 kmem_cache_free+0x381/0x650
 __put_anon_vma+0x12b/0x2d0
 unlink_anon_vmas+0x58b/0x730
 free_pgtables+0x802/0xb40
 exit_mmap+0x490/0x9e0
 __mmput+0x118/0x430
 exit_mm+0x18e/0x250
 do_exit+0x6a2/0x22c0
 do_group_exit+0x21b/0x2d0
 get_signal+0x1284/0x1330
 arch_do_signal_or_restart+0xbc/0x840
 exit_to_user_mode_loop+0x8c/0x4d0
 do_syscall_64+0x33e/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6eea99ce59
Code: Unable to access opcode bytes at 0x7f6eea99ce2f.
RSP: 002b:00007f6eeb8240e8 EFLAGS: 00000246
 ORIG_RAX: 00000000000000ca
RAX: 0000000000000001 RBX: 00007f6eeac15fa8 RCX: 00007f6eea99ce59
RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f6eeac15fac
RBP: 00007f6eeac15fa0 R08: 3fffffffffffffff R09: 0000000000000000
R10: 0000200001000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6eeac16038 R14: 00007fffdc60cea0 R15: 00007fffdc60cf88
 </TASK>


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
[akpm@linux-foundation.org cgroups@vger.kernel.org hannes@cmpxchg.org kerne=
l-team@meta.com linux-kernel@vger.kernel.org linux-mm@kvack.org mhocko@kern=
el.org muchun.song@linux.dev oliver.sang@intel.com qi.zheng@linux.dev roman=
.gushchin@linux.dev shakeel.butt@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

