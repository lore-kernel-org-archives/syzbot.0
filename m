Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67223EBF25
	for <syzbot@lists.linux.dev>; Tue, 10 Feb 2026 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738140; cv=none; b=ii+P1g/7SXJRvqnVOuNAeIpVpmoB2etaRLvLgHC4Cx5qOwc0wWxc2UF/4vcjWagE2Mv19f5oU742FfEYhbXvAlD00JYxs/kdxQTPixyqVrPl6bqPdj89Sqs+wAkExIVmstL39dkw7h4NPjM9GK2uUXpBxnJ0s2hvgbaGC3QaPFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738140; c=relaxed/simple;
	bh=uFHS3S6c1DUQfbwVYkNNhOKvRbYI2lGd+YVS5mxO4kQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Az/qIK3lu2A5HJSW9W905hzmiD0vB5xPzccuIq1tPldxE58u7M/9iyJcqWCvK2QXaB3VsNukQL0T6JvSPbjNnHwp8rtO6gumLCPzPsJM9/SbwOitgaUughvGVoIoV6Q6NcED8bAFRRu9izIpkHm14onfaVCAqxrrrwlI5jhrIGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d195fe3eb4so24879001a34.3
        for <syzbot@lists.linux.dev>; Tue, 10 Feb 2026 07:42:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770738138; x=1771342938;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gPuubgAeO5Ze/XM76KVrWWNllXT9dwRwgZxgoRpz9H0=;
        b=lW6iCnDr0Xjy6apepSX8wEGMERf6XCtkGo0yzLI95attBse3aB1kaTQnxmIL1ApLOC
         Cy+ZomygdkV7bOCWuyYLCIcL/LS3M8QC06qc6EpCsRbLgBueYAQWzsgr31+VKx3bmPiK
         WjRtLTSiYr+6nV/XpckQklUC8U49z3C5yM43gtXN9owy1FGq1DCW0g4C/dE1JPbW//jD
         cWWISXajwl5CeqTINzJE58ypwXhQmZD0RvOT4zqQTpCfX7Xbihs3hK0KubU+x6/5IoRZ
         PsHjjKTnnt49ECwoAfj25DXohUTUAKJ3+Y56rBWx7UkgKPshDNGfDnrllmYQOI9S3t22
         vRzw==
X-Gm-Message-State: AOJu0YxadSjMDoUOr34epOfRPUCQVLpgakK+jcljOq+UHruDEDEpdDAI
	9kGusIKmX9ZCoYszOL/9unEs4aOv4NOO4bDQC8HCJbp3NzocRONpZ1k9/SjSdqR8nAY5VIPxRlE
	STUz7RqKkf7upTIuPoLUTpRJpt2kRKBexKosSAOHjKvqDhiE0EI4mGgqenvU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f06:b0:663:1f2:3e23 with SMTP id
 006d021491bc7-672fc998cc3mr1237080eaf.24.1770738137828; Tue, 10 Feb 2026
 07:42:17 -0800 (PST)
Date: Tue, 10 Feb 2026 07:42:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698b51d9.050a0220.340abe.0005.GAE@google.com>
Subject: [moderation/CI] Re: Virtual Swap Space
From: syzbot ci <syzbot+cib572d1edc7b20732@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] Virtual Swap Space
https://lore.kernel.org/all/20260208215839.87595-1-nphamcs@gmail.com
* [PATCH v3 01/20] mm/swap: decouple swap cache from physical swap infrastr=
ucture
* [PATCH v3 02/20] swap: rearrange the swap header file
* [PATCH v3 03/20] mm: swap: add an abstract API for locking out swapoff
* [PATCH v3 04/20] zswap: add new helpers for zswap entry operations
* [PATCH v3 05/20] mm/swap: add a new function to check if a swap entry is =
in swap cached.
* [PATCH v3 06/20] mm: swap: add a separate type for physical swap slots
* [PATCH v3 07/20] mm: create scaffolds for the new virtual swap implementa=
tion
* [PATCH v3 08/20] zswap: prepare zswap for swap virtualization
* [PATCH v3 09/20] mm: swap: allocate a virtual swap slot for each swapped =
out page
* [PATCH v3 10/20] swap: move swap cache to virtual swap descriptor
* [PATCH v3 11/20] zswap: move zswap entry management to the virtual swap d=
escriptor
* [PATCH v3 12/20] swap: implement the swap_cgroup API using virtual swap
* [PATCH v3 13/20] swap: manage swap entry lifecycle at the virtual swap la=
yer
* [PATCH v3 14/20] mm: swap: decouple virtual swap slot from backing store
* [PATCH v3 15/20] zswap: do not start zswap shrinker if there is no physic=
al swap slots
* [PATCH v3 16/20] swap: do not unnecesarily pin readahead swap entries
* [PATCH v3 17/20] swapfile: remove zeromap bitmap
* [PATCH v3 18/20] memcg: swap: only charge physical swap slots
* [PATCH v3 19/20] swap: simplify swapoff using virtual swap
* [PATCH v3 20/20] swapfile: replace the swap map with bitmaps

and found the following issue:
possible deadlock in vswap_iter

Full report is available here:
https://ci.syzbot.org/series/b9defda6-daec-4c41-bbf9-7d3b7fabd7cb

***

possible deadlock in vswap_iter

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
.git
base:      05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f444cfbe-4ce0-4917-94aa-3a8bd96ee37=
6/config
C repro:   https://ci.syzbot.org/findings/7b8c50b1-47d6-42e0-bcfc-814e7b3bb=
596/c_repro
syz repro: https://ci.syzbot.org/findings/7b8c50b1-47d6-42e0-bcfc-814e7b3bb=
596/syz_repro

loop0: detected capacity change from 0 to 764
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz-executor625/5806 is trying to acquire lock:
ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock include/linux/=
spinlock.h:351 [inline]
ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: vswap_iter+0xfa/0x1b0 mm=
/vswap.c:274

but task is already holding lock:
ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq include/li=
nux/spinlock.h:376 [inline]
ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq+0xe2=
/0x190 mm/vswap.c:1586

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&cluster->lock);
  lock(&cluster->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz-executor625/5806:
 #0: ffff888174bc2800 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock incl=
ude/linux/mmap_lock.h:391 [inline]
 #0: ffff888174bc2800 (&mm->mmap_lock){++++}-{4:4}, at: madvise_lock+0x152/=
0x2e0 mm/madvise.c:1789
 #1: ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq inclu=
de/linux/spinlock.h:376 [inline]
 #1: ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq=
+0xe2/0x190 mm/vswap.c:1586
 #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire inc=
lude/linux/rcupdate.h:331 [inline]
 #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock includ=
e/linux/rcupdate.h:867 [inline]
 #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: vswap_cgroup_record+=
0x40/0x290 mm/vswap.c:1925

stack backtrace:


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bhe@r=
edhat.com cgroups@vger.kernel.org chengming.zhou@linux.dev chrisl@kernel.or=
g christophe.leroy@csgroup.eu gourry@gourry.net hannes@cmpxchg.org huang.yi=
ng.caritas@gmail.com hughd@google.com jannh@google.com joshua.hahnjy@gmail.=
com kasong@tencent.com kernel-team@meta.com len.brown@intel.com linux-kerne=
l@vger.kernel.org linux-mm@kvack.org linux-pm@vger.kernel.org lorenzo.stoak=
es@oracle.com mhocko@kernel.org muchun.song@linux.dev npache@redhat.com nph=
amcs@gmail.com osalvador@suse.de pavel@kernel.org peterx@redhat.com pfalcat=
o@suse.de rafael@kernel.org riel@surriel.com roman.gushchin@linux.dev ryan.=
roberts@arm.com shakeel.butt@linux.dev shikemeng@huaweicloud.com viro@zeniv=
.linux.org.uk weixugc@google.com yosry.ahmed@linux.dev yuanchu@google.com z=
hengqi.arch@bytedance.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

