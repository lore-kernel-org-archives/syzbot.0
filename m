Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454D63B2FD6
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 07:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779174296; cv=pass; b=dwY+iE3Ap0pWWjsk9R8A3t/tAgDKzFmBftyzUmNs9CXbosmZb6NSzawSVMPFX8iJ9nqCSK9BBW2RA6KVSUhFXjq2r6Vne+RsiiEAkNZS9y7IKLz4xGr9l3WO6ezsYivKDy/GjOSMe5QDs0v0Z9OGzctHUeWsV9psFfbQ7MuCXOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779174296; c=relaxed/simple;
	bh=/Pe1JTitLygpYSjj5PB3mDWTLqS3OY9PrSlHV10Gojc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IrTj4JFQj1WWH8hAkzbshOENDRFkxnwSv3PHScm3pMNQdIIGdc7HEO3YIbYGDpPeZL152JmxOv0corsPgU1IUY/CyQPgRZnLv0RCayBT/Xez6Lo9YM7YmpNwB0As8dXnkFD4/cOHLf6QxE+gA/ju0WjSNbT4rhCz822OPGoFJ7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hsoRivKp; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hsoRivKp"
Received: by smtp.kernel.org (Postfix)
	id 00BDBC2BCC9; Tue, 19 May 2026 07:04:56 +0000 (UTC)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AD3E2C2BCF6
	for <syzbot@kernel.org>; Tue, 19 May 2026 07:04:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org AD3E2C2BCF6
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-393a44854d2so30974311fa.3
        for <syzbot@kernel.org>; Tue, 19 May 2026 00:04:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779174292; cv=none;
        d=google.com; s=arc-20240605;
        b=Epqi469wp0zhoARjqwLUdrpelOVhzo/WilQHAyuXrKwkicaGSZDTygQh0pEaE7ATsI
         Qsw1o4c24vnG5PFMG06Zk2pUJloUWPjaItC1QmC1aNEiqGlrwoqUG9UlBXxT5ddh+I+f
         5FPapc1/Qnl3KCJ7WjdVXRa2ybCN16Ajta4lKUW+979ufV/fWpls9LAr2lHBT/8v6GD6
         X/wtg6kf1l6U1l78tFR7OqwR0bycVHGRWSm0HTcEWKAZwJxd9s3ksyMKRtAyakcLFpwi
         c02wlmIGdVzl1sU7bV2yEcXn4q1i3TEktfVFVvf+BWJa2cQ40Yu/+K2+F6EoNiBH7xPg
         CP3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ywBMRN0mnCPEmgB26CJ1z4VMcsMywyOMp26vWktnrl4=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=ZqBMXC1LDiS0UdLXq+dcqcNn5oa7KF/Xmxaa6574cJFe2z/wxJpJ9dmC+mPSiRFynp
         VFkhH3qdWSwz9a/nT4bD1NknVoKdLlOe2V/AZB/FaDPKWZRM/81rq58gP95nsIxPIJ4u
         jeBJC+AE2+PLIPtxuLkGZhK6DM+2Edii8GOLZ0iuNNVINLzqq5NaJ2OkRq0hqJXtbyVC
         2rNxnx8r1lo9JTbkspzALOwB3lwaKGbKp4hQVOeidCJWFcZmxMFgtDzpZYlbp8hTK9BV
         lmsMuZZs2IW91GCdQ/R2KHfl7En1jSQCPubBo8XGEJBHaV4gTl3PiKGxAef+calTTUzE
         z+rw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779174292; x=1779779092; darn=kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ywBMRN0mnCPEmgB26CJ1z4VMcsMywyOMp26vWktnrl4=;
        b=hsoRivKpE2XZtZaH8yVTu1lQOXMuDZqZeYsaQ2BIAvQ33PKEqtCep1prgyEo0mfUCc
         /eLA+k4pvTk2WnTroU6v9IpmRt6n1mffo1IHd0uCK540p4ukEqTfUw210TlXSfiMzfqV
         ADi74kCySSYr3+Yi5z8rGdkuireQNPX56WZOXUFukJ0NZ955f5JsK8u2W2y2ss4kRsua
         aFUM8x29iy0pw4rzi9uvA9/1Pq3pRxOeUcTAjYeEkK9KMszHScakLSctua6xSSSWWHU3
         aqADzLuIvjCmKf52ao83enhWoBBwM9Rc4UrOtCUg0wItPQqeKmVHWsddbLEhi5Pp/Euy
         p/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779174292; x=1779779092;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywBMRN0mnCPEmgB26CJ1z4VMcsMywyOMp26vWktnrl4=;
        b=XzQMUwqDK/Xie2dlBHxMbP5JLG0oKfIw0vV4xcPTqWlnLzUBdnEmKe2S1VjzGcBiFW
         GQbb21LnC4oE4VAyUnDLhsXk9xv77jIo3Do5GH+C73HHdhk/FB/cJOHQwu5niO30GPZy
         LXIHmV0wNQTT3KQMXDY2+j1G4Kg0cJm59Hs+kAYtvL+8vsPadOqX9bmQ1cL3VyGMoTSi
         jWcNwYd6NfdhvjJuv6uV9dBUmln9GY/iCpmvrfO2FjyYCmjIyKtUYYZb39UkKPQrX0M2
         ltKmie2LDbeNRRTS0sMvjNM/r9v7gkkiqI57igRXGUxVWKh8S1gpZPWLmwhlJ9eaLxXA
         XJ1g==
X-Gm-Message-State: AOJu0YzOAvKop/8fZGOQ72/BLm2Kz5YXk3qgGxJc2UzVM1Hqt/uefl2f
	WUgHNagAgSAGY+NnnJBoSWJi505WY62FF56OQLWWJAtqBz7aNZ0QCMxVOJmvWn910j1B0287v0Y
	HgK6LU1VQ2OPvkhRil2ZI4rBVuzF7kQpwhqKzT2iLpEYgN6IiZ94T/x+2
X-Gm-Gg: Acq92OGmQ8exKONWU8Kkm5Zp77wihANt7Xo7uO9Ed8IAlo11sT5qiXHCSOKg5qMoYcd
	/Yjw4cNhkjqCoXfyRWTpqUsHw4D2ASCeFHcdt50rXxKWvpuhaidomeqrrpgO2aKfKBJkpxhkNrw
	rVx4E9MLIddY3s2uGFBT7V4PJVy51alF32epQlyvMSWOyQ+VMLxm7gsaxTvzSMh6t8pX1ODjXRT
	ia1atGfkpLDgvDhtvyGkJ27GfM1oIviSUDOtoUuIQaf0olffUYth+SOVP1Ux7ni2LsxAUbxToC1
	4zOgFJwJsIiAslPRrOXQFdvy+dxFehCZE4NO4wHsroE2aVhZHCfJRdI+IjD1Iqrh4/y+kyuoSu0
	AUl1Xkw==
X-Received: by 2002:a05:651c:325b:b0:393:ba06:1591 with SMTP id
 38308e7fff4ca-39561adbbd5mr52615291fa.5.1779174292106; Tue, 19 May 2026
 00:04:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <471284ae-0b11-43ca-ad34-e497fe2ee24e@mail.kernel.org>
In-Reply-To: <471284ae-0b11-43ca-ad34-e497fe2ee24e@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 19 May 2026 09:04:38 +0200
X-Gm-Features: AVHnY4KgK2Pq5IAGjVVc_iWLJ3oiwV1VujQQK5_fG-kA5fOwcb4WceM-Cohp3Cs
Message-ID: <CACT4Y+b=UYSxh_7Ct+x4Trh8fR2R=uLJj4_EFzRXiZ9f2Chp6Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2] bpf: lru: Use resilient spinlocks to prevent NMI deadlocks
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#syz upstream

On Sat, 16 May 2026 at 19:17, 'syzbot' via
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
> Link: https://syzkaller.appspot.com/ai_job?id=5256e80f-91f9-40da-865e-578a2aee46ad
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
> v2:
> - Added missing `<asm/rqspinlock.h>` include in `kernel/bpf/bpf_lru_list.c`.
>
> v1:
> https://lore.kernel.org/all/dcebc4bd-5cc1-4dc9-b82b-6cca0fad128b@mail.kernel.org/T/
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
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/471284ae-0b11-43ca-ad34-e497fe2ee24e%40mail.kernel.org.
