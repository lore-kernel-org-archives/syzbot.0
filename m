Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F44244C653
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 18:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786990465; cv=none; b=Gd9iXRUUmgGf1O3sPGOLC3GwYYJOpSFwYVdZnLQ6L/bpA5Ptx8UKIm5h2K17qn+JRPMkmmM/kla9P69Df72Im/HhHJmzDMXNPQ/DSV4lM4V+kNPP4EWbA4bHQ9JlLOkgQkaLEheL1t9golnEaC3FZ5OgrZhRHx4kZt9Fj2+jVk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786990465; c=relaxed/simple;
	bh=ao9m2sLvbtNitvCpUq+Gv1OifNM6AgmqBnJ0gntYEVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbN13dwTExW0SwMhCDUo2ZERm/0uEsD6PFR3GvgSyQG67cCz+FUhTvg9qXBDSnxW9iUhJ49Uq26vpLZgeL9aAiPvtmgNb0li7RLb5zUcYXXrmSfP3Ae1FrItjylJcZYl9AS6KLaHmfk+ZoSg7nEEV2XpvRDJw10cwpwSV/ey9EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu; spf=fail smtp.mailfrom=g.harvard.edu; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=l5U8sK7U; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="l5U8sK7U"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-52b6543169fso24738881cf.2
        for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 11:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1786990461; x=1787595261; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AhYnEHSrQOfQP14QlDp7s2GCgdzZ6d9RZ1i39j+Wq9Y=;
        b=l5U8sK7UynRGlHXSFp76U7raAZWLhJPv09ZuYccQyVqDFlUxM0l7ycDa3HTFXzRcIm
         wLTBX/lwQ/Xw6U9f6eCj8Cq8qRvWbrtrzBoTuO9f3wG6hjfiBkfT9cIKAxkEnwy06b2K
         ncrEoB2YviCT8zHnw23sWxHXaBXGnYE4VKcKIITMddHvLMIZ4pxq5wCglDlLNDBsgWk0
         P33z2PAEOzk22M9MPilHjnDu03WwNbKlU55USHQCNsbnRfvM2qXrWPH7PnGdnVdRunDv
         wiBnqYM9mjx1QdeVC6VlrK0VBhTSlsqP8mvI8Xv0jzm2wDvKUf0yzAeCm8pxAJLowaax
         GpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786990461; x=1787595261;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AhYnEHSrQOfQP14QlDp7s2GCgdzZ6d9RZ1i39j+Wq9Y=;
        b=U3G7fqzoAXR/9leaDHBN4jqNgdSLopJLXhNBjhUGUGuCAxcDQMuBPhKcexOrg3cvhg
         I95YrlOebcoVQsIQMD5XsU9XJyGv6OtJ310pDvTzR09aN5TQeO5vg/gwAtD+q8gghSS2
         Tl7Cnq4I4t/PSLb/Bq0LT1NqnH8wYG3VBxINQUVuMTC+EkI4ZhhqBT0XLduvE8lFYotD
         fHzQNoFPSGozLMU5Lcqah5S5JwsuKRsCPPWwih8ZxML7HUSDI1B6lWG+UgrZfIqIpMcF
         jcAh4msDMh3GTUeydsndyIV9C1wr9wiitVhqLmf5jhYj6/RM/2QWWrs91b0pPyaTeYAk
         XUew==
X-Forwarded-Encrypted: i=1; AHgh+RqhSomcCyKlHyQESEGZltuL8BHaOOrkfwflScSlBi/Xfnu+UhKea4KLCi5MOTtufPkqS6NhP4k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxumgHFyAZ/9CJL1IBmP+jkxy8JpQG227pGVJyryKDRUNK3Jb2G
	RT2qrnYSJDSk+ECQsrGOqAg5yeo2CE22mApmmABJpKgM4jkJHDrMhBnZL2x1zAgIjw==
X-Gm-Gg: AR+sD10CqpVeIVDQmHCN8lkGoGnIwT+jjkZnx7c82rC4GO625oyLzLvDzBvJjt65On9
	R3VBJ6CorikL67oA4VxAyybCukqZyZcgUz/b79th9IrNWgScG2y2ja9jhDNcOCqIcrpA8Vp1+k4
	cMzGhcKMoFfnCrM3WuH36h3OmgEOXOkbvksaJpvW0Wg/b7Y+0I3hDLU/mZcPK9cbfhbVPylj8ex
	tgNcK3NUsiwkYDJdSHm9rUty4nx3xVjaukwnBIn+A8ramDlsIcrXn44IfNe6Dx6NvJJK8QbCkQH
	aWDeUl2HM2x5+HityrCO9+VMOc6dKPT5N4V0lpeUM4V0OY7JsNx68FQNFWPjIJwrcjFQI2g6bdU
	rF+6jkvgvSjPMIVwzUSidRLXcg02AOHJc2vcBsH0M9i//UFGahJG2UH0BgeE8NTK5wpORaO5WKl
	vzmKmfjguQYBuE6CKJUpO4Y4ReWjki39ah2nnM4Ej163PQv/UovDmIsGpn6VkhwTKyw5BxCyGuR
	A+gjJWKmxkcggSd2D1wt6fpukCVDvIyWcNpgRjo4HE=
X-Received: by 2002:a05:622a:2445:b0:528:3d62:16c8 with SMTP id d75a77b69052e-52d854a46f0mr317463501cf.31.1786990460710;
        Mon, 17 Aug 2026 11:14:20 -0700 (PDT)
Received: from rowland.harvard.edu ([2607:fb60:1011:2006:2008:aeb7:73d7:d8ff])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c4580f7ebsm14450746d6.5.2026.08.17.11.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 11:14:19 -0700 (PDT)
Date: Mon, 17 Aug 2026 14:14:17 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: syzbot <syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com>,
	asml.silence@gmail.com, axboe@kernel.dk, brauner@kernel.org,
	io-uring@vger.kernel.org, jack@suse.cz, kartikey406@gmail.com,
	kees@kernel.org, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, mjguzik@gmail.com, nogikh@google.com,
	syzbot@kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	syzkaller-upstream-moderation@googlegroups.com,
	torvalds@ppc970.osdl.org, viro@zeniv.linux.org.uk
Subject: Re: [syzbot] [usb?] KASAN: slab-use-after-free Read in ep_open
Message-ID: <16741050-a3e2-4193-bfca-232a615a1311@rowland.harvard.edu>
References: <34e65096-8827-470c-9a88-8c643cccef22@rowland.harvard.edu>
 <6a8338ea.dbb3a75c.20434b.006a.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a8338ea.dbb3a75c.20434b.006a.GAE@google.com>

On Mon, Aug 17, 2026 at 09:38:02AM -0700, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> 
> Reported-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
> Tested-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
> 
> Tested on:
> 
> commit:         8d3ae592 Linux 7.2
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ v7.2
> console output: https://syzkaller.appspot.com/x/log.txt?x=16a91a25580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
> dashboard link: https://syzkaller.appspot.com/bug?extid=df9e891bf8ea586f846b
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=15790679580000
> 
> Note: testing is done by a robot and is best-effort only.

Greg:

Has this patch ever been queued?

https://lore.kernel.org/linux-usb/ee41fbfd-f368-4a06-95d6-ae9b4267fd82@mail.kernel.org/

Looks like you can add syzbot's Tested-by: tag, as well as my Acked-by:.

Note that a different patch to fix the same problem was submitted here:

https://lore.kernel.org/linux-usb/20260731230603.4637-1-kartikey406@gmail.com/

IMO the first patch above is superior.

Alan Stern
