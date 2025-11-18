Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9D04CB5B
	for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 00:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763424061; cv=none; b=nW49p461SoKe1wVPZnn/F0F0P6X7EZpzgf+XspGnPwj3/i6lTDH58PIaUWrt3v/vwqK814OwIVu7BV3WlY/uz4rOs6CgI5fOjzOnNhU7r7IKJXQeY5razTOd5YcUQyuuN7G6JbcUaSCN8H7m/tiBKl8iFLcSm77ZWWL3ZUhklhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763424061; c=relaxed/simple;
	bh=TZ8yr5x5KdzZtQyMCCuopICgLtrVCzQHGaL68iO0hDU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=hhZR6ym8X5dWjVzkrJq/RlZHcDbISwglAUn9oVFvMTvJ1T0Q0kmbERAwzd6bX2Q6SavnyZAnMrGW8dpTeZ2hUVyjvvjEU4y7uEKTG3AYU5E8PloP7qfx+w295fb9wM+I1d+xEiYOKjwTRsdXKlcO9gNVgA6JaxEbg9nf42OmcMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-4337e902d2bso46496255ab.3
        for <syzbot@lists.linux.dev>; Mon, 17 Nov 2025 16:00:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763424059; x=1764028859;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I/dm86WmgA/Mb1gHXNuVCZs40xkq/nutQcXI11xIJ6Q=;
        b=fzC2q2byWmo6JvIzQjp6m7VCz2UfjHhAu7jK22aP2yQoVF3g+fkydFQWdOtzYaCx/E
         2m1+0KpAsBUkGUJvBwL98KwkMR8VFe8KVhQlE+nZ1F0EWL7M0V8RDtalTpkVptbXisIx
         Fge84yqifDP8F45LA7AkZ0hJ8VDZ5rt6TjokvR9ql6dAmzHBcJ7EDaIXAciwqoJEOyMB
         Sam3xF+Di0gZw32aj4CU6oTBIP9lqKi+5CEUcSY4Jbl8TuPp4CXYw06umxn5PCX5FtON
         E0PKW6iqDLnINdEpF5NE1lkGNOBq6XXsrLirhA/LH5FI2EZpnF6q+W5ItoPcANtwDy7s
         uAPg==
X-Gm-Message-State: AOJu0Yz3yrVnGkrG4yAZLyr0qDJHIT3QbbSO9Cak9pwvAaqizNc0xG6e
	EnL1ivY35JaXsUcXyUgkJ98V4uK3va/SuRlI/zZuwtxcQdAvH0u/f0giw/kPDBm/xvOdRF5dNp7
	ANkYRxmSrsKMcETaNt8beSRuTI3xnzZFXJSy77KaPi1qCh6aknZNH0gnqRuM=
X-Google-Smtp-Source: AGHT+IEDQ9qr8ZU0BnLpA+RT5FJsbI1jPE4ZY1CtGJ12i/8Ya7C1kcH/xlrMKLCOAvwNVdH3YratFVRqhxhSUyqfbGdaQyfGxhUH
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c9:b0:433:4fa4:912e with SMTP id
 e9e14a558f8ab-4348c87b4b6mr149694575ab.4.1763424059081; Mon, 17 Nov 2025
 16:00:59 -0800 (PST)
Date: Mon, 17 Nov 2025 16:00:59 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691bb73b.a70a0220.3124cb.00ac.GAE@google.com>
Subject: [moderation/CI] Re: Extend xas_split* to support splitting
 arbitrarily large entries
From: syzbot ci <syzbot+ci16da8bbe26730850@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Extend xas_split* to support splitting arbitrarily large entries
https://lore.kernel.org/all/20251117224701.1279139-1-ackerleytng@google.com
* [RFC PATCH 1/4] XArray: Initialize nodes while splitting instead of while allocating
* [RFC PATCH 2/4] XArray: Update xas_split_alloc() to allocate enough nodes to split large entries
* [RFC PATCH 3/4] XArray: Support splitting for arbitrarily large entries
* [RFC PATCH 4/4] XArray: test: Increase split order test range in check_split()

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/aa74d39d-0773-4398-bb90-0a6d21365c3d

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      41218ede767f6b218185af65ce919d0cade75f6b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/c26972f6-b81e-4d6f-bead-3d77003cf075/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: CPU: 0 PID: 6465 at mm/vmalloc.c:3938 vmalloc_fix_flags+0x9c/0xe0
Modules linked in:
CPU: 0 UID: 0 PID: 6465 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 c7 c0 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 75 2b 6e ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc90005d7fb00 EFLAGS: 00010246
RAX: 6e85c22fb4362300 RBX: 0000000000000dc0 RCX: ffff888176898000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc90005d7fb98 R08: ffff888121224293 R09: 1ffff11024244852
R10: dffffc0000000000 R11: ffffed1024244853 R12: 1ffff92000baff60
R13: dffffc0000000000 R14: ffffc90005d7fb20 R15: ffffc90005d7fb30
FS:  000055555be14500(0000) GS:ffff88818eb36000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f653e85c470 CR3: 00000001139ec000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __vmalloc_noprof+0xf2/0x120
 bpf_prog_alloc_no_stats+0x4a/0x4d0
 bpf_prog_alloc+0x3c/0x1a0
 bpf_prog_create_from_user+0xa7/0x440
 do_seccomp+0x7b1/0xd90
 __se_sys_prctl+0xc3c/0x1830
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f653e990b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007fffbd3687c0 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007f653ea2cf80 RCX: 00007f653e990b0d
RDX: 00007fffbd368820 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007fffbd368830 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007fffbd368c58 R14: 00007fffbd368ed8 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[ackerleytng@google.com akpm@linux-foundation.org david@redhat.com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org michael.roth@amd.com vannapurve@google.com willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

