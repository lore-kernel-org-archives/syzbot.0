Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7BC23A9BD
	for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 02:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757470880; cv=none; b=hYwx5pcCemFfRwtQ9cDYt51XLTitf/GyX5a6fZ3J79N9u2mBxROgQ29ImGGW+vDR5FWRIiMRKurfeybyMBaKw1OvH4Xkam5dBowo22J9bJtt8c6KAzVw0jsXBjPZMy2/vzr5nQWVKJFJnI9p2ilirtleZq2Qtw/BPjnN74DCXBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757470880; c=relaxed/simple;
	bh=Q9EfTtbHp5ksNb27S6LmFtkKWcokV9domlztJFFg2f0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=XedCW0V92myk9L/184F0iHT5GKcbH1PmCteK8xBMGq80JixS0GNv26/ZMxfYitznfk9iXdehCtDQkUfoYr+coXfUfhf+8H/tryTwbV9r6kv+gIih+T5O92qm2koPQw7Ej0roJwywdbszz0L1c8hd3p3ioaGJUiEexe38Hn9/tlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-8875a8663d0so672005739f.1
        for <syzbot@lists.linux.dev>; Tue, 09 Sep 2025 19:21:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757470878; x=1758075678;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SOsJrIAo6XdqtQKtv/0rt+gx3mGfQNqDLuyAilWa3I8=;
        b=IOTv3KiJsrqXrdamdLu+W52HKBkvVRgBBXlmkMU9FnUI6jqXl9etx3S+loggvfBe+u
         f6pzFH5sOwvN/e9cf5HHuUUARgsmhxqRAmmlqUkwohv5xxhT/SsPP+JVRxaEdkLIYl0U
         ans6AF57q+5oEh8l/nvLFAFAAAW6+VqLmwqHTmKn8CRVTViMjb7Pl+K2LGe616KWH/1Y
         ETRFkKrh3xY4etd8FqPqp3ukjCy9QzjcwaoeqnD1KsaE+cLPMbg/L68nUwLWKd1+mig3
         bd8Yc2oeHVBhk1g+/slCFrzTFUYbrtpGmv1yMZCQZZaRhtt9vc63hHvVAfDrXIu0OoAk
         aDtg==
X-Gm-Message-State: AOJu0YyOugaecEeDa0wfsar6paCtRLDIFxy9mLrXHVNDLxnEzwFE+08P
	5AJsPKPubwGfxMRykvPnG/HiP3mNNd4ybJ1dYdATKvEb4+r2qwvw95IjstcUvUFwOv0C3iCqQ4u
	3V/xJFG4Te8sglQWdXjODQB7y2iw13P8YHsCz+tfu6wWBe1iYashtg6rqayQ=
X-Google-Smtp-Source: AGHT+IE7TYGyso64R6Ye0aoslzvRmvEtIufPAAMEmLkVqq4yjfFZze8iRVrlBaZS4w4LZ7jKSvJ4ALhERo417TISdzBhz1VBGkbW
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b42:b0:411:e396:5e2b with SMTP id
 e9e14a558f8ab-411e3966107mr58741865ab.4.1757470877935; Tue, 09 Sep 2025
 19:21:17 -0700 (PDT)
Date: Tue, 09 Sep 2025 19:21:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c0e09d.050a0220.2ff435.0008.GAE@google.com>
Subject: [moderation/CI] Re: mm/slub: Removing unnecessary variable accesses
 in the get_freelist()
From: syzbot ci <syzbot+ci5ba01a2db6fa3664@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[42.hyeyoo@gmail.com akpm@linux-foundation.org cl@linux.com iamjoonsoo.kim@lge.com linux-kernel@vger.kernel.org linux-mm@kvack.org penberg@kernel.org rgbi3307@gmail.com rgbi3307@naver.com rientjes@google.com roman.gushchin@linux.dev vbabka@suse.cz]

If the report looks fine to you, reply with:
#syz upstream

