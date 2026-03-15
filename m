Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91C325A655;
	Sun, 15 Mar 2026 17:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773594170; cv=none; b=d/eVlz1o4wQbe9LaUVNC/KgX2eMNiw70AGFnNPOmo/J7vLCwEz19yb8ZN/S9piBPY0sc56hI0xoqQSdx0cyKzCSXcSPAVxGZRaxOLRrMIRrCfhN1+Kj39PEJogqEYa0GUi1duQFJvHhGuwcCVu4dhHqkHajfxU1iSToux+PZDmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773594170; c=relaxed/simple;
	bh=zy2/z1sXTGswAXzUUoF4kMirR7eYtWRiusezRTgh5s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g1sudbhwf7tQ2iBV4a1+Aauoo5k7dpAiz5WlO4s1yy/4EAAi3xvrpujY25ITsAp4Mp0jtfbR2IUNpaYp8EuYCUweepxorQB7okgZzSForY7NC45eGKDGovzE7kjyPyjdKZ3C/XirFMgy1pNTnZ/z7RWG6mCbiW2GgBDIxUHHCXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0+gkML2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0+gkML2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CA3C4CEF7;
	Sun, 15 Mar 2026 17:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773594170;
	bh=zy2/z1sXTGswAXzUUoF4kMirR7eYtWRiusezRTgh5s4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t0+gkML2+e2/jn6cN+bhDFGyl71Mf4TLa+A9Hizu8tFguiNo8kOnCQ+ThblMFynni
	 4YZbzWigvSOeYm3oDFgm+H9faSPqmNcZfZCsgqlaMuorLTCg/TRBHZkOFbEzOuB0xh
	 5FKBxdaz/Qy2mETzaTMqr9twXgFKV2CHpvnoUqq9VTg8Z69YsGyOjax+WIvXaVfj3S
	 6BjePrMdxtuluW4chV5n6Xg815EpQ7AeONQaRgP3R4YwRax3n+ZyCIuONdEqMl2pKW
	 fP+I399isEdR55o6GGs5jAsqCnai6A5gKDHX6/hnW9jtyYAhF/3mslcIiNwOam1KmF
	 hImyGahvDUnWw==
Date: Sun, 15 Mar 2026 10:02:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: syzbot ci <syzbot+ci46064f472908848f@syzkaller.appspotmail.com>
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, eddyz87@gmail.com, haoluo@google.com,
	john.fastabend@gmail.com, jolsa@kernel.org, kpsingh@kernel.org,
	linux-kernel@vger.kernel.org, martin.lau@linux.dev, sdf@fomichev.me,
	song@kernel.org, yonghong.song@linux.dev, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: bpf: Remove inclusions of crypto/sha1.h
Message-ID: <20260315170247.GA23968@quark>
References: <20260314210810.67348-1-ebiggers@kernel.org>
 <69b69e5e.050a0220.248e02.00f9.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69b69e5e.050a0220.248e02.00f9.GAE@google.com>

On Sun, Mar 15, 2026 at 04:56:14AM -0700, syzbot ci wrote:
> net/ipv6/addrconf.c:3341:25: error: variable has incomplete type 'struct sha1_ctx'
> net/ipv6/addrconf.c:3344:13: error: use of undeclared identifier 'SHA1_BLOCK_SIZE'
> net/ipv6/addrconf.c:3369:2: error: call to undeclared function 'sha1_init'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> net/ipv6/addrconf.c:3378:2: error: call to undeclared function 'sha1_update'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

Thanks.  The BPF CI caught this first, and this was already fixed in v3.

- Eric
