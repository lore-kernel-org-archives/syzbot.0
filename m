Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2FC28504D
	for <syzbot@lists.linux.dev>; Thu, 18 Jun 2026 04:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781756966; cv=none; b=quOMx+3GHbcop/Nxogcp3V9ufOuX0c8fEOgEARXJxfmg6E2f37mfOllOpEGIVR7+lyXBEaGnyyk4RrCyAxBefwTKtqgM/4g1N+LoJfxplce7hInDtl3AYrUXkM4NP2x7ebucA3ZX8jQSLcIA7YlUkk/z7X/TBXbRDJyXhqC33qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781756966; c=relaxed/simple;
	bh=axwg19ZzNMylpdOeiPHgq3/za3tsxzcdHH+RHabryp0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=oyK3YD7w+s7sVyrogD6sas0RvTevinwEUujApR8YTxwCBZEmAYu8tG9yevStFa/G7w5pY/GVHcTs4X1zZIksamLK47aOXXjwtbhrImbuYWW6+UOy8ekS72iv2z3wGAOJJaERC8JmSLtiurPjkz3CK04i+deosd/szWoSIfo2k60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-48651d7d505so953658b6e.0
        for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 21:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781756964; x=1782361764;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iycp/5R53CA+RTNQTjCuM1lm7hncSFSxoKTkHt5fQgo=;
        b=RqSbhvqdlKsKtAIFV+LcNonFrNFJoUdSBDYvXmJke4h2ra9oFU4AdgUrgWBkarxzbP
         b94oJK79t/QN5/3hiQvnTaf3OA2Xh0EZ10djQ6nv9l80txk/s8y3NKvjqVptQ8MEP8d2
         olsz8vC3LP+eccut7z5rkjA7kgYXWDFQTSkvoIPE72oXWGbcmePnKYXtQAinI3tfF39v
         05mlFg3eFKGfkFMpK1lHPVwRVsG59oSdg1Kri6Iv75m7LV9BYn++cWvSaY5M4rwsJyez
         FqiUL6VUiCC0RlRTa+d9x97AGdnonIr0kTSuq9MMsz36eXdEPQsOR3gZW2W55rpoNTsB
         8zjg==
X-Gm-Message-State: AOJu0YwPOdc4mDdN57PZurcRP1k5AtVQErqrpZZ+mrcdOjAWoa+c+KpI
	QxJT/SyqsWr3BV4GS9a5sxBjjhbJ72qZzQWV1t+Bj5vz6fr1rPb0q7Y/LzEbrrPMIT5fBA8krRT
	XXzxglg+iHeQzcM/v4nH4yl/kvjdZzK1XEBnytJeY8h33XLRLaBh7pPBeV60=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6809:3cd:20b0:489:5c86:ba96 with SMTP id
 5614622812f47-4895c86c844mr602500b6e.17.1781756964584; Wed, 17 Jun 2026
 21:29:24 -0700 (PDT)
Date: Wed, 17 Jun 2026 21:29:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a337424.6d5abbec.a50f.0024.GAE@google.com>
Subject: [moderation/CI] Re: coredump/fcntl: Add FD_CLOBCOR flag to close fd
 before dumping core
From: syzbot ci <syzbot+ci5e0a64dea7cd43ee@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] coredump/fcntl: Add FD_CLOBCOR flag to close fd before dumping core
https://lore.kernel.org/all/20260618030700.2511668-1-jackzxcui1989@163.com
* [PATCH] coredump/fcntl: Add FD_CLOBCOR flag to close fd before dumping co=
re

and found the following issue:
WARNING: suspicious RCU usage in exit_files_before_core

Full report is available here:
https://ci.syzbot.org/series/bda032a0-64d8-4226-8ad1-6a4c99514d61

***

WARNING: suspicious RCU usage in exit_files_before_core

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      2a706d98d50a28dd635b3d028531d839c1f5f19a
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/e0dd4cce-02a0-415c-9720-8816ca17346=
d/config

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
./include/linux/fdtable.h:104 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active =3D 2, debug_locks =3D 1
no locks held by syz.2.65/5687.

stack backtrace:
CPU: 0 UID: 0 PID: 5687 Comm: syz.2.65 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 lockdep_rcu_suspicious+0x13f/0x1d0
 exit_files_before_core+0x35a/0x410
 vfs_coredump+0xa52/0x4550
 get_signal+0x1107/0x1330
 arch_do_signal_or_restart+0xbc/0x830
 irqentry_exit+0x2a4/0x860
 asm_exc_page_fault+0x26/0x30
RIP: 0033:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 002b:0000200000000008 EFLAGS: 00010217
RAX: 0000000000000000 RBX: 00007f3125415fa0 RCX: 00007f312519ce59
RDX: 0000200000000000 RSI: 0000200000000000 RDI: 0000000000000000
RBP: 00007f3125232d6f R08: 0000200000000000 R09: 0000000000000000
R10: 0000200000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3125415fac R14: 00007f3125415fa0 R15: 00007f3125415fa0
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
[alex.aring@gmail.com allen.lkml@gmail.com arnd@arndb.de brauner@kernel.org=
 chuck.lever@oracle.com ebiederm@xmission.com j.granados@samsung.com jack@s=
use.cz jackzxcui1989@163.com jlayton@kernel.org keescook@chromium.org linux=
-arch@vger.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kerne=
l.org mcgrof@kernel.org viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

