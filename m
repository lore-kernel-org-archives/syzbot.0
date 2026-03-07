Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B1F21CFE0
	for <syzbot@lists.linux.dev>; Sat,  7 Mar 2026 10:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772880445; cv=none; b=iDwQh996ZwLsfJWSbBX/fVvs0Urz8J07DF1m8aOjIDpC4lWMnEF4tLCqMNMrgVc3i+0JZ7socomXX8fr8Y08rmeCW03BkuvEF8XDQ5OJiBP74FgNSHX4FYapOQevBINAxnwPRPNDgGvuozUbE8RIadeU2B/WcC/o2ugR8wRtxdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772880445; c=relaxed/simple;
	bh=K4ffkJbMXInzvBaHX9qo2FwA1FafdqBCxRPA75MB7OI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=hBXjDwxTd4Kc/vBsx5gYdO8XVjDK3klcBJAzTJh89vC6ZE/ZhOWLaXGXP3qrUgSFRHBZibJ86/qatFL+Ryy+Ohji6Rr2W5pfFQ60vhHULzUVpaZuyLG1uGpUusxODycbSCOrTQuzFaNhC5S1ZI9ifJu9FOc/L6Zib3xjvje38TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679a409a175so155428950eaf.1
        for <syzbot@lists.linux.dev>; Sat, 07 Mar 2026 02:47:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772880443; x=1773485243;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Edj3qQyTek1VJd7lpkiJTUVWZcbBGahddcfhFHRjIjE=;
        b=MrmrMN8AGqi13jm1LyfaHgOmOAvRStdln8fdBTmMcPwXXj0RR7aQ84MWEgDAC8PQ7W
         3I/xYUbGP7+9Ic1O/7ibjgATMZjndX2rYoxhDQ+qYTNVYzEi+nyBjPIIfoXKHeoK0Nwx
         lmrYK30YvH5XmucAUtNV8VZpYRLcuIp1rTYOts8JR12U1XpbE2ckxe4ZM7+ybA3zj7GY
         eCmsHtDiHdMSGUoHqnRUtAfzH+h+6yVdPRq3P4qBcekvwU1A+DyKEKfJxFW7ZQC9SF5I
         KQ5OaWswyHeemHUK6RkYqPwYAajc4Rgz4IgKNOKiKDB8uJbiyKKpQcistbONibE+MdEZ
         u3aw==
X-Gm-Message-State: AOJu0YwYT/gDEB8/FVLUpkEJJCVdWWmzmz55fXWxuKIwsQTywQGqtiYH
	jwpF3j6y6P3vANonC8E2i98PULA84cs+ax8CFNjO70nf6/CvqfySAo9u/0C1fiq5ff1r6EekBFm
	fzd+zExaxK7cLfnnGGohPQI+bSijeGCiuWMugVFTtUx+irNSTKakaa0NgVUM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:982:b0:67a:2305:5e60 with SMTP id
 006d021491bc7-67b9bd1b0b8mr3186972eaf.47.1772880443491; Sat, 07 Mar 2026
 02:47:23 -0800 (PST)
Date: Sat, 07 Mar 2026 02:47:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ac023b.050a0220.13f275.004b.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: nft_set_rbtree: allocate same array
 size on updates
From: syzbot ci <syzbot+ci191df84c04eabe72@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: nft_set_rbtree: allocate same array size on updates
https://lore.kernel.org/all/20260306123649.2878676-1-pablo@netfilter.org
* [PATCH nf] netfilter: nft_set_rbtree: allocate same array size on updates

and found the following issue:
general protection fault in nft_array_may_resize

Full report is available here:
https://ci.syzbot.org/series/63a7af7e-7e81-40b3-ac44-4a537af34cdf

***

general protection fault in nft_array_may_resize

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      488f6400e447d446ff4d5daef6988f3403dd948d
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7f67fa0a-1740-40ec-b191-899f77dd02ce/config
C repro:   https://ci.syzbot.org/findings/c4666971-4767-49ca-b29d-854930c3aace/c_repro
syz repro: https://ci.syzbot.org/findings/c4666971-4767-49ca-b29d-854930c3aace/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5957 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:nft_array_may_resize+0x17f/0x3d0 net/netfilter/nft_set_rbtree.c:649
Code: 00 00 00 49 81 c7 38 01 00 00 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 1b de 4f f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 e3 01 00 00 41 8b 2f 48 c7 c0 a8 c2 1a
RSP: 0018:ffffc9000591ecc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff88816dced700 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff8881012f8473 R09: 1ffff1102025f08e
R10: dffffc0000000000 R11: ffffed102025f08f R12: ffff8881012f8540
R13: dffffc0000000000 R14: 1ffff1102025f0a8 R15: 0000000000000000
FS:  000055557f50a500(0000) GS:ffff88818de64000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000009b40 CR3: 000000016f370000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 nft_rbtree_insert+0x161/0x2c00 net/netfilter/nft_set_rbtree.c:678
 nft_add_set_elem net/netfilter/nf_tables_api.c:7486 [inline]
 nf_tables_newsetelem+0x2a17/0x4450 net/netfilter/nf_tables_api.c:7618
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:526 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
 nfnetlink_rcv+0x1240/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdff099c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff596fb518 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fdff0c15fa0 RCX: 00007fdff099c799
RDX: 0000000000000040 RSI: 0000200000009b40 RDI: 0000000000000003
RBP: 00007fdff0a32bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fdff0c15fac R14: 00007fdff0c15fa0 R15: 00007fdff0c15fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nft_array_may_resize+0x17f/0x3d0 net/netfilter/nft_set_rbtree.c:649
Code: 00 00 00 49 81 c7 38 01 00 00 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 ff e8 1b de 4f f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 28 84 c0 0f 85 e3 01 00 00 41 8b 2f 48 c7 c0 a8 c2 1a
RSP: 0018:ffffc9000591ecc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
RDX: ffff88816dced700 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff8881012f8473 R09: 1ffff1102025f08e
R10: dffffc0000000000 R11: ffffed102025f08f R12: ffff8881012f8540
R13: dffffc0000000000 R14: 1ffff1102025f0a8 R15: 0000000000000000
FS:  000055557f50a500(0000) GS:ffff88818de64000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000009b40 CR3: 000000016f370000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	49 81 c7 38 01 00 00 	add    $0x138,%r15
   9:	4c 89 f8             	mov    %r15,%rax
   c:	48 c1 e8 03          	shr    $0x3,%rax
  10:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
  15:	74 08                	je     0x1f
  17:	4c 89 ff             	mov    %r15,%rdi
  1a:	e8 1b de 4f f8       	call   0xf84fde3a
  1f:	4d 8b 3f             	mov    (%r15),%r15
  22:	4c 89 f8             	mov    %r15,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 e3 01 00 00    	jne    0x219
  36:	41 8b 2f             	mov    (%r15),%ebp
  39:	48                   	rex.W
  3a:	c7                   	.byte 0xc7
  3b:	c0                   	.byte 0xc0
  3c:	a8 c2                	test   $0xc2,%al
  3e:	1a                   	.byte 0x1a


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[fw@strlen.de netfilter-devel@vger.kernel.org pablo@netfilter.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

