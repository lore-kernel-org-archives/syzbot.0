Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFF832694F
	for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762896871; cv=none; b=MMTnzgV2VIrfXwfDayTrOzBh9Zq3oaSrKeKIDiz9MLTuANw4TXx5ka02+4XSSMmoQOeEU22PKB/NaJaNuB1hoGpwbKvHO9+OkWksjvSeXvXzY6vv5pJEEjLVVaXjbUbdYpqvYvREphafrPlnDCTaGOxpaLmmQPzjZP7eB2gfDbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762896871; c=relaxed/simple;
	bh=8ISVIKQfO78xo08XD55ShF3e7Tgvdus4g12TrOq3cnQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jibjwwFn4tFcwn5uJmnAkX4nKMRNrgRp+k92BvhY1dhqm9TSOXdzI037oLbx0vDI9L3Uv+oR+eGJVcypNU76fwNqdIjAV8Bp1zJPeNweIfPh2PQaXxjmyQmJizSkAJgD3LKPFdzYIYVGmOqfRlEiyndpgJ6HaKxbF3eCMNINsvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=d93sc1+V; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="d93sc1+V"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b67684e2904so101759a12.2
        for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 13:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1762896869; x=1763501669; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ukH96olnWYwR6HgfvBJjpA/I9yriMbEJ4ZOqEcsaZVM=;
        b=d93sc1+Vh5Sc0hmLzWVHnzyJStqaqWzjXB36RpdGIi9sd/BZni5HMQYUI3RNMc3kY2
         Ud1XiPuAJPLSyweU2RnEOUsONHYtExJLamYblE4/hGCwyDS7wvS/xaVCuaP8Am4AlJr4
         KWS+zVhIRATsZk9O2ZS91v58dN8vnso1HHLV9ogJPl2rTj7wjyMmn9TTM3hErfTLl430
         79zKvjmVvHI1s4Dn/1EdW2DT7d3S1yJewenjZvyI5Wp5vRXSAI+RbyHjqqe/ynOXXoQr
         DvOkHgiorDPA4k3mo7nu5UjVnusnsy+ySOm2RMT6b1pz7ISNUThta9l0U7j3CFfg+hgZ
         sARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762896869; x=1763501669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ukH96olnWYwR6HgfvBJjpA/I9yriMbEJ4ZOqEcsaZVM=;
        b=rmeU6xZuq1EDMgpGWqKFcwTDJK3EYdtBxQmnsPFjDz5zHXXvUsSWctyipv/yXVPr/q
         9q7VHOdGGPkf/v/LELf7wXzAusqzE7TR3uLFSIuP6Qn235OYtfOgNiDj2vDB+x2qQwrg
         xFVl6fkG6hBNDEJhYn0Q/w2rRubKgPmw+RdNe1e2g0KlffLq3JIEEMlVeqR34ZdBOMMA
         uJ1RbYMLCRTPi0PPy5hBKGsvvn1coXzR/PThvXgz6153BFyS0Ah/a2OaO97gJLAEtx8r
         XTVIuizq+DWlYdtIkisTunAvZhhSRgKRH4bupQpG0swQDnoPkR8Is+EcwAHe6cXKP+LS
         Li2A==
X-Forwarded-Encrypted: i=1; AJvYcCX9qKEZCT0LCtk1tORejdAuV2H6TZ9UIrJ8bhBCTy3I1aWuG56sUA9VuZlsK68+jDZ5tZzTrow=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXZreImLBRtaHNivymrw7b+C/9fCoJWu2eb7Kx8WWQ1HwTea5c
	/lAsiesa7PhshXUU8uQg3bp4KqT9jUf2gx/QwNYjijvlUSpW7rqzIb+YUdubsJ0zUgOOxyWA1/X
	VI607/YBLCYAI22t+9bVmQqfKeNGycc/3NzrfHX4a
X-Gm-Gg: ASbGnctOkQKdyn/lFRs46gWMRs995DERPKOvog4i9pwCMP50yMCNCgWrW7kA5Xah0Xp
	/S0TQlBtuiidlFgmqJTH+CX+NmYyN0sS0BK8fqb+SiRW00WVaUgzYJQQ7hUi16uE/7EfNcOuZAu
	YsXnO0iczXQv2M39a5JrWLNhKJQan5d5LPkCmZCBlMV2LQsQW6QYsSlt0nWh47icxfWJVUxISN/
	Cvic3VydmpPXj/O0sNeXeY473wxLkGXOWW4p/7gkreL2DCg7yHJQyo8jIlo7Hc2vE1A
X-Google-Smtp-Source: AGHT+IFJ/BR/i/JqQOX1uHPtiLvN/QaSvor2OfIp2ScXyjYPgvPn5BjAneTqFWIHa1iChxNLBlMqgE+VewtZUCWFrWY=
X-Received: by 2002:a17:902:da88:b0:295:f95a:5122 with SMTP id
 d9443c01a7336-2984ed3700amr9450215ad.15.1762896868989; Tue, 11 Nov 2025
 13:34:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111093204.1432437-1-edumazet@google.com> <6913437c.a70a0220.22f260.013b.GAE@google.com>
 <CANn89iKgYo=f+NyOVFfLjkYLczWsqopxt4F5adutf5eY9TAJmA@mail.gmail.com>
 <CANn89iJ5p3xY_LJcexq8n2-91A6ERPV6yqjPGphD_w6wr_NHew@mail.gmail.com>
 <CANn89iKLDetsEpMrFU4F_XbTF_N0ranLkzJvf1qG=o-ecfseZg@mail.gmail.com> <CA+NMeC9boCccv944JsADbbkp8T8rRDy_ce__m_ETut0059o7DQ@mail.gmail.com>
In-Reply-To: <CA+NMeC9boCccv944JsADbbkp8T8rRDy_ce__m_ETut0059o7DQ@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 11 Nov 2025 16:34:17 -0500
X-Gm-Features: AWmQ_bk8LvlqKlzMpgUJkMWo3TH82gab_1CI2vi5Ouc84qxG7n0RGNZDR1tPFOk
Message-ID: <CAM0EoMkx3rpiATyoqirtsiRhGALVcMvT_DL4yicLCQmB3_ZUAQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: net_sched: speedup qdisc dequeue
To: Victor Nogueira <victor@mojatatu.com>
Cc: Eric Dumazet <edumazet@google.com>, 
	syzbot ci <syzbot+ci51c71986dfbbfee2@syzkaller.appspotmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net, eric.dumazet@gmail.com, 
	horms@kernel.org, jiri@resnulli.us, kuba@kernel.org, kuniyu@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, toke@redhat.com, 
	willemb@google.com, xiyou.wangcong@gmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 4:04=E2=80=AFPM Victor Nogueira <victor@mojatatu.co=
m> wrote:
>
> Hi Eric,
>
> On Tue, Nov 11, 2025 at 4:44=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > On Tue, Nov 11, 2025 at 11:23=E2=80=AFAM Eric Dumazet <edumazet@google.=
com> wrote:
> > >
> > > On Tue, Nov 11, 2025 at 8:28=E2=80=AFAM Eric Dumazet <edumazet@google=
.com> wrote:
> > > >
> > > > On Tue, Nov 11, 2025 at 6:09=E2=80=AFAM syzbot ci
> > > > <syzbot+ci51c71986dfbbfee2@syzkaller.appspotmail.com> wrote:
> > > > >
> > > > > syzbot ci has tested the following series
> > > > >
> > > > > [v2] net_sched: speedup qdisc dequeue
> > > > > [...]
> > > > > and found the following issue:
> > > > > WARNING in sk_skb_reason_drop
> > > > >
> > > > > Full report is available here:
> > > > > https://ci.syzbot.org/series/a9dbee91-6b1f-4ab9-b55d-43f7f50de064
> > > > >
> > > > > ***
> > > > >
> > > > > WARNING in sk_skb_reason_drop
> > > > > [...]
> > > struct bpf_skb_data_end {
> > >   struct qdisc_skb_cb qdisc_cb;
> > >   void *data_meta;
> > >    void *data_end;
> > > };
> > >
> > > So anytime BPF calls bpf_compute_data_pointers(), it overwrites
> > > tc_skb_cb(skb)->drop_reason,
> > > because offsetof(   ..., data_meta) =3D=3D offsetof(... drop_reason)
> > >
> > > CC Victor and Daniel
> >
> > Quick and dirty patch to save/restore the space.
> >
> > diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> > index 7fbe42f0e5c2b7aca0a28c34cd801c3a767c804e..004d8fe2f29d89bd7df82d9=
0b7a1e2881f7a463b
> > 100644
> > --- a/net/sched/cls_bpf.c
> > +++ b/net/sched/cls_bpf.c
> > @@ -82,11 +82,16 @@ TC_INDIRECT_SCOPE int cls_bpf_classify(struct sk_bu=
ff *skb,
> >                                        const struct tcf_proto *tp,
> >                                        struct tcf_result *res)
> >  {
> > +       struct bpf_skb_data_end *cb =3D (struct bpf_skb_data_end *)skb-=
>cb;
> >         struct cls_bpf_head *head =3D rcu_dereference_bh(tp->root);
> >         bool at_ingress =3D skb_at_tc_ingress(skb);
> >         struct cls_bpf_prog *prog;
> > +       void *save[2];
> >         int ret =3D -1;
> >
> > +       save[0] =3D cb->data_meta;
> > +       save[1] =3D cb->data_end;
> > +
> >         list_for_each_entry_rcu(prog, &head->plist, link) {
> >                 int filter_res;
> >
> > @@ -133,7 +138,8 @@ TC_INDIRECT_SCOPE int cls_bpf_classify(struct sk_bu=
ff *skb,
> >
> >                 break;
> >         }
> > -
> > +       cb->data_meta =3D save[0];
> > +       cb->data_end =3D save[1];
> >         return ret;
> >  }
>
> I think you are on the right track.
> Maybe we can create helper functions for this.
> Something like bpf_compute_and_save_data_end [1] and
> and bpf_restore_data_end [2], but for data_meta as well.
> Also, I think we might have the same issue in tcf_bpf_act [3].
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/i=
nclude/linux/filter.h#n907
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/i=
nclude/linux/filter.h#n917
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/n=
et/sched/act_bpf.c#n50
>

Digging a bit - when you send the fixes, this overwritting i believe
was introduced in:
commit db58ba45920255e967cc1d62a430cebd634b5046

+Cc Alexei

> cheers,
> Victor
