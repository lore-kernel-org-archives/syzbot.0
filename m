Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927F325B08A
	for <syzbot@lists.linux.dev>; Tue,  9 Jun 2026 00:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965773; cv=none; b=e+o9Hk3Fa8GFSPgJB4d/1ZhgIfWeibzTyCbhQ9tY0uHB5ioOYgpZHg18MBrhbnjdDyxIGiXv5JFGd54z6FzEpsfy2BAFxClX+stqOJpft89+dOTq32nV9WvOzLlhBtjtoOLuhErfre4Qx5IED4ugTTN6a9tTjVShEMWw7tgb4NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965773; c=relaxed/simple;
	bh=8TZhdUxW7txjYmge4iMLpo0eOltxLMkq2lCZiYBmr/w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=LyHIDy7hAsXVOpRXHNUetE3c6BTeCbWp/qMYY3A2i3da8+53/+zbMKTPNgjoehGOTxtVJv8mFsawc14i97FD6x48hl/+u6eSjeUJi+fXuVfcmiMScdp5Qot1bk3I3c9jGaFoCmsbjPu20M+hzYUDN6TZHNsbat/nEIOHgJrWo8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e6ed99d4dbso4078247a34.0
        for <syzbot@lists.linux.dev>; Mon, 08 Jun 2026 17:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780965770; x=1781570570;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+kyW64b5CRdKNNXFo7E+1M1DpLTkXziuXfG34+/CqWc=;
        b=hQ9/gFjaIXdWnGL3/UAmB7rhowrWLFFU5gqST65+tcXgsWoxriYtx5cELx3qSNv52z
         pQiUS51iEWNT/gmoQxDWNflgDoq7ZsBBWFGqIgKtHpM6Yx2XXRNSeUpgtbb0DgQ4M75B
         emLx4Yz5ThkDbzJfIb0W9ayiTFAFVop0ilsUvVRr757LxaCLRdf6LPiBH0UNhS+lSPSQ
         R2IRu/h4ixeRTGb+Bn1ySGFx1KiRe8MeRUl1UrAoQlGjhMt35LH90D+zspCaAz1Pafuw
         I4tkv2udw97+3XkyuyEduB2huBkTw3Dwc+/87D1zJj/lxvTD20kGyb2zgBZn+q7R7zFy
         SEDw==
X-Gm-Message-State: AOJu0Yxk7CjBA8eLr6kboF7WWPzjAEPitZKTC0nNKic5QJTuoGHyEMTv
	ZeavNukEFalXZsUOLglF9WDmp17Dls12LoZ51dSRfLS6BwIRR5kjftmV4QFcYtYZRz1qSVUQ5xk
	WXBHme2fIlqLQn6tKIN8mwMCY4EiXW7HHAUoR2knq7BhG9qgPJpReDoIxgYU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81cd:b0:69e:343e:2ba1 with SMTP id
 006d021491bc7-69e68b83921mr10230534eaf.23.1780965770524; Mon, 08 Jun 2026
 17:42:50 -0700 (PDT)
Date: Mon, 08 Jun 2026 17:42:50 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a27618a.c25708ab.1b19ef.0017.GAE@google.com>
Subject: [moderation/CI] Re: KVM Planes + SEV-SNP Support
From: syzbot ci <syzbot+ci1998579f36d5c805@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] KVM Planes + SEV-SNP Support
https://lore.kernel.org/all/20260608144252.351443-1-joro@8bytes.org
* [PATCH 01/60] x86/sev: Define the #HV doorbell page structure
* [PATCH 02/60] KVM: SVM: Add support for the SEV-SNP #HV doorbell page NAE=
 event
* [PATCH 03/60] KVM: SVM: Inject #HV when Restricted Injection is active
* [PATCH 04/60] KVM: SVM: Inject NMIs when Restricted Injection is active
* [PATCH 05/60] KVM: SVM: Inject MCEs when Restricted Injection is active
* [PATCH 06/60] KVM: SVM: Enable Restricted Injection for an SEV-SNP guest
* [PATCH 07/60] KVM: SVM: Add support for the SEV-SNP #HV IPI NAE event
* [PATCH 08/60] Documentation: kvm: introduce "VM plane" concept
* [PATCH 09/60] kvm: Introduce struct kvm_plane
* [PATCH 10/60] kvm: Move vcpu_array to struct kvm_plane
* [PATCH 11/60] kvm: Introduce struct kvm_vcpu_common
* [PATCH 12/60] kvm: Move vcpu accounting to struct kvm_vcpu_common
* [PATCH 13/60] kvm: Add read accessors for kvm_vcpu scheduling state
* [PATCH 14/60] kvm: Make kvm_running_vcpus point to struct kvm_vcpu_common
* [PATCH 15/60] kvm: Move VCPU scheduling state to struct kvm_vcpu_common
* [PATCH 16/60] kvm: Add accessors for kvm_vcpu->mutex
* [PATCH 17/60] kvm: Move VCPU locking to struct kvm_vcpu_common
* [PATCH 18/60] kvm: Move kvm_vcpu->rcuwait to struct kvm_vcpu_common
* [PATCH 19/60] kvm: Introduce accessors for kvm_vcpu->mode
* [PATCH 20/60] kvm: Move kvm_vcpu mode and requests field to struct kvm_vc=
pu_common
* [PATCH 21/60] kvm: Introduce per-plane VCPU requests
* [PATCH 22/60] kvm: Move kvm_vcpu pid members to struct kvm_vcpu_common
* [PATCH 23/60] kvm: Move kvm_vcpu sigset members to struct kvm_vcpu_common
* [PATCH 24/60] kvm: Move kvm_vcpu spinloop members to struct kvm_vcpu_comm=
on
* [PATCH 25/60] kvm: Move kvm_vcpu->dirty_ring to struct kvm_vcpu_common
* [PATCH 26/60] kvm: Introduce arch-specific plane state
* [PATCH 27/60] kvm: Introduce arch-specific part of struct kvm_vcpu_common
* [PATCH 28/60] kvm: Implement KVM_CAP_PLANES
* [PATCH 29/60] kvm: Implement KVM_CREATE_PLANE ioctl
* [PATCH 30/60] kvm: Add KVM_EXIT_PLANE_EVENT
* [PATCH 31/60] kvm: Allocate struct kvm_plane in architecture code
* [PATCH 32/60] kvm: Allocate struct kvm_run only for struct kvm_vcpu_commo=
n
* [PATCH 33/60] KVM: Implement KVM_CREATE_VCPU ioctl for planes
* [PATCH 34/60] kvm: Keep track of plane VCPUs in struct kvm_vcpu_common
* [PATCH 35/60] kvm: Add VCPU plane-scheduling state and helpers
* [PATCH 36/60] kvm: Add plane_level to kvm_kernel_irq_routing_entry
* [PATCH 37/60] kvm: Pass plane_level to kvm_set_routing_entry()
* [PATCH 38/60] kvm: Make KVM_SIGNAL_MSI per plane
* [PATCH 39/60] kvm: Make KVM_SET_GSI_ROUTING per plane
* [PATCH 40/60] kvm: x86: Handle IOAPIC EOIs per plane
* [PATCH 41/60] kvm: x86: Make apic_map per plane
* [PATCH 42/60] kvm: x86: Make local APIC code aware of planes
* [PATCH 43/60] kvm: x86: Move CPUID state to struct kvm_vcpu_arch_common
* [PATCH 44/60] kvm: x86: Move cpu_caps to struct kvm_vcpu_arch_common
* [PATCH 45/60] kvm: x86: Update state for all plane VCPUs after CPUID upda=
te
* [PATCH 46/60] kvm: x86: Share MTRR state across planes
* [PATCH 47/60] kvm: x86: Select a plane to run
* [PATCH 48/60] kvm: x86: Make event injection VCPU requests per-plane
* [PATCH 49/60] kvm: x86: Allow hardware backend to overwrite struct kvm_pl=
ane allocation
* [PATCH 50/60] kvm: x86: Make KVM_REQ_UPDATE_PROTECTED_GUEST_STATE per pla=
ne
* [PATCH 51/60] kvm: x86: Share pio_data across planes
* [PATCH 52/60] kvm: x86: Switch to plane0 if it has events
* [PATCH 53/60] kvm: x86: Introduce max_planes x86-op
* [PATCH 54/60] kvm: x86: Restrict KVM planes support to KVM_IRQCHIP_SPLIT
* [PATCH 55/60] kvm: svm: Track vmsa_features per plane
* [PATCH 56/60] kvm: svm: Implement GET_AP_APIC_IDS NAE event
* [PATCH 57/60] kvm: sev: Allow for VMPL level specification in AP create
* [PATCH 58/60] kvm: svm: Invoke a specified VMPL level VMSA for the vCPU
* [PATCH 59/60] kvm: svm: Implement max_planes x86 operation
* [PATCH 60/60] kvm: svm: Advertise full multi-VMPL support to the SNP gues=
t

and found the following issue:
WARNING in __kvm_plane_ioctl

Full report is available here:
https://ci.syzbot.org/series/7426b4e7-e1df-4f2e-8464-acda36316e29

***

WARNING in __kvm_plane_ioctl

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      2d3090a8aeb596a26935db0955d46c9a5db5c6ce
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f9f7af87-a544-413f-b7e0-662f92794f1=
1/config
syz repro: https://ci.syzbot.org/findings/751865bf-494c-4000-9b11-d8aa15f03=
893/syz_repro

------------[ cut here ]------------
r =3D=3D -EBUSY
WARNING: arch/x86/kvm/../../../virt/kvm/kvm_main.c:4412 at kvm_plane_ioctl_=
create_vcpu virt/kvm/kvm_main.c:4412 [inline], CPU#1: syz.2.19/5809
WARNING: arch/x86/kvm/../../../virt/kvm/kvm_main.c:4412 at __kvm_plane_ioct=
l+0x8bd/0xa70 virt/kvm/kvm_main.c:4908, CPU#1: syz.2.19/5809
Modules linked in:
CPU: 1 UID: 0 PID: 5809 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:kvm_plane_ioctl_create_vcpu virt/kvm/kvm_main.c:4412 [inline]
RIP: 0010:__kvm_plane_ioctl+0x8bd/0xa70 virt/kvm/kvm_main.c:4908
Code: e8 c8 0a 09 00 4c 89 f7 e8 80 a3 ff ff 48 8b 3d a9 a8 fd 11 4c 89 f6 =
e8 c1 35 e7 00 49 63 c7 e9 8c fc ff ff e8 94 2f 87 00 90 <0f> 0b 90 41 bf f=
0 ff ff ff eb bc e8 e3 eb 68 0a 89 f9 80 e1 07 80
RSP: 0018:ffffc9000318f940 EFLAGS: 00010293
RAX: ffffffff813f480c RBX: ffff8881ba113410 RCX: ffff88810d4f4a80
RDX: 0000000000000000 RSI: ffffffff8e6fa0b0 RDI: 00000000fffffff0
RBP: ffffc9000318fa70 R08: ffff88810d4f4a80 R09: 0000000000000002
R10: 00000000fffffff0 R11: 0000000000000000 R12: 1ffff92000631f34
R13: dffffc0000000000 R14: ffff8881b446cb18 R15: 00000000fffffff0
FS:  00007f13e64ad6c0(0000) GS:ffff8882a929c000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f13e64acff8 CR3: 00000001a6053000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 kvm_vm_ioctl+0x88e/0xbf0 virt/kvm/kvm_main.c:5546
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f13e559ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f13e64ad028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f13e5816090 RCX: 00007f13e559ce59
RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000004
RBP: 00007f13e5632d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f13e5816128 R14: 00007f13e5816090 R15: 00007fff90c39748
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
[anelkz@amazon.de ashish.kalra@amd.com clopez@suse.de coconut-svsm@lists.li=
nux.dev huibo.wang@amd.com james.bottomley@hansenpartnership.com joerg.roed=
el@amd.com joro@8bytes.org kvm-riscv@lists.infradead.org kvm@vger.kernel.or=
g kvmarm@lists.linux.dev linux-kernel@vger.kernel.org linux-mips@vger.kerne=
l.org linuxppc-dev@lists.ozlabs.org loongarch@lists.linux.dev michael.roth@=
amd.com nsaenz@amazon.com pbonzini@redhat.com seanjc@google.com thomas.lend=
acky@amd.com x86@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

