Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C2B3B27C9
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 09:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782293245; cv=pass; b=BaxijSypCgsA91t9tNvbmtba62d+Di2moQ1JKMPbjvE9hPI6+a0Lg1s0oRDYuV6whWALT7UZMPKhO5a9nPpvq2+Lu2xGShb7CsP/UBGMrpTIAM8B/vT1rM8zdcVExRXcJoPL7gbj9WZ1tmBG2EhtRsKVHdVcN3LV25lbvSMN27k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782293245; c=relaxed/simple;
	bh=oNPSkTu9X0McU5wN5yxQVx6BRkdnRxc1wA78wVu9xJM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hW+mNpwvs2VD8cuf+mLEX5jPWrwbBb9kWT3qG0vnRhDJppy9Zv76AGyPoeKzKKMpPOztXa2+sKWUDZWirx472uUEPcLj2wKCPNArnslrnLnrD9CsI9ouRC+L4naPEQ4dpJdDxao0lGHOtHuUFPLlUwAznMBS1O5lHipHp7gT87E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rly+dxDL; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rly+dxDL"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-697e93b0d9bso1244094a12.3
        for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 02:27:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782293228; cv=none;
        d=google.com; s=arc-20240605;
        b=G8WVSffOqsvdiNI9jf8Yc2KxyB4UfKLyh2lnVOYa9JQBr9NJRFwG8+IOZ3kL72baUo
         CeDeTkjvlwauqcWnBONWZqjnMVtnXwO4wp1s+i10uZ5oiHku7QkaecWwz+bPGz+cVL1A
         P3X0/vGW/uQ7XSqOFyzZZLptt9l0nTBhgLQ2LeAo8ue9ceBHQSbo9rOj6n2IWVemah4I
         8mlcypDmv2XQooAT7BqWgbgeJHEu9IXKBvi/tguI016ue44fM7dn8dXDAROHTo9A1Rgk
         5hYf3wW8tFISPV2W3iCDT513Qy9ofgU6TprlN8iWzlXScnPC9u3MyhUGQaa4K8AbEFhF
         aSCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tGpHvlELTSR+4hoW3pijCBgrQS7CKp1NXSchzJ4/GA0=;
        fh=TOUA6iy8nw0LxeViBYjW6B5kAh/+i3Xgm43MF8tLYEI=;
        b=Q0MFkfp/EI0jxQb6rQrRbSmEg1wYzJW/4igDYijOQOhJJSoyzCieIS/R7PakxDCQTU
         h5jTLGU2tIGJdeU3/MosPIcEA2aC0H+ohBH6wRdnxst0cFdbgpcLw8BphPyGHmJiD2z6
         jTwj6HXCrnftnsyvL1sD3cZAGBjIWNzxd9NSNSiX+5JYEArY10m9DVK8yWZDSCORejM6
         ExGTbtk8wonBadcbXFq2EGSqooczLhybMvn5c54huQgXTmgeLrfQvp4rK8rhmxWdxvbP
         7L+n8PydVuONffxDAkxYxLRgUX25vyJPUX8FtW1CQmIQALJnWZz3WN6AO6ww7WN987uJ
         Y1Dw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782293228; x=1782898028; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGpHvlELTSR+4hoW3pijCBgrQS7CKp1NXSchzJ4/GA0=;
        b=rly+dxDLoBZEkUuuLhOo8lFMOBIOIaijPJ1ANT3VzTezcY/CRZk055qOpfZ2Sn/O4F
         h3dO2WykcyRG2jquVRD1s2DJImXivYy25vIAs2jw+/S//Vjbv98mgnli0k0vq0fnF3lJ
         0lf63hL1CttDbBA/Qe8Hdn2qVs20oJfYAOFKgcn/qUTZOXoWbbUrQvup57wjLMCBA3Y4
         1RYzC/06cnulurKV5n7fpymiI+wRMWJvUXMad7YSHD04I//0FxaWHvRE0Rv8s954VYrB
         h0y7YuPh3J5rmKgr8FBA+hhcpUlr04DvaAbJZIbenpdsUbVb4sEQPRoXMR7ClXXWVCsh
         scUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782293228; x=1782898028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tGpHvlELTSR+4hoW3pijCBgrQS7CKp1NXSchzJ4/GA0=;
        b=p8sx/wzwtR/QJWb0J9XYEeUAX69Vi8WL9n3+raL4GDf/Hkr8Pip+167dDw3P4mFyE8
         WNzeysNK1LGvBo9yJT9Em2B4Rr8y+geN9FGtujJbYvbDwSVQ0s5SRbAvCaU+/D14oYbk
         3p3N4le/6znsroxDPhZAJzxvQloAPaO4g7DfwVslJOaudq8L4XH8HsqNWpCr6Y29RXCa
         oiFgIPCAihNNZ6BNf9VcoojKvdTe8TEGc+IHlgtv/1vYWoprUifinvDtktf8HCmn2lIx
         Pmy8fRJHgfZ1/E2AcR23k2e45Fiqn40AM11LGWRnEKn4peW9FVNJefC2oAQQUxnVO8Kn
         zECQ==
X-Forwarded-Encrypted: i=1; AHgh+RpvKf9enQaVrjVighBjQTmekAoZ4LIsYmiY+zFgUJH32J2+FeNtydEP3cFWZ8Ufy81V6rHlOY8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzrhTcx7kZWafQe+h5wLnxrTvO8wt7NyepOMr+klo5XvblWD9P
	k3JaVi/pV1zA5UHVhhbpBEtpWXOZToSPzVYgKPBeIGyk2fpM07n10y+fv/C91cBuxrRqTFBhr+A
	rMoDTtMbh1s+BsQvUXlqhqZG8BA7Ur/SNcUnD4v8bbr5Z/dJRpPH5kCXgdqU=
X-Gm-Gg: AfdE7cnRcOVZxrAxIxpYwA0YKYyHgy3S//eOCUZa7CXOam0PPoBguqikjm3U8R2BOeb
	PLu6uSEK4R5/3u7k/+ONQEAi1F/C+3JO7QQQm7KoBgCBY8sw2wFTMVvRAFuuhfm6AMG+LHXsjKM
	gjuPsAtQGBJILrVzIpbjAwBjNJIr2o42Dv20Fyge7NZZOAcGdTnLFVPYA183R6a6QWlCTgZ3D9G
	hvcfBFm9+hBQNf2IoXf03NNXWD1emkd+cRZ6szp2FRAlPBvm7bEgpzp+rl3LsNCKjmRKDBzVi0v
	HaGbSGQT5zahB0cPoSf99SWNTaXEzQNJV3p4Iw==
X-Received: by 2002:a05:6402:518b:b0:695:f580:a66f with SMTP id
 4fb4d7f45d1cf-697f3addbe4mr1162811a12.21.1782293227778; Wed, 24 Jun 2026
 02:27:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <e61a6de2-8e9d-4768-b555-27f8954e48ec@mail.kernel.org>
In-Reply-To: <e61a6de2-8e9d-4768-b555-27f8954e48ec@mail.kernel.org>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 24 Jun 2026 11:26:30 +0200
X-Gm-Features: AVVi8Ce9Wa_06UL2h2KbNtqQG-ZH9T1ntRURiZzTBAquh-3TerGfC9Xa7obXg4U
Message-ID: <CAG_fn=XJ06FXN7=zDOUnFTnHXYf4q-CSTv4HBo7A2qaiyf3_Eg@mail.gmail.com>
Subject: Re: [PATCH RFC] KVM: x86: Drop WARN_ON_ONCE() for concurrently
 disappearing interrupts
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 1:47=E2=80=AFPM 'syzbot' via
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
> pr_err_ratelimited() to log the event instead. The same flawed assumption
> exists in vmx_check_nested_events(), where kvm_apic_has_interrupt() can
> return -1 after kvm_cpu_has_interrupt() returns true. The patch applies t=
he
> same fix there by removing the WARN_ON_ONCE() and gracefully handling the
> missing interrupt with a rate-limited error message.
>
> Fixes: bf672720e83c ("KVM: x86: check the kvm_cpu_get_interrupt result be=
fore using it")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+dd769db18693736eee89@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Ddd769db18693736eee89
> Link: https://syzkaller.appspot.com/ai_job?id=3Db37654f7-62ad-4e4a-a244-0=
949c0ca4246
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
> index 3fe88f29b..c3e9c9d9b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c

Let's not touch nested.c for now. Respin with just the arch/x86/kvm/x86.c p=
art.

> @@ -4446,8 +4446,11 @@ static int vmx_check_nested_events(struct kvm_vcpu=
 *vcpu)
>                 }
>
>                 irq =3D kvm_apic_has_interrupt(vcpu);
> -               if (WARN_ON_ONCE(irq < 0))
> +               if (irq < 0) {
> +                       pr_err_ratelimited(
> +                               "KVM: APIC interrupt disappeared between =
checking and fetching\n");
>                         goto no_vmexit;
> +               }
>
>                 /*
>                  * If the IRQ is L2's PI notification vector, process pos=
ted
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
-upstream-moderation/e61a6de2-8e9d-4768-b555-27f8954e48ec%40mail.kernel.org=
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
