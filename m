Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CE02135B8
	for <syzbot@lists.linux.dev>; Tue,  4 Nov 2025 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762265948; cv=none; b=Ae2venIPwQK4O8cdr10j2sGJV6R76p1oa50azwlrX+kst8noioHG0B8ZSSTzmXqilnSVEkuj5oOia9aqNGygM5N0A3fvvw07OzMghhyAYUYTy2GY5+v7KSWD6zHdpOJWJm2HT6ig89qO+wYKZoG7OXau6Tptu3eMHJCOuK9ViGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762265948; c=relaxed/simple;
	bh=j4Tb4dfG9NzHJVXOZNLE77iTjBNzYcmxqXI+qiS7rBw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=P9UG+MiY9AP9x7S5yKMD79e2z0cR0dSlcn+PTuvQrYDkyD6E9TikxwkfEfn4bhO8AtummdV9CE+T3Rzz/udGhjpEK+dZe1y9Dx3ob6Un7s3QHa6xW//xAorm1MaJqkuOPZTEMyMdHPyrYurA7t6zTwuJwn1199Dqt5qwM3IKu2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-945a5690cb4so1735121939f.2
        for <syzbot@lists.linux.dev>; Tue, 04 Nov 2025 06:19:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762265943; x=1762870743;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BpvY2/di/sw1iy1bBE0TR101Gi2cbsTH1a4bn85lh4g=;
        b=Bw33fEIYVX04WD3lgJL1m7XfbZUPSne6TWHUyBvb9EDuFFRGyDc/KN4Kc0QXbkN76r
         +I03t97Vw4pkalfwzdyMaYJtUouQz/vR2ab3Enqe5sRTIkByY5S76iyx2SrXAInSINbB
         BC8hczGmvx/b19xu/xycXSFdivD//tz4wCzZiPuP1KOGk5ByOsL3cSIAr3TFDcMtjAqi
         NLKy0iRjLQFo0Co6yZT2b+3bIL3TdUj5ll1Zla+Rm2lhQpjI5kockgWGxpHoX7+6+5E9
         eEJ1dy26PIXoFPPR+xaigEcpEy1HqjLOfwNMVdGU7+6IbHyCUv4b/r3Qx7H9fNu7xgsm
         ze4Q==
X-Gm-Message-State: AOJu0Yym86YbIRIQOvOBurFh2BmnhBGKE6JhzEb8RgcDuPrsdDSoW9tG
	CBoDmU7kl82OFnmVMBKyOqlLrrr52kz7I8dDGCADtCxdur6Lr9tkB4bUAmwJo+6R+buCoYpvdHE
	RfQPLpK+sBlAVOK+3Tq3OwR7G4w1F0uSn/GmzUYjHEbhQY4PQWlCEAOnT2/Y=
X-Google-Smtp-Source: AGHT+IHA2lOS3szW05efMMf+mco8kTXFW5SCyhUvCUlah4Ks4n351EfdBHzjjfJPDI4sutqD9UxcODF7yuA6RJr05OxOnEGKaZHi
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d8d:b0:948:15a2:5807 with SMTP id
 ca18e2360f4ac-94822937e95mr2403785539f.3.1762265941878; Tue, 04 Nov 2025
 06:19:01 -0800 (PST)
Date: Tue, 04 Nov 2025 06:19:01 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690a0b55.050a0220.98a6.00ae.GAE@google.com>
Subject: [moderation/CI] Re: net: gro_cells: Provide lockdep class for
 gro_cell's bh_lock
From: syzbot ci <syzbot+cidb71cd333b549541@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[bigeasy@linutronix.de clrkwllms@kernel.org davem@davemloft.net edumazet@google.com gal@nvidia.com horms@kernel.org kuba@kernel.org linux-rt-devel@lists.linux.dev netdev@vger.kernel.org pabeni@redhat.com rostedt@goodmis.org]

If the report looks fine to you, reply with:
#syz upstream

