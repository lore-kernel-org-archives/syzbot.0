Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6E32EEE7E
	for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 20:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782593510; cv=none; b=TMqXv1rr9BBrccL71v/JKt70XkKNvkgkd1chASA+ejdMo18pGSNzw1xORf2bxCkhn9o7StUyi+wPRYhBjjPF7OFNbwuaG3YsKsYT9QQH/hFNyoXFU7gfZ3mio5KzXwRG5vuxOeRTETnoZIgRNt8CsSZjRDzBDKrQDE+2MonkEKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782593510; c=relaxed/simple;
	bh=EYOr+I1UR6hrKji8oTo3Po6OA/9JWWKwDQVbeWXGq0I=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=QmpxKtCUWn0/4In7vcwqlszzPk2Z6CAgMBrPks+zmtzbWwmwRcvqXqKZQEZQFnMdJQhv6L+V0O2jgSRUXfAhMacsY4J/EqO4diNXMQ1Mf95WIHhuMtIE60j1v2STDrZHmb21LQJWcIY0xZbG9f3lBQo7W+k5WleilgsR0I2pUuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-495b9aef82bso14595b6e.1
        for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 13:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782593508; x=1783198308;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pcvETmGL2+C/qu3TncN0uerG3p6eS94cOX3VfeI4Y3E=;
        b=X8ZGS/Fc21ktm/3lDY3ROnjtJxT94JWU2RlIXOldDQlo02JlR8OP5NmUdurtWLr0kb
         Tg+0knJfRpoHoAKqcfamPoT52ntsiJOdGSYDqQ8MWrR5OwgMjj4HXsGzA0GkeFtFWGqA
         gsSH7obZnxcW9cNhpREpyyUn3gvtQooH4DpFNY5/zhQzYYvJa3Z1zq1IVp2Zm58ZRU6r
         ygJWWZKnxTLoscuZWik1WBBAKtoruLBqXJoe896G44IrToaMGAP5H52PrfrSIaeQF91A
         k4pZ3Bp2bbpBc8mS1cTrHNgaf1xeqAcZsuKRhMEQXf9roD10Cqf5dpyCV7OXxumrM+h0
         byWw==
X-Gm-Message-State: AOJu0Yw+58uYbJBMGmEdG0sVpBFZH+NYr2g13YjYCeazd3bTabXW/WJ7
	xBzQTIy4Nb9QfltGFymDSeicdM+EYndckCs98yVAVIkJ7xNM5HBSbQwrpZRzVfue9oNDoJ/niyr
	7i7EL1rBIPSU9u2DlxytrFxrEcKYh250F4HxSn61JmBKW61zXqHZ+EVNW/rA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c2b6:b0:490:315d:e0d5 with SMTP id
 5614622812f47-4921791c07bmr10799686b6e.16.1782593507863; Sat, 27 Jun 2026
 13:51:47 -0700 (PDT)
Date: Sat, 27 Jun 2026 13:51:47 -0700
In-Reply-To: <cover.1782571533.git.xukuohai@huawei.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4037e3.80e5668d.5d0ef.0011.GAE@google.com>
Subject: [syzbot ci] Re: bpf: Introduce static-defined tracing probe for BPF
From: syzbot ci <syzbot+cif1531a0a181338a9@syzkaller.appspotmail.com>
To: a.s.protopopov@gmail.com, ameryhung@gmail.com, andrii@kernel.org, 
	ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net, eddyz87@gmail.com, 
	eyal.birger@gmail.com, jolsa@kernel.org, kpsingh@kernel.org, 
	linux-kernel@vger.kernel.org, memxor@gmail.com, rongtao@cestc.cn, 
	xukuohai@huaweicloud.com, yonghong.song@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] bpf: Introduce static-defined tracing probe for BPF
https://lore.kernel.org/all/cover.1782571533.git.xukuohai@huawei.com
* [RFC PATCH bpf-next 01/12] libbpf: Prepare bpf SDT probe section for the linker
* [RFC PATCH bpf-next 02/12] libbpf: Introduce bpf SDT probe macros
* [RFC PATCH bpf-next 03/12] libbpf: Add bpf_sdt_notes section parser
* [RFC PATCH bpf-next 04/12] bpf: Create insn_array map for bpf SDT probe
* [RFC PATCH bpf-next 05/12] bpf: Collect SDT probe BTF IDs from BTF decl tags
* [RFC PATCH bpf-next 06/12] bpf: Add type check for SDT probe site
* [RFC PATCH bpf-next 07/12] bpf: Record probe name in SDT map
* [RFC PATCH bpf-next 08/12] libbpf: Add libbpf support to load SDT observer program
* [RFC PATCH bpf-next 09/12] bpf: Add kernel support to load SDT observer program
* [RFC PATCH bpf-next 10/12] bpf: Support attach and detach for SDT observer program
* [RFC PATCH bpf-next 11/12] bpf, x86: Add JIT support SDT for probe
* [RFC PATCH bpf-next 12/12] selftests/bpf: Add tests for bpf SDT probe

and found the following issue:
general protection fault in do_jit

Full report is available here:
https://ci.syzbot.org/series/86d21ab6-d0e1-4dd3-b7e1-af4571d27460

***

general protection fault in do_jit

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      53435562a725962e4de0c29653223129ba11643a
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/549153a4-d4b8-46a4-8266-df26ad835e2f/config
syz repro: https://ci.syzbot.org/findings/2efaa7e4-eae0-45d0-b336-f0e311f8356e/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc000000010e: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000870-0x0000000000000877]
CPU: 1 UID: 0 PID: 5818 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:do_jit+0x7c8c/0x12a90 arch/x86/net/bpf_jit_comp.c:2806
Code: 49 83 c4 44 4c 89 e0 48 c1 e8 03 0f b6 04 10 84 c0 0f 85 0a 84 00 00 45 03 34 24 48 8b bc 24 a0 01 00 00 48 89 f8 48 c1 e8 03 <80> 3c 10 00 74 17 e8 49 30 b0 00 48 8b bc 24 a0 01 00 00 48 ba 00
RSP: 0018:ffffc900038cf640 EFLAGS: 00010202
RAX: 000000000000010e RBX: 000000000000001c RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000870
RBP: ffffc900038cfa00 R08: ffff88816bb0d940 R09: 0000000000000096
R10: 00000000000000fb R11: 0000000000000000 R12: ffff8881749b8044
R13: ffff88816c445450 R14: 0000000000000003 R15: 0000000000000000
FS:  00007f06814986c0(0000) GS:ffff8882a9224000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0680472780 CR3: 000000001cfc8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bpf_int_jit_compile+0x8af/0x1620 arch/x86/net/bpf_jit_comp.c:3946
 bpf_prog_jit_compile kernel/bpf/core.c:2571 [inline]
 __bpf_prog_select_runtime+0x4e2/0xb20 kernel/bpf/core.c:2640
 bpf_migrate_filter net/core/filter.c:1318 [inline]
 bpf_prepare_filter+0x10ef/0x1280 net/core/filter.c:1366
 sk_attach_filter+0x24/0x140 net/core/filter.c:1550
 tun_attach_filter+0x176/0x280 drivers/net/tun.c:2992
 __tun_chr_ioctl+0x15f1/0x1e10 drivers/net/tun.c:3344
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f068059ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0681498028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f0680815fa0 RCX: 00007f068059ce59
RDX: 0000200000000300 RSI: 00000000401054d5 RDI: 0000000000000003
RBP: 00007f0680632e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0680816038 R14: 00007f0680815fa0 R15: 00007fff056e7c98
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:do_jit+0x7c8c/0x12a90 arch/x86/net/bpf_jit_comp.c:2806
Code: 49 83 c4 44 4c 89 e0 48 c1 e8 03 0f b6 04 10 84 c0 0f 85 0a 84 00 00 45 03 34 24 48 8b bc 24 a0 01 00 00 48 89 f8 48 c1 e8 03 <80> 3c 10 00 74 17 e8 49 30 b0 00 48 8b bc 24 a0 01 00 00 48 ba 00
RSP: 0018:ffffc900038cf640 EFLAGS: 00010202
RAX: 000000000000010e RBX: 000000000000001c RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000870
RBP: ffffc900038cfa00 R08: ffff88816bb0d940 R09: 0000000000000096
R10: 00000000000000fb R11: 0000000000000000 R12: ffff8881749b8044
R13: ffff88816c445450 R14: 0000000000000003 R15: 0000000000000000
FS:  00007f06814986c0(0000) GS:ffff8882a9224000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f06805ea540 CR3: 000000001cfc8000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	49 83 c4 44          	add    $0x44,%r12
   4:	4c 89 e0             	mov    %r12,%rax
   7:	48 c1 e8 03          	shr    $0x3,%rax
   b:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
   f:	84 c0                	test   %al,%al
  11:	0f 85 0a 84 00 00    	jne    0x8421
  17:	45 03 34 24          	add    (%r12),%r14d
  1b:	48 8b bc 24 a0 01 00 	mov    0x1a0(%rsp),%rdi
  22:	00
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 10 00          	cmpb   $0x0,(%rax,%rdx,1) <-- trapping instruction
  2e:	74 17                	je     0x47
  30:	e8 49 30 b0 00       	call   0xb0307e
  35:	48 8b bc 24 a0 01 00 	mov    0x1a0(%rsp),%rdi
  3c:	00
  3d:	48                   	rex.W
  3e:	ba                   	.byte 0xba


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
