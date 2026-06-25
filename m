Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB82331EC7
	for <syzbot@lists.linux.dev>; Thu, 25 Jun 2026 22:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782426893; cv=pass; b=EwXbZ2F01++MQRAvbhsPfpnZJ+uA779GLv4eWDdp1O3JMU6pRq3ZHPtNcg5tQ9P7OfG/oHwQFx3G5sMGuc3X/jui8hAdt3Yy9HBCzs8XWdFa9kU+2Tar7ygjcHg8O/nekgnvzqgztNPnuXVcX2Do+WEEMSBu3p9gy4+4BWSS6BU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782426893; c=relaxed/simple;
	bh=SK/9doAVjeaUXROyONWOwec6DM1U4xeSHOjmYLRHaX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QLPSdQBm34eSGDqaa/j5oZnVDE7TSPvNFfsSkiAN5mSjayT86lI6FV9G7LHtT2a/ioxNZI9EbbgClyd/Q493Qc3+H0IS1f1z6BhUh3Ub2ev/oMWjsq1agKyyAT6hTte0U7OPOhpAMX57QTCruf1ThqPTBOW0kVwSpLnCXoHAkkE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c/obDDYB; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c/obDDYB"
Received: by smtp.kernel.org (Postfix)
	id B3CDB1F00A3E; Thu, 25 Jun 2026 22:34:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.44
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1782426891;
	b=EQyr1j+iVnXyL494fNIrQWvCODlcohX9LfXLJFe7EhGKj4sYgFSPW39xaj4kvLNc323s
	 UYYDwijy6FTN5/lyuV+qFWnIVtI5oNV6OHMzgLlDai9+/sggKG+aogZg8zNVfvU80k7Ax
	 n7qcRN9gaxzmGcTEfiu75NncNfZkk0ebSF6uuNWnyuTyx9DefdqSrDOzzeoZqvDqQG+Nv
	 P1HwKGBRTPSQCT1BnhgY1aCHgC8r5N/UtZSjpuqyGrMyODiPlr874V5K5jlXuGkjaDd6m
	 a1hwDBTQAbVxs7n7LEPO3YWO9V/lrdCs2UoPksOyg0RDLt6PJbgRsBZA7UThzSIcL7g==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1782426891;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=RsOe00D0dXCtOMeOq38Ryr/BClG0oOTSp27xViUjrz4=;
	b=ZnjTJ2qYot133cd3I1NM9jpTLBfAmq3uiT/Xcm4M/5tbP7psnyn1JEx4aSL7WAeDsCNS
	 zh1CZch08LAwSHHnRZYaS8SvAwo2si2yuDs/+RtyhF/ui/pnIgtspjE3kO7XXHxHzgUFu
	 OXiKzI0bGLY5GIuK/fHO4K/668pb+A3wCYZX+6dNlNHCKk6t9f5foDKSNmvPZobCAWDsG
	 8Pd0fxAlnf63X1/WQAAE3azDBi1lTnXCkub2TTZ9YNJ4SZApau6rL9YCU1J2AnPG+yNhm
	 2ApIjdoxQ+LFJEPqFIRkgwC2HjwOekU1eNKhE/iTjJufNXb5BnoPK3cxLdESxADPUzg==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="c/obDDYB";
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.44
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F1BC21F000E9
	for <syzbot@kernel.org>; Thu, 25 Jun 2026 22:34:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=c/obDDYB
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org F1BC21F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6a11f19fcf6so253001eaf.3
        for <syzbot@kernel.org>; Thu, 25 Jun 2026 15:34:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782426890; cv=none;
        d=google.com; s=arc-20260327;
        b=jflXtNVQRIfOdLMErbPp9Wp8Tm1clEGuJtThjSNe0IiDDLUme/HX6fBXWHqEE39cxj
         J5UOPzkPA4Pl3s1ujX5vJoAywdoDsJHmOA9OdsWfnnJ3nNJWNYmrNMhTMKvkktYtLYDX
         hw9Bey1b8JgUHzJomhgIeNkdF1kgTVFf3LtwZq2q3nqfDlI7zr8zYMFIp3lXNs+VpBmi
         Xna3zOu8KcyYNtsl2ENYKIF9wCPnHMoLRqrpOQ+ExSYLuwTtd4QF3nBJKJYNLirWr5N/
         uM8njneo5j35jbJCbyH8yXlTf5N1+0zyeOiB3v2jjJoyOtKrDcVE7+0vXx813HL6aErT
         BeNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RsOe00D0dXCtOMeOq38Ryr/BClG0oOTSp27xViUjrz4=;
        fh=jZtKPfV6qTnrg0JgsCcT5aSRxPogDEOlYnOcWkx0NLo=;
        b=G8Qz7B5IjzrLR56Yr/TrSQLbWqFqyTeJuRMDC79rVlQcTwzg2ebqhdr3CRD2BVGu/K
         GiPkpdBEhpPJ59NWJWbYNnO5AKA4gosR5XEy0ZGVDJdZRdXjMtcImAC2JgV84Sj7P2VH
         4Wo8RExpIdXUd7VbyQfqliB0MmgKVQsgqaplKr2DJ9Oq6+cLEmOhPeQPFWq4UD42e6uQ
         ueQFTw1U8WhlXEPFU2o6lppsbx2JGuC48af5BOOdaWsouhspA2yrJo/nqAkvodUqnHPy
         7PuZRDsL6FjUe7zJyNa9dixXAIaWcYt7qK7iw0FdF7t+f3RNieLGbvANQyKBmHda0x0F
         l0Pw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782426890; x=1783031690; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsOe00D0dXCtOMeOq38Ryr/BClG0oOTSp27xViUjrz4=;
        b=c/obDDYBQ4sxtgM26I5ohTdQqZ2BfEhtaq1djKo6VVLgNDIHp2R1gejwTLqHH8Pz4p
         /3TqBsqoHiX20KOHAvGOuz30KrZOYRVkh2sKzRTmrJTb+okdKMWAhJrkfBNFhWALnmfR
         rcN8daaE+Azt7p6QAc5Lplo18cDDd4pVHAyWsrDS/syra2OCq7DyFQApqkix5zwLShwZ
         TLIureIWd6pLhxNq61dB9P//oQ8iXZnAt8kxstzDtR47a8ebq7ePYSwE+UhOeQi361KZ
         vhbDC08whh6BOEhyGF/Blw3YTK9x5L1nyKi950pde1yZdimJ6Mb91qXklgKK7uVKTM7m
         wfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782426890; x=1783031690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RsOe00D0dXCtOMeOq38Ryr/BClG0oOTSp27xViUjrz4=;
        b=ObnDv9Xv5pPo+StM5HS5vOsyMqOb3HzEpLPrGYLNw/lIUEKXDlccnMxFwH3f7m8AOJ
         MZoxygjndd4iaeBeCOfSOL2LyUv2gtidMYvB8JmhMkZ1CkXhhufVMk6jfmQggg0h3IRv
         uiLeAAcEHKvs+wpPiW2pHTYqBvs3jCnpPgjUG7pUn4DBfeJvlOtNUe08ATV7ASx7gnj6
         VFZ+i+DfqUnDwZUVO3AWyYtxFja4O12VWTtTPeWd7F452E6XWterCTyhAcxZWwjo5qHb
         h/4qudjVL89yDqyvAn2aqy+/J2U3s51K77/XAsWXusxjkbfdykJNHxXMWnJF1bnssbcf
         lQIw==
X-Gm-Message-State: AOJu0Yz6oiGD9fCY5mMramdGq/eiWWm0tv0NXISUpaDPaKKkw0Pd7pPC
	8JEnQR5ZQATz30daZfsqjsX20SCF1Env2MuVOylJDhwPFYBjJZf2oteaBHjemnnmEs4IVqA1AM1
	buwXcv2iTC5Oo+bV02K+79rA57xa0uWyxvZQpWtSTmQnc/KalGpvdBd81zUc=
X-Gm-Gg: AfdE7cmGDqShcOC4BTi7Mpby8ZiY/nHPTo7Famu7K3Ota0bRPZBI46JhLlaptCyezgk
	w5JvnFZ24Np6jStaVLoFYw11l/5eeVfCZB4oh5a+Iy6GcxSobKADR3Xw87tWR29J5M6pknxly9C
	Lz+N7zFmbaAKWrWe58bNop0daiCZhMTqdMyQkYkc+mawZ3BAbUnAS7ZnHU6UvnxzK5La05tJA0N
	cG+JgPEmz3fRjJi3X3UkaNOW+4sbI2jiPWCEnCe7NDryk1p4zmDqU8rBKLUoMmo9X2mKWkMS8TV
	V3e7wgHOZaYdL7ykgHUREyjQMMtY2uvEADT5W9IV8h7l6LbhcYqUWNhl14lTRgbD2/rOZJXTt11
	JjdUBcv6MVl1oe9HezB1wYHOpXUG/4OCYgsuNusfg+Q==
X-Received: by 2002:a05:6820:1885:b0:6a1:2295:f476 with SMTP id
 006d021491bc7-6a13517a372mr3771260eaf.13.1782426889451; Thu, 25 Jun 2026
 15:34:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <86078441-92eb-4461-b823-7d3539ac5859@mail.kernel.org>
In-Reply-To: <86078441-92eb-4461-b823-7d3539ac5859@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 26 Jun 2026 00:34:38 +0200
X-Gm-Features: AVVi8CfShnwwCAYnttfgfOqUevBYm4PjZ8K74AoCZ3E8AuCUQnSiABH7Y7oHIxM
Message-ID: <CANp29Y7aiAeNCUPAYbym7_b7gxDsjweF+qssQ-VSussbZ1OGgw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Exempt in-kernel PIC from "disappearing"
 interrupt warning
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, kvm@vger.kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, x86@kernel.org, hpa@zytor.com, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 11:10=E2=80=AFPM 'syzbot' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> From: Alexander Potapenko <glider@google.com>
>
> A warning can be triggered in kvm_check_and_inject_events() when an
> interrupt disappears between the time it is checked via
> kvm_cpu_has_injectable_intr() and the time it is fetched via
> kvm_cpu_get_interrupt(). This occurs because the warning incorrectly
> assumes that if an interrupt is injectable, fetching it must always retur=
n
> a valid interrupt vector (i.e., not -1).
>
> However, this assumption is broken by level-triggered interrupts in the
> in-kernel PIC that are deasserted concurrently by another thread. For
> example, if a misconfigured PIT or a PCI device asserts and then
> immediately deasserts a level-triggered interrupt, the vCPU thread might
> see the pending interrupt during the check but find it gone during the
> fetch, resulting in kvm_cpu_get_interrupt() returning -1.
>
> The warning manifests as follows:
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
> Since this is a legitimate Time-Of-Check to Time-Of-Use (TOCTOU) race
> condition for the in-kernel PIC, WARN_ON_ONCE() must not be used for this
> case. Update the warning to exempt the in-kernel PIC, while preserving it
> for other interrupt sources (e.g. APIC) as they are not expected to exhib=
it
> this behavior.
>
> Fixes: bf672720e83c ("KVM: x86: check the kvm_cpu_get_interrupt result be=
fore using it")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+dd769db18693736eee89@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Ddd769db18693736eee89
> Link: https://syzkaller.appspot.com/ai_job?id=3D0b59ccd5-8820-460d-84d3-9=
4df6307bd6a
> Signed-off-by: Alexander Potapenko <glider@google.com>
>
> ---
> v2:
> - Restrict the warning exemption to the in-kernel PIC case.
> - Remove the pr_err_ratelimited() logging.
> - Preserve the WARN_ON_ONCE() for non-PIC interrupt sources.
>
> v1:
> https://lore.kernel.org/all/345e9d6c-d7d9-4bab-adb3-d6a7bd27599f@mail.ker=
nel.org/T/
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0550359ed..f1681aa9f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10857,7 +10857,9 @@ static int kvm_check_and_inject_events(struct kvm=
_vcpu *vcpu,
>                 if (r) {
>                         int irq =3D kvm_cpu_get_interrupt(vcpu);
>
> -                       if (!WARN_ON_ONCE(irq =3D=3D -1)) {
> +                       WARN_ON_ONCE(irq =3D=3D -1 && !pic_in_kernel(vcpu=
->kvm));
> +
> +                       if (irq !=3D -1) {

Hmm, no, that looks weird.
Sorry for the noise, please ignore.


>                                 kvm_queue_interrupt(vcpu, irq, false);
>                                 kvm_x86_call(inject_irq)(vcpu, false);
>                                 WARN_ON(kvm_x86_call(interrupt_allowed)(v=
cpu, true) < 0);
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> --
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
