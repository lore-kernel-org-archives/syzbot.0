Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0294F2FD69D
	for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 10:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789901395; cv=none; b=KOKTwf0266fPnDmmGNljkJbcloEuEHtG6oOmldYdmZ/6CCAiS+iqFakGJ3jCPio9OWJA+Wf8M5sl4K092qA05K9INHA5zZ1eAnIUP9ofORN2IdD98FeKSjMsCJl+NL4oXHD3rPcV+A2ENdoWQj8ujsSUxCdfLzwwvJ7zYcn7Yzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789901395; c=relaxed/simple;
	bh=K20PGmlZpZ/J9S8RSso70aIQOnXGYizeAEu5JbIj8D8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=pZe9TmmjWwjNeEH0oD7tFt9HCV7ksDzvc4AZZkKoaKgoZmcQXyUz2vTIhJvReDEzS4kWzgCnNJGwhKkfjvLQ9+bnnz4r6FQSIrX/tb+1E3wuVj8eJY3eXodIn4z1TovQwZvVePWaTKAoEth8V9AmgVjynb+g1P/2s3yzc8QgHm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b28dafb8e1so3490808b6e.2
        for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 03:49:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789901393; x=1790506193;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aHcJOhRW8IlBD1d9Mg6fiEwM4yxVg3OWKuothPl1YU4=;
        b=Ln8nmCJTMLVxRk8GHx6Dyq1rp3jOqeyD5ZjscpiK69YhdLIqUrzw7OSqo/a4/WBGAZ
         yeSZb6AVOlAprunoKeCwZMA7Jc4mMlzfrOM3CeT2bUg8NvxzQ4Q4aSk0Qe1uLNitIknD
         ZaaIFuwR3W7PzrXjSX707ncnzgoYlg9kmf3wIpW9X3F71f0o//6lJl4xweX0uGVzf+H+
         BTwFL3uXi1wR3ty1LuD5LB0ReWfjOULPB7nFaWrqerxWFJ6HzOkdw7IgdAWUZitM/yXT
         t+iF3LSaWudpqC0o3Is1HhWZQ0Ljk+qVQkIS/EKJIy2qnuIROw5egbWfRbdb+ZWdn/V9
         Utnw==
X-Gm-Message-State: AFuF++maW3Np7t1KwDywigIsTlmfo7O5eongC4zq68p0LJ3/CSl4vZVO
	PjYF4GK7osltedWnH96cP/EIYrZ/sxRb2IELJwi69C2+XhvRqBnBRtnsb/JRuM62TwXIP/Wczya
	mZ06D16kx5AkNlqd7BNY+jlO3S24m+zdRZH2isWnvHkwk1sSwRrTvCyOGU64=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b10:b0:6c3:398:8d29 with SMTP id
 006d021491bc7-6ca9be501b5mr7224156eaf.34.1789901392905; Sun, 20 Sep 2026
 03:49:52 -0700 (PDT)
Date: Sun, 20 Sep 2026 03:49:52 -0700
In-Reply-To: <20260917221205.3214125-1-roryl@candelatech.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aafba50.514bccd6.255447.0006.GAE@google.com>
Subject: [syzbot ci] Re: net: cfg80211: Validate monitor channel set against
 radio usage
From: syzbot ci <syzbot+ci5ae471ec6c7a1072@syzkaller.appspotmail.com>
To: dylan.eskew@candelatech.com, johannes@sipsolutions.net, 
	linux-wireless@vger.kernel.org, roryl@candelatech.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
