Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D298E34AB01
	for <syzbot@lists.linux.dev>; Sat, 13 Jun 2026 20:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781382759; cv=none; b=d67VlvYtOu/JzwKOOampZ4cJJdXIYTY1uFKFou8tg7Kyw8HBO1ra7faJl+Qz0aw+bwUohZA0DKPR/2kleebeblzFSIGfurE5gwTsUHYnVwMXh8WbLKxK+OgIEtobd+ApMLgoc5Z3XYbiYj/JqBVjSuljQlxbOj9y5W0kQPLgJUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781382759; c=relaxed/simple;
	bh=+dVcpXbd8gf1TBNURzrOL154s1ATfna+2GxfDAfIY/I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Bbev6wBFt1twGfZsdNEt+NyDk6AsQagl/ZigIT/DMX6NWHPU28ZzAoW+qbWO2UXF81l2d5/N/OUe1/wa+A4c09w6CG/1YZ7ckCHqUtQmqr929MWiiravF9pyN/cQ+ybXOHbQgDNStqroDmkiADEeG/4jSUYfz35frA/MBORljl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7e6daf5d8f3so2122145a34.2
        for <syzbot@lists.linux.dev>; Sat, 13 Jun 2026 13:32:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781382755; x=1781987555;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4SL+aQgo8C4DrAS+19+Zb4rsI1JiO0HOPv7M9fFC17s=;
        b=TlYkfnMooCToq8dm49hlGsb2ODxSedKZGP2CCSg0FT/+r20uuPRi1VW8obALvTUkRJ
         K2AgnMuehvxQw2i3rcB8a8piyc47b58cOfCifF9XsiqiD62yM83lPRxiiA25hZY14zhF
         LE724i7IJQKNSamfVgmDAHnc48okpoNGXnFRqyqkvJyKzlBQnTZTrw3glpd/cZPjocJG
         6yJSrT5HQLoqKI6Nf4DTua9B9xhUmDHfdxKBf7mvQ9HeB4ILqGT2KD0ftq9HNgGOKtGh
         meQelTzmRqPJR7OFVZ7+xj7FGNfqoOVlNQyajAG3VUZz3jK0tkmu1R/HRWLDlBQo61E2
         UbCA==
X-Gm-Message-State: AOJu0YzbFliVbY/DqgG4ZuPZdKYdPPmnCzixXlmjArC0pMV99tgJhOhv
	rtod5J2GritpssRqApqPjNQaxbW3/7nFROAbDq51EtuARS88sOIDEos7xWrFAFsCMIJs7PfZiE1
	zIAreWRqFuszqVmq9gqQ4noGf3QPZCN5MIDOaQMI3C3dtO+QPC/m7wO+5PGE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1816:b0:487:5d0c:67e4 with SMTP id
 5614622812f47-4875d0c6920mr202264b6e.0.1781382755760; Sat, 13 Jun 2026
 13:32:35 -0700 (PDT)
Date: Sat, 13 Jun 2026 13:32:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2dbe63.8812e0fc.3c3fa4.0009.GAE@google.com>
Subject: [moderation/CI] Re: KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
From: syzbot ci <syzbot+cic0ede7696ff6a703@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
https://lore.kernel.org/all/20260612230622.687665-1-seanjc@google.com
* [PATCH v2 1/8] KVM: x86/hyperv: Get target FIFO in hv_tlb_flush_enqueue(), not caller
* [PATCH v2 2/8] KVM: x86/hyperv: Check for NULL vCPU Hyper-V object in kvm_hv_get_tlb_flush_fifo()
* [PATCH v2 3/8] KVM: x86/hyperv: Ensure vCPU's Hyper-V object is initialized on cross-vCPU accesses
* [PATCH v2 4/8] KVM: Initialize a vCPU's index to '-1' while it's being created
* [PATCH v2 5/8] KVM: Move nVMX's lockdep logic for vcpu->mutex to a common helper
* [PATCH v2 6/8] KVM: x86: Treat a vCPU as unreachable if its index is invalid
* [PATCH v2 7/8] KVM: x86/hyperv: Assert vCPU's mutex is held in to_hv_vcpu()
* [PATCH v2 8/8] KVM: x86/hyperv: Use {READ,WRITE}_ONCE for cross-task synic->active accesses

and found the following issue:
WARNING in kvm_hv_vcpu_uninit

Full report is available here:
https://ci.syzbot.org/series/674ef35a-9335-4710-8a6d-b18d01510cbb

***

WARNING in kvm_hv_vcpu_uninit

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      c1f7303302927f9cbf4efedf70f0512cde168c65
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/20dd789e-0a89-4465-844c-9d91b5ce4a45/config
syz repro: https://ci.syzbot.org/findings/eeefcfe6-b8e9-4c5b-900e-855d814f5d97/syz_repro

------------[ cut here ]------------
debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || vcpu->vcpu_idx < 0 || !refcount_read(&vcpu->kvm->users_count))
WARNING: ./include/linux/kvm_host.h:996 at kvm_lockdep_assert_vcpu_is_locked_or_unreachable include/linux/kvm_host.h:994 [inline], CPU#1: syz.1.25/5883
WARNING: ./include/linux/kvm_host.h:996 at to_hv_vcpu arch/x86/kvm/hyperv.h:78 [inline], CPU#1: syz.1.25/5883
WARNING: ./include/linux/kvm_host.h:996 at kvm_hv_vcpu_uninit+0x198/0x210 arch/x86/kvm/hyperv.c:906, CPU#1: syz.1.25/5883
Modules linked in:
CPU: 1 UID: 0 PID: 5883 Comm: syz.1.25 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:kvm_lockdep_assert_vcpu_is_locked_or_unreachable include/linux/kvm_host.h:994 [inline]
RIP: 0010:to_hv_vcpu arch/x86/kvm/hyperv.h:78 [inline]
RIP: 0010:kvm_hv_vcpu_uninit+0x198/0x210 arch/x86/kvm/hyperv.c:906
Code: 48 89 df e8 0a ba d8 00 48 c7 03 00 00 00 00 eb 05 e8 1c 63 6d 00 5b 41 5c 41 5e 41 5f 5d e9 8f f6 51 0a cc e8 09 63 6d 00 90 <0f> 0b 90 e9 65 ff ff ff 48 c7 c1 e0 5c 30 90 80 e1 07 80 c1 03 38
RSP: 0018:ffffc900035ef940 EFLAGS: 00010293
RAX: ffffffff8158f397 RBX: ffff88816987d400 RCX: ffff888110b20000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff88810c5b9703 R09: 1ffff110218b72e0
R10: dffffc0000000000 R11: ffffed10218b72e1 R12: 0000000000000000
R13: 00000000fffffff8 R14: ffff88810c5b9700 R15: dffffc0000000000
FS:  00007fbc073dc6c0(0000) GS:ffff8882a929a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f451a40fff8 CR3: 000000010f703000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 kvm_arch_vcpu_destroy+0x1a9/0x380 arch/x86/kvm/x86.c:12905
 kvm_vm_ioctl_create_vcpu+0x68b/0x940 virt/kvm/kvm_main.c:4262
 kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5161
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbc0659ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbc073dc028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fbc06815fa0 RCX: 00007fbc0659ce59
RDX: 0000000000000001 RSI: 000000000000ae41 RDI: 00000000000000f7
RBP: 00007fbc06632d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbc06816038 R14: 00007fbc06815fa0 R15: 00007fffc5de9fc8
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
[kvm@vger.kernel.org linux-kernel@vger.kernel.org pbonzini@redhat.com seanjc@google.com syzbot@syzkaller.appspotmail.com vkuznets@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

