Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89D921348
	for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 21:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758664777; cv=none; b=eZHtq92vvUQguZEnvJmzld19oaOq+AcXBwmjYXik28Wo9EXIFFJADI8HIeoGEIy1SJ1wo1v/HkUMTlTumreQtmu4US5gIJujHOsaq3bNYjnoEkm1ih81uOPu8lKAxOTPUTPITUvlzrW0GPs7wpX4Qg2IQ1tdQoY3F6f/Zf0O4Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758664777; c=relaxed/simple;
	bh=n+Tna5yctFylnOzzw6gjcQZXM40ohuoeFQZ83Y8tx9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ulhyccoz6CL2/0700enWa4f8o7d3XUEdpcEx5glBt7QG46dCdYD/DRQrkEcYqv0MOL0vcsa0BDgzVkIk81DZ/s0AX7IBjehBzm+SC4SMW9b7Q6nDgJB1n751hBoCAOLHWuBV1JxKUNhSUhs5VrXk9GBfXiFcwaoRr1Bd3eTeG5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=lrXqHlpH; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="lrXqHlpH"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4d41154079aso7785541cf.0
        for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 14:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1758664774; x=1759269574; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BX3qHs7drl3tKastKD1b5d2t8SLGFfBbCJAz2/e6rWo=;
        b=lrXqHlpHZj6D/zVMGY/hd1fKLU+dzobonTEJcqjNyTFFA4yUoov7KEkaJTjdvXopaz
         t0IGVp7YshdD+JKtgrSL6O9cBezPe7XzipPpTsMjOce/4PSZ6JDg8ek24wJEviupBzJt
         Tfptt250MzWhTik0eh5RrmqfryNN7oYOpK1V3WTGDmDpwNb9z0CtjyxZeABlB6c6Xjrg
         lMni3fcBznMh6SuF45Q3YcueJFfRON+knWM1ttpZGlgFrULwJFACigEVwhK9azcik2ws
         eDKCPIEgEArM7gTAkCrN9vdKU+q76us5k1ARXrorvjD7EF7uc1IzGtmZo7A+LpA9+XDQ
         9wcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758664774; x=1759269574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BX3qHs7drl3tKastKD1b5d2t8SLGFfBbCJAz2/e6rWo=;
        b=Miz3wUGkSB1M5KDob/Q3oXl38ZZwL7P6SB8GRxD3Dl9g6Go37pOstOCzMInOwASg5t
         X9scgVVfsIY1jJUPfeb2Kab7i6Ry1A70N07u8CIVBPRWmb8/YLCu2z8geXqNiBoM0sAe
         ESjHWgxRfB1QDPjYUJIwE3LJRoswx5Kb856Mc5E292xQvGxMto5GwE4KL/659u4xh7IZ
         XWHzjCxMW/wqLZ4c2QP+vZPA1C4dQ2a8iEfG/qcxAB7OpCo1+CYYgziuBPNUGeAnkp6/
         Ilroi9+wvjlZHue+vcJj90UAUduHUVNfubBGMU9LOdG2gKoAFavzesbLK94msMNlgfwI
         Prng==
X-Forwarded-Encrypted: i=1; AJvYcCV258YHY1bDqMxGYBxHG9pBK+hOXi/YnnTQAxWcSot3vj+QMiN8Gr+NWWNU83wl6Mspq5YRnYs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFg0ljxGl+gTA1awfoevhn2G9o15DcNF082Kn7d8Uq+wGMf12v
	aNj+OLGkEmpS5OO3av+03kYI7RAKpVfSCa0rOkE95kDzwKuSm7fTqCoMB2zQRSKcGRM=
X-Gm-Gg: ASbGncuq4w8HzhqUwompNvnr5eXnCpLEGzyetdal/CUjyLLkQ/1CzfIAWArN+E7CIp6
	9qXvX4AXCPcpQlBJlE0B7zLRICjzVMUn7WlxN6t+8ysmDePJmM3K8f3Fcly5hT4x2POV7Dk4R0X
	HqY9TQQ6Ugdl9RSsKInVqfqR+upRW3PoZtLeZSYymRFVxqUE/KRj6ljVI+szHtsu3n/AcZbxsXA
	V76/ya/NOBRuLr3eJRWz8UBjfzNoYluvLwRR5LrAUaMcj1ZW3i6ngdmcVLYEthbKDWztxeZdyYf
	qAo5EoNVXsDHuQk4x6egTlI0Pt02m4lEI79AFzDmAhkl8dyIFgm+Kt19GiEHPSjW+uwzL13eP8+
	BmkiALBRJ6c13uPXi7KX45Vi1NzVXTWcG
X-Google-Smtp-Source: AGHT+IGJK4Ixs84ITmfl21mhtnUIvulA36FWyfmqNajQjBuONg+Bop3F7SJyTIF2oLRK+xYnNqb3Tw==
X-Received: by 2002:a05:622a:a15:b0:4ca:e5df:f266 with SMTP id d75a77b69052e-4d369510c3fmr47797661cf.37.1758664774448;
        Tue, 23 Sep 2025 14:59:34 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4bda2c6d0c5sm93805981cf.21.2025.09.23.14.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 14:59:33 -0700 (PDT)
Date: Tue, 23 Sep 2025 17:59:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: syzbot ci <syzbot+cica6a1c285444b25f@syzkaller.appspotmail.com>
Cc: a.hindborg@kernel.org, akpm@linux-foundation.org, alex.gaynor@gmail.com,
	aliceryhl@google.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, chengming.zhou@linux.dev, dakr@kernel.org,
	david@redhat.com, gary@garyguo.net, gregkh@linuxfoundation.org,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, lossin@kernel.org,
	mhocko@suse.com, minchan@kernel.org, nphamcs@gmail.com,
	ojeda@kernel.org, rppt@kernel.org, rust-for-linux@vger.kernel.org,
	senozhatsky@chromium.org, surenb@google.com, tmgross@umich.edu,
	vbabka@suse.cz, vitaly.wool@konsulko.se, yosry.ahmed@linux.dev,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: rust: zpool: add API for C and Rust
Message-ID: <20250923215929.GA1122379@cmpxchg.org>
References: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
 <68d2cfc2.a70a0220.4f78.000a.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68d2cfc2.a70a0220.4f78.000a.GAE@google.com>

On Tue, Sep 23, 2025 at 09:50:10AM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v6] rust: zpool: add API for C and Rust
> https://lore.kernel.org/all/20250923102547.2545992-1-vitaly.wool@konsulko.se
> * [PATCH v6 1/2] mm: reinstate zpool as a thin API
> * [PATCH v6 2/2] rust: zpool: add abstraction for zpool drivers
> 
> and found the following issues:
> * BUG: unable to handle kernel NULL pointer dereference in zswap_store
> * KASAN: slab-out-of-bounds Read in zpool_get_total_pages
> * KASAN: slab-out-of-bounds Read in zswap_store
> * KASAN: slab-use-after-free Read in zpool_get_total_pages
> * KASAN: use-after-free Read in zpool_get_total_pages
> 
> Full report is available here:
> https://ci.syzbot.org/series/e8b22352-ae56-4d7c-9113-75573acf2b64
> 
> ***
> 
> BUG: unable to handle kernel NULL pointer dereference in zswap_store

struct zpool {
	void *pool;
};

struct zpool *zpool_create_pool(const char *name) \
{ \
	return (struct zpool *) prefix ## _create_pool(name); \
} \

u64 zpool_get_total_pages(struct zpool *zpool) \
{ \
	return prefix ## _get_total_pages(zpool->pool); \
}

You create the zpool by simply casting the backend pool, but then you
deref it twice as if it were an actual container for the backend pool.

I'm guessing you didn't test this even superficially?

This also still proposes an API with no in-kernel user.

NAK
