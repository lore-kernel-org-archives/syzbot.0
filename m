Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5C43EBF25
	for <syzbot@lists.linux.dev>; Tue, 10 Feb 2026 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738222; cv=pass; b=l+Y0kk8RtbOIKW/XzF36P1MtUxrxKaR6JzaE2OAyyTGlPdwNQYE+UqQmct4Y0gNJZ7Rb7m/laC4tP3Q0scfySdX45/5Ml8w3JjuXfgslKY43W9IbuAp4SbymN8ZNWkWgaizDAZHkgdpOIDQfzLz4tk7SzYNic8nITJfqHNVAXG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738222; c=relaxed/simple;
	bh=yitbqOWgIAXGubFOt4bc4E+OOpR/Y1Jpfw4FRhYZ91o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JxGaPMGVVH4NlUOpHWrNw+sGEPLXotZZCz4JtQQpSFFW9zmJluJbaHEruYu88Q9M+Hz5IxHoqxH/trxSWmYnHSWmazkSmChJgNxBF4HIRwc7BGjro9q7v5GYMhvAcJF8Ff9buF1IZfILSd6/cyjpR888a2zR+z62qbk0TSgZj+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=becJh3b/; arc=pass smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="becJh3b/"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-45c8e85deffso1456978b6e.1
        for <syzbot@lists.linux.dev>; Tue, 10 Feb 2026 07:43:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770738219; cv=none;
        d=google.com; s=arc-20240605;
        b=fCH3wOqnrJiUdLnfFMNdL+FCVySi5sH9dF9usggjfIb6p3/L7D9mLC5Fn/i7594LkN
         oiyizgOyVno8MjYUgIYNw5+eCVggPZuHPagFWB0tNSdFOIz9shEmUI+zvvXXRvCpN/38
         yJBWrLzSmC7WrstYjL8hrR814a3G5GlIFTMLXQnDmLDlgAiFcN3crrw9n/Mh9tPPuKIv
         PYL30swz7NypIO3gWuQXUCDeMZZGpc/iuSHsMVED9874he4jd/bEgUMZppLzPsFWU3k9
         /Wq9r/z5nBBS/I29iRgHFTvk+XaIdRaW4vymn3oR6mxTUsIkWitBI0buoLev9d5dWO9E
         AwsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P9Kzjj3lJ+IuqsGIIkHk4Sz7/lQM7cNjXdMZgAEuhDM=;
        fh=19acFvX6Sp0Byw0UzZE5ms9aBMySC4JhuUFgWL0GsfE=;
        b=OF4UY2K8YFQBFC+LHhPhyg7qOilhQgvb5iWyKwSNh4lRpw7TW7yt3KX7QptbRv46u6
         arqJPRAgSD3lF61kmkZkpOeS9mi5v0cqehFnauo1rgkOErDZUmWbUhQFMBPj+I2GLs2v
         Ddo8W4QAd9VctySGIC1UyOrxNjukB+b0bbvgXtgN0y+Np7rg/KPbsrUUef/KzGm3fKx8
         vfx2UlnKjzEKDrSHq/8Cyq14iJaM8Pfg7q+9sFmGkSZlJHljo6+WsEJJcW1QAzUXbk/k
         eCzvNly2ASI2QHynh8ZI1ma5G+BbIrJeAO+j/PtzLWuO2oocvTLweW1Odj3tdHKeWa+L
         3rnA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770738219; x=1771343019; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P9Kzjj3lJ+IuqsGIIkHk4Sz7/lQM7cNjXdMZgAEuhDM=;
        b=becJh3b/g9R446MdJ/mVEPDDZ8BXulwypbYvg5ngThafVs6jlbDY+eJIGegDI0Z/2n
         qZu8N++ygwYxdkC3KHUkjmUq38vp+lMv5/rkGm9Ik4v+uMiUgf33nX/EcGTX9v9yoUol
         LX0JbCWwoq0R8WQMta8pXguviTN5rztSbh048ZOzSFtMuwRG/ANA3t3871SCtMlY3c7G
         xJUPllX+uLJx6NbGSDtheCPt6WXswTD1FBpw+zv5Wpqao+3jwk/lom4VpTNb8cmAzzEI
         quH9rDt9/375GtR5aXMeHJb6XQFR/doVSR1MZct4pgt6zuo55wpsrbnfYtBG8yZq3w6F
         HGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770738219; x=1771343019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P9Kzjj3lJ+IuqsGIIkHk4Sz7/lQM7cNjXdMZgAEuhDM=;
        b=aaDVY0ANCU0HvQo0DNw1Lgv66GydUiI+t+xDjXbrS4NnIp2nT1oULetnTfbWnKi5MJ
         HVISTRpRpZO/8USpB1bA/KfYGjfn6+EAu/7Xd7fG+MhIyLAK5j3mXlc3ss7f5FuVP3KF
         7xvovoJLzX3MspbSEXufKu208lk6xCKQjP5f9D+TDobowhInkNRjdo8gP95L6MVsRg5S
         p/3ez7L9ujmkMcVh/FV4NP3lwZ7LMOxBJV4uvZ7TwNbV5MgxExPbN2WE/IZkdDyX4mwL
         PTeN1SeEXUNhitfdrETxNTh/0mvAaS+TEMWj2P9fXez8kKEuRzwrnkWWGWBrsawc2LCV
         9Tow==
X-Forwarded-Encrypted: i=1; AJvYcCW7ur0+49D0BF5eQOEnY8QQGD8kRYriPyXyhHDAqXjZbYbqOzqiEMI4571f38e5YxbQLLVq/08=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcXQiaGFTqlJO+q0d+oFGV0LTRpQCuCt+vTBa7wDPmImdXya46
	5p9/ZAU7uokt0a1hDNfbuExN60LDk/rhe/x8pF/XNdarnv1nbgohcuSTzi7g+hT5j0SOFY/V62u
	mO71yVLyftEsrEnsiLxzPOyttGORkTGnYxuMdM1L3
X-Gm-Gg: AZuq6aIAfzihMqsyU+QKC9HQky1YIsxDHBs0gV04xtP7h3g+QkRIXVqfj+PgOd+WBxo
	QvtOqE29tndKrARcHiKh4wI/fNfThIdtnHj3KXMxflKntBYyo2tDfUTPIEuAxEKAN6MLbDfdN3V
	NCLIqauctwobebQG4YCkpd71eB2wh4o9uKMrsl12XuiPjKbg491Fzvsn+ohhHeod3Ipyn0FcKE0
	kloKUFMiow1owxCC8Q2zY42WNr15cmvbjyO7UhvZUuoHzVjXJFwVvGYGiqT435fBLn128GXkf9V
	AxLyFY4jQA+57dYT9/rK9X4/VZbeaTC2OG4QUySeLcXBVieoykWDGQkqyRJLyEyOWjSa5aVC
X-Received: by 2002:a05:6820:2d09:b0:673:ed80:c7aa with SMTP id
 006d021491bc7-673ed80c94cmr186502eaf.0.1770738219121; Tue, 10 Feb 2026
 07:43:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <698b51d9.050a0220.340abe.0005.GAE@google.com>
In-Reply-To: <698b51d9.050a0220.340abe.0005.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 10 Feb 2026 16:43:27 +0100
X-Gm-Features: AZwV_QjqEJr3r1mE3MLynti1RkLUS-qpjcSCtPWXNqnsLy4dKVdgjdr_FZO3sJk
Message-ID: <CANp29Y7MO7OnotwM5nqDjYb9SgmJuD=-dVMWqnh65KJm2HBb7g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Virtual Swap Space
To: syzbot ci <syzbot+cib572d1edc7b20732@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Feb 10, 2026 at 4:42=E2=80=AFPM syzbot ci
<syzbot+cib572d1edc7b20732@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Virtual Swap Space
> https://lore.kernel.org/all/20260208215839.87595-1-nphamcs@gmail.com
> * [PATCH v3 01/20] mm/swap: decouple swap cache from physical swap infras=
tructure
> * [PATCH v3 02/20] swap: rearrange the swap header file
> * [PATCH v3 03/20] mm: swap: add an abstract API for locking out swapoff
> * [PATCH v3 04/20] zswap: add new helpers for zswap entry operations
> * [PATCH v3 05/20] mm/swap: add a new function to check if a swap entry i=
s in swap cached.
> * [PATCH v3 06/20] mm: swap: add a separate type for physical swap slots
> * [PATCH v3 07/20] mm: create scaffolds for the new virtual swap implemen=
tation
> * [PATCH v3 08/20] zswap: prepare zswap for swap virtualization
> * [PATCH v3 09/20] mm: swap: allocate a virtual swap slot for each swappe=
d out page
> * [PATCH v3 10/20] swap: move swap cache to virtual swap descriptor
> * [PATCH v3 11/20] zswap: move zswap entry management to the virtual swap=
 descriptor
> * [PATCH v3 12/20] swap: implement the swap_cgroup API using virtual swap
> * [PATCH v3 13/20] swap: manage swap entry lifecycle at the virtual swap =
layer
> * [PATCH v3 14/20] mm: swap: decouple virtual swap slot from backing stor=
e
> * [PATCH v3 15/20] zswap: do not start zswap shrinker if there is no phys=
ical swap slots
> * [PATCH v3 16/20] swap: do not unnecesarily pin readahead swap entries
> * [PATCH v3 17/20] swapfile: remove zeromap bitmap
> * [PATCH v3 18/20] memcg: swap: only charge physical swap slots
> * [PATCH v3 19/20] swap: simplify swapoff using virtual swap
> * [PATCH v3 20/20] swapfile: replace the swap map with bitmaps
>
> and found the following issue:
> possible deadlock in vswap_iter
>
> Full report is available here:
> https://ci.syzbot.org/series/b9defda6-daec-4c41-bbf9-7d3b7fabd7cb
>
> ***
>
> possible deadlock in vswap_iter
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/f444cfbe-4ce0-4917-94aa-3a8bd96ee=
376/config
> C repro:   https://ci.syzbot.org/findings/7b8c50b1-47d6-42e0-bcfc-814e7b3=
bb596/c_repro
> syz repro: https://ci.syzbot.org/findings/7b8c50b1-47d6-42e0-bcfc-814e7b3=
bb596/syz_repro
>
> loop0: detected capacity change from 0 to 764
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor625/5806 is trying to acquire lock:
> ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock include/linu=
x/spinlock.h:351 [inline]
> ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: vswap_iter+0xfa/0x1b0 =
mm/vswap.c:274
>
> but task is already holding lock:
> ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq include/=
linux/spinlock.h:376 [inline]
> ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq+0x=
e2/0x190 mm/vswap.c:1586
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
> 3 locks held by syz-executor625/5806:
>  #0: ffff888174bc2800 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock in=
clude/linux/mmap_lock.h:391 [inline]
>  #0: ffff888174bc2800 (&mm->mmap_lock){++++}-{4:4}, at: madvise_lock+0x15=
2/0x2e0 mm/madvise.c:1789
>  #1: ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq inc=
lude/linux/spinlock.h:376 [inline]
>  #1: ffff88811884c018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_i=
rq+0xe2/0x190 mm/vswap.c:1586
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: vswap_cgroup_recor=
d+0x40/0x290 mm/vswap.c:1925
>
> stack backtrace:
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bhe=
@redhat.com cgroups@vger.kernel.org chengming.zhou@linux.dev chrisl@kernel.=
org christophe.leroy@csgroup.eu gourry@gourry.net hannes@cmpxchg.org huang.=
ying.caritas@gmail.com hughd@google.com jannh@google.com joshua.hahnjy@gmai=
l.com kasong@tencent.com kernel-team@meta.com len.brown@intel.com linux-ker=
nel@vger.kernel.org linux-mm@kvack.org linux-pm@vger.kernel.org lorenzo.sto=
akes@oracle.com mhocko@kernel.org muchun.song@linux.dev npache@redhat.com n=
phamcs@gmail.com osalvador@suse.de pavel@kernel.org peterx@redhat.com pfalc=
ato@suse.de rafael@kernel.org riel@surriel.com roman.gushchin@linux.dev rya=
n.roberts@arm.com shakeel.butt@linux.dev shikemeng@huaweicloud.com viro@zen=
iv.linux.org.uk weixugc@google.com yosry.ahmed@linux.dev yuanchu@google.com=
 zhengqi.arch@bytedance.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/698b51d9.050a0220.340abe.0005.GAE%40google.com.
