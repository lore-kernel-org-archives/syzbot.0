Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C209242D6B
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 08:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778918543; cv=pass; b=FR+SG79a+1LW+6Kw6MaEdK/b5lKnHxqQEvGOEY5ggmDfi/y9ZGFtab3q2Qw80ee/T/a1Nmo8nP4YyQ0YsuVHLnYtuvpcz8uBnDEdpa5OwcqM7e2p5jPZmeSHY/uXhkrKYvqXKKbaUNQ8Ja7B0+L5mTKDANZeo6h4JNtWdpIp+IE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778918543; c=relaxed/simple;
	bh=eZl4hOVQGE3eXd4gPdEdU9K8AKrJcQTMN6gFBMhpJLg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dxFACqo49hviV2R4O0s4w+jAkiUZxtRzE+nd2zp63YCconEU0EWc26S0ghoOPNyKEwLEpEB7Hi92q7di12SjY+4MWrYGkVG3KZaMZrCrJ0ixQtSHkXnTd64Y9gP3ayEwble5Shh2i0zgPw8Twl3htgIMXQXx/311B2SaFNILlFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P0f5P/hS; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P0f5P/hS"
Received: by smtp.kernel.org (Postfix)
	id F2454C2BCB7; Sat, 16 May 2026 08:02:22 +0000 (UTC)
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AA67CC19425
	for <syzbot@kernel.org>; Sat, 16 May 2026 08:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org AA67CC19425
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-404254ffe8aso536601fac.0
        for <syzbot@kernel.org>; Sat, 16 May 2026 01:02:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778918540; cv=none;
        d=google.com; s=arc-20240605;
        b=WqljzyAbclslt+7vSYDgeW1j3qp6oMSd1Z4mQJrfERrUVvCt6qS2fefc+pVFwmGpWC
         1CR8U9h3Fl7z4spxhZqXw65OIC2LdQPkYGJC+Ut5lcvWRYBgp0xg1PX+ABGnddvl0a/i
         DTrnqkmh+qnib0tqahSzkD/e+mpghTMjdCVQ2lSQavcbvKG14fGBl+i4Hu94hD4EPhTS
         svoKRCgGu6EsCesUj0NLk/yQJKqKr87kuYc5fdRrypbt6Z9Q3rdXm+DtiIFOwpQD01Pm
         /vh85x6d6hbKu+YxbLK8qUvECEXxVA87iR/p2i4Fe8j/56KnFuUsCr/VscEIZ1bGbW/q
         Qbhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h1VSERmK0osTjSj0poYvPuAzYqyOFiP5kuXeoRou3DY=;
        fh=wDINbZTynOzHKZZdfYzTv1C5XrcPd39poBV3E5XRpBc=;
        b=gkouW4AGRW4J2vwzKSDs5orV/WQkThtPIg4d5MD0fSiqhr/PGWW7heoBM1mpmONOXY
         EOhKb/65vcmVZbGZSReX56ik4g+efp57r6RsqwJ8b9nrdwryHaPpzXh5Iio1dGSdtzi3
         cXU+fFt3SPiO4UxzwNZsLzHtY2ux0GqiTmYbz3NZClZFFQnHAQVLmvHDjCishrKyKVHM
         VYOP5287pkuxn/uaSZxNZo2pQqHFImP4vwUvVgQG9DBSMXd1BAzR2AcwI16hppdL2lmC
         TJSDaamKI2WXBP+6tVFgYRxAQY5+TDPNMpgeSiFd5LF6r1OgbXeFZpjtNTa5WjJKmCen
         mlwA==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778918540; x=1779523340; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1VSERmK0osTjSj0poYvPuAzYqyOFiP5kuXeoRou3DY=;
        b=P0f5P/hSkbqjCNZdL1MsSMrlZwmPHx8PNEb7OWYJwfLotNIi5GVHoeDi3owXisIAX6
         /NaeKJQMP1z+y9PdTAjh6v+mkzvDVUnVpPCGuTFuZV39qpU7N134EtUPD0XWvroQ2PxO
         ZoWlQOzNwjW96FtbeDUIPxnN6oRjot1jRcDTlim1I+1iYZMqq0NRrtKTDOr3p/NewcTK
         Qs/ph7GBzQe3eHK+F3i9GzDTJ1y2nQSl/R6OgE5bqzeQOPJe3HPOn7VCe4OVbTcQpaxr
         YXPP69GJO/cHR6SywJc/75n9tSAiZe0QtZh6ANrryFDYkZ7eQ9Q38zOBeoPU0FIUWggR
         ZVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778918540; x=1779523340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h1VSERmK0osTjSj0poYvPuAzYqyOFiP5kuXeoRou3DY=;
        b=Nwk04CL9NTcOgkYAsaJ1aOFHpZm4TAR/P2jcIiVEVQIlzHQ76d+3mJkKZn0eimDETv
         3U57T86svip1vhaGvev7F4BLFpczD2pEbx/affBpsRez7EE6cbgdnyZ31dXYYVTlqyYz
         sntFFPEmTCdx9mIJzRYVYeaBuiAT6gzj7k2hzOFYI4ecZPe7dAs2V9hf5h1Iokr1PDTE
         cBrZ4gL9V1j6TB9t89rMx0hO4yoEtFR6lYP/eFv52HIgX7eYmpgRN+75dDZTCc98TOKh
         eFM7SsdPgm3eqhY8HMvRm0YdfKhHWicnQ6y7ZymUUsQD/3WkGi67Y8vMTSHfGpUot0xn
         zNeA==
X-Gm-Message-State: AOJu0YxSMwOhh3hzreG2AqV5H5DvrjpaYm3pafrafTOAMOAkPnypuLI/
	9fLYRDSjA0aME7tx2jsuNeDCMtZScj2u8UaisaccyBescGQs8jLxgFtGr8FpgMUbn1SG6ZKCJQL
	pCubRFzGG8Z1JnZoizcg13cUYE/CMXS0JSRc3Pqn+
X-Gm-Gg: Acq92OExaGgN/1GqauUxEYJLS+BVea1XiH/Ey9ZnyizI0CDw3wId+DqqlD2RGLRkkJb
	2ZkNGBinBOd2wz3RgkxZ4InZl3bEVwuti9f1WFapWKdIfx6n/n++nlmWnaQXDumt+BYUWCKYO7u
	qkwhnD7OoVxtMD3Nwwo6fulbUPHdHikwADjyllCoWpYKovCZtM0JmwliS213l3SC3VJCQBvtZ08
	a7IZllLQtc4g4rc8WC44eRTbhqNwmA0H5fTjw6J2oIuq1KztA+YLJjb7aCZXA0/X/WS1ucjgFNm
	2EUJ0/jwJxtTmEkmusjMb3yFqxIQ6FFUNDcK1lhn8CbNDF0czC+Q4MmcSrYvV30/4BkN08hDYkC
	bwRNGDck=
X-Received: by 2002:a05:6870:ec9f:b0:435:25c8:1833 with SMTP id
 586e51a60fabf-439f94bfe2emr6357882fac.17.1778918540125; Sat, 16 May 2026
 01:02:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <dcebc4bd-5cc1-4dc9-b82b-6cca0fad128b@mail.kernel.org> <CACT4Y+bG9MvoSJb8G4XOquvcb+aQDXkF4XM=-zAEJcNFXcg4cA@mail.gmail.com>
In-Reply-To: <CACT4Y+bG9MvoSJb8G4XOquvcb+aQDXkF4XM=-zAEJcNFXcg4cA@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 16 May 2026 10:02:07 +0200
X-Gm-Features: AVHnY4IGxAqTE7ZKTUI7O3o3kWWMccuG4306fF6IoCepEtNDot9GuWDGcHLSkXQ
Message-ID: <CANp29Y4S2QH81tgkhrNnh6b90wUhVYBsjPtXHxQhdpqM=DBrUg@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: lru: Use resilient spinlocks to prevent NMI deadlocks
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 6:59=E2=80=AFAM 'Dmitry Vyukov' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A very similar patch was tested for this bug, which confirms the patch
> is correct.

.. or that fix was also AI-generated :)

>
>
> On Thu, 14 May 2026 at 00:38, 'syzbot' via
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
> >
> > Fixes: 3a08c2fd763450a927d1130de078d6f9e74944fb ("bpf: LRU List")
> > Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-previe=
w
> > Reported-by: syzbot+c69a0a2c816716f1e0d5@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=3Dc69a0a2c816716f1e0d5
> > Link: https://syzkaller.appspot.com/ai_job?id=3D10f0c342-88ea-4f57-a31f=
-48eff83eae85
> > To: <bpf@vger.kernel.org>
> > To: <martin.lau@linux.dev>
> > Cc: <andrii@kernel.org>
> > Cc: <ast@kernel.org>
> > Cc: <daniel@iogearbox.net>
> > Cc: <eddyz87@gmail.com>
> > Cc: <jolsa@kernel.org>
> > Cc: <linux-kernel@vger.kernel.org>
> > Cc: <memxor@gmail.com>
> > Cc: <song@kernel.org>
> > Cc: <yonghong.song@linux.dev>
> >
> > ---
> > diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
> > index e7a2fc605..d02c37ca9 100644
> > --- a/kernel/bpf/bpf_lru_list.c
> > +++ b/kernel/bpf/bpf_lru_list.c
>
> Add <asm/rqspinlock.h> include in this file too.
>
> > @@ -307,9 +307,10 @@ static void bpf_lru_list_push_free(struct bpf_lru_=
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
> > @@ -319,7 +320,8 @@ static void bpf_lru_list_pop_free_to_local(struct b=
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
> > @@ -338,7 +340,7 @@ static void bpf_lru_list_pop_free_to_local(struct b=
pf_lru *lru,
> >                                       local_free_list(loc_l),
> >                                       BPF_LRU_LOCAL_LIST_T_FREE);
> >
> > -       raw_spin_unlock(&l->lock);
> > +       raw_res_spin_unlock(&l->lock);
> >  }
> >
> >  static void __local_list_add_pending(struct bpf_lru *lru,
> > @@ -404,7 +406,8 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free=
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
> > @@ -420,7 +423,7 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free=
(struct bpf_lru *lru,
> >                 __bpf_lru_node_move(l, node, BPF_LRU_LIST_T_INACTIVE);
> >         }
> >
> > -       raw_spin_unlock_irqrestore(&l->lock, flags);
> > +       raw_res_spin_unlock_irqrestore(&l->lock, flags);
> >
> >         return node;
> >  }
> > @@ -437,7 +440,8 @@ static struct bpf_lru_node *bpf_common_lru_pop_free=
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
> > @@ -448,7 +452,7 @@ static struct bpf_lru_node *bpf_common_lru_pop_free=
(struct bpf_lru *lru,
> >         if (node)
> >                 __local_list_add_pending(lru, loc_l, cpu, node, hash);
> >
> > -       raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> > +       raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
> >
> >         if (node)
> >                 return node;
> > @@ -466,23 +470,26 @@ static struct bpf_lru_node *bpf_common_lru_pop_fr=
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
> > @@ -511,10 +518,11 @@ static void bpf_common_lru_push_free(struct bpf_l=
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
> > @@ -522,7 +530,7 @@ static void bpf_common_lru_push_free(struct bpf_lru=
 *lru,
> >                 bpf_lru_node_clear_ref(node);
> >                 list_move(&node->list, local_free_list(loc_l));
> >
> > -               raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> > +               raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
> >                 return;
> >         }
> >
> > @@ -538,11 +546,12 @@ static void bpf_percpu_lru_push_free(struct bpf_l=
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
> > @@ -625,7 +634,7 @@ static void bpf_lru_locallist_init(struct bpf_lru_l=
ocallist *loc_l, int cpu)
> >
> >         loc_l->next_steal =3D cpu;
> >
> > -       raw_spin_lock_init(&loc_l->lock);
> > +       raw_res_spin_lock_init(&loc_l->lock);
> >  }
> >
> >  static void bpf_lru_list_init(struct bpf_lru_list *l)
> > @@ -640,7 +649,7 @@ static void bpf_lru_list_init(struct bpf_lru_list *=
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
> > This is an AI-generated patch subject to moderation.
> > Reply with '#syz upstream' to send it to the mailing list.
> > Reply with '#syz reject' to reject it.
> >
> > See  for more information.
> >
> > --
> > You received this message because you are subscribed to the Google Grou=
ps "syzkaller-upstream-moderation" group.
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkall=
er-upstream-moderation/dcebc4bd-5cc1-4dc9-b82b-6cca0fad128b%40mail.kernel.o=
rg.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/CACT4Y%2BbG9MvoSJb8G4XOquvcb%2BaQDXkF4XM%3D-zAEJcNFXcg=
4cA%40mail.gmail.com.
