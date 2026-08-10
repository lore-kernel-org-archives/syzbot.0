Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FA3369D7D
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786379626; cv=pass; b=UVafxzN9Tc8sHt/NIDPewb4JqsVjsj88ngaIpPWygQX6yhZtWynrjNLEG/VVoAsE3bW0K9bAe/SKhAB+nr5EpxWE8rUUMy98JaSm64MpGQCWijCCcCPzewDXFDiXO5/QjKAHLcN+fuBsmfTXVRtPyNUsX2b3DhHZHfS5TE2UJ24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786379626; c=relaxed/simple;
	bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NrTg7z/wqCniXy9Now2vxFIJdN5xZl21RQaZ5Zw0O1Dj6exNEQUXPCvk+yNrYL4uE+nkn6MU3Tl3D1dCmgu2mKWIA5demMG0WrVwajTQblxvlxWvz7JCXI1XLRDAn+a09XEI3KgZMzR2yHCEkWZrn/NRTCU6kFcaEfrp2bUkadQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XbPzka/G; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XbPzka/G"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-476a130c138so1999261f8f.0
        for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 09:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786379623; cv=none;
        d=google.com; s=arc-20260327;
        b=c1rN7Fwq/fj3ncwqu8Wb8vVvCfAn2Udw6xyqg/nxK1D4CcGTY2XjJYsOvl53KnKc1K
         P6/YimlX9CF8JPJZcKmiTyovWgygLGNL+/4EzFNztiPdF4K8vjt4dPu+NHZVp+G3YAqi
         2qEwxmwHyQ68DH+kpBHWzwlRE87wd0ue+wg0CM1voEQ2SH6XVEQjB7K3FcnTKzdqrG35
         WxcnD03Y16wGn7tBpubw5+c4uyedTxdqltfPU+kK1dSiBzAdOJ64p3SqIsI//a7SDdMR
         tlWut0MFKNUoaX3KQ8v3MvTAy85tqFYn16Rxqj1a/hsCtOIouS567N0KAVJhgl9grzbQ
         Aq+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
        fh=w68jvQUSWMiH/7edt74fSN15oOgOs5sjOdnJRUNDSpE=;
        b=j6m+UCXzZvyn0SZjOS9Ymde53+ItAlUfBHuyM82HuKQU5kolQDC6H+sogr7vDw7sF+
         in7+zE7tR1EVFoEcftfRmLF7F3fNlgiXneEAYVyxagKMbT8XB54w7uxIvRy1ueoeuZhh
         1c2483X9rMYk2aYN5dX3KucHuUytjW9HUnylOVp7tXfAHrPL3EBFOtooEcrWUvqOh+Es
         iWyM/nE8BDg4MsFraAADbcp+G1QZVi+XCKblbM6eVBrNg//N38L/Q0mRMoTfhYR5c1KS
         oa3AP7MfoejjQ+rYqSg22s2SUP+Y2Fy/6/jltMxCXZ2yFcypVRq0x52ULm6cbsZ5HAJU
         2FAA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786379623; x=1786984423; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
        b=XbPzka/Gp2xj7W1McslGXjCooqb5z5qokcsutbk9M6li4kPMtKzHSdKU4rMa4yF5gn
         1n+joSd4V8wpejQ+IAtg4z3km14N9+QzFV8aDkyCI68C6HTO1n4URQUgol/GEwIAFbuM
         K14HMtoUoS0Ph08/9GpwMqbm0JcfLBhEaGCY+46YLK7v2y9QqVYLVyauynJ0w3FFmB39
         p8KIaFZLS4e5eMN91lh+fA1UnyVuXIgQnZo1XP/Z7b5Y38a7VqdXrr0Rhcq2kySHe4Dc
         q27D02La5IJegMBunRmqmbNZcMTtQfjG1tfI4ITrwek6PnXcYqX7vTg81TeSOhZxmvkZ
         yaWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786379623; x=1786984423;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=92IdV19r0TDh/ZZaldtV1bjlAmTbuJX6DPtxnWcUDvU=;
        b=AJG4P5fEN4r+S6ZgpuoT3amncTQ3/b+dmbzwyxyRfD0AUV2DUX5102VMmybY4lbago
         mX2xKtGUQ9Xnw+qtEB1Mfj9p9gGVDkFfEEEkZQDR7gGgqiPKjHoFCzedxhKi73z1gzVm
         fsaOYyyDw1tK2Gs+cLxlOF6jWPX/4Dd/+BEr0/WhyoIqCz212+Nw4VzsWD9aZlvux+4B
         e+C3BtUCqA1hDL/R5F3oXivwKQ+StBYQqN/cHVw+bwsS3lbytTxbWpHBvsq8ntMgvroH
         1zOi6SzoK1HSbtERPtEttPHyhFVu31HiMrNRFzBhOaDFPT0yomNqpAwaVSgpnT9HTZz3
         9GTQ==
X-Forwarded-Encrypted: i=1; AHgh+RoaDxxgwWcI8JBWcZHksNJsK6Z1N/k/6sjXwCGRILmVI8+W5gQXpyvU5ZT478OgVLCO2rh6r2Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDlx5iF0SurzmW8SGj/w1PJrMmEwjx1KGTyQLYF9H4CaAt/nxD
	vAFL+3n5Zbt6K30Nk1VOvmfwVn17YAv/ogilwfgsmQy8afrZbOLvO9KmXJu/JhZrIo+GeDAaOcT
	dCPELZ4x3xlOMpFv963zowHUEaAYEPGo=
X-Gm-Gg: AR+sD12WXv6KmNbr6nYvu/rTQUDe5goqLmuFUudYU7yO2+UFdRVtvOTL6Rg4bgHUY1L
	qRDeNYvtyLrbPBL6XzPLxsdm+zN0+TjoBmovQKjZAWxrOnPfJAixiA5esLJJQ2/DJjrnkLie80s
	9dOyTVQF+MJCAeD4Hy1h7NrJlLkPoPcgtJfcq3p+AXaLIALdzM2+qWjGHL2Zk14/zl6USwltUtx
	qDtQrzOpwoO8+64iFwgDrtfc9075IvXiPTxGjM3rzcmhfDNymwb17BzO95iG08Lr0PoJoaMqN1G
	dVrhFwPwqREt7L989dsuSDaO4XpJSsv3kWzVe6e8Prv1y191Xzr0JSx/z/FmX1J5X+VZyRsCyhZ
	Y8JzDGd1+GDpS
X-Received: by 2002:a05:6000:c50:b0:47f:7c50:2222 with SMTP id
 ffacd0b85a97d-47ffd967728mr37586913f8f.24.1786379622849; Mon, 10 Aug 2026
 09:33:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <6a756c71.01d0871a.3a0d52.003a.GAE@google.com>
 <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
In-Reply-To: <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 10 Aug 2026 09:33:31 -0700
X-Gm-Features: AUfX_mzZKBGWa5jQHBx4faGYg8WQuFE8t_gvjrXgkg0wPeZavX_nvUNwRzCJVmE
Message-ID: <CAKEwX=M=08W43G3dSjRh1p7Z0QFSDQZWuNWguon1yETvxW+89A@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baoquan.he@linux.dev, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	corbet@lwn.net, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, 
	haowenchao22@gmail.com, kasong@tencent.com, kernel-team@meta.com, 
	liam@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 7, 2026 at 12:21=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Nhat,
>
> On Thu, Aug 6, 2026 at 10:26=E2=80=AFPM syzbot ci
> <syzbot+cif942a042aaa8793c@syzkaller.appspotmail.com> wrote:
> >
> > syzbot ci has tested the following series
> >
> > [v3] Virtual Swap Space (Swap Table Edition)
> > https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com
> > * [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
> > * [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backen=
ds
> > * [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
> > * [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
> > * [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
> > * [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical=
 swap
> > * [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only =
vswap entries
> > * [PATCH v3 08/11] mm, swap: only charge physical swap entries
> > * [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
> > * [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical =
swap clusters
> > * [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsign=
ed long
> >
> > and found the following issue:
> > KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/e7da1097-3230-4e50-80cb-1dfafeebea40
>
> Please take a look at the syzbot report and let us know what you think.
>
> Chris
>

Oh it's a real bug. Not too hard to fix though.

Basically, before adding the folio to the swap cache, all bets are
off. If you don't lock the PTE ("and pte mapped but not yet locked"),
the swap entry can even go away under you. With the old code and no
indirection, it's fine - we pin the swap device, and we only need that
swap device's property here (for the sync IO dispatch). With vswap
though, you need to also check vswap's entry backend device. I need to
add proper rcu/null check here in the case the vswap entry (and its
cluster) goes away.

Ironically, I think I got this correct in the pre-swap-table version
:) I was way, way overly defensive over there (I think I add one extra
pin for the vswap entry, and then pin the backend device to just for
good measures, which is not really necessary).
