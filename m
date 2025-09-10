Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E65B2D29D5
	for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 08:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757493571; cv=none; b=Al4hCNqcfSRkJzlreHHJ5tvYfQCJdSBVDcKzEkYj2EwqHO7q5xbJM0lvFE7B1gy1Zh4l0FI8vCMtcJKM4nccwtgs8X9gP1qXavM45TGZJ+juwB/yEKWUKBL+oRR7GXQDOcxQh271GXrzDY0vTRO4hQWVVcqxqTp/zFydTFZmVWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757493571; c=relaxed/simple;
	bh=gry4TlZ3aQ73uBdGDKA5zzFuF4d7TFuTwiMfXGz2ICc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=KvSuJvNIyfduJPHFr9GmM95GHbw0LPyhoSEBssmILoCGb1VZSD1F/HfnMjD7OdkO4ZBAK69Aez3oHFWeE/KJ56ed6me5ZljQ+0YJ4tp6giENRBsstUmIZMnq8bkv/Dp3dLo7zMPeuGPGZxU6mKR93ZcCAsyWI32WQcPQf56Irvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4190d8f16c3so2595225ab.3
        for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 01:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757493569; x=1758098369;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wcqwa9UVTgt+vSJ2HOOPjUHsHWgh6bX7b58VAKjfe3Q=;
        b=w1hwQCBSzo+C6exTxrqNYSkP6qkMwpPEtn568Oj3Mb+bG0UfGo/UM1KhQBshN0dmxq
         OfbZuKedm/IATLVgpa4rCaRspB4iOlhrcS9uQBiMfXpCCE/7rC5ilUQDFh1Jbi73hzRw
         /ytt/WN5lZwPCY2Tb5tPeT15BkCKsLlSl3DQpZJ5GuSAiThsquI/UEppg/LROMuqxoTu
         9VYSLax0CMAXEbkTYRO3pUhLQTwWM5kcJs7FBW4pnEfOu5ZbzfFP3NUcDcq/V4sy9K+e
         RBdGZcgIX5xMpHMvRWCYXERdC628IyZTrR1/6GzGRktAwdSYbg2s5nviw6eA66woV8X0
         anTg==
X-Gm-Message-State: AOJu0Yxa5ioROc5xhzm6S5iTX2pHAeRTsQByhE6JxY2NRpQNR7Cglp1i
	ZbolxUAwDE3sSVfR1jKIkmQ/MGDOOQRlFdo4HDAENIWWmJTNCQmIGrgORox/6CgscozaCWD45Dx
	FIZJsX0QoB4NdrpQvSpaXxXa8hlfGTViHG5zvucj1MP0zAiUoqf0D2Y+eAsY=
X-Google-Smtp-Source: AGHT+IF+kkdZuXHRGt39YmgS5WbPtMYJOAMbJ/XGa2whcdg3dnOyi8+jm0FGA1na2rxzdjWkeavI2JXVEsr6LVsp5+Vhp83goTur
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2e:b0:412:f7d1:7432 with SMTP id
 e9e14a558f8ab-412f7d17596mr65192215ab.1.1757493569579; Wed, 10 Sep 2025
 01:39:29 -0700 (PDT)
Date: Wed, 10 Sep 2025 01:39:29 -0700
In-Reply-To: <20250910005957.54108-1-rgbi3307@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c13941.050a0220.3c6139.001d.GAE@google.com>
Subject: [syzbot ci] Re: mm/slub: Removing unnecessary variable accesses in
 the get_freelist()
From: syzbot ci <syzbot+ci49ef42f07c0503e6@syzkaller.appspotmail.com>
To: 42.hyeyoo@gmail.com, akpm@linux-foundation.org, cl@linux.com, 
	iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	penberg@kernel.org, rgbi3307@gmail.com, rgbi3307@naver.com, 
	rientjes@google.com, roman.gushchin@linux.dev, vbabka@suse.cz
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/slub: Removing unnecessary variable accesses in the get_freelist()
https://lore.kernel.org/all/20250910005957.54108-1-rgbi3307@gmail.com
* [PATCH] mm/slub: Removing unnecessary variable accesses in the get_freelist()

and found the following issue:
kernel BUG in __smpboot_create_thread

Full report is available here:
https://ci.syzbot.org/series/832d6128-4556-4bd1-ab18-0676b8e7dbc1

***

kernel BUG in __smpboot_create_thread

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      f777d1112ee597d7f7dd3ca232220873a34ad0c8
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/7bff7792-4edd-4680-a5e7-3cc9d97ac5ed/config

smpboot: CPU0: Intel QEMU Virtual CPU version 2.5+ (family: 0xf, model: 0x6b, stepping: 0x1)
Performance Events: unsupported Netburst CPU model 107 no PMU driver, software events only.
signal: max sigframe size: 1440
------------[ cut here ]------------
kernel BUG at mm/slub.c:3832!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:___slab_alloc+0x13ab/0x1420
Code: ff ff 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 3e 4f 0f ff 90 0f 0b 90 0f 0b 48 89 f7 48 c7 c6 3a a1 a0 8d e8 29 4f 0f ff 90 0f 0b 90 <0f> 0b 90 0f 0b 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 11 4f 0f ff 90 0f
RSP: 0000:ffffc90000047750 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff888100028000 RCX: 0000000000800001
RDX: 0000000000800001 RSI: ffffffff8dba8965 RDI: ffffffff8be33980
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff82189e55
R10: dffffc0000000000 R11: fffffbfff1f47407 R12: ffff88804b03e480
R13: ffff88801a441640 R14: ffff88804b03e460 R15: ffffffff82189e55
FS:  0000000000000000(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __kmalloc_cache_node_noprof+0x29a/0x3d0
 __smpboot_create_thread+0x11a/0x3b0
 smpboot_register_percpu_thread+0xc6/0x420
 spawn_ksoftirqd+0x2f/0xc0
 do_one_initcall+0x236/0x820
 do_pre_smp_initcalls+0x4c/0x80
 kernel_init_freeable+0x30c/0x4b0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x3fc/0x770
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:___slab_alloc+0x13ab/0x1420
Code: ff ff 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 3e 4f 0f ff 90 0f 0b 90 0f 0b 48 89 f7 48 c7 c6 3a a1 a0 8d e8 29 4f 0f ff 90 0f 0b 90 <0f> 0b 90 0f 0b 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 11 4f 0f ff 90 0f
RSP: 0000:ffffc90000047750 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff888100028000 RCX: 0000000000800001
RDX: 0000000000800001 RSI: ffffffff8dba8965 RDI: ffffffff8be33980
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff82189e55
R10: dffffc0000000000 R11: fffffbfff1f47407 R12: ffff88804b03e480
R13: ffff88801a441640 R14: ffff88804b03e460 R15: ffffffff82189e55
FS:  0000000000000000(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
