Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55BE304BDF
	for <syzbot@lists.linux.dev>; Tue,  7 Jul 2026 06:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405920; cv=pass; b=tU+LJlSI6lFMl8IwAo0hXhzS6Nr5uox9i58Q3KuBxptoC1r3DUGwjSQqG5hwB6s00kTRPiPGPnUnoEPoZqGnKoY2B7CE4hVAbLE8P/qXV4fy0aO6xEcClLORuOS/a/20fgX0aQiMSL/1XBDf5m6DZHIfQK6wwA1Jm1ruPrYB1l0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405920; c=relaxed/simple;
	bh=Ok4DdDyrt4npNmgTE0dHGfWr55cH0vj7G/PM4TsjadE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BdgIbNkjpq5DPa5FuhQST68c+EoABuou8/v5v72Mb0Pk7qappmF7cttvQ69iIh9vCOCelYFCw+fvc0qgg1L/PSknOtVMbC+xl4LzsOmhDhSP7+Zhq3gg8cx1RE5CRrBB1yB31vkQgXlzfHZHNbq8foDX46uVoLs2S6bfM+dpdeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VJhBfq5T; arc=pass smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VJhBfq5T"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6a145935764so1261730eaf.3
        for <syzbot@lists.linux.dev>; Mon, 06 Jul 2026 23:31:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783405918; cv=none;
        d=google.com; s=arc-20260327;
        b=M54Y18JqBPEAtuGRhEhrg/enQVWN6CYdc8+9TH1KKNfazK4L+uzAaVb/jhuTNfyYSH
         ud2ZXuYb7zot3enQtfNzdb/NvA96CnLQ3//h1DPIwol8ymbiGC3K0iiFn83LVciIKHa4
         zpwP+TEgJ+Z+2sVp7R897R4LXGGL+AZTKQlR9Q8DF3B8nKeih3g37V4EcptznYWV1RW2
         wAlQu0n+XpgVJsPFd5nr33ZeJMrh332noHSHdDlMK1XTUC8PmZaHlpvTblAKjIaEPF2R
         wxUCsSC0ZScWFCIluSNXpjZd8lKK3ilPUJGgmpjpqVNZV+/Dh0pd6XM3Ib9iR7FJBF7f
         Df9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KZLNNBCYC4veWuGDWEG+oLUHObcLHP8mifytwtPywtQ=;
        fh=9YPMEHZSRStxYAp1x+R9+8l8YSML6qvqzOX/iUCflp8=;
        b=HKJDlaEIlKaZVLTYun638+0oOCtKmVylGwqNuRdqecf2A+Z9t7c0/4schtbOuNAq0K
         PKNTy0ikqR9KHfOCp3CVgDGYviW0cSwSrDVkrQyJyuGG8SiVuDUK7f1upLmK0b3u5xwq
         Rdp/ZJYa9fUpyt/TFRHOKYxMOebAr/AJSpuzCdyo4EOi9r3qgs8LWCbzCoHxHMcrK8c9
         A5NaJJLqYb3wUmsHmiTwgNg0K0TP4AAYDWCV4IEO0qpZkLvTuEjAOiSHwDVS6uRrHlYC
         T3Vj1Zh1B2jVLHsK8lrLyWuN2Fhr79CnQ+0x6/wWeaG1mTNkOwfpVoVv3Ub9RG/F1yNF
         ssFQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783405918; x=1784010718; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZLNNBCYC4veWuGDWEG+oLUHObcLHP8mifytwtPywtQ=;
        b=VJhBfq5TIQZXMFkD/zI2RUgV6qDsVR5DuTPVdz51PRL143EPe1XgzTayap4GkCTUAz
         UPE4e8SR+tA8S4TgPA9OyWbQocAz9dcN9bzEseYB9TIslLS1PzyQjKWoHPVInpw2yPUy
         Ib/mOYoKzIMDIxwX8Sn5Rg2D58g6+2X4tiOYDY8CiEZ/AESyQp+4vo3qoMolE39vih10
         jF2ysnAQ4IZlDxB2iqHjtJ4UcY2wkTswCeUaI23tA1qb2JMAc6l6GTTmvdB+jVaRemus
         PKIUS/PwYfw0eFy72jeU2NGSxCilpY+p6eprUW1l/SzHHC1VSS6wSlb7RwlOu+FdTHE3
         AhAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783405918; x=1784010718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KZLNNBCYC4veWuGDWEG+oLUHObcLHP8mifytwtPywtQ=;
        b=rxDCiJLelFr7NLzv6rcRoproq1tGv61qDeilj7TtUied+Y1E8M01R0N9cXMZWTzz9m
         Vq4m48RLXy+6VVSPFqbIjgLQybusqTx5H11/wrOwssgRciWKfu9SiTEMgvmqpOFGZ94m
         dr40rlFPHeP+oTDDIMmzpCU6xVELa3ggu6sclM1zyk1dLmWewE99gPaI1FW8K9r21kZg
         FKZN2W418FQxxBlwgAHmF4POifV/OKVs16yUmMdSZiZ5bcEjL3WDmKIqDSK4JLt/QZyc
         0gt3Tf4cPugxUV/WLVnN97M9ERDJF68Xxd9TcyhquFJY79A7OS4I1kEGMpX1kYMi4XP0
         zCrQ==
X-Forwarded-Encrypted: i=1; AFNElJ+eRpsAg8GKuhgKMx6sr4nqKfNuzdhJIy31OeDUcp982c8CJWasHwyxAH0+cycElyHCn0HlFpk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8TisfBdoqHidfKorJ/tfUVP2L/u45J/UlJDQVCRzTHWaIUhyn
	O474DFlOMVaDHvvtI3eLbzyUncTv8qfljDBaBJjVDqJHxiYfNmojWaPO4LGa2fQW312FTmadEKi
	/yCNBB3caLEpv6ztSu2YI8+G4taaSgIj4RrXomiN1
X-Gm-Gg: AfdE7clQCTeE3GkY1QpVRbgc0WrD9I3ZDRMcLBOqpR2clN/rK1Bgq+1i+AZmEHkQIbL
	xqJAmPEAA1ELabXYNfRCX8CUsA9cUhg1tbBKpbbGukpc24CwYwoq5MqdrN13VAsvfKgBdYCDqr/
	MF0IqHIllkLhgxrcg2XzXcC5xtXIx+Jzcwnkhjvtm9ITDQrWA6IYuLcXR7D4KFaNMJh+fUanCZu
	iF3Xj63fFMle6GoGKtGUWNP1ESbqMawp3THvieajOgqOP0AhOGxXNqxXDqnHLFxw2vG11yS+bCg
	dWW3aaBsddRlQceDVHVRu+sVbC4OAr/+lqh5lwEkFNw3C66nWI2ul6mksybqsfJuGi7RvaHpaD/
	e87ZuhFaC8pXa7pKCDy40V9Nbchirl+e7KXKmTFmuVQ==
X-Received: by 2002:a05:6820:160f:b0:6a3:1b9a:48db with SMTP id
 006d021491bc7-6a3556e518cmr2775975eaf.52.1783405917170; Mon, 06 Jul 2026
 23:31:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a4c97f4.57639fcc.86d58.0009.GAE@google.com>
In-Reply-To: <6a4c97f4.57639fcc.86d58.0009.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 7 Jul 2026 08:31:45 +0200
X-Gm-Features: AVVi8CcgauhulYTKKXFcYvMH8K9tRPFeM_M2UPcHxQVHeHV0Yvt5xVxm5HGnBMw
Message-ID: <CANp29Y6D59OMu4j-JbhuZLNj7DnQL37hjfvL9CerYV7UMwKhFA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: x86: Destroy the PIC and IOAPIC before
 destroying vCPUs
To: syzbot ci <syzbot+ci5bad6d1ccf4c5208@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jul 7, 2026 at 8:08=E2=80=AFAM syzbot ci
<syzbot+ci5bad6d1ccf4c5208@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] KVM: x86: Destroy the PIC and IOAPIC before destroying vCPUs
> https://lore.kernel.org/all/20260706180025.2735341-3-bestswngs@gmail.com
> * [PATCH v2] KVM: x86: Destroy the PIC and IOAPIC before destroying vCPUs
>
> and found the following issue:
> general protection fault in kvm_cpu_has_extint
>
> Full report is available here:
> https://ci.syzbot.org/series/43a61d29-79d6-47db-ac80-4e948bd10c1a
>
> ***
>
> general protection fault in kvm_cpu_has_extint
>
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      fb402386af4cdce108ff991a796386de55439735
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/7f3721c2-14ce-4beb-aa97-08232f57e=
71a/config
> syz repro: https://ci.syzbot.org/findings/0522c527-432c-4524-9835-64ab75b=
899af/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000012: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
> CPU: 1 UID: 0 PID: 5786 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kvm_cpu_has_extint+0xdb/0x340 arch/x86/kvm/irq.c:83
> Code: c6 e8 0d 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e=
8 44 54 e0 00 bb 90 00 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38=
 84 c0 0f 85 aa 00 00 00 8b 2b eb 6d e8 df 08 76 00
> RSP: 0018:ffffc900032f7740 EFLAGS: 00010206
> RAX: 0000000000000012 RBX: 0000000000000090 RCX: ffff88816b748000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: 0000000000000001 R08: ffff88816b748000 R09: 0000000000000006
> R10: 0000000000000006 R11: 0000000000000000 R12: 1ffff1102e032000
> R13: dffffc0000000000 R14: ffff88811e33cde8 R15: dffffc0000000000
> FS:  00007f57357e76c0(0000) GS:ffff8882a9714000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fae800f0378 CR3: 0000000109ffc000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_cpu_has_injectable_intr+0x1c/0x170 arch/x86/kvm/irq.c:98
>  __nested_vmx_vmexit+0x1911/0x2b40 arch/x86/kvm/vmx/nested.c:5181
>  nested_vmx_vmexit arch/x86/kvm/vmx/nested.h:46 [inline]
>  vmx_leave_nested arch/x86/kvm/vmx/nested.c:6854 [inline]
>  nested_vmx_free_vcpu+0x8e/0xd0 arch/x86/kvm/vmx/nested.c:381
>  vmx_vcpu_free+0x109/0x2c0 arch/x86/kvm/vmx/vmx.c:7765
>  kvm_arch_vcpu_destroy+0x154/0x380 arch/x86/kvm/x86.c:12859
>  kvm_vcpu_destroy virt/kvm/kvm_main.c:469 [inline]
>  kvm_destroy_vcpus+0x123/0x380 virt/kvm/kvm_main.c:489
>  kvm_arch_destroy_vm+0xf9/0x2c0 arch/x86/kvm/x86.c:13405
>  kvm_destroy_vm virt/kvm/kvm_main.c:1301 [inline]
>  kvm_put_kvm+0x772/0xb10 virt/kvm/kvm_main.c:1338
>  kvm_vcpu_release+0x54/0x60 virt/kvm/kvm_main.c:4101
>  __fput+0x41f/0xa40 fs/file_table.c:469
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  get_signal+0x1181/0x12c0 kernel/signal.c:2807
>  arch_do_signal_or_restart+0xbb/0x810 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0xa3/0x5e0 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
>  do_syscall_64+0x357/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f573499ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f57357e7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: fffffffffffffffc RBX: 00007f5734c15fa0 RCX: 00007f573499ce59
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000006
> RBP: 00007f5734a32e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5734c16038 R14: 00007f5734c15fa0 R15: 00007fffda4d80f8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:kvm_cpu_has_extint+0xdb/0x340 arch/x86/kvm/irq.c:83
> Code: c6 e8 0d 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e=
8 44 54 e0 00 bb 90 00 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38=
 84 c0 0f 85 aa 00 00 00 8b 2b eb 6d e8 df 08 76 00
> RSP: 0018:ffffc900032f7740 EFLAGS: 00010206
> RAX: 0000000000000012 RBX: 0000000000000090 RCX: ffff88816b748000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: 0000000000000001 R08: ffff88816b748000 R09: 0000000000000006
> R10: 0000000000000006 R11: 0000000000000000 R12: 1ffff1102e032000
> R13: dffffc0000000000 R14: ffff88811e33cde8 R15: dffffc0000000000
> FS:  00007f57357e76c0(0000) GS:ffff8882a9714000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000056532c5e2950 CR3: 0000000109ffc000 CR4: 0000000000352ef0
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   e8 0d 00 00 4c          call   0x4c000012
>    5:   89 f0                   mov    %esi,%eax
>    7:   48 c1 e8 03             shr    $0x3,%rax
>    b:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1)
>   10:   74 08                   je     0x1a
>   12:   4c 89 f7                mov    %r14,%rdi
>   15:   e8 44 54 e0 00          call   0xe0545e
>   1a:   bb 90 00 00 00          mov    $0x90,%ebx
>   1f:   49 03 1e                add    (%r14),%rbx
>   22:   48 89 d8                mov    %rbx,%rax
>   25:   48 c1 e8 03             shr    $0x3,%rax
> * 29:   42 0f b6 04 38          movzbl (%rax,%r15,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 aa 00 00 00       jne    0xe0
>   36:   8b 2b                   mov    (%rbx),%ebp
>   38:   eb 6d                   jmp    0xa7
>   3a:   e8 df 08 76 00          call   0x76091e
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [bestswngs@gmail.com jasowang@redhat.com kai.huang@intel.com kvm@vger.ker=
nel.org pbonzini@redhat.com seanjc@google.com shixuanqing.11@bytedance.com =
stable@vger.kernel.org wangzhong.c0ss4ck@bytedance.com zhanghy@sangfor.com]
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
-upstream-moderation/6a4c97f4.57639fcc.86d58.0009.GAE%40google.com.
