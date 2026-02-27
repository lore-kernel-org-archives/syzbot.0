Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF0D3803FA
	for <syzbot@lists.linux.dev>; Fri, 27 Feb 2026 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212801; cv=none; b=Pcmvb+R6OhoF/E8ocdDZM31PS/g4p88GuChWAqg8u9x6vO4fV6CHIX6RlETMfbu1T9Lkv+Gk7O8OeXeXIBF4n1unZKC/qQvZDDlcdoQcEChc6zSB+0bfm3JYd3mxNm4S8ifLDbSRgiOaNvn8rH8BoxN1Kb5cNQwmQOQDDCz96DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212801; c=relaxed/simple;
	bh=dRrcaed5arKUxpNpU+Win7YZTl99EuIbExN2i4MrCeg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=V+kVcsWz82K/tzFf0KgbcDah3AJoGBkD0zAF+P87GZ3hwmcxT6cfwh0uTbYB7lozouMrUBud1xFNUHJERXmiZ6WogUh60xzoG0R9QgSXzQDdZ9+QdPOqLMMRFq2ELNU1ga5SyDBeVzSEn4Dh1fB9dBzaT972t4WmnqOo+PtWVdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679e5688b33so17829892eaf.3
        for <syzbot@lists.linux.dev>; Fri, 27 Feb 2026 09:19:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772212798; x=1772817598;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WJ4BkquWrQudkpZJpdybzFuZnl8q0V/ADJQ7gWF70fI=;
        b=K7L6/vWKrPa1Cdii7AOVtra2sxL+CddpOT/VNujxZNPUojYM0d+XhEMtPMfut6g4+p
         yEOYkghFg9bwuBH8CMPQBG/NTa1Rtygxn4sntYdZdOXKbP/OfO2v9GhRtB4DEcKoPRqM
         JdO4CLAG6Zf4iHC4k3fZjnlg6URjwO8njQu2UjCuYghtUhe7D2F/pzf8mHu/xrW0FAIG
         6lIr+9LPmU2lZYAqZK0pXn3Z7TcwRrsb40N94vOokEQ555yYU1xxJMHtACi/3fW63HvK
         uxcGcApf39PxjgQ5oXv2eSw+XM4HsicsBT928At1w12O6ZwCEYSQhUYETELvlAz9zHvn
         964w==
X-Gm-Message-State: AOJu0YxP8g9whGnF1pFkiKS9YSGzizO0/wWFct7zUoGOhsgdUNTd+KHs
	hX2xYEpv/y+goYG1JpVRJBCn0XagHFTmcmW5pMT72unP2Y2LFthrrMbvrk1CXB0H/X3ztE96Scd
	Ws3t9rvuH+vtOk3MYa8Mom35uWgE2R5sSxqmnvchr/F9TUNkaSvC4F4KHfeU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:228a:b0:66f:6d5e:76c3 with SMTP id
 006d021491bc7-679faf197f4mr2158861eaf.42.1772212798260; Fri, 27 Feb 2026
 09:19:58 -0800 (PST)
Date: Fri, 27 Feb 2026 09:19:58 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a1d23e.050a0220.3a55be.0025.GAE@google.com>
Subject: [moderation/CI] Re: BIG TCP for UDP tunnels
From: syzbot ci <syzbot+ci60beb959ea6a7a80@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] BIG TCP for UDP tunnels
https://lore.kernel.org/all/20260226201600.222044-1-alice.kernel@fastmail.i=
m
* [PATCH net-next v2 01/12] net/sched: act_csum: don't mangle UDP tunnel GS=
O packets
* [PATCH net-next v2 02/12] udp: gso: Simplify handling length in GSO_PARTI=
AL
* [PATCH net-next v2 03/12] geneve: Fix off-by-one comparing with GRO_LEGAC=
Y_MAX_SIZE
* [PATCH net-next v2 04/12] net: Use helpers to get/set UDP len tree-wide
* [PATCH net-next v2 05/12] net: Enable BIG TCP with partial GSO
* [PATCH net-next v2 06/12] udp: Support gro_ipv4_max_size > 65536
* [PATCH net-next v2 07/12] udp: Support BIG TCP GSO packets where they can=
 occur
* [PATCH net-next v2 08/12] udp: Validate UDP length in udp_gro_receive
* [PATCH net-next v2 09/12] udp: Set length in UDP header to 0 for big GSO =
packets
* [PATCH net-next v2 10/12] vxlan: Enable BIG TCP packets
* [PATCH net-next v2 11/12] geneve: Enable BIG TCP packets
* [PATCH net-next v2 12/12] selftests: net: Add a test for BIG TCP in UDP t=
unnels

and found the following issue:
WARNING in l2tp_xmit_skb

Full report is available here:
https://ci.syzbot.org/series/8de1e666-84bd-4f74-b980-539c4b651492

***

WARNING in l2tp_xmit_skb

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      fd6dad4e1ae296b67b87291256878a58dad36c93
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f58ab8e4-fdf3-4b35-8063-129b877f1ed=
8/config
C repro:   https://ci.syzbot.org/findings/a09a9cb9-7ad3-49ee-8662-3581bd42c=
d46/c_repro
syz repro: https://ci.syzbot.org/findings/a09a9cb9-7ad3-49ee-8662-3581bd42c=
d46/syz_repro

------------[ cut here ]------------
len >=3D 65536u
WARNING: ./include/linux/udp.h:38 at udp_set_len_short include/linux/udp.h:=
38 [inline], CPU#1: syz.0.17/5957
WARNING: ./include/linux/udp.h:38 at l2tp_xmit_core net/l2tp/l2tp_core.c:12=
93 [inline], CPU#1: syz.0.17/5957
WARNING: ./include/linux/udp.h:38 at l2tp_xmit_skb+0x1204/0x18d0 net/l2tp/l=
2tp_core.c:1327, CPU#1: syz.0.17/5957
Modules linked in:
CPU: 1 UID: 0 PID: 5957 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:udp_set_len_short include/linux/udp.h:38 [inline]
RIP: 0010:l2tp_xmit_core net/l2tp/l2tp_core.c:1293 [inline]
RIP: 0010:l2tp_xmit_skb+0x1204/0x18d0 net/l2tp/l2tp_core.c:1327
Code: 0f 0b 90 e9 21 f9 ff ff e8 e9 05 ec f6 90 0f 0b 90 e9 8d f9 ff ff e8 =
db 05 ec f6 90 0f 0b 90 e9 cc f9 ff ff e8 cd 05 ec f6 90 <0f> 0b 90 e9 de f=
a ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 4f
RSP: 0018:ffffc90003d67878 EFLAGS: 00010293
RAX: ffffffff8ad985e3 RBX: ffff8881a6400090 RCX: ffff8881697f0000
RDX: 0000000000000000 RSI: 0000000000034010 RDI: 000000000000ffff
RBP: dffffc0000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520007acf00 R12: ffff8881baf20900
R13: 0000000000034010 R14: ffff8881a640008e R15: ffff8881760f7000
FS:  000055557e81f500(0000) GS:ffff8882a9467000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000033000 CR3: 00000001612f4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 pppol2tp_sendmsg+0x40a/0x5f0 net/l2tp/l2tp_ppp.c:302
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 sock_write_iter+0x503/0x550 net/socket.c:1195
 do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
 vfs_writev+0x33c/0x990 fs/read_write.c:1059
 do_writev+0x154/0x2e0 fs/read_write.c:1105
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f636479c629
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffffd4241c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007f6364a15fa0 RCX: 00007f636479c629
RDX: 0000000000000001 RSI: 0000200000000080 RDI: 0000000000000003
RBP: 00007f6364832b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6364a15fac R14: 00007f6364a15fa0 R15: 00007f6364a15fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alice.kernel@fastmail.im alice@isovalent.com andrew@lunn.ch daniel@iogearb=
ox.net davem@davemloft.net dsahern@kernel.org edumazet@google.com fw@strlen=
.de gal@nvidia.com horms@kernel.org kuba@kernel.org lucien.xin@gmail.com ne=
tdev@vger.kernel.org pabeni@redhat.com razor@blackwall.org shuah@kernel.org=
 stfomichev@gmail.com willemdebruijn.kernel@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

