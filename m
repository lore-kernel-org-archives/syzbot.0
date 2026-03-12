Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AE64035DE
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 19:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773343040; cv=none; b=o9B3/Js7ybSF6kGe3fyosk+InNcw4VfbzvHqjcR9iQrOSQx8tOst5ojLWvxci3e2MyoUNoJn/83qjUdkpesclHSroinMcvssNDnRwPf85+8GWdQeWu5ghPzwTkdcCaWi4TnO6DK/a6YDQ3SI6t57CL9sskOR7dzXBCYhRz2HKU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773343040; c=relaxed/simple;
	bh=EJLnba4UGOy0/eiq/lvKbQrYNT7DxwU+cfL1tJjcj4Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=KToER+aVABD1shNq368uix1phBpw7nqkJ9dG7zTM/9FPyGZOEzU43qbfLEpcG4da6mBPm+lZb0oTz7MYWH6ApZOsAfAZWHAdR/HvCivpHySfduRDaoLdWugM2iOcKTrqawJDXf4ITn7GAFLg5c8BTG74zS9PaKu1Ut/Avl8hvig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7d742bb4003so5967306a34.0
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 12:17:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773343038; x=1773947838;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sWPmA2Mb4CZzdtanNKE81NSKHn/qkndo3nB+5uWHV6o=;
        b=UuT5dwn0ML5meZInFsKXduSdaTrQVoGqyavNR8vyootfs5lqNfn+hhtumLE+I+6ccF
         kao5+6QQRtipav/mv4Vhc945inayXa5rIs3L5AzWv4wY8S7cZu8/dra7NAayd++JYw/5
         Efa6bGvE1klFvwDkFBQun5E0gHGF6XoOl3+V1dC5U5r3vmGgT0e9HknuWtSlKdO7iFA8
         CENDGSpx3K72G9Lpbfhpehlwm4XBg2ectYbWhaelWS3Q9V/b+H4tw6aVn3KEPLMWDUiW
         L+wFWGEklxf/LYNJVMm0TZ0RhU6tKtJtBHmDLhIGywaifbVzLkQ30sfTfwtCbp8UuTRG
         X4Vw==
X-Gm-Message-State: AOJu0YwOSjWxjCjvFXCpX8YIV3BHDJxKef4F8MYQ0mdHIEqv6xddS8yK
	CWb7dBeu5WvnAuZ6Sxn7aHTxrFvmYxbtuU4TRpC2k6dcebKcPc2uOtc1VYCznxrUIz3EzLfhlIB
	Mua8XDpkXT+ErBYCVgEQ3vInOwFu57ITlw9umLSKBJRozG0/1QKjS4jdO0Ks=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2223:b0:66e:7aaa:be64 with SMTP id
 006d021491bc7-67bdaa79cd9mr322985eaf.55.1773343038096; Thu, 12 Mar 2026
 12:17:18 -0700 (PDT)
Date: Thu, 12 Mar 2026 12:17:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b3113e.a00a0220.3b25d1.0001.GAE@google.com>
Subject: [moderation/CI] Re: misc chandef cleanups
From: syzbot ci <syzbot+ci2610d53654eef5fa@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[arien.judge@morsemicro.com johannes@sipsolutions.net lachlan.hodges@morsemicro.com linux-wireless@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

