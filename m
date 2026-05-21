Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6693E215F42
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375963; cv=pass; b=pmtcjLpT6WwtXlZ1g1PyMYV1gv9g4fHjQpRNcf1xqz5WoepSO9Sm5AGVRPf0/3bobP4GgQ3vUwS4erizTIyP7WIcFRAebx3XvgeNypOtUy27c2pK2eYGhy0uXxf91OXmWvmDdaBc4MBBSNQ2mcs3bv2yX4N895XLbb2QgLD+7cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375963; c=relaxed/simple;
	bh=QTey0AX7bAhX7uyHlRzwMxS6KTkjyu6q9JzGgnzf04E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l5V+gFcNjRBd+j1oWjW8TOXhyAqcknP0tPnuvkXBkRDdE0kepxvdGq30fWSe6O1KrV6DAYosu4OoJPdhXhy6oKo/NZEegdHWjJW9AM7D8tRBEUNX9SIBzowFFLifIXg1zWAXQDzPdb+d1gj7LuseVujpuHQXE0h1zKt5Hb98uVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=huS1hBp0; arc=pass smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="huS1hBp0"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3939d2bd739so50201961fa.0
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 08:06:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779375959; cv=none;
        d=google.com; s=arc-20240605;
        b=a7xbCG8cP7NRd02V58OX9zNgiP0BlvZTbQIUznvipTaD6bd2eaztl7J9gZUNBALIRA
         w0TzqBdIqCLlvf11/NpM3NUKzq/Uxhs1eiBw4QE94ufrr3mpEP2LaXaEDbmJCUqfhf1s
         At13rXlI6bMIo8mDpJQgaRfhtoYX4bsH9BQHc6GPz4Xmxkkmp6I4C8P76nXeqaB42mGS
         kiMfrijtBOewcQB5TpKXkTt71BogTlqIj52MCZGJ0Ln7LiVoLbnt9pYsIGg5m+wn9zLQ
         e0xi4GuAPbYMu823XI2t0Ovhs6JXaPT6iyUdlOIHobasQbWqS67n5ocj545TEhApg+7s
         hcqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=etRNq7lQsJ98L0l2lIG9g3q/AsJpV/YyssFAQsYxgvQ=;
        fh=loSLvoiriEZ3MCPUgxKxEKU0Pt3vSKug2pwknWvcFH4=;
        b=OMvzDNwAZxUCu/mgpsrbkeUEy5JzZ/R5RSN6gpnAc6/ZNan8Vqu3yNCV54oQOBxvQF
         5MXOjVbkYzXFaNH6hEx03Da6VIBgT8iROUcLD5JrWaHF5UPW7QC4lHP1jTwj9yamALqH
         guitvKV58hZ4voPZ8/RBdBM7ZIQYZ2qajvMyGukDiF4Me+baGhl7JQtmz9tN+AMjDLKg
         1aO9+IRm3dW7CMr5xTiX6no0PwDS7NLdacMwOqXPErpje05qINpC5pm10oNkIKq8aFaC
         6akw6UJ/ezQX5ShL2PSP8pc90UN5DSVtmWr/XU2NPH/zE2BFlsJWmCwM9qi3i18JACe6
         z3xw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779375959; x=1779980759; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=etRNq7lQsJ98L0l2lIG9g3q/AsJpV/YyssFAQsYxgvQ=;
        b=huS1hBp0B86juOHdI2mQURHAPO5phEfSBAvIK9HmI4GKPEUnknQ5BVf83kj8yVx5Fu
         CjpVTNifefIFH2HA7LOALK7f7+9chowNE19fPFOrBwZaaOhOeB2qwYyPX8iM6Sn/dqED
         3PVExZqAt3ZQ5Z3RdypEzSLj4akj4T56yiJgg7EAsZgTR3aM8nKj8vM9NDsLPdbzbE3P
         XYtTp+KwDgOVwgAH1rJSJ8liiys+YAoQa+OKTkDHYz/QWsfMYUxEhII4llZT+9uDpyot
         weIjcDgqBceDRfFDqwEOCy0m+/r1ipjaGY1MwZ7yWBkJrkihQd5bx++wezFrmwecHhpv
         qK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779375959; x=1779980759;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=etRNq7lQsJ98L0l2lIG9g3q/AsJpV/YyssFAQsYxgvQ=;
        b=nK3RSxCJkJ6hjWCNpisKhuF0u3fPkgIUyMQLfNT6zzii2ek6x+wsiT6sEvM+QJXpLg
         mALYimbk0maelqtqlAfKF3n+nPbuiPIBqB7ABjycri6pN0aX9E6Wb7PsAJInY4xPbpKI
         FeemFtQjK4saaumv89HZCi9LCZzZeCCL/op08SDefKkQ32rAlKudq/E1SU9A7mm6MwPi
         AkHyOagRBxXj4+Lv1+c5xQZGxFZLegCXCbb2eFey1xa8BQWli7y6cvymroEjk3UbcGzo
         TAMxtRRh1bWR5qHXsdyD3VxSelbmkM/3afHcCriDcL2Czcj/GiwAYHlo/RkN+NTnHXuF
         JXdw==
X-Forwarded-Encrypted: i=1; AFNElJ8jGo+WkptnNdlIb53HaLZ/uXmysWJhivOPKI1GCmI4YngMeJqtujhhus++1Eyw/aHyzeXAxHA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWwisknGAApHUM0jMab01Y5OEnkVFq0krF5YfwB9Z5fk0gmqce
	5oMXyU5HXlLyavkc6CqTSottbQDZt4V+plh8gBeXGrt9NL6DxS/fy9y1oJM9O3AdVRsvDxchdSU
	wSQyQQwWLW3nRoune8QAKkGb2QalfLxDYmtLgVBIZ
X-Gm-Gg: Acq92OHtpfI1YhnCZQ5CB06GHBW78XuvKlos2kuHjbbzK+PhQlmcl7pxirX6vVM9CZI
	x4xZtOf4j62SJFuyK/M8XVweVNwkxmw6sBBsi02VOTA5+vdTHSAc7FHGaqmSpirZgad0EB3Q9ft
	PscZoWNM7mdZkHJdMFOpZLD/Vqqn9n+I/nynOz2/RT3mhAjMiSSUcrmRjmNBk8b2/trPS125HfY
	xSFB7qYUyALfkkiFKTqePz+u8HsFD3AeQjGhIiSdUHGTatnWu+0WfD73wf2idkgvwBqmwUOwx9/
	M07hXdPZyXCAkScgkE+cAvpHyB7A0J42xlLvRySGJv8V7A5qJpqzxFSGgc0kNLYvNGIls7v31zJ
	PEOVO
X-Received: by 2002:a2e:bc83:0:b0:393:903c:2256 with SMTP id
 38308e7fff4ca-395ca6b460emr13138891fa.26.1779375958847; Thu, 21 May 2026
 08:05:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <13d16b15-8e25-40f2-afbd-eb9b486bf1d2@mail.kernel.org>
In-Reply-To: <13d16b15-8e25-40f2-afbd-eb9b486bf1d2@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Thu, 21 May 2026 17:05:46 +0200
X-Gm-Features: AVHnY4K-l3ty-WG_v3ECIscFyNW2pLRn1-7t9ODsmERfoxP9TScE0XBzy_TjMW4
Message-ID: <CACT4Y+Y7pawESc96N6yHyZ-vyY3BEAmBWdcaMposffWsypMZ9A@mail.gmail.com>
Subject: Re: [PATCH] bpf: lru: Use resilient spinlocks to prevent NMI deadlocks
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation+final@googlegroups.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 19 May 2026 at 09:10, 'syzbot' via
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

Add comments to the code about lock failure in stealing, push and
flush operations as to what are the consequences, any why we prefer
them over the deadlock.

>
> Fixes: 3a08c2fd763450a927d1130de078d6f9e74944fb ("bpf: LRU List")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+c69a0a2c816716f1e0d5@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=c69a0a2c816716f1e0d5
> Link: https://syzkaller.appspot.com/ai_job?id=5256e80f-91f9-40da-865e-578a2aee46ad
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
>
> ---
> diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
> index e7a2fc605..3d6613378 100644
> --- a/kernel/bpf/bpf_lru_list.c
> +++ b/kernel/bpf/bpf_lru_list.c
> @@ -4,6 +4,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/spinlock.h>
>  #include <linux/percpu.h>
> +#include <asm/rqspinlock.h>
>
>  #include "bpf_lru_list.h"
>
> @@ -307,9 +308,10 @@ static void bpf_lru_list_push_free(struct bpf_lru_list *l,
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
> @@ -319,7 +321,8 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
>         struct bpf_lru_node *node, *tmp_node;
>         unsigned int nfree = 0;
>
> -       raw_spin_lock(&l->lock);
> +       if (raw_res_spin_lock(&l->lock))
> +               return;
>
>         __local_list_flush(l, loc_l);
>
> @@ -338,7 +341,7 @@ static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
>                                       local_free_list(loc_l),
>                                       BPF_LRU_LOCAL_LIST_T_FREE);
>
> -       raw_spin_unlock(&l->lock);
> +       raw_res_spin_unlock(&l->lock);
>  }
>
>  static void __local_list_add_pending(struct bpf_lru *lru,
> @@ -404,7 +407,8 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
>
>         l = per_cpu_ptr(lru->percpu_lru, cpu);
>
> -       raw_spin_lock_irqsave(&l->lock, flags);
> +       if (raw_res_spin_lock_irqsave(&l->lock, flags))
> +               return NULL;
>
>         __bpf_lru_list_rotate(lru, l);
>
> @@ -420,7 +424,7 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(struct bpf_lru *lru,
>                 __bpf_lru_node_move(l, node, BPF_LRU_LIST_T_INACTIVE);
>         }
>
> -       raw_spin_unlock_irqrestore(&l->lock, flags);
> +       raw_res_spin_unlock_irqrestore(&l->lock, flags);
>
>         return node;
>  }
> @@ -437,7 +441,8 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
>
>         loc_l = per_cpu_ptr(clru->local_list, cpu);
>
> -       raw_spin_lock_irqsave(&loc_l->lock, flags);
> +       if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
> +               return NULL;
>
>         node = __local_list_pop_free(loc_l);
>         if (!node) {
> @@ -448,7 +453,7 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
>         if (node)
>                 __local_list_add_pending(lru, loc_l, cpu, node, hash);
>
> -       raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> +       raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
>
>         if (node)
>                 return node;
> @@ -466,23 +471,26 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(struct bpf_lru *lru,
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
> @@ -511,10 +519,11 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
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
> @@ -522,7 +531,7 @@ static void bpf_common_lru_push_free(struct bpf_lru *lru,
>                 bpf_lru_node_clear_ref(node);
>                 list_move(&node->list, local_free_list(loc_l));
>
> -               raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> +               raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
>                 return;
>         }
>
> @@ -538,11 +547,12 @@ static void bpf_percpu_lru_push_free(struct bpf_lru *lru,
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
> @@ -625,7 +635,7 @@ static void bpf_lru_locallist_init(struct bpf_lru_locallist *loc_l, int cpu)
>
>         loc_l->next_steal = cpu;
>
> -       raw_spin_lock_init(&loc_l->lock);
> +       raw_res_spin_lock_init(&loc_l->lock);
>  }
>
>  static void bpf_lru_list_init(struct bpf_lru_list *l)
> @@ -640,7 +650,7 @@ static void bpf_lru_list_init(struct bpf_lru_list *l)
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
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/13d16b15-8e25-40f2-afbd-eb9b486bf1d2%40mail.kernel.org.
