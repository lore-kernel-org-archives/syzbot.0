Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252EE221558
	for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 11:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759230629; cv=none; b=r6F5GZyZBVwILc0wEEZOuVdcH+eKyOrpxAKAYXh9Pq48k2aWAlCmhrR3vsY3SZc5bpKXSqeZMIu4Deyck/gTXM37C7/GCfLs582lkN7i9LhR5sHys2aa6vC1AyeIj38ZdLIr45sJb3PFW720yhyactBl5CpsIoZrC6RB8Scqarg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759230629; c=relaxed/simple;
	bh=Jg6HcQRgTk4b1JCcVGk5k9PKkh4F8GcWzqtH61P0cAk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=s0rr+aCadtMiAgGmbaMEyHhe6FW+4C+tO4zx84fSNH9P+2uGGk+aZ/A/YSaBAogyZ3HrPo1NvHOxBxcuGtyCcCUARJhYtb7u5+8iu/+8/ha0f1YE4ViaWPylzLJ2WMP5pHWi71BCSK30DbOIClFjMep9btUyOXktq02g8bLvxO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88c2f1635e1so594759339f.0
        for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 04:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759230625; x=1759835425;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qr5DOGEJoQ86bZMIFFTCDF6OtUQR6eGTFpAiWiqpIs8=;
        b=vBzVBRqxxTrv7Pof9bkxgcvwGL0bLvZOzoQAilOsxmIEvixEJ7vpsVD1CEGAqf8IAz
         b8wr4dUCuMHbDquUd8ccLM9fIxLavwfmZ1FPqphAZcfGDDRCQff4JpTIJAbsFZUa3ZEL
         UnrUD9xdsB4FcVBh7M77qbmoqEe3z5PtFjxA4lJCGIr4yya+NqmoosTd5aQx5qC/n0IA
         HA0K3c2A4VyOsLzlyNy4YNi+eyk/FS1tm7O6udWVC2+NmcSpH0XQEQClu7vV+prs3Ojh
         maf7LEt99v/yZl2gJXut3YPECGdCM7eXogxbrWpvbs130iE5Zo/gyBrDsWGyvFhfyV1j
         lIXA==
X-Gm-Message-State: AOJu0YzbN/jddJhAXOyqWjxRaoz+/yKhc9z71VqZyVvzAGo5QYjg/Mk2
	p2uvnw+pThRz6PZtgulpei57UKUo02Cs9ErvDsxW2DvhRmMfzB8GK4gjLrWtzgnaGuS79v50KCN
	C97ypFYh6jNEmcUKyeyQRwCWw9aREoGUuxUG/tp9NdoYgZgFgEpGrqUSptJI=
X-Google-Smtp-Source: AGHT+IESEIy+6qoyQBvL0Fr60MNtQ1+awA5X64bN8+7XvDNghvwCD/XrprersvblZ6xE/aXemCgv9q6NV3pOr7u5M8zVrv/zBwrI
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:170a:b0:428:7ace:e591 with SMTP id
 e9e14a558f8ab-4287acefcb0mr143233785ab.16.1759230625229; Tue, 30 Sep 2025
 04:10:25 -0700 (PDT)
Date: Tue, 30 Sep 2025 04:10:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dbbaa1.a70a0220.10c4b.0154.GAE@google.com>
Subject: [moderation/CI] Re: mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
From: syzbot ci <syzbot+ci8409f4b8a5a5f1bf@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-fille=
d mTHP subpage to shared zeropage
https://lore.kernel.org/all/20250930071053.36158-1-lance.yang@linux.dev
* [PATCH v4 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remappin=
g zero-filled mTHP subpage to shared zeropage

and found the following issue:
general protection fault in remove_migration_pte

Full report is available here:
https://ci.syzbot.org/series/8cc7e52f-a859-4251-bd08-9787cdaf7928

***

general protection fault in remove_migration_pte

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      262858079afde6d367ce3db183c74d8a43a0e83f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/97ee4826-5d29-472d-a85d-51543b0e45d=
e/config
C repro:   https://ci.syzbot.org/findings/f4819db2-21f2-4280-8bc4-942445398=
953/c_repro
syz repro: https://ci.syzbot.org/findings/f4819db2-21f2-4280-8bc4-942445398=
953/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 6025 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
RIP: 0010:remove_migration_pte+0x369/0x2320 mm/migrate.c:352
Code: 00 48 8d 43 20 48 89 44 24 68 49 8d 47 40 48 89 84 24 e8 00 00 00 4c =
89 64 24 48 4c 8b b4 24 50 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 7=
4 08 4c 89 f7 e8 f8 3e ff ff 49 8b 06 48 89 44 24
RSP: 0018:ffffc90002fb73e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88802957e300 RCX: 1ffffd40008c9006
RDX: 0000000000000000 RSI: 0000000000030dff RDI: 0000000000030c00
RBP: ffffc90002fb75d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520005f6e34 R12: ffffea0004648008
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004648000
FS:  00005555624de500(0000) GS:ffff8880b83fc000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000300 CR3: 000000010d8b8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 rmap_walk_anon+0x553/0x730 mm/rmap.c:2855
 remove_migration_ptes mm/migrate.c:469 [inline]
 migrate_folio_move mm/migrate.c:1381 [inline]
 migrate_folios_move mm/migrate.c:1711 [inline]
 migrate_pages_batch+0x202e/0x35e0 mm/migrate.c:1967
 migrate_pages_sync mm/migrate.c:1997 [inline]
 migrate_pages+0x1bcc/0x2930 mm/migrate.c:2106
 migrate_to_node mm/mempolicy.c:1244 [inline]
 do_migrate_pages+0x5ee/0x800 mm/mempolicy.c:1343
 kernel_migrate_pages mm/mempolicy.c:1858 [inline]
 __do_sys_migrate_pages mm/mempolicy.c:1876 [inline]
 __se_sys_migrate_pages+0x544/0x650 mm/mempolicy.c:1872
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb18e18ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdca5c9838 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
RAX: ffffffffffffffda RBX: 00007fb18e3d5fa0 RCX: 00007fb18e18ec29
RDX: 0000200000000300 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 00007fb18e211e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000040 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb18e3d5fa0 R14: 00007fb18e3d5fa0 R15: 0000000000000004
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
RIP: 0010:remove_migration_pte+0x369/0x2320 mm/migrate.c:352
Code: 00 48 8d 43 20 48 89 44 24 68 49 8d 47 40 48 89 84 24 e8 00 00 00 4c =
89 64 24 48 4c 8b b4 24 50 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 7=
4 08 4c 89 f7 e8 f8 3e ff ff 49 8b 06 48 89 44 24
RSP: 0018:ffffc90002fb73e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88802957e300 RCX: 1ffffd40008c9006
RDX: 0000000000000000 RSI: 0000000000030dff RDI: 0000000000030c00
RBP: ffffc90002fb75d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520005f6e34 R12: ffffea0004648008
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004648000
FS:  00005555624de500(0000) GS:ffff8880b83fc000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000300 CR3: 000000010d8b8000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	00 48 8d             	add    %cl,-0x73(%rax)
   3:	43 20 48 89          	rex.XB and %cl,-0x77(%r8)
   7:	44 24 68             	rex.R and $0x68,%al
   a:	49 8d 47 40          	lea    0x40(%r15),%rax
   e:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  15:	00
  16:	4c 89 64 24 48       	mov    %r12,0x48(%rsp)
  1b:	4c 8b b4 24 50 01 00 	mov    0x150(%rsp),%r14
  22:	00
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruct=
ion
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 f8 3e ff ff       	call   0xffff3f31
  39:	49 8b 06             	mov    (%r14),%rax
  3c:	48                   	rex.W
  3d:	89                   	.byte 0x89
  3e:	44                   	rex.R
  3f:	24                   	.byte 0x24


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org apopple@nvidia.com baohua@kernel.org baolin.wang=
@linux.alibaba.com byungchul@sk.com david@redhat.com dev.jain@arm.com gourr=
y@gourry.net harry.yoo@oracle.com ioworker0@gmail.com jannh@google.com josh=
ua.hahnjy@gmail.com lance.yang@linux.dev liam.howlett@oracle.com linux-kern=
el@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com matthew.br=
ost@intel.com npache@redhat.com peterx@redhat.com rakie.kim@sk.com riel@sur=
riel.com ryan.roberts@arm.com stable@vger.kernel.org usamaarif642@gmail.com=
 vbabka@suse.cz ying.huang@linux.alibaba.com yuzhao@google.com ziy@nvidia.c=
om]

If the report looks fine to you, reply with:
#syz upstream

