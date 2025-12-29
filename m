Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF0F2264A9
	for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 10:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767003675; cv=none; b=DpEIpzSpU23++rRMbkQMPlJlvvEyJOLmdGzc8NK1p3MSNLPaMhLO8I0Ti951Qe6GKwU6MmmMpIdHm73QnWkI+5TJMevWK/T1kHOMp1U9zoAPCqke1wxBr1D36y2SKBQ4NbnSomEHbjjCc20tu/H8Wmc0+pvCYeewFt8dWb5/fhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767003675; c=relaxed/simple;
	bh=dBCMYsDpmAE7+tuKNWkAP5n75sQkUyW10a5YxwNG6tQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=HLYNXG21j82OaiLIIGCd9l27Uh36vsMj0n7tK0lzfbzinsuR+oS99/PuIeowvDuuVP0sNU6eraF2MDiN5cWu6Ra6bzJEZnFZM3EFGFOmjQNDLYYEvcoHqcyDgnqeh8X4dpkXGSmd1NdweCo+itxp372Jz5aEHGltdDrF0KdgnaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7c7046514a2so8375129a34.0
        for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 02:21:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767003672; x=1767608472;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ox/JblUcwCOD3ZgrWg9WrGCpSYzfvgdXBXhPwxfKuIE=;
        b=c9c1JwQQO7HTI0mqQgB8jzUJDnp5lzF7TPCl3IRbfP/RoMNJUXJPe/EOOJ/AGDbEWY
         Xd1K2+L+v9GTjrpuJ3zwpkiHtJIt1IxpPXYLZM4cDIZ/9Lwto0IOBdzFYBWnrE/vLhuG
         OXWb0Ps7NlgvJSWDFNu9dfxShjX6fzEyWllfPOOsnucuYa8LTasZbDEQMiQIjO5Pv2oG
         E3k31D3GqswsPqlrt9X4ipAU4eZgpfTC4mFDOP3n9YpwtxcH/C4TjumgQ9YieUjN3Y5G
         dw04kZ+9tQtoDwkx2TJUAyAmKAAuHwnoQExcPHptyVSXLy2jt/sM/1p40t7X07l7+hIp
         u8zA==
X-Gm-Message-State: AOJu0YxJAvzV49VoGKTZEeAqH3th5PtuEzb5j/gNkhjlgVnwuBWsyb+Z
	omyosZUdABvw1WjoGktQVQEv6RV9+jbd6aAJ1fkbuhL1+y5eUjZWwjXlB7keYAiaqAC75ewrdVB
	UGUr1JVYOv55x/4iT6CbQXs48Z7WdpIwbtKgkW6W6AgWMQdw/T3JQOBbOabk=
X-Google-Smtp-Source: AGHT+IFpWCdL4QrEBSygiVaHr4fo6u1s6eHPbXeWm+VlW7aCSUqPVhYeV8lwJAV9yWeuo8qMVDlOXxenUqwlRmyHrJRbuMalMSZS
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca1:b0:65b:387a:8362 with SMTP id
 006d021491bc7-65d0eb56659mr13532225eaf.55.1767003672640; Mon, 29 Dec 2025
 02:21:12 -0800 (PST)
Date: Mon, 29 Dec 2025 02:21:12 -0800
In-Reply-To: <20251229055151.54887-1-yanglincheng@kylinos.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69525618.a70a0220.c527.0026.GAE@google.com>
Subject: [syzbot ci] Re: Improve khugepaged scan logic
From: syzbot ci <syzbot+ci74fd370f54089b9b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, david@kernel.org, 
	dev.jain@arm.com, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, richard.weiyang@gmail.com, 
	vernon2gm@gmail.com, yanglincheng@kylinos.cn, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] Improve khugepaged scan logic
https://lore.kernel.org/all/20251229055151.54887-1-yanglincheng@kylinos.cn
* [PATCH v2 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
* [PATCH v2 2/4] mm: khugepaged: just skip when the memory has been collapsed
* [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when MADV_COLD/MADV_FREE
* [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY

and found the following issue:
WARNING in madvise_dontneed_free

Full report is available here:
https://ci.syzbot.org/series/f936dff1-2423-4f46-a59a-ea041c1d741a

***

WARNING in madvise_dontneed_free

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      33b485bade996a9d0154cf0888b7a5c23723121e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/81f62216-5094-4281-a942-238b7448a3be/config
C repro:   https://ci.syzbot.org/findings/e308c3a0-c806-45c4-bc1c-24536a3c3ca3/c_repro
syz repro: https://ci.syzbot.org/findings/e308c3a0-c806-45c4-bc1c-24536a3c3ca3/syz_repro

------------[ cut here ]------------
WARNING: mm/madvise.c:795 at get_walk_lock mm/madvise.c:795 [inline], CPU#0: syz.0.17/5977
WARNING: mm/madvise.c:795 at madvise_free_single_vma mm/madvise.c:830 [inline], CPU#0: syz.0.17/5977
WARNING: mm/madvise.c:795 at madvise_dontneed_free+0xb52/0xe10 mm/madvise.c:960, CPU#0: syz.0.17/5977
Modules linked in:
CPU: 0 UID: 0 PID: 5977 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:get_walk_lock mm/madvise.c:795 [inline]
RIP: 0010:madvise_free_single_vma mm/madvise.c:830 [inline]
RIP: 0010:madvise_dontneed_free+0xb52/0xe10 mm/madvise.c:960
Code: c7 c6 b0 6e 25 8e e8 7d 4c a3 ff 48 83 fb 01 74 0c 83 fb 03 75 0e e8 ed 46 a3 ff eb 12 e8 e6 46 a3 ff eb 09 e8 df 46 a3 ff 90 <0f> 0b 90 31 db 89 9c 24 08 01 00 00 48 8b 74 24 68 48 8b 54 24 70
RSP: 0018:ffffc90004a17400 EFLAGS: 00010293
RAX: ffffffff821e7411 RBX: 0000000000000002 RCX: ffff888169b7d7c0
RDX: 0000000000000000 RSI: ffffffff8e256eb0 RDI: 0000000000000002
RBP: ffffc90004a175b0 R08: ffff888169b7d7c0 R09: 0000000000000002
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000100 R15: 1ffff92000942e88
FS:  0000555555761500(0000) GS:ffff88818e62f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe49d72b600 CR3: 00000001b85b6000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 madvise_vma_behavior+0xd57/0x3680 mm/madvise.c:1385
 madvise_walk_vmas+0x575/0xaf0 mm/madvise.c:1730
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1944
 do_madvise+0x1bc/0x270 mm/madvise.c:2037
 __do_sys_madvise mm/madvise.c:2046 [inline]
 __se_sys_madvise mm/madvise.c:2044 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:2044
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe49d78f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff39cea178 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fe49d9e5fa0 RCX: 00007fe49d78f7c9
RDX: 0000000000000008 RSI: 0000000000600002 RDI: 0000200000000000
RBP: 00007fe49d7f297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe49d9e5fa0 R14: 00007fe49d9e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
