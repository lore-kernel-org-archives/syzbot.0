Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517543D8137;
	Thu, 21 May 2026 13:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369431; cv=none; b=J2qh+yFkBrEr2Zu7zcEO7sy8ZfvEEX9luXjD9S92D7wg9VrI46oamV0ZTRUwOA/y0vwtY+s/qIAeU0h6Yw8YzOJc+chY7/fs8Qpu60C+xljV/N4xMr5p7BXc082Y+3b8CeRd/11kFQFuSMgFiCPC5CJDdHR+bRmLXRkd1RRRySw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369431; c=relaxed/simple;
	bh=2Bp5FinDWdHEiuBtoHEza6NtgUKF52tTxINQTnHTO38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HS1bmkeagpLT9eOI+kIH7titqrVH4uMQf37V9rokNGYZdKTqhN6NCyt/tdTFzPEbcae4jR5/e3YlDwNEZKRBHjy7FFdgMVJMdzgpYzY4lgnhefsyEwF9c3YJt90p1dS+ov/W9NX3lYLfw6oFS5pEZGBACDxzxkcLhyrGjTayUxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbQHKLOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbQHKLOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDC71F000E9;
	Thu, 21 May 2026 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779369430;
	bh=ds3P5Wpksb1Ia/3Z7aSpgz0FzyoMHN3hjiuAQ7jkmlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WbQHKLOECPl+fhlm3JC3WfF6bbWr4bLiV44Jd+PUIHoIJnTNF1icb23IHmn20ZK6+
	 ohKNdbmNVFzkL1GWPGiEv0U2nhP+VJGXfKE9Nep2ybeIaDan0sa0DzqS1pMvKY4nnv
	 LQ8OJ0JGk4tKRz4BlT01mZoswnGuRLknb37/sSfdaEnfyRIZv53COajN8rrHC4Eq6L
	 cckphZVg+e3CwgZhYcGpeMsN4MpXrHjoLpL1lCvrgkQs2gNUOocodetbz412uH3zoj
	 2PA9Gip2/KNdtge1otCk0Naw8IK7+BKRkIJXZIE6xOLbcuhIWutwcY1pLtt7XGl5gx
	 7LwcT55g/VfkA==
Date: Thu, 21 May 2026 15:17:03 +0200
From: Christian Brauner <brauner@kernel.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org, syzbot <syzbot@kernel.org>, 
	adrianhuang0701@gmail.com, akpm@linux-foundation.org, kexinsun@smail.nju.edu.cn, 
	oleg@redhat.com, peterz@infradead.org, syzbot@lists.linux.dev, tglx@kernel.org, 
	Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>
Subject: Re: [PATCH] signal: clear JOBCTL_PENDING_MASK for caller in
 zap_other_threads()
Message-ID: <20260521-wehrlos-beeilen-f02efdff924d@brauner>
References: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
 <20260521-kultur-zahnpasta-f09198836179@brauner>
 <CANp29Y5Cjy6k2vLp2+2O9FXwRXAmNP_ja6seORVXVQnrdUwH3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
> 
> In a discussion under another patch by syzbot [1], Greg noted that
> syzbot cannot be listed as the author. The official documentation [2]
> isn't very specific about how to handle this exact scenario.
> 
> Once we know what changes are needed, we'd be happy to submit a v2
> that fully adheres to the rules.
> 
> [1] https://lore.kernel.org/all/2026052107-recast-opt-946d@gregkh/
> [2] https://docs.kernel.org/process/coding-assistants.html

Submit under your name just like you would with a
coccinelle/sed/grep/script generated thing?
