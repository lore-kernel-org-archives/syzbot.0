Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3083F363C74
	for <syzbot@lists.linux.dev>; Fri,  1 May 2026 11:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777635706; cv=none; b=ZifXUaWvLxCbsyHtuDcJG9gsH5Nogn8N55biXP+zPMEuyydT/01jN8cCdJ8D8Pp9K17mPrJvtmYS1TxSuu4j5fdjqKtpUfGeSzk8qIBAmGfcWZLpSuQbD9wcD4PtbaK+5lfJZroRFTuAfSzWcVWqnPVE5TJjg9XS9bqcAQipoMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777635706; c=relaxed/simple;
	bh=YYbX7+harpsulRD/Gis6RxAHwpL3P9OxYWPyjS4FRJo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=c2PCM5omUrU9JDmXDzYm7rVgpKT40FTDz4xf8NqLigxfcuUjR9sXYTal1Qf/Sftl32BIUbYwnLOtrrr9bjlcKT9wS8hx8Jh7RFm/OP8wa7xm/ydm0KE8mYvAtD6YYrpGQudWOJVDlBbbuS4eDws4lmFOC5qCZIqcE9IXNnzyGlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7dbbb806e10so3889342a34.1
        for <syzbot@lists.linux.dev>; Fri, 01 May 2026 04:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777635704; x=1778240504;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=brrMHuN8oNtpBKa5oSAMBoax/OnBYKWERfGCIMxFp9w=;
        b=mAY+ht9U5VwK1YPbeVFm6EA6ht0anUNjH46acwlKFYya99L3qIm5EXbIBzL4GxJUKy
         tz+jxBEH+oGYhgBAux+AbmhZqAjrvn8l8h0N20zj7J9gx1u+6nO8mSNdSQhgZL1ih773
         Y/9sYWbBmyhsi9YnIVgDc8FtMMPcNBXZgR7UqNsm1iZMyZfooTxqV/SHeVhzVZ3pmjnr
         huuOsltFxrtgZG+76NhCulxbu4OCNGq+gJFAtAM1gNvlrH9KY/7Q2QSHUHzp4BhQq6Gg
         lmVsRnKI02pd4UbPAKiTnh1kckjduBpcwQUPiR9T7zegz5QGJuIxoz9YF4ItiCXnfCYC
         9/IQ==
X-Gm-Message-State: AOJu0YymTeGCRu9Zu62FUNeSZJ2UohsYnkguSY+F1v+2GaUEpNaM7R5y
	a47Sv2BXPodBalVqGSjFYMYws0ttMd02MfV9AGeMMkqMEu8dBynLCmx37exGeblAHhDDWdeoRip
	BJDGva4V5CDCMxH/eG7HjYfuHl2ZIhrZqq7676i25qUx8FBrKdF7u0uLyNNQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f12:b0:694:8f3a:3f36 with SMTP id
 006d021491bc7-6968bbf99cdmr1042570eaf.27.1777635704274; Fri, 01 May 2026
 04:41:44 -0700 (PDT)
Date: Fri, 01 May 2026 04:41:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f49178.050a0220.3cbe47.000b.GAE@google.com>
Subject: [moderation/CI] Re: mm: Support selecting doing direct COW for
 anonymous pmd entry
From: syzbot ci <syzbot+ci7e654742b9b7a582@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: Support selecting doing direct COW for anonymous pmd entry
https://lore.kernel.org/all/20260501-thp_cow-v1-0-005377483738@tencent.com
* [PATCH 1/5] mm: add basic madvise helpers and branch for THP setup
* [PATCH 2/5] mm: add pmd level THP COW parameter in sysfs
* [PATCH 3/5] mm: add pmd level THP COW judgement helpers
* [PATCH 4/5] mm: enable map_anon_folio_pmd_nopf to handle unshare
* [PATCH 5/5] mm: support choosing to do THP COW for anonymous pmd entry.

and found the following issue:
general protection fault in __page_table_check_pmds_set

Full report is available here:
https://ci.syzbot.org/series/37e78e03-c08b-4de1-9b07-a21c64f4f462

***

general protection fault in __page_table_check_pmds_set

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      41cd9e3d23b8fd9e6c3c0311e9cb0304442c6141
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/fcdd679f-29e8-43db-8792-d4fd97c62d9=
1/config
syz repro: https://ci.syzbot.org/findings/87820d58-5d91-4c2e-b80b-5a75006e2=
30d/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5807 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__page_table_check_pmds_set+0x1d4/0x340 mm/page_table_check.c:240
Code: 00 00 4c 89 6c 24 08 4c 89 3c 24 4a 8d 2c fd f8 ff ff ff 31 db 49 bf =
00 00 00 00 00 fc ff df 49 8d 3c 1e 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 7=
4 05 e8 00 29 f4 ff 4d 8b 24 1e 45 89 e5 41 81 e5
RSP: 0018:ffffc90003c46ee0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8881102a1d80 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000001 R09: 1ffff110242081d8
R10: dffffc0000000000 R11: ffffed10242081d9 R12: dffffc0000000000
R13: 0000000025c008e7 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fbef78216c0(0000) GS:ffff88818dc91000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32f63fff CR3: 000000002350a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 page_table_check_pmds_set include/linux/page_table_check.h:92 [inline]
 set_pmd_at arch/x86/include/asm/pgtable.h:1209 [inline]
 map_anon_folio_pmd_nopf+0x452/0x480 mm/huge_memory.c:1449
 collapse_huge_page mm/khugepaged.c:1411 [inline]
 mthp_collapse mm/khugepaged.c:1530 [inline]
 collapse_scan_pmd mm/khugepaged.c:1773 [inline]
 collapse_single_pmd+0x4691/0x5540 mm/khugepaged.c:2786
 madvise_collapse+0x300/0x7a0 mm/khugepaged.c:3218
 madvise_vma_behavior+0x11b0/0x4210 mm/madvise.c:1383
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1738
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1954
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2047
 __do_sys_madvise mm/madvise.c:2056 [inline]
 __se_sys_madvise mm/madvise.c:2054 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2054
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbef699cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbef7821028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fbef6c15fa0 RCX: 00007fbef699cdd9
RDX: 0000000000000019 RSI: 0000000000400000 RDI: 0000200000000000
RBP: 00007fbef6a32d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbef6c16038 R14: 00007fbef6c15fa0 R15: 00007ffdddd640f8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__page_table_check_pmds_set+0x1d4/0x340 mm/page_table_check.c:240
Code: 00 00 4c 89 6c 24 08 4c 89 3c 24 4a 8d 2c fd f8 ff ff ff 31 db 49 bf =
00 00 00 00 00 fc ff df 49 8d 3c 1e 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 7=
4 05 e8 00 29 f4 ff 4d 8b 24 1e 45 89 e5 41 81 e5
RSP: 0018:ffffc90003c46ee0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8881102a1d80 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000001 R09: 1ffff110242081d8
R10: dffffc0000000000 R11: ffffed10242081d9 R12: dffffc0000000000
R13: 0000000025c008e7 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fbef78216c0(0000) GS:ffff88818dc91000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32f63fff CR3: 000000002350a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	4c 89 6c 24 08       	mov    %r13,0x8(%rsp)
   7:	4c 89 3c 24          	mov    %r15,(%rsp)
   b:	4a 8d 2c fd f8 ff ff 	lea    -0x8(,%r15,8),%rbp
  12:	ff
  13:	31 db                	xor    %ebx,%ebx
  15:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  1c:	fc ff df
  1f:	49 8d 3c 1e          	lea    (%r14,%rbx,1),%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruct=
ion
  2f:	74 05                	je     0x36
  31:	e8 00 29 f4 ff       	call   0xfff42936
  36:	4d 8b 24 1e          	mov    (%r14,%rbx,1),%r12
  3a:	45 89 e5             	mov    %r12d,%r13d
  3d:	41                   	rex.B
  3e:	81                   	.byte 0x81
  3f:	e5                   	.byte 0xe5


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org arnd@arndb.de baohua@kernel.org baolin.wang@linu=
x.alibaba.com corbet@lwn.net david@kernel.org dev.jain@arm.com jannh@google=
.com kasong@tencent.com lance.yang@linux.dev liam@infradead.org linux-arch@=
vger.kernel.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linu=
x-mm@kvack.org ljs@kernel.org lukabai@tencent.com lukafocus@icloud.com mhoc=
ko@suse.com npache@redhat.com rppt@kernel.org ryan.roberts@arm.com skhan@li=
nuxfoundation.org surenb@google.com vbabka@kernel.org ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

