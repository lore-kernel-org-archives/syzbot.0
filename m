Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4441131A56D
	for <syzbot@lists.linux.dev>; Mon, 15 Jun 2026 18:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781548669; cv=none; b=nMt1umDEgsp7nzjGSkh+jlCMXHUt6mjOnIR/DCDI4/XZKpRzY3aqWMDYmVvo/GdyW6zK7fSjKsEn1MbTP4FYnHbhnXKuH9x8JsjVi7LljVoPjGnqWm1lJcg75+k/AvXMJbrERPEIVU+f7AzisL9TNDY2egoK+E2iXdrvnGlK97s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781548669; c=relaxed/simple;
	bh=xjBtda5yQylDR43xaldFv16csYNrCOOieWasSqFyZII=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IglbwLAq67V+G82t5anqhNk9xvoEr7692XB2jmTGbFpn9PgNY6drge4orbuTCzNeoDVv7r4EDHPUF7gAOfXQZwO3PhgHVuq9rJYJ9P0yB9crXo04k84/4oAEkSK18+QnCOYE24mdFC4mqbk3LQKGgDPajuzAVQQi03l1zURTWj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WCC4IFmZ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WCC4IFmZ"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c85a2bf5388so1774115a12.1
        for <syzbot@lists.linux.dev>; Mon, 15 Jun 2026 11:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781548667; x=1782153467; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CiMgdwm1uK8wMIHpR+UI3R9OpwIEA1Of5OYuzODRAHc=;
        b=WCC4IFmZHAiuaCooYJBAUFk/8DFtRkBi7+1e8SVBeuMBdR6wT0IP65eyvnZ/QzOa+w
         c7AMyYsDFNCvMgXM3/ycja+oyI+3gjpkzxf8puSHkhKmuMLD/j0gIAbAakOrlKWn4Y7R
         Qv36dt+P0BjvHJsTILqU0OOVuKfI80bOMPL5Bm7A//Ggf7mjfDQRQsNoC19Hi4QTe7zZ
         2SVDOyW4iRgVEC9mBiv0URxtcZnwQqpXEqBd9SHdQrnp36pGwuxVNOMg7YI+Rd8F0ng7
         bivXrdeeZTx71kHh2A1lfKm/JVItW5VpfyUP0ev51KtHiWy2+8sO1C2avXw5PNN0N8bp
         TH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781548667; x=1782153467;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CiMgdwm1uK8wMIHpR+UI3R9OpwIEA1Of5OYuzODRAHc=;
        b=I5jTjd74llrusmYpjjBqbzsp8zw//LfU75rVz3vec3hop+DMPVQaIUDlrwJKLfAoSD
         T81/nHzlXB4tk5azJM2O3G2oMAFz91K8bMC10oGTIIZhUJc5kFjs0zZeLDa/8vXmJEaD
         vsh/2s87kj30rze4nyjuYh6ASh/hz3MZlpu3C1sp8C8MEfhem9NHMOQ6CH509JIH4bHa
         XhVvGPiUo8UQKEcZt4JXEjZWMkSzjbmCMJVexF2Wq7b9LcOj7Fceq21t5qI0270VLofa
         DBOfNUc795/FUtiYulCB1DwpWQuoDrisvCjOKlYdUXvnfHQ8N6HW5zUT/sNxSEX9EMpR
         xDeg==
X-Forwarded-Encrypted: i=1; AFNElJ/JT5J5p2W4kMlHTw3dIUPQQsy12Ummac5KjPVIrvwQdQdVSnwHJTDc5A4QM/rGmSbmnFK2EF4=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywv3ChpbXbarg200uA9Cmr18t5vTmV+Y+OrL4ys3pDnJGiZr4WO
	NQOxle7/RjW33FMhfmnbaumjSYBaH9PGkMItgoJD+CFrbdWqSbTXr3CO4VkgNws+TdfidH8RmjV
	4Ur95/Q==
X-Received: from pfbmc1.prod.google.com ([2002:a05:6a00:7681:b0:842:b0d3:e4d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cc97:b0:39f:82bd:298
 with SMTP id adf61e73a8af0-3b783587375mr16591062637.0.1781548666395; Mon, 15
 Jun 2026 11:37:46 -0700 (PDT)
Date: Mon, 15 Jun 2026 11:37:45 -0700
In-Reply-To: <79c59d84-80bc-41f6-950f-41ff2e6b2b5b@suse.de>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610214523.2905255-2-clopez@suse.de> <6a2adf3b.3b0a2d4e.8c8d1.0012.GAE@google.com>
 <airudX6N4oL5X_wE@google.com> <79c59d84-80bc-41f6-950f-41ff2e6b2b5b@suse.de>
Message-ID: <ajBGeUyhVM1-SI33@google.com>
Subject: Re: [syzbot ci] Re: KVM: x86: Unconditionally recompute CR8 intercept
 on PPR update
From: Sean Christopherson <seanjc@google.com>
To: "Carlos =?utf-8?B?TMOzcGV6?=" <clopez@suse.de>
Cc: syzbot ci <syzbot+ci493c6d734b63e050@syzkaller.appspotmail.com>, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, osteffen@redhat.com, 
	pbonzini@redhat.com, sgarzare@redhat.com, stable@vger.kernel.org, 
	tglx@kernel.org, x86@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026, Carlos L=C3=B3pez wrote:
> On 6/11/26 7:20 PM, Sean Christopherson wrote:
> > On Thu, Jun 11, 2026, syzbot ci wrote:
> >> ------------[ cut here ]------------
> >> debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || !refcount_r=
ead(&vcpu->kvm->users_count))
> >> WARNING: arch/x86/kvm/vmx/nested.h:61 at get_vmcs12 arch/x86/kvm/vmx/n=
ested.h:60 [inline], CPU#0: syz.2.19/5879
> >> WARNING: arch/x86/kvm/vmx/nested.h:61 at vmx_update_cr8_intercept+0x3d=
e/0x4e0 arch/x86/kvm/vmx/vmx.c:6879, CPU#0: syz.2.19/5879
> >> Modules linked in:
> >> CPU: 0 UID: 0 PID: 5879 Comm: syz.2.19 Not tainted syzkaller #0 PREEMP=
T(full)=20
> >> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian=
-1.16.2-1 04/01/2014
> >> RIP: 0010:get_vmcs12 arch/x86/kvm/vmx/nested.h:60 [inline]
> >> RIP: 0010:vmx_update_cr8_intercept+0x3de/0x4e0 arch/x86/kvm/vmx/vmx.c:=
6879
> >>  apic_update_ppr arch/x86/kvm/lapic.c:984 [inline]
> >>  kvm_lapic_reset+0x1c24/0x2980 arch/x86/kvm/lapic.c:3023
> >>  kvm_vcpu_reset+0x44c/0x1bf0 arch/x86/kvm/x86.c:12986
> >>  kvm_arch_vcpu_create+0x746/0x8b0 arch/x86/kvm/x86.c:12847
> >>  kvm_vm_ioctl_create_vcpu+0x428/0x930 virt/kvm/kvm_main.c:4201
> >>  kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5159
> >>  vfs_ioctl fs/ioctl.c:51 [inline]
> >>  __do_sys_ioctl fs/ioctl.c:597 [inline]
> >>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
> >>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
> >>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >=20
> > This is "fine", the assertion just wants to make sure KVM isn't access =
vmcs12
> > without holding vcpu->mutex, otherwise any queries are inherently unsta=
ble.
> > It's just that vCPU creation runs without taking vcpu->mutex, because t=
he vCPU
> > is otherwise unreachable.
> >=20
> > I'm pretty sure we can squash the WARN by grabbing vmcs12 if and only i=
f the vCPU
> > is actually in guest mode.
>=20
> Will you add this on top or should I send a v3?

Gah, I was going to say "I'll fixup when applying", but that leads to an un=
wieldy
changelog.  I'll send a v3 with this slotted in as a proper prep patch, mig=
ht as
well let syzbot have another go at it, to make sure there isn't another ass=
ertion
lurking.

> > diff --git arch/x86/kvm/vmx/vmx.c arch/x86/kvm/vmx/vmx.c
> > index c548f22375ad..332fbcd924f2 100644
> > --- arch/x86/kvm/vmx/vmx.c
> > +++ arch/x86/kvm/vmx/vmx.c
> > @@ -6876,11 +6876,10 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fast=
path_t exit_fastpath)
> > =20
> >  void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
> >  {
> > -       struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
> >         int tpr_threshold;
> > =20
> >         if (is_guest_mode(vcpu) &&
> > -               nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
> > +           nested_cpu_has(get_vmcs12(vcpu), CPU_BASED_TPR_SHADOW))
> >                 return;
> > =20
> >         guard(vmx_vmcs01)(vcpu);
> >=20
> >=20
> > Longer term, I'll work on figuring out how to handle this in get_vmcs12=
(), because
> > to_hv_vcpu() has the solve the same fundamental problem:
> >=20
> > https://lore.kernel.org/all/aeqRzanSaa9P_EPg@google.com
>=20
