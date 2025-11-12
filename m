Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C299232B9B1
	for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 12:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762950131; cv=none; b=H8t8HJCQD/TLgrokOhlrIr+kR4KNcEfi/y6AiNJM8F9tt8HR/QIx5CB9eijKZAeDOrespmqF08B4ZkeeXCA8GleiGe4rK4LwJ8YVlnUJg5svMumd6QnkVCHU0xyrexCrCzy0zLohf27kvacEEZ1hathbMLXM5RVQzRU4lzFEx8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762950131; c=relaxed/simple;
	bh=8VbH1vPLVeOTC5gudSX/EGeep5DkWGS1lhpes6CR8/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VgwOHyQ4r/Mn4BcylrcZ2/FucfIr2RLSPNfHiIh7qSdW2yKZv71ymve0/MU3crFpWlvVsAR7ZSed9BDVs4ey2qZruG+sMlfCU7Y/2cnY/4UuZEYTVBPdJnQDQIGqNxPlvP8ixvmMuRn/A/0OqomopYKStPyWmBtGAlYE32/PNT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I9ni1HFy; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I9ni1HFy"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b272a4ca78so113815385a.1
        for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 04:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762950129; x=1763554929; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAyyz8vpOHqT/CVE44dcXbZcQ7/MzpxYyZh4muhHTJE=;
        b=I9ni1HFydSZUT6aqZGcAP2P/tpIndhmXPS3xa/Id5WRmfYWQmykvYRNjjbhuyr6GtY
         oNXmLpFZLW606/Df/k+uhLjZZjrEDyzpUC6jGAY9AZ3tHlBqqqqhE1mhUCwMzucT0vQO
         RKEORaPyxlil/iHnNKCZoqfs3d/zmN8OMFcSO4f0W8JwpIzV9IgjVlscAz1I3uj3JyEI
         UGzNHGKox2H1tYiWiIGZkDmF7teuz4A/V+XRN1uvPOkifzacuYBdXekGMvw2uk6Zej0a
         GaFEQ+bLJqPZhLHwCR6h4/lp0IvSJfxzB33HfN12QRgFFqc6y9j90foUsQxUWhhF7sK2
         bR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762950129; x=1763554929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OAyyz8vpOHqT/CVE44dcXbZcQ7/MzpxYyZh4muhHTJE=;
        b=BOuZM4vPTNTQ2RnPb3okhbnSHS0Kj+jxwy/W+7x8eKqhq2LE47GoNywRenHk6rUajL
         w2fnD7BNgEe6aR0aRCBAqSXx0U2rrEL3Qp4Bg3HF0977klG2yFisqySwhyoqoecEyZOo
         1+xOfTICApvaGKWCYCuzpW08exV8ythlOTTw47gSn/li+TtOWo3eFAFNyRVI0S/OWmjY
         HCf0CORXUHbKy1yuG8ZtRl46sttE4Ld2HcGFYymDisARV//RWABbLGyNC9nXbt/8rr8U
         dIQy1/CUWQPMKyrbwlcgnemddefapzLoNDQuULFqMa5hdWkaQ2z67V9xsWmXv7ZfROpd
         CKoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsaD347uyW3zczsSIfic00JMtOVJT715AszyiTbt0TFSnghqPIQRGsGxamlm9YMGaqZtvwoBA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8Kt2o6EEdjqkI3I1b5/B+CT2J83Humrf3R9tAI1L7lgYuX0/e
	t7I9hQw+5shuvnbcmM82qUcwIFXn34Utl4C6BJ3/0NnbWBHnpm5U6BCIboq3uPrUZjMW/9VaFPJ
	pYgEl7cE9M+Xmj5tawxxkq43r1Apn6/PYgPhCsbLU
X-Gm-Gg: ASbGncvZTYfyOS2TWwSo9x1iyt+73Y2x3xmihtXdr19X3zdqryCVR1Nnbnr0VmRoTVs
	ML6Pr5nifDNPyrD1x6uxYuq8KUmTAB6cQ6fexB8C89VNWOgvKive+bxVe8L3jzm0k9Fmp+kBzqs
	Hysua5qug/oB8Qr75FsnECCtoPTV1f+r3yZIRijt4QeX1bDxM/GRgJFxWvKXSTo2+RlaHfSJzkN
	H4ES7y3wCy1zy9YdrppaVdJx+UCi97ipqKqxk2oWseaX3lKiEK8OKS4fta2osGzW6+3HPuv
X-Google-Smtp-Source: AGHT+IEDEurm/WUEke6yg+UTL4G3UfZssgo1RO1I9dkC9flwOu7hFLM+dba0o2uxTQhL+29tuiKuMUDku06TvENvqoA=
X-Received: by 2002:a05:620a:1a82:b0:8b1:5f62:a5c8 with SMTP id
 af79cd13be357-8b29b7df4fbmr340813585a.62.1762950128090; Wed, 12 Nov 2025
 04:22:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111093204.1432437-1-edumazet@google.com> <6913437c.a70a0220.22f260.013b.GAE@google.com>
 <CANn89iKgYo=f+NyOVFfLjkYLczWsqopxt4F5adutf5eY9TAJmA@mail.gmail.com>
 <CANn89iJ5p3xY_LJcexq8n2-91A6ERPV6yqjPGphD_w6wr_NHew@mail.gmail.com>
 <CANn89iKLDetsEpMrFU4F_XbTF_N0ranLkzJvf1qG=o-ecfseZg@mail.gmail.com>
 <CA+NMeC9boCccv944JsADbbkp8T8rRDy_ce__m_ETut0059o7DQ@mail.gmail.com> <CAM0EoMkx3rpiATyoqirtsiRhGALVcMvT_DL4yicLCQmB3_ZUAQ@mail.gmail.com>
In-Reply-To: <CAM0EoMkx3rpiATyoqirtsiRhGALVcMvT_DL4yicLCQmB3_ZUAQ@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 12 Nov 2025 04:21:57 -0800
X-Gm-Features: AWmQ_bmy1VYheZXEu6_eH390vZemgE6oEpJp0JelwqspGstN8dqm_2xOImnbWsA
Message-ID: <CANn89iKYvgikRmHc5MOS-eEBwy9-4+ODf5HNYnL2NUcpGBUXTQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: net_sched: speedup qdisc dequeue
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Victor Nogueira <victor@mojatatu.com>, 
	syzbot ci <syzbot+ci51c71986dfbbfee2@syzkaller.appspotmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net, eric.dumazet@gmail.com, 
	horms@kernel.org, jiri@resnulli.us, kuba@kernel.org, kuniyu@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, toke@redhat.com, 
	willemb@google.com, xiyou.wangcong@gmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 1:34=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> On Tue, Nov 11, 2025 at 4:04=E2=80=AFPM Victor Nogueira <victor@mojatatu.=
com> wrote:
> >
> > Hi Eric,
> >
> > On Tue, Nov 11, 2025 at 4:44=E2=80=AFPM Eric Dumazet <edumazet@google.c=
om> wrote:
> > >
> > > On Tue, Nov 11, 2025 at 11:23=E2=80=AFAM Eric Dumazet <edumazet@googl=
e.com> wrote:
> > > >
> > > > On Tue, Nov 11, 2025 at 8:28=E2=80=AFAM Eric Dumazet <edumazet@goog=
le.com> wrote:
> > > > >
> > > > > On Tue, Nov 11, 2025 at 6:09=E2=80=AFAM syzbot ci
> > > > > <syzbot+ci51c71986dfbbfee2@syzkaller.appspotmail.com> wrote:
> > > > > >
> > > > > > syzbot ci has tested the following series
> > > > > >
> > > > > > [v2] net_sched: speedup qdisc dequeue
> > > > > > [...]
> > > > > > and found the following issue:
> > > > > > WARNING in sk_skb_reason_drop
> > > > > >
> > > > > > Full report is available here:
> > > > > > https://ci.syzbot.org/series/a9dbee91-6b1f-4ab9-b55d-43f7f50de0=
64
> > > > > >
> > > > > > ***
> > > > > >
> > > > > > WARNING in sk_skb_reason_drop
> > > > > > [...]
> > > > struct bpf_skb_data_end {
> > > >   struct qdisc_skb_cb qdisc_cb;
> > > >   void *data_meta;
> > > >    void *data_end;
> > > > };
> > > >
> > > > So anytime BPF calls bpf_compute_data_pointers(), it overwrites
> > > > tc_skb_cb(skb)->drop_reason,
> > > > because offsetof(   ..., data_meta) =3D=3D offsetof(... drop_reason=
)
> > > >
> > > > CC Victor and Daniel
> > >
> > > Quick and dirty patch to save/restore the space.
> > >
> > > diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> > > index 7fbe42f0e5c2b7aca0a28c34cd801c3a767c804e..004d8fe2f29d89bd7df82=
d90b7a1e2881f7a463b
> > > 100644
> > > --- a/net/sched/cls_bpf.c
> > > +++ b/net/sched/cls_bpf.c
> > > @@ -82,11 +82,16 @@ TC_INDIRECT_SCOPE int cls_bpf_classify(struct sk_=
buff *skb,
> > >                                        const struct tcf_proto *tp,
> > >                                        struct tcf_result *res)
> > >  {
> > > +       struct bpf_skb_data_end *cb =3D (struct bpf_skb_data_end *)sk=
b->cb;
> > >         struct cls_bpf_head *head =3D rcu_dereference_bh(tp->root);
> > >         bool at_ingress =3D skb_at_tc_ingress(skb);
> > >         struct cls_bpf_prog *prog;
> > > +       void *save[2];
> > >         int ret =3D -1;
> > >
> > > +       save[0] =3D cb->data_meta;
> > > +       save[1] =3D cb->data_end;
> > > +
> > >         list_for_each_entry_rcu(prog, &head->plist, link) {
> > >                 int filter_res;
> > >
> > > @@ -133,7 +138,8 @@ TC_INDIRECT_SCOPE int cls_bpf_classify(struct sk_=
buff *skb,
> > >
> > >                 break;
> > >         }
> > > -
> > > +       cb->data_meta =3D save[0];
> > > +       cb->data_end =3D save[1];
> > >         return ret;
> > >  }
> >
> > I think you are on the right track.
> > Maybe we can create helper functions for this.
> > Something like bpf_compute_and_save_data_end [1] and
> > and bpf_restore_data_end [2], but for data_meta as well.
> > Also, I think we might have the same issue in tcf_bpf_act [3].
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree=
/include/linux/filter.h#n907
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree=
/include/linux/filter.h#n917
> > [3] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree=
/net/sched/act_bpf.c#n50
> >
>
> Digging a bit - when you send the fixes, this overwritting i believe
> was introduced in:
> commit db58ba45920255e967cc1d62a430cebd634b5046

I will test the following :

 include/linux/filter.h |   20 ++++++++++++++++++++
 net/sched/act_bpf.c    |    7 +++----
 net/sched/cls_bpf.c    |    6 ++----
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index a104b39942305af245b9f2938a0acf7d7ab33c23..03e7516c61872c1aa98e0be743a=
bb96d496e49c3
100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -901,6 +901,26 @@ static inline void
bpf_compute_data_pointers(struct sk_buff *skb)
        cb->data_end  =3D skb->data + skb_headlen(skb);
 }

+static inline int bpf_prog_run_data_pointers(
+       const struct bpf_prog *prog,
+       struct sk_buff *skb)
+{
+       struct bpf_skb_data_end *cb =3D (struct bpf_skb_data_end *)skb->cb;
+       void *save_data_meta, *save_data_end;
+       int res;
+
+       save_data_meta =3D cb->data_meta;
+       save_data_end =3D cb->data_end;
+
+       bpf_compute_data_pointers(skb);
+       res =3D bpf_prog_run(prog, skb);
+
+       cb->data_meta =3D save_data_meta;
+       cb->data_end =3D save_data_end;
+
+       return res;
+}
+
 /* Similar to bpf_compute_data_pointers(), except that save orginal
  * data in cb->data and cb->meta_data for restore.
  */
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 396b576390d00aad56bca6a18b7796e5324c0aef..3f5a5dc55c29433525b319f1307=
725d7feb015c6
100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -47,13 +47,12 @@ TC_INDIRECT_SCOPE int tcf_bpf_act(struct sk_buff *skb,
        filter =3D rcu_dereference(prog->filter);
        if (at_ingress) {
                __skb_push(skb, skb->mac_len);
-               bpf_compute_data_pointers(skb);
-               filter_res =3D bpf_prog_run(filter, skb);
+               filter_res =3D bpf_prog_run_data_pointers(filter, skb);
                __skb_pull(skb, skb->mac_len);
        } else {
-               bpf_compute_data_pointers(skb);
-               filter_res =3D bpf_prog_run(filter, skb);
+               filter_res =3D bpf_prog_run_data_pointers(filter, skb);
        }
+
        if (unlikely(!skb->tstamp && skb->tstamp_type))
                skb->tstamp_type =3D SKB_CLOCK_REALTIME;
        if (skb_sk_is_prefetched(skb) && filter_res !=3D TC_ACT_OK)
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 7fbe42f0e5c2b7aca0a28c34cd801c3a767c804e..a32754a2658bb7d21e8ceb62c67=
d6684ed4f9fcc
100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -97,12 +97,10 @@ TC_INDIRECT_SCOPE int cls_bpf_classify(struct sk_buff *=
skb,
                } else if (at_ingress) {
                        /* It is safe to push/pull even if skb_shared() */
                        __skb_push(skb, skb->mac_len);
-                       bpf_compute_data_pointers(skb);
-                       filter_res =3D bpf_prog_run(prog->filter, skb);
+                       filter_res =3D
bpf_prog_run_data_pointers(prog->filter, skb);
                        __skb_pull(skb, skb->mac_len);
                } else {
-                       bpf_compute_data_pointers(skb);
-                       filter_res =3D bpf_prog_run(prog->filter, skb);
+                       filter_res =3D
bpf_prog_run_data_pointers(prog->filter, skb);
                }
                if (unlikely(!skb->tstamp && skb->tstamp_type))
                        skb->tstamp_type =3D SKB_CLOCK_REALTIME;
