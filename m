Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABAB320A0A
	for <syzbot@lists.linux.dev>; Tue,  4 Nov 2025 14:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762266125; cv=none; b=D6jpnZRC2+C2ttcK14DN6QvTYZYu+P/KscttvM3iMuwLlfEG8k2e7cTkjpfJRN59bxmmaYMWixv/DLHzmnddm8lW3ztr8a5BUj8Y/V2jPQRR69QDVH4wmljUnboCVwsydB8ozMEHV0yaXGFGkIkWc/0cLKMTgpHu+zyT7g62Oyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762266125; c=relaxed/simple;
	bh=6jIgJlHnumjsVCvAjEKio5uU/oww1S2wY5/AvwY31AE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=f50mJzS6BW8SGI1I7KsVWB9sH5Jjihkc00uGxRH09irGBg8nrbxx3xrXFkjWuPyrztObLJct9ehJVp7bJyQ9r4ayqAO+tqv6oZIRKKalE79O7wxYB8Hl52FNLBUG8WG+hdEM2XWaQnxyUdSBKkGhDZZ7IEySimsLuK9zWifIli4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-945aa9e086eso592801739f.0
        for <syzbot@lists.linux.dev>; Tue, 04 Nov 2025 06:22:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762266122; x=1762870922;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xKdLwrQmemIG9kw2hdf/eFPzpoxPYGPbZwYFsHinfy0=;
        b=FZZrZbS2vfj+ts92KIVDt2ZQX6FlnyBycyIr1qGfOUDc3W4dg+QC2SWAwt6EUF1ohB
         i62TCJh5WL1Pz1VanRI6QN9GpajN6FcLXwYzmKMmvY5xMdVGOP0pBFFlqG4QrVL1Qx6j
         wxEbK3tFGD26HKl1dh29SzqTfaj1ZE1i/dULK5De/br8UeOuWD6hR+aKZiuWkdgu7ayj
         flDg8DjT7QLZQjtB6aQxKcye03TaLxbDY5oCmOPmMPiLkv5KxAotCsm1Rd8f0d4HEBov
         pTX5mbU613URP8zs5l10zZcd9VNUalfT040uI5Evsrc9g/rEPji4L0row/PB8fvRAazc
         v8WQ==
X-Gm-Message-State: AOJu0YyJc+7xOhFIt2LBW+GBnRFKgHbyqH+xWz5NnHwIhuBpr7EoE6rz
	1oO9r4ZFq03xg7ymZXr6ayeroMUaDuCyW5isKd7jm8w+0zF2GW3iPeif8xymCGAzZpaMmMlHWkM
	+L8YQRWEx5l56eYHbSEC+D6V6uPOJ6SrLl181VzCgJaMleIbhA81fLLv3BqI=
X-Google-Smtp-Source: AGHT+IGMkA7qZdgINA/IHNHUaeFr9++EDZQ4fETaxS4a+tgyecjDBSOY1s6NYOs7jiwUj9LcBLjMa8ChOX9K+YKyAoqyABny5LgN
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1515:b0:940:d833:a83d with SMTP id
 ca18e2360f4ac-9485927e2e9mr542425939f.1.1762266122412; Tue, 04 Nov 2025
 06:22:02 -0800 (PST)
Date: Tue, 04 Nov 2025 06:22:02 -0800
In-Reply-To: <20251104111201.5eBxkOKb@linutronix.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690a0c0a.050a0220.98a6.00b0.GAE@google.com>
Subject: [syzbot ci] Re: net: gro_cells: Provide lockdep class for gro_cell's bh_lock
From: syzbot ci <syzbot+cicbd1a39d13eaaed7@syzkaller.appspotmail.com>
To: bigeasy@linutronix.de, clrkwllms@kernel.org, davem@davemloft.net, 
	edumazet@google.com, gal@nvidia.com, horms@kernel.org, kuba@kernel.org, 
	linux-rt-devel@lists.linux.dev, netdev@vger.kernel.org, pabeni@redhat.com, 
	rostedt@goodmis.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: gro_cells: Provide lockdep class for gro_cell's bh_lock
https://lore.kernel.org/all/20251104111201.5eBxkOKb@linutronix.de
* [PATCH net] net: gro_cells: Provide lockdep class for gro_cell's bh_lock

and found the following issue:
BUG: key ADDR has not been registered!

Full report is available here:
https://ci.syzbot.org/series/487d8c1b-77a3-45c6-af6d-8195d5c60ad7

***

BUG: key ADDR has not been registered!

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      3d18a84eddde169d6dbf3c72cc5358b988c347d0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/45da8225-040a-4fda-9352-295e63030683/config

gb_gbphy: registered new driver usb
asus_wmi: ASUS WMI generic driver loaded
gnss: GNSS driver registered with major 494
usbcore: registered new interface driver gnss-usb
usbcore: registered new interface driver hdm_usb
usbcore: registered new interface driver snd-usb-audio
usbcore: registered new interface driver snd-ua101
usbcore: registered new interface driver snd-usb-usx2y
usbcore: registered new interface driver snd-usb-us122l
usbcore: registered new interface driver snd-usb-caiaq
usbcore: registered new interface driver snd-usb-6fire
usbcore: registered new interface driver snd-usb-hiface
usbcore: registered new interface driver snd-bcd2000
usbcore: registered new interface driver snd_usb_pod
usbcore: registered new interface driver snd_usb_podhd
usbcore: registered new interface driver snd_usb_toneport
usbcore: registered new interface driver snd_usb_variax
drop_monitor: Initializing network drop monitor service
NET: Registered PF_LLC protocol family
GACT probability on
Mirror/redirect action on
Simple TC action Loaded
netem: version 1.3
u32 classifier
    Performance counters on
    input device check on
    Actions configured
nf_conntrack_irc: failed to register helpers
nf_conntrack_sane: failed to register helpers
nf_conntrack_sip: failed to register helpers
xt_time: kernel timezone is -0000
IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
IPVS: ipvs loaded.
IPVS: [rr] scheduler registered.
IPVS: [wrr] scheduler registered.
IPVS: [lc] scheduler registered.
IPVS: [wlc] scheduler registered.
IPVS: [fo] scheduler registered.
IPVS: [ovf] scheduler registered.
IPVS: [lblc] scheduler registered.
IPVS: [lblcr] scheduler registered.
IPVS: [dh] scheduler registered.
IPVS: [sh] scheduler registered.
IPVS: [mh] scheduler registered.
IPVS: [sed] scheduler registered.
IPVS: [nq] scheduler registered.
IPVS: [twos] scheduler registered.
IPVS: [sip] pe registered.
ipip: IPv4 and MPLS over IPv4 tunneling driver
BUG: key ffff88816c216e68 has not been registered!
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:4976 lockdep_init_map_type+0x241/0x380
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:lockdep_init_map_type+0x241/0x380
Code: 75 cd 90 e8 21 dc e8 02 85 c0 74 22 83 3d 2a c9 df 0d 00 75 19 90 48 c7 c7 36 2e 8f 8d 48 c7 c6 93 c8 7e 8d e8 00 dd e5 ff 90 <0f> 0b 90 90 65 48 8b 05 93 fc d0 10 48 3b 44 24 08 0f 85 14 01 00
RSP: 0000:ffffc900000672a8 EFLAGS: 00010246
RAX: 40a598123e634300 RBX: ffffe8fee481dde8 RCX: ffff888102688000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba650 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88816c216e68 R15: ffffe8fee481dde8
FS:  0000000000000000(0000) GS:ffff88818eb3c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000dd38000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 gro_cells_init+0x26c/0x380
 ip_tunnel_init+0xc9/0x650
 register_netdevice+0x6bf/0x1ae0
 __ip_tunnel_create+0x3e7/0x560
 ip_tunnel_init_net+0x2ba/0x800
 ops_init+0x35c/0x5c0
 register_pernet_operations+0x336/0x800
 register_pernet_device+0x2a/0x80
 ipip_init+0x1d/0xd0
 do_one_initcall+0x236/0x820
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x334/0x4b0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x4bc/0x870
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
