Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF463B42C0
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 13:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782306624; cv=pass; b=GH4XtBRMJuBTg+cuVGW8JxKeAk8mdKFtFy/iFUvf91lMFdYR1hoNkx49zAYMZpdO0IT35MkXwUqYAXSKy35TGZ8q8q2SCwzEFHh7d2TtQfAcloNSF1is62YoYPOkEhXoTWAML1JTcsAirGzOJ6LsHEggYyRsor0eUVls+AdHw6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782306624; c=relaxed/simple;
	bh=R/3IQ8+v+Li1vX1Os859TRqsM3fd0Pp5VqeNpxtE8Xw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tVoSKRczi6S6AU95WEL++6eCOMPurf/9TToU+6TvNM5z82flro0tIBVPm13RUKvrIYK/nLnlw9rwdzgN/+l6fvmjkYSWzyOYbzJi07cLWOJOeqFXPAx5VH2QnVxR4ftELTwzNccy2PH8Ns4b6TPbS5R/Ik8SCj69HBo0hWsnJ/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qaMIiZ8d; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qaMIiZ8d"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-68852b58d87so2070929a12.3
        for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 06:10:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782306621; cv=none;
        d=google.com; s=arc-20240605;
        b=c+Z8RaJWFSYzyPtD7uO0TZOtKoUBo3j1hAHcKn/pexZbLu8YJseqxQw+eYr/jTqFnv
         NuSmo8f0YAkIVSwZlPquCKlEiShSZiKmmq6EN6RE6w72JTgW4wqga6OvNvF3x55lsNh1
         25BFv8mL5yuXFSR45zfa3AME3bzFRXCb88cEAMzQrXpfn6rbtvNnfIjHE/lmvcux1cJk
         8Yw9/HWfJ9Yey5uaJamYg9Gy4hQc3/PjIaAGofhjcDfIKoysYlObzsfVzKgeWQg3BzMQ
         AX1PIIBExY+eLuapcT9trr90FYlR/ePe1eR6skBfVBOOcLXFl1OGyV8pydxn8fc2s5G6
         7QIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TmII1rhwtBP4b1+t2evVEpTLsHSzEDW/F2Qyb4wJGJg=;
        fh=/WIw8xraXNojETtIaSA9NXozeIAvSYAaKk509+TEFZc=;
        b=DN2ME7QZa1hWyHcuCqM30ETipk+4whAkWISJMv/JUs+pI63N0AckxYVWttkfhC6Qbn
         EHXS3gCtpOq9Wvx7hG1DLVUDsLdtsadSVMMlMbF4ymmek0ro2Wzv3DvRbIqwdUE5n7Ip
         RjkyXFNI+BDLV98WonRgy7CFrVOl1QpE7oj/Ib8yZIVNAPgmx2JWqAJf5vZ9shKxCvOS
         lqg6qIigogcIyF9BjEoMHmResLMiFQOw4Rfq2ZW03ARYdPbmTqwRUC4FplI5IqQm/DZi
         sd+YS/9jDEzFvTVqT//gpa6xVpP0altZimp2gT0Ud6y5g6v9Ggy1CM7hbKOTicB/WLuP
         6bCA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782306621; x=1782911421; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TmII1rhwtBP4b1+t2evVEpTLsHSzEDW/F2Qyb4wJGJg=;
        b=qaMIiZ8dGFCHFXDcVtE8B6MFBXabeF2ygTRGted4iPuP3kxZRFfo/X1lmuwRtiXTOy
         ACyaJsIU+FN/Alz84/YtTBjXcP+Rijdhpnr5zdiub8qWYVesLm54cOcC21aosVJHNr2Z
         ByrQtIJ71ypVt/xjYied5sXshyhVWFshb0ckkgOOP7mjlsq7JWNPfeD6xs2zokfXaulJ
         xvE5/d4+GTXqaYLrWWgZRv4b0AGdOVtH7/1dQ/WyzYxSc7Hz63dNMBLdDZDMMNOKdPpw
         FSmjOsaJ2DQBDoJr/dBWDaK8Bn1J0hSGYCS6wenBibZXZ3f5FmhTDJjRfKVCOyciNYCa
         UVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782306621; x=1782911421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TmII1rhwtBP4b1+t2evVEpTLsHSzEDW/F2Qyb4wJGJg=;
        b=BT0eyJd0+cZ0mDRCJAI1wsiNfjAPnEdrWcoVOxg5DTitJREUiRNwXJ61VGzhUOKClQ
         zbSsxA2Hqnm8y4OiTsjsdX8Wc7Zl7VuXd1glbyV3QtQU3Sos+ON+D/Nosv6bL4x5fvi/
         AzsBqenSx9vnNMINNxxAAT6nNaEWG6ywMOxGQnUvjxHM4Nr3jwDnEFEFiI60CkK5V5an
         OoO95rvQ0mNz5JcZpcO7gf01AuecdqcEa9plS1SBf0sEkgkjXD09t3ZOns0/EgxZ+1WZ
         vqYmmY4Q3ejLpMxiVkfww1ckm5KxYaLPU6uWsuwlY73s9xhGt/GaKFEHr37/eomhZHkW
         rhxA==
X-Forwarded-Encrypted: i=1; AHgh+Rrh6O+bjVURqOIq7GCDkbTB/g1gMOggjp8B9oXaSqnwhILoP0bP5hXZvVUwj+eaFAcIso1cMPo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXP8Z9GYC2UxJWl6QGJT6+eb4YCmNi1pTC5DGx9F1pZc0cn5jD
	WYND0ab+9BR2K1yclPJwUu2PUGAgSQRh+RN7nHGQB5k5v3NdixBWuEb/+kRIuXzY9E2hzYf4uCi
	9NN3Qg6M2v1Ac9zO568pvJo4gPMVWX5QsUFSTYwxI
X-Gm-Gg: AfdE7cnibSno+qDgdM9r6/bfddCX4f1O1Knf5ywPEM6CiHGNxJDIskD/K3rYi3AA2Un
	eaOvPMgKF5kmAGnY3c3lDaUNR4qJzPqK42r7GJPd9KobapSnDSaHx5M6W+GL6tZfglFm58htbVQ
	fRtZmCBi3nBAK9cu201881RbuuPRqzfyA21cmScxUKEhl0pEgHUfoTk5b9ggkmF2ilSlfSNZImn
	fKIrYRhV8hRMiyY7rr5WHI2QMXRdcov8n4eY7dh+W9TuGmX9vlwAdvTnH/5Kc3rx3778gwZ+yHf
	52XBW/kJfxgy1pi2hcepV5mREc0=
X-Received: by 2002:a05:6402:440b:b0:695:d60e:1df9 with SMTP id
 4fb4d7f45d1cf-697f3a8cecbmr1756438a12.12.1782306620724; Wed, 24 Jun 2026
 06:10:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <28ac723d-47df-426b-939e-752b6df7f1a8@mail.kernel.org>
In-Reply-To: <28ac723d-47df-426b-939e-752b6df7f1a8@mail.kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 24 Jun 2026 15:09:41 +0200
X-Gm-Features: AVVi8CfNO3QGMLYOz5fqrCOIpesGXXTpbskAMI1TKBGbaKIXMXlPCruc0wNh2e8
Message-ID: <CAG_fn=XNVY6eAGhd=8MXoyANz8O=wNP240RRPy-o7D3OLp0=5A@mail.gmail.com>
Subject: Re: [PATCH RFC v2] KVM: x86: Drop WARN_ON_ONCE() for concurrently
 disappearing interrupts
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jun 24, 2026 at 3:02=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A warning can be triggered in kvm_check_and_inject_events() when an
> interrupt disappears between the time it is checked via
> kvm_cpu_has_injectable_intr() and the time it is fetched via
> kvm_cpu_get_interrupt(). This occurs because the warning incorrectly
> assumes that if an interrupt is injectable, fetching it must always retur=
n
> a valid interrupt vector (i.e., not -1).
>
> However, this assumption is broken by level-triggered interrupts that are
> deasserted concurrently by another thread. For example, if a misconfigure=
d
> PIT or a PCI device asserts and then immediately deasserts a
> level-triggered interrupt, the VCPU thread might see the pending interrup=
t
> during the check but find it gone during the fetch, resulting in
> kvm_cpu_get_interrupt() returning -1.
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
> condition that can occur during normal operation, WARN_ON_ONCE() must not
> be used for conditions that can legitimately happen. The patch removes th=
e
> WARN_ON_ONCE() in kvm_check_and_inject_events() and replaces it with a
> pr_err_ratelimited() to log the event instead.
>
> Fixes: bf672720e83c ("KVM: x86: check the kvm_cpu_get_interrupt result be=
fore using it")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+dd769db18693736eee89@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Ddd769db18693736eee89
> Link: https://syzkaller.appspot.com/ai_job?id=3D35cad3cd-95fd-4c0d-8ca8-8=
12f58d56e59
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
> v2:
> - Removed changes to arch/x86/kvm/vmx/nested.c.
>
> v1:
> https://lore.kernel.org/all/e61a6de2-8e9d-4768-b555-27f8954e48ec@mail.ker=
nel.org/T/
> ---
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0550359ed..c5b4cddd9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10857,10 +10857,13 @@ static int kvm_check_and_inject_events(struct k=
vm_vcpu *vcpu,
>                 if (r) {
>                         int irq =3D kvm_cpu_get_interrupt(vcpu);
>
> -                       if (!WARN_ON_ONCE(irq =3D=3D -1)) {
> +                       if (irq !=3D -1) {
>                                 kvm_queue_interrupt(vcpu, irq, false);
>                                 kvm_x86_call(inject_irq)(vcpu, false);
>                                 WARN_ON(kvm_x86_call(interrupt_allowed)(v=
cpu, true) < 0);
> +                       } else {
> +                               pr_err_ratelimited(
> +                                       "KVM: interrupt disappeared betwe=
en checking and fetching\n");
>                         }
>                 }
>                 if (kvm_cpu_has_injectable_intr(vcpu))
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
-upstream-moderation/28ac723d-47df-426b-939e-752b6df7f1a8%40mail.kernel.org=
.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
