Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29BE5013B9
	for <syzbot@lists.linux.dev>; Tue, 13 Oct 2026 20:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791921883; cv=pass; b=pocAcfNy+PU7A2wTnSqSEocIeM6Wfq7TfVLJPM7XHKj8HTeNxI6CcRD5Av2ZYgfsKGW4SDIrjUs+dNpWAaoGYsBR4TOdGhO72VySm5LsemNjt851wc+Hzp6WMbmTNfiDXDcKOKIDcNXs6iyz06wzPJ0xMMb3QNyQtqLviOFKfSo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791921883; c=relaxed/simple;
	bh=7Jv1iSFAbrSjZoi6l0tfv1a+KvqYPKKxMV/IhR1HN+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rqgvg7dP++1LpNQxgU8lHnSQ7la10VhZiyyjn01tQK2UCk65RM2u8zoWxDGkJ2H1CnyhHGGglfpunGDK/lMTFWoYfpZW75f8BKpaOhLW8JOtqed3FEheEqZkurcBn3Gy07a1uo0siCdWpJIttX5i7udxoizWuSFBeJ8HoVUvUgA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PLt7fNKR; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PLt7fNKR"
Received: by smtp.kernel.org (Postfix)
	id 43DC51F000FF; Tue, 13 Oct 2026 20:04:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.48
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1791921881;
	b=xDKZS4GHpxBxxHJIGLrRkY68m24JjBMUOgSbJ5dERXkKchMgFRLv5NlsmxWXGsHMYV0/
	 vfeAm6FwlRfSWov8LhPUgVcwdphGAGV4lbTq1D/blNZbhLTOCoDcOL/T+2zKJEVlcYHeR
	 RqW6Sg4bdGFA8OO24mImXye3yyJ8JcPic1QHYWG8otbXm/w4948A/8lWSk0PBz767v0ZI
	 hWq3VZPt3lYakZdEZBWLfOK7sSP/45SUtT9PVC4wXKl8bG0P983J8bFkL/kC45sMPE3qh
	 pybLN9uCYDZEWQhiHMMpg7GqHG6BXsUch/yknbjSrqeZoocAIEwgs287oUoSPkx88lQ==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1791921881;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=tUFEhL4DQJd+O8HSIhVwqm3r983DtF+LPqL5gtfmFQY=;
	b=FIB+yfy+fDJ7L0MiQ3+iBisURkPUa8Ongjgw7NZwEOTrneHgUDJ4yaUTrgaiPj38gvcI
	 rdkyUxlTu59Mdvn2jZdUAq4Fhgyi4tvWusBKc7E4ZXffQ1xdHq/mWGJjRR7iZwROb7v+s
	 u372d163di5tiXoLgyqnAH3TlBRb8NisS8yEOq8gy86rV/FOty12PmSkfdJzpy06lG4/t
	 Bon/wLBkDyWNWCndJGOeVYX54r9yf6dLohxxbw22k/Kq/wbQAcuOTW7oapVUl0P65DQ2f
	 RwVySVq8LogmFABXXUXGkBrKnvDSOsY+nNK1qZ41sZP5So2u/s1wPKaGQaJsVayxV/w==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PLt7fNKR;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.48
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8125A1F00893
	for <syzbot@kernel.org>; Tue, 13 Oct 2026 20:04:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=PLt7fNKR
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 8125A1F00893
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-82380b0f55dso1574471a34.1
        for <syzbot@kernel.org>; Tue, 13 Oct 2026 13:04:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791921879; cv=none;
        d=google.com; s=arc-20260327;
        b=RPmN5pbtKBXnqMUxjDW7hrU9jjW9noodd4WfV0JizKSmw7bLjdG19T8XAc6v9mSIKc
         rQcaaRn/Ijh4tw++2wcl5egoIpILTQSjOl9zcwylUIXiXFbJchpYz0Kir/pTuhwcKfpE
         0AQ5p9RB9AP+2ktyJOPQF6i45GbVQym6BK6VefB6kWarCEzsvKHWqM0bKp4MuBlx59gI
         tVIsS02dq0dTavvnsbk+AH5KKe1ddCA4lzPoDDf6+EZOVwo0plKZEY5wixsIHbJj4E2f
         URCpo43jO9XaSmg0Tfvv4WflM96auSeswsd459IK+VWrK6yrR2p9ynoaSo2klLk3/gxi
         Nr6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tUFEhL4DQJd+O8HSIhVwqm3r983DtF+LPqL5gtfmFQY=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=lS1DAY7VOT5Yncz9/q/xLYCBOUQx92p2mjq0BTOt72Jqaw36k0zHT4gN6z7uc2coXE
         LReXciGY7XHszNDMjnRQVfqObQJPZhDZSQY4hNG18mN7gIZo3Qsd85yvbXV8P9/Mhkaq
         U2zKsU1dArxEV4F3Qak0biEhYYqaFqPjQkkykU8f9moGZVSD9ohDquBI1ZvVtv0T4rSU
         A0U6X7qCtYmNn+qxKaWxp6INXUoIe80OtPBEiGraMzMATWeFOlAeACdJCPIsTgcvpI8w
         HBZhEIyAO/7zwKFR6/T8edv37shzUOuRbtBHapeldOF/feNWa79wPI/Yn2n0HNPFQZui
         bY9A==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791921879; x=1792526679; darn=kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tUFEhL4DQJd+O8HSIhVwqm3r983DtF+LPqL5gtfmFQY=;
        b=PLt7fNKR1APsIwMDEqN28Wi0cP0Fnb61mWb0U/rxcurdLXHiYnU1D5rkHJaFi2fCUh
         AthhP1YoQjWrgne9voT9dQppCR4ygjfIhqWPQRI6k6Xw/hKB+N+555Fvjw7tZkIu3Tvp
         qZYnRaqJaaSNdy9AHkApREUM3kyenTF08g0VNzu49RP0Sv3McLbPCLGb/+GXeVEDM7/H
         Z8KHKI802mfLenMzvsjmt+ASXDTJ8vzsbDkDQaNDV/KXPaG9u87xpvXUDI5tzSG1sqe5
         eym93CbAZoD7NAQdK/jfoEVHDzBYKUiBkxIZ/z+S9sSGUpD6k3b/KrGQSiu9Kx8gYvVn
         dTcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791921879; x=1792526679;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tUFEhL4DQJd+O8HSIhVwqm3r983DtF+LPqL5gtfmFQY=;
        b=Y2tMQN2TqxkmIqyQoYNPLQc0se29CHhZ07uZvwta5OjZVxgb7ai4a3/TCWFTuGnPO3
         0sO7htL45a4djmliRngyz04zbkLt6DS28tB866DkqOOOIVwdEkjZ/D5QE4ddFr4j7c5T
         rLC+4Z4kLxg3U93DSCzEWGjKYwyOmZZP8sl8lodSorTezsHyT7Yf+NDM1yZMZhUAtflF
         /M2twGykyksDUjPvQasmtCGMXTugVczRIqtE3O2e+ptikGz+mi0IQNb8YqpcidYAyp8N
         o91q27hhMFtiOt0qlG8JGEgg+k8nVxm6I46gGTe8qmSt7FZ0Ejm5SeCshHQ0JBXaR/1T
         +uZA==
X-Gm-Message-State: AFq9FYKfELPMSmxyb//XHAlnJbSmiNVyB4ulKIeqpE/+nlwRw8QrIFJR
	WK8MY92AH5Xx+y3B427XI1qJK2sGS96IuYXtZi6VMxoT7nJgPwau7Mp/KaN8QvW0doutoXbNr6U
	CEiKob3Rtjqe7uOIYm76meZ9uOxryXdYEUaeABAydFzbis2kg2l0aIECO
X-Gm-Gg: AYBFou1NRrMgISd9HSEu3ozEaupriQOyzOmUkUruYya6N1iMpP8VS8/F8kXfmV7NAEq
	ZfmlLkqfTMgqRaF4a4356hc81RK9XHJ32GQvBxUDwLRRrCyoQyaaf397JwoBOKDmqMQAqoK/IDM
	ZLOA7JVPY9BeWsIsU6FrSdxDXdQd6zmeHNrVpgHnqqf8vuODZR2VlakYzoY7wu/KrjJR1217PVn
	JSlMX8aSAAUQDDJXNRoinAXNsVdDyijmZQkw4FXDbi7chLdgXqYSumEuBtNs8IYUEh/wsDvIMSY
	YUp+HI5Z9PptKAXBP/MUKkmQB2H1XemykUa3SMRm4opUHbZ/05Z1ud8++nnb/evEU4L8AhVwOUo
	6VXJhurIrBreTiV575kcHM43H1nMIV50vkM7l5sP8xqndyArw222RLFPPHyTnC36HR+6qXQ2tD5
	4giw6+ny0K0w9y86eL7ADb8shP6w==
X-Received: by 2002:a05:6808:4fd0:b0:4cb:d056:b14f with SMTP id
 5614622812f47-50c41aa9d1fmr14145142b6e.1.1791921878640; Tue, 13 Oct 2026
 13:04:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ef965aec-2c08-41e1-9f81-59bfb3e2892a@mail.kernel.org>
In-Reply-To: <ef965aec-2c08-41e1-9f81-59bfb3e2892a@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 13 Oct 2026 22:04:27 +0200
X-Gm-Features: AclHuK__D1UsXvY_jcaja4Z25cB6sEAkbyTP5mIBBGUzxKUbn9H6uFzShXueSI0
Message-ID: <CANp29Y5Bc329gaZw4w11d=DTJwEwXWik084P8JFzJyOuJUw0Og@mail.gmail.com>
Subject: Re: [PATCH RFC] KVM: x86/xen: Skip fast path for Xen timer delivery
 on PREEMPT_RT
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz reject

On Tue, Oct 13, 2026 at 4:09=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The Xen vCPU timer hrtimer (vcpu->arch.xen.timer) is initialized with
> HRTIMER_MODE_ABS_HARD so that timer expiration occurs with high precision
> in hard interrupt context. When the timer expires, xen_timer_callback()
> runs in hardirq context and attempts to deliver the event directly via
> kvm_xen_set_evtchn_fast().
>
> However, kvm_xen_set_evtchn_fast() acquires &gpc->lock using
> read_lock_irqsave(). On CONFIG_PREEMPT_RT kernels, rwlock_t is implemente=
d
> as rt_rw_lock, which is a sleeping lock based on rtmutexes. Attempting to
> acquire a sleeping lock in hardirq context triggers a sleeping function
> called from invalid context BUG:
>
> BUG: sleeping function called from invalid context at
> kernel/locking/spinlock_rt.c:248
> in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 6214, name: rm
> preempt_count: 1000000, expected: 0
> RCU nest depth: 1, expected: 1
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x31b/0x470 kernel/sched/core.c:9264
>  rt_read_lock+0xa9/0x4b0 kernel/locking/spinlock_rt.c:248
>  kvm_xen_set_evtchn_fast+0x1f4/0x990 arch/x86/kvm/xen.c:1843
>  xen_timer_callback+0x109/0x220 arch/x86/kvm/xen.c:139
>  __run_hrtimer kernel/time/hrtimer.c:2074 [inline]
>  __hrtimer_run_queues+0x3a0/0xaf0 kernel/time/hrtimer.c:2131
>  hrtimer_interrupt+0x4c2/0xa80 kernel/time/hrtimer.c:2250
>  ...
>  </IRQ>
>
> Using read_trylock() instead would still be unsafe on PREEMPT_RT, because=
 a
> successful read trylock followed by read_unlock() can wake up a blocked
> writer, which takes the rtmutex wait lock and releases it with
> raw_spin_unlock_irq(), unconditionally enabling interrupts from within th=
e
> hardirq handler. Furthermore, gpc->lock cannot be converted to raw_rwlock=
_t
> because no raw reader-writer spinlock exists in Linux, and converting it =
to
> a raw_spinlock_t would serialize all concurrent readers across Xen memory
> cache lookups.
>
> Fix this by bypassing the kvm_xen_set_evtchn_fast() fast path in
> xen_timer_callback() on CONFIG_PREEMPT_RT kernels. When PREEMPT_RT is
> enabled, xen_timer_callback() falls back to the slow path: incrementing
> vcpu->arch.xen.timer_pending, setting KVM_REQ_UNBLOCK, and kicking the
> vCPU. When the vCPU thread is subsequently scheduled, it delivers the tim=
er
> event in task context via kvm_xen_inject_timer_irqs(), where acquiring
> &gpc->lock is safe.
>
> Fixes: 77c9b9dea4fb ("KVM: x86/xen: Use fast path for Xen timer delivery"=
)
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+e42793f1299e53beb2ee@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3De42793f1299e53beb2ee
> Link: https://syzkaller.appspot.com/ai_job?id=3Df51d6e61-bc74-4ce3-8f36-5=
4e585622882
> To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
> To: "Borislav Petkov" <bp@alien8.de>
> To: "Clark Williams" <clrkwllms@kernel.org>
> To: "Dave Hansen" <dave.hansen@linux.intel.com>
> To: "David Woodhouse" <dwmw2@infradead.org>
> To: <kvm@vger.kernel.org>
> To: <linux-rt-devel@lists.linux.dev>
> To: "Ingo Molnar" <mingo@redhat.com>
> To: "Paul Durrant" <paul@xen.org>
> To: "Paolo Bonzini" <pbonzini@redhat.com>
> To: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Sean Christopherson" <seanjc@google.com>
> To: "Thomas Gleixner" <tglx@kernel.org>
> To: <x86@kernel.org>
> To: "David Woodhouse" <dwmw@amazon.co.uk>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index d113bd0f1..7aa387d8d 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -125,21 +125,24 @@ static enum hrtimer_restart xen_timer_callback(stru=
ct hrtimer *timer)
>  {
>         struct kvm_vcpu *vcpu =3D container_of(timer, struct kvm_vcpu,
>                                              arch.xen.timer);
> -       struct kvm_xen_evtchn e;
> -       int rc;
>
>         if (atomic_read(&vcpu->arch.xen.timer_pending))
>                 return HRTIMER_NORESTART;
>
> -       e.vcpu_id =3D vcpu->vcpu_id;
> -       e.vcpu_idx =3D vcpu->vcpu_idx;
> -       e.port =3D vcpu->arch.xen.timer_virq;
> -       e.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
> +       if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
> +               struct kvm_xen_evtchn e;
> +               int rc;
>
> -       rc =3D kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
> -       if (rc !=3D -EWOULDBLOCK) {
> -               vcpu->arch.xen.timer_expires =3D 0;
> -               return HRTIMER_NORESTART;
> +               e.vcpu_id =3D vcpu->vcpu_id;
> +               e.vcpu_idx =3D vcpu->vcpu_idx;
> +               e.port =3D vcpu->arch.xen.timer_virq;
> +               e.priority =3D KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
> +
> +               rc =3D kvm_xen_set_evtchn_fast(&e, vcpu->kvm);
> +               if (rc !=3D -EWOULDBLOCK) {
> +                       vcpu->arch.xen.timer_expires =3D 0;
> +                       return HRTIMER_NORESTART;
> +               }
>         }
>
>         atomic_inc(&vcpu->arch.xen.timer_pending);
>
>
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
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
-upstream-moderation/ef965aec-2c08-41e1-9f81-59bfb3e2892a%40mail.kernel.org=
.
