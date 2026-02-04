Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A736438E5FB
	for <syzbot@lists.linux.dev>; Wed,  4 Feb 2026 07:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191026; cv=pass; b=stZdyhJrAD3tjfTw/6Y6nTTiM3xjSzUdcyq+USMCT0PiDZlZnSn3gPrdQnCVw38pVH0g5gxLpObaEn7mkJNf+/Jld9dDzlX8IdT79vOa4hG3Uk1/b90i6ubEXpD56ebdsFBzOK0lmxxiKWz/XzDDLEN4FxEceF8Lc4O1ejki9Sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191026; c=relaxed/simple;
	bh=3mCG8ZKOzMs62m4qzq6f97XEoZ712kcEwoV3GO3tFj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k/MM2TX5yg99aHpPZBqSrbVqDVxD7aEftRBU0mbnV40MfH0cCXQWOhvy/JDkyNX8LaEf5HN53Irm3i4N6dESq3Oq/c3L3h4EDs2H8T0eCtMmcTM5ucxFwN3V9T9/8qWY3/U/GjBV1sMxCdQGcIpiMbdYUu1mKot337Bhpmp6Sqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PjZo/uka; arc=pass smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PjZo/uka"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-45eabce608dso4624459b6e.2
        for <syzbot@lists.linux.dev>; Tue, 03 Feb 2026 23:43:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770191025; cv=none;
        d=google.com; s=arc-20240605;
        b=QISypbqiGYAkVLL3BLrhx5/5d12heMlS2n0aD7cqCpC1qmmckqypedDldyqaBakROP
         S64LZy0A327e1NsP+FE8CB/CTs7eZBzMzw/lzjKI9hZgXqWvPHAYer5XiFbc2c+88+Lg
         3HxqKrgurN+TEi3LFmHfhL9TLhQb1PSABGRo1YMufy24OsiWY+GgeWAy6QjO79uIiliW
         1pzeRxnHa8MpW2vNRMZ6US2oLeUpzO0IGNDtPhp7OOpMakIsNxnYUo847FOOZfQhPdhl
         jjV1l9QlXQhjdpyDUJAMSaAsSeQPA95XyyHIYv63X4KPdTmc92Jl6WBxzA6uEtQyzI4f
         jCjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cnuQrhFq+XEjDvV2fxNFaW85fpGFUzP9g9Of5hRrzCk=;
        fh=f1Y4FSbLmb3/xiCYuQREsEprqP7uypOrM9PIfQnx3iQ=;
        b=NowYz7Wbr13wv63F5tpLXoaauGBn1221yJduUzgeqI2Pl8ZSOLYCN/1xd01K5nf3rH
         x9lHEsHjKHLqIbtSRYweGmntY5RETSQiqOd6iy+oByTe/lR0CCpXVo5XLXhW6YFwAW+h
         UxY8AA3M+19xQ8PajrLWBR5yML3fPQ4LJpArhWkh3OnS0At048f4RTSyOWG9Ke6hmhrm
         11tcr7Lv9/PwTrIWXnm3mGF+CqmxGuEysNcI/msj2tSqgxLbS8XYEWw80ihMoTtqi4MV
         ib6NGoyeDvaU3fOaSXQEoSfcxzia1gzoSQXihkkfNh/UcTVBDA4hIG28NXRrM6UhyDRd
         7zMw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770191025; x=1770795825; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cnuQrhFq+XEjDvV2fxNFaW85fpGFUzP9g9Of5hRrzCk=;
        b=PjZo/uka+8kOSsRLJzo9UTmaCTi0YSB2gVvUXeYan+2QJ0sepGp7X+bY3SmGyaS1b0
         YVypSnAh/Q+vGrFBbflqyn9IKgoraZVgyzs8zSMqRgcpAaECFJh4gh0Jsf5MWcmBaXGF
         6ukcfyz2Zn7rytYdGordXFyIYWGbt7YlcBFyhLJRsxZmv8z8Fb+E68DulWJTt5ku9qFA
         m5c8wJ8m+vJTff43L6UcTV1MZisur1OfWbE6Tx8X/GAV0Pbzb3qPjPv0C/bih0q92TKx
         UAFDgwb5pybNFxd7XYXQHFtlbOuz2eWm/+37Ng3b/v8iBdIY6Zradlpr+L6eqhC07hrI
         0R0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770191025; x=1770795825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cnuQrhFq+XEjDvV2fxNFaW85fpGFUzP9g9Of5hRrzCk=;
        b=HFGzBK8hMxMk7mkj2bzxKmDpZum/roS7OwJF/N4RgrTHn7Igr14qO2hXCxaLb/M1Rh
         vmohYEUsIZk+rJD6P0b7LZlPfiv3Dtc10hYZiOMXoK7Keu/oIjfJVNAYCefRcE2e0WKk
         hyESb0lhFMTLqnXJKhcXQwgXBagFMC6hNL2d0wS/wJgM9AfzbAOdWm4bndV47k66EaPd
         Thu1i/5QFiG4fQK7rBi0kEEuUU2mwLIDsqTd7gQkEiyBdHC29uSAAnH57aC/GzKbpcfX
         B5NYigHRXDgC6N18j3lvCa4I+8w9JnpEZ2P4RKNpU2EIKdf+lygWYQIPcBxLNZqWXWYh
         mklw==
X-Forwarded-Encrypted: i=1; AJvYcCWmtD/0+NscaYcVjYUQOWH642W7G4l8dwqC74MbIPYu7U9Gz6uBk5t5/H3GeiLZ6O4/UHSnpyc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5J/7ha81zEJJksK9Y9/ytg1r717EHeNQbFo5sdmV8MsQqZW6u
	xENhAW2X6LxiT/haNqrEKafcGEshHEYFbs0MQcTntRS6kkHkJWOZPZ8ZXzd0Tx2Su0DXMMTEoRJ
	Ot/KJ3g1WF+J5i6/4zLDtYVnqTSHS9vVDuCduJDk6
X-Gm-Gg: AZuq6aIA+2wd7WeA6LaOfB7zC3l7ol1Rq7YEhxt1iUC7e6dtTM7rbUXqlDEqo3jqqZ7
	uOKSB+RtUBM5SE2epIy6dLONq1dwvBaKgbMshSDICKmVHadQdGg60XD8XbJ0SYNwq/Pyf5QpnvG
	zfkBtsYHWTtSQmP9gGLbL+LSBqQcekZLEJyoaa4VNQ3RaFTFK5DbYaDyEEHLmCvjpXgY6CBvZKk
	HcLiAnnlD5K+tHgNTMQFTlpN2vvUOTYBa6zXi30vQ2+csjNIFHmvaomlTRGMsvvF663jUzIeFjB
	/Ri9OJOVSOOIaTtt/REONV5CKNyx+Vm8rRlG0o9rR7YiY4ODClLtZf/K6kZk
X-Received: by 2002:a05:6808:4fd4:b0:45e:a75c:aa97 with SMTP id
 5614622812f47-462d58b58dbmr904343b6e.22.1770191025199; Tue, 03 Feb 2026
 23:43:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <698298b4.050a0220.3b3015.000f.GAE@google.com>
In-Reply-To: <698298b4.050a0220.3b3015.000f.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 4 Feb 2026 08:43:33 +0100
X-Gm-Features: AZwV_Qj-RC-yyDE3b25gfb9TLgLAsohWUjDN-3KA0oC4GvFe129uyBsuFejw8KI
Message-ID: <CANp29Y4peaAw3skKJUx75CZEJ28fbqoi8Znqq+LXTNNxq2LsqQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: VMX APIC timer virtualization support
To: syzbot ci <syzbot+ci9e8c0f7d30ab60c2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Feb 4, 2026 at 1:54=E2=80=AFAM syzbot ci
<syzbot+ci9e8c0f7d30ab60c2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] KVM: VMX APIC timer virtualization support
> https://lore.kernel.org/all/cover.1770116050.git.isaku.yamahata@intel.com
> * [PATCH 01/32] KVM: VMX: Detect APIC timer virtualization bit
> * [PATCH 02/32] KVM: x86: Implement APIC virt timer helpers with callback=
s
> * [PATCH 03/32] KVM: x86/lapic: Start/stop sw/hv timer on vCPU un/block
> * [PATCH 04/32] KVM: x86/lapic: Wire DEADLINE MSR update to guest virtual=
 TSC deadline
> * [PATCH 05/32] KVM: x86/lapic: Add a trace point for guest virtual timer
> * [PATCH 06/32] KVM: VMX: Implement the hooks for VMX guest virtual deadl=
ine timer
> * [PATCH 07/32] KVM: VMX: Update APIC timer virtualization on apicv chang=
ed
> * [PATCH 08/32] KVM: nVMX: Disallow/allow guest APIC timer virtualization=
 switch to/from L2
> * [PATCH 09/32] KVM: nVMX: Pass struct msr_data to VMX MSRs emulation
> * [PATCH 10/32] KVM: nVMX: Supports VMX tertiary controls and GUEST_APIC_=
TIMER bit
> * [PATCH 11/32] KVM: nVMX: Add tertiary VM-execution control VMCS support
> * [PATCH 12/32] KVM: nVMX: Update intercept on TSC deadline MSR
> * [PATCH 13/32] KVM: nVMX: Handle virtual timer vector VMCS field
> * [PATCH 14/32] KVM: VMX: Make vmx_calc_deadline_l1_to_host() non-static
> * [PATCH 15/32] KVM: nVMX: Enable guest deadline and its shadow VMCS fiel=
d
> * [PATCH 16/32] KVM: nVMX: Add VM entry checks related to APIC timer virt=
ualization
> * [PATCH 17/32] KVM: nVMX: Add check vmread/vmwrite on tertiary control
> * [PATCH 18/32] KVM: nVMX: Add check VMCS index for guest timer virtualiz=
ation
> * [PATCH 19/32] KVM: VMX: Advertise tertiary controls to the user space
> * [PATCH 20/32] KVM: VMX: dump_vmcs() support the guest virt timer
> * [PATCH 21/32] KVM: VMX: Enable APIC timer virtualization
> * [PATCH 22/32] KVM: VMX: Introduce module parameter for APIC virt timer =
support
> * [PATCH 23/32] KVM: nVMX: Introduce module parameter for nested APIC tim=
er virtualization
> * [PATCH 24/32] KVM: selftests: Add a test to measure local timer latency
> * [PATCH 25/32] KVM: selftests: Add nVMX support to timer_latency test ca=
se
> * [PATCH 26/32] KVM: selftests: Add test for nVMX MSR_IA32_VMX_PROCBASED_=
CTLS3
> * [PATCH 27/32] KVM: selftests: Add test vmx_set_nested_state_test with E=
VMCS disabled
> * [PATCH 28/32] KVM: selftests: Add tests nested state of APIC timer virt=
ualization
> * [PATCH 29/32] KVM: selftests: Add VMCS access test to APIC timer virtua=
lization
> * [PATCH 30/32] KVM: selftests: Test cases for L1 APIC timer virtualizati=
on
> * [PATCH 31/32] KVM: selftests: Add tests for nVMX to vmx_apic_timer_virt
> * [PATCH 32/32] Documentation: KVM: x86: Update documentation of struct v=
mcs12
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
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/2a120ac0-8f97-4828-b0ef-4e034e736=
2b8/config
> C repro:   https://ci.syzbot.org/findings/e56d47d6-212d-4ddf-a0e9-1bab4ec=
317ca/c_repro
> syz repro: https://ci.syzbot.org/findings/e56d47d6-212d-4ddf-a0e9-1bab4ec=
317ca/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000010: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
> CPU: 0 UID: 0 PID: 5989 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kvm_sync_apic_virt_timer+0x82/0x120 arch/x86/kvm/lapic.c:1871
> Code: 00 00 41 8b 2f 89 ee 83 e6 01 31 ff e8 37 68 74 00 40 f6 c5 01 75 6=
4 e8 ec 63 74 00 4c 8d bb 81 00 00 00 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 75 71 41 80 3f 00 74 2f e8 ca 63 74 00 4c 89
> RSP: 0018:ffffc90003f96f90 EFLAGS: 00010202
> RAX: 0000000000000010 RBX: 0000000000000000 RCX: ffff88817447c980
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff88810435003f R09: 1ffff1102086a007
> R10: dffffc0000000000 R11: ffffed102086a008 R12: dffffc0000000000
> R13: dffffc0000000000 R14: ffff888104350000 R15: 0000000000000081
> FS:  0000555587f08500(0000) GS:ffff88818e328000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000175a26000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  nested_vmx_enter_non_root_mode+0x897/0xaa10 arch/x86/kvm/vmx/nested.c:37=
51
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
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
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
> Code: 00 00 41 8b 2f 89 ee 83 e6 01 31 ff e8 37 68 74 00 40 f6 c5 01 75 6=
4 e8 ec 63 74 00 4c 8d bb 81 00 00 00 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 75 71 41 80 3f 00 74 2f e8 ca 63 74 00 4c 89
> RSP: 0018:ffffc90003f96f90 EFLAGS: 00010202
> RAX: 0000000000000010 RBX: 0000000000000000 RCX: ffff88817447c980
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff88810435003f R09: 1ffff1102086a007
> R10: dffffc0000000000 R11: ffffed102086a008 R12: dffffc0000000000
> R13: dffffc0000000000 R14: ffff888104350000 R15: 0000000000000081
> FS:  0000555587f08500(0000) GS:ffff88818e328000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000175a26000 CR4: 0000000000352ef0
> ----------------
> Code disassembly (best guess):
>    0:   00 00                   add    %al,(%rax)
>    2:   41 8b 2f                mov    (%r15),%ebp
>    5:   89 ee                   mov    %ebp,%esi
>    7:   83 e6 01                and    $0x1,%esi
>    a:   31 ff                   xor    %edi,%edi
>    c:   e8 37 68 74 00          call   0x746848
>   11:   40 f6 c5 01             test   $0x1,%bpl
>   15:   75 64                   jne    0x7b
>   17:   e8 ec 63 74 00          call   0x746408
>   1c:   4c 8d bb 81 00 00 00    lea    0x81(%rbx),%r15
>   23:   4c 89 f8                mov    %r15,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 0f b6 04 20          movzbl (%rax,%r12,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   75 71                   jne    0xa4
>   33:   41 80 3f 00             cmpb   $0x0,(%r15)
>   37:   74 2f                   je     0x68
>   39:   e8 ca 63 74 00          call   0x746408
>   3e:   4c                      rex.WR
>   3f:   89                      .byte 0x89
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
> The email will later be sent to:
> [isaku.yamahata@gmail.com isaku.yamahata@intel.com kvm@vger.kernel.org li=
nux-kernel@vger.kernel.org oliver.sang@intel.com pbonzini@redhat.com seanjc=
@google.com yang.zhong@linux.intel.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/698298b4.050a0220.3b3015.000f.GAE%40google.com.
