Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECA1374185
	for <syzbot@lists.linux.dev>; Thu,  3 Sep 2026 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788459773; cv=none; b=O4bPVzcOjOfOB7pmwgjsO+3tEl9auJxAeZxamc17AitU6FqfEEHXBhdJvvJ8cSYRzfP4EziM0U/oHs747xjj4qu5bjRelHyLFxVDOZt5O3OQO4p9umqW4km4IQRIxJtQJU179OUTBp+ijQ9cnW8jLSd71fhN6JpVAlDR3KqLDuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788459773; c=relaxed/simple;
	bh=if1pQRZYUHU13lF/e3EruiKqRjX34bboC2WAykT2rWY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=W9RUaFdC3Hd8+9SSgP1htkjlKY33r8LgKOHMG3D63POhPURJPCJ2E2OoBqexyBQUV9tUiUktVLLSsuSY9IbeMVdhBD7EwXUL3mEwx2+aOP9Q8Bq9/JS3c1kWNSvu00c9nDGpaOew2nxBjtvAB53XRGiHOemA2tcTc9Fap9SN42s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wPq43bzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wPq43bzI"
Received: by smtp.kernel.org (Postfix)
	id 2B4501F00A3D; Thu,  3 Sep 2026 18:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A1A1F000E9;
	Thu,  3 Sep 2026 18:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788459772;
	bh=BH9198rK799MJYuMQnII0Ud2Ndbo/vSNpauNbEwkaPY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wPq43bzInk5PeSp03yEN+aaBk6/3zIf+7JLmixWEffRb5kBY3W1GcGa93mnUjUzXg
	 Hz16ZsLD6o3bVbGZX4OZUfNz4QCUyhqGdY1anzkvlaOC2h+ggDk3KjZZ3hnvkpn+5y
	 lrk+hARIF5FuzcZ1IukI/fdIPXcztqFvwINX0ybI=
Date: Thu, 3 Sep 2026 11:22:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "syzbot" <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Krystian Kaniewski
 <krystianmkaniewski@gmail.com>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, "Matthew Wilcox" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] xarray: fix index jumping backwards in xas_find()
Message-Id: <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org>
In-Reply-To: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
References: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  3 Sep 2026 13:48:55 +0000 (UTC) "syzbot" <syzbot@kernel.org> wrote:

> From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> A bug in the XArray iterator xas_find() causes the iterator's index
> (xas->xa_index) to jump backwards when iterating over a multi-index entry
> (like a THP) that resides in a non-leaf node and is concurrently split.
> 
> When iterating over a multi-index entry in a non-leaf node, xas_load() sets
> xas->xa_offset to the base offset of the entry, but leaves xas->xa_index at
> the requested index. When the caller subsequently wants to advance to the
> next entry, xas_find() is called. xas_find() attempts to synchronize
> xas->xa_offset with xas->xa_index before advancing. However, the fixup
> logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
> Because the THP resides in a non-leaf node, the fixup is skipped.
> 
> As a result, xas_find() simply increments xas->xa_offset and recalculates
> xas->xa_index based on this new offset. This causes xas->xa_index to jump
> backwards. If the THP was concurrently split, the entry at the new offset
> is a node pointer, so xas_find() descends into it and returns the folio at
> the backwards index. The caller (filemap_map_pages()) then calculates the
> PTE pointer based on this backwards index, resulting in an invalid memory
> access such as an out-of-bounds read or use-after-free on a page-table page
> freed via tlb_remove_table_rcu().
> 
> To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
> xas->xa_node). If it does not and the node is a non-leaf node, set
> xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before advancing.
> Also add test cases in test_xarray to verify xas_find() behavior when
> iterating over and splitting multi-index entries.

Thanks.  But the changelog omits vital information: a description of
the userspace-visible runtime effects of the bug.

> Fixes: b803b42823d0 ("xarray: Add XArray iterators")
> Assisted-by: Gemini:gemini-3.7-flash syzbot
> Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083

I see from there that it was a use-after-free, detected by KASAN.  I'll
update the changelog and I'll add cc:stable.

I'll queue the patch for testing while awaiting review input.

> Link: https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61

