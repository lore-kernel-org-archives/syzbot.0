Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3D3392C51
	for <syzbot@lists.linux.dev>; Fri,  6 Feb 2026 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770401169; cv=none; b=nxEJyP1nHA4OW6CRLHQYHX6gJDHlkJdJXyO2RRntabN5D9A8Dq57eEAMq1BBFR+0+i53k+LIIyb3u5hLoDtDrmY1SwdQCFGol+hDjCODy13bOhP17NsKFibM7PpY58Kn3lMKDKs2K9QHhB6bMXfAQMja7iBoBSiu36vg32+RKtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770401169; c=relaxed/simple;
	bh=CYysKqZS1YvRZNd3IDudzJvb5gPLSzfMkg4VyKAXr8U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Q8zRhgvNftHKyN+cEoaR73ncscjnWXVj8UwvIlWYZFqba5nG8F353SpLLRPG+yaGosEFHeZiHBcuzn45MDkH4IqKekWjTUBu2uLVKrbN8btubLNGBgZV9rLCef0OfUPwfCdMSy5+l/gt0+GWHLzvjn5lPjTIHMGeX8SUlmtgqOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6630d58662aso11395571eaf.0
        for <syzbot@lists.linux.dev>; Fri, 06 Feb 2026 10:06:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770401168; x=1771005968;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uREq6rOyLzalGM6iq926bjnPQ161CJntuG88vA0zo8M=;
        b=vk34lCTVFLVR0XYVwzmbRjRF98iHPWJx1xWWfdwNSdTI3jAHXeCKGEbcQ+L6UNU0EN
         6uEkTeykPLcZtjvHlqSTqD3Z6bWERGUZKfGSOTy1CzKyYyGENoUVfs2Cz4XGYhagn91U
         aGXJGC2eGMTCu7Urrymo2waNiO2Eu0srF+sQcuAW21pxtOzMIlC46qTSS1MoUIczYktc
         JY5aV/o6UIdunuk2OUo2Q72Oaj7REDSUqa3cRVYJvA+4i+FMdjF3Py1m0Ui0TwO+37w0
         N6pcQOvsuwZ19mSU+WDND1SpJuPHQbOTVzahcbgzgbCl/S2s4CvGN889WbJIOp2wzYw3
         lkeg==
X-Gm-Message-State: AOJu0YxmJ9MDOh4a7jJeKJf3223Ef82xuaoqR3+F7zjLHVW1iUvRvTqD
	Pj+7WaKxyk0kaPiUF8fkshav9/SBBW/fO7POUIaAuYM8OMZRuis5bjOwoakZXXvZo3zOmKCLJWS
	f6sM9a3ER2j+yukOO8EkxUy19Nc2mSVZzVOsS1NfMg4XBo9QpSG7fq4/yPPU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4ccb:b0:66a:1886:e4dd with SMTP id
 006d021491bc7-66d0bcb986cmr1749872eaf.45.1770401167885; Fri, 06 Feb 2026
 10:06:07 -0800 (PST)
Date: Fri, 06 Feb 2026 10:06:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69862d8f.050a0220.3b3015.0043.GAE@google.com>
Subject: [moderation/CI] Re: mm: map maximum pages possible in finish_fault
From: syzbot ci <syzbot+ci1beb1ef26018f006@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: map maximum pages possible in finish_fault
https://lore.kernel.org/all/20260206135648.38164-1-dev.jain@arm.com
* [PATCH] mm: map maximum pages possible in finish_fault

and found the following issue:
WARNING in folio_add_file_rmap_ptes

Full report is available here:
https://ci.syzbot.org/series/72be5e3b-2ee7-4758-9574-5c09e110d6d0

***

WARNING in folio_add_file_rmap_ptes

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      7235a985b8126d891dbd4e7f20546ff3002b6363
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7bf34a11-2b89-440d-9047-d9a8b7d52cb=
c/config
C repro:   https://ci.syzbot.org/findings/b307b537-ffd9-403f-b188-852c8f39b=
e62/c_repro
syz repro: https://ci.syzbot.org/findings/b307b537-ffd9-403f-b188-852c8f39b=
e62/syz_repro

------------[ cut here ]------------
nr_pages <=3D 0
WARNING: ./include/linux/rmap.h:349 at __folio_rmap_sanity_checks include/l=
inux/rmap.h:349 [inline], CPU#0: syz.0.17/5977
WARNING: ./include/linux/rmap.h:349 at __folio_add_rmap mm/rmap.c:1350 [inl=
ine], CPU#0: syz.0.17/5977
WARNING: ./include/linux/rmap.h:349 at __folio_add_file_rmap mm/rmap.c:1696=
 [inline], CPU#0: syz.0.17/5977
WARNING: ./include/linux/rmap.h:349 at folio_add_file_rmap_ptes+0x98a/0xe60=
 mm/rmap.c:1722, CPU#0: syz.0.17/5977
Modules linked in:
CPU: 0 UID: 0 PID: 5977 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__folio_rmap_sanity_checks include/linux/rmap.h:349 [inline]
RIP: 0010:__folio_add_rmap mm/rmap.c:1350 [inline]
RIP: 0010:__folio_add_file_rmap mm/rmap.c:1696 [inline]
RIP: 0010:folio_add_file_rmap_ptes+0x98a/0xe60 mm/rmap.c:1722
Code: 0b 90 e9 4c f7 ff ff e8 84 d1 ab ff 48 89 df 48 c7 c6 e0 44 9a 8b e8 =
d5 3e 11 ff 90 0f 0b 90 e9 9d f7 ff ff e8 67 d1 ab ff 90 <0f> 0b 90 e9 b2 f=
7 ff ff e8 59 d1 ab ff 49 ff cf e9 ea f7 ff ff e8
RSP: 0018:ffffc90003f675f0 EFLAGS: 00010293
RAX: ffffffff8216c889 RBX: ffffea000412fa00 RCX: ffff8881170c3a80
RDX: 0000000000000000 RSI: 00000000fb412000 RDI: 0000000000000001
RBP: 00000000fb412000 R08: f888304bee000000 R09: 1ffffd4000825f46
R10: dffffc0000000000 R11: fffff94000825f47 R12: dffffc0000000000
R13: ffffea000412fa30 R14: ffffea000412fa00 R15: 0000000000104be8
FS:  0000555589649500(0000) GS:ffff88818e324000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000040 CR3: 0000000114846000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 set_pte_range+0x538/0x8a0 mm/memory.c:5526
 finish_fault+0xec7/0x1290 mm/memory.c:5668
 do_read_fault mm/memory.c:5808 [inline]
 do_fault mm/memory.c:5938 [inline]
 do_pte_missing+0x216f/0x3210 mm/memory.c:4479
 handle_pte_fault mm/memory.c:6322 [inline]
 __handle_mm_fault mm/memory.c:6460 [inline]
 handle_mm_fault+0x1b8c/0x32b0 mm/memory.c:6629
 do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1387
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0010:rep_movs_alternative+0x51/0x90 arch/x86/lib/copy_user_64.S:81
Code: 84 00 00 00 00 00 0f 1f 00 48 8b 06 48 89 07 48 83 c6 08 48 83 c7 08 =
83 e9 08 74 db 83 f9 08 73 e8 eb c5 eb 05 c3 cc cc cc cc <48> 8b 06 48 89 0=
7 48 8d 47 08 48 83 e0 f8 48 29 f8 48 01 c7 48 01
RSP: 0018:ffffc90003f67cf8 EFLAGS: 00010202
RAX: 00007ffffffff001 RBX: 0000000000000050 RCX: 0000000000000050
RDX: 0000000000000001 RSI: 0000200000000040 RDI: ffffc90003f67d60
RBP: ffffc90003f67eb8 R08: ffffc90003f67daf R09: 1ffff920007ecfb5
R10: dffffc0000000000 R11: fffff520007ecfb6 R12: dffffc0000000000
R13: 0000000000000050 R14: ffffc90003f67d60 R15: 0000200000000040
 copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
 raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
 _inline_copy_from_user include/linux/uaccess.h:185 [inline]
 _copy_from_user+0x7a/0xb0 lib/usercopy.c:18
 copy_from_user include/linux/uaccess.h:223 [inline]
 copy_from_bpfptr_offset include/linux/bpfptr.h:53 [inline]
 copy_from_bpfptr include/linux/bpfptr.h:59 [inline]
 __sys_bpf+0x229/0x920 kernel/bpf/syscall.c:6137
 __do_sys_bpf kernel/bpf/syscall.c:6274 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6272 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6272
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4fb5d9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe24ca9848 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f4fb6015fa0 RCX: 00007f4fb5d9acb9
RDX: 0000000000000050 RSI: 0000200000000040 RDI: 0000000000000000
RBP: 00007f4fb5e08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4fb6015fac R14: 00007f4fb6015fa0 R15: 00007f4fb6015fa0
 </TASK>
----------------
Code disassembly (best guess):
   0:	84 00                	test   %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 00                	add    %al,(%rax)
   6:	0f 1f 00             	nopl   (%rax)
   9:	48 8b 06             	mov    (%rsi),%rax
   c:	48 89 07             	mov    %rax,(%rdi)
   f:	48 83 c6 08          	add    $0x8,%rsi
  13:	48 83 c7 08          	add    $0x8,%rdi
  17:	83 e9 08             	sub    $0x8,%ecx
  1a:	74 db                	je     0xfffffff7
  1c:	83 f9 08             	cmp    $0x8,%ecx
  1f:	73 e8                	jae    0x9
  21:	eb c5                	jmp    0xffffffe8
  23:	eb 05                	jmp    0x2a
  25:	c3                   	ret
  26:	cc                   	int3
  27:	cc                   	int3
  28:	cc                   	int3
  29:	cc                   	int3
* 2a:	48 8b 06             	mov    (%rsi),%rax <-- trapping instruction
  2d:	48 89 07             	mov    %rax,(%rdi)
  30:	48 8d 47 08          	lea    0x8(%rdi),%rax
  34:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  38:	48 29 f8             	sub    %rdi,%rax
  3b:	48 01 c7             	add    %rax,%rdi
  3e:	48                   	rex.W
  3f:	01                   	.byte 0x1


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org anshuman.khandual@arm.com david@kernel.org dev.j=
ain@arm.com kirill@shutemov.name liam.howlett@oracle.com linux-kernel@vger.=
kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.com rp=
pt@kernel.org ryan.roberts@arm.com surenb@google.com vbabka@suse.cz willy@i=
nfradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

