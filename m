Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEA337F74C
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 05:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786080494; cv=none; b=il8to+MJA6cypgq2AIvJfrwQPXSXHn//QBA3I3APZDy6Odgzprey3b1XbDDqjXHcQtbRZoy9xeinpBv2BbIDBe5gjdrY+tlSca7JYodFNsdGzde5eMb+8Mq51oRuSVYbTaGK7siSqIrwEVBPErZpQRb1ibaeJolXaLDktAPweZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786080494; c=relaxed/simple;
	bh=qFvp4uTofHAGTkfOnJ0T+NM7iIzp2wiRIOn9DUfpOUw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=rHxIEFQm1Jb7AHxf1eQkDgKxdvu0xnFbuAwdKSdWfUXNLAlTGXmKGAgwfIuVa4CVkdSvaGWRzTQq9KGubyvLVsqKef2IiJRSDbfdQmY6Q9PL2fDJmtKBi2RSwyqirVTCYL4unrm6cipxlVqnkBZz8cAb9yyEEpwDt2wnG2a9qhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-49aa4525b82so2906529b6e.1
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 22:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786080490; x=1786685290;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TvTYXt+JOaan37lriLTI6Cyp2pGjz3SyqEWd9qAwVQU=;
        b=nzi88uDnk0J4KNJqAaRVe+HxFMQjeSkQNYn8F9x2/KJ8H2a6ykyrWe0ZdrCNuvIfZQ
         EnbT1zlnpuC5UqwguyMjPsm0iavvPwRVmy75wYLjitlCb4blrLspcR1Xw/N1H64x8lxz
         Y4gsVll6IwSDRLDK3RtyaJx4JlJzMKAM46PIcrqGvaSm6Bb/6J4layxxerqCf4YS48I4
         BjAiiID9upscXZNXQdTEpK9u1g6qB8cPOmlFwLVREBnFhDpilABXfqwaEV1mRb1TMNGZ
         STFO6fbiCvyDBoNgfbi0UHC5eEY6yDL2UwLCdarRm/ysRkRtW6zTzrvf2bV62DF+r6mL
         RBCA==
X-Gm-Message-State: AOJu0YwPF/FtoPBLMDMNZeGd7EHQ4vWfIgraFhlEw1XARmMA4ameXx4d
	5PD1VOnywlIywwFGrvyjjWTZemcpOwAsqYAQCIYrHCia90Fv/mZVpOK1Lv4EJz1gxon/T70qdUG
	i3JGaVClhJSpBKKRyRlkjtaflPVVCJ+iC8oZ51UdrSPp8zSk0Zfe2x6tkurg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c89:b0:6ae:4ff6:8d99 with SMTP id
 006d021491bc7-6ae96f658cemr10227803eaf.26.1786080490002; Thu, 06 Aug 2026
 22:28:10 -0700 (PDT)
Date: Thu, 06 Aug 2026 22:28:09 -0700
In-Reply-To: <20260807002250.1817498-1-antonio@openvpn.net>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a756ce9.01d0871a.3a0d52.003b.GAE@google.com>
Subject: [syzbot ci] Re: pull request: fixes for ovpn 2026-08-07
From: syzbot ci <syzbot+cifb58fcbd8413e765@syzkaller.appspotmail.com>
To: andrew@lunn.ch, antonio@openvpn.net, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, ralf@mandelbit.com, sd@queasysnail.net
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] pull request: fixes for ovpn 2026-08-07
https://lore.kernel.org/all/20260807002250.1817498-1-antonio@openvpn.net
* [PATCH net 1/4] ovpn: fix NULL dereference when killing missing key
* [PATCH net 2/4] ovpn: finish crypto callback cleanup before peer release
* [PATCH net 3/4] ovpn: run deferred work on a module-owned workqueue
* [PATCH net 4/4] ovpn: defer key slot crypto freeing to workqueue

and found the following issue:
WARNING in __alloc_workqueue

Full report is available here:
https://ci.syzbot.org/series/a46f06c7-f8d8-4053-a746-91498a46c290

***

WARNING in __alloc_workqueue

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      594d905195024b228c962627ae5ae7c17bd582a4
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/cc426b49-07b7-496e-badf-5b0646780dd0/config

usbcore: registered new interface driver udl
bochs-drm 0000:00:01.0: vgaarb: deactivate vga console
[drm] Found bochs VGA, ID 0xb0c5.
[drm] Framebuffer size 16384 kB @ 0xfd000000, mmio @ 0xfebf0000.
[drm] Initialized bochs-drm 1.0.0 for 0000:00:01.0 on minor 2
bochs-drm 0000:00:01.0: [drm] fb1: bochs-drmdrmfb frame buffer device
usbcore: registered new interface driver gm12u320
usbcore: registered new interface driver gud
brd: module loaded
loop: module loaded
zram: Added device: zram0
null_blk: disk nullb0 created
null_blk: module loaded
Guest personality initialized and is inactive
VMCI host device registered (name=vmci, major=10, minor=267)
Initialized host personality
usbcore: registered new interface driver rtsx_usb
lpc_ich 0000:00:1f.0: I/O space for GPIO uninitialized
usbcore: registered new interface driver viperboard
usbcore: registered new interface driver dln2
usbcore: registered new interface driver pn533_usb
nfcsim 0.2 initialized
usbcore: registered new interface driver port100
usbcore: registered new interface driver nfcmrvl
Loading iSCSI transport class v2.0-870.
st: Version 20160209, fixed bufsize 32768, s/g segs 256
ACPI: \_SB_.GSIA: Enabled at IRQ 16
ahci 0000:00:1f.2: AHCI vers 0001.0000, 32 command slots, 1.5 Gbps, SATA mode
ahci 0000:00:1f.2: 6/6 ports implemented (port mask 0x3f)
ahci 0000:00:1f.2: flags: 64bit ncq only 
scsi host0: ahci
scsi host1: ahci
scsi host2: ahci
scsi host3: ahci
scsi host4: ahci
scsi host5: ahci
ata1: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2100 irq 26 lpm-pol 1
ata2: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2180 irq 26 lpm-pol 1
ata3: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2200 irq 26 lpm-pol 1
ata4: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2280 irq 26 lpm-pol 1
ata5: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2300 irq 26 lpm-pol 1
ata6: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2380 irq 26 lpm-pol 1
Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
slram: not enough parameters.
ftl_cs: FTL header not found.
wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
------------[ cut here ]------------
workqueue: ovpn is using neither WQ_PERCPU or WQ_UNBOUND. Setting WQ_PERCPU.
WARNING: kernel/workqueue.c:5852 at __alloc_workqueue+0x1cf5/0x2060, CPU#0: swapper/0/1
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__alloc_workqueue+0x1cf8/0x2060
Code: 38 00 e9 59 f9 ff ff e8 46 96 38 00 e9 26 fb ff ff e8 3c 96 38 00 e9 a7 fb ff ff e8 32 96 38 00 48 8d 3d fb a1 cc 0e 4c 89 f6 <67> 48 0f b9 3a 81 cd 00 01 00 00 e9 a7 e5 ff ff e8 13 96 38 00 48
RSP: 0000:ffffc900000677a8 EFLAGS: 00010293
RAX: ffffffff818e8c5e RBX: 0000000000000000 RCX: ffff888102a95940
RDX: 0000000000000000 RSI: ffff88810c4cf570 RDI: ffffffff905b2e60
RBP: 0000000000000000 R08: ffff888102a95940 R09: 0000000000000002
R10: 0000000000000102 R11: 0000000000000000 R12: ffffc900000678c0
R13: ffff88810c4cf400 R14: ffff88810c4cf570 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88818d934000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e946000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 alloc_workqueue_noprof+0xe3/0x210
 ovpn_init+0x1b/0xb0
 do_one_initcall+0x250/0x870
 do_initcall_level+0x10a/0x1a0
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x29d/0x3e0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
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
