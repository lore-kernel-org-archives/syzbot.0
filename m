Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B9925B0A7
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 04:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778907597; cv=pass; b=CwZTd/i1P56z4EoLpwIv8wQV4ISpqWetl39LKnUzz7XPVBr4bWTdLMNJVOSPMjOhomxG+ii+vWHJMxPmVNkiXVd4OkoO3ufKqQgfQ0fWNL26SoPZFrcsH+yqw2vXImeHrUCgNyOU1fpgwUyvN4CtlAm0E1nXu68shz+lY4svO4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778907597; c=relaxed/simple;
	bh=my/yewYPdEmWsutfqJBiavpQSuv6Z/A5rKe13rPJGKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o3Cjfbzd8yqp9Mfjt79JmyvUT6EpEEJLvGeqhmjnNV2H3zgQ8ccN6Gqd5vCdPt1wz+cAmKr/oBvMGZqBxMBV9VVJILP2sljh6IVtwnWeSWTyX4L+XRSvSH0BhcyJgcO0uTcnH2hy/YVsJQ8dvlcJ63BjB9ypR+GEdvxJi0S8VWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pPK/IHvI; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pPK/IHvI"
Received: by smtp.kernel.org (Postfix)
	id 6E69DC2BCB8; Sat, 16 May 2026 04:59:57 +0000 (UTC)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2953AC19425
	for <syzbot@kernel.org>; Sat, 16 May 2026 04:59:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 2953AC19425
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-38be5e86918so8383321fa.3
        for <syzbot@kernel.org>; Fri, 15 May 2026 21:59:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778907594; cv=none;
        d=google.com; s=arc-20240605;
        b=UQpOO9IBHAwp1g5lI38VoyiPetdY1Av4nTkWQRc78BuOozc2YJ/s80U2kMtZlhf3Iv
         5hjtVOcxGdlunOWUluqscO4amPcrCB9QW2tjvY1LBFGDrVSBdsGyvqUQnDuQTq4na6C6
         KMmDMKivjmKmHkGe0rNbgGGoAX4qWLQdxH1H2ZCijDl3bMnxoW4dxu/H/21hD8F5jDlO
         oepjA7BQA4CLQHvJgDgEDtNLg6q5l1bCnbRkATmz6g6aQb74scfOVm9muy++9t+pdzs3
         C6FzRNbE2P7YLL54rZb12WHdiBu7Lc7/tRrdxkKliT1+EE4QlxdMbWfHNCsffgaLeu9n
         68xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hIWyCDrIaOap1jIYptuo5nnqH16Pe+G1iueT2Gx9pYk=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=kHAPKPEokv6MFv897JKaTd3N0SUIUsdiIZoHs8UH5NmMR8WIavn6vflo9uTS1qRE1o
         ks7gGXAES8p/P4P3r2bVztCMRYzkaiNWGF5LAivuvnDdOGdZd0eC6jwtj9tOi8gZK60f
         RE0Eq9nqaeGQrOpgFmuDF35ibxzhcZ6+DxA+yYwDQxKEaA6dRDc1LqBPWUXpsxd8Koj6
         NnlU3wbgBNHm+0YNaA0OdxGNvvkr9eoBbr7MxB1r+5jZyYcpseMEFT8wg9M0F0nTQt6j
         8lMqBHx/hH7p1k8XNc4yFxfGtkj3lxqAAe5b8+02f04BS3+fnse6H9yRXAv/XwveUdGu
         4dzA==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778907594; x=1779512394; darn=kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hIWyCDrIaOap1jIYptuo5nnqH16Pe+G1iueT2Gx9pYk=;
        b=pPK/IHvIFkUqYsaTgYWdPBh7ml6jXefuVOjdubfRUwCKqb1ic5p3zDJz5FK6sM2TVi
         T/c4TpUVOcp6W135R+21rIzo3PiMXxIF+HGMeWqCcLakLzx4QCrkcWYMmAMBYZJ2XUCP
         gqOUAaLiSkeWnrQ30ZUgPWzToR6csXz2wzhsornzJgzPLbadVTDjdDcmEjwGOFDmm3Wm
         bcnPyq5sdd3bWxMHrMUiWeCMkeMcDy8RpWbTQA8E8upMneh/KKqzpsRo98smU2SAMlqk
         hS6fojhFEKhu8JTnTEjaLh3u0r23EknoJAgjvzM/kNuBpxMjBmgYNjk9HsPffXloWBZ/
         4gDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778907594; x=1779512394;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hIWyCDrIaOap1jIYptuo5nnqH16Pe+G1iueT2Gx9pYk=;
        b=h83ndGR4QyC3eFn9G9wi/Xzs6eFAPEIh9FjcGgBjqz7+72riHYr8/vELocz1BV49aB
         tQOWL+v+4SxvDt9UhaVfLRt61ocAvxT2LLQ0aKst0aqPYo0fP/nZ6v76tTTV1zcoFMFT
         iD45Kbg7w1rYSxI9Rto6r/zukKXzp7vyWlPyItN6f6QKf3KcFFu81ZUbcbtP01mcMmeI
         t1AOiFNkZ1N+6EuN6j1TzA6RfA00UZKhGPgUyS783GGn66e2PYAvYk3685JPFPq7z5Aj
         OCsY1Gd69IHBrmeANSZ34fzEbAK6TuBSkzIY6B5q/oLv//o+j/5e23XsdsYIw50F3voA
         yRHw==
X-Gm-Message-State: AOJu0Yxm/Rt0tKmO/jkpAH72964LPNnbh4X4C6bUweOMLeGzLLfODn7W
	oXe11fElpyjoScFUyx6y2XOEzbFbNnaD1IKZ1cZ1otcwRVYfX4TpuoClj52y6ENLOXe1YzaSd3U
	DIuiHciCANH4jvBJhoCqXl1RcBdrmTXrlCeDQ9gO3SPolrXQxJkmkXuWj4Jw=
X-Gm-Gg: Acq92OFVAzB7f0F25Imhj0hEGWiH3LBKgapUzMTrAcv1y44eLuACmTSF2E2qiEWFoN9
	5Wup2WO98yI0v6611jYwLaoz8eMOuB+48bct2KeNWCTkVQ5wjsVA0M9Qk2Kc+Mst+emfhAbJjXt
	F+dqRKkRrX9f6eI0p6hLAOgoJr8fUo/k4+uDJfUyvOWoXnTCWvuvBi6oDUbwiBXUNEkMLsqQJzk
	2DmtOOp0RVAxsVeVuy6iJ8lZmE7dF9Yg0qvPGXxWNFAEnKSx1LNnnUk0BJNmVjuKELxO+T4SJN1
	sS7v4RLyDo7IBpanSzyZSg/BH2QsAd7DivGrxgI2OZhXtnRAEyoGSoYeevUVXTPwvMOC39wHq1T
	hVgbwKio=
X-Received: by 2002:a05:651c:41d5:b0:38f:e2ad:e975 with SMTP id
 38308e7fff4ca-39561c0d38amr20313771fa.14.1778907593682; Fri, 15 May 2026
 21:59:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <dcebc4bd-5cc1-4dc9-b82b-6cca0fad128b@mail.kernel.org>
In-Reply-To: <dcebc4bd-5cc1-4dc9-b82b-6cca0fad128b@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 16 May 2026 06:59:42 +0200
X-Gm-Features: AVHnY4J9Lu7bps9X1arZQ6EDgnjJ5en-QZMuL3247N-yzWSwfbnHcggeDKUG1H4
Message-ID: <CACT4Y+bG9MvoSJb8G4XOquvcb+aQDXkF4XM=-zAEJcNFXcg4cA@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: lru: Use resilient spinlocks to prevent NMI deadlocks
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

A very similar patch was tested for this bug, which confirms the patch
is correct.


On Thu, 14 May 2026 at 00:38, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> BPF LRU maps currently use standard `raw_spinlock_t` for their local and
> global list locks, which are not NMI-safe. If an NMI (such as a perf
> event hardware breakpoint) interrupts a normal context that is holding
> an LRU list lock, and a BPF program executed in the NMI context attempts
> to acquire the exact same lock (e.g., via `bpf_map_delete_elem`), it
> will spin forever waiting for the lock to be released. This results in a
> hard deadlock because the context holding the lock has been preempted by
> the NMI itself. Lockdep correctly detects this unsafe `{INITIAL USE} ->
> {IN-NMI}` transition and emits an inconsistent lock state warning.
>
> To resolve this, update the LRU list implementation to use resilient
> queued spinlocks (`rqspinlock_t`), similar to how bucket locks in
> standard BPF hash maps were previously converted. Resilient spinlocks
> are NMI-safe because they detect deadlocks (such as re-entrancy on the
> same CPU) and return an error instead of hanging. Replace all standard
> spinlock operations with their resilient counterparts in
> `bpf_lru_list.c`. Since resilient spinlock acquisitions can fail, update
> the LRU functions to handle these failures gracefully. For pop
> functions, return `NULL` when the lock cannot be acquired, which callers
> already handle by propagating an `-ENOMEM` error. When stealing nodes
> from remote CPUs, safely skip the CPU if its lock cannot be acquired.
> For push and flush functions, abort and return early if the lock fails,
> effectively leaking the LRU node, which is an acceptable trade-off to
> prevent a hard system deadlock in NMI context.
>
> Fixes: 3a08c2fd763450a927d1130de078d6f9e74944fb ("bpf: LRU List")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+c69a0a2c816716f1e0d5@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=c69a0a2c816716f1e0d5
> Link: https://syzkaller.appspot.com/ai_job?id=10f0c342-88ea-4f57-a31f-48eff83eae85
> To: <bpf@vger.kernel.org>
> To: <martin.lau@linux.dev>
> Cc: <andrii@kernel.org>
> Cc: <ast@kernel.org>
> Cc: <daniel@iogearbox.net>
> Cc: <eddyz87@gmail.com>
> Cc: <jolsa@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: <memxor@gmail.com>
> Cc: <song@kernel.org>
> Cc: <yonghong.song@linux.dev>
>
> ---
> diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
> index e7a2fc605..d02c37ca9 100644
> --- a/kernel/bpf/bpf_lru_list.c
> +++ b/kernel/bpf/bpf_lru_list.c

Add <asm/rqspinlock.h> include in this file too.

> @@ -307,9 +307,10 @@ static void bpf_lru_list_push_free(struct bpf_lru_list *l,
>         if (WARN_ON_ONCE(IS_LOCAL_LIST_TYPE(node->type)))
>                 return;
>
> -       raw_spin_lock_irqsave(&l->lock, flags);
> +       if (raw_res_spin_lock_irqsave(&l->lock, flags))
> +               return;
>         __bpf_lru_node_move(l, node, BPF_LRU_LIST_T_FREE);
> -       raw_spin_unlock_irqrestore(&l->lock, flags);
> +       raw_res_spin_unlock_irqrestore(&l->lock, flags);
>  }
>
>  static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
> @@ -319,7 +320,8 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
>         struct bpf_lru_node *node, *tmp_node;
>         unsigned int nfree = 0;
>
> -       raw_spin_lock(&l->lock);
> +       if (raw_res_spin_lock(&l->lock))
> +               return;
>
>         __local_list_flush(l, loc_l);
>
> @@ -338,7 +340,7 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
>                                       local_free_list(loc_l),
>                                       BPF_LRU_LOCAL_LIST_T_FREE);
>
> -       raw_spin_unlock(&l->lock);
> +       raw_res_spin_unlock(&l->lock);
>  }
>
>  static void __local_list_add_pending(struct bpf_lru *lru,
> @@ -404,7 +406,8 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
>
>         l = per_cpu_ptr(lru->percpu_lru, cpu);
>
> -       raw_spin_lock_irqsave(&l->lock, flags);
> +       if (raw_res_spin_lock_irqsave(&l->lock, flags))
> +               return NULL;
>
>         __bpf_lru_list_rotate(lru, l);
>
> @@ -420,7 +423,7 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
>                 __bpf_lru_node_move(l, node, BPF_LRU_LIST_T_INACTIVE);
>         }
>
> -       raw_spin_unlock_irqrestore(&l->lock, flags);
> +       raw_res_spin_unlock_irqrestore(&l->lock, flags);
>
>         return node;
>  }
> @@ -437,7 +440,8 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
>
>         loc_l = per_cpu_ptr(clru->local_list, cpu);
>
> -       raw_spin_lock_irqsave(&loc_l->lock, flags);
> +       if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
> +               return NULL;
>
>         node = __local_list_pop_free(loc_l);
>         if (!node) {
> @@ -448,7 +452,7 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
>         if (node)
>                 __local_list_add_pending(lru, loc_l, cpu, node, hash);
>
> -       raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> +       raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
>
>         if (node)
>                 return node;
> @@ -466,23 +470,26 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
>         do {
>                 steal_loc_l = per_cpu_ptr(clru->local_list, steal);
>
> -               raw_spin_lock_irqsave(&steal_loc_l->lock, flags);
> +               if (raw_res_spin_lock_irqsave(&steal_loc_l->lock, flags))
> +                       goto next_steal;
>
>                 node = __local_list_pop_free(steal_loc_l);
>                 if (!node)
>                         node = __local_list_pop_pending(lru, steal_loc_l);
>
> -               raw_spin_unlock_irqrestore(&steal_loc_l->lock, flags);
> +               raw_res_spin_unlock_irqrestore(&steal_loc_l->lock, flags);
>
> +next_steal:
>                 steal = cpumask_next_wrap(steal, cpu_possible_mask);
>         } while (!node && steal != first_steal);
>
>         loc_l->next_steal = steal;
>
>         if (node) {
> -               raw_spin_lock_irqsave(&loc_l->lock, flags);
> +               if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
> +                       return NULL;
>                 __local_list_add_pending(lru, loc_l, cpu, node, hash);
> -               raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> +               raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
>         }
>
>         return node;
> @@ -511,10 +518,11 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
>
>                 loc_l = per_cpu_ptr(lru->common_lru.local_list, node->cpu);
>
> -               raw_spin_lock_irqsave(&loc_l->lock, flags);
> +               if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
> +                       return;
>
>                 if (unlikely(node->type != BPF_LRU_LOCAL_LIST_T_PENDING)) {
> -                       raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> +                       raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
>                         goto check_lru_list;
>                 }
>
> @@ -522,7 +530,7 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
>                 bpf_lru_node_clear_ref(node);
>                 list_move(&node->list, local_free_list(loc_l));
>
> -               raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> +               raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
>                 return;
>         }
>
> @@ -538,11 +546,12 @@ static void bpf_percpu_lru_push_free(struct bpf_lru *lru,
>
>         l = per_cpu_ptr(lru->percpu_lru, node->cpu);
>
> -       raw_spin_lock_irqsave(&l->lock, flags);
> +       if (raw_res_spin_lock_irqsave(&l->lock, flags))
> +               return;
>
>         __bpf_lru_node_move(l, node, BPF_LRU_LIST_T_FREE);
>
> -       raw_spin_unlock_irqrestore(&l->lock, flags);
> +       raw_res_spin_unlock_irqrestore(&l->lock, flags);
>  }
>
>  void bpf_lru_push_free(struct bpf_lru *lru, struct bpf_lru_node *node)
> @@ -625,7 +634,7 @@ static void bpf_lru_locallist_init(struct bpf_lru_locallist *loc_l, int cpu)
>
>         loc_l->next_steal = cpu;
>
> -       raw_spin_lock_init(&loc_l->lock);
> +       raw_res_spin_lock_init(&loc_l->lock);
>  }
>
>  static void bpf_lru_list_init(struct bpf_lru_list *l)
> @@ -640,7 +649,7 @@ static void bpf_lru_list_init(struct bpf_lru_list *l)
>
>         l->next_inactive_rotation = &l->lists[BPF_LRU_LIST_T_INACTIVE];
>
> -       raw_spin_lock_init(&l->lock);
> +       raw_res_spin_lock_init(&l->lock);
>  }
>
>  int bpf_lru_init(struct bpf_lru *lru, bool percpu, u32 hash_offset,
> diff --git a/kernel/bpf/bpf_lru_list.h b/kernel/bpf/bpf_lru_list.h
> index fe2661a58..ecd93c77a 100644
> --- a/kernel/bpf/bpf_lru_list.h
> +++ b/kernel/bpf/bpf_lru_list.h
> @@ -7,6 +7,7 @@
>  #include <linux/cache.h>
>  #include <linux/list.h>
>  #include <linux/spinlock_types.h>
> +#include <asm/rqspinlock.h>
>
>  #define NR_BPF_LRU_LIST_T      (3)
>  #define NR_BPF_LRU_LIST_COUNT  (2)
> @@ -34,13 +35,13 @@ struct bpf_lru_list {
>         /* The next inactive list rotation starts from here */
>         struct list_head *next_inactive_rotation;
>
> -       raw_spinlock_t lock ____cacheline_aligned_in_smp;
> +       rqspinlock_t lock ____cacheline_aligned_in_smp;
>  };
>
>  struct bpf_lru_locallist {
>         struct list_head lists[NR_BPF_LRU_LOCAL_LIST_T];
>         u16 next_steal;
> -       raw_spinlock_t lock;
> +       rqspinlock_t lock;
>  };
>
>  struct bpf_common_lru {
>
>
> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/dcebc4bd-5cc1-4dc9-b82b-6cca0fad128b%40mail.kernel.org.
