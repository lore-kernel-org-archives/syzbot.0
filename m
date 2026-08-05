Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885624657C6
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 23:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785971334; cv=none; b=Z6IqQqflWahciZGJ1ztAyUNyxCEZdvTf/XDMSDsANfGz6Pyq8a5qrZszJuUf1OYR633IB/VMLfTfJzDNr6Qwlacgicfon4zamx20T9P6JSUeSr++L2KZcKrd63mR45RNPIICGuNFlYbMfKDe2m77GKIAVqHALukEhGvjkJIuDh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785971334; c=relaxed/simple;
	bh=ahy/Nfw+qM4VThvlqfvaTbOQvtjxLxUjyU37AdDdB54=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TPnXH0ZcpOisoIwnTAj+YUUizq4tuedbckr5lQFEDaQHjzpdCmHlWmdI18Q+050DgYhVaW/9pLm2A/scjkMtY97eHHBdCfPN1JjtU4FBwyq5nKJyQENhYJvaTstK3mfp5YtXc0867anEls1Lm5cSZ1JTT7K9dkbRyzVQmPM7z+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0ra4w06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0ra4w06"
Received: by smtp.kernel.org (Postfix)
	id 4D8401F00A3A; Wed,  5 Aug 2026 23:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79371F000E9;
	Wed,  5 Aug 2026 23:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785971333;
	bh=ahy/Nfw+qM4VThvlqfvaTbOQvtjxLxUjyU37AdDdB54=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=b0ra4w06+jlHoug4cSFCgOcaGNEvIwt1QYAlptreMaGVuu6REgxA43wQBvZp5ohbT
	 agbO7i4nwtDZVlDErd3151Bsg2D8IO+Kt3HFPKUoFKVblnKOe05l8LhSsVKX5i+v2t
	 R7K7WyRjPxqOpxy5eSi8VH5yM09GIYUz4OEE90gPadsr2A91pqyweP6tpgvtTQQT92
	 6pGE1O66F3QcTUbqGN1HuLUfjO2qepDxi0lMkZEmCiBclNFBq6KDXHFRIcjoMtkGso
	 mdJ70B5AwmXlZ5jNf5bGCysU12n58wiDBORfN5IkmGe09uVsEc7oPeMTNuBcq0DxUD
	 RjEOJ/sb0Jl1w==
Date: Wed, 5 Aug 2026 16:08:51 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "syzbot" <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>,
 "Andrew Lunn" <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>,
 <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] netdevsim: fix deadlock in nsim_bus_dev_max_vfs_write()
Message-ID: <20260805160851.571ed66f@kernel.org>
In-Reply-To: <b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org>
References: <b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 09:55:04 +0000 (UTC) syzbot wrote:
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -273,7 +273,11 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,

Sorry to chime in poniewczasie.
Please delete this file. netdevsim is a harness for in-tree selftests,
none seems to be reading or writing the debugfs num_vfs AFAICT
so let's just drop it?
