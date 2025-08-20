Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2042D94BF
	for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755697158; cv=none; b=YOnMxmYWqVEvo8izRIVYF1y4jnfPoB2Y5aqwF6J1vPH8pRBPO+a50/epfVOJXMUZs7Da/Qi3fO2ouW3AIN7ifuz6TbotrNtn89sYPNfFjHDBW97WI4as5MF2BXuAES0ZWQGNofMI2+rml8JQKT190z/yEe+qbmOHl0cL5KlenEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755697158; c=relaxed/simple;
	bh=A7szlMuxj9+l/LShgbe909kui/Wz9p61VR9MyU9ZLQA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Dztr6iTCB3TulL9CoUXQJy5GAd2MEZyBYd5nR4+OLd38aR/u85fQXSt3KaNQ+0lku9jc7GkyvMXeFwInfOjTSNiDLS5p5kZ1dydIpifn2HF3+rqHt0m2vc8AVSEVAA1HOiJN71LHmjEcGDcAbCDUwXBFXi+h8j6vKlOZAKNwugc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88432da036bso726061339f.1
        for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 06:39:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755697156; x=1756301956;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bjhxpn1DiG+O92jFf7g7vwSa4Vs7zOfCE2Tsti/rrxE=;
        b=dLB3fw3Erawb9YWBIMzmO8azhkP2ZfDWmpPxofdoUJbqB/WQvbiI2VUKrg1olkY0xJ
         +GcldpHUKwW/oDPyz58s1krcAW7XJN10/+seTfxI8KXa8gpTKXYVaXKTgvTPiztgCS8R
         wHT/QeoHBtC12KWugXhiT9jnQtgx9/Z9eHTJWuEyOA6OLTrQoTeW9fIBx6q6gyZWbWtj
         WDiITpccg/dE1CyJNVPs+WDkR0Ff63D2UX/qaXozAYDyHZDLDggKcJyxHplSMLROfzBh
         cimL5/MPtWi13NzbYUM9WJL0hHcFBaC8167QA2kwlM8WGraI+p/XusWeKUgQGhoGyY2K
         8i+w==
X-Gm-Message-State: AOJu0Ywm03nRkF06HkkWbae0NmRzvE3fh1Xq/Fr+aDcFH3eHOz4BRK5w
	zooVnBtFym3qD9xG5RSCrcjm9k4572fm/9dRjJajFRQFzs0XgEtnEK055R9RBcX8leWsbYYWzJp
	BYKvPbQvsx8S9lyViJQJxJbkHBzKC08o9emenpjWRojNmCfMhDSBLvi6xkGQ=
X-Google-Smtp-Source: AGHT+IEnq8/lc7a0hCHIMReYZayQL1Gao/BlzwlKHzg/yPNj8Dl8C+EIxUXgU6fH1meZHWDvGpDg5WMgK5ZL0agFoPy9lcXPEE9g
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d16:b0:881:99eb:e212 with SMTP id
 ca18e2360f4ac-88471b3468emr645380639f.9.1755697156044; Wed, 20 Aug 2025
 06:39:16 -0700 (PDT)
Date: Wed, 20 Aug 2025 06:39:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a5d004.050a0220.3d78fd.0002.GAE@google.com>
Subject: [moderation/CI] Re: net: af_packet: Use hrtimer to do the retire operation
From: syzbot ci <syzbot+ci1b055c1c5811b39f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[davem@davemloft.net edumazet@google.com ferenc@fejes.dev horms@kernel.org jackzxcui1989@163.com kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com willemdebruijn.kernel@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

