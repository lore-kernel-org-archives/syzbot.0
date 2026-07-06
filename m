Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E57A36C9EC
	for <syzbot@lists.linux.dev>; Mon,  6 Jul 2026 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783350497; cv=none; b=P4n2QwkF0VMrWVxpFslxmYYfrQdsRIErR93OzY8ix82H7Ze3DYPPfaID3Mk26ZfQ8GuKp3I9TKC1xiNeoSrwceI12/CamvdFlqZtNC3lhzl9ZctPg8kyrELlZ7Q5tGBUqBByxgAMurkVVyjIkMyx97WnnDM8B9SdNnNVPPAC7Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783350497; c=relaxed/simple;
	bh=o6cfBCr0OHP9q4rSuhDhb1Y5VeHWO9ohq6MiitZhRVo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ApZy26vIMOAmYfWe0holwlKyBakv4laZWLFJAjbYTL0B8MjNKf0Gkhx9ydAFrBHvSqbTFNmtPLafgYdwexSe5UHWaVuGqrryRJlDm7MYCYHwD/iVjdx17agG2JLIXExvcB2bI2H+qlugRlqOUcKdm8akom4piCB6hYYA7vWUV/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-49d4cb3ca23so2012895b6e.3
        for <syzbot@lists.linux.dev>; Mon, 06 Jul 2026 08:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783350495; x=1783955295;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aYMegwcgwvuP7RtDJt3mtuA6Fk6/X3uo2QmMdvEcWng=;
        b=LcFVyQd/0/IK0FogCmMz87/OUIGAPx/KGhrGgobeNWtd4jV9kA/3W8kR6zmcqQlP37
         aqfBHl9okaeWTClsdkopSYGOReRSXLRcXAka4EfoaS9+Jbc35Z5vqSWJbxvawo03xmZh
         ZJRGp3gCcaqphvK7v5pdvzA5RbFBj03ojzxI4CYzoofa8wF5G5LQKTM9zO4Pyf1fi6SA
         utdTj+5rNJG1qFz/gYQldbDe/oxncalHDkrb708HKBTBovD6RsLTOZanS9y6W4qNaYi2
         7+g1bp4z5e4jarF1e0IVXu4z874L3sPJlhXjQawxWDEfdTQocHhF8VbG9UX3uhaG+E2B
         i5UQ==
X-Gm-Message-State: AOJu0YzDOSfWs1Jl7tEsXCD8WvSzOpQlvY35a/yMJCGCxQkaEhqqM0S5
	JiKuyK+2ueZnRWJ7JgH4/OuP+hUn6fYVTBGroB2g3i+tCZd7v/OVe9uARyFFi5aPiVwQ7UGiilN
	hvMZQ4hRPWZA6/fcBWOJTIY/LrEMQF2scTRFHJCPIi0aE/kGR7enfBPxO1Zg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5296:b0:496:b7c:9445 with SMTP id
 5614622812f47-49fdbe418b2mr712310b6e.12.1783350494987; Mon, 06 Jul 2026
 08:08:14 -0700 (PDT)
Date: Mon, 06 Jul 2026 08:08:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4bc4de.b42ede87.8bd1.002c.GAE@google.com>
Subject: [moderation/CI] Re: KVM: x86: Document and enforce APIC base memory hole
From: syzbot ci <syzbot+cibf87a6f723c5bded@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] KVM: x86: Document and enforce APIC base memory hole
https://lore.kernel.org/all/20260706092021.3625908-2-twiederh@redhat.com
* [PATCH 1/4] KVM: x86: Document that KVM_CREATE_IRQCHIP must precede vcpu =
creation
* [PATCH 2/4] KVM: x86: Document APIC base address constraint for in-kernel=
 irqchip
* [PATCH 3/4] KVM: x86: Reject KVM_CREATE_IRQCHIP if APIC base is already m=
apped
* [PATCH 4/4] KVM: x86: Reject user memory regions covering the APIC base

and found the following issue:
WARNING: suspicious RCU usage in gfn_to_memslot

Full report is available here:
https://ci.syzbot.org/series/b02ae7eb-bae2-492f-88f2-fa1b511c93cf

***

WARNING: suspicious RCU usage in gfn_to_memslot

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      8cd9520d35a6c38db6567e97dd93b1f11f185dc6
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/2e25da54-5ae8-4f08-889d-30a90ffbe68=
8/config
syz repro: https://ci.syzbot.org/findings/707c5fee-46af-42c3-9700-7fc53ef58=
eb2/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/linux/kvm_host.h:1084 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active =3D 2, debug_locks =3D 1
1 lock held by syz.0.17/5871:
 #0: ffff888113334b40 (&kvm->lock){+.+.}-{4:4}, at: kvm_arch_vm_ioctl+0x8d1=
/0x1990 arch/x86/kvm/x86.c:7320

stack backtrace:
CPU: 0 UID: 0 PID: 5871 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 __kvm_memslots include/linux/kvm_host.h:1082 [inline]
 kvm_memslots include/linux/kvm_host.h:1089 [inline]
 gfn_to_memslot+0x3df/0x420 virt/kvm/kvm_main.c:2630
 kvm_arch_vm_ioctl+0x1590/0x1990 arch/x86/kvm/x86.c:7340
 kvm_vm_ioctl+0x8f7/0xd30 virt/kvm/kvm_main.c:5381
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd744b9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd7459b7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fd744e15fa0 RCX: 00007fd744b9ce59
RDX: 0000000000000000 RSI: 000000000000ae60 RDI: 0000000000000004
RBP: 00007fd744c32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd744e16038 R14: 00007fd744e15fa0 R15: 00007ffe5f70a5a8
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
[bp@alien8.de corbet@lwn.net dave.hansen@linux.intel.com hpa@zytor.com kvm@=
vger.kernel.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org ming=
o@redhat.com pbonzini@redhat.com seanjc@google.com skhan@linuxfoundation.or=
g tglx@kernel.org twiederh@redhat.com x86@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

