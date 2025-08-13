Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4503D35942
	for <syzbot@lists.linux.dev>; Wed, 13 Aug 2025 00:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755046628; cv=none; b=WVeUFKFUaro59OCpLdEn6sjw0E+Nda6rwspNeLauWn+AhoYuQYvz2XEcNTwQD9VQV7kmt5cnZ0ZJsN9tZSmUu+MLHOE2S7Q9SIKNqVuuaD8RENIfrVyXBkoTgrbPiTmBCOT07sxIUZI2BLbi7tcR6/1z+MZzG4Eni34C17A7Yk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755046628; c=relaxed/simple;
	bh=AUSNraVHnwfX9JYR8kijdGOWeDg9B2NPw2zVekpPjj4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Xv2OKblkFsdOg2t0eP4l71ecPSys075kfxNmnU4WAcbbkuXPD1lTRZ5nL00cqgNrLciiKrIBcmCHYpqDtHKfXy5SVkPCyuam0L/32UNYyeECLUshgXm8BytP453fPUwPqywEphT5GMHhw1xNoFKNvlFWOrFFnhgMgmXb3P7vZI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8816e763309so615851539f.3
        for <syzbot@lists.linux.dev>; Tue, 12 Aug 2025 17:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755046625; x=1755651425;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SBzO11mYKgM9wemc9PZYMgSWzsbwRdgJFeDrD3KuZ98=;
        b=q3mh99iw5F/N+ZbNY/pdCoAu210JMsMLlmYngNQJd765rK0F2s3eDg2jflkHpoW/O/
         H03tOA4wDxAutrYQX0MAveX7GLWSckswlC6FJBetBjeJWRDSzv0jT8KL4Fv8bu53UZkB
         bsDLSUTENgHX07IIEef9Za6PEcHW2wpvPdGzguIvZrIa7Op7Sqel9seGFS1xRMEXqtM6
         /xXp88Dy8iByeZZNRCD/Stf/YtGikeT2BqJZWH/GFXisIfQgK5x1s6Ynr1Ij1lti2Nv9
         Ul301cfZMtMNDi6ARXhXhf95XljE8euJyT/8DgYTOehl4816V/dVYu8qqfBfNvUDpvQT
         064w==
X-Gm-Message-State: AOJu0YwjkHH2pl5bI2XPEdovRDQx8KT1xeFxQ82bAM0X9wrs3O1X94AB
	jzAQXxuySmL874WdVfcH+uF75CTDbjcxlWYSfcK0oVDTAGq7rHU0wsVBdr0HCPQnep9I4ehqoxR
	nHaYuduYON7pHTIGGIEWesFmQwJvFRK9hsbFSP9/+y6tqB7qpKzAOGK0AbvY=
X-Google-Smtp-Source: AGHT+IFf6BcvSiamlF+dqf5u0lzUlxcdZSO445/8GO5LwLGGgOPMPsHEbAiGp5rPNcBb77gOoWNKUUy9YUikYhfDShjItRjWFOkE
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:14c4:b0:883:fc1c:edfc with SMTP id
 ca18e2360f4ac-884296091c0mr204742139f.3.1755046625285; Tue, 12 Aug 2025
 17:57:05 -0700 (PDT)
Date: Tue, 12 Aug 2025 17:57:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689be2e1.050a0220.7f033.013e.GAE@google.com>
Subject: [moderation/CI] Re: net: Convert to skb_dst_reset and skb_dst_restore
From: syzbot ci <syzbot+ci3cb22cefbd0c9566@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: Convert to skb_dst_reset and skb_dst_restore
https://lore.kernel.org/all/20250812155245.507012-1-sdf@fomichev.me
* [PATCH net-next 1/7] net: Add skb_dst_reset and skb_dst_restore
* [PATCH net-next 2/7] xfrm: Switch to skb_dst_reset to clear dst_entry
* [PATCH net-next 3/7] netfilter: Switch to skb_dst_reset to clear dst_entr=
y
* [PATCH net-next 4/7] net: Switch to skb_dst_reset/skb_dst_restore for ip_=
route_input callers
* [PATCH net-next 5/7] staging: octeon: Convert to skb_dst_drop
* [PATCH net-next 6/7] chtls: Convert to skb_dst_reset
* [PATCH net-next 7/7] net: Add skb_dst_check_unset

and found the following issue:
WARNING in nf_reject_fill_skb_dst

Full report is available here:
https://ci.syzbot.org/series/dcc132bc-db4e-4a0b-a95c-9960b8a48d10

***

WARNING in nf_reject_fill_skb_dst

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      37816488247ddddbc3de113c78c83572274b1e2e
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp=
1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/2aac43d4-6d95-49c6-8e28-28941fdb311=
7/config
C repro:   https://ci.syzbot.org/findings/0af27fa7-d0b6-43d6-8965-58fbc54ca=
186/c_repro
syz repro: https://ci.syzbot.org/findings/0af27fa7-d0b6-43d6-8965-58fbc54ca=
186/syz_repro

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 skb_dst_check_un=
set include/linux/skbuff.h:1164 [inline]
WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 skb_dst_set incl=
ude/linux/skbuff.h:1210 [inline]
WARNING: CPU: 1 PID: 5901 at ./include/linux/skbuff.h:1165 nf_reject_fill_s=
kb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
Modules linked in:
CPU: 1 UID: 0 PID: 5901 Comm: kworker/u8:3 Not tainted 6.16.0-syzkaller-120=
63-g37816488247d-dirty #0 PREEMPT(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
RIP: 0010:skb_dst_set include/linux/skbuff.h:1210 [inline]
RIP: 0010:nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_i=
pv4.c:234
Code: 8b 0d 60 b1 8b 08 48 3b 8c 24 e0 00 00 00 75 5d 48 8d 65 d8 5b 41 5c =
41 5d 41 5e 41 5f 5d e9 03 8d 67 01 cc e8 cd 6c ab f7 90 <0f> 0b 90 e9 38 f=
f ff ff 44 89 f9 80 e1 07 fe c1 38 c1 0f 8c 2b fe
RSP: 0018:ffffc900001e0360 EFLAGS: 00010246
RAX: ffffffff8a143ee3 RBX: ffff888110b91200 RCX: ffff88810a3d8000
RDX: 0000000000000100 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc900001e0490 R08: ffffffff8fa34737 R09: 1ffffffff1f468e6
R10: dffffc0000000000 R11: fffffbfff1f468e7 R12: ffff888011c5c101
R13: dffffc0000000001 R14: 1ffff9200003c070 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881a3c21000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c003cc5000 CR3: 000000010fc16000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
 nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x40c/0x1920 net/netfilter/nf_tables_core.c:285
 nft_do_chain_inet+0x25d/0x340 net/netfilter/nft_chain_filter.c:161
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x206/0x3a0 include/linux/netfilter.h:316
 __netif_receive_skb_one_core net/core/dev.c:5979 [inline]
 __netif_receive_skb+0x143/0x380 net/core/dev.c:6092
 process_backlog+0x60e/0x14f0 net/core/dev.c:6444
 __napi_poll+0xc7/0x360 net/core/dev.c:7489
 napi_poll net/core/dev.c:7552 [inline]
 net_rx_action+0x707/0xe30 net/core/dev.c:7679
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 do_softirq+0xec/0x180 kernel/softirq.c:480
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:910 [inline]
 __dev_queue_xmit+0x1d79/0x3b50 net/core/dev.c:4740
 neigh_output include/net/neighbour.h:547 [inline]
 ip6_finish_output2+0x11fe/0x16a0 net/ipv6/ip6_output.c:141
 NF_HOOK include/linux/netfilter.h:318 [inline]
 ndisc_send_skb+0xb96/0x1470 net/ipv6/ndisc.c:512
 ndisc_send_ns+0xcb/0x150 net/ipv6/ndisc.c:670
 addrconf_dad_work+0xaae/0x14b0 net/ipv6/addrconf.c:4282
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[abhishektamboli9@gmail.com andrew@lunn.ch ayush.sawal@chelsio.com coreteam=
@netfilter.org davem@davemloft.net dsahern@kernel.org edumazet@google.com g=
regkh@linuxfoundation.org herbert@gondor.apana.org.au horms@kernel.org kadl=
ec@netfilter.org kuba@kernel.org linux-kernel@vger.kernel.org linux-staging=
@lists.linux.dev mhal@rbox.co netdev@vger.kernel.org netfilter-devel@vger.k=
ernel.org pabeni@redhat.com pablo@netfilter.org sdf@fomichev.me steffen.kla=
ssert@secunet.com]

If the report looks fine to you, reply with:
#syz upstream

