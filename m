Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A853C3016FC
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 06:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760422283; cv=none; b=V4qoPyysr84/WJdfJPJtrWU3v3qGlJ3Vk9rg6uqX+E6/ayMXSMVkJjkGHVeAQNHKtvnsTu6caTHmUnX5fIK6swb9c2TVoh6rocofMnUoQA89rz4Lk0fGQ9hOn1iGGmVEYX1DCghogcjNCimR7/bILbieb1XSDJIrk5cHaQAXKIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760422283; c=relaxed/simple;
	bh=WMRf7qFYeBB/TZLLgxR3qGymJt7X2ESKtQcqAaW2WNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PpCO3PHL22dCCltKaIWcARPpEB/wM6jBrAnr/iRFmkCDXvN8iI89itZeAzdgi8dqjcng/pbm5htFP+189fLYYEBFPyZO5Js22liKt0StZfARzhWITQgNR6Al5nUFVnE8vRuuItBW1Jl7QSf/1DqoQEe3UKsoSgMhFZMbwBKnAj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P+yCj8EU; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P+yCj8EU"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-43f50c2765dso2591501b6e.3
        for <syzbot@lists.linux.dev>; Mon, 13 Oct 2025 23:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760422273; x=1761027073; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbmmEVxshGZE7myYbCeNTocUeP3p2FABlzqxV0hlm3U=;
        b=P+yCj8EUkjWBw5VRvUrvE8kK03wjSeuYZTjr2OkGYGMa6mUvE/uVmRIdCME3B36/tl
         49Gw+DapmKvjeBvQDRs0D3MrFZFDJF0HgMGCqPxjGF7bqN/tzKfTi9XK2W+mcZ2a+xtL
         rWEfulLJnD9h+XzAQkPhs4HsRLtZ1q2nnS0g0dAtppFV+BRpD6IuXpnguIuJZLE0qZhf
         NezYNIearfHCB/kwQEAdp4Shg6wifNae7jtFZtbIA1aanPI+fbvV38tgLRjS/kNwgCnh
         9daEN/IMzX3IEDNVdsIOigCnipld4TzfvuWwniRDzUWqDJ0oTM2ix97p8x5sejqtEevL
         LFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760422274; x=1761027074;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbmmEVxshGZE7myYbCeNTocUeP3p2FABlzqxV0hlm3U=;
        b=QbFzZT7CeTlD7hW4ivzIUe3JRZYZuvWAqefSJXSxcR14qB/FCcSZ9wxIVotk2lf6ll
         u6ynQmkV+fKMN3BBR/3770lT5jJhL1d1JP6mkCdkP2H8HgBWRlw3aMH7jIBY1rFub023
         kcrRwCZWpaXmtxbLQCmQHXnN0oO2FC0gV4shVzOcnIWuh9BrvnmPfNVvtM0tcq2kXEQF
         Q5pp0Kyr3z4SaCjTcJFGtlMRx7Z7pXMH16SCUy3KquEsp8Kpj82me5fDAc28rs3QoKoD
         iVY1qIKzNvpNVfBLNgVVw7w+pq9z+j1rjXn5y1an6T202msLK8KnV5ObRdxEujlmUIBV
         nnZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr+KBU6YerKeftsKnjXpvvWfAX1lFlBh2gEkcKtHWhayHM75r1a2qbkPChrSn0O+MvZss5mN4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUmanzaMpVdIAb+Yr8FQJhPZWX41ygEgJ4f+cWma5l5/mJybZE
	Y/qv9GVbdnq2JMkVYv7h5tsU43tGWyilsPQ2wgzu1+Rsjlt7JypzbCxWh22r1n4E11y7Q1ubopH
	eh01h9jhsZhMEwbNPal3sgmTeIo0q7sMAYdCQ/boe
X-Gm-Gg: ASbGncv01xXbT2F8l8WlZfIHkgh+1aFWcTOLC44QsPgMYikKpqOyWX9sf4SALEzkkKW
	yxWSzm/7UKPindgoRdj+vWDhFlUnfYGyxseFg30yeYvqk0waJV2fIEr58qM5GAKWyX9uGJAHj0b
	xXZHshO1cIvHY+p6MLYvzIHmhtoGaiosZTJDo+MnO9//EZU3UGY/mvDzHJPgTswDz21M+jb6DDS
	HFgjjfoNW4O1bzn2W1Qdqqwbw4ZFLrh+C6VDN4QMMDhlQXB6yK8t5FsMoq9PIcquA==
X-Google-Smtp-Source: AGHT+IFeQQ9n5jF/XTvgXi71DBSwOtC1F+rFuGssz1E52lfBAAKCxfseNdZUOJmiADsFl6hkwbgSBrb3OH98UADyouw=
X-Received: by 2002:a05:6808:d4a:b0:441:8f74:fad with SMTP id
 5614622812f47-4418f74207dmr9892320b6e.58.1760422273462; Mon, 13 Oct 2025
 23:11:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ed6ded.050a0220.91a22.01eb.GAE@google.com>
In-Reply-To: <68ed6ded.050a0220.91a22.01eb.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 14 Oct 2025 08:11:02 +0200
X-Gm-Features: AS18NWCRSielG_TuOqEE2MD6CL55Syld0McxALGrmIbwLOOaAV5Gf9XhBpiMvjQ
Message-ID: <CANp29Y6oWSfgdh+ZbCu+WhJUo2uzQwvFOQZdCkZn6iEdNkmrOg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: x86: Unify L1TF flushing under per-CPU variable
To: syzbot ci <syzbot+ci995bc9256a200467@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Oct 13, 2025 at 11:24=E2=80=AFPM syzbot ci
<syzbot+ci995bc9256a200467@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] KVM: x86: Unify L1TF flushing under per-CPU variable
> https://lore.kernel.org/all/20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@goo=
gle.com
> * [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable
>
> and found the following issue:
> BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruct=
ion
>
> Full report is available here:
> https://ci.syzbot.org/series/c0a39c51-4121-4883-a21f-4277f63b3118
>
> ***
>
> BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruct=
ion
>
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      6b36119b94d0b2bb8cea9d512017efafd461d6ac
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/a964957a-128c-43dd-b6df-7758575a9=
993/config
> C repro:   https://ci.syzbot.org/findings/c0c645e8-abe2-437f-aa29-1adf339=
cb732/c_repro
> syz repro: https://ci.syzbot.org/findings/c0c645e8-abe2-437f-aa29-1adf339=
cb732/syz_repro
>
> BUG: using __this_cpu_write() in preemptible [00000000] code: syz.0.17/59=
62
> caller is kvm_set_cpu_l1tf_flush_l1d arch/x86/include/asm/kvm_host.h:2486=
 [inline]
> caller is x86_emulate_instruction+0x1a4/0x1f70 arch/x86/kvm/x86.c:9405
> CPU: 1 UID: 0 PID: 5962 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  check_preemption_disabled+0x10a/0x120 lib/smp_processor_id.c:47
>  kvm_set_cpu_l1tf_flush_l1d arch/x86/include/asm/kvm_host.h:2486 [inline]
>  x86_emulate_instruction+0x1a4/0x1f70 arch/x86/kvm/x86.c:9405
>  kvm_mmu_page_fault+0x91a/0xb70 arch/x86/kvm/mmu/mmu.c:6385
>  __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6624 [inline]
>  vmx_handle_exit+0x10a4/0x18c0 arch/x86/kvm/vmx/vmx.c:6641
>  vcpu_enter_guest arch/x86/kvm/x86.c:11461 [inline]
>  vcpu_run+0x4359/0x6fc0 arch/x86/kvm/x86.c:11619
>  kvm_arch_vcpu_ioctl_run+0xfc9/0x1940 arch/x86/kvm/x86.c:11958
>  kvm_vcpu_ioctl+0x95c/0xe90 virt/kvm/kvm_main.c:4476
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:598 [inline]
>  __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:584
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0f9698eec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff7c8600c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f0f96be5fa0 RCX: 00007f0f9698eec9
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 00007f0f96a11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0f96be5fa0 R14: 00007f0f96be5fa0 R15: 0000000000000003
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [bp@alien8.de dave.hansen@linux.intel.com hpa@zytor.com jackmanb@google.c=
om kvm@vger.kernel.org linux-kernel@vger.kernel.org mingo@redhat.com pbonzi=
ni@redhat.com seanjc@google.com tglx@linutronix.de x86@kernel.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68ed6ded.050a0220.91a22.01eb.GAE%40google.com.
