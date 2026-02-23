Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A3745BE3
	for <syzbot@lists.linux.dev>; Mon, 23 Feb 2026 05:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771824094; cv=none; b=aifpX+maP/a3C7BfTEYhSdV4RZ0r3wDmBe1qIrn4WGd6eVssGgIF7tgeL/zmPzDET10iqIqci8jNHPCdDo/mAI2TO/GzHp8AjltiZfhCip7UvoC+xAEdHsmtuNrhvoP79mIG8vE/AIs3CLrvBOaYWD5sIKF+jpLcl0PeALgPMa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771824094; c=relaxed/simple;
	bh=rYpTMx6nY6Awge69Y7U3dRxhz5k/bhs4hXgiOlaJF6s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=bhicoZ0wYQ77Tp887YHa4x7galVvFk7a1HgT8TcjceoeSy7xtyRF3CoULxw5BkWdZm5WXFfM4FVffEity3HRhADgcYzK9xMZmGHoJ26fBp/NOkzHaeU0yo9lKCJ9gLIINlSUrcziRDMoUjb7X6ObjNbXOC9gfxlLy/Aub97x8U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-679a409a175so60595686eaf.1
        for <syzbot@lists.linux.dev>; Sun, 22 Feb 2026 21:21:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771824091; x=1772428891;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ebCFX1yI0R+COURPkU3cP42bzc8INakZLi0qzAwt1VI=;
        b=j5IXraeyRlWRUKE3gLcR8Yk3FlT/fsYwC//IcLNdiLINdJqtzSJhYe/bO4GriadsUs
         PzlIj8mf1Z37MKFuFUVY5wds+CheF8zatrPANv0svVSmDmgtXaDV/T7O7S49ksmhS5UY
         cSyhZKm/2/r3pA9NmFy+fAWWo9B3yN5f+VjSDRj6jbtyibMx2c05DoyvubPq/nYyML9S
         w1TFOzzcf7JCkWH+dCGF6mlHL1SQmpy/hwGxcR+cBWJo2LnN/s5T4A1uV0lgTodRrGYV
         fYgGSszRtbBc3AYunPLXErT67gK6RMXdCxoTbovHb+gBK6wwtQD/FwEs1AoTYSqMQt3n
         K5AQ==
X-Gm-Message-State: AOJu0YxCvAp2s8ojgzR7x3x3Y8hinnKe6788PKOLGMV2p64g+4Zl93oN
	dNfG09Y09ZCA0g40ia2QnXWpJIFWZCkcltZQ7qsWDt21rdKz111k1gUxnrboZ5V8U5g2z9cIIaj
	b/qhgL5K3rUYc6NEmGurDWFoEcs9oUfJ9RYhXBps3P51XsYU/GyHdFzhOn5A=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2d02:b0:663:1f2:3e23 with SMTP id
 006d021491bc7-679c466aebamr4557013eaf.24.1771824091325; Sun, 22 Feb 2026
 21:21:31 -0800 (PST)
Date: Sun, 22 Feb 2026 21:21:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <699be3db.050a0220.340abe.0d37.GAE@google.com>
Subject: [moderation/CI] Re: Zero page->private when freeing pages
From: syzbot ci <syzbot+ci20e76ddb05181950@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Zero page->private when freeing pages
https://lore.kernel.org/all/20260223032641.1859381-1-ziy@nvidia.com
* [PATCH v1 01/11] relay: zero page->private when freeing pages
* [PATCH v1 02/11] mm/slub: zero page->private when freeing pages
* [PATCH v1 03/11] drm/ttm: zero page->private when freeing pages
* [PATCH v1 04/11] blk-mq: zero page->private when freeing pages
* [PATCH v1 05/11] watch_queue: zero page->private when freeing pages
* [PATCH v1 06/11] binder: zero page->private when freeing pages
* [PATCH v1 07/11] null_blk: zero page->private when freeing pages
* [PATCH v1 08/11] percpu: zero page->private when freeing pages
* [PATCH v1 09/11] erofs: zero page->private when freeing pages
* [PATCH v1 10/11] mm/huge_memory: add page->private check back in __split_=
folio_to_order()
* [PATCH v1 11/11] mm/page_alloc: check page->private upon page free

and found the following issue:
WARNING in __free_frozen_pages

Full report is available here:
https://ci.syzbot.org/series/10f470ac-46ac-4e38-902d-dc86ae743494

***

WARNING in __free_frozen_pages

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      a6fdc327de4678e54b5122441c970371014117b0
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0586347c-8ef1-427f-8a9c-7f6c08b616a=
9/config

Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
NET: Registered PF_RXRPC protocol family
Key type rxrpc registered
Key type rxrpc_s registered
NET: Registered PF_KCM protocol family
lec:lane_module_init: lec.c: initialized
mpoa:atm_mpoa_init: mpc.c: initialized
l2tp_core: L2TP core driver, V2.0
l2tp_ppp: PPPoL2TP kernel driver, V2.0
l2tp_ip: L2TP IP encapsulation support (L2TPv3)
l2tp_netlink: L2TP netlink interface
l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
NET: Registered PF_PHONET protocol family
8021q: 802.1Q VLAN Support v1.8
sctp: Hash tables configured (bind 32/56)
NET: Registered PF_RDS protocol family
Registered RDS/infiniband transport
Registered RDS/tcp transport
tipc: Activated (version 2.0.0)
NET: Registered PF_TIPC protocol family
tipc: Started in single node mode
smc: adding smcd device lo without pnetid
NET: Registered PF_SMC protocol family
9pnet: Installing 9P2000 support
NET: Registered PF_CAIF protocol family
NET: Registered PF_IEEE802154 protocol family
Key type dns_resolver registered
Key type ceph registered
libceph: loaded (mon/osd proto 15/24)
batman_adv: B.A.T.M.A.N. advanced 2025.5 (compatibility version 15) loaded
openvswitch: Open vSwitch switching datapath
NET: Registered PF_VSOCK protocol family
mpls_gso: MPLS GSO support
IPI shorthand broadcast: enabled
sched_clock: Marking stable (19970046340, 93374727)->(20073238384, -9817317=
)
registered taskstats version 1
Loading compiled-in X.509 certificates
Loaded X.509 cert 'Build time autogenerated kernel key: 98092a222e11368da22=
3b039d625e21c3e2e069c'
zswap: loaded using pool 842
Demotion targets for Node 0: null
Demotion targets for Node 1: null
debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page=
 table helpers
------------[ cut here ]------------
page->private
WARNING: mm/page_alloc.c:1433 at __free_frozen_pages+0x78e/0xe10, CPU#0: sw=
apper/0/1
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__free_frozen_pages+0x78e/0xe10
Code: 5f 5d e9 05 1e 00 00 48 b8 00 00 00 00 00 fc ff df 0f b6 44 05 00 84 =
c0 0f 85 d7 02 00 00 c7 03 ff ff ff ff e9 22 fc ff ff 90 <0f> 0b 90 e9 8d f=
c ff ff bd 01 00 00 00 83 f8 05 0f 85 bb fe ff ff
RSP: 0000:ffffc900000676e0 EFLAGS: 00010282
RAX: 1ffffd4000bad935 RBX: ffffea0005d6c9a8 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffea0005d6c9b4
RBP: ffffea0005d6c9b8 R08: ffffea0005d6c9b7 R09: 1ffffd4000bad936
R10: dffffc0000000000 R11: fffff94000bad937 R12: ffffea0005d6c980
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88818de64000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e54c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 destroy_args+0x15d/0x570
 debug_vm_pgtable+0x3f8/0x410
 do_one_initcall+0x250/0x8d0
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x2a6/0x3e0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x51e/0xb90
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
[airlied@gmail.com akpm@linux-foundation.org aliceryhl@google.com arve@andr=
oid.com axboe@kernel.dk baohua@kernel.org baolin.wang@linux.alibaba.com bra=
uner@kernel.org christian.koenig@amd.com cl@gentwo.org cmllamas@google.com =
dave@stgolabs.net david@kernel.org dennis@kernel.org dev.jain@arm.com dhava=
le@google.com dlemoal@kernel.org dri-devel@lists.freedesktop.org gregkh@lin=
uxfoundation.org guochunhai@vivo.com hannes@cmpxchg.org harry.yoo@oracle.co=
m jackmanb@google.com jefflexu@linux.alibaba.com johannes.thumshirn@wdc.com=
 katrinzhou@tencent.com kernelxing@tencent.com kprateek.nayak@amd.com lance=
.yang@linux.dev liam.howlett@oracle.com lihongbo22@huawei.com linux-block@v=
ger.kernel.org linux-erofs@lists.ozlabs.org linux-kernel@vger.kernel.org li=
nux-mm@kvack.org lorenzo.stoakes@oracle.com maarten.lankhorst@linux.intel.c=
om matthew.auld@intel.com matthew.brost@intel.com mhiramat@kernel.org mhock=
o@suse.com mripard@kernel.org npache@redhat.com ray.huang@amd.com rientjes@=
google.com roman.gushchin@linux.dev ryan.roberts@arm.com sandeen@redhat.com=
 simona@ffwll.ch surenb@google.com tj@kernel.org tkjos@android.com tzimmerm=
ann@suse.de vbabka@kernel.org xiang@kernel.org zbestahu@gmail.com ziy@nvidi=
a.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

