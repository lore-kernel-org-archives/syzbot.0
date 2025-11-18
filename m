Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AE334DB69
	for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 11:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763463621; cv=none; b=jl+hFQzC4b2aCSKxpxIw94IVnnUcb1WM8f4kxCYa2au+5v/LaAWkN2VnnUuZm5MK67MeUhXetlAaFnG1OyjLXw9S1CWq7B26IBXzBcghk51vsyznZT13Z+CP+NiWjSQP4AmtOq3Zod78LkIr3CxCa1k5gG7LjbPixrw8B6MzZU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763463621; c=relaxed/simple;
	bh=dwAWDI+sOVAMWcDulQgs+/vBxg1VmZRPIdCNuIyCLCA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Xd+0PQlLbu5ntoQ5gHv7Sr+jg77/hcE8CHxFpYyR02o5pxTCIgdaofCPH0Tabs49TT+cJ7lhdAj5YUWw3i4Mij1HJwREVFC++OPIn8D/BNHOnTayS5jyfQFAoYXSKf+xdPL6g8v7I6gEyJE1NWO1rm1hf1gnODTIoyQqsGsj/+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-9490596dfb4so184809239f.1
        for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 03:00:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763463619; x=1764068419;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZqsCRgmPGQ1/nAKmgEuuzu7thfwWOTH7bNkwqiXk2yY=;
        b=mAr3R7RyFkWFq7HkDQoi0VK7gSRK6UFz0Y6pkeLzZ0zf2Gb5GrANQgsRVidsSR+kdv
         0G3I99IkgIwN03B7VuOJzm6gpCpkLF/uy5hS6kknvi5IVm/nDjzRxOl6YRmuZDZZjB0x
         LENbHmS8YiIsHWmuiZHt2zs7C4tU3qHihv0ze7eMLBtjCWLFEaaxNVCh1+yJWOAJgGz0
         buzAP07yHF6WrwDrwTwh1EWVTBt11HQ+gqgCdNiK5Wdplu7XVA+S16gAqmoL2IzGgTjM
         XMsSC4WRwDmg1j3ZqErq1MOL9AaRw90bpP9uYH42h7URXpz3tWT2b5kyR2E6AymHKMqp
         +yqA==
X-Gm-Message-State: AOJu0Ywh+Ox20GMi6U0s/p+iHATauIuDP63pEwKtOfC30a5RS2CXBQ3G
	HJJLzT/hqjI2KEWT+OQa6IxEvCVPcC/1EOUGzPYroAhhlGqZPIEGqkZJeLQuGBEV2+L/MUyVPn1
	D2CBorpFLlYAu6hR8lIsUPVZWVNNh4muqbffs4VPDn5jcPhjIymaVnq+27sI=
X-Google-Smtp-Source: AGHT+IGCjAOWj/SWiwNfFX1AWNbn+bb24U99i5C0QLZTjHv/0t8wy6oMDw3n7+nQksptvN/Fs5QnxXxodRbxD/iQlwMHpC+J+Ie2
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:5e8a:b0:434:96ea:ff56 with SMTP id
 e9e14a558f8ab-43496eb00b0mr127852665ab.39.1763463618755; Tue, 18 Nov 2025
 03:00:18 -0800 (PST)
Date: Tue, 18 Nov 2025 03:00:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691c51c2.a70a0220.3124cb.00bf.GAE@google.com>
Subject: [moderation/CI] Re: zram: Fix the issue that the write - back limits
 might overflow
From: syzbot ci <syzbot+ci7427a48d33cb9843@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] zram: Fix the issue that the write - back limits might overflow
https://lore.kernel.org/all/tencent_2FEBA8888C5B7C3CC495E17C29EFE76BA805@qq.com
* [PATCH v2] zram: Fix the issue that the write - back limits might overflow

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/259c5b30-7d81-45fe-a0e0-b283a12d6bfa

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      41218ede767f6b218185af65ce919d0cade75f6b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e782f0b5-cca9-46b3-98b9-cd87f46fb439/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: CPU: 1 PID: 6000 at mm/vmalloc.c:3938 vmalloc_fix_flags+0x9c/0xe0
Modules linked in:
CPU: 1 UID: 0 PID: 6000 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 c7 c0 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 75 2b 6e ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc90004fa7b00 EFLAGS: 00010246
RAX: 4ebf39c92d9eb400 RBX: 0000000000000dc0 RCX: ffff88816aa0d700
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90004fa7b98 R08: ffff88823c624293 R09: 1ffff110478c4852
R10: dffffc0000000000 R11: ffffed10478c4853 R12: 1ffff920009f4f60
R13: dffffc0000000000 R14: ffffc90004fa7b20 R15: ffffc90004fa7b30
FS:  000055555cfc1500(0000) GS:ffff8882a9f36000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb90085c470 CR3: 0000000112060000 CR4: 00000000000006f0
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
RIP: 0033:0x7fb900990b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007fff5f8ff980 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007fb900a2cf80 RCX: 00007fb900990b0d
RDX: 00007fff5f8ff9e0 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007fff5f8ff9f0 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007fff5f8ffe18 R14: 00007fff5f900098 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org bgeffon@google.com licayy@outlook.com linux-block@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org minchan@kernel.org richardycc@google.com senozhatsky@chromium.org ywen.chen@foxmail.com]

If the report looks fine to you, reply with:
#syz upstream

