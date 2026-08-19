Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400913E1218
	for <syzbot@lists.linux.dev>; Wed, 19 Aug 2026 07:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124764; cv=none; b=lM+7SKIssipwBD7rBNXMDt6Kf1lQCTJH4BICyyFcCrvOv9mWNH9elqRW0TZA4Zpu/Ml+f3WGVA5lVQFj5gRFyeXXMsjQ5MGXNz4D8u20komqxJ7nkvi/+SvGd3472MgM6pYfVUL+MQnU0GruQW0WgSIyJICxHE40CpSqYYOKUsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124764; c=relaxed/simple;
	bh=VPeKBfuvfNvpny90s+OEiSFpt2LC7rJK5kPuJHvTMPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aY0QHZbt1J5cSq8q+pyjwgbwA7UI+dMv9gpaGVIMimob78ACd0cIUhppPAOTGox+/QKCzW+9W3gacTa3Mke6hzUnboCDibUfUPImfdpp7DMnM1SnbStJfpbQB3DfPTV6PXmw5s2RIogNrQ96ZAFLvwOy/gMDL/8vSmFDBghtqak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xf+FiVHh; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xf+FiVHh"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a36982a875so1101218a12.0
        for <syzbot@lists.linux.dev>; Wed, 19 Aug 2026 00:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787124760; x=1787729560; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hH825Fr5Lnit/D/5pt4IJTuS2ae+IJVeyuadtcJRcUA=;
        b=Xf+FiVHhpAXGwE55+/1K2xL5NuAo20Pnr+JynCW13UQVtrq6yU1KiWVNlM4g3bk7Ag
         0ZkKmdc/2y27i6PnnlY864jJpeR/FLspzbAHCD8xvyK83Zk5LdCNn1uGI+juvdI1bYQ8
         6HEiz41FhAdj1tbAro+jP3I5QCMPUhjkz4zDtrY21GGELBZpnXEKEhuSfI4lHN59CfLS
         ZMYs5eLHDKg8tocJJzbuAdHl4twmpbTaGffo1fByLnFUvtmUV4Vo7JNzSVWO0J07phZT
         8o3yCZW+6rZnxb12MhEBIWPqopInplU1U2BdgnV0O7RMnwBgQeSDQsHHU/yowbVmze3A
         fi/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787124760; x=1787729560;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hH825Fr5Lnit/D/5pt4IJTuS2ae+IJVeyuadtcJRcUA=;
        b=XDTLTVREeOIouuhY6KnJBl0lIq1opEZ+SPUPhLhjczNlIdwoPjpmEINO7LVN0FoVxn
         qDGwiSULDMzkKjni+rnDsBNX1t9zXwwbkmWQzucp9qkx4hZnjFf5AX+f9+RVFcZHVVFg
         YQ3fbp58mdHE7zINQ9aB33/QzmT1j5P00EuuY7+uxgUx39EboifYFo4pzyFiUmVGmEXV
         AgVPvJgdk4WeXgBzbtGuAyYwC0v/XzPjJYkk9iJIzTrD4hPYBlkzlq79mab4BxUtXisw
         YSl8FdGkpWPOI6scsojYzDcLx+ivvF9PxTOk+AD00NT9SoTZOGvdwSc+iCiVIJXtLLhI
         +xlA==
X-Gm-Message-State: AOJu0Yx+KsaYLwZ237yc3lK86u+cZLRX7b+NN281zZ5L8mQrn1L2AJnL
	7U7c7f0pKW7dV62v/VcgDvDFXRHIiBi3aqNziNhuQnZjx/X0dMT+OneY
X-Gm-Gg: AR+sD12f4C3dSfMW1fLtQ7OvniwMbz3mD8EH7WjKIik0RihaPXyrbtZhv2+xVZHuWzb
	ahQMe1hExCgbpldN1sVkS9QGj/yE4woFUXviDG80KxIJ3wlUcX6YY4he4JQerzBMKR4QMFA0K4n
	iNRZ6JLnPYYgOxb0jnyS5iPuPybzbqDQUsn4rV1aeSTjY3pg62+/v9DmNy/klSzaZDJaFiO45tN
	/2OdjUrzqlglvM45JXMBUX+WPPg/p+Q/9Af2podRvElcDPzfdvEGrOOpzS+zI8hbnv73HTG9KuL
	KRehFbMt9qaDhyarwEa/btzvCXqku+yXcSvFnBJDgvhHOYTRW7RgSyIytEwWAlzu2iYR6FqMRCv
	rUv6cQQDmzWPK4VjcsgPnFUQfPrjB/CQRJmbjnEjI0FXr8jyF/Mo+qWVVU0bYQx2tYkN5+LEyEz
	oXwdVCdRERAbXjNnaoXCYdcAlxuxG5097g+Xshpww8GQ/3NbkSRBFVUFpjMTfuWUSuxgd2jRacG
	aUZQCcpV4XT+DiVGfgjJgp1A2Udh60b3HG4qxRUatXVO89z94o59ptbZJhRV0WJJL5u6H8re/Y6
	S24AwaZlQyhvaUZTnwo4eEKh3/vN8MG6W7TuL14QExHuvNSxIJtdK9E=
X-Received: by 2002:a17:907:5c6:b0:c21:9411:881b with SMTP id a640c23a62f3a-c242e26974fmr134100066b.25.1787124760132;
        Wed, 19 Aug 2026 00:32:40 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c243c4ac06asm38061366b.33.2026.08.19.00.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 00:32:39 -0700 (PDT)
Message-ID: <17449f8c-df13-42b5-8a0b-de5cfa32918c@gmail.com>
Date: Wed, 19 Aug 2026 09:32:38 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] XArray: fix index jumping backwards in xas_find()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <e62bb2ac-6ecf-41a2-823f-c13547d5db78@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <e62bb2ac-6ecf-41a2-823f-c13547d5db78@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Resynchronize a non-leaf `xas_find()` cursor to the node slot containing
`xa_index` before the existing `xas_next_offset()` call. The current
`get_offset(xa_index - 1, node) + 1` assignment already moves past the
resynchronization slot, then the common increment moves once more. For an
order-7 entry covering indexes 0 through 127, an adjacent entry at 128, 
and a
walk beginning at 100, the current code changes the offset from 0 to 2 
and then
to 3. It skips the stable entry at offset 2. This violates the documented
forward-iteration contract without any concurrent modification.

Keep the shift-aware mismatch detection and the XArray-layer repair. Use the
slot containing `xa_index` as the non-leaf resynchronization point, then 
let the
existing helper perform the single forward step. Preserve the 
established leaf
boundary calculation. Add deterministic coverage for the order-7 adjacent
entry case and for splitting a multi-index entry after a lookup begins 
inside
it. Implement both cases in a new `check_multi_find_4()` helper in
`lib/test_xarray.c` and invoke it from `check_find()`.

Correct the commit message to describe the retained KASAN use-after-free in
`filemap_map_pages()` through `ptep_get()`, not a slab-out-of-bounds report.
Preserve the verified backward-index mechanism, the `Fixes` tag, syzbot 
links,
and the existing Gemini provenance tag. Do not change locking, public 
APIs, or
caller error behavior.

On 8/17/2026 3:04 AM, syzbot wrote:
> A bug in the XArray iterator xas_find() causes the iterator's index
> (xas->xa_index) to jump backwards when iterating over a multi-index entry
> (like a THP) that resides in a non-leaf node and is concurrently split.
>
> When iterating over a multi-index entry in a non-leaf node, xas_load() sets
> xas->xa_offset to the base offset of the entry, but leaves xas->xa_index at
> the requested index. When the caller subsequently wants to advance to the
> next entry, xas_find() is called. xas_find() attempts to synchronize
> xas->xa_offset with xas->xa_index before advancing. However, the fixup
> logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
> Because the THP resides in a non-leaf node, the fixup is skipped.
>
> As a result, xas_find() simply increments xas->xa_offset and recalculates
> xas->xa_index based on this new offset. This causes xas->xa_index to jump
> backwards. If the THP was concurrently split, the entry at the new offset
> is a node pointer, so xas_find() descends into it and returns the folio at
> the backwards index. The caller (filemap_map_pages()) then calculates the
> PTE pointer based on this backwards index, resulting in an out-of-bounds
> memory access.
>
> For example, a KASAN slab-out-of-bounds read can be triggered in ptep_get()
> via filemap_map_pages():
>
> BUG: KASAN: slab-out-of-bounds in ptep_get include/linux/pgtable.h:495
> [inline]
> BUG: KASAN: slab-out-of-bounds in filemap_map_folio_range mm/filemap.c:3820
> [inline]
> BUG: KASAN: slab-out-of-bounds in filemap_map_pages+0x1100/0x2090
> mm/filemap.c:3955
> Read of size 8 at addr ffff88811b3b4a00 by task syz-executor411/5876
>
> To fix this, remove the !xas->xa_node->shift restriction and use the
> get_offset() helper to correctly calculate the offset for any node shift.
> This ensures that xas->xa_offset is correctly synchronized with
> xas->xa_index before advancing, regardless of the node's depth in the tree.
>
> Fixes: b803b42823d0 ("xarray: Add XArray iterators")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
> Link: https://syzkaller.appspot.com/ai_job?id=608570d2-1765-472d-a79b-ea5b0b3a226a
> To: "Andrew Morton" <akpm@linux-foundation.org>
> To: <linux-fsdevel@vger.kernel.org>
> To: <linux-mm@kvack.org>
> To: "Matthew Wilcox" <willy@infradead.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/lib/xarray.c b/lib/xarray.c
> index 9a8b49165..5695618bf 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -1406,9 +1406,8 @@ void *xas_find(struct xa_state *xas, unsigned long max)
>   		entry = xas_load(xas);
>   		if (entry || xas_not_node(xas->xa_node))
>   			return entry;
> -	} else if (!xas->xa_node->shift &&
> -		    xas->xa_offset != (xas->xa_index & XA_CHUNK_MASK)) {
> -		xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
> +	} else if (xas->xa_offset != get_offset(xas->xa_index, xas->xa_node)) {
> +		xas->xa_offset = get_offset(xas->xa_index - 1, xas->xa_node) + 1;
>   	}
>   
>   	xas_next_offset(xas);
>
>
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
