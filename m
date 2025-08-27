Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC50030CDBA
	for <syzbot@lists.linux.dev>; Wed, 27 Aug 2025 08:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756281769; cv=none; b=Uz5UwRKhjPmRwlqatRdQPTDgwkoX3HecURmS7AWY+V/XXTw3kGvbLmiPuIYEccAlEGkOB/P65dISS/yApt8/4Jk6k9ROMmZxU7PXNmTv6sRuU+5KTcS385olUHi7hf6gJ3b7EYHisTONyNAAuhm+y+fCci+8iYZKuNizoPwxI78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756281769; c=relaxed/simple;
	bh=vO8Vyie80YjCwDE9MSGskrfGBH90O56PJOpRbS2hT7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I6Oq5kL62SvA9Oggz2yN3O0PDHeNWpoq7RnI5kej6a22ix+HodlT3QTK4dkDP5NFAdTpQ4g1PzjXrqjOBAhtHWnmPA4wtImUlYcE3BAiq+lYKyIqMbCkvlkFILMDJK1S1QXZ6t/Dwcnbg0y63B/z1GsV3et7WgWRkHqRn3YMVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nMv3bpXf; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nMv3bpXf"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-314f88360c4so2154835fac.1
        for <syzbot@lists.linux.dev>; Wed, 27 Aug 2025 01:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756281767; x=1756886567; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhZEbirqUXdW/X10gS1jJGHlGj1qix/3wjkKx5MsliM=;
        b=nMv3bpXfPEZYZWd0aH6e4e3A8j84ye3JFY8YBa7y6BXAHyJbTY5IBnplzoIqBrof1l
         WrxQVJTWSx3KcMv2PRR5sQkYvrwxZniZ4wcCTB/cWK40tc1xeW8eSCSFmDBGpteL7Bkc
         6gBR4BOPJhmt+0Ckx1LGk1n8oj31WWSOxJYm50j0J42TYcj5FVlrrJ3NCKLnoRXImzuU
         RG+MCJqN5xbBQAM81qBOvO7RQYuRrzj7RIqy5l+sxWtNM50CN2MGr8kMT3AXrCaL6oB6
         w2761cJByQWigON8pK/goOfFB6ThWD91xpRO2bqIjwRscwPaFcTh/ncwUWrbIVdVKBhN
         MeAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756281767; x=1756886567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhZEbirqUXdW/X10gS1jJGHlGj1qix/3wjkKx5MsliM=;
        b=kIMzif0LDFHiXG3vX7yOoD4/J6SsRV3ZVeuwPYLxttNPaIVSrehq0b5oUxlUaTqIuR
         hgSobqONK/XYLhUY/lUnMdQPEd7ytwLLB0yyNGcWzC920P/9yuM6EdcaExmSe1ZS7GyZ
         sMhOyPAuPHLs6kAeA9BQ5CcOkcRvPZKV9jkABc4jDD7pJjEwqtntwTDi1XXp59IoBpVf
         gAmLmmu4F9zGukxhKD+cR4fBKnIX9ycil2tD7tEuc2kNCTnHyRQtrDyOc9UPomPlwyYl
         XtsxzIRZSjrN0+gyq3pZmxaw1lyF4IXnAgSx/h04QdFPGEg5oFFgRpmzzrHXsV+gOYoK
         O/Lg==
X-Forwarded-Encrypted: i=1; AJvYcCXUAmfKVKQtiyzGnF1V/gVWLkBQwQGDZ3hnuiPwCjpEEKEQgSx9dwVNoQYjKyG2PgSMTbALe28=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAzVu1Bkxdx6w1G/4DduuKc1c/ryXMeg/vhBfI5jodjiAc4bim
	ohjeLZamcjFIFXM110YTwcspbXe4PghDlxkn+T7UhlAx7iL81W4o4dq9OgjH4/Q9m2KQo0Q70vM
	8xaQ1bDwPRw8Unw9pPW4Y/ZNJThv8CpNUfFA7oDY0
X-Gm-Gg: ASbGncuCyV72V9v3wi1q0uXOM+PW4UPy+JSFBRnYxxcahpiTfabf0o2w1W+G9O9mSbr
	OVVa6Otq57DwGtjqF3vZofdIsUMQU3nx9vP8Dm3yRUwtMCnp0fxKm4ooACmJOEjbHZ9wYPvKAMC
	k16IvJt7ihNaHyWLV16Pi0r2KACy6/619nCa2VCj/Go0RVV4wXUjqE0FI0HaLA3cdat9TReIX/S
	rW9ijoUU7CyQtpYu5u3PuoEC6USmrVz7C3KNsEDvP0MbnODJTw+h4U=
X-Google-Smtp-Source: AGHT+IEfrBnLDNDMITTzpqS7Ih0YLvOu5dDXvJ1pLSxTZyRah+jbSa+BiwsWbAY2nWbL1cPzLl2SgGPL/cFwtCoPLxY=
X-Received: by 2002:a05:6870:d06:b0:2f3:e087:678d with SMTP id
 586e51a60fabf-314dcc1201amr8231440fac.11.1756281766476; Wed, 27 Aug 2025
 01:02:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ae73e7.a70a0220.3cafd4.0005.GAE@google.com>
In-Reply-To: <68ae73e7.a70a0220.3cafd4.0005.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 27 Aug 2025 10:02:35 +0200
X-Gm-Features: Ac12FXyj0gwCbnjuW7Npo2Y9-aaaaG5XaAqxyeTcNf2GWeTFwzZMduVWDzIkM8Q
Message-ID: <CANp29Y6-XaVLuCbBKPChq=tmJhNJv1kbEDwX7G_2Aap-A_6A_w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/pageblock: improve readability of some
 pageblock handling
To: syzbot ci <syzbot+ci018773107f49120e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Aug 27, 2025 at 4:56=E2=80=AFAM syzbot ci
<syzbot+ci018773107f49120e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm/pageblock: improve readability of some pageblock handling
> https://lore.kernel.org/all/20250827021121.13645-1-richard.weiyang@gmail.=
com
> * [Patch v2 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better re=
ading
> * [Patch v2 2/2] mm/pageblock-flags: remove PB_migratetype_bits/PB_migrat=
e_end
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/51db4b94-ae73-4ea0-8cf3-4ea5b7715cf1
>
> ***
>
> kernel build error
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      fab1beda7597fac1cecc01707d55eadb6bbe773c
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/49ee15fe-3add-4064-a3a9-1461fbba8=
c85/config
>
> mm/page_alloc.c:373:2: error: call to '__compiletime_assert_1636' declare=
d with 'error' attribute: BUILD_BUG_ON failed: __MIGRATE_TYPE_END > MIGRATE=
TYPE_MASK
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [akpm@linux-foundation.org david@redhat.com linux-mm@kvack.org lorenzo.st=
oakes@oracle.com richard.weiyang@gmail.com vbabka@suse.cz ziy@nvidia.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68ae73e7.a70a0220.3cafd4.0005.GAE%40google.com.
