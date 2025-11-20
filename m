Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8057022F386
	for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 05:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763616070; cv=none; b=LiaIUYDUtGeNESUioBJiK7pTgWr8PM5V3Kzpb/PDCWkZSUPERrwrgDKAK7XI5PpxZMb+yKLvfsiw3iqqw06heyI8ezAIW4DjrtwvZDOAu34A+DKoLb7VbOA5rBF8j/0SyKfEYtbgZY7TjOYxpum0pHznvVkMcRpxGR+4GOpmtMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763616070; c=relaxed/simple;
	bh=xNsc+7TB+y/97iHZijt66v7fnqPM5UlxdeV3fOmAKak=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=pxUJs9c9J5o2yfxXzEYuQDiiT1/0rrY8iI8hku/Kv4TQk2Luiu+r9HvsQ7LmvYF20fSy1AZcqol4OclYIiMkje2RgIa4HDxuz8muVhUGFdxmneOmJ2dXA7o0JLpuccGVIDLe1/SW3cYR2b4Te0yVsKDvBnP/MCmCycJi6ZyNQb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9489a3f6e3dso34951739f.0
        for <syzbot@lists.linux.dev>; Wed, 19 Nov 2025 21:21:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763616065; x=1764220865;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zV8swJNG+UWrgoun7qyT+AXI9canhAjpEOvcjHkgNrc=;
        b=QjHbrY2jvvdk513H1lZWa8ARwwIh3G3vslyv/cILLyuT2gzhV8kMfrgiy0+QCjvSPr
         ZvUM1RTJy61s2GA+kpqy7T2xLh8FuchBS97i5E+OTH2hOuIedYVpC65AgXeD3M7Apgkf
         hllAnrWA9v2HBUO8Rqh6PHNul0N5lvICVQXvTYWQo4bAmc/JgvcIWH+op3Vl8m5MeMD1
         Es9Y2wQq8A0Z4u7Xc0nffjp2NDq3j2C5MY8DuVj+tzBsm3F63pKRfrO/3siY57PN11hO
         swgZQnxKbyf/Y9YbVLstv5JCmk1r+Ct3a8tBMvrz+VV3ym/uLneJSjnxiQQmBWk81/yY
         Tcxw==
X-Gm-Message-State: AOJu0Yy1KqrY7vMZJt0YCwJj6KMpZkV7VAzFT2yRPvb4MpuqFAU/BxYy
	nQW8y3nPa8I81Zheq1dIri82Yh7dCfRpOs4w41QEsibRI35y43bIBx/ZaZwjgjdGaNn5bGIwwGn
	8AiMZvrXwqU+0Mm1mcrshm3LFFPCZY4/zgTSnrdcmbMCBciQWVCNxQNssUO0=
X-Google-Smtp-Source: AGHT+IEFS8+XPPWncvhXxQAyDC/33egh3IwXkDDsjUbyxqUR/l34vSPg/tk6WDAVkcqEUea/ZYz1l1dtfsxzFVNxpnfYncQ8D9u+
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a02:384d:0:b0:5b7:12b4:475e with SMTP id
 8926c6da1cb9f-5b9541543b6mr1359736173.11.1763616065596; Wed, 19 Nov 2025
 21:21:05 -0800 (PST)
Date: Wed, 19 Nov 2025 21:21:05 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691ea541.a70a0220.d98e3.0028.GAE@google.com>
Subject: [moderation/CI] Re: folio->mapping == NULL check issue
From: syzbot ci <syzbot+ci46cbb599bd900932@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] folio->mapping =3D=3D NULL check issue
https://lore.kernel.org/all/20251120035953.1115736-1-ziy@nvidia.com
* [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference in try_f=
olio_split_to_order()
* [RFC PATCH 2/3] mm/huge_memory: add kernel-doc for folio_split_supported(=
)
* [RFC PATCH 3/3] mm/memory-failure: handle min_order_for_split() error cod=
e properly

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/2a4cc355-ca94-42db-a23e-aa4903987419

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      41218ede767f6b218185af65ce919d0cade75f6b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2e9b453c-36f8-40d6-a442-d3b26be0c6d=
8/config

------------[ cut here ]------------
Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERN=
EL|__GFP_ZERO). Fix your code!
WARNING: CPU: 1 PID: 6030 at mm/vmalloc.c:3938 vmalloc_fix_flags+0x9c/0xe0
Modules linked in:
CPU: 1 UID: 0 PID: 6030 Comm: syz-executor Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c7 =
c7 c0 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 35 2b 6e ff 90 <0f> 0b 90 90 8b 4=
4 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0018:ffffc9000410fb00 EFLAGS: 00010246
RAX: d1ff9ff165489d00 RBX: 0000000000000dc0 RCX: ffff888176319d00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc9000410fb98 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba684 R12: 1ffff92000821f60
R13: dffffc0000000000 R14: ffffc9000410fb20 R15: ffffc9000410fb30
FS:  00005555625f2500(0000) GS:ffff8882a9f36000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f49adc5c470 CR3: 0000000115d48000 CR4: 00000000000006f0
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
RIP: 0033:0x7f2180390b0d
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 44 =
24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff f=
f 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
RSP: 002b:00007ffc336f7f90 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
RAX: ffffffffffffffda RBX: 00007f218042cf80 RCX: 00007f2180390b0d
RDX: 00007ffc336f7ff0 RSI: 0000000000000002 RDI: 0000000000000016
RBP: 00007ffc336f8000 R08: 0000000000000006 R09: 0000000000000071
R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
R13: 00007ffc336f8428 R14: 00007ffc336f86a8 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.com =
david@kernel.org dev.jain@arm.com lance.yang@linux.dev liam.howlett@oracle.=
com linmiaohe@huawei.com linux-kernel@vger.kernel.org linux-mm@kvack.org lo=
renzo.stoakes@oracle.com nao.horiguchi@gmail.com npache@redhat.com ryan.rob=
erts@arm.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

