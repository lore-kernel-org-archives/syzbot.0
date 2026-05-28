Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A01B49253F
	for <syzbot@lists.linux.dev>; Thu, 28 May 2026 14:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779980065; cv=none; b=VCW2L9gpqjx0gjvWSNrBZeA4EeA5U96a5qsq1pxDo+sCUihtseK1e8lHGVe5fij5njT5TEuPTNihfQtXIwufPIY2g85stvQ8pKiF8yReIQdjPnoFtPF7AjxGOJ9GI+GvMY+WT90z4PAssl/14zIW//EpfFyu08xW2waZte85xpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779980065; c=relaxed/simple;
	bh=SOTQlt9SFhHIeCQ5LzNoGG5rAuUOIKHJHzCYlRFv3Hc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=LM3xUBOzlwOv3wvJsAV3qbfgPQoOZ1polEtlx3Iz8nJjomgIZkJaCzrmqrtcqkLOV4ny8t6dSZikzzEXbbtGPPH3L9Pk+Vs4bXl7eNOA+wf6QMShZM7AVAgpL1TiI13yKNrSW1S/fUmiidlKgmrIwBrYuSNmC9hZcLW9Gj2IsmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.219.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8cccfcebd47so26334596d6.3
        for <syzbot@lists.linux.dev>; Thu, 28 May 2026 07:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779980061; x=1780584861;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjjqTfrHRut1vyPHrQt2RqADIBgUKnT3fd+MM+uvxps=;
        b=h0HOqMFvuFLYKh0uyCCHysw3laUiFW4XVrwhpYD0LaLBelQBVAcByQ5ZBWFjGBgzih
         ylq5UJHM8xZhYlSTITGS5iy2PGOUfK6SIBcxtEwqnVCJjxCqly1dK+gEo+GK/nnji7b+
         q7rsJKk4SZaQpEAUBq0UG2c8wCHC0Z9pYWU7RyTHYsUkAdUvCOY2UWzHodMCqTdzEA4K
         9jaWhRniaJcTSp5+4a6AkbinfxDcbrDhhBr5AvDw5eBxC5pgU2C98h7eEvRMsGtTO5pQ
         /6j700y4z8pdE4hjdM1dQt4Np9EfS08XO13S4rfBJx0rtEfhZg66rlTdM2U4/DIxV3oz
         47Eg==
X-Forwarded-Encrypted: i=1; AFNElJ9AawmDZjcPZez8NjaKCicYE1s7UpwDjNZ0ryOKiBNVY5vi4AnD6Uo8atieUlpjKPYd0h3UIlk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxl64VRa2EIv0U5uHPQZ3NHgsOQH+HLnxz5pRBVYys7xZQbRpXd
	JC8078nsOiwhgEvfo9ozFLhbVJ2CUlc0NKO0HOvnYuZE8VhjiQ1nohG75W7rTMvklOIcbbuVkER
	D8N0vGJimaKgIWUyl1MMcVabqxQaplVlp6bJ8cZitEqkO4/yL7r4/QX2RNgw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f010:b0:69d:fccf:90c4 with SMTP id
 006d021491bc7-69dfccf9f5amr642245eaf.23.1779979644080; Thu, 28 May 2026
 07:47:24 -0700 (PDT)
Date: Thu, 28 May 2026 07:47:24 -0700
In-Reply-To: <6a18557b.b6d9d2ce.2aaec5.0358.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a18557c.7f45b5d1.9d2a9.0396.GAE@google.com>
Subject: Re: Re: [moderation/CI] Re: netlink: fix skb refcount leak when dump
 start fails
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@syzkaller.appspotmail.com
Cc: pimyn@google.com, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #syz upstream
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Failed to process the command. Contact syz=
kaller@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> On Thu, May 28, 2026 at 4:39=E2=80=AFPM s=
yzbot ci
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> <syzbot+cidbb9f477452b5813@syzkaller.apps=
potmail.com> wrote:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syzbot ci has tested the following serie=
s
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [v1] netlink: fix skb refcount leak when=
 dump start fails
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> https://lore.kernel.org/all/202605280736=
14.1169858-1-vulab@iscas.ac.cn
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> * [PATCH] netlink: fix skb refcount leak=
 when dump start fails
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> and found the following issues:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> * KASAN: slab-use-after-free Read in nl8=
0211_prepare_wdev_dump
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> * KASAN: slab-use-after-free Read in xfr=
m_dump_sa_done
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> * KASAN: slab-use-after-free Write in sk=
_skb_reason_drop
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Full report is available here:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> https://ci.syzbot.org/series/8ed6f41d-0d=
02-4f1f-a7be-cc639c2b4cfd
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> KASAN: slab-use-after-free Read in nl802=
11_prepare_wdev_dump
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> tree:      net
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> URL:       https://kernel.googlesource.c=
om/pub/scm/linux/kernel/git/netdev/net.git
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> base:      18014147d3ee7831dce53fe65d7fc=
8d428b02552
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> arch:      amd64
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> compiler:  Debian clang version 21.1.8 (=
++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> config:    https://ci.syzbot.org/builds/=
90c5185d-0dad-4c34-a563-4253ebb12eb2/config
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syz repro: https://ci.syzbot.org/finding=
s/0ad9835c-f631-4240-a3ad-2610bca3de33/syz_repro
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in __nlm=
sg_parse include/net/netlink.h:784 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in nlmsg=
_parse_deprecated include/net/netlink.h:830 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in nl802=
11_prepare_wdev_dump+0x634/0x680 net/wireless/nl80211.c:1245
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Read of size 4 at addr ffff88816e172d80 =
by task syz.0.17/5814
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CPU: 1 UID: 0 PID: 5814 Comm: syz.0.17 N=
ot tainted syzkaller #0 PREEMPT(full)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Hardware name: QEMU Standard PC (Q35 + I=
CH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Call Trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  <TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  dump_stack_lvl+0xe8/0x150 lib/dump_stac=
k.c:120
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_address_description+0x55/0x1e0 mm=
/kasan/report.c:378
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_report+0x58/0x70 mm/kasan/report.=
c:482
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_report+0x117/0x150 mm/kasan/repor=
t.c:595
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __nlmsg_parse include/net/netlink.h:784=
 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  nlmsg_parse_deprecated include/net/netl=
ink.h:830 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  nl80211_prepare_wdev_dump+0x634/0x680 n=
et/wireless/nl80211.c:1245
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  nl80211_dump_station+0x186/0xdb0 net/wi=
reless/nl80211.c:8216
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  genl_dumpit+0x10b/0x1b0 net/netlink/gen=
etlink.c:1026
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_dump+0x702/0xe10 net/netlink/af=
_netlink.c:2325
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_recvmsg+0x690/0xa50 net/netlink=
/af_netlink.c:1976
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_recvmsg_nosec net/socket.c:1137 [i=
nline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_recvmsg+0x172/0x1b0 net/socket.c:1=
159
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_recvfrom+0x240/0x3c0 net/socket.c=
:2315
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_recvfrom net/socket.c:2330 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_recvfrom net/socket.c:2326 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_recvfrom+0xde/0x100 net/socke=
t.c:2326
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RIP: 0033:0x7fd64155d68e
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 8=
9 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 8=
9 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48=
 83 ec 08
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RSP: 002b:00007fd6424b5e88 EFLAGS: 00000=
246 ORIG_RAX: 000000000000002d
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RAX: ffffffffffffffda RBX: 00007fd6424b7=
6c0 RCX: 00007fd64155d68e
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RDX: 0000000000001000 RSI: 00007fd6424b6=
000 RDI: 0000000000000003
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RBP: 0000000000000000 R08: 0000000000000=
000 R09: 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R10: 0000000000000000 R11: 0000000000000=
246 R12: 0000000000000003
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R13: 00007fd6424b5f58 R14: 00007fd6424b6=
000 R15: 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  </TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Allocated by task 5813:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/com=
mon.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  unpoison_slab_object mm/kasan/common.c:=
340 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/c=
ommon.c:366
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_alloc include/linux/kasan.h:=
253 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_post_alloc_hook mm/slub.c:4569 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4898 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x384/0x69=
0 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmalloc_reserve net/core/skbuff.c:613 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x27d/0x7d0 net/core/skbuff=
.c:713
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x5d4/0xb40 net/netlink=
/af_netlink.c:1869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.=
c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c=
:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socke=
t.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Freed by task 5813:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/com=
mon.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_free_info+0x46/0x50 mm/kasan=
/generic.c:584
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  poison_slab_object mm/kasan/common.c:25=
3 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_free+0x5c/0x80 mm/kasan/co=
mmon.c:285
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_free include/linux/kasan.h:2=
35 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free_hook mm/slub.c:2689 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free mm/slub.c:6250 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kfree+0x1c5/0x640 mm/slub.c:6565
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_kfree_head net/core/skbuff.c:1075 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_free_head net/core/skbuff.c:1087 [i=
nline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_release_data+0x828/0xa60 net/core/s=
kbuff.c:1114
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_release_all net/core/skbuff.c:1189 =
[inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kfree_skb+0x5d/0x210 net/core/skbuff.=
c:1203
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast_kernel net/netlink/af_n=
etlink.c:1319 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast+0x764/0x8e0 net/netlink=
/af_netlink.c:1344
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x813/0xb40 net/netlink=
/af_netlink.c:1894
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.=
c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c=
:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socke=
t.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address belongs to the object =
at ffff88816e172d80
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  which belongs to the cache skbuff_small=
_head of size 704
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address is located 0 bytes ins=
ide of
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  freed 704-byte region [ffff88816e172d80=
, ffff88816e173040)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address belongs to the physica=
l page:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page: refcount:0 mapcount:0 mapping:0000=
000000000000 index:0x0 pfn:0x16e170
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: order:2 mapcount:0 entire_mapcount=
:0 nr_pages_mapped:0 pincount:0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> flags: 0x57ff00000000040(head|node=3D1|z=
one=3D2|lastcpupid=3D0x7ff)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_type: f5(slab)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 057ff00000000040 ffff888160415140 d=
ead000000000100 dead000000000122
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 0000000000000000 0000000800120012 0=
0000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 057ff00000000040 ffff888160415140 =
dead000000000100 dead000000000122
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 0000000000000000 0000000800120012 =
00000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 057ff00000000002 ffffffffffffff01 =
00000000ffffffff 00000000ffffffff
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: ffffffffffffffff 0000000000000000 =
00000000ffffffff 0000000000000004
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page dumped because: kasan: bad access d=
etected
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_owner tracks the page as allocated
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last allocated via order 2, migrate=
type Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GF=
P_COMP|__GFP_NOMEMALLOC), pid 5530, tgid 5530 (sshd), ts 47735478218, free_=
ts 34702748767
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  set_page_owner include/linux/page_owner=
.h:32 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  post_alloc_hook+0x22d/0x280 mm/page_all=
oc.c:1858
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  prep_new_page mm/page_alloc.c:1866 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  get_page_from_freelist+0x24ba/0x2540 mm=
/page_alloc.c:3946
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_frozen_pages_noprof+0x18d/0x380=
 mm/page_alloc.c:5226
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_slab_page mm/slub.c:3278 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_slab mm/slub.c:3525 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_objects+0x339/0x3d0 mm/slub.c:72=
71
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_sheaf mm/slub.c:2816 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __pcs_replace_empty_main+0x321/0x720 mm=
/slub.c:4651
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_from_pcs mm/slub.c:4749 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4883 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x441/0x69=
0 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmalloc_reserve net/core/skbuff.c:613 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x27d/0x7d0 net/core/skbuff=
.c:713
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_skb include/linux/skbuff.h:1383 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __tcp_send_ack+0xae/0x4f0 net/ipv4/tcp_=
output.c:4473
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  tcp_cleanup_rbuf net/ipv4/tcp.c:1612 [i=
nline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  tcp_recvmsg_locked+0x2dfa/0x3720 net/ip=
v4/tcp.c:2916
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  tcp_recvmsg+0x205/0x7e0 net/ipv4/tcp.c:=
2945
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_recvmsg_nosec net/socket.c:1137 [i=
nline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_recvmsg+0x155/0x1b0 net/socket.c:1=
159
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_read_iter+0x251/0x320 net/socket.c=
:1229
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_sync_read fs/read_write.c:493 [inli=
ne]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  vfs_read+0x582/0xa70 fs/read_write.c:57=
4
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ksys_read+0x150/0x270 fs/read_write.c:7=
17
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last free pid 5059 tgid 5059 stack =
trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  reset_page_owner include/linux/page_own=
er.h:25 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_pages_prepare mm/page_alloc.c:14=
02 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_frozen_pages+0xbc7/0xd30 mm/page=
_alloc.c:2943
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __slab_free+0x274/0x2c0 mm/slub.c:5612
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  qlink_free mm/kasan/quarantine.c:163 [i=
nline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  qlist_free_all+0x99/0x100 mm/kasan/quar=
antine.c:179
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_quarantine_reduce+0x148/0x160 mm/=
kasan/quarantine.c:286
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_alloc+0x22/0x80 mm/kasan/c=
ommon.c:350
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_alloc include/linux/kasan.h:=
253 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_post_alloc_hook mm/slub.c:4569 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4898 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_kmalloc_node mm/slub.c:5294 [inlin=
e]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kvmalloc_node_noprof+0x4d7/0x8a0 mm/s=
lub.c:6832
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  seq_buf_alloc fs/seq_file.c:39 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  seq_read_iter+0x202/0xe10 fs/seq_file.c=
:211
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_sync_read fs/read_write.c:493 [inli=
ne]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  vfs_read+0x582/0xa70 fs/read_write.c:57=
4
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ksys_read+0x150/0x270 fs/read_write.c:7=
17
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Memory state around the buggy address:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff88816e172c80: fb fb fb fb fb fb fb =
fb fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff88816e172d00: fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> >ffff88816e172d80: fa fb fb fb fb fb fb =
fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                    ^
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff88816e172e00: fb fb fb fb fb fb fb =
fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff88816e172e80: fb fb fb fb fb fb fb =
fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> KASAN: slab-use-after-free Read in xfrm_=
dump_sa_done
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> tree:      net
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> URL:       https://kernel.googlesource.c=
om/pub/scm/linux/kernel/git/netdev/net.git
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> base:      18014147d3ee7831dce53fe65d7fc=
8d428b02552
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> arch:      amd64
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> compiler:  Debian clang version 21.1.8 (=
++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> config:    https://ci.syzbot.org/builds/=
90c5185d-0dad-4c34-a563-4253ebb12eb2/config
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syz repro: https://ci.syzbot.org/finding=
s/53579ff8-1479-4e0c-ae08-2f1ea756ee1b/syz_repro
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in xfrm_=
dump_sa_done+0x54/0xd0 net/xfrm/xfrm_user.c:1491
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Read of size 8 at addr ffff888167305398 =
by task syz.0.17/5812
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CPU: 1 UID: 0 PID: 5812 Comm: syz.0.17 N=
ot tainted syzkaller #0 PREEMPT(full)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Hardware name: QEMU Standard PC (Q35 + I=
CH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Call Trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  <TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  dump_stack_lvl+0xe8/0x150 lib/dump_stac=
k.c:120
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_address_description+0x55/0x1e0 mm=
/kasan/report.c:378
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_report+0x58/0x70 mm/kasan/report.=
c:482
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_report+0x117/0x150 mm/kasan/repor=
t.c:595
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  xfrm_dump_sa_done+0x54/0xd0 net/xfrm/xf=
rm_user.c:1491
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_release+0x12c8/0x1ad0 net/netli=
nk/af_netlink.c:768
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_release net/socket.c:722 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_close+0xc3/0x240 net/socket.c:1514
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __fput+0x44f/0xa60 fs/file_table.c:510
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  task_work_run+0x1d9/0x270 kernel/task_w=
ork.c:233
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  resume_user_mode_work include/linux/res=
ume_user_mode.h:50 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __exit_to_user_mode_loop kernel/entry/c=
ommon.c:67 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  exit_to_user_mode_loop+0xf3/0x4d0 kerne=
l/entry/common.c:98
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __exit_to_user_mode_prepare include/lin=
ux/irq-entry-common.h:207 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  syscall_exit_to_user_mode_prepare inclu=
de/linux/irq-entry-common.h:230 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  syscall_exit_to_user_mode include/linux=
/entry-common.h:318 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x33e/0xf80 arch/x86/entr=
y/syscall_64.c:100
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RIP: 0033:0x7fe50bf9ce59
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 0=
0 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8=
b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64=
 89 01 48
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RSP: 002b:00007fff8a02cc38 EFLAGS: 00000=
246 ORIG_RAX: 00000000000001b4
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RAX: 0000000000000000 RBX: 00007fe50c217=
da0 RCX: 00007fe50bf9ce59
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RDX: 0000000000000000 RSI: 0000000000000=
01e RDI: 0000000000000003
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RBP: 00007fe50c217da0 R08: 00007fe50c216=
038 R09: 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R10: 000000000003fdd4 R11: 0000000000000=
246 R12: 0000000000010018
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R13: 00007fe50c215fac R14: 00007fe50c215=
fa8 R15: 00007fe50c215fa0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  </TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Allocated by task 5813:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/com=
mon.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  unpoison_slab_object mm/kasan/common.c:=
340 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/c=
ommon.c:366
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_alloc include/linux/kasan.h:=
253 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_post_alloc_hook mm/slub.c:4569 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4898 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x384/0x69=
0 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x1d0/0x7d0 net/core/skbuff=
.c:702
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x5d4/0xb40 net/netlink=
/af_netlink.c:1869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.=
c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c=
:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socke=
t.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Freed by task 5813:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/com=
mon.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_free_info+0x46/0x50 mm/kasan=
/generic.c:584
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  poison_slab_object mm/kasan/common.c:25=
3 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_free+0x5c/0x80 mm/kasan/co=
mmon.c:285
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_free include/linux/kasan.h:2=
35 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free_hook mm/slub.c:2689 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free mm/slub.c:6250 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_free+0x182/0x650 mm/slub.c:6=
377
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast_kernel net/netlink/af_n=
etlink.c:1319 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast+0x764/0x8e0 net/netlink=
/af_netlink.c:1344
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x813/0xb40 net/netlink=
/af_netlink.c:1894
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.=
c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c=
:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socke=
t.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address belongs to the object =
at ffff888167305380
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  which belongs to the cache skbuff_head_=
cache of size 240
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address is located 24 bytes in=
side of
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  freed 240-byte region [ffff888167305380=
, ffff888167305470)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address belongs to the physica=
l page:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page: refcount:0 mapcount:0 mapping:0000=
000000000000 index:0x0 pfn:0x167304
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: order:1 mapcount:0 entire_mapcount=
:0 nr_pages_mapped:0 pincount:0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> flags: 0x57ff00000000040(head|node=3D1|z=
one=3D2|lastcpupid=3D0x7ff)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_type: f5(slab)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 057ff00000000040 ffff888160416dc0 d=
ead000000000100 dead000000000122
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 0000000000000000 0000000800150015 0=
0000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 057ff00000000040 ffff888160416dc0 =
dead000000000100 dead000000000122
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 0000000000000000 0000000800150015 =
00000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 057ff00000000001 ffffffffffffff81 =
00000000ffffffff 00000000ffffffff
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: ffffffffffffffff 0000000000000000 =
00000000ffffffff 0000000000000002
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page dumped because: kasan: bad access d=
etected
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_owner tracks the page as allocated
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last allocated via order 1, migrate=
type Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORET=
RY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5813, tgid 5812 (syz.0.17), ts 6485967=
9564, free_ts 63312613640
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  set_page_owner include/linux/page_owner=
.h:32 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  post_alloc_hook+0x22d/0x280 mm/page_all=
oc.c:1858
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  prep_new_page mm/page_alloc.c:1866 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  get_page_from_freelist+0x24ba/0x2540 mm=
/page_alloc.c:3946
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_frozen_pages_noprof+0x18d/0x380=
 mm/page_alloc.c:5226
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_slab_page mm/slub.c:3278 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_slab mm/slub.c:3525 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_objects+0x339/0x3d0 mm/slub.c:72=
71
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_sheaf mm/slub.c:2816 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __pcs_replace_empty_main+0x321/0x720 mm=
/slub.c:4651
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_from_pcs mm/slub.c:4749 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4883 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x441/0x69=
0 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x1d0/0x7d0 net/core/skbuff=
.c:702
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x5d4/0xb40 net/netlink=
/af_netlink.c:1869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.=
c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c=
:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socke=
t.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last free pid 15 tgid 15 stack trac=
e:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  reset_page_owner include/linux/page_own=
er.h:25 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_pages_prepare mm/page_alloc.c:14=
02 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_frozen_pages+0xbc7/0xd30 mm/page=
_alloc.c:2943
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  rcu_do_batch kernel/rcu/tree.c:2617 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c=
:2869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  handle_softirqs+0x22a/0x840 kernel/soft=
irq.c:622
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  run_ksoftirqd+0x36/0x60 kernel/softirq.=
c:1076
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  smpboot_thread_fn+0x541/0xa50 kernel/sm=
pboot.c:160
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kthread+0x389/0x470 kernel/kthread.c:43=
6
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ret_from_fork+0x514/0xb70 arch/x86/kern=
el/process.c:158
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ret_from_fork_asm+0x1a/0x30 arch/x86/en=
try/entry_64.S:245
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Memory state around the buggy address:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff888167305280: fb fb fb fb fb fb fb =
fb fb fb fb fb fb fb fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff888167305300: fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> >ffff888167305380: fa fb fb fb fb fb fb =
fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                             ^
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff888167305400: fb fb fb fb fb fb fb =
fb fb fb fb fb fb fb fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff888167305480: fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> KASAN: slab-use-after-free Write in sk_s=
kb_reason_drop
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> tree:      net
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> URL:       https://kernel.googlesource.c=
om/pub/scm/linux/kernel/git/netdev/net.git
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> base:      18014147d3ee7831dce53fe65d7fc=
8d428b02552
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> arch:      amd64
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> compiler:  Debian clang version 21.1.8 (=
++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> config:    https://ci.syzbot.org/builds/=
90c5185d-0dad-4c34-a563-4253ebb12eb2/config
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syz repro: https://ci.syzbot.org/finding=
s/c87569e1-d26e-4670-a17b-9f2f64a5af67/syz_repro
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in instr=
ument_atomic_read_write include/linux/instrumented.h:112 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in atomi=
c_fetch_sub_release include/linux/atomic/atomic-instrumented.h:400 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in __ref=
count_sub_and_test include/linux/refcount.h:389 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in __ref=
count_dec_and_test include/linux/refcount.h:432 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in refco=
unt_dec_and_test include/linux/refcount.h:450 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in skb_u=
nref include/linux/skbuff.h:1292 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in __sk_=
skb_reason_drop net/core/skbuff.c:1212 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in sk_sk=
b_reason_drop+0x37/0x110 net/core/skbuff.c:1240
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Write of size 4 at addr ffff8881178efee4=
 by task syz.1.18/5873
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CPU: 0 UID: 0 PID: 5873 Comm: syz.1.18 N=
ot tainted syzkaller #0 PREEMPT(full)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Hardware name: QEMU Standard PC (Q35 + I=
CH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Call Trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  <TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  dump_stack_lvl+0xe8/0x150 lib/dump_stac=
k.c:120
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_address_description+0x55/0x1e0 mm=
/kasan/report.c:378
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_report+0x58/0x70 mm/kasan/report.=
c:482
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_report+0x117/0x150 mm/kasan/repor=
t.c:595
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  check_region_inline mm/kasan/generic.c:=
-1 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_check_range+0x264/0x2c0 mm/kasan/=
generic.c:200
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  instrument_atomic_read_write include/li=
nux/instrumented.h:112 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  atomic_fetch_sub_release include/linux/=
atomic/atomic-instrumented.h:400 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __refcount_sub_and_test include/linux/r=
efcount.h:389 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __refcount_dec_and_test include/linux/r=
efcount.h:432 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refcount_dec_and_test include/linux/ref=
count.h:450 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_unref include/linux/skbuff.h:1292 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sk_skb_reason_drop net/core/skbuff.c:=
1212 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sk_skb_reason_drop+0x37/0x110 net/core/=
skbuff.c:1240
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kfree_skb_reason include/linux/skbuff.h=
:1322 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kfree_skb include/linux/skbuff.h:1331 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_release+0x133a/0x1ad0 net/netli=
nk/af_netlink.c:770
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_release net/socket.c:722 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_close+0xc3/0x240 net/socket.c:1514
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __fput+0x44f/0xa60 fs/file_table.c:510
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  task_work_run+0x1d9/0x270 kernel/task_w=
ork.c:233
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  resume_user_mode_work include/linux/res=
ume_user_mode.h:50 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __exit_to_user_mode_loop kernel/entry/c=
ommon.c:67 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  exit_to_user_mode_loop+0xf3/0x4d0 kerne=
l/entry/common.c:98
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __exit_to_user_mode_prepare include/lin=
ux/irq-entry-common.h:207 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  syscall_exit_to_user_mode_prepare inclu=
de/linux/irq-entry-common.h:230 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  syscall_exit_to_user_mode include/linux=
/entry-common.h:318 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x33e/0xf80 arch/x86/entr=
y/syscall_64.c:100
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RIP: 0033:0x7fd4d139ce59
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 0=
0 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8=
b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64=
 89 01 48
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RSP: 002b:00007fff722ecbf8 EFLAGS: 00000=
246 ORIG_RAX: 00000000000001b4
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RAX: 0000000000000000 RBX: 00007fff722ec=
ce0 RCX: 00007fd4d139ce59
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RDX: 0000000000000000 RSI: 0000000000000=
01e RDI: 0000000000000003
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RBP: 0000000000012825 R08: 0000000000000=
001 R09: 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R10: 0000001b32e20000 R11: 0000000000000=
246 R12: 00007fff722ecd20
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R13: 00007fd4d1615fac R14: 0000000000012=
859 R15: 00007fd4d1615fa0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  </TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Allocated by task 5874:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/com=
mon.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  unpoison_slab_object mm/kasan/common.c:=
340 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_mempool_unpoison_object+0xa3/0x=
130 mm/kasan/common.c:564
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_mempool_unpoison_object include/l=
inux/kasan.h:391 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  napi_skb_cache_get+0x3c8/0x780 net/core=
/skbuff.c:306
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x19a/0x7d0 net/core/skbuff=
.c:696
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x5d4/0xb40 net/netlink=
/af_netlink.c:1869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendto+0x672/0x710 net/socket.c:2=
265
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendto net/socket.c:2272 [inli=
ne]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendto net/socket.c:2268 [inli=
ne]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendto+0xde/0x100 net/socket.=
c:2268
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Freed by task 5874:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/com=
mon.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_free_info+0x46/0x50 mm/kasan=
/generic.c:584
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  poison_slab_object mm/kasan/common.c:25=
3 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_free+0x5c/0x80 mm/kasan/co=
mmon.c:285
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_free include/linux/kasan.h:2=
35 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free_hook mm/slub.c:2689 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free mm/slub.c:6250 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_free+0x182/0x650 mm/slub.c:6=
377
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast_kernel net/netlink/af_n=
etlink.c:1319 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast+0x764/0x8e0 net/netlink=
/af_netlink.c:1344
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x813/0xb40 net/netlink=
/af_netlink.c:1894
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendto+0x672/0x710 net/socket.c:2=
265
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendto net/socket.c:2272 [inli=
ne]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendto net/socket.c:2268 [inli=
ne]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendto+0xde/0x100 net/socket.=
c:2268
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address belongs to the object =
at ffff8881178efe00
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  which belongs to the cache skbuff_head_=
cache of size 240
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address is located 228 bytes i=
nside of
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  freed 240-byte region [ffff8881178efe00=
, ffff8881178efef0)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address belongs to the physica=
l page:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page: refcount:0 mapcount:0 mapping:0000=
000000000000 index:0x0 pfn:0x1178ee
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: order:1 mapcount:0 entire_mapcount=
:0 nr_pages_mapped:0 pincount:0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> flags: 0x17ff00000000040(head|node=3D0|z=
one=3D2|lastcpupid=3D0x7ff)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_type: f5(slab)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 017ff00000000040 ffff888160416c80 d=
ead000000000122 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 0000000000000000 0000000800150015 0=
0000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 017ff00000000040 ffff888160416c80 =
dead000000000122 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 0000000000000000 0000000800150015 =
00000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 017ff00000000001 ffffffffffffff81 =
00000000ffffffff 00000000ffffffff
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: ffffffffffffffff 0000000000000000 =
00000000ffffffff 0000000000000002
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page dumped because: kasan: bad access d=
etected
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_owner tracks the page as allocated
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last allocated via order 1, migrate=
type Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORET=
RY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5050, tgid 5050 (klogd), ts 7588726595=
3, free_ts 75876344896
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  set_page_owner include/linux/page_owner=
.h:32 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  post_alloc_hook+0x22d/0x280 mm/page_all=
oc.c:1858
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  prep_new_page mm/page_alloc.c:1866 [inl=
ine]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  get_page_from_freelist+0x24ba/0x2540 mm=
/page_alloc.c:3946
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_frozen_pages_noprof+0x18d/0x380=
 mm/page_alloc.c:5226
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_slab_page mm/slub.c:3278 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_slab mm/slub.c:3525 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_objects+0x339/0x3d0 mm/slub.c:72=
71
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_sheaf mm/slub.c:2816 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __pcs_replace_empty_main+0x321/0x720 mm=
/slub.c:4651
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_from_pcs mm/slub.c:4749 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4883 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x441/0x69=
0 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x1d0/0x7d0 net/core/skbuff=
.c:702
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_skb include/linux/skbuff.h:1383 [=
inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_skb_with_frags+0xc8/0x760 net/cor=
e/skbuff.c:6743
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_alloc_send_pskb+0x878/0x990 net/co=
re/sock.c:2998
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  unix_dgram_sendmsg+0x460/0x18d0 net/uni=
x/af_unix.c:2141
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline=
]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendto+0x672/0x710 net/socket.c:2=
265
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendto net/socket.c:2272 [inli=
ne]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendto net/socket.c:2268 [inli=
ne]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendto+0xde/0x100 net/socket.=
c:2268
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_6=
4.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entr=
y/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7=
f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last free pid 0 tgid 0 stack trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  reset_page_owner include/linux/page_own=
er.h:25 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_pages_prepare mm/page_alloc.c:14=
02 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_frozen_pages+0xbc7/0xd30 mm/page=
_alloc.c:2943
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  rcu_do_batch kernel/rcu/tree.c:2617 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c=
:2869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  handle_softirqs+0x22a/0x840 kernel/soft=
irq.c:622
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_softirq kernel/softirq.c:656 [inli=
ne]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  invoke_softirq kernel/softirq.c:496 [in=
line]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __irq_exit_rcu+0xca/0x220 kernel/softir=
q.c:735
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:=
752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  instr_sysvec_apic_timer_interrupt arch/=
x86/kernel/apic/apic.c:1061 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sysvec_apic_timer_interrupt+0xa6/0xc0 a=
rch/x86/kernel/apic/apic.c:1061
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  asm_sysvec_apic_timer_interrupt+0x1a/0x=
20 arch/x86/include/asm/idtentry.h:697
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Memory state around the buggy address:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff8881178efd80: fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff8881178efe00: fa fb fb fb fb fb fb =
fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> >ffff8881178efe80: fb fb fb fb fb fb fb =
fb fb fb fb fb fb fb fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                                         =
               ^
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff8881178eff00: fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff8881178eff80: fc fc fc fc fc fc fc =
fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> If these findings have caused you to res=
end the series or submit a
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> separate fix, please add the following t=
ag to your commit message:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   Tested-by: syzbot@syzkaller.appspotmai=
l.com
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> This report is generated by a bot. It ma=
y contain errors.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syzbot ci engineers can be reached at sy=
zkaller@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To test a patch for this bug, please rep=
ly with `#syz test`
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> (should be on a separate line).
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The patch should be attached to the emai=
l.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Note: arguments like custom git repos an=
d branches are not supported.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email will later be sent to:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [davem@davemloft.net edumazet@google.com=
 horms@kernel.org kees@kernel.org kuba@kernel.org kuniyu@google.com linux-k=
ernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com stable@vger.=
kernel.org vulab@iscas.ac.cn yangfeng@kylinos.cn]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> If the report looks fine to you, reply w=
ith:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #syz upstream
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> If the report is a false positive, reply=
 with
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #syz invalid
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> You received this message because you ar=
e subscribed to the Google Groups "syzkaller-upstream-moderation" group.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To unsubscribe from this group and stop =
receiving emails from it, send an email to syzkaller-upstream-moderation+un=
subscribe@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To view this discussion visit https://gr=
oups.google.com/d/msgid/syzkaller-upstream-moderation/6a185386.99a1ea37.128=
423.0001.GAE%40google.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --=20
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> You received this message because you are =
subscribed to the Google Groups "syzkaller-upstream-moderation" group.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To unsubscribe from this group and stop re=
ceiving emails from it, send an email to syzkaller-upstream-moderation+unsu=
bscribe@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To view this discussion visit https://grou=
ps.google.com/d/msgid/syzkaller-upstream-moderation/6a18555e.e783d627.6395.=
0001.GAE%40google.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corres=
ponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller=
.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any kno=
wn bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --=20
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> You received this message because you are s=
ubscribed to the Google Groups "syzkaller-upstream-moderation" group.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To unsubscribe from this group and stop rec=
eiving emails from it, send an email to syzkaller-upstream-moderation+unsub=
scribe@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To view this discussion visit https://group=
s.google.com/d/msgid/syzkaller-upstream-moderation/6a185560.7f45b5d1.9d2a9.=
0004.GAE%40google.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corresp=
onding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.=
appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any know=
n bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the correspo=
nding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.a=
ppspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known=
 bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --=20
>>>>>>>>>>>>>>>>>>>>>>>>>>>>> You received this message because you are sub=
scribed to the Google Groups "syzkaller-upstream-moderation" group.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To unsubscribe from this group and stop recei=
ving emails from it, send an email to syzkaller-upstream-moderation+unsubsc=
ribe@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To view this discussion visit https://groups.=
google.com/d/msgid/syzkaller-upstream-moderation/6a185566.b6d9d2ce.2aaec5.0=
006.GAE%40google.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the correspon=
ding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.ap=
pspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known =
bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the correspond=
ing bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.app=
spotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known b=
ug.
>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the correspondi=
ng bug.
>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.apps=
potmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bu=
g.
>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the correspondin=
g bug.
>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appsp=
otmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug=
.
>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corresponding=
 bug.
>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspo=
tmail.com address
>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corresponding =
bug.
>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspot=
mail.com address
>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corresponding b=
ug.
>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotm=
ail.com address
>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corresponding bu=
g.
>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotma=
il.com address
>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corresponding bug=
.
>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmai=
l.com address
>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail=
.com address
>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.=
com address
>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.c=
om address
>>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.co=
m address
>>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com=
 address
>>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com =
address
>>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com a=
ddress
>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com ad=
dress
>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com add=
ress
>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com addr=
ess
>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>> Please double check the address.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com addre=
ss
>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>> Please double check the address.
>>>>>>>>>
>>>>>>>>
>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com addres=
s
>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>> Please double check the address.
>>>>>>>>
>>>>>>>
>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>> Please double check the address.
>>>>>>>
>>>>>>
>>>>>> I see the command but can't find the corresponding bug.
>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
>>>>>> but the HASH does not correspond to any known bug.
>>>>>> Please double check the address.
>>>>>>
>>>>>
>>>>> I see the command but can't find the corresponding bug.
>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
>>>>> but the HASH does not correspond to any known bug.
>>>>> Please double check the address.
>>>>>
>>>>
>>>> I see the command but can't find the corresponding bug.
>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
>>>> but the HASH does not correspond to any known bug.
>>>> Please double check the address.
>>>>
>>>
>>> I see the command but can't find the corresponding bug.
>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
>>> but the HASH does not correspond to any known bug.
>>> Please double check the address.
>>>
>>
>> I see the command but can't find the corresponding bug.
>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
>> but the HASH does not correspond to any known bug.
>> Please double check the address.
>>
>
> I see the command but can't find the corresponding bug.
> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
> but the HASH does not correspond to any known bug.
> Please double check the address.
>

I see the command but can't find the corresponding bug.
The email is sent to  syzbot+HASH@syzkaller.appspotmail.com address
but the HASH does not correspond to any known bug.
Please double check the address.

