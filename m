Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C22C175A74
	for <syzbot@lists.linux.dev>; Thu,  7 May 2026 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778175051; cv=none; b=sM19w0hMXvTfACiX7MMUkim8B6yMiFykDQ2hHjnamtLxTV1/J5DOUr6AWnb/h9Y2nDCdesNdRDvhIyeNuvAgXeMxgAWrLJTwwb64BIfiaq1L275IsZrVb1wk3BItxTezYuM+a/SFDBkTobx1GEC+4IqRRWiqg1H2PG17WhQYVDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778175051; c=relaxed/simple;
	bh=MmYp5LLzQ1b9FL+b0rqOV10u4+0P6y7XpulagZ6t508=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=nOaEJuy3NVivXRZ1WAmoQYTL0s6Jw1XLPOUxy0pEySSgLbLfbomuh+PG9rilU/n9iFg54U5opp+WmoABUyfCImrH+X4LYdUhiZfEGzn1F9FvV+566KUygTh/VqN+SsJZkGsS+nVVJamlvhqU30hiIGcyl0NL0Ob/qUdZkBWAmWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-42c091fcd06so2007295fac.3
        for <syzbot@lists.linux.dev>; Thu, 07 May 2026 10:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778175049; x=1778779849;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GMQs/AD1jOAJv+/I/3AJx27UpVjb1He477+QsRhrzQE=;
        b=DQVO3CLUJx8B85NiO9LLhmRNpDw9+UXiViFRe8MaL+qrUV/Bw/tteNaC9nrFc2O+lo
         OGESE9MMS0r/aYrJhultIdLAh4gipmN2YDvBKblCFyYTISJfbmvoxUA43MqGX1hRTvqL
         UwcRwy4J9qXESsCmyke+pI38VrboG5VxSeMbp/1NzNq42JBvUmtc4nBo/bVCugXZU4ae
         FrA4tIW1a+ukvsP1hRqEvqyYbDJmIGF4IhT6kZMA8kq53CfBIrtZrK6PnMJynlOsscco
         UCjMjHEsW2zpTZeULbuawVIgqr/zvDAe+a+M9klv+BdHimRjAExfXB+51z3PM+qsHVNU
         lb4w==
X-Gm-Message-State: AOJu0YzMAWp3pqMV4RBux4dYyUC3e9iBE/LeXIG9uwYNWj9XsU9cJ7um
	hHBItu4HBd2KJjZHrhB7T4bk5PIVf5fOFXtyYibAKro8sj8sg74OP3RVcvOTdmmmXXPMXe44mqP
	en4+nqk1yJ1ho9nGX6ga1upmLDRBzvoQjOqjXSa3lErokZk3ZJkKHPbXHrxE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4df7:b0:68b:bc93:1de with SMTP id
 006d021491bc7-69998d3362fmr4701502eaf.35.1778175049000; Thu, 07 May 2026
 10:30:49 -0700 (PDT)
Date: Thu, 07 May 2026 10:30:48 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69fccc48.050a0220.3cf765.035b.GAE@google.com>
Subject: [moderation/CI] Re: mm/vmalloc: free unused pages when shrinking
 vrealloc() allocation
From: syzbot ci <syzbot+ci1936964899135e53@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/vmalloc: free unused pages when shrinking vrealloc() allocation
https://lore.kernel.org/all/20260507114854.41117-1-jillravaliya@gmail.com
* [PATCH 1/2] mm/vmalloc: free unused pages when shrinking vrealloc() allocation
* [PATCH 2/2] selftests/mm: add test for vrealloc() shrink page freeing

and found the following issue:
kernel BUG in __vunmap_range_noflush

Full report is available here:
https://ci.syzbot.org/series/13b0874e-a9f8-4992-be93-e93cc88e5e44

***

kernel BUG in __vunmap_range_noflush

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      2c340aab5485ebe9e33c01437dd4815ef33c8df5
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/625f7138-9b20-4205-b0e7-02ed1219bd31/config
syz repro: https://ci.syzbot.org/findings/13e8dc07-d697-4345-a27f-319e9c1fe3d6/syz_repro

------------[ cut here ]------------
kernel BUG at mm/vmalloc.c:488!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5824 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__vunmap_range_noflush+0xb4d/0xb70 mm/vmalloc.c:488
Code: 00 e9 64 f5 ff ff e8 12 8d a6 ff 48 c7 c7 a0 0e a8 8e 48 8b 74 24 48 48 89 da e8 0e c5 cf 02 e9 67 f5 ff ff e8 f4 8c a6 ff 90 <0f> 0b e8 ec 8c a6 ff e9 53 ff ff ff e8 e2 8c a6 ff bb 02 00 00 00
RSP: 0018:ffffc90003b575e0 EFLAGS: 00010293
RAX: ffffffff821f16bc RBX: ffffc900036fa000 RCX: ffff8881072a1d80
RDX: 0000000000000000 RSI: ffffc900036fa000 RDI: ffffc900036fa000
RBP: ffff88816ebb3980 R08: ffff88810007f1bb R09: 0000000000000000
R10: ffffc900036f9bb0 R11: ffffed102000fe38 R12: 0000000000000001
R13: ffffc900036fa000 R14: ffffc900036fa000 R15: dffffc0000000000
FS:  00007f4d6b8c46c0(0000) GS:ffff8882a9293000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055924f0dd8c0 CR3: 00000001057f2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 vunmap_range_noflush mm/vmalloc.c:506 [inline]
 vunmap_range mm/vmalloc.c:521 [inline]
 vrealloc_node_align_noprof+0x4fc/0x880 mm/vmalloc.c:4346
 bpf_patch_insn_data+0xeb/0x10a0 kernel/bpf/fixups.c:254
 bpf_convert_ctx_accesses+0x213f/0x2d70 kernel/bpf/fixups.c:974
 bpf_check+0x2b8e/0x49f0 kernel/bpf/verifier.c:20094
 bpf_prog_load+0x1406/0x1a10 kernel/bpf/syscall.c:3082
 __sys_bpf+0x618/0x950 kernel/bpf/syscall.c:6248
 __do_sys_bpf kernel/bpf/syscall.c:6361 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6359 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6359
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4d6a99cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4d6b8c4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f4d6ac15fa0 RCX: 00007f4d6a99cdd9
RDX: 0000000000000048 RSI: 00002000000054c0 RDI: 0000000000000005
RBP: 00007f4d6aa32d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4d6ac16038 R14: 00007f4d6ac15fa0 R15: 00007ffff714fc08
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__vunmap_range_noflush+0xb4d/0xb70 mm/vmalloc.c:488
Code: 00 e9 64 f5 ff ff e8 12 8d a6 ff 48 c7 c7 a0 0e a8 8e 48 8b 74 24 48 48 89 da e8 0e c5 cf 02 e9 67 f5 ff ff e8 f4 8c a6 ff 90 <0f> 0b e8 ec 8c a6 ff e9 53 ff ff ff e8 e2 8c a6 ff bb 02 00 00 00
RSP: 0018:ffffc90003b575e0 EFLAGS: 00010293
RAX: ffffffff821f16bc RBX: ffffc900036fa000 RCX: ffff8881072a1d80
RDX: 0000000000000000 RSI: ffffc900036fa000 RDI: ffffc900036fa000
RBP: ffff88816ebb3980 R08: ffff88810007f1bb R09: 0000000000000000
R10: ffffc900036f9bb0 R11: ffffed102000fe38 R12: 0000000000000001
R13: ffffc900036fa000 R14: ffffc900036fa000 R15: dffffc0000000000
FS:  00007f4d6b8c46c0(0000) GS:ffff8882a9293000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdaf55afd8 CR3: 00000001057f2000 CR4: 00000000000006f0


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
[akpm@linux-foundation.org jillravaliya@gmail.com linux-kernel@vger.kernel.org linux-mm@kvack.org urezki@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

