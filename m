Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18481155747
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 03:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961056; cv=none; b=Tsy2sGdlDwUhqIhyQgQaOW2WLpV6lL98uWesIKllse/vguGq2bdEVc2Pu5Zjm8On23BF2v83tSTPJ4gB+2JlTpd1RG/iTpRH/w6eQmMrY8LUgyKBIhCbB/G702bfcUVwc9QxcAKGt9gLTseXXLgYlgdf0+2NxXErYzFIEFVZDhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961056; c=relaxed/simple;
	bh=Q/3/5Nx5FM48RTGX6txObAhBKRMQKcQXI809YkxxirY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=MTurBmuZm661AZPFM7r5ECTyKrHEywvcUQXBelXCoVUvl01s6Ph61XYAL2iYhN1IjOS6GoQE+kjfg+ST42vFD7rmN2G+49bDJwk9njB5IU3YA+IfMUvsmr+9Lbzt/pPdn7rvinkjgONQTX3+dahTWMLLmHNmXz9g+NRdA3Ez0b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7f4e9fe8b17so3104538a34.1
        for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 20:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789961054; x=1790565854;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wJ3hMGw7iw6O9BkY5HoyPwy1BTyJgCiMk7aL5MnnWMw=;
        b=ycOA+LQl85DBAPIrcdtp80H0RxMu9ln3OuhG/f+HhveIqg9Q2SYm5PsahmS6wMoXS5
         kz620xlHMd8Y+Kij7oJaN7Z3WOmrTNuVNVnmhukNzoGPLjSjLZECqtPOOh3tveii7W1G
         OdUeAWEhIIycjlhea8w347SIbDDTwhrYKfpd2RLdPnp2xK0STjhIKQ/sW1EMfbZu9fPu
         JneEAfpxPxh049V7noYnS80Y/FmdQa/kCfFdxPPnFdz7Pn8W23prVMP9i8/l+CFB2QYE
         N9fJFnUIrAQ8pomrPoEtoG7VoDIWDkjSVnV7hMh9EqK1qGyNo50RNjWxESND83O0gZuC
         zoCg==
X-Gm-Message-State: AFuF++mvzQh89RkyICu8UFjCEP5V4LzZCE18YuV7IChZRHw1Pq/e7OWV
	vvrxGyhN+CMFnT2hG5iqyTMIcUT8XxWQ8URnc9zRYyrmsUYxlxXXLdynb+xYK5/PVAGZblTUcmJ
	a/TRECUndkJMOkbg+7szBTpFpgnhf1wzt5eDnU4l7Pt6OOELzM4VGL52Gbzo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d0a:b0:6cd:3ffc:acfc with SMTP id
 006d021491bc7-6cd3ffcef09mr6027448eaf.76.1789961053959; Sun, 20 Sep 2026
 20:24:13 -0700 (PDT)
Date: Sun, 20 Sep 2026 20:24:13 -0700
In-Reply-To: <20260918210419.4088201-1-kuba@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab0a35d.71f81b7d.15fa6d.001f.GAE@google.com>
Subject: [syzbot ci] Re: net: opt loopback into instance locking
From: syzbot ci <syzbot+ci721ed44e87a0b71e@syzkaller.appspotmail.com>
To: andrew@lunn.ch, davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
