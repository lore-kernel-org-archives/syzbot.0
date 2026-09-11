Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FE4322C88
	for <syzbot@lists.linux.dev>; Fri, 11 Sep 2026 22:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789166870; cv=none; b=LQQk4qQdcX2mbJmF4c9dFdx2jT46l7XjeEmixCwWU3Rx7y4xWOt9zy6G3Zl+QZdg1FKpGQOHp70oy0EE1b8kQpOtH930hc3i3Ckj8aRm8dCP2I441qPvDsoPl8XEw7t4UrDp9pD/FdZk1MACOw+jDv8vtKFGheaPfpLuJPcFPzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789166870; c=relaxed/simple;
	bh=qgsv5izkByJthcAH8hWzxJ7oHLnrXSTxMPruwTN3YMA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=BmVlD+S+XsJ764IlwObR+tZa5S0fUNqz020y8NMtC8jRzN0QYwt/rLRFol82JicNElN0laU8R3CyI4Gasf7k7fBzdWhyUmZBSpRVqvuPnrLWnP+EQjLh39x4YwxWFHUtCSmeGd2NlHLJEQF2/yicU8fpjZvtxIuTqURDxqVUUPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6b1a3f01d2aso1860698eaf.1
        for <syzbot@lists.linux.dev>; Fri, 11 Sep 2026 15:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789166867; x=1789771667;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C8vvwRg/l2A/hL2twahuJQjKCqUBRlQScEYoaPmT2q0=;
        b=FIirS08Zs4DPNz482ON2NlkdLaXN/XkYAWl26SWtIPIUDFbeS0GJiBdw8c31Em8nuT
         Qe5gmDAEXKNGwkvtymsI30si8OaIw0Oqit9zTG5UcCbXuezPNozDznxLksWHv1h5hvXG
         tibqcxcsgEjBiMY1RTgX6ZrZzOACDiyyjwrJKIOOgRVAOhtTluNpg3zKRvX0b3G9e04e
         rheSlXVdEjpwvyyswwNzsNkfEBuZsd866mTn3IoKaW7fzS+4y2hqEIbrKG+46xIbXTMS
         XqZsms0tX00Ib+liHdulIq6TjA8svYP1o/uhsH9xzC0l58p/TJFBVSiqtkAWQlAfpfbS
         BwUg==
X-Gm-Message-State: AFuF++m1NdxwVfdg2XNjTEh4cmTao+yBvUcVkPmsl9hlYG0YuU3uRqca
	F8W/qut4NTcBr771xZRoD/1cQ6zL512+puti+4xbbNTNlXaFMVpVQBkkLn5VkSIVHQPucQbry9C
	ZxOaczmoJKUU6tL35fOnrgbnZtza1o2zrpeOEjusO/hDLRVVa4VM5k+Akavs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1515:b0:6b7:46fc:1da with SMTP id
 006d021491bc7-6c24ed534f5mr374061eaf.57.1789166867309; Fri, 11 Sep 2026
 15:47:47 -0700 (PDT)
Date: Fri, 11 Sep 2026 15:47:47 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa48513.6e6c5f9e.28f11f.004b.GAE@google.com>
Subject: [moderation/CI] Re: KVM: unbounded per-VM kernel memory growth via KVM_SET_MEMORY_ATTRIBUTES
From: syzbot ci <syzbot+ci111ff5cfa790edc5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] KVM: unbounded per-VM kernel memory growth via KVM_SET_MEMORY_ATTRIBUTES
https://lore.kernel.org/all/20260911184819.101123-1-davimaba.v@proton.me
* [PATCH 1/2] KVM: Bound per-VM GFN materialization in KVM_SET_MEMORY_ATTRIBUTES
* [PATCH 2/2] KVM: Account mem_attr_array nodes to the caller's memcg

and found the following issue:
WARNING: suspicious RCU usage in kvm_vm_ioctl_set_mem_attributes

Full report is available here:
https://ci.syzbot.org/series/734bda86-476d-49cf-9a5e-335cc5b006c0

***

WARNING: suspicious RCU usage in kvm_vm_ioctl_set_mem_attributes

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      d4b7fb647204f0c81dfeae2d1a708e4d858e0c94
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a54b5b46-809d-4f22-a473-c317ec575648/config
syz repro: https://ci.syzbot.org/findings/c345c736-c3eb-46c9-9d9d-cc78ce4bf677/syz_repro

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/linux/xarray.h:1211 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
locks held by syz.2.19/5790: 1, last CPU#0:
 #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2605 [inline]
 #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_ioctl_set_mem_attributes+0x365/0x1af0 virt/kvm/kvm_main.c:2690

stack backtrace:
CPU: 0 UID: 0 PID: 5790 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6938
 xa_head include/linux/xarray.h:1210 [inline]
 xas_start+0x618/0x770 lib/xarray.c:191
 xas_load+0x2c/0x5a0 lib/xarray.c:239
 xas_find+0x157/0x980 lib/xarray.c:1409
 kvm_count_mem_attr_entries virt/kvm/kvm_main.c:2558 [inline]
 kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2660 [inline]
 kvm_vm_ioctl_set_mem_attributes+0x1578/0x1af0 virt/kvm/kvm_main.c:2690
 kvm_vm_ioctl+0xb33/0xd30 virt/kvm/kvm_main.c:5421
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4321f9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4322e33028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4322225fa0 RCX: 00007f4321f9e159
RDX: 0000200000002200 RSI: 000000004020aed2 RDI: 0000000000000004
RBP: 00007f432203503b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4322226038 R14: 00007f4322225fa0 R15: 00007ffea2b6d9c8
 </TASK>

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/linux/xarray.h:1227 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
locks held by syz.2.19/5790: 1, last CPU#0:
 #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2605 [inline]
 #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_ioctl_set_mem_attributes+0x365/0x1af0 virt/kvm/kvm_main.c:2690

stack backtrace:
CPU: 0 UID: 0 PID: 5790 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6938
 xa_entry include/linux/xarray.h:1226 [inline]
 xas_descend lib/xarray.c:208 [inline]
 xas_load+0x4dc/0x5a0 lib/xarray.c:246
 xas_find+0x157/0x980 lib/xarray.c:1409
 kvm_count_mem_attr_entries virt/kvm/kvm_main.c:2558 [inline]
 kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2660 [inline]
 kvm_vm_ioctl_set_mem_attributes+0x1578/0x1af0 virt/kvm/kvm_main.c:2690
 kvm_vm_ioctl+0xb33/0xd30 virt/kvm/kvm_main.c:5421
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4321f9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4322e33028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4322225fa0 RCX: 00007f4321f9e159
RDX: 0000200000002200 RSI: 000000004020aed2 RDI: 0000000000000004
RBP: 00007f432203503b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4322226038 R14: 00007f4322225fa0 R15: 00007ffea2b6d9c8
 </TASK>

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/linux/xarray.h:1227 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
locks held by syz.2.19/5790: 1, last CPU#0:
 #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2605 [inline]
 #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_ioctl_set_mem_attributes+0x365/0x1af0 virt/kvm/kvm_main.c:2690

stack backtrace:
CPU: 0 UID: 0 PID: 5790 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6938
 xa_entry include/linux/xarray.h:1226 [inline]
 xas_next_entry include/linux/xarray.h:1731 [inline]
 kvm_count_mem_attr_entries virt/kvm/kvm_main.c:2558 [inline]
 kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2660 [inline]
 kvm_vm_ioctl_set_mem_attributes+0x1834/0x1af0 virt/kvm/kvm_main.c:2690
 kvm_vm_ioctl+0xb33/0xd30 virt/kvm/kvm_main.c:5421
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4321f9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4322e33028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4322225fa0 RCX: 00007f4321f9e159
RDX: 0000200000002200 RSI: 000000004020aed2 RDI: 0000000000000004
RBP: 00007f432203503b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4322226038 R14: 00007f4322225fa0 R15: 00007ffea2b6d9c8
 </TASK>

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/linux/xarray.h:1244 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
locks held by syz.2.19/5790: 1, last CPU#0:
 #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2605 [inline]
 #0: ffff88810b9900a0 (&kvm->slots_lock){+.+.}-{4:4}, at: kvm_vm_ioctl_set_mem_attributes+0x365/0x1af0 virt/kvm/kvm_main.c:2690

stack backtrace:
CPU: 0 UID: 0 PID: 5790 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6938
 xa_parent+0xec/0xf0 include/linux/xarray.h:1243
 xas_find+0x6f2/0x980 lib/xarray.c:1422
 kvm_count_mem_attr_entries virt/kvm/kvm_main.c:2558 [inline]
 kvm_vm_set_mem_attributes virt/kvm/kvm_main.c:2660 [inline]
 kvm_vm_ioctl_set_mem_attributes+0x1578/0x1af0 virt/kvm/kvm_main.c:2690
 kvm_vm_ioctl+0xb33/0xd30 virt/kvm/kvm_main.c:5421
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4321f9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4322e33028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4322225fa0 RCX: 00007f4321f9e159
RDX: 0000200000002200 RSI: 000000004020aed2 RDI: 0000000000000004
RBP: 00007f432203503b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4322226038 R14: 00007f4322225fa0 R15: 00007ffea2b6d9c8
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
[davimaba.v@proton.me kvm@vger.kernel.org pbonzini@redhat.com security@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

