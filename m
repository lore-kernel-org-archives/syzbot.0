Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30787284B29
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779375600; cv=none; b=Aa0TNWuIRomE5b1agKfEV3wKanaU1611P6SfZyr92rkYomaw+GC4ypYIK0LGaNzgA1txYOd3FiA5kOrBhKcAwK12dosOoGcuozLmy1ggDhidBrX1W+dCJMjPDfYrsCwIA26AlOUAsPeh48DBw50+Kf+Lb5yOVLU+MgNFV1QSy/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779375600; c=relaxed/simple;
	bh=Ow/pF9wYbP4smfbmonFE132HA6W6bBdV03i2gX5JhcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eP1CqtpthZJjafu2FH+Y+eswv7y77GdwOhg1tehZJUTYBd8UbeSewxaUVK4uVfGy5Oeb83OG5XuukBKuMkKjOFWBG7ovNqpwCFbqbfeU1dgV7I1W8KbaDKdMe7l1dp3YFwoDUpkm077PbCJP4Q8JjK0vBuFIxiIUen9TT53CKH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz2glykq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz2glykq"
Received: by smtp.kernel.org (Postfix)
	id 15A7D1F00A3B; Thu, 21 May 2026 14:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E201F000E9;
	Thu, 21 May 2026 14:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779375599;
	bh=a9oTzhmU/B+PGGuHwEQ1ZB9dv9hsVLLdlaadODUv2rY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qz2glykqN6tNOBTXqq6iP8zjexaMD04I9gNdk/VMDt7QeF4Dm/IJnoH34/d69D6KI
	 yhWuXEsvblcKwDA0X+gdEdjmuKygmoShmtuHnEvJ71zs60UEZFUfZJO0AS9/bEtIpn
	 1ZPKqhfQdlYAl4wN07TIAkuLp3pvlIc/VvtN2Cjs=
Date: Thu, 21 May 2026 17:00:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org, syzbot <syzbot@kernel.org>,
	adrianhuang0701@gmail.com, akpm@linux-foundation.org,
	kexinsun@smail.nju.edu.cn, oleg@redhat.com, peterz@infradead.org,
	syzbot@lists.linux.dev, tglx@kernel.org,
	Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>
Subject: Re: [PATCH] signal: clear JOBCTL_PENDING_MASK for caller in
 zap_other_threads()
Message-ID: <2026052150-header-bridged-03c8@gregkh>
References: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
 <20260521-kultur-zahnpasta-f09198836179@brauner>
 <CANp29Y5Cjy6k2vLp2+2O9FXwRXAmNP_ja6seORVXVQnrdUwH3g@mail.gmail.com>
 <2026052159-conductor-suffice-4c81@gregkh>
 <CANp29Y4Pe5Skz9A21ksAymybgyVhHgpaQJ38UTX4=+YLvzoMgA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y4Pe5Skz9A21ksAymybgyVhHgpaQJ38UTX4=+YLvzoMgA@mail.gmail.com>

On Thu, May 21, 2026 at 04:30:24PM +0200, Aleksandr Nogikh wrote:
> On Thu, May 21, 2026 at 4:17 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, May 21, 2026 at 03:03:35PM +0200, Aleksandr Nogikh wrote:
> > > (+Greg)
> > >
> > > Hi Christian and Oleg,
> > >
> > > Thanks for reviewing and accepting the patch!
> > >
> > > However, it seems that we first need to clarify how these types of
> > > patches should be submitted to ensure we don't violate the Linux
> > > kernel rules regarding AI-assisted contributions.
> >
> > The documentation is very clear on this, what is missing?
> >
> > > In a discussion under another patch by syzbot [1], Greg noted that
> > > syzbot cannot be listed as the author. The official documentation [2]
> > > isn't very specific about how to handle this exact scenario.
> >
> > A "tool" can not sign off on a patch.  That's always been the case, a
> > person has to take ownership and responsibility for it from a legal and
> > technical point of view.  Again, nothing new here, been this way for a
> > very long time.
> 
> The documentation was very clear that the `Signed-off-by` tag must
> belong to a real person and these 2 patches actually did have such a
> Signed-off-by.

So, then you end up with an "authorless" signed-off-by patch, something
that makes everyone sit up and go "what just broke!".

> We've just updated syzbot to also add a `From: ` tag with the
> name/email of the person who pre-reviewed the patch and approved
> sending it to LKML.

Then they are the ones taking responsibility for a tool-generated patch.
Good luck with that, and be prepared for people to just blindly reject
them...

thanks,

greg k-h
