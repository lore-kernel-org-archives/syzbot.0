Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2BB279DAD
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 03:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789960305; cv=none; b=a7XmWWcjuWSnqeDgev/r654roiB5+39axXTSVlI7vKuv6veEJJ8PQ8pWH50XI0lshREZKU1Hu9i1+NXwMmqPV0lhUQtUIwr8FZnPwQVF+TEv/OCMaR07B9r2l4PJhqCFzDbTGEYZGKBec2fQO8dWGwoRp2sZg1MmKWeT13VLad0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789960305; c=relaxed/simple;
	bh=zE5aQWnV+dCqVW4nD3efUQl4HwQKG8nYny5sNkR1p/Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=o6U6NMYlUic1e7zGViGtIKBy6dEzuaSG10AB7CHOZ9QRJU+P5rXJHj2FtjlbZAWTncI1cS7HiRkf6ZWIaaKN8XGJVDvmT70zWNpbqQLSOIWY0fMG7PQIAsYvYLzgw3YmqrNEcAWRndycuFkZ5GGLPTwM50bcGI8oA0PSRRnE0EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b2f2b8d88fso4221676b6e.2
        for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 20:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789960303; x=1790565103;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bEm9o5XFk2Ap+Jz8+GP1jKV4jCizWW9gtbeG/zz1z7o=;
        b=jWerXK4MV0Y8mgUa5iOX9cQZUXwJs7fp4IcKbhGVfsmMph5SOW/qExjFhkFp/EzH70
         86V5mUR5XjX5m7VNs6unCXMFGtbvhFbJzY1Nu619VUVoYoX6C83q2XyMfWFwSl5XNtpn
         V4gWm9HdeUj7PrmoqSKqJl2EOyzjKQfkZnP3sif62NYmLkPxRLcPviWUtdRku9Atl84d
         YL0JCC0dp0P99EwAmenFHluu6ETNWbvSk4nPQe5I14OM3rswDUHy2/gdPuiXLq24N4kJ
         mU4ynJtrFqoM2/Rxhm3xZ/5n/S+5oFFU5N0tvz0GCTLaiVilsdLRXNHVpRkr33mzUY/N
         t3VQ==
X-Gm-Message-State: AFuF++k81SM2nkM436HYFw60MNGBed7+y7rnaur769mNEubcJSS3uJM5
	tG9wIhcP3usDOUvUoW12sY6bRwdUT7r6gBKvbX1uXIc/S+AwEbsrQpVD1gRe+9x9ex3KaM7uivR
	JFkWGTy5T2iM96pNnjB/PHAuvyT3rbrUuRYesvLB4jw5fIEdyjiSjqILTPq4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f2b:b0:4c5:238e:b14d with SMTP id
 5614622812f47-4ccf6746423mr12048968b6e.6.1789960302740; Sun, 20 Sep 2026
 20:11:42 -0700 (PDT)
Date: Sun, 20 Sep 2026 20:11:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab0a06e.514bccd6.255447.000c.GAE@google.com>
Subject: [moderation/CI] Re: net: opt loopback into instance locking
From: syzbot ci <syzbot+ci82cbe6e020993733@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: opt loopback into instance locking
https://lore.kernel.org/all/20260918210419.4088201-1-kuba@kernel.org
* [PATCH net-next] net: opt loopback into instance locking

and found the following issue:
WARNING in ipv6_add_dev

Full report is available here:
https://ci.syzbot.org/series/f12bc892-cfa6-4277-beac-794482c9a3f7

***

WARNING in ipv6_add_dev

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      8830e65ed46de41f849eefb8ba227d4852c460f6
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/ae142b5c-beb2-4c41-814c-2cd3e14bdbb0/config

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
u32 classifier
    Performance counters on
    input device check on
    Actions configured
nf_conntrack_irc: The irc conntrack helper is scheduled for removal.
Please contact the netfilter-devel mailing list if you still need this.
The pptp conntrack helper is scheduled for removal.
Please contact the netfilter-devel mailing list if you still need this.
The DCCP match is deprecated and scheduled to be removed in 2027.
Please contact the netfilter-devel mailing list or update your iptables rules
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
gre: GRE over IPv4 demultiplexer driver
ip_gre: GRE over IPv4 tunneling driver
IPv4 over IPsec tunneling driver
Initializing XFRM netlink socket
IPsec XFRM device driver
xfrm_iptfs: IPsec IP-TFS tunnel mode module
NET: Registered PF_INET6 protocol family
------------[ cut here ]------------
debug_locks && !(lock_is_held(&(&dev->lock)->dep_map) != 0)
WARNING: ./include/net/netdev_lock.h:70 at ipv6_add_dev+0xfc1/0x1400, CPU#0: swapper/0/1
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ipv6_add_dev+0xfc1/0x1400
Code: ff ff e8 a2 6e 3a f7 48 8d 3d 6b 56 fd 05 48 c7 c6 80 a2 32 8d ba 80 01 00 00 67 48 0f b9 3a e9 ab f0 ff ff e8 80 6e 3a f7 90 <0f> 0b 90 e9 cb f1 ff ff e8 72 6e 3a f7 48 8d 3d 5b 56 fd 05 48 c7
RSP: 0000:ffffc900000678c0 EFLAGS: 00010293
RAX: ffffffff8a8d6400 RBX: dffffc0000000000 RCX: ffff888102abda00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff90253707 R09: 1ffffffff204a6e0
R10: dffffc0000000000 R11: fffffbfff204a6e1 R12: dffffc0000000000
R13: ffff88810c036000 R14: ffffffff8caa6a10 R15: ffff88810c036008
FS:  0000000000000000(0000) GS:ffff88818d6cd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000eb48000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 addrconf_init+0x8b/0x170
 inet6_init+0x228/0x3f0
 do_one_initcall+0x250/0x870
 do_initcall_level+0x10a/0x1a0
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x29d/0x3e0
 kernel_init+0x22/0x1d0
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

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[andrew@lunn.ch davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

