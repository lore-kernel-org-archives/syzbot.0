Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A252D34BA5B
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 23:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786145920; cv=none; b=QzpfTx0Syh5l0ORRnSd1RK6UbqfG3SHnXqR7Qi7F9Js0aqKLpKIZKC2atnnaf5fJsBSJ6ZS/uh2QhpNXQDkNMqeFadg7+UMOHnYGnvyFax3fDX0DFmIhN55ebIBx7Pohi323ENHHkQgcwMQn78KHeskn9eoxQf6Isq0mhxKDBdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786145920; c=relaxed/simple;
	bh=/eCNesmnjXg2DZ9eQuZJzfeaYwYhKGrPR0IljtrpqhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qv0LkPfxcY9zUVfcFo0lmNs/rxkVDtpLmuaXkn7kuELGT0CfELpANx7vrO4AHMeQ5lV6D6aTJLpXI/E/idflOJihyfcnvDxtZrIkFWZjRx9DvB6v7UCXak+m4jRzBw9peXrvzxTA/EkO0JOuvrTShCqMh0LloGWJ25po11kl+4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sakamocchi.jp; spf=pass smtp.mailfrom=sakamocchi.jp; dkim=pass (2048-bit key) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.b=h4oSArwV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Kf99lEvu; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sakamocchi.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sakamocchi.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.b="h4oSArwV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Kf99lEvu"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id C1C541D00138;
	Fri,  7 Aug 2026 19:38:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 07 Aug 2026 19:38:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1786145917; x=
	1786232317; bh=wFGxNR4KDQgZaxbDqlfhZF1nqBzVWqT1kkp5gL+l2Vk=; b=h
	4oSArwVdKPrKkQQJFcrnWfEs9xSTRxs5YrkQlI3SSEa4T+WPR12qBTAP9Qzr1ja4
	rtUNy71m6O03Nzw+4cbEpUZtvb/YFifdEuq2EievBbwuD41rLk2nTFUSsHYZxhWF
	8CvkPBEfdpoCRxvNHp3vuPeDeqZiOT4pdai6mcYyBxc8QuKcy2dIiXXl6g3oEWOb
	Gf4nEKONFYIIIUZjtcqSK67eY1Zjo5MxbHa17b6Z+j9FqVk+RYSuXIDzZIldgU2O
	/puEaeSN2NPjbcunvaCnn5796nISa9rPA9ngLfNaQHN/An0nXQC+FzaN0SHqSqfG
	jO7y8Vxyrq8SJk5m2q1bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786145917; x=1786232317; bh=wFGxNR4KDQgZaxbDqlfhZF1nqBzVWqT1kkp
	5gL+l2Vk=; b=Kf99lEvuaEV3hzlCnyGhq1tbk758IAVpDGEm/3ZYvDBOnd+T132
	ZieENnOMxatka5NXD85di9NwqS9e4CeXMVQqQba1hWHFbBCuC4QDxY13EhxqPSQU
	rst/2LroGN4v6Qb1+1iL+LVwfuVRNqg9ty8u9yxYKXkWtCo3HTpUk2jDqRy9Iv80
	UmOtvKNR6GS5lvJd2Qp1V3vzbMADzzcwAMadsArs6dnrX/+pKy2+esqpsoCxQ4Lo
	De1A/rOk0/2atBG270GylvC1+FvvFtEB0U48ayHweaxRs29+mveqV7vYoq1KOFts
	I0AOzqk4vxTNVieZRp+fq0nDTjkcy8IT35Q==
X-ME-Sender: <xms:fWx2arRvAW-XdUeEGe-3Pvwry9FiouY8smB-JPlbokDJqtrY0koesg>
    <xme:fWx2antmGC_OtjksCaaJdXLhkfqJccQH6DumowiDtJ-HQwDywDgI4QxtEQM4LXOMh
    hIwoVBo5GCxVFwsWjE2xxUdCKZ5qfhhKtGmPxbL7u9ZcHXXdpSJB6M>
X-ME-Received: <xmr:fWx2av2a4iotoVEVZFnyA9E5VDGMhbIxaficpFR_iukY2-cdKe7z1SrNapBoijgNHBon9TsfaeDVF4zgepvhZZRHWcFOdQ>
X-ME-Proxy-Cause: dmFkZTFOpMpQ1XXxnxE8r51UoC0v4JSMyMSVCJ+8AlXIBqzvZDgt1a2sCct5jSdipfZaTk
    42zYezUMuyD4aG5f+4q83D3/NQlKUR5CnY+e50An4iiF/0PIZIZ4ZtH5ulMPFVFOWd3W0u
    6kuFZt8Fd8CM6O7ekp+bkkvwu7bPdSTziM4fydTNdIrjuw0TEY5oR0Z6qMQ3cYUMZc4xRy
    9hcvGqRPf3cFarjBwM5kRQRrQtMVG8M3LIfsY6yS3PECjkk+yC4cKr85IiMxsvV0UArzmW
    RODEokSqkH9WYQwtd7ybF/6rHul+Z8qNq6IcaEuGmfZzrd9/Tf02PwWa7DTIphvXBZuMra
    TZ69330QcOxPPVlCuPWM9yVOs10sSopmED+HJt66QbA9AjPFQ6mYOv19Z0drHe1qdyE7IF
    J0f1dDBER9EOr0tokMmsT+Rw+z30MoVl99gs8wZxgbrF0/bYyluv+Dsmvw0KIlRJJw96S2
    jlq7u1ugKcIJl+IxMKzfNSK1S10R9Cl/uaW4RJ9krDpmiOzbS6efNemXIwaf7LotC2JyI5
    sOUaAh6PBHqSwZyzSaYSa1B3EJrOtoGJce/KKst0/Mt6t5b35yXB2R2P4cNvyovO9bSieo
    n7ejP7eRkEmaXTwoMJWfvMpKvZoGgPgfRCihya21cNDhrj7XQbhQ/DtCAVVw
X-ME-Proxy: <xmx:fWx2agVQxR8xdmCICMj_T2vnYeg0yEA--6vqlYpBwExkqKBLRcJdGQ>
    <xmx:fWx2aiJsx9J0fAgXTg3uU1fw0gWxj7IhtKd96x662oT2-vIjfLOC7Q>
    <xmx:fWx2aq0EF6T3tiPGtB6VgjJYXMUTJ_SfmiGAfi5tbmm0enjRLRPByg>
    <xmx:fWx2ag5AMSk85HnNiUGxxBVJY4rEFJSYjGr2t-WAL_NFKJuIlsYxww>
    <xmx:fWx2avROfc0AUFHTSJrIjsU2SO2OgN2jxi7H5MkhDg5WEP3LUyoCkRkL>
Feedback-ID: ie8e14432:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 19:38:35 -0400 (EDT)
Date: Sat, 8 Aug 2026 08:38:33 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] firewire: ohci: fix NULL pointer dereference in
 ar_context_release
Message-ID: <20260807233833.GA479199@sakamocchi.jp>
Mail-Followup-To: syzbot <syzbot@kernel.org>,
	syzkaller-bugs@googlegroups.com,
	Aleksandr Nogikh <nogikh@google.com>,
	linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
References: <90c5db71-dd1f-4d46-b9d3-2f1046cbd5ea@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90c5db71-dd1f-4d46-b9d3-2f1046cbd5ea@mail.kernel.org>

Hi,

On Fri, Aug 07, 2026 at 02:25:26PM +0000, syzbot wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> During the error handling path of the driver's probe function, a NULL
> pointer dereference can occur in ar_context_release().
> 
> When pci_probe() fails early (e.g., if pcim_enable_device() or MMIO mapping
> fails), the devres cleanup mechanism invokes release_ohci(). This function
> unconditionally calls ar_context_release() to clean up the asynchronous
> receive contexts. However, if ar_context_init() was not yet called,
> ctx->ohci remains NULL (as the fw_ohci structure is zero-initialized by
> devres_alloc()).
> 
> ar_context_release() immediately dereferences ctx->ohci to get the dev
> pointer before checking if the context was actually initialized, leading to
> a crash:
> 
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> RIP: 0010:ar_context_release+0x3f/0x380 drivers/firewire/ohci.c:543
> Call Trace:
>  release_ohci+0x3f/0x60 drivers/firewire/ohci.c:3567
>  release_nodes drivers/base/devres.c:546 [inline]
>  devres_release_all+0x1a8/0x260 drivers/base/devres.c:576
>  device_unbind_cleanup drivers/base/dd.c:597 [inline]
>  really_probe+0x451/0xae0 drivers/base/dd.c:772
> 
> To fix this, move the assignment of the dev pointer after the !ctx->buffer
> check. If ctx->buffer is NULL, it indicates that the context was never
> successfully initialized and there is nothing to release, safely avoiding
> the dereference of the uninitialized ctx->ohci pointer.
> 
> Fixes: 5716e58aecdd ("firewire: ohci: release buffer for AR req/resp contexts when managed resource is released")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+d30aad27833a559defab@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d30aad27833a559defab
> Link: https://syzkaller.appspot.com/ai_job?id=10a18617-7893-42dd-bf1c-cd49e19e95d9
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

Applied to for-linus branch.


Thanks

Takashi Sakamoto
