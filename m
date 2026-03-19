Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F373FA5D2
	for <syzbot@lists.linux.dev>; Thu, 19 Mar 2026 23:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773962785; cv=pass; b=HR4KkTn3QtAQjEHRMiphr1P0ZYDxS4gdkeQJbBfrOnZltAzYbVEuFYGNUAVoQl5odBTOQRCzpY1KhlWL+bwIOF2h8WS6pBPULUjywzPn13ef61AkKT9dlYWlX5Y2YyDWVYhxPiqDwczFP5cnB51+fWszWlmVdhu2QXw03PFuoGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773962785; c=relaxed/simple;
	bh=biWQzYmkSAT7COHU3SJ1yQbLPGtRxmVBoGdTj8nctes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HGB1Rv3E7U2YHx1mttcQ3LequQN8ssa/YDzRWq2vmiOse3tTTXCyqclom5yEwiwMzkXsNRQ5t7id8TPyD9vEXBHRqHiNcVRD4f0DCmHkbyWxkvYeVNcxaEdhuvn5btI8IB7lDeDAvxwzTVAklnB3Qxj2AVD099hHv814anvYFV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kY7/7AFC; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kY7/7AFC"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439b2965d4bso31098f8f.2
        for <syzbot@lists.linux.dev>; Thu, 19 Mar 2026 16:26:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773962782; cv=none;
        d=google.com; s=arc-20240605;
        b=jwl/RIdgo+WHMPtyt7aJvCZ+2gSAIl23ucUSPG7G3yGZPdTIhNN1jdUcphpu1yO51+
         iCG3AFlRNDsUMNZk1VlZ1+q8GDMFrZUReC3qcxGKirezdKm7rtTvr88paM80XWZe23hf
         rMDPFrsPiUEqg6NdnH5G9BES2KHFzBY65Pd79kEsiabz0bPYTAJRYySwQA5Qai9ScGGx
         x+1+27SZ715clKcfKD/ndti9zL8lVTeKQjX56GWLy6JCCDZ9XlsDtPpqju58oRlrTLKP
         KeBUcwJ7gd8FvVJe+vFW6PsXZfV63878MIedfzJ8s/VRx2HUB0GFQbHWzzxOuVxKIGzm
         igUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7beb8gjsdwOqcZgIyiO7JeS7nO6wuiWGWdh35QWvwZE=;
        fh=Brb/eOklz6P0ZZ0vYsOu3NQF/3lkrbzi8I8H3QUX1wY=;
        b=JS3U61PTt9c6gpj9myxo9pddVAB02PDS2tq8Kta4N6T0kiTnYLZkMp0lVWTFiqzFaH
         Nsj/arQ5ugnp5aHggmAz+KYNduQyvduSojbZu5P7AnCiJEQ1/j9J0UfCkP/3iU1R5DZO
         afzTALapC+bTGIt/SiTXqvz6Hh0wFjQBR5eqczhU7+gKsiH3/r6aEXWmMK1fQxsxZiQG
         QOOjYSro5O/NVEoZd94EhkCiXIN/4hZX4BEZj1TAIVKdCC6xSvjlvATk/ZkQurmWymui
         5wQKVNh3Wz4VMfjtKQ1DqP4pib1wi/4+TszLt+KYNF30OKqh6OCJOudM9mNeqtBA2HRw
         oecg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773962782; x=1774567582; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7beb8gjsdwOqcZgIyiO7JeS7nO6wuiWGWdh35QWvwZE=;
        b=kY7/7AFC3DmtWzEXqRkGRnbzoyeDO8sjz/wzXSWeknAZbRqaiRjeW+eSdqSlh8/9pH
         OQOf5R6V7CaM8bIHkKq2ITugwIgw+07zdJF6FVwIzOwqdFtXMQ3St+Oq463GOp56C7qg
         m5jlVpMn1GxJ949Za81VWenJKPx4VNAkEs8+veEKVe91RM4fXJMrqKBtzSJHhDctsthy
         NzN8uIEfzD+ayTZmApteUzFEt8Qg9rPdatWhKmPUrbvJIbRC5FaE5+lvuNmW6jzZlKCp
         tiiNbTdD34jaCNYzFVRZNG3n1Mfe5FT5v3Mre3GCWztWwZYE9uDJFEDWBdWYyBxW3WWY
         E1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773962782; x=1774567582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7beb8gjsdwOqcZgIyiO7JeS7nO6wuiWGWdh35QWvwZE=;
        b=elf+4jQeTvvswwbbiPDul3DAfh+MnYhb8uTI8WxQDaVDOz9nqoyGbP4pfDVidT9g3F
         0kn9ABmkthTrmENimoajINo6Wyc28R0X33KEXSjcf02+EdC6msz4xPb9YoCJySS16gMx
         p2C5q8SjZys41oh3DsPpMLhZ6JHXxkI3vjRjb+9+VI/McmsVQ/8KS2oTMH7cimaz8UT3
         Fwg6JaAkLcxgH/H1IyATyGDUGUAYdVsJv5GOM/XgaBSAhxi5eMXwvfmWGeCiRge5hBI8
         fp7T4awZWU4mTg8Pgzzv7Jbg6f0V6Qc/NUFoWvxBcdiEaq80mE6fLWaezS7mtMn5VDsB
         oDJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzhemYwrav9+CpilY+1Bz1JQJwK+Hj6e/Yz8ZSVWRVCe0rYMB8L95uvxAsHrHWD/F36c0dpiE=@lists.linux.dev
X-Gm-Message-State: AOJu0YypLDKfbhfbIegE5xHuZbyKTpDQGLQ56a8MTsyrsj0PVWjmRAqA
	rz5uB1V6mXpjzs5fOLFkjcgw2JobSKXcZfC8i8MQJo4CPn00uZqfOPDX9k7M3x7r7rZDdb4fIY9
	ZvCxgmaRgSDb6RNRYPg8CB7vrGf7pGsA=
X-Gm-Gg: ATEYQzy0vsZGm2OXMsbYWD/MDJRkOn0K89mmKXqUd0h4foyxsSFCDjN/df0G74OOxIP
	wVTxjByfKZoblvKWTnuXzl62T80cmE0r84ayjvmVbxrYm93k4D3ovZTJPBasR+6c2k+PcsfyO/g
	HydGPUgSUcQQZSrBgdKA5OAFkBmFkP4ETpG8DFdKnb4KE69dPjaDINHDCd9RR843HEH7Q3qoG1u
	A9Nb5fhtgGsqqVWTHQimSGlIaIwnm7A2H+NGlxsJOMPUSmjMdy0v+wEpdj0RCQDgT2VUTESNRor
	6iAFdzv6MBnS6TDSNUQL+ziiXTaJ3sg0Xk4BWwY=
X-Received: by 2002:a05:6000:1a88:b0:432:5c34:fb32 with SMTP id
 ffacd0b85a97d-43b64257edamr2078092f8f.23.1773962781517; Thu, 19 Mar 2026
 16:26:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260318222953.441758-1-nphamcs@gmail.com> <69bc6c4f.050a0220.3bf4de.0001.GAE@google.com>
In-Reply-To: <69bc6c4f.050a0220.3bf4de.0001.GAE@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 19 Mar 2026 16:26:10 -0700
X-Gm-Features: AaiRm53Xe0ySNcLwX_1MJR-ZkSlSVSu1aeYx4yiRcGwlx-CLDipgZeR1y7Vur74
Message-ID: <CAKEwX=PF470op0e+eXcFS3SHKaLRd5v6ZuE+_aUk_4xfdGosog@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Virtual Swap Space
To: syzbot ci <syzbot+ci0215525ee2c0ed89@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, axelrasmussen@google.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, bhe@redhat.com, 
	byungchul@sk.com, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, kasong@tencent.com, kernel-team@meta.com, 
	lance.yang@linux.dev, lenb@kernel.org, liam.howlett@oracle.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, riel@surriel.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2026 at 2:36=E2=80=AFPM syzbot ci
<syzbot+ci0215525ee2c0ed89@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] Virtual Swap Space
> https://lore.kernel.org/all/20260318222953.441758-1-nphamcs@gmail.com
> * [PATCH v4 01/21] mm/swap: decouple swap cache from physical swap infras=
tructure
> * [PATCH v4 02/21] swap: rearrange the swap header file
> * [PATCH v4 03/21] mm: swap: add an abstract API for locking out swapoff
> * [PATCH v4 04/21] zswap: add new helpers for zswap entry operations
> * [PATCH v4 05/21] mm/swap: add a new function to check if a swap entry i=
s in swap cached.
> * [PATCH v4 06/21] mm: swap: add a separate type for physical swap slots
> * [PATCH v4 07/21] mm: create scaffolds for the new virtual swap implemen=
tation
> * [PATCH v4 08/21] zswap: prepare zswap for swap virtualization
> * [PATCH v4 09/21] mm: swap: allocate a virtual swap slot for each swappe=
d out page
> * [PATCH v4 10/21] swap: move swap cache to virtual swap descriptor
> * [PATCH v4 11/21] zswap: move zswap entry management to the virtual swap=
 descriptor
> * [PATCH v4 12/21] swap: implement the swap_cgroup API using virtual swap
> * [PATCH v4 13/21] swap: manage swap entry lifecycle at the virtual swap =
layer
> * [PATCH v4 14/21] mm: swap: decouple virtual swap slot from backing stor=
e
> * [PATCH v4 15/21] zswap: do not start zswap shrinker if there is no phys=
ical swap slots
> * [PATCH v4 16/21] swap: do not unnecesarily pin readahead swap entries
> * [PATCH v4 17/21] swapfile: remove zeromap bitmap
> * [PATCH v4 18/21] memcg: swap: only charge physical swap slots
> * [PATCH v4 19/21] swap: simplify swapoff using virtual swap
> * [PATCH v4 20/21] swapfile: replace the swap map with bitmaps
> * [PATCH v4 21/21] vswap: batch contiguous vswap free calls
>
> and found the following issue:
> possible deadlock in vswap_iter
>
> Full report is available here:
> https://ci.syzbot.org/series/f8238a2a-370e-404d-b3f7-5945b574bd63
>
> ***
>
> possible deadlock in vswap_iter
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/cf1517a6-d391-46d8-bfbe-98e6be6b9=
3ce/config
> syz repro: https://ci.syzbot.org/findings/b4e84ae7-17d4-4bf8-9c3f-4c13b10=
a1e52/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz.1.18/6001 is trying to acquire lock:
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock include/linu=
x/spinlock.h:351 [inline]
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: vswap_iter+0xfa/0x1b0 =
mm/vswap.c:274
>
> but task is already holding lock:
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq include/=
linux/spinlock.h:376 [inline]
> ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq+0x=
e2/0x190 mm/vswap.c:1529
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&cluster->lock);
>   lock(&cluster->lock);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 3 locks held by syz.1.18/6001:
>  #0: ffff8881bb523440 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock in=
clude/linux/mmap_lock.h:391 [inline]
>  #0: ffff8881bb523440 (&mm->mmap_lock){++++}-{4:4}, at: madvise_lock+0x15=
2/0x2e0 mm/madvise.c:1789
>  #1: ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq inc=
lude/linux/spinlock.h:376 [inline]
>  #1: ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_i=
rq+0xe2/0x190 mm/vswap.c:1529
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: vswap_cgroup_recor=
d+0x41/0x440 mm/vswap.c:1909
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6001 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>  spin_lock include/linux/spinlock.h:351 [inline]
>  vswap_iter+0xfa/0x1b0 mm/vswap.c:274
>  vswap_cgroup_record+0xeb/0x440 mm/vswap.c:1910
>  swap_cgroup_record+0xc5/0x130 mm/vswap.c:1933
>  memcg1_swapout+0x358/0x9e0 mm/memcontrol-v1.c:623

Good (syz)bot! We're already holding the cluster lock here - shouldn't
need to reacquire the lock.

Should be an easy-ish fix.
