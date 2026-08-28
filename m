Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71823AE6E4
	for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 08:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787904838; cv=none; b=NANYmIN5NE7e6+RUy1qUXC51lqi4WAu5Ioq6ZF7BhStlbrRsAgGP9e0onPD+P0/gz+mXkHIFO0QXCQxFf9/ncCbk73VFyXT5taw0aDMe6x4fmBA497NXgZrV+d3X+Tx7SY769fTxaF2YCAK6pW9XWSCFb/OZLMUd6bsM+75lBlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787904838; c=relaxed/simple;
	bh=xjOYbivtA32F6ha66B+pCBJYSWiANn03SqvtMKMUhas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o8b4+SP3vdmX5ujS+LRyTfkGMvCUmbCvYGV8dyUS4wvXH5V/sSbZBvshSAUsC//NPZXf+g22ynkYloh1GaRBY9dW1egYoQ8kzctmnDvF7CcbwAWT0RED4Y3LMDfYQd4zzT4+Lmcln4tMoSbb0D/UILYkf/4/ieuHdtgNwYyeF0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JM+Cc/Ra; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JM+Cc/Ra"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49b8687630fso4312945e9.3
        for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 01:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787904835; x=1788509635; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=14EXCzZNsBfJoaU6ILgI+k9i79jHJFmdKhCygfeHlls=;
        b=JM+Cc/Ra5VxQc/yxxAvChrlfw97tEi6dCBXCJ7ufcdgytO5jVmST7r3G0UuNbfc4Tr
         UlWLjQFVI5wpOONBUrwEWCt350DOda+IOoRrk8NDO712Lj/qET75VDPUyRPZrWBCpHif
         ci6JO6KeDuNQDpjNtuT1yJQUBsPTxH7Nmp/B0tNny26HijEP9CNSzDVfKYWhNbrWn6aQ
         ngHcJccY9owfUMwrLacC2efjFhjSQlFrR6GOjS8rItv8jC7J1O79LUU5NlxVVoOcZkZL
         X26tuAUznDfXXztMtrzl14ZmQRF0MsjE8Jd/qkiXtYK+xAgnxcU6ViZe2zX0j+7XldSp
         UqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787904835; x=1788509635;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=14EXCzZNsBfJoaU6ILgI+k9i79jHJFmdKhCygfeHlls=;
        b=OwDxE+qkt5AZ+HfnnYXzmYLiUk6dGKHzb492uuUjZ23TNMDIBOS1TU2bN2m6Yq2r6t
         daTT1Wd3lX2wlLxkW8tvTUZm4IrH4VZf6JN8+xjPStWpXWwQgQMSyMqzn0bf7gJaSfFC
         qCIOHFcafDE8lDfkRuzfYVOTr+suZwVHiCokCBPirN/VC7k30OOHs9K+xD41qKXU73iE
         IXzRtlvpHI6eXu97fXWwintoEzpOauJf9vsCFp1WGYEdD26a5jRyXEXQO/qLEbvEFnnl
         texGVqHmvZMKkWR9pJEt5F9pLGKlBtRjoi1h2Tgfo/jo/Nz29DAlqZJ9amZb6U4uNh4U
         Ns0g==
X-Gm-Message-State: AFuF++mvd8FzMkrBR0Rb2SCiviJAOwcMhU+lbMkf/9xVST33AcUCfm+f
	GkLi2lGW+dF9oyIIPaNeOVvTJ4Kv9cyNBlILO6198oiJGu4/ogyJN0DN9qTFg+Bu
X-Gm-Gg: AR+sD13Q4BLcratFbyxY8w1xovKgIP7d3PFaSgJ9ZlGm3OJQLtm8Mt5YynzV0ft7SmV
	4ThEPoAK5iME+yO6OCYQUq4AotJLSv5jOI21rqLUP5HPotEx0aBrccIKg8gLne0g/yWR38hnh06
	LAAv2AWnX2uLr1TAG20nNwhHA8kKNNRRMaiLhDaVv1eaORCy8mEODDvjvx82D1dzradYpCPrLx/
	2uZu+VO9ZhNhS7jtulg963LdqIuS4JhDZ+a1C9pqWr16UidFFCQsYeVfHNH7AFTssY5Pn9ZQCyo
	ZUX4uTpr5bG//vIA1rk7AoqK3KuhlLf1LeZzmt7x7HPT9mce+z/005OXGw9ihjdpuhHu+JVGZDh
	Gj8o7skK2HpQnzFz4czP/MjUdF8yeMJ1wSqQSXiv5N11m/SU9RkJma+pOva9wavElc2XlAvjgY5
	Y8purVANyNe49LQNqxstJXY3EYsKTXxzZqNowyzztaNGG7rc16ngNYTUmNj3Xb5jnWW0FkSDw44
	9wdyDHxaiQMJ9AlAC6WdafWltmR9OiDkiOX3jF76Q5VNcd9SDPo0yj/pU74NS1A8u0Y3+JE/snG
	c+t9UAjzAQprdJ/uKg78W+mqdNxbq1sUbQeImMvjmO4jszRs7667dx0kK4GESKYH2Q==
X-Received: by 2002:a05:600c:4e41:b0:495:6e68:5df2 with SMTP id 5b1f17b1804b1-49b91c63a47mr72351415e9.12.1787904831036;
        Fri, 28 Aug 2026 01:13:51 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbab3f16sm2321909f8f.1.2026.08.28.01.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 01:13:50 -0700 (PDT)
Message-ID: <0a0370de-11f2-47c4-89f5-fb2bb0815fd8@gmail.com>
Date: Fri, 28 Aug 2026 10:13:49 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] xarray: fix index jumping backwards in xas_find()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <e2842b55-5d7f-47c1-bff1-28162cc1578d@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <e2842b55-5d7f-47c1-bff1-28162cc1578d@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Remove or correct the substituted KASAN excerpt in the commit 
description. It still says `KASAN: slab-use-after-free`, gives address 
`ffff888116c63a00`, and uses `filemap_map_pages+0x1100/0x2090`. The 
retained report says `KASAN: use-after-free`, gives address 
`ffff88803f851a00`, and reports `filemap_map_pages+0x1b75/0x1f80`. The 
victim is a page-table page freed through `tlb_remove_table_rcu()`. The 
general backward-index mechanism is accurate, so a concise description 
without a verbatim crash excerpt is sufficient.

Keep the lowercase subject, both code hunks, both `check_multi_find_4()` 
scenarios, and the `Fixes`, `Reported-by`, `Closes`, `Link`, and Gemini 
`Assisted-by` tags unchanged.

On 8/27/2026 5:23 PM, syzbot wrote:
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
> access such as a use-after-free on a page-table page freed via
> tlb_remove_table_rcu().
>
> For example, a KASAN use-after-free read on a page-table page freed via
> tlb_remove_table_rcu() can be triggered in ptep_get() via
> filemap_map_pages():
>
> BUG: KASAN: slab-use-after-free in ptep_get include/linux/pgtable.h:495
> [inline]
> BUG: KASAN: slab-use-after-free in filemap_map_folio_range
> mm/filemap.c:3820 [inline]
> BUG: KASAN: slab-use-after-free in filemap_map_pages+0x1100/0x2090
> mm/filemap.c:3955
> Read of size 8 at addr ffff888116c63a00
>
> Call Trace:
>   <TASK>
>   kasan_report+0x117/0x150 mm/kasan/report.c:595
>   ptep_get include/linux/pgtable.h:495 [inline]
>   filemap_map_folio_range mm/filemap.c:3820 [inline]
>   filemap_map_pages+0x1100/0x2090 mm/filemap.c:3955
>   do_fault_around mm/memory.c:5818 [inline]
>   do_read_fault mm/memory.c:5851 [inline]
>   do_fault mm/memory.c:5994 [inline]
>   do_pte_missing+0x21ac/0x3260 mm/memory.c:4566
>   handle_pte_fault mm/memory.c:6379 [inline]
>   __handle_mm_fault mm/memory.c:6517 [inline]
>   handle_mm_fault+0x1ad6/0x3070 mm/memory.c:6686
>   do_user_addr_fault+0x744/0x1340 arch/x86/mm/fault.c:1394
>   handle_page_fault arch/x86/mm/fault.c:1483 [inline]
>   exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
>   </TASK>
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
> Link: https://syzkaller.appspot.com/ai_job?id=b8678dd0-4122-4e08-b590-12a929d4b350
> To: "Andrew Morton" <akpm@linux-foundation.org>
> To: <linux-fsdevel@vger.kernel.org>
> To: <linux-mm@kvack.org>
> To: "Matthew Wilcox" <willy@infradead.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v3:
> - Renamed xas_split to split and passed xa_mk_index(0) to xas_split_alloc() and xas_split() in test_xarray.
> - Updated commit description to clarify that the use-after-free occurs on a page-table page freed via tlb_remove_table_rcu().
> - Changed subject prefix to lowercase 'xarray:'.
> - Corrected the quoted crash report in the commit description.
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
