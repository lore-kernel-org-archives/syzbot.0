Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794170394;
	b=4sQhWca1uxpFKfZLwbAaP29XG1XwU14Kf1rBKu58nYMAfPipsQOFZ6n+LY7GWeDa5Blz
	 gc4JR5Q+WrKiDdLWgUpJYsFW7HASPdpAwJDID+kttIfuXPqhtgF4jPnvpgueOTL5VOPaz
	 J+0mfxRptVFc4nXvDfFvFXH5hFRrnXxBPpvtdYemKDuATKJM3wBR7uHzbo2cRMuUwjPB6
	 zuEdDiOCUTaHZfa6PTjFqGVdc1U49g4KnZ2iZaXAGeYbQAR6qBRVdF6Q4pgzBON6RtCtj
	 RFdrGrqY33jOBKtor4jiuEG4IGmwMpB9bO4TAdg0yxG1hiXyWv42syr3exhcoRbMPbg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170394;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=VIsDWGErw0p0+NEINW2Cw1oYjCh0sI7g3YfB3pKEXU0=;
	b=CaEQERWMEbrEC6AomJFrBWWAAbNJp21wjLSyu65L/5jttIRRqqddtPtSlWzCrRrFQ7uy
	 wlgGX7B/W5aZo/q2zalL61VaXLmxk95hnCTmwvl/+Gi2j75irPSFTctaHXI1PUBbrtmC4
	 b3U7V04g4CoVMgtVaVD3t/9vvG9A9JHK80FoQb1CFkGYPn7xoE7QIg+CVNDns+oyTHRah
	 Y2L1h9sFjx1o6V+kUJ8hTKTUoWE3lQ0QSsrP0BqR37a7ra0JxMupiVCQNHMHuDF9aJaIF
	 Hm4loHdfg7v35k52rNt1teUu136SoDN7bP+sp+8i19jUPfICO8BRANpcsDH2PNokemA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mCkJclwE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.174
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283A4606A31C
	for <syzbot@lists.linux.dev>; Sun,  8 Nov 2026 20:39:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 283A4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mCkJclwE
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-4b190cdc9feso139638b6e.0
        for <syzbot@lists.linux.dev>; Sun, 08 Nov 2026 12:39:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794170393; cv=none;
        d=google.com; s=arc-20260327;
        b=OnNZXKRcVo6VqduC5Z2zv9erHwis76oYqmMfzJN+akQZNyUaOzGVHzNkjLmBNRU82Q
         s/h84op60uAUIabwinvu2UhfTdz79Ws3WBY1/Fk2kWiYlOOEC8sQD3ojDLQaSp+PvTB4
         xhwQeFx7RWremglfkBLLr2GrbS6VJg385kfC2f4QGSblmo+tpjzS7yM+Kkgh/ANoYs42
         CW/gpSC4gX4GZHngWNj3XNnfWFBdVBpNzqC+KByPC8W8ZXbeHqP2iMjwYdOxm2zUxJke
         nq4kspAKJGqNVgKxi/V23MsTAhjxdcqHNJddIVYedv+bpvv/vJG56yiU2dV2zcK2W8b9
         TMJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VIsDWGErw0p0+NEINW2Cw1oYjCh0sI7g3YfB3pKEXU0=;
        fh=jTVBv2/HfrG5LsPTrC3uUnzemHJBVTzqfbH2OkiFAto=;
        b=EeYxpam4PwKD9SwymG+oLDQTzHsW1u4LYTzifrmUGZP0ww/+jSa+fP1wsvE3tGlyCX
         +GKhqelGPvhb7y6I51RugRfLciyh1gv8nb1UNHm4HQu8qjr+BmLN52jWHATuE64TNI5y
         0+5gW7eOTi6yvSeYqW/J9UwP/VP0zNxpYC03BIotkPijY+vq0FRLnh9dPydzvl0vsYeg
         xgAMpgxv/H9mXXZBDrPhV/ggET04SiQwLBu5Ajr9aKWb4acUNLH3mJ9NjOZmihr2MLIg
         t7/gMAk1Phck1280EYFyNox7Oc0M9oizdx9H382VKJrFfDeIu9gxKipKRqL7flRcHeh9
         YFWQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794170393; x=1794775193; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VIsDWGErw0p0+NEINW2Cw1oYjCh0sI7g3YfB3pKEXU0=;
        b=mCkJclwEGdstpE/tlAemb9hGE69YlyfQxYsOqxYwlQn3X35L15RKgRyt1KgOuZ47pH
         AQvj6G8jNTE9U63VLPr6HhHWcOYv5sMNi0EkfRVZTXC9EtBvLJaA+RuGPEAH+jtY4by/
         75PJZkRYEol57mDuQQ+vLfiFHjt2QSd5ONQkhIw+4apYmnzsldiTHOEpG9AzridAqyA0
         xKwojaKc6/blvgP68iCdbE0IBdQ8KGxu77MSS44pEKp+o4a4V7GHY4E+c4Hxnd4v14zn
         LYMYr2M7YCxAiN1maL+ER+YJTD1DhorDaWQxHlUTgtVJp8OPRPTbO/uy+QI/mollmPk9
         A0dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794170393; x=1794775193;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VIsDWGErw0p0+NEINW2Cw1oYjCh0sI7g3YfB3pKEXU0=;
        b=nsNf+NvbwTEnwKvO3F9JvWWbY1kMrfH+V0cG1IQfZRt+oGGO6IbPMZ301XagZGnjS1
         WRWPSbFpXyBt92IKT0qWR2WyD/DIOMB8sN++UvRt0PKoYYKZQ9nmoFwdjom6LYiBHu8W
         bEQxkdlQ0smZeyVvVE/CAh97aAAv0Jct9SGgavZ1xuUOmtPDlNcBwF6EqJcRKibg0erm
         liaN3+KECw8dGZ5plQg2eur8gJoa7DFNFf9j1ouT52DMnKTepeZvXyUfOLjPAuS816lj
         XZorQFe7E0O8zOCuj/7dTcpa6+04i4Hj1t6Oy34HPjlt9lD1VEyLIoZLKIJAxI9co8GB
         M78w==
X-Forwarded-Encrypted: i=1; AL+hErFtxz4vMhnSmoBDcKqsjIjNq6o4su6mraCcS+3ZC1m2vbVgjeDrWxfTpM9SIcX6LAlgedm/5Co=@lists.linux.dev
X-Gm-Message-State: APuU4Z8VgMy0bMUdWnQh/xP7mlIyLNcwDtURQ2VYiAlNdQbDjvz6jIAD
	BHpScOI5M1NumgoKyf/47tUgAMR5Ao5wng44eioPpDzE1kcLwG6Gg9tRTdxNCQZ9iawIMgrKLuM
	6cANvVU4GU+WarPjucnUmS+ca9YkrHrUE07HE8pci
X-Gm-Gg: AYBFou2gomtXcQvbRaPuyHjR5nvBqDjadIZoIqhMP96HLc4VZa+lGro4Y2tXz8jnH02
	hrQdbpIsQT51xkXXOyL7DlkcfXpxUBCRjxzf2mvBRv3/u6zc/HBAsR0NvSLRMtoHMNajbVQuuij
	DCemDKZWfX0cF62jHwS4nG9EWzxgg7ZxwrSBZMrK6cXi7K0HEcXjOMMxdRPPDtPWtevzCqGlz4S
	z4N98FRJhDmBUjyZqnILb7LEXXxWxWy+OC8/W3JPDlKnrFpoaeXBv5GvZdwGOWEs8NbhQC9KAnJ
	IVEtJ96nOvoZMLNCgEWXaLPb53v54qx6ROl1Ks/t10BrviD5P3PfG5oDK0Akim5la6p5SxSvx0M
	bDdgWyrdtDGiQJiu208nxuxJ113A8X+xXIlUdXl86kHYr84Vg5xg0uZwyQOIr0mU2ORcqEPJI1m
	zd+/AJPq2PfxbNSI3oA+CoNrxjPOTRuuQpYT2bggB6W0mlw9VxgMMCj+HbGYCF1epAuZgCbL7UX
	f/k3dHh
X-Received: by 2002:a05:6808:19a2:b0:567:f627:67f7 with SMTP id
 5614622812f47-568144b6c1emr1923697b6e.27.1794170392376; Sun, 08 Nov 2026
 12:39:52 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6af0b845.4dd4714a.f8d02.0018.GAE@google.com>
In-Reply-To: <6af0b845.4dd4714a.f8d02.0018.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 8 Nov 2026 21:39:41 +0100
X-Gm-Features: AclHuK-q9Ed1lB0eF61iKd4jD8hOxdvQJYgUkMHxMD_Xulz835D9HTeBTc9-dks
Message-ID: <CANp29Y50Vz9P1icqE9ANwL6wyF69Om_h-EKW9a8M1xe2mRHs=g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: configfs: fix slab-UAF Write in config_item_put
To: syzbot ci <syzbot+ci93000cdc57c52911@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sun, Nov 8, 2026 at 6:58=E2=80=AFPM syzbot ci
<syzbot+ci93000cdc57c52911@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] configfs: fix slab-UAF Write in config_item_put
> https://lore.kernel.org/all/20261105165055.362-1-drifabdelmalekmohamedsai=
d@gmail.com
> * [PATCH v3] configfs: fix slab-UAF Write in config_item_put
>
> and found the following issues:
> * KASAN: slab-use-after-free Write in config_item_get
> * kernel BUG in config_item_get
> * kernel BUG in configfs_symlink
>
> Full report is available here:
> https://ci.syzbot.org/series/6e7e3ace-c083-43ff-9d6c-4b65ef15bd2f
>
> ***
>
> KASAN: slab-use-after-free Write in config_item_get
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      691edd89507f8977eb8831892c3b460edc79d73c
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/b34863a5-8646-4b81-a3b6-8d7c722db=
7f8/config
> syz repro: https://ci.syzbot.org/findings/4586cba9-fdc4-48a1-bbe4-43b477a=
6d2cf/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/l=
inux/instrumented.h:112 [inline]
> BUG: KASAN: slab-use-after-free in atomic_fetch_add_relaxed include/linux=
/atomic/atomic-instrumented.h:252 [inline]
> BUG: KASAN: slab-use-after-free in __refcount_add include/linux/refcount.=
h:283 [inline]
> BUG: KASAN: slab-use-after-free in __refcount_inc include/linux/refcount.=
h:366 [inline]
> BUG: KASAN: slab-use-after-free in refcount_inc include/linux/refcount.h:=
383 [inline]
> BUG: KASAN: slab-use-after-free in kref_get include/linux/kref.h:45 [inli=
ne]
> BUG: KASAN: slab-use-after-free in config_item_get+0x26/0x90 fs/configfs/=
item.c:104
> Write of size 4 at addr ffff8881191a501c by task syz.1.22/5911
>
> CPU: 0 UID: 0 PID: 5911 Comm: syz.1.22 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
>  atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:252 =
[inline]
>  __refcount_add include/linux/refcount.h:283 [inline]
>  __refcount_inc include/linux/refcount.h:366 [inline]
>  refcount_inc include/linux/refcount.h:383 [inline]
>  kref_get include/linux/kref.h:45 [inline]
>  config_item_get+0x26/0x90 fs/configfs/item.c:104
>  configfs_get_config_item fs/configfs/configfs_internal.h:127 [inline]
>  configfs_symlink+0x17d/0xa60 fs/configfs/symlink.c:167
>  vfs_symlink+0x18e/0x370 fs/namei.c:5812
>  filename_symlinkat+0x1a5/0x430 fs/namei.c:5837
>  __do_sys_symlinkat fs/namei.c:5857 [inline]
>  __se_sys_symlinkat+0x4e/0x2b0 fs/namei.c:5852
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ffbd0f9fb19
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffbd1dfb028 EFLAGS: 00000246 ORIG_RAX: 000000000000010a
> RAX: ffffffffffffffda RBX: 00007ffbd1225fa0 RCX: 00007ffbd0f9fb19
> RDX: 0000200000000780 RSI: ffffffffffffff9c RDI: 0000200000000740
> RBP: 00007ffbd1037b70 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffbd1226038 R14: 00007ffbd1225fa0 R15: 00007ffeea8f6108
>  </TASK>
>
> Allocated by task 5903:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x31c/0x600 mm/slub.c:5680
>  _kmalloc_noprof include/linux/slab.h:991 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  config_desc_make+0x23e/0x620 drivers/usb/gadget/configfs.c:730
>  configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1369
>  vfs_mkdir+0x411/0x660 fs/namei.c:5428
>  filename_mkdirat+0x284/0x550 fs/namei.c:5461
>  __do_sys_mkdirat fs/namei.c:5482 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5479
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5908:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:264 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2780 [inline]
>  slab_free mm/slub.c:6630 [inline]
>  kfree+0x1c5/0x650 mm/slub.c:6923
>  config_item_cleanup fs/configfs/item.c:128 [inline]
>  config_item_release+0x13a/0x2d0 fs/configfs/item.c:137
>  configfs_symlink+0x7b4/0xa60 fs/configfs/symlink.c:240
>  vfs_symlink+0x18e/0x370 fs/namei.c:5812
>  filename_symlinkat+0x1a5/0x430 fs/namei.c:5837
>  __do_sys_symlinkat fs/namei.c:5857 [inline]
>  __se_sys_symlinkat+0x4e/0x2b0 fs/namei.c:5852
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff8881191a5000
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 28 bytes inside of
>  freed 1024-byte region [ffff8881191a5000, ffff8881191a5400)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1191=
a0
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000040 ffff888100041dc0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
> head: 017ff00000000040 ffff888100041dc0 dead000000000100 dead000000000122
> head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
> head: 017ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2820(=
GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 569=
7, tgid 5697 (kworker/u8:3), ts 73161807282
>  set_page_owner include/linux/page_owner.h:33 [inline]
>  post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1856
>  prep_new_page mm/page_alloc.c:1864 [inline]
>  get_page_from_freelist+0x220f/0x2280 mm/page_alloc.c:3935
>  __alloc_frozen_pages_noprof+0x1fe/0x410 mm/page_alloc.c:5444
>  alloc_slab_page mm/slub.c:3384 [inline]
>  allocate_slab+0x7d/0x5e0 mm/slub.c:3499
>  new_slab mm/slub.c:3550 [inline]
>  refill_objects+0x2d5/0x350 mm/slub.c:7539
>  refill_sheaf mm/slub.c:2917 [inline]
>  __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4811
>  alloc_from_pcs mm/slub.c:4887 [inline]
>  slab_alloc_node mm/slub.c:5021 [inline]
>  __do_kmalloc_node mm/slub.c:5530 [inline]
>  __kmalloc_noprof+0x476/0x710 mm/slub.c:5556
>  _kmalloc_noprof include/linux/slab.h:995 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  neigh_alloc net/core/neighbour.c:525 [inline]
>  ___neigh_create+0x6da/0x21f0 net/core/neighbour.c:659
>  ip6_finish_output2+0xe06/0x1460 net/ipv6/ip6_output.c:130
>  NF_HOOK_COND include/linux/netfilter.h:314 [inline]
>  ip6_output+0x337/0x540 net/ipv6/ip6_output.c:248
>  dst_output include/net/dst.h:472 [inline]
>  NF_HOOK include/linux/netfilter.h:325 [inline]
>  ndisc_send_skb+0xcb2/0x1650 net/ipv6/ndisc.c:513
>  ndisc_send_ns+0xd7/0x160 net/ipv6/ndisc.c:672
>  addrconf_dad_work+0xa8d/0x15c0 net/ipv6/addrconf.c:4343
>  process_one_work kernel/workqueue.c:3495 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
>  kthread+0x38b/0x480 kernel/kthread.c:436
> page last free pid 5696 tgid 5696 ts 63917357465 stack trace:
>  reset_page_owner include/linux/page_owner.h:26 [inline]
>  __free_pages_prepare mm/page_alloc.c:1403 [inline]
>  __free_frozen_pages+0xc97/0xd90 mm/page_alloc.c:2954
>  __slab_free+0x269/0x2c0 mm/slub.c:5926
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:361
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4720 [inline]
>  slab_alloc_node mm/slub.c:5033 [inline]
>  kmem_cache_alloc_noprof+0x2b4/0x600 mm/slub.c:5047
>  __proc_create+0x55d/0xad0 fs/proc/generic.c:462
>  proc_create_reg fs/proc/generic.c:606 [inline]
>  proc_create_data+0xa5/0x190 fs/proc/generic.c:620
>  nfs_net_init+0x1a7/0x290 fs/nfs/inode.c:2777
>  ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
>  setup_net+0x118/0x350 net/core/net_namespace.c:443
>  copy_net_ns+0x536/0x770 net/core/net_namespace.c:584
>  create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
>  unshare_nsproxy_namespaces+0x144/0x190 kernel/nsproxy.c:234
>  ksys_unshare+0x532/0x890 kernel/fork.c:3320
>  __do_sys_unshare kernel/fork.c:3386 [inline]
>  __se_sys_unshare kernel/fork.c:3384 [inline]
>  __x64_sys_unshare+0x38/0x50 kernel/fork.c:3384
>
> Memory state around the buggy address:
>  ffff8881191a4f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8881191a4f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff8881191a5000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                             ^
>  ffff8881191a5080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881191a5100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> kernel BUG in config_item_get
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      691edd89507f8977eb8831892c3b460edc79d73c
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/b34863a5-8646-4b81-a3b6-8d7c722db=
7f8/config
> syz repro: https://ci.syzbot.org/findings/1475de5c-5602-4f7c-97d8-fa318d3=
969f7/syz_repro
>
> refcount_t: addition on 0; use-after-free.
> ------------[ cut here ]------------
> kernel BUG at lib/refcount.c:34!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 5904 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:refcount_warn_saturate+0xf0/0x110 lib/refcount.c:34
> Code: 80 c1 03 38 c1 0f 8c 6a ff ff ff 4c 89 f7 e8 a7 10 51 fd e9 5d ff f=
f ff e8 fd c2 d9 fc 48 c7 c7 a0 98 8c 8c e8 e1 73 38 fc 90 <0f> 0b e8 e9 c2=
 d9 fc 48 c7 c7 20 99 8c 8c e8 cd 73 38 fc 90 0f 0b
> RSP: 0018:ffffc900030bfc68 EFLAGS: 00010246
> RAX: 000000000000002a RBX: 0000000000000002 RCX: ca30be1f7752be00
> RDX: 0000000000000000 RSI: 8000000000000001 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffc900030bf9e7 R09: 1ffff92000617f3c
> R10: dffffc0000000000 R11: fffff52000617f3d R12: 1ffff1102365c80a
> R13: ffff88811776d218 R14: ffff888117f184b4 R15: ffff8881ba75a598
> FS:  00007fcbbc6696c0(0000) GS:ffff88818be0d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fcbbb6716a0 CR3: 0000000117a68000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __refcount_add include/linux/refcount.h:-1 [inline]
>  __refcount_inc include/linux/refcount.h:366 [inline]
>  refcount_inc include/linux/refcount.h:383 [inline]
>  kref_get include/linux/kref.h:45 [inline]
>  config_item_get+0x88/0x90 fs/configfs/item.c:104
>  configfs_get_config_item fs/configfs/configfs_internal.h:127 [inline]
>  configfs_symlink+0x17d/0xa60 fs/configfs/symlink.c:167
>  vfs_symlink+0x18e/0x370 fs/namei.c:5812
>  filename_symlinkat+0x1a5/0x430 fs/namei.c:5837
>  __do_sys_symlinkat fs/namei.c:5857 [inline]
>  __se_sys_symlinkat+0x4e/0x2b0 fs/namei.c:5852
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fcbbb79fb19
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fcbbc669028 EFLAGS: 00000246 ORIG_RAX: 000000000000010a
> RAX: ffffffffffffffda RBX: 00007fcbbba25fa0 RCX: 00007fcbbb79fb19
> RDX: 0000200000000840 RSI: ffffffffffffff9c RDI: 0000200000000800
> RBP: 00007fcbbb837b70 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fcbbba26038 R14: 00007fcbbba25fa0 R15: 00007ffd984fbca8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:refcount_warn_saturate+0xf0/0x110 lib/refcount.c:34
> Code: 80 c1 03 38 c1 0f 8c 6a ff ff ff 4c 89 f7 e8 a7 10 51 fd e9 5d ff f=
f ff e8 fd c2 d9 fc 48 c7 c7 a0 98 8c 8c e8 e1 73 38 fc 90 <0f> 0b e8 e9 c2=
 d9 fc 48 c7 c7 20 99 8c 8c e8 cd 73 38 fc 90 0f 0b
> RSP: 0018:ffffc900030bfc68 EFLAGS: 00010246
> RAX: 000000000000002a RBX: 0000000000000002 RCX: ca30be1f7752be00
> RDX: 0000000000000000 RSI: 8000000000000001 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffc900030bf9e7 R09: 1ffff92000617f3c
> R10: dffffc0000000000 R11: fffff52000617f3d R12: 1ffff1102365c80a
> R13: ffff88811776d218 R14: ffff888117f184b4 R15: ffff8881ba75a598
> FS:  00007fcbbc6696c0(0000) GS:ffff88818be0d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fcbbb6716a0 CR3: 0000000117a68000 CR4: 00000000000006f0
>
>
> ***
>
> kernel BUG in configfs_symlink
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      691edd89507f8977eb8831892c3b460edc79d73c
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/b34863a5-8646-4b81-a3b6-8d7c722db=
7f8/config
> AI triage: https://ci.syzbot.org/findings/124f4628-8711-4fab-bb9a-b0f7ba1=
656ba/triage_trajectory
>
> refcount_t: underflow; use-after-free.
> ------------[ cut here ]------------
> kernel BUG at lib/refcount.c:37!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5815 Comm: syz.2.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:refcount_warn_saturate+0x104/0x110
> Code: 5d ff ff ff e8 fd c2 d9 fc 48 c7 c7 a0 98 8c 8c e8 e1 73 38 fc 90 0=
f 0b e8 e9 c2 d9 fc 48 c7 c7 20 99 8c 8c e8 cd 73 38 fc 90 <0f> 0b 66 2e 0f=
 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc90006787c88 EFLAGS: 00010246
> RAX: 0000000000000026 RBX: 0000000000000003 RCX: 7d2d66e1f00cde00
> RDX: 0000000000000000 RSI: 8000000000000000 RDI: 0000000000000000
> RBP: ffffc90006787d88 R08: ffffc90006787a07 R09: 1ffff92000cf0f40
> R10: dffffc0000000000 R11: fffff52000cf0f41 R12: 1ffff110228fe2e2
> R13: 00000000fffffffe R14: ffff88816f8584b4 R15: 1ffff92000cf0fa0
> FS:  00007f3b9041d6c0(0000) GS:ffff8882a780d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007feda95bb440 CR3: 0000000110044000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  configfs_symlink+0x7b4/0xa60
>  vfs_symlink+0x18e/0x370
>  filename_symlinkat+0x1a5/0x430
>  __se_sys_symlinkat+0x4e/0x2b0
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3b8f59fb19
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3b9041d028 EFLAGS: 00000246 ORIG_RAX: 000000000000010a
> RAX: ffffffffffffffda RBX: 00007f3b8f826090 RCX: 00007f3b8f59fb19
> RDX: 0000200000000840 RSI: ffffffffffffff9c RDI: 0000200000000800
> RBP: 00007f3b8f637b70 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3b8f826128 R14: 00007f3b8f826090 R15: 00007ffcd3b51e38
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:refcount_warn_saturate+0x104/0x110
> Code: 5d ff ff ff e8 fd c2 d9 fc 48 c7 c7 a0 98 8c 8c e8 e1 73 38 fc 90 0=
f 0b e8 e9 c2 d9 fc 48 c7 c7 20 99 8c 8c e8 cd 73 38 fc 90 <0f> 0b 66 2e 0f=
 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc90006787c88 EFLAGS: 00010246
> RAX: 0000000000000026 RBX: 0000000000000003 RCX: 7d2d66e1f00cde00
> RDX: 0000000000000000 RSI: 8000000000000000 RDI: 0000000000000000
> RBP: ffffc90006787d88 R08: ffffc90006787a07 R09: 1ffff92000cf0f40
> R10: dffffc0000000000 R11: fffff52000cf0f41 R12: 1ffff110228fe2e2
> R13: 00000000fffffffe R14: ffff88816f8584b4 R15: 1ffff92000cf0fa0
> FS:  00007f3b9041d6c0(0000) GS:ffff88818be0d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd9936587f0 CR3: 0000000110044000 CR4: 00000000000006f0
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
> [a.hindborg@kernel.org brauner@kernel.org drifabdelmalekmohamedsaid@gmail=
.com jack@suse.cz leitao@debian.org linux-fsdevel@vger.kernel.org linux-ker=
nel@vger.kernel.org ranhongyun1@huawei.com syzbot@syzkaller.appspotmail.com=
 syzkaller-bugs@googlegroups.com viro@zeniv.linux.org.uk]
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
-upstream-moderation/6af0b845.4dd4714a.f8d02.0018.GAE%40google.com.
