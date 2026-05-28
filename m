Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64944DBD8B
	for <syzbot@lists.linux.dev>; Thu, 28 May 2026 14:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779980126; cv=none; b=b0F6i5bf7B3ewsxPaAJe50U9ocZSFr+IDSadG98vfdfZBdPi4tfPbrlqsaWpuQ3s+q5IcmPRXLZ8JfanjVufMh2+0UUG9GgKleY3NZ3dT4S3ZUMMHpmQ6OeejeI/OYaXla54MotgkIt4v3liTQ0IpW/KlgLDs4FrQcPKpYud75M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779980126; c=relaxed/simple;
	bh=CvM5q9/MUGGwS2Ge/F+FPNwWs790OUm8P+7emaPtP1M=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qaF8ojb2/AO6mbu1QCj555LKmTg4GR0HDC2uSUBJyl/WA1ETXi9ppRTSxM0QHInqzWVdn7qiLLS8rp9/t5XZXOLIIq9ZjMpKpLiBUTe/2L+MgN0aFEd4HRWXxtIxPiNNTFvlrQRVFdEIUhRoHMg54r0t4JAjz0dqNRK1H8UgUfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e60737a946so5616441a34.1
        for <syzbot@lists.linux.dev>; Thu, 28 May 2026 07:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779980123; x=1780584923;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/zSGfVYkSl4TOVtx5xTdcYg3mzShqpWBNP9pQsSJNz8=;
        b=Sxl1bGPoFkkiH1X/2r7vM5mw+g1c8+creoKpDnZoACk6HnsXSUzscggaTyBDPfaVpC
         VJDxFpdUGrEtHhTOmpvNbCYWPfCEiAfXd9686Uo7v1ZhpdhvguBAK9b+n9rkgL1SmAyc
         pJyIaEorMp8xQdKd82LhZpUi/shxWSOmlWzd1XQhDFFoUNxnLgn0SZlzQbuyIynhtLlK
         NObNb9Nv0sSAtW5xlF1adHUs3LL5+1JG4AUupmgzzu+Zkj10MfMsRUZUelm/bo/Pk6TQ
         9omBkM50oxA3xJdcsdpB4MamxSIzrPX2nmflkLazHfJoJ3TjaaBYBnwHHO6L6MRUVDjK
         MEHg==
X-Forwarded-Encrypted: i=1; AFNElJ/KFhJVz8Q6RPsLQLY4+jBl7UoXVMPrXoamgXe8lJRRym/wEx+vkdlQthkhqLg8g076UhPnyKE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuwN5BP4N3EXUDEmfqJ8asVraQC6jqT9cN9EsdB9faysx+SVOs
	5sMBOdwvHRbUkBpUS51c0K9BGfpnwI7zYBHVX4cHNP8ogAqF28dOk24RYs4P95Mu3janxIXqRpo
	SLlf6Ryc/1nGDY7hqNtwy3aTxrSexCBwktx2IN1Pa43f3Bb15or5HMHdbrb8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8c6:b0:67d:e7c3:3c6c with SMTP id
 006d021491bc7-69d7ece5518mr14582435eaf.53.1779979660359; Thu, 28 May 2026
 07:47:40 -0700 (PDT)
Date: Thu, 28 May 2026 07:47:40 -0700
In-Reply-To: <6a18558b.9efe2910.1869e6.0692.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a18558c.586c836d.2e3ab2.06f6.GAE@google.com>
Subject: Re: Re: [moderation/CI] Re: netlink: fix skb refcount leak when dump
 start fails
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@syzkaller.appspotmail.com
Cc: pimyn@google.com, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #syz upstream
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Failed to process the=
 command. Contact syzkaller@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> On Thu, May 28, 2026=
 at 4:39=E2=80=AFPM syzbot ci
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> <syzbot+cidbb9f47745=
2b5813@syzkaller.appspotmail.com> wrote:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syzbot ci has teste=
d the following series
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [v1] netlink: fix s=
kb refcount leak when dump start fails
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> https://lore.kernel=
.org/all/20260528073614.1169858-1-vulab@iscas.ac.cn
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> * [PATCH] netlink: =
fix skb refcount leak when dump start fails
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> and found the follo=
wing issues:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> * KASAN: slab-use-a=
fter-free Read in nl80211_prepare_wdev_dump
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> * KASAN: slab-use-a=
fter-free Read in xfrm_dump_sa_done
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> * KASAN: slab-use-a=
fter-free Write in sk_skb_reason_drop
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Full report is avai=
lable here:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> https://ci.syzbot.o=
rg/series/8ed6f41d-0d02-4f1f-a7be-cc639c2b4cfd
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> KASAN: slab-use-aft=
er-free Read in nl80211_prepare_wdev_dump
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> tree:      net
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> URL:       https://=
kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> base:      18014147=
d3ee7831dce53fe65d7fc8d428b02552
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> arch:      amd64
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> compiler:  Debian c=
lang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50=
), Debian LLD 21.1.8
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> config:    https://=
ci.syzbot.org/builds/90c5185d-0dad-4c34-a563-4253ebb12eb2/config
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syz repro: https://=
ci.syzbot.org/findings/0ad9835c-f631-4240-a3ad-2610bca3de33/syz_repro
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in __nlmsg_parse include/net/netlink.h:784 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in nlmsg_parse_deprecated include/net/netlink.h:830 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in nl80211_prepare_wdev_dump+0x634/0x680 net/wireless/nl80211.=
c:1245
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Read of size 4 at a=
ddr ffff88816e172d80 by task syz.0.17/5814
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CPU: 1 UID: 0 PID: =
5814 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Hardware name: QEMU=
 Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Call Trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  <TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  dump_stack_lvl+0xe=
8/0x150 lib/dump_stack.c:120
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_address_desc=
ription+0x55/0x1e0 mm/kasan/report.c:378
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_report+0x58/=
0x70 mm/kasan/report.c:482
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_report+0x117=
/0x150 mm/kasan/report.c:595
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __nlmsg_parse incl=
ude/net/netlink.h:784 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  nlmsg_parse_deprec=
ated include/net/netlink.h:830 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  nl80211_prepare_wd=
ev_dump+0x634/0x680 net/wireless/nl80211.c:1245
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  nl80211_dump_stati=
on+0x186/0xdb0 net/wireless/nl80211.c:8216
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  genl_dumpit+0x10b/=
0x1b0 net/netlink/genetlink.c:1026
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_dump+0x702=
/0xe10 net/netlink/af_netlink.c:2325
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_recvmsg+0x=
690/0xa50 net/netlink/af_netlink.c:1976
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_recvmsg_nosec=
 net/socket.c:1137 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_recvmsg+0x172=
/0x1b0 net/socket.c:1159
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_recvfrom+0x2=
40/0x3c0 net/socket.c:2315
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_recvfrom =
net/socket.c:2330 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_recvfrom =
net/socket.c:2326 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_recvfrom=
+0xde/0x100 net/socket.c:2326
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RIP: 0033:0x7fd6415=
5d68e
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Code: 08 0f 85 a5 a=
8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 0=
8 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f=
 1f 80 00 00 00 00 48 83 ec 08
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RSP: 002b:00007fd64=
24b5e88 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RAX: ffffffffffffff=
da RBX: 00007fd6424b76c0 RCX: 00007fd64155d68e
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RDX: 00000000000010=
00 RSI: 00007fd6424b6000 RDI: 0000000000000003
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RBP: 00000000000000=
00 R08: 0000000000000000 R09: 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R10: 00000000000000=
00 R11: 0000000000000246 R12: 0000000000000003
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R13: 00007fd6424b5f=
58 R14: 00007fd6424b6000 R15: 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  </TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Allocated by task 5=
813:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack m=
m/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0=
x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  unpoison_slab_obje=
ct mm/kasan/common.c:340 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_alloc=
+0x6c/0x80 mm/kasan/common.c:366
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_alloc i=
nclude/linux/kasan.h:253 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_post_alloc_ho=
ok mm/slub.c:4569 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm=
/slub.c:4898 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_n=
ode_noprof+0x384/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmalloc_reserve ne=
t/core/skbuff.c:613 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x27d/=
0x7d0 net/core/skbuff.c:713
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x=
5d4/0xb40 net/netlink/af_netlink.c:1869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec=
 net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net=
/socket.c:802 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x=
972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2=
a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/=
socket.c:2784 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg n=
et/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg n=
et/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+=
0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Freed by task 5813:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack m=
m/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0=
x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_free_in=
fo+0x46/0x50 mm/kasan/generic.c:584
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  poison_slab_object=
 mm/kasan/common.c:253 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_free+=
0x5c/0x80 mm/kasan/common.c:285
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_free in=
clude/linux/kasan.h:235 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free_hook mm/=
slub.c:2689 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free mm/slub.=
c:6250 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kfree+0x1c5/0x640 =
mm/slub.c:6565
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_kfree_head net=
/core/skbuff.c:1075 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_free_head net/=
core/skbuff.c:1087 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_release_data+0=
x828/0xa60 net/core/skbuff.c:1114
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_release_all ne=
t/core/skbuff.c:1189 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kfree_skb+0x5d/0=
x210 net/core/skbuff.c:1203
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast_ke=
rnel net/netlink/af_netlink.c:1319 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast+0x=
764/0x8e0 net/netlink/af_netlink.c:1344
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x=
813/0xb40 net/netlink/af_netlink.c:1894
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec=
 net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net=
/socket.c:802 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x=
972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2=
a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/=
socket.c:2784 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg n=
et/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg n=
et/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+=
0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address b=
elongs to the object at ffff88816e172d80
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  which belongs to t=
he cache skbuff_small_head of size 704
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address i=
s located 0 bytes inside of
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  freed 704-byte reg=
ion [ffff88816e172d80, ffff88816e173040)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address b=
elongs to the physical page:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page: refcount:0 ma=
pcount:0 mapping:0000000000000000 index:0x0 pfn:0x16e170
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: order:2 mapco=
unt:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> flags: 0x57ff000000=
00040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_type: f5(slab)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 057ff000000000=
40 ffff888160415140 dead000000000100 dead000000000122
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 00000000000000=
00 0000000800120012 00000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 057ff00000000=
040 ffff888160415140 dead000000000100 dead000000000122
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 0000000000000=
000 0000000800120012 00000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 057ff00000000=
002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: fffffffffffff=
fff 0000000000000000 00000000ffffffff 0000000000000004
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page dumped because=
: kasan: bad access detected
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_owner tracks t=
he page as allocated
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last allocated=
 via order 2, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWA=
RN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5530, tgid 5530 (sshd), =
ts 47735478218, free_ts 34702748767
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  set_page_owner inc=
lude/linux/page_owner.h:32 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  post_alloc_hook+0x=
22d/0x280 mm/page_alloc.c:1858
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  prep_new_page mm/p=
age_alloc.c:1866 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  get_page_from_free=
list+0x24ba/0x2540 mm/page_alloc.c:3946
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_frozen_pag=
es_noprof+0x18d/0x380 mm/page_alloc.c:5226
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_slab_page mm=
/slub.c:3278 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  allocate_slab+0x77=
/0x660 mm/slub.c:3467
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_slab mm/slub.c=
:3525 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_objects+0x3=
39/0x3d0 mm/slub.c:7271
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_sheaf mm/sl=
ub.c:2816 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __pcs_replace_empt=
y_main+0x321/0x720 mm/slub.c:4651
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_from_pcs mm/=
slub.c:4749 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm=
/slub.c:4883 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_n=
ode_noprof+0x441/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmalloc_reserve ne=
t/core/skbuff.c:613 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x27d/=
0x7d0 net/core/skbuff.c:713
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_skb include/=
linux/skbuff.h:1383 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __tcp_send_ack+0xa=
e/0x4f0 net/ipv4/tcp_output.c:4473
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  tcp_cleanup_rbuf n=
et/ipv4/tcp.c:1612 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  tcp_recvmsg_locked=
+0x2dfa/0x3720 net/ipv4/tcp.c:2916
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  tcp_recvmsg+0x205/=
0x7e0 net/ipv4/tcp.c:2945
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_recvmsg_nosec=
 net/socket.c:1137 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_recvmsg+0x155=
/0x1b0 net/socket.c:1159
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_read_iter+0x2=
51/0x320 net/socket.c:1229
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_sync_read fs/r=
ead_write.c:493 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  vfs_read+0x582/0xa=
70 fs/read_write.c:574
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ksys_read+0x150/0x=
270 fs/read_write.c:717
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last free pid =
5059 tgid 5059 stack trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  reset_page_owner i=
nclude/linux/page_owner.h:25 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_pages_prepa=
re mm/page_alloc.c:1402 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_frozen_page=
s+0xbc7/0xd30 mm/page_alloc.c:2943
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __slab_free+0x274/=
0x2c0 mm/slub.c:5612
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  qlink_free mm/kasa=
n/quarantine.c:163 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  qlist_free_all+0x9=
9/0x100 mm/kasan/quarantine.c:179
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_quarantine_r=
educe+0x148/0x160 mm/kasan/quarantine.c:286
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_alloc=
+0x22/0x80 mm/kasan/common.c:350
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_alloc i=
nclude/linux/kasan.h:253 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_post_alloc_ho=
ok mm/slub.c:4569 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm=
/slub.c:4898 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_kmalloc_node =
mm/slub.c:5294 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kvmalloc_node_no=
prof+0x4d7/0x8a0 mm/slub.c:6832
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  seq_buf_alloc fs/s=
eq_file.c:39 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  seq_read_iter+0x20=
2/0xe10 fs/seq_file.c:211
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_sync_read fs/r=
ead_write.c:493 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  vfs_read+0x582/0xa=
70 fs/read_write.c:574
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ksys_read+0x150/0x=
270 fs/read_write.c:717
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Memory state around=
 the buggy address:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff88816e172c80: =
fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff88816e172d00: =
fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> >ffff88816e172d80: =
fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                    =
^
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff88816e172e00: =
fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff88816e172e80: =
fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> KASAN: slab-use-aft=
er-free Read in xfrm_dump_sa_done
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> tree:      net
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> URL:       https://=
kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> base:      18014147=
d3ee7831dce53fe65d7fc8d428b02552
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> arch:      amd64
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> compiler:  Debian c=
lang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50=
), Debian LLD 21.1.8
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> config:    https://=
ci.syzbot.org/builds/90c5185d-0dad-4c34-a563-4253ebb12eb2/config
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syz repro: https://=
ci.syzbot.org/findings/53579ff8-1479-4e0c-ae08-2f1ea756ee1b/syz_repro
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in xfrm_dump_sa_done+0x54/0xd0 net/xfrm/xfrm_user.c:1491
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Read of size 8 at a=
ddr ffff888167305398 by task syz.0.17/5812
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CPU: 1 UID: 0 PID: =
5812 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Hardware name: QEMU=
 Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Call Trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  <TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  dump_stack_lvl+0xe=
8/0x150 lib/dump_stack.c:120
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_address_desc=
ription+0x55/0x1e0 mm/kasan/report.c:378
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_report+0x58/=
0x70 mm/kasan/report.c:482
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_report+0x117=
/0x150 mm/kasan/report.c:595
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  xfrm_dump_sa_done+=
0x54/0xd0 net/xfrm/xfrm_user.c:1491
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_release+0x=
12c8/0x1ad0 net/netlink/af_netlink.c:768
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_release net=
/socket.c:722 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_close+0xc3/0x=
240 net/socket.c:1514
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __fput+0x44f/0xa60=
 fs/file_table.c:510
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  task_work_run+0x1d=
9/0x270 kernel/task_work.c:233
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  resume_user_mode_w=
ork include/linux/resume_user_mode.h:50 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __exit_to_user_mod=
e_loop kernel/entry/common.c:67 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  exit_to_user_mode_=
loop+0xf3/0x4d0 kernel/entry/common.c:98
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __exit_to_user_mod=
e_prepare include/linux/irq-entry-common.h:207 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  syscall_exit_to_us=
er_mode_prepare include/linux/irq-entry-common.h:230 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  syscall_exit_to_us=
er_mode include/linux/entry-common.h:318 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x33=
e/0xf80 arch/x86/entry/syscall_64.c:100
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RIP: 0033:0x7fe50bf=
9ce59
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Code: ff c3 66 2e 0=
f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4=
d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1=
 e8 ff ff ff f7 d8 64 89 01 48
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RSP: 002b:00007fff8=
a02cc38 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RAX: 00000000000000=
00 RBX: 00007fe50c217da0 RCX: 00007fe50bf9ce59
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RDX: 00000000000000=
00 RSI: 000000000000001e RDI: 0000000000000003
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RBP: 00007fe50c217d=
a0 R08: 00007fe50c216038 R09: 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R10: 000000000003fd=
d4 R11: 0000000000000246 R12: 0000000000010018
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R13: 00007fe50c215f=
ac R14: 00007fe50c215fa8 R15: 00007fe50c215fa0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  </TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Allocated by task 5=
813:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack m=
m/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0=
x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  unpoison_slab_obje=
ct mm/kasan/common.c:340 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_alloc=
+0x6c/0x80 mm/kasan/common.c:366
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_alloc i=
nclude/linux/kasan.h:253 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_post_alloc_ho=
ok mm/slub.c:4569 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm=
/slub.c:4898 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_n=
ode_noprof+0x384/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x1d0/=
0x7d0 net/core/skbuff.c:702
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x=
5d4/0xb40 net/netlink/af_netlink.c:1869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec=
 net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net=
/socket.c:802 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x=
972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2=
a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/=
socket.c:2784 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg n=
et/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg n=
et/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+=
0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Freed by task 5813:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack m=
m/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0=
x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_free_in=
fo+0x46/0x50 mm/kasan/generic.c:584
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  poison_slab_object=
 mm/kasan/common.c:253 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_free+=
0x5c/0x80 mm/kasan/common.c:285
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_free in=
clude/linux/kasan.h:235 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free_hook mm/=
slub.c:2689 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free mm/slub.=
c:6250 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_free+0x=
182/0x650 mm/slub.c:6377
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast_ke=
rnel net/netlink/af_netlink.c:1319 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast+0x=
764/0x8e0 net/netlink/af_netlink.c:1344
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x=
813/0xb40 net/netlink/af_netlink.c:1894
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec=
 net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net=
/socket.c:802 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x=
972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2=
a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/=
socket.c:2784 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg n=
et/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg n=
et/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+=
0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address b=
elongs to the object at ffff888167305380
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  which belongs to t=
he cache skbuff_head_cache of size 240
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address i=
s located 24 bytes inside of
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  freed 240-byte reg=
ion [ffff888167305380, ffff888167305470)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address b=
elongs to the physical page:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page: refcount:0 ma=
pcount:0 mapping:0000000000000000 index:0x0 pfn:0x167304
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: order:1 mapco=
unt:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> flags: 0x57ff000000=
00040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_type: f5(slab)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 057ff000000000=
40 ffff888160416dc0 dead000000000100 dead000000000122
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 00000000000000=
00 0000000800150015 00000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 057ff00000000=
040 ffff888160416dc0 dead000000000100 dead000000000122
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 0000000000000=
000 0000000800150015 00000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 057ff00000000=
001 ffffffffffffff81 00000000ffffffff 00000000ffffffff
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: fffffffffffff=
fff 0000000000000000 00000000ffffffff 0000000000000002
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page dumped because=
: kasan: bad access detected
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_owner tracks t=
he page as allocated
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last allocated=
 via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__G=
FP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5813, tgid 5812 (=
syz.0.17), ts 64859679564, free_ts 63312613640
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  set_page_owner inc=
lude/linux/page_owner.h:32 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  post_alloc_hook+0x=
22d/0x280 mm/page_alloc.c:1858
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  prep_new_page mm/p=
age_alloc.c:1866 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  get_page_from_free=
list+0x24ba/0x2540 mm/page_alloc.c:3946
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_frozen_pag=
es_noprof+0x18d/0x380 mm/page_alloc.c:5226
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_slab_page mm=
/slub.c:3278 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  allocate_slab+0x77=
/0x660 mm/slub.c:3467
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_slab mm/slub.c=
:3525 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_objects+0x3=
39/0x3d0 mm/slub.c:7271
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_sheaf mm/sl=
ub.c:2816 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __pcs_replace_empt=
y_main+0x321/0x720 mm/slub.c:4651
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_from_pcs mm/=
slub.c:4749 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm=
/slub.c:4883 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_n=
ode_noprof+0x441/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x1d0/=
0x7d0 net/core/skbuff.c:702
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x=
5d4/0xb40 net/netlink/af_netlink.c:1869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec=
 net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net=
/socket.c:802 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ____sys_sendmsg+0x=
972/0x9f0 net/socket.c:2698
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ___sys_sendmsg+0x2=
a5/0x360 net/socket.c:2752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendmsg net/=
socket.c:2784 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendmsg n=
et/socket.c:2789 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendmsg n=
et/socket.c:2787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendmsg+=
0x1bd/0x2a0 net/socket.c:2787
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last free pid =
15 tgid 15 stack trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  reset_page_owner i=
nclude/linux/page_owner.h:25 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_pages_prepa=
re mm/page_alloc.c:1402 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_frozen_page=
s+0xbc7/0xd30 mm/page_alloc.c:2943
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  rcu_do_batch kerne=
l/rcu/tree.c:2617 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  rcu_core+0x7cd/0x1=
070 kernel/rcu/tree.c:2869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  handle_softirqs+0x=
22a/0x840 kernel/softirq.c:622
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  run_ksoftirqd+0x36=
/0x60 kernel/softirq.c:1076
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  smpboot_thread_fn+=
0x541/0xa50 kernel/smpboot.c:160
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kthread+0x389/0x47=
0 kernel/kthread.c:436
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ret_from_fork+0x51=
4/0xb70 arch/x86/kernel/process.c:158
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ret_from_fork_asm+=
0x1a/0x30 arch/x86/entry/entry_64.S:245
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Memory state around=
 the buggy address:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff888167305280: =
fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff888167305300: =
fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> >ffff888167305380: =
fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                    =
         ^
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff888167305400: =
fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff888167305480: =
fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> KASAN: slab-use-aft=
er-free Write in sk_skb_reason_drop
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> tree:      net
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> URL:       https://=
kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> base:      18014147=
d3ee7831dce53fe65d7fc8d428b02552
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> arch:      amd64
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> compiler:  Debian c=
lang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50=
), Debian LLD 21.1.8
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> config:    https://=
ci.syzbot.org/builds/90c5185d-0dad-4c34-a563-4253ebb12eb2/config
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syz repro: https://=
ci.syzbot.org/findings/c87569e1-d26e-4670-a17b-9f2f64a5af67/syz_repro
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in instrument_atomic_read_write include/linux/instrumented.h:1=
12 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in atomic_fetch_sub_release include/linux/atomic/atomic-instru=
mented.h:400 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in __refcount_sub_and_test include/linux/refcount.h:389 [inlin=
e]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in __refcount_dec_and_test include/linux/refcount.h:432 [inlin=
e]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in refcount_dec_and_test include/linux/refcount.h:450 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in skb_unref include/linux/skbuff.h:1292 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in __sk_skb_reason_drop net/core/skbuff.c:1212 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BUG: KASAN: slab-us=
e-after-free in sk_skb_reason_drop+0x37/0x110 net/core/skbuff.c:1240
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Write of size 4 at =
addr ffff8881178efee4 by task syz.1.18/5873
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CPU: 0 UID: 0 PID: =
5873 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Hardware name: QEMU=
 Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Call Trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  <TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  dump_stack_lvl+0xe=
8/0x150 lib/dump_stack.c:120
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_address_desc=
ription+0x55/0x1e0 mm/kasan/report.c:378
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  print_report+0x58/=
0x70 mm/kasan/report.c:482
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_report+0x117=
/0x150 mm/kasan/report.c:595
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  check_region_inlin=
e mm/kasan/generic.c:-1 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_check_range+=
0x264/0x2c0 mm/kasan/generic.c:200
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  instrument_atomic_=
read_write include/linux/instrumented.h:112 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  atomic_fetch_sub_r=
elease include/linux/atomic/atomic-instrumented.h:400 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __refcount_sub_and=
_test include/linux/refcount.h:389 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __refcount_dec_and=
_test include/linux/refcount.h:432 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refcount_dec_and_t=
est include/linux/refcount.h:450 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  skb_unref include/=
linux/skbuff.h:1292 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sk_skb_reason_dr=
op net/core/skbuff.c:1212 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sk_skb_reason_drop=
+0x37/0x110 net/core/skbuff.c:1240
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kfree_skb_reason i=
nclude/linux/skbuff.h:1322 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kfree_skb include/=
linux/skbuff.h:1331 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_release+0x=
133a/0x1ad0 net/netlink/af_netlink.c:770
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_release net=
/socket.c:722 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_close+0xc3/0x=
240 net/socket.c:1514
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __fput+0x44f/0xa60=
 fs/file_table.c:510
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  task_work_run+0x1d=
9/0x270 kernel/task_work.c:233
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  resume_user_mode_w=
ork include/linux/resume_user_mode.h:50 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __exit_to_user_mod=
e_loop kernel/entry/common.c:67 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  exit_to_user_mode_=
loop+0xf3/0x4d0 kernel/entry/common.c:98
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __exit_to_user_mod=
e_prepare include/linux/irq-entry-common.h:207 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  syscall_exit_to_us=
er_mode_prepare include/linux/irq-entry-common.h:230 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  syscall_exit_to_us=
er_mode include/linux/entry-common.h:318 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x33=
e/0xf80 arch/x86/entry/syscall_64.c:100
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RIP: 0033:0x7fd4d13=
9ce59
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Code: ff c3 66 2e 0=
f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4=
d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1=
 e8 ff ff ff f7 d8 64 89 01 48
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RSP: 002b:00007fff7=
22ecbf8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RAX: 00000000000000=
00 RBX: 00007fff722ecce0 RCX: 00007fd4d139ce59
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RDX: 00000000000000=
00 RSI: 000000000000001e RDI: 0000000000000003
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> RBP: 00000000000128=
25 R08: 0000000000000001 R09: 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R10: 0000001b32e200=
00 R11: 0000000000000246 R12: 00007fff722ecd20
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> R13: 00007fd4d1615f=
ac R14: 0000000000012859 R15: 00007fd4d1615fa0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  </TASK>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Allocated by task 5=
874:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack m=
m/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0=
x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  unpoison_slab_obje=
ct mm/kasan/common.c:340 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_mempool_un=
poison_object+0xa3/0x130 mm/kasan/common.c:564
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_mempool_unpo=
ison_object include/linux/kasan.h:391 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  napi_skb_cache_get=
+0x3c8/0x780 net/core/skbuff.c:306
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x19a/=
0x7d0 net/core/skbuff.c:696
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x=
5d4/0xb40 net/netlink/af_netlink.c:1869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec=
 net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net=
/socket.c:802 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendto+0x672=
/0x710 net/socket.c:2265
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendto ne=
t/socket.c:2272 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendto ne=
t/socket.c:2268 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendto+0=
xde/0x100 net/socket.c:2268
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Freed by task 5874:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_stack m=
m/kasan/common.c:57 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_track+0=
x3e/0x80 mm/kasan/common.c:78
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_save_free_in=
fo+0x46/0x50 mm/kasan/generic.c:584
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  poison_slab_object=
 mm/kasan/common.c:253 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __kasan_slab_free+=
0x5c/0x80 mm/kasan/common.c:285
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kasan_slab_free in=
clude/linux/kasan.h:235 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free_hook mm/=
slub.c:2689 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_free mm/slub.=
c:6250 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_free+0x=
182/0x650 mm/slub.c:6377
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast_ke=
rnel net/netlink/af_netlink.c:1319 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_unicast+0x=
764/0x8e0 net/netlink/af_netlink.c:1344
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  netlink_sendmsg+0x=
813/0xb40 net/netlink/af_netlink.c:1894
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec=
 net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net=
/socket.c:802 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendto+0x672=
/0x710 net/socket.c:2265
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendto ne=
t/socket.c:2272 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendto ne=
t/socket.c:2268 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendto+0=
xde/0x100 net/socket.c:2268
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address b=
elongs to the object at ffff8881178efe00
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  which belongs to t=
he cache skbuff_head_cache of size 240
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address i=
s located 228 bytes inside of
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  freed 240-byte reg=
ion [ffff8881178efe00, ffff8881178efef0)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The buggy address b=
elongs to the physical page:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page: refcount:0 ma=
pcount:0 mapping:0000000000000000 index:0x0 pfn:0x1178ee
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: order:1 mapco=
unt:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> flags: 0x17ff000000=
00040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_type: f5(slab)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 017ff000000000=
40 ffff888160416c80 dead000000000122 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> raw: 00000000000000=
00 0000000800150015 00000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 017ff00000000=
040 ffff888160416c80 dead000000000122 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 0000000000000=
000 0000000800150015 00000000f5000000 0000000000000000
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: 017ff00000000=
001 ffffffffffffff81 00000000ffffffff 00000000ffffffff
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> head: fffffffffffff=
fff 0000000000000000 00000000ffffffff 0000000000000002
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page dumped because=
: kasan: bad access detected
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page_owner tracks t=
he page as allocated
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last allocated=
 via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__G=
FP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5050, tgid 5050 (=
klogd), ts 75887265953, free_ts 75876344896
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  set_page_owner inc=
lude/linux/page_owner.h:32 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  post_alloc_hook+0x=
22d/0x280 mm/page_alloc.c:1858
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  prep_new_page mm/p=
age_alloc.c:1866 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  get_page_from_free=
list+0x24ba/0x2540 mm/page_alloc.c:3946
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_frozen_pag=
es_noprof+0x18d/0x380 mm/page_alloc.c:5226
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_slab_page mm=
/slub.c:3278 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  allocate_slab+0x77=
/0x660 mm/slub.c:3467
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  new_slab mm/slub.c=
:3525 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_objects+0x3=
39/0x3d0 mm/slub.c:7271
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  refill_sheaf mm/sl=
ub.c:2816 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __pcs_replace_empt=
y_main+0x321/0x720 mm/slub.c:4651
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_from_pcs mm/=
slub.c:4749 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  slab_alloc_node mm=
/slub.c:4883 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  kmem_cache_alloc_n=
ode_noprof+0x441/0x690 mm/slub.c:4950
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __alloc_skb+0x1d0/=
0x7d0 net/core/skbuff.c:702
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_skb include/=
linux/skbuff.h:1383 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  alloc_skb_with_fra=
gs+0xc8/0x760 net/core/skbuff.c:6743
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_alloc_send_ps=
kb+0x878/0x990 net/core/sock.c:2998
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  unix_dgram_sendmsg=
+0x460/0x18d0 net/unix/af_unix.c:2141
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sock_sendmsg_nosec=
 net/socket.c:787 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sock_sendmsg net=
/socket.c:802 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __sys_sendto+0x672=
/0x710 net/socket.c:2265
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_sys_sendto ne=
t/socket.c:2272 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __se_sys_sendto ne=
t/socket.c:2268 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __x64_sys_sendto+0=
xde/0x100 net/socket.c:2268
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_x64 arc=
h/x86/entry/syscall_64.c:63 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  do_syscall_64+0x15=
f/0xf80 arch/x86/entry/syscall_64.c:94
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  entry_SYSCALL_64_a=
fter_hwframe+0x77/0x7f
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> page last free pid =
0 tgid 0 stack trace:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  reset_page_owner i=
nclude/linux/page_owner.h:25 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_pages_prepa=
re mm/page_alloc.c:1402 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __free_frozen_page=
s+0xbc7/0xd30 mm/page_alloc.c:2943
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  rcu_do_batch kerne=
l/rcu/tree.c:2617 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  rcu_core+0x7cd/0x1=
070 kernel/rcu/tree.c:2869
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  handle_softirqs+0x=
22a/0x840 kernel/softirq.c:622
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __do_softirq kerne=
l/softirq.c:656 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  invoke_softirq ker=
nel/softirq.c:496 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  __irq_exit_rcu+0xc=
a/0x220 kernel/softirq.c:735
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  irq_exit_rcu+0x9/0=
x30 kernel/softirq.c:752
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  instr_sysvec_apic_=
timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  sysvec_apic_timer_=
interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  asm_sysvec_apic_ti=
mer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Memory state around=
 the buggy address:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff8881178efd80: =
fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff8881178efe00: =
fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> >ffff8881178efe80: =
fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>                    =
                                    ^
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff8881178eff00: =
fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  ffff8881178eff80: =
fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ***
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> If these findings h=
ave caused you to resend the series or submit a
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> separate fix, pleas=
e add the following tag to your commit message:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>   Tested-by: syzbot=
@syzkaller.appspotmail.com
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> This report is gene=
rated by a bot. It may contain errors.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> syzbot ci engineers=
 can be reached at syzkaller@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To test a patch for=
 this bug, please reply with `#syz test`
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> (should be on a sep=
arate line).
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The patch should be=
 attached to the email.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Note: arguments lik=
e custom git repos and branches are not supported.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email will late=
r be sent to:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> [davem@davemloft.ne=
t edumazet@google.com horms@kernel.org kees@kernel.org kuba@kernel.org kuni=
yu@google.com linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@re=
dhat.com stable@vger.kernel.org vulab@iscas.ac.cn yangfeng@kylinos.cn]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> If the report looks=
 fine to you, reply with:
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #syz upstream
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> If the report is a =
false positive, reply with
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> #syz invalid
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> You received this m=
essage because you are subscribed to the Google Groups "syzkaller-upstream-=
moderation" group.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To unsubscribe from=
 this group and stop receiving emails from it, send an email to syzkaller-u=
pstream-moderation+unsubscribe@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To view this discus=
sion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/=
6a185386.99a1ea37.128423.0001.GAE%40google.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --=20
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> You received this mes=
sage because you are subscribed to the Google Groups "syzkaller-upstream-mo=
deration" group.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To unsubscribe from t=
his group and stop receiving emails from it, send an email to syzkaller-ups=
tream-moderation+unsubscribe@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To view this discussi=
on visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/6a=
18555e.e783d627.6395.0001.GAE%40google.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but =
can't find the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  =
syzbot+HASH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not =
correspond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check th=
e address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but c=
an't find the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  s=
yzbot+HASH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not c=
orrespond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the=
 address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but ca=
n't find the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  sy=
zbot+HASH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not co=
rrespond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the =
address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --=20
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> You received this messag=
e because you are subscribed to the Google Groups "syzkaller-upstream-moder=
ation" group.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To unsubscribe from this=
 group and stop receiving emails from it, send an email to syzkaller-upstre=
am-moderation+unsubscribe@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To view this discussion =
visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/6a185=
562.222db38e.c0a93.0000.GAE%40google.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can=
't find the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syz=
bot+HASH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not cor=
respond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the a=
ddress.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can'=
t find the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzb=
ot+HASH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not corr=
espond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the ad=
dress.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --=20
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> You received this message =
because you are subscribed to the Google Groups "syzkaller-upstream-moderat=
ion" group.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To unsubscribe from this g=
roup and stop receiving emails from it, send an email to syzkaller-upstream=
-moderation+unsubscribe@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To view this discussion vi=
sit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/6a18556=
5.e783d627.6395.0003.GAE%40google.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't=
 find the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbo=
t+HASH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not corre=
spond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the add=
ress.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't =
find the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot=
+HASH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not corres=
pond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the addr=
ess.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --=20
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> You received this message be=
cause you are subscribed to the Google Groups "syzkaller-upstream-moderatio=
n" group.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To unsubscribe from this gro=
up and stop receiving emails from it, send an email to syzkaller-upstream-m=
oderation+unsubscribe@googlegroups.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> To view this discussion visi=
t https://groups.google.com/d/msgid/syzkaller-upstream-moderation/6a185568.=
b6d9d2ce.2aaec5.0010.GAE%40google.com.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't f=
ind the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+=
HASH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not corresp=
ond to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the addre=
ss.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't fi=
nd the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+H=
ASH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspo=
nd to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the addres=
s.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't fin=
d the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HA=
SH@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspon=
d to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address=
.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find=
 the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HAS=
H@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond=
 to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find =
the corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH=
@syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond =
to any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find t=
he corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@=
syzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond t=
o any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find th=
e corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@s=
yzkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to=
 any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the=
 corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@sy=
zkaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to =
any known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the =
corresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syz=
kaller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to a=
ny known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the c=
orresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzk=
aller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to an=
y known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the co=
rresponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzka=
ller.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any=
 known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the cor=
responding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkal=
ler.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any =
known bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corr=
esponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkall=
er.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any k=
nown bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corre=
sponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkalle=
r.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any kn=
own bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> I see the command but can't find the corres=
ponding bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> The email is sent to  syzbot+HASH@syzkaller=
.appspotmail.com address
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> but the HASH does not correspond to any kno=
wn bug.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Please double check the address.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

