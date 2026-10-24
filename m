Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792846282;
	b=LdHd77Oq+3seLB+oEplTg2vc+s5T8NEEmez+hytuV4xEmpzKESuq7OVDUHEUlbmPKA1v
	 ECLysofYZ5zGHKcjIweDN6mk78AL6YtDseEnZwB5HN0uqoL89IWxNC1fuKpQtLGWIGK/m
	 8owDmFLje1san6+8M6d0kbHylA+PO8bb3NMfQcS4CnGf0fvDZnPWLZf7PZwmMrKb4s/M7
	 gx5puUL1DpNzFT2tehG7NDGyxLxfPo0dwd4jfXK6tMuewhdo608sYIwJ2B3w8SJ2zQOvH
	 bpp5qLG34MaI2Py91LA6h1U9nxrEDE7X13wxkDQiuzLChB3tE0z55HSXNZsr1U3aL7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792846282;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=AT/Rq6CNJMpop9+LVmJC467HqUI6B1NeLGZhljX4elE=;
	b=5X98pXAdPBuUiYiMcUGWCEq9DR9Hw/j9wV2wUGWt4Nxso5K/QZMI1yDgG4SWJX8Tcddg
	 MyKe+Swv7nm1x2MY2f3rCpjWCRKMMfs+iYBghSpQituYaJz4OC/yVTZCagM9K68y6/aMp
	 kz+QhL8taj0h1qzbEZ2uxWmZOGerLznpEfFTmjZ9I2vxtPv1f9HVZkmjow8c4UDD0Aeaf
	 +KLNJGI/2k1xveFU+lJuJHuXeoeSG/9BPUUZTi1P/dWX1+2iUI3pfXff+qL3qWR1QZDuO
	 JFWcOyRtDgtR/dr8JgMg/t0wI6px2tCHoYjR+a+RwcDAm1iXnFGt6NVmPB43qtg+cxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5562606A31A
	for <syzbot@lists.linux.dev>; Sat, 24 Oct 2026 12:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5562606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b597558c4cso2683298b6e.1
        for <syzbot@lists.linux.dev>; Sat, 24 Oct 2026 05:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792846281; x=1793451081;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AT/Rq6CNJMpop9+LVmJC467HqUI6B1NeLGZhljX4elE=;
        b=gshhPGuPTyqYim+1UGRs9CMsdZZa2WZyiovVdFTRwxAHzDkfyiTRPV73iVeOxLF3qG
         z7T7J2hrJs0jMM2p3g7uuzhhgy3634jbSLYtV0lGZes4N5zZClTx59in8sGEaWoUOnGf
         3iSCdbqAGoy1UnHFkE/JE20EyrYIepvY88U1EwKR+ykqbqC/wW1dHA1fDAzZeTiT3AtY
         /+kFehljtO03Bbv4kDNyMwkV8hULeV20WPdjUiz5zzlKZpQcrKC5gOMyrSROwnes+EM+
         8PxRRXUBMEoi5ZGVBB4kNUVvmi2Mv6l474VlXsPy14Ss9T3hoYCdzaIsawKLUIxaIlhu
         SRuA==
X-Gm-Message-State: AFq9FYI+o7lRLuYP6lFt92qmer6ehfJz2cVxUes8Vrv0boOcACnVYP8g
	7k3G2iF/6hD0qzzBp/imCdOWiGuEY5UDVmSSmtzFK1Uejp3JASfcOK6/b7yTYblusla8Gpx9XIu
	ur+gNyBEE0Aw7mgkaH0Q96iOWfRqoMI7VqaNUYkW/y21t8OMEbQq7N8l6c9Y=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1984:b0:4f5:6fff:3ac4 with SMTP id
 5614622812f47-55c002e9626mr1342452b6e.41.1792846280895; Sat, 24 Oct 2026
 05:51:20 -0700 (PDT)
Date: Sat, 24 Oct 2026 05:51:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adca9c8.998fdb85.f0000.000f.GAE@google.com>
Subject: [moderation/CI] Re: ipv6: Protect multiple routes insertion by table lock.
From: syzbot ci <syzbot+ci8f91d74e670176f2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ipv6: Protect multiple routes insertion by table lock.
https://lore.kernel.org/all/20261023191517.607834-1-kuniyu@google.com
* [PATCH v1 net] ipv6: Protect multiple routes insertion by table lock.

and found the following issue:
WARNING: suspicious RCU usage in rt6_multipath_rebalance

Full report is available here:
https://ci.syzbot.org/series/7d878fa2-f84a-4468-85e2-c2a5e263aeff

***

WARNING: suspicious RCU usage in rt6_multipath_rebalance

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      7076f684d5132e6a6145e1da2fa74771ecd052e5
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/bbb3053f-f23f-4fe3-a9e9-85396428119d/config
AI triage: https://ci.syzbot.org/findings/64360b2e-48dc-4b55-b253-6a517535ecb7/triage_trajectory

IPv6: RTM_NEWROUTE with no NLM_F_CREATE or NLM_F_REPLACE
IPv6: NLM_F_CREATE should be set when creating new route
=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/net/addrconf.h:351 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
locks held by syz.2.3386/18922: 1, last CPU#0:
 #0: ffff888177df3430 (&tb->tb6_lock){+...}-{3:3}, at: inet6_rtm_newroute+0x3dc/0x1ab0

stack backtrace:
CPU: 0 UID: 0 PID: 18922 Comm: syz.2.3386 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 lockdep_rcu_suspicious+0x140/0x1d0
 rt6_multipath_rebalance+0xf11/0x1080
 fib6_del+0xada/0x15a0
 inet6_rtm_newroute+0x15b5/0x1ab0
 rtnetlink_rcv_msg+0x802/0xc00
 netlink_rcv_skb+0x226/0x4a0
 netlink_unicast+0x8ef/0xa80
 netlink_sendmsg+0x7f0/0xb20
 sock_sendmsg_nosec+0x14e/0x190
 ____sys_sendmsg+0x54e/0x850
 ___sys_sendmsg+0x2a5/0x360
 __sys_sendmmsg+0x273/0x4e0
 __x64_sys_sendmmsg+0xa0/0xc0
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa77459f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa775488028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007fa774826090 RCX: 00007fa77459f559
RDX: 040000000000009f RSI: 00002000000002c0 RDI: 000000000000000b
RBP: 00007fa774636b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa774826128 R14: 00007fa774826090 R15: 00007fffd26b46d8
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
[davem@davemloft.net dsahern@kernel.org edumazet@kernel.org horms@kernel.org idosch@nvidia.com kuba@kernel.org kuni1840@gmail.com kuniyu@google.com netdev@vger.kernel.org pabeni@redhat.com syzbot@syzkaller.appspotmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

