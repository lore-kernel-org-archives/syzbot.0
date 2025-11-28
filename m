Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A2C3043D7
	for <syzbot@lists.linux.dev>; Fri, 28 Nov 2025 09:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764322737; cv=none; b=odfZX70bzlwB78l/KdSQ4fDFHRsWLf20xie4lU1n8lQGcDKwLZFJlLGJQL2vu6yuSKIYa+VZLk1aXSfYcpsTVZj3PkPITU/GRQrq9tQlRdYk+7kS9klFVTbc/8+MqaigWqnkL3fpCexg08f8iCXBsRjEBcMvd1mDWLTm+0zMGFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764322737; c=relaxed/simple;
	bh=bmjvH9E16Sxurms4e9QneierzEBTCD+79C5Lorrt3uQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XiAQKOeED/HsZXBwjmQbkzilatKsKk30qdWBw0vo7tRj/H8ZRoIPLmE0QhSA+G2HINmcOoU570v2sxAgBJzuJllXIt8/cULNLU4XDaA0RnTBsnZXp6v2u0xiLS9rXyKAffhSxZUeYjAm8MEvTR/gtfutHCDG3vXuT0kATyNpTT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MLaQeH7/; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MLaQeH7/"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-3e898ba2a03so1026848fac.0
        for <syzbot@lists.linux.dev>; Fri, 28 Nov 2025 01:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764322735; x=1764927535; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LthYqAY+RtNmaLYwiqzD4WGuMCX4E/gtJRMR/lWn3jg=;
        b=MLaQeH7/Wk4LZbYM33m2ND++IxpfoFjfYIP2uGW+Gsn43Fyio2cEWS0i7lupt/Ki1+
         otsUR3SZpm1PkV6X9UlxGk4HWOx68FaHbT8zgeZqFgln30PFEbmeO9GLMG53DvBYNwj6
         /2O/+C+0RiySxHHLrlGIXKIYvyGyDGFe6z+qKrCrnRQknxrvXfwAgINCY6RVmJkr5dIQ
         StmPX6kDvYD2QOqndTMxLj071EL0AQcDCcmINS7fo1nBZZJVJ5dVZ6rDZb05qwWqffAf
         Ou7dLFwSj2mzDvPdXwDxtdk0MJ9eNpqZdMFWryrwwNd3uxUBJS80RLCp3hD0fRg1a3qA
         DBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764322735; x=1764927535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LthYqAY+RtNmaLYwiqzD4WGuMCX4E/gtJRMR/lWn3jg=;
        b=lr4ve4f3qOO2mJRZ1jrrfSW9vsinbuuwgsjFsH6ssRFN3x5OpoEpQLWJzpLcambGkt
         GMxf1KFf0qkuoxiLW6jxitMch2wun0gqOLQtuPpbzV+/HpN9AHPShXoMOWfwFo0c2uF/
         oUSADBQnxWIq5BPn9U/KA3SPX+y5CCYM/Umikbx4veEk1syTQrjlZjD0ef+u5RC6NnLt
         J9bnMFQE97eY/49yfOLorD+9yR2ZC7N9eK4jeLPw0FuFT+kiVLRO+t9D/DWc28G4HZDz
         PWfbkinarjgWz/duCASnNBGV5MLTVvo6abp02XjlIRVkljaosFD8k7UAnxmHptl+f98U
         tWxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNzv+eYCzr2AdvFtPAovY9XNmJGO1rGxi4/Gwu6Gu+qfzwu1eBzkO5L6WRZ1erpXt02GdYZFM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyx9MdfgwYCbtu/56TKfziYpkfq2RP0AomjMX5qwWiXdxNiM4uf
	jjGbJ46xrV+nwoX7/LGWAKEHQYqBNWkCYy9Fts75SWXn0sN7E+g2BQYfA12FYKUMnKPaYhXd+9T
	G6DcNb4HdmnE2mKqIyth8qVlfeJlUpnwghEJSKr1r
X-Gm-Gg: ASbGncuLtaIPCUAzaxCApMyJMiY/l50jOeTUqgq418iX7V8WlhvcuJ0uBv9TkH0WZla
	SackMConoh+cH/bt6TaQpI9RjW1tjWOV757HT0w295RTOlSeBGsM9KGir7U2tiUpZiHyC6qL8D+
	NXGyseMx4gK/YNZUnzUmcHhm4tUQ1dX34U+x3+Zyjbu2d0xJvG2qPwo2jIQzArVCFv58jtxA7Dn
	KxNnMqyTHCRK7j/T303A6XSdVpezg9/mzcgNBqhlQO5C1oVa1CsZbPDLU2hVLnEfvLDd89RImZz
	hfnwfE8qQmf/qMotXigUoeLOiiul/6pbqXlRDnf4a6u0AwEvgouaxsDU3Q==
X-Google-Smtp-Source: AGHT+IFcyyhbh5mVLdY6dqJ7ghVL1gBbOMscSGmFxa8A82O/KN22JtPYs3kaPhokDLE3pT1VcvqlHnf18z44t362i7Y=
X-Received: by 2002:a05:6808:180b:b0:43b:8cf4:9284 with SMTP id
 5614622812f47-4514e65b547mr5702306b6e.14.1764322734625; Fri, 28 Nov 2025
 01:38:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6928c91e.a70a0220.d98e3.011e.GAE@google.com>
In-Reply-To: <6928c91e.a70a0220.d98e3.011e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 28 Nov 2025 10:38:43 +0100
X-Gm-Features: AWmQ_bmY1ThK9ROYMd6hQxDYrcPPJmXllGT5IPNJ00nZ2ZnlyV6A2f0gfFzn4GA
Message-ID: <CANp29Y5tOb06+pWVS625NWuuBWvcA4QxDo-3F3XoMEYd90UcdA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: check for insn arrays in check_ptr_alignment
To: syzbot ci <syzbot+ci744778633ebbc17c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It's a valid build error (though other bots have already pointed it
out, so there's no reason to upstream).

On Thu, Nov 27, 2025 at 10:56=E2=80=AFPM syzbot ci
<syzbot+ci744778633ebbc17c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf: check for insn arrays in check_ptr_alignment
> https://lore.kernel.org/all/20251127210732.3241888-1-a.s.protopopov@gmail=
.com
> * [PATCH bpf-next] bpf: check for insn arrays in check_ptr_alignment
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/1a9e3044-2e1a-4d53-9086-9e8da1793af5
>
> ***
>
> kernel build error
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      5262cb23393f7e86a64d1a45eeaa8a6f99f03d10
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/1eba2ba3-74cf-49e5-87bb-fbc49cde6=
9ac/config
>
> kernel/bpf/verifier.c:7568:25: error: use of undeclared identifier 'insn_=
array'
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
> [a.s.protopopov@gmail.com ast@kernel.org bpf@vger.kernel.org]
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
-upstream-moderation/6928c91e.a70a0220.d98e3.011e.GAE%40google.com.
