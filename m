Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D9EC8EB
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 00:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755218848; cv=none; b=dgGVjPeDQ7ZATIxTNc65Z5zk9VePa2aqbYm5T0ZJEudMVqucmHU06DkwaNcas6KieqYv4xG5xr6PDo2dLxCbk4gZueAkrUPpX5gORVvOXPUHinUYaXgnby6a/G1TwW6zyYsrPF+EOuX7dG/OCCkhUTYvCkj+/sF8vWOonfZkqR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755218848; c=relaxed/simple;
	bh=34WM6So8VbGZqPMr8xscZOBPNCRcGWUPYDxiKQvyhqA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=s9zg6HIxfjdILbC/aieHwLqY814NyoZYYah4Esu+nK1eA1OSVGHlH9I0O5ASxLEW3eKmwlVEdUhfgFu3M5NQQBRqEdWiHYeLsDOJi9GxO/yUER40QSh5Hc/PiWuOTsmRAEzXlaL+f9W+gdohscbRjnzCGoL5l30iMXWhiviCbhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-88432d877bfso321515739f.1
        for <syzbot@lists.linux.dev>; Thu, 14 Aug 2025 17:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755218846; x=1755823646;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QV9/yhaItwI3yI9EHOJSe8Xo7FnmAd3WAIwRRO99k6k=;
        b=Fu3xsSrxI6I59hXyY0i/WA4nwexkFs8VO8fnNdPMrdRiGIest34ylFhEZllewATnlT
         qcsRegTJ4kbqABuxsYHObNBMq863pZZnULBWyoWPuAVd3Wtp/lV2w9Ukjymkbk/FEjBc
         0PH0hNSAS5TfzZCBTVjAgCVPOg4/CLV5I7UCJVZOcY80nTYnvRJwKfo1gvn/uV1eXKKP
         ThlOl+Vv69fYb/zP55kjsU+tgv3Y6TJ68NELS3vJyYRFt8jUoWAr7cwKeWRNARGBuscG
         mmRK9HWqGyKUG9FWdCmBBDrY35jUHfiuP20h6GaBUo0u5LllsUMmwo1vEUmmMOA8fQiy
         IHAA==
X-Gm-Message-State: AOJu0YznLGIgMb8ICkO52nzxvQ9oYEYK9ZNdBxR5lSxvPbHyw5tm+hr3
	rVJON1+4CuvfzedqFQr0H+LHACh3rHzDCVQDvFUvwvCV8MfiwtNl4qUJx+ZrlnjhcdGFb682jCo
	0KXg6q0xoAEg7NCx5Dpn7ROXTR8cu9/pB19sVutdMr+AXHafVdQQW3pl5eB0=
X-Google-Smtp-Source: AGHT+IE1PyuW23fhUBfdVAcQXKxOlQ++E3+8DLVie8fa6nu2ipf5pzP4BaSNQHpk79CgnuVNX9j+JnhAAEVHFAfkzPX22q2xKR5d
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6406:b0:881:82bb:94b2 with SMTP id
 ca18e2360f4ac-8843e45e536mr90522339f.13.1755218845848; Thu, 14 Aug 2025
 17:47:25 -0700 (PDT)
Date: Thu, 14 Aug 2025 17:47:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689e839d.050a0220.1b2f6c.0001.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Use tnums for JEQ/JNE is_branch_taken logic
From: syzbot ci <syzbot+ci2ba5e1eb47e138d7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] bpf: Use tnums for JEQ/JNE is_branch_taken logic
https://lore.kernel.org/all/ba9baf9f73d51d9bce9ef13778bd39408d67db79.1755098817.git.paul.chaignon@gmail.com
* [PATCH bpf-next 1/2] bpf: Use tnums for JEQ/JNE is_branch_taken logic
* [PATCH bpf-next 2/2] selftests/bpf: Tests for is_scalar_branch_taken tnum logic

and found the following issue:
WARNING in reg_bounds_sanity_check

Full report is available here:
https://ci.syzbot.org/series/fd950b40-1da8-44b1-bd12-4366e4a354b1

***

WARNING in reg_bounds_sanity_check

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      07866544e410e4c895a729971e4164861b41fad5
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/c4af872a-9b42-4821-a832-941921acc063/config
C repro:   https://ci.syzbot.org/findings/8dfae15e-cda5-4fa6-8f95-aab106ebd860/c_repro
syz repro: https://ci.syzbot.org/findings/8dfae15e-cda5-4fa6-8f95-aab106ebd860/syz_repro

verifier bug: REG INVARIANTS VIOLATION (true_reg1): range bounds violation u64=[0xffffdfcd, 0xffffffffffffdfcc] s64=[0x80000000ffffdfcd, 0x7fffffffffffdfcc] u32=[0xffffdfcd, 0xffffdfcc] s32=[0xffffdfcd, 0xffffdfcc] var_off=(0xffffdfcc, 0xffffffff00000000)
WARNING: CPU: 0 PID: 6007 at kernel/bpf/verifier.c:2728 reg_bounds_sanity_check+0x6e6/0xc20 kernel/bpf/verifier.c:2722
Modules linked in:
CPU: 0 UID: 0 PID: 6007 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-00022-g07866544e410-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:reg_bounds_sanity_check+0x6e6/0xc20 kernel/bpf/verifier.c:2722
Code: 24 20 4c 8b 44 24 60 4c 8b 4c 24 58 41 ff 75 00 53 41 57 55 ff 74 24 38 ff 74 24 70 ff 74 24 40 e8 1f 30 aa ff 48 83 c4 38 90 <0f> 0b 90 90 48 bb 00 00 00 00 00 fc ff df 4d 89 f7 4c 8b 74 24 08
RSP: 0018:ffffc9000294ef08 EFLAGS: 00010282
RAX: 98d8a1179b385100 RBX: 00000000ffffdfcc RCX: ffff888020fb5640
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: 00000000ffffdfcd R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bfa1ec R12: ffff88803dbe4258
R13: ffff88803dbe4278 R14: ffff88803dbe4290 R15: 00000000ffffdfcc
FS:  000055557043b500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f985e5b7dac CR3: 000000010f3be000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 reg_set_min_max+0x214/0x300 kernel/bpf/verifier.c:16338
 check_cond_jmp_op+0x1625/0x2910 kernel/bpf/verifier.c:16772
 do_check_insn kernel/bpf/verifier.c:19960 [inline]
 do_check+0x6751/0xe520 kernel/bpf/verifier.c:20097
 do_check_common+0x1949/0x24f0 kernel/bpf/verifier.c:23265
 do_check_main kernel/bpf/verifier.c:23348 [inline]
 bpf_check+0x1746a/0x1d2e0 kernel/bpf/verifier.c:24708
 bpf_prog_load+0x1318/0x1930 kernel/bpf/syscall.c:2979
 __sys_bpf+0x528/0x870 kernel/bpf/syscall.c:6029
 __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f985e38ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd45036968 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f985e5b5fa0 RCX: 00007f985e38ebe9
RDX: 0000000000000048 RSI: 00002000000054c0 RDI: 0000000000000005
RBP: 00007f985e411e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f985e5b5fa0 R14: 00007f985e5b5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net eddyz87@gmail.com paul.chaignon@gmail.com shung-hsi.yu@suse.com yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

