Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8F028B7DB;
	Wed, 12 Nov 2025 07:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762931255; cv=none; b=WNvoq/lhQ3MZcCTD0QnUzghsJoexVvXZ3l5nUJzWa1na4Nl9p0Exotko/jX/26/KuI2+5u824mglOv81A+8k+q+XFUjUIAcSCpdJoGoJOkC/44BatotqcIqZ34hzT7UqOf4E6DHcFeJcEKPJry+KC7BKgV+U4KhymKRhLudLGdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762931255; c=relaxed/simple;
	bh=CyXPBqB/MKq2o3PIoKKlGeJt0SxfrUxp+JeC69yMOmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q693F/UstpYVM0afAhLrH4UB1R7h5lJHfwg/tMCTz/maLLhvnCU7GULQzeOvwrVGPEbFG9DF+SZ3FPb1qOXjzaR8uuhRpy86XJjkxlXr2v+g1JKviY+fUxDw+EnT4bLS0KMP7BXgUWjdnJSHf6UK7K4Gu49AwGDZrPTjO6pQPX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=doEOEIfp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="doEOEIfp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=n5+DZIdYmdMUBYPf9tQoU3zDHSAGhrCH2u+Z/t1MhZo=; b=doEOEIfptDBs3uw6k01V4qPd5y
	7xc4xmrg/SbLNsi5vYU4DCPZWWPSXq7/FsoY9skCInDV84g6MmFDBVbxQ8mtCEZd68ElmMnB0OsRD
	2bjVhF3SCCnvyar5L44YeZgng1WxVtltRo3simsOqrl/4vq/RyhFhjJPR40TmVkwej919EqAnP3d8
	Ynff4ZZWbx81sGEEWzLxp6L8X/htxV8jsF5qQjvVP18hlUg+D3QEFbTGyz4vqrmXPG6GV9VUK+ee8
	sUrbVwk4xkn/pYQ/mnDRPzGJu9nqGd0EN3Xr/87nwoEb85Qkr2BGL4eYXJNoJ3HkPfEuEYXeyt+s3
	+LLKvT+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJ4wz-00000008Fz7-2dPw;
	Wed, 12 Nov 2025 07:07:29 +0000
Date: Tue, 11 Nov 2025 23:07:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: syzbot ci <syzbot+ci9989da8336cb2bc7@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, hch@infradead.org, hch@lst.de,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	vishal.moola@gmail.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRQyMck_MeVvvCdX@infradead.org>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
 <69123b72.a70a0220.22f260.0105.GAE@google.com>
 <aROasppMPmek9Afh@milan>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aROasppMPmek9Afh@milan>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 11, 2025 at 09:21:06PM +0100, Uladzislau Rezki wrote:
> > Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> >
> It looks like we need to add __GFP_HARDWALL to the white-list-mask.

__GFP_HARDWALL is part of GFP_USER.  Doing GFP_USER vmalloc sounds like
a bit of an odd idea to me, but there are a few users mostly in bpf
and drm code (why do these always show up for odd API usage patterns?).

So I guess yes, we'll need to allow it for now, but I'd like to start
a discussion if it really makes much sense.

