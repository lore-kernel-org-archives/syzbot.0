Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A341F12F8
	for <syzbot@lists.linux.dev>; Tue,  9 Dec 2025 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765290499; cv=none; b=ipwCorxaZ4WQnyJ5laVuGL/JDeNjCDKgtTbAEZs0nik/E/RDY/UrkynFoZy15wjQYJjGy3wLSqApblqCSqE/PqUVciaDZL2DmuwsN8KAKVLE0SF0+sdTKU+S0CLXP+2pf96l89aDiPZF97S1vlk3YUa+nvB9LGKRkqgpuvQZaB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765290499; c=relaxed/simple;
	bh=f/HjL58kbkgOj6p8ZRFte7H+4eIbJ3UBTbZQ0s1GTNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bYCOC6quMtlJQm0W4JJWyTryz53DT/mMNxY07ho8DHdq58TYCeOo/LdpBLV8VrqFGmf366OEr7MNvIDjxeFLAnlH45sqf2oz11D0kVBQslH4CsTjeU/OISGHE6iV/uwRRObrDN9rTGZ7rWOuKepazAvQjs5UYvZ31A3Ygbv80jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VQgEBUK5; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VQgEBUK5"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-450c9057988so3209063b6e.1
        for <syzbot@lists.linux.dev>; Tue, 09 Dec 2025 06:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765290496; x=1765895296; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsWumiKfm7XYjvf0DmYSCvVk3FeH88k2zqhEq4zOck4=;
        b=VQgEBUK5RLviWjxMD8Evj1LH2pqvZLSY6kjmREfZNYo3fSoIm9dAoGFatqiEhwB7C7
         RN0FdHsVDnDY+68EC/BTWH2yPjwnSgjoSftX/OJV8Aw9wjgZpSuWCDbj2BkFNb5bx//2
         4TKCV+Siw4sxqrnNKikh8jkxSaq/lGdH8fs5RqA213N+gOqboIPF2BLYUKm2XqYtyxrf
         kCyoDjN0K8m8hAadxJFJ7niTpv8qKRGLtvoVCWW8LgbpbVfp84WcBiwJFVRI86ggtLeF
         zEvaFD2EiKq0V1YA77g2XtfQ8cmNIiDGFIYZRT/hd6NGN/j02eBUB85G9odppe3Gw7ZB
         S7/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765290496; x=1765895296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IsWumiKfm7XYjvf0DmYSCvVk3FeH88k2zqhEq4zOck4=;
        b=NXAgcKcukTIYcI/OXScFpmI7g18P3CyOW89sap6EMbKoOR5Hv2AIBbL81/uKNd19gx
         G++WuPbjc6RWbLYxZfS+sYsW3x726p5Vg+kF5NCbMdcJc6lo7urlqb2wuI5pC+Jg7zVU
         4JYWKanLEkfQwj6T5/RS3iUYxb2NEKkWNrdYQORWLHYiybhfP0sdbU4IkNct/Wn7SA6z
         sD1c4+/R4myqCCHJW5icnpM+UANqz5/nOzwwZzQ0xEKwkk1S/hrR0zsvJmAFjsAtbmeS
         diU39V+Yt6f8jHdV7IKu1O9UgmVmRFP8cUg46VdnmfySTzmXwIo0Pzq0skDwynwwRhAJ
         H9VA==
X-Forwarded-Encrypted: i=1; AJvYcCWAWni1acj4Or0En6lVIRKfGMnsc/6lSWQRynewuNeGqwslLnYgp2UCpEZ3hz1bSuC9VKTz7vQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyJOTObS34hwOM7j2HfSUbyfJ7rAaMEGXMdPtsbUpp9iuQv7nD
	FvflClBAIlAuzSnKbNOQ2nn3q0zjyESfUOKD2NGVkHMOWbd1bfhDNGv5z8RMjRudUPHeTi/5uLA
	D/QE52JefFa7QsxV62T9FnHLGq4je+iBb+70Xql+KK+MmIzo6IN04pWgS
X-Gm-Gg: ASbGncsvqRalwZ1fUKczlN5bIYdtYpwJjG9VgmsrFeCLM0cSlyGS1/GmKcmB4LbcYK9
	k1bW1PGQQFUCjErYb5VuqE65dFCTaqB2geLxy+0reE0NRc1DbD/Y6u9TpME/xECIzMdMM/i+VqN
	hisPMZaQEfekvJtqR7A/IeTibwp2IosAGf4zkvxDmmnFYovuOXd1rnkR8aF4sigB2GMOCVqeanP
	JNH6Jk87Bqqe29nCpSZK8T0JNOqcZwlK2dUf/m+0tH/dQpZQeZXLrdww8IfXauF9DUN4924irMH
	z4XR3GRhbUCuv0SMyCki3CV4Y3E=
X-Google-Smtp-Source: AGHT+IGmtBUb+BWXyXfHbkhK3sL+BsIfyCL8PC21zx66DNBFaOrRtUmzlyX7QQIzlr/Jx0SFQTxaquYP8xRAWv3psxY=
X-Received: by 2002:a05:6808:2388:b0:450:1fa0:1447 with SMTP id
 5614622812f47-4539e0886edmr3959783b6e.39.1765290496378; Tue, 09 Dec 2025
 06:28:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69382937.a70a0220.104cf0.0006.GAE@google.com>
In-Reply-To: <69382937.a70a0220.104cf0.0006.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 9 Dec 2025 23:28:04 +0900
X-Gm-Features: AQt7F2rg0NSiXecAhoDC99_5VbeZny59exSpNYuL5Y3oWiITFRvaZWfeYkWjvzI
Message-ID: <CANp29Y4NOYfdeDoEyoL9geHh44n7Q4UzoJyBFkprJrBKxw2kNQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: add sysfs attribute err_report_sec to
 control s_err_report timer
To: syzbot ci <syzbot+ci19ba43d779af7693@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Dec 9, 2025 at 10:50=E2=80=AFPM syzbot ci
<syzbot+ci19ba43d779af7693@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ext4: add sysfs attribute err_report_sec to control s_err_report tim=
er
> https://lore.kernel.org/all/20251209095254.11569-1-liubaolin12138@163.com
> * [PATCH v1] ext4: add sysfs attribute err_report_sec to control s_err_re=
port timer
>
> and found the following issue:
> WARNING: ODEBUG bug in ext4_update_super
>
> Full report is available here:
> https://ci.syzbot.org/series/0516238c-3b72-42ec-95e0-a3a1100dfe97
>
> ***
>
> WARNING: ODEBUG bug in ext4_update_super
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      67a454e6b1c604555c04501c77b7fedc5d98a779
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/d05c5a00-1dcc-4a73-9a08-de3990555=
1e0/config
> C repro:   https://ci.syzbot.org/findings/f5e1c416-0890-43de-a395-f7444bc=
f3202/c_repro
> syz repro: https://ci.syzbot.org/findings/f5e1c416-0890-43de-a395-f7444bc=
f3202/syz_repro
>
> EXT4-fs error (device loop0): ext4_orphan_get:1391: inode #15: comm syz.0=
.17: iget: bad i_size value: 360287970189639680
> ------------[ cut here ]------------
> ODEBUG: assert_init not available (active state 0) object: ffff88816a5866=
c8 object type: timer_list hint: 0x0
> WARNING: lib/debugobjects.c:615 at 0x0, CPU#1: syz.0.17/5984
> Modules linked in:
> CPU: 1 UID: 0 PID: 5984 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:debug_print_object+0x170/0x1e0 lib/debugobjects.c:612
> Code: f8 48 c1 e8 03 80 3c 18 00 74 08 4c 89 ff e8 b7 e0 8f fd 4d 8b 0f 4=
c 89 ef 48 8b 74 24 08 48 89 ea 44 89 e1 4d 89 f0 ff 34 24 <67> 48 0f b9 3a=
 48 83 c4 08 ff 05 8d 86 e9 0a 48 83 c4 10 5b 41 5c
> RSP: 0018:ffffc90004927210 EFLAGS: 00010246
> RAX: 1ffffffff16da490 RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: ffffffff8bc02f80 RSI: ffffffff8bc02a40 RDI: ffffffff8f8bd1a0
> RBP: ffffffff8bc02f80 R08: ffff88816a5866c8 R09: ffffffff8b6d35e0
> R10: dffffc0000000000 R11: ffffffff81aeb6f0 R12: 0000000000000000
> R13: ffffffff8f8bd1a0 R14: ffff88816a5866c8 R15: ffffffff8b6d2480
> FS:  0000555563b84500(0000) GS:ffff8882a9e44000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3e58d73ea0 CR3: 0000000114724000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  debug_object_assert_init+0x2db/0x380 lib/debugobjects.c:1020
>  debug_timer_assert_init kernel/time/timer.c:803 [inline]
>  debug_assert_init kernel/time/timer.c:848 [inline]
>  __mod_timer+0x4a/0xf30 kernel/time/timer.c:1025
>  ext4_update_super+0xc23/0x12f0 fs/ext4/super.c:6239
>  ext4_commit_super+0x67/0x430 fs/ext4/super.c:6257
>  ext4_handle_error+0x65e/0x950 fs/ext4/super.c:718
>  __ext4_error_inode+0x328/0x4f0 fs/ext4/super.c:861
>  __ext4_iget+0x187b/0x4280 fs/ext4/inode.c:-1
>  ext4_orphan_get+0x1e3/0x630 fs/ext4/ialloc.c:1391
>  ext4_orphan_cleanup+0xad2/0x1460 fs/ext4/orphan.c:465
>  __ext4_fill_super fs/ext4/super.c:5661 [inline]
>  ext4_fill_super+0x58e5/0x6240 fs/ext4/super.c:5785
>  get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1751
>  fc_mount fs/namespace.c:1199 [inline]
>  do_new_mount_fc fs/namespace.c:3636 [inline]
>  do_new_mount+0x302/0xa10 fs/namespace.c:3712
>  do_mount fs/namespace.c:4035 [inline]
>  __do_sys_mount fs/namespace.c:4224 [inline]
>  __se_sys_mount+0x313/0x410 fs/namespace.c:4201
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3e58d90f6a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 8=
4 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffde744ab68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffde744abf0 RCX: 00007f3e58d90f6a
> RDX: 0000200000000880 RSI: 0000200000000500 RDI: 00007ffde744abb0
> RBP: 0000200000000880 R08: 00007ffde744abf0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000200000000500
> R13: 00007ffde744abb0 R14: 0000000000000524 R15: 00002000000003c0
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   f8                      clc
>    1:   48 c1 e8 03             shr    $0x3,%rax
>    5:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1)
>    9:   74 08                   je     0x13
>    b:   4c 89 ff                mov    %r15,%rdi
>    e:   e8 b7 e0 8f fd          call   0xfd8fe0ca
>   13:   4d 8b 0f                mov    (%r15),%r9
>   16:   4c 89 ef                mov    %r13,%rdi
>   19:   48 8b 74 24 08          mov    0x8(%rsp),%rsi
>   1e:   48 89 ea                mov    %rbp,%rdx
>   21:   44 89 e1                mov    %r12d,%ecx
>   24:   4d 89 f0                mov    %r14,%r8
>   27:   ff 34 24                push   (%rsp)
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   48 83 c4 08             add    $0x8,%rsp
>   33:   ff 05 8d 86 e9 0a       incl   0xae9868d(%rip)        # 0xae986c6
>   39:   48 83 c4 10             add    $0x10,%rsp
>   3d:   5b                      pop    %rbx
>   3e:   41 5c                   pop    %r12
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [adilger.kernel@dilger.ca linux-ext4@vger.kernel.org linux-kernel@vger.ke=
rnel.org liubaolin12138@163.com liubaolin@kylinos.cn tytso@mit.edu]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/69382937.a70a0220.104cf0.0006.GAE%40google.com.
