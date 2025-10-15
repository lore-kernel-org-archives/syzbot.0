Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D757A3002A2
	for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 17:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760550527; cv=none; b=RR5nohRnKqVwwW12FRe1iU/HQih8M8Q3OJqg0rqr9vadXZyVonx+j1RyhFqkF7nHhajavVu9YxIpllLegETUtHCjDKCMXUnECTApPTlhaGs8DkWwJ9HcJ/1dYelpvniSYZg1sZ+lHwHU+7WkxpeT5w6b0JIrQD2cO4oCWs1JpTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760550527; c=relaxed/simple;
	bh=IucoTQH0q1uwyj6Ds7YE1BsdjMEUrG4yGJjVlrrtEqM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=AjB+HNhFZFVrSG+zvBgLj8eqFT5Ht/thOc8XS/w6SB4TlXwYJ8heik+cVVsn4qtyv2cC7BHm2m4I88sAMRNbW9DS+T8qIxIT0xes2v7ES7RhXkMrCu5vxy7oBL9hm48tBF8P5XtFKjhgzQX4hlbb5VEbrK9EkG8qPULBqigx0E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42f989e2030so135204255ab.2
        for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 10:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760550525; x=1761155325;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BTeMMOAl68AFSHVaL0DE02o75Y2hBV4MP80bKqFZr00=;
        b=TrQZDhOgcVr5+ThUhpQx/7k/HtvtZbPNBPPDBREXxT6rTeghNQ5vYSaVrUy9fYofxG
         bJEgs0PI1PEYfCUtyOTpt8cR0BfZmA1zlLv7myM0H6It6HlvQkiAQtUonq+CDXxIvbhR
         JXVxrEroaJrgP9Uh1+pYoc1Lt5yhq+dNU4A59A4w2YhW9kHaWX9MVifrvYRuemiztH2Z
         RbarY1W0Aq1kNA9txMFZ229Khd7R9CMUn1UJdxdmY334xhHX5iPu6RCj0N3R8OVceplY
         w/NTaiJgBuzR5fbQao0TLHjR5Fhf8cnfFIAW2K6thU2roTt59QmZG2zy3RFaM2a4gb1r
         rYUA==
X-Gm-Message-State: AOJu0YxSipKA2Ic5CvutVdOB4sjNtlV7ce47+x+j8isZjtA/JEO1rY7b
	G/ti1KH8ovEFSC5Er7rCTgpisKP7HEGa/5d308oXIBFL6NQz66ZzaEoenAj0iGFs9RgOYdf2UMs
	da76pVqYgEp6MyZWaZKvv/ZQgYg3yog4ss1nwjE1yCw9Qlly1QLFBSrjv+cQ=
X-Google-Smtp-Source: AGHT+IG1aCYWQ3vo3AndgUC3LpLgSH3cn9j11z0fWX+jYt2Xl+GpBhohAwbGjbTmBwzAKBjh3rwJi1H+KoJkmKE9jJk9K3Y7/cu/
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19ca:b0:42e:2c30:2835 with SMTP id
 e9e14a558f8ab-42f872c11f6mr309993385ab.0.1760550524841; Wed, 15 Oct 2025
 10:48:44 -0700 (PDT)
Date: Wed, 15 Oct 2025 10:48:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68efde7c.050a0220.91a22.02bb.GAE@google.com>
Subject: [moderation/CI] Re: slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
From: syzbot ci <syzbot+ci589653ca55210abe@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
https://lore.kernel.org/all/20251015125945.481950-1-hao.ge@linux.dev
* [PATCH v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab

and found the following issue:
kernel BUG in __free_slab

Full report is available here:
https://ci.syzbot.org/series/61ff4fe1-2e84-410d-ad85-42ead772d9c8

***

kernel BUG in __free_slab

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e5875084-ea86-418c-979d-5b00cded86c=
a/config
syz repro: https://ci.syzbot.org/findings/1f8913d8-6d9a-448a-9419-90b758c82=
c3b/syz_repro

 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
kernel BUG at mm/slab.h:544!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT(fu=
ll)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:slab_obj_exts mm/slab.h:543 [inline]
RIP: 0010:free_slab_obj_exts mm/slub.c:2178 [inline]
RIP: 0010:unaccount_slab mm/slub.c:3186 [inline]
RIP: 0010:__free_slab+0x1b8/0x1e0 mm/slub.c:3286
Code: e8 2d 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 1b 8a 0c ff =
90 0f 0b 48 89 df 48 c7 c6 9d 66 95 8d e8 09 8a 0c ff 90 <0f> 0b 48 89 df 4=
8 c7 c6 18 ad 91 8d e8 f7 89 0c ff 90 0f 0b 48 89
RSP: 0000:ffffc900001478b0 EFLAGS: 00010246
RAX: 680205e52e87ff00 RBX: ffffea00044c3c80 RCX: 680205e52e87ff00
RDX: 0000000000000000 RSI: ffffffff8d7e835a RDI: ffffffff8bc076e0
RBP: 0000000000000001 R08: ffffffff8f9e1177 R09: 1ffffffff1f3c22e
R10: dffffc0000000000 R11: fffffbfff1f3c22f R12: ffffffff821b61b0
R13: ffffffff81a82877 R14: ffff888160415a00 R15: ffffea00044c3c98
FS:  0000000000000000(0000) GS:ffff88818e70c000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fef42bb12f8 CR3: 000000000df38000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:622
 run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
 smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:slab_obj_exts mm/slab.h:543 [inline]
RIP: 0010:free_slab_obj_exts mm/slub.c:2178 [inline]
RIP: 0010:unaccount_slab mm/slub.c:3186 [inline]
RIP: 0010:__free_slab+0x1b8/0x1e0 mm/slub.c:3286
Code: e8 2d 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 1b 8a 0c ff =
90 0f 0b 48 89 df 48 c7 c6 9d 66 95 8d e8 09 8a 0c ff 90 <0f> 0b 48 89 df 4=
8 c7 c6 18 ad 91 8d e8 f7 89 0c ff 90 0f 0b 48 89
RSP: 0000:ffffc900001478b0 EFLAGS: 00010246
RAX: 680205e52e87ff00 RBX: ffffea00044c3c80 RCX: 680205e52e87ff00
RDX: 0000000000000000 RSI: ffffffff8d7e835a RDI: ffffffff8bc076e0
RBP: 0000000000000001 R08: ffffffff8f9e1177 R09: 1ffffffff1f3c22e
R10: dffffc0000000000 R11: fffffbfff1f3c22f R12: ffffffff821b61b0
R13: ffffffff81a82877 R14: ffff888160415a00 R15: ffffea00044c3c98
FS:  0000000000000000(0000) GS:ffff88818e70c000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fef42bb12f8 CR3: 000000000df38000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org ast@kernel.org cl@gentwo.org gehao@kylinos.cn ha=
o.ge@linux.dev harry.yoo@oracle.com linux-kernel@vger.kernel.org linux-mm@k=
vack.org rientjes@google.com roman.gushchin@linux.dev shakeel.butt@linux.de=
v surenb@google.com vbabka@suse.cz]

If the report looks fine to you, reply with:
#syz upstream

