Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7697A24E4A8
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 01:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778549732; cv=none; b=q85FQKkoxajyfqnP5TZDeSRaHm+3h+8RMPGFh+/uRBYAHrLKxJ4MHZsjkkz9X3LXhwzYInFVdPItnwAF5AWICs/fR5POLZk5FH+fcCMIU/xG7tWoQ2aQtjz1w/4x+C+4I7RNjQA9gXyHQmivzNls3a0pUuVzQHslf8ZwO77NvIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778549732; c=relaxed/simple;
	bh=S5CiyDXWf6X5z61rNOKGDeWtbE5lUyS7kIq6IyWVFIk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=rDWs4+NRz8CtsuUD0+JekHz34m9F/wvbEEIhquc9OyTzYFCcg0BzWg2kIHBhN8QSBhtHzuozAcZfZQzsK1PGvArZtgawJlCzH6TEA+EthhbguWnQsSzcM8h0EptJU4p4gxGzvGTIzrBabL/zkeRz4mLcU0QulxIeXuqgfqCQI80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-479d900d222so8149100b6e.2
        for <syzbot@lists.linux.dev>; Mon, 11 May 2026 18:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778549729; x=1779154529;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A4SjzNrrjzKDz4a8nXRuztpUXLLVt03rHC9YlHXRN4c=;
        b=Km/VLbVjEz/tmNpdeoM0zNW2MtFzJcyys9+vfHDxC8LRf4srfMVjYRCtsD6kxG2JKh
         tCBi9YNDYak408zCXVkne+w5Bjcu695hOew/khM470PJdtGBS/bBE/UxP8NlBBAmb4k4
         IhKTsBNwvEMC9UwvsBwqKEykGJBEWwJLUAdu6xoj58j43Bp7q/U+9r1aBL9B3WSvbO11
         PVmQKfYulvJ4ZOu25vxWCm/StASE2CnQErCaiiPxqluIz6E1XL5dbz4+9oO6IOqvqq57
         yVgz+z8Br0rbiIMJkDMyS1xNn4jNbsuoG0DO2ZWiEfILtoZeyND6uE1bk4t5rOMNI9K+
         zoFg==
X-Gm-Message-State: AOJu0YxrYfT9ZbUThtRmO/UfSx3j90CIaz3BY9leTvftfruEJtKvJ1r3
	tBVYZNxcf5jb48lLy0iYd9IYNLY+IrL71E1hlk6vVoPs5SmWKLTZOzTK2/f3oVU+2LlKRg16pF0
	hPycxmqnQAtAR5/+4g9k+6lYC7Y3yxVDSl1P8FxA9O9a/HltEein3YsLYDHE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:80f:b0:694:95cb:4367 with SMTP id
 006d021491bc7-69b69efab01mr519037eaf.47.1778549729241; Mon, 11 May 2026
 18:35:29 -0700 (PDT)
Date: Mon, 11 May 2026 18:35:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0283e1.170a0220.7f9b3.0007.GAE@google.com>
Subject: [moderation/CI] Re: tcp: fix stale per-CPU tcp_tw_isn leak enabling
 ISN prediction
From: syzbot ci <syzbot+ciee63f726d92f39f7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] tcp: fix stale per-CPU tcp_tw_isn leak enabling ISN prediction
https://lore.kernel.org/all/20260511151559.1916614-1-edumazet@google.com
* [PATCH net] tcp: fix stale per-CPU tcp_tw_isn leak enabling ISN prediction

and found the following issues:
* BUG: using __this_cpu_write() in preemptible code in tcp_v4_do_rcv
* BUG: using __this_cpu_write() in preemptible code in tcp_v6_do_rcv

Full report is available here:
https://ci.syzbot.org/series/45073ca6-4b5b-4cbd-83bf-ae30c470d334

***

BUG: using __this_cpu_write() in preemptible code in tcp_v4_do_rcv

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      a450063ef86b9967234ca1f896c0d77400c74f11
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d6bfac50-400c-447d-b4f2-f5caa36c16ac/config
syz repro: https://ci.syzbot.org/findings/95b64202-6cf3-4356-94bc-753dbd8443c4/syz_repro

BUG: using __this_cpu_write() in preemptible [00000000] code: syz.0.17/5875
caller is tcp_v4_do_rcv+0xb4a/0x13e0 net/ipv4/tcp_ipv4.c:1881
CPU: 0 UID: 0 PID: 5875 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
 tcp_v4_do_rcv+0xb4a/0x13e0 net/ipv4/tcp_ipv4.c:1881
 sk_backlog_rcv include/net/sock.h:1190 [inline]
 __release_sock+0x265/0x3a0 net/core/sock.c:3216
 release_sock+0x190/0x260 net/core/sock.c:3815
 mptcp_pm_rm_addr_or_subflow+0x472/0x9d0 net/mptcp/pm.c:789
 mptcp_nl_remove_id_zero_address net/mptcp/pm_kernel.c:1140 [inline]
 mptcp_pm_nl_del_addr_doit+0x503/0x1430 net/mptcp/pm_kernel.c:1176
 genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6847f9cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6848e95028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6848215fa0 RCX: 00007f6847f9cdd9
RDX: 0000000024000800 RSI: 0000200000000140 RDI: 0000000000000004
RBP: 00007f6848032d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6848216038 R14: 00007f6848215fa0 R15: 00007ffe50763178
 </TASK>


***

BUG: using __this_cpu_write() in preemptible code in tcp_v6_do_rcv

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      a450063ef86b9967234ca1f896c0d77400c74f11
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d6bfac50-400c-447d-b4f2-f5caa36c16ac/config
syz repro: https://ci.syzbot.org/findings/f5960777-902c-46ad-b811-9dff0f17d320/syz_repro

BUG: using __this_cpu_write() in preemptible [00000000] code: syz.0.173/6173
caller is tcp_v6_do_rcv+0x10c2/0x1ca0 net/ipv6/tcp_ipv6.c:1644
CPU: 0 UID: 0 PID: 6173 Comm: syz.0.173 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
 tcp_v6_do_rcv+0x10c2/0x1ca0 net/ipv6/tcp_ipv6.c:1644
 sk_backlog_rcv include/net/sock.h:1190 [inline]
 __release_sock+0x1b8/0x3a0 net/core/sock.c:3216
 __tcp_close+0x832/0xfe0 net/ipv4/tcp.c:3238
 __mptcp_close_ssk+0x52d/0x1180 net/mptcp/protocol.c:2604
 mptcp_destroy_common+0x15c/0x330 net/mptcp/protocol.c:3408
 mptcp_destroy+0x82/0x120 net/mptcp/protocol.c:3616
 __mptcp_destroy_sock+0x156/0x370 net/mptcp/protocol.c:3250
 __mptcp_close+0x8f6/0xd10 net/mptcp/protocol.c:3352
 mptcp_close+0x28/0x1a0 net/mptcp/protocol.c:3367
 inet_release+0x143/0x190 net/ipv4/af_inet.c:442
 __sock_release net/socket.c:722 [inline]
 sock_close+0xc3/0x240 net/socket.c:1514
 __fput+0x44f/0xa60 fs/file_table.c:510
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f69be79cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc7668ad18 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007ffc7668ae00 RCX: 00007f69be79cdd9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000012dd1 R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b32b20000 R11: 0000000000000246 R12: 00007ffc7668ae40
R13: 00007f69bea15fac R14: 0000000000012e0a R15: 00007f69bea15fa0
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
[davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@kernel.org kuba@kernel.org kuniyu@google.com ncardwell@google.com netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

