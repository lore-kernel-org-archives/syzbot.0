Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CFA8F40
	for <syzbot@lists.linux.dev>; Tue, 22 Jul 2025 11:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753183208; cv=none; b=cjzeQ+P5xfQjMTXE+sI8XGLq3EFQN2dg35UA827Oj/vyHpx42iJQhdRdWwDZDgGZnOyb4irB377tblMtj0qhcsEUt7zmdMxE9Do8ZjChW9R+AMPVdlGyXsuel0tQlIOCZ9ladgZd8yaz8mHQJi1mqT9OcHoH+Wg7oyzFTOVa45A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753183208; c=relaxed/simple;
	bh=MMjFICKy2wJOVPlwn7JahhiBgISyKlD0b2pBJAMXblk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=a0z/oI88JwZPpv3JFhBovyUT7vP2vQExlasDwm2Dvte19RGvdyfPhqYgtezxl0iPl4OMF4tHlvS8DjvlMKBEa9ZxF81LNcOYr6fHxcNYSpAOjBThSKyw5Gzv5wgShnQmKwb2/0yplgVLhaxwcR8f+whpokKFyISSYMHz9108+Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-87c467931c1so292432139f.3
        for <syzbot@lists.linux.dev>; Tue, 22 Jul 2025 04:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753183206; x=1753788006;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAXo+VBI1zPcmXRs7Gwo9UPCqDnbAGJ6yA3aDorSq18=;
        b=fWwL15ETx9ev8jJYbFS6D2WUNzMDodNGzI9Psav3in2/JBInPF6s5Fe7SZYM3b5Dsz
         jMFGPJmGSzn5o6xgunyhBnng0IYTYW2eKpglY7+zTHCU9dZFhw7jb+rtvbDHCCjQF0OT
         0p70rhEHqgRVkjYgZPBcx42BK2XHOhqzQpnzl8fBoyt9i5R/P/OrfnxKq1ubmVrIqBiA
         B09flwunZnag+agdeYgZwRqTiGQxNt0q2WaDVhA96iq+ejM3H3PMJF7NqQYrtRkdArGs
         9ckfijKz0DbA80WIPRxFs8qSDKhDGz+1ZMhEn8ShqibctCxPldm1qvEvR0XBs8C3cbG8
         +XHg==
X-Gm-Message-State: AOJu0YwYB4BmkGV/qUwRE8cXb7a9elO+geVknWCicoVDXtlFEuXwlAwa
	1fWavPpU6c2KwAqLcCvkdWX27dfK6rHEjjodeAdljHDafOzHz/q/S+jeQg//HXY6H8osFcC1Fj1
	X1MMxNRMovLrNVc7pBi+aVbiacQMMR41U5P0OCkfWLv2gU37OJ/3jXfEfbEI=
X-Google-Smtp-Source: AGHT+IG0xbL3yTmrqoR9dJDueV186e6jCNTcAwwIOTwnfjnDzltdigVNR4z07M17a1CHBmJMUneSgIJ5123TQIG0hazA7mfnjA8Q
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4804:b0:875:bc13:3c26 with SMTP id
 ca18e2360f4ac-879c08a5f86mr3531212139f.4.1753183206059; Tue, 22 Jul 2025
 04:20:06 -0700 (PDT)
Date: Tue, 22 Jul 2025 04:20:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687f73e6.a70a0220.21b99c.000b.GAE@google.com>
Subject: [moderation/CI] Re: net: Revert tx queue length on partial failure in dev_qdisc_change_tx_queue_len()
From: syzbot ci <syzbot+ci486d0f7ad816d3a7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: Revert tx queue length on partial failure in dev_qdisc_change_tx_=
queue_len()
https://lore.kernel.org/all/<20250722071508.12497-1-suchitkarunakaran@gmail=
.com>
* [PATCH] net: Revert tx queue length on partial failure in dev_qdisc_chang=
e_tx_queue_len()

and found the following issue:
BUG: unable to handle kernel paging request in dev_qdisc_change_tx_queue_le=
n

Full report is available here:
https://ci.syzbot.org/series/75b0a15e-cca4-4e46-8bf9-595c0dd34915

***

BUG: unable to handle kernel paging request in dev_qdisc_change_tx_queue_le=
n

tree:      netdev
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      81e0db8e839822b8380ce4716cd564a593ccbfc5
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp=
1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/2ee305f2-ddb8-45c6-8f47-2a150dc6dd2=
2/config
syz repro: https://ci.syzbot.org/findings/1e75a6d3-11ac-48da-af27-60753abb6=
1c7/syz_repro

netlink: 'syz.2.18': attribute type 13 has an invalid length.
netlink: 'syz.2.18': attribute type 17 has an invalid length.
BUG: unable to handle page fault for address: ffffed4821fa6a4b
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 13ffee067 P4D 13ffee067 PUD 0=20
Oops: Oops: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5980 Comm: syz.2.18 Not tainted 6.16.0-rc6-syzkaller-001=
28-g81e0db8e8398-dirty #0 PREEMPT(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:dev_qdisc_change_tx_queue_len+0x542/0x640
Code: be 7f 05 00 00 48 c7 c2 20 d2 95 8c e8 27 db 27 f8 44 89 e0 48 69 c0 =
c0 01 00 00 49 8d 1c 06 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 7=
4 08 48 89 df e8 1f af ab f8 48 8b 1b 4c 8d 73 18
RSP: 0018:ffffc900024beaa0 EFLAGS: 00010a06
RAX: 1ffff14821fa6a4b RBX: ffff8a410fd35258 RCX: ffff888020f2d640
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc900024beb90 R08: ffffffff8fa1d6f7 R09: 1ffffffff1f43ade
R10: dffffc0000000000 R11: fffffbfff1f43adf R12: 00000000ffffffff
R13: dffffc0000000000 R14: ffff88810fd35400 R15: ffff88810ffe2018
FS:  00007fa854ede6c0(0000) GS:ffff8881a3c23000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed4821fa6a4b CR3: 00000000295fa000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 netif_change_tx_queue_len+0x167/0x270
 do_setlink+0xdfb/0x41c0
 rtnl_newlink+0x149f/0x1c70
 rtnetlink_rcv_msg+0x7cf/0xb70
 netlink_rcv_skb+0x208/0x470
 netlink_unicast+0x75c/0x8e0
 netlink_sendmsg+0x805/0xb30
 __sock_sendmsg+0x21c/0x270
 ____sys_sendmsg+0x505/0x830
 ___sys_sendmsg+0x21f/0x2a0
 __x64_sys_sendmsg+0x19b/0x260
 do_syscall_64+0xfa/0x3b0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa853f8e9a9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa854ede038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fa8541b5fa0 RCX: 00007fa853f8e9a9
RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000000000000003
RBP: 00007fa854010d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fa8541b5fa0 R15: 00007ffe5a5f8288
 </TASK>
Modules linked in:
CR2: ffffed4821fa6a4b
---[ end trace 0000000000000000 ]---
RIP: 0010:dev_qdisc_change_tx_queue_len+0x542/0x640
Code: be 7f 05 00 00 48 c7 c2 20 d2 95 8c e8 27 db 27 f8 44 89 e0 48 69 c0 =
c0 01 00 00 49 8d 1c 06 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 7=
4 08 48 89 df e8 1f af ab f8 48 8b 1b 4c 8d 73 18
RSP: 0018:ffffc900024beaa0 EFLAGS: 00010a06
RAX: 1ffff14821fa6a4b RBX: ffff8a410fd35258 RCX: ffff888020f2d640
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc900024beb90 R08: ffffffff8fa1d6f7 R09: 1ffffffff1f43ade
R10: dffffc0000000000 R11: fffffbfff1f43adf R12: 00000000ffffffff
R13: dffffc0000000000 R14: ffff88810fd35400 R15: ffff88810ffe2018
FS:  00007fa854ede6c0(0000) GS:ffff8881a3c23000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed4821fa6a4b CR3: 00000000295fa000 CR4: 00000000000006f0


---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aleksander.lobakin@intel.com davem@davemloft.net edumazet@google.com horms=
@kernel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org kuniyu@google=
.com linux-kernel-mentees@lists.linux.dev linux-kernel@vger.kernel.org netd=
ev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me skhan@linuxfoundation.=
org suchitkarunakaran@gmail.com xiyou.wangcong@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

