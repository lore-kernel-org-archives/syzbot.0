Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16756319845
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 06:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755239559; cv=none; b=e4CPePo5kHQ9XlMZhy0X03jChHqTSAsYkY4LQnsjr/aDK5ebQ9khCmtYZehlPisuFs2Cx0Wgj6HQRN2cW12yq2DgOJQuak8Jqor+Hu95KlpSFJTtEIy3vIXrjIp7ha89s9gAb5Min3RxBkizaqhTbqo6DY7CE+rR8haQj0knWR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755239559; c=relaxed/simple;
	bh=h4rqyq/iLS8yQ3/QsnjivEZ79/mIPzG6/Z3WGpyPEbg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ksC+CatOnYQGvrOwjFvQ3f5gWnasC2xWIL3lLI1r19ZIHoV2/xyGdMKGRp5C1YJpyzrDW3vJE3CmRD5HZXN4RW4UDbx9q4MOkPtsflLJMip5GyYg95Fdshr5IllRi80ur/HHnx0VxIzo1MH6/+lnj4G0uLjPOrMyOi5Zdz4LGFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-88432e1630fso176966139f.2
        for <syzbot@lists.linux.dev>; Thu, 14 Aug 2025 23:32:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755239556; x=1755844356;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VZlJHLnt0E6+sMYKf0RszObq97C4jGa3xy3LzRvKbCA=;
        b=X2PDlQooKugib7vZiu+96Gl/GMiOpeJeVtchcczjM+19t2bAs+AgpKc+Y4NkRDawvg
         CcIj5xLHIJvaKq/syJyJzBFeOZLQ3LztMwx+1UzOeG/5TgGtZFCK7gNrfdEIjH3BG4AM
         qKfMqnu9TZ7HSPDZXaYWEq2Dsgblo2p1vhT/UJodYBQ4R+ShSTc9wDLjC6ZYRYq8G7Yz
         4ZuXm7CV7YNMeruKSR7/sgY+NTJjluMAeRp4WMvV7xpgksk2t6yb4k97w9KnWAyWkyaz
         mhqDuYEoUe/JZ9htJK+QXhwbIZqTt7abdcNX09rJQM4lu86wkZ4taXqo2evSizdyJHhE
         opaw==
X-Gm-Message-State: AOJu0YyevrUYmXUTXHCJzkyo00SgW5HPjwUsa41ZXxhfxGcsDc8FFoki
	Ik/g8Rb9SRfRkgbVArXibr+MuXX5krCZ1dIPpDKXsNkITbSJKndSA3biYatbmMbpjnK7ityS8Ak
	57MIRodbDLBljNWQrzEARXD9OkKt7nq3rTwbO36TkCoq3Sqx5aMP9gn/GaWs=
X-Google-Smtp-Source: AGHT+IEmDfMhRpob1zI6vxd1de5lX2dn/mUCUe7aSIwjT8ZkMmZq+ETwRA9XTfhl4m6ZJqULBkIrfpcfqxWn09fMSxfqONiLRtpv
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a07:b0:3e5:7437:9187 with SMTP id
 e9e14a558f8ab-3e57e9ddad8mr17432835ab.23.1755239556022; Thu, 14 Aug 2025
 23:32:36 -0700 (PDT)
Date: Thu, 14 Aug 2025 23:32:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689ed484.050a0220.e29e5.000a.GAE@google.com>
Subject: [moderation/CI] Re: Signed BPF programs
From: syzbot ci <syzbot+ci4c6e7e1421addc1d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] Signed BPF programs
https://lore.kernel.org/all/20250813205526.2992911-1-kpsingh@kernel.org
* [PATCH v3 01/12] bpf: Update the bpf_prog_calc_tag to use SHA256
* [PATCH v3 02/12] bpf: Implement exclusive map creation
* [PATCH v3 03/12] libbpf: Implement SHA256 internal helper
* [PATCH v3 04/12] libbpf: Support exclusive map creation
* [PATCH v3 05/12] selftests/bpf: Add tests for exclusive maps
* [PATCH v3 06/12] bpf: Return hashes of maps in BPF_OBJ_GET_INFO_BY_FD
* [PATCH v3 07/12] bpf: Move the signature kfuncs to helpers.c
* [PATCH v3 08/12] bpf: Implement signature verification for BPF programs
* [PATCH v3 09/12] libbpf: Update light skeleton for signing
* [PATCH v3 10/12] libbpf: Embed and verify the metadata hash in the loader
* [PATCH v3 11/12] bpftool: Add support for signing BPF programs
* [PATCH v3 12/12] selftests/bpf: Enable signature verification for some lskel tests

and found the following issue:
general protection fault in bpf_verify_pkcs7_signature

Full report is available here:
https://ci.syzbot.org/series/67d9a289-da5c-4051-8c3c-cc32b6ccd77d

***

general protection fault in bpf_verify_pkcs7_signature

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      07866544e410e4c895a729971e4164861b41fad5
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/1e87aafb-11dc-48f1-a980-c91551ba52de/config
C repro:   https://ci.syzbot.org/findings/0c329233-09a8-4e8b-9e6e-72f234dd85ab/c_repro
syz repro: https://ci.syzbot.org/findings/0c329233-09a8-4e8b-9e6e-72f234dd85ab/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-00022-g07866544e410-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:bpf_verify_pkcs7_signature+0x31/0x190 kernel/bpf/helpers.c:3835
Code: 41 56 41 55 41 54 53 48 89 d3 49 89 f6 49 89 ff 48 bd 00 00 00 00 00 fc ff df e8 aa b0 e0 ff 4c 8d 63 08 4c 89 e0 48 c1 e8 03 <0f> b6 04 28 84 c0 0f 85 01 01 00 00 41 80 3c 24 00 74 3d 48 89 d8
RSP: 0018:ffffc90002f7fa08 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888020c51cc0
RDX: 0000000000000000 RSI: ffffc90002f7faa0 RDI: ffffc90002f7fac0
RBP: dffffc0000000000 R08: 0000000000000018 R09: ffffffff820b8a70
R10: ffffc90002f7fac0 R11: fffff520005eff5a R12: 0000000000000008
R13: 0000000000000010 R14: ffffc90002f7faa0 R15: ffffc90002f7fac0
FS:  00005555895fe500(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30b63fff CR3: 0000000028898000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bpf_prog_verify_signature+0x2da/0x3b0 kernel/bpf/syscall.c:2815
 bpf_prog_load+0xcc4/0x19e0 kernel/bpf/syscall.c:2989
 __sys_bpf+0x507/0x860 kernel/bpf/syscall.c:6116
 __do_sys_bpf kernel/bpf/syscall.c:6226 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6224 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6224
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0a4558ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff940250b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f0a457b5fa0 RCX: 00007f0a4558ebe9
RDX: 00000000000000a8 RSI: 0000200000000140 RDI: 0000000000000005
RBP: 00007f0a45611e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0a457b5fa0 R14: 00007f0a457b5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bpf_verify_pkcs7_signature+0x31/0x190 kernel/bpf/helpers.c:3835
Code: 41 56 41 55 41 54 53 48 89 d3 49 89 f6 49 89 ff 48 bd 00 00 00 00 00 fc ff df e8 aa b0 e0 ff 4c 8d 63 08 4c 89 e0 48 c1 e8 03 <0f> b6 04 28 84 c0 0f 85 01 01 00 00 41 80 3c 24 00 74 3d 48 89 d8
RSP: 0018:ffffc90002f7fa08 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888020c51cc0
RDX: 0000000000000000 RSI: ffffc90002f7faa0 RDI: ffffc90002f7fac0
RBP: dffffc0000000000 R08: 0000000000000018 R09: ffffffff820b8a70
R10: ffffc90002f7fac0 R11: fffff520005eff5a R12: 0000000000000008
R13: 0000000000000010 R14: ffffc90002f7faa0 R15: ffffc90002f7fac0
FS:  00005555895fe500(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30b63fff CR3: 0000000028898000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	41 56                	push   %r14
   2:	41 55                	push   %r13
   4:	41 54                	push   %r12
   6:	53                   	push   %rbx
   7:	48 89 d3             	mov    %rdx,%rbx
   a:	49 89 f6             	mov    %rsi,%r14
   d:	49 89 ff             	mov    %rdi,%r15
  10:	48 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%rbp
  17:	fc ff df
  1a:	e8 aa b0 e0 ff       	call   0xffe0b0c9
  1f:	4c 8d 63 08          	lea    0x8(%rbx),%r12
  23:	4c 89 e0             	mov    %r12,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 04 28          	movzbl (%rax,%rbp,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 01 01 00 00    	jne    0x137
  36:	41 80 3c 24 00       	cmpb   $0x0,(%r12)
  3b:	74 3d                	je     0x7a
  3d:	48 89 d8             	mov    %rbx,%rax


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bboscaccy@linux.microsoft.com bpf@vger.kernel.org daniel@iogearbox.net kpsingh@kernel.org kys@microsoft.com linux-security-module@vger.kernel.org paul@paul-moore.com]

If the report looks fine to you, reply with:
#syz upstream

