Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8F03B9D8B
	for <syzbot@lists.linux.dev>; Thu, 15 Oct 2026 06:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792045770; cv=pass; b=BavIeqriqDXnYo+IlTQn/I6dwKAJFm3p/j5kM8vFGLE/J2Bi0E/E8Chw+RzKfzNp8rk9adJXzykBb59HyPubX2zdTPHnxHJRGIRt0FQMD+UYRYJCKpoX7pvWOZacxble8NyRVcrNcvuDlvrQymtU9hmU4tZEdi3PR6Jh0Q5a35s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792045770; c=relaxed/simple;
	bh=Wxb+7kR6dEYYWy66ms5d6iGDcbgzLG0hy8rOr0rGwOk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GWE5BewoAiwgZD1mszSHU0hdIp5fxZ/Ft8m1FrqrPPws7ZeEeEQ71hrGe68Z5XKuC38wLNpbKHUNMiwSAP3/dv0Qo+hOsu82zLMIPxLXGc7Sf42RK+kZk055W4t+OvuHQbVarX/CBkZj2nzqXKpihtkiqfSpDn3H4ogEBy4JlTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q9WtBoMj; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q9WtBoMj"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6d68de53053so2088851eaf.0
        for <syzbot@lists.linux.dev>; Wed, 14 Oct 2026 23:29:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792045767; cv=none;
        d=google.com; s=arc-20260327;
        b=aLXsdUr8xO8Xfg/SjlCc2Ico3n9kWc96xUV7dz1L4r8YZYdMz3ZyC0d1OHjFV0LinS
         OD02eeLqF1G3mJJlqd1+FFSvo0iKoWJenXV+0On7RBqcLjula81YgNTgZWMi6V/R9rer
         ijdgJZDdgm1CW0jidz72emO8gG7y87Qfes9pfL6SUDDafv8K1tsi5KaPNHZKTxfdTe6g
         9orHAHkMA5ox/MAucqwyGpyc1IFhXLrR3GFpZWv2mDrkEeG5Lp+npcEYWEKDu/NM0MTB
         QKuTjLcLP51+QXDGB/H3NkT0ZyQiplEJA4Uh7GVZ4O05ULbjouNyd16z6bxwSQfs9uzq
         ZIIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oHGy0oy04i67uF1SHircFo/39hqNdcT4GWRuMIwl7n0=;
        fh=cj6AXZLHXBx1elqEi3ruaR+EgxfRszIt2CpNHlu874M=;
        b=fjay11ECENRYymUD2ucKamz1N/kAgnIXPcn7Cd2S7IwCJVve3CquZJiQ0+/wDFn1kM
         McKHdDRr4rmaVz53h0C7/bVNBML/TQPbdvyWeK/JqdmbzG0gNJGTa8y/okn04ocw+Yz7
         1IgAGj1YlhNqajIqGhCVnmJEch488QhajzJfNxVCxc+wQmO5LJBUbfDZdxTevVhlAZtV
         X67qfK7W9pNGR4bIBrzX3w2/u4+3M80Z6C+Bir+BvWBR6R6yaGHcQCuV99XH+zrxeefy
         AH8v3rigYnF8SzQ/OBurkbha4EPf0e1E41584A9XO/SYqcaxuyuOtsSi+ltXzUaEMiof
         WxvA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792045767; x=1792650567; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oHGy0oy04i67uF1SHircFo/39hqNdcT4GWRuMIwl7n0=;
        b=q9WtBoMjksTkKcvAoDifU5/G6cX4bswzpXnfz1mm3EUjdQT4jPqOTSj/s+8HEwt1c4
         WcQA5Sfv3lpMYuABxIkcpNady86ne/YQ3K4czIAroY9TDnSaifBUYpGVbZ71Lc9eSMUg
         ojFP6+aCCzrlKYeF/Lkfq1//e+fQtEUQnvs+LQg0wxqtU52cNovzcRcFce9Ib2PTTF1L
         jd5aVIq99OsgDDOBuAeTZurPySBELX5OpD3mt4RUIQWN7srxAiqC3m3RfJgapQ1Z+xtM
         T/CBPnEjQ2NAHWQNQavHrMpvPBcjjAkUmtp8cRVnO5y1S9KlvnC5vIPug3mXR3nkRrLn
         dzVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792045767; x=1792650567;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oHGy0oy04i67uF1SHircFo/39hqNdcT4GWRuMIwl7n0=;
        b=EgozaJpO36tP9OG/dtLsVALzmJ0u+d9h7mioM6jv0ftA/OhrkgZwmuev6N7/+nZw8o
         FQOW6G+2OrvcrcCWax3emn8oGST6G5nophjjRGC7D3iURRFkm2Xn9Rvcn+p6XswBy3qO
         AIagscdLVQLcySsnB0dXxHASE9WCIPnyHrHFrAlxaR+7NkqMCLROk3MrhAEYiNr8awqw
         gHyVjgi0wwVdfKevyjqn7RyWUQoH77cezySZihjvqWfZv3k7faYglnHuKpxQFwjHzTFx
         zr6I3kVxXe1EpMOgQS5nOZ8WHKjgud0VVcObks/t4J2+KPtLZfAyIcER+j7hb0/L4Ju4
         QIVw==
X-Forwarded-Encrypted: i=1; AKwUvBz3alyIiBg3I74LsG7sTKWRvBUQFvU3s8FAmutbnpL+XaK2i8UlP9RtlO9xCxLySgkuSMGq8ek=@lists.linux.dev
X-Gm-Message-State: AFq9FYIkBb6H8zkO52fAm3ZehI4qH3XwzLSVlmeKxDx0sVVTakzuLRlD
	BNkSlO7cS0UtxCZvHFXOZXWmAU3W/Y00cMCDLphleenTk0YyDpodpwzA4Ahuxwu9pqO/W432Hzp
	HZlfbju+ZdZ52IS+zerHvBJTO/la5aPCn+LDf9qvu
X-Gm-Gg: AYBFou1a2+HNCycBwbUalMZHFB0hKm5Uiv2RKgqy0r54vcZypo75cByWhrLg2+xPuaK
	vsrfBW8Q1TKikOtoRWdelBEOHILF2ji/GfemZV8GNenn6EF39njmM7sWQDkOFoAZcV02xqEq7NU
	3HyHAwXE0F4sUG9dt35hELfMJl9w+qudmCWgv1rFT4Umbh8BS35cHY//3Ry/2E8G4AGAWL29t/b
	hnUfMC5EAUYDVP+vRL1FCnfq5F05aj78xr5v0aLFb8G4ntG5fV2krZXJUz6PhxGQD3oJeCOCawc
	7vpDlAafa4WQqGLBncXiKcAHqaDmouttfZY3T24j7dTPsFRRIZ/XQ3+Wc089Dc4BbJvWXaUDzQY
	Go2+TkXSoqVdNaGiCqf32TwnO0i+j4B05hmMGGKXphuPKMi6hLL8GcQ9z/4mE8yjcw5iP0f+hGn
	+XLwO4WXYH3ZgjVLvuJXW3kdUMiQ==
X-Received: by 2002:a05:6820:160a:b0:6f9:59ee:cf9a with SMTP id
 006d021491bc7-6f959eedf5fmr6510481eaf.7.1792045766677; Wed, 14 Oct 2026
 23:29:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ad07190.7ce658ee.3494bd.0006.GAE@google.com>
In-Reply-To: <6ad07190.7ce658ee.3494bd.0006.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 15 Oct 2026 08:29:15 +0200
X-Gm-Features: AclHuK-LTW6QXM2n4i_ag48Tiiv3bKBqe6phD9n95Q7XAF3AO9TARpCHeHlVEw0
Message-ID: <CANp29Y5DYttJr5ccVgjpnDcbA_=nvoFN1_ASpe6KOM_v5NoEzw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: x86/xen: Don't drop event deliveries
 which race memslot updates
To: syzbot ci <syzbot+ci2fb68a675810f96c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Thu, Oct 15, 2026 at 8:24=E2=80=AFAM syzbot ci
<syzbot+ci2fb68a675810f96c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] KVM: x86/xen: Don't drop event deliveries which race memslot updates
> https://lore.kernel.org/all/20261014220508.518772-1-dwmw2@infradead.org
> * [PATCH v2 01/11] KVM: pfncache: Return -EAGAIN for a lookup which hits =
an invalid memslot
> * [PATCH v2 02/11] KVM: pfncache: Add a 'wait' argument to the refresh an=
d activate functions
> * [PATCH v2 03/11] KVM: x86/xen: Don't block on xen_lock within the vCPU'=
s kvm->srcu section
> * [PATCH v2 04/11] KVM: x86/xen: Wait out memslot updates in the Xen attr=
ibute ioctls
> * [PATCH v2 05/11] KVM: x86/xen: Don't lose the timer event when delivery=
 fails transiently
> * [PATCH v2 06/11] KVM: x86/xen: Retry event channel delivery which races=
 a memslot update
> * [PATCH v2 07/11] KVM: x86/xen: Extract delivery of event to vCPU into a=
 separate helper
> * [PATCH v2 08/11] KVM: x86/xen: Explicitly tag "shared info" page as nev=
er being dirty tracked
> * [PATCH v2 09/11] KVM: x86/xen: Don't dirty track "vCPU info" page
> * [PATCH v2 10/11] KVM: x86: Request the guest TLB flush from record_stea=
l_time()
> * [PATCH v2 11/11] KVM: selftests: Add Xen evtchn vs memslot-update race =
test
>
> and found the following issue:
> WARNING: suspicious RCU usage in kvm_gpc_check
>
> Full report is available here:
> https://ci.syzbot.org/series/cde10220-9f8c-48fe-a62d-36d3df4d9a0b
>
> ***
>
> WARNING: suspicious RCU usage in kvm_gpc_check
>
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      d4b7fb647204f0c81dfeae2d1a708e4d858e0c94
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/dbdeec8a-a092-44d6-96b1-12ae99a6a=
0ce/config
> AI triage: https://ci.syzbot.org/findings/35b5a98d-93a1-4f38-ad62-620c40c=
551e8/triage_trajectory
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/linux/kvm_host.h:1094 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> locks held by syz.0.18064/14640: 3, last CPU#0:
>  #0: ffff8881133851a8 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0x27=
f/0xfd0
>  #1: ffff8880201d5d30 (&kvm->arch.xen.xen_lock){+.+.}-{4:4}, at: kvm_xen_=
vcpu_set_attr+0x4d/0x1250
>  #2: ffff8881133861e0 (&gpc->lock){....}-{3:3}, at: xen_get_guest_pvclock=
+0x29/0x260
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 14640 Comm: syz.0.18064 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  lockdep_rcu_suspicious+0x140/0x1d0
>  kvm_gpc_check+0x325/0x380
>  xen_get_guest_pvclock+0x3e/0x260
>  kvm_xen_start_timer+0x160/0x5f0
>  kvm_xen_vcpu_set_attr+0xbb2/0x1250
>  kvm_arch_vcpu_ioctl+0x1485/0x23a0
>  kvm_vcpu_ioctl+0x7e3/0xfd0
>  __se_sys_ioctl+0xfc/0x170
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3c49f9e559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3c4ae4a028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f3c4a226090 RCX: 00007f3c49f9e559
> RDX: 00002000000000c0 RSI: 000000004048aecb RDI: 000000000000000a
> RBP: 00007f3c4a0358b0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3c4a226128 R14: 00007f3c4a226090 R15: 00007ffed7dff5b8
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [dwmw2@infradead.org dwmw@amazon.co.uk fgriffo@amazon.co.uk kvm@vger.kern=
el.org linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org paul@xe=
n.org pbonzini@redhat.com seanjc@google.com vkuznets@redhat.com]
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
-upstream-moderation/6ad07190.7ce658ee.3494bd.0006.GAE%40google.com.
