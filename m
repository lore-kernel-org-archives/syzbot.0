Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2E040D59E
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 13:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781875242; cv=none; b=mmqF0Sscpn+TuGqR774zO8XsLqe4cPPDY8TLmxZsgQo3EEVNvTPSe9kO/h6RpeWakzrRXitLlHyNAQPegwZLtrRGIpa3rnDD01snsrHBaqGidiZ7bZsgL5tQvcs3FJPC07W/V2z6Tbmiv7nKWnSnzOwa9xyTJz0Pmy5T3R+tBxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781875242; c=relaxed/simple;
	bh=RtUVghacg5CxCoCX83FmCDBRa6fvCqRZdITb+ykFULs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=lxIuK0OyCWvQBKV79mInXlN1F1H6/rUteMDKj9K4ExeXS5lPl9Cgc2hR3WkRKKyLPSupbVtg1QM0G86CZVJWD3Ta+VFgGKnvc59ccMvAwhy2AKvfa9ilIxRXNk6MnTcUWzOR0xlnORCMgjttOu1twMX9hMlC9h0g+n3UcyKwwkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-486a2231742so4666815b6e.1
        for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 06:20:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875240; x=1782480040;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FF2wT4CvKb+GpUfO1B0fZ3OyDvhFfoIQws0YZxoSQAA=;
        b=eXr6v45vRNGqPcUnHf5wyTV6V7YuZu68n1Yil1aVBX++RjEyrzJ0IG+UT6FJrgVkmf
         K6x8dmWHz9IXFT9fj+hWLgBgPzU8lFrfQaEXd3pPQyaiIiOMr3A3P9aUKqZoQQ5jy3Lt
         l6k8/cPVtTSZemT5eR4MtJPUBtUAblJ7p3UZ646uzu3yXcIc2eOScWtJwM4RhjqXV8T6
         mBBQrvcNcdc1rccKjNfs7WANT1s2R34JFJ14VcTzbilkZINudL9amMQlgdfN1yUJDLoE
         HyhoPHgL+89EouU7jEBizWeMM26nr7mWAxE1nh0+cTaVcofdP5kM2Slxr7siEIUfAdRS
         ArzQ==
X-Gm-Message-State: AOJu0YzSnr6QpY6Ybmle74T1UbbnJIOVcO6dYQKIztUvyJFfs85XDIvk
	bUFKhnUnMtCzX6iN5eTY5EVI2/cTLatv4J1Lv5elqCWBf15b7sO74FISRZ4Ages8aR8fbv03dAe
	YYk8cizsxNc2nf6RO8C4qQsmr7L4Fl4WZm0O9AMoaRAZ3HKklCBP4hjMI/c0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3099:b0:485:729e:6ac8 with SMTP id
 5614622812f47-4896c3d6d18mr2111717b6e.5.1781875240209; Fri, 19 Jun 2026
 06:20:40 -0700 (PDT)
Date: Fri, 19 Jun 2026 06:20:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a354228.6d5abbec.a50f.002f.GAE@google.com>
Subject: [moderation/CI] Re: namespace-aware configfs
From: syzbot ci <syzbot+ci7b32e0df290d155b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] namespace-aware configfs
https://lore.kernel.org/all/20260619-configfs-ns-v2-0-82fd7094b8dc@kernel.o=
rg
* [PATCH RFC v2 01/12] fs/configfs: rework configfs_is_root()
* [PATCH RFC v2 02/12] fs/configfs: dynamically allocate super_info
* [PATCH RFC v2 03/12] fs/configfs: separate out configfs_{link,unlink}_roo=
t()
* [PATCH RFC v2 04/12] fs/configfs: add superblock as attribute to configfs=
_pin_fs()
* [PATCH RFC v2 05/12] fs/configfs: add 'fill_subsystem' and 'clear_subsyst=
em' callbacks
* [PATCH RFC v2 06/12] fs/configfs: add superblock as attribute to configfs=
_pin_fs()
* [PATCH RFC v2 07/12] fs/namespace: implement mnt_clone_direct()
* [PATCH RFC v2 08/12] fs/configfs: switch to get_tree_keyed()
* [PATCH RFC v2 09/12] fs/configfs: open-code simple_pin_fs()
* [PATCH RFC v2 10/12] nvmet: make discovery subsystem dynamic
* [PATCH RFC v2 11/12] nvmet: per net-namespace port list
* [PATCH RFC v2 12/12] nvmet: make configfs setup namespace aware

and found the following issue:
general protection fault in put_net

Full report is available here:
https://ci.syzbot.org/series/dd681b97-ec65-4bbf-9440-cbbf1c103062

***

general protection fault in put_net

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      66affa37cfac0aec061cc4bcf4a065b0c52f7e19
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/a4aeaf5c-a583-4650-97af-058d3590923=
4/config
syz repro: https://ci.syzbot.org/findings/773be3e5-366e-482f-8da3-9a5abb71b=
7a8/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
000000003b: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x00000000000001d8-0x00000000000001df]
CPU: 0 UID: 0 PID: 5865 Comm: syz.1.18 Tainted: G        W           syzkal=
ler #0 PREEMPT(full)=20
Tainted: [W]=3DWARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:is_ns_init_id include/linux/ns_common.h:25 [inline]
RIP: 0010:__ns_ref_put include/linux/ns_common.h:72 [inline]
RIP: 0010:put_net+0x33/0x260 include/net/net_namespace.h:297
Code: 53 48 89 fb e8 4e ea 50 ff 48 85 db 0f 84 e8 00 00 00 49 bc 00 00 00 =
00 00 fc ff df 4c 8d b3 e0 01 00 00 4d 89 f5 49 c1 ed 03 <43> 80 7c 25 00 0=
0 74 08 4c 89 f7 e8 6d 1d be ff 4d 8b 3e 31 ff 4c
RSP: 0018:ffffc9000349fcb8 EFLAGS: 00010203
RAX: ffffffff8275a0b2 RBX: fffffffffffffffd RCX: ffff88810d921dc0
RDX: 0000000000000000 RSI: 0000000000010000 RDI: fffffffffffffffd
RBP: 0000000000010000 R08: ffffffff903203f7 R09: 1ffffffff206407e
R10: dffffc0000000000 R11: ffffffff8275aa40 R12: dffffc0000000000
R13: 000000000000003b R14: 00000000000001dd R15: 0000000000000000
FS:  000055558a1a8500(0000) GS:ffff88818dc4e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33263fff CR3: 0000000116edc000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 put_fs_context+0x123/0xb00 fs/fs_context.c:498
 fscontext_release+0x62/0x80 fs/fsopen.c:79
 __fput+0x44f/0xa60 fs/file_table.c:512
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x1fa/0x710 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb902f9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff92660ec8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007fff92660fb0 RCX: 00007fb902f9ce59
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00000000000107a6 R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b32620000 R11: 0000000000000246 R12: 00007fff92660ff0
R13: 00007fb903215fac R14: 00000000000107da R15: 00007fb903215fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:is_ns_init_id include/linux/ns_common.h:25 [inline]
RIP: 0010:__ns_ref_put include/linux/ns_common.h:72 [inline]
RIP: 0010:put_net+0x33/0x260 include/net/net_namespace.h:297
Code: 53 48 89 fb e8 4e ea 50 ff 48 85 db 0f 84 e8 00 00 00 49 bc 00 00 00 =
00 00 fc ff df 4c 8d b3 e0 01 00 00 4d 89 f5 49 c1 ed 03 <43> 80 7c 25 00 0=
0 74 08 4c 89 f7 e8 6d 1d be ff 4d 8b 3e 31 ff 4c
RSP: 0018:ffffc9000349fcb8 EFLAGS: 00010203
RAX: ffffffff8275a0b2 RBX: fffffffffffffffd RCX: ffff88810d921dc0
RDX: 0000000000000000 RSI: 0000000000010000 RDI: fffffffffffffffd
RBP: 0000000000010000 R08: ffffffff903203f7 R09: 1ffffffff206407e
R10: dffffc0000000000 R11: ffffffff8275aa40 R12: dffffc0000000000
R13: 000000000000003b R14: 00000000000001dd R15: 0000000000000000
FS:  000055558a1a8500(0000) GS:ffff88818dc4e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33263fff CR3: 0000000116edc000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	53                   	push   %rbx
   1:	48 89 fb             	mov    %rdi,%rbx
   4:	e8 4e ea 50 ff       	call   0xff50ea57
   9:	48 85 db             	test   %rbx,%rbx
   c:	0f 84 e8 00 00 00    	je     0xfa
  12:	49 bc 00 00 00 00 00 	movabs $0xdffffc0000000000,%r12
  19:	fc ff df
  1c:	4c 8d b3 e0 01 00 00 	lea    0x1e0(%rbx),%r14
  23:	4d 89 f5             	mov    %r14,%r13
  26:	49 c1 ed 03          	shr    $0x3,%r13
* 2a:	43 80 7c 25 00 00    	cmpb   $0x0,0x0(%r13,%r12,1) <-- trapping instr=
uction
  30:	74 08                	je     0x3a
  32:	4c 89 f7             	mov    %r14,%rdi
  35:	e8 6d 1d be ff       	call   0xffbe1da7
  3a:	4d 8b 3e             	mov    (%r14),%r15
  3d:	31 ff                	xor    %edi,%edi
  3f:	4c                   	rex.WR


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
[a.hindborg@kernel.org brauner@kernel.org hare@kernel.org hare@suse.de hch@=
lst.de jack@suse.cz kch@nvidia.com leitao@debian.org linux-fsdevel@vger.ker=
nel.org linux-kernel@vger.kernel.org linux-nvme@lists.infradead.org sagi@gr=
imberg.me viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

