Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CE3386C11
	for <syzbot@lists.linux.dev>; Fri, 13 Mar 2026 08:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773391522; cv=none; b=dcDx4Z8QVhIjZ1NOrrNxnlSP8fuOY5GXs5F2wnwxsAfPbPq8L93nR08FvyjpX/dy0uyTYPaWpHm8OBWMXggeFnlTim7T1D/t0VqoIfX+mjv5CGfDsjwg1Li6/7VDTq/7VMlOGru9+4mj+jLYjd11u/YCsmsj0HW1XjKW7DoZ/RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773391522; c=relaxed/simple;
	bh=q/2arKQRvxe5l8bdQLLgTnns1HiKUCDfcCll5Cm23SM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JRvEts2EIAsj8eAPPNgpOiy3oPCe/t4A+6bhOU/bgUIQYXnfC4xrCwweWhanFtnfKp9QKqvvJBFpA0d1LKyt+by8CVGOt1oM3YRgoOtVQj1vw4FfebttP1afypcwWYddIibEldBJW+vyroe3+HWHmX1GIpnrIpL1YbJDR4MxcDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67bcaf99fdcso30774284eaf.3
        for <syzbot@lists.linux.dev>; Fri, 13 Mar 2026 01:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773391518; x=1773996318;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9MHG008xP8OEekEobxOFfSIkDz9YZx5/0f2eRnYeoWw=;
        b=CS1Qth467ak3Lw+gJb+ObO3KYvFvtJwHUaE2Ea+/CtbAH+Ypz4Rg+Cb6gsYr4ryS0+
         xdjGVaKTSOSnGTU4XkTkYtDcPgt+uNEIBJLRK6doYGztNyEtzCM5mK/W4oU8MmfkrvOB
         TTnK4G/8HRzuOog2x2JXs/c854dw04j0//kh+51FfNLDI2EsPz/SOsSy+cTfm+hujouZ
         XNH2lfiJo1iUHRxlmoQIG/HwRFHT9cd/5P9Qu9vRv4FSLh73c4ZnQwAQz0HSYys8xqvZ
         77LNBXJMtLOq3vaNvqNwhQ93nd2eqi8yy7N/cif755b6WIvB5nV2l8u7vBdTPI7fLUlx
         FECw==
X-Gm-Message-State: AOJu0YwXJTHE2epcq33JRYD8dUk6Mi6BeU+KVsbr1s+QxKjA4DuELri0
	SBrChlnVD/c4p+9p11IkkAiTvEhJTIZclhyREcSE+0T0gPCuR0d34e9tgNJOfftrI2bmi+QR/kD
	cKT6F/d/Ec0QnHwVjdAXridJqvNKDct5JjeDPep718F//ML6syIVw/ps59RQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:207:b0:67b:aa33:4086 with SMTP id
 006d021491bc7-67bda9bf9d2mr1684336eaf.18.1773391517898; Fri, 13 Mar 2026
 01:45:17 -0700 (PDT)
Date: Fri, 13 Mar 2026 01:45:17 -0700
In-Reply-To: <20260312045804.362974-1-lachlan.hodges@morsemicro.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b3ce9d.050a0220.12d28.010d.GAE@google.com>
Subject: [syzbot ci] Re: misc chandef cleanups
From: syzbot ci <syzbot+ci0f91523e1d0ef709@syzkaller.appspotmail.com>
To: arien.judge@morsemicro.com, johannes@sipsolutions.net, 
	lachlan.hodges@morsemicro.com, linux-wireless@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] misc chandef cleanups
https://lore.kernel.org/all/20260312045804.362974-1-lachlan.hodges@morsemicro.com
* [PATCH wireless-next v3 1/3] wifi: mac80211: don't use cfg80211_chandef_create() for default chandef
* [PATCH wireless-next v3 2/3] wifi: cfg80211: restrict cfg80211_chandef_create() to only HT-based bands
* [PATCH wireless-next v3 3/3] wifi: cfg80211: check non-S1G width with S1G chandef

and found the following issue:
WARNING in cfg80211_chandef_create

Full report is available here:
https://ci.syzbot.org/series/ce6fc7d6-d8d4-4d00-a746-db78cba13e47

***

WARNING in cfg80211_chandef_create

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      80234b5ab240f52fa45d201e899e207b9265ef91
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0a18d006-45de-4bb2-a6e2-2cbb788bd2f5/config
C repro:   https://ci.syzbot.org/findings/c279480a-56a9-4a59-b533-0033d65eca62/c_repro
syz repro: https://ci.syzbot.org/findings/c279480a-56a9-4a59-b533-0033d65eca62/syz_repro

netlink: 8 bytes leftover after parsing attributes in process `syz.0.17'.
------------[ cut here ]------------
chan->band == NL80211_BAND_60GHZ || chan->band == NL80211_BAND_S1GHZ
WARNING: net/wireless/chan.c:35 at cfg80211_chandef_create+0x99/0x3d0 net/wireless/chan.c:34, CPU#1: syz.0.17/5951
Modules linked in:
CPU: 1 UID: 0 PID: 5951 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:cfg80211_chandef_create+0x99/0x3d0 net/wireless/chan.c:34
Code: 8b 26 4c 89 e7 48 c7 c6 40 d6 e3 8f e8 a0 7d bd f6 49 83 fc 04 74 0d 41 83 fc 02 75 12 e8 0f 78 bd f6 eb 05 e8 08 78 bd f6 90 <0f> 0b 90 eb 05 e8 fd 77 bd f6 89 ef 48 c7 c6 60 d6 e3 8f e8 6f 7d
RSP: 0018:ffffc900054fef78 EFLAGS: 00010293
RAX: ffffffff8b0825a8 RBX: ffffc900054ff0e0 RCX: ffff888112b5ba80
RDX: 0000000000000000 RSI: ffffffff8fe3d640 RDI: 0000000000000004
RBP: 0000000000000002 R08: ffff888112b5ba80 R09: 0000000000000002
R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000004
R13: dffffc0000000000 R14: ffff888111c65998 R15: ffffc900054ff0e8
FS:  000055558dcaa500(0000) GS:ffff8882a9463000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f14d1588095 CR3: 000000010668a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 _nl80211_parse_chandef+0x438/0x1160 net/wireless/nl80211.c:3616
 __nl80211_set_channel+0x1fe/0x850 net/wireless/nl80211.c:3736
 nl80211_set_wiphy+0x116b/0x2fa0 net/wireless/nl80211.c:-1
 genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
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
RIP: 0033:0x7f0ea239c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe7ad20a38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f0ea2615fa0 RCX: 00007f0ea239c799
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007f0ea2432bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0ea2615fac R14: 00007f0ea2615fa0 R15: 00007f0ea2615fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
