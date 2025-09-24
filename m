Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D2418BC3B
	for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 17:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758735506; cv=none; b=BADnMRqw2+28j+UixM1iKjWODztdkyfczDxkAtTIKv8CfYTV3G4iiPJ/E6UrhTY3M5OuIGu13Aq+RZLA4hDvd1L0QnB9QoMBQKKU+nr/YzDLsvOEVBrk6882pRQ1m76mBidhXWwx6gBw0GbrkVqyWEeELFjA0W//aco8KZKZDFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758735506; c=relaxed/simple;
	bh=Z17DVKG/RBCGaD1+SPrxGUmyIL1h9oOOffGlgKmOAgw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=idtkUaTaoxez17oYvNGzGOudgU9isBQ42jtt934WgR7yNTIFQ3brlSUol/Y5DplYL5I5UjkfsOx7Nb9jPEM+k0XhQIu8cG/ed2PxkKs6zTkGXOr/pfRvHfBYNpnkKEnASatb83MclkSLQu8MgXfcd389EkLjPe23xiLpaQ+WHYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vez/QiUA; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vez/QiUA"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-4256f0fac67so306575ab.2
        for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 10:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758735504; x=1759340304; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30S3XZGJU9mWOJVs113Jcz1pN9m3tlO1m1w4FB2QQH0=;
        b=Vez/QiUACLHzb4K7+MKin8e192plGsEvfP1yNt9a78QDHs3s97YB+sugBTogxRj+wa
         hf/LUWnfU2bxXfVx6KW0NBuqFPFE3nLvn3gBC0P7XzOBBf1idNZuBa3NsYgwxlWZJBmf
         D+Nmw2JyVNG+mxkPHjGFdqsgkQKYcd2Yp+ibPss05xrCpRTc3uIeGs75LWK39if993+X
         /9iAqfpuCuWIJs2h9NoqnYPmSSwzR11OhXNsruOL14TihakZsXL6kBApSJH0Mwj0cur5
         n/zpbwVJyNzlKlkb9SEPkIuGx6ZvErOycvVhVn3OMM9CPac6nvHMtMK1QzkxwCHwMVtf
         jxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758735504; x=1759340304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30S3XZGJU9mWOJVs113Jcz1pN9m3tlO1m1w4FB2QQH0=;
        b=Jn69rBQYguIFiZQ577ecPGGTLBlSOd4AfSkTZnCyPyVupz5MEgLWXOWNgGL7gHxlAZ
         +CR8omwTAOJoh+Aa0gu6/qiuyesMKLxN4ESRzdII/M9G8wHAnLtZmsFMVUm7t2e8W0qM
         HAX3G++D00pvBLvVl/kF358pc7leoQ/MJetJYpe+dSP58ndojhh8hOddEj5LXso0Pkm5
         VlAcRzLBfmqlF28002SGSLhXcbHIAliTfw3Kzr0/VxZfN2sZ67lEb242T/Aqy3l2pRMx
         XXj54LX/fyL8y38pivVthgIJF8vHxNt4oyFC5p46IAFu8ZJsvpe7/Xg5z6in7T2hZez9
         x6Zg==
X-Forwarded-Encrypted: i=1; AJvYcCU2Hruo95l63ZeYQiAvG5FZuvXqF5jtXXZDEpnUTbFBeYc4uoOfqHcG5vm61iJmya1FadpCgdk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2KhsW2drh74kR3a3uhDenZx+HNWWDg6GMlP9KN62DOW+fPL0+
	EGkUOhN0Z/VBor4PAr338CnUEZRdxuVkj5xnnOkqWqpbo7uVzT/OXu6MC+I1ByxMjqPhkdQ7Nrh
	hXq/8c7sEgFMF4q0noZcN1vc8eqI155s=
X-Gm-Gg: ASbGncto3cMBooW5SDPwANqWRvIwcjLM754S/Es9ewhl74nQZTMiD5t7OKD669vhXzU
	cD4+8SPvMgH0t/25sCInS3E6tERLMKm0VLBz4u2GT9i5ZOA6VChOTUL9bCvXtzi5Pv7qvtFZK4D
	DJjyABM5uX5Ir0O6TCpnZhIK++TCZo+mouSdpPBMtwJ5Ju80h05j4UobIILGLxyGJCye1HTOSGo
	+/d
X-Google-Smtp-Source: AGHT+IF6MTXy6w1DyXC7/o/nI0lSM4Q/Gz/7/Id81c+he4tFC30Z8cRyZeTvBBdURAh4Zo5aTq0YpXpMF9IG5v6/6so=
X-Received: by 2002:a05:6e02:218f:b0:424:1c9a:cadf with SMTP id
 e9e14a558f8ab-425955ed4d8mr6926285ab.3.1758735503219; Wed, 24 Sep 2025
 10:38:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
 <68d2cfc2.a70a0220.4f78.000a.GAE@google.com> <20250923215929.GA1122379@cmpxchg.org>
 <aabca3ff-3cbe-468a-9b65-290d5239d987@konsulko.se>
In-Reply-To: <aabca3ff-3cbe-468a-9b65-290d5239d987@konsulko.se>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Sep 2025 10:38:11 -0700
X-Gm-Features: AS18NWAPSCyNKHQcdiRVEaduc42g7VmVYowOBIJ4ozJua0iyYaZ3jlavJyn10Pg
Message-ID: <CAKEwX=P18Krj-+rXvTSCocRt+Q3o07Ghisv4nJLRCJ8tLus54Q@mail.gmail.com>
Subject: Re: [syzbot ci] Re: rust: zpool: add API for C and Rust
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	syzbot ci <syzbot+cica6a1c285444b25f@syzkaller.appspotmail.com>, a.hindborg@kernel.org, 
	akpm@linux-foundation.org, alex.gaynor@gmail.com, aliceryhl@google.com, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, chengming.zhou@linux.dev, 
	dakr@kernel.org, david@redhat.com, gary@garyguo.net, 
	gregkh@linuxfoundation.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	lossin@kernel.org, mhocko@suse.com, minchan@kernel.org, ojeda@kernel.org, 
	rppt@kernel.org, rust-for-linux@vger.kernel.org, senozhatsky@chromium.org, 
	surenb@google.com, tmgross@umich.edu, vbabka@suse.cz, yosry.ahmed@linux.dev, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 10:46=E2=80=AFPM Vitaly Wool <vitaly.wool@konsulko.=
se> wrote:
>
>
>
> On 9/23/25 23:59, Johannes Weiner wrote:
> > On Tue, Sep 23, 2025 at 09:50:10AM -0700, syzbot ci wrote:
> >> syzbot ci has tested the following series
> >>
> >> [v6] rust: zpool: add API for C and Rust
> >> https://lore.kernel.org/all/20250923102547.2545992-1-vitaly.wool@konsu=
lko.se
> >> * [PATCH v6 1/2] mm: reinstate zpool as a thin API
> >> * [PATCH v6 2/2] rust: zpool: add abstraction for zpool drivers
> >>
> >> and found the following issues:
> >> * BUG: unable to handle kernel NULL pointer dereference in zswap_store
> >> * KASAN: slab-out-of-bounds Read in zpool_get_total_pages
> >> * KASAN: slab-out-of-bounds Read in zswap_store
> >> * KASAN: slab-use-after-free Read in zpool_get_total_pages
> >> * KASAN: use-after-free Read in zpool_get_total_pages
> >>
> >> Full report is available here:
> >> https://ci.syzbot.org/series/e8b22352-ae56-4d7c-9113-75573acf2b64
> >>
> >> ***
> >>
> >> BUG: unable to handle kernel NULL pointer dereference in zswap_store
> >
> > struct zpool {
> >       void *pool;
> > };
> >
> > struct zpool *zpool_create_pool(const char *name) \
> > { \
> >       return (struct zpool *) prefix ## _create_pool(name); \
> > } \
> >
> > u64 zpool_get_total_pages(struct zpool *zpool) \
> > { \
> >       return prefix ## _get_total_pages(zpool->pool); \
> > }
> >
> > You create the zpool by simply casting the backend pool, but then you
> > deref it twice as if it were an actual container for the backend pool.
> >
> > I'm guessing you didn't test this even superficially?
>
> LOL, no, forgot to run git commit --amend so came up with a wrong version=
.
>
> The Rust version is correct though.
>
> > This also still proposes an API with no in-kernel user.
>
> That's not correct, zsmalloc is the user.

A single user does not an API make.
