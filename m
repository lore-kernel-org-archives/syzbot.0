Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB5D33D4F0
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 07:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786519118; cv=none; b=YSGJdlKZU/fKsZYVVbJeIkiD6G/88Ai/7qC7aSq5NQC/14XtDOf1t56ZjwNldQR1up7za+Be+evBs0khVezEXOIb+ub5xmYCmaed8RJh/qTugGJa3BxaYGTHKOD4ktFAnbSt4/ruo5oLk6EYXxDKdi+C3QcLT6nk/dXFJj4PeVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786519118; c=relaxed/simple;
	bh=nv5fggdiG/GtalVrTvxUew4usSW/ob73E0kwCxPLlZI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=RPMZ1yO0eWMjNjo81fU0zgqUfOl9TROC8D2Ou4e3nPFDzHy84KqbLb3Z8z+Vh2AAGasf48mwd/bsmY8JKyxCIgy6lQORuLHv9BwnscMCjHnAhXH6gx4Su28FOwedJG1J7BpZEp+j9wN3j1+UO1sQdxvcM4pffp826gRxWBv/ypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a41f46d629so969141b6e.3
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 00:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786519115; x=1787123915;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:in-reply-to:date:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8KBxR5i6Cpb80gDb9kRiVLUGQ+i66jj+t7Wtqm6QpEM=;
        b=Rz7wysXuitcIs4vqjP5skEGJiHn/qRT4HuuE6iFpSE0alvtakCVk/2+KLoBDMQkKEW
         nGxuy1jqpUPjYmXqCIup0d8L/Uu16V9HA5nk7+lYr2Wms19v4xkW7kG1M9G5Js6SPmnP
         uq8lRAgEAoMsKOw1U2yb0Tpo1AaCEZi9LKqF4CsLqBlKd0ZtX9/h1AnaqSJTaH5vkdpC
         Fi34LrwXGnlQq+IWVmGqjv3jy9CS9VYGz0B5KioKvrToD2Be7TjR0hzH3MC2+tJ02ce5
         4WcqOUOgDnHQTM1/8LykifPB++rpGlbci0ADA1oH1C7icw7DC9suB7s5skBJ08cFvhDL
         HdAQ==
X-Forwarded-Encrypted: i=1; AHgh+RoVQ/S6uMnqOUaT7Gw+F8zAVaJakl1xV3Sx243nsdfiasf524x1iBtKlxk1nTolXPyYQawgAWA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeUys+oGRwBaNWtpMCrg51hg/NvPqs3NGdwLiyVUmIolQNq6et
	8tk80mbLzhVGY87AxJmrTjT+55vtW00h6NBvrxxqrjT3OG5mwUKwXB8rkEjsf94Dn915VSzSqBO
	/UBFkF7LYSA/gtoK67B7i26qHn2mD5TYvX/JpYaNS9FoZGIDPRGE9ki59O+c=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2209:b0:4b1:540a:df99 with SMTP id
 5614622812f47-4b210c532ebmr2732592b6e.21.1786519115301; Wed, 12 Aug 2026
 00:18:35 -0700 (PDT)
Date: Wed, 12 Aug 2026 00:18:35 -0700
In-Reply-To: <CANp29Y5qW58Eh8yarbwg_45CxYCvNSo0qrY0POAzU=9sFSKZCQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7c1e4b.3668565d.e8814.000e.GAE@google.com>
Subject: Re: Re: [moderation/CI] Re: wifi: mac80211: guard drv_net_setup_tc()
 against unbound AP_VLAN sdata
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: nogikh@google.com
Cc: nogikh@google.com, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> #syz upstream

Failed to process the command. Contact syzkaller@googlegroups.com.

>
> On Wed, Aug 12, 2026 at 3:36=E2=80=AFAM syzbot ci
> <syzbot+ci59a1ab611e254e14@syzkaller.appspotmail.com> wrote:
>>
>> syzbot ci has tested the following series
>>
>> [v1] wifi: mac80211: guard drv_net_setup_tc() against unbound AP_VLAN sd=
ata
>> https://lore.kernel.org/all/20260811210926.11422-1-ayushmanrout27@gmail.=
com
>> * [PATCH] wifi: mac80211: guard drv_net_setup_tc() against unbound AP_VL=
AN sdata
>>
>> and found the following issue:
>> WARNING in ieee80211_netdev_setup_tc
>>
>> Full report is available here:
>> https://ci.syzbot.org/series/db0f7870-cfa6-4a9b-b78b-225ce86c2a89
>>
>> ***
>>
>> WARNING in ieee80211_netdev_setup_tc
>>
>> tree:      wireless-next
>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wire=
less/wireless-next.git
>> base:      ca800a9302764c445de0da0e84d2252400a770ee
>> arch:      amd64
>> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~=
exp1~20260613092250.77), Debian LLD 22.1.8
>> config:    https://ci.syzbot.org/builds/e40f4f29-7949-48eb-9c12-006be404=
6454/config
>> syz repro: https://ci.syzbot.org/findings/4c184dbd-070a-4d74-8afd-085fa1=
b5f0a2/syz_repro
>>
>> ------------[ cut here ]------------
>> syzkaller0: Failed check-sdata-in-driver check, flags: 0x0
>> WARNING: net/mac80211/driver-ops.h:1719 at drv_net_setup_tc net/mac80211=
/driver-ops.h:1719 [inline], CPU#1: syz.1.18/5848
>> WARNING: net/mac80211/driver-ops.h:1719 at ieee80211_netdev_setup_tc+0x2=
f0/0x550 net/mac80211/iface.c:938, CPU#1: syz.1.18/5848
>> Modules linked in:
>> CPU: 1 UID: 0 PID: 5848 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(=
full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1=
.16.2-1 04/01/2014
>> RIP: 0010:drv_net_setup_tc net/mac80211/driver-ops.h:1719 [inline]
>> RIP: 0010:ieee80211_netdev_setup_tc+0x345/0x550 net/mac80211/iface.c:938
>> Code: 48 8b 02 48 8d b0 20 01 00 00 48 85 c0 48 0f 44 f1 0f b6 04 2b 84 =
c0 4d 89 ee 0f 85 ad 00 00 00 49 8d 84 24 68 0a 00 00 8b 10 <67> 48 0f b9 3=
a e9 16 fe ff ff e8 cc ee 86 f6 90 0f 0b 90 e9 75 fe
>> RSP: 0018:ffffc900042ff078 EFLAGS: 00010246
>> RAX: ffff8881709e9928 RBX: 1ffff1102e13d325 RCX: ffff8881709e9938
>> RDX: 0000000000000000 RSI: ffff8881709e8120 RDI: ffffffff9068ed60
>> RBP: dffffc0000000000 R08: ffffc900042ff157 R09: 0000000000000000
>> R10: ffffc900042ff128 R11: ffffffff8b3fff60 R12: ffff8881709e8ec0
>> R13: ffffc900042ff120 R14: ffffc900042ff120 R15: ffff8881709e8000
>> FS:  00007f5cd6df16c0(0000) GS:ffff8882a8f66000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00002000000012c0 CR3: 000000016f0fc000 CR4: 00000000000006f0
>> Call Trace:
>>  <TASK>
>>  tcf_block_offload_cmd+0x235/0x3b0 net/sched/cls_api.c:838
>>  tcf_block_offload_bind net/sched/cls_api.c:875 [inline]
>>  tcf_block_get_ext+0xfe0/0x17d0 net/sched/cls_api.c:1498
>>  tcf_block_get+0x67/0xa0 net/sched/cls_api.c:1543
>>  multiq_init+0x72/0x2b0 net/sched/sch_multiq.c:246
>>  qdisc_create+0x7b5/0xf00 net/sched/sch_api.c:1337
>>  __tc_modify_qdisc net/sched/sch_api.c:1771 [inline]
>>  tc_modify_qdisc+0x17af/0x2390 net/sched/sch_api.c:1835
>>  rtnetlink_rcv_msg+0x7b9/0xc00 net/core/rtnetlink.c:7121
>>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>>  __sock_sendmsg net/socket.c:790 [inline]
>>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>>  __sys_sendmsg net/socket.c:2770 [inline]
>>  __do_sys_sendmsg net/socket.c:2775 [inline]
>>  __se_sys_sendmsg net/socket.c:2773 [inline]
>>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7f5cd5f9e0d9
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f5cd6df1028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>> RAX: ffffffffffffffda RBX: 00007f5cd6225fa0 RCX: 00007f5cd5f9e0d9
>> RDX: 0000000000000000 RSI: 00002000000012c0 RDI: 0000000000000004
>> RBP: 00007f5cd6035024 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007f5cd6226038 R14: 00007f5cd6225fa0 R15: 00007ffc6aba2558
>>  </TASK>
>> ----------------
>> Code disassembly (best guess):
>>    0:   48 8b 02                mov    (%rdx),%rax
>>    3:   48 8d b0 20 01 00 00    lea    0x120(%rax),%rsi
>>    a:   48 85 c0                test   %rax,%rax
>>    d:   48 0f 44 f1             cmove  %rcx,%rsi
>>   11:   0f b6 04 2b             movzbl (%rbx,%rbp,1),%eax
>>   15:   84 c0                   test   %al,%al
>>   17:   4d 89 ee                mov    %r13,%r14
>>   1a:   0f 85 ad 00 00 00       jne    0xcd
>>   20:   49 8d 84 24 68 0a 00    lea    0xa68(%r12),%rax
>>   27:   00
>>   28:   8b 10                   mov    (%rax),%edx
>> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instruct=
ion
>>   2f:   e9 16 fe ff ff          jmp    0xfffffe4a
>>   34:   e8 cc ee 86 f6          call   0xf686ef05
>>   39:   90                      nop
>>   3a:   0f 0b                   ud2
>>   3c:   90                      nop
>>   3d:   e9                      .byte 0xe9
>>   3e:   75 fe                   jne    0x3e
>>
>>
>> ***
>>
>> If these findings have caused you to resend the series or submit a
>> separate fix, please add the following tag to your commit message:
>>   Tested-by: syzbot@syzkaller.appspotmail.com
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>>
>> To test a patch for this bug, please reply with `#syz test`
>> (should be on a separate line).
>>
>> The patch should be attached to the email.
>> Note: arguments like custom git repos and branches are not supported.
>>
>> The email will later be sent to:
>> [ayushmanrout27@gmail.com johannes@sipsolutions.net linux-kernel@vger.ke=
rnel.org linux-wireless@vger.kernel.org nbd@nbd.name syzbot@syzkaller.appsp=
otmail.com]
>>
>> If the report looks fine to you, reply with:
>> #syz upstream
>>
>> If the report is a false positive, reply with
>> #syz invalid
>>
>> --
>> You received this message because you are subscribed to the Google Group=
s "syzkaller-upstream-moderation" group.
>> To unsubscribe from this group and stop receiving emails from it, send a=
n email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
>> To view this discussion visit https://groups.google.com/d/msgid/syzkalle=
r-upstream-moderation/6a7bce19.d5f0ebe7.22d851.0004.GAE%40google.com.
