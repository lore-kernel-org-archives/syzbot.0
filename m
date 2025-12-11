Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA98D3148DA
	for <syzbot@lists.linux.dev>; Thu, 11 Dec 2025 16:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765471363; cv=none; b=Z23m9E2KafNgFnh5ejWHyQHBFjP7qxU1NayMwVM844uYkQ2e+cN6xHQJvgnmabvI/2R40ejkTJ1RP5vJCkMDaLybme1nnWgTlTahC4O/IqEZSyR3Nc6FEO8npLpPZMe3aKfo8J8PB67hWDTpR4aAWp107si7C7LxgYU8/ki6Rvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765471363; c=relaxed/simple;
	bh=C2Irb+AOliXJZV5eDYLr03TD4kWKwAB7GTo+cJWOyaw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=HcXNKgrbHT6nfP33c/YcOmSPZ5GqOu9oOAUpB3von6XV/7f7S+XGYZHd4jCsaMwr90PHCwNnyk6znbPoCBaCqKbU+pIYqNBDF4APluCHew+uEX3EzUW7KSmoEt5ByLNBntJ7gNZhY28jsIyAo/QAqKyhGZGLgqrYXupzqoUSLnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-65b355a1abbso276250eaf.2
        for <syzbot@lists.linux.dev>; Thu, 11 Dec 2025 08:42:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765471361; x=1766076161;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oyy7jzxXZJoOjRQdIK8t8j16EGWe4YjdH0GeMLVpgUU=;
        b=YyLvAEdfdwKLjBpopwyRwwirUvBsJzhrixyJCvfLPp7a82R7lfE+K8SDmY4c8yha3t
         Bgq3FJX8XodQIFfBDSquw2EjmljL770ZjnIaCSSy+VZLgsgD5wRavp4uYaCLaRu06jJh
         t8sN4sTR404nnuSSk2mpDI3rzh9QZG7DSaTEvQx2JKeatLhR8ce8AwYY2GijKancy5sr
         YjvswYyFxSDChG5WBqZqQ34WLGqVTs46B59vsJlJ9nxr1U60okGG1FBzePQrMmEZBl2N
         4FCivNG1jr//9wkbTn240nr3L4pltQwFyQFBp6iogSx4v7ovuvrz1d65Joq6/WzK5Py/
         VIfw==
X-Gm-Message-State: AOJu0Yz0pfYp6OBm1OXer6ba9DZQvC7hqChCZn+7cF58viirDhxZ20tV
	DU+a32zBOWFVGcDNp7UFEYkFFUyiSuLJQBK9+SESZ1+YU20N7L69lEsPOnetlEU8dH/7fQ9UodJ
	YxTX1C+UXwTRrxUNTK48X3+2yTcASZJTeeyf1dwXgwo+O6syH7XAiPvIqftE=
X-Google-Smtp-Source: AGHT+IG8tBd07/z2sgb6yN+vj0oUgpchchG7IZtQ8ND5HPb3rolr71t15P0VgdNrt489V98PSs7pK5KzT9tVWhB6UJNPYYM43JLY
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f08:b0:65b:3641:bf72 with SMTP id
 006d021491bc7-65b3641c46amr1432202eaf.68.1765471360872; Thu, 11 Dec 2025
 08:42:40 -0800 (PST)
Date: Thu, 11 Dec 2025 08:42:40 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693af480.050a0220.4004e.03c5.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: nf_tables: avoid chain re-validation
 if possible
From: syzbot ci <syzbot+ci3c6f9b9cf7ea73f4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] netfilter: nf_tables: avoid chain re-validation if possible
https://lore.kernel.org/all/20251211123038.1175-1-fw@strlen.de
* [PATCH nf v3] netfilter: nf_tables: avoid chain re-validation if possible

and found the following issue:
WARNING in nft_chain_validate

Full report is available here:
https://ci.syzbot.org/series/498345c4-bb9b-4e13-9cd1-42a483844f55

***

WARNING in nft_chain_validate

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      6a107cfe9c99a079e578a4c5eb70038101a3599f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e56f0271-a9ee-403c-ad73-fe3d0fb22785/config
C repro:   https://ci.syzbot.org/findings/c4c03a63-b1c1-4815-b601-f7c763a99b6c/c_repro
syz repro: https://ci.syzbot.org/findings/c4c03a63-b1c1-4815-b601-f7c763a99b6c/syz_repro

------------[ cut here ]------------
WARNING: net/netfilter/nf_tables_api.c:4112 at nft_chain_vstate_update net/netfilter/nf_tables_api.c:4112 [inline], CPU#1: syz.0.17/5982
WARNING: net/netfilter/nf_tables_api.c:4112 at nft_chain_validate+0x6b0/0x8c0 net/netfilter/nf_tables_api.c:4176, CPU#1: syz.0.17/5982
Modules linked in:
CPU: 1 UID: 0 PID: 5982 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:nft_chain_vstate_update net/netfilter/nf_tables_api.c:4112 [inline]
RIP: 0010:nft_chain_validate+0x6b0/0x8c0 net/netfilter/nf_tables_api.c:4176
Code: 31 db 89 d8 48 83 c4 50 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 2d 32 42 f8 bb fc ff ff ff eb de e8 21 32 42 f8 90 <0f> 0b 90 49 83 c5 78 ba 04 00 00 00 4c 89 ef 31 f6 e8 ea 18 a8 f8
RSP: 0018:ffffc90003df6fe0 EFLAGS: 00010293
RAX: ffffffff897f183f RBX: 0000000000000000 RCX: ffff888102f93a80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000040 R08: ffff888102f93a80 R09: 0000000000000002
R10: 0000000000000010 R11: 0000000000000000 R12: ffff88816a79c510
R13: ffff88816a79c500 R14: ffff88816a79c500 R15: dffffc0000000000
FS:  000055555e417500(0000) GS:ffff8882a9eb1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000005000 CR3: 000000017531c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 nft_validate_register_store+0xf6/0x1d0 net/netfilter/nf_tables_api.c:11750
 nft_parse_register_store+0x225/0x2c0 net/netfilter/nf_tables_api.c:11787
 nft_immediate_init+0x1cf/0x390 net/netfilter/nft_immediate.c:67
 nf_tables_newexpr net/netfilter/nf_tables_api.c:3550 [inline]
 nf_tables_newrule+0x1794/0x28a0 net/netfilter/nf_tables_api.c:4419
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:526 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
 nfnetlink_rcv+0x11d9/0x2590 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:718 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:733
 ____sys_sendmsg+0x505/0x820 net/socket.c:2608
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2662
 __sys_sendmsg net/socket.c:2694 [inline]
 __do_sys_sendmsg net/socket.c:2699 [inline]
 __se_sys_sendmsg net/socket.c:2697 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2697
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f577a58f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe377887c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f577a7e5fa0 RCX: 00007f577a58f7c9
RDX: 0000000000000000 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007f577a5f297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f577a7e5fa0 R14: 00007f577a7e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[fw@strlen.de hamzamahfooz@linux.microsoft.com netfilter-devel@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

