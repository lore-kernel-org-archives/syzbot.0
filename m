Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDAF43F0BA
	for <syzbot@lists.linux.dev>; Sat, 18 Jul 2026 17:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784396755; cv=none; b=Skr6h4cclfpUJEfTVCUb+TDx4t9uacNVNK1IulBlWiPEj67RqF7IRaDj9hUKwiKk8HZGxrw7TSlT4V3a7p99ak9I2Sl7mJ0eMeFS/UqZIJsGREL9M12PaIfXeEdSJBhqpN7GlwNlHoonczFnsmAyaz856gbNIWqXVGlKcqH7OBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784396755; c=relaxed/simple;
	bh=jIfkucsbqDKY88nfsMjTtAi9OVAkJC8FqD9vcQ6ertA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=dcyyJXTnJan/6BjeRvsakLamUG7lwro3xHU41Hyjj5s0OE/qLDSFd6fceViVEHbebxdMP4/JD2KocX/ikzIfgW3+iJfGC8pYXD9+j78fSeAcU+oNsz7FzQXBqW1SUjYZGlWeqFeWlbAnX++NGg9gM1PDzh+HSaa0ZZvWnweyNR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a41f46d629so8219501b6e.3
        for <syzbot@lists.linux.dev>; Sat, 18 Jul 2026 10:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784396753; x=1785001553;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fBrzXeXZM4BftU4q6PsZCBPmJrZPjUbuzm6auyLa3iw=;
        b=TvKqd0cGJ5lRCtAz2dSlIKHUljlUMRFOoIiq9XDE3Ottid68v+OGBSPtOBvp2ofQnF
         CJC3ZEVQaFlh2shgduWgwyVVN2pfgpgW5si5BhSaC5hE10YIJEQOiShk+r813D9Dw/jB
         Tg4EZxFBlBB1iB20zgfTUySMu+JnISda1K44j+T2pyAff70SDpHfjr77U3zx/xnx7rA8
         dQKvdG3CEfIRzSq3gYOMxEoic8S+SLRN+uvF22MASwmfL/AzwnD/Amyr2JhiLIw5ATkE
         OYyitC0j96jaMjn7nImAlyCy1f5zMEzF5ap0W2OUXFat/iefB7/rGPe6jht4jo8NOkWO
         BPkA==
X-Gm-Message-State: AOJu0Yy2ibtc5lxD2uH0WEDG6zHzD+HEGw5P3VOqlrMnX3EJGPaCptoY
	pp+d2H7CItp1Bz7SU2KxBN+k2X/N9XjGrYqvhKKHjhhSsNZzQBkbenOLxSOdWdA9Gvevy75bdEf
	JGCMQQLo8S/zAm+v98xDUJrukm+7DPSnOoonUGV6hc8ZaQJ9afnWIg/0gJx0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1384:b0:496:a01:458b with SMTP id
 5614622812f47-4a4d03262edmr4549283b6e.2.1784396753119; Sat, 18 Jul 2026
 10:45:53 -0700 (PDT)
Date: Sat, 18 Jul 2026 10:45:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5bbbd1.42649fcc.6186.006b.GAE@google.com>
Subject: [moderation/CI] Re: Fix an imbalanced file ref count in the mmap syscall
From: syzbot ci <syzbot+ci238e01f3c60e6304@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Fix an imbalanced file ref count in the mmap syscall
https://lore.kernel.org/all/20260718123417.16339-1-liavalb@gmail.com
* [PATCH] mm/vma: fix imbalanced file reference count, properly abort mmap_prepare

and found the following issue:
WARNING in tear_down_vmas

Full report is available here:
https://ci.syzbot.org/series/63d42f9f-f249-4678-8916-5464a15accd6

***

WARNING in tear_down_vmas

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      3827fe994db98623a5a619a72f15f57bf8274deb
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/f57e989a-6273-4413-b35d-20dab5a41e92/config
syz repro: https://ci.syzbot.org/findings/8f36751f-0976-460a-b5ab-de97c9074c0a/syz_repro

------------[ cut here ]------------
!vma_is_attached(vma)
WARNING: ./include/linux/mmap_lock.h:435 at vma_assert_attached include/linux/mmap_lock.h:435 [inline], CPU#0: syz.2.19/5813
WARNING: ./include/linux/mmap_lock.h:435 at vma_mark_detached include/linux/mmap_lock.h:455 [inline], CPU#0: syz.2.19/5813
WARNING: ./include/linux/mmap_lock.h:435 at tear_down_vmas+0x381/0x520 mm/mmap.c:1261, CPU#0: syz.2.19/5813
Modules linked in:
CPU: 0 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vma_assert_attached include/linux/mmap_lock.h:435 [inline]
RIP: 0010:vma_mark_detached include/linux/mmap_lock.h:455 [inline]
RIP: 0010:tear_down_vmas+0x381/0x520 mm/mmap.c:1261
Code: 48 89 df e8 01 46 16 00 48 8b 44 24 18 48 39 03 0f 87 e0 00 00 00 e8 ce a8 a8 ff ff 44 24 04 e9 9a fd ff ff e8 c0 a8 a8 ff 90 <0f> 0b 90 e9 2c ff ff ff e8 b2 a8 a8 ff 90 0f 0b 90 e9 94 fe ff ff
RSP: 0018:ffffc90003cdf7e0 EFLAGS: 00010293
RAX: ffffffff821dbb90 RBX: ffff888115e14b40 RCX: ffff888171f9bb80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003cdf920 R08: ffff888115e14b43 R09: 1ffff11022bc2968
R10: dffffc0000000000 R11: ffffed1022bc2969 R12: ffff888115e14a80
R13: 0000000000000001 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f15b88e36c0(0000) GS:ffff88818dc1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9033eab095 CR3: 0000000173ace000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 exit_mmap+0x4ca/0x9f0 mm/mmap.c:1320
 __mmput+0x118/0x420 kernel/fork.c:1187
 exit_mm+0x221/0x2d0 kernel/exit.c:610
 do_exit+0x6cd/0x2360 kernel/exit.c:992
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1147
 get_signal+0x121b/0x12c0 kernel/signal.c:3038
 arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
 exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f15b799ce59
Code: Unable to access opcode bytes at 0x7f15b799ce2f.
RSP: 002b:00007f15b88e30e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f15b7c15fa8 RCX: 00007f15b799ce59
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f15b7c15fa8
RBP: 00007f15b7c15fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f15b7c16038 R14: 00007ffe1b61d9f0 R15: 00007ffe1b61dad8
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

The email will later be sent to:
[akpm@linux-foundation.org david@kernel.org jannh@google.com liam@infradead.org liavalb@gmail.com linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org mhocko@suse.com pfalcato@suse.de rppt@kernel.org surenb@google.com vbabka@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

