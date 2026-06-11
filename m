Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6388408601
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 16:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781194509; cv=pass; b=Y7WZ2hGNqLTLlq9XPD5hSQyfP+rDqZ1CtnwAkVk6fhVO0b4C96IpadScNE+kN5oWd5PEpnZB27lS+5ZmNI56jdWAbN59wJpsL6WevyfC8ev02jOpr2eQfeiXM1orrPVOf0/UT2EHrIsLVREjaBNbqmQ4pd6Jys9A2yYWC0q5z6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781194509; c=relaxed/simple;
	bh=kWMe9+yXiWMX/fF4a8805qzr2iHiPgj9gteJPXZTl2E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H8yqZz4VXAjhOv9mbFpxARBKNyDN+Vs5h6krk55I6ZlwHvDr0fMJtTIIeCzLUop/+3ccjObfThBYjdmLkcwc/ORdi/ddaVHoxU12Ii/TRHK3i+Xx4KjVygyeLEIcwqGJ+/8owlv0NcJ4FfVMZKEmi3I0YUQ4MiWeoAtJ4G0TlWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AR+ynDKH; arc=pass smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AR+ynDKH"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-486118ecd5dso67532b6e.0
        for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 09:15:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781194507; cv=none;
        d=google.com; s=arc-20240605;
        b=IEtPnFf91DUXyXenGPP19SOAGKd/KDo9djzgLD6SxUZCOq56sA2br/DjWz74tFNuRa
         dw853j6tG1sAEJGQ0o6JYD5l0axxg76c4DoUN3cisnB/kkbNhi6kPJ++nmTYuc/hAyq7
         UMqm/bU+VRa5L4lU3ZgUq5HM/wWFb57BG92Dr0APq9xKS/dR7QiN05oID8MusrywYgh9
         B+L8BpJwbLSCQO4nJwIzEZrbhJyakgwf9NB9xcgjQmT6LrrpirHeo6P8UvT9VVurCDCL
         OvqPr7GHvyn6Cj3tFM/fzSdqPO2diZ9EeGam/hhLcvoNmjXJ9kpzkHXCpp9rvv8DM74G
         /r2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=72oLF6jixVTzC9ZMIFRNgxKk1/886lzmLphtlo2M5Rc=;
        fh=GNMAPdQsb2+QAoiB5yzoUmin9sWRrNUJMe7/sjMuJXk=;
        b=EHUf9cP6WLE3c2IvmPKcQReMvQLEffsJTXkisRmcD4JWwIMa7tx+Yk5ObFtmUI5EmR
         jmP/miV0K8e1i26T5KXGkuUvXRVo9IwOLikuchHR8rbudL2fNqiZ4xhTUzxlIanMkmTA
         KNKu0qZKcWQU7aHKEP2cLJSaQYBC41Zyc69y+KubriTI2/AXKmsXswRTTuE6LpG2CP64
         gcQQnGPuN7SQPGYM/HTwg+vTxDiyvacYfySUrizOyrH2wM8ltYy6zCBDHItZGoR8mFHL
         rxKfDsg+c+GzdFk6VyCYLVsfOUJTBJ/kzvFDm2bGzQxWS2BVJQeTGBXJiojLVh4sfGID
         fF8g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781194507; x=1781799307; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72oLF6jixVTzC9ZMIFRNgxKk1/886lzmLphtlo2M5Rc=;
        b=AR+ynDKHHlgnSmuxTVQhDK+iRoE30U77rTvEuegINrGEDEiOSTruSBXu8z5RySyDBO
         rNZmnyyH/u9E+tWR7/V4jxZ2kYRMpUpGAUGyjfBfcjLvFHIoUL3H1L+oLCsNjG9FBG63
         bCB8LHDA1n03J+LseBQxBN20KQ4EMOxTgmtZzmtySEIryDCB0/UmeWLEjC8wEzzop5cr
         Mg5pWtk9fc7ILRRVDNn2Cem2EEeiJ2edaB9KoVDlU9dGGK45NgEK7OMldxPeOkIIT3AX
         JQhUaq+zyglFqYE6b3p24bo4tbNUNLju1nSngdSYOXxKhSupknRjRZR+rnwcZyRwe6/i
         97Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781194507; x=1781799307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=72oLF6jixVTzC9ZMIFRNgxKk1/886lzmLphtlo2M5Rc=;
        b=b5gthRL9l65DbW2IFDJ9WHL6k/vU67MMHZwTOyFmL1aAMtcJP3/fHDT/7EO93/bV/b
         VGbYdh7BYDu56fCobCnEjX4VUdL+eC/DnY7oedWvrtKXeVgDeLunb6WpK5d0CA4jZu87
         TibjJhfg/EsJ12sAsLTYn+WX6a4BF/k4h7FEgj/ZMAHCxN6O5CH7cx7hdUuW+b490Sqa
         meAAr5GoU063f+pfYeEyDBi1Ati2f5h2NbZhvChcnkLAVJGlc1azWEVOuXyX5M7IGHbR
         fjg0y+NDAUfGpqWU0352Zu++GeNyrWNepmNNP/WNfM1lNfGygBACFGyS5W6roTgaTQj8
         qppg==
X-Forwarded-Encrypted: i=1; AFNElJ8fDr7zlznimC8lT+t58Yoldu5ZCj9dUU75PFYvLlt0+fljpZzCr7SW46TZGA81e5JnH1eQp48=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwQO9Ns1F4lXKz26Xd6kYMknKONeZoanoWbdy7FRVIYPYnROcI
	gcl4dn9P4AoWNQIrkSxR7+3GmNjCA+n+fqOeNzjH8mr5Z4qOnK0MKdUY1AtDhvMhKbW5i8IMwzf
	s/0hMSHQi7flrhoXv8vS1Fsm+vyvobByjnu4euh8q
X-Gm-Gg: Acq92OGmzjr/yr1JrpQrO/wj4PmdaWD/od5JYsTDU5i4rB7qzltEQ9I5kfoE8EjBcc4
	mjUV8ZJXmOoto+f0oHHGcrMq4Yz0aeP4V1phODtT7bs6044DfpCQi9W6FC6VjntgSvKlWwNNL4j
	qclBfDXblLQbi9xpGSfWhAkvLVz0rIk9ESJGIfnvlbQncu8TsfU/+nC/5SSCQ/lEanf53LHV4+x
	/jgVXW5MMk+467sHxDqEtjWrlN55EqPekr+8Ox80wdmbfftnad2CuC0CRf94Va2HFVgIZHihJ2A
	I/p9G40CnUw9/oi5jaS+owMV//HTcbJPfFMstAovHjhEtjPrejrqic+xaQjHhOGfx1Gijg==
X-Received: by 2002:a05:6808:1801:b0:467:1212:46fd with SMTP id
 5614622812f47-4871a58b3bemr2362115b6e.33.1781194506337; Thu, 11 Jun 2026
 09:15:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a2adec2.58e8d1cc.3928d.0006.GAE@google.com>
In-Reply-To: <6a2adec2.58e8d1cc.3928d.0006.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 11 Jun 2026 18:14:54 +0200
X-Gm-Features: AVVi8Cdppb9l55bEV2kfRQvUaxe4JJZ069KyNLd4vX-GR1H7d22O1x4LO5XNaX4
Message-ID: <CANp29Y6YJFn-FbY8d7wLV=Fi2kZ3mVonmjJGZX63hV1bdfLQig@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: x86: Unconditionally recompute CR8
 intercept on PPR update
To: syzbot ci <syzbot+ci06a7684d8fb5fb81@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Jun 11, 2026 at 6:14=E2=80=AFPM syzbot ci
<syzbot+ci06a7684d8fb5fb81@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] KVM: x86: Unconditionally recompute CR8 intercept on PPR update
> https://lore.kernel.org/all/20260610214523.2905255-2-clopez@suse.de
> * [PATCH v2] KVM: x86: Unconditionally recompute CR8 intercept on PPR upd=
ate
>
> and found the following issue:
> WARNING in vmx_update_cr8_intercept
>
> Full report is available here:
> https://ci.syzbot.org/series/d94aebb2-8082-4777-ab08-5c3a0d680bed
>
> ***
>
> WARNING in vmx_update_cr8_intercept
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      c1f7303302927f9cbf4efedf70f0512cde168c65
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8f417377-50a6-450a-8ce0-a83de33b8=
c6d/config
> syz repro: https://ci.syzbot.org/findings/62a660e6-a9b1-42ca-9cf0-7aadd2f=
5d292/syz_repro
>
> ------------[ cut here ]------------
> debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || !refcount_read=
(&vcpu->kvm->users_count))
> WARNING: arch/x86/kvm/vmx/nested.h:61 at get_vmcs12 arch/x86/kvm/vmx/nest=
ed.h:60 [inline], CPU#0: syz.2.19/5879
> WARNING: arch/x86/kvm/vmx/nested.h:61 at vmx_update_cr8_intercept+0x3de/0=
x4e0 arch/x86/kvm/vmx/vmx.c:6879, CPU#0: syz.2.19/5879
> Modules linked in:
> CPU: 0 UID: 0 PID: 5879 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:get_vmcs12 arch/x86/kvm/vmx/nested.h:60 [inline]
> RIP: 0010:vmx_update_cr8_intercept+0x3de/0x4e0 arch/x86/kvm/vmx/vmx.c:687=
9
> Code: 0b 90 e9 f1 fe ff ff e8 30 12 69 00 90 0f 0b 90 e9 59 fe ff ff e8 2=
2 12 69 00 e8 ad 86 d6 ff e9 ca fe ff ff e8 13 12 69 00 90 <0f> 0b 90 e9 fc=
 fc ff ff e8 05 12 69 00 e8 90 86 d6 ff eb a7 48 c7
> RSP: 0018:ffffc9000271f758 EFLAGS: 00010293
> RAX: ffffffff815d048d RBX: ffff888113380000 RCX: ffff8881142b8000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 00000000ffffffff R08: ffff8881114d9703 R09: 1ffff1102229b2e0
> R10: dffffc0000000000 R11: ffffed102229b2e1 R12: 0000000000000000
> R13: dffffc0000000000 R14: ffff888116d0bca0 R15: 0000000000000001
> FS:  00007ff34d6b86c0(0000) GS:ffff88818dc9b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffc75e78ae8 CR3: 000000010c609000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  apic_update_ppr arch/x86/kvm/lapic.c:984 [inline]
>  kvm_lapic_reset+0x1c24/0x2980 arch/x86/kvm/lapic.c:3023
>  kvm_vcpu_reset+0x44c/0x1bf0 arch/x86/kvm/x86.c:12986
>  kvm_arch_vcpu_create+0x746/0x8b0 arch/x86/kvm/x86.c:12847
>  kvm_vm_ioctl_create_vcpu+0x428/0x930 virt/kvm/kvm_main.c:4201
>  kvm_vm_ioctl+0x893/0xd50 virt/kvm/kvm_main.c:5159
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff34c79ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff34d6b8028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007ff34ca15fa0 RCX: 00007ff34c79ce59
> RDX: 0000000000000002 RSI: 000000000000ae41 RDI: 0000000000000004
> RBP: 00007ff34c832d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff34ca16038 R14: 00007ff34ca15fa0 R15: 00007ffe4bc28aa8
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
> [bp@alien8.de clopez@suse.de dave.hansen@linux.intel.com hpa@zytor.com kv=
m@vger.kernel.org linux-kernel@vger.kernel.org mingo@redhat.com osteffen@re=
dhat.com pbonzini@redhat.com rkagan@virtuozzo.com seanjc@google.com sgarzar=
e@redhat.com stable@vger.kernel.org tglx@kernel.org x86@kernel.org]
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
-upstream-moderation/6a2adec2.58e8d1cc.3928d.0006.GAE%40google.com.
