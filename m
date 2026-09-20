Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962FB2E266C
	for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 05:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789881159; cv=none; b=qbtfEsATi9i6gmL5zMJ2F5sH1ARUdD8xH1Av+utzipeyjh4bIND5bIUFFqdWa96jbbd4ditcUySM9/oR3zXv5JFttYDsErTk0XIj4c9wuFULfdVRIyJAXKjS+to2aZhlHSXEdPnwEtZT+JSB6wgSaNx7w96yYwTanEVfxEcuePY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789881159; c=relaxed/simple;
	bh=XH0CBgsPyHRZWeeFrHkpw1/1E66HJ38Om17b+yZ261Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=JBD/U1krf4Y/ecp+wNvdsxyKm80aoaqkcYNQyvico+tl8P2jZFlfuv1M1RtrrJYIdIVunSg7s+NxswZW3fOK54eRZPmQpQV9dOOQLL+IWMnUwu+cEV6ikE+sL7vCIFeHYOedT9nUa+sPe+a5Uo1URyDzFl423y5t1DAvFJqPRYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-8048c813cceso3390839a34.1
        for <syzbot@lists.linux.dev>; Sat, 19 Sep 2026 22:12:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789881156; x=1790485956;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6MihNCZUKTYyS8yT6JT8yocNZMY9/IyNlUU4OFWlGJs=;
        b=pR3Y5+ZHJjzi13NQzjSULO+b5IaPbzMi+wKKn/PWqlZzQs4QqVeL2nJHUtuM4z2CY0
         gP4Rly07woenHZPTDzGwbAFwHjGUBjtGCPHcnVfaJR3dM+4LDAZSOx+Ogq5yn4E/9nq8
         Z4jp5BgYeiNemVgmt248mxn9rO6MYT/Ecruiwvzk6XZO5hEXPjB+ttiqMuIvquKTUdX1
         P969o+V9beuqB2aAiPmFhoJMLgvdsbuYvHMUzXaZip280Lv7rsUsuPSfHaRG/wB6NZAy
         Y2bom7hz3ydNqLWnUcuxMU/RyPmqhw+ronI9C88EgajFPNrj52MghUPnqqkyQ+7o8wVJ
         pVAw==
X-Gm-Message-State: AFuF++kNG2TFnlHynvgWDRegwucWw2AfIaNHnIFcd2s4FIzJ2olZEpPD
	tP0njyWG0GoPYTAsuj8ZQHuN2jShJia6LF+Bb0V0fdWWh8upPP0KbPt4ULedFyziDS4JlPq42ip
	GGiK1Bn/vXqH+yVzsGiqT6Uq4rdzpeq71llWOzDlem1JVmSXe0x2g8lCpjrU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:7092:20b0:6cd:3fec:de82 with SMTP id
 006d021491bc7-6cd3fecf3bbmr2586130eaf.88.1789881156487; Sat, 19 Sep 2026
 22:12:36 -0700 (PDT)
Date: Sat, 19 Sep 2026 22:12:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aaf6b44.3179f8cd.1e36b2.0009.GAE@google.com>
Subject: [moderation/CI] Re: net: cfg80211: Validate monitor channel set
 against radio usage
From: syzbot ci <syzbot+cifdd8742fac68be6d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: cfg80211: Validate monitor channel set against radio usage
https://lore.kernel.org/all/20260917221205.3214125-1-roryl@candelatech.com
* [PATCH wireless-next] net: cfg80211: Validate monitor channel set against radio usage

and found the following issue:
UBSAN: shift-out-of-bounds in cfg80211_set_monitor_channel

Full report is available here:
https://ci.syzbot.org/series/096ed229-0401-4402-9865-92c5b6d81b57

***

UBSAN: shift-out-of-bounds in cfg80211_set_monitor_channel

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      3b35f726c20d138fafa154182ee926a419306269
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7147a923-683e-41dc-b623-05cfe4ac2a30/config
syz repro: https://ci.syzbot.org/findings/525583ec-5ed7-4adc-aeab-6eb3b293f9ee/syz_repro

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in net/wireless/chan.c:1831:49
shift exponent -22 is negative
CPU: 1 UID: 0 PID: 5855 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
 cfg80211_can_set_monitor_channel net/wireless/chan.c:1831 [inline]
 cfg80211_set_monitor_channel+0x38a/0x8d0 net/wireless/chan.c:1844
 __nl80211_set_channel+0x340/0x990 net/wireless/nl80211.c:4203
 nl80211_set_wiphy+0x127c/0x3050 net/wireless/nl80211.c:-1
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7e3a59e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7e3b3d5028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7e3a825fa0 RCX: 00007f7e3a59e159
RDX: 0000000004040000 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007f7e3a63506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7e3a826038 R14: 00007f7e3a825fa0 R15: 00007ffd12ef16a8
 </TASK>
---[ end trace ]---


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
[dylan.eskew@candelatech.com johannes@sipsolutions.net linux-wireless@vger.kernel.org roryl@candelatech.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

