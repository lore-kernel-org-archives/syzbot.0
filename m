Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E8A3148C9
	for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 08:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776672761; cv=none; b=AOzEhvdCIjbNAXkz7J/ECJ1eiDXOgyIQiXQeVKOGhUA5eybYm6wUp6tkzVlL+Zas8Mw3VzvzN0eGHZDCbhr9/U44nG7mzW6So72dmA7hNH3qCt8Gqnmz73XB1zHdMUFOEpOqc3ar2hR+J0MurxiUKkhC+Sl9aigrkJ633oXrK4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776672761; c=relaxed/simple;
	bh=GQTy+ZBSq9aEMmo6nMHZ4n4nx2xyjOOsbDMz7J6AKBk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=aNnbXTEZeHsPgTL/RQdc4808H08BHTG3VLSXCiOig5wYZptMabbBWvPdsjQWKwCFClQL3kR0JXjs4pWFc47moyvqJQDygbUAD7vaoja78z9iY1z0oI/UIifrZhTYGXilfX+dUydv+oQi8iafrNmA8ml5Rp3NjhuNy1R/WtDVkuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-688c232dd72so3429340eaf.1
        for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 01:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776672758; x=1777277558;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QrnYfIYXXYam0VZDYj4/7kC54JxgeVUDla9fg6DopKQ=;
        b=TZnSpVT7svfYirvHgFVLeGSy6Eyn07mM3x1d+X02lbmMQmR9FqaiKU9R+oeJLVgnjf
         XZ3y+12tBPe8fe6Nl1yWc9mg+BDdx6e8eIQ73I8KsrX8CuD6D3ZuEyhpsx9m4EitdPbl
         FBsTSxjahDTw+9ryQJC0rnV1huC+3irEz/ZoJX1RlSUycfz8foW5g99pgs2PXDNMdpHI
         jr3HWyR8dh/yDHUUC28Y7p+aafV+7FyUCNfApn7wiyO7iqgXY4UX2naJO8b4jq3xALSO
         9prU6WTiYJdbb6u3PWnSNd/ZiU2SrozsDb3nS8myjH0KH+vhQY0JVNtc3KxfjjASdAQX
         ntOg==
X-Gm-Message-State: AOJu0Yx0AnA7Sj5X6MELDbSyjQkbBmENl6wMfoLlRhVA82MESbCwdy3S
	ocCtPRam7Sxje0F0JFMDGlAHD/eO8ZDRQW+0qfJCGHjYgS51kH8mA1YtjCnYu780NT+qWH9+djQ
	57yDd812YPW8/+2WfagM7R+3LX9ydgQn5yW+uZ9S6NpbyFLtNc0nDVSItXWo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8c3:b0:692:ef5b:ad46 with SMTP id
 006d021491bc7-69462e20417mr6110472eaf.1.1776672758742; Mon, 20 Apr 2026
 01:12:38 -0700 (PDT)
Date: Mon, 20 Apr 2026 01:12:38 -0700
In-Reply-To: <6112cce99b4e3571444a616d0fb19e91e2fcca72.1776597598.git.caoruide123@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e5dff6.a00a0220.9259.0001.GAE@google.com>
Subject: [syzbot ci] Re: net: nsh: handle nested NSH headers during GSO
From: syzbot ci <syzbot+ci38a89a871d631008@syzkaller.appspotmail.com>
To: bird@lzu.edu.cn, caoruide123@gmail.com, davem@davemloft.net, 
	edumazet@google.com, horms@kernel.org, jbenc@redhat.com, kuba@kernel.org, 
	lx24@stu.ynu.edu.cn, n05ec@lzu.edu.cn, netdev@vger.kernel.org, 
	pabeni@redhat.com, tomapufckgml@gmail.com, yifanwucs@gmail.com, 
	yuantan098@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: nsh: handle nested NSH headers during GSO
https://lore.kernel.org/all/6112cce99b4e3571444a616d0fb19e91e2fcca72.1776597598.git.caoruide123@gmail.com
* [PATCH net 1/1] net: nsh: handle nested NSH headers during GSO

and found the following issue:
WARNING in nsh_gso_segment

Full report is available here:
https://ci.syzbot.org/series/13f77bac-014d-4059-9187-fbdbcb6a6540

***

WARNING in nsh_gso_segment

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      0cf004ffb61cd32d140531c3a84afe975f9fc7ea
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/193058cd-cd88-4bb0-a6e6-b43b6179fcd9/config
syz repro: https://ci.syzbot.org/findings/446db72d-a630-471c-b369-2ef1f7b3b6ed/syz_repro

------------[ cut here ]------------
offset != (typeof(skb->mac_header))offset
WARNING: ./include/linux/skbuff.h:3173 at skb_reset_mac_header include/linux/skbuff.h:3173 [inline], CPU#1: syz.1.20/5978
WARNING: ./include/linux/skbuff.h:3173 at nsh_gso_segment+0x833/0x12d0 net/nsh/nsh.c:107, CPU#1: syz.1.20/5978
Modules linked in:
CPU: 1 UID: 0 PID: 5978 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:skb_reset_mac_header include/linux/skbuff.h:3173 [inline]
RIP: 0010:nsh_gso_segment+0x833/0x12d0 net/nsh/nsh.c:107
Code: 2f 08 00 00 48 8b 7c 24 60 44 89 f6 e8 46 83 e4 fd 48 85 c0 0f 84 20 08 00 00 e8 48 af 31 f6 e9 ab fb ff ff e8 3e af 31 f6 90 <0f> 0b 90 e9 43 fd ff ff e8 30 af 31 f6 90 0f 0b 90 e9 39 fe ff ff
RSP: 0018:ffffc90004847220 EFLAGS: 00010293
RAX: ffffffff8b93aeb2 RBX: ffff88817362a6d8 RCX: ffff88810f088000
RDX: 0000000000000000 RSI: 0000000000010040 RDI: 0000000000010000
RBP: ffffc90004847390 R08: ffff88810f088000 R09: 0000000000000005
R10: 0000000000000005 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000010040 R14: dffffc0000000000 R15: 0000000000000074
FS:  00007f28e9ed36c0(0000) GS:ffff8882a9245000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000010000 CR3: 0000000170f06000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 skb_mac_gso_segment+0x31c/0x690 net/core/gso.c:53
 __skb_gso_segment+0x376/0x540 net/core/gso.c:124
 skb_gso_segment include/net/gso.h:83 [inline]
 validate_xmit_skb+0xa21/0x14a0 net/core/dev.c:4039
 validate_xmit_skb_list+0x84/0x120 net/core/dev.c:4089
 sch_direct_xmit+0xdf/0x4c0 net/sched/sch_generic.c:357
 __dev_xmit_skb net/core/dev.c:4209 [inline]
 __dev_queue_xmit+0x180f/0x3950 net/core/dev.c:4831
 packet_snd net/packet/af_packet.c:3077 [inline]
 packet_sendmsg+0x3ebc/0x50f0 net/packet/af_packet.c:3109
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 __sys_sendto+0x672/0x710 net/socket.c:2265
 __do_sys_sendto net/socket.c:2272 [inline]
 __se_sys_sendto net/socket.c:2268 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2268
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f28e8f9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f28e9ed3028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f28e9216090 RCX: 00007f28e8f9c819
RDX: 00000000000100a6 RSI: 0000200000000180 RDI: 0000000000000005
RBP: 00007f28e9032c91 R08: 0000200000000140 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f28e9216128 R14: 00007f28e9216090 R15: 00007ffd50249d78
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
