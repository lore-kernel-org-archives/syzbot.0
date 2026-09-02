Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F1B3909AE
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 21:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788384805; cv=none; b=MwVGOY/obuWaYWezhK7gEGYucU/H+S6FHAIhZj+RiVocxWqnrANJwC9rLMEGrNqb+U4sFXgEuF4hb2GOB/CAnTRLuOlr3nqd6W/f3rbNvKiLoCdb3CCCmWdZFTEflXsWCr+4IEpzg/fyv9mhnxLqROazAT0D8BdVncaIYWdoIU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788384805; c=relaxed/simple;
	bh=/cmTPVvbKLXly9Udjg1lY024CGrvxfXYO7MB6rEClE8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=JtxNS+emisndYRcIEw1JejzNT2d/jIODtdeUEQa61XQ3dVmESKikz8wfJgJl8FbtA/jTngMuyYxBqlM1s3aAgxuDVSUEUdVnt1oPkYhySGAVAU7U2zyGiZ7HHMRZoCCSblMEj8ZsJtjKWreJM7wmHZ09R9gsM4lfoYlaP9LOyf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6b1c1538784so1586342eaf.3
        for <syzbot@lists.linux.dev>; Wed, 02 Sep 2026 14:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788384799; x=1788989599;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c8bd5hafQnp4SY6aHaO/pDHLLaXmV8mXE7EzQViShs8=;
        b=pHzDraXOcE0+KT3FxVGZbRivSMzIuRx/Uh1y9QkV3duIazlikBTQvNAQwAOV+TvfBM
         SVC7b8HHfel8iLtDz4GjI/HPzD5gjBhTae6iqjQ4yCQdh6twUte3kUC4H8aLT7GCK3Vw
         BWqfiSx4QcgtScM1EpIrSmbA9S00FdkzR8kh4PKlcOkyR6/eoDjEwsiiHmS+b0Tym+lf
         TvgdmcxRYEeeVCeCnEcVjxFMySruX4CXNrkH9scFQ/5YduorDaB0qB9k/hiTveKjV2OC
         EV+qqHA0aUI/SyENuq1xMP4vU8vPCMwycZHQ84SROL7+mXpgYtbWdBNF50n2oVLJaTlN
         KkwA==
X-Gm-Message-State: AFuF++mUOjl4VpNLXd6sCubUezrvH0iDr+7oQ4CDV9ToRnvw/jdWLsGI
	7q3KaitCH57pACyf9/CB8OQZZLi+1+QWOTYIXIt/XuZj5x8JdERSfiYVZV7ITEDWvJONfPJ8rNk
	gsUauAQ5/f723X6bpCtZrv9tn9yig/wYh6Xc5JK0DbK4BvSsj4wwHyWqCqZI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1787:b0:6b1:c376:d35f with SMTP id
 006d021491bc7-6b4788d00cbmr6678561eaf.0.1788384799762; Wed, 02 Sep 2026
 14:33:19 -0700 (PDT)
Date: Wed, 02 Sep 2026 14:33:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a98961f.9266084e.bf0d7.0010.GAE@google.com>
Subject: [moderation/CI] Re: ip: validate options before echoing them
From: syzbot ci <syzbot+ci580e1d9fe98861cc@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] ip: validate options before echoing them
https://lore.kernel.org/all/20260902055802.3724915-1-4ncienth@gmail.com
* [PATCH net v3] ip: validate options before echoing them

and found the following issue:
WARNING in __ip_options_echo

Full report is available here:
https://ci.syzbot.org/series/58d17295-c695-49b2-826d-b0fe305808e9

***

WARNING in __ip_options_echo

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      70f3995830d3f1e79faa14eb0605914f778feca9
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9a250d6c-0a45-4565-bbc0-cac6bc3e42ee/config
syz repro: https://ci.syzbot.org/findings/5fa937c9-0c72-4a82-8221-cd01d8dc83d5/syz_repro

------------[ cut here ]------------
len > ((int)(~0U >> 1))
WARNING: ./include/linux/skbuff.h:2864 at pskb_may_pull_reason include/linux/skbuff.h:2864 [inline], CPU#1: syz.0.17/5791
WARNING: ./include/linux/skbuff.h:2864 at pskb_network_may_pull_reason include/linux/skbuff.h:3294 [inline], CPU#1: syz.0.17/5791
WARNING: ./include/linux/skbuff.h:2864 at pskb_network_may_pull include/linux/skbuff.h:3299 [inline], CPU#1: syz.0.17/5791
WARNING: ./include/linux/skbuff.h:2864 at __ip_options_echo+0x10e4/0x1870 net/ipv4/ip_options.c:115, CPU#1: syz.0.17/5791
Modules linked in:
CPU: 1 UID: 0 PID: 5791 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:pskb_may_pull_reason include/linux/skbuff.h:2864 [inline]
RIP: 0010:pskb_network_may_pull_reason include/linux/skbuff.h:3294 [inline]
RIP: 0010:pskb_network_may_pull include/linux/skbuff.h:3299 [inline]
RIP: 0010:__ip_options_echo+0x10e4/0x1870 net/ipv4/ip_options.c:115
Code: 00 00 00 fc ff df 43 0f b6 04 3c 84 c0 0f 85 64 07 00 00 41 88 1e 4c 8b 64 24 10 41 83 c4 04 e9 a7 fe ff ff e8 7d 13 84 f7 90 <0f> 0b 90 e9 35 f1 ff ff 44 89 e7 44 89 f6 e8 79 15 84 f7 45 39 f4
RSP: 0018:ffffc90004efef40 EFLAGS: 00010293
RAX: ffffffff8a43a023 RBX: ffff8881b89a6b58 RCX: ffff888111125a00
RDX: 0000000000000000 RSI: 00000000fffffff8 RDI: 0000000000000000
RBP: ffffc90004eff070 R08: ffffc90004eff2c7 R09: 0000000000000000
R10: ffffc90004eff2b8 R11: fffff520009dfe59 R12: 00000000fffffff8
R13: ffff8881b89a6a80 R14: ffff8881b89a6b00 R15: 000000000000001c
FS:  00007f39f8af86c0(0000) GS:ffff8882a8cdf000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f39f8af7ff8 CR3: 0000000112830000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ip_options_echo include/net/ip.h:798 [inline]
 icmp_reply+0x2da/0xc90 net/ipv4/icmp.c:429
 icmp_timestamp+0x246/0x370 net/ipv4/icmp.c:1430
 icmp_rcv+0xd33/0x1290 net/ipv4/icmp.c:1543
 ip_protocol_deliver_rcu+0x2dc/0x440 net/ipv4/ip_input.c:207
 ip_local_deliver_finish+0x3bb/0x6f0 net/ipv4/ip_input.c:241
 NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
 NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
 __netif_receive_skb_one_core net/core/dev.c:6264 [inline]
 __netif_receive_skb net/core/dev.c:6377 [inline]
 netif_receive_skb_internal net/core/dev.c:6463 [inline]
 netif_receive_skb+0x45b/0xbf0 net/core/dev.c:6522
 tun_rx_batched+0x1de/0x790 drivers/net/tun.c:1571
 tun_get_user+0x2be0/0x44d0 drivers/net/tun.c:2045
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:2091
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f39f7b5e98e
Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
RSP: 002b:00007f39f8af7fb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f39f8af86c0 RCX: 00007f39f7b5e98e
RDX: 000000000000003e RSI: 0000200000000780 RDI: 00000000000000c8
RBP: 00007f39f7c35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f39f7e26038 R14: 00007f39f7e25fa0 R15: 00007fff66b2b028
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[4ncienth@gmail.com davem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.org idosch@nvidia.com kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

