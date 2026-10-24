Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792862289;
	b=Gx9k6iOx0sBc7j809VtTT1TKw2H/u2k7iMhBwpEfco1D968Op+c2WAnaMxPFFhZxquTG
	 pUviyqzJ2W1zk0nfld9J8gliqJX6ALp7ac6rhtgeaH3XyrDUSAKYHs0tUwc3Q8z9uPO60
	 XV2L+yw3LitRv9wECVNLyBf/TVmYH7tLoh52RQDaAuVmpQZQApgcm1c9mmaysA3QJ8An9
	 Y4w86u036AWdfYQMOPUhGynKs9xqW0kUsWo2KSk2hdfVSRsYuxGyZ6PBVsdy62j5MA+gE
	 Uo7x6bRZ1ztr2J9aU3lZfsuJp2jAcvSFqShXgsyrO0vuZ7Is7l+dnPRPqv91vIO4FMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792862289;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=x2VefjjoeNiNoDbqnOX3ai1zbfJDTfzptX9m6LwRkuE=;
	b=18xL9rMaJjt+vmcjae+FnIfp7AsqI6WmylC8dtB9Kqwj2DMOPyJGOEAN6+dn5OAtqwdw
	 WwfyeKUPBTsPGLjrmCMrhkRRz1iEig1VfMVDemgOoozIEsTPHwDfaftEkgQZ5SLKlRI8h
	 OiTbVCXwNtfLNMamRwb9CObGs3iPp59fLLTCKCVP8PVFrFIqAfja0+T3DzI5iIbN64NJC
	 LKztxkLZlmrtjjnYI9I3VC7tC2CL6Zu1JrYEgNHqZ9rmwJt6dgjGbM79bmQhCzZujt/Yr
	 qXApWRelgNPOUV7IDYZDqUlC0Mbm/YADFFrXwRMaYayproxlFbD9ZAVeVbo+1KRF6oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6E0606A326
	for <syzbot@lists.linux.dev>; Sat, 24 Oct 2026 17:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D6E0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c307941971so2367906b6e.1
        for <syzbot@lists.linux.dev>; Sat, 24 Oct 2026 10:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792862288; x=1793467088;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=x2VefjjoeNiNoDbqnOX3ai1zbfJDTfzptX9m6LwRkuE=;
        b=AnXC9mPHbStjBywAV2tCRLVPUYUpg6mgyZ5fVPlQB6ZTwsHVGXzcPR7pRWgMSWUlqZ
         XK3V0iGxwj5yRexjvJOsvOBoMgS22uHtG6GuynHjgLwgDeurcIKCC9oEZggGueT7+AQ3
         ow/ZdbxijK9XSmFweu0WYBsIbsoW7tpeXGLPFkW/wLUn8AuPVjF05BFi0dBs/+N6r+W6
         VWCiqwhyzykyOlKcBCmWXASu8UZfUAq1vjL9oxmnnBn1DgljnVYErvhPCU0chAetnn9k
         2Ss4wJq0HKDfqTEKd7fQFIJ8k6ZeF3kZiHYzq89FSJ665fFROp131sxOohWT0sES/qj0
         JwlA==
X-Gm-Message-State: AFq9FYLoFgFHIV1ZdJe5iYL8G+HPhDaTFwswpxUsnizOc4ceIACj45ZV
	7sypV9yb3Ynq5oFeAJP/HR3nwGqnaeYp0QfiWentQx8cK/WNyVKCDL1tergIbefMshtosr9pPUd
	RzFIdQsfYLCjGepLRJwR9Xw3GjNrzS+q4Ab7B9ojpVFjT8fd/XC6ErJieDRk=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:8319:b0:55c:8df:61f3 with SMTP id
 5614622812f47-55c08df722emr759248b6e.67.1792862288483; Sat, 24 Oct 2026
 10:18:08 -0700 (PDT)
Date: Sat, 24 Oct 2026 10:18:08 -0700
In-Reply-To: <20261023191517.607834-1-kuniyu@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adce850.a26421ad.3bb4f4.0011.GAE@google.com>
Subject: [syzbot ci] Re: ipv6: Protect multiple routes insertion by table lock.
From: syzbot ci <syzbot+ci1c0f05215dd3ab6b@syzkaller.appspotmail.com>
To: davem@davemloft.net, dsahern@kernel.org, edumazet@kernel.org, 
	horms@kernel.org, idosch@nvidia.com, kuba@kernel.org, kuni1840@gmail.com, 
	kuniyu@google.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzbot@syzkaller.appspotmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
