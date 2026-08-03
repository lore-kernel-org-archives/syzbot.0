Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56A033F8C5
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785796589; cv=none; b=BKW75m5L9B8x4Azpx0FeJu3p1SKHEn5CtEbPBx23qSUWhBJjDsICtTLjUVNmLiCryLuznZhkLUiFy4xDxibH7AhGT4FDgj0w7JL8wNhdCtf/87UP2+yyRZMn+sXQGocdCayjaOIpegksjPgLxJThFAfyQR60qTgt7dlVd6Gusmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785796589; c=relaxed/simple;
	bh=92vxIv3M2fGiEQt6F8cwnkyRY0T2hxb/D0Rb6nYrFXE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=F4J7utKM8c4HMdI0WSIjwsC4Ks1ytOEAGyjjv9ivsJY9WhX5yV+qjpWKSxi+ceMtFT7RKuZF/BaVURxo92GsJ/8b9srUgfvNfkyY9eDx1GgOzcZUVTon4Dr15pq42aJX400+izpImXacqccXhLaAXs/ZmsiE815kYXgeCSSKxM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-49d4cb3ca23so5719365b6e.3
        for <syzbot@lists.linux.dev>; Mon, 03 Aug 2026 15:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785796586; x=1786401386;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A/O/8axi+oxA9+wdpwCOnT9D9mfFtijIY9MWs7TjMiY=;
        b=fcL/vX26vokNfW5O6IfyM0tQcoGvFJGfVasfzYZjtrEP7MozhBlZ+UCfPxBp+2j3S3
         mzL0PM8RzYhgsiKDWiXSRJTbMdRN+56ZoukN+NTUKPceCPixRF3FslXjHChCBSLpWaLv
         Eq4KiFWuuZ0NfD4VAueA/7bZL+BEj+gt1A9EZRBbM15+lHN0xthC7bPlzz7sBri6XSva
         t5R58mxNWapgqnwChbvHhY+Hafu+ObZDk9d7UoCA2Rq6by/y2nQ66NcOqHLqJH5WGkFf
         XHWQJ7FRHpe9LPxDTyBHMCSpSHnmoPE3/SlPDwZGErvnohnEJx51ZcqIelbVGfI8jWcb
         GL8A==
X-Gm-Message-State: AOJu0Yx+CjwzkJhkzPpPmELFaC98kG/hni90fPAVP5G9y6U6IFJfDVfc
	LN8ZbMqbo9PWe1k6PmLdG2sJGLjBo5XG0KDSlx3ivvisgh0rVV2ySLtec+qGFV91MEwsrZMr5f2
	lmGN/03pssIT0NvUEnKgyaGIAUNbi7RradIb1OpOH+0tFlv7UTJvYEamAat0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1305:b0:4a3:95f3:68e with SMTP id
 5614622812f47-4af5e0a9efamr20529607b6e.9.1785796586737; Mon, 03 Aug 2026
 15:36:26 -0700 (PDT)
Date: Mon, 03 Aug 2026 15:36:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7117ea.d35e88fd.de8b.0002.GAE@google.com>
Subject: [moderation/CI] Re: mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
From: syzbot ci <syzbot+ci1d3cd18901bb71c1@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
https://lore.kernel.org/all/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com
* [PATCH RFC 01/15] mm/memcontrol: make lru_zone_size atomic and simplify s=
anity check
* [PATCH RFC 02/15] mm/memcontrol: allow update of LRU statistic without ho=
lding LRU lock
* [PATCH RFC 03/15] mm/mglru: introduce and always use helpers for manipula=
ting page flags
* [PATCH RFC 04/15] mm/mglru: make generation page counters atomic
* [PATCH RFC 05/15] mm/mglru: move max_seq read into walk_update_folio
* [PATCH RFC 06/15] mm/mglru: use explicit tier range in read_ctrl_pos()
* [PATCH RFC 07/15] mm/mglru: move refault workingset activation into lru_g=
en_refault
* [PATCH RFC 08/15] mm/memcg: add folio-based lruvec live helper
* [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-=
FG)
* [PATCH RFC 10/15] mm/mglru: make folio lru referenced times count a gener=
ic API
* [PATCH RFC 11/15] mm/mglru: replace folio workinset check and update with=
 new helper
* [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
* [PATCH RFC 13/15] mm/huge_memory: mark file folio as accessed more accura=
tely on split
* [PATCH RFC 14/15] mm/khugepaged: consider workingset folios as referenced
* [PATCH RFC 15/15] mm/madvise: convert to new lru refs API and better supp=
ort for MGLRU

and found the following issue:
WARNING in folio_inc_lru_refs

Full report is available here:
https://ci.syzbot.org/series/5db36d1d-9faa-4882-9f0d-1a8f52132274

***

WARNING in folio_inc_lru_refs

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      94f9b3980dd446b56acf1dfed649e9b32a9f3813
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9f324367-2b95-4fd0-9025-fef1ff1f605=
a/config

page: refcount:3 mapcount:2 mapping:0000000000000000 index:0x0 pfn:0xe4ee
flags: 0xfff00000002000(reserved|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
raw: 00fff00000002000 ffffea0000393b88 ffffea0000393b88 0000000000000000
raw: 0000000000000000 0000000000000000 0000000300000001 0000000000000000
page dumped because: VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled()=
)
page_owner info is not present (never set?)
------------[ cut here ]------------
1
WARNING: ./include/linux/memcontrol.h:745 at folio_inc_lru_refs+0xb4f/0xc10=
, CPU#0: mount/5025
Modules linked in:
CPU: 0 UID: 0 PID: 5025 Comm: mount Not tainted syzkaller #0 PREEMPT(full)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:folio_inc_lru_refs+0xb4f/0xc10
Code: ff 4c 89 e7 e8 c2 ae fd ff e9 e9 fc ff ff e8 18 91 ba ff 4c 89 e7 48 =
c7 c6 20 90 f8 8b e8 99 b0 1b ff c6 05 a6 a9 34 0e 01 90 <0f> 0b 90 e9 85 f=
6 ff ff e8 f4 90 ba ff e9 29 f8 ff ff 44 89 f1 80
RSP: 0018:ffffc9000324f4c0 EFLAGS: 00010246
RAX: 8e914a919570c700 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff8e4b4187 RDI: ffff888174f53c00
RBP: ffffc9000324f5d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1d3ca24 R12: ffffea0000393b80
R13: 1ffffd4000072770 R14: 1ffff92000649ea8 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88818d949000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb77b215440 CR3: 000000000e946000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __zap_vma_range+0x20f5/0x4f70
 unmap_vmas+0x390/0x550
 exit_mmap+0x293/0x9f0
 __mmput+0x118/0x420
 exit_mm+0x221/0x2d0
 do_exit+0x6cd/0x2360
 do_group_exit+0x22d/0x2f0
 __x64_sys_exit_group+0x3f/0x40
 x64_sys_call+0x221a/0x2240
 do_syscall_64+0x174/0x580
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb77b2d3a90
Code: Unable to access opcode bytes at 0x7fb77b2d3a66.
RSP: 002b:00007ffe32d58618 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fb77b3c4860 RCX: 00007fb77b2d3a90
RDX: 00000000000000e7 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007fb77b3c4860 R08: 00007ffe32d58490 R09: 00007ffe32d58570
R10: 00007ffe32d584d0 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fb77b3c8658 R15: 0000000000000001
 </TASK>


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
[akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org baoli=
n.wang@linux.alibaba.com baoquan.he@linux.dev cgroups@vger.kernel.org chenr=
idong@xiaomi.com chrisl@kernel.org david@kernel.org dev.jain@arm.com devnul=
l@kernel.org gourry@gourry.net hannes@cmpxchg.org hughd@google.com kasong@t=
encent.com lance.yang@linux.dev linux-kernel@vger.kernel.org linux-mm@kvack=
.org ljs@kernel.org mhocko@kernel.org muchun.song@linux.dev nico.pache@linu=
x.dev nphamcs@gmail.com qi.zheng@linux.dev rientjes@google.com roman.gushch=
in@linux.dev ryan.roberts@arm.com ryncsn@gmail.com shakeel.butt@linux.dev s=
hikemeng@huaweicloud.com sj@kernel.org surenb@google.com tz2294@columbia.ed=
u usama.arif@linux.dev vbabka@kernel.org vernon2gm@gmail.com wangzicheng@ho=
nor.com weixugc@google.com willy@infradead.org ying.huang@linux.alibaba.com=
 youngjun.park@lge.com yuanchu@google.com yuzhao@google.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

