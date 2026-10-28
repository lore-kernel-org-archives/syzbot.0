Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793178996;
	b=iYuOvaR9AxBxD8ucE97AmrEwjV2ALb0jRwgLCNc47eyWtA5mL0a7m03v0/qGd6v94a2r
	 UG6lYNTCv7pIaDc57DT77BTu5C0tW20viQ+UbeqXb/qve/jMHTd/5J9lcqaM1VNdp6O8P
	 75oGO2nQTyu2A1cjDpRDTFl97/pKwFEBTtn0mnDc1PErRXA6No3kRroqk7Y1WNlxyPNZW
	 A+C55K8XMEELHzcjwra0pMgzxjwNnEdyeDeiTngFwNo80+oRk5dlO9DiS3I4ZM6rrjAaG
	 fyX+8jc2APQdigR5bMrXm8a4KNrch3tu+YmnfQCdMltquzj9HU9E1i4ia5TAONgp98w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793178996;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=TuTV8oCEarXR9Vq6bpayc/vEIIXhdmb7RzdU8yQprpA=;
	b=mZSo68HGDWJQTRP047jcmtncm5o3XSTc2eqHHcTJ6B/DSyke+vWMv0/vZ+ZqFAK401qD
	 Z3/xCEtd1UBkyTTsznYTXWuId7R60FmBf5mBByDuNCU2wJhyQT1X+pSEPGQmUJYKpJsKS
	 tzzCrMEQBQJDnJEaSRNDAssRzi91jLChSxEoin4kAiFzzn/kfnivhzjI/CEkF2FZ0CgN0
	 OHq29Mppd4kXn92DhDT4O2yYtP9slNTqz+pI7biNp1N/CgGtDAos2Rz3g8V5Suva5G1/Q
	 4Xf2ehCWBe4j3hQSRG2WvluOS02xmXO1sE8Clz+JT/O9kUePQsxD4YpShWhJ9QBDRQg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HWSSIAef;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.179
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73357606A31A
	for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 09:16:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73357606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HWSSIAef
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5363c8de563so9782191cf.0
        for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 02:16:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793178995; cv=none;
        d=google.com; s=arc-20260327;
        b=IqYGwutdJbgMFS1+rLFzrEda5sk1o4YA38wLi/rwy6S0kegyx3Tuw0vRehpw0b8iXp
         zlX5zliVCV+sStxDocKIw1ZFC4t72Q79UJVZ0Y6R2gzvcgtMLhd7zZIxGbNZ/s/37HbM
         wutiLgD9bRa1mWPGTRC19K6FD+UzYhgLbg7a3nIoMUb3F29i9j6ESI3TjX/xiTXI6RLk
         UxSmPEUix3CkCnQMszydBAFOk/KbIn+9izEOMLFwDI+/lj052QOi+o5Xsk4I/pa13hhv
         pIpf95KWxLeUV7h+od4o/QNg1lVwVoXrpOBTL05OjA67YZuejkhDYahbCpqQ2tqaZAcv
         R/8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TuTV8oCEarXR9Vq6bpayc/vEIIXhdmb7RzdU8yQprpA=;
        fh=Gkgku+GGol244pZVTTMeS0468syjmRvsnUrl+HMlwYw=;
        b=sRjK0Xhd26FmYIH4+OmqZ+kAwVEg2eAUTyAmm13V2QWYvsGG8rwYd5VZfNf/424ITP
         kHocJp1IFN01qhRwaQ8JLMVEpXbPlseXDzq9AWnIuSpBgKRQKIpJdWbyhM+iWtv0jCdL
         PH1konB5SRDPQOCgTalJN3g7OXh+pj2KrxvOdqCelDD9Zn0VRyX7LUnoF/WShACyRdz8
         +ZJNoIpFD4tkPTiMSqjttpIq1Ra9DPHkZcGOaBKslIVwY/7WOTJ/ZU4vjal4FU8ijBMr
         ohAjPwzw/tzUkSoP+9ZIlHrtKvsZPVHm46yaeGB7qkr6DZfJoetpa9ivXMBRunyO3gx6
         szuQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793178995; x=1793783795; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TuTV8oCEarXR9Vq6bpayc/vEIIXhdmb7RzdU8yQprpA=;
        b=HWSSIAef/R1GpV07TobVx+UdRGmA+0QYUPlNW5ngn2bVYbr+eCItw77DjPMiTagUsw
         SwgwZfZaTA8243w0kA+Xqwg1U/+XWpTGyCXyleECgDiL7/x+YidPARVNmL+BmO+bXC9H
         eViZ32AENMsKusxLjm5o+VdJWfH/sMfMBojc50pLBklEo4ZmidfpzDJChuTyxsxqsC1S
         4SOaN0ZPWOCw/pQvl3oHjaw7h+TLbP0o5VSB+qi/Fzz71EjO2fx93Yg0nOarmWYH0DPL
         szTdTjn1amV+Opyxw8DnbAiRcmIzFQr9BzHeMtwNTYnNEEvcqf/4BVXeGBbuSUA2wn+i
         Kh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793178995; x=1793783795;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TuTV8oCEarXR9Vq6bpayc/vEIIXhdmb7RzdU8yQprpA=;
        b=iGWcC6qRb/GkVmFdMT1/KhS1PADDzPL2BViSJrf28xOGIMxVLiibIFXP2ZkHHfNyhM
         CCO0vaal1Tx9TNNJTxetl2rASXZ8TNdHPS4TXRKCTBKjRDpF9sJ7u/rYcR9TsdOmp8hk
         7RlBl9fr9E7auuUUGyw+/fXK3Fo6KDalrmvfoJl7L1+jPeW3kM2rpFfGLr55bHMAhHDk
         x9rrgzOjRYN57TdiXecz4/7M0pXFjyHJI8I9SNgybkz98KsvKkv6gUAmBrl/fZUOw3Ve
         gsJmzsaJqjOuMeBDRyQM3uWv+oKZ2GBKFqVFXGkY8HG9wcIjIBCzPS98NP12jQr2mBe5
         Pzuw==
X-Forwarded-Encrypted: i=1; AKwUvBzA1b7N/X1bmhSxveOdji6R58HJhMdOFzR6OfyI17l6xa9UoXWxVKAUsRcouiIpf4W2P9PBjIw=@lists.linux.dev
X-Gm-Message-State: AFq9FYIzlikOTQZKXaSC/L9By1vVX4k3AXH66woWVdzl7qZ9RVD7N8Ec
	Do52Fc0FS6Z0JrVHrEE9Rhifm+FWsQqQTrGed370GZPr2KSWXcHSvNhe9q8RL0e5zEO4q1QSWYy
	nvnXxR2S7QXUYQGLQQuNhU2auTOtTTFP3CoDqn7lv
X-Gm-Gg: AYBFou3eEgEXYZVLlPm7vNTsYL36AyJ3lfbdKuRMj1PUzw4pDJ0xbOnwcq5EbGMtCDj
	s89WdZuDAQBTyC1tKfrVZ2yhuyJ4BN6oe6PS2UJXt1y4QrK6wrH+MePTJqTseRHO/n/0Lw0Zben
	tV8urQDE45LIFMBylJoeQiq+ikjKd7Kbi4A4wcgUS3oqYYV5rY1aaMV8cMBLzVqGcv1vz1wqRHm
	/nrQYNZXISFzaGrZ0MwrBTEjswtWC95qOHW1JSz5UHqBiDh6LkjenFcb4rqVoIO7eucWIF4c/QP
	GNNktSgm0Z7qJPi6PUaejPXCGy+Zx7TLK3V7jXwpaj+V8YL/hyXrRBDktllaqD8j5bjHwkcWbox
	ssktKZqiO8mKVy6Be9R5FzDErwq9S8qeDmbNmeta80Y4oqEb/T3wQG2gZ5/2hfR3LUhtvjlVWvK
	sKBMZfwosZWqrNv/6+/rS9
X-Received: by 2002:a05:622a:1906:b0:536:8bb3:ee45 with SMTP id
 d75a77b69052e-53fcc0e4207mr28900431cf.30.1793178994719; Wed, 28 Oct 2026
 02:16:34 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae1bcd9.f0fe5aea.79aa1.009f.GAE@google.com>
In-Reply-To: <6ae1bcd9.f0fe5aea.79aa1.009f.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Wed, 28 Oct 2026 10:16:23 +0100
X-Gm-Features: AclHuK8hsYW7n1beM4KzP0zSVfglzRgwn_m1xwssMxqQJEQ5D4eaG6cS9hC3lBo
Message-ID: <CAJWNTGxrNLs6Yp=mG9YSAfdEnGeUD-OEPMR9qKzMTn_02efrcg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: Fix+harden against bad uaccess using
 dying VM
To: syzbot ci <syzbot+ci1eacd2ff5765fce8@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Oct 28, 2026 at 10:14=E2=80=AFAM syzbot ci
<syzbot+ci1eacd2ff5765fce8@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] KVM: Fix+harden against bad uaccess using dying VM
> https://lore.kernel.org/all/20261027221209.1560865-1-seanjc@google.com
> * [PATCH v3 01/15] KVM: Reject user accesses to guest memory if current->=
mm !=3D kvm->mm
> * [PATCH v3 02/15] KVM: nVMX: Don't force a full nested VM-Exit when dest=
roying a vCPU
> * [PATCH v3 03/15] KVM: PPC: Flush/zap all memslots on kvm_arch_flush_sha=
dow_all()
> * [PATCH v3 04/15] KVM: x86: Unmap VMAs for KVM-internal memslots when th=
e memslot is freed
> * [PATCH v3 05/15] KVM: Disallow setting memslots when the VM is being de=
stroyed
> * [PATCH v3 06/15] KVM: Destroy memslots immediately after mmu_notifiers =
are unregistered
> * [PATCH v3 07/15] KVM: WARN if KVM attempts to do guest-related uaccess =
with "wrong" process
> * [PATCH v3 08/15] KVM: WARN and reject guest-based uaccess if VM is dyin=
g
> * [PATCH v3 09/15] KVM: Pre-check uaccesses in KVM's APIs to read/write g=
uest memory
> * [PATCH v3 10/15] KVM: VMX: Explicility free vmcs01, not the current VMC=
S, in vCPU free paths
> * [PATCH v3 11/15] KVM: nVMX: Don't explicitly VMCLEAR+free() vmcs01's sh=
adow VMCS when freeing vCPU
> * [PATCH v3 12/15] KVM: nVMX: Cancel the nested VMX Preemption Timer's hr=
timer in free_nested()
> * [PATCH v3 13/15] KVM: VMX: Explicitly remove dying vCPUs from the PI wa=
keup list
> * [PATCH v3 14/15] KVM: nVMX: Don't switch to vmcs01 when freeing a vCPU
> * [PATCH v3 15/15] KVM: nVMX: Don't load+put the vCPU when freeing nested=
 state for a dying vCPU
>
> and found the following issue:
> WARNING in vt_vcpu_pi_remove_from_wakeup_list
>
> Full report is available here:
> https://ci.syzbot.org/series/c648fc23-f4c2-4346-93cd-b717ef38b27c
>
> ***
>
> WARNING in vt_vcpu_pi_remove_from_wakeup_list
>
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      7e60162b16f9da0d2fa83da5c1723b6853a0ac1d
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/e4ed6c4f-9b58-4549-9ac6-525add47e=
472/config
> syz repro: https://ci.syzbot.org/findings/320f356a-c5e9-41ff-b8f5-3f0866e=
300b7/syz_repro
>
> ------------[ cut here ]------------
> refcount_read(&vcpu->kvm->users_count)
> WARNING: arch/x86/kvm/vmx/posted_intr.c:154 at vt_vcpu_pi_remove_from_wak=
eup_list+0x142/0x1f0 arch/x86/kvm/vmx/posted_intr.c:154, CPU#1: syz.2.19/58=
70
> Modules linked in:
> CPU: 1 UID: 0 PID: 5870 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vt_vcpu_pi_remove_from_wakeup_list+0x142/0x1f0 arch/x86/kvm/vmx=
/posted_intr.c:154
> Code: 48 85 db 74 2d e8 ee 1b 64 00 eb 0c e8 e7 1b 64 00 eb 05 e8 e0 1b 6=
4 00 5b 41 5e 41 5f 5d e9 c5 b5 87 0a cc e8 cf 1b 64 00 90 <0f> 0b 90 e9 2b=
 ff ff ff e8 c1 1b 64 00 e8 ac 60 cf ff eb da 44 89
> RSP: 0018:ffffc900037cf8c8 EFLAGS: 00010293
> RAX: ffffffff816404a1 RBX: ffff88816ada8000 RCX: ffff888110eb0000
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 0000000000000003 R08: ffff88810fb01f83 R09: 1ffff11021f603f0
> R10: dffffc0000000000 R11: ffffed1021f603f1 R12: dffffc0000000000
> R13: 00000000fffffff8 R14: ffff88810fb01f80 R15: dffffc0000000000
> FS:  00007f9e487ab6c0(0000) GS:ffff8882a7cbf000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f07a7ed4870 CR3: 000000010eea9000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  vmx_vcpu_free+0x28/0x400 arch/x86/kvm/vmx/vmx.c:7517
>  kvm_arch_vcpu_destroy+0x154/0x380 arch/x86/kvm/x86.c:9556
>  kvm_vm_ioctl_create_vcpu+0x76f/0x9f0 virt/kvm/kvm_main.c:4384
>  kvm_vm_ioctl+0x442/0xcb0 virt/kvm/kvm_main.c:5294
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9e4799f1eb
> Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 4=
4 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0=
 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
> RSP: 002b:00007f9e487aaed0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f9e4799f1eb
> RDX: 0000000000000003 RSI: 000000000000ae41 RDI: 0000000000000085
> RBP: 00007f9e47a36b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000c00000 R11: 0000000000000246 R12: 00000000000004ce
> R13: 0000200000c00000 R14: 0000200000001040 R15: 00007ffeb7342be8
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
> [jmattson@google.com jthoughton@google.com kvm@vger.kernel.org linux-kern=
el@vger.kernel.org linuxppc-dev@lists.ozlabs.org maddy@linux.ibm.com mason@=
kernel.org npiggin@gmail.com pbonzini@redhat.com seanjc@google.com]
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
-upstream-moderation/6ae1bcd9.f0fe5aea.79aa1.009f.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
