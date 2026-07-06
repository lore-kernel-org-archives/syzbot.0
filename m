Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3664138735E
	for <syzbot@lists.linux.dev>; Mon,  6 Jul 2026 15:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783351164; cv=pass; b=NF+gRyFOH3ZTqTvdHlUX8v838IuBYP/ahcTsL883Cbxtz7d/d4Ft841jAK+V5vRN+/Caw0ugjGSG+FgeyFHyGdcFvqliKd1PqLKvl8ytoU/EQOsGF7Uq4I0PFaIgAgAaHqfJmqZ5/YrSFclelDMf7Xy36m7ZNo14Bk3MSpQxxZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783351164; c=relaxed/simple;
	bh=ozGcv5FN6l/QjPWsw3yrkqICPzMkIRA6NslIX0KwFVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AtZyBVar7wnO2enivWKF+HHwRZOUZV0e8mU0Kedhk0sHdlXelTLmMnzP1naRjrrCIPiqaApLGIz83AzheOjbWL2sKRyOzuQk1TauNqtPIOjnCUpYRb3LHKDaOe5oAB5ZG58WZO0nztCb0OMXdBpvmjWAjd50eS5LjkLEB8/1BUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FeWsvzIS; arc=pass smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FeWsvzIS"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7ea9c6ea7deso2367018a34.3
        for <syzbot@lists.linux.dev>; Mon, 06 Jul 2026 08:19:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783351159; cv=none;
        d=google.com; s=arc-20260327;
        b=p+8HKqtCcQR++4vX5fJIPuIAluLnOlPTqixZVlipuONp3gs+1O1XkMAtgTDa756WVQ
         HVAxUuwsPK4Me+xu7eSfpDGuoiMfHMFY8QY/GSDK585xPIpDcr3CU0DYllyAftMGNt0Z
         8XodClo7kCmlAablrSbpsJ+gm2mlaqnY25pGDdTUNmdzDWJQZxMDPs+evWXYeyeaXG0b
         F/OhlmPSRkvhUlMLptWDejkQE7+bWgM/XqLkOG4eqxMGWx1yBK5KPq/rB44EPtMFp89w
         nOVZnBPjQnixL2kM3wO8Om1KwWhQiAgK4HnqbwSxtdx98JlmhQZIowrN6hCCInjJ/DRz
         vsVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rMcbmbGYZS2C+TWmlL5dGZDz4iOWGlhYzI6db/+Vop4=;
        fh=rZkOeZXE0MBkWN+mZNEzbtmlEd03fWWEpNi664hf+d4=;
        b=lPjjT/0szAiDjt+Bl/1CgYW1jr6hq548yhqNhG/dBeg9Lo8BHM3eeInX85tX+WcRbv
         6TudfQVn3MPna2MBoggI8jvMXdvXW/OXceUYyoAaPUNRHHQ3TeBKdPAxZLxP5WyFxVBn
         vDFK6CQBM5m4ArItoMnMIW19b7Tf5afXm2QtDKy/rFlQ5m1YoDkN2DIGfhgAqLsyZTSy
         aZsu7l4iqnCf/5GRzvb8t12m99biYv9U7GqpibeEN7OJQPPhhF5ZFR7kSqIIdck3uwxO
         e0j+LiKk+0OuC4vU4U7QdAXOkroapEAaLQnX58ZtQmh7V/8mT7RFmXJcpLB0NXCYdDfw
         HDFg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783351159; x=1783955959; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMcbmbGYZS2C+TWmlL5dGZDz4iOWGlhYzI6db/+Vop4=;
        b=FeWsvzIS6nnGobiJnEoilxe4zjZknlh5Fq6l4nrO8l+hRak4M5O6OCuINc7pUe/pbg
         lQRZAGfI1jE+mh8ts+6JDuA6jWn+/iNq0XoLgfuOfAk0XKOP98zGMEtQv/n7CXRLonfm
         IBYxa3/OhDPgTRFXOFwJbHPLGb3xXY2uEsxBz7xfI6nZ9GvsHgns599wWpYo9/4hoFkT
         7gFNaufcDwK3Z62iQmwLDZvSpKyJzp8Gzwp1gwbjDmL8qdkQGay+oDOGK8DTFb06ebcq
         Bqk1HAfl2oZAqB0nOy3K6G7vU1SHE6OMNeh8reTlSFn5QzfZ0BkYPjwPEURaThn0f59l
         um2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783351159; x=1783955959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rMcbmbGYZS2C+TWmlL5dGZDz4iOWGlhYzI6db/+Vop4=;
        b=KmZ5G9PyWrhvGybYRBsfnZSVsv6oSUFGYJApuEZDtg8Msk1hWUIeo4gzOmlWVfNHLX
         9gagMvyLVyBZJKratuNGYEcyAHRRyev3HoWh2z7jUqI5VxIAADmD+il/EPka8USepFAK
         qpWqYL1ZqdW9B+y+V0UvAh97O5z7ZnuxDmVpRhJnpVeIlPQP+cefXCj3b8LZyveL4uSn
         Jcy2yNTDz3Do/oceIcm9L06jisNRCMVYC1qgLCTvXoD8GvC5I8EFByyfEp7lSdy75GHX
         7/pNDsJwcRbk5dve9wZTaHT7ywYIwYEIjN4WRUjVUjRpjtsP3Mpo4cNxJRSGcCD05Otn
         q5HQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Yl6dSJ8oR+BSOFskyr2DiY9p4nbPnNa/9Xs5kfjeA9jM69Atf2DTIdqLsN839ZslSxuUhr/0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzkQ2pNADtCQsuC2RcmJoN2ZHHbVPHP+y0iRMwSZ89D5NOhj3fk
	Yp+le0PnSqh4vK0kK0sWrKNuY7vDQ9tQs3vA5i0dfFGcQH/CmVuf/6uKLzTuc8FxS31QRQdqjSr
	ncaPlPS/lwux3r5VzySHlUstDC+oJEHT218YSZjOJ
X-Gm-Gg: AfdE7cnwcYvwu4Jdq6iexxZOTE/8x2qjiVeuJhdGcVeyq2jBL9ZAOewL+B4EBUepPiW
	sU5/1IuaXn5a8PSAxdC0m9DEK+vMsQ3gFJzMG3FmCf17iTLkaHaUo/r1svH1DSI8KnJlZC4dUV/
	xFfnq7AMuxcp9uEwnYYUIQR5mN45okWwTw7wNBRQhq8ed4Q85gC2T9R8LPPjr6WxWsL9uv1ouNN
	/5rmTyPAXOgSrxF7KjRK300uoOAw4AZkx/s5bThDrKvWJT674TVSK6wGfP6USjjnvxcAjgUSlEF
	impPh6897BX1ahZ9I/+rlr8rWa78np7uG2Xoi4gbkSLaxVLK74EBEGIMASSxZ+4yxvzzwXuYLgZ
	NaRhETODUkxDZuJ9RQApgRDTugPh+MaMhQ72WARRFZw==
X-Received: by 2002:a05:6820:1b07:b0:6a1:77ce:1b09 with SMTP id
 006d021491bc7-6a35523fe26mr653850eaf.6.1783351158472; Mon, 06 Jul 2026
 08:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a4bc4de.b42ede87.8bd1.002c.GAE@google.com>
In-Reply-To: <6a4bc4de.b42ede87.8bd1.002c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 6 Jul 2026 17:19:07 +0200
X-Gm-Features: AVVi8CdWlTQAieLa1ICq8JmJHZe_OjWZArjLPXhlkk3Cj1ksmorbb94AtxaD_Zk
Message-ID: <CANp29Y7dLupcuxbXsDsjwxZ_b=8ZLemx6wKkqYCk=7RMpG82mg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: x86: Document and enforce APIC base
 memory hole
To: syzbot ci <syzbot+cibf87a6f723c5bded@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Jul 6, 2026 at 5:08=E2=80=AFPM syzbot ci
<syzbot+cibf87a6f723c5bded@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] KVM: x86: Document and enforce APIC base memory hole
> https://lore.kernel.org/all/20260706092021.3625908-2-twiederh@redhat.com
> * [PATCH 1/4] KVM: x86: Document that KVM_CREATE_IRQCHIP must precede vcp=
u creation
> * [PATCH 2/4] KVM: x86: Document APIC base address constraint for in-kern=
el irqchip
> * [PATCH 3/4] KVM: x86: Reject KVM_CREATE_IRQCHIP if APIC base is already=
 mapped
> * [PATCH 4/4] KVM: x86: Reject user memory regions covering the APIC base
>
> and found the following issue:
> WARNING: suspicious RCU usage in gfn_to_memslot
>
> Full report is available here:
> https://ci.syzbot.org/series/b02ae7eb-bae2-492f-88f2-fa1b511c93cf
>
> ***
>
> WARNING: suspicious RCU usage in gfn_to_memslot
>
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/2e25da54-5ae8-4f08-889d-30a90ffbe=
688/config
> syz repro: https://ci.syzbot.org/findings/707c5fee-46af-42c3-9700-7fc53ef=
58eb2/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/linux/kvm_host.h:1084 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by syz.0.17/5871:
>  #0: ffff888113334b40 (&kvm->lock){+.+.}-{4:4}, at: kvm_arch_vm_ioctl+0x8=
d1/0x1990 arch/x86/kvm/x86.c:7320
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5871 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  __kvm_memslots include/linux/kvm_host.h:1082 [inline]
>  kvm_memslots include/linux/kvm_host.h:1089 [inline]
>  gfn_to_memslot+0x3df/0x420 virt/kvm/kvm_main.c:2630
>  kvm_arch_vm_ioctl+0x1590/0x1990 arch/x86/kvm/x86.c:7340
>  kvm_vm_ioctl+0x8f7/0xd30 virt/kvm/kvm_main.c:5381
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd744b9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd7459b7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fd744e15fa0 RCX: 00007fd744b9ce59
> RDX: 0000000000000000 RSI: 000000000000ae60 RDI: 0000000000000004
> RBP: 00007fd744c32e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd744e16038 R14: 00007fd744e15fa0 R15: 00007ffe5f70a5a8
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
> [bp@alien8.de corbet@lwn.net dave.hansen@linux.intel.com hpa@zytor.com kv=
m@vger.kernel.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org mi=
ngo@redhat.com pbonzini@redhat.com seanjc@google.com skhan@linuxfoundation.=
org tglx@kernel.org twiederh@redhat.com x86@kernel.org]
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
-upstream-moderation/6a4bc4de.b42ede87.8bd1.002c.GAE%40google.com.
