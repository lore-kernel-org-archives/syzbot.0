Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F5A21D011
	for <syzbot@lists.linux.dev>; Thu,  4 Sep 2025 17:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757005291; cv=none; b=XCs9mDIx/kbUeT5h6e1npRII3ZFItWORrJTvVr5xiNp/o+My42kz0ku6wsndLs2oiSVPX5l+P7E3m8sWf/LugDb3iKT1aKodJ9+yvr53EQqspsNJWP4c2fxP+MhdjNTl4pf/S3eNJbAuR/jsUWNJuNA9W7JWvJ5WtTzlpN1Yajo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757005291; c=relaxed/simple;
	bh=yziYJhh542pXmzcnaIvjTYmqHD9a63eKsqK9NdeJ62c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=pqNWOthYnf0AT/7oWMoTcyXnSjzbBz7J/CclWUmhzAet7vvF+MkYJJK4SQUv3soEXTqKXQpMwnbL17LkGWMZHPaUTLHs5rei0xJAcCIpIUg7bC9nUfXeeQDCK5pwWj+ilUeKRNV+JJ++CTe7gt3KFhML62MGB/KAYgtcdnXBALE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-887427eeefbso141030839f.3
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 10:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757005289; x=1757610089;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kYaitDAGjYEoPp9XyVlmY9H1syqa/zseC7k3V/N2nXE=;
        b=QvfGFiYOftr37nhv+auYdfsXahtVwlAUtQIq24xWYFtp8bCTjsncz2Im5HbpphQL6m
         93pZsp7+VbrxsVOjzaNmHauURZv1X02Cvci62qmkYu6xwOR4MPfahkrEJpIPoSJXYarC
         XMF8he+PtbgwjNqbFDFmjxRj5XocRJelTfazZSNCD9N1hrePQciTXupPhUsO94cznpCX
         DogGlLvlkbLxk9MYZlatbHUdfnJq8WCHBCpKrOxPX0GL9UpUWEP3gOjeTPrtHldFlMo7
         5FKvYzkMll+z/+ZRGetBCeWvHL6yiwU+VXb10CA53J3uF3XhtMKv/VeYdTu5TGOETCtW
         GIOQ==
X-Gm-Message-State: AOJu0Ywwpu5jN555Jlbd0agioDLURSBSxIjyyiwh4Nx31+SK/Kv7/Se1
	i+qo7hbhsqZxWGaWjZEZpzDiQescGvgZ9Lnh1n4/yULN140IGfX4TDIZVAR3ZkUJkpRAKgNAWn+
	zC+dex+KAJMqXEkq6yed8kIemFpKlmDiPeEa5T1KG6d/2NhplXGzHDIc/byA=
X-Google-Smtp-Source: AGHT+IFIPYBkSK1Kc1l+17j/wJelDf+TygL8lUPq43EPC2xcSX2iB6hPRN3sqWFurQ9JOn/S00a2VpKggnMxvaw2R4eo+RrZ6gN9
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194b:b0:3f3:d923:d67e with SMTP id
 e9e14a558f8ab-3f402ab66d2mr288163905ab.31.1757005254421; Thu, 04 Sep 2025
 10:00:54 -0700 (PDT)
Date: Thu, 04 Sep 2025 10:00:54 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b9c5c6.050a0220.192772.000a.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Support non-linear skbs for BPF_PROG_TEST_RUN
From: syzbot ci <syzbot+cif54e06847efbeb9b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] bpf: Support non-linear skbs for BPF_PROG_TEST_RUN
https://lore.kernel.org/all/cover.1756983951.git.paul.chaignon@gmail.com
* [PATCH bpf-next 1/4] bpf: Refactor cleanup of bpf_prog_test_run_skb
* [PATCH bpf-next 2/4] bpf: Craft non-linear skbs in BPF_PROG_TEST_RUN
* [PATCH bpf-next 3/4] selftests/bpf: Support non-linear flag in test loader
* [PATCH bpf-next 4/4] selftests/bpf: Test direct packet access on non-linear skbs

and found the following issue:
kernel BUG in bpf_prog_test_run_skb

Full report is available here:
https://ci.syzbot.org/series/94d30edd-8375-4788-b43c-b4f85290f7e8

***

kernel BUG in bpf_prog_test_run_skb

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      c9110e6f7237f4a314e2b87b75a8a158b9877a7b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/f23c9149-2bb8-4751-96fa-a1ef3b28cee2/config
syz repro: https://ci.syzbot.org/findings/4d88c169-3df8-4aac-b20a-ff80d8b2eff5/syz_repro

------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:23!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6005 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__phys_addr+0x17b/0x180 arch/x86/mm/physaddr.c:23
Code: 50 cf fa 8d 48 89 de 4c 89 f2 e8 10 9a 8a 03 e9 4d ff ff ff e8 66 25 4b 00 90 0f 0b e8 5e 25 4b 00 90 0f 0b e8 56 25 4b 00 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc90002c0fba8 EFLAGS: 00010293
RAX: ffffffff817486fa RBX: 000000007ffffff9 RCX: ffff888107c99cc0
RDX: 0000000000000000 RSI: 000000007ffffff9 RDI: 000000001fffffff
RBP: 00000000fffffff9 R08: ffffffff8fa38037 R09: 1ffffffff1f47006
R10: dffffc0000000000 R11: fffffbfff1f47007 R12: 0000000000000000
R13: 0000000000000000 R14: 000000007ffffff9 R15: dffffc0000000000
FS:  00007fae773f76c0(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31a63fff CR3: 000000001f48c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 virt_to_folio include/linux/mm.h:1180 [inline]
 kfree+0x77/0x440 mm/slub.c:4871
 bpf_prog_test_run_skb+0xceb/0x16e0 net/bpf/test_run.c:1179
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4590
 __sys_bpf+0x581/0x870 kernel/bpf/syscall.c:6047
 __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fae7658ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fae773f7038 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fae767c5fa0 RCX: 00007fae7658ebe9
RDX: 0000000000000050 RSI: 0000200000000080 RDI: 000000000000000a
RBP: 00007fae76611e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fae767c6038 R14: 00007fae767c5fa0 R15: 00007ffe5431da58
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__phys_addr+0x17b/0x180 arch/x86/mm/physaddr.c:23
Code: 50 cf fa 8d 48 89 de 4c 89 f2 e8 10 9a 8a 03 e9 4d ff ff ff e8 66 25 4b 00 90 0f 0b e8 5e 25 4b 00 90 0f 0b e8 56 25 4b 00 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc90002c0fba8 EFLAGS: 00010293
RAX: ffffffff817486fa RBX: 000000007ffffff9 RCX: ffff888107c99cc0
RDX: 0000000000000000 RSI: 000000007ffffff9 RDI: 000000001fffffff
RBP: 00000000fffffff9 R08: ffffffff8fa38037 R09: 1ffffffff1f47006
R10: dffffc0000000000 R11: fffffbfff1f47007 R12: 0000000000000000
R13: 0000000000000000 R14: 000000007ffffff9 R15: dffffc0000000000
FS:  00007fae773f76c0(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31a63fff CR3: 000000001f48c000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net eddyz87@gmail.com paul.chaignon@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

