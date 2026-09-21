Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA285013D6
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790017226; cv=pass; b=GCcIUl1Q/164OF1sHCGIFqykptgYnyHzNj1F+DUyeOk56+PfjpJbcKezjmIHNav8EI7bD2FjlpsyUmmTa8u5udRQLjefztU0hCgdWtZtIAa1tw+bAnng/VvMh5LbG4COCuEafRZaEVJ2jYEbIz2bXACrMW3b47baB9D3GUZ90Ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790017226; c=relaxed/simple;
	bh=FeFO3AREa1i0Oy9rChHlku4bTopkweu2G7chupZtHVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r9+6hwRqMtm3nZ8dPbS6cbAeqjXH/gTH4HR5KdC5MmkW9ImrvgzeMIIsa8bpYMnvTthi5oOQEFDDpUXUkdX45K1iwjH5NvSTO+n/27SpVMM1uMNP5NWDdVRYU9XgQzxB1SlLSpME6ngoABKVnB8NGUQe1/vtyuX9d/d1XBZ/3A0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lIRKT67f; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lIRKT67f"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd4ba9f68so46105765e9.1
        for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 12:00:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790017223; cv=none;
        d=google.com; s=arc-20260327;
        b=PdIo6ZkOzH4Fj1Aa2YFTNHg2taNpO+FZ0iN7N76fk5birGBMGmjSvsk/OEhiefR0nc
         AjQQcLDYKnK3Sj5H6wCh9Ut6ORnZp+rQhjFAB8bWG2QmF1KWGpFoLCHPRPA1wCYxm9UN
         wkl4YQRemuMWYLnlCwbutil6waiQ0hRS/Wq8kL12Y1cu1ZF5SpUs/nkf83gzSJedQfLc
         WxGx0L2Mh5nfWikER0KoNaHLfS40/b6s97K+FAToG1JMq+r+q29QDE2Jn7NFrFRCybFh
         syIMHYZgG2+UJeiR/8pj3nlAxGRgrFi1/UAUrxZxb9lV+qiXYLbvJamtrBUx/YkeFgIL
         g4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FeFO3AREa1i0Oy9rChHlku4bTopkweu2G7chupZtHVk=;
        fh=/DX4rTjr9dAjzlzl5Ewx3PbxMnYkY5bLzUlxdgL3S5k=;
        b=DA5NRo2d5UeZk046TNDZ+uNRvuqVi0BPT97GuOL+ZVYeupJ7iGln3CqyMifrbfV83f
         skURh/bVoW/AwbbZ0yFwLya18xIxbtJRu7jT22NkTInouoktGkpAXWL/wLUxCC93WavD
         0/RjPv9od+O3vG3U6rASDnLNYNXlNab3h4JaIs2U2G0n8WNMYNM7HIJyYwHqm9sYWb1x
         5brAtW+u07VnFKdTMjYt4J78rWj4ZV20vfI5vyBmhiANeKkFWvp61rCtbh2BsJriDs9l
         PoUCmJDoAMjqSWFA6UXE9yI3GQqTSYsGvBsKWvdphunipAh8R4d4KwfgRNHv2lxNfDRW
         Q5zw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790017223; x=1790622023; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FeFO3AREa1i0Oy9rChHlku4bTopkweu2G7chupZtHVk=;
        b=lIRKT67f4CK6zCh+IkV08mbniAtuhS1voktxBOd1AKNy3u2+GktilYOUhXXhO0u6vl
         4bKvJCsZBhpqa34Z/C1+WgLdcqYzMjSZe6EWqCqFfwqCQ3FB6KrpiUhPJRFzRmYzKBKz
         gS3PJdLCFTQDNxoVkrawXwFF5LunYEdgHSKBiEAzGqISAm1NcDEe4ZRzZUfhDrqCHhgA
         BFkqJMrMUbEGrXESDRTgM6wH/qCxfKozmSJuDVTK1n1awXvf1i7FBMriICK8l8a8ALkn
         UqnB8EOQarRN2hjA8qpxD6a1Dt15J8CIx3RDs1Vw/Vk1kGamiq1gE07T4RB3ZoDOzChX
         4s2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790017223; x=1790622023;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FeFO3AREa1i0Oy9rChHlku4bTopkweu2G7chupZtHVk=;
        b=NhrMGu1mMXIXtwcuSqkJKhn8+siOdGB4yXn/P9JwqvKJbrR45KhmVL5qLmD/KhYfEm
         TvVINIPx8q2NidwdAIM0abtKqHbWE2CXhO9pWeTRWPlM7PEtT9FKJWtE5bHih2eLE51Y
         5IpVA1FVgzubmTJB5UHZxMcnTLq/uVkD1Yy83fZh4lWhx82fx8a5M6eQ8newtwwqGNaS
         5yOTRHO84BXkYWcTBqcQkiBMGvBCZbgbz3S789+l2OC7YV/CvZoEZUJTLE1MFfpmXeQR
         j5FVxjjnhSKOrLw3dD0PS/y010KXdH3mFbtrN8fX9/up/jip9Gbv1FShEqj3oDgPWKxf
         N41g==
X-Forwarded-Encrypted: i=1; AKwUvBxNmvsVRf0s4LOv1FNE+M+OlMXK63qs1FGRJR5NCJBkGbYRjS6+bL1mhhgB9LblG5F7z6ZjuBo=@lists.linux.dev
X-Gm-Message-State: AFuF++lG3nLuYhSsTL9wINZLPHfZ/TyqNx3IAU1bZi4vsWtMG62pXN2X
	lhiKE2y1kcF0xBrtwKl8VTxG4pB56gVTPz0eNQeElqclyGoMdKqHBOrIWNrxKocweYkuRdu4zgf
	JcdA931wQRmCZAjewlWPofLi40sysJqM=
X-Gm-Gg: AYBFou1Z67veGIlGh3YS6TJyjlLb4putO4Ns7T8KPuRv1rEH0bvjMIhkKQBxMKGigAs
	taLb9aTuKHjp0wbpmfcUST/+0HjVLqx5eUuEumoBmZKgpa7OxcPAXODSMwzbUFCHcrOlvJpOsWA
	NqZHUQrOGoIdYmL46WjRB6ASLvpbOR7nQwWDpn3QbZTM+2TGaoIAqNyVfrgYSGUSfHeEOnAbY9b
	ABNmghGiwDHCsyzRVh6G212NIlU6+cMpQ3X0dUajAaJT327xxwKkSJ6wQ5LTaiXl11KM3yGsPyd
	l5ayJ9rsLMG6RopLNG1rlvpmnsy9c6ZQDPt7qeqZW4Qt8DHsDuz+7cUEdx5rbmvTyxYq2dhkRrK
	zPW7GMzvLZe8=
X-Received: by 2002:a05:600c:c8a:b0:49d:433:c3b6 with SMTP id
 5b1f17b1804b1-49fc5743da1mr174500025e9.27.1790017222438; Mon, 21 Sep 2026
 12:00:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <6ab13438.71f81b7d.15fa6d.002c.GAE@google.com>
In-Reply-To: <6ab13438.71f81b7d.15fa6d.002c.GAE@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 21 Sep 2026 12:00:08 -0700
X-Gm-Features: AcwNN1VSiww_CbRe6xoCT3Rgd63gTKNcURFr8FJ8W6bVgDoo9VnivNDHr1UO828
Message-ID: <CAKEwX=NczHcGVrGsArjV34Viv95kKbV3jo+c57BdG9pHc087GQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
To: syzbot ci <syzbot+cid08c37b8dadb4c43@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	gourry@gourry.net, hannes@cmpxchg.org, haowenchao22@gmail.com, 
	hughd@google.com, kasong@tencent.com, kernel-team@meta.com, 
	kunwu.chan@linux.dev, liam@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	skhan@linuxfoundation.org, surenb@google.com, tj@kernel.org, 
	vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 6:42=E2=80=AFAM syzbot ci
<syzbot+cid08c37b8dadb4c43@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] Virtual Swap Space (Swap Table Edition)
> https://lore.kernel.org/all/20260918180241.3424851-1-nphamcs@gmail.com
> * [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
> * [PATCH v5 02/11] mm, swap: support zswap and zero-filled swap pages as =
vswap backends
> * [PATCH v5 03/11] mm, swap: prepare the swap IO path for vswap
> * [PATCH v5 04/11] mm, swap: support physical swap as a vswap backend
> * [PATCH v5 05/11] mm, swap: enable THP swapin for vswap entries
> * [PATCH v5 06/11] mm, swap: write back vswap zswap entries to physical s=
wap
> * [PATCH v5 07/11] mm, swap: reclaim physical slots backing cache-only vs=
wap entries
> * [PATCH v5 08/11] mm, swap: only charge physical swap entries
> * [PATCH v5 09/11] mm, swap: add debugfs counters for vswap
> * [PATCH v5 10/11] mm, swap: defer memcg_table allocation for physical sw=
ap clusters
> * [RFC PATCH v5 11/11] mm, swap: back vswap clusters with a VM_SPARSE arr=
ay
>
> and found the following issue:
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> Full report is available here:
> https://ci.syzbot.org/series/713f2473-328a-4c16-8bce-63005d15a338
>
> ***
>
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

Ah I think the bug is in the RFC patch (the one that does the
conversion). I was too overzealous in deleting checks :)

The skeleton (cluster struct) itself is no longer freed (I just put it
back on the free list). But I do free the vtable when there is no slot
used in that cluster. It's one invariant replaced with another -
"cluster freeable, but if cluster exists then vtable exists" becomes
"cluster is never freed but the vtable inside it might be freed", so I
should change the check rather than just deleting the check.

Should be easily fixable.
