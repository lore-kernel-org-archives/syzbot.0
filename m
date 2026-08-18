Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3DF2F39B5
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 03:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787024805; cv=none; b=AIa/ZLDdIZ7hwOd9kT/7grrrb/Kcdgpp4UO9gbhuZscJsw72P5P/n5BHyL6vrXINlXUJoHbbHhO4us5m+PTAcMCRMgy/7rc3ji27v/0W9n5biuotY2T4+7bY4mejvcl9iPr+Q3stwnYoD5dV9C96eOpBBXvlRrAGb7IF1xo/6WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787024805; c=relaxed/simple;
	bh=j929hSbKhj3vtGgVwsWaL4urNlDZzAFxO//Uq6WLltE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=DBFmesol02JuSeUKjFLzbJgHTo5KsW+FdP3mPTPZgX7yZZ2/t+ZCToubdr4hRMwm9VtRQDe4BpH+DDcMJsvJMfKTBg+3lxw2b4cB8AR6NJU5WeixWtRIa9YWBj/EE3+M3vrDz/ssbOuPqRJEJ/9ieVhUPGMkfWGrnqJNIe0vtU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b28d7ffab0so1377453b6e.1
        for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 20:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787024802; x=1787629602;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7RtXiIO5Kekl4OPIleSkmISBfstR2L+Spb2zTpY5g5Y=;
        b=r+1kjmzKOqbAfxZZsIO6Qo5XmKcabTTijH3IDLEmSuaBzpMA4RtJlYbnhIipR4z7Wr
         72CysoyDUIKmEMNlaQ5HZUipcX1h8VJfXtOtd6g1c8wMYlDj95dNJMt+c7/Ar2GInLcw
         bu//LBvvGAb47Cr1ohLqc+SrWuy++q/ImL4/HsjCrWZtpFIJq7MhfQ3pqt1mKKcDAcCI
         YztH+3BwFkCtGA81v0ouWLIEBQQy7C5ILcipWjxFeVF5fhdZZRQOiKUlODblTEN4wva3
         HmWBQZvl99PePTTfL99EFTEZrixrGVgjAqkqfGIDVzvoK9N8XODZQ011U5A1U0uroLyz
         zR0w==
X-Gm-Message-State: AOJu0YxWtewroylHuNN0MJTa13SMHJMfcRVBm+XUi2L1YSxcFt41M2OO
	kP3rig5wN78NZ1DddnmLf9tsxorzvYsBKLqFM9pyvqshYhVuVC+JnP+XSX3OraScdZdyNhQHQes
	xctZert507c6WH3XhBZgYay6HYXmh8tYUzxVg4CxTfSRrFVOtWgm6mIAgahI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1907:b0:492:3ed0:9073 with SMTP id
 5614622812f47-4b2973be92fmr5005730b6e.4.1787024802286; Mon, 17 Aug 2026
 20:46:42 -0700 (PDT)
Date: Mon, 17 Aug 2026 20:46:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a83d5a2.4d75e56a.c9a88.0009.GAE@google.com>
Subject: [moderation/CI] Re: mm/memcontrol: introduce per-tier memory
 accounting and control
From: syzbot ci <syzbot+ci533f84960377f713@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/memcontrol: introduce per-tier memory accounting and control
https://lore.kernel.org/all/20260818023121.100613-1-liuqiqi@kylinos.cn
* [RFC PATCH 1/8] mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
* [RFC PATCH 2/8] mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
* [RFC PATCH 3/8] mm/memcontrol: add per-tier page counter infrastructure and lifecycle
* [RFC PATCH 4/8] mm/memcontrol: add per-tier charge and uncharge
* [RFC PATCH 5/8] mm/memcontrol: add per-cpu stock for tier charge/uncharge
* [RFC PATCH 6/8] mm/memcontrol: add memory.tier control file
* [RFC PATCH 7/8] mm/memcontrol: auto-derive tier high/max from memory.high/max
* [RFC PATCH 8/8] cgroup: add memory_tiered_limits cgroup mount option

and found the following issue:
WARNING in uncharge_folio

Full report is available here:
https://ci.syzbot.org/series/9db711d8-d389-45d1-b245-7e8b316a8432

***

WARNING in uncharge_folio

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dcacab904fe78d60840ba947a104993ee9ded887
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/bf213e6f-1b40-41fa-a938-385807688eec/config

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep_map))
WARNING: ./include/linux/memcontrol.h:391 at uncharge_folio+0x459/0x5b0, CPU#1: udevd/5681
Modules linked in:
CPU: 1 UID: 0 PID: 5681 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:uncharge_folio+0x459/0x5b0
Code: c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8b 3c 24 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 88 79 00 00 90 <0f> 0b 90 e9 c9 fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 49 fc
RSP: 0018:ffffc90004ff7210 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc90004ff72a0 RCX: 0000000080000001
RDX: 0000000000000000 RSI: ffffffff8e4a6d0d RDI: ffffffff8c4bb280
RBP: ffffc90004ff72a8 R08: ffffea0006e7a7c7 R09: 1ffffd4000dcf4f8
R10: dffffc0000000000 R11: fffff94000dcf4f9 R12: ffffea0006e7a7f8
R13: 1ffffd4000dcf4f8 R14: 0000000000000001 R15: ffffea0006e7a7c0
FS:  00007f1ec7ce0c80(0000) GS:ffff8882a8f6a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0cdf670000 CR3: 000000017358a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __mem_cgroup_uncharge_folios+0xfd/0x1d0
 folio_batch_move_lru+0x86f/0xa60
 lru_add_drain_cpu+0xbc/0x750
 lru_add_drain+0x121/0x3e0
 __folio_batch_release+0x48/0x90
 shmem_undo_range+0x4e6/0x15d0
 shmem_evict_inode+0x280/0xa80
 evict+0x624/0xb50
 dentry_kill+0x1b9/0x880
 finish_dput+0x1a/0x260
 filename_renameat2+0x61b/0x9a0
 __se_sys_rename+0x55/0x2c0
 do_syscall_64+0x174/0x580
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ec789a93b
Code: 48 8b 15 f0 64 15 00 83 c8 ff 64 83 3a 15 75 0e 48 8b 7c 24 08 e8 d5 d4 07 00 f7 d8 19 c0 48 83 c4 18 c3 b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 76 10 48 8b 15 be 64 15 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffcb336cd08 EFLAGS: 00000202 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1ec789a93b
RDX: 0000558c622ea032 RSI: 00007ffcb336cd28 RDI: 00007ffcb336d128
RBP: 000055893abc0910 R08: 0000000000000006 R09: f80f8ce6f311cb22
R10: 00000000000001b6 R11: 0000000000000202 R12: 000055893aba2730
R13: 00007ffcb336cd28 R14: 00007ffcb336d128 R15: 0000558926efb160
 </TASK>


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
[akpm@linux-foundation.org cgroups@vger.kernel.org hannes@cmpxchg.org linux-kernel@vger.kernel.org linux-mm@kvack.org liuqiqi@kylinos.cn mhocko@kernel.org mkoutny@suse.com muchun.song@linux.dev roman.gushchin@linux.dev shakeel.butt@linux.dev tj@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

