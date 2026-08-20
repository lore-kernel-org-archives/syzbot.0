Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3AF2D8DB5
	for <syzbot@lists.linux.dev>; Thu, 20 Aug 2026 07:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787211224; cv=pass; b=oowmR+tuy8wUn/qSwZff28x0kBYBGIshpcQC8/fwnGKdcmneHibzih22aZyDlv/V10868/huNOW60hmu3OmhmmV93oh0HcL5tbWf7HZEC59Wk9gYjjAVgHLts7aCCqjBEEaRJaKDNiL9Az8r1SLlLrEm+PnV4eVGwTGcWEkhYLw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787211224; c=relaxed/simple;
	bh=3aLoH0UPWOX6g/DIpcdu/D0RGZvtQwzAWXKiQnAjO+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZdem5Hf8pAhEeqGaxI/tvB3Ca/TI6kwf8bqzhssBnawWSzDC2tFpFl6mDhfSsuTcajYk+/ij003q3du8P8piaTHX71Uc5xqf4wAnYLx5RawYhCNK/TjJW1d15uFjRwplaA+dlu4dqGDIzr7uYjb06llEfBIAV0dNz5zhNpFXqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WULNicnc; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WULNicnc"
Received: by smtp.kernel.org (Postfix)
	id 08B801F00A3A; Thu, 20 Aug 2026 07:33:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1787211222;
	b=mrReVglfhlXXoEwjlGR6sOw58PLVP+zo4469Z6dPZFT6VygPwDlUHQQ3js9+XVSgILiQ
	 oC5FWVQF70j/akNSBrkeRxAySEAHY1N32Pg+Y0g+x56CCtecMVpzEBkgSvYAHHk4djgpA
	 TBEyaQpW0ox7F8xqaCSeekhinxTl9Y46wacxF7lD9DqjVU8gTHn3NnM1TCuVlcfX8lw+j
	 dvxFT/6L3/1ygmVvoerhdAbFRN3CjZOGv3psvhsElye1LowyW9agNDcm5FCE6HI9+gxoF
	 SSUv09wGsf6U2djqCqhrbDedQFoNlA29So+aZbwU+Hg1g71zcBTj7JpQDo7IdKpaClw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787211222;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=wJRBXH5HBdzU1+TJJ8HukY/EDbkthd34sEpJxZXTzPU=;
	b=Q5VeLd3WnddWJwRw2/0CnJxZK/De1Tq/6CaZfZR9P7vW8ctyj5Oipx+k4SUVcEX0IMhe
	 9yoniqh/1nqWZxdUtYBB0vdGMnfyLmm+pDlrlCPBvpoI1EnonguZcKiQbmHSbSEvhbQXT
	 BjpFH9jSh/buLb0VA1MKPPtavHzecsjXxTOjZ/4v2KP9Hgz7QiPAgrg4qNMtTJeKOBJq8
	 j/plua2tod/tsGOl9ptllOR2z6x9rDXxOKONhqYvpBm8bmsm+EkVgBnkQWauWV8RnNV+K
	 rc+vBHQYMuED2tq3IW/buCcbt5lHhtmOHwDIqmu1klvaohI6td1+iaiDo4VYglufKLw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=WULNicnc;
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 787E51F000E9;
	Thu, 20 Aug 2026 07:33:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=WULNicnc
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 787E51F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wJRBXH5HBdzU1+TJJ8HukY/EDbkthd34sEpJxZXTzPU=; b=WULNicnc/HsstdCLsTGm7d2EBu
	Gum2bWIBPrdeX7QTwMfauTyyGI9L/0aY5G+73geE8SPxGqMqvhzQ+QLy0GpfYBTCKsYYfqlgpcRTG
	YXFKhnPyUuMaLda404B+Rg8eJTPuEp3LlHe6f2xIerJEOqlNYFqO3ykA5Dh7el17GkzhSKj2/FKKy
	YNV6bajhtSUj213an5c76QGb8wlgc7lILfgyUBOl4MN6ou12uOpTUQdv51HOxenMiGR/HvHUlxr+9
	1DlQH9Rq56c9VdyM9eHR+snsVLXSUDeV3+0TPteYkcBr0QN2YbxnjDnCvRBEU0OEfjUkrh/I31Xxu
	sC4eCupA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wwxHO-00000002vDB-0pJo;
	Thu, 20 Aug 2026 07:33:38 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4AB993006FA; Thu, 20 Aug 2026 09:33:37 +0200 (CEST)
Date: Thu, 20 Aug 2026 09:33:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yao Kai <yaokai34@huawei.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, andrealmeid@igalia.com,
	dave@stgolabs.net, dvhart@infradead.org, liuyongqiang13@huawei.com,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] futex: Fix might_sleep() warning in futex_pivot_pending()
Message-ID: <20260820073337.GL1247881@noisy.programming.kicks-ass.net>
References: <515ea00f-a081-4b9a-bcb3-f5517fd4e565@mail.kernel.org>
 <20260814133803.GA687043@noisy.programming.kicks-ass.net>
 <f3ed739d-fa18-43b8-a7d7-c5f1db0e22b0@huawei.com>
 <20260818104658.GE1246887@noisy.programming.kicks-ass.net>
 <681d9e21-d408-4acb-8c51-b8a86d599e0f@huawei.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <681d9e21-d408-4acb-8c51-b8a86d599e0f@huawei.com>

On Tue, Aug 18, 2026 at 08:24:07PM +0800, Yao Kai wrote:

> > +		__wq_head = __var_waitqueue(mm);
> > +		init_wait_var_entry(&__wbq_entry, mm, 0);
> > +		__wbq_entry.wq_entry.func = woken_wake_bit_function;
> > +		add_wait_queue(__wq_head, &__wbq_entry.wq_entry);
> > +
> > +		/*
> > +		 * add_wait_queue()		futex_ref_put()
> > +		 * MB (this)			MB (implied)
> > +		 * futex_pivot_pending()	wake_up_var()
> > +		 *                                waitqueue_active()
> > +		 *
> > +		 * Notably, it must not be possible to see
> > +		 * !futex_pivot_pending() && !waitqueue_active().
> > +		 */
> > +		smp_mb__after_spinlock();
> 
> I still think we should use smp_mb() here, smp_mb__after_spinlock() only
> orders accesses preceding the lock acquisition against later accesses. The
> waitqueue insertion happens after that acquisition, so I don't think
> smp_mb__after_spinlock() covers it here.

I can definitely make it smp_mb() just to make you feel better, this is
not a fast path. But the smp_mb__after_spinlock() is sufficient in this
case.

Specifically, the situation is

	LOCK(&waitq->lock)
	[STORE] list_add()
	UNLOCK(&waitq->lock)

	smp_mb__after_spinlock()

	LOCK(&mmph->lock)
 	[LOAD] refcount
	UNLOCK(&mmph->lock)

That means the STORE and LOAD are separated by UNLOCK+LOCK, and on every
architecture *EXCEPT* PPC that implies smp_mb(). On PPC we need the
extra smp_mb() to 'upgrade' the LWSYNC to SYNC.

Specifically, on TSO (x86,s390,sparc64) the atomic op in LOCK implies a
full barrier, on ARM64 RELEASE+ACQUIRE is RCsc, etc.

There is a section on LOCKING in
tools/memory-model/Documentation/explanation.txt on this very subject.

> > +
> > +		while (!futex_pivot_pending(mm) &&
> > +		       wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
> > +				  MAX_SCHEDULE_TIMEOUT))
> > +			/* empty */;
> 
> Since MAX_SCHEDULE_TIMEOUT never returns zero, so I think this can be:
> 
> 		while (!futex_pivot_pending(mm))
> 		       wait_woken(&__wbq_entry.wq_entry, TASK_UNINTERRUPTIBLE,
> 				  MAX_SCHEDULE_TIMEOUT));

Well, you missed the '&&', but that is exactly what I wrote, no?

I just put the ';' behind a comment, to indicate it was an empty loop on
purpose. Some people (and static checkers/linters/etc.) get
upset/confused if there is no body on a loop construct.

Anyway, I've tested all this, selftests/futex trips this WARN without,
and runs to completion with this patch, so it must be perfect.

Let me go write a Changelog.
