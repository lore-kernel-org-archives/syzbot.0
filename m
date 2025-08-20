Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6576D3376A9
	for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 17:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755710276; cv=none; b=gtvxCutzGMdJEBN3sIN2IyKHbXQdgJgVCE7zkmcGiuN6iH05gsHMp29MAbz2LF/DotHMUuYcHQwdnKnge7LXdZ2zEF+PpFpvBon+NtFV2qV0s+W+a/hFhjh8XX/snqVZ55sWwq7MEWZ4MmnFzsDIHaEXy9Jh69DlOrpwHlQbrZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755710276; c=relaxed/simple;
	bh=9OxDFeOGsZ1jaH5ULb/cUOvIqPV875sARvo1ZqY5nrw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=MIci5HlKizfRkPxUENkWXhq/5XYwBlOrqlvKRweq9tDx2DJewHmqgTHLHWVi6moQIWPDfalfIMOt1XUbLv569NngE0w2tuamupERBmxRwCf+5MsOjHj1XOxy8G2VTGaLN5Fd+9xpH4+yY2Taanl2K6Eiylyhu8+Sjz9gvMlQtxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88432cb7627so5025039f.0
        for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 10:17:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755710273; x=1756315073;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VLeTytjqbBKaRAtop7EGh10XEOsvKGKAJtGNOAenP1Q=;
        b=V3jKgaRZO01aUcutTmoqOGQ9vxqQihQvqRWSVnbosssDhb1FDznoeGypD9JrNNoBnS
         f7cY+U5RFaSLfdks1zSj9hRUM2j7S9f5OWgMUOv9xsGB3L6yxFS9mmTM3u+WqQ2ad4eF
         9NdRmUIrHlJoKJo9oGgQneQywsAq9b9LDzT35xhtTbxgOBntDPrtDDfuUsYE9ZzkEZnM
         0lJNfh3rH3i/FvLK7MAjz74xvK7KWawE4bHUvrWNIBNt32ldBihsYIHNBDBeZHMd1Fyi
         rkxtOjbtRLk90hwtnJqqycZnCzFFBU8GUes9xR7kMUIa7OcqqL2p88gf0jbp2BBocHOe
         0SCg==
X-Gm-Message-State: AOJu0YwKrx0XF4YHUKKHZdzqDWW4qiphruNAAqtDHgR2cpUdChcqwOqT
	FRagC6/daScj7t4yzLccBP9cokOhtCwspMxhcAaT6nt1tSaGXx2GMiPYq+rSph+9Xc8m62VpGdN
	wOJcwz5VYuK3fB5u+NRZ09s18e84wuIjYTePRKFw6+JlYJjW9+awzgVKX7xM=
X-Google-Smtp-Source: AGHT+IF2Khjv4lZ+dkgShq2CprdsXLXxNhmfD0Zjdc6F+wChlVYZ4QLKooJ69O3FxsOs8yAGYoAEmE2HAQa5hqO02aolwdWNR+1y
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2dd0:b0:879:674e:2c73 with SMTP id
 ca18e2360f4ac-884718238e1mr745786439f.4.1755710273439; Wed, 20 Aug 2025
 10:17:53 -0700 (PDT)
Date: Wed, 20 Aug 2025 10:17:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a60341.050a0220.3d78fd.0008.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Use tnums for JEQ/JNE is_branch_taken logic
From: syzbot ci <syzbot+cif71619ec18e29d68@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] bpf: Use tnums for JEQ/JNE is_branch_taken logic
https://lore.kernel.org/all/be3ee70b6e489c49881cb1646114b1d861b5c334.1755694147.git.paul.chaignon@gmail.com
* [PATCH bpf-next v2 1/2] bpf: Use tnums for JEQ/JNE is_branch_taken logic
* [PATCH bpf-next v2 2/2] selftests/bpf: Tests for is_scalar_branch_taken tnum logic

and found the following issue:
WARNING in reg_bounds_sanity_check

Full report is available here:
https://ci.syzbot.org/series/a620d588-9a6a-4802-961b-93129a241715

***

WARNING in reg_bounds_sanity_check

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      bf7a6a67050f5d59a674ecc3ecd06d6b09cfec49
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/6ac3a676-88de-4dc5-9ca9-a28230534b6a/config
C repro:   https://ci.syzbot.org/findings/7a77d039-65ff-461d-9497-06c3d3d81893/c_repro
syz repro: https://ci.syzbot.org/findings/7a77d039-65ff-461d-9497-06c3d3d81893/syz_repro

verifier bug: REG INVARIANTS VIOLATION (true_reg1): range bounds violation u64=[0xffffdfcd, 0xffffffffffffdfcc] s64=[0x80000000ffffdfcd, 0x7fffffffffffdfcc] u32=[0xffffdfcd, 0xffffdfcc] s32=[0xffffdfcd, 0xffffdfcc] var_off=(0xffffdfcc, 0xffffffff00000000)
WARNING: CPU: 0 PID: 5985 at kernel/bpf/verifier.c:2733 reg_bounds_sanity_check+0x6e6/0xc20 kernel/bpf/verifier.c:2727
Modules linked in:
CPU: 0 UID: 0 PID: 5985 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:reg_bounds_sanity_check+0x6e6/0xc20 kernel/bpf/verifier.c:2727
Code: 24 20 4c 8b 44 24 60 4c 8b 4c 24 58 41 ff 75 00 53 41 57 55 ff 74 24 38 ff 74 24 70 ff 74 24 40 e8 3f 2f aa ff 48 83 c4 38 90 <0f> 0b 90 90 48 bb 00 00 00 00 00 fc ff df 4d 89 f7 4c 8b 74 24 08
RSP: 0018:ffffc90007806f08 EFLAGS: 00010282
RAX: 24deae30949c2200 RBX: 00000000ffffdfcc RCX: ffff888023361cc0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: 00000000ffffdfcd R08: ffffc90007806be7 R09: 1ffff92000f00d7c
R10: dffffc0000000000 R11: fffff52000f00d7d R12: ffff888036551258
R13: ffff888036551278 R14: ffff888036551290 R15: 00000000ffffdfcc
FS:  000055558a4c1500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fed12fb7dac CR3: 0000000105e50000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 reg_set_min_max+0x214/0x300 kernel/bpf/verifier.c:16349
 check_cond_jmp_op+0x1625/0x2910 kernel/bpf/verifier.c:16783
 do_check_insn kernel/bpf/verifier.c:19971 [inline]
 do_check+0x6751/0xe520 kernel/bpf/verifier.c:20108
 do_check_common+0x1949/0x24f0 kernel/bpf/verifier.c:23279
 do_check_main kernel/bpf/verifier.c:23362 [inline]
 bpf_check+0x1746a/0x1d2e0 kernel/bpf/verifier.c:24722
 bpf_prog_load+0x1318/0x1930 kernel/bpf/syscall.c:2979
 __sys_bpf+0x528/0x870 kernel/bpf/syscall.c:6029
 __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fed12d8ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd1a55fb58 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fed12fb5fa0 RCX: 00007fed12d8ebe9
RDX: 0000000000000048 RSI: 00002000000054c0 RDI: 0000000000000005
RBP: 00007fed12e11e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fed12fb5fa0 R14: 00007fed12fb5fa0 R15: 0000000000000003
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

