Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EE030C160;
	Thu, 20 Aug 2026 07:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787211330; cv=none; b=uxuh3Sf7JPePW11znI58pXEtlMxvrVX5lRZNY20fuZeIhFywds2aQ+/Wwbee1Ka0/1iKmJA2qgoK69hitledUFGJTWG8nIV6LmjNp/n2yGbnwB4Lrrrdk6e6ekw83oMo/IuJO5M3VBqTPl2ZjNCeKJKsw2Mf6Etvtm7dBrDQUzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787211330; c=relaxed/simple;
	bh=cmbJUxUgGvebnABcU46nCXusu0u7thztcjxbPiPbKqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mjseB/DvAdqX+fSsG7whFtkcoh78U2svJqc6ON1KqJ497ayead//lOQ/WSr25g2B3MpVPvPr4VclY/tnj1S0ZgghlMxgFHKmTVQDJpin955olbh5gKAQLMDaHrwMox8RngDImhd7t6awLaDRkRezlnaiJ+LRxW/l6Ycxd0cVRuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hy7l0Klo; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hy7l0Klo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zFXyWZbjVNYC4PvQESwo0eEoVZSmnyq3B3+TmmX5Yf4=; b=hy7l0Klo2dx55gx9+tpjv+NJz+
	kCxa2YYuUXR+XtbrIWnCFNxDv9OOC5gHcisrONVbs1WX14geJo4SvM0FPAWTRzmZ/0lBB024ExnXh
	6zq0KkgYRaq6GYOnwN2lFRTNg/oT6LGyrMaB+JFWp4m9ehRprymdqmvt0jl/QjoNGFgPHhL6imaoo
	PeWZiocd8aIW9u//PA2T0Dpfq/BHo6u8zti+2/yrXvqsVIz0MU4iy/lZnHP7V9N1idnjdiOOiBhoV
	cBWq/UGBbhpxHdhMfQKdcToRRVxIvKhRKpQgHUgdJnGuEzco8CrRgsSWJO8a+7K3tpJPHyOiofzZB
	VVM0ee3A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwxJ1-0000000F6k3-44fG;
	Thu, 20 Aug 2026 07:35:20 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 07A7A3006FA; Thu, 20 Aug 2026 09:35:19 +0200 (CEST)
Date: Thu, 20 Aug 2026 09:35:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yao Kai <yaokai34@huawei.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, andrealmeid@igalia.com,
	dave@stgolabs.net, dvhart@infradead.org, liuyongqiang13@huawei.com,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] futex: Fix might_sleep() warning in futex_pivot_pending()
Message-ID: <20260820073518.GM1247881@noisy.programming.kicks-ass.net>
References: <515ea00f-a081-4b9a-bcb3-f5517fd4e565@mail.kernel.org>
 <20260814133803.GA687043@noisy.programming.kicks-ass.net>
 <f3ed739d-fa18-43b8-a7d7-c5f1db0e22b0@huawei.com>
 <20260818104658.GE1246887@noisy.programming.kicks-ass.net>
 <681d9e21-d408-4acb-8c51-b8a86d599e0f@huawei.com>
 <2247c7e0-1466-4228-900c-c5b0677fba41@huawei.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2247c7e0-1466-4228-900c-c5b0677fba41@huawei.com>

On Thu, Aug 20, 2026 at 03:32:17PM +0800, Yao Kai wrote:

> > I still think we should use smp_mb() here, smp_mb__after_spinlock() only
> > orders accesses preceding the lock acquisition against later accesses. The
> > waitqueue insertion happens after that acquisition, so I don't think
> > smp_mb__after_spinlock() covers it here.
> > 
> 
> On further thought, please disregard my previous objection to
> smp_mb__after_spinlock().
> 
> I was considering the documented semantics of
> smp_mb__after_spinlock() in isolation and overlooked that the full
> waiter-side sequence also includes the subsequent mutex acquisition in
> futex_pivot_pending():
> 
>         STORE waitqueue entry
>         UNLOCK wq_head->lock
>         smp_mb__after_spinlock()
>         LOCK mmph->lock
>         LOAD refcount
> 
> On architectures where the UNLOCK+LOCK sequence needs strengthening,
> smp_mb__after_spinlock() provides the required full barrier. On
> architectures where it is a no-op, the lock acquisition is already
> strong enough to provide the required ordering.
> 
> So your version looks sufficient. Sorry for the noise.

No problem.
