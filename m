Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BFF254B03
	for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 09:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767002114; cv=none; b=UQ8YzyqqragE+oYuU83lXfeu8LjeHt58WoSRIIUxtkxXw5H5aagKBpYDSvgyqtuawkZBSD8+DVG4VeYAVg7wpGAfdrXuHWZZ3BDVmiSIfQaxVYvgmgHPOwhccyfwdS7VHIlqerFpjYqDtF+Amj2U/5EPsuXpGqp+/k5DFJyW9Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767002114; c=relaxed/simple;
	bh=xLUvS/curr4pH9VdvuTGMdNYs9GvfZ7wVFMm5T1nBnI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=RFZQWzdRbWcerjFa/aCJCfVCdYoNFwSyOEIMgQTxnxy66Nei1WGb5CV0X01ei1RCduWQ0wxaCdW1Ep1viK5koRgChNnz5fcC1ajIPJkJlDJReJr8Lzzd2mm0VGpX1zfdGGiHXVeuMw3vdqA/YoJOerJZo52eEt8TrRo00/ZS3WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7c6d329f19cso19363629a34.1
        for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 01:55:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767002112; x=1767606912;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cvi6P4Fv4JMYGGQx82Lm/K8snRU9Qb6DnOKCWxQ5KLg=;
        b=QGR6N7urG/c8q/2eaktnu+G/2KtMi653iygxW666DLpyB4/3E19H4k8HOWcWFem9ED
         hhwKj1iXy1RdY4XhPSLXOxIhetnNxLWlb6suOOUPWYmfFT4MIKupObTlTmcOzWdJTXvP
         IwoZ2BJGybSNr9PG79QhgcKlcIjDr07qJY/nmxFctsbBNBM7hmDpHJlgjMANkVLG/1Wi
         /QH9FbePvIupa4+kuV8HaEn3mq44G3stIB+rrUCb9QYcdDdGB5Ih7+pG2MgaU4lylA5X
         IKgyNFZs9Jq4I/eyrjyx2Q1ixdfBtCQ39xbeKM30SHdfejRSD9grG4VdLWLORLXd7FEd
         2a0g==
X-Gm-Message-State: AOJu0YwDh5nEYniSJ51l8S6VoGkN/vhNhgE7Ek/kp2WrNQtXuuxheoNN
	JRO1DrBEAWrZqQ6/vyyawgbiH3kbmfKZOYwhU8+PG7Xvhkv2U4Y3urACQnRveGnB9IB5Yhj+wzP
	tbHyG/AYNhp4N9J0WFuTCpaRgTRdbHmNERKyvnEr83lUlIU6uLpLjdJIHt7Y=
X-Google-Smtp-Source: AGHT+IGCr2VofzU8QBAmRw95yxFT/C833R9QKsrY8Nsy/YNa/52AEX2uV8gRpN/YAYcfXCPK9hjq9njhJ/0QENyt21whqna+BYRm
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:162a:b0:659:9a49:8fdd with SMTP id
 006d021491bc7-65d0e932ca5mr13724773eaf.10.1767002111758; Mon, 29 Dec 2025
 01:55:11 -0800 (PST)
Date: Mon, 29 Dec 2025 01:55:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69524fff.a70a0220.90d62.0038.GAE@google.com>
Subject: [moderation/CI] Re: Improve khugepaged scan logic
From: syzbot ci <syzbot+ci5a1dd5603fd894f8@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] Improve khugepaged scan logic
https://lore.kernel.org/all/20251229055151.54887-1-yanglincheng@kylinos.cn
* [PATCH v2 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
* [PATCH v2 2/4] mm: khugepaged: just skip when the memory has been collaps=
ed
* [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when MADV_COLD/MADV=
_FREE
* [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has MMF_DISA=
BLE_THP_COMPLETELY

and found the following issue:
WARNING in madvise_dontneed_free

Full report is available here:
https://ci.syzbot.org/series/f936dff1-2423-4f46-a59a-ea041c1d741a

***

WARNING in madvise_dontneed_free

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      33b485bade996a9d0154cf0888b7a5c23723121e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/81f62216-5094-4281-a942-238b7448a3b=
e/config
C repro:   https://ci.syzbot.org/findings/e308c3a0-c806-45c4-bc1c-24536a3c3=
ca3/c_repro
syz repro: https://ci.syzbot.org/findings/e308c3a0-c806-45c4-bc1c-24536a3c3=
ca3/syz_repro

------------[ cut here ]------------
WARNING: mm/madvise.c:795 at get_walk_lock mm/madvise.c:795 [inline], CPU#0=
: syz.0.17/5977
WARNING: mm/madvise.c:795 at madvise_free_single_vma mm/madvise.c:830 [inli=
ne], CPU#0: syz.0.17/5977
WARNING: mm/madvise.c:795 at madvise_dontneed_free+0xb52/0xe10 mm/madvise.c=
:960, CPU#0: syz.0.17/5977
Modules linked in:
CPU: 0 UID: 0 PID: 5977 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:get_walk_lock mm/madvise.c:795 [inline]
RIP: 0010:madvise_free_single_vma mm/madvise.c:830 [inline]
RIP: 0010:madvise_dontneed_free+0xb52/0xe10 mm/madvise.c:960
Code: c7 c6 b0 6e 25 8e e8 7d 4c a3 ff 48 83 fb 01 74 0c 83 fb 03 75 0e e8 =
ed 46 a3 ff eb 12 e8 e6 46 a3 ff eb 09 e8 df 46 a3 ff 90 <0f> 0b 90 31 db 8=
9 9c 24 08 01 00 00 48 8b 74 24 68 48 8b 54 24 70
RSP: 0018:ffffc90004a17400 EFLAGS: 00010293
RAX: ffffffff821e7411 RBX: 0000000000000002 RCX: ffff888169b7d7c0
RDX: 0000000000000000 RSI: ffffffff8e256eb0 RDI: 0000000000000002
RBP: ffffc90004a175b0 R08: ffff888169b7d7c0 R09: 0000000000000002
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000100 R15: 1ffff92000942e88
FS:  0000555555761500(0000) GS:ffff88818e62f000(0000) knlGS:000000000000000=
0
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
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
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

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org david@kernel.org dev.jain@arm.=
com lance.yang@linux.dev linux-kernel@vger.kernel.org linux-mm@kvack.org lo=
renzo.stoakes@oracle.com richard.weiyang@gmail.com vernon2gm@gmail.com yang=
lincheng@kylinos.cn ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

