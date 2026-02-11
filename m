Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84382EA151
	for <syzbot@lists.linux.dev>; Wed, 11 Feb 2026 19:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770838555; cv=none; b=i5sl9TSZitLI3yjmL7HLDMeS6UCndgD3gw1JO770fW6DOruNNm3771QSCgFISMyBBkYs/BmvNcFLSJw9vL2nQjNtdEAe240OW18wOcyhMxLy9tFqbMAVCS9KYas7Q5NxHQo2YvEjcNiw2cPQZbrMbf6KgX+SvrxlippmqIUX7Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770838555; c=relaxed/simple;
	bh=teGeJDggDpHHWTeGigDVL+qiXZdQw9j3RnmLoIjv2PQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=posWK/TE4zb6pILLcPtO1vFtSu3hQABw6mKSl39PUJoyZrzrV3bS5+hDeXCJgbbjKpJPLkAFmXSeQ85/QzcxJIorycuI4PSBbhtTvqSjVHEpOMDhm24innlzorzc4nndfDm5JnNVQIQ2gz6WELJTi+U+6NkX7MAa+hnqzbJXTBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6751c78b651so4125100eaf.3
        for <syzbot@lists.linux.dev>; Wed, 11 Feb 2026 11:35:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770838552; x=1771443352;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Q9gjSLIM+0N0t/hdX5CngwZ7n5mxa5WEj12PyZvtcI=;
        b=BoD19deRD0vVXfCGxju3l8PrfpOtxwEUyFN2GeovZu2UwAHqBz3ln/XH5agR6gpaK6
         SFjO4TDf62ZeVXYk15gfVTbTitmeMqp5UKv8JIWGJkLRzavJVvZypRuZcyFMV7cpx3BF
         6mFJuXC2IYv9wgFAbSuz/a9oTbWPehjbhDLVdo6QvqSZfWS5MGFec4BEPjf8B+b614to
         FAgyBUmfB8oqWtD4iiluGTFFuhaR3zpZQyHfgM7/jJAovk+0i71QnY06OxpWT9PGhBwU
         ozTEkYTwkute9vOAtTv2igMTkPwU48Wiwff+x10qRTzwgVKW6oifbG7o8plqlkNFiGE8
         DAKQ==
X-Gm-Message-State: AOJu0YwJIqMMzPotpCQ6PKAh0CiD7DUJGi7snMXqoJgPf0V/chEPONNp
	YsNGMhP+eNYdltVz5qCig+XmMPKDOgJQmrSQzpxApXD8KU1WJeOxDtlvq713m/JMohdMr5ldIAQ
	tur1uDGNWEZREahI+pEiDRYSDYUpR6tq7kniJASjarcASP6K0Zi5OGAJd8vI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:80c5:b0:674:52d9:b25f with SMTP id
 006d021491bc7-6759affdf24mr128189eaf.44.1770838552688; Wed, 11 Feb 2026
 11:35:52 -0800 (PST)
Date: Wed, 11 Feb 2026 11:35:52 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698cda18.a70a0220.2c38d7.0088.GAE@google.com>
Subject: [moderation/CI] Re: mm: zone lock tracepoint instrumentation
From: syzbot ci <syzbot+ci84c74045278606f6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: zone lock tracepoint instrumentation
https://lore.kernel.org/all/cover.1770821420.git.d@ilvokhin.com
* [PATCH 1/4] mm: introduce zone lock wrappers
* [PATCH 2/4] mm: convert zone lock users to wrappers
* [PATCH 3/4] mm: convert compaction to zone lock wrappers
* [PATCH 4/4] mm: add tracepoints for zone lock

and found the following issue:
stack segment fault in dbUpdatePMap

Full report is available here:
https://ci.syzbot.org/series/43cf8aeb-42ac-4698-aa54-c296a912448f

***

stack segment fault in dbUpdatePMap

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      af41d136f7932e545ba8b068fa5d352304b65078
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/9cea4e2f-a652-4347-a169-f8ad5ebd228=
4/config
syz repro: https://ci.syzbot.org/findings/edbdba1b-7fc9-4625-b875-9a2af033c=
b21/syz_repro

Oops: stack segment: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 117 Comm: jfsCommit Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__list_add_valid_or_report+0x3e/0x130 lib/list_debug.c:29
Code: 00 00 00 48 89 d3 48 85 d2 0f 84 93 00 00 00 49 89 f6 49 89 ff 49 bd =
00 00 00 00 00 fc ff df 4c 8d 63 08 4c 89 e5 48 c1 ed 03 <42> 80 7c 2d 00 0=
0 74 08 4c 89 e7 e8 b2 f6 81 fd 4d 39 34 24 75 71
RSP: 0018:ffffc90003137a40 EFLAGS: 00010806
RAX: 0000000000000000 RBX: dead000000000100 RCX: 0000000000000000
RDX: dead000000000100 RSI: ffffc90002a79120 RDI: ffff88811d809ca8
RBP: 1bd5a00000000021 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000626f3c R12: dead000000000108
R13: dffffc0000000000 R14: ffffc90002a79120 R15: ffff88811d809ca8
FS:  0000000000000000(0000) GS:ffff88818e0f1000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555c51ca28 CR3: 000000011316a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __list_add_valid include/linux/list.h:96 [inline]
 __list_add include/linux/list.h:158 [inline]
 list_add include/linux/list.h:177 [inline]
 dbUpdatePMap+0x7ec/0xed0 fs/jfs/jfs_dmap.c:577
 txAllocPMap+0x57d/0x6b0 fs/jfs/jfs_txnmgr.c:2426
 txUpdateMap+0x81e/0x9c0 fs/jfs/jfs_txnmgr.c:2364
 txLazyCommit fs/jfs/jfs_txnmgr.c:2665 [inline]
 jfs_lazycommit+0x43d/0xaa0 fs/jfs/jfs_txnmgr.c:2734
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_add_valid_or_report+0x3e/0x130 lib/list_debug.c:29
Code: 00 00 00 48 89 d3 48 85 d2 0f 84 93 00 00 00 49 89 f6 49 89 ff 49 bd =
00 00 00 00 00 fc ff df 4c 8d 63 08 4c 89 e5 48 c1 ed 03 <42> 80 7c 2d 00 0=
0 74 08 4c 89 e7 e8 b2 f6 81 fd 4d 39 34 24 75 71
RSP: 0018:ffffc90003137a40 EFLAGS: 00010806
RAX: 0000000000000000 RBX: dead000000000100 RCX: 0000000000000000
RDX: dead000000000100 RSI: ffffc90002a79120 RDI: ffff88811d809ca8
RBP: 1bd5a00000000021 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000626f3c R12: dead000000000108
R13: dffffc0000000000 R14: ffffc90002a79120 R15: ffff88811d809ca8
FS:  0000000000000000(0000) GS:ffff88818e0f1000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055555c51ca28 CR3: 000000011316a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	00 48 89             	add    %cl,-0x77(%rax)
   5:	d3 48 85             	rorl   %cl,-0x7b(%rax)
   8:	d2 0f                	rorb   %cl,(%rdi)
   a:	84 93 00 00 00 49    	test   %dl,0x49000000(%rbx)
  10:	89 f6                	mov    %esi,%esi
  12:	49 89 ff             	mov    %rdi,%r15
  15:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
  1c:	fc ff df
  1f:	4c 8d 63 08          	lea    0x8(%rbx),%r12
  23:	4c 89 e5             	mov    %r12,%rbp
  26:	48 c1 ed 03          	shr    $0x3,%rbp
* 2a:	42 80 7c 2d 00 00    	cmpb   $0x0,0x0(%rbp,%r13,1) <-- trapping instr=
uction
  30:	74 08                	je     0x3a
  32:	4c 89 e7             	mov    %r12,%rdi
  35:	e8 b2 f6 81 fd       	call   0xfd81f6ec
  3a:	4d 39 34 24          	cmp    %r14,(%r12)
  3e:	75 71                	jne    0xb1


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org axelrasmussen@google.com d@ilvokhin.com david@ke=
rnel.org hannes@cmpxchg.org jackmanb@google.com kernel-team@meta.com liam.h=
owlett@oracle.com linux-cxl@vger.kernel.org linux-kernel@vger.kernel.org li=
nux-mm@kvack.org linux-trace-kernel@vger.kernel.org lorenzo.stoakes@oracle.=
com mathieu.desnoyers@efficios.com mhiramat@kernel.org mhocko@suse.com osal=
vador@suse.de rostedt@goodmis.org rppt@kernel.org shakeel.butt@linux.dev su=
renb@google.com vbabka@suse.cz weixugc@google.com yuanchu@google.com zhengq=
i.arch@bytedance.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

