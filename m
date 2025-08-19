Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FC525C816
	for <syzbot@lists.linux.dev>; Tue, 19 Aug 2025 14:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755613624; cv=none; b=af/gD3jZwpQS9GV1DF/LhYAXoRM18hhDHqk0F3WfeJga2/9Nf2FQdhxu2iGnCO4u9g4lUSxJim10peu+hjsBTvvv9nTOigl9NthFI6DF9x4fLwBfbvdxx7s/GWPhwqYNoY9sdtsJAOgSq7efUDe8fWTU38VUZ2v8ombsmINn7RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755613624; c=relaxed/simple;
	bh=ONhD8AdbvQjoKIU9iaiAeOn0II4tBDZgTBhfzxxJmaI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=uWKgdBbyzDYq35cTu/UqYi4n8pPCPY8qdQ2JZa9ZUWOBqMMWMAxGBralLYy5JfGLNEf0jU9CYs3TGfcmKRqbnKepnbVwqjgKo/Xq/QMnKdE7iLE/Wkh+EInl6VD6gce1e7sFtKKTBtR1epCwrDowHGrA3jD+DApvBo90fW28sBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-88432e5f161so1452122839f.3
        for <syzbot@lists.linux.dev>; Tue, 19 Aug 2025 07:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755613622; x=1756218422;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ujSQ6j2CVfwnE99NNB4nQ2rs8NqtvLwTyofbbR1JjEE=;
        b=Q41ThXtQ/RompQ/5W+cJpcp2aLPUNr60b081vMuk7wgiZokfViVH5U0Z5V+fuKmeux
         ovHlX7SfwE3ZY1RUlLuxrD4gvwNzsTV1d37FWd7GxApc7sH7Nuw5GpaRArBcE+r1ira3
         g77yAkoKhwtBWjazzkReeLl9uFv9QmlPyu0zxVjRTVk9f7oh7Q+QCPE4tGYfxvF34J6v
         C4kff2qR+XfscR4aLuq/etiTSvazVFJYXQujMJH8YS4gDNZVyncnbAcQPE3MylfXDMKF
         smZim7UGBgu4H5RKS1gMdmsQX2DU3Z9MEOd//oLGtv+o7IXdSpXKe2SKSDukXlI1Q1ZQ
         /Leg==
X-Gm-Message-State: AOJu0Yz0PRxM1BYIQKDSM2kI/k2PQsCTHiC9QrJedi5K0TLNrDo1wWi/
	LVQov3NSKuGTZmOjfVn3ZHfMq/g9EcWBmcx8SShQrrNdf1gc9umQbUlsJlvSME0hlLh4eP47xag
	SpcK50qCJeMNR4To/NghJLwT6ZqfVPozqG5L/vubqzfvs78vYV73JRsgv1vs=
X-Google-Smtp-Source: AGHT+IFdJk1gy7F96Lh81Rjq8z8i5CoTkrdqEFa5vCv0rDvj1oLDIbIJL4yjq1sxgGsJ2p91wbweYY6zklVPHDqzvQfgHJZR8fLT
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d16:b0:87c:2e82:5a6a with SMTP id
 ca18e2360f4ac-88467e9a446mr529165539f.4.1755613622412; Tue, 19 Aug 2025
 07:27:02 -0700 (PDT)
Date: Tue, 19 Aug 2025 07:27:02 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a489b6.050a0220.1b2f6c.0008.GAE@google.com>
Subject: [moderation/CI] Re: KVM: Speed up MMIO registrations
From: syzbot ci <syzbot+cid1f70a8279f5df6f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] KVM: Speed up MMIO registrations
https://lore.kernel.org/all/20250819090853.3988626-1-keirf@google.com
* [PATCH v3 1/4] KVM: arm64: vgic-init: Remove vgic_ready() macro
* [PATCH v3 2/4] KVM: arm64: vgic: Explicitly implement vgic_dist::ready ordering
* [PATCH v3 3/4] KVM: Implement barriers before accessing kvm->buses[] on SRCU read paths
* [PATCH v3 4/4] KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()

and found the following issue:
WARNING in kvm_put_kvm

Full report is available here:
https://ci.syzbot.org/series/3dc60813-f155-4817-8552-1f86bd35f4e4

***

WARNING in kvm_put_kvm

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/a80ce1fb-9721-4229-8c84-f01975da18a2/config
C repro:   https://ci.syzbot.org/findings/c7213edd-3666-4fca-886f-07477eb19900/c_repro
syz repro: https://ci.syzbot.org/findings/c7213edd-3666-4fca-886f-07477eb19900/syz_repro

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6003 at kernel/rcu/srcutree.c:697 cleanup_srcu_struct+0x4ea/0x5f0 kernel/rcu/srcutree.c:697
Modules linked in:
CPU: 0 UID: 0 PID: 6003 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:cleanup_srcu_struct+0x4ea/0x5f0 kernel/rcu/srcutree.c:697
Code: 8b 5c 24 08 74 08 48 89 df e8 e2 30 7d 00 48 c7 03 00 00 00 00 48 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 90 <0f> 0b 90 eb e6 90 0f 0b 90 eb e0 90 0f 0b 90 eb 14 90 0f 0b 90 eb
RSP: 0018:ffffc90003b0fc78 EFLAGS: 00010202
RAX: 1ffffd1fe28c5059 RBX: 1ffff1102341db2b RCX: b3fdaa5e0844b500
RDX: 0000000000000000 RSI: ffffffff8dba5bb5 RDI: ffff888022170000
RBP: ffffe8ff146282c8 R08: ffffe8ff14628367 R09: 1ffffd1fe28c506c
R10: dffffc0000000000 R11: fffff91fe28c506d R12: ffff88811a0ed958
R13: 0000000000000000 R14: dffffc0000000000 R15: 1ffffffff1b7be74
FS:  000055557858e500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c002fcff88 CR3: 000000003a46e000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 kvm_destroy_vm virt/kvm/kvm_main.c:1324 [inline]
 kvm_put_kvm+0x8ca/0xa70 virt/kvm/kvm_main.c:1353
 kvm_vm_release+0x43/0x50 virt/kvm/kvm_main.c:1376
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d1/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f975198ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffbfd6bfd8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 000000000000ed88 RCX: 00007f975198ebe9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 00000003bfd6c2cf
R10: 0000001b2fa20000 R11: 0000000000000246 R12: 00007f9751bb5fac
R13: 00007f9751bb5fa0 R14: ffffffffffffffff R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[eric.auger@redhat.com keirf@google.com kvm@vger.kernel.org linux-arm-kernel@lists.infradead.org linux-kernel@vger.kernel.org maz@kernel.org oliver.upton@linux.dev pbonzini@redhat.com seanjc@google.com will@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

