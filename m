Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E4B28641F
	for <syzbot@lists.linux.dev>; Wed,  7 Jan 2026 07:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767770983; cv=none; b=Pyu3n+aqPpvtzzJG/5Jz5azUswCdLyCVcYiHgFOPiLhx9x5T6R4iC3iYZD1ihf6yh2tISJ+63RIiQf/l2O0l7j+cse6ppeFo0pHDxPoePjU3yWm2g+sz8bNISOhw9XA5uEkVqqSkfprDERGLudmRLalSeRygamjCZl4ddKQTSKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767770983; c=relaxed/simple;
	bh=GJkxCE6w3KPklk8iFvgegRwUzCMBjTJPCQu7m3NHEeE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=L5dQBlzaWUP1eUNThqG4/50PuPgRQMkEL8bX/AxWxQTIyg12Um5u5+IHRBEDqgrckg+ujBgvCKF3/GefEv7hj21Iz3iocVrEbjb1kbj47bCDBE0gENRju8BcBWlNJ9m3Vs7INIRbLI88x4fWTlKKUKQgnYtviVbBw3FvQ2RjcpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-65f30d38617so3227606eaf.1
        for <syzbot@lists.linux.dev>; Tue, 06 Jan 2026 23:29:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767770981; x=1768375781;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MoybaKXdj283M2AxUCCehLSLuVC7znL/PT0tESBuOEc=;
        b=k51TRn40DdCyYWJJ7TDFDMKaveH6NTm/5Gwr/4d+miTMtlYbFbHXKs35a9AaQ6Gmz5
         G1ftdT/T3FtT8AWZzr0OdeqqhuhrW9LGl7aXeqtguWICM7G3CI8qDTUoeZ8snNyuHMgy
         XWU1Tz9tewB/8yHfk7+wmsRmoHCc2o1vaxPuRf1g9Y+TrUsZSYxSGQL3OdQK/sejAnuz
         EnUfa8wzq3YXlMUXceHE4aPIhVBfgcNlHTqa9RYsOFAdK+JuATlh1HkzK+1/lIfgEPMx
         b8zNIDemGUPLkeAnrt9XzErHlvxGSuWBYFfrwaH6gkVXJV8PCyj8wUk4dkSqkiWsFNTn
         cmdA==
X-Gm-Message-State: AOJu0YyaW+a0RgFJCh23ACs3HXL9SAGbOhxe4PTrZaBRYzKinh8CGonN
	TD5KFMmzWqRtc5abmc2Jjau5CW0ue1lwycD0zv0QJBZBcMRrFDnPYVTlqSr1CbR9NICxkrFY2Rd
	xpN9Pyl+NkqBvERettRQ/wR3hOZyI9BGLZy3m3oKT//j7U6R2RpHmZ1g8/n0=
X-Google-Smtp-Source: AGHT+IFqMQVuMCLxQnYmm3zrWq/rFPMsuGHkTW8gwAwJXGgXzD5v6VG/qOtR8daXJAoQp0CT0MXl/N8gwmCqLVVcKlod+u+L6H7J
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:dd0b:0:b0:654:18f9:10f4 with SMTP id
 006d021491bc7-65f54e4e232mr512495eaf.0.1767770981262; Tue, 06 Jan 2026
 23:29:41 -0800 (PST)
Date: Tue, 06 Jan 2026 23:29:41 -0800
In-Reply-To: <20260106164338.1738035-1-edumazet@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695e0b65.050a0220.1c677c.0359.GAE@google.com>
Subject: [syzbot ci] Re: net: update netdev_lock_{type,name}
From: syzbot ci <syzbot+ci84807814270b24b7@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, eric.dumazet@gmail.com, 
	horms@kernel.org, kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: update netdev_lock_{type,name}
https://lore.kernel.org/all/20260106164338.1738035-1-edumazet@google.com
* [PATCH net] net: update netdev_lock_{type,name}

and found the following issue:
WARNING in netdev_init_one_queue

Full report is available here:
https://ci.syzbot.org/series/68d4719e-5ae3-402a-a73d-99450d0774b4

***

WARNING in netdev_init_one_queue

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      1806d210e5a8f431ad4711766ae4a333d407d972
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/1c4d3398-ae52-417f-943e-84be818a07a6/config

------------[ cut here ]------------
netdev_lock_pos() could not find dev_type=824
WARNING: net/core/dev.c:527 at netdev_init_one_queue+0x1c5/0x440, CPU#1: syz-executor/6079
Modules linked in:
CPU: 1 UID: 0 PID: 6079 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:netdev_init_one_queue+0x1c7/0x440
Code: bf 3f 00 00 00 e8 b9 14 74 f8 66 41 83 ff 3e 0f 87 59 01 00 00 e8 09 11 74 f8 eb 19 e8 02 11 74 f8 48 8d 3d 3b 32 82 06 89 ee <67> 48 0f b9 3a 41 bf 3e 00 00 00 4e 8d 24 fd e0 1f 90 8c 4c 89 e0
RSP: 0018:ffffc90005487020 EFLAGS: 00010293
RAX: ffffffff894e61fe RBX: ffff88816c381000 RCX: ffff8881047257c0
RDX: 0000000000000000 RSI: 0000000000000338 RDI: ffffffff8fd09440
RBP: 0000000000000338 R08: 0000000000000003 R09: 0000000000000000
R10: 0000000000000010 R11: ffffffff81ae36b0 R12: 000000000000fffe
R13: dffffc0000000000 R14: 000000000000003e R15: ffffffff8c9022d8
FS:  0000555586066500(0000) GS:ffff8882a9a0f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555586079888 CR3: 000000011929a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 alloc_netdev_mqs+0x937/0x11b0
 rtnl_create_link+0x31f/0xd70
 rtnl_newlink_create+0x277/0xb70
 rtnl_newlink+0x1666/0x1be0
 rtnetlink_rcv_msg+0x7d5/0xbe0
 netlink_rcv_skb+0x232/0x4b0
 netlink_unicast+0x80f/0x9b0
 netlink_sendmsg+0x813/0xb40
 __sock_sendmsg+0x21c/0x270
 __sys_sendto+0x3c0/0x550
 __x64_sys_sendto+0xde/0x100
 do_syscall_64+0xe2/0xf80
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcc51555ed7
Code: 48 89 fa 4c 89 df e8 a8 56 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
RSP: 002b:00007ffe07b19fa0 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000555586066500 RCX: 00007fcc51555ed7
RDX: 000000000000004c RSI: 00007fcc52334670 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00007ffe07b1a004 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
R13: 0000000000000000 R14: 00007fcc52334670 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
