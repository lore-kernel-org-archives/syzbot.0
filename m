Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793141061;
	b=ZsoJ55zhIM9+DoHpZ7YNBXlNvEWIqVZGqnQRbQ0BegOP95vO2J3v5fSsEYOCpsUHZNXN
	 CbZj/4J9bsDB6cYedrBQumVtIaMHpyyBdeaAZ6ZxVqgdDAbd7zI5xsiCeBfIwmmHMA89c
	 1GYkgYn7Fl1QNYIdw8sW4CEacGEqh+WNqtMDy1al9iuP74qudpUx7uighD+MC93buomjK
	 +PfR/x2Qyn04WIgvwepcMSzgr0qr6IUXA5hc2DfFGj0dt6NVDab0eP1e0Y7Bc5pZsTtkJ
	 DIfn2SMckVa2Hl2RIN2SJKRYUjdhzFCcwLNRSSAm1MEQzgSqaMRVCQTAnnlLeDub6gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793141061;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=kYWUpr7t4bxefcFVy//45YwhxGZafHOENbXFa0EZiZE=;
	b=Uqrd+rqUlWZvUBMOi8rXsAB5eRb9GCO2hlTJWtZaWKvQT4XTrbEdUAG/4Q4NjiN/Obx/
	 yNAVtc1HBtB7xAIbCFGpZ7j+KQ7syJp57ApHXmZTNClZgf1YSUsBEhBbx/5Nsz5g5xA5d
	 +cBNFzBmjUl1+KYHYsjVvWXlhsjo9vUyaFmsF9IJqNKY/J20N5LaGNknAeJR6o5bsRSYD
	 nT5gMgBXPjA57/zdgY+53JE+wwjOOhxXF7RB6RIoSx9bE5Qi22X2NJJHqzomxHHzR0GGe
	 g6vS/ZW5wb+5NAMDl3y+62EVNGuXlMoUsSPqgi6bSkhlwMH5xYO8aiOLyv3ap78NQ7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EB2606A31E
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 22:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02EB2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4d2f0f77124so488094b6e.3
        for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 15:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793141060; x=1793745860;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kYWUpr7t4bxefcFVy//45YwhxGZafHOENbXFa0EZiZE=;
        b=SW/EIlrBN0P7nKbtFT52ghQBS7P5Z8WtFovOkROUhLs32VDqhAK7JLrmJ44DDJsrf7
         0oPlsb2RT4PXCjIwYQN8nkS1RAwEjULnl960VyyGC+wleE5l/Fxt/ovoGvgud5KaN++S
         SKWtk2qQDs/9Ih+p/WbE1A+FI2lZLi2AIzTTiPdHO5u+MLQcVNVnsw//K6yLuy6WATq0
         amgu88OxJPmG1rXxQNZAa59gOY0mupM1IiN5pQeU986HzJfNqUQqL75TPCqN+tm4h2z5
         5fMSoBQPgUzAa3RTiobGMWus4ZyNwbKTUKLCSvB2Dd6Bwd2iD4PGWvuPm2q7HWsDzmW8
         SEUw==
X-Gm-Message-State: AFq9FYKx9q8dyCXExgIRRBcpUM+2cejnoEK/iKunFqEDhud7wJyomHNC
	XQoKIWJ5Qt03MUom7aLLa6UOHhQamM7UJdvy8Zow1zsSCoiQ5xYJVqVdLedzoqld0mSQ/LDa8Ok
	cCIqjb2iNe8dGWzh50i7UfB7heg2ClP0JCDPwA5CmUWDLzFLKolJcU7FpC2I=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6905:b0:4d6:90f4:48b4 with SMTP id
 5614622812f47-56384f7e6cbmr400409b6e.54.1793141059964; Tue, 27 Oct 2026
 15:44:19 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:44:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae12943.47d0a7c9.33355c.007e.GAE@google.com>
Subject: [moderation/CI] Re: mm: clear pmd in pmdp_invalidate()
From: syzbot ci <syzbot+ci0915606b3d8f5335@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm: clear pmd in pmdp_invalidate()
https://lore.kernel.org/all/20261027113813.1332096-1-trintaeoitogc@gmail.com
* [PATCH] mm: clear pmd in pmdp_invalidate()

and found the following issue:
kernel BUG in page_table_check_clear

Full report is available here:
https://ci.syzbot.org/series/ea6c690b-0dbf-4e3e-8367-2b5092d2878d

***

kernel BUG in page_table_check_clear

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      01146870c415f6ff70a469fb7ceb962a3f2c8c52
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/b4be77d2-e026-48a2-b906-ba8967ba2d37/config
syz repro: https://ci.syzbot.org/findings/8fa94c36-acda-4fe5-a760-1dea60977f77/syz_repro

------------[ cut here ]------------
kernel BUG at mm/page_table_check.c:83!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5817 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:page_table_check_clear+0x4ec/0x500 mm/page_table_check.c:83
Code: 89 e7 e8 f7 1a f4 ff e9 bd fb ff ff e8 4d 37 83 ff 90 0f 0b e8 45 37 83 ff 90 0f 0b e8 3d 37 83 ff 90 0f 0b e8 35 37 83 ff 90 <0f> 0b e8 2d 37 83 ff 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90
RSP: 0018:ffffc900035eed50 EFLAGS: 00010293
RAX: ffffffff8244dd9b RBX: 0000000000000200 RCX: ffff88810d88bc00
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffff888104dea000 R08: ffff888104dea04b R09: 1ffff110209bd409
R10: dffffc0000000000 R11: ffffed10209bd40a R12: 00000000ffffffff
R13: 0000000000000001 R14: ffff888104dea048 R15: 0000000000116200
FS:  00007f8b11ee36c0(0000) GS:ffff88818c4c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000140 CR3: 0000000112c36000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 page_table_check_pmd_clear include/linux/page_table_check.h:64 [inline]
 pmdp_invalidate+0x2fc/0x310 mm/pgtable-generic.c:206
 __split_huge_pmd_locked mm/huge_memory.c:3323 [inline]
 split_huge_pmd_locked+0x100a/0x2e50 mm/huge_memory.c:3476
 __split_huge_pmd+0x202/0x2e0 mm/huge_memory.c:3490
 zap_pmd_range mm/memory.c:2136 [inline]
 zap_pud_range mm/memory.c:2179 [inline]
 zap_p4d_range mm/memory.c:2200 [inline]
 __zap_vma_range+0xb85/0x4f80 mm/memory.c:2240
 zap_vma_range_batched+0x3e0/0x5b0 mm/memory.c:2351
 madvise_dontneed_single_vma mm/madvise.c:868 [inline]
 madvise_dontneed_free mm/madvise.c:959 [inline]
 madvise_vma_behavior+0x252b/0x41d0 mm/madvise.c:1370
 madvise_walk_vmas+0x924/0xb00 mm/madvise.c:1687
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1916
 do_madvise+0x327/0x3a0 mm/madvise.c:2014
 __do_sys_madvise mm/madvise.c:2023 [inline]
 __se_sys_madvise mm/madvise.c:2021 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2021
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8b10f9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8b11ee3028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f8b11225fa0 RCX: 00007f8b10f9f559
RDX: 0000000000000004 RSI: 0000000000003000 RDI: 000020000015e000
RBP: 00007f8b11036b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8b11226038 R14: 00007f8b11225fa0 R15: 00007fff02a6aba8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:page_table_check_clear+0x4ec/0x500 mm/page_table_check.c:83
Code: 89 e7 e8 f7 1a f4 ff e9 bd fb ff ff e8 4d 37 83 ff 90 0f 0b e8 45 37 83 ff 90 0f 0b e8 3d 37 83 ff 90 0f 0b e8 35 37 83 ff 90 <0f> 0b e8 2d 37 83 ff 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90
RSP: 0018:ffffc900035eed50 EFLAGS: 00010293
RAX: ffffffff8244dd9b RBX: 0000000000000200 RCX: ffff88810d88bc00
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffff888104dea000 R08: ffff888104dea04b R09: 1ffff110209bd409
R10: dffffc0000000000 R11: ffffed10209bd40a R12: 00000000ffffffff
R13: 0000000000000001 R14: ffff888104dea048 R15: 0000000000116200
FS:  00007f8b11ee36c0(0000) GS:ffff88818c4c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000140 CR3: 0000000112c36000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org david@kernel.org liam@infradead.org linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org mhocko@suse.com rppt@kernel.org surenb@google.com trintaeoitogc@gmail.com vbabka@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

