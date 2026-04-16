Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472A022D4E9
	for <syzbot@lists.linux.dev>; Thu, 16 Apr 2026 05:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776316389; cv=none; b=GX8U5EIH4uV8ZHlNn631n7OuzsiTMlUdmeIq1bQrAO42RQUx+Q1UYblpG7RU0WWh31bGrZwnjROf05FPezRufeW+KlOyebId3DS49ycszAAvH97bZ7eYSazT5nMR/e31gFLE1Q9+zQ7vXQHWdCAfDNU56UVsB4tY7DHNUTNpaBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776316389; c=relaxed/simple;
	bh=9c9BmLaBlZOcSiZF9s7LEqgUZ3//qUZCDQmu+Qx1TGk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=QY6HXN70Z4QRWETWqlBtK66eYfwjwtYpDKj5xOW+bW3yxtwjKNR6ha7xhYCxoswxVHSDcnz/IIj7nGZH7SpnOUDl7TVlN7apPeNVwxF4ZnhkgR4X1gN3YQvvPG5qc+lH5RH6BPuKvbJqatJT0tPDJhSwo6DKQO+5c4NE4gX3Mkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-68ca9de3a6dso7861443eaf.1
        for <syzbot@lists.linux.dev>; Wed, 15 Apr 2026 22:13:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776316387; x=1776921187;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dZ3sbzJxRbUjQJLJGXW0VjWD/nWHowCdNNv6Rtl7h+0=;
        b=Yfiw37lasmLobWj7iYbxvMVGBRdhOrH5aV2UtOxwqhD345Qx/TxbKQ7bNIwUSxnhKF
         xnrP7CHEgJXUnqcE+kBcdKH6sZNO2btLPQo6sTRkRTLZtx3Y404dIKNCictouOMyBZAm
         zzJmSASNvXjSTN69ZVjxPeoyCwGZzQNGLsZsQ2TLrR8XMYPab98001+NdQuOd1ssS+RB
         +l4zIg8L+Z6YuxC3ldfM//4GGpHxi6tMYDnh+I2pKXuQRZegwwQkQsilnUZ0jcdC8caS
         Jy1xoPmFTPuYoat+O+tSp2zC8ICUzZ3QvYHHIA98Em2nZc8AuIYh2Gcj5Hj5u+QnUIjQ
         M7lw==
X-Gm-Message-State: AOJu0Yy1F2NwZz2ZtmqNi+L24LSClgyiUr/Nacr3vORPCmARXL8wjX2h
	XxGXm1ROFpZ6sWyEnuhAeanbd9P0LUvRih7xkGnn8hX0ODGFZCCi3CRkZGHMEuSs5AD2yO8EGMB
	niF/OiYMEiNYCFvmJk2n0t9iRrtiIcXswuV7adLqHWck+8NWrDTd5zOBKX0s=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6586:b0:67e:3ee6:d76f with SMTP id
 006d021491bc7-68be85d8950mr9045995eaf.47.1776316387199; Wed, 15 Apr 2026
 22:13:07 -0700 (PDT)
Date: Wed, 15 Apr 2026 22:13:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e06fe3.a00a0220.8f24c.0176.GAE@google.com>
Subject: [moderation/CI] Re: net: tunnel: fix stale transport header after
 GRE/TEB decap
From: syzbot ci <syzbot+ci7355195b2024957a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: tunnel: fix stale transport header after GRE/TEB decap
https://lore.kernel.org/all/20260416034610.8873-1-jiayuan.chen@linux.dev
* [PATCH net v1 1/2] net: tunnel: fix stale transport header after GRE/TEB =
decap
* [PATCH net-next v1 2/2] net: add DEBUG_NET_WARN_ON_ONCE for negative tran=
sport offset

and found the following issue:
WARNING in udpv6_err

Full report is available here:
https://ci.syzbot.org/series/3886f2f1-a6d5-4c5c-8dc8-bc1cec577567

***

WARNING in udpv6_err

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      1f5ffc672165ff851063a5fd044b727ab2517ae3
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/06cf41a2-60fe-4f9b-8f68-57eb6d1e48c=
c/config

------------[ cut here ]------------
off < 0
WARNING: ./include/linux/skbuff.h:3239 at udpv6_err+0x1521/0x16d0, CPU#0: k=
worker/u9:2/51
Modules linked in:

CPU: 0 UID: 0 PID: 51 Comm: kworker/u9:2 Not tainted syzkaller #0 PREEMPT(f=
ull)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: wg-kex-wg0 wg_packet_handshake_send_worker

RIP: 0010:udpv6_err+0x1521/0x16d0
Code: f7 b0 01 89 44 24 30 49 bf 00 00 00 00 00 fc ff df e9 ea ef ff ff e8 =
8e f2 66 f7 90 0f 0b 90 e9 2a f9 ff ff e8 80 f2 66 f7 90 <0f> 0b 90 e9 bb f=
9 ff ff e8 72 f2 66 f7 90 0f 0b 90 e9 1a fa ff ff
RSP: 0018:ffffc900000074e0 EFLAGS: 00010246

RAX: ffffffff8a5e6c30 RBX: 0000000080000000 RCX: ffff888106e91d80
RDX: 0000000000000100 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90000007670 R08: ffff88810be30ae0 R09: 000000000000234e
R10: 000000000000003c R11: ffffffff8a5e5710 R12: ffff888116513390
R13: ffff888114c38900 R14: fffffffffffffff8 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88818dc43000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555561513898 CR3: 000000016fad2000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 icmpv6_notify+0x407/0x850
 icmpv6_rcv+0x13b0/0x1d80
 ip6_protocol_deliver_rcu+0xe37/0x1610
 ip6_input_finish+0x191/0x370
 NF_HOOK+0x336/0x3c0
 ip6_input+0x16a/0x270
 NF_HOOK+0x336/0x3c0
 process_backlog+0x7dd/0x1950
 __napi_poll+0xae/0x340
 net_rx_action+0x627/0xf70
 handle_softirqs+0x22a/0x840
 do_softirq+0x76/0xd0
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0xf8/0x130
 wg_socket_send_skb_to_peer+0x16b/0x1d0
 wg_packet_handshake_send_worker+0x203/0x350
 process_scheduled_works+0xb5d/0x1860


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
[davem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.or=
g jiayuan.chen@linux.dev kuba@kernel.org linux-kernel@vger.kernel.org netde=
v@vger.kernel.org pabeni@redhat.com pshelar@nicira.com syzbot@syzkaller.app=
spotmail.com tom@herbertland.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

