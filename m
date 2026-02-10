Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEC32652B0
	for <syzbot@lists.linux.dev>; Tue, 10 Feb 2026 00:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770685186; cv=none; b=mncWmhZ867x2qWialPC/pVMMJg6UCnWpi8BHOazFFaVIOdRwdKLUTKGOQ2NhAQblopIXm0MQWMwOgSDiX6ZfJ6DzJa4dX+YVFUdE4Pfuw0rPHf+yI2ZDkVXHw4Skj6IfGHEhfqvxXRbnfhes8SZCrbZvHRpr4VH298EX0jEn140=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770685186; c=relaxed/simple;
	bh=FXVK2sc58kPmlkJdDqZHgno5SMenpAg8VschYPNdzoc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=KssAlVpK7PcQjFGtW5m27jq6ws14o6cTexp4SBliDKu3nTVVPvpmRiFX390VxKbv+qHrKKwDBqnp1qksIRGobZKtCZzuNET6Bz6GmkpUM7nCcZoh2jDXBgrTtmU3bIMMATtvT2fsgc3HZFU4QWEC/ZxxFPx6UCJrnmPKMwJHObE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6630d58662aso1856508eaf.0
        for <syzbot@lists.linux.dev>; Mon, 09 Feb 2026 16:59:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770685184; x=1771289984;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dRcnEG0YKr6Z/6lsoZpFGk/XtcWB1aASZHR4ECk4hPs=;
        b=PLHUyRySAsaVIC2kBYA96VZvfT+Ym0Wyr81K2bdhNg9ojfalgYcVqbPbRC9x0tlW/t
         7OF9wguAYEsIjLI2oh1s/4qCsxvBhAJicHpVeujb2g3lZeQt5wQmxUrrAv23FFGelfdi
         ZWbiKJPvSXeimE6BMH6YpcI7oNhL6Lg0JDlKJEmLB3A/yOjgC0XuO37J2Li31s8P46ru
         Qx1qlABPfLDVyAI1LLe5FmejxQ4q4e031zopFbmrRoV+oU6GupqybsTjP6HIKFwsKNxj
         N9HL8DAlHt3jiU+Kd8/ga0gzP8dVz7sYJPrSMLvj/kJLbe4bch5y6QpHAu/9O6aCrfeb
         s0dQ==
X-Gm-Message-State: AOJu0YyI4b41fLRLV6tWj8oDaK2mxsTsuIGEnGP1g2Fe3XIEnGI0qoZW
	bOBwt5alVQsQKlOqQdaXx9j/yAj39mbHG1NtZ+wwcGnla3Jxyxiyj9nJClGvZqXzgYdComeS4ax
	Sh0JB9rxx0wRvLFm65NtRJmo1DrDGbH7bnI5BFDBrKBFaqgIFrWXEWUFaOLc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1896:b0:662:b892:40c1 with SMTP id
 006d021491bc7-66d0bcb980bmr5261489eaf.52.1770685184139; Mon, 09 Feb 2026
 16:59:44 -0800 (PST)
Date: Mon, 09 Feb 2026 16:59:44 -0800
In-Reply-To: <aYqC_Aj2Ee4UiSZX@iyamahat-desk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698a8300.050a0220.1ad825.0031.GAE@google.com>
Subject: Forwarded: Re: [syzbot ci] Re: KVM: VMX APIC timer virtualization support
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com>, 
	isaku.yamahata@intel.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: Re: [syzbot ci] Re: KVM: VMX APIC timer virtualization support
Author: isaku.yamahata@intel.com

#syz test: git://github.com/yamahata/linux.git apic_timer-virt-6.19-rc7-fix-1

On Tue, Feb 03, 2026 at 11:46:26PM -0800,
syzbot ci <syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com> wrote:

> syzbot ci has tested the following series
> 
> [v1] KVM: VMX APIC timer virtualization support
> https://lore.kernel.org/all/cover.1770116050.git.isaku.yamahata@intel.com
> * [PATCH 01/32] KVM: VMX: Detect APIC timer virtualization bit
> * [PATCH 02/32] KVM: x86: Implement APIC virt timer helpers with callbacks
> * [PATCH 03/32] KVM: x86/lapic: Start/stop sw/hv timer on vCPU un/block
> * [PATCH 04/32] KVM: x86/lapic: Wire DEADLINE MSR update to guest virtual TSC deadline
> * [PATCH 05/32] KVM: x86/lapic: Add a trace point for guest virtual timer
> * [PATCH 06/32] KVM: VMX: Implement the hooks for VMX guest virtual deadline timer
> * [PATCH 07/32] KVM: VMX: Update APIC timer virtualization on apicv changed
> * [PATCH 08/32] KVM: nVMX: Disallow/allow guest APIC timer virtualization switch to/from L2
> * [PATCH 09/32] KVM: nVMX: Pass struct msr_data to VMX MSRs emulation
> * [PATCH 10/32] KVM: nVMX: Supports VMX tertiary controls and GUEST_APIC_TIMER bit
> * [PATCH 11/32] KVM: nVMX: Add tertiary VM-execution control VMCS support
> * [PATCH 12/32] KVM: nVMX: Update intercept on TSC deadline MSR
> * [PATCH 13/32] KVM: nVMX: Handle virtual timer vector VMCS field
> * [PATCH 14/32] KVM: VMX: Make vmx_calc_deadline_l1_to_host() non-static
> * [PATCH 15/32] KVM: nVMX: Enable guest deadline and its shadow VMCS field
> * [PATCH 16/32] KVM: nVMX: Add VM entry checks related to APIC timer virtualization
> * [PATCH 17/32] KVM: nVMX: Add check vmread/vmwrite on tertiary control
> * [PATCH 18/32] KVM: nVMX: Add check VMCS index for guest timer virtualization
> * [PATCH 19/32] KVM: VMX: Advertise tertiary controls to the user space
> * [PATCH 20/32] KVM: VMX: dump_vmcs() support the guest virt timer
> * [PATCH 21/32] KVM: VMX: Enable APIC timer virtualization
> * [PATCH 22/32] KVM: VMX: Introduce module parameter for APIC virt timer support
> * [PATCH 23/32] KVM: nVMX: Introduce module parameter for nested APIC timer virtualization
> * [PATCH 24/32] KVM: selftests: Add a test to measure local timer latency
> * [PATCH 25/32] KVM: selftests: Add nVMX support to timer_latency test case
> * [PATCH 26/32] KVM: selftests: Add test for nVMX MSR_IA32_VMX_PROCBASED_CTLS3
> * [PATCH 27/32] KVM: selftests: Add test vmx_set_nested_state_test with EVMCS disabled
> * [PATCH 28/32] KVM: selftests: Add tests nested state of APIC timer virtualization
> * [PATCH 29/32] KVM: selftests: Add VMCS access test to APIC timer virtualization
> * [PATCH 30/32] KVM: selftests: Test cases for L1 APIC timer virtualization
> * [PATCH 31/32] KVM: selftests: Add tests for nVMX to vmx_apic_timer_virt
> * [PATCH 32/32] Documentation: KVM: x86: Update documentation of struct vmcs12
> 
> and found the following issue:
> general protection fault in kvm_sync_apic_virt_timer
> 
> Full report is available here:
> https://ci.syzbot.org/series/febd2a47-f17d-45ba-954d-44cd44564c81
> 
> ***
> 
> general protection fault in kvm_sync_apic_virt_timer
> 
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/2a120ac0-8f97-4828-b0ef-4e034e7362b8/config
> C repro:   https://ci.syzbot.org/findings/e56d47d6-212d-4ddf-a0e9-1bab4ec317ca/c_repro
> syz repro: https://ci.syzbot.org/findings/e56d47d6-212d-4ddf-a0e9-1bab4ec317ca/syz_repro
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000010: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
> CPU: 0 UID: 0 PID: 5989 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:kvm_sync_apic_virt_timer+0x82/0x120 arch/x86/kvm/lapic.c:1871
> Code: 00 00 41 8b 2f 89 ee 83 e6 01 31 ff e8 37 68 74 00 40 f6 c5 01 75 64 e8 ec 63 74 00 4c 8d bb 81 00 00 00 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 75 71 41 80 3f 00 74 2f e8 ca 63 74 00 4c 89
> RSP: 0018:ffffc90003f96f90 EFLAGS: 00010202
> RAX: 0000000000000010 RBX: 0000000000000000 RCX: ffff88817447c980
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff88810435003f R09: 1ffff1102086a007
> R10: dffffc0000000000 R11: ffffed102086a008 R12: dffffc0000000000
> R13: dffffc0000000000 R14: ffff888104350000 R15: 0000000000000081
> FS:  0000555587f08500(0000) GS:ffff88818e328000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000175a26000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  nested_vmx_enter_non_root_mode+0x897/0xaa10 arch/x86/kvm/vmx/nested.c:3751
>  nested_vmx_run+0x5fb/0xc30 arch/x86/kvm/vmx/nested.c:3951
>  __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6792 [inline]
>  vmx_handle_exit+0xf22/0x1670 arch/x86/kvm/vmx/vmx.c:6802
>  vcpu_enter_guest arch/x86/kvm/x86.c:11491 [inline]
>  vcpu_run+0x5581/0x76e0 arch/x86/kvm/x86.c:11652
>  kvm_arch_vcpu_ioctl_run+0x1010/0x1dc0 arch/x86/kvm/x86.c:11997
>  kvm_vcpu_ioctl+0xa62/0xfd0 virt/kvm/kvm_main.c:4492
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f94ddb9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe0d9bd148 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f94dde15fa0 RCX: 00007f94ddb9acb9
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 00007f94ddc08bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f94dde15fac R14: 00007f94dde15fa0 R15: 00007f94dde15fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:kvm_sync_apic_virt_timer+0x82/0x120 arch/x86/kvm/lapic.c:1871
> Code: 00 00 41 8b 2f 89 ee 83 e6 01 31 ff e8 37 68 74 00 40 f6 c5 01 75 64 e8 ec 63 74 00 4c 8d bb 81 00 00 00 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 84 c0 75 71 41 80 3f 00 74 2f e8 ca 63 74 00 4c 89
> RSP: 0018:ffffc90003f96f90 EFLAGS: 00010202
> RAX: 0000000000000010 RBX: 0000000000000000 RCX: ffff88817447c980
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff88810435003f R09: 1ffff1102086a007
> R10: dffffc0000000000 R11: ffffed102086a008 R12: dffffc0000000000
> R13: dffffc0000000000 R14: ffff888104350000 R15: 0000000000000081
> FS:  0000555587f08500(0000) GS:ffff88818e328000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000175a26000 CR4: 0000000000352ef0
> ----------------
> Code disassembly (best guess):
>    0:	00 00                	add    %al,(%rax)
>    2:	41 8b 2f             	mov    (%r15),%ebp
>    5:	89 ee                	mov    %ebp,%esi
>    7:	83 e6 01             	and    $0x1,%esi
>    a:	31 ff                	xor    %edi,%edi
>    c:	e8 37 68 74 00       	call   0x746848
>   11:	40 f6 c5 01          	test   $0x1,%bpl
>   15:	75 64                	jne    0x7b
>   17:	e8 ec 63 74 00       	call   0x746408
>   1c:	4c 8d bb 81 00 00 00 	lea    0x81(%rbx),%r15
>   23:	4c 89 f8             	mov    %r15,%rax
>   26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
>   2f:	84 c0                	test   %al,%al
>   31:	75 71                	jne    0xa4
>   33:	41 80 3f 00          	cmpb   $0x0,(%r15)
>   37:	74 2f                	je     0x68
>   39:	e8 ca 63 74 00       	call   0x746408
>   3e:	4c                   	rex.WR
>   3f:	89                   	.byte 0x89
> 
> 
> ***
> 
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
> 
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
> 

-- 
Isaku Yamahata <isaku.yamahata@intel.com>
