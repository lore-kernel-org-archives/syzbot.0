Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22BE2DCF45
	for <syzbot@lists.linux.dev>; Mon, 13 Oct 2025 21:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760390640; cv=none; b=YGzfg9gpXNZIy2CPhInnsekom+YQmQX2JRCv3Taju84O2oQBumcG78cWtlU8oCSWRR/0TUh5kPz0lOYOWYhx88XIb3Bmgx/fNbVrl4PrbD0nPbXrgVRz7hztG7X3ZxTMNbJvnJORpM4lCqDOgcwqY/KNh05V3N2eBQ75frceKIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760390640; c=relaxed/simple;
	bh=WIo7nxm0mjdKbOHE6uhCTDvalwJ0U4iAVZezzgGzI0U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qHTEH2X9yEqPBF1YJbxL5bYC1L2ZUXEPZm2Ycthx6bA62Ngt9oD7qCD99Krpo2TcEtmZFExFaN3JrjaMLajwfuNwxFkSKY/UoFmJ6Bp4zHwBo2RJCFO+TJCBQHieAhD/EsOh8nja4pFOhRJs4HRex7+3xVx4mQI4mcp6/1/ej64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-919d48f1869so2882583639f.0
        for <syzbot@lists.linux.dev>; Mon, 13 Oct 2025 14:23:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760390638; x=1760995438;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AuedoF3HxoFuNqyyGQzlzOND691M6Z4JEh01M7irQAs=;
        b=N+uVLUZe6wl9Acf2UVhQ8Vwxc9XW+BeU/X3K+Y3x7awGicR7/zI3iRMde4xCTDThT2
         GF6AgdwVehG6eD+fVGyWGlp/UdBs0wkxFABcVgCvG/adok35vVXt4hCM0j3Vn+vnp76Y
         V6h42WxP68bCimf2Iwv3+oY0B6mL30FciCqtiJ1D32U7eCa6Nxy/nSyVgeqeoyahdklB
         nRmNWLLPGh7HU1qejwDHvl5FeXXcglZDe7Hj2Cjoay1IM8oqhu24mefdN2rwDRUo0xF8
         HDh7qi+IrAdZMI3xcxlQZngusBzYW6G3f8o2yheUO/ZujFmXHs0VU89/NUExI2AsyZWS
         1Yog==
X-Gm-Message-State: AOJu0YwByB2KmP2/D6NsKPJGL/ShoWEUMTGwkJOLWxv+NOS6wV2jwOgW
	4BU3VWPgZZe8M9szMcu2RmM6yXlxRxDO5THGT5ve7ljCYcQmuvl+9Ip+uD7J1xbZU1BEsubxyZy
	fN51N4oR0K/Lw6HLgH2bj0drYFaLunGyrMoHeKFhhjq/fGqt4Bm9Z+KLYq00=
X-Google-Smtp-Source: AGHT+IFFe1fNK5RO4Atm+BOUHY1pBrGD6azAWxNtFhN2TL8jtbopXP9nB5BjxwFy9MY/zRRDR86YIRYCo/mHFVnYVyzYfII4kXpq
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c04:b0:42e:729d:5f65 with SMTP id
 e9e14a558f8ab-42f87350876mr231018935ab.1.1760390637908; Mon, 13 Oct 2025
 14:23:57 -0700 (PDT)
Date: Mon, 13 Oct 2025 14:23:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ed6ded.050a0220.91a22.01eb.GAE@google.com>
Subject: [moderation/CI] Re: KVM: x86: Unify L1TF flushing under per-CPU variable
From: syzbot ci <syzbot+ci995bc9256a200467@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] KVM: x86: Unify L1TF flushing under per-CPU variable
https://lore.kernel.org/all/20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com
* [PATCH] KVM: x86: Unify L1TF flushing under per-CPU variable

and found the following issue:
BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruction

Full report is available here:
https://ci.syzbot.org/series/c0a39c51-4121-4883-a21f-4277f63b3118

***

BUG: using __this_cpu_write() in preemptible code in x86_emulate_instruction

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      6b36119b94d0b2bb8cea9d512017efafd461d6ac
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/a964957a-128c-43dd-b6df-7758575a9993/config
C repro:   https://ci.syzbot.org/findings/c0c645e8-abe2-437f-aa29-1adf339cb732/c_repro
syz repro: https://ci.syzbot.org/findings/c0c645e8-abe2-437f-aa29-1adf339cb732/syz_repro

BUG: using __this_cpu_write() in preemptible [00000000] code: syz.0.17/5962
caller is kvm_set_cpu_l1tf_flush_l1d arch/x86/include/asm/kvm_host.h:2486 [inline]
caller is x86_emulate_instruction+0x1a4/0x1f70 arch/x86/kvm/x86.c:9405
CPU: 1 UID: 0 PID: 5962 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 check_preemption_disabled+0x10a/0x120 lib/smp_processor_id.c:47
 kvm_set_cpu_l1tf_flush_l1d arch/x86/include/asm/kvm_host.h:2486 [inline]
 x86_emulate_instruction+0x1a4/0x1f70 arch/x86/kvm/x86.c:9405
 kvm_mmu_page_fault+0x91a/0xb70 arch/x86/kvm/mmu/mmu.c:6385
 __vmx_handle_exit arch/x86/kvm/vmx/vmx.c:6624 [inline]
 vmx_handle_exit+0x10a4/0x18c0 arch/x86/kvm/vmx/vmx.c:6641
 vcpu_enter_guest arch/x86/kvm/x86.c:11461 [inline]
 vcpu_run+0x4359/0x6fc0 arch/x86/kvm/x86.c:11619
 kvm_arch_vcpu_ioctl_run+0xfc9/0x1940 arch/x86/kvm/x86.c:11958
 kvm_vcpu_ioctl+0x95c/0xe90 virt/kvm/kvm_main.c:4476
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0f9698eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff7c8600c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f0f96be5fa0 RCX: 00007f0f9698eec9
RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
RBP: 00007f0f96a11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0f96be5fa0 R14: 00007f0f96be5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[bp@alien8.de dave.hansen@linux.intel.com hpa@zytor.com jackmanb@google.com kvm@vger.kernel.org linux-kernel@vger.kernel.org mingo@redhat.com pbonzini@redhat.com seanjc@google.com tglx@linutronix.de x86@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

