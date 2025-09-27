Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBCE86359
	for <syzbot@lists.linux.dev>; Sat, 27 Sep 2025 00:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758932863; cv=none; b=no0mVQHSW7j/w0Zkz8X1dlSMWgp0tAjhcAEl7bnbciuBhjpdCUaj9uBP+17dGFXDv3ZlYaawx0ujR8kHgumznN4+mZ1Uv/WsZd2BEALeXpnCsQaWzin9TWTm7u5Vktol/I1Q7ecpWHvvwRm6oVB6obkoPZ24+K+a9qpdviqG1dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758932863; c=relaxed/simple;
	bh=ud8RkufimNMyFH21DB+aGGwe2RF9GSmc+PrG/UIFlaY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=UOhuR7BxqeWDHM4rNjuUK6JOeZUP/LezH5my4k1X3dujaKF6TBOTkzN/1oidmhZS0x8kT9ir2wo0bOZhz4neM6PKtrlDztGLCsTMarYyStyAP2M9Go74Hk0YmpOAGkP2DhvJKx5l7FetaBsqN3fcj7niwWgMjQ+MXPe7AzMyIsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-90e469a7f6bso164870339f.2
        for <syzbot@lists.linux.dev>; Fri, 26 Sep 2025 17:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758932861; x=1759537661;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KcYEkunbPC70P8TjGyaYZiNQoi6woUVaqA7Wl0FtPtw=;
        b=sC2qkZvos+q4JOZu/hgC8tJS2lsHwi7Lgeac2xVdeEja/AuGosQpAugZmr6fAaKvcV
         Yvgc1Rf70S+6kKcLoY6YQTcmQOsn5m9YZcBhTmG2lpyeGwg/8hPQbWVKelGYUYRjEe5g
         UoZjK2O7+sYx8emRu49vFKdS0rWD1YktwN64lCgaiWirqcGgnE5EdUMWYH1kc+AVWjVn
         yuRdfA/sX+cI26ShgL2dsWuKtoz1rRxzI41nMZMmyZaMA91RoU/KMONcHtkTUzQ+pPKs
         4pe6uCS0inZKjhj3tYEnOIj4W5+tXlsbJzmrwR1x56RNtlDfoulrmPtmZuuCok45XER3
         SVcQ==
X-Gm-Message-State: AOJu0YxvVLqLEYVp7yvKP8rwaWw7GH5OxHjoaJXa2fLy6lrmSecqp7gX
	F8tKHyjL0ZEjLnUaK4LPfBGD75sWrjZdJLyfzZHjvpPQDOGm2V81+EJEgmQ+AkEDrCM0dACZAyf
	rY6q3EzYvBG7g6NFLFChfkXsEnQVjR5RYNHB4o6N+Giki39w/1mWNWCDLOIk=
X-Google-Smtp-Source: AGHT+IGOu901jJBzyWOjijKuxRwodZZuyIINSy/pcKT/TIyp5NQx6PA/7VP7S9mE1xUtbisKdAH9JnWbxyTOHZiki0DcwJFBnuhA
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4901:b0:423:b2b8:99c6 with SMTP id
 e9e14a558f8ab-4259563e05cmr133430225ab.21.1758932860770; Fri, 26 Sep 2025
 17:27:40 -0700 (PDT)
Date: Fri, 26 Sep 2025 17:27:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d72f7c.a70a0220.10c4b.0004.GAE@google.com>
Subject: [moderation/CI] Re: BPF signature hash chains
From: syzbot ci <syzbot+cice8998b6b30a0022@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] BPF signature hash chains
https://lore.kernel.org/all/20250926203111.1305999-1-bboscaccy@linux.micros=
oft.com
* [PATCH bpf-next 1/2] bpf: Add hash chain signature support for arbitrary =
maps
* [PATCH bpf-next 2/2] selftests/bpf: Enable map verification for some lske=
l tests

and found the following issue:
general protection fault in bpf_prog_verify_signature

Full report is available here:
https://ci.syzbot.org/series/9d93d1cd-d2bd-4967-a631-f3e84ee6fb41

***

general protection fault in bpf_prog_verify_signature

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      d43029ff7d1b7183dc0cf11b6cc2c12a0b810ad8
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/a6b64e3c-6f08-4a6d-b484-ece99910a3f=
0/config
C repro:   https://ci.syzbot.org/findings/a6c59e03-c4f7-4752-8d4f-526ccf945=
b7c/c_repro
syz repro: https://ci.syzbot.org/findings/a6c59e03-c4f7-4752-8d4f-526ccf945=
b7c/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
00020244a9: 0000 [#1] SMP KASAN PTI
KASAN: probably user-memory-access in range [0x0000000010122548-0x000000001=
012254f]
CPU: 1 UID: 0 PID: 6002 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:bpf_prog_verify_signature+0x610/0xc40 kernel/bpf/syscall.c:2873
Code: f7 e8 04 73 52 00 4d 8b 2e 89 d8 25 ff ff ff 7f 48 8b 4c 24 10 4c 8d =
34 81 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c=
0 0f 85 c9 03 00 00 49 63 06 4c 8d 34 85 00 00 00
RSP: 0018:ffffc90002bff920 EFLAGS: 00010206
RAX: 00000000020244a9 RBX: 0000000004048956 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002bffb30 R08: ffffffff8fa3b537 R09: 1ffffffff1f476a6
R10: dffffc0000000000 R11: fffffbfff1f476a7 R12: 1ffff9200057ff34
R13: 0000000000000000 R14: 000000001012254a R15: 0000000080000000
FS:  0000555591f35500(0000) GS:ffff8881a3c11000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000011081a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bpf_prog_load+0xcc7/0x19e0 kernel/bpf/syscall.c:3072
 __sys_bpf+0x4ff/0x850 kernel/bpf/syscall.c:6199
 __do_sys_bpf kernel/bpf/syscall.c:6309 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6307 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6307
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feeb318ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffd613f7e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007feeb33d5fa0 RCX: 00007feeb318ec29
RDX: 00000000000000b9 RSI: 0000200000000100 RDI: 0000000000000005
RBP: 00007feeb3211e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007feeb33d5fa0 R14: 00007feeb33d5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bpf_prog_verify_signature+0x610/0xc40 kernel/bpf/syscall.c:2873
Code: f7 e8 04 73 52 00 4d 8b 2e 89 d8 25 ff ff ff 7f 48 8b 4c 24 10 4c 8d =
34 81 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c=
0 0f 85 c9 03 00 00 49 63 06 4c 8d 34 85 00 00 00
RSP: 0018:ffffc90002bff920 EFLAGS: 00010206
RAX: 00000000020244a9 RBX: 0000000004048956 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002bffb30 R08: ffffffff8fa3b537 R09: 1ffffffff1f476a6
R10: dffffc0000000000 R11: fffffbfff1f476a7 R12: 1ffff9200057ff34
R13: 0000000000000000 R14: 000000001012254a R15: 0000000080000000
FS:  0000555591f35500(0000) GS:ffff8881a3c11000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000011081a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	f7 e8                	imul   %eax
   2:	04 73                	add    $0x73,%al
   4:	52                   	push   %rdx
   5:	00 4d 8b             	add    %cl,-0x75(%rbp)
   8:	2e 89 d8             	cs mov %ebx,%eax
   b:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
  10:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  15:	4c 8d 34 81          	lea    (%rcx,%rax,4),%r14
  19:	4c 89 f0             	mov    %r14,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax <-- trapping instruct=
ion
  2e:	84 c0                	test   %al,%al
  30:	0f 85 c9 03 00 00    	jne    0x3ff
  36:	49 63 06             	movslq (%r14),%rax
  39:	4c                   	rex.WR
  3a:	8d                   	.byte 0x8d
  3b:	34 85                	xor    $0x85,%al
  3d:	00 00                	add    %al,(%rax)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bboscaccy@linux.microsoft.com bpf@vger.ke=
rnel.org daniel@iogearbox.net james.bottomley@hansenpartnership.com kpsingh=
@kernel.org kys@microsoft.com linux-security-module@vger.kernel.org paul@pa=
ul-moore.com wufan@linux.microsoft.com]

If the report looks fine to you, reply with:
#syz upstream

