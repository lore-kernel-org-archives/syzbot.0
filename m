Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B023019A6;
	Thu,  6 Nov 2025 22:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762468773; cv=none; b=W6YxDVtPMHbrzmCyYo+DqrzyuzOKXUWszWjwrGorCMloP2KzUK5yBQ0CHxpbRSFUP6IHshLeNZUv5EgbjgSKn84KYbPPPXkVBDjH1bWVhUbEt9UshV1vmoYN5FYpOGIkUvY2cz1JfH+6OYLHzhWmhvcAEtKNG426HodwS7TDPQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762468773; c=relaxed/simple;
	bh=IBbW//g1/t93zSIOLt853VI4ZeaeWfZEYZmRaZVGH88=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GD2oNqYSBMtLi9mwjffp5niKnqv75KAzo0edhiAumDrlCADw+GxxsCutgDgbe+Zk0yT1q0kee21CyC8y6Dig/8EQo7IJL0oLOslWghEbxXy/nno1OxBYXhBOOHAxLmYYkr65FghuTlS4IPIZPDnImU/S6fRviCQ+ksIvrpTW/+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=piB5DOIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="piB5DOIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77FFC4CEF7;
	Thu,  6 Nov 2025 22:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762468772;
	bh=IBbW//g1/t93zSIOLt853VI4ZeaeWfZEYZmRaZVGH88=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=piB5DOIjWWoaHhnMnZp7U19/qZI2r8Cnord9TfG/0rAMV4XuOVl7yDVB6PMiIwKhe
	 xzCBqk47SqrEN1U3SPPQP1GwPbKS1OxVT6yysLsyyQ81/A009FcPd+k5ltNJT7VWpa
	 nZTW8aNTq5Lg/xQAVJWFrb1jor4h8kyLmjw/k1o9qiFutOjLqIlZ+WT6miETy5Nb6y
	 jCih8X9+bC6Ih2Ll5o9Yo8OiDIG5nDWXhJe+Er85TYyfm69cBT5sWuu9j7ObDlfrAf
	 6YqhMS1Kn/ELiI+vOrbcndkgS5bbOJvHuHxDlrBHW6q0UKxFnPwiX9EokmRPJbUYtq
	 l5JFqTzSbiphw==
Date: Thu, 6 Nov 2025 14:39:30 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: syzbot+cif2d6d318f7e85f0b@syzkaller.appspotmail.com,
 davem@davemloft.net, edumazet@google.com, hoang.h.le@dektech.com.au,
 horms@kernel.org, jmaloy@redhat.com, kuni1840@gmail.com,
 netdev@vger.kernel.org, pabeni@redhat.com, syzbot@lists.linux.dev,
 syzbot@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com,
 tipc-discussion@lists.sourceforge.net
Subject: Re: [syzbot ci] Re: tipc: Fix use-after-free in
 tipc_mon_reinit_self().
Message-ID: <20251106143930.48e9ff2b@kernel.org>
In-Reply-To: <CAAVpQUBkFxS6Dm28n7uDoO+x63npwZWb925+Gs3UHz-gAZo7yQ@mail.gmail.com>
References: <690c6ca9.050a0220.1e8caa.00d2.GAE@google.com>
	<20251106175926.686885-1-kuniyu@google.com>
	<20251106143004.55f4f3fc@kernel.org>
	<CAAVpQUBkFxS6Dm28n7uDoO+x63npwZWb925+Gs3UHz-gAZo7yQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 6 Nov 2025 14:37:10 -0800 Kuniyuki Iwashima wrote:
> > On Thu,  6 Nov 2025 17:59:17 +0000 Kuniyuki Iwashima wrote:  
> > > -void tipc_mon_reinit_self(struct net *net)
> > > +void tipc_mon_reinit_self(struct net *net, bool rtnl_held)
> > >  {
> > >       struct tipc_monitor *mon;
> > >       int bearer_id;
> > >
> > > -     rtnl_lock();
> > > +     if (!rtnl_held)
> > > +             rtnl_lock();  
> >
> > I haven't looked closely but for the record conditional locking
> > is generally considered to be poor code design. Extract the body
> > into a __tipc_mon_reinit_self() helper and call that when lock
> > is already held? And:
> >
> > void tipc_mon_reinit_self(struct net *net)
> > {
> >         rtnl_lock();
> >         __tipc_mon_reinit_self(net);
> >         rtnl_unlock();
> > }  
> 
> That's much cleaner, I'll use this.

After sending I realized you probably want to do this wrapping around
tipc_net_finalize(), otherwise we'd just be shifting the conditional.
But you get the point.. :)
