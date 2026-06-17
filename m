Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2FB3D0918
	for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 09:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781688715; cv=none; b=t9sXYlELGCXBL24EesnOZKUhyLpTXf20Hoq7eDN9ylPGGRvCgc0wzxp4Lpgd/Z1GzcfUglJsYjSXuxhu3m52Twm0cXi8dPjc1zxU+qh9+iVctlSGjs9IabasydpxbppIDoJMQQsgHcoSAGmLrZ8SekXNgsgHKp6KVGWiAfhiuN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781688715; c=relaxed/simple;
	bh=InkgWW+/VHDyhaoc+fT+csd/kvb5mastzqAMS5sVaxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=birBuc/hXSy5i/tTaTKXM6a/udj4aF3HM3uU2X20Nd50QQlmlPbxmUwPzNJ8PBSZF4S/SvRZZHNgadN+ap33atvQXTyU60ZgpD6+5MMJTh8GeU+ZODxQlox6ONXOpJccDeli1GU4RxV7f8XXAmN9GehrA9hZ87Bq4ubLAQfpNTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MjZRZgFR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MjZRZgFR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781688711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vjo/PuOgMPgrqc3EuUbFNwHzptbDO7oNZxgsy6X+RuE=;
	b=MjZRZgFRnTZDjU10c/Bg6t2u8s67Ira4K6oPfxd12yBtCG7TVEH29XsNjpIdXUZ1BoE6IP
	SQxRe2c7k3PH/JwUGMHSYqs38VzeqmRV/lJrVPU3yYrrMdt/2iszjbzJ16T0ksiBL0VKEb
	wUeY8P+L9VfqyUhuB5dxHQP1jzcR+kc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-fngUQ5PYNNa8Vdjd4O93Ng-1; Wed, 17 Jun 2026 05:31:50 -0400
X-MC-Unique: fngUQ5PYNNa8Vdjd4O93Ng-1
X-Mimecast-MFC-AGG-ID: fngUQ5PYNNa8Vdjd4O93Ng_1781688709
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490b8adf8b8so51722335e9.0
        for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 02:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781688709; x=1782293509;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vjo/PuOgMPgrqc3EuUbFNwHzptbDO7oNZxgsy6X+RuE=;
        b=QgBGbCYB+5Jgs7dolhvDWQ8DS24YipyNTkBwlFkjKDkeMBJs5+PuoKZ8SS2eDjstlq
         Or2DlWzSZ6dsPnYDfFfBeMAQGaQlsuvGZS+M6Pgg8sECZtiAKz08gnhxNPcv1aojHKd/
         5bfiK9/XZw9MDiT+xflbrLgs4fj+ws99Ldu6ka011Me55T7g71H1CTmnqag4HyuuTJ4T
         dbX+UZlFoDAMACXvob8G4YzPzMqx632j92kBJupox64mniS6BNu3rpSok1uzfvNU12q9
         VznAfRY4nhP0K3tjZTuc1NnujIaqTbWcNYsiLgRwhOFk3xQUDLEPdCQ2FrLzPiAu8aKe
         puKw==
X-Forwarded-Encrypted: i=1; AFNElJ9uAKhzr3hx2aPkyeyWZu9BY8+EISan2yoQu5624i5sccMwOWUFzKMV6QIBlWT9Ojz3R/sBjiw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVDBqr1TkQ3F/LR8rjB9Zw6MLM7hVkTYNHrzMZ7RFapdtAAT5D
	aJ7m0L77xy02m+88WnYr1Ck2ZG7hrHVrNbBMusWUkl9ZIAg1GSK8vBZ1i+VXgMleig4WDyUClSX
	dPSmUa1kOOD+ii5MtlmzsworjOet6413bSXj20XImZLP3ymBSjmXWDfg3aA==
X-Gm-Gg: Acq92OHIPQ4M9B/JczvMvDqPlIV/Iw11bqml9bGg8K8GGRGB0gp/hUHv2k28HBroqik
	eLxUdIFiWQSsEMUES8blcn7ZaxC1Lr9iVoWTawkjZmMHf/ZyazL3927b6f2ZB98K0wNA6xmPrjk
	EiVKwNmdTHLD0TS5m5x8uqUck/vrC+Y7BIyxuzfIZ/kpSMcH03MwJ/IqyAi25cQVnDI6pY739P4
	5O62Tqo7Kn8WciClZyLwFdWJtGbjtlv/v09Zft8bt0Pt3wo1GQ9sNdguPK3jm2IuyCewc5I+ETZ
	F4NjNED5OZxmPOrQfN7rGMhWIHthhHLBAoeuxML/IIWbwkglk7CVDTONgfIVMAtMIghMf7tvlYd
	X3/uGgzRD0oX7+vOEi37lk+Crf2obF8UFFujU4Ow5FzM+FzHHrtP64VndhsBd
X-Received: by 2002:a05:600c:a142:b0:490:b8d3:5dcc with SMTP id 5b1f17b1804b1-492333ca3b7mr41077365e9.19.1781688709367;
        Wed, 17 Jun 2026 02:31:49 -0700 (PDT)
X-Received: by 2002:a05:600c:a142:b0:490:b8d3:5dcc with SMTP id 5b1f17b1804b1-492333ca3b7mr41076915e9.19.1781688708883;
        Wed, 17 Jun 2026 02:31:48 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-135-12.retail.telecomitalia.it. [82.53.135.12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49233bf0881sm52263795e9.2.2026.06.17.02.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 02:31:48 -0700 (PDT)
Date: Wed, 17 Jun 2026 11:31:42 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>, 
	syzbot ci <syzbot+ci493c6d734b63e050@syzkaller.appspotmail.com>, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	osteffen@redhat.com, pbonzini@redhat.com, stable@vger.kernel.org, tglx@kernel.org, 
	x86@kernel.org, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: KVM: x86: Unconditionally recompute CR8
 intercept on PPR update
Message-ID: <ajJnb-Bzu4S0oOP5@sgarzare-redhat>
References: <20260610214523.2905255-2-clopez@suse.de>
 <6a2adf3b.3b0a2d4e.8c8d1.0012.GAE@google.com>
 <airudX6N4oL5X_wE@google.com>
 <79c59d84-80bc-41f6-950f-41ff2e6b2b5b@suse.de>
 <ajBGeUyhVM1-SI33@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ajBGeUyhVM1-SI33@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bQbFi-YqP-j1qgkFqUWeA-KnImkcjcoe0DagmE8Q6u8_1781688709
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 15, 2026 at 11:37:45AM -0700, Sean Christopherson wrote:
>On Mon, Jun 15, 2026, Carlos López wrote:
>> On 6/11/26 7:20 PM, Sean Christopherson wrote:
>> > On Thu, Jun 11, 2026, syzbot ci wrote:
>> >> ------------[ cut here ]------------
>> >> debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || !refcount_read(&vcpu->kvm->users_count))
>> >> WARNING: arch/x86/kvm/vmx/nested.h:61 at get_vmcs12 arch/x86/kvm/vmx/nested.h:60 [inline], CPU#0: syz.2.19/5879
>> >> WARNING: arch/x86/kvm/vmx/nested.h:61 at vmx_update_cr8_intercept+0x3de/0x4e0 arch/x86/kvm/vmx/vmx.c:6879, CPU#0: syz.2.19/5879
>> >> Modules linked in:
>> >> CPU: 0 UID: 0 PID: 5879 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full)
>> >> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>> >> RIP: 0010:get_vmcs12 arch/x86/kvm/vmx/nested.h:60 [inline]
>> >> RIP: 0010:vmx_update_cr8_intercept+0x3de/0x4e0 arch/x86/kvm/vmx/vmx.c:6879
>> >>  apic_update_ppr arch/x86/kvm/lapic.c:984 [inline]
>> >>  kvm_lapic_reset+0x1c24/0x2980 arch/x86/kvm/lapic.c:3023
>> >>  kvm_vcpu_reset+0x44c/0x1bf0 arch/x86/kvm/x86.c:12986
>> >>  kvm_arch_vcpu_create+0x746/0x8b0 arch/x86/kvm/x86.c:12847
>> >>  kvm_vm_ioctl_create_vcpu+0x428/0x930 virt/kvm/kvm_main.c:4201
>> >>  kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5159
>> >>  vfs_ioctl fs/ioctl.c:51 [inline]
>> >>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>> >>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>> >>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>> >>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>> >>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> >
>> > This is "fine", the assertion just wants to make sure KVM isn't access vmcs12
>> > without holding vcpu->mutex, otherwise any queries are inherently unstable.
>> > It's just that vCPU creation runs without taking vcpu->mutex, because the vCPU
>> > is otherwise unreachable.
>> >
>> > I'm pretty sure we can squash the WARN by grabbing vmcs12 if and only if the vCPU
>> > is actually in guest mode.
>>
>> Will you add this on top or should I send a v3?
>
>Gah, I was going to say "I'll fixup when applying", but that leads to an unwieldy
>changelog.  I'll send a v3 with this slotted in as a proper prep patch, might as
>well let syzbot have another go at it, to make sure there isn't another assertion
>lurking.

I successfully tested Carlos's v2 plus this hunk with SVSM as mentioned 
in the link in the description.

So, feel free to carry my T-b in v3:

Tested-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

>
>> > diff --git arch/x86/kvm/vmx/vmx.c arch/x86/kvm/vmx/vmx.c
>> > index c548f22375ad..332fbcd924f2 100644
>> > --- arch/x86/kvm/vmx/vmx.c
>> > +++ arch/x86/kvm/vmx/vmx.c
>> > @@ -6876,11 +6876,10 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>> >
>> >  void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
>> >  {
>> > -       struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>> >         int tpr_threshold;
>> >
>> >         if (is_guest_mode(vcpu) &&
>> > -               nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
>> > +           nested_cpu_has(get_vmcs12(vcpu), CPU_BASED_TPR_SHADOW))
>> >                 return;
>> >
>> >         guard(vmx_vmcs01)(vcpu);
>> >
>> >
>> > Longer term, I'll work on figuring out how to handle this in get_vmcs12(), because
>> > to_hv_vcpu() has the solve the same fundamental problem:
>> >
>> > https://lore.kernel.org/all/aeqRzanSaa9P_EPg@google.com
>>
>

