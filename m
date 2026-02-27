Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F4D1A3154
	for <syzbot@lists.linux.dev>; Fri, 27 Feb 2026 18:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772216253; cv=none; b=l6FNBVGoY1wQ7E+TrhjW3Pgft0c7SLeeB8OcVVIgRkM9gaiE4U0VPJZEXa8U1G4AoIebIxiyBAEvO5TnM7jziuE/Ja8gkCauvsXHjX5Lif5xiqfdekVc1qxxez06y6XtMII2Blh4wTdYScya1HI+VjehE06ZQka+DcbKbmktEmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772216253; c=relaxed/simple;
	bh=soH6hV39L2gYKnYnP51JdCHxKqu1FO0ZeD+n5rTN3/U=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=lMR1TCtkJo31noTDC62PSJK/LCYgyi3WCZ+JkyipBqKMKJyqcww4eNjyANRzaW9qnmQt48dXDj2EzSD/+NvvSQz/2P3xXXde6VmvkkyZDJFbVckVFauUl52GftYLzjHEDucSVWg/F5CGQkjhjdjecrG/yFDLuOiT8OVVpN9grmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-45f0bfd68a3so13473996b6e.3
        for <syzbot@lists.linux.dev>; Fri, 27 Feb 2026 10:17:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772216251; x=1772821051;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pBJiS8fxCtqRyQn4T4iQGdcpPcYBpoLg1KEwDHKMuJA=;
        b=wdccMkSh7nDz5qSIu+uN/s8x3fiSd5nwT3KwGGw4IcyAadbMwR3Vk3DXuCXA6aVmkN
         vx7R0MbS89TPuAdETNKmgAb5FAArsEvvmENJoMlH0YUoSSRqwjnIFoifDF5qwEkriNYQ
         fg4GHIprtpmst/8g0R7oamYmwzcirwm9Os+eaV9sxZIRoXrqjmfDSPPB1QxvAR5Fd/Js
         mumpNF/QQFW44ZkEdV/AoBKEl86fbZHakbU5xdZXUYxHn6RwTNZehtCDzhOCqZfK5T39
         X5+t1BY6c4I72d2k/PtzdhH9o2M5dzbnCh9lDurrEEk7QEvDd8KoSNLc9TR5eo3hAu7W
         1PcQ==
X-Gm-Message-State: AOJu0Yw48FUGY/0dDAy6q/LEwIadHs1KDVsVUo5G16wodVCyXUyNN19/
	Dxz1lI2XBpEFDRnDGjtvTHR8iSUeZdtUgfpmWuhhGiElfdeMqym6WHDT8OzkJEOVaycHCODDJWC
	DKN/9TqOp+aCuZQIx4L0zRc4Dff43n+5zfj0eGupCyb4jFYnQzaQYH8nlsxA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8189:b0:675:2e2e:569c with SMTP id
 006d021491bc7-679fae11f43mr2370432eaf.25.1772216250636; Fri, 27 Feb 2026
 10:17:30 -0800 (PST)
Date: Fri, 27 Feb 2026 10:17:30 -0800
In-Reply-To: <20260226201600.222044-1-alice.kernel@fastmail.im>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a1dfba.050a0220.3a55be.0026.GAE@google.com>
Subject: [syzbot ci] Re: BIG TCP for UDP tunnels
From: syzbot ci <syzbot+ci3edea60a44225dec@syzkaller.appspotmail.com>
To: alice.kernel@fastmail.im, alice@isovalent.com, andrew@lunn.ch, 
	daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, fw@strlen.de, gal@nvidia.com, horms@kernel.org, 
	kuba@kernel.org, lucien.xin@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, razor@blackwall.org, shuah@kernel.org, 
	stfomichev@gmail.com, willemdebruijn.kernel@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] BIG TCP for UDP tunnels
https://lore.kernel.org/all/20260226201600.222044-1-alice.kernel@fastmail.im
* [PATCH net-next v2 01/12] net/sched: act_csum: don't mangle UDP tunnel GSO packets
* [PATCH net-next v2 02/12] udp: gso: Simplify handling length in GSO_PARTIAL
* [PATCH net-next v2 03/12] geneve: Fix off-by-one comparing with GRO_LEGACY_MAX_SIZE
* [PATCH net-next v2 04/12] net: Use helpers to get/set UDP len tree-wide
* [PATCH net-next v2 05/12] net: Enable BIG TCP with partial GSO
* [PATCH net-next v2 06/12] udp: Support gro_ipv4_max_size > 65536
* [PATCH net-next v2 07/12] udp: Support BIG TCP GSO packets where they can occur
* [PATCH net-next v2 08/12] udp: Validate UDP length in udp_gro_receive
* [PATCH net-next v2 09/12] udp: Set length in UDP header to 0 for big GSO packets
* [PATCH net-next v2 10/12] vxlan: Enable BIG TCP packets
* [PATCH net-next v2 11/12] geneve: Enable BIG TCP packets
* [PATCH net-next v2 12/12] selftests: net: Add a test for BIG TCP in UDP tunnels

and found the following issue:
WARNING in l2tp_xmit_skb

Full report is available here:
https://ci.syzbot.org/series/8de1e666-84bd-4f74-b980-539c4b651492

***

WARNING in l2tp_xmit_skb

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      fd6dad4e1ae296b67b87291256878a58dad36c93
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f58ab8e4-fdf3-4b35-8063-129b877f1ed8/config
C repro:   https://ci.syzbot.org/findings/a09a9cb9-7ad3-49ee-8662-3581bd42cd46/c_repro
syz repro: https://ci.syzbot.org/findings/a09a9cb9-7ad3-49ee-8662-3581bd42cd46/syz_repro

------------[ cut here ]------------
len >= 65536u
WARNING: ./include/linux/udp.h:38 at udp_set_len_short include/linux/udp.h:38 [inline], CPU#1: syz.0.17/5957
WARNING: ./include/linux/udp.h:38 at l2tp_xmit_core net/l2tp/l2tp_core.c:1293 [inline], CPU#1: syz.0.17/5957
WARNING: ./include/linux/udp.h:38 at l2tp_xmit_skb+0x1204/0x18d0 net/l2tp/l2tp_core.c:1327, CPU#1: syz.0.17/5957
Modules linked in:
CPU: 1 UID: 0 PID: 5957 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:udp_set_len_short include/linux/udp.h:38 [inline]
RIP: 0010:l2tp_xmit_core net/l2tp/l2tp_core.c:1293 [inline]
RIP: 0010:l2tp_xmit_skb+0x1204/0x18d0 net/l2tp/l2tp_core.c:1327
Code: 0f 0b 90 e9 21 f9 ff ff e8 e9 05 ec f6 90 0f 0b 90 e9 8d f9 ff ff e8 db 05 ec f6 90 0f 0b 90 e9 cc f9 ff ff e8 cd 05 ec f6 90 <0f> 0b 90 e9 de fa ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 4f
RSP: 0018:ffffc90003d67878 EFLAGS: 00010293
RAX: ffffffff8ad985e3 RBX: ffff8881a6400090 RCX: ffff8881697f0000
RDX: 0000000000000000 RSI: 0000000000034010 RDI: 000000000000ffff
RBP: dffffc0000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520007acf00 R12: ffff8881baf20900
R13: 0000000000034010 R14: ffff8881a640008e R15: ffff8881760f7000
FS:  000055557e81f500(0000) GS:ffff8882a9467000(0000) knlGS:0000000000000000
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
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
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
