Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719F31DE8BE
	for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 13:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755697819; cv=none; b=Oi/2VhVfRDjhu7UYg0mQmm75O1/QUClGuyYKDDEmxfUb9l38MFDUPisLyb/42IhFuoTihHShWoYSnDhfZeWGujJy8IzLHIXa57lnILm3Hm6Y9llT4htbkBG3dVgBs8B9IitkuzFdibEpklgTBvBDfxwuBj4BY96n8aNYsYFCSH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755697819; c=relaxed/simple;
	bh=IY1hCmh/ms+pl4eZUlo7JOL5fRJk9SupjR3P8rg4KAA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=fospKJmFnjb+fa/NM+2FBDk7FWD8rjwYhqOuc91AYr6Tb7rsyk5l8vN9KTOY5fCTy21lYXNCItZAlfrqTLJxQtgH0zyJ4U8NxNW1kBNeWSpPwa6IV3PoraFpwtm2XKv1ORei7eVuygF0dSdwQiLt8mJ/KqPKpIAkqRTFN1C1dto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e6670d5bafso95168085ab.2
        for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 06:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755697816; x=1756302616;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FCft0OtSYmLcVWsWIK6iy7gIzs3jV3RaunmmsDo3CIY=;
        b=Cs3WgqVQFEX2C9Ens3ZhdjVlr8RGxMAg/PByn9wudivOHYq/e4P3v3nhAO1o9QXfG3
         4F3PlsEBrT9tLf2cMugmZBAZ1xpXzHndTwx/LHDlud4caEhVrtb/NDlids7A58lnGU0Z
         /tBtD5Q2gtWIslDfCMZvuoCeGQGe77zL/i2e09EjJxMABxe+C8OVDlAwO1NCNqNNwIYm
         kpg20isnR0US23SnMTd8ifeoxOaOsPdJuLAPBSOMkbnGNFE9kHi5HRnPJBhIUJ73V5wk
         pk2sX3TFR+6+ZPuizRe923zX/06w2OLxCNHUQrOIekFaRaoQUJ+t2H3RO3mlcaNF8U/R
         hxdQ==
X-Gm-Message-State: AOJu0YxNjoGsEgAH1hXhC7fq3a0j/6x0q56Dia6oPvtinUTfApsGy/fA
	l2+o3jDyspXKXE2C+Zt3BsuIiqpnrcnEFCvo9oHcCxkomp7107HV3vgPrCn8g3xn4A/Xap8duV6
	ANazS9SkIwAQPsGba/lBt0+vWZlAQYcKr4tUZt0IXwP87Wopp4DejMPoTU60=
X-Google-Smtp-Source: AGHT+IGhn4ZYmJP7sBYy4J89eY3N54uRGsYJzXgBSJdGM3I2L/PUzn7oQGaPAbDMu9Q/TuHoUNnRPiV0D3jaz8zlEydn+YcEPKCy
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156e:b0:3e5:3ef0:b0e5 with SMTP id
 e9e14a558f8ab-3e67c9b66b1mr46030995ab.7.1755697816711; Wed, 20 Aug 2025
 06:50:16 -0700 (PDT)
Date: Wed, 20 Aug 2025 06:50:16 -0700
In-Reply-To: <20250820092925.2115372-1-jackzxcui1989@163.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a5d298.050a0220.3d78fd.0003.GAE@google.com>
Subject: [syzbot ci] Re: net: af_packet: Use hrtimer to do the retire operation
From: syzbot ci <syzbot+ci8b7a13618981d53b@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, ferenc@fejes.dev, 
	horms@kernel.org, jackzxcui1989@163.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	willemdebruijn.kernel@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v6] net: af_packet: Use hrtimer to do the retire operation
https://lore.kernel.org/all/20250820092925.2115372-1-jackzxcui1989@163.com
* [PATCH net-next v6] net: af_packet: Use hrtimer to do the retire operation

and found the following issue:
WARNING in hrtimer_forward

Full report is available here:
https://ci.syzbot.org/series/81b08fd6-a740-4520-9c88-b7dcdc7953a1

***

WARNING in hrtimer_forward

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      da114122b83149d1f1db0586b1d67947b651aa20
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/0ebac6ed-b7ae-4c3d-9edc-db3a521ad7a0/config
C repro:   https://ci.syzbot.org/findings/c3421800-7bbc-4097-a1cf-36e97a4dea98/c_repro
syz repro: https://ci.syzbot.org/findings/c3421800-7bbc-4097-a1cf-36e97a4dea98/syz_repro

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6012 at kernel/time/hrtimer.c:1052 hrtimer_forward+0x1d6/0x2b0 kernel/time/hrtimer.c:1052
Modules linked in:
CPU: 1 UID: 0 PID: 6012 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:hrtimer_forward+0x1d6/0x2b0 kernel/time/hrtimer.c:1052
Code: 4c 89 33 48 8b 04 24 eb 07 e8 66 30 12 00 31 c0 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 01 b0 ce 09 cc e8 4b 30 12 00 90 <0f> 0b 90 eb df 48 89 e8 4c 09 f8 48 c1 e8 20 74 0a 48 89 e8 31 d2
RSP: 0018:ffffc900029def90 EFLAGS: 00010293
RAX: ffffffff81ad7be5 RBX: ffff888028782648 RCX: ffff88810e88d640
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 000000000000116b R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
R10: dffffc0000000000 R11: ffffffff81724e10 R12: ffff888028782660
R13: 00000000007a1200 R14: 1ffff110050f04cc R15: 0000000000000001
FS:  000055555f6cd500(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcf1be3d88 CR3: 0000000023c86000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 hrtimer_forward_now include/linux/hrtimer.h:366 [inline]
 _prb_refresh_rx_retire_blk_timer net/packet/af_packet.c:697 [inline]
 prb_open_block+0x3a7/0x5e0 net/packet/af_packet.c:930
 prb_dispatch_next_block net/packet/af_packet.c:994 [inline]
 __packet_lookup_frame_in_block net/packet/af_packet.c:1152 [inline]
 packet_current_rx_frame net/packet/af_packet.c:1178 [inline]
 tpacket_rcv+0x1229/0x2f40 net/packet/af_packet.c:2409
 deliver_skb net/core/dev.c:2472 [inline]
 deliver_ptype_list_skb net/core/dev.c:2487 [inline]
 __netif_receive_skb_core+0x3107/0x4020 net/core/dev.c:5923
 __netif_receive_skb_list_core+0x23f/0x800 net/core/dev.c:6054
 __netif_receive_skb_list net/core/dev.c:6121 [inline]
 netif_receive_skb_list_internal+0x975/0xcc0 net/core/dev.c:6212
 netif_receive_skb_list+0x54/0x450 net/core/dev.c:6264
 xdp_recv_frames net/bpf/test_run.c:280 [inline]
 xdp_test_run_batch net/bpf/test_run.c:361 [inline]
 bpf_test_run_xdp_live+0x1786/0x1b10 net/bpf/test_run.c:390
 bpf_prog_test_run_xdp+0x713/0x1000 net/bpf/test_run.c:1322
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4590
 __sys_bpf+0x581/0x870 kernel/bpf/syscall.c:6047
 __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f31da38ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcf1be5358 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f31da5b5fa0 RCX: 00007f31da38ebe9
RDX: 0000000000000050 RSI: 0000200000000600 RDI: 000000000000000a
RBP: 00007f31da411e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f31da5b5fa0 R14: 00007f31da5b5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
