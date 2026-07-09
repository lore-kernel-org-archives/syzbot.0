Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B72C3B388A
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 06:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783578267; cv=pass; b=Nl5z9JZIr2DIHqhVd6LbGwNyEaThPEmusahIsm7Ef4CET0vwZiO9H5iLCFLPJrJN1ZUp/YFtj+7dQZ61EkQUwwS+XzirnGCR+eSaSWMK3NLylY2PD1Ozcde/0JErGs8ni/dB3c/qq6fgEhdYwLFjt1Bi2wHa7ld/VyhfO29uW6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783578267; c=relaxed/simple;
	bh=dQsmUnoPmHcmg1PppN6W3t/TUI4hA7vPwQTAa0VQ8SA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GvsE5S/J7ZRB4Vm/LyzXb+aolq5dqHdH6Ac9SkWCXrlDddqCK4ZMHqx9uyhbVxT8/RCytiQ0uLOVl7yv6rcw1jsjQBeTnjqouQlvp8BYLvoSSdciFV+AjDIzUdL9puj5s75Az2gWkOPDoeqxONMHUUysWDibPPlZtkELAxctXHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oXhytBzj; arc=pass smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oXhytBzj"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-44cb68d549fso239969fac.1
        for <syzbot@lists.linux.dev>; Wed, 08 Jul 2026 23:24:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783578265; cv=none;
        d=google.com; s=arc-20260327;
        b=bEe+XGoRdQLmClhozi4BAEMxYasBdhs6b9HR4bUAy5cxEAervmdI92qRdpd+docdti
         Mdt9Q4a40BVVZ9oWjrSxbnr/B8/K1iGzDfL9HPp6Sh/ribZ3mvOFKAyGdpGAtio1xkto
         8KW/tvDGtUTOxZhRHDqfK8m99QTWQYwQ5XPDFXE+uOQ7UklU1q4P+BYv5F65gmhdF9Km
         qZG8mCPSOQD0aoLhtL+vkj2Ui4cOdsqwO2HyQ76OPLxigkR8t1lvMPVgpvm4vAFDRYIX
         B2u15DDrkdze7iJgKktgVtrMjb1qOWA26Frzmc2Q7KVVxs8sng1VUlSnsCmp5kKQo7J3
         VCpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=24PJVh69Wt8AAqKB/g/6heMyDbLfkxuPJbQO/kQrsTM=;
        fh=ta1NfJTgqaSfq1gOmM/AoDgQGv8FXxBJdgRS0U1wULg=;
        b=bOvSiRpi0F3qjGu80rYFwR2HIBldI7dxEOIoMoAFcDoTXUhWzorE4tgfLDFHgYq1f5
         6rZSzbw319lqBOr/c7YO5LjtIyFm6jfREYggwDNvbfrSEg/pPqYEBAukPiL3qcHP13ee
         ddrE0hAKFvyr5IQ446coheHfPOk7GMf0NAoIPiKvHLdyJpbBuPFheWwykdEuvcS8osqt
         lAH8KhU8IFtSbzqOscAKd6ufYgPfqBFZkjRYLgGQ+rfqwNiXvZGUjUsE614eZJ3V710O
         Iwkcks79j+PO+hfcyAspuiHrKk7MOy2KBUtHmOxfYofMjSFsmChUPvLicpN+mWgs18Xj
         jBBA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783578265; x=1784183065; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=24PJVh69Wt8AAqKB/g/6heMyDbLfkxuPJbQO/kQrsTM=;
        b=oXhytBzj0HZNsE0OwF5hHlkCw6NbJEsT02w+gEVtw2llSM4nGnTlDt7Z56MnV/8tQE
         PSDvX+gXqRtDf2pZ9W/2fMiFSgomxeTTpAupdfmQ8BV2cGDVEqTJXlqKAUMaN4XiAf2L
         9eVMFBAHF0T7WsBYxn8z7QRwc8A+wEam7hFPG0xrazicplcsUFGNnEeODx0Mr+yLFqZ4
         VNgkTal3ta3L4NC8sLiaGLa5TZx9B+blBCp34BWmDbc++CTSinMlXpHW3FImIuY4ghS4
         YT0FUINyZNyj03nEQRJz/H5AFa58/Y1xgri3hWMWa6iCq38TiBUHweCUio2SHZA3q43S
         7zNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783578265; x=1784183065;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=24PJVh69Wt8AAqKB/g/6heMyDbLfkxuPJbQO/kQrsTM=;
        b=LFGTwsZ8DDTUEnw4dC2c+JaPyWIwo+JpZRQ0fL1FeeXx/thu4M3HTJhao1msL2zdDd
         S+Qrokrxmejq3b4lmeR+AKnbxM8H1OilAqnOfTwu8TyKWUylMcfQYNtbjSocQz85xrjf
         /CSLm7kFtlu7wh1QtqUV6ozy/IEk5e9/6MT8IxQRNonjyh6EbvLTSoXsROVDFcyYIjwq
         g/zTyiE1cj29jKXKKK89LXgPB4dGlre+PPmpaCdIkocSJzb/s1+arkgyiLCrF62LyzhR
         oQHN8hZcmMza1KckZcKWMo2bGv5EVLIxmY2MTfrdGEsw/W8E8mbjN9ycC1xJw3QSTOx3
         v9bw==
X-Forwarded-Encrypted: i=1; AHgh+RoyEvXD2rDG9mL1uFek3H2m78ng+J8urU5/6lbr9//bx8pI5iyXBEfgOshNtDqMA0u/sr8D+1g=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDPBzybjtLxMusCbTAG2wj058jgctf8FlvfJnexYEHU5Kce++7
	gX46kKSoAISVd1KDR3Y3pKHzAldZkqkANnFnFKYScpuHe303sS7fVaV2diM1xluCsanJkSOXVZS
	5vre0uYPDMzOGditP8J6opMDEiJz+o7ATUEDpGQFZ
X-Gm-Gg: AfdE7cnCbOuq96zdVb4LHNmzZ0HmmgvEIUSxiivmOSKyyh7/lcPAhuFHEiNcJCRdQyN
	olOGvtnOhuzP1xYV2Ry8CY+mKlipx/s/WkU//SWKHJ/u2NAeh7/5qFERBfyWYvG4uz3Lk8uMA44
	Dg8WLMTVkvAf2TgMGWfzfa4PDeF7m2BjA+EDEJqrTfg/jkjiVOfmzOONQAqQgH5BjMGRuZAr0lS
	FdXxBiFRCg0ya7Gq17uEH0hRT+YiQ+kmwhANOixYtAdTIopMx+ZbMA2PKJuMydWGI8BwaV3HauG
	2QwbZp5YRAENEnLwlCbXkT6bA0Fl9+q8IH4Tf3QrVXMcV46YuD8mpLp6wrVXCaZiNBjAxr6Hc4N
	lS2e1VKcpnDwUCuJ8wUrvnNB6BqjOUa/Sq6a/Hq7Ztt4=
X-Received: by 2002:a05:6870:648f:b0:448:d83b:edaf with SMTP id
 586e51a60fabf-451957b7068mr1028503fac.25.1783578264509; Wed, 08 Jul 2026
 23:24:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a4eb0fa.57639fcc.86d58.0016.GAE@google.com>
In-Reply-To: <6a4eb0fa.57639fcc.86d58.0016.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 9 Jul 2026 08:24:03 +0200
X-Gm-Features: AVVi8CenN-Je_Sz_wdTRWHYMssqIdaRWPR_4ueLAtD361e0zHrL6LUnFWHULCvY
Message-ID: <CANp29Y6HUyHMBuNAo37GkLyXWbmncKc-BtC7T8PUx6DWS4OK0g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: riscv: Generate riscv instruction functions
To: syzbot ci <syzbot+cidf072037ac66b347@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jul 8, 2026 at 10:20=E2=80=AFPM syzbot ci
<syzbot+cidf072037ac66b347@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] riscv: Generate riscv instruction functions
> https://lore.kernel.org/all/20260707-riscv_insn_table-v3-0-3f8e5f75ba97@g=
mail.com
> * [PATCH v3 01/17] riscv: Introduce instruction table generation
> * [PATCH v3 02/17] riscv: alternatives: Use generated instruction headers=
 for patching code
> * [PATCH v3 03/17] riscv: kgdb: Use generated instruction headers
> * [PATCH v3 04/17] riscv: Add kprobes instruction simulation KUnit
> * [PATCH v3 05/17] riscv: kprobes: Use generated instruction headers
> * [PATCH v3 06/17] riscv: cfi: Use generated instruction headers
> * [PATCH v3 07/17] riscv: Maintain epc on misaligned emulation error
> * [PATCH v3 08/17] riscv: Use generated instruction headers for misaligne=
d loads/stores
> * [PATCH v3 09/17] riscv: kvm: Use generated instruction headers for csr =
code
> * [PATCH v3 10/17] KVM: device: Add test device
> * [PATCH v3 11/17] KVM: riscv: selftests: Add mmio test
> * [PATCH v3 12/17] riscv: kvm: Use generated instruction headers for mmio=
 emulation
> * [PATCH v3 13/17] riscv: kvm: Add emulated test csr
> * [PATCH v3 14/17] KVM: riscv: selftests: Add csr emulation test
> * [PATCH v3 15/17] riscv: kvm: Use generated instruction headers for csr =
emulation
> * [PATCH v3 16/17] riscv: kexec: Use generated instruction headers for ke=
xec relocations
> * [PATCH v3 17/17] riscv: Remove unused instruction headers
>
> and found the following issue:
> WARNING in kvm_io_bus_unregister_dev
>
> Full report is available here:
> https://ci.syzbot.org/series/f3c61796-0ca0-4bfd-add1-23a20352fb7b
>
> ***
>
> WARNING in kvm_io_bus_unregister_dev
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/65190eb6-0d65-4629-b225-e3b7089a0=
b10/config
> syz repro: https://ci.syzbot.org/findings/fa2c789e-ba9f-4d55-b3ba-0d5f22f=
78a4d/syz_repro
>
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&kvm->slots_lock)->dep_map) !=3D 0)
> WARNING: arch/x86/kvm/../../../virt/kvm/kvm_main.c:6027 at kvm_io_bus_unr=
egister_dev+0x4b0/0x580 virt/kvm/kvm_main.c:6027, CPU#1: syz.2.19/5828
> Modules linked in:
> CPU: 1 UID: 0 PID: 5828 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kvm_io_bus_unregister_dev+0x4b0/0x580 virt/kvm/kvm_main.c:6027
> Code: 3f fc ff ff e8 a1 ce 86 00 48 c7 c7 40 f7 c1 8b e8 a5 29 e9 ff 48 8=
9 ef e8 ed 00 00 00 b8 f4 ff ff ff eb a3 e8 81 ce 86 00 90 <0f> 0b 90 e9 cd=
 fb ff ff 48 c7 c1 e0 bb 2f 90 80 e1 07 80 c1 03 38
> RSP: 0018:ffffc900032afc30 EFLAGS: 00010293
> RAX: ffffffff813e81af RBX: ffff88816b133688 RCX: ffff888160aba540
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffc900032afb7f R09: 0000000000000000
> R10: ffffc900032afb70 R11: ffffffff81404850 R12: dffffc0000000000
> R13: 0000000000000000 R14: dffffc0000000000 R15: ffff8881a5354000
> FS:  000055555b90c500(0000) GS:ffff8882a92b9000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b33663fff CR3: 00000001bceb8000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  mmio_test_destroy+0x66/0x90 virt/kvm/mmio_test.c:83
>  kvm_destroy_devices virt/kvm/kvm_main.c:1251 [inline]
>  kvm_destroy_vm virt/kvm/kvm_main.c:1296 [inline]
>  kvm_put_kvm+0x902/0xae0 virt/kvm/kvm_main.c:1332
>  kvm_vm_release+0x43/0x50 virt/kvm/kvm_main.c:1355
>  __fput+0x418/0xa50 fs/file_table.c:510
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0x193/0x6b0 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2f43d9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffde9296e78 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007ffde9296f60 RCX: 00007f2f43d9ce59
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000011938 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000001b32a20000 R11: 0000000000000246 R12: 00007ffde9296fa0
> R13: 00007f2f44015fac R14: 0000000000011971 R15: 00007f2f44015fa0
>  </TASK>
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
> [akpm@linux-foundation.org alex@ghiti.fr anup@brainfault.org atish.patra@=
linux.dev conor@kernel.org jtaubepe@redhat.com kvm-riscv@lists.infradead.or=
g kvm@vger.kernel.org linux-kernel@vger.kernel.org linux-kselftest@vger.ker=
nel.org linux-riscv@lists.infradead.org namcao@linutronix.de palmer@dabbelt=
.com pbonzini@redhat.com pjw@kernel.org radim.krcmar@oss.qualcomm.com shuah=
@kernel.org thecharlesjenkins@gmail.com]
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
-upstream-moderation/6a4eb0fa.57639fcc.86d58.0016.GAE%40google.com.
