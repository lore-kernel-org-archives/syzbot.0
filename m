Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1D51E25ED
	for <syzbot@lists.linux.dev>; Wed,  6 Aug 2025 20:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754512056; cv=none; b=ozdpoZFigg2CfyNtA7g8xjFcOwjD4ZUuko3VBkTkwmbqQB655XucxAhMRjv7BsJDXoSTRURdcgRMN9lr8mVB9AhvWkOh7IwIfWS4XACqsy+ErOPmsUHrsT1Lgeai5n+2mVPewyVgYRL6JSIpu5PrcMq64DJAh/+feZX9XRrZ344=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754512056; c=relaxed/simple;
	bh=2BDdvzqj8Q/8mh3JjxY3tnE1Ls8dplb4vLGkpyDAVLw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=nAvYArgYssap/U0goLMU+pW0YAtLjqQEMADFk7S/yXpMyn90AAzKo0YQVotEGZxC6MjNV5/+0NhBNnzDyysaw6St8sQsxS+Wo0e4P0CpInoSgIvVABfpCUihhEhWC/YSzYWjfU5INTCHYaZDCDHNHadECcHfW2kw2uhCUJfq9JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-86463467dddso34200239f.3
        for <syzbot@lists.linux.dev>; Wed, 06 Aug 2025 13:27:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754512054; x=1755116854;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zIQfolwgngehqHDwYKUVPevC4Wu2weYxKE0wzDSrrvA=;
        b=hAwDrr6DWtzlN+XcsLK2jIDLW2EB0TgBQ2aHM0TFJT9X9Of/W2WRUyPIo0s21n11aa
         P+J6jUpTo66vD+EA2pnAxFbl4r1UT1wPnLvRC5KMAF2nRRqkdO3yjk3U+ga+JPx4sFp1
         jtWQJFmpKBebcb9oQXbwvKKSIECMlWrVrEkxUSsyJDpFfikq4JMdmLotC2bAPQBAbKBH
         sCWLXTfwWgKonhHDhPpVb0oO9WrznD7PlDvksv3Gv/O9v8wX7C9l2QMPQCB3Fjbcfj3R
         LmMnlD7bcP/TJTNM05VwihYZeYJQcWO9m/kRNQ4yfzjxkPhohB+ahd38KOUpJ1wUHe5g
         7pxg==
X-Gm-Message-State: AOJu0YzpL3HGK7o80IEN236JVfzCOxxFg8CqeEAEUIJ7UZCPh9j7v+mf
	G+klzv2VsVGUTVMUvx5brEHwd+l5llXqcYnx+6Jr4JZmIPjWDV6Ve9u2QNLOhTvArGU+r7cNkQk
	7ezpUFerk4cmOkFB7dihIVK26uqa23GhYqIGxdgsHrfvPd/0vNPG2uNefo3Q=
X-Google-Smtp-Source: AGHT+IH/3z7y0qIMUsa8DG55AX/t660n7Y7kBCqu5ZkhHnBVhibpP30Qjp6QITBl4FPSHURru5tAl/JqPmJg06o4Yif8223Id6gJ
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1508:b0:881:8a24:55c3 with SMTP id
 ca18e2360f4ac-8819f323048mr736637439f.1.1754512054261; Wed, 06 Aug 2025
 13:27:34 -0700 (PDT)
Date: Wed, 06 Aug 2025 13:27:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6893bab6.a70a0220.7865.0007.GAE@google.com>
Subject: [moderation/CI] Re: xsk: fix immature cq descriptor production
From: syzbot ci <syzbot+ci6e2923a937c1ed25@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] xsk: fix immature cq descriptor production
https://lore.kernel.org/all/20250806154127.2161434-1-maciej.fijalkowski@intel.com
* [PATCH v3 bpf] xsk: fix immature cq descriptor production

and found the following issue:
WARNING in xsk_create

Full report is available here:
https://ci.syzbot.org/series/ed9b41fb-c772-4c8d-ab6b-07919dac7f3f

***

WARNING in xsk_create

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf.git
base:      e8d780dcd957d80725ad5dd00bab53b856429bc0
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/ac640846-151f-4c3e-8a63-10a1d56881e1/config
syz repro: https://ci.syzbot.org/findings/34ebabe4-f302-4e4b-9951-0a44d704970a/syz_repro

------------[ cut here ]------------
kmem_cache of name 'xsk_generic_xmit_cache' already exists
WARNING: CPU: 1 PID: 6031 at mm/slab_common.c:110 kmem_cache_sanity_check mm/slab_common.c:109 [inline]
WARNING: CPU: 1 PID: 6031 at mm/slab_common.c:110 __kmem_cache_create_args+0xa3/0x320 mm/slab_common.c:307
Modules linked in:
CPU: 1 UID: 0 PID: 6031 Comm: syz.2.21 Not tainted 6.16.0-syzkaller-06699-ge8d780dcd957-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:kmem_cache_sanity_check mm/slab_common.c:109 [inline]
RIP: 0010:__kmem_cache_create_args+0xa3/0x320 mm/slab_common.c:307
Code: 81 fc 58 a5 22 8e 74 26 49 8b 7c 24 f8 48 89 de e8 32 81 67 09 85 c0 75 e2 90 48 c7 c7 f2 e1 98 8d 48 89 de e8 5e 00 7f ff 90 <0f> 0b 90 90 48 89 df be 20 00 00 00 e8 cc 82 67 09 48 85 c0 0f 85
RSP: 0018:ffffc90002dffcc8 EFLAGS: 00010246
RAX: 2d59588130194a00 RBX: ffffffff8cb69260 RCX: ffff888105d20000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: 0000000000000010 R08: ffffc90002dff9e7 R09: 1ffff920005bff3c
R10: dffffc0000000000 R11: fffff520005bff3d R12: ffff88801fde6928
R13: 0000607e5bfbe4c0 R14: ffffc90002dffd60 R15: 0000000000000098
FS:  00007f455d4c26c0(0000) GS:ffff8881a3c7e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f455c7b7dac CR3: 0000000106b38000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __kmem_cache_create include/linux/slab.h:353 [inline]
 xsk_create+0x67e/0x8d0 net/xdp/xsk.c:1817
 __sock_create+0x4b3/0x9f0 net/socket.c:1589
 sock_create net/socket.c:1647 [inline]
 __sys_socket_create net/socket.c:1684 [inline]
 __sys_socket+0xd7/0x1b0 net/socket.c:1731
 __do_sys_socket net/socket.c:1745 [inline]
 __se_sys_socket net/socket.c:1743 [inline]
 __x64_sys_socket+0x7a/0x90 net/socket.c:1743
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f455c58ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f455d4c2038 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 00007f455c7b5fa0 RCX: 00007f455c58ebe9
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 000000000000002c
RBP: 00007f455c611e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f455c7b6038 R14: 00007f455c7b5fa0 R15: 00007ffd678e28c8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aleksander.lobakin@intel.com andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net e.kubanski@partner.samsung.com maciej.fijalkowski@intel.com magnus.karlsson@intel.com netdev@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

