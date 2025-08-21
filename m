Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6242206AF
	for <syzbot@lists.linux.dev>; Thu, 21 Aug 2025 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755770682; cv=none; b=nnGYeDxeGx3FgICjqnIwrwMJjfkrKjV9Mk4wisip+NwdlNxZzxoJz/nD8VNFDKSCf3G5BbQohefaN6i8Riqg6ELNhEmvrldKaP8kExm6YmWCuSAaIOVOmsDy2YFUboyk/T2NV7930jUw3xqD37TWCj6vaVaEhfNRgVKR+2Cm3Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755770682; c=relaxed/simple;
	bh=eHtjpzeBUotBe9iJ5shsBWXjPiisjrMOZofLgwf8DmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrxC9fCiN8JILJPDdwu1AKi9KhzxON3Qb2jXn4mpqn5BcXKdaPmBjBBn4mZQjIq2ghTw9ocwLcW82lGmpqRhY/ypxkyXMoLLMaibEf9pRQM109F0cqfvh5lcmfNeOjqkkSoKIp/oFVEXDcy/QPRm+xYNaw7Nzco29OcbCj2GSNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUNiSjGC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUNiSjGC"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45a1abf5466so5317985e9.0
        for <syzbot@lists.linux.dev>; Thu, 21 Aug 2025 03:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755770679; x=1756375479; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+qSqnNW5BPDmS3JUddq1Dx24H6xetXszPTWmtepLBsE=;
        b=bUNiSjGCXet0v08L1G6VPbrpOWDQ1aL2+7S6nrG3i4EIKeIa7rK8TErpwaqBGQHMQZ
         WU0AaWugHQH1cRm6pR92nZhxiTU0eoMywcjn4RIfCTh9BlKuudurcHfDkawYuYCOLXJD
         0B7FG4+Hmd8M5UPnhPyeMc7pYmQ2MxQYYnNH4YJuFm6NI8a4eXKS/k3GlIVL1i4Y7Mqc
         KN2fx+vMOCmXzyqFbrnkSK2/7IKd33I0vLXn5zwLfV9UFfiGX3M3XTJ2BtdosbZ+Gzzi
         q+JGe+gsaxm2JtOrZO1oJ4UO8zTBHwyA/ZfNfqcjYFWkXYxzjoIIZb+iWdAYxpHwAvAK
         WmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755770679; x=1756375479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qSqnNW5BPDmS3JUddq1Dx24H6xetXszPTWmtepLBsE=;
        b=vdxlBGDh8AIdoahViBDFhPcHnZFt3/XGli9vorlBlU6+VJS7TWIa0LxqNhHtke0koU
         Hd66IKizG5aE5m3D1YD9pCe1/aillkuBhvfGeAsV0Z7ZTsh6rZnFEVzDDygmVfiuX6W6
         DY61C8E1DXP6RreOZZvwuelNL5WdMiIKj9BW3iVUmPdgImlN0FBY0U29LkTTOjkfAPHi
         fDSGo4qByMZzvdLramcg6WpChpQnfWcwF9fFAxRKDBwlGtCqhG7yvmLHVA7/tOd40vhT
         Sd7/7Z7IjJts4B3Z+PJSWlt05+/8IWAnFFWktynqB4x7gR4ofJaBDmomT95wsuKHPrvj
         bGKw==
X-Forwarded-Encrypted: i=1; AJvYcCWQeqAi8dNeqonebafzwtVq0HD2mGlb6nXxt6aF41cXeTYe2/+drjOAylQI3NmeF5MrmuVqnfs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1BUwWfegrDH7YmLsw4HFrDofKrekAemSuZH+MGWbWwZp8NA32
	2t83c3KxX42K9jPNiZKl+yGCEGV4zSVlXbyHdFwXzJX+K7NLlsACuVAC
X-Gm-Gg: ASbGncsXCXh4gTAxSG6dvA9WVH9TX7/IxJvdw+2LK2VUoPxAzUS8ysI6MFysqGelcm+
	44Eq8mCZp1aG+5MZ1l7DSm7/94LqE1oPqnTlVLUmbZ4kJT8SW/2gGKdx0gCR1NcZmDE0LgsGnHH
	B1+hLhrwjs5L1BB/Ebyl92PVepe/LxNLCcSVNfjYnVew0IgQfm9mx3/GMwCNr67ZByce8ZHfQtP
	IR1o85zz9xYSj9DEgviKFoJgiKpnHnntlB3Jc5ZvhRtT92ChsMdbb2DsUlOHKjoj0q5MFrAZ1Hs
	T7MWbGJCkLPJCcwwiZPa2HfznSwvhAmryYGo85dBWk4m3S/AoPzadmakzft/0Lb3ZUfpejw/8mn
	zXceDfGERRpCBZ2hxgVqQHShXxAff7PUTQcmuSOpCWWt/9RpWRb2QCxuPWkB1y9P++6BbNHhWHh
	A1aHlx3o7YoYt5yf4WtE7KEgPSZ+2apYw=
X-Google-Smtp-Source: AGHT+IE+6GXkISYGbni+uaCAjkw1VzDWAcm9sJXxkCr8OoOVKD4QCrcDcbCgM7Qv9pG6Y3Wc4AVqDQ==
X-Received: by 2002:a05:600c:4f53:b0:458:d289:3e26 with SMTP id 5b1f17b1804b1-45b4d8de8b9mr15459915e9.2.1755770678710;
        Thu, 21 Aug 2025 03:04:38 -0700 (PDT)
Received: from mail.gmail.com (2a01cb0889497e00765727e34656ae4a.ipv6.abo.wanadoo.fr. [2a01:cb08:8949:7e00:7657:27e3:4656:ae4a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b4db387fdsm23361045e9.11.2025.08.21.03.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 03:04:38 -0700 (PDT)
Date: Thu, 21 Aug 2025 12:04:36 +0200
From: Paul Chaignon <paul.chaignon@gmail.com>
To: Eduard Zingerman <eddyz87@gmail.com>
Cc: syzbot ci <syzbot+ci59254af1cb47328a@syzkaller.appspotmail.com>,
	andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, shung-hsi.yu@suse.com,
	yonghong.song@linux.dev, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: bpf: Use tnums for JEQ/JNE is_branch_taken logic
Message-ID: <aKbvNM0WDUy7v4DB@mail.gmail.com>
References: <ba9baf9f73d51d9bce9ef13778bd39408d67db79.1755098817.git.paul.chaignon@gmail.com>
 <689eeec8.050a0220.e29e5.000f.GAE@google.com>
 <aKWytdZ8mRegBE0H@mail.gmail.com>
 <6d172613960339eff4b3a9261ef61a2c50f69dae.camel@gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d172613960339eff4b3a9261ef61a2c50f69dae.camel@gmail.com>

On Wed, Aug 20, 2025 at 12:37:46PM -0700, Eduard Zingerman wrote:
> On Wed, 2025-08-20 at 13:34 +0200, Paul Chaignon wrote:
> 
> [...]
> 
> > I have a patch to potentially fix this, but I'm still testing it and
> > would prefer to send it separately as it doesn't really relate to my
> > current patchset.
> 
> I'd like to bring this point again: this is a cat-and-mouse game.
> is_scalar_branch_taken() and regs_refine_cond_op() are essentially
> same operation and should be treated as such: produce register states
> for both branches and prune those that result in an impossible state.

I agree. I've been slowly convincing myself of the same :)
So far, the syzkaller invariant violation reports have been useful to
retrieve examples of where the two functions diverge and to deduce
improvements. But syzkaller now seems to be iterating between the same
three different cases of violations, so maybe it's time to look at a
more generic solution.

I assume you would call regs_refine_cond_op() then reg_bounds_sync()
and use the result in is_scalar_branch_taken()? Most of the impossible
states are only exposed once passed through reg_bounds_sync().

> There is nothing wrong with this logically and we haven't got a single
> real bug from the invariant violations check if I remember correctly.

That's correct. We also have pretty good coverage of this logic in
selftests and now it seems in syzkaller as well. Agni is also
continuously verifying reg_bounds_sync(). So I think the risk of relying
on regs_refine_cond_op() and reg_bounds_sync() in
is_scalar_branch_taken() would be low.

> 
> Comparing the two functions, it looks like tricky cases are BPF_JE/JNE
> and BPF_JSET/JSET|BPF_X. However, given that regs_refine_cond_op() is
> called for a false branch with opcode reversed it looks like there is
> no issues with these cases.
> 
> I'll give this a try.

I'd be happy to contribute selftests extracted from the syzkaller logs.
It's still hitting three different kinds of invariant violations: the
one reported here, the one addressed by my patch, and another one.

And I'm of course interested to run any patch through Cilium's CI to
check the complexity impact.

> 
> [...]
