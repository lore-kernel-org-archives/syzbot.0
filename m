Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD1D31355E
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 12:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760444877; cv=none; b=UNmwTjYChV7/5qCEb60nXu9u9NrPLiou/HZ/SZ58M4pYLBU5AgqA6nenLho4ULVvZypW0IcAdNBhfxPz+TrLtLwwmcphMxXBogcUZ6uiXDjqxDHmrJbhWaRptxgcRV4zi/++Yl5L0qX6zeatjoP+66ZdtB3vrE2EGgdssWxQXFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760444877; c=relaxed/simple;
	bh=01uuTvR4bDXnHAQRDRjMZhk7JBI1YmoaZSVufen84XI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=E6wIvQr+FT+1FGxQeVujlAllelzKdl9k6b8qUcRw7PE1rz61tEQtA6E8EqipbRrCxcWtZEtWkbxs0U9LYo4D0+kbkxK58vCOTWDM6uudF9WI+aYJO/kiFQiUeKyYWkSKOEg28oPQ4S4XYHxQymTYCFFxm6Tytr63reHmXHUSfDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-430929af37bso27407105ab.0
        for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 05:27:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760444875; x=1761049675;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DBDpa0FgwoN86WXS0sJErvW4jbuJmz8TH8QSweQ0osU=;
        b=HEnNySAsncv6A0Sabgv5jtxA0kKFa4FYfvDsKt8ec2XJyqv8SOF/eraWXICpil1D7Z
         ITCl/jCMe3Bpe+qJyw/d/SxB+NzVkNZV3SDHdJkzFauy6ZQtON/R6R2wmJKpG1iqYQeD
         4/c/qLQ1IsoSVcnUS8ESQi1LAjov/zFqcEMknQHrx8ZkK3oKDMzioibb18EJGonqal2B
         zVzOjwBeqiV64poBWQhuoS7A4YJ/iBdA6UXTO0PRnpMLqtoRLGhRmirZDUsTWl+KpyMw
         oeiI8QlynPZI8Hu9Es3uXftDGyClcQMf8gYRoS5GHyEQAdN+lgZzlKl82cV+PCAyEVXe
         HTCw==
X-Gm-Message-State: AOJu0Yy5xCAwNlU1tMG3iG0QTfpZqIa1kNzkGtjswyjuDPaXMWa80cye
	sVrq7sizD1xVDk9Np/crjEJEK+e1GWzGyzb8DC1Up9lLqR9rOT5/H2HAuBLtW9xKp237poQmGV8
	hribewCmMnWpiyg1FJDZHd1dHyssbQLzcMixucssFy+P//E1D4RUW4fRwywY=
X-Google-Smtp-Source: AGHT+IFfUXN2BK2Qia9xZh4QB+UySFtuzHaXUhvyiqlZT/KLmsbByZrRuPQNVILaGysIWrlQLrPoGc20NCrzrqjfpKkGo9DOZlr1
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:219a:b0:42f:9542:7b4a with SMTP id
 e9e14a558f8ab-42f95427d9bmr204334345ab.15.1760444875112; Tue, 14 Oct 2025
 05:27:55 -0700 (PDT)
Date: Tue, 14 Oct 2025 05:27:55 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ee41cb.050a0220.91a22.020b.GAE@google.com>
Subject: [moderation/CI] Re: slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags
From: syzbot ci <syzbot+cia3f00a4d25e231dd@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags
https://lore.kernel.org/all/20251014093124.300012-1-hao.ge@linux.dev
* [PATCH] slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags

and found the following issue:
general protection fault in percpu_ref_get_many

Full report is available here:
https://ci.syzbot.org/series/6fd66120-211f-479f-b6a1-35f990da2dc2

***

general protection fault in percpu_ref_get_many

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      0d97f2067c166eb495771fede9f7b73999c67f66
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/74de5bb7-695b-4115-9a4b-ee7d7fd0cca=
2/config

Oops: general protection fault, probably for non-canonical address 0xdffffc=
00177780ff: 0000 [#1] SMP KASAN PTI
KASAN: probably user-memory-access in range [0x00000000bbbc07f8-0x00000000b=
bbc07ff]
CPU: 1 UID: 0 PID: 6155 Comm: syz-executor Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:percpu_ref_get_many+0x8d/0x140
Code: 01 48 c7 c7 80 70 78 8b be 65 03 00 00 48 c7 c2 c0 70 78 8b e8 64 2b =
6f ff 49 bc 00 00 00 00 00 fc ff df 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 7=
4 08 4c 89 ff e8 c4 50 f7 ff 49 8b 07 a8 03 75 62
RSP: 0018:ffffc90004df7500 EFLAGS: 00010206
RAX: 00000000177780ff RBX: ffffffff822de139 RCX: 14bab840e71f4400
RDX: 0000000000000000 RSI: ffffffff8bc074c0 RDI: ffffffff8bc07480
RBP: 0000000000000088 R08: 0000000000000000 R09: ffffffff822de139
R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: dffffc0000000000
R13: ffff88823c63b5c0 R14: 0000000000000001 R15: 00000000bbbc07f8
FS:  0000555570ae6500(0000) GS:ffff8882a9d12000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555562d8c5c8 CR3: 0000000113444000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 refill_obj_stock+0x254/0x850
 __memcg_slab_free_hook+0x123/0x3b0
 kfree+0x3f7/0x6d0
 kobject_uevent_env+0x361/0x8c0
 netdev_queue_update_kobjects+0x346/0x6c0
 netdev_register_kobject+0x258/0x310
 register_netdevice+0x126c/0x1ae0
 __ip_tunnel_create+0x3e7/0x560
 ip_tunnel_init_net+0x2ba/0x800
 ops_init+0x35c/0x5c0
 setup_net+0xfe/0x320
 copy_net_ns+0x34e/0x4e0
 create_new_namespaces+0x3f3/0x720
 unshare_nsproxy_namespaces+0x11c/0x170
 ksys_unshare+0x4c8/0x8c0
 __x64_sys_unshare+0x38/0x50
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f85c81906c7
Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe57c0ca58 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f85c81906c7
RDX: 00007f85c818eec9 RSI: 00007ffe57c0ca20 RDI: 0000000040000000
RBP: 00007ffe57c0cac0 R08: 00007f85c83a69d0 R09: 00007f85c83a69d0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe57c0cac0
R13: 00007ffe57c0cac8 R14: 0000000000000009 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:percpu_ref_get_many+0x8d/0x140
Code: 01 48 c7 c7 80 70 78 8b be 65 03 00 00 48 c7 c2 c0 70 78 8b e8 64 2b =
6f ff 49 bc 00 00 00 00 00 fc ff df 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 7=
4 08 4c 89 ff e8 c4 50 f7 ff 49 8b 07 a8 03 75 62
RSP: 0018:ffffc90004df7500 EFLAGS: 00010206
RAX: 00000000177780ff RBX: ffffffff822de139 RCX: 14bab840e71f4400
RDX: 0000000000000000 RSI: ffffffff8bc074c0 RDI: ffffffff8bc07480
RBP: 0000000000000088 R08: 0000000000000000 R09: ffffffff822de139
R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: dffffc0000000000
R13: ffff88823c63b5c0 R14: 0000000000000001 R15: 00000000bbbc07f8
FS:  0000555570ae6500(0000) GS:ffff8882a9d12000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555562d8c5c8 CR3: 0000000113444000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org ast@kernel.org cgroups@vger.kernel.org gehao@kyl=
inos.cn hannes@cmpxchg.org hao.ge@linux.dev harry.yoo@oracle.com linux-kern=
el@vger.kernel.org linux-mm@kvack.org mhocko@kernel.org muchun.song@linux.d=
ev roman.gushchin@linux.dev shakeel.butt@linux.dev surenb@google.com vbabka=
@suse.cz]

If the report looks fine to you, reply with:
#syz upstream

