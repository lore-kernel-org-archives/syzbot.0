Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350F134845E
	for <syzbot@lists.linux.dev>; Tue, 23 Dec 2025 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766511969; cv=none; b=ru+ieprPQT1YwY+9I3Uvh/2ak7XOs3fE8gPLknp9mKydv2wTnwnAAsFAbqyPu3Graa8t68Fks8jfCQZIVQlcSCLmFWLRJrq2KLAeNsRydNAsNysM8PqNil4bt7ttYP5VJsymm84rOrr2irjwIGeRY38xvHA3MY1Lf0QWGLUzR5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766511969; c=relaxed/simple;
	bh=98UU4aANZn21uVO6fSeUGuppFm6BBVInEkCRBoK2FKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QezjDt5sWpNhHZJ6eGZLGD+c++15dgVFhG+7ss3Wcb80larTE37YDcUeCG301q9EmJCha6QKGFPmw3r2t4YbtX43njs6pN43a40ldTC0d4p5j5pHB3k1hSFY0hNIVv3El0TsdhciYvzBtADuLexLDpX15Uy6ASeIaIrwSU1pGWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ilIqQ1Zd; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ilIqQ1Zd"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-455ddb90934so1401761b6e.0
        for <syzbot@lists.linux.dev>; Tue, 23 Dec 2025 09:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766511965; x=1767116765; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdUJZuDy1HsFGyUcnjhO1tvBaD/sJ1vHlkV2y24W9r4=;
        b=ilIqQ1Zdb+jeFsyE7P0Ss1LgNwQm0mrPWZet08atY7155dBbFLsGbQQJYCvpg6Skva
         koXXEbd6X/5duSuXjnkwbMu3ZxahwIGZVNqLB6f1MbtqopmbJiSVL7kQ074sCJnFBkTs
         z3erY818KaRiVqPhvu2aIuBXkcZzQX5/UB+RbZi34eLddglbNpHhjBNjYn4mWahRG0TN
         B273CUuFLe9nh8eErg6IgEQHQ8S79P0qUMMrvg8meu1Gi+/AAmZrgaNii/bxth45w5lZ
         r8E0F32ckFzFJb/UvSaJTXSCgekG1UyCBZhmTpy/moAQiDqOGxtledToE34xLBQovC9j
         oSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766511965; x=1767116765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fdUJZuDy1HsFGyUcnjhO1tvBaD/sJ1vHlkV2y24W9r4=;
        b=YswBLWr8Tg1REI8oeIkV51Cz4LcEwvm/EDiLpD3pUcgdGNiDvxovsqdUFipUG9F5+Y
         17dmRXzSBzk9v/8HBkC+rfht9naAoEfgNil/oj4q9AWsJf2LvPeW3Ovio7Jm50TrZ8jp
         AAHqEbKpxPs25l/SbcTbAjLTvzC1sFhmFKwrKBBUfojr/AaQhkMmnRBEkS51kJkPvfM6
         /Ac2SBhxO5c+gufmSnL5J/NbaPl16/SfB5xe/nVsv/XtD1llH0I2uy0iH7WEhHA0Ay1Z
         v0dOrjgGCt4kk3ifcxq9gX7M2kz6CvtOlTScmXs30DA27fwhCB6BELGqzXsKmF+sYU5G
         YoqA==
X-Forwarded-Encrypted: i=1; AJvYcCX7t3KSKnSu4SLkxuvWg/QQ4eVwf/pdaIgswp3eEBX9sKwhVK0i/T6ZFLCecJzPIgzHyejUZZQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWfZjZIY2tBOIe+CXczpQHOAZ3HElWTfa8h88QKyxGa0wYSX+2
	qD7BYouOPy14m4CXEdf39UXXFp1WjXQVmDt0DooT8kKiQer+1FXX6I6c54zp9WWFVpNAZArYd7Q
	SAlrrEBBhnvwi5gj+F9VL1eOegsh9q/VxcXo5zaZI
X-Gm-Gg: AY/fxX6pcb+MXnhIybiyKh4zkxuQK2wgEleE08pVBQODGVxqGNBVNQY8KT/Qo5aasSL
	0U1zkWMOYB+UsWj4+xg3kshy6Htvq9yVkoLLPOJvlTKrQ16hEmwtHLtaa2s1AOT9/MYIxAKkly7
	fBXCXieAEe5FoGxkqQLygyDE4knuMVMI0Mah9LKND7KVIUdUfFeHGuDSgemcUb6iRPmCL5m1IW1
	VMN/ELj0lNo/pul10QBvJhai2d4ZDJBnpD4rFpD0y7XyDlEozfy14xuTh8TWa/jR+LPWnXvPDoh
	fAJDYw7G5ARF1oAr8YX/KGQpDySERnfSNekZzTQ7JwHVTh0Hsh/Cb105oGp3+/tCJFMy1xo=
X-Google-Smtp-Source: AGHT+IEk5TC1sGYPUfqukfu5sHcsAl1ZJdV0UzjhrDg/O5UkJZC4TeNcbb5vfvIMLSato4FxoUPUIjBT3s4MsmqTGNE=
X-Received: by 2002:a05:6808:2e4d:b0:450:92f9:1ba1 with SMTP id
 5614622812f47-457b2058079mr7192362b6e.67.1766511964610; Tue, 23 Dec 2025
 09:46:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <694ac000.050a0220.19928e.0030.GAE@google.com>
In-Reply-To: <694ac000.050a0220.19928e.0030.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Dec 2025 18:45:52 +0100
X-Gm-Features: AQt7F2puj6sB3SjWtG2kWMCOSTOvaI3Hw1v9PtdcmbHIElPNIRMxZOjlxAT1RQ0
Message-ID: <CANp29Y4s0jh+atGmib-sXyRpEQhQ_0J8EJEoWYaMVBWoe_gk3g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fuse: compound commands
To: syzbot ci <syzbot+ci71c667420ed312f3@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Dec 23, 2025 at 5:14=E2=80=AFPM syzbot ci
<syzbot+ci71c667420ed312f3@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fuse: compound commands
> https://lore.kernel.org/all/20251223-fuse-compounds-upstream-v1-0-7bade66=
3947b@ddn.com
> * [PATCH RFC 1/2] fuse: add compound command to combine multiple requests
> * [PATCH RFC 2/2] fuse: add an implementation of open+getattr
>
> and found the following issue:
> general protection fault in fuse_dir_open
>
> Full report is available here:
> https://ci.syzbot.org/series/11a1edb1-479b-4bb9-a173-a5aef4cc9455
>
> ***
>
> general protection fault in fuse_dir_open
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      9094662f6707d1d4b53d18baba459604e8bb0783
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/0d046766-2385-4f04-bae0-5a8d6df01=
c3a/config
> C repro:   https://ci.syzbot.org/findings/027737d8-b067-4bd4-90f6-5b236fb=
8420b/c_repro
> syz repro: https://ci.syzbot.org/findings/027737d8-b067-4bd4-90f6-5b236fb=
8420b/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000000b: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
> CPU: 1 UID: 0 PID: 5985 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:fuse_dir_open+0x14e/0x220 fs/fuse/dir.c:1900
> Code: eb a7 4d 8d 7e 58 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f=
f e8 e0 77 f3 fe 4d 8b 3f 49 83 c7 2c 4d 89 fc 49 c1 ec 03 <43> 0f b6 04 2c=
 84 c0 0f 85 82 00 00 00 41 8b 2f 89 ee 83 e6 14 31
> RSP: 0018:ffffc90003907860 EFLAGS: 00010203
> RAX: 1ffff11022f0688b RBX: ffff8881b9320000 RCX: 0000000000000000
> RDX: ffff88810afbba80 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff8f822b77 R09: 1ffffffff1f0456e
> R10: dffffc0000000000 R11: fffffbfff1f0456f R12: 000000000000000b
> R13: dffffc0000000000 R14: ffff888117834400 R15: 000000000000005c
> FS:  00007fa1fc9506c0(0000) GS:ffff8882a9e1f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fa1fb1fdfc8 CR3: 000000016abde000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_dentry_open+0x7ce/0x1420 fs/open.c:962
>  vfs_open+0x3b/0x340 fs/open.c:1094
>  do_open fs/namei.c:4628 [inline]
>  path_openat+0x340e/0x3dd0 fs/namei.c:4787
>  do_filp_open+0x1fa/0x410 fs/namei.c:4814
>  do_sys_openat2+0x121/0x200 fs/open.c:1430
>  do_sys_open fs/open.c:1436 [inline]
>  __do_sys_openat fs/open.c:1452 [inline]
>  __se_sys_openat fs/open.c:1447 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1447
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xec/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa1fbb8e010
> Code: 48 89 44 24 20 75 93 44 89 54 24 0c e8 69 95 02 00 44 8b 54 24 0c 8=
9 da 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 38 44 89 c7 89 44 24 0c e8 bc 95 02 00 8b 44
> RSP: 002b:00007fa1fc94fdf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 0000000000010000 RCX: 00007fa1fbb8e010
> RDX: 0000000000010000 RSI: 00002000000000c0 RDI: 00000000ffffff9c
> RBP: 00002000000000c0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000293 R12: 00002000000000c0
> R13: 00007fa1fc94feb0 R14: 0000000000000000 R15: 0000200000002280
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:fuse_dir_open+0x14e/0x220 fs/fuse/dir.c:1900
> Code: eb a7 4d 8d 7e 58 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f=
f e8 e0 77 f3 fe 4d 8b 3f 49 83 c7 2c 4d 89 fc 49 c1 ec 03 <43> 0f b6 04 2c=
 84 c0 0f 85 82 00 00 00 41 8b 2f 89 ee 83 e6 14 31
> RSP: 0018:ffffc90003907860 EFLAGS: 00010203
> RAX: 1ffff11022f0688b RBX: ffff8881b9320000 RCX: 0000000000000000
> RDX: ffff88810afbba80 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff8f822b77 R09: 1ffffffff1f0456e
> R10: dffffc0000000000 R11: fffffbfff1f0456f R12: 000000000000000b
> R13: dffffc0000000000 R14: ffff888117834400 R15: 000000000000005c
> FS:  00007fa1fc9506c0(0000) GS:ffff8882a9e1f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fa1fb1fdfc8 CR3: 000000016abde000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   eb a7                   jmp    0xffffffa9
>    2:   4d 8d 7e 58             lea    0x58(%r14),%r15
>    6:   4c 89 f8                mov    %r15,%rax
>    9:   48 c1 e8 03             shr    $0x3,%rax
>    d:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
>   12:   74 08                   je     0x1c
>   14:   4c 89 ff                mov    %r15,%rdi
>   17:   e8 e0 77 f3 fe          call   0xfef377fc
>   1c:   4d 8b 3f                mov    (%r15),%r15
>   1f:   49 83 c7 2c             add    $0x2c,%r15
>   23:   4d 89 fc                mov    %r15,%r12
>   26:   49 c1 ec 03             shr    $0x3,%r12
> * 2a:   43 0f b6 04 2c          movzbl (%r12,%r13,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   0f 85 82 00 00 00       jne    0xb9
>   37:   41 8b 2f                mov    (%r15),%ebp
>   3a:   89 ee                   mov    %ebp,%esi
>   3c:   83 e6 14                and    $0x14,%esi
>   3f:   31                      .byte 0x31
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
> [bschubert@ddn.com hbirthelmer@ddn.com hbirthelmer@googlemail.com linux-f=
sdevel@vger.kernel.org linux-kernel@vger.kernel.org miklos@szeredi.hu]
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
-upstream-moderation/694ac000.050a0220.19928e.0030.GAE%40google.com.
