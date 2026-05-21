Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154B42D8364
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779373073; cv=none; b=FtyJfyapnV72kSikKWoK/5PiynZASmo06DD1mHs6MLzA6xvhfhw1N7GOm0tLur8uqDTLm9WOe+lMIBYMNIB8ywHu7PdcQNmHBJ74PSCjaUCZYt57QYjJQoeovqhJoHc9SptGctBo7D79hoZlLVvwK4GTy+bIgKzKhWegWBig64M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779373073; c=relaxed/simple;
	bh=NNXVDtwxsYm9U+tbl8jVd8x/44J6uM2S8mfFGGKU2bI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3nBwHxRoQrjAQcW7twSuzeYK0xsYfUjgLbBQjMr9IfJJQIEC58jHk9iWuMP87S+WYj33mR/Kn3OrXHcs2Sk0YZPIImmeq0ZXTRO5cAj5TSW+5UgvOXmHi4O41zGV0YAfEseb+JXgnE8fGDMnhTi8OjFX4ZPpn8Ve2ERwu2Tkdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqS6a+VH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqS6a+VH"
Received: by smtp.kernel.org (Postfix)
	id BA3DD1F00A3D; Thu, 21 May 2026 14:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340431F00A3B;
	Thu, 21 May 2026 14:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779373071;
	bh=+EtFenkMTgQC8+vFFjbeZru/rGiawtsCwIbjn0IS//s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iqS6a+VHxQu2jTbO27TJvqVo/f61p4XDydVKmkDwzu4/SNmMiymdoquFq2gnnt/XA
	 Cf/LqQyPv91aJCQ1+sWhOhYPJC5I/wsQfJ4LAF8fKqeNeWbLhyf/6WaVyMbA1DMSsW
	 bN09evsxumOM7UELe7AY4ZdxV0zykGY5VPwkEOU8=
Date: Thu, 21 May 2026 16:17:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Christian Brauner <brauner@kernel.org>, syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org, syzbot <syzbot@kernel.org>,
	adrianhuang0701@gmail.com, akpm@linux-foundation.org,
	kexinsun@smail.nju.edu.cn, oleg@redhat.com, peterz@infradead.org,
	syzbot@lists.linux.dev, tglx@kernel.org,
	Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>
Subject: Re: [PATCH] signal: clear JOBCTL_PENDING_MASK for caller in
 zap_other_threads()
Message-ID: <2026052159-conductor-suffice-4c81@gregkh>
References: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
 <20260521-kultur-zahnpasta-f09198836179@brauner>
 <CANp29Y5Cjy6k2vLp2+2O9FXwRXAmNP_ja6seORVXVQnrdUwH3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANp29Y5Cjy6k2vLp2+2O9FXwRXAmNP_ja6seORVXVQnrdUwH3g@mail.gmail.com>

On Thu, May 21, 2026 at 03:03:35PM +0200, Aleksandr Nogikh wrote:
> (+Greg)
> 
> Hi Christian and Oleg,
> 
> Thanks for reviewing and accepting the patch!
> 
> However, it seems that we first need to clarify how these types of
> patches should be submitted to ensure we don't violate the Linux
> kernel rules regarding AI-assisted contributions.

The documentation is very clear on this, what is missing?

> In a discussion under another patch by syzbot [1], Greg noted that
> syzbot cannot be listed as the author. The official documentation [2]
> isn't very specific about how to handle this exact scenario.

A "tool" can not sign off on a patch.  That's always been the case, a
person has to take ownership and responsibility for it from a legal and
technical point of view.  Again, nothing new here, been this way for a
very long time.

thanks,

greg k-h
