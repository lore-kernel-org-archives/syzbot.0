Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF743A9615
	for <syzbot@lists.linux.dev>; Thu, 15 Oct 2026 06:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792045909; cv=none; b=f2+802ZbxjAeClssry/WakBbVdgOPYWLZKq4nd24iIGAakqAj2Hru+pEKlu8faW/H32Ul0C/jt1EERJw/aQTrebwb9PrWSUCI90HuuXdI+xJmvbfhm3a4GVJgWy0tdJKiXZ6pX7XR5GKF9QqHqyxLAs3V5oAMvd2KQCaFVEi1rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792045909; c=relaxed/simple;
	bh=B8S0LlkmJ7EjMISZNd7v7BcToBZJiQKXzNCR1/0gNH8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=dpDMtnYVzMDWWYh2UonNzp1Ro2ueS+Dj+7Qxzxrb9lAfmg9Je1EiDJaGfqhiM+f4lb0l5qPaJsnGt/uF8X/b63+3PFqgYwo+WCw/AYdQ2oOPE6VelQfG0HvSnNn60tYfk2JJUYd5g3e9IKazt49mEM8UtEgnBdf1FdUc1e/O1pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4f8281066c4so7977288b6e.2
        for <syzbot@lists.linux.dev>; Wed, 14 Oct 2026 23:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792045907; x=1792650707;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3F35E4jPIx7RMMTCdlc4Vo4sGi0Ur0Tkpp/QXlSGOsg=;
        b=jtZVZFy2nga6ZkCVB+wZ+yVPlFfzG7FdhUWD/GzFF+jnBE5I66D+xPQmJmlk4vNBYu
         hdGfQxqWMx9sNXjBeIvvfK7TvecyZc+deShqTejioDtVF+MBzkfCbVi1S5jEVeFpO1sJ
         XBMGY4up4KxR7wnKA/UCpXM9VeN93OD0SSDICho4DZQYC99FmlosBA3h7oSEpV9km5ys
         YZdRpfGOMxc7HBdYqiOxhvi40cod9dicGfbAaaFuMt/s09MLAQdDcrrY+qlZl/+lT66q
         YGltIMlLEO3FAqzXmyPCVyjVbZFCtHMSvxN2D2Ha8IXkHb/WztU8sRT0+nBUSKxXEJe5
         LXXw==
X-Gm-Message-State: AFq9FYLqUpSP44RxmF8KnH8wtX3sGgvNGT2P3eG1nQKwTQnPkanWV2ce
	eLnOoqqP8o0eoCIXpwX89+RzhEPV6npPsysqXkMK76U/8Sy1w0ERyFDddVJvGwQel7B2HyG1Rzx
	/D2TLdKC+r1OKD1G4MdfWbLpERWHkYpVPgarvgDtg1134OA9G3VfP46ysvNM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f28:b0:4b3:7b31:8df7 with SMTP id
 5614622812f47-50c524711f0mr20489692b6e.14.1792045907183; Wed, 14 Oct 2026
 23:31:47 -0700 (PDT)
Date: Wed, 14 Oct 2026 23:31:47 -0700
In-Reply-To: <20261014220508.518772-1-dwmw2@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad07353.5f317f00.247b6.0062.GAE@google.com>
Subject: [syzbot ci] Re: KVM: x86/xen: Don't drop event deliveries which race
 memslot updates
From: syzbot ci <syzbot+ci189dc6e331dcf349@syzkaller.appspotmail.com>
To: dwmw2@infradead.org, dwmw@amazon.co.uk, fgriffo@amazon.co.uk, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, paul@xen.org, pbonzini@redhat.com, 
	seanjc@google.com, vkuznets@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] KVM: x86/xen: Don't drop event deliveries which race memslot updates
https://lore.kernel.org/all/20261014220508.518772-1-dwmw2@infradead.org
* [PATCH v2 01/11] KVM: pfncache: Return -EAGAIN for a lookup which hits an invalid memslot
* [PATCH v2 02/11] KVM: pfncache: Add a 'wait' argument to the refresh and activate functions
* [PATCH v2 03/11] KVM: x86/xen: Don't block on xen_lock within the vCPU's kvm->srcu section
* [PATCH v2 04/11] KVM: x86/xen: Wait out memslot updates in the Xen attribute ioctls
* [PATCH v2 05/11] KVM: x86/xen: Don't lose the timer event when delivery fails transiently
* [PATCH v2 06/11] KVM: x86/xen: Retry event channel delivery which races a memslot update
* [PATCH v2 07/11] KVM: x86/xen: Extract delivery of event to vCPU into a separate helper
* [PATCH v2 08/11] KVM: x86/xen: Explicitly tag "shared info" page as never being dirty tracked
* [PATCH v2 09/11] KVM: x86/xen: Don't dirty track "vCPU info" page
* [PATCH v2 10/11] KVM: x86: Request the guest TLB flush from record_steal_time()
* [PATCH v2 11/11] KVM: selftests: Add Xen evtchn vs memslot-update race test

and found the following issue:
WARNING: suspicious RCU usage in kvm_gpc_check

Full report is available here:
https://ci.syzbot.org/series/cde10220-9f8c-48fe-a62d-36d3df4d9a0b

***

WARNING: suspicious RCU usage in kvm_gpc_check

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      d4b7fb647204f0c81dfeae2d1a708e4d858e0c94
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/dbdeec8a-a092-44d6-96b1-12ae99a6a0ce/config

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/linux/kvm_host.h:1094 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
locks held by syz.0.18064/14640: 3, last CPU#0:
 #0: ffff8881133851a8 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0x27f/0xfd0
 #1: ffff8880201d5d30 (&kvm->arch.xen.xen_lock){+.+.}-{4:4}, at: kvm_xen_vcpu_set_attr+0x4d/0x1250
 #2: ffff8881133861e0 (&gpc->lock){....}-{3:3}, at: xen_get_guest_pvclock+0x29/0x260

stack backtrace:
CPU: 0 UID: 0 PID: 14640 Comm: syz.0.18064 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 lockdep_rcu_suspicious+0x140/0x1d0
 kvm_gpc_check+0x325/0x380
 xen_get_guest_pvclock+0x3e/0x260
 kvm_xen_start_timer+0x160/0x5f0
 kvm_xen_vcpu_set_attr+0xbb2/0x1250
 kvm_arch_vcpu_ioctl+0x1485/0x23a0
 kvm_vcpu_ioctl+0x7e3/0xfd0
 __se_sys_ioctl+0xfc/0x170
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3c49f9e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3c4ae4a028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f3c4a226090 RCX: 00007f3c49f9e559
RDX: 00002000000000c0 RSI: 000000004048aecb RDI: 000000000000000a
RBP: 00007f3c4a0358b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3c4a226128 R14: 00007f3c4a226090 R15: 00007ffed7dff5b8
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
