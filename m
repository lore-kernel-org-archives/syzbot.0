Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0296E31B810
	for <syzbot@lists.linux.dev>; Mon,  9 Feb 2026 07:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770622024; cv=pass; b=jIyXWxjHrJQoZCSrsy60c0CFEb/URl4jl7EK6zPNDdGuCeDg4eGIZZWI9hcsgWONExRpCsfXZHbMjEbIcfnDUNDl/hgcCu8Y9WE7N9blt5EOm+uM9CEHEEYymIngt0RZIORaYjOcowAj3wt34F8W7Q9kzkAH+Z667oPvm6Z9TNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770622024; c=relaxed/simple;
	bh=6kudD+JwB+BvevI7e5b+VFkO7BbE3ZwZP08/EgxVz4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eG+jdhLqE2t2wYHcVoINqCyP5WldOUz2gbCSQpgNj3KBRWSWp9AwNrs4Rd8GDcFqIZjRyC+TqmRsaIkQVxXEvc4v29iFVwRLnPZS0lg111lN9D3E6qYbyVqEBckWAFhEeRojjgZiRo5DizCp+BFvMP6r9vz6sZ6KHDB1hVa7/lU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OjYAQOBd; arc=pass smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OjYAQOBd"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-4094f6f4b7bso930995fac.2
        for <syzbot@lists.linux.dev>; Sun, 08 Feb 2026 23:27:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770622023; cv=none;
        d=google.com; s=arc-20240605;
        b=Vwc5BBofIHtkfexKbJPhTlBxy2a4Eyix9BGPrXjg1cDYtqyZJycNs7gmHRg8K3IWIA
         zCNvJdchVl5vHF6/BncA44Zm5U00dGgnfMPvJabj7QHPD4TmIH/4KKAna65AiyUx1xfa
         nw35Kad17JOIQOc04D4rHNjVDiWsDhVU6BrrC1GAtOgDobxYOy3WpT2EV4qsnA+QX5k5
         eLKmEl5cHA7XucIwmHQ3XLSzwCBJpvtitDhtJXR2IWhlwwoiVy0AM5EBwTiOhlV0FEJo
         4w7o7uQTgXDGZ/foSLAf3xqgr7E6/N7bRKtvxc+xZICbfKS5bIfOCcGmDn5EqkNPWjWT
         4Ixg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SkyNaLrYztsDbQWBVey48Fs1HZAfSAJPicOfhTmPxJQ=;
        fh=Ga/kbt9yI1o4giAIvPaT7JQPoGAw3WDURezNZYpzu90=;
        b=TlWRnKdKuiZHVrv8ri8UC7KMYmUJV/x57MqAay3vuQc+ekeWLiTNMZb8aiZPeFQRn3
         aJnfNgo1cLdz333wWAEuXhThw2XZlG6BAsDJOiB8tflU5APPSUjwghsdRBmfF1arQ1kV
         13iQ49H4Sbm6jrWGT1ACugmhtFGGK4thd2Yiup7nQXiFMmywdN9x9dY8RRtPxcfVeU/I
         W351pjvx/4bibxwnfa1dvKFO9TPAUedYxmWWgcZUGzPxpbqcpZn4f+JBShijBZHa+0Uu
         I+7ndUpSQomJUeHqJSgisL4xc6V9ku+Sv1fRUUfv6mQ7kNM9D5QHqJrpeAIr0/N87afU
         yP3A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770622023; x=1771226823; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SkyNaLrYztsDbQWBVey48Fs1HZAfSAJPicOfhTmPxJQ=;
        b=OjYAQOBd4c0K+EhyLSzeDOQekG/JnrGgxmUf4BinPs4XSVm4eHAsXvk2/hciLE+Eil
         QoVSl04rdMhQ52GKlI1yGp3A3nniaMpKWIPrAST1+9ctD/t5KK/GYm77CY9cfq0WyLp8
         poET9AF6pPVV6u1ssSftwGkqRxCEGd0qKhW6NFu/jc2yWo9QlbnW3N2SDoc4UpaRwX4J
         ehdbXHrpe/Bir8OpinBCxs+2vBZAvJUoR0eBcpvfSo7UM6xsLGB7kwubqZaK2+tP9hqI
         U6LLWg/fXqvAh0U8Y9NgvNrzp7AGX/95aP3uP16wYQF+nd7RGr4fGiVCqKXgUFXoVDIg
         NiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770622023; x=1771226823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SkyNaLrYztsDbQWBVey48Fs1HZAfSAJPicOfhTmPxJQ=;
        b=Wht/7Ba+aNCSJZvWsttIRttq+/MBR3dq9SwMUT90xxXrKws4rEgWaWrJJcO8syoAdp
         vtPX6JstZ8NQiP+yBtXav5WOUj3vatk3gZsx0VUc7UyEE+oVbC6KKVHCLxE9/BbHwjqP
         3oLPi4PeueFytM7nc1o4JTnWT5hU9dXBGuKJk1xcQyXBZYxM3J5Gt5AfH4h6uSIPdKRj
         dWc5sTH7+XFI1hOy9J+vei3ttKRk4G+/au13R7I2tI+X2e0fMbnteqKmqWJ76AxLUPQU
         s9QLXBTMG/VjOBLOtibbLDmwuVub4fVPGkKOpt9Dozr3q6NlL+I6zPtfM0tJzfZlXSPR
         kyQQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9rFupTw6kZKzZEhfLmvcz1nvX2ZhDFqj3lddmw5gpZwFoJ3wH8oJEGjFgIfaZaqrJginBZ+Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzUfgnL1NOi/4Ah9u06mNLs6zm7oarMxUgMrpKA8/UWP7NetGLr
	+eEB4wkihl30OMAEPzOeF7M7BgZZ6gPzPV7iQr8gRDUuGqtiOLVr77LeoYwLf5jKYbHIqSmMLQa
	T5fAj8hSOrzmxdUoYBHt8+W/5DpXlIJ7zNm87LBUe
X-Gm-Gg: AZuq6aKh/ooO7zvkega9+sbbzpFmsXaOIfay0+ke72RjMyejJZ1HXVE7XMn/3iqsxQz
	pa5VJ53//E2MXPpmlg6evORfR3aDanV2BCWU/Y+/hS8b2MQB3zktTd2j3rybNB7c4ANIbi5hXHg
	dgb00SB2xzWIm36jtFDHQGvdFG35nwhsIi1v8DDfCxrQpg60xA7xI2Zoq1ZYb4FHgI6JZTVPfJW
	R7qSkG+x9lUPkGLCpCWJpPmpAdm7dFspspMCOO1LaBakPVvHYQsC2kJLVIL8khHof/eK+rkXFp4
	4dgbt3km/pufLfJC20/hUOnWYga2Y7S1nSDWqAg+69drfqoP3o+MD9iL8HrM
X-Received: by 2002:a05:6870:be96:b0:3f9:e786:38b6 with SMTP id
 586e51a60fabf-40a96f82c39mr5758551fac.52.1770622022475; Sun, 08 Feb 2026
 23:27:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6989789c.050a0220.1ad825.000d.GAE@google.com>
In-Reply-To: <6989789c.050a0220.1ad825.000d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 9 Feb 2026 08:26:51 +0100
X-Gm-Features: AZwV_QgKrOAusObexCfrs2YdM89fYFoqxxT_2uxc9B7WX-m2WLYXqt9PeIdYp_w
Message-ID: <CANp29Y4jDC_hES8Yhof9iADE6VFpZ4VBBjSfxNyTt3VsM6PQZg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ppp: don't store tx skb in the fastpath
To: syzbot ci <syzbot+ci9e67600f0124c452@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Feb 9, 2026 at 7:03=E2=80=AFAM syzbot ci
<syzbot+ci9e67600f0124c452@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ppp: don't store tx skb in the fastpath
> https://lore.kernel.org/all/20260209021134.21194-1-dqfext@gmail.com
> * [RFC PATCH net-next] ppp: don't store tx skb in the fastpath
>
> and found the following issue:
> KASAN: slab-use-after-free Write in sk_skb_reason_drop
>
> Full report is available here:
> https://ci.syzbot.org/series/0307aa1e-223a-4cd7-af71-1a3c3b7b33f0
>
> ***
>
> KASAN: slab-use-after-free Write in sk_skb_reason_drop
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      57be33f85e369ce9f69f61eaa34734e0d3bd47a7
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/3b8a7fc0-258a-4d96-b4cf-cf8281124=
15c/config
> C repro:   https://ci.syzbot.org/findings/43f9458e-e8a7-4c35-83a9-fd92f2c=
65af4/c_repro
> syz repro: https://ci.syzbot.org/findings/43f9458e-e8a7-4c35-83a9-fd92f2c=
65af4/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/l=
inux/instrumented.h:96 [inline]
> BUG: KASAN: slab-use-after-free in atomic_fetch_sub_release include/linux=
/atomic/atomic-instrumented.h:400 [inline]
> BUG: KASAN: slab-use-after-free in __refcount_sub_and_test include/linux/=
refcount.h:389 [inline]
> BUG: KASAN: slab-use-after-free in __refcount_dec_and_test include/linux/=
refcount.h:432 [inline]
> BUG: KASAN: slab-use-after-free in refcount_dec_and_test include/linux/re=
fcount.h:450 [inline]
> BUG: KASAN: slab-use-after-free in skb_unref include/linux/skbuff.h:1292 =
[inline]
> BUG: KASAN: slab-use-after-free in __sk_skb_reason_drop net/core/skbuff.c=
:1226 [inline]
> BUG: KASAN: slab-use-after-free in sk_skb_reason_drop+0x37/0x170 net/core=
/skbuff.c:1254
> Write of size 4 at addr ffff88811262cce4 by task syz.0.17/5962
>
> CPU: 1 UID: 0 PID: 5962 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
>  atomic_fetch_sub_release include/linux/atomic/atomic-instrumented.h:400 =
[inline]
>  __refcount_sub_and_test include/linux/refcount.h:389 [inline]
>  __refcount_dec_and_test include/linux/refcount.h:432 [inline]
>  refcount_dec_and_test include/linux/refcount.h:450 [inline]
>  skb_unref include/linux/skbuff.h:1292 [inline]
>  __sk_skb_reason_drop net/core/skbuff.c:1226 [inline]
>  sk_skb_reason_drop+0x37/0x170 net/core/skbuff.c:1254
>  kfree_skb_reason include/linux/skbuff.h:1322 [inline]
>  kfree_skb include/linux/skbuff.h:1331 [inline]
>  ppp_push+0x1284/0x1440 drivers/net/ppp/ppp_generic.c:-1
>  __ppp_xmit_process drivers/net/ppp/ppp_generic.c:1680 [inline]
>  ppp_xmit_process+0x9d7/0x1d90 drivers/net/ppp/ppp_generic.c:1706
>  ppp_write+0x2c6/0x400 drivers/net/ppp/ppp_generic.c:540
>  do_loop_readv_writev fs/read_write.c:850 [inline]
>  vfs_writev+0x4bd/0x990 fs/read_write.c:1059
>  do_pwritev fs/read_write.c:1153 [inline]
>  __do_sys_pwritev fs/read_write.c:1199 [inline]
>  __se_sys_pwritev fs/read_write.c:1194 [inline]
>  __x64_sys_pwritev+0x19f/0x2a0 fs/read_write.c:1194
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1a1d39acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc1381da18 EFLAGS: 00000246 ORIG_RAX: 0000000000000128
> RAX: ffffffffffffffda RBX: 00007f1a1d615fa0 RCX: 00007f1a1d39acb9
> RDX: 0000000000000001 RSI: 00002000000002c0 RDI: 0000000000000003
> RBP: 00007f1a1d408bf7 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1a1d615fac R14: 00007f1a1d615fa0 R15: 00007f1a1d615fa0
>  </TASK>
>
> Allocated by task 5962:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  kmem_cache_alloc_node_noprof+0x427/0x6f0 mm/slub.c:5315
>  __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
>  alloc_skb include/linux/skbuff.h:1383 [inline]
>  ppp_write+0xb1/0x400 drivers/net/ppp/ppp_generic.c:523
>  do_loop_readv_writev fs/read_write.c:850 [inline]
>  vfs_writev+0x4bd/0x990 fs/read_write.c:1059
>  do_pwritev fs/read_write.c:1153 [inline]
>  __do_sys_pwritev fs/read_write.c:1199 [inline]
>  __se_sys_pwritev fs/read_write.c:1194 [inline]
>  __x64_sys_pwritev+0x19f/0x2a0 fs/read_write.c:1194
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5962:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2540 [inline]
>  slab_free mm/slub.c:6674 [inline]
>  kmem_cache_free+0x195/0x610 mm/slub.c:6785
>  ppp_prepare_tx_skb drivers/net/ppp/ppp_generic.c:1850 [inline]
>  __ppp_xmit_process drivers/net/ppp/ppp_generic.c:1676 [inline]
>  ppp_xmit_process+0x1147/0x1d90 drivers/net/ppp/ppp_generic.c:1706
>  ppp_write+0x2c6/0x400 drivers/net/ppp/ppp_generic.c:540
>  do_loop_readv_writev fs/read_write.c:850 [inline]
>  vfs_writev+0x4bd/0x990 fs/read_write.c:1059
>  do_pwritev fs/read_write.c:1153 [inline]
>  __do_sys_pwritev fs/read_write.c:1199 [inline]
>  __se_sys_pwritev fs/read_write.c:1194 [inline]
>  __x64_sys_pwritev+0x19f/0x2a0 fs/read_write.c:1194
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88811262cc00
>  which belongs to the cache skbuff_head_cache of size 240
> The buggy address is located 228 bytes inside of
>  freed 240-byte region [ffff88811262cc00, ffff88811262ccf0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1126=
2c
> head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000040 ffff8881616f28c0 ffffea00044a4780 dead000000000002
> raw: 0000000000000000 0000000080150015 00000000f5000000 0000000000000000
> head: 017ff00000000040 ffff8881616f28c0 ffffea00044a4780 dead000000000002
> head: 0000000000000000 0000000080150015 00000000f5000000 0000000000000000
> head: 017ff00000000001 ffffea0004498b01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 1, tgid 1 (swapper/0), ts 20587824573, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
>  prep_new_page mm/page_alloc.c:1892 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
>  alloc_slab_page mm/slub.c:3075 [inline]
>  allocate_slab+0x86/0x3a0 mm/slub.c:3248
>  new_slab mm/slub.c:3302 [inline]
>  ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
>  __slab_alloc+0x65/0x100 mm/slub.c:4779
>  __slab_alloc_node mm/slub.c:4855 [inline]
>  slab_alloc_node mm/slub.c:5251 [inline]
>  kmem_cache_alloc_node_noprof+0x4b5/0x6f0 mm/slub.c:5315
>  __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
>  alloc_skb include/linux/skbuff.h:1383 [inline]
>  nlmsg_new include/net/netlink.h:1055 [inline]
>  rtmsg_ifinfo_build_skb+0x84/0x260 net/core/rtnetlink.c:4407
>  rtmsg_ifinfo_event net/core/rtnetlink.c:4449 [inline]
>  rtmsg_ifinfo+0x8c/0x1a0 net/core/rtnetlink.c:4458
>  register_netdevice+0x175f/0x1ae0 net/core/dev.c:11458
>  register_netdev+0x40/0x60 net/core/dev.c:11522
>  nr_proto_init+0x14a/0x720 net/netrom/af_netrom.c:1424
>  do_one_initcall+0x250/0x840 init/main.c:1378
>  do_initcall_level+0x104/0x190 init/main.c:1440
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff88811262cb80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88811262cc00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88811262cc80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
>                                                        ^
>  ffff88811262cd00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88811262cd80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
> The email will later be sent to:
> [andrew@lunn.ch davem@davemloft.net dqfext@gmail.com edumazet@google.com =
kuba@kernel.org linux-kernel@vger.kernel.org linux-ppp@vger.kernel.org netd=
ev@vger.kernel.org pabeni@redhat.com]
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
-upstream-moderation/6989789c.050a0220.1ad825.000d.GAE%40google.com.
