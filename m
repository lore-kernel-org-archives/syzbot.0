Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE9423815B
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 11:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782301713; cv=none; b=GxSd6HQQZVKrbBmqxqIaAwxb4s5CJBbRvV63e4ay7Q4cl1sA6DZi6RX5VlRD1AN+lyOmd6+bsIK8bal6FPrB3jKh8CKkLvaMeEubMwNPjwuXI562/ZNOIjGjThiXfveHMO3v9yrCpzXRS17iqAwm3wMye7/e2khrxWr0B4Ig/WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782301713; c=relaxed/simple;
	bh=K+bmw8YO6o6D6OJSvav8SyHnrz4knSXDRENkJlubQmk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=fEg8Pp4db0z69bs1QG1qJiPT5UwD28FSZMO1iZ8NIBDVec4Otyes++iv04oD6o/vTiXJo56gBqbOrKoGx0OGp3/AwOBK518YUH/nL/tGh1xjhz38Z+VsPWDmypfoxC9U+fE4kUYtlmgqsr+Q4A5e0QuCLvsxyDax2AnW2MdNz1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e6db540d17so1469531a34.0
        for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 04:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782301711; x=1782906511;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oSjOaMFDxBhMVjGJkVDcrGCD6XYHtT95t+UgwY2KWks=;
        b=pSNmkzNfweo3vbQ8SounGWJrV/EqEHE26cB77Rucd8fCgM8lXhy2RmEPT5ZCUOdnax
         OLL7tm1s8OcEsKyJI1WnKmOI/zLbz/fCM7xXWItaXBBDu/6z6dCW4Spn68RgSlj0I5k3
         mSrOy/vE7zIQ7FkfP+GLbsA4WlChRT9t07lGhIsTmZY9CrZLLa2TxM2ccrJCUphNF1XD
         XokeK41/ot3xnXe79pU9TzpNT1jqxgI451Bop7R6oFzcKOpi9SMPGenuM9dAPgKeoUC1
         VnJE2lL7wcXzo+BJvCQivvFq1wZbION8U8ICYj/AIqiL1mWt4I7J54iCWDH65C2ljvNm
         dn7Q==
X-Gm-Message-State: AOJu0Yw0WbZzPqRnnRvmYBEyz7MzJ0w7y+5xgDNdCwyfu3jKSoW4f196
	GhU/PIBfxMXeMyW/juVNcmuAz+qH1TMEKqFWfhb9VKSrO47lsV3F0Wkv9Uxpv3YQD9RI1zgQTK0
	dvzfGg/d6czNabKczSeyhl83UWKW9qPWUrtwmLkr7uQoe5nPBv4G5pM/Tvy0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b11:b0:489:6cbf:cec5 with SMTP id
 5614622812f47-49078e9129bmr2074035b6e.25.1782301710781; Wed, 24 Jun 2026
 04:48:30 -0700 (PDT)
Date: Wed, 24 Jun 2026 04:48:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3bc40e.ac6cd362.bc7d6.0003.GAE@google.com>
Subject: [moderation/CI] Re: net: clear transport header during tunnel decapsulation
From: syzbot ci <syzbot+cic115a49afd959330@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: clear transport header during tunnel decapsulation
https://lore.kernel.org/all/20260624073209.3703492-1-edumazet@google.com
* [PATCH net] net: clear transport header during tunnel decapsulation

and found the following issue:
WARNING in geneve_udp_encap_recv

Full report is available here:
https://ci.syzbot.org/series/1f6dc47e-354f-4904-bc18-c2b7ea4d79b2

***

WARNING in geneve_udp_encap_recv

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      d87363b0edfc7504ff2b144fe4cdd8154f90f42e
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/7bb83c16-d55d-4d99-8c2b-6050e0022ef6/config

------------[ cut here ]------------
!skb_transport_header_was_set(skb)
WARNING: ./include/linux/skbuff.h:3094 at geneve_udp_encap_recv+0x26ed/0x4130, CPU#1: kworker/1:3/5072
Modules linked in:
CPU: 1 UID: 0 PID: 5072 Comm: kworker/1:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: mld mld_ifc_work
RIP: 0010:geneve_udp_encap_recv+0x26ed/0x4130
Code: c8 00 00 00 0f b6 04 01 84 c0 0f 85 f2 18 00 00 48 8b 7c 24 78 66 44 89 6f 0a e8 7e 9b 7a 03 e9 8c 00 00 00 e8 f4 fc 33 fb 90 <0f> 0b 90 e9 2e e3 ff ff 49 83 c6 06 4c 89 f0 48 c1 e8 03 48 b9 00
RSP: 0018:ffffc90000a08620 EFLAGS: 00010246
RAX: ffffffff8691f92c RBX: ffff8881bcc8b5d0 RCX: ffff88816a7abb80
RDX: 0000000000000100 RSI: 000000000000ffff RDI: 000000000000ffff
RBP: ffffc90000a08790 R08: ffffffff903114f7 R09: 1ffffffff206229e
R10: dffffc0000000000 R11: fffffbfff206229f R12: ffff888109f6a108
R13: 1ffff110213ed5df R14: 0000000000000010 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8882a927b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6956ea5440 CR3: 000000016f55c000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 udp_queue_rcv_one_skb+0xfc5/0x10e0
 udp_unicast_rcv_skb+0x21a/0x3a0
 udp_rcv+0xecb/0x1db0
 ip_protocol_deliver_rcu+0x27e/0x440
 ip_local_deliver_finish+0x3bb/0x6f0
 NF_HOOK+0x336/0x3c0
 NF_HOOK+0x336/0x3c0
 process_backlog+0xa34/0x1860
 __napi_poll+0xaa/0x330
 net_rx_action+0x61d/0xf50
 handle_softirqs+0x225/0x840
 do_softirq+0x76/0xd0
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0xf8/0x130
 __dev_queue_xmit+0x1ed7/0x37f0
 ip6_output+0x337/0x540
 NF_HOOK+0x177/0x4f0
 mld_sendpack+0x890/0xe10
 mld_ifc_work+0x839/0xe70
 process_scheduled_works+0xa8e/0x14e0
 worker_thread+0xa47/0xfb0
 kthread+0x388/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[davem@davemloft.net dsahern@kernel.org edumazet@google.com eric.dumazet@gmail.com horms@kernel.org idosch@nvidia.com kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com syzbot@syzkaller.appspotmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

