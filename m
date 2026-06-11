Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E7F423161
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 17:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781198458; cv=none; b=YycXtAjMSpislDXn0Iie1LsKLIuJJm+EyXVvMR+povrlv8fULSPvl34zNuKWBw68/qBwDvh9Dxbd1adEhnr/jR6vxY5tKG/358R5lTyyoTVFwlQPLw35n6ZjgEmlm4aP9l7ThIyE+Hq8Tn/sE1rTJkFGAaEP4eR5JD+qYnDYTLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781198458; c=relaxed/simple;
	bh=Hot4UniHs4ligl/7ejYYsuex1217fakSzNm+wlM+65E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XijGanfgLPOb9dYWEKqwwtDCl7SalWnkExbnEhopiDsfYfvSj7QTjQPW3eGMrGSsLtRkjfyb+CZniDJbW5vRvZiexzlaM8kpdjKhkcr9y4+/trrpr9X+6IBtJYp24BVXNZAAHAbaZe7aK1tKP4hEv9i2PR5isDpI/SAvA8Y5CaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YmXjN+dW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YmXjN+dW"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c0c272e532so795075ad.1
        for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 10:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781198455; x=1781803255; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9kKAnYeHG2u5wx8ciAL480Un709THxmEGRnj+zMfdq4=;
        b=YmXjN+dWub9CM2IGDCOPmGFS5BDDdtC0u3hgXTV6+IpO+aYeiIeEqJCoBHeV8b0xXh
         53O1ikptXgYF2eE8E0fCQTLPmoFuvIvAUg5SQOHyPXsk6zlVxZ03c4Rb0LpLPNf2pFuJ
         FbLwH48lcBlpcXpFplzglAcCoYc3isSxPioKxyESK3H+QelHcL+GERJ8bAnLcp8Krvci
         fT15xAczcovGUmYH103VcoDqXlv/GAxm7cxgRcrid7ljpbNx3i/AKB7czpbf1qEDRHXz
         ZcJdbwzsgLpcdEndHD8b8MIxrva6bEeFmWiRLZ7dkRVSFrl7NeQYaiT9Nbd8RKfAWXh1
         QQpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781198455; x=1781803255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kKAnYeHG2u5wx8ciAL480Un709THxmEGRnj+zMfdq4=;
        b=cwhZiQpSq1Je/ULrhI0WVtV9NN8HNkEyT/90NwQoZGvd4p03k5aCJ+hXuaLVw4gYwV
         NHdzuGtBNkf7Prb5730o8ae240nmmNvvxBmcJg/7/g+gB+X353fx4VWp0O2UTXxfhuwY
         HMpOc9/nL1UWIKLQSbhsVPZ6QG6ekdLEJhMDpy83A/oUmvCfhvdRTddUKtZdNej3wZcb
         yUfPb0HHHBz5At/tktau8EXt/wM0ywQ7NXMP10mZgBZ7y1ZiyLcSt59E1Elir5ksF+NH
         NZpF6ddnBb+wpbOQw9Afl5FJqd8jD7qrsjTiCXiqaZejxHeeuiusZ/cni2t27bE3zVGi
         6VXA==
X-Forwarded-Encrypted: i=1; AFNElJ8DxKWbjunuK2jHdW3p6CNEfSp64oC5DdglFxxjma/SNu0dtvzl5RHausdCzjP93QuPyCbO8BQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YylzlMbyiIvC5AmFESbgVRtMsBMrJgSRp88eaO/HdQrI4ositrg
	zaNc7nXdcLISgAYHQQ8inungCSR85hlXcAWLH35B+12uCPEY9LJNXQsxQpmFXPXI3ONZOXZ8AdP
	LFVbWYw==
X-Received: from pllh1.prod.google.com ([2002:a17:902:7481:b0:2b0:b22a:e6ef])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc8f:b0:2c0:bcb3:86f
 with SMTP id d9443c01a7336-2c2f18e2d19mr45384435ad.6.1781198454681; Thu, 11
 Jun 2026 10:20:54 -0700 (PDT)
Date: Thu, 11 Jun 2026 10:20:53 -0700
In-Reply-To: <6a2adf3b.3b0a2d4e.8c8d1.0012.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610214523.2905255-2-clopez@suse.de> <6a2adf3b.3b0a2d4e.8c8d1.0012.GAE@google.com>
Message-ID: <airudX6N4oL5X_wE@google.com>
Subject: Re: [syzbot ci] Re: KVM: x86: Unconditionally recompute CR8 intercept
 on PPR update
From: Sean Christopherson <seanjc@google.com>
To: syzbot ci <syzbot+ci493c6d734b63e050@syzkaller.appspotmail.com>
Cc: bp@alien8.de, clopez@suse.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	osteffen@redhat.com, pbonzini@redhat.com, rkagan@virtuozzo.com, 
	sgarzare@redhat.com, stable@vger.kernel.org, tglx@kernel.org, x86@kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 11, 2026, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v2] KVM: x86: Unconditionally recompute CR8 intercept on PPR update
> https://lore.kernel.org/all/20260610214523.2905255-2-clopez@suse.de
> * [PATCH v2] KVM: x86: Unconditionally recompute CR8 intercept on PPR update
> 
> and found the following issue:
> WARNING in vmx_update_cr8_intercept

...

> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || !refcount_read(&vcpu->kvm->users_count))
> WARNING: arch/x86/kvm/vmx/nested.h:61 at get_vmcs12 arch/x86/kvm/vmx/nested.h:60 [inline], CPU#0: syz.2.19/5879
> WARNING: arch/x86/kvm/vmx/nested.h:61 at vmx_update_cr8_intercept+0x3de/0x4e0 arch/x86/kvm/vmx/vmx.c:6879, CPU#0: syz.2.19/5879
> Modules linked in:
> CPU: 0 UID: 0 PID: 5879 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:get_vmcs12 arch/x86/kvm/vmx/nested.h:60 [inline]
> RIP: 0010:vmx_update_cr8_intercept+0x3de/0x4e0 arch/x86/kvm/vmx/vmx.c:6879
>  apic_update_ppr arch/x86/kvm/lapic.c:984 [inline]
>  kvm_lapic_reset+0x1c24/0x2980 arch/x86/kvm/lapic.c:3023
>  kvm_vcpu_reset+0x44c/0x1bf0 arch/x86/kvm/x86.c:12986
>  kvm_arch_vcpu_create+0x746/0x8b0 arch/x86/kvm/x86.c:12847
>  kvm_vm_ioctl_create_vcpu+0x428/0x930 virt/kvm/kvm_main.c:4201
>  kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5159
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

This is "fine", the assertion just wants to make sure KVM isn't access vmcs12
without holding vcpu->mutex, otherwise any queries are inherently unstable.
It's just that vCPU creation runs without taking vcpu->mutex, because the vCPU
is otherwise unreachable.

I'm pretty sure we can squash the WARN by grabbing vmcs12 if and only if the vCPU
is actually in guest mode.

diff --git arch/x86/kvm/vmx/vmx.c arch/x86/kvm/vmx/vmx.c
index c548f22375ad..332fbcd924f2 100644
--- arch/x86/kvm/vmx/vmx.c
+++ arch/x86/kvm/vmx/vmx.c
@@ -6876,11 +6876,10 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
-       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
        int tpr_threshold;
 
        if (is_guest_mode(vcpu) &&
-               nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
+           nested_cpu_has(get_vmcs12(vcpu), CPU_BASED_TPR_SHADOW))
                return;
 
        guard(vmx_vmcs01)(vcpu);


Longer term, I'll work on figuring out how to handle this in get_vmcs12(), because
to_hv_vcpu() has the solve the same fundamental problem:

https://lore.kernel.org/all/aeqRzanSaa9P_EPg@google.com
