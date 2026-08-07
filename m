Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1E0376A1B
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 21:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786139277; cv=none; b=oUPPXKEE5aDYpxKhM7iqfPrXpBOXlZKQncLDPzwNEZn6YAWT3NsabMlOaLZoWqQoJNL94HFNGmCY5y92/iRvEPTDTPduPupkkkvNr7QxFzZoL2dmt3ItOafCCmmW2Lc2iD8yovXP8QVpBxyPNpnhoCv3f7nrwLb3Siqp7gn969Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786139277; c=relaxed/simple;
	bh=koetqpbEeC98gN9e1Ssr7tU8lFk8F9fQE39eeScZrIs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QCHaIPXZ0e4sAIcBy4Hg5MnXqiz3HkwJt/B9aigUsjahgK9bH/vlZa9A4U7risRRKiEEMj73P51Sgxt6GNqRWvNDH6L5Yyiq43nPxvaL56fMjwChbzAPcqTuIp8FYHu84kQdIehoWG7GYwonfPhboSfy/9/KRW9E6wO9dXfQs7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMDhvnsK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMDhvnsK"
Received: by smtp.kernel.org (Postfix)
	id 588471F00A3A; Fri,  7 Aug 2026 21:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE381F000E9;
	Fri,  7 Aug 2026 21:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786139276;
	bh=KBdgQ/OV4x8IrDGHO26NYn9OVVaYEM8IGv/f3C6IApc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UMDhvnsKKc2XDlrhfiNx4O7ylsD0fxXTK/EcX3d/aR+0AUdzXSw0A6oLhvGtRzFwn
	 g7mMAQVGnTD79eOJiKS3dncwOHljGKBVhTiVJYp2GR8QKhB3W2Ad2Nh+oKRxpsjSj7
	 lE3x6VRJsN0TB8iHW9dVHhIqIUES6Pkm9130/kbCw7iIDx81lTjk7YDPzwvzZBHItr
	 W9TNT23Gq2FvZWdunZ9by370aTPExF+uFXdsVIKBnG88USxcsj7OGsISrBEmZ+p0CW
	 mqyJ2Y8vWFvamJOD+mQYA0vLPPdnAatnPUGlvpcJ7nnlJ1sDICec59oJFau7xsY9G5
	 DkehCaugVh3qg==
Date: Fri, 7 Aug 2026 14:47:55 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] netdevsim: fix deadlock in nsim_bus_dev_max_vfs_write()
Message-ID: <20260807144755.49141d2d@kernel.org>
In-Reply-To: <anWJyHCic8XvA0Q2@nr200>
References: <b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org>
	<20260805160851.571ed66f@kernel.org>
	<anWJyHCic8XvA0Q2@nr200>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 7 Aug 2026 09:31:20 +0200 Slawomir Stepien wrote:
> That's true, but is netdevsim used *just* by the selftests (or was
> designed with only selftests in mind)? What if someone is using it
> without selftests?

Quoting documentation:

  netdevsim
  ~~~~~~~~~
  
  ``netdevsim`` is a test driver which can be used to exercise driver
  configuration APIs without requiring capable hardware.
  Mock-ups and tests based on ``netdevsim`` are encouraged when
  adding new APIs with complex logic in the stack. The tests should
  be written so that they can run both against ``netdevsim`` and a real
  device (see ``tools/testing/selftests/drivers/net/README.rst``).
  ``netdevsim``-only tests should focus on testing corner cases
  and failure paths in the core which are hard to exercise with a real driver.
  
  ``netdevsim`` in itself is **not** considered
  a use case/user. You must also implement the new APIs in a real driver.
  
  We give no guarantees that ``netdevsim`` won't change in the future
  in a way which would break what would normally be considered uAPI.
  
  ``netdevsim`` is reserved for use by upstream tests only, so any
  new ``netdevsim`` features must be accompanied by selftests under
  ``tools/testing/selftests/``.
  
See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#netdevsim

> On the other hand: what sashiko found:
> https://netdev-ai.bots.linux.dev/sashiko/#/patchset/b7bf56ea-7522-4163-acd5-aaa69ad03b3a%40mail.kernel.org
> is true: the same issue will be with e.g. break_health. So it seems
> to me that a better approach would be to change when the debugfs
> files are removed.

I seem to recall being annoyed at the fact that the health API takes
devlink lock. It should be callable from IRQ even. Forcing drivers
to worry about calling context is annoying for real drivers too.

> It seems to me that change in nsim_drv_remove() might be easy, but
> what about nsim_dev_reload_down()...it seems it will have the same
> deadlock. Or am I missing something for this case?

netdevsim is just a test mock. Fixing it for the sake of fixing
netdevsim is a waste of everyone's time. The first question you should
be asking yourself is "do I understand what this code was *designed
for*"..
