Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2352F4AA40F
	for <syzbot@lists.linux.dev>; Thu,  3 Sep 2026 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442984; cv=none; b=DW1fCjvfasI215tzaO5/0kO8L6OS3b9hbY+2lnPD7OaiUblF1aanuaxp4nrl6pB34T786H/GYIDGy+mfTeKR1gpnPbfawvN2vgStCyR3EminB7lYpW5adxiZGl7ahvcgtU6iHVC5OBPg7XNaJHqP+J/V2Hw8briTmR3PpdC1DsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442984; c=relaxed/simple;
	bh=VdS3TIVpsGk2H8r+41+ScTWb/dkYq/b5cmeM4rty3Xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C4Q3HJoNA0tt4HIer7WRfAuq3pUtEYeAh5L3vcE3hdv7TGE2wyu9U+pc54E2nk/zGJAaIu3BqQoXCMck6Zpf9/ca7yoW0FPiC2afQv0hqlC8wWgewzPk3BKzCJ+EGexFLdZpNrvpuqGMiHVc8ZLOv6vuPQgAR4KciTOPc2qtbjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KfHHUFsS; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KfHHUFsS"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a5ebf75d62so1776963a12.1
        for <syzbot@lists.linux.dev>; Thu, 03 Sep 2026 06:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788442965; x=1789047765; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RaIu74bw6eLOMKYANPeKIm2s1q9acmHz12gAtaInzqo=;
        b=KfHHUFsSyYGeCWHUiqTX+21ht+gm3tdBkwzGnpFujD7N7eU2PPaHgzOU+DohxgqBk7
         W8YapusHf9+MUAkDvHJ9nt2g1FfY99op7ea0ccDLvTwn7n0tnxnx2aHOZcZsnhEKW/cy
         TSy/7DxLmMbxNPGXJLmfTUMtnWnv+GMUukJDYCasm5XxKpSuVJESUQa6K4nc/5T+Y7BY
         VyeyQibvGvDFwQmQpYuKm4H61eR9UlZDztCXReuF8RLtljFR1e4jP2qpWXVt9c3qG3ul
         Ii0HD0QKt0FH/LKUIATd0b2f1FHZRV84nKCNk9iSe7Dtk9I1fPoAOy90vWW9mtp93t/E
         E+AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788442965; x=1789047765;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RaIu74bw6eLOMKYANPeKIm2s1q9acmHz12gAtaInzqo=;
        b=h1DBUqatTPa7kaGqvgf7wd7I9ahxjvk19hZ4EosRN9PM4HpaPPRJMszLd4X2wD8bgL
         pZQuGTZ1o8Kx+nxJgoMk7p7MQ/eyELZsjDhFNsaSg0FH2ipqQJmTIybRDXuMttg+HGCy
         376Du9uXLWybfgFF/H2BdJwUmEvmuMMSpm2YJBKtV2Mi0QcHplpTk9J/yH03aYX425yf
         nRBYd/vVyfNW9bAFYta0Utbz+Zf95z2u/HuFPHA3kqIKZDHMANzdyaS/P9M2Csn+zYvW
         ocUPi+QycrXL62R2ybkcPd0mSxp+mc+Siex/TRPLuFTOVxcaBEeBp+yX5IQQfnihisvw
         I38g==
X-Gm-Message-State: AFuF++msKw8qc+68pfcq85j6XWU5MSkAuwE+au+Q8KCNWtRTalWaFsnw
	qJx07DmJx9rAOJD8EoS5o/3VuVH9icMGHz6YwwUsuZbQ1TZ2LjbEybmk
X-Gm-Gg: AYBFou2kxnOrYhlooL/JMv2kV1Ih2EbdlPM5qz+/MHaEH7Vd/1ffdSXiI14TV7ZWoD9
	vxajdJfIuF9FobHngueOwiLRJJR5xRbdwtyZekOrl1xZhgCh+uB2u3XuDYuLAiJVZD5opQ8XBNm
	esV35aABGgmJaI7I+bV2RQDBvk7QNRAO0C6Ksb/M/uFzz5CZeyBr/in+enQnFcvMRq6EjzvfOjG
	WeR6H7wo1KuaDT3I7a+xRUpjyYYpr9qTjDp24hXjAsj0oysZX9KZ0YDS9E/HvWh0YmLYPXZVGIN
	VZO1P5992RKT+GBBuXukZAlij4r53EenrV/VLyPoFFNFcfTlK/+xyKgQExjAjlgv4zOvD1Y7rr5
	oaRuvV9ZS8OD0tiEyr7g8JRODhC1B9HjoO0jdqZfn/eXXeovEAOFhCI81YStNN21/ZefpgaGAVU
	vdgM3VKZWhkFjK+ZBMrEOjbekZuzr/g24YBuxngvU1DtjhO5ufrg1pTN0fxad7XRGOEJAxFiLPb
	mM+DeCzah5OodmqsZF3oOUu9qh+EP1im3KQS7Bs+mLO5nLSY4k7GTAAljAXebVEWI6cj0g6bFan
	jAwKwIYJiUpCJN2J1Ci6XDGJFNi7GC5uYdItu0JK7m9NWZ2NhuIn8MWjkdOephSRvjExMAnBMCX
	LpTOqX/JkR6pmi+RUV8lqa0U+MjjDd7rZEic=
X-Received: by 2002:a05:6402:354:b0:6a6:8b31:ee29 with SMTP id 4fb4d7f45d1cf-6a6965928edmr2214380a12.0.1788442965211;
        Thu, 03 Sep 2026 06:42:45 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a67f8becc5sm2509639a12.12.2026.09.03.06.42.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 06:42:44 -0700 (PDT)
Message-ID: <cb39fec7-b072-41d2-b5da-89a4d1d665a6@gmail.com>
Date: Thu, 3 Sep 2026 15:42:43 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4] xarray: fix index jumping backwards in xas_find()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <4b9f783d-acf4-40a7-bb2a-00ed8e394bad@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <4b9f783d-acf4-40a7-bb2a-00ed8e394bad@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 8/28/2026 10:23 AM, syzbot wrote:
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
> PTE pointer based on this backwards index, resulting in an invalid memory
> access such as an out-of-bounds read or use-after-free on a page-table page
> freed via tlb_remove_table_rcu().
>
> To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
> xas->xa_node). If it does not and the node is a non-leaf node, set
> xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before advancing.
> Also add test cases in test_xarray to verify xas_find() behavior when
> iterating over and splitting multi-index entries.
>
> Fixes: b803b42823d0 ("xarray: Add XArray iterators")
> Assisted-by: Gemini:gemini-3.7-flash syzbot
> Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
> Link: https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61
> To: "Andrew Morton" <akpm@linux-foundation.org>
> To: <linux-fsdevel@vger.kernel.org>
> To: <linux-mm@kvack.org>
> To: "Matthew Wilcox" <willy@infradead.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v4:
> - Removed verbatim KASAN crash report excerpt from the commit description.
>
> v3:
> - Renamed xas_split to split and passed xa_mk_index(0) to xas_split_alloc() and xas_split() in test_xarray.
> - Updated commit description to clarify that the use-after-free occurs on a page-table page freed via tlb_remove_table_rcu().
> - Changed subject prefix to lowercase 'xarray:'.
> - Corrected the quoted crash report in the commit description.
> https://lore.kernel.org/all/e2842b55-5d7f-47c1-bff1-28162cc1578d@mail.kernel.org/T/
>
> v2:
> - Corrected offset synchronization for non-leaf nodes to use get_offset(xas->xa_index, xas->xa_node).
> - Added check_multi_find_4() self-test in lib/test_xarray.c to test multi-index entry lookups and concurrent splitting.
> - Updated the commit description to include the KASAN slab-use-after-free report.
> https://lore.kernel.org/all/fc978b5d-df9f-4a06-89f5-d0fed8939e42@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/e62bb2ac-6ecf-41a2-823f-c13547d5db78@mail.kernel.org/T/
> ---
> diff --git a/lib/test_xarray.c b/lib/test_xarray.c
> index 5ca0aefee..cda7245e4 100644
> --- a/lib/test_xarray.c
> +++ b/lib/test_xarray.c
> @@ -1247,6 +1247,67 @@ static noinline void check_multi_find_3(struct xarray *xa)
>   	}
>   }
>   
> +static noinline void check_multi_find_4(struct xarray *xa)
> +{
> +#ifdef CONFIG_XARRAY_MULTI
> +	XA_STATE(xas, xa, 100);
> +	XA_STATE_ORDER(split, xa, 0, 0);
> +	void *entry;
> +	unsigned long i;
> +
> +	/* (1) Order-7 entry (0-127) with adjacent entry at 128, starting at 100 */
> +	xa_store_order(xa, 0, 7, xa_mk_index(0), GFP_KERNEL);
> +	XA_BUG_ON(xa, xa_store_index(xa, 128, GFP_KERNEL) != NULL);
> +
> +	rcu_read_lock();
> +	entry = xas_find(&xas, ULONG_MAX);
> +	XA_BUG_ON(xa, entry != xa_mk_index(0));
> +	XA_BUG_ON(xa, xas.xa_index != 100);
> +
> +	entry = xas_find(&xas, ULONG_MAX);
> +	XA_BUG_ON(xa, entry != xa_mk_index(128));
> +	XA_BUG_ON(xa, xas.xa_index != 128);
> +
> +	entry = xas_find(&xas, ULONG_MAX);
> +	XA_BUG_ON(xa, entry != NULL);
> +	rcu_read_unlock();
> +
> +	xa_erase_index(xa, 128);
> +	xa_erase_index(xa, 0);
> +	XA_BUG_ON(xa, !xa_empty(xa));
> +
> +	/* (2) Splitting a multi-index entry after a lookup begins inside it */
> +	xa_store_order(xa, 0, 7, xa_mk_index(0), GFP_KERNEL);
> +	XA_BUG_ON(xa, xa_store_index(xa, 128, GFP_KERNEL) != NULL);
> +
> +	xas_set(&xas, 100);
> +	rcu_read_lock();
> +	entry = xas_find(&xas, ULONG_MAX);
> +	XA_BUG_ON(xa, entry != xa_mk_index(0));
> +	XA_BUG_ON(xa, xas.xa_index != 100);
> +	rcu_read_unlock();
> +
> +	xas_split_alloc(&split, xa_mk_index(0), 7, GFP_KERNEL);
> +	xas_lock(&split);
> +	xas_split(&split, xa_mk_index(0), 7);
> +	for (i = 0; i < 128; i++)
> +		__xa_store(xa, i, xa_mk_index(i), 0);
> +	xas_unlock(&split);
> +
> +	rcu_read_lock();
> +	entry = xas_find(&xas, ULONG_MAX);
> +	XA_BUG_ON(xa, entry != xa_mk_index(128));
> +	XA_BUG_ON(xa, xas.xa_index != 128);
> +
> +	entry = xas_find(&xas, ULONG_MAX);
> +	XA_BUG_ON(xa, entry != NULL);
> +	rcu_read_unlock();
> +
> +	xa_destroy(xa);
> +	XA_BUG_ON(xa, !xa_empty(xa));
> +#endif
> +}
> +
>   static noinline void check_find_1(struct xarray *xa)
>   {
>   	unsigned long i, j, k;
> @@ -1370,6 +1431,7 @@ static noinline void check_find(struct xarray *xa)
>   		check_multi_find_1(xa, i);
>   	check_multi_find_2(xa);
>   	check_multi_find_3(xa);
> +	check_multi_find_4(xa);
>   }
>   
>   /* See find_swap_entry() in mm/shmem.c */
> diff --git a/lib/xarray.c b/lib/xarray.c
> index 9a8b49165..980324d68 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -1406,9 +1406,11 @@ void *xas_find(struct xa_state *xas, unsigned long max)
>   		entry = xas_load(xas);
>   		if (entry || xas_not_node(xas->xa_node))
>   			return entry;
> -	} else if (!xas->xa_node->shift &&
> -		    xas->xa_offset != (xas->xa_index & XA_CHUNK_MASK)) {
> -		xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
> +	} else if (xas->xa_offset != get_offset(xas->xa_index, xas->xa_node)) {
> +		if (!xas->xa_node->shift)
> +			xas->xa_offset = ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
> +		else
> +			xas->xa_offset = get_offset(xas->xa_index, xas->xa_node);
>   	}
>   
>   	xas_next_offset(xas);
>
>
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
