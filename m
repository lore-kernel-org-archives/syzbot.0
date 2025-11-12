Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF5B26E717
	for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 20:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762980320; cv=none; b=SQJpFS6Qtewo+XpA9oyHdDyRMVa6l+i9GiPTOaHTWXbzzakbxtYZTSKCFDfR2T6PvQJnqBDk8J+4D4cLtDIXg2m4ImGqvZqXP4i6h6ep4Dng3IQhN3sOa+W20v7jQZB858sSepUzTg+4BioPkf8u10o1ySRtBELKmvq54QGo2Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762980320; c=relaxed/simple;
	bh=i0M2Ds/6fKqVtgInowiv26bGgqdM3LwJwDxnD2RGVEw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=SPyM02Gu0/lG2GeQl5BZKDLF+7gODKhLAyrJTXxGSMf5v0bCDTrGQ+HgIX5ZNYI92yhSFZb2TMtod+3o8rka8cx2+wTE92BMo1dY/q83b5gksuUh3ekwQTRuKAMiQ69qDM72UfR6ck1xyB05eaRBA+dfre6nxSPcSQ+jLPok5NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-940d88b8c15so23117739f.2
        for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 12:45:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762980318; x=1763585118;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=de80dDytFfdBi9RAKfxz7F+CKYhmFukDCzsyNkQKp2U=;
        b=OD4QP2fmbD3DgxrfLmhy8jn31WGos0u/XXmshlp1YV17CkfLPmVY2Subax3OqOUMYa
         Du0pOdQDErY2eTactgWGxQzIdhcW9unINAkH9IckeNN2A4iCTeI/waGaMce/veouyr6n
         EoucYb1WzNYsSjrwA4syWcZDClk1sz9Q1IrF+8ExeRyQpSgRBy+viKfdb3tB+uPb2Pfc
         M/3oU2jbcp8YSZjpAf9hklHlzvnq9xwRHGNI7EucGD2JJfvE1sNFFaxtcpKcMBBXKAPS
         srPYMOzQ5RHLmeA+EI1L3ew9mgGmK7QJ4/9Gr0G9v4RdCWLGQ+857freAxxn0qz6tCGt
         fGJg==
X-Gm-Message-State: AOJu0Yy48ZPmmUA4jkQq7QRgNLOTYTGuafrZBpFNYBhB7XSTft76XB68
	fgRQDv/Bc8HUhioL1q+OWs+nMRDBte3hH70b3edJEIShInvQfUlWij14O7LD5g/42kt1ipH7FSe
	7tnOlibVeqfgCDXzAFqj/kCfQx+RoBT7p2fB0zA1+uiDT73HQSsqtxolEX+8=
X-Google-Smtp-Source: AGHT+IHZuVyeixeQ2jRg9jWO2Ykfc0lNRz2bYReCLgz3FM5zJXa9NL0lWbcUyzN3udqyQ1mpM+AgOljELiyNWn1eKSpXPKVqBwIL
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184a:b0:433:4fc9:7b38 with SMTP id
 e9e14a558f8ab-43473db4a60mr53046105ab.28.1762980317920; Wed, 12 Nov 2025
 12:45:17 -0800 (PST)
Date: Wed, 12 Nov 2025 12:45:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6914f1dd.a70a0220.3124cb.000e.GAE@google.com>
Subject: [moderation/CI] Re: make vmalloc gfp flags usage more apparent
From: syzbot ci <syzbot+cid2ec7a2d0105f633@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] make vmalloc gfp flags usage more apparent
https://lore.kernel.org/all/20251112185834.32487-1-vishal.moola@gmail.com
* [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
* [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
* [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
* [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/46d6cb1a-188d-4ff5-8fab-9c58465d74d3

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      b179ce312bafcb8c68dc718e015aee79b7939ff0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/3449e2a5-35e0-4eac-86c6-97ca0ec741d7/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#1: syz-executor/6079
Modules linked in:
CPU: 1 UID: 0 PID: 6079 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 c7 40 c3 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 a5 a1 6c ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc90005557b00 EFLAGS: 00010246
RAX: a6bff5ae8e950700 RBX: 0000000000000dc0 RCX: ffff888173b29d40
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90005557b98 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba6ec R12: 1ffff92000aaaf60
R13: dffffc0000000000 R14: ffffc90005557b20 R15: ffffc90005557b30
FS:  000055557c070500(0000) GS:ffff8882a9ec0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f86f6df0000 CR3: 0000000113d64000 CR4: 00000000000006f0
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
RIP: 0033:0x7fcbe2f90b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007ffed4000b80 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007fcbe302cf80 RCX: 00007fcbe2f90b0d
RDX: 00007ffed4000be0 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007ffed4000bf0 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007ffed4001018 R14: 00007ffed4001298 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org bpf@vger.kernel.org hch@infradead.org hch@lst.de linux-kernel@vger.kernel.org linux-mm@kvack.org urezki@gmail.com vishal.moola@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

