Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1664A263C
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 14:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530902; cv=pass; b=NVuW5yVl4yghBLOakVcj660gryI93j9MsuK7MX7O2/uQQcs4PMSOmiEc2Yr/Nlxeassc9ghcCFCtUmOxAmV/9Egm7UeLH9Wa2KCJ7RabvRmT64LNdCcCFQccZ1vtuTa6Gnytfo7JGn6moIqVnoe3J0A8erhEfKqAADbAbAXkVJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530902; c=relaxed/simple;
	bh=LhfyFIy67JGOVmRgtYFVs/+jbKV7tHa9zSdbweD20NU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MpxUiaCoro5z0+eWK7gaMUqHqnvcszvprAn2Jxw9cHKEOXK/ty+WfmlaIOrAVxnvP+EhD9qcnOZsMiuxmp9bIF9MCAflSHlmpKqXDGtNrc2cO/JfCpolyn0RUWkU9CM+kSASLcXwZBHugG13vPXBZ21vbbdDCrjIhzqmw//9uA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=igcvXUnv; arc=pass smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="igcvXUnv"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7f84a55cc06so854379a34.2
        for <syzbot@lists.linux.dev>; Fri, 04 Sep 2026 07:08:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788530899; cv=none;
        d=google.com; s=arc-20260327;
        b=I7xafSEGLg+ynyDmeq1LcXOKZPNAoV/MXf9mZnkkE0khcdPdKjJ0k1zqqR7iVFWhW2
         GgrFweaJfcVbZIyAYl1tt87f0N9nI+23kdIZdYXiX6cObQgD7EkfCoQ4e5K6AE/HQf6r
         jnTF5EJhgZ8mMke9HRqiXHMRUtY0LpUG86h3ANJWeXHC9TSPJPrc12FUxEdW9/I5gPRo
         cCGdUafn8TG0wjuyNaH69KDxGDIiPsIbgD+R2Eu/S4UGDWhUvYxznMyrichOAqeGBW8/
         PEpgEXlqMQE6s1FL9BiSZVVBboBuOrZHi7yJyVukuRXMtaiDLvYXaiPxPVqRFnAHnRXv
         s1cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qUlAvyuJQt5tKl7q+91N5TLkRduNvzwngCQ78ptjVPU=;
        fh=JF3Vpce41HDTw32/rvwjOcLdSGBgy3tX9gHZTAMLvJg=;
        b=l/CIgs9NqpbMTcawQIa44Zeu2bp3XwCVfh3mLim94dcV/HDJeEqWyX27BE4Qx8ZOva
         8nZP9IjuvAhyY+NInNp+bCzrypdYgXqF/iz059imlSb4OKWcJS5+thoqmA+a/NSd2pOM
         VkVNNWNAijWxfScKiPCGE9IPTKlQ+FqqnXLxzvU6vzSqr/ZDQ2FMBfJNQhKJdoPCtNUd
         oxxgA6oYjQAhGdZk4tPJAo+GQIMA46yU/q/OT1Nz/LDec7/ryDkqW0E2P/weGKz2OU2+
         kbHDebVfC9WUE1x5gFKN+8atlTkx5V0cXJ9lWTR7kVQCMZ9zN91ayNXy3MAG+/Z7kKPR
         ZTqA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788530899; x=1789135699; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qUlAvyuJQt5tKl7q+91N5TLkRduNvzwngCQ78ptjVPU=;
        b=igcvXUnvTN+u8bTwzHya/SayjdP37a2bw429NTSFTGTr5rSEMPXqbUkhXnaX52qOgl
         +bisCX5uQ41nCkZfVu1NiG1sFMhIyUS3U9+MdkMMoF5ilUZRJolDeN0fWbNrCPzprbKQ
         HrzaKSMPl2+CQ4BCufpAT3nwczSWlS1IHKirJym48yrj5o8wgCZaBIwLCK31+EeKhGi8
         I9aTU44hzjKRfQY9syfO0rV/RjTG0rvwKWUnEjvpDaK48FVXfYIB0pKSE0qbaZYJ1ypK
         1olP0tcNhKhFpIUVIPzWdD/i8xqodq50ofnlVLj5hD1HifiRp33otnR/s9i1g8cETp5Y
         awdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788530899; x=1789135699;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qUlAvyuJQt5tKl7q+91N5TLkRduNvzwngCQ78ptjVPU=;
        b=p5JfXnxWDfGr2J6Nlf1hGJUsIyL90nKydbvOsNMIQN+tvi9ka4lrF5H7wgpqb72yRh
         4t5H9JLRyVKkocBsT1v1hD2ziAhhCNPxpog2q2UCDYkixi0QHCVxebsZ4uPzUsLfxbaq
         xy8oulS7e/WCAL8Vz3N161j434dS/UYpRh7zy1J97WTLlfkojnT3SSELe76zqesV/StS
         OztyraUZzLwWw5APho/Z25MsCB2nm25S1bicNHsTSdz63WCz88mWUrg3w8dQyadMbtSL
         Qb/EgOFGxda/OqnXc6VM+SozHA7hgLlbMzMuxiNUMFtVsHa6nFii74coqo4lQ/DWQJpe
         DHeA==
X-Forwarded-Encrypted: i=1; AKwUvBzCU/esv3FZqItAnHVBlsTVb9P7VlAS/4lbfCixtdoGEbodtd087jFSleldbWPALQ3CXeNKXN4=@lists.linux.dev
X-Gm-Message-State: AFuF++lgPR8EFSsDLVwXaVfq7VAqwuJuU6rRLWK3mOPOJJ9BuesLIBH6
	CLiQ9kAUQtCdw6FhTMGyhk4rFGyBdRJmZWMzzC/RJHDKXII5CxZpqbSnwAjVzGtVFQ4RjOPR2w9
	daoQKrnW9Qg6d08CIIOb6p9pX3D+J+6nBxafrTJvoZN0VyFLMQsW10RZp
X-Gm-Gg: AYBFou05yEjcaHZr4Y3pT70nmqAPw/z/buwIzf5r7345i7bXPFms7G/6wbv3kmhiE15
	urv8eNOp7/VaavcqjVGty+WAJLIrt+be0pb4eh+ug2cQmfn9Mx8IGsnGIcZ7gW3yUzZXkKqfz4H
	rvFkfxAARBWLOfYQ0VQFGaDnxgHCeIF9JPB9mq4hxBIFBERWBWAkTr890qZ/GE14yDN0PQM+PZ+
	WxjN3bXQDw2GUaOL3WmhyOSnqkDK0G2l9a8hiO6+B+UH3n1IfSCYj0EkNql4aPPvhhp2v7EnInl
	seRZEbMVSbZYEzOq/8HFM6mFxC5mf/i2eVrhijIBqXEW8rrMOMrW0AGNIUBlW78OwaqLCQhJLVx
	nwqMNtgShBYQJMg1WHIz3EOsAFT25G2jCdhMgQGcztpsFMbTNPAhTbdDel514laipZvlwnmI9UI
	naIWPQXL2U8aR1
X-Received: by 2002:a05:6830:83b7:b0:7f4:bd7e:1394 with SMTP id
 46e09a7af769-7fa1e1b786bmr5329752a34.1.1788530898654; Fri, 04 Sep 2026
 07:08:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a9acf21.04649fcc.10325f.0002.GAE@google.com>
In-Reply-To: <6a9acf21.04649fcc.10325f.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 4 Sep 2026 16:08:07 +0200
X-Gm-Features: AcwNN1WLur1o_QSYI_EYOqIccmHoXb3lA5fOMSpASSawKsyahfepVMfgk-g8MGQ
Message-ID: <CANp29Y4iwCeYMpsgVqCpdNKxrHepxie2PjbFHpgWs-Xei-cOXw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bonding: fix slave_cnt leak on XDP error paths
To: syzbot ci <syzbot+ci36ca8a217343eb7d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Sep 4, 2026 at 4:01=E2=80=AFPM syzbot ci
<syzbot+ci36ca8a217343eb7d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] bonding: fix slave_cnt leak on XDP error paths
> https://lore.kernel.org/all/20260903-bond_slave_cnt-v2-1-02e27304ca36@kyl=
inos.cn
> * [PATCH net v2] bonding: fix slave_cnt leak on XDP error paths
>
> and found the following issue:
> KASAN: slab-out-of-bounds Write in bond_update_slave_arr
>
> Full report is available here:
> https://ci.syzbot.org/series/f9a94005-1c91-4312-a91e-f495ce00314a
>
> ***
>
> KASAN: slab-out-of-bounds Write in bond_update_slave_arr
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      70f3995830d3f1e79faa14eb0605914f778feca9
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/767af4fc-83f9-4b54-8f38-27761606a=
652/config
> syz repro: https://ci.syzbot.org/findings/abcea6f7-092c-48e4-8137-756a0ff=
617ba/syz_repro
>
> 8021q: adding VLAN 0 to HW filter on device bond0
> bond1: (slave bond0): making interface the new active one
> =3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in bond_update_slave_arr+0x47c/0xf30 drive=
rs/net/bonding/bond_main.c:5198
> Write of size 8 at addr ffff888115edcc98 by task syz.1.18/5855
>
> CPU: 1 UID: 0 PID: 5855 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  bond_update_slave_arr+0x47c/0xf30 drivers/net/bonding/bond_main.c:5198
>  bond_enslave+0x2c43/0x3b20 drivers/net/bonding/bond_main.c:2337
>  do_set_master+0x563/0x720 net/core/rtnetlink.c:3071
>  do_setlink+0xe7b/0x4670 net/core/rtnetlink.c:3273
>  rtnl_changelink net/core/rtnetlink.c:3905 [inline]
>  __rtnl_newlink net/core/rtnetlink.c:4076 [inline]
>  rtnl_newlink+0x15a3/0x1c30 net/core/rtnetlink.c:4215
>  rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
>  __sock_sendmsg net/socket.c:815 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
>  __sys_sendmsg net/socket.c:2799 [inline]
>  __do_sys_sendmsg net/socket.c:2804 [inline]
>  __se_sys_sendmsg net/socket.c:2802 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5f8df9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5f8ee80028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f5f8e225fa0 RCX: 00007f5f8df9e159
> RDX: 0000000000000000 RSI: 0000200000000240 RDI: 0000000000000006
> RBP: 00007f5f8e035024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5f8e226038 R14: 00007f5f8e225fa0 R15: 00007ffd4eafc2e8
>  </TASK>
>
> Allocated by task 5855:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5414 [inline]
>  __kmalloc_noprof+0x36b/0x720 mm/slub.c:5439
>  _kmalloc_noprof include/linux/slab.h:995 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  bond_update_slave_arr+0x161/0xf30 drivers/net/bonding/bond_main.c:5172
>  bond_enslave+0x2c43/0x3b20 drivers/net/bonding/bond_main.c:2337
>  do_set_master+0x563/0x720 net/core/rtnetlink.c:3071
>  do_setlink+0xe7b/0x4670 net/core/rtnetlink.c:3273
>  rtnl_changelink net/core/rtnetlink.c:3905 [inline]
>  __rtnl_newlink net/core/rtnetlink.c:4076 [inline]
>  rtnl_newlink+0x15a3/0x1c30 net/core/rtnetlink.c:4215
>  rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
>  __sock_sendmsg net/socket.c:815 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
>  __sys_sendmsg net/socket.c:2799 [inline]
>  __do_sys_sendmsg net/socket.c:2804 [inline]
>  __se_sys_sendmsg net/socket.c:2802 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888115edcc80
>  which belongs to the cache kmalloc-32 of size 32
> The buggy address is located 0 bytes to the right of
>  allocated 24-byte region [ffff888115edcc80, ffff888115edcc98)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x115e=
dc
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff888100041780 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000000400040 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 564=
3, tgid 5643 (syz-executor), ts 53054509528
>  set_page_owner include/linux/page_owner.h:33 [inline]
>  post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
>  prep_new_page mm/page_alloc.c:1879 [inline]
>  get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
>  __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
>  alloc_slab_page mm/slub.c:3347 [inline]
>  allocate_slab+0x7d/0x620 mm/slub.c:3462
>  new_slab mm/slub.c:3513 [inline]
>  refill_objects+0x2d5/0x350 mm/slub.c:7410
>  refill_sheaf mm/slub.c:2885 [inline]
>  __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
>  alloc_from_pcs mm/slub.c:4850 [inline]
>  slab_alloc_node mm/slub.c:4984 [inline]
>  __do_kmalloc_node mm/slub.c:5413 [inline]
>  __kmalloc_noprof+0x47b/0x720 mm/slub.c:5439
>  _kmalloc_noprof include/linux/slab.h:995 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  lsm_blob_alloc security/security.c:218 [inline]
>  lsm_sock_alloc security/security.c:4477 [inline]
>  security_sk_alloc+0x52/0x360 security/security.c:4493
>  sk_prot_alloc+0x101/0x210 net/core/sock.c:2254
>  sk_alloc+0x3a/0x390 net/core/sock.c:2307
>  inet6_create+0x81a/0x1270 net/ipv6/af_inet6.c:178
>  __sock_create+0x4b3/0x9d0 net/socket.c:1676
>  inet_ctl_sock_create+0xa2/0x220 net/ipv4/af_inet.c:1639
>  ndisc_net_init+0x95/0x260 net/ipv6/ndisc.c:1977
>  ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
>  setup_net+0x118/0x350 net/core/net_namespace.c:443
> page last free pid 15 tgid 15 ts 53012061369 stack trace:
>  reset_page_owner include/linux/page_owner.h:26 [inline]
>  __free_pages_prepare mm/page_alloc.c:1418 [inline]
>  __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
>  __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
>  tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
>  rcu_do_batch kernel/rcu/tree.c:2650 [inline]
>  rcu_core+0x926/0x1260 kernel/rcu/tree.c:2919
>  handle_softirqs+0x226/0x860 kernel/softirq.c:645
>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1108
>  smpboot_thread_fn+0x565/0xa70 kernel/smpboot.c:160
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff888115edcb80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
>  ffff888115edcc00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
> >ffff888115edcc80: 00 00 00 fc fc fc fc fc 00 00 00 fc fc fc fc fc
>                             ^
>  ffff888115edcd00: 00 00 00 00 fc fc fc fc 00 00 00 fc fc fc fc fc
>  ffff888115edcd80: fa fb fb fb fc fc fc fc 00 00 00 fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [andrew@lunn.ch daniel@iogearbox.net davem@davemloft.net edumazet@google.=
com hangbin.liu@linux.dev joamaki@gmail.com jv@jvosburgh.net kuba@kernel.or=
g linux-kernel@vger.kernel.org liuhangbin@kylinos.cn netdev@vger.kernel.org=
 pabeni@redhat.com razor@blackwall.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6a9acf21.04649fcc.10325f.0002.GAE%40google.com.
