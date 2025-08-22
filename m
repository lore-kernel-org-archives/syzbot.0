Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60F42E6105
	for <syzbot@lists.linux.dev>; Fri, 22 Aug 2025 09:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755853687; cv=none; b=UNsVfbpOBINRq8VPpu/fU+1CfiDZBQU1dp8logEv4L5iRY52Iaxa+HVMcxkpg8xe7XfQlIX2kepH6weAvz2qNOckoziyIzY5sIDFDw3YgdS1ATlttCEO4xcSslU8XyONghcqhgB9lZmserOq+mKa/P/EmlneKaL8gkXOduOFU/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755853687; c=relaxed/simple;
	bh=9TSSZyKjJ0d3s2gjl1o0gZbkzbAiwGdZRFEiiOB7hX0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=bmlL2EzJPRqk/zpfa7zQ22qdVJEP8YlyzRkf9IjsAlmOix9Cz0/9Jb+36Z4er2pUX0d+xgzJijbx4vvc7d5gQ06pPWfh5TQVIExRR4CBN1lVM4b2L2o4N9xQQBelEdiLR8ikv9+j8czded/1YOrX74vgyr0JDyO1vJPFmA2XG5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88432d9ae89so159733139f.1
        for <syzbot@lists.linux.dev>; Fri, 22 Aug 2025 02:08:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755853685; x=1756458485;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VegEE/8h7OauzJkfJVbztSWMF3ODdKEV7dLA21bWxOs=;
        b=tW9FPERVGOutlRk3kolY56oN53eejCPRTnDloXiiD7Wm4zW24XqagJoerai5NcHckk
         l6++eqeN9BkZ2K8UepQl7bAEdqGjmx8g7qI0pRfRqV7EuCmYkKThA8oU/TaANwTh9rhA
         /8cfi41t2AO9eu4hCg3sU6zdBQ7z9+HcDTHVwFGjvKI7b7oEYUvXDS0/ttxEuyR5dMjm
         f9Ap+z9BRKi50+ojQ2sLdgLOF53GmzHveN7Rk9PZSlIRYRR+EeUuBHdrH7inOgdbOlBR
         1/4DmaSZZMF8l9NiufTA3LzxMhWOhdWomBWQXtiwg01EF2Rd/CnXv3kye6ejaSdRAsDR
         hUVg==
X-Gm-Message-State: AOJu0YzrtrA09hrjAVg0M3VGrAyoWAHBtpfuxMiUsi4Ush2Os1D/yLU+
	KqTZAep8G8o1NWG0fb4xWpqonYjf40s58yEI0wE6IxBwXpkcnmkHhyTtxIYpl5oEFDyhfzBtCf1
	Zegf6YhUx0oJw0CoJrhakW80YAXm06eVjhkIYXbAlnhvkUke7/hK425w2sS0=
X-Google-Smtp-Source: AGHT+IHmk+VNXNUi2Xo7de+YtmISF+yvT6EJoT90lW3ebCSHysHBUY2AA7+6I5d6kVDxmaCGW8xGL6feuNpo/gBuBLQpcQ1yKFbP
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1564:b0:3e9:eec4:9b5f with SMTP id
 e9e14a558f8ab-3e9eec49ee0mr2649515ab.30.1755853684885; Fri, 22 Aug 2025
 02:08:04 -0700 (PDT)
Date: Fri, 22 Aug 2025 02:08:04 -0700
In-Reply-To: <20250822-b4-tcp-ao-md5-rst-finwait2-v1-0-25825d085dcb@arista.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a83374.050a0220.3809a8.0004.GAE@google.com>
Subject: [syzbot ci] Re: tcp: Destroy TCP-AO, TCP-MD5 keys in .sk_destruct()
From: syzbot ci <syzbot+cif1e3ec255ad34895@syzkaller.appspotmail.com>
To: 0x7f454c46@gmail.com, davem@davemloft.net, devnull@kernel.org, 
	dima@arista.com, dsahern@kernel.org, edumazet@google.com, gilligan@arista.com, 
	horms@kernel.org, kuba@kernel.org, kuniyu@google.com, 
	linux-kernel@vger.kernel.org, ncardwell@google.com, netdev@vger.kernel.org, 
	noureddine@arista.com, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] tcp: Destroy TCP-AO, TCP-MD5 keys in .sk_destruct()
https://lore.kernel.org/all/20250822-b4-tcp-ao-md5-rst-finwait2-v1-0-25825d085dcb@arista.com
* [PATCH net-next 1/2] tcp: Destroy TCP-AO, TCP-MD5 keys in .sk_destruct()
* [PATCH net-next 2/2] tcp: Free TCP-AO/TCP-MD5 info/keys without RCU

and found the following issue:
WARNING in inet_sock_destruct

Full report is available here:
https://ci.syzbot.org/series/4e53fc18-79b4-47d6-87c4-89e499e12879

***

WARNING in inet_sock_destruct

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      a9af709fda7edafa17e072bffe610d9e7ed7a5df
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/d6e1c7cd-df1b-4192-bc2d-a2db69987793/config
C repro:   https://ci.syzbot.org/findings/62fd81c8-8c8c-49fe-aa87-8e1418bcc053/c_repro
syz repro: https://ci.syzbot.org/findings/62fd81c8-8c8c-49fe-aa87-8e1418bcc053/syz_repro

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6012 at net/ipv4/af_inet.c:153 inet_sock_destruct+0x5f9/0x730 net/ipv4/af_inet.c:153
Modules linked in:
CPU: 0 UID: 0 PID: 6012 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:inet_sock_destruct+0x5f9/0x730 net/ipv4/af_inet.c:153
Code: 00 41 0f b6 74 24 12 48 c7 c7 20 91 9e 8c 4c 89 e2 48 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d e9 dd 38 24 f7 e8 68 44 bc f7 90 <0f> 0b 90 e9 62 fe ff ff e8 5a 44 bc f7 90 0f 0b 90 e9 95 fe ff ff
RSP: 0018:ffffc90003a0fc58 EFLAGS: 00010293
RAX: ffffffff8a0366c8 RBX: dffffc0000000000 RCX: ffff888106891cc0
RDX: 0000000000000000 RSI: 00000000000003c0 RDI: 0000000000000000
RBP: 00000000000003c0 R08: ffff88803bb429c3 R09: 1ffff11007768538
R10: dffffc0000000000 R11: ffffed1007768539 R12: ffff88803bb42880
R13: dffffc0000000000 R14: ffff88803bb429c0 R15: 1ffff11007768512
FS:  00005555690ff500(0000) GS:ffff8880b861a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000f65000 CR3: 0000000106d3a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __sk_destruct+0x89/0x660 net/core/sock.c:2339
 inet_release+0x144/0x190 net/ipv4/af_inet.c:435
 __sock_release net/socket.c:649 [inline]
 sock_close+0xc3/0x240 net/socket.c:1439
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa54ab8ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc0978c268 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 000000000000ce2e RCX: 00007fa54ab8ebe9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 000000040978c55f
R10: 0000001b30220000 R11: 0000000000000246 R12: 00007fa54adb5fac
R13: 00007fa54adb5fa0 R14: ffffffffffffffff R15: 0000000000000006
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
