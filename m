Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E69F30C60B
	for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 14:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762870013; cv=none; b=Unh+s9+xAiNxQ1rJ7gLiE6mK9m0F1Aq4ddxbhH1SYcu0OwWiuW0AR8JcE8Km432vB6HrWu35G/CwSBXheN4H09S3EnZmqIistTZFKxr5G/+yR+XAbdacho1czQKIv6KmgjDgHDXvESAqjBBr3bWqpiSroNZx77SMcsgjkR43hFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762870013; c=relaxed/simple;
	bh=KQSf+o2Bv5vy5hI8uHE6V77CJlnTRUUAuJ6MED07vIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HwFBCvkRoyc8CkeqHZCmESbl7Sc8tvAwEfeGmKjDuWmiKe+FajXJsnusCeI/P12D2XOxeA7Ed1V1h7z0KZW6nqtIjEp3hwnYTThYhsBa1JFUKwgu5dw9uIBiH05/hxU1xlDb+IafzQ13n/JXIC4XiEmkdCbd+i0tProljd5lQ0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DM9DeTb/; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DM9DeTb/"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7c6d13986f8so539684a34.0
        for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 06:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762870011; x=1763474811; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4YV7Pu5e5f+5dCTuTLqedHwQDqMZsFAEukTUjqir58=;
        b=DM9DeTb/FSsVwYhW+HkOTQU77xTMc0YuO9EgoPx14aiLQ9TD89u9eY1d9swbjeLih4
         OIIV9h2WjE8ZIX0d1Jv8QXoVk3bWGrUEeKuzr3ds2tuZBfBAYFfLoMEuiYwqjZMZR5YL
         HHrbSwWofx+oC5BoJc0LrU0/+vOI8XsCRJQxlgguf9o25KCqdn6p9VZc/e+rAcQ7DChv
         CSkoqxP33k4lRTlG7oBXWM+hHqVmBo1Ng/zO5toTTcHJPT1xN5ziI0qosf3QWMfrNQNq
         NxQ5FAZ6bMzrJYrGnuF1VzwSgr42oy4L1fnph30z1dUkzBCP9pScvL4tZb1A2WQ0XG9M
         6qpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762870011; x=1763474811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N4YV7Pu5e5f+5dCTuTLqedHwQDqMZsFAEukTUjqir58=;
        b=UsxoPD8wcqM5nwOjlqbl2eQyKrRN+AJ/f0gNDiVsn0cxzhwqMRsbjE9mQwu/M5sn+f
         LCl1DrQQW9FFHI4d0oUf2RQh/KLtQ/RaaeNf9xEknBI10A/rFGdtObgOz7TjCG+kkmoq
         D6yKiEsrP8fS4fx+IHx7EMGkWJK717O9Xli6U9vycQvsXT1KiX1Nb82N8jbY5ywMMuEU
         lI7ssfCERtQV4BzPkP1RpSqYioP5bCqNaJ2XndRiWHaMDRzN9CA+r3wgddMyYy8CiYET
         TY9SKgeDGut141I6Ygawm2PXoBjvhh5wVo4oJ6EzUzT2DyReZe5/SzwhtlDyBB/F80Je
         EBLw==
X-Forwarded-Encrypted: i=1; AJvYcCXQtt3HvLO+V7RhQCxbOto+a2uxuiY7ONj4/aWj3gGBVCLWYiBIFiix6nSCSlJXYyG6RkHAYj0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9sOqHYCXgBZY5PFu8geOp5zxD4DdYxZpAo9j6D4kmgHk4G/NC
	0Bai6+GTtQ7GdKKtMO910zBubCMEUVFpBhbaA4S0qx/Whjkna1dFkmkjVJEt+3VVYP4iCtbbm1E
	GLIVbPKyRJ7HPY+MRWgJamxsLQLCFTm1Q++k7gbUI
X-Gm-Gg: ASbGncsNYWVRGwhHw/aOFYD05OeHVKHpY+pUmS/uNGNwHi7eS7XGhF9Mnnzd7ow5OmB
	7OyTErLqYlV5Vk59uVwrec7PcL9TO+myp29b0/AiJvx59YqgA4U8N3i6S7prh9jpQ/zgr4FhWwd
	/tCR46GaxRF2V2XF667M6+UoWpjXPgExdYIe6+BeRHq7sPRU+rnNrcWTw6nGEQyZJja/BWaeDOl
	TmpQswOx/hr+qAU1x8GlmG9OFD9EnO8iNoRqgtNThhFXy/uLXxJK4OH/TMiU4c2lM2kRXg1C5CV
	bzb51aLeqtm6iLex9QX0HIFMhsgsE1G4o2K7/tIIktTMb1EKblBOJ3f+Q+NOvjSepczs
X-Google-Smtp-Source: AGHT+IHukPtvQ6Pde4/Sa+F6wrrTgi95MJ5pGqqNdzH7qLqwlXShYXJnJ6xgGsZ0Ll/dIvE0dfDPiBHycuxmrf2fhpg=
X-Received: by 2002:a9d:6c99:0:b0:7c2:9902:85cf with SMTP id
 46e09a7af769-7c720bfa59cmr1360084a34.9.1762870010404; Tue, 11 Nov 2025
 06:06:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <691340c9.a70a0220.22f260.013a.GAE@google.com>
In-Reply-To: <691340c9.a70a0220.22f260.013a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 11 Nov 2025 15:06:39 +0100
X-Gm-Features: AWmQ_blpTYnXLBe_VWnM3pZo5VjN0j4MzGaX4hSdN_eM4CqVr-gyXiITB0zNlqI
Message-ID: <CANp29Y4naLGjhdwTO_7GfdAG6RqEbX7=P7Z4z==9NxjM500X7g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net_sched: speedup qdisc dequeue
To: syzbot ci <syzbot+ciae3d45b95de4eab5@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Nov 11, 2025 at 2:57=E2=80=AFPM syzbot ci
<syzbot+ciae3d45b95de4eab5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net_sched: speedup qdisc dequeue
> https://lore.kernel.org/all/20251111093204.1432437-1-edumazet@google.com
> * [PATCH v2 net-next 01/14] net_sched: make room for (struct qdisc_skb_cb=
)->pkt_segs
> * [PATCH v2 net-next 02/14] net: init shinfo->gso_segs from qdisc_pkt_len=
_init()
> * [PATCH v2 net-next 03/14] net_sched: initialize qdisc_skb_cb(skb)->pkt_=
segs in qdisc_pkt_len_init()
> * [PATCH v2 net-next 04/14] net: use qdisc_pkt_len_segs_init() in sch_han=
dle_ingress()
> * [PATCH v2 net-next 05/14] net_sched: use qdisc_skb_cb(skb)->pkt_segs in=
 bstats_update()
> * [PATCH v2 net-next 06/14] net_sched: cake: use qdisc_pkt_segs()
> * [PATCH v2 net-next 07/14] net_sched: add Qdisc_read_mostly and Qdisc_wr=
ite groups
> * [PATCH v2 net-next 08/14] net_sched: sch_fq: move qdisc_bstats_update()=
 to fq_dequeue_skb()
> * [PATCH v2 net-next 09/14] net_sched: sch_fq: prefetch one skb ahead in =
dequeue()
> * [PATCH v2 net-next 10/14] net: prefech skb->priority in __dev_xmit_skb(=
)
> * [PATCH v2 net-next 11/14] net: annotate a data-race in __dev_xmit_skb()
> * [PATCH v2 net-next 12/14] net_sched: add tcf_kfree_skb_list() helper
> * [PATCH v2 net-next 13/14] net_sched: add qdisc_dequeue_drop() helper
> * [PATCH v2 net-next 14/14] net_sched: use qdisc_dequeue_drop() in cake, =
codel, fq_codel
>
> and found the following issue:
> WARNING in sk_skb_reason_drop
>
> Full report is available here:
> https://ci.syzbot.org/series/a9dbee91-6b1f-4ab9-b55d-43f7f50de064
>
> ***
>
> WARNING in sk_skb_reason_drop
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      a0c3aefb08cd81864b17c23c25b388dba90b9dad
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/a5059d85-d1f8-4036-a0fd-b677b5945=
ea9/config
> C repro:   https://ci.syzbot.org/findings/e529fc3a-766e-4d6c-899a-c35a8fd=
aa940/c_repro
> syz repro: https://ci.syzbot.org/findings/e529fc3a-766e-4d6c-899a-c35a8fd=
aa940/syz_repro
>
> syzkaller0: entered promiscuous mode
> syzkaller0: entered allmulticast mode
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5965 at net/core/skbuff.c:1192 __sk_skb_reason_drop =
net/core/skbuff.c:1189 [inline]
> WARNING: CPU: 0 PID: 5965 at net/core/skbuff.c:1192 sk_skb_reason_drop+0x=
76/0x170 net/core/skbuff.c:1214
> Modules linked in:
> CPU: 0 UID: 0 PID: 5965 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__sk_skb_reason_drop net/core/skbuff.c:1189 [inline]
> RIP: 0010:sk_skb_reason_drop+0x76/0x170 net/core/skbuff.c:1214
> Code: 20 2e a0 f8 83 fd 01 75 26 41 8d ae 00 00 fd ff bf 01 00 fd ff 89 e=
e e8 08 2e a0 f8 81 fd 00 00 fd ff 77 32 e8 bb 29 a0 f8 90 <0f> 0b 90 eb 53=
 bf 01 00 00 00 89 ee e8 e9 2d a0 f8 85 ed 0f 8e b2
> RSP: 0018:ffffc9000284f3b0 EFLAGS: 00010293
> RAX: ffffffff891fdcd5 RBX: ffff888113587680 RCX: ffff88816e6f3a00
> RDX: 0000000000000000 RSI: 000000006e1a2a10 RDI: 00000000fffd0001
> RBP: 000000006e1a2a10 R08: ffff888113587767 R09: 1ffff110226b0eec
> R10: dffffc0000000000 R11: ffffed10226b0eed R12: ffff888113587764
> R13: dffffc0000000000 R14: 000000006e1d2a10 R15: 0000000000000000
> FS:  000055558e11c500(0000) GS:ffff88818eb38000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000002280 CR3: 000000011053c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  kfree_skb_reason include/linux/skbuff.h:1322 [inline]
>  tcf_kfree_skb_list include/net/sch_generic.h:1127 [inline]
>  __dev_xmit_skb net/core/dev.c:4258 [inline]
>  __dev_queue_xmit+0x2669/0x3180 net/core/dev.c:4783
>  packet_snd net/packet/af_packet.c:3076 [inline]
>  packet_sendmsg+0x3e33/0x5080 net/packet/af_packet.c:3108
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x505/0x830 net/socket.c:2630
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
>  __sys_sendmsg net/socket.c:2716 [inline]
>  __do_sys_sendmsg net/socket.c:2721 [inline]
>  __se_sys_sendmsg net/socket.c:2719 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fc1a7b8efc9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff4ba6d968 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fc1a7de5fa0 RCX: 00007fc1a7b8efc9
> RDX: 0000000000000004 RSI: 00002000000000c0 RDI: 0000000000000007
> RBP: 00007fc1a7c11f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fc1a7de5fa0 R14: 00007fc1a7de5fa0 R15: 0000000000000003
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
> [davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@ker=
nel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org kuniyu@google.com=
 netdev@vger.kernel.org pabeni@redhat.com toke@redhat.com willemb@google.co=
m xiyou.wangcong@gmail.com]
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
-upstream-moderation/691340c9.a70a0220.22f260.013a.GAE%40google.com.
