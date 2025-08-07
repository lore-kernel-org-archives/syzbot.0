Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC1525BEFE;
	Thu,  7 Aug 2025 13:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754574078; cv=none; b=VtMHI60s48y3ptm+jGhWhZVYtGuHu8vbB6T9FzPluqYnb9W8qWpTUIN9Db6O/XTem/cwX/BiN94Pjx/8EW9rx6HG9QST8hXjBMD0K/F81dXocfnDzgYLeyrEzMHHb7R9NX80sZx7mk/YnZtwrob0OCcdCzewlgLO3aqYUz2VKgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754574078; c=relaxed/simple;
	bh=SPfwrzSIan42jP1kA3wWuNVvDGLGoZyFGkOKG4nL9LM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QnFRpl2HEQXD6rcHy52hpRKAc+RUuaoNW6BmWNOj668Og4cdAYNpDsinEjkG/oIw2kcCzgypU+0S7u3cwnejRnchdsCgmXb7sj3ZthVNx/k/9zH3eRbshXH2icaFT16uPRaJSCYuiP0Z+hdHk55daI5t9gwLzAC7kHjVUuZ3QS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuVzllHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuVzllHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689DBC4CEEB;
	Thu,  7 Aug 2025 13:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754574077;
	bh=SPfwrzSIan42jP1kA3wWuNVvDGLGoZyFGkOKG4nL9LM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PuVzllHVyMG1DgKAWwPxddy4QHEdg0sGfWKBg7mYbOTy1b+XZRwym6RlSPYPpHh6Z
	 ORpNGhR5P2me/N+3HCPIwIKZMIgB9eTXZ+3svW9gI9s5PdQ7Kw+LAz0qZSER/UaS2b
	 kun74eRZnMls1mj+NtFHx3VAXxYQ/LRqL5AYyAk9rrqGmVnMDS9hymxhxEEMnwtOI6
	 w+xAU1FYEPpHBKbLIqAXAPNNYp3y/tfBRqvysi9wmZXhGCA7tB83PrdrOIuY9H36vJ
	 gY8dtUnP+qtBPvPJEfcuSIKcqHd26shhyEi/N/8TZCEFl4T8HUxDVPfD9FjTwsBPLL
	 4Wk27rYoTXNBg==
Date: Thu, 7 Aug 2025 06:41:16 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: dvyukov@google.com, edumazet@google.com,
 linux-kernel-mentees@lists.linux.dev, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, syzbot@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: Revert tx queue length on partial failure
 in dev_qdisc_change_tx_queue_len()
Message-ID: <20250807064116.6aa8e14f@kernel.org>
In-Reply-To: <20250723094720.3e41b6ed@kernel.org>
References: <20250722100743.38914e9a@kernel.org>
	<20250723162547.1395048-1-nogikh@google.com>
	<20250723094720.3e41b6ed@kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Jul 2025 09:47:20 -0700 Jakub Kicinski wrote:
> On Wed, 23 Jul 2025 18:25:47 +0200 Aleksandr Nogikh wrote:
> > On Tue, 22 Jul 2025 Jakub Kicinski wrote:  
> > > I think this email is missing a References: header ?
> > > It doesn't get threaded properly.    
> > 
> > Yes, that was indeed a bug that has now been fixed, thanks for
> > reaching out!  
> 
> Thank you!

One more thing, would it be possible to add / correct the DKIM on these
messages? Looks like when our bots load the syzbot ci emails from lore
the DKIM verification fails. I see a X-Google-DKIM-Signature: header,
but no real DKIM-Signature:
