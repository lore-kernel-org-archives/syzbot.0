Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3142066F7
	for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 18:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770919204; cv=none; b=WGUdKV/aFkMwL/GM5qHz7+9DfmmyI7sTPsdXUc4IGQLx/W0Z2pNw33RERo4ZGqyd7nJ9bc1kJeMVZUVWcAjVE85VDCxNhmGtqkpZgBeTno/ckIBmoQ2lKtUQ2sQnQGnqMX9IxG1NOoIqoEpQd2xep09+WO4Cj9Mw0kX5jmtNmfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770919204; c=relaxed/simple;
	bh=6ptBCPJLYzh4j70Xx5PSC/qSYz9EvRJfA3DKuN2VNYw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qgGk9a7adUeoiLN+WBk2102vF9ne+lEQRWfT18oJgFMCd0nC6PCUtEIh7fHblb2v3LnmI4rNYLcA+nnQFHe9NVrj9A1qvK93H59d/6UVRDD1cTLQqNxGD5MT9tmHKRbYZnj/warrODhK0fskvHf2DJtvT/0qJnkHFb7AnP3yxb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7d4c1b9061eso610365a34.0
        for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 10:00:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770919202; x=1771524002;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vbmnpUve/uPSstEGIDIuUzj3KCWxm+EpJZz74xTf/eo=;
        b=gjDndQkXN/uhnc9RzdBgGWeFICXgSOEhMiMCngPIOGs3NF5GYIFDVwsbAVsRTJ3rSZ
         EIWdg/8N7xVL/HIB9LimRK1LJpQKpqiJbw0mVZAIEV3mAGsED6+viX538HQ6xfLLhthK
         fKjSgmmqQvaf55BPz6s/FNUNqphA+EXMa+ykPhjp/VAy9tCuibIF6ykFfDJVrEGFedyX
         yDyophw6DYONhbKxliCr3l8obCOlPnkk2CszkfcAPf1ixjNxW+UTvqyHj7i9u928J4Bn
         Y7urGgESy+jq+vz6lssZ0Dgwc0BkzVG5qChPDZAolsvok3JTkWVZIMT0jOOLAXEYhje0
         h+YQ==
X-Gm-Message-State: AOJu0Yw0zaR9QJZ68z9JENryiPr8ZVw0mPrn8pG5giOUVzTAKRVexbcC
	KBhUb3/hvb8E6KisnkE1jMfGvgYXKiF55AID37F5Vl0oMizuIweGfA1VqOPppQF4kYOz4f5EvM5
	bUisW7l3enFwGY7NsGKv7RwYB3tSNReK3PRU8zogRItuLqfeT0OGzNL7Gu+U=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dfc:b0:662:f898:2382 with SMTP id
 006d021491bc7-676f0a9f62cmr136601eaf.63.1770919201953; Thu, 12 Feb 2026
 10:00:01 -0800 (PST)
Date: Thu, 12 Feb 2026 10:00:01 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698e1521.a70a0220.2c38d7.009b.GAE@google.com>
Subject: [moderation/CI] Re: improve per-node allocation and reclaim visibility
From: syzbot ci <syzbot+ci2ee21f12ad886ab7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] improve per-node allocation and reclaim visibility
https://lore.kernel.org/all/20260212045109.255391-1-inwardvessel@gmail.com
* [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
* [PATCH 2/2] mm: move pgscan and pgsteal to node stats

and found the following issue:
WARNING in __mod_node_page_state

Full report is available here:
https://ci.syzbot.org/series/4ec12ede-3298-43a3-ab6b-79d47759672e

***

WARNING in __mod_node_page_state

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      72a46cdd4ef13690beb8c5a2f6a2023fd7ef2eb4
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0f678e4c-a4ba-4f17-8ed7-8ae99e56a46=
3/config

------------[ cut here ]------------
IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count() =
=3D=3D 0 && this_cpu_read(hardirqs_enabled))
WARNING: mm/vmstat.c:396 at __mod_node_page_state+0x126/0x170, CPU#0: kthre=
add/2
Modules linked in:
CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted syzkaller #0 PREEMPT(full)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__mod_node_page_state+0x126/0x170
Code: 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 89 df 4c 89 e6 44 89 fa =
e8 68 00 00 00 31 db eb cc 90 0f 0b 90 e9 3e ff ff ff 90 <0f> 0b 90 eb 80 4=
8 c7 c7 e0 c6 64 8e 4c 89 f6 e8 66 3c d3 02 e9 28
RSP: 0000:ffffc900000773d0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 000000000000003d RDI: ffff88815fffb380
RBP: dffffc0000000000 R08: ffffffff8fef2977 R09: 1ffffffff1fde52e
R10: dffffc0000000000 R11: fffffbfff1fde52f R12: ffff88815fffb380
R13: ffffffff92f50f00 R14: 000000000000003d R15: 000000000000003d
FS:  0000000000000000(0000) GS:ffff88818e0f0000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e346000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x407/0x740
 alloc_pages_noprof+0xa8/0x190
 get_free_pages_noprof+0xf/0x80
 __kasan_populate_vmalloc+0x38/0x1d0
 alloc_vmap_area+0xd21/0x1460
 __get_vm_area_node+0x1f8/0x300
 __vmalloc_node_range_noprof+0x372/0x1730
 __vmalloc_node_noprof+0xc2/0x100
 dup_task_struct+0x228/0x9a0
 copy_process+0x508/0x3980
 kernel_clone+0x248/0x870
 kernel_thread+0x13f/0x1b0
 kthreadd+0x4f9/0x6f0
 ret_from_fork+0x51b/0xa40
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org apopple@nvidia.com axelrasmussen@google.com byun=
gchul@sk.com cgroups@vger.kernel.org david@kernel.org eperezma@redhat.com g=
ourry@gourry.net hannes@cmpxchg.org inwardvessel@gmail.com jasowang@redhat.=
com joshua.hahnjy@gmail.com kernel-team@meta.com liam.howlett@oracle.com li=
nux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com ma=
tthew.brost@intel.com mhocko@suse.com mst@redhat.com muchun.song@linux.dev =
rakie.kim@sk.com roman.gushchin@linux.dev rppt@kernel.org shakeel.butt@linu=
x.dev surenb@google.com vbabka@suse.cz virtualization@lists.linux.dev weixu=
gc@google.com xuanzhuo@linux.alibaba.com ying.huang@linux.alibaba.com yuanc=
hu@google.com zhengqi.arch@bytedance.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

