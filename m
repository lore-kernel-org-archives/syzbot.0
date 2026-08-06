Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77BE3B813D;
	Thu,  6 Aug 2026 15:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030716; cv=none; b=QjKEdq7i8GmfRatRh4r7u9hK6hanjPqqC9SNZnY88+1aYzHzXlY0Qq/VeJ54X+jLL+2rxp/8mVJ8zzeW4OYN0npNTGY/K4kpPex7PaB+CL2tX6PYw1z2dDfFUq/kN8X1SopbDjBwxSOzv3T7PT8GL6UrplN9BGfEACaZDwrpr9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030716; c=relaxed/simple;
	bh=CLgpZ+mqLkfssG2OIAC6ZREL4VwTQNnxyNCwt5Bir/4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fbYmWsTzKi/diFIfOA5X/cnDgn/9HBL/xrwTGeW/7z992OXlerYU6Sl9458r+uiAc0PHRtTzCGOncPEeF4s7C1Iih03a4NO5OAjgCJsnHlvxPmn5Frz6FByHUaiYQRos0JOtF4wtxh3Wr85BeAvfycTcrLChh9soApbb+i2qx/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PNem0QtT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNem0QtT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304091F000E9;
	Thu,  6 Aug 2026 15:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786030715;
	bh=6gYOa257In8vn3YLaZJ6UX8femFZuLnE6kCXMgTsP+U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PNem0QtT4d5BPtqw5WNgK64ZEays+Flk4NrHQ/6Jb0ERzAlxpMUB60e63qX9bwJYQ
	 1lHoePlqV6bIqGhwZfWz1Lf7E8BO4hQsX1DWW/hCTe4geoVKTX8D58BQyxo8gePPMP
	 YvyB7U/KNYbMOrG/jXTCeVXGmEMGsa92zMMAuWTa5ghFNGekaKG6Si34/dD2PAsnQ2
	 ElYWreUZWh0vDS4/LchCfBsvPPHhsXaBTtkoqitmT6fchhKkmAhVr6E3sNBR1ZO3qa
	 gpFCCW5zUbwK45s0EHFAqfSLa1dJDuWCKICyX1nTzui6B+p3+5ZLEHEKvvzmnP+ilj
	 4ipagYFFHe36A==
Date: Thu, 6 Aug 2026 08:38:34 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, syzkaller-bugs@googlegroups.com,
 dskr99@gmail.com, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
 syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] ipvlan: keep lower device alive until private
 destruction
Message-ID: <20260806083834.28db4cde@kernel.org>
In-Reply-To: <20260803121140.261329-1-krystianmkaniewski@gmail.com>
References: <20260803121140.261329-1-krystianmkaniewski@gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  3 Aug 2026 14:11:39 +0200 Krystian Kaniewski wrote:
> Specifically, RXE acts as an asynchronous owner in this scenario. RXE
> queues RDMA device removal on NETDEV_UNREGISTER, meaning it can retain a
> reference to the ipvlan netdev after ndo_uninit has completed.

The netdev reference only guarantees that struct net_device does not 
go away. Caller must check that the device is still alive if it is
trying to operate on it without a guarantee that it's still live.
