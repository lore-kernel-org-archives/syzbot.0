Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416AB3D4105;
	Thu, 30 Jul 2026 22:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785450770; cv=none; b=GxBuABdHwcGK5BoviFr0866TUVp4LCyBjpkmodEQBmq7regI65/ll1MZStTA45ybYYRBtBgswGIJMA4ZcIUCOgAyGlKKZ889cYQzLyhAspTbPO/33N7CKd5lAUCKyme5YZK5lhTY0ZUcKvnQl61jVINFD1f/gw/h1CwKc3bORMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785450770; c=relaxed/simple;
	bh=j+FX6xg6tPwXVeimEhngDdnA6nU3pL3rYKzacO944jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ffS+QvAJvC2xPWvanpXFNq/qRKsG7uPPqhE0yq2FB/Q1DShLh12sPJ0PXIfYQwQOpYSYRghuHoRav1A1OjIdjijghi/k7eUg2iBzn3J6MM4hY1VbbaoMtpd0lCk4h5cK9MLH17kVE2Bj+BG9HVKr11sK40uWHdmeT9TfYDJioRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elK4ZcLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elK4ZcLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6661F000E9;
	Thu, 30 Jul 2026 22:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785450768;
	bh=SRwrT1r0NKbkZ/4FVHLT2H1almQLO4Ohk2yrJOdusig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=elK4ZcLN9JjaOwxXsTiy9dHl2zOiFRC1cIWxjhb/I8mqOPFckShR/nBP5obHW9wkb
	 2XHMToe/w3sPS8KfhjSJeUUgf7psouIZQBrW9cuuDNL+4mq7C9RsPTkEHwSloEaPOm
	 aLLnqwNAIFEbJJK+8tkXi+lQYf3tGht4rfgLPnTrbZCrYZpsKNjnLivO6RUW7DDhMd
	 kim2AbjC+oBhDDcJJ2Ljh6QNSViGR2HqIT7F2NcVHvy69pMxr4E9oGg2DwhV3lJoHU
	 DqCDjOZw4ArNTPSuFwhGB+daQVFs1d/F+rEwHxnrlbIQrOS8dhO38Z5J4hf+v9XtBg
	 DnnpAlnxAb50g==
Date: Thu, 30 Jul 2026 15:32:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "syzbot" <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Krystian Kaniewski
 <krystianmkaniewski@gmail.com>, "Andrew Lunn" <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, "Eric Dumazet"
 <edumazet@google.com>, <netdev@vger.kernel.org>, "Paolo Abeni"
 <pabeni@redhat.com>, dskr99@gmail.com, kees@kernel.org,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] ipvlan: keep lower device alive until private
 destruction
Message-ID: <20260730153247.2373cf7e@kernel.org>
In-Reply-To: <26b3176e-d9ed-4508-bde7-388deefd970d@mail.kernel.org>
References: <26b3176e-d9ed-4508-bde7-388deefd970d@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Jul 2026 08:40:37 +0000 (UTC) syzbot wrote:
> Subject: [PATCH] ipvlan: keep lower device alive until private destruction

please rebase on net/main, and repost with [PATCH net v2]
-- 
pw-bot: cr
