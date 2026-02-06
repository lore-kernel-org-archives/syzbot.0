Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F81F2FFF88
	for <syzbot@lists.linux.dev>; Fri,  6 Feb 2026 06:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770359019; cv=none; b=Hjf7jPQ0/cdKRXZIIIggGUg0dND1XcJLkHDxbI4o/JEzgf+SAgWxAfx8Bbvh/oxcGForMMMqD//fehzGp9ZsZCKYJc2uCprjSSDNA5vGkWbpY2o0JIOkwFFe6pKlx2fbujH9NXDAdTcC8ceMD1bOwm45uUdA5s94uWUISWLI3Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770359019; c=relaxed/simple;
	bh=29tqX6CnKcR0aKhmJbUZIjWxopqmAmDF8TStkD2krhw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=I4CNuFbofjG2fGCPB8B3DlOXrnQkyBPgSiSG1r01tQEE992A6BVpV3l8ETqKd1/jcFRZHW8xGgUGY7PFVXvQ68yUgW+TQ7B/2MTh2I0bL01FEONM2M8Ww1O+/chwKZvhe7H4j0yxCmlheycnjEg0xJ+9nSyVyOR6RM2VbSfO9oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-66b8c7f0debso8449151eaf.3
        for <syzbot@lists.linux.dev>; Thu, 05 Feb 2026 22:23:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770359018; x=1770963818;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cd8Uoxb91k+GJqPuzWMXFo8rNhclVFe6jhcUtoP7u/8=;
        b=ULO4kgRAgr4r6WB6geEi6gVp1fUJTUffae8PsVNHjFSuKl7UEdSMm/BaVkoc057eXj
         /yxzqNxmaVY3LWA7YtU2x1b7Ca9XGq09I1BMPQLnIL0AY8TEtPe/cShD7znTOnX62K+w
         vu1cfYmRDHIGvRoGk+i/caNZKP0bID+LzmfrMs+RWtzFxJ0VT+Gn/YoBYcsCe+Kao9MD
         PloVyFal49ZGbWlg2IP32npQIK/OC9qnEUqzsu8M/KhUUtQaCRzNU5Sngv24MghJp9CV
         ml3AFW/OfQWQxgRhHaOi6yYQrOCLqSY/YnFVvG9pY/monP1AVbTi15QlaqcS0FCML2J0
         dlJQ==
X-Gm-Message-State: AOJu0YxJIW+btf1463fV3+heatg4fa5LOPDybR9sXgdQOxEbZNNj2i2P
	gvACr5MYbQk01tq/rmsCI7QvZsYIc2mXuUgxe1Fh39ZACaNDfiPZaT4mJAACR+d1YhLTRtjVLX9
	YUFJvnSSL0idg+ltzFCQ3RdqrKQSmiJ5whw4I4bYI02RU9/5OibjbnvtrfmA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3096:b0:65f:6cf5:f963 with SMTP id
 006d021491bc7-66d099c58b8mr934358eaf.6.1770359018148; Thu, 05 Feb 2026
 22:23:38 -0800 (PST)
Date: Thu, 05 Feb 2026 22:23:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698588ea.a00a0220.37c87e.0033.GAE@google.com>
Subject: [moderation/CI] Re: net/rds: RDS-TCP reconnect and fanout improvements
From: syzbot ci <syzbot+ci4b2f1eb20eeb4a02@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net/rds: RDS-TCP reconnect and fanout improvements
https://lore.kernel.org/all/20260206022419.1357513-1-achender@kernel.org
* [PATCH net-next v1 1/3] net/rds: Delegate fan-out to a background worker
* [PATCH net-next v1 2/3] net/rds: Use proper peer port number even when not connected
* [PATCH net-next v1 3/3] net/rds: rds_sendmsg should not discard payload_len

and found the following issue:
BUG: sleeping function called from invalid context in rds_tcp_conn_free

Full report is available here:
https://ci.syzbot.org/series/1a5ef180-c02c-401d-9df7-670b18570a55

***

BUG: sleeping function called from invalid context in rds_tcp_conn_free

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      7a4cd71fa4514cd85df39b3cf99da8142660cdcd
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/77f47047-43cb-4c25-b0b6-73b8746cea2a/config
syz repro: https://ci.syzbot.org/findings/49698f1e-4f36-4446-9dd1-c409366e6296/syz_repro

BUG: sleeping function called from invalid context at kernel/workqueue.c:4390
in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 6005, name: syz.2.19
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by syz.2.19/6005:
 #0: ffffffff8e35a360 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e35a360 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8e35a360 (rcu_read_lock){....}-{1:3}, at: __rds_conn_create+0x2e4/0x22d0 net/rds/connection.c:177
 #1: ffffffff8fa00a98 (rds_conn_lock){....}-{3:3}, at: __rds_conn_create+0x18e2/0x22d0 net/rds/connection.c:304
irq event stamp: 752
hardirqs last  enabled at (751): [<ffffffff8b7cc843>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (751): [<ffffffff8b7cc843>] _raw_spin_unlock_irq+0x23/0x50 kernel/locking/spinlock.c:202
hardirqs last disabled at (752): [<ffffffff8b7cc61a>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (752): [<ffffffff8b7cc61a>] _raw_spin_lock_irqsave+0x1a/0x60 kernel/locking/spinlock.c:162
softirqs last  enabled at (32): [<ffffffff8ac0cd59>] rds_sendmsg+0x7b9/0x2150 net/rds/send.c:1266
softirqs last disabled at (30): [<ffffffff89463a1f>] spin_lock_bh include/linux/spinlock.h:356 [inline]
softirqs last disabled at (30): [<ffffffff89463a1f>] release_sock+0x2f/0x1f0 net/core/sock.c:3793
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 6005 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:8829
 __cancel_work_sync+0x6d/0x110 kernel/workqueue.c:4390
 rds_tcp_conn_free+0x2c/0x170 net/rds/tcp.c:361
 __rds_conn_create+0x1bfb/0x22d0 net/rds/connection.c:334
 rds_conn_create_outgoing+0x43/0x60 net/rds/connection.c:377
 rds_sendmsg+0xff5/0x2150 net/rds/send.c:1321
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x4d7/0x810 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5b6bf9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5b6cd8b028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f5b6c216090 RCX: 00007f5b6bf9acb9
RDX: 0000000000000000 RSI: 0000200000000480 RDI: 0000000000000004
RBP: 00007f5b6c008bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5b6c216128 R14: 00007f5b6c216090 R15: 00007ffc17760058
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[achender@kernel.org allison.henderson@oracle.com edumazet@google.com horms@kernel.org kuba@kernel.org linux-kselftest@vger.kernel.org linux-rdma@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com rds-devel@oss.oracle.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

