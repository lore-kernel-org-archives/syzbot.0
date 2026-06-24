Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E61A2F7F14
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 02:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782268323; cv=none; b=t7PzKzWodTkB7XMXsMYPU9HtlfZBohUjGNuHVLRSM3WXViHOEnXrvlqfMfgK+6wRd1WC+VhsZd6vVZfYBPbC0jHQGLK7mUc7v9NxLvJvrQCCSHZGFQjuT6644gsLlTWXmKGx6WS3JR096tJSKaF7kJq2CSnWl5nW7bury1FPzm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782268323; c=relaxed/simple;
	bh=+qQs2K/5tO8S6adG1DlKxrMOPlOww29lLBN4AKH53yw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=AirHJq4PmCIqG/0l5M5GSu3ufjLX4+nIDj/+CdhZPDk6U7bOIyPq7TAfSH0EhOPbqy6TNJ+iiXV6d6StFD1QuKo7B/Lcni2aE3wJl7w8/63p1vSgrmd9fq7H9VFdipIJnzQ7bixNOykVgsb1nlgMT6TUHUriXh/YgGRtgClOeiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-48a4c610ebdso1043031b6e.0
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 19:32:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782268321; x=1782873121;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kTZp6fmtqwQIWNEVGPjUXgg/IIXLUxwWIgmbsSv2auQ=;
        b=FhQDRAtexFC71JRPh9Q5YY83n+V//JubwzySoc1xOjP1pCjqCr/JtSVJYpoFhMjEeP
         LjrYnnfHaaCZ2I2NGfWgSeWSKdoOMj3QfGXSqsO/thrToxaGB4Uj9+3nTg7eCmjE062x
         oyj+thi3xXtIkzN0iKn16MxMNAGMQtEKSgnqt64gsGU9XgcsUaJowFRgwUfmOUBjUKj/
         DhKjqBkHruedwIXXaLSDlGUF/9Ws1mXKWK5FFn4Mz1Gs1OmkLHczbX4D8nLZ8sOCTatO
         1lZNhuTLGh7eG7EoUsd1Ad+2JMKQxjVQ4dNCZF/qINWo5hpimXI705enrcX/63O1Ztwj
         /Pww==
X-Gm-Message-State: AOJu0YwasL2CunDlFXY8seTVD4egxMBL1nukv71dwBfz4w4CHrNdtzXx
	aZ2n3V6Lb66sSTWz+z1cn2PsB1x/P3qgUDaca6KVKrVhToqOqJDaxJT14IeAwlC4G3p4v+EVCM3
	N9talpA68CzBKbLaOiF3BSv748ymlqA3DFu6kwAXU23n5xbwmy95B5qvk5jk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:518f:b0:489:93ff:9e9c with SMTP id
 5614622812f47-4907a674ceamr1081785b6e.43.1782268321248; Tue, 23 Jun 2026
 19:32:01 -0700 (PDT)
Date: Tue, 23 Jun 2026 19:32:01 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3b41a1.c358b6d0.89040.0006.GAE@google.com>
Subject: [moderation/CI] Re: nfc: nci: fix uninit-value in nci_core_init_rsp_packet()
From: syzbot ci <syzbot+ci5398511bc95c05d5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] nfc: nci: fix uninit-value in nci_core_init_rsp_packet()
https://lore.kernel.org/all/20260623222402.175798-1-sam@bynar.io
* [PATCH net] nfc: nci: fix uninit-value in nci_core_init_rsp_packet()

and found the following issue:
UBSAN: array-index-out-of-bounds in nci_init_complete_req

Full report is available here:
https://ci.syzbot.org/series/2a9a8657-37a3-4dce-8cb5-2035027791dd

***

UBSAN: array-index-out-of-bounds in nci_init_complete_req

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      a986fde914d88af47eb78fd29c5d1af7952c3500
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/80f835c3-e998-47ff-aaa5-24c578af3b4e/config
syz repro: https://ci.syzbot.org/findings/65008893-2498-4786-b913-f2c474a7b34a/syz_repro

------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in net/nfc/nci/core.c:192:7
index 4 is out of range for type '__u8[4]' (aka 'unsigned char[4]')
CPU: 0 UID: 0 PID: 5905 Comm: syz.1.33 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 nci_init_complete_req+0x255/0x460 net/nfc/nci/core.c:192
 __nci_request+0x7d/0x300 net/nfc/nci/core.c:108
 nci_open_device net/nfc/nci/core.c:529 [inline]
 nci_dev_up+0x8c3/0xdc0 net/nfc/nci/core.c:643
 nfc_dev_up+0x165/0x350 net/nfc/core.c:118
 nfc_genl_dev_up+0x89/0xe0 net/nfc/netlink.c:775
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:775 [inline]
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0x9b9/0xa20 net/socket.c:2684
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
 __sys_sendmsg net/socket.c:2770 [inline]
 __do_sys_sendmsg net/socket.c:2775 [inline]
 __se_sys_sendmsg net/socket.c:2773 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f55ead9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f55ebcb9028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f55eb015fa0 RCX: 00007f55ead9ce59
RDX: 0000000004008054 RSI: 0000200000000200 RDI: 0000000000000005
RBP: 00007f55eae32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f55eb016038 R14: 00007f55eb015fa0 R15: 00007ffcba11c798
 </TASK>
---[ end trace ]---


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
[davem@davemloft.net david@ixit.cz edumazet@google.com horms@kernel.org kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org oe-linux-nfc@lists.linux.dev pabeni@redhat.com sam@bynar.io stable@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

