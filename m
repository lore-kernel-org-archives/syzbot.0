Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBD843F8D4;
	Thu,  6 Aug 2026 10:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011343; cv=none; b=QWsz9bQHaK/aMmhZBybmwrkv0LFq7q2VARJd25r0hM/hc79dtiXdxq/tB4iyVBmCWns3z4NHrcCPoDUDxRz21Q6Tb/sk2Db2DnDLgrCDAeZtDvc3v49Ew4gGyviORevQnndXaVHqNeouKAC37snYm4LDH+Z5yYm150mavUBMApI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011343; c=relaxed/simple;
	bh=1fmvtaAWoMP1VQR5OHubgCetHapNW874u4kQCtnU4UY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WJLM300u8aW8Hq7ZsHoMYvmVHapnnoh51rFb7+jpBE1Ha0nT/S02F50esFkjgiDZSViItOs/wy39y4Wri9SdDIk2wEIqRbXmeoI+8xyQiuTUqhzIdx9y5pi0dmIdX9X/JUX9AhkhEeHu1i2S+w2L1jcQi/t0fhf0/eVm+hnvvF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=R9pJ5sTG; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="R9pJ5sTG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1fmvtaAWoMP1VQR5OHubgCetHapNW874u4kQCtnU4UY=;
	t=1786011339; x=1787220939; b=R9pJ5sTGz1I3cDaRpAusfHMxp53vu99+ELA4LN1kxRwAbdi
	sSzZrNgpCWaAyBSUxcJzdHBXBk1WojNdVfXW2CCTtvB49PPoNYuh/VTtk1clbj3qduQZ/IqzCI+NP
	t4wkhKijP+CitRUEFbxG7f76L1l0/BDsG/77ft/UJDy3foRqKwNaEDeQqiWAXvojrrhWrKrRFhcqs
	qyEUDRBWyKkIYAV82bZPIqyUi6TWGuR6ml9Hi1i3u6tLSpjd3ZGdUay4DGs2BkKbGBuEeJqLXgMM0
	Hjdl05RIy9y5YoDlwXQB50vjqnQOKCuAIKXjmPUS8I9Z3FifxztavVjnwfx/DIUQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wrv8P-000000005no-1D4h;
	Thu, 06 Aug 2026 12:15:33 +0200
Message-ID: <6007f37089d14eb14deed54d34921f0ef691e1fa.camel@sipsolutions.net>
Subject: Re: sysbot AI patches and wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, Slawomir Stepien <sst@poczta.fm>, Krystian
 Kaniewski	 <krystianmkaniewski@gmail.com>
Date: Thu, 06 Aug 2026 12:15:32 +0200
In-Reply-To: <CANp29Y6sHOe5QY6BgzeUtKFGqc2pDyP8WAUzQ6E1-3oYgZTY0g@mail.gmail.com> (sfid-20260806_102109_476227_AFE35DBC)
References: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org>
	 <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
	 <CANp29Y6sHOe5QY6BgzeUtKFGqc2pDyP8WAUzQ6E1-3oYgZTY0g@mail.gmail.com>
	 (sfid-20260806_102109_476227_AFE35DBC)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi!

> 1. Every AI-generated patch sent by syzbot has been pre-reviewed and
> approved by a human engineer. The person who approved the patch is
> listed in the From: and Signed-off-by: fields.

Yes, I realize that. But the experience still seems to be one of me
effectively consuming pure LLM output, just via an intermediary. If I
had the time to do that, then I'd be perfectly able to talk to an LLM
directly, cutting out the intermediaries, and get the issues fixed that
way - much, much faster than writing everything in emails.

If, on the other hand, the intermediaries actually do the necessary
legwork etc. then I don't think this whole process is necessary; I don't
think using "b4" would be a significant hurdle in the process, and
that's really the only thing this helps with? Maybe LLM access (not
everyone has effectively free tokens), but that's still enabled by
syzbot providing the service over on the internal/upstream-moderation
list I guess.

Now, of course now that I say this (and you disabled it) I guess I'll
just see the patches pasted into an email manually instead, and I've
lost the signal that I could use to just ignore them entirely, but at
least I've been honest about it - and I guess I'll still silently drop
patches where the "human engineer" has no idea what they're doing. Even
having Reported-by: syzbot has been a signal of that to some extent.

I do think syzbot is a bit of a special case - at least if there's a
reproducer it's trivial to tell the system "hack the code until the
issue no longer reproduces" - but that's almost certainly guaranteed to
not be a useful patch yet.

The system, in a case like this, is almost certainly going to provide a
very narrow, targeted fix (with an annoying wall of text explaining
exactly that), but I think that at least the human in the loop should
actually take a step back from that and ask what the semantics of the
code should be ... I've played this game with Slawomir's first patch
myself, but that clearly cannot scale if the original intermediary
doesn't want to do that.

Maybe it's something you can even tell the LLM to do, somehow, so the
first draft is better. In this case, for example, why the hell did it
decide that it made any sense to have multiple branches of the same
switch statement - and there are even only two! - implement the same
validation? At the very least I'd expect the "human engineer" to take
that step back.

This is why I'm refusing these patches, because clearly nobody actually
even bothers to look at the semantics of the code before or during the
patching. Does pulling out the check outside of the switch change the
order of errors? Yes. Does that matter? No, the new order of errors for
NL80211_TDLS_ENABLE_LINK would actually - if you think about it (!) -
make a lot more sense! Am I surprised the LLM doesn't do that when you
tell it to make a targeted fix? Absolutely not.

But I really cannot make that judgement call myself for every single
issue like that, if I could, see above, I could be doing all of this
myself. Need the contributors to do that. Slawomir did that after I
prompted (pun intended!) him to do that, and it didn't work out so well
and we had a good discussion about it, but again, I can't provide that
support all time.

> 2. For the patches already sent to LKML, the bot *does not* send
> automatic replies and *does not* automatically submit newer versions.
> Once the patch is on LKML, follow-ups, comments, and iterations are
> handled entirely by the human developer who signed off on it, so you
> have not been interacting with an LLM.

Thanks for clarifying. I've definitely seen pure LLM replies (sometimes
even with the output saying things along the lines of "the reviewer said
this, I'll explain...") but that might have been in other contexts,
clearly it's not just syzbot which enables people doing things like
that.

> I apologize for the frustration this may have caused. We'll stop
> sending AI-assisted patches to the wireless subsystem.

Apology accepted, and thanks for disabling it.

Slawomir, Krystian, I assume you mean well and I apologise that you're
getting caught in the cross-fire here. Even the targeted fixes are still
fixes, so I understand from your perspective this still made sense, but
from mine it just absolutely cannot scale, both in terms of long-term
maintenance (sprinkling checks all over the code disregarding the
architecture) and also in terms of review bandwidth etc. I'm sorry
you're effectively the two first victims of this new process.

johannes
