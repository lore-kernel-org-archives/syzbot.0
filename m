Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B225A2749E6
	for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 21:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770931272; cv=none; b=WW+v3J1WJ690bclfpGOOAEjIBjyjhoBSDJ5IrJWyGkDnaKOS72zrDFIQ4SptFIPbI+zaRSXjjkTjty1oriHX6joipEi2icBvxwGHOGG8/I36xFwPnnPEjx9J87UZvvAfXPm8v+LZDLM2Hmsb+17CAwnnMNatGzQOfacYzE2tH98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770931272; c=relaxed/simple;
	bh=vgaKw7ZRaBqWI9OfqqFwlVA2v+wq2YsKCfdhvcIVApY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qI16Qo8zozxQnz/H/l6hqBqfeOtNAN0tPNh+GQORmac3NdN2VfsFSGGVFlaBKKAAyHb8Nr8+DnCOKnIZMQRUQl9wXR4bDS/aADIQrLZq4d1yi2fmCWLaUx3mZSCw4lo7fL5qv1mb+UHSdKyvzOmBZtZlEvDq10Dw9BVCK6zMGo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-66304fd6389so1886077eaf.1
        for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 13:21:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931269; x=1771536069;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B4/9Jxys972LYWTFxjfnrhdmuoziRLGf7VehmUb/tNE=;
        b=TwWqwYLauvlAb/AUoVRir+/yvol8lREOnroA5hGsarIqMTULgV0CF1Sr0v9vtS+QhG
         0f3y/OJxUMJEZO+j/E6f8e1HZnxQIFTsiIkIgdAFP6WvGPz8miTSnDpto8P/BL45cJmJ
         /dojf0xu1Hm2QNJVpgtmf3WvF3h7eVqgCI0CfBf9wzsO5UHJ8jz+w1KW76Kor8SdkoR5
         WUFXQYR/Z2+Fv3iHQfzzDQW6i82oxpiChURyOz2dldnfUsjM6YrKSKOSMt0OvjrPXlft
         aXpVwLqsfEHtUFduY3JkXxh87S13+OVbJkWcoPuQFJYFQWqZUe+qQ8rFEpdAc4TMuEn9
         0RcQ==
X-Gm-Message-State: AOJu0Yyf2XCCpYs2Oth52llV6Ijm/7BA9jsg4EtXclPFMo3AgxhP9jZ4
	+iCLIrCurO1b4JcbNkjV1kORpNbmI6ra5/nSxeX6Wi+Pme2wZ6zv8EjD/dyri3E7912E4SMgG+O
	uGSjfQTCm1iYlfvHKNo+7FxMhWU84jOXgROJ2NlH0D1uqySoJtfBjaBntpfY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:98e:b0:663:bad:9727 with SMTP id
 006d021491bc7-67723af5bbdmr98414eaf.78.1770931269528; Thu, 12 Feb 2026
 13:21:09 -0800 (PST)
Date: Thu, 12 Feb 2026 13:21:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698e4445.a70a0220.2c38d7.00a3.GAE@google.com>
Subject: [moderation/CI] Re: fs/ntfs3: add delayed-allocation (delalloc) support
From: syzbot ci <syzbot+ci03b327bb4b4298d4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fs/ntfs3: add delayed-allocation (delalloc) support
https://lore.kernel.org/all/20260212170849.12455-1-almaz.alexandrovich@paragon-software.com
* [PATCH] fs/ntfs3: add delayed-allocation (delalloc) support

and found the following issue:
WARNING in ntfs_extend_initialized_size

Full report is available here:
https://ci.syzbot.org/series/13e78e99-d298-48f9-b81b-be0931799244

***

WARNING in ntfs_extend_initialized_size

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      9152bc8cebcb14dc16b03ec81f2377ee8ce12268
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b551b487-d04a-4a8a-89aa-575a75c69c23/config
C repro:   https://ci.syzbot.org/findings/c8966f1e-fd77-42d2-8f24-1e7b54ac54dd/c_repro
syz repro: https://ci.syzbot.org/findings/c8966f1e-fd77-42d2-8f24-1e7b54ac54dd/syz_repro

loop0: detected capacity change from 0 to 4096
------------[ cut here ]------------
is_compressed(ni)
WARNING: fs/ntfs3/file.c:236 at ntfs_extend_initialized_size+0x1dc/0x210 fs/ntfs3/file.c:236, CPU#1: syz.0.17/5975
Modules linked in:
CPU: 1 UID: 0 PID: 5975 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ntfs_extend_initialized_size+0x1dc/0x210 fs/ntfs3/file.c:236
Code: 0d ff 4c 89 33 31 ed eb 05 e8 70 8b a3 fe 89 e8 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 9b a6 8e 08 cc e8 55 8b a3 fe 90 <0f> 0b 90 e9 31 ff ff ff 89 d1 80 e1 07 80 c1 03 38 c1 0f 8c e1 fe
RSP: 0018:ffffc90004547c30 EFLAGS: 00010293
RAX: ffffffff8322128b RBX: ffff8881a8229670 RCX: ffff88810ba49d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000800 R08: ffff8881a8229737 R09: 1ffff110350452e6
R10: dffffc0000000000 R11: ffffed10350452e7 R12: 0000000000000110
R13: 0000000000000ef0 R14: 1ffff110350452ce R15: 0000000000000000
FS:  000055555ee59500(0000) GS:ffff8882a9460000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f811e871980 CR3: 000000010f87c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ntfs_fallocate+0xf21/0x1220 fs/ntfs3/file.c:670
 vfs_fallocate+0x669/0x7e0 fs/open.c:340
 ksys_fallocate fs/open.c:364 [inline]
 __do_sys_fallocate fs/open.c:369 [inline]
 __se_sys_fallocate fs/open.c:367 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f811e99bf79
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffecc78b558 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007f811ec15fa0 RCX: 00007f811e99bf79
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00007f811ea327e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f811ec15fac R14: 00007f811ec15fa0 R15: 00007f811ec15fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[almaz.alexandrovich@paragon-software.com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org ntfs3@lists.linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

