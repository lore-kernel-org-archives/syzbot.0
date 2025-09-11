Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3662F33F3
	for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 04:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757566272; cv=none; b=j/70B1YBoCAODSmGBjfGQBNA+xPWy7liGBao3bArsf8yCNbE5NKB3pGnfkl4sifCu8CcZk0cig2z87tlzHvd0Gc7Ja4OQMnR5BVbfgTqjbKkfVRLqoeR5Pm92p685MuUb5ZpFcl6WKbjlkCY+rRq50fKyvG+ugV7iCdnm/WYYZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757566272; c=relaxed/simple;
	bh=nLwqVQA/xDnnJ2rMD2wK+H9HKLex403bpJI5Lff/eXE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=pKHlZFuc/+5R1Cdd+5BcioKcv7R6GXXBhhz8+3nxYOHpqd1jvDlgueep9s+nQReNk60DXIBSf795MPa79IhG0FvZ1QhQ8A7sTxFyBNsIY85R9yQ4CdVx9V/ghdjyvPahiyTcOBQcElR4EDvnZl1vmDhGI/8iMuJwjgZMPLQtr+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-886e347d2afso29496839f.3
        for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 21:51:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757566269; x=1758171069;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D2JmCl+sK5wkjNN3QgH7tRFeUyR37xwlhp6PpSHut74=;
        b=nP8emrjFFIi4XfrwQijGpPKuh3SplMVuFodRNJiQ24jlge+J1ncRUgVaFmljZO+L0P
         n8RnrgzclzkYWqgbzxizSRvKcxJo1lYiTnrPx9zgPeijT8EQoBUqioSRnNmk5sRxGF2j
         YrfLyO+sI316NGhUJOXim27oKjZpocgAlz/k8tTdPE0CaD1kqMAPA9r7Xx60u2JFy2we
         hdDs7Z8lE8rj7un6+ekxOwhULrZ//A1OqR0kH92jwzhXh93f1saxptTQOzftrRXBhjgI
         z06V6AwID76o1x2tzWxV/8G9zSI8pkeu2HSAdObWpdoXmYSlPW5otUWxgYp7ShqOJrji
         fScw==
X-Gm-Message-State: AOJu0YyJFakorEX2+iGKf4pq9bL4WJl6sczEbyI2TdrF2yz3vLLiRoyz
	EUnvFB2ifp2ibVJVIJLmZ+MjAujhQAtVgD12rnDjNZhYtcSCvFGkCHtXncV544oLonadqm27LvN
	LpYBiQ+w9+0nAM7OtNr6frzFa0zovVf2sJbwE4cZB4GMgP3IvWHIf+q116XU=
X-Google-Smtp-Source: AGHT+IEXLQaHzXG1HAvrpYD2dccZ/HUNEWEuF+5kXdNO4J30RJHiXSk9hukMdNhn2Ny5DYqdGvWA7Tndjej1Syb61G4Gqjy7oNfM
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc2:b0:418:c5b3:da7d with SMTP id
 e9e14a558f8ab-418c5d26169mr62049695ab.2.1757566269228; Wed, 10 Sep 2025
 21:51:09 -0700 (PDT)
Date: Wed, 10 Sep 2025 21:51:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c2553d.050a0220.2ff435.0020.GAE@google.com>
Subject: [moderation/CI] Re: bpf: replace path-sensitive with path-insensitive
 live stack analysis
From: syzbot ci <syzbot+cidc36f88185e99d4b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] bpf: replace path-sensitive with path-insensitive live stack analysis
https://lore.kernel.org/all/20250911010437.2779173-1-eddyz87@gmail.com
* [PATCH bpf-next v1 01/10] bpf: bpf_verifier_state->cleaned flag instead of REG_LIVE_DONE
* [PATCH bpf-next v1 02/10] bpf: use compute_live_registers() info in clean_func_state
* [PATCH bpf-next v1 03/10] bpf: remove redundant REG_LIVE_READ check in stacksafe()
* [PATCH bpf-next v1 04/10] bpf: declare a few utility functions as internal api
* [PATCH bpf-next v1 05/10] bpf: compute instructions postorder per subprogram
* [PATCH bpf-next v1 06/10] bpf: callchain sensitive stack liveness tracking using CFG
* [PATCH bpf-next v1 07/10] bpf: enable callchain sensitive stack liveness tracking
* [PATCH bpf-next v1 08/10] bpf: signal error if old liveness is more conservative than new
* [PATCH bpf-next v1 09/10] bpf: disable and remove registers chain based liveness
* [PATCH bpf-next v1 10/10] bpf: table based bpf_insn_successors()

and found the following issue:
KASAN: slab-out-of-bounds Write in compute_postorder

Full report is available here:
https://ci.syzbot.org/series/c42e236b-f40c-4d72-8ae7-da4e21c37e17

***

KASAN: slab-out-of-bounds Write in compute_postorder

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      e12873ee856ffa6f104869b8ea10c0f741606f13
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6d2bc952-3d65-4bcd-9a84-1207b810a1b5/config
C repro:   https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b00b3121701/c_repro
syz repro: https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b00b3121701/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in compute_postorder+0x802/0xcb0 kernel/bpf/verifier.c:17840
Write of size 4 at addr ffff88801f1d4b98 by task syz.0.17/5991

CPU: 0 UID: 0 PID: 5991 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 compute_postorder+0x802/0xcb0 kernel/bpf/verifier.c:17840
 bpf_check+0x1f90/0x1d440 kernel/bpf/verifier.c:24437
 bpf_prog_load+0x1318/0x1930 kernel/bpf/syscall.c:2979
 __sys_bpf+0x528/0x870 kernel/bpf/syscall.c:6029
 __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f366058eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef8486b28 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f36607d5fa0 RCX: 00007f366058eba9
RDX: 0000000000000070 RSI: 0000200000000440 RDI: 0000000000000005
RBP: 00007f3660611e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f36607d5fa0 R14: 00007f36607d5fa0 R15: 0000000000000003
 </TASK>

Allocated by task 5991:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4365 [inline]
 __kvmalloc_node_noprof+0x30d/0x5f0 mm/slub.c:5052
 kvmalloc_array_node_noprof include/linux/slab.h:1065 [inline]
 compute_postorder+0xd6/0xcb0 kernel/bpf/verifier.c:17823
 bpf_check+0x1f90/0x1d440 kernel/bpf/verifier.c:24437
 bpf_prog_load+0x1318/0x1930 kernel/bpf/syscall.c:2979
 __sys_bpf+0x528/0x870 kernel/bpf/syscall.c:6029
 __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88801f1d4b80
 which belongs to the cache kmalloc-cg-32 of size 32
The buggy address is located 0 bytes to the right of
 allocated 24-byte region [ffff88801f1d4b80, ffff88801f1d4b98)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88801f1d4e40 pfn:0x1f1d4
memcg:ffff888026bbb801
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88801a449b40 dead000000000100 dead000000000122
raw: ffff88801f1d4e40 000000008040003f 00000000f5000000 ffff888026bbb801
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 532, tgid 532 (kworker/u10:0), ts 5351847364, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2487 [inline]
 allocate_slab+0x8a/0x370 mm/slub.c:2655
 new_slab mm/slub.c:2709 [inline]
 ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
 __slab_alloc mm/slub.c:3981 [inline]
 __slab_alloc_node mm/slub.c:4056 [inline]
 slab_alloc_node mm/slub.c:4217 [inline]
 __do_kmalloc_node mm/slub.c:4364 [inline]
 __kmalloc_noprof+0x305/0x4f0 mm/slub.c:4377
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 lsm_blob_alloc security/security.c:684 [inline]
 lsm_cred_alloc security/security.c:701 [inline]
 security_prepare_creds+0x52/0x390 security/security.c:3271
 prepare_kernel_cred+0x2ee/0x500 kernel/cred.c:617
 call_usermodehelper_exec_async+0xd0/0x360 kernel/umh.c:88
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88801f1d4a80: fa fb fb fb fc fc fc fc 00 00 00 fc fc fc fc fc
 ffff88801f1d4b00: 00 00 00 fc fc fc fc fc fa fb fb fb fc fc fc fc
>ffff88801f1d4b80: 00 00 00 fc fc fc fc fc fa fb fb fb fc fc fc fc
                            ^
 ffff88801f1d4c00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 ffff88801f1d4c80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net eddyz87@gmail.com kernel-team@fb.com martin.lau@linux.dev yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

