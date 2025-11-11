Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF90299928
	for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 19:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762889050; cv=none; b=UHZmPeLFHbIcyX9TEKH0bzb3qBsRSkA2cO8urCL8w9r+hMlxktKAMZ/fua8IhS5cc57TNQ4fCoQgssDPedAoBapKAxUXw6iweJt10VOjNRFx7qClijPnyOoevOXZW0nzHLGQddbCxt4klxGzyYC0SufGNNdUer9dIQ/jokbgnmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762889050; c=relaxed/simple;
	bh=0kVZEUry4zA5gM/6QJOrIUT0TdpY7tJ37G3Y/Rm4wD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f7dzz1HyDelYMV3bMnq1mpZ8qzMnSp1ipUFGgALH8hJDxdGfP3TPzXNXKF1C6DsVanLhiQuU5go5FZPDypxBieM2P77sJFf9Gox6iwh7lwFXORyKZEChPf9dJVm2O60ATegJXGymMBD8B+AC8Kdv7Ig5pVYEYrQgAu5q9hEhd7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VZZYbToM; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VZZYbToM"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ed861eb98cso815281cf.3
        for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 11:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762889047; x=1763493847; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NpUysYmo0ZFjhBZAlpmGn5yIqRvZt+XQSoQi1hXJ3Kk=;
        b=VZZYbToM4EZTc+3uKfDaXJXay+ouRKXV13+yE6K61w94bA7mmCKU6dhOfh4a7f639a
         XULBoJHuLwR+KgpxU9aw2TChfE4tnzM73jntole14baAxvdJmvvfgCcz5INKHSiCEe/E
         2VLpUjUgSb2wnIopeqW48LdLNu2I+l0nIlwytp0QgHeMzNAs4Zl1y9wgJdGHRYWcpWZf
         siFBy0Mg8ZxcVF/ptmOwVonfU7Y78kPhf8pk2JihhsxwVqscTulrSk4fSvfDoAmaI+kW
         0gsUgxcNHQ/vqs90xOqMpx1W0P9bFKoXcHj3TZWkBWYVVhXEyuFGEKv6LcB/vCeQq/cK
         60ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762889047; x=1763493847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NpUysYmo0ZFjhBZAlpmGn5yIqRvZt+XQSoQi1hXJ3Kk=;
        b=G2IwDaRb3zaBLPNWL3kYDO0gIO98QwcyWVEyxciI8KBlV7subjqbdls7pcTXvBcpUe
         Y6m5Mt4RBmUT4rlQxS6SIo/kjKpVGPDZHMAnF16te+RzyKKkbwofARqfMIP4jYSIuoXd
         khsMx7WN6z1Mb+RDvgYIeN1VXoqRLfVEK1BcwN3gc0iTuBmwpr+nfu8G8AV8QMuIuqt5
         aD6azA4EIzVETQOppn2/LAQ248UpmKgu3KnmyZWD9rBQxbif6qEPFJGakQH/eoGpA6lH
         aeQlhi94f8wByXlbAcqFdjE5NKt/ntjF/O2AKwRptUQn87HXpFvsVufVtytn+qvS743b
         aqeA==
X-Forwarded-Encrypted: i=1; AJvYcCWk6Vr1YPqMKug7PQacxyKj+RSxTOyoRQOK3mjDgqZ2G36ZP6C8xQW/NJMaJcoF8rRUW2o6kaU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwImu5KiQlmHVo7YEXT3Hh4xyKMA5vDq/9l6WQgpsPEqR70V8zL
	wMChf0ZKWz8eNa+qfBLDHk0Vy/ssiX/8QllXOSdUGzFvuUIfciN1DxjSt1JM4DSbCvaYZWHi6/f
	jkx9lwvZPdYvLLQqYxwENcOI5W+kWPmeQa9dj3mO+
X-Gm-Gg: ASbGncuJf/9RrR8u2WbkGbBnphAkTEXWqa0otwoSpOqWna04l2mGldRaIiX7BFDl3bG
	Fk/FTd9CV4YKK0OwAIqvNzcxg9TKKxsNAbDt6buq7L5MM5kolehtlxsyKLcRJcQ3/FJt/GlLKoH
	CxPFb7+yR5io/UROV7Z5YlZD9pfFFVmeMDBibN5iibRDnvhkIkHmsmnWWokdyrNeGUU6usE4LvP
	Q+hUzbZjmAXjHKgaQ3fTTbljcsVbuOyjqmiLr5xwmuOr3aEf2VMjIC0udhvZGH1uPG9zQrL6FVL
	xX5aGg==
X-Google-Smtp-Source: AGHT+IHgdffxMXk2L1+L5D0EhFqavRvZsApB6HWnfPka30SNopPchdb7ARpmkpdsMZWjHBLGKHeTt55ooRXtd0+tDxg=
X-Received: by 2002:ac8:5741:0:b0:4e8:a0bf:f5b5 with SMTP id
 d75a77b69052e-4eddbdd8f4amr4549541cf.73.1762889046407; Tue, 11 Nov 2025
 11:24:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111093204.1432437-1-edumazet@google.com> <6913437c.a70a0220.22f260.013b.GAE@google.com>
 <CANn89iKgYo=f+NyOVFfLjkYLczWsqopxt4F5adutf5eY9TAJmA@mail.gmail.com>
In-Reply-To: <CANn89iKgYo=f+NyOVFfLjkYLczWsqopxt4F5adutf5eY9TAJmA@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 11 Nov 2025 11:23:55 -0800
X-Gm-Features: AWmQ_bn3Ul8SCcs8ZoLOIGAmR_eqcxw1d18J9obuuLSR1JxaFhqsmm6gXHf1epU
Message-ID: <CANn89iJ5p3xY_LJcexq8n2-91A6ERPV6yqjPGphD_w6wr_NHew@mail.gmail.com>
Subject: Re: [syzbot ci] Re: net_sched: speedup qdisc dequeue
To: syzbot ci <syzbot+ci51c71986dfbbfee2@syzkaller.appspotmail.com>, 
	Victor Nogueira <victor@mojatatu.com>, Daniel Borkmann <daniel@iogearbox.net>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, horms@kernel.org, 
	jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org, kuniyu@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, toke@redhat.com, 
	willemb@google.com, xiyou.wangcong@gmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 8:28=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Tue, Nov 11, 2025 at 6:09=E2=80=AFAM syzbot ci
> <syzbot+ci51c71986dfbbfee2@syzkaller.appspotmail.com> wrote:
> >
> > syzbot ci has tested the following series
> >
> > [v2] net_sched: speedup qdisc dequeue
> > https://lore.kernel.org/all/20251111093204.1432437-1-edumazet@google.co=
m
> > * [PATCH v2 net-next 01/14] net_sched: make room for (struct qdisc_skb_=
cb)->pkt_segs
> > * [PATCH v2 net-next 02/14] net: init shinfo->gso_segs from qdisc_pkt_l=
en_init()
> > * [PATCH v2 net-next 03/14] net_sched: initialize qdisc_skb_cb(skb)->pk=
t_segs in qdisc_pkt_len_init()
> > * [PATCH v2 net-next 04/14] net: use qdisc_pkt_len_segs_init() in sch_h=
andle_ingress()
> > * [PATCH v2 net-next 05/14] net_sched: use qdisc_skb_cb(skb)->pkt_segs =
in bstats_update()
> > * [PATCH v2 net-next 06/14] net_sched: cake: use qdisc_pkt_segs()
> > * [PATCH v2 net-next 07/14] net_sched: add Qdisc_read_mostly and Qdisc_=
write groups
> > * [PATCH v2 net-next 08/14] net_sched: sch_fq: move qdisc_bstats_update=
() to fq_dequeue_skb()
> > * [PATCH v2 net-next 09/14] net_sched: sch_fq: prefetch one skb ahead i=
n dequeue()
> > * [PATCH v2 net-next 10/14] net: prefech skb->priority in __dev_xmit_sk=
b()
> > * [PATCH v2 net-next 11/14] net: annotate a data-race in __dev_xmit_skb=
()
> > * [PATCH v2 net-next 12/14] net_sched: add tcf_kfree_skb_list() helper
> > * [PATCH v2 net-next 13/14] net_sched: add qdisc_dequeue_drop() helper
> > * [PATCH v2 net-next 14/14] net_sched: use qdisc_dequeue_drop() in cake=
, codel, fq_codel
> >
> > and found the following issue:
> > WARNING in sk_skb_reason_drop
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/a9dbee91-6b1f-4ab9-b55d-43f7f50de064
> >
> > ***
> >
> > WARNING in sk_skb_reason_drop
> >
> > tree:      net-next
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/net=
dev/net-next.git
> > base:      a0c3aefb08cd81864b17c23c25b388dba90b9dad
> > arch:      amd64
> > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1=
~exp1~20250708183702.136), Debian LLD 20.1.8
> > config:    https://ci.syzbot.org/builds/a5059d85-d1f8-4036-a0fd-b677b59=
45ea9/config
> > C repro:   https://ci.syzbot.org/findings/e529fc3a-766e-4d6c-899a-c35a8=
fdaa940/c_repro
> > syz repro: https://ci.syzbot.org/findings/e529fc3a-766e-4d6c-899a-c35a8=
fdaa940/syz_repro
> >
> > syzkaller0: entered promiscuous mode
> > syzkaller0: entered allmulticast mode
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 5965 at net/core/skbuff.c:1192 __sk_skb_reason_dro=
p net/core/skbuff.c:1189 [inline]
> > WARNING: CPU: 0 PID: 5965 at net/core/skbuff.c:1192 sk_skb_reason_drop+=
0x76/0x170 net/core/skbuff.c:1214
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 5965 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT=
(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-=
1.16.2-1 04/01/2014
> > RIP: 0010:__sk_skb_reason_drop net/core/skbuff.c:1189 [inline]
> > RIP: 0010:sk_skb_reason_drop+0x76/0x170 net/core/skbuff.c:1214
> > Code: 20 2e a0 f8 83 fd 01 75 26 41 8d ae 00 00 fd ff bf 01 00 fd ff 89=
 ee e8 08 2e a0 f8 81 fd 00 00 fd ff 77 32 e8 bb 29 a0 f8 90 <0f> 0b 90 eb =
53 bf 01 00 00 00 89 ee e8 e9 2d a0 f8 85 ed 0f 8e b2
> > RSP: 0018:ffffc9000284f3b0 EFLAGS: 00010293
> > RAX: ffffffff891fdcd5 RBX: ffff888113587680 RCX: ffff88816e6f3a00
> > RDX: 0000000000000000 RSI: 000000006e1a2a10 RDI: 00000000fffd0001
> > RBP: 000000006e1a2a10 R08: ffff888113587767 R09: 1ffff110226b0eec
> > R10: dffffc0000000000 R11: ffffed10226b0eed R12: ffff888113587764
> > R13: dffffc0000000000 R14: 000000006e1d2a10 R15: 0000000000000000
> > FS:  000055558e11c500(0000) GS:ffff88818eb38000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000200000002280 CR3: 000000011053c000 CR4: 00000000000006f0
> > Call Trace:
> >  <TASK>
> >  kfree_skb_reason include/linux/skbuff.h:1322 [inline]
> >  tcf_kfree_skb_list include/net/sch_generic.h:1127 [inline]
> >  __dev_xmit_skb net/core/dev.c:4258 [inline]
> >  __dev_queue_xmit+0x2669/0x3180 net/core/dev.c:4783
> >  packet_snd net/packet/af_packet.c:3076 [inline]
> >  packet_sendmsg+0x3e33/0x5080 net/packet/af_packet.c:3108
> >  sock_sendmsg_nosec net/socket.c:727 [inline]
> >  __sock_sendmsg+0x21c/0x270 net/socket.c:742
> >  ____sys_sendmsg+0x505/0x830 net/socket.c:2630
> >  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
> >  __sys_sendmsg net/socket.c:2716 [inline]
> >  __do_sys_sendmsg net/socket.c:2721 [inline]
> >  __se_sys_sendmsg net/socket.c:2719 [inline]
> >  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fc1a7b8efc9
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fff4ba6d968 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 00007fc1a7de5fa0 RCX: 00007fc1a7b8efc9
> > RDX: 0000000000000004 RSI: 00002000000000c0 RDI: 0000000000000007
> > RBP: 00007fc1a7c11f91 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007fc1a7de5fa0 R14: 00007fc1a7de5fa0 R15: 0000000000000003
> >  </TASK>
> >
>
> Seems that cls_bpf_classify() is able to change tc_skb_cb(skb)->drop_reas=
on,
> and this predates my code.

struct bpf_skb_data_end {
  struct qdisc_skb_cb qdisc_cb;
  void *data_meta;
   void *data_end;
};

So anytime BPF calls bpf_compute_data_pointers(), it overwrites
tc_skb_cb(skb)->drop_reason,
because offsetof(   ..., data_meta) =3D=3D offsetof(... drop_reason)

CC Victor and Daniel
