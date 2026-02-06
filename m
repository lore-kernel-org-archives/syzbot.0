Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A233D7D71
	for <syzbot@lists.linux.dev>; Fri,  6 Feb 2026 13:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770383696; cv=none; b=hBtSDx/2c6z0d01FdAcaUeeqXfnX7eTudo1oVvq5Bo8KB1zJGUnijmaDjx6GGDmtje7yp5vaP2n50SZhSRFhGQqz61YqXK+hVsTezNSRqBWzWkXa9yLgYRP8JT2y87HJxDaVVluvHL0qg4qpQyEyeRpQ1HQcOzH9+QEBLFr69Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770383696; c=relaxed/simple;
	bh=2iGcZywpHodWzlOKuRQyg6A5ib5PXEpTq0DgaLXPqe0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=RPL813pjHbq/898vSutUzWWEbNaJHnQyZFmJgGuW+0uBPqZQugF+FxVhZ7X8Rq/CncMzyKuweLZsjRL/1Zu9coTXkLggek04RyVvoqmQDGcb79wNzVkZRXTshz5nJ1n+o4LlAvTd+fVT6LqLveTEJHC22GtPw/dZfY2/MEPmcuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-409483fc17aso8469754fac.2
        for <syzbot@lists.linux.dev>; Fri, 06 Feb 2026 05:14:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770383695; x=1770988495;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PWkDCgh9f/kPKPcI5vfsA62tRCAy5B5GJyKSAXzysps=;
        b=U48AGHoqR6k2a0KT7C4sLIdBSZb+0y/IA5gpyotDmOIareX+Oh7ugIsLI1oK5Ymxmd
         7X0H6In943Uswnesp9AG8XP/eGxhmZrWRNvYvf5W40cJVoNfj21GpW7fAYtp3w+FyDVq
         jTS3gS9GG6wEylgVaeO8LEu2O0mZ8w0uR05jGwchbydvM/5iRQQtNL5g8RHOzPHijJ2W
         Gk8m0rZ6AeMz7FuXU61EugMGk/YbB80t9tra+h+vhenfOpeGs0XH1GURlFnCxjw/Ku+Z
         EBVxRdfYEJf5b1qgoFzrePnMR1911lnIolzr835NquDUi4kH9UnSAAg48MJXaNFuk1L6
         6GLw==
X-Gm-Message-State: AOJu0YwJ5ig1CyPKSKj91fv/wVUtGPSCIpSYzqRS6EJBu/75rQwhfjUJ
	gHzOEPwGudws6rqHlVxVLFEUtGbANcBPfGpxmBj1L8xDSEiytno7iweXMNp0lSDjYyVFeqyyRyj
	Rd4SJH7NAc5E7p1oOnS0thE9Y+O+c7xQ6P626gGOVFnpw/G3Rty60+Zq1aos=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81d6:b0:66a:1886:e4d2 with SMTP id
 006d021491bc7-66d0a47838emr1270349eaf.21.1770383695369; Fri, 06 Feb 2026
 05:14:55 -0800 (PST)
Date: Fri, 06 Feb 2026 05:14:55 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6985e94f.050a0220.3b3015.003d.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Add preempt disable for bpf_get_stack
From: syzbot ci <syzbot+ci1ea0462c6f16682e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] bpf: Add preempt disable for bpf_get_stack
https://lore.kernel.org/all/20260206090653.1336687-1-chen.dylane@linux.dev
* [PATCH bpf-next v2 1/2] bpf: Add preempt disable for bpf_get_stack
* [PATCH bpf-next v2 2/2] bpf: Add preempt disable for bpf_get_stackid

and found the following issue:
WARNING in preempt_count_sub

Full report is available here:
https://ci.syzbot.org/series/90d08df2-d19d-404f-b9dd-c201605b83a2

***

WARNING in preempt_count_sub

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      1ace9bac1ad2bc6a0a70baaa16d22b7e783e88c5
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/64881591-241a-4854-9beb-1f691566835=
c/config
C repro:   https://ci.syzbot.org/findings/98f347c8-b879-4c85-829b-a20ef900e=
645/c_repro
syz repro: https://ci.syzbot.org/findings/98f347c8-b879-4c85-829b-a20ef900e=
645/syz_repro

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(val > preempt_count())
WARNING: kernel/sched/core.c:5751 at preempt_count_sub+0x9e/0x170 kernel/sc=
hed/core.c:5751, CPU#0: syz.0.17/5991
Modules linked in:
CPU: 0 UID: 0 PID: 5991 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:preempt_count_sub+0xa5/0x170 kernel/sched/core.c:5751
Code: 05 cf 8f 48 c1 e8 03 0f b6 04 18 84 c0 0f 85 88 00 00 00 83 3d ef 21 =
3d 0e 00 75 13 48 8d 3d b2 f3 3f 0e 48 c7 c6 a0 fe 8b 8b <67> 48 0f b9 3a 9=
0 eb b8 90 e8 5d ab 03 03 85 c0 74 2f 48 c7 c0 a4
RSP: 0018:ffffc90004437bc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff8881746f8000
RDX: 0000000000000000 RSI: ffffffff8b8bfea0 RDI: ffffffff8fd1d770
RBP: ffffc90004437cd0 R08: ffffffff8fcf05a3 R09: 1ffffffff1f9e0b4
R10: dffffc0000000000 R11: fffffbfff1f9e0b5 R12: dffffc0000000000
R13: 1ffff92000886f84 R14: 0000000000000000 R15: 0000000000000000
FS:  000055557d481500(0000) GS:ffff88818e328000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1f89c706c0 CR3: 00000001742f0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bpf_prog_test_run_raw_tp+0x4b9/0x6c0 net/bpf/test_run.c:794
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4721
 __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6246
 __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f89d9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff9e3fd488 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f1f8a015fa0 RCX: 00007f1f89d9acb9
RDX: 000000000000000c RSI: 0000200000000500 RDI: 000000000000000a
RBP: 00007f1f89e08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1f8a015fac R14: 00007f1f8a015fa0 R15: 00007f1f8a015fa0
 </TASK>
----------------
Code disassembly (best guess):
   0:	05 cf 8f 48 c1       	add    $0xc1488fcf,%eax
   5:	e8 03 0f b6 04       	call   0x4b60f0d
   a:	18 84 c0 0f 85 88 00 	sbb    %al,0x88850f(%rax,%rax,8)
  11:	00 00                	add    %al,(%rax)
  13:	83 3d ef 21 3d 0e 00 	cmpl   $0x0,0xe3d21ef(%rip)        # 0xe3d2209
  1a:	75 13                	jne    0x2f
  1c:	48 8d 3d b2 f3 3f 0e 	lea    0xe3ff3b2(%rip),%rdi        # 0xe3ff3d5
  23:	48 c7 c6 a0 fe 8b 8b 	mov    $0xffffffff8b8bfea0,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	90                   	nop
  30:	eb b8                	jmp    0xffffffea
  32:	90                   	nop
  33:	e8 5d ab 03 03       	call   0x303ab95
  38:	85 c0                	test   %eax,%eax
  3a:	74 2f                	je     0x6b
  3c:	48                   	rex.W
  3d:	c7                   	.byte 0xc7
  3e:	c0                   	.byte 0xc0
  3f:	a4                   	movsb  %ds:(%rsi),%es:(%rdi)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org chen.dylane@linux.dev=
 daniel@iogearbox.net eddyz87@gmail.com haoluo@google.com john.fastabend@gm=
ail.com jolsa@kernel.org kpsingh@kernel.org linux-kernel@vger.kernel.org ma=
rtin.lau@linux.dev sdf@fomichev.me song@kernel.org yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

