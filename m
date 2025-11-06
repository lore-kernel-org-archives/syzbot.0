Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD6E306B12
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 22:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762469522; cv=none; b=d/JicHCxhR1UoE8oDH8ZPnr3N9oCJb6t3+JCDellNUNRE2hq3tIWV6EaghlEryVkiW4ENp/vKDBbvLBHXgEcdgZEFJ3F/PEv+tx3Pyjl4/hYBPCECJNgVknZmt6OFgBVUnM4uLni/vsG8dbbnwtoZtDfuwxo4JDiq4yFgDahXAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762469522; c=relaxed/simple;
	bh=K6vs0598/wxVxv6ULBosbjkLZ7I3n8J8AI1tRHyjD9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TO6Oi+5mhZNRGDc9CFYJBedYLYGNb/71Kn7ijxfiTU0fGHW9Rina0A9b8zKunLGKItTRVSTqPVOgtH1AbFuCXv+xf+QzHyJ/8SeOIO2CP+wWhWPAEyiI1VUbzgJI7KlPIsaFtVMSSXlhcHRcs0Bw7Slv6/cHJJA6sdQwOYu174A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GZFM4zKW; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GZFM4zKW"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b99bfb451e5so110823a12.2
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 14:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762469520; x=1763074320; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NwSKAxqy2SfLjpHB+T+r/Edcz4EGZRszuORPbU31So8=;
        b=GZFM4zKWuFuc81HLF8eL6NQHa4ADINkrTbglHMGv/CGGoeVT+WNEFumjh2NobhaDM0
         TCOjFRWQwT/JGKnCmRqd2rqKuQ18erZKBO1W8H6H0QoPxStrDWFJY8lfrlgccnI0lWXz
         2Px4hOu/JeyBWSKZN+othHr9bbUi67K08EJbT9gQKd7eZQuxiToBUgMdpNYjpX3hdifl
         h8058CYcATs1zHZ7WnbuQq4HqPlVAK4KRwpTzwt3xzj9iDK0QecRuSQP50vrfeDHkF+f
         iQ5Y3ZLAm4m7DupwiASX7CX77DLW7LIhltHTMX5F9C9dpF9uBnhwHsiqJAj62qt/gzec
         0Zdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762469520; x=1763074320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NwSKAxqy2SfLjpHB+T+r/Edcz4EGZRszuORPbU31So8=;
        b=shrKj2/ZfkjrJQDMntrua2zwFXoEg9I3xVRFAN+gPjNYlxGawGEdrQCuON9tcIgzdT
         ADKdvSrKIkoUV3B78LxAnAWUkzODJMErjtUJP7OzQWG/W6D7cJATBd8uFgT/g03zjMFX
         j3v5cTvw3H12Own87Si/SCWga3eBE6wy956drtCzy/AMO45CzR+ZkoltLU6xSGm+azKm
         C1CkWbKwpT479rZXAcvK1K2wImo4q5Ho7cHzKGO1o4IxGGk0rmrodNuEBitswNYAddMo
         mhXi6A8jd3odsl+k8Ac1/+IOae7kngUZTNfJqZCE4wjw50a02Ql+wLp0Sox25o0/zH9f
         4U5g==
X-Forwarded-Encrypted: i=1; AJvYcCUecSEqZTMTN7Wt/ey1Hmz65sULPOiqrnTK887t4GDrWKJM/aDSSIMTo7JgvfCm/l6Sq8A0Kh0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQO6ZYl52LcCA30x4lzK/mOTeZ5uglSsrDIP5A8Yr0zBuSYHGb
	u7Oexwt4Cl/1qGEiIAcpdl8RKHnV5L5PWkgqJ3ClDPreXLXjpFyUyoSGey+RAMwVYFGrTsqfLlu
	FR3Z+v/ksG1B6QhJ+onKsTYzwdKHkPlB0X3l2a1Sw
X-Gm-Gg: ASbGncvY38GZdCNwxdJQ/7uD5nLgkZJnt5f1mEUD0t80I7JSsqZdBr5cveQii/pmi1m
	tc0ALEAdmy2rQI7x0OOaWqX26uD6f98ChOvV1NN1+Or1nJ/6Zqaetntf0vZuVp2I21ho7LNylaK
	O+WbWS+OYHkG2jYBx994/jPstllYgyejywtVAAjApiVZJO36ofPy4Zil23TYyQ1BVRKvYgYTrrX
	QdOlPUvqldOmQuwZ9jPACWdKx+3VtWrnEGIrukIeCteTZBBWTGwygg1pt/4BYvXz9RVZprLmZdC
	LMRP9eq1FwQ8KBc=
X-Google-Smtp-Source: AGHT+IGoU/aDf7OWV1wxE/pbg/j83Yclpd9FA5WAljAUkIqN8hE4mqBZ/hGGtb4Pr1JR+yRNf96Df+4NZqUQWQVFI5E=
X-Received: by 2002:a17:903:f87:b0:295:e9af:8e4f with SMTP id
 d9443c01a7336-297c046b832mr14426155ad.52.1762469519910; Thu, 06 Nov 2025
 14:51:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <690c6ca9.050a0220.1e8caa.00d2.GAE@google.com> <20251106175926.686885-1-kuniyu@google.com>
 <20251106143004.55f4f3fc@kernel.org> <CAAVpQUBkFxS6Dm28n7uDoO+x63npwZWb925+Gs3UHz-gAZo7yQ@mail.gmail.com>
 <20251106143930.48e9ff2b@kernel.org>
In-Reply-To: <20251106143930.48e9ff2b@kernel.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Thu, 6 Nov 2025 14:51:48 -0800
X-Gm-Features: AWmQ_bkSip7YWSfFmRhzhF8kbiIFrPfdkb5r9Wpce9sVwgTueuUIkuC0jBfTe-c
Message-ID: <CAAVpQUBVyWBr6PqAOw7Js9_Jg4fDvVTvuJzoZ_ZCw0YKG2KWhQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: tipc: Fix use-after-free in tipc_mon_reinit_self().
To: Jakub Kicinski <kuba@kernel.org>
Cc: syzbot+cif2d6d318f7e85f0b@syzkaller.appspotmail.com, davem@davemloft.net, 
	edumazet@google.com, hoang.h.le@dektech.com.au, horms@kernel.org, 
	jmaloy@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 2:39=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Thu, 6 Nov 2025 14:37:10 -0800 Kuniyuki Iwashima wrote:
> > > On Thu,  6 Nov 2025 17:59:17 +0000 Kuniyuki Iwashima wrote:
> > > > -void tipc_mon_reinit_self(struct net *net)
> > > > +void tipc_mon_reinit_self(struct net *net, bool rtnl_held)
> > > >  {
> > > >       struct tipc_monitor *mon;
> > > >       int bearer_id;
> > > >
> > > > -     rtnl_lock();
> > > > +     if (!rtnl_held)
> > > > +             rtnl_lock();
> > >
> > > I haven't looked closely but for the record conditional locking
> > > is generally considered to be poor code design. Extract the body
> > > into a __tipc_mon_reinit_self() helper and call that when lock
> > > is already held? And:
> > >
> > > void tipc_mon_reinit_self(struct net *net)
> > > {
> > >         rtnl_lock();
> > >         __tipc_mon_reinit_self(net);
> > >         rtnl_unlock();
> > > }
> >
> > That's much cleaner, I'll use this.
>
> After sending I realized you probably want to do this wrapping around
> tipc_net_finalize(), otherwise we'd just be shifting the conditional.
> But you get the point.. :)

Yes, will wrap it in tipc_net_finalize_work() :)
