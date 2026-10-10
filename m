Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D8C3033F7
	for <syzbot@lists.linux.dev>; Sat, 10 Oct 2026 21:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791666887; cv=pass; b=cyyUFqA52BNX7YApSMQD6f4gzKaiEouUINAuJI7VXAn6/cQEjQtkRh+apLobanEkjF5To2Uj0l9l7U2Xatjo9mWr5FUCb7JLoVTEN0/EITBwiQgbALP6ReJPQK/eJ+ZijxdyxuG03RzGiAyxX6171hbA95pN5cGqmsDuwdskElQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791666887; c=relaxed/simple;
	bh=9LD+DeaBM/rniVALFj9y3umM40WIdFaMDd18TJA8w40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o1uKmCvLsjJDhSGKcXMjsbpcSjKZz16kyAm+PV2QcUHeqti7cg0LfdAMnXHB9eeArQ1VHmKIcq7cInx+HDNdMCike3Na7NreGQ/V8dcTUU+BUvR90xFwe0BOVBhJvN7Kryg0lHertfSHl9QqHsIT7GjhVYIlFQLCwSMp0YSfSFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I+RVp8Xb; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I+RVp8Xb"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-919abb3335fso11603026d6.0
        for <syzbot@lists.linux.dev>; Sat, 10 Oct 2026 14:14:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791666884; cv=none;
        d=google.com; s=arc-20260327;
        b=nKgWs3ORFf1Lfva3P0Vz300vhZ+Pw0ovLf7ldwqASKC/DlisnEctQknasnVw8c/k6o
         CCBfZgJGSLCBiTAT8mVVLiFMiPN3wuMW5ESNjHKzcp6iXwyuFKOhQukO3m/vhe+82Inc
         888XJ5zhcdz4+GsaB6lvfAPF26X7VjCIJhWoM0WSp0vHgGxxdTnPEXsSfZIKDdhA98QD
         j21hs1FXgmNqDK4AOLOyHaW6KpYa4227QXFrzZr8+FtiMI5sNqgI1wj1Rlw1zzVyd9vO
         +z9mImmDuHJAafVLM3Edpf+xO6BWRJlgc7llyxGYyCfN+M6zlrmPlIOPIIUoiozUY5As
         C/AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kh0m9lB5bZNziSxi0WLdMi19xYVkhH13OEUrfUXbdWI=;
        fh=cWg0N8EJJ7ey0d1psTvvcc22p3CIbZUSrNNMBWpKQIQ=;
        b=QG2VR+2tokXu/4cTVF86UGqEw+g/20fy3X6irMqWwBhuCwpk4gkXHjpNTKbP9aUF2V
         tEze+JSzFEx9r6bl+OMgy3rf6oNgGJXYX8BU8BMD3uO8oXzReNdP56HiDk5nX+gwIZBt
         FN6c5IQszqM4pTLuwkkqCK8Mm1HLn6ixQbHCXSB2dTNb4xsEmJ8vgvxNvfhisVTGJtjN
         +CjT2qqVJ3Kq5EZ5FF2NUuaOVpcMJJO+xBtr/toMfVW05znsH892NuWoc3/pC4Ye/jRl
         omtK0aGF9EpEJC910JIEbeuLKVpX2217GM888/Uy8KUSo2TnYp0gWkC2Cxlsp3AEb4JV
         hM8A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791666884; x=1792271684; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kh0m9lB5bZNziSxi0WLdMi19xYVkhH13OEUrfUXbdWI=;
        b=I+RVp8XbEVwo0Shh7s8drBHTSu/qm2o06dVhtoeDZXOtPT46MpuXcHVt7Js9Ar5d0u
         tw3+wbXt18iuxRyX2ZGmZWNFZYJzVI1Hkh8vZhoENeXREz316JlPOGvwCz399Vog/0M/
         e9XOvomu0iVdbAwEo9LLBLynahwqLAvcmSmk5PnoiN2PM7Q16A7RRI2PVQyIJ49CoYG7
         uPgJL+C39FrrmLbxlXGTzU3UB37Lzk4hyARWhUsn/jA6jX+PSSZncRx9XpAXt3id7wJF
         YqWlxhW5brRsanJFqF4dlSCJrs83x3J533bpssa/eBxqw/aMmiKYqiB6wr/9s8He8Ww8
         G/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791666884; x=1792271684;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kh0m9lB5bZNziSxi0WLdMi19xYVkhH13OEUrfUXbdWI=;
        b=GaSgF2KaOJdA78UywFyU4sa+f9Vhk+eFeXx/TAdR+JiKJsbIlJYEI6QyPxLoo5nme3
         udM4KJRSHSKms2WXG+hdXBDk2rhv9HyKsHvX0xanjUyCTnrnENA3IJToUd30Z/FB/L31
         caScZ21NvfCBf/IM248ZjHVaGvFejl2RMYPV0up0iTXlZKYOOFd5hmM6OZF6179AjE7o
         WRngBR1HdP1QeiSkzCTjnu31gY+Q4IxxA6vTfP6+DhwcdqvVnwRtj6CwA1+7TZGWkMw2
         P6Wv4NbTHZBuGPw67FUiN6R4UV36fV8BwN0cGadNweC0VrkOEDhfecR84lxVv7mLFo2J
         pV2w==
X-Forwarded-Encrypted: i=1; AKwUvByvqFbmNs1QVlZiTmRqehNLrbfnWkC9QnEnTW0/eoFfFyCy2IM4hbqH5zA/mR88iqE9ccDWJ98=@lists.linux.dev
X-Gm-Message-State: AFq9FYI8t2RVwWfLScNXXuMC13KVjx1JPgc8+tTqE8VHnjEyMWw/wjHx
	F4OQWL2BzfQWdny1/zv0sAvZS6YmNq7afnJX9FnESFu5r1MYIunwZ/hXWXZOZ4LyMWFGw2NuhIv
	Y2fX4YNkSbKtJnu1GdIgePp3G/yebgGfCNYnT8nK7
X-Gm-Gg: AYBFou0tBiVepz2F+sUae6spHy6E9e5Xch+OiUAYhnDY6hk2qnfJUlxAQAJ5VfNkU7V
	kk0glxxkQ+uebsIwgEzry7U5vuP29MQeQBYxK6QCSb6cVXvmOaHEjocrJw4Wj40zIY/XswTY7p6
	F/VrVTXX51FIfxEjYLRO1l2bo/C5su5+MDhLc5fruIPoTEqisSA25HgTYYgR1KxeDSiAjk6dv59
	ydLSYkeV9LJeahIalxs7yErQEQQw/0cRCSudy10yojTw3XV9ALHBm2rYud59guRqNa2SRyVrO/1
	zFWwY2qMeGdVBeeKMKivND9ojAPQLjWHdz9ztyfLqShOVDyk6t6JgIvTWrRcxuP4Af84LcRCuCP
	6j2wlq2BASXlragjDhM2ocfiqZ2gQi0xWt3JsylqXfL6X
X-Received: by 2002:a05:6214:498e:b0:91b:5d3b:4acc with SMTP id
 6a1803df08f44-91b5d3b4e26mr103351866d6.53.1791666883760; Sat, 10 Oct 2026
 14:14:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6acaa3bc.bbc4c7f9.15faa7.0074.GAE@google.com>
In-Reply-To: <6acaa3bc.bbc4c7f9.15faa7.0074.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Sat, 10 Oct 2026 23:14:32 +0200
X-Gm-Features: AclHuK8w4tPItzsb7o8ApD_tV8rcnXGV1cpFAqDP7cH0Xo5psaBe7hjTPYdPen4
Message-ID: <CAJWNTGxQ0Xiv4gS-GSgm7wq=KLRCD5F4ZeW9cSDGHRmoj4Jurw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: wifi: further RTNL redux
To: syzbot ci <syzbot+cibf4155e47130af9f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, Oct 10, 2026 at 10:44=E2=80=AFPM syzbot ci
<syzbot+cibf4155e47130af9f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] wifi: further RTNL redux
> https://lore.kernel.org/all/20261010160459.229064-11-johannes@sipsolution=
s.net
> * [PATCH RESEND wireless-next 1/9] wifi: nl80211: avoid RTNL in nl80211_g=
et_reg_do()
> * [PATCH RESEND wireless-next 2/9] wifi: cfg80211: drop RTNL from disconn=
ect_work
> * [PATCH RESEND wireless-next 3/9] wifi: nl80211: don't hold RTNL for SET=
_SAR_SPECS
> * [PATCH RESEND wireless-next 4/9] wifi: cfg80211: switch wiphy netns und=
er cfg80211_mutex
> * [PATCH RESEND wireless-next 5/9] wifi: nl80211: avoid RTNL for wiphy/in=
terface netlink dumps
> * [PATCH RESEND wireless-next 6/9] wifi: cfg80211: protect wiphy names wi=
th cfg80211_mutex
> * [PATCH RESEND wireless-next 7/9] wifi: cfg80211: check wiphy name in wi=
phy_register()
> * [PATCH RESEND wireless-next 8/9] wifi: mac80211: don't hold RTNL for ra=
te control algo
> * [PATCH RESEND wireless-next 9/9] wifi: mac80211: fix interface registra=
tion error path order
>
> and found the following issues:
> * KASAN: slab-use-after-free Read in NUM
> * KASAN: slab-use-after-free Read in append_radio_msg
>
> Full report is available here:
> https://ci.syzbot.org/series/51e15aa3-1f1c-404d-b5c8-c1065c90bcb0
>
> ***
>
> KASAN: slab-use-after-free Read in NUM
>
> tree:      wireless-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wirel=
ess/wireless-next.git
> base:      fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/2d1bce7d-9b9b-4d15-9fb8-ca75e747b=
223/config
> AI triage: https://ci.syzbot.org/findings/16122501-0ad0-4e77-82f8-2bc9a7a=
74e63/triage_trajectory
>
> netlink: 76 bytes leftover after parsing attributes in process `syz.1.35'=
.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in strlen+0x57/0x70
> Read of size 1 at addr ffff888116dae800 by task syz.1.35/5916
>
> CPU: 0 UID: 0 PID: 5916 Comm: syz.1.35 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>    53.418828][ T5916]
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  print_address_description+0x55/0x1e0
>  print_report+0x58/0x70
>  kasan_report+0x117/0x150
>  strlen+0x57/0x70
>  append_radio_msg+0x3cc/0x5f0
>  mac80211_hwsim_new_radio+0x41cd/0x5750
>  hwsim_new_radio_nl+0xd8b/0xf90
>  genl_family_rcv_msg_doit+0x233/0x340
>  genl_rcv_msg+0x614/0x7a0
>  netlink_rcv_skb+0x226/0x4a0
>  genl_rcv+0x28/0x40
>  netlink_unicast+0x7bd/0x940
>  netlink_sendmsg+0x813/0xb40
>  sock_sendmsg_nosec+0x14e/0x190
>  ____sys_sendmsg+0x54e/0x850
>  ___sys_sendmsg+0x2a5/0x360
>  __x64_sys_sendmsg+0x1b1/0x290
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4941d9e1d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f493ffd5028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f4942026090 RCX: 00007f4941d9e1d9
> RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000005
> RBP: 00007f4941e35888 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4942026128 R14: 00007f4942026090 R15: 00007ffdf55e71e8
>  </TASK>
>
> Allocated by task 5916:
>  kasan_save_track+0x3e/0x80
>  __kasan_kmalloc+0x93/0xb0
>  __kmalloc_node_track_caller_noprof+0x4b4/0x720
>  kstrdup+0x42/0x100
>  kobject_set_name_vargs+0x61/0x110
>  dev_set_name+0xe2/0x140
>  wiphy_new_nm+0x710/0x1ae0
>  ieee80211_alloc_hw_nm+0x3f3/0x1f00
>  mac80211_hwsim_new_radio+0x1ea/0x5750
>  hwsim_new_radio_nl+0xd8b/0xf90
>  genl_family_rcv_msg_doit+0x233/0x340
>  genl_rcv_msg+0x614/0x7a0
>  netlink_rcv_skb+0x226/0x4a0
>  genl_rcv+0x28/0x40
>  netlink_unicast+0x7bd/0x940
>  netlink_sendmsg+0x813/0xb40
>  sock_sendmsg_nosec+0x14e/0x190
>  ____sys_sendmsg+0x54e/0x850
>  ___sys_sendmsg+0x2a5/0x360
>  __x64_sys_sendmsg+0x1b1/0x290
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5916:
>  kasan_save_track+0x3e/0x80
>  kasan_save_free_info+0x40/0x50
>  __kasan_slab_free+0x5c/0x80
>  kfree+0x1c5/0x650
>  kobject_set_name_vargs+0xca/0x110
>  dev_set_name+0xe2/0x140
>  wiphy_register+0x214e/0x3290
>  ieee80211_register_hw+0x3d72/0x4b30
>  mac80211_hwsim_new_radio+0x3284/0x5750
>  hwsim_new_radio_nl+0xd8b/0xf90
>  genl_family_rcv_msg_doit+0x233/0x340
>  genl_rcv_msg+0x614/0x7a0
>  netlink_rcv_skb+0x226/0x4a0
>  genl_rcv+0x28/0x40
>  netlink_unicast+0x7bd/0x940
>  netlink_sendmsg+0x813/0xb40
>  sock_sendmsg_nosec+0x14e/0x190
>  ____sys_sendmsg+0x54e/0x850
>  ___sys_sendmsg+0x2a5/0x360
>  __x64_sys_sendmsg+0x1b1/0x290
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888116dae800
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 0 bytes inside of
>  freed 64-byte region [ffff888116dae800, ffff888116dae840)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x116d=
ae
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, =
tgid 1 (swapper/0), ts 10987624482
>  post_alloc_hook+0x1f9/0x250
>  get_page_from_freelist+0x2209/0x2280
>  __alloc_frozen_pages_noprof+0x217/0x5a0
>  allocate_slab+0x7d/0x620
>  refill_objects+0x2d5/0x350
>  __pcs_replace_empty_main+0x2c8/0x6c0
>  __kmalloc_node_track_caller_noprof+0x548/0x720
>  krealloc_node_align_noprof+0x19a/0x390
>  add_sysfs_param+0x15f/0xb80
>  kernel_add_sysfs_param+0x7f/0xe0
>  param_sysfs_builtin+0x199/0x250
>  param_sysfs_builtin_init+0x23/0x30
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x10a/0x1a0
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x29d/0x3e0
> page last free pid 9 tgid 9 ts 10970419393 stack trace:
>  __free_frozen_pages+0xc93/0xd90
>  kasan_depopulate_vmalloc_pte+0x6d/0x90
>  __apply_to_page_range+0xbd8/0x1420
>  __kasan_release_vmalloc+0xa2/0xd0
>  purge_vmap_node+0x220/0x960
>  __purge_vmap_area_lazy+0x783/0xb40
>  drain_vmap_area_work+0x27/0x40
>  process_scheduled_works+0xc3d/0x1630
>  worker_thread+0xa47/0xfb0
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>
> Memory state around the buggy address:
>  ffff888116dae700: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff888116dae780: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> >ffff888116dae800: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>                    ^
>  ffff888116dae880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff888116dae900: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-use-after-free Read in append_radio_msg
>
> tree:      wireless-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wirel=
ess/wireless-next.git
> base:      fbfa27d9b06f025c5f2cfa79d0e01e6400eeff2a
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/2d1bce7d-9b9b-4d15-9fb8-ca75e747b=
223/config
> syz repro: https://ci.syzbot.org/findings/32e84c9a-2451-4ee9-8f84-a781e00=
11961/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in strlen+0x57/0x70 lib/string.c:402
> Read of size 1 at addr ffff8881157eac40 by task syz.1.20/5852
>
> CPU: 0 UID: 0 PID: 5852 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  strlen+0x57/0x70 lib/string.c:402
>  __fortify_strlen include/linux/fortify-string.h:218 [inline]
>  append_radio_msg+0x3cc/0x5f0 drivers/net/wireless/virtual/mac80211_hwsim=
_main.c:4484
>  hwsim_mcast_new_radio drivers/net/wireless/virtual/mac80211_hwsim_main.c=
:4519 [inline]
>  mac80211_hwsim_new_radio+0x41cd/0x5750 drivers/net/wireless/virtual/mac8=
0211_hwsim_main.c:6243
>  hwsim_new_radio_nl+0xd8b/0xf90 drivers/net/wireless/virtual/mac80211_hws=
im_main.c:7061
>  genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2572
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1361
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1916
>  sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
>  __sock_sendmsg net/socket.c:818 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
>  __sys_sendmsg net/socket.c:2801 [inline]
>  __do_sys_sendmsg net/socket.c:2806 [inline]
>  __se_sys_sendmsg net/socket.c:2804 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd7e8f9e1d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd7e9e0b028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fd7e9225fa0 RCX: 00007fd7e8f9e1d9
> RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000004
> RBP: 00007fd7e9035888 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd7e9226038 R14: 00007fd7e9225fa0 R15: 00007ffc32258e48
>  </TASK>
>
> Allocated by task 5852:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5414 [inline]
>  __kmalloc_node_track_caller_noprof+0x4b4/0x720 mm/slub.c:5545
>  __kmemdup_nul mm/util.c:64 [inline]
>  kstrdup+0x42/0x100 mm/util.c:84
>  kobject_set_name_vargs+0x61/0x110 lib/kobject.c:274
>  dev_set_name+0xe2/0x140 drivers/base/core.c:3564
>  wiphy_new_nm+0x710/0x1ae0 net/wireless/core.c:665
>  ieee80211_alloc_hw_nm+0x3f3/0x1f00 net/mac80211/main.c:858
>  mac80211_hwsim_new_radio+0x1ea/0x5750 drivers/net/wireless/virtual/mac80=
211_hwsim_main.c:5747
>  hwsim_new_radio_nl+0xd8b/0xf90 drivers/net/wireless/virtual/mac80211_hws=
im_main.c:7061
>  genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2572
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1361
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1916
>  sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
>  __sock_sendmsg net/socket.c:818 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
>  __sys_sendmsg net/socket.c:2801 [inline]
>  __do_sys_sendmsg net/socket.c:2806 [inline]
>  __se_sys_sendmsg net/socket.c:2804 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5852:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:264 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2748 [inline]
>  slab_free mm/slub.c:6509 [inline]
>  kfree+0x1c5/0x650 mm/slub.c:6802
>  kobject_set_name_vargs+0xca/0x110 lib/kobject.c:293
>  dev_set_name+0xe2/0x140 drivers/base/core.c:3564
>  wiphy_register+0x214e/0x3290 net/wireless/core.c:1227
>  ieee80211_register_hw+0x3d72/0x4b30 net/mac80211/main.c:1634
>  mac80211_hwsim_new_radio+0x3284/0x5750 drivers/net/wireless/virtual/mac8=
0211_hwsim_main.c:6188
>  hwsim_new_radio_nl+0xd8b/0xf90 drivers/net/wireless/virtual/mac80211_hws=
im_main.c:7061
>  genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2572
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1361
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1916
>  sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
>  __sock_sendmsg net/socket.c:818 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
>  __sys_sendmsg net/socket.c:2801 [inline]
>  __do_sys_sendmsg net/socket.c:2806 [inline]
>  __se_sys_sendmsg net/socket.c:2804 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff8881157eac40
>  which belongs to the cache kmalloc-16 of size 16
> The buggy address is located 0 bytes inside of
>  freed 16-byte region [ffff8881157eac40, ffff8881157eac50)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881157e=
a2c0 pfn:0x1157ea
> flags: 0x17ff00000000200(workingset|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000200 ffff888100041640 ffffea00045d6b10 ffffea000415b550
> raw: ffff8881157ea2c0 000000000080007f 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, =
tgid 1 (swapper/0), ts 9509757778
>  create_dummy_stack mm/page_owner.c:121 [inline]
>  register_dummy_stack+0x98/0x100 mm/page_owner.c:127
>  init_page_owner+0x2e/0x600 mm/page_owner.c:145
>  invoke_init_callbacks mm/page_ext.c:152 [inline]
>  page_ext_init+0x511/0x550 mm/page_ext.c:485
>  mm_core_init+0x97/0xb0 mm/mm_init.c:2685
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff8881157eab00: 00 01 fc fc 00 00 fc fc 00 01 fc fc 00 01 fc fc
>  ffff8881157eab80: 00 00 fc fc 00 00 fc fc fa fb fc fc fa fb fc fc
> >ffff8881157eac00: fa fb fc fc 00 01 fc fc fa fb fc fc fa fb fc fc
>                                            ^
>  ffff8881157eac80: 00 02 fc fc 00 02 fc fc 00 00 fc fc 00 00 fc fc
>  ffff8881157ead00: 00 00 fc fc 00 00 fc fc 00 00 fc fc 00 02 fc fc
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
> [johannes.berg@intel.com johannes@sipsolutions.net linux-wireless@vger.ke=
rnel.org]
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
-upstream-moderation/6acaa3bc.bbc4c7f9.15faa7.0074.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
