Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342803F7875
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 13:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782480303; cv=none; b=gJegReRocBVlsbk1lCwNxlWXJWX/72LLarHmG/2/ChFEIH6PhY5mqDiosAHe5H2zYr5dHhU4UrJvAhWcTXshtNgY79s91xzfrtGzO0QnNgwiIgOZTQ9y8tEVAADy2HnNvE/SPw61QBfUUXzOnh7KaJTmDkT4ILkzFWMpE5F6hhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782480303; c=relaxed/simple;
	bh=QFbAfw5bUBeltg9R/TJZjZDHodgBuvpaHaNMXChpQkc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qGi3LCdMTH3lUTFww2gOkG7pREmuVehZ0I7c9qM9W7BTixrQX53Rf7uuPnE72CtS0j7HZzPr93sP3Yu4Gmqf7PTFoZjveZgNTPM380lsMUHzJjTKyX3hOQQK2xE59kRtcysg6vHIcR5Kv3bMLxEwESWkHUiX+bWGVlsZ1jIDB+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VDq3/NdG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VDq3/NdG"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2bd04e4fe3dso17072015ad.3
        for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 06:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782480299; x=1783085099; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p3qRohislCxr0zH3IYymabMtFAGnZkTlHrF4Ptfedn0=;
        b=VDq3/NdGkU1eyJ0Vjtwpc6pvNTjSmvkkfKWwd00WTM3o0J3gex7u6tmX2PX4nuCFUT
         M24MDLNIUaJjC2ryjRIRFNq6AP2q3rYYMaXgQH0uNNWzu2P9oXWChDPFQOuOH0+Yo4qW
         72wcXVX963c+iY93aOqjRUyEINwk3nM6jdFMIpxJqCgf1jBOeITCUiC/JNbHFsV6fXvV
         JFb2oUUXmMqCOuYhrdOwRjk29szYTM2kOaQIDKvihyEAgRiaUuvzMfK4QN2CXJxEYD3F
         wySwaAhGdEYbW8vjlWntjuVYI7zq9gL3x0bV/Nj/3IS+B2KeWXlEy18nlLEpM9m5pDBs
         ECjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782480299; x=1783085099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p3qRohislCxr0zH3IYymabMtFAGnZkTlHrF4Ptfedn0=;
        b=og9CMKRNuGNiosODMF2Lye36XUVFrIW8/PpwuBGirEu/pgq1fltewsAN/gsZ1jXhxP
         3P6f5kB41ZD6iIQyhIHhHauEnIkioEtmUkFnrDvzV0sVb0IdtlS68iZwEZa2n2BFwG4T
         ofdsdCfVv1SAo0OKic4yTqVvHxPxKxIe4Ja0w+ye7bKNixkeG0s1B8DBcVdy/MpwMncE
         2aBQACYFH7hoRqh4yL/uUxhVsQjNSkD3i7DTOxqBUas+n1cpEEHj7UZ93zUfzRBTlV/y
         ACh1CxCo6EEuvSmyGAuHaDQ44fuVb3AdAjjLdFKySQOO2P8Pmu2wcLhkUgTBHTuxaW+4
         SFBA==
X-Forwarded-Encrypted: i=1; AHgh+RrCnadSwIElRSABwyiel0+sLra94YNAyJ2W/yQo0QT4f5k+ZuBoK08wnCkeaK/SBTK8ghCoGqg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4hhVvi9dW5THod6YqFWhz940Fx22DFykH/9bYE5LLC1zfN/Ho
	oprtypcGE1lQzwBJmakWZg0kLwfPBkHMYqGWgbIyPo+QxImLBM44OiXXYJpjGdZ8BVZr8yNjgLF
	LG1+MBw==
X-Received: from plblv13.prod.google.com ([2002:a17:903:2a8d:b0:2c8:7ed:acf4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:6b8a:b0:2c9:97a9:2099
 with SMTP id d9443c01a7336-2c997a9212bmr140195ad.45.1782480298846; Fri, 26
 Jun 2026 06:24:58 -0700 (PDT)
Date: Fri, 26 Jun 2026 06:24:55 -0700
In-Reply-To: <6a3e24ff.bd346d9a.250aae.0008.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260625223623.3376478-1-seanjc@google.com> <6a3e24ff.bd346d9a.250aae.0008.GAE@google.com>
Message-ID: <aj59p5e2aa1ir1_O@google.com>
Subject: Re: [syzbot ci] Re: KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
From: Sean Christopherson <seanjc@google.com>
To: syzbot ci <syzbot+ci6c27aad5db86e5b9@syzkaller.appspotmail.com>
Cc: dwmw2@infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	paul@xen.org, pbonzini@redhat.com, syzbot@syzkaller.appspotmail.com, 
	vkuznets@redhat.com, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 26, 2026, syzbot ci wrote:
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || vcpu->vcpu_idx < 0 || !refcount_read(&vcpu->kvm->users_count))
> WARNING: ./include/linux/kvm_host.h:996 at kvm_lockdep_assert_vcpu_is_locked_or_unreachable include/linux/kvm_host.h:994 [inline], CPU#1: syz.1.34/5967
> WARNING: ./include/linux/kvm_host.h:996 at to_hv_vcpu arch/x86/kvm/hyperv.h:79 [inline], CPU#1: syz.1.34/5967
> WARNING: ./include/linux/kvm_host.h:996 at kvm_hv_vcpu_uninit+0x198/0x210 arch/x86/kvm/hyperv.c:906, CPU#1: syz.1.34/5967
> Modules linked in:
> CPU: 1 UID: 0 PID: 5967 Comm: syz.1.34 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:kvm_lockdep_assert_vcpu_is_locked_or_unreachable include/linux/kvm_host.h:994 [inline]
> RIP: 0010:to_hv_vcpu arch/x86/kvm/hyperv.h:79 [inline]
> RIP: 0010:kvm_hv_vcpu_uninit+0x198/0x210 arch/x86/kvm/hyperv.c:906
> Code: 48 89 df e8 0a 55 d8 00 48 c7 03 00 00 00 00 eb 05 e8 5c 16 6d 00 5b 41 5c 41 5e 41 5f 5d e9 ff 16 4d 0a cc e8 49 16 6d 00 90 <0f> 0b 90 e9 65 ff ff ff 48 c7 c1 e0 bb 2f 90 80 e1 07 80 c1 03 38
> RSP: 0018:ffffc9000390f960 EFLAGS: 00010293
> RAX: ffffffff8158e9e7 RBX: ffff8881bc192880 RCX: ffff88816ac70000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff888101fa1743 R09: 1ffff110203f42e8
> R10: dffffc0000000000 R11: ffffed10203f42e9 R12: 0000000000000000
> R13: 00000000fffffff8 R14: ffff888101fa1740 R15: dffffc0000000000
> FS:  00007f47c1e886c0(0000) GS:ffff8882a92b6000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000c64000 CR3: 000000016a5e7000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_arch_vcpu_destroy+0x1a9/0x380 arch/x86/kvm/x86.c:9413
>  kvm_vm_ioctl_create_vcpu+0x615/0x990 virt/kvm/kvm_main.c:4269

This is the same thing Sashiko pointed out; I completely botched the cleanup if
vCPU creation fails.
