Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10D33EC2E3
	for <syzbot@lists.linux.dev>; Sun,  4 Oct 2026 17:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791135689; cv=none; b=jIT73VZjI0D/tvr7+A6xxr57ehTSGLa9e3qS6Kbcm5rHSAh2kgdDmGX32y78mqBko5Zf6jbeUeAfmWm9UqnyKNa5VOJdrUS2Imwa97fD7N7fZNvSLJfdzYCiUekFaSwnjLhe1fFS3iDnqtJrEGDNUHO6M9aDCSd68o46J3PyiWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791135689; c=relaxed/simple;
	bh=XgugV+wBu1XHW4PVpqORgu8rFaqeisNmNmCiYi7At0c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=RfSAWl+87bpsCBTwHq8NfzglBk9f1rSxe0HeL6A2Vx46jUUMPwMCNTT7u9c+/Ymxkm+cdj8b9rpukdrOuY+zX7y2qA+w1Jb9/It73sfJcrO/7U/5wvN3SVNM6mDlve0JbE1ALe9ZGyFSKkpJXuZ8zaZAsq8M92HFRTJbpPM4Ymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-82315dbce25so1039365a34.2
        for <syzbot@lists.linux.dev>; Sun, 04 Oct 2026 10:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791135686; x=1791740486;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hVzND2NL9NvTq9Faukush6bU3XsJrbn79R5iwVLXjlY=;
        b=Vaqvdki3Gsw+7ZUG8AQD1xJfvT/dkdPxqo9GqQjnbj1V4w8KEbDBpddUDZOdygUNj1
         73jtNYr2lTpSe3tybhv8uYBez7KPTjtBRDLtGQOVp2OQ2uEG+bsG31+HrSU/+vnVKyF6
         8+SI41mVTkBfgsdhEUb8ih9kxgTUTkIP6/SCMR2hr4Sjx8Fgq4MZ/f07AILOa654Tq/w
         42Du2nPzRF0zXNk9FvZJhu4grXLPI5vqdIwyTre9FsefA+/KnMuSYstfZbCu7/nh+G3C
         Rw9QNlQmMX0TUX0A4nkdpnycWvBBpKrBTF7VtZ5OOntvv3ITSiC/Ij2a1pbawCE6Z5KJ
         hgpg==
X-Gm-Message-State: AFuF++kQt5jXgJd4JysO/242i69B06h9zcajTnj9nLfQR1JYWPHlrUu9
	prPdsz63K0TxpjoTmWd6MrJKVefc7nTn0zEclpultjDxa6SJOo8P6wasIsDfKUl4NAYTBpsMxgO
	uxyGh2J+btNFAyfWUNz+d0avuySmDnrWlCAQwHr139Wm3NpuUWDrwBzTHWYo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1811:b0:4e6:46cf:4a14 with SMTP id
 5614622812f47-4f528ee2d7bmr8591900b6e.25.1791135686705; Sun, 04 Oct 2026
 10:41:26 -0700 (PDT)
Date: Sun, 04 Oct 2026 10:41:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac28fc6.a58718c8.226e00.0002.GAE@google.com>
Subject: [moderation/CI] Re: bpf: use scalar evolution to widen bounded loops
From: syzbot ci <syzbot+ci94ba2fc855ffd21e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] bpf: use scalar evolution to widen bounded loops
https://lore.kernel.org/all/20261004-scev-minimal-rebase-v2-0-f6254e29fdf2@gmail.com
* [PATCH bpf-next v2 01/43] bpf: represent stack access effects with arg_access_info
* [PATCH bpf-next v2 02/43] bpf: describe helper stack accesses with arg_access_info
* [PATCH bpf-next v2 03/43] bpf: describe kfunc stack accesses with arg_access_info
* [PATCH bpf-next v2 04/43] bpf: track may_write flags in liveness
* [PATCH bpf-next v2 05/43] bpf: summarize may write stack slots in insn_aux_data
* [PATCH bpf-next v2 06/43] bpf: summarize live stack slots in insn_aux_data
* [PATCH bpf-next v2 07/43] bpf: summarize regs that may hold a frame pointer in insn_aux_data
* [PATCH bpf-next v2 08/43] bpf: record write effects for atomic operations in liveness.c
* [PATCH bpf-next v2 09/43] bpf: add tnum_alignment()
* [PATCH bpf-next v2 10/43] bpf: add cnum{32,64}_union()
* [PATCH bpf-next v2 11/43] bpf: add cnum64_intersect_linear()
* [PATCH bpf-next v2 12/43] bpf: expose comparison opcode transformations
* [PATCH bpf-next v2 13/43] bpf: allow subrange relations for PTR_TO_STACK in regsafe()
* [PATCH bpf-next v2 14/43] bpf: representation for intervals with steps
* [PATCH bpf-next v2 15/43] bpf: varying offset access support for PTR_TO_BTF_ID pointers
* [PATCH bpf-next v2 16/43] bpf: save DFS postorder numbers for program instructions
* [PATCH bpf-next v2 17/43] bpf: move the live-register and SCC printout to a standalone function
* [PATCH bpf-next v2 18/43] bpf: compute immediate dominators
* [PATCH bpf-next v2 19/43] bpf: compute loop hierarchy
* [PATCH bpf-next v2 20/43] bpf: add bpf_set_reg_range()
* [PATCH bpf-next v2 21/43] bpf: add bpf_mark_reg_known_scalar()
* [PATCH bpf-next v2 22/43] bpf: add bpf_reg_union()
* [PATCH bpf-next v2 23/43] bpf: add a min-heap for ordered analysis worklists
* [PATCH bpf-next v2 24/43] bpf: record basic-block ends in insn_aux_data
* [PATCH bpf-next v2 25/43] bpf: add bpf_split_cur_state()
* [PATCH bpf-next v2 26/43] bpf: add bpf_same_memory_origin()
* [PATCH bpf-next v2 27/43] bpf: allow precision backtracking between overlapping checkpoints
* [PATCH bpf-next v2 28/43] bpf: compute scalar evolution expressions for loops
* [PATCH bpf-next v2 29/43] bpf: use SCEV to widen bounded loops
* [PATCH bpf-next v2 30/43] bpf: avoid widening registers that hinder exact stack-slot tracking
* [PATCH bpf-next v2 31/43] bpf: bpf_func_state size optimization
* [PATCH bpf-next v2 32/43] selftests/bpf: __msg_next tag for matching messages on consecutive lines
* [PATCH bpf-next v2 33/43] selftests/bpf: bound UNIX socket path loops by sun_path size
* [PATCH bpf-next v2 34/43] selftests/bpf: test for stack-pointer subrange pruning
* [PATCH bpf-next v2 35/43] selftests/bpf: tests for may_write stack-liveness tracking
* [PATCH bpf-next v2 36/43] selftests/bpf: tests for may_def marks of atomic RMW operations
* [PATCH bpf-next v2 37/43] selftests/bpf: tests for map special cases in bpf_helper_stack_access_bytes()
* [PATCH bpf-next v2 38/43] selftests/bpf: tests for register base/step arithmetic
* [PATCH bpf-next v2 39/43] selftests/bpf: tests for register base/step state pruning
* [PATCH bpf-next v2 40/43] selftests/bpf: tests for varying offset access to PTR_TO_BTF_ID
* [PATCH bpf-next v2 41/43] selftests/bpf: tests for loop hierarchy computation
* [PATCH bpf-next v2 42/43] selftests/bpf: tests for immediate dominator computation
* [PATCH bpf-next v2 43/43] selftests/bpf: tests for SCEV analysis and loop widening

and found the following issue:
general protection fault in bpf_compute_scev

Full report is available here:
https://ci.syzbot.org/series/ff81cb40-7952-4f8a-b785-1f9e875f9b1f

***

general protection fault in bpf_compute_scev

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      99dc1ba542420db6b8df209744f55cc52466ad91
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a6050598-290a-4e4f-bba8-55721490a3a8/config
syz repro: https://ci.syzbot.org/findings/63885d0d-bef7-464a-9e39-0d57d15cba85/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5853 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:compute_insn_scevs kernel/bpf/scev.c:1489 [inline]
RIP: 0010:bpf_compute_scev+0x5482/0x6050 kernel/bpf/scev.c:1569
Code: 24 08 30 04 00 00 49 81 c7 30 04 00 00 45 31 ed 48 8b 44 24 10 4e 8d 34 a8 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 af 00 00 00 41 8b 16 48 89 df 31 f6 48 8b
RSP: 0018:ffffc9000372f6e0 EFLAGS: 00010247
RAX: 0000000000000000 RBX: ffff8881144bad00 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000011 RDI: 0000000000000011
RBP: ffffc9000372f910 R08: ffff888101bd0000 R09: 0000000000000004
R10: 000000000000010f R11: 0000000000000000 R12: 0000000000000011
R13: 0000000000000000 R14: 0000000000000004 R15: 0000000000000430
FS:  00007fd0dc1f56c0(0000) GS:ffff88818d6b6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd0db270050 CR3: 00000001bf29a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bpf_check+0x2fbe/0x3550 kernel/bpf/verifier.c:23332
 bpf_prog_load+0x1594/0x1d60 kernel/bpf/syscall.c:3177
 __sys_bpf+0xd86/0xe00 kernel/bpf/syscall.c:6437
 __do_sys_bpf kernel/bpf/syscall.c:6559 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6556 [inline]
 __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6556
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd0db39e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd0dc1f5028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fd0db625fa0 RCX: 00007fd0db39e159
RDX: 0000000000000094 RSI: 0000200000000040 RDI: 0000000000000005
RBP: 00007fd0db43506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd0db626038 R14: 00007fd0db625fa0 R15: 00007fff2dcab378
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:compute_insn_scevs kernel/bpf/scev.c:1489 [inline]
RIP: 0010:bpf_compute_scev+0x5482/0x6050 kernel/bpf/scev.c:1569
Code: 24 08 30 04 00 00 49 81 c7 30 04 00 00 45 31 ed 48 8b 44 24 10 4e 8d 34 a8 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 af 00 00 00 41 8b 16 48 89 df 31 f6 48 8b
RSP: 0018:ffffc9000372f6e0 EFLAGS: 00010247
RAX: 0000000000000000 RBX: ffff8881144bad00 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000011 RDI: 0000000000000011
RBP: ffffc9000372f910 R08: ffff888101bd0000 R09: 0000000000000004
R10: 000000000000010f R11: 0000000000000000 R12: 0000000000000011
R13: 0000000000000000 R14: 0000000000000004 R15: 0000000000000430
FS:  00007fd0dc1f56c0(0000) GS:ffff88818d6b6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd0db270050 CR3: 00000001bf29a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 4 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	49 81 c7 30 04 00 00 	add    $0x430,%r15
   9:	45 31 ed             	xor    %r13d,%r13d
   c:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  11:	4e 8d 34 a8          	lea    (%rax,%r13,4),%r14
  15:	4c 89 f0             	mov    %r14,%rax
  18:	48 c1 e8 03          	shr    $0x3,%rax
  1c:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  23:	fc ff df
* 26:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax <-- trapping instruction
  2a:	84 c0                	test   %al,%al
  2c:	0f 85 af 00 00 00    	jne    0xe1
  32:	41 8b 16             	mov    (%r14),%edx
  35:	48 89 df             	mov    %rbx,%rdi
  38:	31 f6                	xor    %esi,%esi
  3a:	48                   	rex.W
  3b:	8b                   	.byte 0x8b


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

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net eddyz87@gmail.com emil@etsalapatis.com ezingerman@fb.com kernel-team@fb.com yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

