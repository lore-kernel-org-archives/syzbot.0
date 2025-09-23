Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7031A13B797
	for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 10:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758621704; cv=none; b=sqq0+J1hdkgSdTv7QK+esPvrsH5nVu+wnB74v/YYcJK+nFTD+VzR96A9ToErKtGKL3iaY59L8f0wdx5TxqQTw+mnzkoASFlNO7LH9tXVkaAskn1glEdbyY56SfSJRRKjr89wDsEsFd+oLHstPQJNCnHpen7gddHR+s+VlQCwlx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758621704; c=relaxed/simple;
	bh=LGSmg5OdwakZuqXFArEIbvxh8+2cWOf91kVya/6Sa+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZAUbYJz01avq3Z2GEX3OdzD/3Hxrsgx+JlrK/RMelOdzjXKrZtPacEqcysHj4AelaDPOOBEZzGSrjAAYn+cd+1He0CXJIsPbhIjPP7z1UsB0ki4mcZqrIDBOiqLZ1CTmKIAPhp1WMlxVSX1ENGTZBqBmJ9qC0b7NGO6lB4uRIAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UeepuxKf; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UeepuxKf"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-344618b80d0so1358625fac.0
        for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 03:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758621701; x=1759226501; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zG8/4Is9tJtQq9XWiLAR36Ex5Rgf9HgIJhD7BKcB63Y=;
        b=UeepuxKfBOCy9unjLLVUKG5hu/BK+CJ6HgFexlhavHZnqDAfxQPBPme9Z77UAXMwc5
         CdZ/bWnt693nW0cinTpOj4B79Vrwt8n4ZB/5xEKkQQmY5IoRcrCNlSsHX3llVVbVAbcW
         2bcnxZ5s7ltrNiWZ3WfVQ24aMPFpO/3eHinUsOlD0ewIaknO1ppDH70fQ8HQMiXOF6m/
         I63045CsdBlmQTVhAMw4sA4UWn7EMEmrlHxYVOp3i4/jOLvwXA4KiNUbLN6jTQmHjMUV
         2drI6m/AXR4iuVXaQEp1vlEzU/YrVDRVdB3W9xFavPOgc+tAUrVWnnfQlwCB5yZNR9WN
         3tWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758621701; x=1759226501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zG8/4Is9tJtQq9XWiLAR36Ex5Rgf9HgIJhD7BKcB63Y=;
        b=HiAyGpUfzSDAKTr/Frlf1LWCQM3/kG+1Ha7fqf+q2/NZr672NyskYZeUVylGAXDcpM
         icCOLphOUNqPmaPqBKnpx9UV78xSRMNqJA4TnWwyEQFaJRcwLan5XH5KdXuATXUlgh0O
         q0XAV3o3lwlR+E/57Z3tR9DzlyuV/hqvQwwbov64I5WdlyLlCuIyMArUYzNPaE3L8IDD
         7eaK46YBQ9ENLibY68llFepfboZdIqanzNIP2n7aIFxuN2BZufy+COt1XKf2lvCrBAPJ
         1Y1qt4FG8zLH1JdEi7MGjDoFgYpZqGq//+P+j2QrKFKww+KwtVZebnRU3e0ia90wPt+i
         eEeg==
X-Forwarded-Encrypted: i=1; AJvYcCXODTpC4Y8oWD4/LzRwfba2fsDUM9infeqOLKQ4aWIXt8xbYDwtjqdVHDub0HPu5S4yKdkOdzY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxyu+U2fm4iJTMIy/GXEvwT9dd03e1E7qpjSuXZAIXuvRbAQo7V
	ePaQMKIsPV23uvjgxZreItv87VSlZCRUP+p+0zPz0K4RTSDb/m+/LQtn6lLyNvDkO1bYwob/Gse
	NyhLGaWB2ttuC30N4i3TZrxOwwkR65x8XRJcK4eyyXIRr1/vffUtqqhIi
X-Gm-Gg: ASbGncsSAx1lDoz1qC3+tP7SeRBQj0r9MyoTRQKbRc3nCahypStIw7YPo7KE+e6woFK
	5w2KJ99kXtKiyvXWr2za/ZeCvVbN3JfByTWxfOYg1R4M2QkJpOsbOP/tEPozYzd7Vk05Gs0JFw8
	PwWSaaX2rEQiG7FEUL1FKQ8nQW1MrWneTzqzZrOHSM4xsPbjR7R0owMovACD2mTCNF8wVQbenuL
	QtRQYKU1AdOoCMIj0BVOQ==
X-Google-Smtp-Source: AGHT+IEiRpD8dlCLQ0DSLkMPrKOYf0/GjKbx7u23JNi9JWthf6NjuAtfwKWSSlkkxE0Do+M99H0LsTUHrQDlgLOf8g4=
X-Received: by 2002:a05:6808:bc5:b0:43b:2829:e643 with SMTP id
 5614622812f47-43f2d42de0bmr921797b6e.25.1758621701142; Tue, 23 Sep 2025
 03:01:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68d2627a.a70a0220.1b52b.02a5.GAE@google.com>
In-Reply-To: <68d2627a.a70a0220.1b52b.02a5.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Sep 2025 12:01:30 +0200
X-Gm-Features: AS18NWCqtsFOB7qzqqpLNpH2OKP3aVVplSd5nD_fJDZldvWy0SEazP7XhVWf254
Message-ID: <CANp29Y6739ok8a49uoXFirVReg1DatcMpYPRBDsQ0msoR8HMhw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: AMD: Add Secure AVIC KVM Support
To: syzbot ci <syzbot+cid6c004f06ccdd5f2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Sep 23, 2025 at 11:03=E2=80=AFAM syzbot ci
<syzbot+cid6c004f06ccdd5f2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] AMD: Add Secure AVIC KVM Support
> https://lore.kernel.org/all/20250923050317.205482-1-Neeraj.Upadhyay@amd.c=
om
> * [RFC PATCH v2 01/17] KVM: x86/lapic: Differentiate protected APIC inter=
rupt mechanisms
> * [RFC PATCH v2 02/17] x86/cpufeatures: Add Secure AVIC CPU feature
> * [RFC PATCH v2 03/17] KVM: SVM: Add support for Secure AVIC capability i=
n KVM
> * [RFC PATCH v2 04/17] KVM: SVM: Set guest APIC protection flags for Secu=
re AVIC
> * [RFC PATCH v2 05/17] KVM: SVM: Do not intercept SECURE_AVIC_CONTROL MSR=
 for SAVIC guests
> * [RFC PATCH v2 06/17] KVM: SVM: Implement interrupt injection for Secure=
 AVIC
> * [RFC PATCH v2 07/17] KVM: SVM: Add IPI Delivery Support for Secure AVIC
> * [RFC PATCH v2 08/17] KVM: SVM: Do not inject exception for Secure AVIC
> * [RFC PATCH v2 09/17] KVM: SVM: Do not intercept exceptions for Secure A=
VIC guests
> * [RFC PATCH v2 10/17] KVM: SVM: Set VGIF in VMSA area for Secure AVIC gu=
ests
> * [RFC PATCH v2 11/17] KVM: SVM: Enable NMI support for Secure AVIC guest=
s
> * [RFC PATCH v2 12/17] KVM: SVM: Add VMGEXIT handler for Secure AVIC back=
ing page
> * [RFC PATCH v2 13/17] KVM: SVM: Add IOAPIC EOI support for Secure AVIC g=
uests
> * [RFC PATCH v2 14/17] KVM: x86/ioapic: Disable RTC EOI tracking for prot=
ected APIC guests
> * [RFC PATCH v2 15/17] KVM: SVM: Check injected timers for Secure AVIC gu=
ests
> * [RFC PATCH v2 16/17] KVM: x86/cpuid: Disable paravirt APIC features for=
 protected APIC
> * [RFC PATCH v2 17/17] KVM: SVM: Advertise Secure AVIC support for SNP gu=
ests
>
> and found the following issue:
> general protection fault in kvm_apply_cpuid_pv_features_quirk
>
> Full report is available here:
> https://ci.syzbot.org/series/887b895e-0315-498c-99e5-966704f16fb5
>
> ***
>
> general protection fault in kvm_apply_cpuid_pv_features_quirk
>
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/a65d3de7-36d8-4181-8566-80e0f0719=
955/config
> C repro:   https://ci.syzbot.org/findings/939a8c5a-41b2-4e9b-9129-80dff6d=
039c4/c_repro
> syz repro: https://ci.syzbot.org/findings/939a8c5a-41b2-4e9b-9129-80dff6d=
039c4/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000013: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000098-0x000000000000009f]
> CPU: 0 UID: 0 PID: 5992 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kvm_apply_cpuid_pv_features_quirk+0x38c/0x4f0 arch/x86/kvm/cpui=
d.c:248
> Code: c1 e8 03 80 3c 10 00 74 12 4c 89 ff e8 9d d8 d4 00 48 ba 00 00 00 0=
0 00 fc ff df bb 9c 00 00 00 49 03 1f 48 89 d8 48 c1 e8 03 <0f> b6 04 10 84=
 c0 0f 85 c2 00 00 00 80 3b 00 74 2e e8 4e 6a 71 00
> RSP: 0018:ffffc90004f871a0 EFLAGS: 00010203
> RAX: 0000000000000013 RBX: 000000000000009c RCX: ffff888107562440
> RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90004f87250 R08: 0000000000000005 R09: 000000008b838003
> R10: ffffc90004f872e0 R11: fffff520009f0e61 R12: ffff888034f30970
> R13: 1ffff110069e612e R14: ffff888020170528 R15: ffff888034f302f8
> FS:  000055556af3f500(0000) GS:ffff8880b861b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffff40f56c8 CR3: 0000000020cc0000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_vcpu_after_set_cpuid+0xc75/0x18a0 arch/x86/kvm/cpuid.c:432
>  kvm_set_cpuid+0xea4/0x1110 arch/x86/kvm/cpuid.c:551
>  kvm_vcpu_ioctl_set_cpuid2+0xbe/0x130 arch/x86/kvm/cpuid.c:626
>  kvm_arch_vcpu_ioctl+0x13c5/0x2a80 arch/x86/kvm/x86.c:5975
>  kvm_vcpu_ioctl+0x74d/0xe90 virt/kvm/kvm_main.c:4637
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:598 [inline]
>  __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:584
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f14f278e82b
> Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 4=
4 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0=
 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
> RSP: 002b:00007ffff40f55f0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007ffff40f5d40 RCX: 00007f14f278e82b
> RDX: 00007ffff40f5d40 RSI: 000000004008ae90 RDI: 0000000000000005
> RBP: 00002000008fc000 R08: 0000000000000000 R09: 0000000000000006
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000063 R14: 00002000008fb000 R15: 00002000008fc800
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:kvm_apply_cpuid_pv_features_quirk+0x38c/0x4f0 arch/x86/kvm/cpui=
d.c:248
> Code: c1 e8 03 80 3c 10 00 74 12 4c 89 ff e8 9d d8 d4 00 48 ba 00 00 00 0=
0 00 fc ff df bb 9c 00 00 00 49 03 1f 48 89 d8 48 c1 e8 03 <0f> b6 04 10 84=
 c0 0f 85 c2 00 00 00 80 3b 00 74 2e e8 4e 6a 71 00
> RSP: 0018:ffffc90004f871a0 EFLAGS: 00010203
> RAX: 0000000000000013 RBX: 000000000000009c RCX: ffff888107562440
> RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90004f87250 R08: 0000000000000005 R09: 000000008b838003
> R10: ffffc90004f872e0 R11: fffff520009f0e61 R12: ffff888034f30970
> R13: 1ffff110069e612e R14: ffff888020170528 R15: ffff888034f302f8
> FS:  000055556af3f500(0000) GS:ffff8881a3c1b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055df3be04900 CR3: 0000000020cc0000 CR4: 0000000000352ef0
> ----------------
> Code disassembly (best guess):
>    0:   c1 e8 03                shr    $0x3,%eax
>    3:   80 3c 10 00             cmpb   $0x0,(%rax,%rdx,1)
>    7:   74 12                   je     0x1b
>    9:   4c 89 ff                mov    %r15,%rdi
>    c:   e8 9d d8 d4 00          call   0xd4d8ae
>   11:   48 ba 00 00 00 00 00    movabs $0xdffffc0000000000,%rdx
>   18:   fc ff df
>   1b:   bb 9c 00 00 00          mov    $0x9c,%ebx
>   20:   49 03 1f                add    (%r15),%rbx
>   23:   48 89 d8                mov    %rbx,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   0f b6 04 10             movzbl (%rax,%rdx,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 c2 00 00 00       jne    0xf8
>   36:   80 3b 00                cmpb   $0x0,(%rbx)
>   39:   74 2e                   je     0x69
>   3b:   e8 4e 6a 71 00          call   0x716a8e
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
> [bp@alien8.de david.kaplan@amd.com huibo.wang@amd.com kvm@vger.kernel.org=
 linux-kernel@vger.kernel.org naveen.rao@amd.com neeraj.upadhyay@amd.com ni=
kunj@amd.com pbonzini@redhat.com santosh.shukla@amd.com seanjc@google.com s=
uravee.suthikulpanit@amd.com thomas.lendacky@amd.com tiala@microsoft.com va=
sant.hegde@amd.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68d2627a.a70a0220.1b52b.02a5.GAE%40google.com.
