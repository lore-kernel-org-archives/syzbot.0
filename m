Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A3B1D47AC
	for <syzbot@lists.linux.dev>; Sun,  6 Sep 2026 06:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788675825; cv=none; b=Zk3OTUVsWJQ9AYWQmzzfvtUr73Dj6/6KTS1zroH6KzBox9a1YK4r3mGELWf/H5wuEGKptvUmdEf2w+1AeUD9lY92xmwxJ16FGpMcbNoeP0vrm4eEykkw4qxXIbQoJo0c5fRFcmzRLwqIMPh12rPEIVX51lP9CqRV19TMwWOZImw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788675825; c=relaxed/simple;
	bh=48BftR2fV0rA8IpaJEaptkIppidijhLu+FVBM6mRE6s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=SimppPko4+rwrzpWGnTZpytGZWI6NUuKgI1Gmf2wkN6Z730fw2XuoVWkbPyi4Ez1ql9LH7tFDqHrs+OeHgwR0368vJOvyxeIWhDcrUzNxNdcA8ayJNzTBQ8BiwbhuQuRKLOuOT/g6ve9B864Ls5arK3Wg39QRwR1iuyzhwgcNYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-49aa4525b82so3159357b6e.1
        for <syzbot@lists.linux.dev>; Sat, 05 Sep 2026 23:23:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788675822; x=1789280622;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LHpDhyEdk8/cZQUpYA+1TwV7nzFO0R408edrFsF6GwA=;
        b=VgTAynnaUFPu+LIk6ydzjVrCoHg3jTcGxttPxKU4scORz+/y3MpC1qJbSyBJZfIonY
         wFrugQLByAiPeqttPMCcytacDWN05HuW2CaXqNP4BSBJRuyBmIlkw14nov7+u/eeIEWU
         RtN4wS1yE/xtjoHMRchhSRBpPPG2egHJsCrccmQ8WP0mQGPViekwPaXoL0aD+swZnXeZ
         LkmbDodct5leOh3QNsgYC4N9mteHJrIq95o320R8IGSv/Gp4+bBWLHtSQYhXlCqzOnYI
         qyy/TR4yMkBni2mc2zC8ObXqskvDDhcGyXwsFe8Va6qQ0xSz/IKQYKC9OgNJ+mGWr96s
         O08w==
X-Gm-Message-State: AFuF++nTff4KoNAgxjRrjKjfWulUHmSMGRmVCDrPBnENQ1fFumULLqi5
	XFHXlSE6sigHlS9PSoITFmF+4pYwxpESMzrLKpSu+uN8hH9eHvoLgEA7/UNxTGLMHJW+zNdxXhf
	aHU8VmatI/MjWspBTvupv4q/P2lBj2+OM/EakOz07SZ7TP26NJQs0HkQ0vwk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2211:b0:6b7:46fa:169c with SMTP id
 006d021491bc7-6b746fa1a60mr9020722eaf.49.1788675822309; Sat, 05 Sep 2026
 23:23:42 -0700 (PDT)
Date: Sat, 05 Sep 2026 23:23:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9d06ee.a5e650b3.26d8a.0015.GAE@google.com>
Subject: [moderation/CI] Re: wifi: mac80211_hwsim: don't hand frames to
 mac80211 while stopping
From: syzbot ci <syzbot+cid7efdd8361b129d0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: mac80211_hwsim: don't hand frames to mac80211 while stopping
https://lore.kernel.org/all/20260904170140.5f69a10d606b.I4a7921d00643f69e439c7a3b221d104f66a3dcdc@changeid
* [PATCH wireless] wifi: mac80211_hwsim: don't hand frames to mac80211 while stopping

and found the following issue:
BUG: unable to handle kernel paging request in hwsim_cloned_frame_received_nl

Full report is available here:
https://ci.syzbot.org/series/219738fc-ed0e-47c8-8100-a5940fbc20b7

***

BUG: unable to handle kernel paging request in hwsim_cloned_frame_received_nl

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      1b60ed34f712e9f606d80951f1586f4274ebadf1
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/f0e5a89a-2d3b-4813-b1a1-01cf1b6e2ce4/config
syz repro: https://ci.syzbot.org/findings/457734e4-6b31-48a4-9aa6-ac6a4c6d65ee/syz_repro

BUG: unable to handle page fault for address: 00000000000048d0
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 10ab48067 P4D 10ab48067 PUD 0 
Oops: Oops: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 5793 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:lock_release+0x85/0x3c0 kernel/locking/lockdep.c:5923
Code: 84 26 02 00 00 65 8b 05 71 68 f1 11 85 c0 0f 85 17 02 00 00 65 4c 8b 3d b1 23 f1 11 41 83 bf a4 0b 00 00 00 0f 85 01 02 00 00 <49> 81 3e e0 24 56 94 0f 84 f4 01 00 00 9c 5b fa 48 c7 c7 60 f2 48
RSP: 0018:ffffc900036ef418 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000004870 RCX: 8000000000000001
RDX: 0000000000000000 RSI: ffffffff8c6d9460 RDI: ffffffff8c6d9420
RBP: ffffc900036ef570 R08: ffffc900036ef60f R09: 0000000000000000
R10: ffffc900036ef5e0 R11: fffff520006ddec2 R12: ffff888171777aa4
R13: ffffffff873ae393 R14: 00000000000048d0 R15: ffff88810ccca580
FS:  00007fe9e40d46c0(0000) GS:ffff8882a8cd9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000048d0 CR3: 0000000113f11000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __mutex_unlock_slowpath+0x88/0x900 kernel/locking/mutex.c:989
 hwsim_cloned_frame_received_nl+0x363/0xcf0 drivers/net/wireless/virtual/mac80211_hwsim_main.c:6607
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 __sys_sendto+0x408/0x5a0 net/socket.c:2281
 __do_sys_sendto net/socket.c:2288 [inline]
 __se_sys_sendto net/socket.c:2284 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2284
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe9e315e98e
Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
RSP: 002b:00007fe9e40d2ea8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fe9e40d46c0 RCX: 00007fe9e315e98e
RDX: 0000000000000034 RSI: 00007fe9e40d2fe0 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007fe9e40d2f24 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 00007fe9e40d2fe0 R15: 0000000000000000
 </TASK>
Modules linked in:
CR2: 00000000000048d0
---[ end trace 0000000000000000 ]---
RIP: 0010:lock_release+0x85/0x3c0 kernel/locking/lockdep.c:5923
Code: 84 26 02 00 00 65 8b 05 71 68 f1 11 85 c0 0f 85 17 02 00 00 65 4c 8b 3d b1 23 f1 11 41 83 bf a4 0b 00 00 00 0f 85 01 02 00 00 <49> 81 3e e0 24 56 94 0f 84 f4 01 00 00 9c 5b fa 48 c7 c7 60 f2 48
RSP: 0018:ffffc900036ef418 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000004870 RCX: 8000000000000001
RDX: 0000000000000000 RSI: ffffffff8c6d9460 RDI: ffffffff8c6d9420
RBP: ffffc900036ef570 R08: ffffc900036ef60f R09: 0000000000000000
R10: ffffc900036ef5e0 R11: fffff520006ddec2 R12: ffff888171777aa4
R13: ffffffff873ae393 R14: 00000000000048d0 R15: ffff88810ccca580
FS:  00007fe9e40d46c0(0000) GS:ffff8882a8cd9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000048d0 CR3: 0000000113f11000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	84 26                	test   %ah,(%rsi)
   2:	02 00                	add    (%rax),%al
   4:	00 65 8b             	add    %ah,-0x75(%rbp)
   7:	05 71 68 f1 11       	add    $0x11f16871,%eax
   c:	85 c0                	test   %eax,%eax
   e:	0f 85 17 02 00 00    	jne    0x22b
  14:	65 4c 8b 3d b1 23 f1 	mov    %gs:0x11f123b1(%rip),%r15        # 0x11f123cd
  1b:	11
  1c:	41 83 bf a4 0b 00 00 	cmpl   $0x0,0xba4(%r15)
  23:	00
  24:	0f 85 01 02 00 00    	jne    0x22b
* 2a:	49 81 3e e0 24 56 94 	cmpq   $0xffffffff945624e0,(%r14) <-- trapping instruction
  31:	0f 84 f4 01 00 00    	je     0x22b
  37:	9c                   	pushf
  38:	5b                   	pop    %rbx
  39:	fa                   	cli
  3a:	48                   	rex.W
  3b:	c7                   	.byte 0xc7
  3c:	c7                   	(bad)
  3d:	60                   	(bad)
  3e:	f2                   	repnz
  3f:	48                   	rex.W


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
[johannes.berg@intel.com johannes@sipsolutions.net linux-wireless@vger.kernel.org syzbot@syzkaller.appspotmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

