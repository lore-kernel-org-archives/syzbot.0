Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D508135CBAA
	for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 21:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762895097; cv=none; b=ZiztEGVD4V+YK0FgfWrGmLdlLiXG4CcdI3IzWwV2ZOtS4ja5TxRVZxOvditMMj+kGMYMbw/PtPneQMsQ6wlTDS33mi+IZuexrKW4eqEUezlghOfVXmeTGRfoNYMDCv8EvYPz2oNLa5iJSYYfrlOn0XuSkQPcV3DwhsmHlQTyr+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762895097; c=relaxed/simple;
	bh=0ANGAKyfk0XacrpbOjrV4oYrYM4NHQcvpLeYTqVpFhE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tus+jQkWfh0q+A8voXJ/jkhnsY+C/bhAuylsLlc0nFgEsx62HtS6VAjvfDXH54XMrCEltCoPeZYU/YsYzcmkVzkrEqMUG2hBXGzbJjM94vibhYY+MKkoh6UACM+9lis7s04Tq//Yy2Ea0YAuIpkiM8/p7gfXPLaPbjN5l6DDlpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=wThYqRk2; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="wThYqRk2"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d71bcab6fso1543747b3.0
        for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 13:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1762895095; x=1763499895; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Rff8D2bE9OY4iP9W0vlt5rdkV0idApAURH+0R2bNBo=;
        b=wThYqRk2A9oRdtqtLrf2WUssJPhSVSSjczuBHmPCiVtZt2znMJYjLdABxRtXUZa87H
         J/QGUSr0uhLCtZgPqpLew0TT/cs4xXE1Co75qjeClT5EwABErHM+sVTQnUlapNfbF+CF
         29FRWZv4qFfiMmg+3XpicHFIpWbdU3B44JbHs2hnI0NByDLg6CjTDX7+q1eNC7oFxPar
         xHt4E7JreSohw955u/M0njdubsysIlGixjb/5/DguJLGJ9yaDSt7e/Fm5CVzTsnsfccR
         WEVALIO/qiUES1YMSU00W+MCSuhc9R2YJ1OASIGu9ru12ZDeXZ6Y0ZmghAxI7GG3m/xL
         juig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762895095; x=1763499895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Rff8D2bE9OY4iP9W0vlt5rdkV0idApAURH+0R2bNBo=;
        b=wOd/yQsdZvFJ9Cm7451IgbEPmq1sIcol++igdQ7z1Fghkn4otvAmORG9Q1EEFGNZO5
         sl1sX0W7U1Q5gPJrj1+s1UvksVFGhwvG0J0K6L0zY1NKBA1w42M67R2i8uwAfJuVhcds
         uY3Jd5EAM93h69yli4D+w90j79y2+/gyDk0AkotlHme78gtg0fVvN94kDVhJV57S0651
         CEwELgsBnndr+MuOVcgmaWm3aO6jPVXQOFejq0hbQ7nTzDYXdj3+zysBkImcqj8+hcQn
         0bonfaHrduIQKYe6nN5OQUkM/2aaUPnwquE1lgyp75DeQI/tPasKL6G4qQltOG1imUAT
         Zuxg==
X-Forwarded-Encrypted: i=1; AJvYcCVqxXhuxP0LpvLqBo4unJBE6A9WCCp5V+yGuPlxx7aZeA+zHLaFTmMjOYg979zkJm79Kx5Wtqw=@lists.linux.dev
X-Gm-Message-State: AOJu0YysPuXnvjs13N5IENo8SOcWkIrsCT+H30n9Ddg/6Oq6Qsos7Xbd
	3fTf/k5scTVm0Kqvgbj8npg4eprnFdhQxFFQJHU7tZm77zs5BE78FB8HlkBhKxoFa+ZxF1LDrRo
	eA1vL1TlnAruO9em3iHldLYrxH7l7zpqBMYQhjTjm
X-Gm-Gg: ASbGnctToTxt62Ikfe6+3gMnXmwsjObbUYIdMDL1ZuLKgMj4srYPUlUidXaASfJ01To
	WQNwvagZJYQA7VeFPirCmcLgxKpAwUAI2uZWBY5GqdqybmLxYGNCHrX/M7AQ5fE9BdYiFKn53ej
	kButM2xI2W19I+sp+qFkjTBG57n6ul0zF7QzMhDZ+B63eJr/8cx//nC40U5AHeunHBhsBqkuEzL
	Sji0ILKwy2XejXMfLaWnILVT+mxpPffEJzMATrUWx07/XNJHm3NhWG6nsQHY2EdTamD0RqZw6s=
X-Google-Smtp-Source: AGHT+IF8+WaQjjhdoqDmDzA6o7MOUw6Bcr7AID3NwciJiO09oN4GC/yXdrw2LwzQikWa/McrC31ZxchNTlf2AmTi8PU=
X-Received: by 2002:a81:8a02:0:b0:787:e5bb:fb83 with SMTP id
 00721157ae682-788136a8ed4mr3083177b3.32.1762895094747; Tue, 11 Nov 2025
 13:04:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111093204.1432437-1-edumazet@google.com> <6913437c.a70a0220.22f260.013b.GAE@google.com>
 <CANn89iKgYo=f+NyOVFfLjkYLczWsqopxt4F5adutf5eY9TAJmA@mail.gmail.com>
 <CANn89iJ5p3xY_LJcexq8n2-91A6ERPV6yqjPGphD_w6wr_NHew@mail.gmail.com> <CANn89iKLDetsEpMrFU4F_XbTF_N0ranLkzJvf1qG=o-ecfseZg@mail.gmail.com>
In-Reply-To: <CANn89iKLDetsEpMrFU4F_XbTF_N0ranLkzJvf1qG=o-ecfseZg@mail.gmail.com>
From: Victor Nogueira <victor@mojatatu.com>
Date: Tue, 11 Nov 2025 18:04:43 -0300
X-Gm-Features: AWmQ_ble_zMFtuh4sJpY_p-zd95UkdHrGxhVK0Z7iNNjnMXOCKxYj_htacYxTxk
Message-ID: <CA+NMeC9boCccv944JsADbbkp8T8rRDy_ce__m_ETut0059o7DQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: net_sched: speedup qdisc dequeue
To: Eric Dumazet <edumazet@google.com>
Cc: syzbot ci <syzbot+ci51c71986dfbbfee2@syzkaller.appspotmail.com>, 
	Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net, eric.dumazet@gmail.com, 
	horms@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org, 
	kuniyu@google.com, netdev@vger.kernel.org, pabeni@redhat.com, toke@redhat.com, 
	willemb@google.com, xiyou.wangcong@gmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, Nov 11, 2025 at 4:44=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Tue, Nov 11, 2025 at 11:23=E2=80=AFAM Eric Dumazet <edumazet@google.co=
m> wrote:
> >
> > On Tue, Nov 11, 2025 at 8:28=E2=80=AFAM Eric Dumazet <edumazet@google.c=
om> wrote:
> > >
> > > On Tue, Nov 11, 2025 at 6:09=E2=80=AFAM syzbot ci
> > > <syzbot+ci51c71986dfbbfee2@syzkaller.appspotmail.com> wrote:
> > > >
> > > > syzbot ci has tested the following series
> > > >
> > > > [v2] net_sched: speedup qdisc dequeue
> > > > [...]
> > > > and found the following issue:
> > > > WARNING in sk_skb_reason_drop
> > > >
> > > > Full report is available here:
> > > > https://ci.syzbot.org/series/a9dbee91-6b1f-4ab9-b55d-43f7f50de064
> > > >
> > > > ***
> > > >
> > > > WARNING in sk_skb_reason_drop
> > > > [...]
> > struct bpf_skb_data_end {
> >   struct qdisc_skb_cb qdisc_cb;
> >   void *data_meta;
> >    void *data_end;
> > };
> >
> > So anytime BPF calls bpf_compute_data_pointers(), it overwrites
> > tc_skb_cb(skb)->drop_reason,
> > because offsetof(   ..., data_meta) =3D=3D offsetof(... drop_reason)
> >
> > CC Victor and Daniel
>
> Quick and dirty patch to save/restore the space.
>
> diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> index 7fbe42f0e5c2b7aca0a28c34cd801c3a767c804e..004d8fe2f29d89bd7df82d90b=
7a1e2881f7a463b
> 100644
> --- a/net/sched/cls_bpf.c
> +++ b/net/sched/cls_bpf.c
> @@ -82,11 +82,16 @@ TC_INDIRECT_SCOPE int cls_bpf_classify(struct sk_buff=
 *skb,
>                                        const struct tcf_proto *tp,
>                                        struct tcf_result *res)
>  {
> +       struct bpf_skb_data_end *cb =3D (struct bpf_skb_data_end *)skb->c=
b;
>         struct cls_bpf_head *head =3D rcu_dereference_bh(tp->root);
>         bool at_ingress =3D skb_at_tc_ingress(skb);
>         struct cls_bpf_prog *prog;
> +       void *save[2];
>         int ret =3D -1;
>
> +       save[0] =3D cb->data_meta;
> +       save[1] =3D cb->data_end;
> +
>         list_for_each_entry_rcu(prog, &head->plist, link) {
>                 int filter_res;
>
> @@ -133,7 +138,8 @@ TC_INDIRECT_SCOPE int cls_bpf_classify(struct sk_buff=
 *skb,
>
>                 break;
>         }
> -
> +       cb->data_meta =3D save[0];
> +       cb->data_end =3D save[1];
>         return ret;
>  }

I think you are on the right track.
Maybe we can create helper functions for this.
Something like bpf_compute_and_save_data_end [1] and
and bpf_restore_data_end [2], but for data_meta as well.
Also, I think we might have the same issue in tcf_bpf_act [3].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/inc=
lude/linux/filter.h#n907
[2] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/inc=
lude/linux/filter.h#n917
[3] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/net=
/sched/act_bpf.c#n50

cheers,
Victor
