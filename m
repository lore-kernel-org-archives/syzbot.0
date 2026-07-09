Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E2B3C4575
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 06:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783578395; cv=none; b=j2mFvgIpAl3/x9aHDqtzv8e/pv0vfpYzrzqocSgf+K+uZzf9q/l7VmECACa+zQbkSTmEpqsLaTmceJ+dB3IAxNcAOAnBhiaWZ9yDcEGzUCJXgsg682nbyCv5x30+0xBJC7B4oFof3Z3YRTY944uvjJTefeLfoZ2Jpby5eeFUgnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783578395; c=relaxed/simple;
	bh=bymmM7itjNf6NASDeVGA5S1tohPd/mGFdJxsI2iR/Ec=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=S590HuAXzNSwAO8VHYezNJYonNDI1ofwvhrM9VN1Dsy/7Kkbo8DiRwgejax/82mP6YJjvIQg93rImC8bh/koa4eeF6A4rjGQ6nj5rdABGnAEDl9Kzm3wmUVKbnlElXSJlbN+1qDuTktkjtL+GpVRwEQxAcK9+BfChQheloWMffI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7eb6429750eso2139382a34.0
        for <syzbot@lists.linux.dev>; Wed, 08 Jul 2026 23:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783578383; x=1784183183;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aGYb6cIYWCwKklV7e199C3toXW7ue1Oty8gsT7/cke4=;
        b=GKvdV66XHxDE4dkwy3JERNUVpPOD5MylrSphblZZm/Y5oMsED1Musco/BccDxrk/xt
         4CfByaZ0U3K57YD1BtlBaCbzLCHW8O8hgt2Tp8+dtvBdfk+fPlBf9IJsuHqtTx50gu+V
         qDBh7prbsvSWvvgL45RowC1JDPes6AbHAJeyEBs14jWtpwuYSwVXJHUa/A3ySBrSXVOz
         27gwjcnFmWEjlcz+XMeuhkzR7ljS3C+oc/cWzY/i6bYZ8WPFjqarp58ajZWsdIRU/0ZE
         qlyhkcZ7/FG6ZRWs+QOQwJ/j6KXSCXrj69n8sI7AHhlfTwEmXQ2LoOX9tbW5wjuSWc3j
         gSKA==
X-Gm-Message-State: AOJu0Yw8f0ZVSYit2BlQRIBm3DToTJUyCjeDiDzumCC7zyzRLnDvea1E
	fZ2BQ6cBvRQna16SzjLx6ZC90n2keSqwfWEquyQCQYc+zNHqQdbtL2Fxh+tr7ygB/QsSxcbBnAe
	of8uHu/6LlWkASs28CCzgXBkej+6We6sYLKJZtLKznyPEsgK12PTSdOkLwjY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d09:b0:6a3:66dd:c9fa with SMTP id
 006d021491bc7-6a36da10ff8mr3986082eaf.55.1783578382884; Wed, 08 Jul 2026
 23:26:22 -0700 (PDT)
Date: Wed, 08 Jul 2026 23:26:22 -0700
In-Reply-To: <20260707-riscv_insn_table-v3-0-3f8e5f75ba97@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4f3f0e.57639fcc.86d58.001b.GAE@google.com>
Subject: [syzbot ci] Re: riscv: Generate riscv instruction functions
From: syzbot ci <syzbot+ci19dac46105b003f7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, alex@ghiti.fr, anup@brainfault.org, 
	atish.patra@linux.dev, conor@kernel.org, jtaubepe@redhat.com, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-riscv@lists.infradead.org, namcao@linutronix.de, palmer@dabbelt.com, 
	pbonzini@redhat.com, pjw@kernel.org, radim.krcmar@oss.qualcomm.com, 
	shuah@kernel.org, thecharlesjenkins@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] riscv: Generate riscv instruction functions
https://lore.kernel.org/all/20260707-riscv_insn_table-v3-0-3f8e5f75ba97@gmail.com
* [PATCH v3 01/17] riscv: Introduce instruction table generation
* [PATCH v3 02/17] riscv: alternatives: Use generated instruction headers for patching code
* [PATCH v3 03/17] riscv: kgdb: Use generated instruction headers
* [PATCH v3 04/17] riscv: Add kprobes instruction simulation KUnit
* [PATCH v3 05/17] riscv: kprobes: Use generated instruction headers
* [PATCH v3 06/17] riscv: cfi: Use generated instruction headers
* [PATCH v3 07/17] riscv: Maintain epc on misaligned emulation error
* [PATCH v3 08/17] riscv: Use generated instruction headers for misaligned loads/stores
* [PATCH v3 09/17] riscv: kvm: Use generated instruction headers for csr code
* [PATCH v3 10/17] KVM: device: Add test device
* [PATCH v3 11/17] KVM: riscv: selftests: Add mmio test
* [PATCH v3 12/17] riscv: kvm: Use generated instruction headers for mmio emulation
* [PATCH v3 13/17] riscv: kvm: Add emulated test csr
* [PATCH v3 14/17] KVM: riscv: selftests: Add csr emulation test
* [PATCH v3 15/17] riscv: kvm: Use generated instruction headers for csr emulation
* [PATCH v3 16/17] riscv: kexec: Use generated instruction headers for kexec relocations
* [PATCH v3 17/17] riscv: Remove unused instruction headers

and found the following issue:
WARNING in kvm_io_bus_unregister_dev

Full report is available here:
https://ci.syzbot.org/series/f3c61796-0ca0-4bfd-add1-23a20352fb7b

***

WARNING in kvm_io_bus_unregister_dev

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      8cd9520d35a6c38db6567e97dd93b1f11f185dc6
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/65190eb6-0d65-4629-b225-e3b7089a0b10/config
syz repro: https://ci.syzbot.org/findings/fa2c789e-ba9f-4d55-b3ba-0d5f22f78a4d/syz_repro

------------[ cut here ]------------
debug_locks && !(lock_is_held(&(&kvm->slots_lock)->dep_map) != 0)
WARNING: arch/x86/kvm/../../../virt/kvm/kvm_main.c:6027 at kvm_io_bus_unregister_dev+0x4b0/0x580 virt/kvm/kvm_main.c:6027, CPU#1: syz.2.19/5828
Modules linked in:
CPU: 1 UID: 0 PID: 5828 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:kvm_io_bus_unregister_dev+0x4b0/0x580 virt/kvm/kvm_main.c:6027
Code: 3f fc ff ff e8 a1 ce 86 00 48 c7 c7 40 f7 c1 8b e8 a5 29 e9 ff 48 89 ef e8 ed 00 00 00 b8 f4 ff ff ff eb a3 e8 81 ce 86 00 90 <0f> 0b 90 e9 cd fb ff ff 48 c7 c1 e0 bb 2f 90 80 e1 07 80 c1 03 38
RSP: 0018:ffffc900032afc30 EFLAGS: 00010293
RAX: ffffffff813e81af RBX: ffff88816b133688 RCX: ffff888160aba540
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffc900032afb7f R09: 0000000000000000
R10: ffffc900032afb70 R11: ffffffff81404850 R12: dffffc0000000000
R13: 0000000000000000 R14: dffffc0000000000 R15: ffff8881a5354000
FS:  000055555b90c500(0000) GS:ffff8882a92b9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33663fff CR3: 00000001bceb8000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 mmio_test_destroy+0x66/0x90 virt/kvm/mmio_test.c:83
 kvm_destroy_devices virt/kvm/kvm_main.c:1251 [inline]
 kvm_destroy_vm virt/kvm/kvm_main.c:1296 [inline]
 kvm_put_kvm+0x902/0xae0 virt/kvm/kvm_main.c:1332
 kvm_vm_release+0x43/0x50 virt/kvm/kvm_main.c:1355
 __fput+0x418/0xa50 fs/file_table.c:510
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0x193/0x6b0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2f43d9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffde9296e78 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007ffde9296f60 RCX: 00007f2f43d9ce59
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000011938 R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b32a20000 R11: 0000000000000246 R12: 00007ffde9296fa0
R13: 00007f2f44015fac R14: 0000000000011971 R15: 00007f2f44015fa0
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
