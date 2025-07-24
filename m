Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B06148830
	for <syzbot@lists.linux.dev>; Thu, 24 Jul 2025 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753382464; cv=none; b=mNPUK8vfMfcMpqUKKfK9Gk5inwyuFpiMC3lrcEdmmKj9KTsS9Mx38UlRYDDhRSULVTZ71ofeRPGgNN7nwDuERLh4AEEze/ZURwRAl+rYfUwyK14qdxey6t+iGcTaPTrNo+ZwECMc78GFNNP7V6yWF3D5h3u/AIujIK692T9/Wa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753382464; c=relaxed/simple;
	bh=rds8KFk4zUNq+KC87772i6EWZ4sLltvIYey4SPwG8Pw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y5bMvx58W02Ulcqklz2/FRQ+ye1lSXSD+AX7BrohqG7SXocR4UE85jmmVYNVoPKXAa849gtU1EZabvN4cjyBD9s1yDX/kdFZfhY8W7vGGTdmIcOWUDqKzzJ15H/XqBpPXn6ARMVsoX/otDc0em5wYFlgc8wIqUs9mRH2CAv+Kog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fRU18jx1; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fRU18jx1"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-31332cff2d5so1335602a91.1
        for <syzbot@lists.linux.dev>; Thu, 24 Jul 2025 11:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753382462; x=1753987262; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=znIKVdkd57Q+4kpT97VS/y4+spii/S1BEViNAR6jd6E=;
        b=fRU18jx1FnGySfQo54Rbz0L32+TZLRffLCdPiWOAifE7bbN1oYeyuwrYFwqboMfgYd
         N1fl41nmHnf5Fol3T1IV9w4+oAlBC5sU1mg3kD9GM94I09krDNcLgAVMhetVIRhgxUQO
         uRA1Wa8khm05L1F7K+vRrYJV/BlUFCteizdfMlQ0/fLKmCwTM0peDUiU6+8eaIZFwN1E
         /5pDY0rXLofYVSKQQ5FUwX85vtk+Nv+69yNWcuKbcTbXrCz1kXYMHFZGmslwTQUtBbUM
         lZnabByR+xc+OByMFOWXMeGMHmEHSsD+M6nuu01Eemkbpb7xx4otdSzHlOg6ufcW7trJ
         ar7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753382462; x=1753987262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=znIKVdkd57Q+4kpT97VS/y4+spii/S1BEViNAR6jd6E=;
        b=PSmX/x1rDZUaUvJZnpAqk8iayc2v//C3isN+kWf2fjSLyEh7neb9hE5gfSnEG5/2/R
         B9B864Z5+GPXI8UHQtwcqXeJ4X9NIpT6k2WFKokokVXHuHxse8Xl5qc4rK2q6c9ZV4L4
         bjyDNJOFGLN+V9PfRNbD5zq6rjtruxJ/rhkyHz9ZpgRTMf44x4XQmNA9jv0mnOwKkUDp
         WUoYr0Ay97GE0sAJX0bYbf6Gwq3T0tqTiVyWaoMnc/mnA+vS4eP3gcKFha1+DqvdorU+
         3WCovJy4tdqObRr82Kxdr+mqLYlZXjovvGnhWgUDHyyEirX3SYGPJTGR7KuN2LFtMzRC
         02QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQ1vwqx2hw+HvZbQ/HO7RoWk8+Lz4cAHL7JQ/DG8nYOsvyxBiGEcFJKzSxQbDc9ozfZe4rDVw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzG3w6OCP8zePo4l7frmylbbq9jZPZ7sjhRzh7KaycusY1MTve2
	mEzEs2HLONMIEBg+4YJmkjbqQKZJC14wSFa7gUZBzewUTQRKl4rLOtPHMftZDx2lzXKyz7vGGEi
	KbMzNGj+xsT/huwGdDJx84dzBtpw5Wh4S62b/OSfB
X-Gm-Gg: ASbGncvjVVizaHFJXmKZg2RWFX7cNbasDMyFEEyQOBgzcEU9tqBOx9S5Hy8/3HZzYl3
	Cgi/32I78l9pDbi3FgCuYbconYJQHD8AkijeKGBB1z7g3Nq3xaNUNQf6/H+bXcmEI/DsjrTQYwC
	AzJNTWptvxblPDXfQc0qDWMu8FzNhgBIDrklsz+PyImnxqe22U6bpay92na9306u9JK2CcNFu1j
	rGv2UnlpW5l4zLEicOxD4Q6SNkiY7KoxufsF7pF
X-Google-Smtp-Source: AGHT+IEhcySnBA7f/U5yV60MA6PmOJTdGKd3oxlWTkq0SgImH+w6f8KlgHC09YcOm7pqAaLGUh0GKse7HQH72bgJFWQ=
X-Received: by 2002:a17:90b:3d09:b0:312:29e:9ed5 with SMTP id
 98e67ed59e1d1-31e507dad0amr10747182a91.23.1753382461588; Thu, 24 Jul 2025
 11:41:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68826fcc.a00a0220.2f88df.002f.GAE@google.com> <CANp29Y6LnJgHDsMrVEC0Ks3DCfbKpfEr5uecFxGJrx=aM7+KhQ@mail.gmail.com>
In-Reply-To: <CANp29Y6LnJgHDsMrVEC0Ks3DCfbKpfEr5uecFxGJrx=aM7+KhQ@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 24 Jul 2025 20:40:49 +0200
X-Gm-Features: Ac12FXyjhZtmIW2_PisMGZo1NWOx7dZ0MrP0a72vwckAcmG3BC2AJUxWWV77P1I
Message-ID: <CANp29Y7vQKPJYZFJbFdbcDi5HnUGH2_Jqp-mNyVprrNDq-X0SQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/ipv6: RFC6724 rule 5.5 preparations
To: syzbot ci <syzbot+ci4d9dcc4a3d2bde47@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Thu, Jul 24, 2025 at 8:40=E2=80=AFPM Aleksandr Nogikh <nogikh@google.com=
> wrote:
>
> #syz upstream
>
> On Thu, Jul 24, 2025 at 7:39=E2=80=AFPM syzbot ci <syzbot+ci4d9dcc4a3d2bd=
e47@syzkaller.appspotmail.com> wrote:
>>
>> syzbot ci has tested the following series
>>
>> [v1] net/ipv6: RFC6724 rule 5.5 preparations
>> https://lore.kernel.org/all/20250724131828.32155-1-equinox@diac24.net
>> * [PATCH net-next 1/4] net/ipv6: flatten ip6_route_get_saddr
>> * [PATCH net-next 2/4] net/ipv6: create ipv6_fl_get_saddr
>> * [PATCH net-next 3/4] net/ipv6: use ipv6_fl_get_saddr in output
>> * [PATCH net-next 4/4] net/ipv6: drop ip6_route_get_saddr
>>
>> and found the following issues:
>> * general protection fault in icmpv6_route_lookup
>> * general protection fault in xfrm_lookup_with_ifid
>>
>> Full report is available here:
>> https://ci.syzbot.org/series/3acce8b8-a246-47fc-bb73-d961e3946a5c
>>
>> ***
>>
>> general protection fault in icmpv6_route_lookup
>>
>> tree:      net-next
>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netd=
ev/net-next.git
>> base:      56613001dfc9b2e35e2d6ba857cbc2eb0bac4272
>> arch:      amd64
>> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~=
exp1~20250616065826.132), Debian LLD 20.1.7
>> config:    https://ci.syzbot.org/builds/9e473f74-1396-464d-868c-c8273cf3=
923b/config
>> syz repro: https://ci.syzbot.org/findings/2c2d1023-a44b-4226-b918-23466b=
921da9/syz_repro
>>
>> Oops: general protection fault, probably for non-canonical address 0xdff=
ffc000000001c: 0000 [#1] SMP KASAN PTI
>> KASAN: null-ptr-deref in range [0x00000000000000e0-0x00000000000000e7]
>> CPU: 0 UID: 0 PID: 5991 Comm: syz.0.19 Not tainted 6.16.0-rc6-syzkaller-=
01646-g56613001dfc9-dirty #0 PREEMPT(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1=
.16.2-1 04/01/2014
>> RIP: 0010:ipv6_anycast_destination include/net/ip6_route.h:234 [inline]
>> RIP: 0010:icmpv6_route_lookup+0x1ad/0x590 net/ipv6/icmp.c:374
>> Code: a4 01 00 00 49 89 c7 e8 b1 54 94 f7 4c 89 f8 49 89 df e9 3f 02 00 =
00 4c 8b 74 24 60 4d 8d ae e0 00 00 00 4c 89 e8 48 c1 e8 03 <42> 0f b6 04 3=
8 84 c0 0f 85 41 03 00 00 45 8b 6d 00 44 89 ee 81 e6
>> RSP: 0018:ffffc90002b4ec00 EFLAGS: 00010202
>> RAX: 000000000000001c RBX: ffffc90002b4eee0 RCX: 0000000000000000
>> RDX: ffff8880206c3980 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: ffffc90002b4ed70 R08: ffff88802a9ef3c3 R09: 1ffff1100553de78
>> R10: dffffc0000000000 R11: ffffed100553de79 R12: ffff88810de0f800
>> R13: 00000000000000e0 R14: 0000000000000000 R15: dffffc0000000000
>> FS:  00007faf43ec86c0(0000) GS:ffff8880b8615000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000200000034000 CR3: 0000000028440000 CR4: 00000000000006f0
>> Call Trace:
>>  <TASK>
>>  icmp6_send+0x1001/0x1940 net/ipv6/icmp.c:606
>>  icmpv6_param_prob_reason+0x32/0x50 net/ipv6/icmp.c:654
>>  ip6_tlvopt_unknown net/ipv6/exthdrs.c:94 [inline]
>>  ip6_parse_tlv+0x19fc/0x1e60 net/ipv6/exthdrs.c:-1
>>  ipv6_destopt_rcv+0x597/0xbc0 net/ipv6/exthdrs.c:325
>>  ip6_protocol_deliver_rcu+0xe0b/0x15c0 net/ipv6/ip6_input.c:438
>>  ip6_input_finish+0x191/0x370 net/ipv6/ip6_input.c:489
>>  NF_HOOK+0x30c/0x3a0 include/linux/netfilter.h:317
>>  ip6_input+0x16a/0x270 net/ipv6/ip6_input.c:500
>>  ip6_mc_input+0x5c8/0xaf0 net/ipv6/ip6_input.c:590
>>  NF_HOOK+0x30c/0x3a0 include/linux/netfilter.h:317
>>  __netif_receive_skb_one_core net/core/dev.c:5979 [inline]
>>  __netif_receive_skb+0xd3/0x380 net/core/dev.c:6092
>>  netif_receive_skb_internal net/core/dev.c:6178 [inline]
>>  netif_receive_skb+0x1cb/0x790 net/core/dev.c:6237
>>  tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
>>  tun_get_user+0x2aa2/0x3e20 drivers/net/tun.c:1950
>>  tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1996
>>  new_sync_write fs/read_write.c:593 [inline]
>>  vfs_write+0x54b/0xa90 fs/read_write.c:686
>>  ksys_write+0x145/0x250 fs/read_write.c:738
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7faf42f8e9a9
>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007faf43ec8038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>> RAX: ffffffffffffffda RBX: 00007faf431b5fa0 RCX: 00007faf42f8e9a9
>> RDX: 0000000000000ffe RSI: 00002000000000c0 RDI: 0000000000000003
>> RBP: 00007faf43010d69 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 0000000000000000 R14: 00007faf431b5fa0 R15: 00007ffeead38248
>>  </TASK>
>> Modules linked in:
>> ---[ end trace 0000000000000000 ]---
>> RIP: 0010:ipv6_anycast_destination include/net/ip6_route.h:234 [inline]
>> RIP: 0010:icmpv6_route_lookup+0x1ad/0x590 net/ipv6/icmp.c:374
>> Code: a4 01 00 00 49 89 c7 e8 b1 54 94 f7 4c 89 f8 49 89 df e9 3f 02 00 =
00 4c 8b 74 24 60 4d 8d ae e0 00 00 00 4c 89 e8 48 c1 e8 03 <42> 0f b6 04 3=
8 84 c0 0f 85 41 03 00 00 45 8b 6d 00 44 89 ee 81 e6
>> RSP: 0018:ffffc90002b4ec00 EFLAGS: 00010202
>> RAX: 000000000000001c RBX: ffffc90002b4eee0 RCX: 0000000000000000
>> RDX: ffff8880206c3980 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: ffffc90002b4ed70 R08: ffff88802a9ef3c3 R09: 1ffff1100553de78
>> R10: dffffc0000000000 R11: ffffed100553de79 R12: ffff88810de0f800
>> R13: 00000000000000e0 R14: 0000000000000000 R15: dffffc0000000000
>> FS:  00007faf43ec86c0(0000) GS:ffff8880b8615000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000200000034000 CR3: 0000000028440000 CR4: 00000000000006f0
>> ----------------
>> Code disassembly (best guess), 2 bytes skipped:
>>    0:   00 00                   add    %al,(%rax)
>>    2:   49 89 c7                mov    %rax,%r15
>>    5:   e8 b1 54 94 f7          call   0xf79454bb
>>    a:   4c 89 f8                mov    %r15,%rax
>>    d:   49 89 df                mov    %rbx,%r15
>>   10:   e9 3f 02 00 00          jmp    0x254
>>   15:   4c 8b 74 24 60          mov    0x60(%rsp),%r14
>>   1a:   4d 8d ae e0 00 00 00    lea    0xe0(%r14),%r13
>>   21:   4c 89 e8                mov    %r13,%rax
>>   24:   48 c1 e8 03             shr    $0x3,%rax
>> * 28:   42 0f b6 04 38          movzbl (%rax,%r15,1),%eax <-- trapping i=
nstruction
>>   2d:   84 c0                   test   %al,%al
>>   2f:   0f 85 41 03 00 00       jne    0x376
>>   35:   45 8b 6d 00             mov    0x0(%r13),%r13d
>>   39:   44 89 ee                mov    %r13d,%esi
>>   3c:   81                      .byte 0x81
>>   3d:   e6                      .byte 0xe6
>>
>>
>> ***
>>
>> general protection fault in xfrm_lookup_with_ifid
>>
>> tree:      net-next
>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netd=
ev/net-next.git
>> base:      56613001dfc9b2e35e2d6ba857cbc2eb0bac4272
>> arch:      amd64
>> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~=
exp1~20250616065826.132), Debian LLD 20.1.7
>> config:    https://ci.syzbot.org/builds/9e473f74-1396-464d-868c-c8273cf3=
923b/config
>> syz repro: https://ci.syzbot.org/findings/47a724ea-a36c-478d-af91-ca8b35=
320f01/syz_repro
>>
>> Oops: general protection fault, probably for non-canonical address 0xdff=
ffc0000000001: 0000 [#1] SMP KASAN PTI
>> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>> CPU: 0 UID: 0 PID: 6016 Comm: syz.1.17 Not tainted 6.16.0-rc6-syzkaller-=
01646-g56613001dfc9-dirty #0 PREEMPT(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1=
.16.2-1 04/01/2014
>> RIP: 0010:xfrm_lookup_with_ifid+0xb9/0x1a70 net/xfrm/xfrm_policy.c:3181
>> Code: c7 44 29 0a f3 f3 e8 f6 b8 ac f7 ba 10 00 00 00 4c 89 f7 31 f6 e8 =
d7 ca 0e f8 4c 89 64 24 18 49 83 c4 08 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 0=
0 74 08 4c 89 e7 e8 e8 c7 0e f8 4d 8b 24 24 4c 89 e0
>> RSP: 0018:ffffc90002b77960 EFLAGS: 00010202
>> RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90002b77a10
>> RBP: ffffc90002b77a78 R08: ffffc90002b77a0f R09: 0000000000000000
>> R10: ffffc90002b77a00 R11: fffff5200056ef42 R12: 0000000000000008
>> R13: dffffc0000000000 R14: ffffc90002b77a00 R15: ffff888025d85d80
>> FS:  00007fa26dbba6c0(0000) GS:ffff8880b8615000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000200000000000 CR3: 0000000026e50000 CR4: 00000000000006f0
>> Call Trace:
>>  <TASK>
>>  xfrm_lookup net/xfrm/xfrm_policy.c:3336 [inline]
>>  xfrm_lookup_route+0x3c/0x1c0 net/xfrm/xfrm_policy.c:3347
>>  ip6_datagram_dst_update+0x75c/0xcb0 net/ipv6/datagram.c:96
>>  __ip6_datagram_connect+0xbd1/0x1150 net/ipv6/datagram.c:255
>>  udpv6_connect+0x36/0x240 net/ipv6/udp.c:1310
>>  __sys_connect_file net/socket.c:2086 [inline]
>>  __sys_connect+0x316/0x440 net/socket.c:2105
>>  __do_sys_connect net/socket.c:2111 [inline]
>>  __se_sys_connect net/socket.c:2108 [inline]
>>  __x64_sys_connect+0x7a/0x90 net/socket.c:2108
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7fa26cd8e9a9
>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fa26dbba038 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
>> RAX: ffffffffffffffda RBX: 00007fa26cfb5fa0 RCX: 00007fa26cd8e9a9
>> RDX: 000000000000001c RSI: 0000200000000000 RDI: 0000000000000003
>> RBP: 00007fa26ce10d69 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 0000000000000000 R14: 00007fa26cfb5fa0 R15: 00007ffe87554b78
>>  </TASK>
>> Modules linked in:
>> ---[ end trace 0000000000000000 ]---
>> RIP: 0010:xfrm_lookup_with_ifid+0xb9/0x1a70 net/xfrm/xfrm_policy.c:3181
>> Code: c7 44 29 0a f3 f3 e8 f6 b8 ac f7 ba 10 00 00 00 4c 89 f7 31 f6 e8 =
d7 ca 0e f8 4c 89 64 24 18 49 83 c4 08 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 0=
0 74 08 4c 89 e7 e8 e8 c7 0e f8 4d 8b 24 24 4c 89 e0
>> RSP: 0018:ffffc90002b77960 EFLAGS: 00010202
>> RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90002b77a10
>> RBP: ffffc90002b77a78 R08: ffffc90002b77a0f R09: 0000000000000000
>> R10: ffffc90002b77a00 R11: fffff5200056ef42 R12: 0000000000000008
>> R13: dffffc0000000000 R14: ffffc90002b77a00 R15: ffff888025d85d80
>> FS:  00007fa26dbba6c0(0000) GS:ffff8880b8615000(0000) knlGS:000000000000=
0000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000200000000000 CR3: 0000000026e50000 CR4: 00000000000006f0
>> ----------------
>> Code disassembly (best guess):
>>    0:   c7 44 29 0a f3 f3 e8    movl   $0xf6e8f3f3,0xa(%rcx,%rbp,1)
>>    7:   f6
>>    8:   b8 ac f7 ba 10          mov    $0x10baf7ac,%eax
>>    d:   00 00                   add    %al,(%rax)
>>    f:   00 4c 89 f7             add    %cl,-0x9(%rcx,%rcx,4)
>>   13:   31 f6                   xor    %esi,%esi
>>   15:   e8 d7 ca 0e f8          call   0xf80ecaf1
>>   1a:   4c 89 64 24 18          mov    %r12,0x18(%rsp)
>>   1f:   49 83 c4 08             add    $0x8,%r12
>>   23:   4c 89 e0                mov    %r12,%rax
>>   26:   48 c1 e8 03             shr    $0x3,%rax
>> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping i=
nstruction
>>   2f:   74 08                   je     0x39
>>   31:   4c 89 e7                mov    %r12,%rdi
>>   34:   e8 e8 c7 0e f8          call   0xf80ec821
>>   39:   4d 8b 24 24             mov    (%r12),%r12
>>   3d:   4c 89 e0                mov    %r12,%rax
>>
>>
>> ***
>>
>> If these findings have caused you to resend the series or submit a
>> separate fix, please add the following tag to your commit message:
>> Tested-by: syzbot@syzkaller.appspotmail.com
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>>
>> The email will later be sent to:
>> [davem@davemloft.net dsahern@kernel.org equinox@diac24.net lorenzo@googl=
e.com netdev@vger.kernel.org prohr@google.com]
>>
>> If the report looks fine to you, reply with:
>> #syz upstream
>>
>> --
>> You received this message because you are subscribed to the Google Group=
s "syzkaller-upstream-moderation" group.
>> To unsubscribe from this group and stop receiving emails from it, send a=
n email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
>> To view this discussion visit https://groups.google.com/d/msgid/syzkalle=
r-upstream-moderation/68826fcc.a00a0220.2f88df.002f.GAE%40google.com.
