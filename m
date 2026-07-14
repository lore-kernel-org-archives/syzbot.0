Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7372978C9C
	for <syzbot@lists.linux.dev>; Tue, 14 Jul 2026 00:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989398; cv=none; b=OlKiSpyO2UMkzKaarHAoY09Y/EqMF3igRKOvb5MYfyw9wbvMQ0ME+s4EdQ6jhN8AYNYisg7JWP3sWmEGCX/YnoT6nAGBlN7cpl1NStwi3B7XENaMHg6Im3j6MlfWtXopyJb0XxW+ZnKaIGY0sgsFyt+BYYF4QiQcShKzI21kKOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989398; c=relaxed/simple;
	bh=E6L9N8C5tzb8aHMaLc9tP9vZq4RcJ1ge26BOeH4auWM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=E6bL//dPX63vyKnq9zNc4syvT6LHUl45vxDzenEluapsaVbvdaV4EjYmwb1oVVnof1TpkI3Nab0R2IXUtkUsADD4t31rUgLWrDSEP21SgsenJx3a4LkGRCsHUL6M0jE1jWxJ3NJQz/mHAK3YkbaLO/3sQH1LH4w+3h0bQZx6h04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-49226201eb8so3868113b6e.1
        for <syzbot@lists.linux.dev>; Mon, 13 Jul 2026 17:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989395; x=1784594195;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XyGZhaSby5zmgmNKQ2wtsd8UQKwpUtaqwtHfPH9hEfE=;
        b=p5sLU4gp7Qn9OiDpbmBFTj62vt58f45Vo+7EpbbO2Crc712+qeD9rL1LcXe3kWQSFQ
         3iGn8wk7rWJMyRQWCSicnR6I16QbDVyyvv4lu/GaHpecGEYGkVs3ABOrtgOwZ8lDPQ+U
         Q+MTLYMMgvHaB1eBBAfmvpt3l/XLfzXoCVGYGTIMnaWOoOfZTuPqAP4GtdWESWh1zTi+
         cGIMlh6KtX7LbVRO0uf3xhDdC6seHG4c/3Gg+JUsnZnV7JF7+BZR72OXv6n0nh1YOpGL
         Qbr+UXp+7x7TmvU+sBrLPZ+G2bUuu4jSDY93kw0HKUOVTg6oZtSwSDOz4fvpP1evCWM/
         kK6A==
X-Gm-Message-State: AOJu0YwqN194FmLK89reO4KTvRT92iB32fjl9J55yI1AYNQP6tnw7HyJ
	q6vYvI3Etxxv+kw9s9qnVbmb2rrC2WrNQVoAeth+ZriGUct0jGGfUDWy30qYK77FHY9jMnOp5R1
	qihGVutyVle7djkrp704rO0rfeBa2bnMB+0c9rs9im9WKFPj0j5QBVTK42ao=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f8e:b0:4a3:fb6b:bcb8 with SMTP id
 5614622812f47-4a42ac30398mr7058431b6e.10.1783989395463; Mon, 13 Jul 2026
 17:36:35 -0700 (PDT)
Date: Mon, 13 Jul 2026 17:36:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a558493.c90005c7.37d349.0010.GAE@google.com>
Subject: [moderation/CI] Re: Redesign Verification Errors
From: syzbot ci <syzbot+cice1532664a7f7405@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] Redesign Verification Errors
https://lore.kernel.org/all/20260713153910.2556007-1-memxor@gmail.com
* [PATCH bpf-next v3 01/17] bpf: Add verifier diagnostics report helpers
* [PATCH bpf-next v3 02/17] bpf: Add source and instruction diagnostic context
* [PATCH bpf-next v3 03/17] bpf: Add verifier diagnostic event log
* [PATCH bpf-next v3 04/17] bpf: Prune verifier diagnostics when switching paths
* [PATCH bpf-next v3 05/17] bpf: Track verifier register diagnostic events
* [PATCH bpf-next v3 06/17] bpf: Track verifier reference diagnostic events
* [PATCH bpf-next v3 07/17] bpf: Track verifier context diagnostic events
* [PATCH bpf-next v3 08/17] bpf: Report Register Type Safety errors
* [PATCH bpf-next v3 09/17] bpf: Report Memory Safety bounds errors
* [PATCH bpf-next v3 10/17] bpf: Report Resource Lifetime reference leaks
* [PATCH bpf-next v3 11/17] bpf: Report Call Type Safety argument errors
* [PATCH bpf-next v3 12/17] bpf: Report Execution Context Safety errors
* [PATCH bpf-next v3 13/17] bpf: Report Program Structure CFG errors
* [PATCH bpf-next v3 14/17] bpf: Report Policy helper and kfunc errors
* [PATCH bpf-next v3 15/17] bpf: Report Verifier Limit errors
* [PATCH bpf-next v3 16/17] bpf: Report Verifier Internal errors
* [PATCH bpf-next v3 17/17] bpf: Gate verifier diagnostics on log level

and found the following issue:
WARNING in bpf_diag_record_mod

Full report is available here:
https://ci.syzbot.org/series/60c41043-96fb-4c6b-bc8e-3ddab76db3ec

***

WARNING in bpf_diag_record_mod

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      9a3a07d06e7d74f4aecc51396c771149336ac55d
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/bb13c0f7-c05e-4ad3-b3f3-365157b560a0/config
syz repro: https://ci.syzbot.org/findings/fa0ac02b-def4-401c-ac09-aea8fa6688a1/syz_repro

------------[ cut here ]------------
1
WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.17/5810
Modules linked in:
CPU: 0 UID: 0 PID: 5810 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
Code: 74 10 4c 89 e7 89 54 24 0c e8 4e 2c 0e 00 8b 54 24 0c 49 83 3c 24 00 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 74 45 f6 0d 01 90 <0f> 0b 90 e9 17 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
RSP: 0018:ffffc90003abef40 EFLAGS: 00010246
RAX: ffffc90003abef00 RBX: 000000000000000b RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003abefa8
RBP: ffffc90003abf040 R08: ffffc90003abefa7 R09: 0000000000000000
R10: ffffc90003abef80 R11: fffff52000757df5 R12: 0000000000000000
R13: 1ffff92000757dec R14: 0000000000440cc0 R15: dffffc0000000000
FS:  00007f71b81f66c0(0000) GS:ffff88818dc0e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33463fff CR3: 000000016f8e4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
 ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5302
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5333
 __do_kmalloc_node mm/slub.c:5350 [inline]
 __kmalloc_node_track_caller_noprof+0x164/0x730 mm/slub.c:5497
 __do_krealloc mm/slub.c:6865 [inline]
 krealloc_node_align_noprof+0x19a/0x390 mm/slub.c:6886
 _krealloc_array_noprof include/linux/slab.h:1213 [inline]
 diag_append_history kernel/bpf/diagnostics.c:464 [inline]
 bpf_diag_record_mod+0xcbc/0x1590 kernel/bpf/diagnostics.c:1666
 check_alu_op kernel/bpf/verifier.c:16428 [inline]
 do_check_insn+0x1125c/0x1b4a0 kernel/bpf/verifier.c:18578
 do_check kernel/bpf/verifier.c:18817 [inline]
 do_check_common+0x416c/0x5930 kernel/bpf/verifier.c:19902
 do_check_main+0x63/0x1f0 kernel/bpf/verifier.c:19994
 bpf_check+0x25df/0x2cb0 kernel/bpf/verifier.c:21502
 bpf_prog_load+0x13ec/0x1ac0 kernel/bpf/syscall.c:3118
 __sys_bpf+0xd0d/0xd90 kernel/bpf/syscall.c:6339
 __do_sys_bpf kernel/bpf/syscall.c:6458 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6455 [inline]
 __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6455
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f71b8b9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f71b81f6028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f71b8e15fa0 RCX: 00007f71b8b9ce59
RDX: 0000000000000094 RSI: 0000200000000b00 RDI: 0000000000000005
RBP: 00007f71b8c32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f71b8e16038 R14: 00007f71b8e15fa0 R15: 00007ffe3ec24ce8
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
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net eddyz87@gmail.com emil@etsalapatis.com kernel-team@meta.com kkd@meta.com memxor@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

