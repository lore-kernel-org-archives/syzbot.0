Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0476390C8C
	for <syzbot@lists.linux.dev>; Thu, 28 May 2026 10:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779962704; cv=pass; b=utodbX1tF4F5n7lDR4nSzknAXPL7RB6m0SfHzDDjPoMWhp/ls+MJ2ndcOo13LJHzd5NgzP1BYcTwDoQDRl3Zix3kslJZavTnkE70hgeiccFtcolk2bo0kVlLbH3umFkcAePVoYt4vO2GnNe5nsacZYCMkDguXXfXJ2YvwLwDGPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779962704; c=relaxed/simple;
	bh=mZGTf8Uoq0+3RKvaRgNzaRTYJ9Qw+43aUbOtdASmpCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=teTKbFLIkh+nIILrb2V760o7OanVnfq0OgAsxJ9qGd0u+HsBG+oKmR/2WlsgltPyS2eoPh5Eh9TbhpAZOm1lcR8C2vRJJYasEJSvGz6Mj3U9P/6ZmIbyul1u/o8QmdeGqUyz/Un2SxmvBOawe5ubuNiIiFcMj61Qli8eKnUOxuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NhXT0C8Y; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NhXT0C8Y"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-439a7e828b1so10281740fac.1
        for <syzbot@lists.linux.dev>; Thu, 28 May 2026 03:05:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779962701; cv=none;
        d=google.com; s=arc-20240605;
        b=SHl1ffhoogYd0DB74SSwHuhwhgq/HD0m2qhOPzEhM5RYnfAffarESVGfx0paZy4040
         yL9y94HHavbpsnTawH3M/TeYT3fj8/bDewLM1yHI3z52jOw7kAIYBi/wH+Q6HZ7hLEx7
         aEBm/WVeHF1mfUCLB8J8TN1tg9nhvPy9i1rjz0sC2Fd6b4k5hrPfXYEUG3C0jqjyKPQp
         xpAzC7GsAKk4w60VArTbfiBXH+IaO0tAWLAjNd9qR0K33BE2QhqNj9qgVhanDJw9s9H1
         EzU2QJ+jGcGuLdL4oP79jkTqZC5ZxPIVduSOYNjtOBQ9bc3TyfmkEsj9h4ZShGOqG7CT
         +uog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KpigqoGai3Ke9DoEhKm+gp22mb6OaHGNtw+4U0fuzA0=;
        fh=KX3Pebhb43ASoUFs95lvIaGxcmMwRQLiABO4kHRqVMI=;
        b=RyFfCYf4+knPVpuZnGgyeaKr1/Ynn/Nk1enrND7SJ2UbYW8SNGRYCeVxhPS7G0/C3Y
         Xswz8qc2gqQkqEgukxlw1uWPMlnk6NQkp6li1+yKzaojaETn5asZ3cd2UpCJDSBIFUIE
         yoQWmo+FJFaUyw9wjMKUksqnDBKa75PEnIfq0rBtAKsW2boBXya3wK3dumI4h+VU/cNo
         JACn+yffLQ3e8CZOG7FezNcPJmmhh8HsWVnRHB+KdanPnkKSLmMc4pi4Jby3A6I+cNC4
         M2MOhb8xZ5VaA49zkOyBFbq/QryOOL0qd4+AUIaf/rvIX0EiUvqYdc27In7dYoU/ZuQZ
         LZbg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779962701; x=1780567501; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KpigqoGai3Ke9DoEhKm+gp22mb6OaHGNtw+4U0fuzA0=;
        b=NhXT0C8YHav3ZroOi41YLwNo/O6I1MmDF9LJxHsP59nsE+XsPutZyaJiWaFbPBAcBI
         wnuhuKMUoiSX4+1LIUUODvk/wCAaPuy/wUtsFUf8BXLNU4qU8DQrhzJFlWhVjPCVSdaX
         k3gr6eP7wvhRM3RQvEq9XZFDGFYbLsLJNyQHwbThbF3g5GR1Gfq3GtT3Fkl4en2AqBgn
         JIsczD8w8KrxI8CFv9dbBhpLCxTdVrxuRSg0RsyPiYZz9YaCj1f4+UoDjyTPam4XjJ5l
         Ic+n7IyfhDQEfzQzgWrUBlMIHvIMzIgq18/XUibM3X5juJgQZimtCxwmPZLpF3CAZumc
         Shnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779962701; x=1780567501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KpigqoGai3Ke9DoEhKm+gp22mb6OaHGNtw+4U0fuzA0=;
        b=IB4zpN2o4WeS3JxuKOmmiTgpAtrQ2pMXHQubk+I6oxuU2THqo/1JClxxslZaSieCLr
         CCYGUv0ghfIBLWfHcynmZy4xlAzkXRqj24H4buUpuP0KpJqOidk6Ci9X6IAs5nV3ILTD
         Is/zqezLYuc3VrKvbC8NILvSsOQGwMtM+qdv6HgapCOUAETJdQ0q7CXZkhSmdLRZaY7y
         hF5iCSDgBy9s/jsUNqpuGviRBwok/hvYLdrwgenFJbaa/wv7SML9urf2pXPhNaFD2ZGG
         oUJ/uCa6oHtwxP7t669Vw9MN1klnBvjvrcvqzxR44zbXFG1yJP9tpLvuPnxZQd+oZqZF
         uZlw==
X-Forwarded-Encrypted: i=1; AFNElJ+6vkmIhZoUlVqfaInEmqbea9sqYGBC6xmNVnW+pe4qDq5AkP7IadrAAy8XXeHvinkpfiwrmtA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz09ezQLqoxMJAFeaRBHC56IIQ5KNiSltSkUxhMObj6XzgVRNwM
	B9OUxy0qBUW/8w6bgFCsJ6z2nXyM/55BHY/YLGanU91uMYuFlKlloyjzOzMPj0krme15VGzQJUM
	qBnLVDkPPgYLw4uxbiabRqRFrpVnGGOsxDedRezyJaAJr71shOa+pQuXo
X-Gm-Gg: Acq92OFF3+1rSQsvUDRJByom6jnEUYDlXuqlP1kDn6VovwbZOBXNE+SJzP4ttpx9B7x
	VBUhKWU/SyBkLAD+LqNH+smI7pIWeTYPy5B2yPkqvSLQOnkI9PbTjJEH2HghD3q2/rYWnaT7bti
	xNf6d4/UU2a58z7i0wvPJ2/Geuqmm7G1P488vt7RvTY+At+Dn0tbX7figArnN/cZxjS/IC20JFo
	4QODe6rIFlFWaj1yLBDFet9vjz1knAt5tfmn8Onsx3klzG6GTCsBQN8mfH+aRY8kNpFeJ9rhSUo
	LshwyeGncrWC4kuxKrKr+7fvWJ2C8HR86nAVUClbX048WwSMhM+/dL8UT0begnMuxx8HnwQ1TY3
	U0JF+DI8mSdYSZe4=
X-Received: by 2002:a05:6808:c182:b0:485:4202:eefc with SMTP id
 5614622812f47-485d9517844mr291569b6e.3.1779962701023; Thu, 28 May 2026
 03:05:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <13d16b15-8e25-40f2-afbd-eb9b486bf1d2@mail.kernel.org> <CACT4Y+Y7pawESc96N6yHyZ-vyY3BEAmBWdcaMposffWsypMZ9A@mail.gmail.com>
In-Reply-To: <CACT4Y+Y7pawESc96N6yHyZ-vyY3BEAmBWdcaMposffWsypMZ9A@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 28 May 2026 12:04:49 +0200
X-Gm-Features: AVHnY4JEM1j4cEaUUBnvyKMCmlQIF9mz49WU1a4B6cAFkU1XVipbtDTqwKBQpNA
Message-ID: <CANp29Y6U1Gn26_hnX6G94RO+OeU0VUu5qub-EmmAEVGN4cxXag@mail.gmail.com>
Subject: Re: [PATCH] bpf: lru: Use resilient spinlocks to prevent NMI deadlocks
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation+final@googlegroups.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz reject

On Thu, May 21, 2026 at 5:06=E2=80=AFPM 'Dmitry Vyukov' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> On Tue, 19 May 2026 at 09:10, 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
> >
> > BPF LRU maps currently use standard `raw_spinlock_t` for their local an=
d
> > global list locks, which are not NMI-safe. If an NMI (such as a perf
> > event hardware breakpoint) interrupts a normal context that is holding
> > an LRU list lock, and a BPF program executed in the NMI context attempt=
s
> > to acquire the exact same lock (e.g., via `bpf_map_delete_elem`), it
> > will spin forever waiting for the lock to be released. This results in =
a
> > hard deadlock because the context holding the lock has been preempted b=
y
> > the NMI itself. Lockdep correctly detects this unsafe `{INITIAL USE} ->
> > {IN-NMI}` transition and emits an inconsistent lock state warning.
> >
> > To resolve this, update the LRU list implementation to use resilient
> > queued spinlocks (`rqspinlock_t`), similar to how bucket locks in
> > standard BPF hash maps were previously converted. Resilient spinlocks
> > are NMI-safe because they detect deadlocks (such as re-entrancy on the
> > same CPU) and return an error instead of hanging. Replace all standard
> > spinlock operations with their resilient counterparts in
> > `bpf_lru_list.c`. Since resilient spinlock acquisitions can fail, updat=
e
> > the LRU functions to handle these failures gracefully. For pop
> > functions, return `NULL` when the lock cannot be acquired, which caller=
s
> > already handle by propagating an `-ENOMEM` error. When stealing nodes
> > from remote CPUs, safely skip the CPU if its lock cannot be acquired.
> > For push and flush functions, abort and return early if the lock fails,
> > effectively leaking the LRU node, which is an acceptable trade-off to
> > prevent a hard system deadlock in NMI context.
>
> Add comments to the code about lock failure in stealing, push and
> flush operations as to what are the consequences, any why we prefer
> them over the deadlock.
>
> >
> > Fixes: 3a08c2fd763450a927d1130de078d6f9e74944fb ("bpf: LRU List")
> > Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-previe=
w
> > Reported-by: syzbot+c69a0a2c816716f1e0d5@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=3Dc69a0a2c816716f1e0d5
> > Link: https://syzkaller.appspot.com/ai_job?id=3D5256e80f-91f9-40da-865e=
-578a2aee46ad
> > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> >
> > ---
> > diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
> > index e7a2fc605..3d6613378 100644
> > --- a/kernel/bpf/bpf_lru_list.c
> > +++ b/kernel/bpf/bpf_lru_list.c
> > @@ -4,6 +4,7 @@
> >  #include <linux/cpumask.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/percpu.h>
> > +#include <asm/rqspinlock.h>
> >
> >  #include "bpf_lru_list.h"
> >
> > @@ -307,9 +308,10 @@ static void bpf_lru_list_push_free(struct bpf_lru_=
list *l,
> >         if (WARN_ON_ONCE(IS_LOCAL_LIST_TYPE(node->type)))
> >                 return;
> >
> > -       raw_spin_lock_irqsave(&l->lock, flags);
> > +       if (raw_res_spin_lock_irqsave(&l->lock, flags))
> > +               return;
> >         __bpf_lru_node_move(l, node, BPF_LRU_LIST_T_FREE);
> > -       raw_spin_unlock_irqrestore(&l->lock, flags);
> > +       raw_res_spin_unlock_irqrestore(&l->lock, flags);
> >  }
> >
> >  static void bpf_lru_list_pop_free_to_local(struct bpf_lru *lru,
> > @@ -319,7 +321,8 @@ static void bpf_lru_list_pop_free_to_local(struct b=
pf_lru *lru,
> >         struct bpf_lru_node *node, *tmp_node;
> >         unsigned int nfree =3D 0;
> >
> > -       raw_spin_lock(&l->lock);
> > +       if (raw_res_spin_lock(&l->lock))
> > +               return;
> >
> >         __local_list_flush(l, loc_l);
> >
> > @@ -338,7 +341,7 @@ static void bpf_lru_list_pop_free_to_local(struct b=
pf_lru *lru,
> >                                       local_free_list(loc_l),
> >                                       BPF_LRU_LOCAL_LIST_T_FREE);
> >
> > -       raw_spin_unlock(&l->lock);
> > +       raw_res_spin_unlock(&l->lock);
> >  }
> >
> >  static void __local_list_add_pending(struct bpf_lru *lru,
> > @@ -404,7 +407,8 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free=
(struct bpf_lru *lru,
> >
> >         l =3D per_cpu_ptr(lru->percpu_lru, cpu);
> >
> > -       raw_spin_lock_irqsave(&l->lock, flags);
> > +       if (raw_res_spin_lock_irqsave(&l->lock, flags))
> > +               return NULL;
> >
> >         __bpf_lru_list_rotate(lru, l);
> >
> > @@ -420,7 +424,7 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free=
(struct bpf_lru *lru,
> >                 __bpf_lru_node_move(l, node, BPF_LRU_LIST_T_INACTIVE);
> >         }
> >
> > -       raw_spin_unlock_irqrestore(&l->lock, flags);
> > +       raw_res_spin_unlock_irqrestore(&l->lock, flags);
> >
> >         return node;
> >  }
> > @@ -437,7 +441,8 @@ static struct bpf_lru_node *bpf_common_lru_pop_free=
(struct bpf_lru *lru,
> >
> >         loc_l =3D per_cpu_ptr(clru->local_list, cpu);
> >
> > -       raw_spin_lock_irqsave(&loc_l->lock, flags);
> > +       if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
> > +               return NULL;
> >
> >         node =3D __local_list_pop_free(loc_l);
> >         if (!node) {
> > @@ -448,7 +453,7 @@ static struct bpf_lru_node *bpf_common_lru_pop_free=
(struct bpf_lru *lru,
> >         if (node)
> >                 __local_list_add_pending(lru, loc_l, cpu, node, hash);
> >
> > -       raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> > +       raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
> >
> >         if (node)
> >                 return node;
> > @@ -466,23 +471,26 @@ static struct bpf_lru_node *bpf_common_lru_pop_fr=
ee(struct bpf_lru *lru,
> >         do {
> >                 steal_loc_l =3D per_cpu_ptr(clru->local_list, steal);
> >
> > -               raw_spin_lock_irqsave(&steal_loc_l->lock, flags);
> > +               if (raw_res_spin_lock_irqsave(&steal_loc_l->lock, flags=
))
> > +                       goto next_steal;
> >
> >                 node =3D __local_list_pop_free(steal_loc_l);
> >                 if (!node)
> >                         node =3D __local_list_pop_pending(lru, steal_lo=
c_l);
> >
> > -               raw_spin_unlock_irqrestore(&steal_loc_l->lock, flags);
> > +               raw_res_spin_unlock_irqrestore(&steal_loc_l->lock, flag=
s);
> >
> > +next_steal:
> >                 steal =3D cpumask_next_wrap(steal, cpu_possible_mask);
> >         } while (!node && steal !=3D first_steal);
> >
> >         loc_l->next_steal =3D steal;
> >
> >         if (node) {
> > -               raw_spin_lock_irqsave(&loc_l->lock, flags);
> > +               if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
> > +                       return NULL;
> >                 __local_list_add_pending(lru, loc_l, cpu, node, hash);
> > -               raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> > +               raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
> >         }
> >
> >         return node;
> > @@ -511,10 +519,11 @@ static void bpf_common_lru_push_free(struct bpf_l=
ru *lru,
> >
> >                 loc_l =3D per_cpu_ptr(lru->common_lru.local_list, node-=
>cpu);
> >
> > -               raw_spin_lock_irqsave(&loc_l->lock, flags);
> > +               if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
> > +                       return;
> >
> >                 if (unlikely(node->type !=3D BPF_LRU_LOCAL_LIST_T_PENDI=
NG)) {
> > -                       raw_spin_unlock_irqrestore(&loc_l->lock, flags)=
;
> > +                       raw_res_spin_unlock_irqrestore(&loc_l->lock, fl=
ags);
> >                         goto check_lru_list;
> >                 }
> >
> > @@ -522,7 +531,7 @@ static void bpf_common_lru_push_free(struct bpf_lru=
 *lru,
> >                 bpf_lru_node_clear_ref(node);
> >                 list_move(&node->list, local_free_list(loc_l));
> >
> > -               raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> > +               raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
> >                 return;
> >         }
> >
> > @@ -538,11 +547,12 @@ static void bpf_percpu_lru_push_free(struct bpf_l=
ru *lru,
> >
> >         l =3D per_cpu_ptr(lru->percpu_lru, node->cpu);
> >
> > -       raw_spin_lock_irqsave(&l->lock, flags);
> > +       if (raw_res_spin_lock_irqsave(&l->lock, flags))
> > +               return;
> >
> >         __bpf_lru_node_move(l, node, BPF_LRU_LIST_T_FREE);
> >
> > -       raw_spin_unlock_irqrestore(&l->lock, flags);
> > +       raw_res_spin_unlock_irqrestore(&l->lock, flags);
> >  }
> >
> >  void bpf_lru_push_free(struct bpf_lru *lru, struct bpf_lru_node *node)
> > @@ -625,7 +635,7 @@ static void bpf_lru_locallist_init(struct bpf_lru_l=
ocallist *loc_l, int cpu)
> >
> >         loc_l->next_steal =3D cpu;
> >
> > -       raw_spin_lock_init(&loc_l->lock);
> > +       raw_res_spin_lock_init(&loc_l->lock);
> >  }
> >
> >  static void bpf_lru_list_init(struct bpf_lru_list *l)
> > @@ -640,7 +650,7 @@ static void bpf_lru_list_init(struct bpf_lru_list *=
l)
> >
> >         l->next_inactive_rotation =3D &l->lists[BPF_LRU_LIST_T_INACTIVE=
];
> >
> > -       raw_spin_lock_init(&l->lock);
> > +       raw_res_spin_lock_init(&l->lock);
> >  }
> >
> >  int bpf_lru_init(struct bpf_lru *lru, bool percpu, u32 hash_offset,
> > diff --git a/kernel/bpf/bpf_lru_list.h b/kernel/bpf/bpf_lru_list.h
> > index fe2661a58..ecd93c77a 100644
> > --- a/kernel/bpf/bpf_lru_list.h
> > +++ b/kernel/bpf/bpf_lru_list.h
> > @@ -7,6 +7,7 @@
> >  #include <linux/cache.h>
> >  #include <linux/list.h>
> >  #include <linux/spinlock_types.h>
> > +#include <asm/rqspinlock.h>
> >
> >  #define NR_BPF_LRU_LIST_T      (3)
> >  #define NR_BPF_LRU_LIST_COUNT  (2)
> > @@ -34,13 +35,13 @@ struct bpf_lru_list {
> >         /* The next inactive list rotation starts from here */
> >         struct list_head *next_inactive_rotation;
> >
> > -       raw_spinlock_t lock ____cacheline_aligned_in_smp;
> > +       rqspinlock_t lock ____cacheline_aligned_in_smp;
> >  };
> >
> >  struct bpf_lru_locallist {
> >         struct list_head lists[NR_BPF_LRU_LOCAL_LIST_T];
> >         u16 next_steal;
> > -       raw_spinlock_t lock;
> > +       rqspinlock_t lock;
> >  };
> >
> >  struct bpf_common_lru {
> >
> >
> > base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> > --
> > See  for more information.
> >
> > --
> > You received this message because you are subscribed to the Google Grou=
ps "syzkaller-upstream-moderation" group.
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkall=
er-upstream-moderation/13d16b15-8e25-40f2-afbd-eb9b486bf1d2%40mail.kernel.o=
rg.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/CACT4Y%2BY7pawESc96N6yHyZ-vyY3BEAmBWdcaMposffWsypMZ9A%=
40mail.gmail.com.
