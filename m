Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020EB3B38B7
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782307402; cv=none; b=c7xl8A8xntgc9hkryVgTP8upCnlaOT2PBmASgLoeuML5eKGhCVtCDqTEBmLImmtmMg0bTtHxGyB2FX+0bUGSUsNv8VvJW8YG3WmEzWIWMeIcPCUPZKXx1bbSQGcqvb/GrFj0R/yFOdgtH9zMtaGtSysYGiXdJgASi08yzH6/pfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782307402; c=relaxed/simple;
	bh=raU69NVRAtRAxtjXvLMIBNjBFn1hyuVPyf7yqqGbVKg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ctz0TGialDMX2ixcEwjgHXZrwY3Zv39Ihi6VgTdduYUhTVUHYrR/om/Yk8u585Cpnx3CQJhczUKshbMwCF39AYWnKskL50kv7QePlLAzwVsCNdtuIL4mMqRHeriiqghhaJf++m9fg40JctDPdI5r4nVrK8l/CMQxY4EQCBbHixA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kuFx4FMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kuFx4FMX"
Received: by smtp.kernel.org (Postfix)
	id 5FD9F1F00A3A; Wed, 24 Jun 2026 13:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD621F000E9;
	Wed, 24 Jun 2026 13:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782307400;
	bh=FdzfK8NzIbxMt0dVdyRP9xobT0gtBNGsBxgHXz62SIE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kuFx4FMXcuO5TCwOfgBEJ1EGxIyFYJWLfykDuwaXPluPkWBgDKgtxD8KrAHH3a0tL
	 lK+qoTseBq8MeAZNzVQ2kOjQPENuMwSh+1bleWvEuyQ4nxsg4tbmT1gL85TtQhNs85
	 M/2oX/DugpHZhf+3BDf7phoCbkTEdD/DoGXv3UmGA+VfL1s4Vj69M7VR5uxhyg0EhA
	 BmCXkRcTQ3Ys3ilEVv/R471knaAWOYsFjQlANqDPhrnriYzY3+JPG3k56ereNsscH8
	 gEA8m28SkBXBsrQBF3GSqLZIir3rdqOmLwvCB+Wg6Zz06a5IFjwVT3c/sx/VhCfOGj
	 9/D7yqqo8cV9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: x86: Drop WARN_ON_ONCE() for concurrently
 disappearing interrupts
Reply-To: sashiko-reviews@lists.linux.dev
To: syzbot <syzbot@kernel.org>
Cc: kvm@vger.kernel.org
In-Reply-To: <345e9d6c-d7d9-4bab-adb3-d6a7bd27599f@mail.kernel.org>
References: <345e9d6c-d7d9-4bab-adb3-d6a7bd27599f@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 13:23:19 +0000
Message-Id: <20260624132320.2DD621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Guest-triggerable host log spam via pr_err_ratelimited() for a n=
ormal TOCTOU condition.
--

commit 116bec97d294fdbb66935efe3243c46e486faba6
Author: Alexander Potapenko <glider@google.com>

KVM: x86: Drop WARN_ON_ONCE() for concurrently disappearing interrupts

This commit removes a warning in kvm_check_and_inject_events() that occurs
when an interrupt disappears between being checked and fetched. Since this
is a legitimate race condition, the warning is replaced with a rate-limited
error message.

Link: https://syzkaller.appspot.com/ai_job?id=3D35cad3cd-95fd-4c0d-8ca8-812=
f58d56e59

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0550359ed798f..c5b4cddd9c0cb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10857,10 +10857,13 @@ static int kvm_check_and_inject_events(struct k=
vm_vcpu *vcpu,
>  		if (r) {
>  			int irq =3D kvm_cpu_get_interrupt(vcpu);
> =20
> -			if (!WARN_ON_ONCE(irq =3D=3D -1)) {
> +			if (irq !=3D -1) {
>  				kvm_queue_interrupt(vcpu, irq, false);
>  				kvm_x86_call(inject_irq)(vcpu, false);
>  				WARN_ON(kvm_x86_call(interrupt_allowed)(vcpu, true) < 0);
> +			} else {
> +				pr_err_ratelimited(
> +					"KVM: interrupt disappeared between checking and fetching\n");

[Severity: Medium]
Since the commit message identifies this as a legitimate race condition that
can occur during normal operation, could this pr_err_ratelimited() allow an
unprivileged guest to continuously spam the host kernel log?

By configuring a PIT or PCI device to rapidly assert and deassert
level-triggered interrupts, a guest could intentionally trigger this path a=
nd
force the host to log messages at the maximum rate-limited frequency
indefinitely.

Should this event be logged with pr_warn_once() instead, or dropped entirely
to prevent adversary-reachable host log pollution?

> +			}
>  		}
>  		if (kvm_cpu_has_injectable_intr(vcpu))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/345e9d6c-d7d9-4bab-=
adb3-d6a7bd27599f@mail.kernel.org?part=3D1
