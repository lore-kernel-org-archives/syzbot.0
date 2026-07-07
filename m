Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C3B37647E
	for <syzbot@lists.linux.dev>; Tue,  7 Jul 2026 21:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783459539; cv=pass; b=jjtk/Nf8Xm6vmxStxVsqBlBKivT7ocQgFaMNNXHSo6EWxmUqio37bMWGJZhb9vpmkeqsz65PaiWk8BmDKtEEMXvj794jIY/YHhwYtuahO8Te+HyD6uZuQOCggrF2Iylav42I1m8nFKbarSvK+iWKCsTOuMDKvWinT6VrGC/QUOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783459539; c=relaxed/simple;
	bh=pOdXM2oymvr/smId1Omver3teKkaw9mprd4E/4+VOz0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bEohe6aYi96Wip2j2pWBQAkj0fFl5slfiN1ioMozyBh7PG9ZJCgSPPJ/5oEzTNgEB5i1ok06FXVcKi54huObie0P5psZOS/TvclRQG3i3FfEbFvQdN++t9WDv7GtagX5r8+fFPV1cFNTXX3z6psZ+pLi1OJWc1BlRgpIC7aPUXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uQYbYSO9; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uQYbYSO9"
Received: by smtp.kernel.org (Postfix)
	id E624E1F00A3A; Tue,  7 Jul 2026 21:25:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.214.201
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1783459537;
	b=S+/0lAHfbT0RYo3UMxMHWVQKA2j5cgzHLwpBRvrxzxvqLmnrz/rHd1fMimzraotuhHjC
	 q2wIsGnOZeZKCyKzdr7cqdUhhi7ecyeKRuI1h67XYaEfuY84KJ+PIbjXcJdYlM9Z1XsPE
	 xQyeXuwOMWXQJV3vsn8PlXHq4AmNbkJG1t+lvzXMUFKkKlHeq+38cYftHnzE/rxuEWezp
	 JdQO2140QCAQkJDSGjn4Tv2dO4muRkIriiy81saCff0lkUADA6Vnr8Wc1nc8oSKc0nD69
	 cVZLNOlQ7ewGygM1Q5WfXRDBa3dGCjG6EQlNNug9ikezSItoWkhgGACvNkzsOUhhOUQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1783459537;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=ZUVoSE8UgGc/A9+Kf+89pNsJjY/CmRXkhT+zbp2ozz0=;
	b=kKzB4GvfB/XWDLqWC/sIfyYFQ6rCUqJgaq9+LdmssCNZin7mKWRgNXatz0+hRdnUt8Ij
	 KbjdjyZ8r4x5s7aIkf3jHEru1KwE3VDj2N+iJY+QLbRPmk5sN+XX6LjSF1mJxSl0ijogo
	 sm9uTmyD96sz48e0g/bdf/c57Lre8cvzaHOJM4SzcnTHceEdTwrCoAl9dXHNgET2b8OnH
	 BH5EZe5lOAF2uaxm8bGnS6QnuX0Pw3KgsE8j3p/EI4LRc8CK+YKVe2Tt3jdVy+E4MpouR
	 anPRQtOqrOmqX+iqgPp7R0X4whc1uOofYMNfLeIrzT7B7KQRkukEor8CjmVJenGdkjw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=uQYbYSO9;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com;
	arc=none smtp.remote-ip=209.85.214.201
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 56D591F000E9
	for <syzbot@kernel.org>; Tue,  7 Jul 2026 21:25:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=uQYbYSO9
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 56D591F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2c82843005eso768895ad.1
        for <syzbot@kernel.org>; Tue, 07 Jul 2026 14:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783459536; x=1784064336; darn=kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZUVoSE8UgGc/A9+Kf+89pNsJjY/CmRXkhT+zbp2ozz0=;
        b=uQYbYSO9aMJq9Cbj008vndFr848x0uJ8brseHURw63vUb22B+83Ob5rB+jPqwZGddz
         V65oK1aMhusZwukFfAiJe2uBlcODTYGD+wOdKugbcRyBvfQ5INhe6s1p6OkJ1Vw53bWI
         wd/o5tA+ZcxgKDjxIoQfYkj8yHEYNBb8rK15eTnOwy6QbgXCQ5wNrpzhvgUUO91ILJnR
         9yLVA0rz8mPLifkTadvfGAk0u/WP6V3hxKfq95PseyRigN30g2oavQxWlvURe9p6rfYV
         K+tgPc8D5f2UqOjEguoMTWgHC6YhpLgjb7zMwCXg/Z/5fMPhocuaw+BqLF3+P6RKczgm
         loaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783459536; x=1784064336;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZUVoSE8UgGc/A9+Kf+89pNsJjY/CmRXkhT+zbp2ozz0=;
        b=WOAGbd8JV6CAHQpQbJ9I3Xc3NlB0RasuHyw+Zdiu3Wxj/UOJz7rfG7lKQ6p6Y+QTs5
         ac8a1TfquQV8gM2mc+YjcvMAWtdqPDyiwE8zF4QzNWsnHJkNkHfNJpDIJ5c2xoXESNPM
         tey4TPFQ6FpXbS4+UzubsU5jaG8+swa9MhOTKztFlX/jFQTGu4fCvTkAqU5WzO535456
         9T7YY3RvPtyC2iADRxWxfBYyfb2OPmft73q3WuB8sIOIIVTx/WzhRG7VQEA7V8Cy2sm4
         5qM+LWJF6GWilkhBp7bgvKGX5OZlaGqC5U+kHKT1lNZcaekg3a6CdSHlkHn4mT313sNR
         zkLA==
X-Gm-Message-State: AOJu0YwNip8rxgHsbWS+PrtR2Os+va1PWlAyEFvISc5YRxGfO0Qr2yv+
	gjjpdFoiru+yBlf7MREEVv4dYZVmV/DAD176LbCwNsWVwuIXSKQ6I1jDEBuezXqMZn0kA5Y7FA2
	HuvrXtA==
X-Received: from plpn4.prod.google.com ([2002:a17:902:9684:b0:2cc:8aff:d1e5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:248c:b0:2ca:11af:5ee9
 with SMTP id d9443c01a7336-2ccbf0515c7mr46279875ad.25.1783459536408; Tue, 07
 Jul 2026 14:25:36 -0700 (PDT)
Date: Tue, 7 Jul 2026 14:25:35 -0700
In-Reply-To: <20260625212001.3B6561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <86078441-92eb-4461-b823-7d3539ac5859@mail.kernel.org> <20260625212001.3B6561F000E9@smtp.kernel.org>
Message-ID: <ak1uzySYz-i1EImO@google.com>
Subject: Re: [PATCH v2] KVM: x86: Exempt in-kernel PIC from "disappearing"
 interrupt warning
From: Sean Christopherson <seanjc@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: syzbot <syzbot@kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 25, 2026, sashiko-bot@kernel.org wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> [ ... ]
> > @@ -10857,7 +10857,9 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
> >  		if (r) {
> >  			int irq = kvm_cpu_get_interrupt(vcpu);
> >  
> > -			if (!WARN_ON_ONCE(irq == -1)) {
> > +			WARN_ON_ONCE(irq == -1 && !pic_in_kernel(vcpu->kvm));
> 
> [Severity: Medium]
> Does this inadvertently suppress the warning for APIC bugs in the default
> full-irqchip mode?
> 
> Since pic_in_kernel() evaluates to true when the in-kernel PIC is present,
> checking !pic_in_kernel() disables the warning entirely for all interrupt
> sources in that configuration. This appears to contradict the commit message
> intent of preserving the warning for other sources like the APIC.
> 
> [Severity: High]
> This is a pre-existing issue, but can a malicious guest still trigger this
> warning when KVM is configured with a split irqchip and Xen emulation is
> enabled?

Argh, yes.  

> If a guest concurrently toggles its evtchn_upcall_pending flag in memory
> while the host executes the event injection loop, it seems this path is
> directly reachable. 

Even more coarsely, userspace could disable Xen event stuff entirely via
KVM_XEN_HVM_CONFIG.  The easiest fix would be to condition the WARN on
!IS_ENABLED(CONFIG_KVM_XEN).  We could track if the VM has ever used Xen
emulation, but I don't think that's worth doing given that many deployments can
and should disable Xen emulation.

The other annoying issue is that vmx_check_nested_events() has the same flaw.
And I definitely don't want to toss that WARN either, because it recently found
a real bug that actually matters.

I'll send a v2 in the near-ish future to weed out CONFIG_KVM_XEN, and fix the
nVMX case as well, hopefully without having to duplicate too much code.
