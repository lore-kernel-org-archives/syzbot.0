Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2532F2914
	for <syzbot@lists.linux.dev>; Thu, 23 Apr 2026 20:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776977439; cv=pass; b=Z5WFtc7k4ln7Ql5Mdr5VPBCjLmDEzXD7JNKBR5V4iSks6Ylafds5vSY5Eg8xH3sqwJZapLwVLbA0nKgeRSr/tgBeWt0wvzWK06VKLKPh5niY3NFD/2s1tNrsTZAtLsbSA4uS+v8YiP3/6bg6ZwyN0MXYqwZ3VBwZ22n92LagSjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776977439; c=relaxed/simple;
	bh=duuGIzF01sXDjVaZMJqf1N0my+ho/ltsQPoQzB/kj6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WfMQR+niDu19VUYYRYYqn2XXTe+Nm6VfZBe497PW5qXeol9dt/k86efUUKjHwRx3LiTrWT0/BhgEYhFAJZLOXw8BTE0LB2AHKVpV2tvg/1m4424iQKr3ebzDqJS3+Sj7DEsnAWB8Qao5E9uQqes27E+4VbbMeg8caO9YIKKgJ8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RuHk6fv5; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RuHk6fv5"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6948579e5e9so2694524eaf.2
        for <syzbot@lists.linux.dev>; Thu, 23 Apr 2026 13:50:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776977436; cv=none;
        d=google.com; s=arc-20240605;
        b=EwamY7Y2BYi6WFiVJ1hUeBkyVDBIrrfHoZmlhLVUcd60YANdu/GejhQuaYAbLL2JEs
         ueoVxIhcsgHAkC9cF6Iw5ciTp7qlGGqzst0dn73VWz5kt7MPM6/LLRJp+0RFQ82M7Gid
         xdBg7Uz7zOP4GHcwP9YSdNi0dLsJNMkDM8UPDlQQYTVK+4vLn1SkWUnH/LomoC7acoTE
         L9qeTlfSLyqibVP9BTqsmmJM8JiK1L+FR7kfZDSytNt8SW8+hHJdrPEUR4IJdcyGMt5b
         nwbr/KCCbO9jtiAWLHgnjuFW9uH2LdtQo+2bZ355xPzHMKjTGGnrrgHU80JomhC0DC5m
         dpfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nOLjbXpHycCoDxr57FL4eIx80KTFlHyJQ8LEbDk6q+c=;
        fh=yTIoaSH3vHqq3m+INwA3quiEZtmy4j3hUvnyEqffmGo=;
        b=LRmcoODu6MxGXYmJe1b8VmhLhvj5lwVA8+QVGcuAiVkjc7pTJBlSMVPAIlovs4M9U3
         4BqOYFUc0iLs15etPtCSfGjydPdzluYf3iOWyaEpmF7nPS7dpm47BRJa7XRGtOvR8k/M
         LhKJJtJ8iqVz0YzfpAz3TOyhgCaU2DXeZjfpRS8BJegTFDCfkqWDaYh+ufSaKfQeMX7d
         4qJIXB+IN9j3Z/8I2iKLGk+cVP0qYcQtbAvTYcoiDwVGrRU8dSU7HhAaGABRvovk1FMr
         KQryxSBmIWQQ5fNRrMSd1kc3YGjlSbh+UOmcB3SzXzhjgRyuTcFGq+UnxDd5e4wom1Yb
         2USA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776977436; x=1777582236; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOLjbXpHycCoDxr57FL4eIx80KTFlHyJQ8LEbDk6q+c=;
        b=RuHk6fv5wW51iQkdeLkD5nIrvEvtLUieaM6pqpBOI0xdUP/PXOYV2oHoKdQdjSWfR1
         PL+MKXgflfPUbofbEuGka8Agt3nPsG0XFRaMp7mkj6liuA8zejbutJ9+p4OG9haUmfIg
         UpVRQimYeBfxyaigR+jFCtNrgP+QtqSidH3X4kzjG/w1UABvGzbx93OHXq5aQCfVRiDK
         UVgUAY+eJ1cqWvzmTTBp1py7f7Udh9fVQt06/X91Z8zeYWtxWsXv27j+ih3MYfBU4WMy
         Zc1ujFXlod31T5HbxSjZKIWr28LiPpHor/16F1u1DTmcTU6Kah+DfXEUeL16ZOdS3DA0
         N4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776977436; x=1777582236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nOLjbXpHycCoDxr57FL4eIx80KTFlHyJQ8LEbDk6q+c=;
        b=DCui4UHD+RMPfDOxKQBeogdkBghZYOqDSl2zANGs0kzOAb7kXRAQmhCbSFAimTZAid
         ZtALPaDfVHM40uERIea939eVsvUWym7pcgukdALsz0totehkwcUtLiJq4bUkNAF19u1x
         5O0gtn54QcYzy+s/YFDohxzDIfAv9u0l+IItZ+aao8ZEmuI4hcghyTYEor0ssPlNQXmW
         NPMMAFsr5x5bxgwEyV9KIwo1aon2yLMJB9X+ZyVwkxI3XA0AibxQjFCTKYwvunASOfgE
         mL70EUmO/AEauOblMlMPLeXCU7q3PgescXX1gvZ6eZCu83Mm1UOPSA4jTi/NDO8UNxhL
         LTTg==
X-Forwarded-Encrypted: i=1; AFNElJ/zG6eX1gA1rIf11RzpPtTkJ56pq5pUplXk3jBFnvhCBOP0IyOrtyvyKHIE0m0pRRVo9MVv4TU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzttZZoahSE3P4aYMUVz6oNzGzUQCyUFkrS7mBPty7F3Y91qlm+
	gAHE396ono5X+GEucfeOFMiV5+itc7WnSZWd0+YasJ7AsMCG/cgtzIvidFMjjZpDZJn4ME85Q5r
	p8wy5XJ3RgKU9oU4EV83Hjrl4orX7d+b/tn3wvUr0
X-Gm-Gg: AeBDiesTWLWoHWOanFUsIzBdzayc1AXQEs2x5QzbjfQOPd4KqcRJE2Cs/eqz7aenHa2
	aP9ynl/UVpE+Rl97Uv0rUn+sQBQH8DtzRNueTlZ54XHkQJKld0G3iawJR3H7o/6zq6xfAP3KnN2
	nmQvKmHph3YIAbE4JFkhEEEO+BN38yBnHW9RKllDQId6LTbEUkDlSVvuu4DAZiw5eis6B5iE5v/
	pKAmzqpSPNUROcBDsHOhQnWjDyR6HbC6zNuo2VnTkHE+aeMVLLJSd6tM6HYY5J3aSuVA2Z+Ozt9
	LDy2+C1mEHqLQyY0kt/qiK2RctTogT/THRLnwMK2AIhHqGyMx7arx6Bkr2EYlBXhg4fD+N63iyf
	Hw9EA7WBTvM5E1YIYbgsw8SPYzno=
X-Received: by 2002:a05:6820:162c:b0:695:b571:e579 with SMTP id
 006d021491bc7-695b571faa3mr4674562eaf.10.1776977436010; Thu, 23 Apr 2026
 13:50:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ea70f3.a00a0220.9259.002b.GAE@google.com>
In-Reply-To: <69ea70f3.a00a0220.9259.002b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 23 Apr 2026 22:50:24 +0200
X-Gm-Features: AQROBzBaasg5YIHkhfyUsSgviLajQq7gb4LEvTp9RrMVBTYG76cXW_YMQQTM7WU
Message-ID: <CANp29Y4JiMF-T1GOkPWs4aF3e7NgVD1KVPzm=_2N5rfFaG9MhA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
To: syzbot ci <syzbot+cid8a1874d28ce2fb3@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Apr 23, 2026 at 9:20=E2=80=AFPM syzbot ci
<syzbot+cid8a1874d28ce2fb3@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
> https://lore.kernel.org/all/20260423140833.439512-1-seanjc@google.com
> * [PATCH 1/5] KVM: x86/hyperv: Get target FIFO in hv_tlb_flush_enqueue(),=
 not caller
> * [PATCH 2/5] KVM: x86/hyperv: Check for NULL vCPU Hyper-V object in kvm_=
hv_get_tlb_flush_fifo()
> * [PATCH 3/5] KVM: x86/hyperv: Ensure vCPU's Hyper-V object is initialize=
d on cross-vCPU accesses
> * [PATCH 4/5] KVM: x86/hyperv: Assert vCPU's mutex is held in to_hv_vcpu(=
)
> * [PATCH 5/5] KVM: x86/hyperv: Use {READ,WRITE}_ONCE for cross-task synic=
->active accesses
>
> and found the following issue:
> WARNING in kvm_hv_vcpu_uninit
>
> Full report is available here:
> https://ci.syzbot.org/series/e1f68dae-f32a-4112-a163-7a00f36d6508
>
> ***
>
> WARNING in kvm_hv_vcpu_uninit
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      85f871f6ba46f20d7fbc0b016b4db648c33220dd
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/4f8c36c7-e865-4f65-bb81-e22962e8a=
1e0/config
> syz repro: https://ci.syzbot.org/findings/60fac5d8-1296-4ec7-a8e3-40f561d=
007e9/syz_repro
>
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || !refcount_read=
(&vcpu->kvm->users_count))
> WARNING: arch/x86/kvm/hyperv.h:79 at to_hv_vcpu arch/x86/kvm/hyperv.h:78 =
[inline], CPU#1: syz.2.19/5974
> WARNING: arch/x86/kvm/hyperv.h:79 at kvm_hv_vcpu_uninit+0x163/0x1b0 arch/=
x86/kvm/hyperv.c:906, CPU#1: syz.2.19/5974
> Modules linked in:
> CPU: 1 UID: 0 PID: 5974 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:to_hv_vcpu arch/x86/kvm/hyperv.h:78 [inline]
> RIP: 0010:kvm_hv_vcpu_uninit+0x163/0x1b0 arch/x86/kvm/hyperv.c:906
> Code: 48 89 df e8 0f 0f d8 00 48 c7 03 00 00 00 00 eb 05 e8 e1 8c 6d 00 5=
b 41 5c 41 5e 41 5f 5d e9 c4 a8 5a 0a cc e8 ce 8c 6d 00 90 <0f> 0b 90 e9 65=
 ff ff ff 48 c7 c1 00 12 12 90 80 e1 07 80 c1 03 38
> RSP: 0018:ffffc90003e07940 EFLAGS: 00010293
> RAX: ffffffff81592fe2 RBX: ffff8881b6acd380 RCX: ffff8881046e4980
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: 0000000000000002 R08: ffff88817696d743 R09: 1ffff1102ed2dae8
> R10: dffffc0000000000 R11: ffffed102ed2dae9 R12: 0000000000000000
> R13: 00000000fffffff8 R14: ffff88817696d740 R15: dffffc0000000000
> FS:  00007f4cc3a9b6c0(0000) GS:ffff8882a944f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4cc2c4edd5 CR3: 000000016d918000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  kvm_arch_vcpu_destroy+0x1a9/0x380 arch/x86/kvm/x86.c:12963
>  kvm_vm_ioctl_create_vcpu+0x69a/0x930 virt/kvm/kvm_main.c:4269
>  kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5168
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4cc2b9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4cc3a9b028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f4cc2e15fa0 RCX: 00007f4cc2b9c819
> RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 0000000000000004
> RBP: 00007f4cc2c32c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4cc2e16038 R14: 00007f4cc2e15fa0 R15: 00007ffd36efc848
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [kvm@vger.kernel.org linux-kernel@vger.kernel.org pbonzini@redhat.com sea=
njc@google.com vkuznets@redhat.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/69ea70f3.a00a0220.9259.002b.GAE%40google.com.
