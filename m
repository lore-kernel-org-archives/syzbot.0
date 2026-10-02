Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3B13F1077
	for <syzbot@lists.linux.dev>; Fri,  2 Oct 2026 19:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790969212; cv=none; b=U7mlgMFU58eKIuhzrdy8gIRt4vJcegQ6f1Gj+GfoOc1DFZK696/b+r0Qdli/QjNKCfUfGuX/Q8S+nmCWbXrDDg11tdmZ0WTbyyI59EgzNGo512T13Z+6nlaSXoDd6ou6GZNnqCsh/HJ/eGq/zZ9YubuWsdT21rtz2wKv9zsLvnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790969212; c=relaxed/simple;
	bh=5jtK62nQIDWXDOVb/tkJR2OosQo+t2LJ7oeQ8i56MeA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=kHuYvD1d9eVqXTNojfu3HnLSsBgDcfvWU0mrMougpCAeC4UCZ3u49l0JxgYM/zrNPeoVRgxOgwnNzhbuvKDA3y0clnwrNS7noxW2Wfn07SorIYFDUE9DxR861M6k48YUXoef/laeF2iRNIsPTirnnpNEx90LACSsoFgFPd2c1o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-4566537e644so443405fac.0
        for <syzbot@lists.linux.dev>; Fri, 02 Oct 2026 12:26:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790969209; x=1791574009;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wy1sei0Ny3eJo/juHrJkWWbB7Z49uRpuB4iD7bvknu8=;
        b=x9/i85GtZboC/EAULQC7fSyHeGygDRbLguSoWWmXxpqD+iDWzDzfpk1o1LiOyRutji
         rCact42wc2ia6oI3+lqVWi6cEsSjYfJ98m59rRJMj/AXx1XUPkyTscDbWPyaHFcZ1DzN
         zm0SX48v9sATRmReq89Aj2r3upoWkZXJJRyGjnIEth0vxf4EuwtdOY8y2I3koSvFmJxf
         YbFvgVD0tEefDwNk7qiATKGCTuxZMRKPMGe5ww2jG4xx05+DpIZ3i1V84RtD+MLvPDKf
         ATK8xGp8/nz9lBEFSujmT3p7jh5RHWV4XgIBkmJai32/1zeKZ7nWkKtO3EkROF8RKxRo
         +1fw==
X-Gm-Message-State: AFuF++n6HiRv8tRRgBk+WLEauDPg7fQSA5dNgFbJ+cowgtz7UjfyEMYR
	b3zmRLargSpYfdJzwtSPYmCmxbpPFl9Q82M0LyBFnpTvjfawlfzdiW4aW2ZaXGX7AaWs3FFsurs
	OtjpAxcXCc8RHOWRqjniyWjqoXZOpAk45FERG6m/q0yJoOZoYCw29RM/gibM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6809:245:10b0:4f5:5dbd:1328 with SMTP id
 5614622812f47-4f55dbd1397mr1700125b6e.42.1790969209352; Fri, 02 Oct 2026
 12:26:49 -0700 (PDT)
Date: Fri, 02 Oct 2026 12:26:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac00579.34119e79.2f92f3.0000.GAE@google.com>
Subject: [moderation/CI] Re: KVM: Fix+harden against bad uaccess using dying VM
From: syzbot ci <syzbot+ci5e192c41dea0b5ba@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] KVM: Fix+harden against bad uaccess using dying VM
https://lore.kernel.org/all/20261001202234.3794060-1-seanjc@google.com
* [PATCH v2 01/10] KVM: Reject user accesses to guest memory if current->mm != kvm->mm
* [PATCH v2 02/10] KVM: PPC: Flush/zap all memslots on kvm_arch_flush_shadow_all()
* [PATCH v2 03/10] KVM: x86: Unmap VMAs for KVM-internal memslots when the memslot is freed
* [PATCH v2 04/10] KVM: Disallow setting memslots when the VM is being destroyed
* [PATCH v2 05/10] KVM: Destroy memslots immediately after mmu_notifiers are unregistered
* [PATCH v2 06/10] KVM: WARN if KVM attempts to do guest-related uaccess with "wrong" process
* [PATCH v2 07/10] KVM: WARN and reject guest-based uaccess if VM is dying
* [PATCH v2 08/10] KVM: nVMX: Don't flush shadow VMCS12 to guest memory during vCPU teardown
* [PATCH v2 09/10] KVM: nVMX: Don't try to load eVMCS12 page when the VM is dying
* [PATCH v2 10/10] KVM: Pre-check uaccesses in KVM's APIs to read/write guest memory

and found the following issue:
WARNING in __kvm_read_guest_page

Full report is available here:
https://ci.syzbot.org/series/5f8da53a-c584-4176-abcb-7a29eb02e4c4

***

WARNING in __kvm_read_guest_page

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      d4b7fb647204f0c81dfeae2d1a708e4d858e0c94
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/4d4c10d0-f56c-448f-8782-ad4dab8f46d0/config
syz repro: https://ci.syzbot.org/findings/dc5f6c42-c3ab-41b0-9384-1a15798e4820/syz_repro

------------[ cut here ]------------
!__kvm_can_do_uaccess(kvm)
WARNING: ./include/linux/kvm_host.h:1360 at kvm_can_do_uaccess include/linux/kvm_host.h:1360 [inline], CPU#1: syz.1.18/5858
WARNING: ./include/linux/kvm_host.h:1360 at kvm_is_guest_access_ok virt/kvm/kvm_main.c:3216 [inline], CPU#1: syz.1.18/5858
WARNING: ./include/linux/kvm_host.h:1360 at __kvm_read_guest_page+0x38e/0x440 virt/kvm/kvm_main.c:3226, CPU#1: syz.1.18/5858
Modules linked in:
CPU: 1 UID: 0 PID: 5858 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:kvm_can_do_uaccess include/linux/kvm_host.h:1360 [inline]
RIP: 0010:kvm_is_guest_access_ok virt/kvm/kvm_main.c:3216 [inline]
RIP: 0010:__kvm_read_guest_page+0x38e/0x440 virt/kvm/kvm_main.c:3226
Code: f2 ff ff ff 0f 44 d8 31 ff e8 5e a4 89 00 89 d8 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d e9 09 ac a8 0a cc e8 83 9e 89 00 90 <0f> 0b 90 bb f2 ff ff ff eb da e8 73 9e 89 00 90 0f 0b 90 bb f2 ff
RSP: 0018:ffffc90003157778 EFLAGS: 00010293
RAX: ffffffff813e2d22 RBX: 0000000000000000 RCX: ffff888174382580
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffff1102217d82a R08: ffff888110bee183 R09: 1ffff1102217dc30
R10: dffffc0000000000 R11: ffffed102217dc31 R12: ffff888110bee180
R13: ffff888174382b40 R14: 1ffff1102217dc30 R15: 0000000000000000
FS:  000055557c0db500(0000) GS:ffff8882a8cda000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f458dfeb840 CR3: 000000016c9d0000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 kvm_vcpu_read_guest+0x64/0x140 virt/kvm/kvm_main.c:3284
 nested_vmx_load_msr+0x133/0x4d0 arch/x86/kvm/vmx/nested.c:1107
 load_vmcs12_host_state+0x10ca/0x1e20 arch/x86/kvm/vmx/nested.c:4930
 __nested_vmx_vmexit+0x1800/0x2d10 arch/x86/kvm/vmx/nested.c:5206
 nested_vmx_vmexit arch/x86/kvm/vmx/nested.h:46 [inline]
 vmx_leave_nested arch/x86/kvm/vmx/nested.c:6891 [inline]
 nested_vmx_free_vcpu+0x8e/0xd0 arch/x86/kvm/vmx/nested.c:389
 vmx_vcpu_free+0x109/0x3e0 arch/x86/kvm/vmx/vmx.c:7653
 kvm_arch_vcpu_destroy+0x154/0x380 arch/x86/kvm/x86.c:9463
 kvm_vcpu_destroy virt/kvm/kvm_main.c:469 [inline]
 kvm_destroy_vcpus+0x123/0x380 virt/kvm/kvm_main.c:489
 kvm_arch_destroy_vm+0x55/0x120 arch/x86/kvm/x86.c:10014
 kvm_destroy_vm virt/kvm/kvm_main.c:1326 [inline]
 kvm_put_kvm+0x93a/0xc80 virt/kvm/kvm_main.c:1359
 kvm_vm_release+0x43/0x50 virt/kvm/kvm_main.c:1382
 __fput+0x418/0xa50 fs/file_table.c:512
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x204/0x770 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:336 [inline]
 do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7fec79e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff0d2850c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007f7feca27da0 RCX: 00007f7fec79e159
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f7feca27da0 R08: 00007f7feca26038 R09: 0000000000000000
R10: 000000000003fdb8 R11: 0000000000000246 R12: 000000000000ec04
R13: 00007f7feca25fac R14: 000000000000e938 R15: 00007fff0d2851d0
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

The email will later be sent to:
[jmattson@google.com kvm@vger.kernel.org linux-kernel@vger.kernel.org linuxppc-dev@lists.ozlabs.org maddy@linux.ibm.com npiggin@gmail.com pbonzini@redhat.com seanjc@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

