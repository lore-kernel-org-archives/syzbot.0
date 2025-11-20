Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8B026ED53
	for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 20:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763670036; cv=none; b=RFGiQF/R1BLYrVWFJi+P876mN8TbQzsl2P98Rn0UUIVdOB5I5tq7X9rsw0/B1QGZbAwkc8AMdSBsqI57U5kCxKN3+1tp9LRSFtwcwuw/VqRBm9xf2Tx2zNnyVCe0C8j0pvqqJ3bQ+byqknQeMKEIy9Je3HFQIM/5amgXNhtGHMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763670036; c=relaxed/simple;
	bh=f7thRuUTNlGhJjZdgTjOBlqzkym1p17x8PacJTM74Gw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=H+ZIK4sKFysnZqJSObsCyeUlcv1sxjh/tpdM8c4GFz+x4FiNDvoMSBBL/kTNIRlH1HTYUQ5yhiYMHGVky6dFrPGNofFK47f0VSa/MRaJkPwih1iOVRSJ07DiKUTgus0yeekxGWmV6vejP1M5jUnTKbH+Vjr28Vcos0L7HSKaLY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-43373c85296so12781855ab.2
        for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 12:20:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763670034; x=1764274834;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T2RMARvZ0J8WW9S9Rr3YxAUO5D9gR7/JZ/hgToBf5bc=;
        b=C2KYsp+XK9lHwssAX5SqvSL3ewC6WJtIBxvh6Uy6nVP9rocCO8KlN3jiAzSutD4ZDV
         wTkKJ7oeqYqYWqVkOSpTbCfdGDzHv3kjAP2A/GXMX48VEF3Tla3JnVOEFxMIqyUVGuFN
         pfi0SApAIZf+/hAY5YMjs8mkmMZsjFra2OlSO/bzJJNxiIIsdmMENYA559WNHVgZvlfe
         /leROoTZywYuXP4IeiwJe+UEd0hJj5EKhB/4QCXAoTEokeliSvZi54Gq5bwsBDTEBKdl
         vmE2DOSwAvji7MGaRkjV+q6WuyfG+LQ4CQz+ZRKYh1khwEXIb8Aj/oJEIS2zTWMu2WNI
         aR4w==
X-Gm-Message-State: AOJu0Yz3ikiIhlI5yYHYt7Q3QX3m2FwtFSdRgIYNZNcaA8yk/5l/i/0v
	5pUtJ/j5JzEobRXG18jRXWttFkTsZhwP9Ch7xDVFuR3knPkD587EPNhFRlIv5uLBnDV83eMWPMM
	37dHTEqzWMmdJJUd0eQfWq+I5Xy/FxT+gjLvEr9Ds73YmisnHFSLKS1Oy7aM=
X-Google-Smtp-Source: AGHT+IFq8qbi5JDg7eWBpL35XNXeVuCehSrTOMhX5HtCoMalCNLWO4GpsM+ql/lOM9Z8IbS25mpQFmJM4tcylbTViwHQToCaiAyj
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a01:b0:434:70bd:8b52 with SMTP id
 e9e14a558f8ab-435b8c03974mr305835ab.7.1763670034510; Thu, 20 Nov 2025
 12:20:34 -0800 (PST)
Date: Thu, 20 Nov 2025 12:20:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691f7812.a70a0220.2ea503.0038.GAE@google.com>
Subject: [moderation/CI] Re: mm: skip wait in wait_sb_inodes() for
 hangable-writeback mappings
From: syzbot ci <syzbot+cifc4d86ec7efca2fa@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm: skip wait in wait_sb_inodes() for hangable-writeback mappings
https://lore.kernel.org/all/20251120184211.2379439-1-joannelkoong@gmail.com
* [PATCH v1 1/2] mm: rename AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM to AS_WRITEBACK_MAY_HANG
* [PATCH v1 2/2] fs/writeback: skip inodes with potential writeback hang in wait_sb_inodes()

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/7b9c70e1-5152-4fcd-89eb-65ec0e69b7a0

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      41218ede767f6b218185af65ce919d0cade75f6b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/f952b0b9-fd14-49db-bd5c-0b163e8c8146/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: CPU: 1 PID: 6089 at mm/vmalloc.c:3938 vmalloc_fix_flags+0x9c/0xe0
Modules linked in:
CPU: 1 UID: 0 PID: 6089 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 c7 c0 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 75 2b 6e ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc9000531fb00 EFLAGS: 00010246
RAX: fcc4f153a8ea0800 RBX: 0000000000000dc0 RCX: ffff888101b8d700
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc9000531fb98 R08: ffff88823c624293 R09: 1ffff110478c4852
R10: dffffc0000000000 R11: ffffed10478c4853 R12: 1ffff92000a63f60
R13: dffffc0000000000 R14: ffffc9000531fb20 R15: ffffc9000531fb30
FS:  00005555939ce500(0000) GS:ffff8882a9f36000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcbb125c470 CR3: 000000016cdbe000 CR4: 00000000000006f0
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
RIP: 0033:0x7fcbb1390b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007ffd748be6b0 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007fcbb142cf80 RCX: 00007fcbb1390b0d
RDX: 00007ffd748be710 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007ffd748be720 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007ffd748beb48 R14: 00007ffd748bedc8 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org athul.krishna.kr@protonmail.com david@redhat.com joannelkoong@gmail.com linux-mm@kvack.org miklos@szeredi.hu shakeel.butt@linux.dev stable@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

