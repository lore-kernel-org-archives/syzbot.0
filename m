Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7DE382392
	for <syzbot@lists.linux.dev>; Sat, 13 Jun 2026 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781383045; cv=pass; b=kKBSZ5Ondf9bZ20ycsKQ0d2hX9i/IVUf2EuHbvDcujlvJMZy2Xjt1ZR5sG7okmJiYeZatdrGaVCYYhfJ/yWO3yJBPil5xHzRN3wnf+QP6WvNvXJqDIRZA6lFaCO1/v1du0HFtqUuMxwzDTDuP6TG+od8+isiiNfbgLWA0DYSuPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781383045; c=relaxed/simple;
	bh=rm7wQhS1um1DMyDkZhvBd1Mqch9RVZI4XMsAkv1Gn7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dOU1kQPMxYdn5cJEmhfivUmnxNXDqBZ+lTKVi22YuIWGp2qJTKEm3Er6kBHp8t/OmKrw7CmTozC/QEf3o7Vif78dudWrFxw/oGLxAysL5enS+zFaWseAen0Nkoxa/nQDrq8eVQiezwBUv6k98IeJWqhZ5N+fNTIThjF7QUzf95s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ORO5H8S5; arc=pass smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ORO5H8S5"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-69e402b625fso1541976eaf.1
        for <syzbot@lists.linux.dev>; Sat, 13 Jun 2026 13:37:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781383041; cv=none;
        d=google.com; s=arc-20240605;
        b=BH3bjj2bJ5jElgHVmU92mBp5QRHydQCNtdSwADNnFb4ke47f3B492bJvuhYDWkL7WN
         msF/mYaJoAgFugkU0V2/GIl+p8YSoq9eUz3rYVvOfbM1Y7PqGEEuahSF3lguETJCgRsN
         kvAKo1HKQCMns2oMeNI4jYwyoum2DikLFJLIXO2GntWIkM91P0F/DrLY1kfih77vhyq9
         dGZhH/VZpDlLcGy2EEl2tWDl19orBtgewXQqD6gG/1halHXlsTMZwhIdtuRjIVm7NRHb
         mgCJ5tTmfk/b+aKPrWfIr+wCMmN/XWniFOw27/cXsXnAt8xh2/F2aszmzT7Xs13Vg4/O
         yc1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h7vUtcoqKGeO8zSARkQ2JWtW9FHX/9lOh2JQqumL3sc=;
        fh=5SEkKaKtjmlfHnPYvOB2qsD+f6R9k9sKybsV7u7ypm8=;
        b=iLg3aJXeQrPgz9F7xHyCsndfq3jvfXYRAlhzxN9Y16VkUJfKhEghNmg8W9OZNmLwGS
         lWO3tGkjyO5PQa3oGekFYb/Atnr5GtX/IsnxK+FFDyzrv2O7tU3TdpubdRyoBDmYbtjl
         rtV973fDF9WAwbXw/i2g3yIpeS8touQRhRKY4zh0QGdSUvi9OPpWuqJ+LPSxZTUDf66u
         vQI6m+fX53C1hR+K+9To5Lq8u5T3AgDhQcxSyz93tq5wsHqvvDsFPi8OjA8b9EX+j8QP
         NWR5xJdz63nvjFknp2u7r0JTZFtK7vml9l2ZLbyLMc9Uzh1Jq5FFNPBLOv9B8oLWkeF2
         mOrQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781383041; x=1781987841; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7vUtcoqKGeO8zSARkQ2JWtW9FHX/9lOh2JQqumL3sc=;
        b=ORO5H8S5Y0KjcFv091aMvzOtrzpxX4JfgZVdNBmZLejMjnmuVHKOMyU/wbG5dbqEMU
         WDFAsY+Sqs38bgzSARCRW1cVJgH5zwKjZoQhAwwS0ctkicnDjMEd6/IFodH6jA/dHVdX
         5msVB11dbBHG1VS5P5yhU1gUVTVqXvmQeYFtm7IomB/nw5poU1hHqimK9eTRrLDl+kDh
         T7zxsA6NgpiYrwRy/wmHqz89me00NwrXqYkSsw7l7q3oLG2p2Pb1d3QtcOhc4GhceUJI
         vry3N85SZX0jcwoEGwTEkCIWSPnwBQ8GqBYXDYl4JNwMdfkzyfd+vQBVYgm2cWo9pd9m
         i43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781383041; x=1781987841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7vUtcoqKGeO8zSARkQ2JWtW9FHX/9lOh2JQqumL3sc=;
        b=lVruglD5qd1rctXbwS8M6Vj4yRP0nbLze8P/GxqsH6UhftkBfWFWlT61ayqVUAeVp2
         hZVA3PvH82iURMiAOSPw//bJmkNuXz8bKfWtjpyD/40Uivwu2d/x0MsHL07YGqAoDgmw
         svjKzeO1tNh17Dm2CBdwHSOHX6bJlBxMhSt0Uwqldksppvw+EMkZ4+j799HtZAoDFKwb
         JnjRPZ4g36NfOgU/LsIhK3drw1l90Xj5Ej6IcLJ+OiQ5mClHtzohjEau//vE+eLdAtJD
         vAgkLc9UC0HyMOJ7oT3OEkvkIMxg7Oue7Kz/YeryryzF4dta0Q9oA6eBHoSTrgdD9Lia
         rDMQ==
X-Forwarded-Encrypted: i=1; AFNElJ9tbX8NuWc09mD9oD0x+dJrQluJ2V+J/57W7GECGIKSKaze0UWMSgnLF3SsAA5dwVhrxcXNGyI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwmaQQHV2ASpPsHG5Y7JWiUMWlrlIMmB5ba114ZaPAkQI73NkOl
	9KpAe+uUD7ZOvWPsBhSTZojOV4RZvi0GIZfWr7DSQfpfDlmnJ+j1bfRgdE7sizEPk+5Hqt5299W
	WFpFZzzzCaZmz/UExVz1Da6fEd0TjKeJE69O2nae3
X-Gm-Gg: Acq92OHLe+jNnRg3gr5eumXwVCXyS51+U+4ILBSYxYjtkI73RliPoFcNargW7iofNVC
	MhMZ1F9W4j+pickBzxj4BOHllOaun0yje3VuvGXHRRAeUAPmqDKS6lZ7fU+i1mJN4AS/G1YdEu1
	UDIy+RKj37rHjXxu0ZvXwR60W3djOiKiwpBhi3Eri43IyW6HemT3wmpNkzVay1iSKSdl1u7Gvh7
	WuKkWfj/VuLJYkFINpbEmsrxpP7zFNb+qr5s9qboDRqVmVi4nSmIEVxESAK0Q5YZ+1FkX6rzEnO
	M51RI10XJdU+rwk0vyDWRnc9C5kJlESrYxdXfKjG/eSaTYe44D1oY7RNWxJUNAW/5E0sOlYPRBH
	5MogQszGfgQRJuFUVC61W0Gh2tscY9fuzI+IQ4eRdj7ARlBWMeVmFSQ==
X-Received: by 2002:a05:6820:151c:b0:69d:eb77:ddce with SMTP id
 006d021491bc7-69edc5d3977mr5230240eaf.2.1781383040285; Sat, 13 Jun 2026
 13:37:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a2dbe63.8812e0fc.3c3fa4.0009.GAE@google.com>
In-Reply-To: <6a2dbe63.8812e0fc.3c3fa4.0009.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 13 Jun 2026 22:37:09 +0200
X-Gm-Features: AVVi8CermSQzunnfVCPp-nCAiJ5v2M1rvGwNs0mdSqxlOe3Q2JM2BN6zEi5hRWI
Message-ID: <CANp29Y6bd9aXwwCniSK1XUs14QTSExAxytW6zCNBeFCSynwN0A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
To: syzbot ci <syzbot+cic0ede7696ff6a703@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Jun 13, 2026 at 10:32=E2=80=AFPM syzbot ci
<syzbot+cic0ede7696ff6a703@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
> https://lore.kernel.org/all/20260612230622.687665-1-seanjc@google.com
> * [PATCH v2 1/8] KVM: x86/hyperv: Get target FIFO in hv_tlb_flush_enqueue=
(), not caller
> * [PATCH v2 2/8] KVM: x86/hyperv: Check for NULL vCPU Hyper-V object in k=
vm_hv_get_tlb_flush_fifo()
> * [PATCH v2 3/8] KVM: x86/hyperv: Ensure vCPU's Hyper-V object is initial=
ized on cross-vCPU accesses
> * [PATCH v2 4/8] KVM: Initialize a vCPU's index to '-1' while it's being =
created
> * [PATCH v2 5/8] KVM: Move nVMX's lockdep logic for vcpu->mutex to a comm=
on helper
> * [PATCH v2 6/8] KVM: x86: Treat a vCPU as unreachable if its index is in=
valid
> * [PATCH v2 7/8] KVM: x86/hyperv: Assert vCPU's mutex is held in to_hv_vc=
pu()
> * [PATCH v2 8/8] KVM: x86/hyperv: Use {READ,WRITE}_ONCE for cross-task sy=
nic->active accesses
>
> and found the following issue:
> WARNING in kvm_hv_vcpu_uninit
>
> Full report is available here:
> https://ci.syzbot.org/series/674ef35a-9335-4710-8a6d-b18d01510cbb
>
> ***
>
> WARNING in kvm_hv_vcpu_uninit
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      c1f7303302927f9cbf4efedf70f0512cde168c65
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/20dd789e-0a89-4465-844c-9d91b5ce4=
a45/config
> syz repro: https://ci.syzbot.org/findings/eeefcfe6-b8e9-4c5b-900e-855d814=
f5d97/syz_repro
>
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || vcpu->vcpu_idx=
 < 0 || !refcount_read(&vcpu->kvm->users_count))
> WARNING: ./include/linux/kvm_host.h:996 at kvm_lockdep_assert_vcpu_is_loc=
ked_or_unreachable include/linux/kvm_host.h:994 [inline], CPU#1: syz.1.25/5=
883
> WARNING: ./include/linux/kvm_host.h:996 at to_hv_vcpu arch/x86/kvm/hyperv=
.h:78 [inline], CPU#1: syz.1.25/5883
> WARNING: ./include/linux/kvm_host.h:996 at kvm_hv_vcpu_uninit+0x198/0x210=
 arch/x86/kvm/hyperv.c:906, CPU#1: syz.1.25/5883
> Modules linked in:
> CPU: 1 UID: 0 PID: 5883 Comm: syz.1.25 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kvm_lockdep_assert_vcpu_is_locked_or_unreachable include/linux/=
kvm_host.h:994 [inline]
> RIP: 0010:to_hv_vcpu arch/x86/kvm/hyperv.h:78 [inline]
> RIP: 0010:kvm_hv_vcpu_uninit+0x198/0x210 arch/x86/kvm/hyperv.c:906
> Code: 48 89 df e8 0a ba d8 00 48 c7 03 00 00 00 00 eb 05 e8 1c 63 6d 00 5=
b 41 5c 41 5e 41 5f 5d e9 8f f6 51 0a cc e8 09 63 6d 00 90 <0f> 0b 90 e9 65=
 ff ff ff 48 c7 c1 e0 5c 30 90 80 e1 07 80 c1 03 38
> RSP: 0018:ffffc900035ef940 EFLAGS: 00010293
> RAX: ffffffff8158f397 RBX: ffff88816987d400 RCX: ffff888110b20000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff88810c5b9703 R09: 1ffff110218b72e0
> R10: dffffc0000000000 R11: ffffed10218b72e1 R12: 0000000000000000
> R13: 00000000fffffff8 R14: ffff88810c5b9700 R15: dffffc0000000000
> FS:  00007fbc073dc6c0(0000) GS:ffff8882a929a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f451a40fff8 CR3: 000000010f703000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_arch_vcpu_destroy+0x1a9/0x380 arch/x86/kvm/x86.c:12905
>  kvm_vm_ioctl_create_vcpu+0x68b/0x940 virt/kvm/kvm_main.c:4262
>  kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5161
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbc0659ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbc073dc028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fbc06815fa0 RCX: 00007fbc0659ce59
> RDX: 0000000000000001 RSI: 000000000000ae41 RDI: 00000000000000f7
> RBP: 00007fbc06632d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fbc06816038 R14: 00007fbc06815fa0 R15: 00007fffc5de9fc8
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
> [kvm@vger.kernel.org linux-kernel@vger.kernel.org pbonzini@redhat.com sea=
njc@google.com syzbot@syzkaller.appspotmail.com vkuznets@redhat.com]
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
-upstream-moderation/6a2dbe63.8812e0fc.3c3fa4.0009.GAE%40google.com.
