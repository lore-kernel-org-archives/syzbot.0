Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A328D470102
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 11:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786016361; cv=pass; b=hcJaMhBLNk6BPizyJQEi0n2ELUNGw38bjfPp/pX2zVml7NHpcNWLENnqJvoE+pq/wsYYBhPjFKBVAX4pGevbAGaQz9f6F8WZIMVq7+jQpTOhM4MmhhJma8TwRQb2b+TLIHdSCbZnd83j/BcmIDrQOsNHqNpNUdrv4HTxodDZg/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786016361; c=relaxed/simple;
	bh=Ms2b1+iwLYtJW4EKc+FcT7UgEfOQ/W9ht+OujYO5R4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7AwwMogru9PMJJHOiwBsH8uXRN1anFZ4EzPojjI5zKoi9ZzkILXF5YeSTX3vUvlyAOp/3wd6unGUbzztgKZq2qhkMa4TaNL2LDbauoD+HmgobxnibJh4+jgmri654T0GKkkrY1dHDY32SoepS88Xf90LErc1R2rRqY8ds4wT9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=JXu4DdVl; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="JXu4DdVl"
Received: by smtp.kernel.org (Postfix)
	id E2B351F00A3A; Thu,  6 Aug 2026 11:39:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786016349;
	b=Xeewb+wuj2iEPzorodsTFOW5FZYGbzgCfgl2Q9VOicyTG3LrEOihyXlqTrmGlYn/RKBL
	 UeeLWEN0R78XUuRgBaHw2HuL4xjV9/GCD+EOEIpGpQMNTa5RdnR0XJanvDXA9Zb2fu7dB
	 b2jByQOKJp5+2ij57JDmAxhi+IkIq616XaNsTcnNZsFB/r20XVMoFSY4yLeUG56k0ZADY
	 55lxc9oosdrsQeQHkEghdBRuWrwl0wUk6LFd0ZmS+QhtS6qjUPdw5+abOgPvaLHCDxA9/
	 1cIQ0kQevIJIDkAcLb8lswWytXQnKdxAXF1OB1qQpvDh9YaaBHGs7KsaKr4Yx8MhBbw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786016349;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=fLlyC2WWzGpA57gYNxu0gi5EVGg83nFZiTa91Q+iepA=;
	b=Qz87YvNcjOLFwrJpGUze3vC6sDXmdLhjgQv/6BR8pR05gjtYybGHJ15iWg40N5wvaRtq
	 aQPmCvpyPNQUzARTTctYdCBeoL82jNcgAXcJpvCk6TwsbZGSAjT4MVQQkMJfNFcAwhbXZ
	 CryOdyU/L9T97gPW5qkLfvvRHaQaE5aQgAXfEODHMZKKzmKtifMbK75Fix+Vrp/43VQqJ
	 jzV+sIHfDksqskdsbAbBwpZUH6clDVZxJLFBZiSpxZa4m1O1euoprr/LZMTLIQZUsj3Z5
	 lFzGJKdjQ2PBJFoVRNPYi8xbWgz2qn6MbQCpSAle34ovjN+zBDAZhcLCuicbsMkViRg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=JXu4DdVl;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 873F11F000E9
	for <syzbot@kernel.org>; Thu,  6 Aug 2026 11:39:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=JXu4DdVl
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 873F11F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu,  6 Aug 2026 13:38:56 +0200 (CEST)
Date: Thu, 6 Aug 2026 13:38:54 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Aleksandr Nogikh <nogikh@google.com>, syzbot <syzbot@kernel.org>,
	syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>
Subject: Re: sysbot AI patches and wireless
Message-ID: <anRyTtgRT8gVUZYR@nr200>
References: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org>
 <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
 <CANp29Y6sHOe5QY6BgzeUtKFGqc2pDyP8WAUzQ6E1-3oYgZTY0g@mail.gmail.com>
 <6007f37089d14eb14deed54d34921f0ef691e1fa.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6007f37089d14eb14deed54d34921f0ef691e1fa.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1786016338; bh=fLlyC2WWzGpA57gYNxu0gi5EVGg83nFZiTa91Q+iepA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=JXu4DdVlV8VFgq8sIy0qeIIHOvDUAKqPtCMa3f/mNQd3v6Q8oHGauTuC+sU2GNeKc
	 wcZKKANzKBh9uOS6q6vHyktjVQY+toPMyhSfBsU3zATrMX2HjpVcoEehQ1/5Di479A
	 LOs5QhYpTyZ4JzcQp8xRW/6Yb1dlajzuJ1J5vI7g=

On sie 06, 2026 12:15, Johannes Berg wrote:
> Hi!
> 
> > 1. Every AI-generated patch sent by syzbot has been pre-reviewed and
> > approved by a human engineer. The person who approved the patch is
> > listed in the From: and Signed-off-by: fields.
> 
> Yes, I realize that. But the experience still seems to be one of me
> effectively consuming pure LLM output, just via an intermediary. If I
> had the time to do that, then I'd be perfectly able to talk to an LLM
> directly, cutting out the intermediaries, and get the issues fixed that
> way - much, much faster than writing everything in emails.
> 
> If, on the other hand, the intermediaries actually do the necessary
> legwork etc. then I don't think this whole process is necessary; I don't
> think using "b4" would be a significant hurdle in the process, and
> that's really the only thing this helps with? Maybe LLM access (not
> everyone has effectively free tokens), but that's still enabled by
> syzbot providing the service over on the internal/upstream-moderation
> list I guess.
> 
> Now, of course now that I say this (and you disabled it) I guess I'll
> just see the patches pasted into an email manually instead, and I've
> lost the signal that I could use to just ignore them entirely, but at
> least I've been honest about it - and I guess I'll still silently drop
> patches where the "human engineer" has no idea what they're doing. Even
> having Reported-by: syzbot has been a signal of that to some extent.
> 
> I do think syzbot is a bit of a special case - at least if there's a
> reproducer it's trivial to tell the system "hack the code until the
> issue no longer reproduces" - but that's almost certainly guaranteed to
> not be a useful patch yet.
> 
> The system, in a case like this, is almost certainly going to provide a
> very narrow, targeted fix (with an annoying wall of text explaining
> exactly that), but I think that at least the human in the loop should
> actually take a step back from that and ask what the semantics of the
> code should be ... I've played this game with Slawomir's first patch
> myself, but that clearly cannot scale if the original intermediary
> doesn't want to do that.
> 
> Maybe it's something you can even tell the LLM to do, somehow, so the
> first draft is better. In this case, for example, why the hell did it
> decide that it made any sense to have multiple branches of the same
> switch statement - and there are even only two! - implement the same
> validation? At the very least I'd expect the "human engineer" to take
> that step back.
> 
> This is why I'm refusing these patches, because clearly nobody actually
> even bothers to look at the semantics of the code before or during the
> patching. Does pulling out the check outside of the switch change the
> order of errors? Yes. Does that matter? No, the new order of errors for
> NL80211_TDLS_ENABLE_LINK would actually - if you think about it (!) -
> make a lot more sense! Am I surprised the LLM doesn't do that when you
> tell it to make a targeted fix? Absolutely not.
> 
> But I really cannot make that judgement call myself for every single
> issue like that, if I could, see above, I could be doing all of this
> myself. Need the contributors to do that. Slawomir did that after I
> prompted (pun intended!) him to do that, and it didn't work out so well

It didn't? Or it did? :) Well I do not have new version of the patch yet, but I'm still
investigating correct approach and testing a lot. I see now, that I should do that in the 1st place.
I'm sorry for that.

> and we had a good discussion about it, but again, I can't provide that
> support all time.
> 
> > 2. For the patches already sent to LKML, the bot *does not* send
> > automatic replies and *does not* automatically submit newer versions.
> > Once the patch is on LKML, follow-ups, comments, and iterations are
> > handled entirely by the human developer who signed off on it, so you
> > have not been interacting with an LLM.
> 
> Thanks for clarifying. I've definitely seen pure LLM replies (sometimes
> even with the output saying things along the lines of "the reviewer said
> this, I'll explain...") but that might have been in other contexts,
> clearly it's not just syzbot which enables people doing things like
> that.
> 
> > I apologize for the frustration this may have caused. We'll stop
> > sending AI-assisted patches to the wireless subsystem.
> 
> Apology accepted, and thanks for disabling it.
> 
> Slawomir, Krystian, I assume you mean well and I apologise that you're
> getting caught in the cross-fire here. Even the targeted fixes are still
> fixes, so I understand from your perspective this still made sense, but
> from mine it just absolutely cannot scale, both in terms of long-term
> maintenance (sprinkling checks all over the code disregarding the
> architecture) and also in terms of review bandwidth etc. I'm sorry
> you're effectively the two first victims of this new process.

Thanks and now worries! It's a good lesson, that the overall subsystem might need a better
approach. I know, that I sometimes will overlook this.

In the end, I should be saying sorry for wasting your time. And also, I should say `thanks!` for all
the good hints and "prompts"!

-- 
Slawomir Stepien
