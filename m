Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793716701;
	b=m7f8RV9kuVFsm357s82NxblE1LwNv8UvbVv0vhLVhFliJzwNym8PAt+r+dLGhQeFp8lz
	 eh9JhzuOVG/I67IyYC9c+QQ3EzRC2MWnPq8YLBvLFHna+e6QCz6PPUiNtxsMsbKnwuzdH
	 yPBj/LTpJoUV1pfv8rAoVNR772nAJDGgPWhP18Y7zfcf0rUyJcU+Hlu/5nAppnuLGiv8p
	 eCz0pFjgc2O63jQBcI9WjoJe6TRYMaOmDmqdpyiGFGkU8G8GBVYGmG6Ls/8R8lTwUJi0M
	 sr03YzySrF9QZzwVGghPCO53iHdsxVYTzGj/XMpvvquLP/+0zgREnSnX/gNgSWaaRSg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716701;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=M3QjUMvw86UCVCXP6zCgY0vsl+8TFEPDFkovjZIm5d0=;
	b=YWa/Axu51GtGqVT9EIr0v9peD9fx3fmgyWoIeyYJSKgfe4NVNVP73+32W0Iurftbprn5
	 oVgKad17VkhDkqBLvC7R2Xl9+4gwXs+iVhbavHar/ev11Xr4m0aqQ041THP3785/NpEYY
	 c1YB9qAdJ6fEttzFJdSmWxUUCHSVVXNmejRboiDWe9FBux318vJbNy/9okZeTie1PA7XX
	 uvYZR6X0W6Uu5WFQA7Q/+hb4qIFoVyQKh4HTVuoL6ti99uKQ0e43GNmcPlISnB2V/z0Sh
	 M9K1A7skg0Rro73H90M6xm0c7tMqxMA8nfwfkcV98m3zKK/LmqHHiblyHwDFhyYZCVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Uevh8YhL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.54
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C807606D808
	for <syzbot@lists.linux.dev>; Tue,  3 Nov 2026 14:38:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C807606D808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Uevh8YhL
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-703be215729so1849526eaf.1
        for <syzbot@lists.linux.dev>; Tue, 03 Nov 2026 06:38:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793716699; cv=none;
        d=google.com; s=arc-20260327;
        b=dQv3a4oFlBy4zd6r/jwwWeLIfQkN+joilfBeAbNLmeoF3Yzt8lMMTroxdmPPhzgXFh
         MAWm6tl+xAjTMvNpplHwGWm7SWM/vRBX5pJfCmNBxRHfk5PI6O5RHuasjGfYtEtQYBk8
         lW9Lj+/GJcddWNr21S+D61Ja12cngsCwEieRagfN3mgUpYXophFPInugibUcqDvfA0h/
         SeFRBT0PqN9u/Z0S9kbs5Ua+rDBqYVRhQfyVLljvUmbpw2lbUMIv1omI/7MJXOnilmvc
         ZHUfkNd2VRgoWXJQHpRop54Rc23lwHfTEmZZGG+b4DZXoJLsARl7ePofRjIW2Ljfi/Yl
         M3MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M3QjUMvw86UCVCXP6zCgY0vsl+8TFEPDFkovjZIm5d0=;
        fh=t2ro5z7wxIMSQMeTy58cC+Np9rh02ao1f8lljqxkUNw=;
        b=JeSk4ALge1me6oJj2QzII/+h7vhy1/eveRkkE5irZNR3CoVNvPm+V6fooj62DBgKIE
         0dRM5ZBXfK2qu1T7ftJNst1fhocxONQWyOs76Q+VZhjVV2zbWkqTMXj1km1l+5Y9K2fV
         UQUN89grqD7TcztTmE+2ZpowHg1xpiHXaKfD8NTuRmnWz8SchGT3eLt254bl6n6M2VhL
         ZbjlsxBmcODLRkKZZ7rUd1fv3T4qCW4gBoYvjgKwACbx4e/c88cpLbPFdFCck2dS+a5J
         miQp4p5SY1XNoxhDJ46ctj4W70pKVlQU/Go1brMjKcZEyiGfSy9J1f9mvcO64tIGunk2
         3Mmw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793716699; x=1794321499; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=M3QjUMvw86UCVCXP6zCgY0vsl+8TFEPDFkovjZIm5d0=;
        b=Uevh8YhL9ZsfvUrZi/kiig7YDofH4GI89sW1bSEn5PydV6OKeA2ElcEje3GgYt7FRY
         N0m8pKnohV2+IElIg0ANAjXzLwyamz9ZBhJ3xolpIAA+gj9wkU1igccTAyJw33zMrgRV
         GB2BKig0UPJxd0fTTztsE6zxEVGpkReZRjCWbSGVrdJWbbSn/bSAnYp2TRpanxUlKI5W
         P02oTg+JgCib17hD+mp9cOs1JTyUwqiz7kkc+XxX0SsLxnFUD9+2us07wg+5abIThYWn
         wSe+XZ4J0h9w0DFLgV0+i/414Bjymkslwb6GftW/CKCtbeqzDablkkYeMSiMERL/1xLN
         spdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793716699; x=1794321499;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M3QjUMvw86UCVCXP6zCgY0vsl+8TFEPDFkovjZIm5d0=;
        b=JGZORKtSC1dItXcPST2/LNrMW3dOPpH08/q1ei+KJQlogBJf7ESMQ3z8JJB9DwKUkI
         hil0bV9cKCaEvuFLSdBLC0GMF/d986LRx4akEjLiP8PKGn+pP8x85RPThkwdQFReEbiE
         fxcIN68VDsBZrj1KF8TIG2XZltgBnPWUkDUr5pFnCu1TKJEJWwYIbkG7k3HLhgLF17Dk
         BRaTgup9zI+VsZPgmLlNBL85h/GhMqqXEeNub5qVfO6CgqI+6oVc2uY6G9gj1V/8e/j/
         m60fPchEmFpRL0MgvTpiuD9QPO5LD0OYrLcMx3VulafxRMZcKgAHB7YQ4XCwfyIeokT5
         sECA==
X-Forwarded-Encrypted: i=1; AKwUvBy0x4gOXF9BS9s2vXvFOnMgGRa/h1fhNb4UkSTyje0gyY8ynEKXZf/o/3d9IfRRn6Z+m/bXjLY=@lists.linux.dev
X-Gm-Message-State: APuU4Z+eq0wfeqTi+y61zGR9bxMkSXSnrljGvNUuYmvseo/1FBgoqkJL
	rPsez9EuZbNzHLKIAVUMknAYeOpbYpLo93j+Srn6O3utMDqKnQyqmthJLsjJAEO9EWPBRFIRzkR
	xDaoIQuLJvMpBOCa6Mq/OR+y5ojqMjG5bRn6yvn3R
X-Gm-Gg: AYBFou3owIE3E5V15rAZ2bSa0CJH91MdHirG0mfWg+eUi0lT4uKkp4hxO+PnMP/5M82
	etVMsos1OqMmUIB9gnuanjNpylDxTxw5NKRTZxZ/NS6O3ZWLk47OPI/Na001+112HqE3jDE6YbR
	Yh/jD78V324BONjknQHTzb9YBcf9VALyIzzjwxRTjl2bKRjISGsrVycuWUtzKgCwtt4+nob1hFW
	jC/9o8zH5o6wZlh61kEETkOw8fI7eKJybu6h8BV4SerfGfmOgpXPaFwJ9+G5e5VM4PFleh8FjCN
	/wX1UUpcogqL+FcT/Uw6zuFM/Qwjxpq0UlzXC5c5z2TyAXT7w5urEqvDi2cmaRzEDPxCMLC4Arx
	S3dusUfV9rpKdUUOuRXXTaL0fxL1CNAyDfkYGHe/cyx3CUuJxDdDsOl/EWlBPYxIKKk+EqeCbno
	HrABn6D+ENtYbsiezjal7gbCzTDCBGXPOnyzIjRzVZP29dFmeOHXGJ+UKJi7yUV1GnNxUrcaWk8
	oUSeDRp
X-Received: by 2002:a05:6820:c448:10b0:6bd:df1c:23b1 with SMTP id
 006d021491bc7-714f295abdbmr5037872eaf.15.1793716698982; Tue, 03 Nov 2026
 06:38:18 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae9f1b1.26d36f6c.15fe18.000a.GAE@google.com>
In-Reply-To: <6ae9f1b1.26d36f6c.15fe18.000a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 3 Nov 2026 15:38:07 +0100
X-Gm-Features: AclHuK8uK4CndU-z0yaKRgqaEzdh-NAKpzAVRnlyVtbIBMHMQTkzsCG2cUYVkAo
Message-ID: <CANp29Y4i0cBJq=wee_Xje3X6VaPVCEBD3xDgMq+oCEn=eS+7tA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: KVM: x86: Introduce memory protection attributes
To: syzbot ci <syzbot+cia869fe32b7d385de@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Nov 3, 2026 at 3:37=E2=80=AFPM syzbot ci
<syzbot+cia869fe32b7d385de@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] KVM: x86: Introduce memory protection attributes
> https://lore.kernel.org/all/20261102174130.8779-1-pbonzini@redhat.com
> * [PATCH 01/45] KVM: nVMX/nSVM: check unconditionally whether CR3 is vali=
d
> * [PATCH 02/45] KVM: x86/hyperv: do not overwrite hc->ingpa for SIGNAL_EV=
ENT hypercall
> * [PATCH 03/45] KVM: x86: apply nGPA->GPA translation to KVM_HC_CLOCK_PAI=
RING
> * [PATCH 04/45] KVM: x86/emulate: Check TSS busy-bit writes during task s=
witches
> * [PATCH 05/45] KVM: loongarch: do full validity check on the gfn-to-hva =
cache
> * [PATCH 06/45] KVM: selftests: Test address translation for Hyper-V dire=
ct L2 hypercalls
> * [PATCH 07/45] KVM: selftests: Take into account mixed memory fault flag=
s
> * [PATCH 08/45] selftests: kvm: drop TEST_ASSERT_SUPPORTED_ATTRIBUTES
> * [PATCH 09/45] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX fla=
gs to userspace
> * [PATCH 10/45] KVM: x86: Introduce memory fault on invalid hypercalls re=
ads/writes
> * [PATCH 11/45] KVM: selftests: test hypercall memory fault exits
> * [PATCH 12/45] KVM: x86/mmu: intersect writability from __kvm_faultin_pf=
n with fault->map_writable
> * [PATCH 13/45] KVM: x86/mmu: Extend map_writable to a full ACC_* mask
> * [PATCH 14/45] KVM: x86/mmu: Init memslot hugepage information for non-p=
rivate_mem VMs too
> * [PATCH 15/45] KVM: VMX: return error from kvm_set_cr*
> * [PATCH 16/45] KVM: adjust for presence of more than one attribute
> * [PATCH 17/45] KVM: Introduce NR/NW/NX memory attributes
> * [PATCH 18/45] KVM: Include memory protections in result of gfn->hva con=
version
> * [PATCH 19/45] KVM: Introduce kvm_fetch_guest_page() and use it for x86
> * [PATCH 20/45] KVM: Take memory protections into account for memory read=
/write/fetch
> * [PATCH 21/45] KVM: Take memory protections into account for __kvm_vcpu_=
map
> * [PATCH 22/45] KVM: Encapsulate memattrs array into anonymous struct
> * [PATCH 23/45] KVM: Introduce kvm_check_gen()/kvm_memslots_check_gen()
> * [PATCH 24/45] KVM: Introduce a generation number for memory attributes
> * [PATCH 25/45] KVM: Take memory protections into account for accesses wi=
th cached gfn->hva
> * [PATCH 26/45] KVM: pfncache: Fail to refresh if it contains memory prot=
ections
> * [PATCH 27/45] KVM: x86/mmu: Do not prefetch sptes on gfns backed by mem=
ory attributes
> * [PATCH 28/45] KVM: x86/mmu: Take memory protection attributes into acco=
unt during faults
> * [PATCH 29/45] KVM: x86/emulate: change return value of emulator_io_perm=
itted to int
> * [PATCH 30/45] KVM: x86/emulate: Propagate memory faults to userspace
> * [PATCH 31/45] KVM: x86: "Handle" failed decode when skipping instructio=
ns
> * [PATCH 32/45] KVM: vmx/sgx: make return value of sgx_gva_to_gpa consist=
ent with its callers
> * [PATCH 33/45] KVM: x86: Allow page fault fixup to return errors
> * [PATCH 34/45] KVM: x86/mmu: Adjust gva_to_gpa to allow returning an err=
or
> * [PATCH 35/45] KVM: x86/mmu: Propagate errors from nested GPA translatio=
n
> * [PATCH 36/45] KVM: x86: Propagate memory faults through load_pdptrs()
> * [PATCH 37/45] KVM: x86/mmu: Issue memory fault exit if walk failed due =
to memory attribute
> * [PATCH 38/45] KVM: x86: mark VM as dead after KVM_SET_SREGS fails to lo=
ad PDPTRs
> * [PATCH 39/45] KVM: VMX: mark VM dead on shadow VMCS or eVMCS access fai=
lures
> * [PATCH 40/45] KVM: let kvm_arch_post_set_memory_attributes drop mmu_loc=
k
> * [PATCH 41/45] KVM: x86/mmu: Obsolete all roots if memattr contains gPTE=
s
> * [PATCH 42/45] KVM: x86: selftests: Introduce memory protection attribut=
es test
> * [PATCH 43/45] KVM: x86: selftests: Introduce memory attributes PTE test
> * [PATCH 44/45] KVM: x86: selftests: Introduce memory attributes side-cha=
nnel tests
> * [PATCH 45/45] KVM: x86: split out parts of load_pdptrs
>
> and found the following issue:
> WARNING: suspicious RCU usage in __kvm_gpc_refresh
>
> Full report is available here:
> https://ci.syzbot.org/series/beb5d6f5-3128-404c-9de5-537fb4326658
>
> ***
>
> WARNING: suspicious RCU usage in __kvm_gpc_refresh
>
> tree:      kvm-next
> URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
> base:      d21eef2084a9af87ac2a783bc7c2b175ba114e4e
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/1748209f-578f-45cd-8bb4-6f6392d79=
a88/config
> syz repro: https://ci.syzbot.org/findings/d02cf2a1-ed84-4f69-ac5f-29b2075=
b5e1f/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/linux/kvm_host.h:2636 Suspicious memory attribute generation us=
age
> !
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> locks held by syz.1.189/6607: 2, last CPU#0:
>  #0: ffff8881bf19dc38 (&gpc->refresh_lock){+.+.}-{4:4}, at: class_mutex_c=
onstructor include/linux/mutex.h:253 [inline]
>  #0: ffff8881bf19dc38 (&gpc->refresh_lock){+.+.}-{4:4}, at: __kvm_gpc_act=
ivate+0x91/0x3b0 virt/kvm/pfncache.c:417
>  #1: ffff8881bf19dbb0 (&gpc->lock){....}-{3:3}, at: __kvm_gpc_refresh+0x1=
af/0x1830 virt/kvm/pfncache.c:272
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6607 Comm: syz.1.189 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6972
>  kvm_mem_attributes_generation include/linux/kvm_host.h:2634 [inline]
>  __kvm_gpc_refresh+0x1657/0x1830 virt/kvm/pfncache.c:306
>  __kvm_gpc_activate+0x289/0x3b0 virt/kvm/pfncache.c:436
>  kvm_set_msr_common+0x2dab/0x4320 arch/x86/kvm/msrs.c:-1
>  vmx_set_msr+0x15b3/0x27f0 arch/x86/kvm/vmx/vmx.c:2632
>  __kvm_set_msr+0x60c/0xab0 arch/x86/kvm/msrs.c:806
>  _kvm_set_msr arch/x86/kvm/msrs.c:812 [inline]
>  kvm_do_msr_access arch/x86/kvm/msrs.c:549 [inline]
>  kvm_set_msr_ignored_check+0x2a/0x390 arch/x86/kvm/msrs.c:818
>  nested_vmx_load_msr+0x245/0x4d0 arch/x86/kvm/vmx/nested.c:1126
>  load_vmcs12_host_state+0x10ca/0x1e20 arch/x86/kvm/vmx/nested.c:4935
>  __nested_vmx_vmexit+0x1a12/0x2c90 arch/x86/kvm/vmx/nested.c:5203
>  nested_vmx_vmexit arch/x86/kvm/vmx/nested.h:46 [inline]
>  vmx_leave_nested arch/x86/kvm/vmx/nested.c:6898 [inline]
>  nested_vmx_free_vcpu+0x8e/0xd0 arch/x86/kvm/vmx/nested.c:389
>  vmx_vcpu_free+0x109/0x3e0 arch/x86/kvm/vmx/vmx.c:7536
>  kvm_arch_vcpu_destroy+0x154/0x380 arch/x86/kvm/x86.c:9627
>  kvm_vcpu_destroy virt/kvm/kvm_main.c:477 [inline]
>  kvm_destroy_vcpus+0x123/0x380 virt/kvm/kvm_main.c:497
>  kvm_arch_destroy_vm+0xf6/0x1d0 arch/x86/kvm/x86.c:10198
>  kvm_destroy_vm virt/kvm/kvm_main.c:1314 [inline]
>  kvm_put_kvm+0x772/0xb50 virt/kvm/kvm_main.c:1351
>  kvm_vm_release+0x6b/0x80 virt/kvm/kvm_main.c:1376
>  __fput+0x40d/0xa50 fs/file_table.c:512
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
>  exit_to_user_mode_loop+0x204/0x770 kernel/entry/common.c:101
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:343 [inline]
>  do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe8f039f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff5710adc8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007fe8f0627da0 RCX: 00007fe8f039f559
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 00007fe8f0627da0 R08: 00007fe8f0626038 R09: 0000000000000000
> R10: 000000000003fd98 R11: 0000000000000246 R12: 00000000000213f0
> R13: 00007fe8f062609c R14: 000000000002118b R15: 00007fe8f0626090
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
> [amoorthy@google.com kvm@vger.kernel.org linux-kernel@vger.kernel.org nsa=
enz@amazon.com pbonzini@redhat.com seanjc@google.com stable@vger.kernel.org=
]
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
-upstream-moderation/6ae9f1b1.26d36f6c.15fe18.000a.GAE%40google.com.
