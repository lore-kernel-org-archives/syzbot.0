Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228B63FDBE7
	for <syzbot@lists.linux.dev>; Thu, 28 May 2026 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779981087; cv=none; b=DXYfp2xacXIE8BJP+WT9cMYZ5bkPACN6ICaa79JkoftA5CItoeGaYhDrLGUbr8r1i5yRhrJ3ueHIVLJTrscmcnXIpciXcMNBRPfDNAccya2RLtV9NYJuI46eKtvd1J/o3Fmr9yupRjaAfbSIdFNU2F23fLlt5sU+yDgMK7E9PAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779981087; c=relaxed/simple;
	bh=wRnz/YCja/aap3iuT5HfgU/1aVFACOW2kMtH5JUZSeI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=PDWSCHw39tfJtLck8QcyKa93ezo7pOBMUz5aS25HEiaRdHCu82ZhNOF22PlidPskHP+sxcUmIVkiDVTxA1BmEk9AH9DayrpOeHzjC0OxGTEtHze3khdnOnG02dSw+SfxgLta6UWsTpRz2hCqlOv4UX765flnTi6NyoBAlQts4iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.219.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8b640ede74bso18969936d6.1
        for <syzbot@lists.linux.dev>; Thu, 28 May 2026 08:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779980991; x=1780585791;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nz9m5IFIIFxwbPPoSnsjjRC+rGOWhddIaBcmKG+sh5g=;
        b=GMJNW8r8VnriBQn9+9wQaahEhu1GWSQOn+JhZQXs1iQ7Vo8oMKW8ppNV6kgiv4BUOK
         wewkGiIB0cNaFKG7wP8K4q0kYyC61HybDLpAcFmBfEsUuldzYNoyCPJHv/wPSkpGHA7Z
         qkYKbjEFEMvB/YJiiqEWNfpGljz5If3knghkn9qjtaG7NeB8cjFs1oL9OE4b/+nfZNBK
         Jp7XyHApfXvu2XkqhIdDlyZq1pbaQz3z1qgT1ah/2qkdZQ7MFxdga40/e4Z1bs1FAvjG
         TBarKLD6SejHLimG3+HwS5kvitwgHPzZkx8oLIrupMUmVKmpIuBWJyPzUiE4+aBDHMc2
         ziiA==
X-Forwarded-Encrypted: i=1; AFNElJ/SLacGJLKFmiOTKFinn1W40+wE17YBpPnQfhof3FyOKpJRSaw8rSkBi+4xZlgTWxafcTUKQMI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMRlgg0L2WPss79VzpnfraMgZvDfdKogpyCfrtFAYBnPSVJt0c
	ItSPBb6Ru7Tc2kLeV4IDs93p9SxkiH2Rv/WO5zdVtpNA6K/kGuySp6jsOckloKUUxprrGM5jAjZ
	33jSD8jwNkT8GarTpTRfUCQ5KMSphF1Kc6KzJ2h9A3IKzuoNWnamy1LtJ34I=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:20d:b0:69d:9367:6321 with SMTP id
 006d021491bc7-69d936763admr11807694eaf.33.1779979633219; Thu, 28 May 2026
 07:47:13 -0700 (PDT)
Date: Thu, 28 May 2026 07:47:13 -0700
In-Reply-To: <6a185570.e783d627.6395.0112.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a185571.222db38e.c0a93.0125.GAE@google.com>
Subject: Re: Re: [moderation/CI] Re: netlink: fix skb refcount leak when dump
 start fails
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@syzkaller.appspotmail.com
Cc: pimyn@google.com, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>>>>>>>>>>>>>>> #syz upstream
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Failed to process the command. Contact syzkaller@googlegroup=
s.com.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On Thu, May 28, 2026 at 4:39=E2=80=AFPM syzbot ci
>>>>>>>>>>>>>>> <syzbot+cidbb9f477452b5813@syzkaller.appspotmail.com> wrote=
:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> syzbot ci has tested the following series
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> [v1] netlink: fix skb refcount leak when dump start fails
>>>>>>>>>>>>>>>> https://lore.kernel.org/all/20260528073614.1169858-1-vulab=
@iscas.ac.cn
>>>>>>>>>>>>>>>> * [PATCH] netlink: fix skb refcount leak when dump start f=
ails
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> and found the following issues:
>>>>>>>>>>>>>>>> * KASAN: slab-use-after-free Read in nl80211_prepare_wdev_=
dump
>>>>>>>>>>>>>>>> * KASAN: slab-use-after-free Read in xfrm_dump_sa_done
>>>>>>>>>>>>>>>> * KASAN: slab-use-after-free Write in sk_skb_reason_drop
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Full report is available here:
>>>>>>>>>>>>>>>> https://ci.syzbot.org/series/8ed6f41d-0d02-4f1f-a7be-cc639=
c2b4cfd
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> KASAN: slab-use-after-free Read in nl80211_prepare_wdev_du=
mp
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> tree:      net
>>>>>>>>>>>>>>>> URL:       https://kernel.googlesource.com/pub/scm/linux/k=
ernel/git/netdev/net.git
>>>>>>>>>>>>>>>> base:      18014147d3ee7831dce53fe65d7fc8d428b02552
>>>>>>>>>>>>>>>> arch:      amd64
>>>>>>>>>>>>>>>> compiler:  Debian clang version 21.1.8 (++20251221033036+2=
078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>>>>>>>>>>>>>>> config:    https://ci.syzbot.org/builds/90c5185d-0dad-4c34=
-a563-4253ebb12eb2/config
>>>>>>>>>>>>>>>> syz repro: https://ci.syzbot.org/findings/0ad9835c-f631-42=
40-a3ad-2610bca3de33/syz_repro
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in __nlmsg_parse include/n=
et/netlink.h:784 [inline]
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in nlmsg_parse_deprecated =
include/net/netlink.h:830 [inline]
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in nl80211_prepare_wdev_du=
mp+0x634/0x680 net/wireless/nl80211.c:1245
>>>>>>>>>>>>>>>> Read of size 4 at addr ffff88816e172d80 by task syz.0.17/5=
814
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> CPU: 1 UID: 0 PID: 5814 Comm: syz.0.17 Not tainted syzkall=
er #0 PREEMPT(full)
>>>>>>>>>>>>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1=
.16.2-debian-1.16.2-1 04/01/2014
>>>>>>>>>>>>>>>> Call Trace:
>>>>>>>>>>>>>>>>  <TASK>
>>>>>>>>>>>>>>>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>>>>>>>>>>>>>>>  print_address_description+0x55/0x1e0 mm/kasan/report.c:37=
8
>>>>>>>>>>>>>>>>  print_report+0x58/0x70 mm/kasan/report.c:482
>>>>>>>>>>>>>>>>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>>>>>>>>>>>>>>>>  __nlmsg_parse include/net/netlink.h:784 [inline]
>>>>>>>>>>>>>>>>  nlmsg_parse_deprecated include/net/netlink.h:830 [inline]
>>>>>>>>>>>>>>>>  nl80211_prepare_wdev_dump+0x634/0x680 net/wireless/nl8021=
1.c:1245
>>>>>>>>>>>>>>>>  nl80211_dump_station+0x186/0xdb0 net/wireless/nl80211.c:8=
216
>>>>>>>>>>>>>>>>  genl_dumpit+0x10b/0x1b0 net/netlink/genetlink.c:1026
>>>>>>>>>>>>>>>>  netlink_dump+0x702/0xe10 net/netlink/af_netlink.c:2325
>>>>>>>>>>>>>>>>  netlink_recvmsg+0x690/0xa50 net/netlink/af_netlink.c:1976
>>>>>>>>>>>>>>>>  sock_recvmsg_nosec net/socket.c:1137 [inline]
>>>>>>>>>>>>>>>>  sock_recvmsg+0x172/0x1b0 net/socket.c:1159
>>>>>>>>>>>>>>>>  __sys_recvfrom+0x240/0x3c0 net/socket.c:2315
>>>>>>>>>>>>>>>>  __do_sys_recvfrom net/socket.c:2330 [inline]
>>>>>>>>>>>>>>>>  __se_sys_recvfrom net/socket.c:2326 [inline]
>>>>>>>>>>>>>>>>  __x64_sys_recvfrom+0xde/0x100 net/socket.c:2326
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>> RIP: 0033:0x7fd64155d68e
>>>>>>>>>>>>>>>> Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 8=
9 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <=
c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
>>>>>>>>>>>>>>>> RSP: 002b:00007fd6424b5e88 EFLAGS: 00000246 ORIG_RAX: 0000=
00000000002d
>>>>>>>>>>>>>>>> RAX: ffffffffffffffda RBX: 00007fd6424b76c0 RCX: 00007fd64=
155d68e
>>>>>>>>>>>>>>>> RDX: 0000000000001000 RSI: 00007fd6424b6000 RDI: 000000000=
0000003
>>>>>>>>>>>>>>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000=
0000000
>>>>>>>>>>>>>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000=
0000003
>>>>>>>>>>>>>>>> R13: 00007fd6424b5f58 R14: 00007fd6424b6000 R15: 000000000=
0000000
>>>>>>>>>>>>>>>>  </TASK>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Allocated by task 5813:
>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>>>>>>>>>>>>>>>>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>>>>>>>>>>>>>>>>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>>>>>>>>>>>>>>>>  slab_post_alloc_hook mm/slub.c:4569 [inline]
>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4898 [inline]
>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>  kmalloc_reserve net/core/skbuff.c:613 [inline]
>>>>>>>>>>>>>>>>  __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
>>>>>>>>>>>>>>>>  netlink_sendmsg+0x5d4/0xb40 net/netlink/af_netlink.c:1869
>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline]
>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline]
>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Freed by task 5813:
>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>>>>>>>>>>>>>>>>  poison_slab_object mm/kasan/common.c:253 [inline]
>>>>>>>>>>>>>>>>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>>>>>>>>>>>>>>>>  kasan_slab_free include/linux/kasan.h:235 [inline]
>>>>>>>>>>>>>>>>  slab_free_hook mm/slub.c:2689 [inline]
>>>>>>>>>>>>>>>>  slab_free mm/slub.c:6250 [inline]
>>>>>>>>>>>>>>>>  kfree+0x1c5/0x640 mm/slub.c:6565
>>>>>>>>>>>>>>>>  skb_kfree_head net/core/skbuff.c:1075 [inline]
>>>>>>>>>>>>>>>>  skb_free_head net/core/skbuff.c:1087 [inline]
>>>>>>>>>>>>>>>>  skb_release_data+0x828/0xa60 net/core/skbuff.c:1114
>>>>>>>>>>>>>>>>  skb_release_all net/core/skbuff.c:1189 [inline]
>>>>>>>>>>>>>>>>  __kfree_skb+0x5d/0x210 net/core/skbuff.c:1203
>>>>>>>>>>>>>>>>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inl=
ine]
>>>>>>>>>>>>>>>>  netlink_unicast+0x764/0x8e0 net/netlink/af_netlink.c:1344
>>>>>>>>>>>>>>>>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline]
>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline]
>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The buggy address belongs to the object at ffff88816e172d8=
0
>>>>>>>>>>>>>>>>  which belongs to the cache skbuff_small_head of size 704
>>>>>>>>>>>>>>>> The buggy address is located 0 bytes inside of
>>>>>>>>>>>>>>>>  freed 704-byte region [ffff88816e172d80, ffff88816e173040=
)
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The buggy address belongs to the physical page:
>>>>>>>>>>>>>>>> page: refcount:0 mapcount:0 mapping:0000000000000000 index=
:0x0 pfn:0x16e170
>>>>>>>>>>>>>>>> head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped=
:0 pincount:0
>>>>>>>>>>>>>>>> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=
=3D0x7ff)
>>>>>>>>>>>>>>>> page_type: f5(slab)
>>>>>>>>>>>>>>>> raw: 057ff00000000040 ffff888160415140 dead000000000100 de=
ad000000000122
>>>>>>>>>>>>>>>> raw: 0000000000000000 0000000800120012 00000000f5000000 00=
00000000000000
>>>>>>>>>>>>>>>> head: 057ff00000000040 ffff888160415140 dead000000000100 d=
ead000000000122
>>>>>>>>>>>>>>>> head: 0000000000000000 0000000800120012 00000000f5000000 0=
000000000000000
>>>>>>>>>>>>>>>> head: 057ff00000000002 ffffffffffffff01 00000000ffffffff 0=
0000000ffffffff
>>>>>>>>>>>>>>>> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0=
000000000000004
>>>>>>>>>>>>>>>> page dumped because: kasan: bad access detected
>>>>>>>>>>>>>>>> page_owner tracks the page as allocated
>>>>>>>>>>>>>>>> page last allocated via order 2, migratetype Unmovable, gf=
p_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEM=
ALLOC), pid 5530, tgid 5530 (sshd), ts 47735478218, free_ts 34702748767
>>>>>>>>>>>>>>>>  set_page_owner include/linux/page_owner.h:32 [inline]
>>>>>>>>>>>>>>>>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>>>>>>>>>>>>>>>>  prep_new_page mm/page_alloc.c:1866 [inline]
>>>>>>>>>>>>>>>>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>>>>>>>>>>>>>>>>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5=
226
>>>>>>>>>>>>>>>>  alloc_slab_page mm/slub.c:3278 [inline]
>>>>>>>>>>>>>>>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>>>>>>>>>>>>>>>  new_slab mm/slub.c:3525 [inline]
>>>>>>>>>>>>>>>>  refill_objects+0x339/0x3d0 mm/slub.c:7271
>>>>>>>>>>>>>>>>  refill_sheaf mm/slub.c:2816 [inline]
>>>>>>>>>>>>>>>>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4651
>>>>>>>>>>>>>>>>  alloc_from_pcs mm/slub.c:4749 [inline]
>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4883 [inline]
>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x441/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>  kmalloc_reserve net/core/skbuff.c:613 [inline]
>>>>>>>>>>>>>>>>  __alloc_skb+0x27d/0x7d0 net/core/skbuff.c:713
>>>>>>>>>>>>>>>>  alloc_skb include/linux/skbuff.h:1383 [inline]
>>>>>>>>>>>>>>>>  __tcp_send_ack+0xae/0x4f0 net/ipv4/tcp_output.c:4473
>>>>>>>>>>>>>>>>  tcp_cleanup_rbuf net/ipv4/tcp.c:1612 [inline]
>>>>>>>>>>>>>>>>  tcp_recvmsg_locked+0x2dfa/0x3720 net/ipv4/tcp.c:2916
>>>>>>>>>>>>>>>>  tcp_recvmsg+0x205/0x7e0 net/ipv4/tcp.c:2945
>>>>>>>>>>>>>>>>  sock_recvmsg_nosec net/socket.c:1137 [inline]
>>>>>>>>>>>>>>>>  sock_recvmsg+0x155/0x1b0 net/socket.c:1159
>>>>>>>>>>>>>>>>  sock_read_iter+0x251/0x320 net/socket.c:1229
>>>>>>>>>>>>>>>>  new_sync_read fs/read_write.c:493 [inline]
>>>>>>>>>>>>>>>>  vfs_read+0x582/0xa70 fs/read_write.c:574
>>>>>>>>>>>>>>>>  ksys_read+0x150/0x270 fs/read_write.c:717
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>> page last free pid 5059 tgid 5059 stack trace:
>>>>>>>>>>>>>>>>  reset_page_owner include/linux/page_owner.h:25 [inline]
>>>>>>>>>>>>>>>>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>>>>>>>>>>>>>>>>  __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
>>>>>>>>>>>>>>>>  __slab_free+0x274/0x2c0 mm/slub.c:5612
>>>>>>>>>>>>>>>>  qlink_free mm/kasan/quarantine.c:163 [inline]
>>>>>>>>>>>>>>>>  qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
>>>>>>>>>>>>>>>>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c=
:286
>>>>>>>>>>>>>>>>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>>>>>>>>>>>>>>>>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>>>>>>>>>>>>>>>>  slab_post_alloc_hook mm/slub.c:4569 [inline]
>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4898 [inline]
>>>>>>>>>>>>>>>>  __do_kmalloc_node mm/slub.c:5294 [inline]
>>>>>>>>>>>>>>>>  __kvmalloc_node_noprof+0x4d7/0x8a0 mm/slub.c:6832
>>>>>>>>>>>>>>>>  seq_buf_alloc fs/seq_file.c:39 [inline]
>>>>>>>>>>>>>>>>  seq_read_iter+0x202/0xe10 fs/seq_file.c:211
>>>>>>>>>>>>>>>>  new_sync_read fs/read_write.c:493 [inline]
>>>>>>>>>>>>>>>>  vfs_read+0x582/0xa70 fs/read_write.c:574
>>>>>>>>>>>>>>>>  ksys_read+0x150/0x270 fs/read_write.c:717
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Memory state around the buggy address:
>>>>>>>>>>>>>>>>  ffff88816e172c80: fb fb fb fb fb fb fb fb fc fc fc fc fc =
fc fc fc
>>>>>>>>>>>>>>>>  ffff88816e172d00: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
>>>>>>>>>>>>>>>> >ffff88816e172d80: fa fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
>>>>>>>>>>>>>>>>                    ^
>>>>>>>>>>>>>>>>  ffff88816e172e00: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
>>>>>>>>>>>>>>>>  ffff88816e172e80: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> KASAN: slab-use-after-free Read in xfrm_dump_sa_done
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> tree:      net
>>>>>>>>>>>>>>>> URL:       https://kernel.googlesource.com/pub/scm/linux/k=
ernel/git/netdev/net.git
>>>>>>>>>>>>>>>> base:      18014147d3ee7831dce53fe65d7fc8d428b02552
>>>>>>>>>>>>>>>> arch:      amd64
>>>>>>>>>>>>>>>> compiler:  Debian clang version 21.1.8 (++20251221033036+2=
078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>>>>>>>>>>>>>>> config:    https://ci.syzbot.org/builds/90c5185d-0dad-4c34=
-a563-4253ebb12eb2/config
>>>>>>>>>>>>>>>> syz repro: https://ci.syzbot.org/findings/53579ff8-1479-4e=
0c-ae08-2f1ea756ee1b/syz_repro
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in xfrm_dump_sa_done+0x54/=
0xd0 net/xfrm/xfrm_user.c:1491
>>>>>>>>>>>>>>>> Read of size 8 at addr ffff888167305398 by task syz.0.17/5=
812
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> CPU: 1 UID: 0 PID: 5812 Comm: syz.0.17 Not tainted syzkall=
er #0 PREEMPT(full)
>>>>>>>>>>>>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1=
.16.2-debian-1.16.2-1 04/01/2014
>>>>>>>>>>>>>>>> Call Trace:
>>>>>>>>>>>>>>>>  <TASK>
>>>>>>>>>>>>>>>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>>>>>>>>>>>>>>>  print_address_description+0x55/0x1e0 mm/kasan/report.c:37=
8
>>>>>>>>>>>>>>>>  print_report+0x58/0x70 mm/kasan/report.c:482
>>>>>>>>>>>>>>>>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>>>>>>>>>>>>>>>>  xfrm_dump_sa_done+0x54/0xd0 net/xfrm/xfrm_user.c:1491
>>>>>>>>>>>>>>>>  netlink_release+0x12c8/0x1ad0 net/netlink/af_netlink.c:76=
8
>>>>>>>>>>>>>>>>  __sock_release net/socket.c:722 [inline]
>>>>>>>>>>>>>>>>  sock_close+0xc3/0x240 net/socket.c:1514
>>>>>>>>>>>>>>>>  __fput+0x44f/0xa60 fs/file_table.c:510
>>>>>>>>>>>>>>>>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>>>>>>>>>>>>>>>>  resume_user_mode_work include/linux/resume_user_mode.h:50=
 [inline]
>>>>>>>>>>>>>>>>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline=
]
>>>>>>>>>>>>>>>>  exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:9=
8
>>>>>>>>>>>>>>>>  __exit_to_user_mode_prepare include/linux/irq-entry-commo=
n.h:207 [inline]
>>>>>>>>>>>>>>>>  syscall_exit_to_user_mode_prepare include/linux/irq-entry=
-common.h:230 [inline]
>>>>>>>>>>>>>>>>  syscall_exit_to_user_mode include/linux/entry-common.h:31=
8 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>> RIP: 0033:0x7fe50bf9ce59
>>>>>>>>>>>>>>>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 4=
8 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>>>>>>>>>>>>>>>> RSP: 002b:00007fff8a02cc38 EFLAGS: 00000246 ORIG_RAX: 0000=
0000000001b4
>>>>>>>>>>>>>>>> RAX: 0000000000000000 RBX: 00007fe50c217da0 RCX: 00007fe50=
bf9ce59
>>>>>>>>>>>>>>>> RDX: 0000000000000000 RSI: 000000000000001e RDI: 000000000=
0000003
>>>>>>>>>>>>>>>> RBP: 00007fe50c217da0 R08: 00007fe50c216038 R09: 000000000=
0000000
>>>>>>>>>>>>>>>> R10: 000000000003fdd4 R11: 0000000000000246 R12: 000000000=
0010018
>>>>>>>>>>>>>>>> R13: 00007fe50c215fac R14: 00007fe50c215fa8 R15: 00007fe50=
c215fa0
>>>>>>>>>>>>>>>>  </TASK>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Allocated by task 5813:
>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>>>>>>>>>>>>>>>>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>>>>>>>>>>>>>>>>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>>>>>>>>>>>>>>>>  slab_post_alloc_hook mm/slub.c:4569 [inline]
>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4898 [inline]
>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x384/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>  __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
>>>>>>>>>>>>>>>>  netlink_sendmsg+0x5d4/0xb40 net/netlink/af_netlink.c:1869
>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline]
>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline]
>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Freed by task 5813:
>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>>>>>>>>>>>>>>>>  poison_slab_object mm/kasan/common.c:253 [inline]
>>>>>>>>>>>>>>>>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>>>>>>>>>>>>>>>>  kasan_slab_free include/linux/kasan.h:235 [inline]
>>>>>>>>>>>>>>>>  slab_free_hook mm/slub.c:2689 [inline]
>>>>>>>>>>>>>>>>  slab_free mm/slub.c:6250 [inline]
>>>>>>>>>>>>>>>>  kmem_cache_free+0x182/0x650 mm/slub.c:6377
>>>>>>>>>>>>>>>>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inl=
ine]
>>>>>>>>>>>>>>>>  netlink_unicast+0x764/0x8e0 net/netlink/af_netlink.c:1344
>>>>>>>>>>>>>>>>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline]
>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline]
>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The buggy address belongs to the object at ffff88816730538=
0
>>>>>>>>>>>>>>>>  which belongs to the cache skbuff_head_cache of size 240
>>>>>>>>>>>>>>>> The buggy address is located 24 bytes inside of
>>>>>>>>>>>>>>>>  freed 240-byte region [ffff888167305380, ffff888167305470=
)
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The buggy address belongs to the physical page:
>>>>>>>>>>>>>>>> page: refcount:0 mapcount:0 mapping:0000000000000000 index=
:0x0 pfn:0x167304
>>>>>>>>>>>>>>>> head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped=
:0 pincount:0
>>>>>>>>>>>>>>>> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=
=3D0x7ff)
>>>>>>>>>>>>>>>> page_type: f5(slab)
>>>>>>>>>>>>>>>> raw: 057ff00000000040 ffff888160416dc0 dead000000000100 de=
ad000000000122
>>>>>>>>>>>>>>>> raw: 0000000000000000 0000000800150015 00000000f5000000 00=
00000000000000
>>>>>>>>>>>>>>>> head: 057ff00000000040 ffff888160416dc0 dead000000000100 d=
ead000000000122
>>>>>>>>>>>>>>>> head: 0000000000000000 0000000800150015 00000000f5000000 0=
000000000000000
>>>>>>>>>>>>>>>> head: 057ff00000000001 ffffffffffffff81 00000000ffffffff 0=
0000000ffffffff
>>>>>>>>>>>>>>>> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0=
000000000000002
>>>>>>>>>>>>>>>> page dumped because: kasan: bad access detected
>>>>>>>>>>>>>>>> page_owner tracks the page as allocated
>>>>>>>>>>>>>>>> page last allocated via order 1, migratetype Unmovable, gf=
p_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GF=
P_NOMEMALLOC), pid 5813, tgid 5812 (syz.0.17), ts 64859679564, free_ts 6331=
2613640
>>>>>>>>>>>>>>>>  set_page_owner include/linux/page_owner.h:32 [inline]
>>>>>>>>>>>>>>>>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>>>>>>>>>>>>>>>>  prep_new_page mm/page_alloc.c:1866 [inline]
>>>>>>>>>>>>>>>>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>>>>>>>>>>>>>>>>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5=
226
>>>>>>>>>>>>>>>>  alloc_slab_page mm/slub.c:3278 [inline]
>>>>>>>>>>>>>>>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>>>>>>>>>>>>>>>  new_slab mm/slub.c:3525 [inline]
>>>>>>>>>>>>>>>>  refill_objects+0x339/0x3d0 mm/slub.c:7271
>>>>>>>>>>>>>>>>  refill_sheaf mm/slub.c:2816 [inline]
>>>>>>>>>>>>>>>>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4651
>>>>>>>>>>>>>>>>  alloc_from_pcs mm/slub.c:4749 [inline]
>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4883 [inline]
>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x441/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>  __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
>>>>>>>>>>>>>>>>  netlink_sendmsg+0x5d4/0xb40 net/netlink/af_netlink.c:1869
>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline]
>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>  __sys_sendmsg net/socket.c:2784 [inline]
>>>>>>>>>>>>>>>>  __do_sys_sendmsg net/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>  __se_sys_sendmsg net/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>> page last free pid 15 tgid 15 stack trace:
>>>>>>>>>>>>>>>>  reset_page_owner include/linux/page_owner.h:25 [inline]
>>>>>>>>>>>>>>>>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>>>>>>>>>>>>>>>>  __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
>>>>>>>>>>>>>>>>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>>>>>>>>>>>>>>>>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>>>>>>>>>>>>>>>>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>>>>>>>>>>>>>>>>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
>>>>>>>>>>>>>>>>  smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
>>>>>>>>>>>>>>>>  kthread+0x389/0x470 kernel/kthread.c:436
>>>>>>>>>>>>>>>>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>>>>>>>>>>>>>>>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Memory state around the buggy address:
>>>>>>>>>>>>>>>>  ffff888167305280: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fc fc
>>>>>>>>>>>>>>>>  ffff888167305300: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
>>>>>>>>>>>>>>>> >ffff888167305380: fa fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
>>>>>>>>>>>>>>>>                             ^
>>>>>>>>>>>>>>>>  ffff888167305400: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fc fc
>>>>>>>>>>>>>>>>  ffff888167305480: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> KASAN: slab-use-after-free Write in sk_skb_reason_drop
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> tree:      net
>>>>>>>>>>>>>>>> URL:       https://kernel.googlesource.com/pub/scm/linux/k=
ernel/git/netdev/net.git
>>>>>>>>>>>>>>>> base:      18014147d3ee7831dce53fe65d7fc8d428b02552
>>>>>>>>>>>>>>>> arch:      amd64
>>>>>>>>>>>>>>>> compiler:  Debian clang version 21.1.8 (++20251221033036+2=
078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
>>>>>>>>>>>>>>>> config:    https://ci.syzbot.org/builds/90c5185d-0dad-4c34=
-a563-4253ebb12eb2/config
>>>>>>>>>>>>>>>> syz repro: https://ci.syzbot.org/findings/c87569e1-d26e-46=
70-a17b-9f2f64a5af67/syz_repro
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in instrument_atomic_read_=
write include/linux/instrumented.h:112 [inline]
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in atomic_fetch_sub_releas=
e include/linux/atomic/atomic-instrumented.h:400 [inline]
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in __refcount_sub_and_test=
 include/linux/refcount.h:389 [inline]
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in __refcount_dec_and_test=
 include/linux/refcount.h:432 [inline]
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in refcount_dec_and_test i=
nclude/linux/refcount.h:450 [inline]
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in skb_unref include/linux=
/skbuff.h:1292 [inline]
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in __sk_skb_reason_drop ne=
t/core/skbuff.c:1212 [inline]
>>>>>>>>>>>>>>>> BUG: KASAN: slab-use-after-free in sk_skb_reason_drop+0x37=
/0x110 net/core/skbuff.c:1240
>>>>>>>>>>>>>>>> Write of size 4 at addr ffff8881178efee4 by task syz.1.18/=
5873
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> CPU: 0 UID: 0 PID: 5873 Comm: syz.1.18 Not tainted syzkall=
er #0 PREEMPT(full)
>>>>>>>>>>>>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1=
.16.2-debian-1.16.2-1 04/01/2014
>>>>>>>>>>>>>>>> Call Trace:
>>>>>>>>>>>>>>>>  <TASK>
>>>>>>>>>>>>>>>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>>>>>>>>>>>>>>>  print_address_description+0x55/0x1e0 mm/kasan/report.c:37=
8
>>>>>>>>>>>>>>>>  print_report+0x58/0x70 mm/kasan/report.c:482
>>>>>>>>>>>>>>>>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>>>>>>>>>>>>>>>>  check_region_inline mm/kasan/generic.c:-1 [inline]
>>>>>>>>>>>>>>>>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>>>>>>>>>>>>>>>>  instrument_atomic_read_write include/linux/instrumented.h=
:112 [inline]
>>>>>>>>>>>>>>>>  atomic_fetch_sub_release include/linux/atomic/atomic-inst=
rumented.h:400 [inline]
>>>>>>>>>>>>>>>>  __refcount_sub_and_test include/linux/refcount.h:389 [inl=
ine]
>>>>>>>>>>>>>>>>  __refcount_dec_and_test include/linux/refcount.h:432 [inl=
ine]
>>>>>>>>>>>>>>>>  refcount_dec_and_test include/linux/refcount.h:450 [inlin=
e]
>>>>>>>>>>>>>>>>  skb_unref include/linux/skbuff.h:1292 [inline]
>>>>>>>>>>>>>>>>  __sk_skb_reason_drop net/core/skbuff.c:1212 [inline]
>>>>>>>>>>>>>>>>  sk_skb_reason_drop+0x37/0x110 net/core/skbuff.c:1240
>>>>>>>>>>>>>>>>  kfree_skb_reason include/linux/skbuff.h:1322 [inline]
>>>>>>>>>>>>>>>>  kfree_skb include/linux/skbuff.h:1331 [inline]
>>>>>>>>>>>>>>>>  netlink_release+0x133a/0x1ad0 net/netlink/af_netlink.c:77=
0
>>>>>>>>>>>>>>>>  __sock_release net/socket.c:722 [inline]
>>>>>>>>>>>>>>>>  sock_close+0xc3/0x240 net/socket.c:1514
>>>>>>>>>>>>>>>>  __fput+0x44f/0xa60 fs/file_table.c:510
>>>>>>>>>>>>>>>>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>>>>>>>>>>>>>>>>  resume_user_mode_work include/linux/resume_user_mode.h:50=
 [inline]
>>>>>>>>>>>>>>>>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline=
]
>>>>>>>>>>>>>>>>  exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:9=
8
>>>>>>>>>>>>>>>>  __exit_to_user_mode_prepare include/linux/irq-entry-commo=
n.h:207 [inline]
>>>>>>>>>>>>>>>>  syscall_exit_to_user_mode_prepare include/linux/irq-entry=
-common.h:230 [inline]
>>>>>>>>>>>>>>>>  syscall_exit_to_user_mode include/linux/entry-common.h:31=
8 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>> RIP: 0033:0x7fd4d139ce59
>>>>>>>>>>>>>>>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 4=
8 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <=
48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>>>>>>>>>>>>>>>> RSP: 002b:00007fff722ecbf8 EFLAGS: 00000246 ORIG_RAX: 0000=
0000000001b4
>>>>>>>>>>>>>>>> RAX: 0000000000000000 RBX: 00007fff722ecce0 RCX: 00007fd4d=
139ce59
>>>>>>>>>>>>>>>> RDX: 0000000000000000 RSI: 000000000000001e RDI: 000000000=
0000003
>>>>>>>>>>>>>>>> RBP: 0000000000012825 R08: 0000000000000001 R09: 000000000=
0000000
>>>>>>>>>>>>>>>> R10: 0000001b32e20000 R11: 0000000000000246 R12: 00007fff7=
22ecd20
>>>>>>>>>>>>>>>> R13: 00007fd4d1615fac R14: 0000000000012859 R15: 00007fd4d=
1615fa0
>>>>>>>>>>>>>>>>  </TASK>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Allocated by task 5874:
>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>>>>>>>>>>>>>>>>  __kasan_mempool_unpoison_object+0xa3/0x130 mm/kasan/commo=
n.c:564
>>>>>>>>>>>>>>>>  kasan_mempool_unpoison_object include/linux/kasan.h:391 [=
inline]
>>>>>>>>>>>>>>>>  napi_skb_cache_get+0x3c8/0x780 net/core/skbuff.c:306
>>>>>>>>>>>>>>>>  __alloc_skb+0x19a/0x7d0 net/core/skbuff.c:696
>>>>>>>>>>>>>>>>  netlink_sendmsg+0x5d4/0xb40 net/netlink/af_netlink.c:1869
>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline]
>>>>>>>>>>>>>>>>  __sys_sendto+0x672/0x710 net/socket.c:2265
>>>>>>>>>>>>>>>>  __do_sys_sendto net/socket.c:2272 [inline]
>>>>>>>>>>>>>>>>  __se_sys_sendto net/socket.c:2268 [inline]
>>>>>>>>>>>>>>>>  __x64_sys_sendto+0xde/0x100 net/socket.c:2268
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Freed by task 5874:
>>>>>>>>>>>>>>>>  kasan_save_stack mm/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>>>>>>>>>>>>>>>>  poison_slab_object mm/kasan/common.c:253 [inline]
>>>>>>>>>>>>>>>>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>>>>>>>>>>>>>>>>  kasan_slab_free include/linux/kasan.h:235 [inline]
>>>>>>>>>>>>>>>>  slab_free_hook mm/slub.c:2689 [inline]
>>>>>>>>>>>>>>>>  slab_free mm/slub.c:6250 [inline]
>>>>>>>>>>>>>>>>  kmem_cache_free+0x182/0x650 mm/slub.c:6377
>>>>>>>>>>>>>>>>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inl=
ine]
>>>>>>>>>>>>>>>>  netlink_unicast+0x764/0x8e0 net/netlink/af_netlink.c:1344
>>>>>>>>>>>>>>>>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline]
>>>>>>>>>>>>>>>>  __sys_sendto+0x672/0x710 net/socket.c:2265
>>>>>>>>>>>>>>>>  __do_sys_sendto net/socket.c:2272 [inline]
>>>>>>>>>>>>>>>>  __se_sys_sendto net/socket.c:2268 [inline]
>>>>>>>>>>>>>>>>  __x64_sys_sendto+0xde/0x100 net/socket.c:2268
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The buggy address belongs to the object at ffff8881178efe0=
0
>>>>>>>>>>>>>>>>  which belongs to the cache skbuff_head_cache of size 240
>>>>>>>>>>>>>>>> The buggy address is located 228 bytes inside of
>>>>>>>>>>>>>>>>  freed 240-byte region [ffff8881178efe00, ffff8881178efef0=
)
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The buggy address belongs to the physical page:
>>>>>>>>>>>>>>>> page: refcount:0 mapcount:0 mapping:0000000000000000 index=
:0x0 pfn:0x1178ee
>>>>>>>>>>>>>>>> head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped=
:0 pincount:0
>>>>>>>>>>>>>>>> flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=
=3D0x7ff)
>>>>>>>>>>>>>>>> page_type: f5(slab)
>>>>>>>>>>>>>>>> raw: 017ff00000000040 ffff888160416c80 dead000000000122 00=
00000000000000
>>>>>>>>>>>>>>>> raw: 0000000000000000 0000000800150015 00000000f5000000 00=
00000000000000
>>>>>>>>>>>>>>>> head: 017ff00000000040 ffff888160416c80 dead000000000122 0=
000000000000000
>>>>>>>>>>>>>>>> head: 0000000000000000 0000000800150015 00000000f5000000 0=
000000000000000
>>>>>>>>>>>>>>>> head: 017ff00000000001 ffffffffffffff81 00000000ffffffff 0=
0000000ffffffff
>>>>>>>>>>>>>>>> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0=
000000000000002
>>>>>>>>>>>>>>>> page dumped because: kasan: bad access detected
>>>>>>>>>>>>>>>> page_owner tracks the page as allocated
>>>>>>>>>>>>>>>> page last allocated via order 1, migratetype Unmovable, gf=
p_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GF=
P_NOMEMALLOC), pid 5050, tgid 5050 (klogd), ts 75887265953, free_ts 7587634=
4896
>>>>>>>>>>>>>>>>  set_page_owner include/linux/page_owner.h:32 [inline]
>>>>>>>>>>>>>>>>  post_alloc_hook+0x22d/0x280 mm/page_alloc.c:1858
>>>>>>>>>>>>>>>>  prep_new_page mm/page_alloc.c:1866 [inline]
>>>>>>>>>>>>>>>>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>>>>>>>>>>>>>>>>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5=
226
>>>>>>>>>>>>>>>>  alloc_slab_page mm/slub.c:3278 [inline]
>>>>>>>>>>>>>>>>  allocate_slab+0x77/0x660 mm/slub.c:3467
>>>>>>>>>>>>>>>>  new_slab mm/slub.c:3525 [inline]
>>>>>>>>>>>>>>>>  refill_objects+0x339/0x3d0 mm/slub.c:7271
>>>>>>>>>>>>>>>>  refill_sheaf mm/slub.c:2816 [inline]
>>>>>>>>>>>>>>>>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4651
>>>>>>>>>>>>>>>>  alloc_from_pcs mm/slub.c:4749 [inline]
>>>>>>>>>>>>>>>>  slab_alloc_node mm/slub.c:4883 [inline]
>>>>>>>>>>>>>>>>  kmem_cache_alloc_node_noprof+0x441/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>  __alloc_skb+0x1d0/0x7d0 net/core/skbuff.c:702
>>>>>>>>>>>>>>>>  alloc_skb include/linux/skbuff.h:1383 [inline]
>>>>>>>>>>>>>>>>  alloc_skb_with_frags+0xc8/0x760 net/core/skbuff.c:6743
>>>>>>>>>>>>>>>>  sock_alloc_send_pskb+0x878/0x990 net/core/sock.c:2998
>>>>>>>>>>>>>>>>  unix_dgram_sendmsg+0x460/0x18d0 net/unix/af_unix.c:2141
>>>>>>>>>>>>>>>>  sock_sendmsg_nosec net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>  __sock_sendmsg net/socket.c:802 [inline]
>>>>>>>>>>>>>>>>  __sys_sendto+0x672/0x710 net/socket.c:2265
>>>>>>>>>>>>>>>>  __do_sys_sendto net/socket.c:2272 [inline]
>>>>>>>>>>>>>>>>  __se_sys_sendto net/socket.c:2268 [inline]
>>>>>>>>>>>>>>>>  __x64_sys_sendto+0xde/0x100 net/socket.c:2268
>>>>>>>>>>>>>>>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>> page last free pid 0 tgid 0 stack trace:
>>>>>>>>>>>>>>>>  reset_page_owner include/linux/page_owner.h:25 [inline]
>>>>>>>>>>>>>>>>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>>>>>>>>>>>>>>>>  __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
>>>>>>>>>>>>>>>>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>>>>>>>>>>>>>>>>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>>>>>>>>>>>>>>>>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>>>>>>>>>>>>>>>>  __do_softirq kernel/softirq.c:656 [inline]
>>>>>>>>>>>>>>>>  invoke_softirq kernel/softirq.c:496 [inline]
>>>>>>>>>>>>>>>>  __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
>>>>>>>>>>>>>>>>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
>>>>>>>>>>>>>>>>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/ap=
ic.c:1061 [inline]
>>>>>>>>>>>>>>>>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/api=
c/apic.c:1061
>>>>>>>>>>>>>>>>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/includ=
e/asm/idtentry.h:697
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Memory state around the buggy address:
>>>>>>>>>>>>>>>>  ffff8881178efd80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
>>>>>>>>>>>>>>>>  ffff8881178efe00: fa fb fb fb fb fb fb fb fb fb fb fb fb =
fb fb fb
>>>>>>>>>>>>>>>> >ffff8881178efe80: fb fb fb fb fb fb fb fb fb fb fb fb fb =
fb fc fc
>>>>>>>>>>>>>>>>                                                        ^
>>>>>>>>>>>>>>>>  ffff8881178eff00: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
>>>>>>>>>>>>>>>>  ffff8881178eff80: fc fc fc fc fc fc fc fc fc fc fc fc fc =
fc fc fc
>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> If these findings have caused you to resend the series or =
submit a
>>>>>>>>>>>>>>>> separate fix, please add the following tag to your commit =
message:
>>>>>>>>>>>>>>>>   Tested-by: syzbot@syzkaller.appspotmail.com
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>> This report is generated by a bot. It may contain errors.
>>>>>>>>>>>>>>>> syzbot ci engineers can be reached at syzkaller@googlegrou=
ps.com.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> To test a patch for this bug, please reply with `#syz test=
`
>>>>>>>>>>>>>>>> (should be on a separate line).
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The patch should be attached to the email.
>>>>>>>>>>>>>>>> Note: arguments like custom git repos and branches are not=
 supported.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The email will later be sent to:
>>>>>>>>>>>>>>>> [davem@davemloft.net edumazet@google.com horms@kernel.org =
kees@kernel.org kuba@kernel.org kuniyu@google.com linux-kernel@vger.kernel.=
org netdev@vger.kernel.org pabeni@redhat.com stable@vger.kernel.org vulab@i=
scas.ac.cn yangfeng@kylinos.cn]
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> If the report looks fine to you, reply with:
>>>>>>>>>>>>>>>> #syz upstream
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> If the report is a false positive, reply with
>>>>>>>>>>>>>>>> #syz invalid
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> --
>>>>>>>>>>>>>>>> You received this message because you are subscribed to th=
e Google Groups "syzkaller-upstream-moderation" group.
>>>>>>>>>>>>>>>> To unsubscribe from this group and stop receiving emails f=
rom it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegr=
oups.com.
>>>>>>>>>>>>>>>> To view this discussion visit https://groups.google.com/d/=
msgid/syzkaller-upstream-moderation/6a185386.99a1ea37.128423.0001.GAE%40goo=
gle.com.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> --=20
>>>>>>>>>>>>>> You received this message because you are subscribed to the =
Google Groups "syzkaller-upstream-moderation" group.
>>>>>>>>>>>>>> To unsubscribe from this group and stop receiving emails fro=
m it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegrou=
ps.com.
>>>>>>>>>>>>>> To view this discussion visit https://groups.google.com/d/ms=
gid/syzkaller-upstream-moderation/6a18555e.e783d627.6395.0001.GAE%40google.=
com.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com a=
ddress
>>>>>>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>
>>>>>>>>>>>>> --=20
>>>>>>>>>>>>> You received this message because you are subscribed to the G=
oogle Groups "syzkaller-upstream-moderation" group.
>>>>>>>>>>>>> To unsubscribe from this group and stop receiving emails from=
 it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroup=
s.com.
>>>>>>>>>>>>> To view this discussion visit https://groups.google.com/d/msg=
id/syzkaller-upstream-moderation/6a185560.7f45b5d1.9d2a9.0004.GAE%40google.=
com.
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
>>>>>>>>> --=20
>>>>>>>>> You received this message because you are subscribed to the Googl=
e Groups "syzkaller-upstream-moderation" group.
>>>>>>>>> To unsubscribe from this group and stop receiving emails from it,=
 send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.co=
m.
>>>>>>>>> To view this discussion visit https://groups.google.com/d/msgid/s=
yzkaller-upstream-moderation/6a185567.586c836d.2e3ab2.0008.GAE%40google.com=
.
>>>>>>>>
>>>>>>>> I see the command but can't find the corresponding bug.
>>>>>>>> The email is sent to  syzbot+HASH@syzkaller.appspotmail.com addres=
s
>>>>>>>> but the HASH does not correspond to any known bug.
>>>>>>>> Please double check the address.
>>>>>>>>
>>>>>>>> --=20
>>>>>>>> You received this message because you are subscribed to the Google=
 Groups "syzkaller-upstream-moderation" group.
>>>>>>>> To unsubscribe from this group and stop receiving emails from it, =
send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com=
.
>>>>>>>> To view this discussion visit https://groups.google.com/d/msgid/sy=
zkaller-upstream-moderation/6a185569.9efe2910.1869e6.000f.GAE%40google.com.
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

