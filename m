Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A741F8691
	for <syzbot@lists.linux.dev>; Sat, 28 Mar 2026 17:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774719600; cv=none; b=eQAuO0BL9IupPEyTogCrmdwX8h4LcTybMw2Cpq4iu+jWJGfLuMIpuLK1zGH+WGhbTvxz33+K7mYhv32WjAI8ezkOOl1RJhQBS43MUdsuTjgD4OKdSvOnpAA29nn97H7FDxInaBfm+mGB57MGoXVQTx3+w2jdKcZRLWHEYGKjPXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774719600; c=relaxed/simple;
	bh=CvGqcc593VzG23ikPjsoJXo4HOiKi2mitRDUYqcfKF0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=OI+PzKOWsl3aaPIDs6c0QyLA9ZE77Q8Zu/beDZpy4TjgIih96oEKV1Jouxq+omw1N/dtlQ+lE8SlStxLnkh1jtXUCpx13Ps8VgIf3Hvh6yDkXRAf3Sbsx9J+X9TKTVOOVV//JhqxTB4GCS/PFnwoDw52ZBUu9InI0lshazb9nCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aBEk0qOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aBEk0qOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5FCC4CEF7;
	Sat, 28 Mar 2026 17:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774719599;
	bh=CvGqcc593VzG23ikPjsoJXo4HOiKi2mitRDUYqcfKF0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aBEk0qOUrYIHyyQ7WnA9ixpbUNxja1hUtWp0/OwMhuR25aZbJbVQtLto1DwKSbFZN
	 ABRbuAG809O600Mom8UZ/FdHxBg8pIH6fe0826r2Rhsl+KQRrXGNJo2aR1Mf33c8ic
	 XhLNVmP5GEiJ0nV/w++qVcYYQkpLxXTAO8fDVJZ8=
Date: Sat, 28 Mar 2026 10:39:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot ci <syzbot+ci9dceb132e443f5a7@syzkaller.appspotmail.com>
Cc: linux-mm@kvack.org, ljykernel@163.com, syzbot@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm/page_owner: warn when stack trace depth hits
 PAGE_OWNER_STACK_DEPTH limit
Message-Id: <20260328103959.a4739ffff3c8d7a6f4d60732@linux-foundation.org>
In-Reply-To: <69c80fa8.a70a0220.97f31.0002.GAE@google.com>
References: <20260328214408.2990597-1-ljykernel@163.com>
	<69c80fa8.a70a0220.97f31.0002.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 28 Mar 2026 10:28:08 -0700 syzbot ci <syzbot+ci9dceb132e443f5a7@syzkaller.appspotmail.com> wrote:

> syzbot ci has tested the following series
> 
> [v2] mm/page_owner: warn when stack trace depth hits PAGE_OWNER_STACK_DEPTH limit
> https://lore.kernel.org/all/20260328214408.2990597-1-ljykernel@163.com
> * [PATCH v2] mm/page_owner: warn when stack trace depth hits PAGE_OWNER_STACK_DEPTH limit
> 
> and found the following issue:
> possible deadlock in hrtimer_start_range_ns
> 
> Full report is available here:
> https://ci.syzbot.org/series/aa38ba8f-44db-4d01-8965-ed5a27174f71
> 
> ***
> 
> possible deadlock in hrtimer_start_range_ns

Thanks.  Sashiko reported a couple of things, one of which is a deadlock,
probably the same one:

	https://sashiko.dev/#/patchset/20260328214408.2990597-1-ljykernel@163.com


