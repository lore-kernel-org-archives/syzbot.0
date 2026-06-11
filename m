Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B83395AD2
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 16:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781194437; cv=none; b=fPkl0v0KlKUAi+I//BbyX1TOyIwJKQxHb7proQy582rTm/RfK1N0XxiUcVc2S3sKOOa+zyEv8aMh0B0pqUfQ8cQ/b5vG3TYimTfcLB8uRwBjr7Pf6ykkCn+Cm97v1+F4KbGnrRhtqEv9JCs0fTqppdpX1bgS11gLpcT39baJ+38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781194437; c=relaxed/simple;
	bh=97a/lG+wyPS3mBa6ZBAUX9LreRm7/sG1m0e0GmBHxxA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qnXEy1I5BpfoJCiJf2ubav0tTcYwDX9QuBDC5n7OsECrYwIEMbocNzq1N1gazeOrarGnG27+/DB9Zox9/I6j6dyE77I3jho85piCccVgwndV66Ua5ffc+voDanQG7Xh8hBeT1yGgHONTQ7F0kHYFHOL5M+HbxyIziiujktghbm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-485ffc7113bso68427b6e.0
        for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 09:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781194435; x=1781799235;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=orOoHX1s6CqlewATXYX9+FkXM98dq/1c7as2L4uViQM=;
        b=o/8MeIthzaiQuaGAAShg03gSBQtyOOewFfv/cj/4OMQthcFrCybgv9pU9d2LXEYaEB
         FMrW8xB5Mzpks0fDMD1S5VHM8SXjl27HnN/uYnHBAX7inWI1IjwP0uJZHasl3zAlnA3x
         klmXNV9gxHkHufmgBoc8Y+RSioCUr8hvPZdUZNwfC8Sq+ipM7gwfHcVZxfG4pOfnW4OB
         l7EwHOQr1RZtzDfPAjnEZRmuBgilyOEtALI2rabM81gMALcZZO6LSs+gIVBjxxDO0QOx
         OCBnfRivI7UpKPpSF/iDeGZjHRseuQZITyPtA/KOXKVcr0LpjE5lMJ79Z9zeezYfnxX2
         Iptg==
X-Gm-Message-State: AOJu0Yz/r7+r3y3Y7fgmyFIEuAa+S2xQXnfzms1WGmsItTDitrKHGmc4
	G6EFzBDIHOtSCAuVQylK+whxt8tJa5hoXt2FUKl23HwJZzN27iZE+IX0LUO4+Jz+HlVmb9F61jK
	vYvw2QMxy1hEn5Z1YtVgVUBzSP3q5Z5NlqzODfKrt7ixtfDUd81YKikr4nxs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b96:b0:69d:a1d0:26d7 with SMTP id
 006d021491bc7-69ecb0581b0mr2602779eaf.47.1781194434896; Thu, 11 Jun 2026
 09:13:54 -0700 (PDT)
Date: Thu, 11 Jun 2026 09:13:54 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2adec2.58e8d1cc.3928d.0006.GAE@google.com>
Subject: [moderation/CI] Re: KVM: x86: Unconditionally recompute CR8 intercept
 on PPR update
From: syzbot ci <syzbot+ci06a7684d8fb5fb81@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] KVM: x86: Unconditionally recompute CR8 intercept on PPR update
https://lore.kernel.org/all/20260610214523.2905255-2-clopez@suse.de
* [PATCH v2] KVM: x86: Unconditionally recompute CR8 intercept on PPR updat=
e

and found the following issue:
WARNING in vmx_update_cr8_intercept

Full report is available here:
https://ci.syzbot.org/series/d94aebb2-8082-4777-ab08-5c3a0d680bed

***

WARNING in vmx_update_cr8_intercept

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      c1f7303302927f9cbf4efedf70f0512cde168c65
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8f417377-50a6-450a-8ce0-a83de33b8c6=
d/config
syz repro: https://ci.syzbot.org/findings/62a660e6-a9b1-42ca-9cf0-7aadd2f5d=
292/syz_repro

------------[ cut here ]------------
debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || !refcount_read(&=
vcpu->kvm->users_count))
WARNING: arch/x86/kvm/vmx/nested.h:61 at get_vmcs12 arch/x86/kvm/vmx/nested=
.h:60 [inline], CPU#0: syz.2.19/5879
WARNING: arch/x86/kvm/vmx/nested.h:61 at vmx_update_cr8_intercept+0x3de/0x4=
e0 arch/x86/kvm/vmx/vmx.c:6879, CPU#0: syz.2.19/5879
Modules linked in:
CPU: 0 UID: 0 PID: 5879 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:get_vmcs12 arch/x86/kvm/vmx/nested.h:60 [inline]
RIP: 0010:vmx_update_cr8_intercept+0x3de/0x4e0 arch/x86/kvm/vmx/vmx.c:6879
Code: 0b 90 e9 f1 fe ff ff e8 30 12 69 00 90 0f 0b 90 e9 59 fe ff ff e8 22 =
12 69 00 e8 ad 86 d6 ff e9 ca fe ff ff e8 13 12 69 00 90 <0f> 0b 90 e9 fc f=
c ff ff e8 05 12 69 00 e8 90 86 d6 ff eb a7 48 c7
RSP: 0018:ffffc9000271f758 EFLAGS: 00010293
RAX: ffffffff815d048d RBX: ffff888113380000 RCX: ffff8881142b8000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 00000000ffffffff R08: ffff8881114d9703 R09: 1ffff1102229b2e0
R10: dffffc0000000000 R11: ffffed102229b2e1 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff888116d0bca0 R15: 0000000000000001
FS:  00007ff34d6b86c0(0000) GS:ffff88818dc9b000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc75e78ae8 CR3: 000000010c609000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 apic_update_ppr arch/x86/kvm/lapic.c:984 [inline]
 kvm_lapic_reset+0x1c24/0x2980 arch/x86/kvm/lapic.c:3023
 kvm_vcpu_reset+0x44c/0x1bf0 arch/x86/kvm/x86.c:12986
 kvm_arch_vcpu_create+0x746/0x8b0 arch/x86/kvm/x86.c:12847
 kvm_vm_ioctl_create_vcpu+0x428/0x930 virt/kvm/kvm_main.c:4201
 kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5159
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff34c79ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff34d6b8028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ff34ca15fa0 RCX: 00007ff34c79ce59
RDX: 0000000000000002 RSI: 000000000000ae41 RDI: 0000000000000004
RBP: 00007ff34c832d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff34ca16038 R14: 00007ff34ca15fa0 R15: 00007ffe4bc28aa8
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
[bp@alien8.de clopez@suse.de dave.hansen@linux.intel.com hpa@zytor.com kvm@=
vger.kernel.org linux-kernel@vger.kernel.org mingo@redhat.com osteffen@redh=
at.com pbonzini@redhat.com rkagan@virtuozzo.com seanjc@google.com sgarzare@=
redhat.com stable@vger.kernel.org tglx@kernel.org x86@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

