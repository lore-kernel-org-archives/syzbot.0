Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD4230EF92
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 02:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779245809; cv=none; b=sBUyPuVs9FSwU7vxw24NWgP7qszYl55XJXFpwSQS/R1ygG58sHN9FWr8apRfdz4bnzSCz+1+J93fKB3trxQrAmtm4Ded2OdjCrloDqzleMTxAktUw6IIRd4WHR96VMGHzdwzORS2H1ym+lhF2F16qiHokl0w67UK1a/iKi5KGFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779245809; c=relaxed/simple;
	bh=OiQs5cHqHD93Rpk0ZzTI2UuBUD4iywks6e1MwlH9VBg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Dxuy4Qm6Vx1CPRVHS1Al9fHONB3RksXfPPMGXqzKys3mOnhYsfnoZW4ketQxL1Xo3TtH7Li9kjU7ZNQJafU4NzdQ9TPRK0GnXR8fSoJmZg7hc6qprTckARyzl25Bw/3vu1CiQwsGCpG9ucjKRVjVDti/XVssdkRdBLMtWsfDvz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e3a338673eso13298684a34.0
        for <syzbot@lists.linux.dev>; Tue, 19 May 2026 19:56:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779245807; x=1779850607;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rXRbetNmEK5PNHKF2T8IWQf/6g7WsLnpFUYkXGRD4FI=;
        b=pyxTFjF0dAAsZjQ7uW3LLNPUw5WweqfY8mt3yzFFeaH94YP6FAbIy+uHUo/3a3AWCf
         oRR59ajPHdgAF7Qv/9QnKiwdn27ZpwVm/FtBi4PKRdDhR7n5lxN5ZyihOOloixglpRsu
         pEFzRzpifI7yINYQo8HEFEu40SwyoIJvvk3E0slIaTwUdaExsVxt2EUvtkkMjlbQ8Wna
         cFQAYJPVnSuqC61hkLQfadhShjrECow+O6ndoh13P4BLnApsFe6RhsX/Zj5Z1S/Q1dyy
         UcE9YszqmT1rgO6w7V4Nu+Dm5yRLBR5XW8+xxAsMKAyyvSoLo1V3xI6Qgd2cXg7JMZ+J
         3q3w==
X-Gm-Message-State: AOJu0YxwFoyOKF2b0MFXwemmlGj28UUfdmHd19NGqL2+YJZoUO2DL+4w
	GtZWiPBnp/GWwXUhg2PwC0H9a9nkkuDck6j5l6iN3hTPR+QtwiVmuXWXI8ESbtDdqDZ9+9v7X6K
	yPELNA4h/Wt6AcTu3NmhxONbWi2jNhbEBY2wqnXnifit6gkvcSpHGoDvWfZM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8585:10b0:69d:4bf6:77eb with SMTP id
 006d021491bc7-69d4bf679f9mr1762817eaf.16.1779245806891; Tue, 19 May 2026
 19:56:46 -0700 (PDT)
Date: Tue, 19 May 2026 19:56:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0d22ee.170a0220.39a13.0008.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: nfnetlink_cthelper: use
 {READ,WRITE}_ONCE for accessing helper flags
From: syzbot ci <syzbot+cidb58587e522e2f70@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
https://lore.kernel.org/all/20260519213826.1181661-1-pablo@netfilter.org
* [PATCH nf 1/7] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
* [PATCH nf 2/7] netfilter: conntrack: add dead flag to helpers
* [PATCH nf 3/7] netfilter: nf_conntrack_helper: add null check in nfct_help_data() calls
* [PATCH nf 4/7] netfilter: conntrack: add null check in nfct_help() calls
* [PATCH nf 5/7] netfilter: conntrack: add nf_ct_iterate_destroy_net()
* [PATCH nf 6/7] netfilter: nf_conntrack_timeout: use nf_ct_iterate_destroy() to cleanup timeout going away
* [PATCH nf 7/7] netfilter: xt_CT: fix race with rule removal and nfnetlink_queue

and found the following issue:
WARNING in xt_ct_tg_check

Full report is available here:
https://ci.syzbot.org/series/c356956d-b1f6-4d7e-be26-6cf68d49814e

***

WARNING in xt_ct_tg_check

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      2beba18b0160446463bf1dbd749324846db98493
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/45c49e4e-439a-4d11-bc9a-3c3a5077f679/config
syz repro: https://ci.syzbot.org/findings/9cfb9381-576b-4a17-a156-68641410fec2/syz_repro

No such timeout policy "syz1"
------------[ cut here ]------------
help
WARNING: net/netfilter/xt_CT.c:226 at xt_ct_tg_check+0x814/0xa90 net/netfilter/xt_CT.c:226, CPU#1: syz.0.17/5870
Modules linked in:
CPU: 1 UID: 0 PID: 5870 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:xt_ct_tg_check+0x814/0xa90 net/netfilter/xt_CT.c:226
Code: c7 c7 c0 a7 e6 8c e8 eb 33 3e f7 e9 12 ff ff ff e8 01 4b dc f7 48 c7 c7 40 a8 e6 8c 4c 89 ee e8 d2 33 3e f7 e9 f9 fe ff ff 90 <0f> 0b 90 4c 89 e0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 e7 e8 73
RSP: 0018:ffffc900036ef6e0 EFLAGS: 00010282
RAX: ffff88812063bd10 RBX: 1ffff920006ddee4 RCX: 0000000000000010
RDX: ffff88812063bd00 RSI: 0000000000000002 RDI: 0000000000000002
RBP: ffffc900036ef7b0 R08: ffffffff90316c23 R09: 1ffffffff2062d84
R10: dffffc0000000000 R11: fffffbfff2062d85 R12: ffff88812063bd10
R13: 00000000fffffffe R14: ffff888113ee1800 R15: dffffc0000000000
FS:  00007fd41ea436c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd41da72780 CR3: 0000000175cc8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xt_checkentry_target net/netfilter/x_tables.c:1115 [inline]
 xt_check_target+0x61a/0xca0 net/netfilter/x_tables.c:1138
 check_target net/ipv4/netfilter/ip_tables.c:510 [inline]
 find_check_entry net/ipv4/netfilter/ip_tables.c:552 [inline]
 translate_table+0x1881/0x2110 net/ipv4/netfilter/ip_tables.c:716
 do_replace net/ipv4/netfilter/ip_tables.c:1137 [inline]
 do_ipt_set_ctl+0x9f5/0xe00 net/ipv4/netfilter/ip_tables.c:1635
 nf_setsockopt+0x26f/0x290 net/netfilter/nf_sockopt.c:101
 do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2381
 __sys_setsockopt net/socket.c:2406 [inline]
 __do_sys_setsockopt net/socket.c:2412 [inline]
 __se_sys_setsockopt net/socket.c:2409 [inline]
 __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2409
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd41db9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd41ea43028 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fd41de15fa0 RCX: 00007fd41db9ce59
RDX: 0000000000000040 RSI: 8001000000000000 RDI: 0000000000000003
RBP: 00007fd41dc32d6f R08: 00000000000002a8 R09: 0000000000000000
R10: 0000200000001500 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fd41de16038 R14: 00007fd41de15fa0 R15: 00007ffdb7f510f8
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

The email will later be sent to:
[netfilter-devel@vger.kernel.org pablo@netfilter.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

