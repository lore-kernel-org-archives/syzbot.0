Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E65C37DEBE;
	Sat, 27 Jun 2026 21:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782595318; cv=none; b=ZBvd85zXl1e8/cH5YA8F6TPwEznRSMmtcfDnvDTx0Fv6rUxeKqRV7b8gOiuI+v/0MyYs0/gK/QWU4nznVbpw+bZR12kEl6eiR6Xr5SB7Cq8cVIq1HplK28pYf8K7b1BtffzbOIY4I5mMSxRJ0cpQ4YKJwn19nFjzWjCGCrbeCGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782595318; c=relaxed/simple;
	bh=fLVB8L5+UljNjcYGv92tq6IstmLoDyzrm8uVsdgxFhg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=So2wQ/ZM858bnGKclRygA/i6QpGR06qJ8FLzmV+qaOrvLVxtISg8+Fac8ARhlAT+Cws5IMjojlGdUFQ9viqiFjKI/B/GSRqewhLKu9IvBjhhmnrCuqD5MZl7nIK0KUi5LlWYJPYaB4J9G3kkfWhSKVcPphPDV3htgE5y9H5qVu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etwKwAkq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etwKwAkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47821F000E9;
	Sat, 27 Jun 2026 21:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782595317;
	bh=x5uT+S91bvMhpnwLh7iOTlNFiSDT1D7uAsCLsW/OXis=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=etwKwAkqBhWWyGjxnktRGcWg9eLJSghh12WRaB1pGLx5X7wRliWWGNmWU3bE/nuPX
	 KFAu/GmsEQcQvQC3+2jDi6JIRrvKu64YKTqq11hlHL2j1VVJXWes0VUgcowHspKNjD
	 UioAn9dNnm2bx3beW1HLHbDq6b2N8LTGgNkv1hRokUnZX9SRLoxGxg2WWFPIqDUat5
	 pb2NQ5ftsiqy6+8LFwnqKmA8IaaL+DxdG81EZF/+p6yRV5om2PQsl7Ubl/CDKLTrH6
	 uIgmcNgGXc8RuxsH0PBDRrwB7s/n9rREsgcYOyyn/PEXamA+B10aezPLF2sWja1oag
	 4LmIJHSc5nUTw==
Date: Sat, 27 Jun 2026 14:21:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "syzbot" <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, "Andrew Lunn" <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, "Eric Dumazet"
 <edumazet@google.com>, <netdev@vger.kernel.org>, "Paolo Abeni"
 <pabeni@redhat.com>, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] netdevsim: remove debugfs files before freeing
 net_device
Message-ID: <20260627142156.64c5799a@kernel.org>
In-Reply-To: <f15205c4-30e1-454f-97e6-92067a74f98f@mail.kernel.org>
References: <f15205c4-30e1-454f-97e6-92067a74f98f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 27 Jun 2026 11:20:11 +0000 (UTC) syzbot wrote:
> A KASAN slab-use-after-free was detected in debugfs_u32_get() when reading
> a debugfs file associated with a netdevsim port.

Please read the replies to previous submissions:
https://lore.kernel.org/all/20260626184856.4b7f5228@kernel.org/
-- 
pw-bot: cr
