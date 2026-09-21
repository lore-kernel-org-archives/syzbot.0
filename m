Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEA4327C08
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 03:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961327; cv=none; b=EzdhIpkWsdJX1U/cu6hr/sdnEmHPdGSu/4wrxylB6kh9l4JScEVFEyiCWxKVnOjgKn29vx0oK2zcGUAXPC5SKEbqHa9XwKhuoEik5+JMx0iiHlLjAjwZIBzUZW17tr2ee8TTkYots0tdCTjLRqUVsjHqwaRAitj/poFUuhmQ0qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961327; c=relaxed/simple;
	bh=JJn++7GbqWUOY9n0ryIL5FigFubgdPL7sU613mDUa44=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=trS2xnA7QYU7AECz+VNi9sB/cNwk7od+8ZuWA+3FRUX8YI9rlNOokBxzkZSIJrWn95IOarONhbAzKwYPFDEYTGNn6XQO6JTM2ImwmMj2ES+9AfkWPYWTUUtCT+0TmeNNcw90OjPZTkK9nLKeUe2UsixURAJbAWsbIbJaigNsX6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6d018fb0e4eso151205eaf.0
        for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 20:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789961324; x=1790566124;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sUGGmSRZ3F8ZMkxmD6BLMsfKV4hWr3JJKlLOmziAfWE=;
        b=1xsaegdUbeVFOB1BYhmuVfxlFM4+IuJVKdPS52A4v/6oTdOgJofPUonX/ZPUDTQLio
         LhKdzeltnRP/Et7LiguZeRGuKHAQeUOrLD7wXBCV8JuSsOHBQzygR2haxZWnzgKxlR4U
         YgTaC2EJ2SzYGW+WWES/aG/Q53iuyo8FODFpBFF9kjfds5mJrxjT9/WZ6lT2OdHt79yj
         NxgjWPaUoIQvod85mdnHGakqoEk6vPz+Bx2Q0RQ/M/D0d4P4h9v+jInEgLNMsyi0zjxr
         wJcbvHOXp+hyvLYlSmx7JuV5DZL6lofSDoZh4Kg5siE4bCjMv/mJm0hXJ88XzCAjua5j
         zKDA==
X-Gm-Message-State: AFuF++lM7gjFA7FLQzSTx8IDEcJ/ioXNpnZvzcmSUM95yX80ITIhk3Tg
	7z0IO1fhx10YQrYdXkudq77HWMtit4rGdYdrIc3BIQA+Q8POEXMJzh5Hbv5KHZHPqo2T9SP7+t7
	C/S19exSmiN+8gpCmKxoufRpDnoNmpR7a2piSiWWAiQYhR7OTVzP66u6cW0s=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:820:b0:6cf:d6b7:d8be with SMTP id
 006d021491bc7-6cfd6c71b59mr1528785eaf.81.1789961324642; Sun, 20 Sep 2026
 20:28:44 -0700 (PDT)
Date: Sun, 20 Sep 2026 20:28:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab0a46c.71f81b7d.15fa6d.0021.GAE@google.com>
Subject: [moderation/CI] Re: Virtual Swap Space (Swap Table Edition)
From: syzbot ci <syzbot+ci01ec2893db94831b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] Virtual Swap Space (Swap Table Edition)
https://lore.kernel.org/all/20260918180241.3424851-1-nphamcs@gmail.com
* [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
* [PATCH v5 02/11] mm, swap: support zswap and zero-filled swap pages as vs=
wap backends
* [PATCH v5 03/11] mm, swap: prepare the swap IO path for vswap
* [PATCH v5 04/11] mm, swap: support physical swap as a vswap backend
* [PATCH v5 05/11] mm, swap: enable THP swapin for vswap entries
* [PATCH v5 06/11] mm, swap: write back vswap zswap entries to physical swa=
p
* [PATCH v5 07/11] mm, swap: reclaim physical slots backing cache-only vswa=
p entries
* [PATCH v5 08/11] mm, swap: only charge physical swap entries
* [PATCH v5 09/11] mm, swap: add debugfs counters for vswap
* [PATCH v5 10/11] mm, swap: defer memcg_table allocation for physical swap=
 clusters
* [RFC PATCH v5 11/11] mm, swap: back vswap clusters with a VM_SPARSE array

and found the following issue:
KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

Full report is available here:
https://ci.syzbot.org/series/713f2473-328a-4c16-8bce-63005d15a338

***

KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      27e4e1835109ef599d72abe6c09711e0b1916033
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/26b06329-3b1c-4c73-8ee3-64c53b99518=
6/config
syz repro: https://ci.syzbot.org/findings/f743742b-1934-4b4e-a590-9a36592da=
902/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrume=
nted.h:82 [inline]
BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomic-=
instrumented.h:3188 [inline]
BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:163 [inline]
BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:202 [inline]
BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xea/0x210 mm/vsw=
ap.h:409
Read of size 8 at addr 0000000000000e00 by task syz.1.38/5916

CPU: 1 UID: 0 PID: 5916 Comm: syz.1.38 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
 __vtable_get mm/vswap.h:163 [inline]
 vswap_to_phys mm/vswap.h:202 [inline]
 swap_entry_backend_has_flag+0xea/0x210 mm/vswap.h:409
 do_swap_page+0x767/0x5a20 mm/memory.c:5042
 __collapse_huge_page_swapin mm/khugepaged.c:1152 [inline]
 collapse_huge_page mm/khugepaged.c:1271 [inline]
 mthp_collapse mm/khugepaged.c:1469 [inline]
 collapse_run_pmd+0xaf1/0x5d90 mm/khugepaged.c:2811
 madvise_collapse mm/madvise.c:1026 [inline]
 madvise_vma_behavior+0x17cf/0x4d80 mm/madvise.c:1548
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1896
 madvise_do_behavior+0x385/0x540 mm/madvise.c:2091
 do_madvise+0x26f/0x330 mm/madvise.c:2189
 __do_sys_madvise mm/madvise.c:2198 [inline]
 __se_sys_madvise mm/madvise.c:2196 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2196
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7b5939e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7b5a1ff028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f7b59625fa0 RCX: 00007f7b5939e159
RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007f7b5943506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7b59626038 R14: 00007f7b59625fa0 R15: 00007ffe5f2d8d38
 </TASK>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


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
[akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org baoli=
n.wang@linux.alibaba.com baoquan.he@linux.dev cgroups@vger.kernel.org cheng=
ming.zhou@linux.dev chrisl@kernel.org corbet@lwn.net david@kernel.org gourr=
y@gourry.net hannes@cmpxchg.org haowenchao22@gmail.com hughd@google.com kas=
ong@tencent.com kernel-team@meta.com kunwu.chan@linux.dev liam@infradead.or=
g linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org=
 ljs@kernel.org mhocko@kernel.org mkoutny@suse.com muchun.song@linux.dev np=
hamcs@gmail.com qi.zheng@linux.dev riel@surriel.com roman.gushchin@linux.de=
v rppt@kernel.org shakeel.butt@linux.dev shikemeng@huaweicloud.com skhan@li=
nuxfoundation.org surenb@google.com tj@kernel.org vbabka@kernel.org weixugc=
@google.com yosry@kernel.org youngjun.park@lge.com yuanchu@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

