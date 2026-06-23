Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD18838BF9A
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 10:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782210539; cv=pass; b=Ypd8X4LsTjF/e+/6Sy0uyu3OTWpthB7thYnFrqp63d6NIOiHz2lrCrv3DgoGkyJVogyaSo0mqdimWyd5ZNDFM5vsR97ymNRZLnvKRs5PDLTa4Ayzm39kxZ5SP1wrF3V5NpXketjxf2fbP1EjnDxogBWMv2qgP2KChRGGRgfeW10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782210539; c=relaxed/simple;
	bh=q6oGLROKZFgcb1FlDHhCTf2hyeCfpWCPiDhOB3R9gX0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCeGeYDcxaWDoR1cio4BhlLKDops30Hg0tQH6AwJ0VtVIFkYo2R1QwfSpnSA1LhdDQt4+2KZIpkn+vNRdgZDgIODzVsmWZxvGw5b8+5Fq7dnqL7x6VSa07XWLLzWUQXH6XEIxpY5KZEjUR7HGx0HAzv4cnDOxj0TnjHoHrF9JVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hwc5pp2o; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hwc5pp2o"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-43d3427401fso3872904fac.0
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 03:28:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782210537; cv=none;
        d=google.com; s=arc-20240605;
        b=HVkJqJjwmOVa3uHe9lUMcNYQwLAwN6v8ErV83owAT/2SpFT92/lYCNOZw7IgoilmcF
         GTZK/TsfEYWTMYSrJGEzfYVM3c+1fhig+bPxfi00JutaS1LM4rKyaplvk7Fc8erFLg+b
         UqYV/wGTNUS82kZl1VR/kMIsj/GIsBsH0C2e6xXCYc+Q3soW9YxrKUVTcomUuDFY7n4Q
         9bLX9mpEqaykzbFFgehkjlSDwGfHDRUWu4kN6cQMWMejOhiR6fTkUzLRIB4JyBExDUKS
         2VB3WeLggAuIz3RIggf2C1u6joAfkR1IXcMaY18+SLQ3W+R22ZUiCA8krLOTS43QPa0f
         6L7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a75VcYk3xco3LJ3XhEM2YIhLCnfZv9pelal/cRwUp2A=;
        fh=iMgEmg0/OkdeMZMbp/3i6oJb2wydwfvJMMdGoRl/Sx4=;
        b=Cm0kUFwPEKpRpw+8fUbksTrz+IcputcyFh8RU+m9s7twb8KULe7UdrBmIT2EzccC7I
         qqEhlcYObHHw/V4zxz9ZtDR2NU+8wAU84r4hBwIQc079w8dXnPQ+/0e/WfZJdy3eQZcK
         vmYK/b/30IWLSYCKyX9BlKW5vZXITYx9+1r2rH340oeMlixJd6S6LxpkF6V2CmCqRsbZ
         UmrKPmSNU86CRhtdmNUHmjdf8PQqZXMrOv+LWQ1f+Q1NlBKN3KBdB8BPNas5xoMPZOUD
         8QW5PJPxERWNsMRExbB+aIRkZHmW3O0Ne46uVoskxI8x87ngKsIr4pe47yPwVNwflvCo
         J2VA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782210537; x=1782815337; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a75VcYk3xco3LJ3XhEM2YIhLCnfZv9pelal/cRwUp2A=;
        b=Hwc5pp2oQTLZAXaNodwSIfXOyQU/xZ0ur+dWpSxfKI+6n+8TRtUmu3GogLfa66jgOZ
         W0Fd3S4pqhwLVvDlxTsUdXa06PIb029107zZ6ivmQlX0HedCMqg223VexZr7I1WegmIW
         Re5uBdA7OLhUYeXjIklK5nWuUChWzd5qCtC/UO9bixQ/juG8GRs+Piv3DW+G+S0OCQx1
         fkxFMq7KFrY+3lk47XKFvwf7RgbcqgAaOWHkhDQ4dGcgCiTL8an8y//hREnfisBrHr05
         xdX+8zTJUEWx/Z7p5wYOY/bgUu9vMD5sEjdMKPSFo1KCFmxExGV2cynJ+SrldKEmHVlc
         CRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782210537; x=1782815337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a75VcYk3xco3LJ3XhEM2YIhLCnfZv9pelal/cRwUp2A=;
        b=mcQMumEYd3w5oc7kjOycM5G7B4RVn8Uidx6lnESOf+sor49JeLd7B5AdQhqNdppMF5
         v22gzC1mB7ck3smt8j2Birx4UpAHsIYkx9AfL/bDaAikFCYCPQzydnzd4kUMfHBkMPU9
         8D450wD29kCcJAEaJ7XqxGDyHuddy5iK5GW8TNnwj6Cpc9niwFW92R7TcCtVUD7L218Y
         nPOEvppUaRkf6D5NXwY1GPfXFhe6T5G5vNxlIyS/umOpm7ER51FIUjsXAQMYBUPprP9j
         GS+B7qSZi6MKwUJT06sALLe6xa+KJ/m+W6rLE5jSj5JKuEXAg04SVTHZsgrfsDZCeGqC
         AfSg==
X-Forwarded-Encrypted: i=1; AFNElJ9ywPIfiPkGfi2CQTtzjLYhhGh1UOFfc0OqmVj2TAyOvO5Mn1sAuA2J1Ddshq+nRuHAXAnSYls=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVbJUWSydtE5erLl14cbuicz2ECeKixgSciVs/NpUnxONL+4Pj
	NDZsRIDsuTJdxZtczjZzChCbRo+u2RFFuvHLVire+/FQWLTX5JHWMK2VuX/Wh8DXT8kwWWv1/18
	Oilm/eV+Kxf7fnHCpE0GVPuhcSUEQJ6KGQ2dPlobM
X-Gm-Gg: AfdE7cki6h0O/Tth6K1y3lPr8drLN+iZXxP4s8/P3e9t4m2hry206bxqxMdTdNmKcB2
	FKd0u1/OIpibxd++xo2xGVUAbdkKiW2IeeFzjvejnrYD0jwp017qH9ZGo4Rl11T2z/eC6BVryx0
	5Us0ivFDTkYCrb8sBuZ1oaXmLjy6LjGp2YkrPVBCkLDD3TKYmv/utTJ9X65UcrJiW11ByJpILUA
	7X8rsoZF7CegpNfTBRRRGwa613OKrY7f2lShHUDuTIu/6jGu6oh+jmfgj/oAyqUfEUbxo2tKuGK
	QQGIYjfe4rvYEovjphOYFwyz2jGyq/JOt/Gf+FUuRA6lUjkeooutCAo5Sa/ZkBGUAwUi9E81eJJ
	JAXlbUkewBynmnkEjfSJyn0l2N0zNVR0XcoIYkCk6hjTYTJ3gXVY=
X-Received: by 2002:a05:6871:de:b0:439:f6c7:586c with SMTP id
 586e51a60fabf-44707df99dbmr14440742fac.25.1782210536126; Tue, 23 Jun 2026
 03:28:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <077c14b4-6f79-45a9-9b11-bd625c8ecff3@mail.kernel.org>
In-Reply-To: <077c14b4-6f79-45a9-9b11-bd625c8ecff3@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Jun 2026 12:28:44 +0200
X-Gm-Features: AVVi8CcpaeWgJTaNZBVWtCgXS5q-mIOI_n00dQGLoCambWvGGbHQ1DzBLBY5yeM
Message-ID: <CANp29Y7xpSf3BvLtAWakKF5=oC1Qxvo0En344Un+GK3xUsc1kA@mail.gmail.com>
Subject: Re: [PATCH RFC] KVM: x86: Drop WARN_ON_ONCE() for concurrent PIC
 interrupt deassertion
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Let's try again with
https://github.com/google/syzkaller/commit/36faab20efd417e2f41d35311544bebb=
8e3af80e

#syz reject

On Mon, Jun 22, 2026 at 6:19=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A false positive warning can be triggered in kvm_check_and_inject_events(=
)
> and vmx_check_nested_events() due to a natural race condition when a
> level-triggered PIC interrupt is deasserted concurrently with vCPU entry.
>
> The WARN_ON_ONCE(irq =3D=3D -1) in kvm_check_and_inject_events() was adde=
d to
> catch cases where kvm_cpu_has_injectable_intr() returns true, but
> kvm_cpu_get_interrupt() returns -1 (meaning no interrupt is pending). The
> assumption was that this could only happen due to a KVM bug. However, for
> level-triggered PIC interrupts, a concurrent deassertion by the device
> makes this a perfectly valid and expected scenario.
>
> For example, if a device asserts a level-triggered interrupt, the IRR bit
> is set and kvm_cpu_has_injectable_intr() returns true. If the device then
> deasserts the interrupt before kvm_cpu_get_interrupt() is called, the IRR
> bit is cleared, and kvm_cpu_get_interrupt() correctly returns -1.
>
> A similar issue exists in vmx_check_nested_events(), where
> kvm_cpu_has_interrupt() is checked first. If it returns true because a PI=
C
> interrupt is pending, but the interrupt is concurrently deasserted, both
> kvm_cpu_get_extint() and kvm_apic_has_interrupt() will return -1,
> triggering a WARN_ON_ONCE(irq < 0).
>
> Remove the WARN_ON_ONCE() macros in both functions, as WARN_ON must not b=
e
> used for conditions that can legitimately happen, and pr_err() should be
> used instead if necessary. In this case, no error logging is needed becau=
se
> the code already handles irq =3D=3D -1 gracefully by skipping the injecti=
on,
> which is the correct behavior when a level-triggered interrupt is
> deasserted before it can be injected.
>
> ------------[ cut here ]------------
> irq =3D=3D -1
> WARNING: arch/x86/kvm/x86.c:10860 at kvm_check_and_inject_events
> arch/x86/kvm/x86.c:10860 [inline]
> WARNING: arch/x86/kvm/x86.c:10860 at vcpu_enter_guest
> arch/x86/kvm/x86.c:11356 [inline]
> WARNING: arch/x86/kvm/x86.c:10860 at vcpu_run+0x57ec/0x7950
> arch/x86/kvm/x86.c:11770
> RIP: 0010:kvm_check_and_inject_events arch/x86/kvm/x86.c:10860 [inline]
> RIP: 0010:vcpu_enter_guest arch/x86/kvm/x86.c:11356 [inline]
> RIP: 0010:vcpu_run+0x57ec/0x7950 arch/x86/kvm/x86.c:11770
> Call Trace:
>  <TASK>
>  kvm_arch_vcpu_ioctl_run+0x1193/0x2070 arch/x86/kvm/x86.c:12125
>  kvm_vcpu_ioctl+0xa61/0xfd0 virt/kvm/kvm_main.c:4470
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
>
> Fixes: bf672720e83c ("KVM: x86: check the kvm_cpu_get_interrupt result be=
fore using it")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+dd769db18693736eee89@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Ddd769db18693736eee89
> Link: https://syzkaller.appspot.com/ai_job?id=3D8568ceee-8527-4f42-b840-1=
fd49498df2e
> To: "Borislav Petkov" <bp@alien8.de>
> To: "Dave Hansen" <dave.hansen@linux.intel.com>
> To: <kvm@vger.kernel.org>
> To: "Ingo Molnar" <mingo@redhat.com>
> To: "Paolo Bonzini" <pbonzini@redhat.com>
> To: "Sean Christopherson" <seanjc@google.com>
> To: "Thomas Gleixner" <tglx@kernel.org>
> To: <x86@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 3fe88f29b..72d434f3f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4446,7 +4446,12 @@ static int vmx_check_nested_events(struct kvm_vcpu=
 *vcpu)
>                 }
>
>                 irq =3D kvm_apic_has_interrupt(vcpu);
> -               if (WARN_ON_ONCE(irq < 0))
> +               /*
> +                * A level-triggered PIC interrupt can be deasserted conc=
urrently,
> +                * making it possible for irq to be -1 even if kvm_cpu_ha=
s_interrupt()
> +                * returned true.
> +                */
> +               if (irq < 0)
>                         goto no_vmexit;
>
>                 /*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0550359ed..af36643b9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10857,7 +10857,13 @@ static int kvm_check_and_inject_events(struct kv=
m_vcpu *vcpu,
>                 if (r) {
>                         int irq =3D kvm_cpu_get_interrupt(vcpu);
>
> -                       if (!WARN_ON_ONCE(irq =3D=3D -1)) {
> +                       /*
> +                        * A level-triggered PIC interrupt can be deasser=
ted
> +                        * concurrently with vCPU entry, making it possib=
le
> +                        * for irq to be -1 even if kvm_cpu_has_injectabl=
e_intr()
> +                        * returned true.
> +                        */
> +                       if (irq !=3D -1) {
>                                 kvm_queue_interrupt(vcpu, irq, false);
>                                 kvm_x86_call(inject_irq)(vcpu, false);
>                                 WARN_ON(kvm_x86_call(interrupt_allowed)(v=
cpu, true) < 0);
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/077c14b4-6f79-45a9-9b11-bd625c8ecff3%40mail.kernel.org=
.
