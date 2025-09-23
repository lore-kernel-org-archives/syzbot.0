Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32A122097
	for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 09:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758618237; cv=none; b=mryYU6AjzEQXPkyKCoVL5yOXQQRsOwoZOgvtnRxTR/bLooY/CK8SEKqASKdspaWSvuQYnRM25gXafIgqZeOkJ9LhniXJRZCHNfENwntN7r+7+PECODYMbwEbh+8NLzDMcfLAs0A4isgQe/fwteW3eS2J0cffu/CTMNJFTm6HXWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758618237; c=relaxed/simple;
	bh=N1nCjwqHYxvpgeyGrHH32+YieTE9OD+kiMv4JO83+B4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=rQPhAVnE6j1Nj8WfvkREMhBMMPeWxmBeKFaGy0GdVVOmLzXxHWML6poP3Hos2Z/CTbVjSXgeXx9E9tcTYSVDMwpf5BSI1PaDY2JImYJc50lBAqiLSJ2tdPSBxrKpCUAMlGXhgTVw3M758Vf8BMxIwkaDqQkSdAhfTZdIUGIYbq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-425753ebc0aso30086915ab.0
        for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 02:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758618235; x=1759223035;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IibcgMJijWGxyY5w1F/S7tyjoKkC6U+OXFqpcBbJCug=;
        b=fMw52S9APQFSIrRVD6+N488eNJQaraafC2pEMzjUILDaL8TlKBc+lVQzjDImkFWrW6
         L/nm39eVFxS/YvgLcNYf5+PPwEcGalO4TNwm30OlEcwUs+wt07KCdwAoHQ6fYct+Mzp7
         UXraXhTiocIU9AFPsoC4y+3fKnnOkMPcxW5R8pT1JFVfIYq1j0++3QVMtmCvHB2hmcFZ
         aQfV3q6ZMmvTrtyf1xI4cEEstWBq6z1T9xakVY5ZeD+xVinJb/qJ34Mf0lA6qkeTLCzQ
         46mjPc2fbnUNj0YtgCtNI4BXuESHz7TyfTDs/wxs3VYwS7tsxnOKKztVpHeV/78E0Njc
         /eiw==
X-Gm-Message-State: AOJu0YxfFyVkFD/a6SvMymNnyisEfVZDzx9wkQAq0kWr7LIQYft2e24q
	HV8pGvxY/x8QYXGPm6pcne37JhHzfMiSYEsQSPpz/ZNOZLICffP9E4WvH103PyMMtKPT5IHI7IL
	ZIRgIjm+BWAG+7xHb3/5ohkCiqLELxcJyYT0gSeDwCMIwPRz99WZ1q7+8Tkg=
X-Google-Smtp-Source: AGHT+IEUEhM32x5rDI0wHKgzJXOROOiXMN9CLYrxYBbOI/PXHU7ZMnOYREw+hjL462JwRzs9I/GxfSIFMGO8f8Ve2Wm/4+ZJD9jL
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c24:b0:424:6c8e:617f with SMTP id
 e9e14a558f8ab-42581e1ee1bmr25650985ab.8.1758618234848; Tue, 23 Sep 2025
 02:03:54 -0700 (PDT)
Date: Tue, 23 Sep 2025 02:03:54 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d2627a.a70a0220.1b52b.02a5.GAE@google.com>
Subject: [moderation/CI] Re: AMD: Add Secure AVIC KVM Support
From: syzbot ci <syzbot+cid6c004f06ccdd5f2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] AMD: Add Secure AVIC KVM Support
https://lore.kernel.org/all/20250923050317.205482-1-Neeraj.Upadhyay@amd.com
* [RFC PATCH v2 01/17] KVM: x86/lapic: Differentiate protected APIC interru=
pt mechanisms
* [RFC PATCH v2 02/17] x86/cpufeatures: Add Secure AVIC CPU feature
* [RFC PATCH v2 03/17] KVM: SVM: Add support for Secure AVIC capability in =
KVM
* [RFC PATCH v2 04/17] KVM: SVM: Set guest APIC protection flags for Secure=
 AVIC
* [RFC PATCH v2 05/17] KVM: SVM: Do not intercept SECURE_AVIC_CONTROL MSR f=
or SAVIC guests
* [RFC PATCH v2 06/17] KVM: SVM: Implement interrupt injection for Secure A=
VIC
* [RFC PATCH v2 07/17] KVM: SVM: Add IPI Delivery Support for Secure AVIC
* [RFC PATCH v2 08/17] KVM: SVM: Do not inject exception for Secure AVIC
* [RFC PATCH v2 09/17] KVM: SVM: Do not intercept exceptions for Secure AVI=
C guests
* [RFC PATCH v2 10/17] KVM: SVM: Set VGIF in VMSA area for Secure AVIC gues=
ts
* [RFC PATCH v2 11/17] KVM: SVM: Enable NMI support for Secure AVIC guests
* [RFC PATCH v2 12/17] KVM: SVM: Add VMGEXIT handler for Secure AVIC backin=
g page
* [RFC PATCH v2 13/17] KVM: SVM: Add IOAPIC EOI support for Secure AVIC gue=
sts
* [RFC PATCH v2 14/17] KVM: x86/ioapic: Disable RTC EOI tracking for protec=
ted APIC guests
* [RFC PATCH v2 15/17] KVM: SVM: Check injected timers for Secure AVIC gues=
ts
* [RFC PATCH v2 16/17] KVM: x86/cpuid: Disable paravirt APIC features for p=
rotected APIC
* [RFC PATCH v2 17/17] KVM: SVM: Advertise Secure AVIC support for SNP gues=
ts

and found the following issue:
general protection fault in kvm_apply_cpuid_pv_features_quirk

Full report is available here:
https://ci.syzbot.org/series/887b895e-0315-498c-99e5-966704f16fb5

***

general protection fault in kvm_apply_cpuid_pv_features_quirk

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/a65d3de7-36d8-4181-8566-80e0f071995=
5/config
C repro:   https://ci.syzbot.org/findings/939a8c5a-41b2-4e9b-9129-80dff6d03=
9c4/c_repro
syz repro: https://ci.syzbot.org/findings/939a8c5a-41b2-4e9b-9129-80dff6d03=
9c4/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000013: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000098-0x000000000000009f]
CPU: 0 UID: 0 PID: 5992 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:kvm_apply_cpuid_pv_features_quirk+0x38c/0x4f0 arch/x86/kvm/cpuid.=
c:248
Code: c1 e8 03 80 3c 10 00 74 12 4c 89 ff e8 9d d8 d4 00 48 ba 00 00 00 00 =
00 fc ff df bb 9c 00 00 00 49 03 1f 48 89 d8 48 c1 e8 03 <0f> b6 04 10 84 c=
0 0f 85 c2 00 00 00 80 3b 00 74 2e e8 4e 6a 71 00
RSP: 0018:ffffc90004f871a0 EFLAGS: 00010203
RAX: 0000000000000013 RBX: 000000000000009c RCX: ffff888107562440
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90004f87250 R08: 0000000000000005 R09: 000000008b838003
R10: ffffc90004f872e0 R11: fffff520009f0e61 R12: ffff888034f30970
R13: 1ffff110069e612e R14: ffff888020170528 R15: ffff888034f302f8
FS:  000055556af3f500(0000) GS:ffff8880b861b000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffff40f56c8 CR3: 0000000020cc0000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 kvm_vcpu_after_set_cpuid+0xc75/0x18a0 arch/x86/kvm/cpuid.c:432
 kvm_set_cpuid+0xea4/0x1110 arch/x86/kvm/cpuid.c:551
 kvm_vcpu_ioctl_set_cpuid2+0xbe/0x130 arch/x86/kvm/cpuid.c:626
 kvm_arch_vcpu_ioctl+0x13c5/0x2a80 arch/x86/kvm/x86.c:5975
 kvm_vcpu_ioctl+0x74d/0xe90 virt/kvm/kvm_main.c:4637
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f14f278e82b
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 =
24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 f=
f ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffff40f55f0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffff40f5d40 RCX: 00007f14f278e82b
RDX: 00007ffff40f5d40 RSI: 000000004008ae90 RDI: 0000000000000005
RBP: 00002000008fc000 R08: 0000000000000000 R09: 0000000000000006
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000063 R14: 00002000008fb000 R15: 00002000008fc800
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:kvm_apply_cpuid_pv_features_quirk+0x38c/0x4f0 arch/x86/kvm/cpuid.=
c:248
Code: c1 e8 03 80 3c 10 00 74 12 4c 89 ff e8 9d d8 d4 00 48 ba 00 00 00 00 =
00 fc ff df bb 9c 00 00 00 49 03 1f 48 89 d8 48 c1 e8 03 <0f> b6 04 10 84 c=
0 0f 85 c2 00 00 00 80 3b 00 74 2e e8 4e 6a 71 00
RSP: 0018:ffffc90004f871a0 EFLAGS: 00010203
RAX: 0000000000000013 RBX: 000000000000009c RCX: ffff888107562440
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90004f87250 R08: 0000000000000005 R09: 000000008b838003
R10: ffffc90004f872e0 R11: fffff520009f0e61 R12: ffff888034f30970
R13: 1ffff110069e612e R14: ffff888020170528 R15: ffff888034f302f8
FS:  000055556af3f500(0000) GS:ffff8881a3c1b000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055df3be04900 CR3: 0000000020cc0000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	c1 e8 03             	shr    $0x3,%eax
   3:	80 3c 10 00          	cmpb   $0x0,(%rax,%rdx,1)
   7:	74 12                	je     0x1b
   9:	4c 89 ff             	mov    %r15,%rdi
   c:	e8 9d d8 d4 00       	call   0xd4d8ae
  11:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  18:	fc ff df
  1b:	bb 9c 00 00 00       	mov    $0x9c,%ebx
  20:	49 03 1f             	add    (%r15),%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax <-- trapping instruct=
ion
  2e:	84 c0                	test   %al,%al
  30:	0f 85 c2 00 00 00    	jne    0xf8
  36:	80 3b 00             	cmpb   $0x0,(%rbx)
  39:	74 2e                	je     0x69
  3b:	e8 4e 6a 71 00       	call   0x716a8e


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[bp@alien8.de david.kaplan@amd.com huibo.wang@amd.com kvm@vger.kernel.org l=
inux-kernel@vger.kernel.org naveen.rao@amd.com neeraj.upadhyay@amd.com niku=
nj@amd.com pbonzini@redhat.com santosh.shukla@amd.com seanjc@google.com sur=
avee.suthikulpanit@amd.com thomas.lendacky@amd.com tiala@microsoft.com vasa=
nt.hegde@amd.com]

If the report looks fine to you, reply with:
#syz upstream

