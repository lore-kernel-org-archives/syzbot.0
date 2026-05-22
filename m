Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AC61A9B24
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 12:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779451492; cv=pass; b=U/1Xa3w/YgnyYTFcXQ8dy1qD9Coh3GojJJAujhKHyb+qhvlunNB660k0sBcCf9Em/EDBty6AXBm4SX9Dt0Q0uFl9ftJm5aLM+c6E6ph/KSv4M6wAYBFMkKw4ix48f15D2EXw5hKXEkY5/jWCBtSl9SeljmZ37MbAiOY0bJRgG4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779451492; c=relaxed/simple;
	bh=/vgncX3kY3VH4Vn/qtv+vbNTYylgm4yzom/Efqwqt/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PYPmJrUd0UVr6l2SyLi2cz5kHDwiDmMM7yEH1Sw7isRZldp9f1CLVyR0M3Yo6Y+xW+53KNYBT10cvZklCHIzYnfX8gHhHssRHfS3M7ngLbffTegsISFfyKmAhwCQCVH613frGKB/z7mfzC4qSeQxpCgar3/W6//Lu/xNhgptR58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tVHCmFOC; arc=pass smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tVHCmFOC"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-69d7b0be378so530524eaf.0
        for <syzbot@lists.linux.dev>; Fri, 22 May 2026 05:04:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779451489; cv=none;
        d=google.com; s=arc-20240605;
        b=A8/Dqm4JNaMjHnmeWDgUrY9wjwAswfWQOD1P5Yh+kdyWCIiVJFCInEYkBrww0NEXeQ
         jiYh/cS6SZ5feLgAhQkJt8gFwAWfvojKdlk+LzG+tWn0m8qdfMkV/8dxliV8hsrL0ceL
         HoFzKeYkKuJpHPxhc2fO/RmVx71h7hZsgKF4bNJHiGn5GmVRYss3q+W/t/SMjWNyAzhb
         tACjdcN5TTH2qQeJvzYGMIimrdlM/aEekCKkDPFIItLceqx4Z/DJTlZHQtiOBIzn/VkQ
         zq9cFnFXasEeaB1Ia5WnK9GOc9B/hPH4O3KVHz5anjOlBo/xDfIfOBmRJ47FqdP/jptR
         wUww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3ljf/MJMu7l0s0DrZLAXDoY+8OpTO5QHZzGBC7mUf3w=;
        fh=RyCYVzhptLSL5QCEZuXaaBEgqwxqj2bvtgDzGDvVAVs=;
        b=KOkOP75IedxpVHaTCqBkXfCRT7tepSb1uULD/S2jMc3dbp9YXOKHy1Hu6kDiGCbADV
         Pn+2r3sIBj79dsHzWcliXfXS9dsVWh7PDSCBVQAz6D+fWwJG7++Go16A63YZnCkNqToh
         Sg2dRUPrGJRu8kroh48nEUwrAiOPs4TgjD3TDSjbKjLV4UzbZKamcm8mdRvHOgA4GZYD
         UA6T+oPpWcXlfuta5d3k8EsSHECj5/ewXwArm9wl6qhLA9yICCvz1nIMIexz6yAyQ0aR
         GFQ+ilB5cOUiwOpz7FsfVPmluspMIETHdrLFehTgfeNCZs5Np97oYM0ZoJ67/TLtWITY
         edXg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779451489; x=1780056289; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ljf/MJMu7l0s0DrZLAXDoY+8OpTO5QHZzGBC7mUf3w=;
        b=tVHCmFOCmw/lXSR/A/BDd1QUO10ba6vujb12KpnlZJ7mjUj5liPeEHCNsv93Xe/6+l
         Tr2OaEXBvcN+9VucTSe9U4ZmxRQGVv+PmRiOE9VHk1mamk62iZYzBmyWrTjXexIY5J3W
         SC9ilTNLvZ5JFrIbfFEsqXF6vzrttlxhAeUw8enJH3kyGKhVYyPVzKt0jrTSzDY9WGwo
         0IJFdFoDjTd09XElZGb/jHlC2pNy3ENjIcN1s54Qw3cJupUFV8eEsI6Sls6PT0pf8Y1O
         N3F/5hXz5Zpa+WLCa32qCcqxaEmXvtCctbaJ0hPelcEHKW0A+G3hlsE88t14ybQPD/6O
         usIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779451489; x=1780056289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3ljf/MJMu7l0s0DrZLAXDoY+8OpTO5QHZzGBC7mUf3w=;
        b=cjN947SfXJTznOG4tU+u9zcr3ItwzU+BbmYO07PImnqx+OkUk14IbUOkIEDnPUE/1q
         ytW17CVb6BEModLsyHQtiO8DBNdka8xHOd4TcvFnPxMDX5WRwItWzahEUD2EpHl1Q8jJ
         E4znL/aIDHqZ6xP78Y38ry8u48KkJhN8HHrEG477N1uyau8LZsE8HAOfkfv3lN/EBfhv
         5MQEXQXJXT/Djmatm9n4GpTi6D+k52OVsCj5ozgqgo4JjAOmNmEPuk6r+lO0Cqan+AaI
         yeBBvkzpG8B4BBlW48JVVleF776rnah/mMa8P18B+1nIUwKdiFxfpO4Bvm4RG/fDIc0Z
         X7TA==
X-Forwarded-Encrypted: i=1; AFNElJ/DyyZSyd1S2iRXo5IPRS8F42Boyf7PrB0HyVFizmuhWfyBMwpJ4Kc/iFw4ZnfOXQxc3ReqWqA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpzVBx9ZYXp21fAG4laAyiXA1xaXihtY5B7hDa058rBrGvLFPJ
	LJVU+T0Pz819NA89njLxam5MFNnXaAK3bejs1RRIg6XD1Qz43+vWzIXWxEHpLpLmb1BdaRxINOY
	/NUeuqjYQCGBghUMgBjEfH+Y3J90WV3I0wG2OPiDO
X-Gm-Gg: Acq92OFrUQbls/5w1j+C9XYb5DBCEiPRnqOSwyloOJhG+VXQXeRBdhBUjnZPEbURp2i
	9i+n+7F3Dqi2N/cJg5IT/d71AXcsJh1BplGbsfCBOhq+62UvEuNaR9Wu/TUvPK++Gz4cPt0P8/x
	ew1/mJB/lcvh6TkJXxEvHvz6krcnxx38Mw5up92/zo+XXszhcyTj4mZNAiMimg5AzdUD1a5l0Ib
	2+wrV+yh83qcTMRf0R+xkxTiUbzL5UVlhsevmAgtZXNgqSnHp54KYkMK115wpvrjVeISVBFBOmW
	0gcdaTNczzXPWCPTltaRAUIjejC8pMuDikcJkdI1Gg06uzQcm21g97ROtO1TqcZ2vNE1mpelRu7
	/P3l4
X-Received: by 2002:a4a:edca:0:b0:696:63bb:f004 with SMTP id
 006d021491bc7-69d7ebc5c9amr1637414eaf.27.1779451489033; Fri, 22 May 2026
 05:04:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <4c0d4f36-c99b-4235-801d-e9a27dfa6c8e@mail.kernel.org>
In-Reply-To: <4c0d4f36-c99b-4235-801d-e9a27dfa6c8e@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 22 May 2026 14:04:37 +0200
X-Gm-Features: AVHnY4KA8x72UecIp4R4aYeRB00uLCFrne0wbDMhzdTpPe7_cWiAyMf29ch3YVM
Message-ID: <CANp29Y4Pmy36bSqNKD_vkDhWaMOtS8civnOa5b14MSC4Nsq4ow@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: Convert bpf_lru_list locks to rqspinlock
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 22, 2026 at 12:08=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> Lockdep reports an inconsistent lock state ({INITIAL USE} -> {IN-NMI})
> for the loc_l->lock in the BPF LRU list implementation. This occurs
> because the lock is first acquired in a normal syscall context (e.g.,
> during BPF_MAP_UPDATE_BATCH) and later attempted to be acquired in an
> NMI context (e.g., when a hardware breakpoint triggers a perf event that
> executes a BPF program).
>
> While lockdep correctly identifies that raw_spinlock_t is not NMI-safe,
> this specific deadlock is prevented in practice by the bpf_prog_active
> counter. If an NMI interrupts a map operation, the NMI handler checks
> bpf_prog_active and skips executing the BPF program, preventing it from
> acquiring the already-held lock. However, lockdep is unaware of this
> protection mechanism, leading to a false positive.
>
> To resolve this false positive and provide robust deadlock prevention,
> convert the raw_spinlock_t locks in bpf_lru_list to rqspinlock_t
> (resilient queued spinlock), similar to the conversion previously done
> for hashtab.c. The rqspinlock infrastructure is designed to return an
> error instead of deadlocking and is invisible to lockdep.
>
> With this conversion, raw_spin_lock_irqsave() is replaced with
> raw_res_spin_lock_irqsave(). If the lock cannot be acquired during pop
> operations, the functions gracefully return NULL, which propagates as
> -ENOMEM to the BPF program. In push operations, the functions simply
> return, effectively dropping the node, as leaking the preallocated
> element is an acceptable trade-off to avoid a hard deadlock in NMI
> context.
>
> Fixes: 4fa8d68aa53e ("bpf: Convert hashtab.c to rqspinlock")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+c69a0a2c816716f1e0d5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dc69a0a2c816716f1e0d5
> Link: https://syzkaller.appspot.com/ai_job?id=3D5c92fef7-50da-4f0f-9ce0-5=
870752f09b4
> To: "Andrii Nakryiko" <andrii@kernel.org>
> To: "Alexei Starovoitov" <ast@kernel.org>
> To: <bpf@vger.kernel.org>
> To: "Daniel Borkmann" <daniel@iogearbox.net>
> To: "Eduard Zingerman" <eddyz87@gmail.com>
> To: "Martin KaFai Lau" <martin.lau@linux.dev>
> To: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
> Cc: "Jiri Olsa" <jolsa@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Song Liu" <song@kernel.org>
> Cc: "Yonghong Song" <yonghong.song@linux.dev>
>
> ---
> diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
> index e7a2fc605..722b4a009 100644
> --- a/kernel/bpf/bpf_lru_list.c
> +++ b/kernel/bpf/bpf_lru_list.c

Please add a missing `<asm/rqspinlock.h>` include here.

Add comments to the code about lock failure in stealing, push and
flush operations as to what are the consequences, any why we prefer
them over the deadlock.

> @@ -307,9 +307,10 @@ static void bpf_lru_list_push_free(struct bpf_lru_li=
st *l,
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
> @@ -319,7 +320,8 @@ static void bpf_lru_list_pop_free_to_local(struct bpf=
_lru *lru,
>         struct bpf_lru_node *node, *tmp_node;
>         unsigned int nfree =3D 0;
>
> -       raw_spin_lock(&l->lock);
> +       if (raw_res_spin_lock(&l->lock))
> +               return;
>
>         __local_list_flush(l, loc_l);
>
> @@ -338,7 +340,7 @@ static void bpf_lru_list_pop_free_to_local(struct bpf=
_lru *lru,
>                                       local_free_list(loc_l),
>                                       BPF_LRU_LOCAL_LIST_T_FREE);
>
> -       raw_spin_unlock(&l->lock);
> +       raw_res_spin_unlock(&l->lock);
>  }
>
>  static void __local_list_add_pending(struct bpf_lru *lru,
> @@ -404,7 +406,8 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(s=
truct bpf_lru *lru,
>
>         l =3D per_cpu_ptr(lru->percpu_lru, cpu);
>
> -       raw_spin_lock_irqsave(&l->lock, flags);
> +       if (raw_res_spin_lock_irqsave(&l->lock, flags))
> +               return NULL;
>
>         __bpf_lru_list_rotate(lru, l);
>
> @@ -420,7 +423,7 @@ static struct bpf_lru_node *bpf_percpu_lru_pop_free(s=
truct bpf_lru *lru,
>                 __bpf_lru_node_move(l, node, BPF_LRU_LIST_T_INACTIVE);
>         }
>
> -       raw_spin_unlock_irqrestore(&l->lock, flags);
> +       raw_res_spin_unlock_irqrestore(&l->lock, flags);
>
>         return node;
>  }
> @@ -437,7 +440,8 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(s=
truct bpf_lru *lru,
>
>         loc_l =3D per_cpu_ptr(clru->local_list, cpu);
>
> -       raw_spin_lock_irqsave(&loc_l->lock, flags);
> +       if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
> +               return NULL;
>
>         node =3D __local_list_pop_free(loc_l);
>         if (!node) {
> @@ -448,7 +452,7 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(s=
truct bpf_lru *lru,
>         if (node)
>                 __local_list_add_pending(lru, loc_l, cpu, node, hash);
>
> -       raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> +       raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
>
>         if (node)
>                 return node;
> @@ -466,13 +470,16 @@ static struct bpf_lru_node *bpf_common_lru_pop_free=
(struct bpf_lru *lru,
>         do {
>                 steal_loc_l =3D per_cpu_ptr(clru->local_list, steal);
>
> -               raw_spin_lock_irqsave(&steal_loc_l->lock, flags);
> +               if (raw_res_spin_lock_irqsave(&steal_loc_l->lock, flags))=
 {
> +                       steal =3D cpumask_next_wrap(steal, cpu_possible_m=
ask);
> +                       continue;
> +               }
>
>                 node =3D __local_list_pop_free(steal_loc_l);
>                 if (!node)
>                         node =3D __local_list_pop_pending(lru, steal_loc_=
l);
>
> -               raw_spin_unlock_irqrestore(&steal_loc_l->lock, flags);
> +               raw_res_spin_unlock_irqrestore(&steal_loc_l->lock, flags)=
;
>
>                 steal =3D cpumask_next_wrap(steal, cpu_possible_mask);
>         } while (!node && steal !=3D first_steal);
> @@ -480,9 +487,10 @@ static struct bpf_lru_node *bpf_common_lru_pop_free(=
struct bpf_lru *lru,
>         loc_l->next_steal =3D steal;
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
> @@ -511,10 +519,11 @@ static void bpf_common_lru_push_free(struct bpf_lru=
 *lru,
>
>                 loc_l =3D per_cpu_ptr(lru->common_lru.local_list, node->c=
pu);
>
> -               raw_spin_lock_irqsave(&loc_l->lock, flags);
> +               if (raw_res_spin_lock_irqsave(&loc_l->lock, flags))
> +                       return;
>
>                 if (unlikely(node->type !=3D BPF_LRU_LOCAL_LIST_T_PENDING=
)) {
> -                       raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> +                       raw_res_spin_unlock_irqrestore(&loc_l->lock, flag=
s);
>                         goto check_lru_list;
>                 }
>
> @@ -522,7 +531,7 @@ static void bpf_common_lru_push_free(struct bpf_lru *=
lru,
>                 bpf_lru_node_clear_ref(node);
>                 list_move(&node->list, local_free_list(loc_l));
>
> -               raw_spin_unlock_irqrestore(&loc_l->lock, flags);
> +               raw_res_spin_unlock_irqrestore(&loc_l->lock, flags);
>                 return;
>         }
>
> @@ -538,11 +547,12 @@ static void bpf_percpu_lru_push_free(struct bpf_lru=
 *lru,
>
>         l =3D per_cpu_ptr(lru->percpu_lru, node->cpu);
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
> @@ -625,7 +635,7 @@ static void bpf_lru_locallist_init(struct bpf_lru_loc=
allist *loc_l, int cpu)
>
>         loc_l->next_steal =3D cpu;
>
> -       raw_spin_lock_init(&loc_l->lock);
> +       raw_res_spin_lock_init(&loc_l->lock);
>  }
>
>  static void bpf_lru_list_init(struct bpf_lru_list *l)
> @@ -640,7 +650,7 @@ static void bpf_lru_list_init(struct bpf_lru_list *l)
>
>         l->next_inactive_rotation =3D &l->lists[BPF_LRU_LIST_T_INACTIVE];
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
> base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patche=
s.md for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/4c0d4f36-c99b-4235-801d-e9a27dfa6c8e%40mail.kernel.org=
.
