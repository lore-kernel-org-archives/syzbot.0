Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A2B3D891B
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 07:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782457551; cv=pass; b=VlH5nMNfbXe30N9OBuirySlmbXkubGOBlipWPZziXHxVmYr7Q5Wma2v03ujZ+sQb5lUt1Q/gM0YAkEXZi89uiOG5DHBwoe19fYt8GMW0gAe6q8+vlcaXmx3KBby1DrUhOzJrbRn12DZZUj91jjJpDb5W240b1Bls4u8J05Qsg0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782457551; c=relaxed/simple;
	bh=IfmpTF/e9fdyodG9ez+orZxj28F/jCLHvSvkXVKcNOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bOZECFLv7jvV66JocNYKIEg/7xBjeYcnBrCAh5vD/RiaveFAXa+5tkVenpfNm6z+087Q/dT4LGUujWgdkCIMjdxsT1gS5aiwXcy8DPIeC8Ae0ewSdDfMSoouGn4m17pNjaCDarDxx7B0RJlOEAJhxIMOtaTwd3jKG7przVOZFTg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rjNUzSTX; arc=pass smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rjNUzSTX"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-447046c980aso440202fac.1
        for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 00:05:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782457549; cv=none;
        d=google.com; s=arc-20260327;
        b=Q/8rYZuSEbnoYCJ368hOBMdycoAZ9deaX02TJSsngDZtIaEE3ezvVh+Y0d7Vnz9dh7
         cIAARm1UIA8/fA5IlS03Q6K5duI0bMkVA15ju+VjFWcMrmA9h/tOqGH5f5/pX3AlJU0z
         YnoyH4whVdY7P/ZaPz5RPJLK9isaFEhqj4vjQjlllAJIBAy3FSFdcU56ibmlAETMNDxq
         Rc2d8gZ1mwzR9uUgeasUWDzbWQhSlvBQjvde4pLYkmxXeXVBzl94KNFG5zomozb94zq/
         5NdZRW/e4i5Z1iHZpoN+rwGYFkaTi6Ijc+hUKh+ERaJZZlxBI4nxAkla6NxueYhhrvc0
         8hlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JIYkxCXxXskxwo3KDfZptWwG37ZxNh01aKe15yU8QA0=;
        fh=6OTE7xzuj8DM1Z3MLR2goqAflrZaqkGzI5v3IBEbleQ=;
        b=NMGyy0+aAuUoxUw6QkmD7XWTP9UYTJFSS0OefU3DPGchv/IkKdX2PTfndl+vYGhxWe
         8yFyLCOzR2WA21Je82r/RM11SluRxSpBJdNKz2JxESy1rkS3i9zfz0YVx6SW12IjI6Rs
         ge2hPecV6g7vmeF4FCzbq6e8YJ4rql1jHTxKHPD8jY9MZmjBFUixdsqAhhZtQ16hjZEO
         F8Xxi5qyRvQF2g3cRRbHESHG2pF53QnNniywmsJGC/i5iXEr/uMd8TbPK3ON1UwHF20/
         SZkt7DPqNLBmU1Q2RUISAbsqqDPCQsrbpXKcEJbv0SPegtVvC4ogdcXOsxsCjkghQ/T7
         9XIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782457549; x=1783062349; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JIYkxCXxXskxwo3KDfZptWwG37ZxNh01aKe15yU8QA0=;
        b=rjNUzSTXSACqQzLqZ93WPyDFEFjeQx1DmKQRk/vBs5dKi88OdYHwvKhtVQNYCbu+d5
         34Yx1zOpQvIVX8Adzh6oTmSApadAvBx/iWPfj3CX0G5uCK1LmSB/3hjGpYl6gHsINjGA
         gDZqsSw3jsaTbXFya3q1g1yA0i35sGYLKYaKtSYdd8ta88HJNHZHsXz1XbaFtxFQja5S
         N7d9ozYiLnUcx1EUWe+WA2LaB30bPmBD2h9rJT4nzNwlPHL/FR3GNz8UjZbR3PjvKjsx
         1vfGS0uOSoFxiSObLxuv9fPQR06ZgXfhXT7SkAU5b8tVm9pGYIeG0bLWSeBfANVsjkXJ
         Hy1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782457549; x=1783062349;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JIYkxCXxXskxwo3KDfZptWwG37ZxNh01aKe15yU8QA0=;
        b=RD0ZSdWBwaZm/v24m2uOBG3E3/uQeWVlxa1881ekp61t0Cv590vY3vhzL0DPuPVJGi
         KY/x4x1Nuoea5Oe/uflr8T47m/ZmYAGqJp0/uMn0gOyV4duJegOkWab5Za8gb5Ucsd4B
         VmBgGbREQTOAqZRnG8jjCuCio7ea8KzUX0JkVGXHFfm8yI3P97qawp8vwcpGs79ceErk
         0DrqVhQdnmap8HFdxY4j0QV5MeaPqXU8GZJa8GZfX8HIAXCACltlhzkJk1m4IgbBO/xQ
         sboWKjggzU9NqExCmQ1L8f44ehvR6ByOlWuk+UuLqAjDpifie3LeqLMDYr/OLG554wKD
         Km/Q==
X-Forwarded-Encrypted: i=1; AFNElJ9NZjwPXVMpaErvUzVr0P9eT79vjO6kWP6o/XUK545Qw+LG3ahvgNCgO3LsrUCyP1A0fs4Ldwg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMyAoza2Xint8eR6NLgEuEvl6GgVtYL1GG8iGMFGn0BQHhO1mR
	ayn8p/7EEd0+wGemO1SrYIMSqfvAtdNRfSjQHpOQagQubQxZEDf4Q//qISrfqy8ZP/f+yJ9nraN
	yiTflxb2b3zR226oxU4L4h7aBngK+9nT+dMBqqYzP
X-Gm-Gg: AfdE7ck9OHcrcF0xqYo6CWzqI/K9r06yilv6Rw3srVTIz72tiEJ4mEYYbsaVJ/BCqym
	h4bXZ1jPrCD9YHlgTL0NrglHJV3IxkZ8ZBn3ACt4EMR4cfZp6cg4/5QunFKqVhu0hVk7s2ekHeA
	vq5KpAoND33sFEKFQ9YBBcUcdPzqoUzikisfdzlDw/ITNctipLoQ20fq1G1b0TwHOwVtrQksEt+
	Psuf6soEW90ysll6Dz7yiOeE09ahY5IefwqR154rx0k7pPSSGiL1qOkWa4xS78GXApmy/2hjfpe
	bQP1tm2G6TxkUOA0c1rM8aTI1sqCxp2AdxyDx8UOfos6Wzjk0nPULqx/ePCLADIBuaoJu36kyMt
	t54/Fh4aIDDnfUVTfdQTJZIcjGrHBW/L3D2PUeP0TN607BteN8sU=
X-Received: by 2002:a05:687c:350:10b0:448:3eb2:8c8c with SMTP id
 586e51a60fabf-4483eb2b080mr364482fac.6.1782457548747; Fri, 26 Jun 2026
 00:05:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a3de85c.50e3af5f.200e1a.0001.GAE@google.com>
In-Reply-To: <6a3de85c.50e3af5f.200e1a.0001.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 26 Jun 2026 09:05:36 +0200
X-Gm-Features: AVVi8CcP3G5MEOsTQRDSSNIlBXekRwMTFbllkPjKTxnvhKdgJ0AfJsJLThSbwVA
Message-ID: <CANp29Y6c_nWLhQwyoq3mBxK6LD6REnXDeYVjvkRnD2dUJYd5pw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
To: syzbot ci <syzbot+ci308c8277881115e4@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jun 26, 2026 at 4:47=E2=80=AFAM syzbot ci
<syzbot+ci308c8277881115e4@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
> https://lore.kernel.org/all/20260625223623.3376478-1-seanjc@google.com
> * [PATCH v3 01/10] KVM: x86/hyperv: Get target FIFO in hv_tlb_flush_enque=
ue(), not caller
> * [PATCH v3 02/10] KVM: x86/hyperv: Check for NULL vCPU Hyper-V object in=
 kvm_hv_get_tlb_flush_fifo()
> * [PATCH v3 03/10] KVM: x86/hyperv: Ensure vCPU's Hyper-V object is initi=
alized on cross-vCPU accesses
> * [PATCH v3 04/10] KVM: x86/xen: Punt singleshot timer hcalls to userspac=
e if Xen vCPU ID isn't set
> * [PATCH v3 05/10] KVM: x86/xen: Consolidate checks on Xen vCPU ID for si=
ngleshot timer hypercalls
> * [PATCH v3 06/10] KVM: Initialize a vCPU's index to '-1' while it's bein=
g created
> * [PATCH v3 07/10] KVM: Move nVMX's lockdep logic for vcpu->mutex to a co=
mmon helper
> * [PATCH v3 08/10] KVM: x86: Treat a vCPU as unreachable if its index is =
invalid
> * [PATCH v3 09/10] KVM: x86/hyperv: Assert vCPU's mutex is held in to_hv_=
vcpu()
> * [PATCH v3 10/10] KVM: x86/hyperv: Use {READ,WRITE}_ONCE for cross-task =
synic->active accesses
>
> and found the following issue:
> WARNING in kvm_hv_vcpu_uninit
>
> Full report is available here:
> https://ci.syzbot.org/series/6864cbe8-ce00-47d1-b4b1-abc7d1528d4e
>
> ***
>
> WARNING in kvm_hv_vcpu_uninit
>
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      a204badd8432f93b7e862e7dac6db0fe3d65f370
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/0627391d-c4d6-4820-99f0-31a8b51ba=
783/config
> syz repro: https://ci.syzbot.org/findings/cdadfdf2-8445-4193-a3a6-bf87817=
6b493/syz_repro
>
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || vcpu->vcpu_idx=
 < 0 || !refcount_read(&vcpu->kvm->users_count))
> WARNING: ./include/linux/kvm_host.h:996 at kvm_lockdep_assert_vcpu_is_loc=
ked_or_unreachable include/linux/kvm_host.h:994 [inline], CPU#1: syz.1.34/5=
967
> WARNING: ./include/linux/kvm_host.h:996 at to_hv_vcpu arch/x86/kvm/hyperv=
.h:79 [inline], CPU#1: syz.1.34/5967
> WARNING: ./include/linux/kvm_host.h:996 at kvm_hv_vcpu_uninit+0x198/0x210=
 arch/x86/kvm/hyperv.c:906, CPU#1: syz.1.34/5967
> Modules linked in:
> CPU: 1 UID: 0 PID: 5967 Comm: syz.1.34 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kvm_lockdep_assert_vcpu_is_locked_or_unreachable include/linux/=
kvm_host.h:994 [inline]
> RIP: 0010:to_hv_vcpu arch/x86/kvm/hyperv.h:79 [inline]
> RIP: 0010:kvm_hv_vcpu_uninit+0x198/0x210 arch/x86/kvm/hyperv.c:906
> Code: 48 89 df e8 0a 55 d8 00 48 c7 03 00 00 00 00 eb 05 e8 5c 16 6d 00 5=
b 41 5c 41 5e 41 5f 5d e9 ff 16 4d 0a cc e8 49 16 6d 00 90 <0f> 0b 90 e9 65=
 ff ff ff 48 c7 c1 e0 bb 2f 90 80 e1 07 80 c1 03 38
> RSP: 0018:ffffc9000390f960 EFLAGS: 00010293
> RAX: ffffffff8158e9e7 RBX: ffff8881bc192880 RCX: ffff88816ac70000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff888101fa1743 R09: 1ffff110203f42e8
> R10: dffffc0000000000 R11: ffffed10203f42e9 R12: 0000000000000000
> R13: 00000000fffffff8 R14: ffff888101fa1740 R15: dffffc0000000000
> FS:  00007f47c1e886c0(0000) GS:ffff8882a92b6000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000c64000 CR3: 000000016a5e7000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_arch_vcpu_destroy+0x1a9/0x380 arch/x86/kvm/x86.c:9413
>  kvm_vm_ioctl_create_vcpu+0x615/0x990 virt/kvm/kvm_main.c:4269
>  kvm_vm_ioctl+0x886/0xd30 virt/kvm/kvm_main.c:5168
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f47c0f9caeb
> Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 4=
4 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0=
 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
> RSP: 002b:00007f47c1e87ee0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f47c1215fa0 RCX: 00007f47c0f9caeb
> RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 00000000000000f7
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000c00000 R11: 0000000000000246 R12: 0000200000c00000
> R13: 0000000000000153 R14: 0000200000000400 R15: 00007ffe526558c8
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
> [dwmw2@infradead.org kvm@vger.kernel.org linux-kernel@vger.kernel.org pau=
l@xen.org pbonzini@redhat.com seanjc@google.com syzbot@syzkaller.appspotmai=
l.com vkuznets@redhat.com]
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
-upstream-moderation/6a3de85c.50e3af5f.200e1a.0001.GAE%40google.com.
