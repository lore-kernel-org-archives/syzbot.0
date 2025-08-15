Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1671E9B2F
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 08:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755246282; cv=none; b=Vk90c8ViiC/BKlwGfeB9OwGlYx794vDX3KcJz8uVd9DUe7zFcMf0EtbaeTPd4FAbeosnShivv0fzBNfgr4PxFVU1jRak+UMxCY4P/T5V62nbQ8zIfkccZCuzT+TsqN1NRPLYptlZzF4csVYNNA/TgsFkc4OlNmGt2B1nAoN7GHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755246282; c=relaxed/simple;
	bh=rrg2Bvx2VAj8xys4jmXkAwGWpuCSTGUzqZqYH9p1FOA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=i4g3xi9MIQj7NSO3tlbTxK/Wf5E7vLVty3T00u1j0/7DfAZdYOJ2Kk0s/MWOKlHTjwVNnN34LLSEpr3tZb8p0qr+k6Mj7EuqXyJZCVTyVJkdObzCQxMPoKt178DR6u9MnjvcrEKFu6BBgFLMX0BThOLlSThmG9SB+a2bS1GUX34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e56ffc6000so20243155ab.1
        for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 01:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755246280; x=1755851080;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FIKN296dGRzixCkkp/I0KdWyNTgumfFlzJYexvVEkFg=;
        b=EESCUhE+lAiMcTHfrqglBfUZvK9vo7zBbLfnDsBr7glp5A0vYNSx4eaFOn3J/txLe+
         ojHfhRVhcY/U34SUJkmvp8L1HTs59BrssyN/FRVRNZnmxtlJJ4vFjJDIFAGlKMDZKG+6
         H8yY8QvXHoer1W41nFSYsWg0h0D/CGeLN+7IVErpnw0aeHEayu3NzOkV1vJS4Mrdtlm7
         4oVIt6/4vojvTg1qZTy+iF7squpHU7R8aXJN1c3cirLhrYYv3X9IJBxyaxHmLZ9e8Rk8
         6MifTk97QOWWl6UmUYVPp0uoFtTwJQ3qp+LmtlSBx0PkKAAC0K6tDDY9aKOK/+rkm4QG
         qvTQ==
X-Gm-Message-State: AOJu0YzPcAoea0ovEDm0on9Er641v8ilyK7OK6gjXl1GXIzac3kdP5VR
	TI6uBgInzrCib1tjj3IWH99a4PNkJy4REhw3gtSnby3UfM3ELIdxFCgNNUZuqpjAfvu5la4wtAJ
	StsZ0efzOd/HDV8Hkxl5NsglfUIKn3JvNrcIGBKgjVMFdy4JXVXxoH+GIIcM=
X-Google-Smtp-Source: AGHT+IG36AW8X0BprfqVG7vWgxsQ9mQIuHb6v2OicPdnL08RLGZvGg4rwN+FltCQx8GMhkqsaQ4ohLRbB+PETLuqceOeCiIC1/T0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc9:b0:3e5:70d2:b57c with SMTP id
 e9e14a558f8ab-3e57e9db9b6mr17020225ab.22.1755246280207; Fri, 15 Aug 2025
 01:24:40 -0700 (PDT)
Date: Fri, 15 Aug 2025 01:24:40 -0700
In-Reply-To: <ba9baf9f73d51d9bce9ef13778bd39408d67db79.1755098817.git.paul.chaignon@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689eeec8.050a0220.e29e5.000f.GAE@google.com>
Subject: [syzbot ci] Re: bpf: Use tnums for JEQ/JNE is_branch_taken logic
From: syzbot ci <syzbot+ci59254af1cb47328a@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, eddyz87@gmail.com, paul.chaignon@gmail.com, 
	shung-hsi.yu@suse.com, yonghong.song@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
