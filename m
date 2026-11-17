Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794945939;
	b=z3xHea4IlpWtjVScrRQ2V3yIeXB/B5/IUrWYDoK637txMYQTWcQ7kKC4kp0gy+FkkfUI
	 T/KOm6BTEJ3R2Ne/tYh2aHL9J+lVnluNR5M89wqu9jjTh+AUGwW9talYJSEWXJW24A0mi
	 8vPtYdC9HTfcn/KGrDAMFY24/KVeJxIWn7N9lseCG1qNhz61tfl94ktWHHeoSfCGmndF9
	 0AWmC3WKW9LBM7jZ53cPoBemJ5hf+SVs0HkvF45vpEne0aN3MWqnKt6tKpExD9A2Y0fH+
	 hrFV9cgLGX+lBZtwys9BCNMcELIEKqYlBZLMhRUEr5X9Ou/Ggb+Wr3duXKCK+jXyS4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794945939;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=BZtm9sHyiktDYCnGeG1o6io6Mc88A5AWr/6VU3Ebv6k=;
	b=MSqHaCI6EJ3HZW5SgWUfPPfAcFgZ6VvpiJx+w7hrIxtK+XUPoST3evnhh1oDsFWocdcM
	 YZrNmWNbC8dBi/qdBQjP7wr61v5DhbwVgpb/chccWkSYtPb9sX2dzg2/7LSil4dLo10u1
	 vuwXJpURCqbs/v5iYrfv5EwShqGlgWPe/vjty3tQ+h66mE1NVBNjhv6dmviWPIdNwoh3/
	 aX6Qh3Vl1pEB4d1oWoPK5WsPVBFN8rjWoVNdAaHZqE0i+Kv4wuPO3ZY3+WpjmMwTMrZOd
	 q7F3S2rau1kk8W7SDBjBoqRT2Uv3QSk56O5mHrcO4YuMYLQf9MutOgTvK+gwESb8fgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B5C60A3818
	for <syzbot@lists.linux.dev>; Tue, 17 Nov 2026 20:05:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73B5C60A3818
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-567e742f481so74061b6e.3
        for <syzbot@lists.linux.dev>; Tue, 17 Nov 2026 12:05:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794945938; x=1795550738;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BZtm9sHyiktDYCnGeG1o6io6Mc88A5AWr/6VU3Ebv6k=;
        b=QsRs7vpdZZLheHSTBkmU+0ogOfqyP6ac/LNSo6eGbGsyD5/PXXZkKs2CyKHlN2uLmB
         796iEHipjN9WupG0I/nx+EhIeRRK1REX4ne64bq9ChFsyb2J6pyiwvorfQ53AzrZERIN
         I+YX4GlTPMBLKvtq0ewji3N4S097Vno+PTMtRmUtUEmLv+6761aE45j/a8zbTZAaDunb
         kkzPO8QicuusZP04YoRRGSrNOyQXBt47Vh3aSu4S9yIBT1gaz2hVYPSLGwCzoJyzUrxi
         E0S7r9RShX70QrL7AxWINCNi9jsdoge5cQELJ8Pb0JNfMTlhbuKiYQJ0jmIzzP1A6Uvm
         SJPA==
X-Gm-Message-State: APuU4Z/XHsO942QHI5RjGVwPNrk/4FywWGgxzo/0nz9p1QUT9pbGpMRZ
	CvtyC8ZMFjPSN3KIZO3glX8HiKDz6cb/cGxHV1p6FcLWcro3jsTE/TFzVagoDm0KGa5BmIkQP34
	vXwwLh81i7ZVu+tQSJ1qZm8w/7iXpJ6X93I2nGrXcgLux8zQKTEZ5zuXy0YU=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5088:b0:4a4:744:a4ff with SMTP id
 5614622812f47-5773db24bc2mr955458b6e.4.1794945938174; Tue, 17 Nov 2026
 12:05:38 -0800 (PST)
Date: Tue, 17 Nov 2026 12:05:38 -0800
In-Reply-To: <20261113102228.1917973-1-shivani.baranwal@oss.qualcomm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afcb392.8f566acc.2517be.0008.GAE@google.com>
Subject: [syzbot ci] Re: wifi: cfg80211/nl80211: add NAN offload support
From: syzbot ci <syzbot+ci70f784aad288583b@syzkaller.appspotmail.com>
To: johannes@sipsolutions.net, kavita.kavita@oss.qualcomm.com, 
	linux-wireless@vger.kernel.org, shivani.baranwal@oss.qualcomm.com, 
	vamsin@qti.qualcomm.com, vganneva@qti.qualcomm.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] wifi: cfg80211/nl80211: add NAN offload support
https://lore.kernel.org/all/20261113102228.1917973-1-shivani.baranwal@oss.qualcomm.com
* [PATCH wireless-next v3 01/19] wifi: nl80211: reject NAN function add/delete when Discovery Engine is in userspace
* [PATCH wireless-next v3 02/19] wifi: nl80211/cfg80211: extend NAN function and configuration for discovery offload
* [PATCH wireless-next v3 03/19] wifi: nl80211/cfg80211: extend NAN match indication for discovery offload
* [PATCH wireless-next v3 04/19] wifi: nl80211/cfg80211: add NAN ranging FTM capability
* [PATCH wireless-next v3 05/19] wifi: nl80211/cfg80211: advertise NAN ranging support
* [PATCH wireless-next v3 06/19] wifi: nl80211/cfg80211: add support for request-based NAN ranging
* [PATCH wireless-next v3 07/19] wifi: nl80211/cfg80211: add support for discovery-based NAN ranging
* [PATCH wireless-next v3 08/19] wifi: nl80211/cfg80211: add ranging results to NAN match event
* [PATCH wireless-next v3 09/19] wifi: nl80211: add NDP offload capability advertisement
* [PATCH wireless-next v3 10/19] wifi: nl80211/cfg80211: add support for NDP initiation in offload mode
* [PATCH wireless-next v3 11/19] wifi: nl80211/cfg80211: add support for NDP response in offload mode
* [PATCH wireless-next v3 12/19] wifi: nl80211/cfg80211: add support for NDP termination in offload mode
* [PATCH wireless-next v3 13/19] wifi: nl80211/cfg80211: add support for NDP request indication
* [PATCH wireless-next v3 14/19] wifi: nl80211/cfg80211: add support for NDP status indication
* [PATCH wireless-next v3 15/19] wifi: nl80211/cfg80211: add support for NDP terminated indication
* [PATCH wireless-next v3 16/19] wifi: nl80211/cfg80211: support updating an offloaded NAN publish function
* [PATCH wireless-next v3 17/19] wifi: nl80211/cfg80211: allow extra NAN attributes in offloaded functions
* [PATCH wireless-next v3 18/19] wifi: nl80211/cfg80211: add NAN group key capabilities to NAN functions
* [PATCH wireless-next v3 19/19] wifi: nl80211/cfg80211: select the 5 GHz NAN channel for IC

and found the following issue:
WARNING in genl_register_family

Full report is available here:
https://ci.syzbot.org/series/51fe1835-2116-4216-afb5-89006d12c38e

***

WARNING in genl_register_family

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      5dbf2415ca9821a611d09308e3b29d2c37e7cd77
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/88ad3d6b-ffda-4626-be13-f0ecdc12abcf/config

Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
NET: Registered PF_ATMPVC protocol family
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
NetLabel:  unlabeled traffic allowed by default
nfc: nfc_init: NFC Core ver 0.1
NET: Registered PF_NFC protocol family
mctp: management component transport protocol core
NET: Registered PF_MCTP protocol family
PCI: Using ACPI for IRQ routing
e820: register RAM buffer resource [mem 0x0009fc00-0x0009ffff]
e820: register RAM buffer resource [mem 0x7ffdf000-0x7fffffff]
pci 0000:00:01.0: vgaarb: setting as boot VGA device
pci 0000:00:01.0: vgaarb: bridge control possible
pci 0000:00:01.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
hpet: 3 channels of 0 reserved for per-cpu timers
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 100.000000 MHz counter
clocksource: Switched to clocksource kvm-clock
VFS: Disk quotas dquot_6.6.0
VFS: Dquot-cache hash table entries: 512 (4096 bytes)
netfs: FS-Cache loaded
CacheFiles: Loaded
TOMOYO: 2.6.0
Mandatory Access Control activated.
AppArmor: AppArmor Filesystem Enabled
acpi PNP0C01:00: Reserved [mem 0xb0000000-0xbfffffff]
pnp: PnP ACPI init
pnp: PnP ACPI: found 4 devices
clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
NET: Registered PF_INET protocol family
IP idents hash table entries: 131072 (order: 8, 1048576 bytes, vmalloc)
tcp_listen_portaddr_hash hash table entries: 4096 (order: 7, 294912 bytes, vmalloc)
Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, vmalloc)
TCP established hash table entries: 65536 (order: 7, 524288 bytes, vmalloc)
TCP bind hash table entries: 65536 (order: 12, 9437184 bytes, vmalloc hugepage)
TCP: Hash tables configured (established 65536 bind 65536)
MPTCP token hash table entries: 8192 (order: 8, 720896 bytes, vmalloc)
UDP hash table entries: 4096 (order: 8, 1048576 bytes, vmalloc)
NET: Registered PF_UNIX/PF_LOCAL protocol family
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp-with-tls transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
------------[ cut here ]------------
i.cmd >= family->resv_start_op && (i.doit.validate || i.dumpit.validate)
WARNING: net/netlink/genetlink.c:581 at genl_register_family+0xc9e/0x17d0, CPU#1: swapper/0/1
Modules linked in:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:genl_register_family+0xc9e/0x17d0
Code: de e8 a6 98 c8 f7 83 fb 01 0f 85 26 0b 00 00 e8 18 95 c8 f7 b0 01 89 44 24 08 4c 8b 7c 24 18 e9 f3 02 00 00 e8 03 95 c8 f7 90 <0f> 0b 90 e9 82 fa ff ff e8 f5 94 c8 f7 4c 8b 7c 24 20 e9 b9 f6 ff
RSP: 0000:ffffc90000067740 EFLAGS: 00010293
RAX: ffffffff89ffd11d RBX: 0000000000000003 RCX: ffff888102aa5a00
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
RBP: ffffc90000067948 R08: ffffc90000067827 R09: 0000000000000000
R10: ffffc90000067800 R11: fffff5200000cf05 R12: ffffc90000067860
R13: ffffc900000677d0 R14: 00000000000000b2 R15: 1ffffffff1cf0d83
FS:  0000000000000000(0000) GS:ffff8882a7c57000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000fb48000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 nl80211_init+0x11/0x50
 cfg80211_init+0x3c/0xe0
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
