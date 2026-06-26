Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535A13DB970
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 07:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782457601; cv=none; b=AleLgtNVx/MBxSSaTO+DATCYATZrWORuaifLhMgApvemYy2bAYM1fRG5yGGxlCvMiTqA0bH/FbC/Zz9oRuczqvLdJavnzgFi5DkIEdpjK6u/8W0jIt+jahThjMCizbKPefYrHdYeZ7JUS0MhMHqZxu0k7u2zt6FfLPioZeCuGYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782457601; c=relaxed/simple;
	bh=pqYqDss+We3+fWbvaNY96iNE/l1ss4C7O7FCExvRb6Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Wy0fcopHklwNXITnlZqwr3jjMnxIG9dW13b7dpzeXTQMA/gGQbOCzMlKAH+diTA5sbI6wjQBSBebo9X9uTr05wYVJDyDzoRHHodfnV8vwJ85wNGllA5KshMUXdvzzRZn+l+wAXer35vZOu0Jw6bukTXNNIdOwOJL0kMXxyFQmHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-486a2231742so1029894b6e.1
        for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 00:06:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782457599; x=1783062399;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o+gKfN7c60i0SfByDcT2rkIdmUDIAot8wJ+q//zIWXU=;
        b=kFkYChVNTTdwDYSI+/dxHCQDJ98L62EqMqtvSLbf3j11DFZWkpSbvmDpoQXx/+mXd+
         k5KtREOFS7R8CKX4qquU5H3gXXxaAIQcYIJXoonsmPqd3EJ2TyiLzWZoVEixQohJ1b1h
         PYJbkuTITfBE2Trly9MEO8w3DmWqBeDBpxG1c4eLU38ZTrmN9b9GYITpbL8rGx/324Xv
         pebD5E1sZdojfUaynA7JcjBjkSrQq/61gRhi6YMss7YUjpmVQtjVp4S0QSeR1grjr8uA
         hQQHDyo6TTqUDR1QC+SiFTAa248HfsEm3kOnrOTr1fbe3DmauoXSpDjb+TvKcDInKT2/
         Zc7Q==
X-Gm-Message-State: AOJu0Yxw4/ZfqtC9t/eFSQiV/FKT5Wuo9x77Bbdje9xWvVdK2U+29c85
	WTuqgRK7i9WSWw/ysir1qQjuJx6TQOg8u0nbE6hV+jbHlmRzaEoRpDmBvsw1Jlpg9huJLjibiNW
	mJ+G+S2yH5rS9BoAyCJZMFgQ0kM9zQX8jDulg1wRksOxxojI3y451eaCU064=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:181c:b0:486:caa4:ea44 with SMTP id
 5614622812f47-48ee2660937mr9593907b6e.6.1782457599446; Fri, 26 Jun 2026
 00:06:39 -0700 (PDT)
Date: Fri, 26 Jun 2026 00:06:39 -0700
In-Reply-To: <20260625223623.3376478-1-seanjc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3e24ff.bd346d9a.250aae.0008.GAE@google.com>
Subject: [syzbot ci] Re: KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
From: syzbot ci <syzbot+ci6c27aad5db86e5b9@syzkaller.appspotmail.com>
To: dwmw2@infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	paul@xen.org, pbonzini@redhat.com, seanjc@google.com, 
	syzbot@syzkaller.appspotmail.com, vkuznets@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] KVM: x86/hyperv: Fix racy usage of vcpu->arch.hyperv
https://lore.kernel.org/all/20260625223623.3376478-1-seanjc@google.com
* [PATCH v3 01/10] KVM: x86/hyperv: Get target FIFO in hv_tlb_flush_enqueue(), not caller
* [PATCH v3 02/10] KVM: x86/hyperv: Check for NULL vCPU Hyper-V object in kvm_hv_get_tlb_flush_fifo()
* [PATCH v3 03/10] KVM: x86/hyperv: Ensure vCPU's Hyper-V object is initialized on cross-vCPU accesses
* [PATCH v3 04/10] KVM: x86/xen: Punt singleshot timer hcalls to userspace if Xen vCPU ID isn't set
* [PATCH v3 05/10] KVM: x86/xen: Consolidate checks on Xen vCPU ID for singleshot timer hypercalls
* [PATCH v3 06/10] KVM: Initialize a vCPU's index to '-1' while it's being created
* [PATCH v3 07/10] KVM: Move nVMX's lockdep logic for vcpu->mutex to a common helper
* [PATCH v3 08/10] KVM: x86: Treat a vCPU as unreachable if its index is invalid
* [PATCH v3 09/10] KVM: x86/hyperv: Assert vCPU's mutex is held in to_hv_vcpu()
* [PATCH v3 10/10] KVM: x86/hyperv: Use {READ,WRITE}_ONCE for cross-task synic->active accesses

and found the following issue:
WARNING in kvm_hv_vcpu_uninit

Full report is available here:
https://ci.syzbot.org/series/6864cbe8-ce00-47d1-b4b1-abc7d1528d4e

***

WARNING in kvm_hv_vcpu_uninit

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      a204badd8432f93b7e862e7dac6db0fe3d65f370
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/0627391d-c4d6-4820-99f0-31a8b51ba783/config
syz repro: https://ci.syzbot.org/findings/cdadfdf2-8445-4193-a3a6-bf878176b493/syz_repro

------------[ cut here ]------------
debug_locks && !(lock_is_held(&(&vcpu->mutex)->dep_map) || vcpu->vcpu_idx < 0 || !refcount_read(&vcpu->kvm->users_count))
WARNING: ./include/linux/kvm_host.h:996 at kvm_lockdep_assert_vcpu_is_locked_or_unreachable include/linux/kvm_host.h:994 [inline], CPU#1: syz.1.34/5967
WARNING: ./include/linux/kvm_host.h:996 at to_hv_vcpu arch/x86/kvm/hyperv.h:79 [inline], CPU#1: syz.1.34/5967
WARNING: ./include/linux/kvm_host.h:996 at kvm_hv_vcpu_uninit+0x198/0x210 arch/x86/kvm/hyperv.c:906, CPU#1: syz.1.34/5967
Modules linked in:
CPU: 1 UID: 0 PID: 5967 Comm: syz.1.34 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:kvm_lockdep_assert_vcpu_is_locked_or_unreachable include/linux/kvm_host.h:994 [inline]
RIP: 0010:to_hv_vcpu arch/x86/kvm/hyperv.h:79 [inline]
RIP: 0010:kvm_hv_vcpu_uninit+0x198/0x210 arch/x86/kvm/hyperv.c:906
Code: 48 89 df e8 0a 55 d8 00 48 c7 03 00 00 00 00 eb 05 e8 5c 16 6d 00 5b 41 5c 41 5e 41 5f 5d e9 ff 16 4d 0a cc e8 49 16 6d 00 90 <0f> 0b 90 e9 65 ff ff ff 48 c7 c1 e0 bb 2f 90 80 e1 07 80 c1 03 38
RSP: 0018:ffffc9000390f960 EFLAGS: 00010293
RAX: ffffffff8158e9e7 RBX: ffff8881bc192880 RCX: ffff88816ac70000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff888101fa1743 R09: 1ffff110203f42e8
R10: dffffc0000000000 R11: ffffed10203f42e9 R12: 0000000000000000
R13: 00000000fffffff8 R14: ffff888101fa1740 R15: dffffc0000000000
FS:  00007f47c1e886c0(0000) GS:ffff8882a92b6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000c64000 CR3: 000000016a5e7000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 kvm_arch_vcpu_destroy+0x1a9/0x380 arch/x86/kvm/x86.c:9413
 kvm_vm_ioctl_create_vcpu+0x615/0x990 virt/kvm/kvm_main.c:4269
 kvm_vm_ioctl+0x886/0xd30 virt/kvm/kvm_main.c:5168
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f47c0f9caeb
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007f47c1e87ee0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f47c1215fa0 RCX: 00007f47c0f9caeb
RDX: 0000000000000000 RSI: 000000000000ae41 RDI: 00000000000000f7
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000c00000 R11: 0000000000000246 R12: 0000200000c00000
R13: 0000000000000153 R14: 0000200000000400 R15: 00007ffe526558c8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
