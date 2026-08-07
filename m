Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D01346ACD;
	Fri,  7 Aug 2026 22:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786142132; cv=none; b=rHoaSHAVUFmIe4cK76TSxdmfzKafFoImyM94cYG4QrexHZRvXQGmrEC/6afrDb1XIOSG28zjF8I8+fNQCekMdYz53vPZEp3RokfSLJW+t+m3kpHEKq30dmoWMjN82P0fdUHZBjSrBRxtrDt0gN8OfzuzWNlUeux5RqihAFN0rv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786142132; c=relaxed/simple;
	bh=qDkgE9PGCbfDeftLSzs9d7Br7G32w/X48uSfIW5fHFk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZqbTEGGi35lamcDixp5qg2NIqGFZTswmbz8rDuciUpSIWwg6BR++C6CMJpqz0jrOIGCwvZA/pGJ5+P2T26yqGYuFtiIJgarb0QKL96iEp3c+FLwZJymY58HwLId09dGhhYYDpWqWxWL8nnxJ0LQzvNgSNk0uOU3UvXNsZB6las=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTZb54Og; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTZb54Og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B8D1F000E9;
	Fri,  7 Aug 2026 22:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786142130;
	bh=+dDabnMX0EOFiescR6reMbGEEEd9vh8FGXlBes4S4s8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KTZb54Og0flJ0LaQeG2dW5mM+rn1AEt9S4FHjW7Wi3aQt9JgaEky2Q7Ror/7NaZXv
	 xUyLpyLo0M3uhldzNAZsrKESUcf5/ITteDe+9Wva5pb1ExqRlZD4s1pU0cmkcebPa1
	 pKdku3EZkqu6ICthMY6QnI5KXUl38oChoT0KH4WRuueUpdP0OlNd5+VgDfj1duEANF
	 gx8QPMLGYSF4Ay8AmEZZq2+B+bgbzSsZdcnzSC7XU5HLimW/1u91vykdnpARNHgCYI
	 8jYMAeL+IsKM0CzgbJlzItRIkjPUdj3HAix9foV9w/vr0qsbWgqpBH0wraXBlzHPo5
	 foZBL3n1gJMGA==
Date: Fri, 7 Aug 2026 15:35:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Antonio Quartulli <antonio@openvpn.net>
Cc: syzbot ci <syzbot+cifb58fcbd8413e765@syzkaller.appspotmail.com>,
 andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
 netdev@vger.kernel.org, pabeni@redhat.com, ralf@mandelbit.com,
 sd@queasysnail.net, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: pull request: fixes for ovpn 2026-08-07
Message-ID: <20260807153529.79fdd152@kernel.org>
In-Reply-To: <937f09b2-cd5f-4352-90dc-dad67ef8ddf2@openvpn.net>
References: <6a756ce9.01d0871a.3a0d52.003b.GAE@google.com>
	<937f09b2-cd5f-4352-90dc-dad67ef8ddf2@openvpn.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 7 Aug 2026 08:37:39 +0200 Antonio Quartulli wrote:
> Will get this addressed and respin the series.

This gets triggered in your own selftests.
You should probably take a hard look at your CI setup? 
