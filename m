Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716839;
	b=CXS7jQ2Q5UmOQP8mn2oMZVnPg4OgyTAbFiHh6eTzI1IKG/T7zbDjhym9Bcan+gaMBA6M
	 lXMdHrcUcvbPWqCBex/IGAhaqjLU2ACU25RyGSIv/v5+Lrg9GcfvlObVbulzsmsHQiN5t
	 ASo5v/DadrLQhu435lBD5v8lyvB+GvRzHoeJxHKfUhBX5XHIl36f5JjOBe/d7lwY2ih3N
	 O14Yl4L/YdVUB4MT4soXOX9ZEP4LX89h1q0HxslLyxuYQDkV8ag6fTrqBDnLbmh9IZU9S
	 VsfaS572hkd6Vn4cOgDGby02Wej4QgIv4ngbGL1agcxEm6uW/TNe9Y+IcK5P57e2mQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716839;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=uYGorSdShMQBHQquhWX9/8c57HWBfRFBIdfPOd+oM1Y=;
	b=CEK+BbsNBq5McGC/DhbpQ7QnfVJQ7aVwpftBxnvIx+zJhF9nsJVD1z8QX14GhhI0OTbr
	 mQ88LspkvrOO/nqIm1eH5tsAt2Gvm+B4njyTwx2AHT3iAbEFyeQoZSlS3jjlE09ZEqxEy
	 6VXxaa6ppKWmhtp0XOvP+8YPV4FapPvMDVvE4GHNeQT8wxBzR7LlfqJLCBP5mJo4U0iaG
	 tj6ImxdCujhf1SKw5URAKxM79MfbEyY9iFL+2SSO8rmpa/U6Vi4E9ubeQtKV/iVNwIMon
	 l57oguJHjh4Aw1n+ewr6cVKDXrP1fn+uz62Fe8I54FHcfeqRigdk3Rf+pyRutw3NovQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.160.72
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7068606A33D
	for <syzbot@lists.linux.dev>; Tue,  3 Nov 2026 14:40:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7068606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-4943ed99826so3766152fac.3
        for <syzbot@lists.linux.dev>; Tue, 03 Nov 2026 06:40:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793716838; x=1794321638;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uYGorSdShMQBHQquhWX9/8c57HWBfRFBIdfPOd+oM1Y=;
        b=0VfDbkeFMtlMHBEWw1Pj2OeizMnGE98kLSEuVXpPY5pAt+zgvPyySw0tEIbZALwOXE
         WgvK8EslbzgnobAV8a03S5bbQPMnkHiCbePExzsS542CmF1CEaUURV9ODmjQ8NyOcPR0
         wrVop9l/zNvH1wyami3B+cqZsR/Hk7a1tCBtAsT6pWIYmptXxSFtvkT8hgKN5ac+0vBM
         lhD0qRRT6VyfIixT9fCxybTuwy6kE67aRGZ4rpFrV32zNUcsVnz115+4jqEUm5/703Gc
         O6vGbm5ZaqSP7O3ePkESK7Q9LL1JaEL8lDl5/p9OySpzTr5TjcpjS3fxdzqF9jDr3zQ5
         O3zQ==
X-Gm-Message-State: APuU4Z/nNAjTKmEcApTpjwWigPsjluqq5dH2FtbcyYWc43ZpkWPShBnF
	ejvrtKqBjGlRr64HpXsOHUXvourMzBzKJJ5Pbsq8RT5ofZ/cgGounLGhSDXU4s1nGWFVzllKpMz
	DxjDYNa/ezXPq2KLAro/NgB03mSTomjLHGf3AaM9Zm6Xh1PAasQPgZJCCvlk=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c3d5:b0:4b9:a829:f016 with SMTP id
 5614622812f47-5640de7a768mr9396181b6e.34.1793716837868; Tue, 03 Nov 2026
 06:40:37 -0800 (PST)
Date: Tue, 03 Nov 2026 06:40:37 -0800
In-Reply-To: <20261102174130.8779-1-pbonzini@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae9f265.318f3b9a.23acd0.0002.GAE@google.com>
Subject: [syzbot ci] Re: KVM: x86: Introduce memory protection attributes
From: syzbot ci <syzbot+ci04113eef29edb032@syzkaller.appspotmail.com>
To: amoorthy@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nsaenz@amazon.com, pbonzini@redhat.com, seanjc@google.com, 
	stable@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] KVM: x86: Introduce memory protection attributes
https://lore.kernel.org/all/20261102174130.8779-1-pbonzini@redhat.com
* [PATCH 01/45] KVM: nVMX/nSVM: check unconditionally whether CR3 is valid
* [PATCH 02/45] KVM: x86/hyperv: do not overwrite hc->ingpa for SIGNAL_EVENT hypercall
* [PATCH 03/45] KVM: x86: apply nGPA->GPA translation to KVM_HC_CLOCK_PAIRING
* [PATCH 04/45] KVM: x86/emulate: Check TSS busy-bit writes during task switches
* [PATCH 05/45] KVM: loongarch: do full validity check on the gfn-to-hva cache
* [PATCH 06/45] KVM: selftests: Test address translation for Hyper-V direct L2 hypercalls
* [PATCH 07/45] KVM: selftests: Take into account mixed memory fault flags
* [PATCH 08/45] selftests: kvm: drop TEST_ASSERT_SUPPORTED_ATTRIBUTES
* [PATCH 09/45] KVM: Define and communicate KVM_EXIT_MEMORY_FAULT RWX flags to userspace
* [PATCH 10/45] KVM: x86: Introduce memory fault on invalid hypercalls reads/writes
* [PATCH 11/45] KVM: selftests: test hypercall memory fault exits
* [PATCH 12/45] KVM: x86/mmu: intersect writability from __kvm_faultin_pfn with fault->map_writable
* [PATCH 13/45] KVM: x86/mmu: Extend map_writable to a full ACC_* mask
* [PATCH 14/45] KVM: x86/mmu: Init memslot hugepage information for non-private_mem VMs too
* [PATCH 15/45] KVM: VMX: return error from kvm_set_cr*
* [PATCH 16/45] KVM: adjust for presence of more than one attribute
* [PATCH 17/45] KVM: Introduce NR/NW/NX memory attributes
* [PATCH 18/45] KVM: Include memory protections in result of gfn->hva conversion
* [PATCH 19/45] KVM: Introduce kvm_fetch_guest_page() and use it for x86
* [PATCH 20/45] KVM: Take memory protections into account for memory read/write/fetch
* [PATCH 21/45] KVM: Take memory protections into account for __kvm_vcpu_map
* [PATCH 22/45] KVM: Encapsulate memattrs array into anonymous struct
* [PATCH 23/45] KVM: Introduce kvm_check_gen()/kvm_memslots_check_gen()
* [PATCH 24/45] KVM: Introduce a generation number for memory attributes
* [PATCH 25/45] KVM: Take memory protections into account for accesses with cached gfn->hva
* [PATCH 26/45] KVM: pfncache: Fail to refresh if it contains memory protections
* [PATCH 27/45] KVM: x86/mmu: Do not prefetch sptes on gfns backed by memory attributes
* [PATCH 28/45] KVM: x86/mmu: Take memory protection attributes into account during faults
* [PATCH 29/45] KVM: x86/emulate: change return value of emulator_io_permitted to int
* [PATCH 30/45] KVM: x86/emulate: Propagate memory faults to userspace
* [PATCH 31/45] KVM: x86: "Handle" failed decode when skipping instructions
* [PATCH 32/45] KVM: vmx/sgx: make return value of sgx_gva_to_gpa consistent with its callers
* [PATCH 33/45] KVM: x86: Allow page fault fixup to return errors
* [PATCH 34/45] KVM: x86/mmu: Adjust gva_to_gpa to allow returning an error
* [PATCH 35/45] KVM: x86/mmu: Propagate errors from nested GPA translation
* [PATCH 36/45] KVM: x86: Propagate memory faults through load_pdptrs()
* [PATCH 37/45] KVM: x86/mmu: Issue memory fault exit if walk failed due to memory attribute
* [PATCH 38/45] KVM: x86: mark VM as dead after KVM_SET_SREGS fails to load PDPTRs
* [PATCH 39/45] KVM: VMX: mark VM dead on shadow VMCS or eVMCS access failures
* [PATCH 40/45] KVM: let kvm_arch_post_set_memory_attributes drop mmu_lock
* [PATCH 41/45] KVM: x86/mmu: Obsolete all roots if memattr contains gPTEs
* [PATCH 42/45] KVM: x86: selftests: Introduce memory protection attributes test
* [PATCH 43/45] KVM: x86: selftests: Introduce memory attributes PTE test
* [PATCH 44/45] KVM: x86: selftests: Introduce memory attributes side-channel tests
* [PATCH 45/45] KVM: x86: split out parts of load_pdptrs

and found the following issue:
WARNING: suspicious RCU usage in __kvm_gpc_refresh

Full report is available here:
https://ci.syzbot.org/series/beb5d6f5-3128-404c-9de5-537fb4326658

***

WARNING: suspicious RCU usage in __kvm_gpc_refresh

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      d21eef2084a9af87ac2a783bc7c2b175ba114e4e
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/1748209f-578f-45cd-8bb4-6f6392d79a88/config
syz repro: https://ci.syzbot.org/findings/d02cf2a1-ed84-4f69-ac5f-29b2075b5e1f/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/linux/kvm_host.h:2636 Suspicious memory attribute generation usage
!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
locks held by syz.1.189/6607: 2, last CPU#0:
 #0: ffff8881bf19dc38 (&gpc->refresh_lock){+.+.}-{4:4}, at: class_mutex_constructor include/linux/mutex.h:253 [inline]
 #0: ffff8881bf19dc38 (&gpc->refresh_lock){+.+.}-{4:4}, at: __kvm_gpc_activate+0x91/0x3b0 virt/kvm/pfncache.c:417
 #1: ffff8881bf19dbb0 (&gpc->lock){....}-{3:3}, at: __kvm_gpc_refresh+0x1af/0x1830 virt/kvm/pfncache.c:272

stack backtrace:
CPU: 0 UID: 0 PID: 6607 Comm: syz.1.189 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6972
 kvm_mem_attributes_generation include/linux/kvm_host.h:2634 [inline]
 __kvm_gpc_refresh+0x1657/0x1830 virt/kvm/pfncache.c:306
 __kvm_gpc_activate+0x289/0x3b0 virt/kvm/pfncache.c:436
 kvm_set_msr_common+0x2dab/0x4320 arch/x86/kvm/msrs.c:-1
 vmx_set_msr+0x15b3/0x27f0 arch/x86/kvm/vmx/vmx.c:2632
 __kvm_set_msr+0x60c/0xab0 arch/x86/kvm/msrs.c:806
 _kvm_set_msr arch/x86/kvm/msrs.c:812 [inline]
 kvm_do_msr_access arch/x86/kvm/msrs.c:549 [inline]
 kvm_set_msr_ignored_check+0x2a/0x390 arch/x86/kvm/msrs.c:818
 nested_vmx_load_msr+0x245/0x4d0 arch/x86/kvm/vmx/nested.c:1126
 load_vmcs12_host_state+0x10ca/0x1e20 arch/x86/kvm/vmx/nested.c:4935
 __nested_vmx_vmexit+0x1a12/0x2c90 arch/x86/kvm/vmx/nested.c:5203
 nested_vmx_vmexit arch/x86/kvm/vmx/nested.h:46 [inline]
 vmx_leave_nested arch/x86/kvm/vmx/nested.c:6898 [inline]
 nested_vmx_free_vcpu+0x8e/0xd0 arch/x86/kvm/vmx/nested.c:389
 vmx_vcpu_free+0x109/0x3e0 arch/x86/kvm/vmx/vmx.c:7536
 kvm_arch_vcpu_destroy+0x154/0x380 arch/x86/kvm/x86.c:9627
 kvm_vcpu_destroy virt/kvm/kvm_main.c:477 [inline]
 kvm_destroy_vcpus+0x123/0x380 virt/kvm/kvm_main.c:497
 kvm_arch_destroy_vm+0xf6/0x1d0 arch/x86/kvm/x86.c:10198
 kvm_destroy_vm virt/kvm/kvm_main.c:1314 [inline]
 kvm_put_kvm+0x772/0xb50 virt/kvm/kvm_main.c:1351
 kvm_vm_release+0x6b/0x80 virt/kvm/kvm_main.c:1376
 __fput+0x40d/0xa50 fs/file_table.c:512
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x204/0x770 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:343 [inline]
 do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe8f039f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff5710adc8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007fe8f0627da0 RCX: 00007fe8f039f559
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007fe8f0627da0 R08: 00007fe8f0626038 R09: 0000000000000000
R10: 000000000003fd98 R11: 0000000000000246 R12: 00000000000213f0
R13: 00007fe8f062609c R14: 000000000002118b R15: 00007fe8f0626090
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
