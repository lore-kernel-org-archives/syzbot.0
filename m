Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5305C309DCB
	for <syzbot@lists.linux.dev>; Mon,  9 Feb 2026 08:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770625796; cv=pass; b=Ct7/4MgvOvLnKJLyJzILawJ1LvmLsxZerQLHv0Vq4u3TVaZHNJhulUYN/RluP0xAk4SSuLOhAkaJfxXHtSKsuIhu2LwgRMJl2Sn98k1sLL2P+Gl3ZhiDFEoQm8b/BfMGP19C0u3BMnDLgP/7m5Ihpv1bvJmDZUSBSHO1EiOr3p4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770625796; c=relaxed/simple;
	bh=NWof1Wsx6eMXBXvCJCCb+BxwOfDwxhM0gebbPE1FjHA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pjVhlHh3Wah5SRFRjHvFTksKkp0KyL+XQTrel1Ueh56IHGQ7c46xKCTbQOzAxVIcajpfRdkg4ImvribmkkspEbvt0T0XwjmptkKLxPQQ7eeUl+YYyCtlDvz3d5JcKfaaBvQ35ljeKoXdwYyE5J+MfNfJp28e9/dN0ct27rfLnXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AfnQ0onU; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AfnQ0onU"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7964f1405a0so3422037b3.1
        for <syzbot@lists.linux.dev>; Mon, 09 Feb 2026 00:29:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770625795; cv=none;
        d=google.com; s=arc-20240605;
        b=TJFcNby36+2YllZPfzMkVdV5kwc9XiBmN5bckxIKPyBTOsuTKgQDtG3mlEOkrVmrir
         w18W/41jtyR5Hrp0KFHJn5uXGr2oYKsF87kPbQdfufMDvynj4dBRmTj0uYdDHFTWEYWc
         Jwl40n8/wA2JbpTeF8CxKGwYyrRqYm76JKrQ5+KTio4h4s9QNvndhHBDkZCSMyiiuwcx
         ItlgeaZ1Vn+68Tmq9cvSYTPk9QqjUabIg8b9mi+nS4yMCl+mtuOmNk3NEyX9gN/pyZhw
         cPig1sABT6QdRzNPlI/9HT42gbmhJcmUhdf5aPSpQdikkdk3VPdgG6JQXXjyDmY5hKzI
         UnDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GaSxgJoK3r2WdutPTvbIx2WmRVTegp0yqHxkGr7jyZk=;
        fh=J1cF/N0KUGEmV73ge6LJLvHEGs63Qm4zEwXs2lcQV0Q=;
        b=FMdXyGn3qjEXDltOjUn2Js72JZWCl6g0qIXv43yaqqB5/Fry81BXEXbnjGwRjrwQ21
         KTdoR9/upVDn0BLbJ0Ly85vzmOmS/4MzUhBYEgqw2rHy5XOk+osUWgAW2Ycbfhnvk/dn
         7WsaLoxID2nWI8gjkR5qo2jGbR5bseTy0vBd5VoCi/3Ayyxn2qh5GSo90Ck/SvGCLKoM
         poCEmQ3WTyWM3Sol90JpGmbdbxt9Be5ZNoWdHvCANLsHW05ExmfVbXXWd5R2v0XJAJQA
         8ae8fWYSTADqW/J+GC+S0In+yezu7o1Gc5MHoaQGO1AiZjsIP+dEJq7lb2thPo8BcNSn
         o6RA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770625795; x=1771230595; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GaSxgJoK3r2WdutPTvbIx2WmRVTegp0yqHxkGr7jyZk=;
        b=AfnQ0onUxQqaxrGrJYyP7/Gx7w+Hy++YzxvCVoMgc+4+w6mnzykfhuSAw5Ul0JJGdv
         UBadhP+iks5vQHNTqLu+qQABg7qNy6fb7DAGeS58Xa8lHJjvv8ZR+9kcpeyDonezSEPZ
         3S9dtBCGazTzj392J+WddVQLEE8j6V7Loxj9hnJOuIUYCPz2CUpd06HKtj166NqiGvfT
         Uj9LOi5qvQ6pqZIOuKyVPNT2MNEcAdaCVaZX/ijufrJoBC4HlqJvPNNVP8Y+VrvNY1Hy
         yRZurToL+B9DAxToTjoyJ/Au1QOXn9HQnzaI9++uV5k9Vn23+Xg/10McKtxh1Xb4T1rQ
         iHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770625795; x=1771230595;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GaSxgJoK3r2WdutPTvbIx2WmRVTegp0yqHxkGr7jyZk=;
        b=K8sXxowT5LSGXR2vehWa+BxIB9hw6/L+a9Au+OA7O9IawJ02DB7iWBvPxn34IDwlwC
         i3bH8Jzs8GB2+HXI/DjNgByImFpdxHTLPEN6WexErnPTTsOrfdGB9jxoTBxDD95IKeg8
         5bxSB6EYT8XaKASsOvc+hnAtkeYAo2/5JkebUvRAYmhG/FzcmkKmwrrSyYwDMlysOsdC
         jLU5TvygniXnWw3qnjrzUO7FEjcpPWH9mIIa3oiEna6TsZAFI/jWMLbGzJThbcrv+2GD
         jQbtAgxgpfpkENIxmxcGDai1VKf7HRNNt0oJOI1WZQ2eG2tOX74DyHmmLlqd6AS/nEAB
         Z2vg==
X-Forwarded-Encrypted: i=1; AJvYcCVNC2E8BeByHb24hSV9CQMAMYTnFMKzWMD2ErerJQPH0zWiReIcUgCHAUYjBbxOkrdJmJQqEUI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxntM6J6hUE/0O70e/DPFatH0WiETHNelevWh064d3VMbg4h8ym
	Q+p9XBbNdFuLRx9Xb7XoXkSHt2vrLeiaU6HI4w+yI/stvYKyWMGOvvN+w6cafxMflsCtoG0bpHR
	kPi2Qduy4cce4d/7jBjEHwcgFi7TOMLo=
X-Gm-Gg: AZuq6aLWkGi4PpYw3WA72maWq4SSrn6Z5PJD1QxAomNKiOElEoDm4rnTGSbzwukxmUi
	tMoYd5sZNdOBwLOnP1lnlOSNCMVoEGlOTwr1dlbIEKllfWn0Hg/kA+kAPx5lVBpIahnd7P7J7MA
	odco1JXcZikp9oVp1UuAHqMqTGvi9sXwnz4Zv9vM8AN8l8jfo814Z8rJ1Jn2S13sjsFhTmfwmJP
	vKqZhwcbnXus4tUwAA8sJ4r4fDNMPH81hvdLqJTa1DXPPZF9LyLDN7igy5Sxd9rkYctvDYo+/wo
	nA6tFzNCYVGCcJiePSDNO2o=
X-Received: by 2002:a05:690c:6b07:b0:795:294c:fd34 with SMTP id
 00721157ae682-7952ab6da31mr91883937b3.52.1770625795217; Mon, 09 Feb 2026
 00:29:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209021134.21194-1-dqfext@gmail.com> <69898ce6.a00a0220.34fa92.0041.GAE@google.com>
In-Reply-To: <69898ce6.a00a0220.34fa92.0041.GAE@google.com>
From: Qingfang Deng <dqfext@gmail.com>
Date: Mon, 9 Feb 2026 16:29:43 +0800
X-Gm-Features: AZwV_QgW4zijmHstwgsE5rDZYq_9Sfu_6dwDt7Comz4G340LEavTLGMqzAX2xsg
Message-ID: <CALW65jac7taVKERiUUymAQ4zqzkHzqqE+RpTJP3wzFj5xvnehg@mail.gmail.com>
Subject: Re: [syzbot ci] Re: ppp: don't store tx skb in the fastpath
To: syzbot ci <syzbot+ci73cb85ac9652d7d4@syzkaller.appspotmail.com>
Cc: andrew@lunn.ch, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-ppp@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 9, 2026 at 3:29=E2=80=AFPM syzbot ci
<syzbot+ci73cb85ac9652d7d4@syzkaller.appspotmail.com> wrote:
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

I missed that ppp_send_frame() can allocate a new skb and free the old
one. Will fix it later.

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
