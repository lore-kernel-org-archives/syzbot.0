Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FFC3B2D1D
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 08:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788510122; cv=none; b=fdw29zOUsr9xGkg6LhXKh6IEacyrGIs8idurPXcwAt43vfglttGiqOnDbVLpNmVisWriXoL/crmGMhnDhbF1HyIRZ4HH8BgeOoSjJNrXtcA30A2H0d5W1ZWdalSR5aY47iRQkuzaD5kD1B4Tz7YCYdQWUXPbHGd/LZxEIZvdM1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788510122; c=relaxed/simple;
	bh=NOPnmzYQ2FNNWOW/u/n3R8m2vKkoaoqBEYdskMu4U3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0+++Dwy/gORnvm1XBUF1Vs+JcyaeLYtJj3G5z+kBbu7ksMCt2xmkbb3vMSW8GCyUljCXCM44cQ2JIHB5ou3/Fl0tTCR5Ihu5uQ9r2joGbSsdi6heZwglbxpO3v0M0PVizAlOEVsEHdewcn/rk5Lyf6bT9aomNJ8H8VA1aGDIzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjIgCijT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjIgCijT"
Received: by smtp.kernel.org (Postfix)
	id 5B19C1F00A3E; Fri,  4 Sep 2026 08:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079581F00A3D;
	Fri,  4 Sep 2026 08:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788510121;
	bh=ViqxEg2nic21/cC+OdaYhidCKvzIE/91TrHsQDV+MNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OjIgCijTg8xubFCjXgjFEtmB1OQ+cfvyNFkyhkMtj8Y7nIE6k+3q/RspG0eSdf5bs
	 2svaQZbbt+haYCBqjLTdpFHywBlL3Dv1AeDUK1p18/QTS9oyZ4cnvAmfa3nBgsmhQM
	 tD6TyWTRFWOZXPJgDpzltMHLopfSdJDEIj0ME57ePoF44PluyT27F2LO0m3wSN+vTx
	 wWntQnd3eH+IaFBkfmKkYvd1h5gGdIK9gnQOyZ7ZeyPE6KjCBYBxL+XNERadmabR4i
	 RSjSNiRJzetnE1zaqPaJTtGeDy75H3nSCS09VbBvslDUSLXNf+yQesncXhmSVvL+5F
	 ZVxAtzIYZMaVg==
Date: Fri, 4 Sep 2026 11:21:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] xarray: fix index jumping backwards in xas_find()
Message-ID: <app_o87YogZExbwm@kernel.org>
References: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
 <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org>

On Thu, Sep 03, 2026 at 11:22:51AM -0700, Andrew Morton wrote:
> On Thu,  3 Sep 2026 13:48:55 +0000 (UTC) "syzbot" <syzbot@kernel.org> wrote:
> 
> > From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> > 
> > A bug in the XArray iterator xas_find() causes the iterator's index
> > (xas->xa_index) to jump backwards when iterating over a multi-index entry
> > (like a THP) that resides in a non-leaf node and is concurrently split.
> > 
> > When iterating over a multi-index entry in a non-leaf node, xas_load() sets
> > xas->xa_offset to the base offset of the entry, but leaves xas->xa_index at
> > the requested index. When the caller subsequently wants to advance to the
> > next entry, xas_find() is called. xas_find() attempts to synchronize
> > xas->xa_offset with xas->xa_index before advancing. However, the fixup
> > logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
> > Because the THP resides in a non-leaf node, the fixup is skipped.
> > 
> > As a result, xas_find() simply increments xas->xa_offset and recalculates
> > xas->xa_index based on this new offset. This causes xas->xa_index to jump
> > backwards. If the THP was concurrently split, the entry at the new offset
> > is a node pointer, so xas_find() descends into it and returns the folio at
> > the backwards index. The caller (filemap_map_pages()) then calculates the
> > PTE pointer based on this backwards index, resulting in an invalid memory
> > access such as an out-of-bounds read or use-after-free on a page-table page
> > freed via tlb_remove_table_rcu().
> > 
> > To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
> > xas->xa_node). If it does not and the node is a non-leaf node, set
> > xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before advancing.
> > Also add test cases in test_xarray to verify xas_find() behavior when
> > iterating over and splitting multi-index entries.
> 
> Thanks.  But the changelog omits vital information: a description of
> the userspace-visible runtime effects of the bug.
> 
> > Fixes: b803b42823d0 ("xarray: Add XArray iterators")
> > Assisted-by: Gemini:gemini-3.7-flash syzbot
> > Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
> 
> I see from there that it was a use-after-free, detected by KASAN.  I'll
> update the changelog and I'll add cc:stable.
> 
> I'll queue the patch for testing while awaiting review input.

The testing shows there are issues with this patch:

https://github.com/linux-mm/linux-mm/actions/runs/33815757662/job/100847425973

And since it's in mm-unstable now it breaks all CI jobs :(

> > Link: https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61
> 
> 

-- 
Sincerely yours,
Mike.
