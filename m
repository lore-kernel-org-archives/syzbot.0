Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5202680C02
	for <syzbot@lists.linux.dev>; Sun, 21 Sep 2025 06:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758436616; cv=none; b=ZuVtpnUzgSu1ScRtEgmhQ7ZHrAs5Kr6ENo5QdE8UcQL6MwbSABwzda4OhH5s0rgWdanHTL9ZLod+x1xKzSalR64tQufE93NNdNhqvLRA7InqPBo73h0Y8weXg+hw0IL3e4umlwTRriHzM4tCPqC6dDXeV1ktEtRuidLQ0ZfPKrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758436616; c=relaxed/simple;
	bh=MKA/n4ISwMTdgPF119bshTzF+Ro+37N/XviK6EE9I5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JZWhzLMStnM98CLIOzaYWysftY4YOmWqIwQjSjWtgw3ohFqB2NfoFYffMvf7DFxo/UBp87GsQE8Zo38rg9Y9mqM8VVpSGjR8grZtvMEzLZ/Boa/p90AlFU3I+7aU3UV0ypF2NM+d6QPIEOafAeor2vpxF1bPX0RsVezxPtMMibs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pc5MDQgl; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pc5MDQgl"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-74c7d98935eso1771590a34.1
        for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 23:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758436613; x=1759041413; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JDoFl3OjOKD7QCoWrmSYMD8pEpVK5OMqlvwYyvD0OvM=;
        b=Pc5MDQglYLKn6+C3kalXhO+5+B+Z00a4526f5OAJqLrmFDEGoiWR3MyKQ2zaGCrOEz
         VSR/+K0bweLdm0eB1ahEx5amaBdRjGe0szoOItmOx82USI4s9s7T2JDLH7iPbcgFAZbV
         oinfCq3WoK0e27R4ACdCdBP3NMo492kbb+mFgvVv1N3YU4E8dkn9XW/EwBcT8/pU8iNi
         GTgwkJANlHDM0nl7DPJMYIDL8ucU+hzi6K/IzBCbUSzwPj4MUGsxQxHu4iOShiBKHit1
         KRZ+cFCfHRh7pYNAXVz2/2FnGi0+019B3B+Jg/eqjAlQWxnvlj2UoJCsTbVEWJi5YNmx
         0QUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758436613; x=1759041413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JDoFl3OjOKD7QCoWrmSYMD8pEpVK5OMqlvwYyvD0OvM=;
        b=KqTIVrHQGjUpFuRZ7WUW6PeT1eKDRYj8WaAmNrJKoXyftxysuGdUIcZiwc78c2o0YG
         W+PYmcSw0e7HWUx243O3WfiX9dItO4zgdnD2B3O2GJ4I0RkGOuRfZVgS5Nam8CZWscdq
         0dcLaiB6I4VOwqoMxV9Byeu+Pahx9iX9SFjz4aUJHSCWE61Mlt0tDzRcwWfqq7sUyPle
         5JyXQzkXBRehE+Tq8luCQI/Z+m5+AeAzAaQS1gHotDuiAeGrkR7Vev4md0msoySnTfh2
         9ow/KoUF2XXvA/v27s9HTK16pLREgXDDrNfXqOlZxHy+CyboVC8TSi4DyC25h0ADQ8wz
         0A6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXushGmHvLYwP9nRwc3msMX2a4FF9gv+kkhv/L8a9v30st+kzK7dEB5VK2KrjhRHeam8BmGqro=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNFOBp/2f0Y1UGS5H2x+JkrfPi4beMisK+fssQvpWDKEzsEzE5
	1LlHueH1fJYLAKdVEm5vk/VE5HUqu9k0slg+obV3Cbz6oOCP92rC8V09cLzCsPTHFVLNQZTFBmK
	E/QPAThkNMPm7ILLpGRIT3jUpXJr5Jlw/w59tF3gN
X-Gm-Gg: ASbGnct1iOco4D8Z+9ZWcErcOOAd6Jn8GxajRt5yZ4tRvHgxHW4KYFbjUHDIdcj9yIR
	oZIJjcTI+5JSPzs7m4u0SpfriKNNPD3tmlPNyAKuYteDQqYze3bl/txfS1AwchC5xItmWrHItaq
	FJsn/UsjQtl7KwN4dDrGRDMWXDk5KeQsmktBWjy4Ca3AsxX+QA4P59keFEtm2P2RiJvJZaJLGw+
	i+3lXesEhdqrxbnzA==
X-Google-Smtp-Source: AGHT+IFBASq+KcUc5PAyTY4ofCJV5zYgxQRUANiFJU6afyxUSJ+rKrhX/HHWp+SWj9JVKjegpVVm+1uG//jNBggkCqI=
X-Received: by 2002:a05:6808:4f27:b0:43a:2e17:3bc2 with SMTP id
 5614622812f47-43d6c1aa7bfmr3747437b6e.21.1758436612858; Sat, 20 Sep 2025
 23:36:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68cf4274.050a0220.13cd81.0025.GAE@google.com>
In-Reply-To: <68cf4274.050a0220.13cd81.0025.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 21 Sep 2025 08:36:41 +0200
X-Gm-Features: AS18NWAy0iy6zzOIJixAO1cCvMrFvD01w9XLOADRf30G69NIjoFrx2D6sgL08-E
Message-ID: <CANp29Y7vWiQBVew0vppniiM4AYLEPQ74BZHfWNn7+ftP_b_4yQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: [PATCH v2] net: skb: guard kmalloc_reserve()
 against oversized allocations
To: syzbot ci <syzbot+ci844553212b72dc63@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Sep 21, 2025 at 2:10=E2=80=AFAM syzbot ci
<syzbot+ci844553212b72dc63@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] [PATCH v2] net: skb: guard kmalloc_reserve() against oversized alloc=
ations
> https://lore.kernel.org/all/20250920201138.402247-1-kriish.sharma2006@gma=
il.com
> * [PATCH] [PATCH v2] net: skb: guard kmalloc_reserve() against oversized =
allocations
>
> and found the following issues:
> * WARNING in __alloc_skb
> * WARNING in pskb_expand_head
>
> Full report is available here:
> https://ci.syzbot.org/series/3048e542-7fa8-46b3-8e97-499b35ec361d
>
> ***
>
> WARNING in __alloc_skb
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      315f423be0d1ebe720d8fd4fa6bed68586b13d34
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/3d048fda-1178-4af7-acb5-2eb1a391f=
26b/config
> C repro:   https://ci.syzbot.org/findings/64757740-d6bb-483c-8261-a190a05=
1189b/c_repro
> syz repro: https://ci.syzbot.org/findings/64757740-d6bb-483c-8261-a190a05=
1189b/syz_repro
>
> ------------[ cut here ]------------
> kmalloc_reserve: request size 2147480000 exceeds KMALLOC_MAX_SIZE (419430=
4)
> WARNING: CPU: 0 PID: 5990 at net/core/skbuff.c:598 kmalloc_reserve+0x2df/=
0x2f0 net/core/skbuff.c:596
> Modules linked in:
> CPU: 0 UID: 0 PID: 5990 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kmalloc_reserve+0x2df/0x2f0 net/core/skbuff.c:596
> Code: ff e8 d5 4a 64 f8 c6 05 67 27 32 06 01 90 b9 00 00 40 00 48 c7 c7 a=
0 0b 94 8c 48 c7 c6 49 5a 96 8d 4c 89 ea e8 82 e7 27 f8 90 <0f> 0b 90 90 45=
 31 e4 e9 37 ff ff ff 0f 1f 44 00 00 90 90 90 90 90
> RSP: 0018:ffffc90002c3f798 EFLAGS: 00010246
> RAX: 6aef4e9a5451c800 RBX: dffffc0000000001 RCX: ffff8881079a5640
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: ffffc90002c3f7e4 R08: ffff88804b024253 R09: 1ffff1100960484a
> R10: dffffc0000000000 R11: ffffed100960484b R12: 000000007ffff080
> R13: 000000007ffff1c0 R14: 0000000000000cc0 R15: 1ffff92000587efc
> FS:  00005555874d6500(0000) GS:ffff8880b8613000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000006038 CR3: 000000010b696000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __alloc_skb+0x142/0x2d0 net/core/skbuff.c:677
>  alloc_skb include/linux/skbuff.h:1377 [inline]
>  sock_wmalloc+0xb2/0x130 net/core/sock.c:2798
>  pppol2tp_sendmsg+0x183/0x5f0 net/l2tp/l2tp_ppp.c:275
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:729
>  ____sys_sendmsg+0x52d/0x830 net/socket.c:2614
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
>  __sys_sendmmsg+0x227/0x430 net/socket.c:2757
>  __do_sys_sendmmsg net/socket.c:2784 [inline]
>  __se_sys_sendmmsg net/socket.c:2781 [inline]
>  __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2781
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f45f258eba9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffda5a883d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007f45f27d5fa0 RCX: 00007f45f258eba9
> RDX: 04000000000001ce RSI: 0000200000005f80 RDI: 0000000000000004
> RBP: 00007f45f2611e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000008040 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f45f27d5fa0 R14: 00007f45f27d5fa0 R15: 0000000000000004
>  </TASK>
>
>
> ***
>
> WARNING in pskb_expand_head
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      315f423be0d1ebe720d8fd4fa6bed68586b13d34
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/3d048fda-1178-4af7-acb5-2eb1a391f=
26b/config
> C repro:   https://ci.syzbot.org/findings/951f3d6d-b4db-4f6e-b7e5-df8d379=
9b0ab/c_repro
> syz repro: https://ci.syzbot.org/findings/951f3d6d-b4db-4f6e-b7e5-df8d379=
9b0ab/syz_repro
>
> ------------[ cut here ]------------
> kmalloc_reserve: request size 4194368 exceeds KMALLOC_MAX_SIZE (4194304)
> WARNING: CPU: 1 PID: 5991 at net/core/skbuff.c:598 kmalloc_reserve+0x2df/=
0x2f0 net/core/skbuff.c:596
> Modules linked in:
> CPU: 1 UID: 0 PID: 5991 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kmalloc_reserve+0x2df/0x2f0 net/core/skbuff.c:596
> Code: ff e8 d5 4a 64 f8 c6 05 67 27 32 06 01 90 b9 00 00 40 00 48 c7 c7 a=
0 0b 94 8c 48 c7 c6 49 5a 96 8d 4c 89 ea e8 82 e7 27 f8 90 <0f> 0b 90 90 45=
 31 e4 e9 37 ff ff ff 0f 1f 44 00 00 90 90 90 90 90
> RSP: 0018:ffffc90003b9f6d8 EFLAGS: 00010246
> RAX: a130a6a821c6fc00 RBX: dffffc0000000001 RCX: ffff88802051b980
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
> RBP: ffffc90003b9f794 R08: ffff888136624253 R09: 1ffff11026cc484a
> R10: dffffc0000000000 R11: ffffed1026cc484b R12: 00000000003fff00
> R13: 0000000000400040 R14: 0000000000000820 R15: 1ffff92000773ef2
> FS:  00005555572cd500(0000) GS:ffff8881a3c13000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30b63fff CR3: 0000000027cee000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  pskb_expand_head+0x18e/0x1150 net/core/skbuff.c:2248
>  __skb_cow include/linux/skbuff.h:3847 [inline]
>  skb_cow_head include/linux/skbuff.h:3881 [inline]
>  __vlan_insert_inner_tag include/linux/if_vlan.h:360 [inline]
>  __vlan_insert_tag include/linux/if_vlan.h:406 [inline]
>  skb_vlan_push+0x30a/0x8d0 net/core/skbuff.c:6390
>  ____bpf_skb_vlan_push net/core/filter.c:3209 [inline]
>  bpf_skb_vlan_push+0x217/0x900 net/core/filter.c:3199
>  bpf_prog_db72096d6b827dfb+0x4c/0x55
>  bpf_dispatcher_nop_func include/linux/bpf.h:1335 [inline]
>  __bpf_prog_run include/linux/filter.h:718 [inline]
>  bpf_prog_run include/linux/filter.h:725 [inline]
>  bpf_test_run+0x318/0x7b0 net/bpf/test_run.c:434
>  bpf_prog_test_run_skb+0xb30/0x1560 net/bpf/test_run.c:1099
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4590
>  __sys_bpf+0x581/0x870 kernel/bpf/syscall.c:6047
>  __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7efd6458eba9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe070e5238 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007efd647d5fa0 RCX: 00007efd6458eba9
> RDX: 0000000000000050 RSI: 0000200000000180 RDI: 000000000000000a
> RBP: 00007efd64611e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007efd647d5fa0 R14: 00007efd647d5fa0 R15: 0000000000000003
>  </TASK>
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
> The email will later be sent to:
> [aleksander.lobakin@intel.com almasrymina@google.com davem@davemloft.net =
ebiggers@google.com edumazet@google.com horms@kernel.org kerneljasonxing@gm=
ail.com kriish.sharma2006@gmail.com kuba@kernel.org linux-kernel@vger.kerne=
l.org martin.lau@kernel.org mhal@rbox.co netdev@vger.kernel.org pabeni@redh=
at.com skhan@linuxfoundation.org syzbot@syzkaller.appspotmail.com willemb@g=
oogle.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68cf4274.050a0220.13cd81.0025.GAE%40google.com.
