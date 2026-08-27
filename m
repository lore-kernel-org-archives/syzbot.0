Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D2447CA7D
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787842300; cv=none; b=K2+GmK2q8ZdZjSZU/Fc2pEGiSWBM7xpmqtl4Uv57g4b7wCDWZI1GrYRW5md0WpXzPETzD8NLO3vItEwdIpyywIjC2EBNoSEuYYv4Lkh8ravdyoPJz6AdNQ5KBphVGBzTHeJLt4GfaFj5ZrIJmBemjDbapRQ+DpYaJHbIca4QNbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787842300; c=relaxed/simple;
	bh=U85kjlJ/PVaBBqzBCPEmnBBElmV/GlqJmViuguWtnMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/YpNXO04+Bc+t6ayPGogYTM28bw2ibsd1POmv2hO8OTAPvY9uRUQQ5Gvgl2xvh+zQvgShu/Lhsd2tUAT7fcNJZ0th1uL8fIyZs2pmnjwZoR5xr/RpCEzGIs9JZvmf+CckhNZKPUQ4zuVKbzPrVCf/tO3Joh5oejAOyC79FCFyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VeMRa6U/; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VeMRa6U/"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a5e971c970so1762164a12.0
        for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 07:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787842286; x=1788447086; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gc+lqeRuSyvtYVaZ4CHxgk1g9g1Z5ggB5TAlps+bMeE=;
        b=VeMRa6U/L78KKw9sMa/CgnAPumNgidJzx8Pn3rVauVTDs8jkIJ0Rv/FV5ClsZ7aY3v
         qvImQJjOOfbPRy/grcjmWGNzXX57rd2WD5C0td5wkcrDHSOvdAZ2XsdLNNUqwF2xt/GC
         Che+HraEkklA4Z0lBCQyplwleuJMBJQV3w8VG8ehOyN8lWlBGNEI6g+e6Pz7+YN9PXFV
         iMKZteWeZT01j8ljhXla7sIFmF+2IpQrZUsdvLc15fjTMzT5xGq0am/doX0ACJnoFYJp
         LymuLLuD6ItjRg9qaE+4t1hJkxaIDnrallUdAi56g+g3oK4pxcRmb68Eso2z1pT1xpU3
         MleQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787842286; x=1788447086;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gc+lqeRuSyvtYVaZ4CHxgk1g9g1Z5ggB5TAlps+bMeE=;
        b=gU7KnDGkK153TVBFRhLakV3TSsEcyTPdlDiDC4t6wa6eQ1VN2znglV0xlnlSAlPSzB
         F0Ts7P3jeWp4kvHkGvEYTnznE4p2U7AEEiLz7X0dr5lHFbFyZgA900PcBoI5m66kCvat
         rmW0OnbGzGHiaE27H+kiXDrsQej0CPVX8f4mLbAkwIk+tPeT4wLWDAaK90PyjKcL5fmP
         dna1haBxQ7VPzw6ywzpdNljxR/SYRy8tN/NN859zNmx4xLaEjTj9VstSbTT5norNMXu5
         7NFYsnvsMjq2R5GbRMZgIAfe/yak3aqBHV7crWUZQ5sg0VaxUKloOdLLmKaENhXFnrau
         QYmw==
X-Gm-Message-State: AFuF++mjEB+lJaTRlb9j7+UZCc8A7VlD/SN69fo2h+OsDvbViGmGub3J
	uOI5dl3M0q0TJVdl5uYvBXVU9Gvl4tQNVJkir8RfPJY63u5wxGTfrpUTnf2HNcsIJEc=
X-Gm-Gg: AR+sD13zy7Q9SMta1sRsFKTlfe5JoaXsi+QbAD2StdUcEZ0q8WYyB4o7yl/ij99bioE
	RPC33hH/ddcLi+uCePLz3jYfcxhR9dfRIAwqncnaEn8rviHpTsRkBhweQ401CC1htFlLuhgI1a0
	u405z6mFwWFBdDmM2KnVWQxhjYO+VdCYVdKl/xt1/zxFaPBMDskqMwFoRlJp0PGFmDjJElQzIJe
	7gaVNY9v+fq5GfNBgmL1TV+/Sn5yMY6+bUd2Rr/W6DpkYy++2aEyL6lsoMOUaa+sfNyNrAZQFlH
	dpsOw+8HCDlM2zQNWnqYdAXNXaOU2756lOdJPPT11jSc8Qd8dYCGLOJNFTkdbDtPL3ywv+XSCs3
	ZOkpYi5ZhRrc1ckgTcbw8U0A/z93qx/p7XtDykAifA/tRJQAz+idu5ediAMqOheMuLUJSFlQmjB
	TpeL/GMMCowwuLFo0piVomgkUfyil066uv2j1x0Ak6bJJSjqmDSNwVw56wpKPxUktZqpJUmLx2D
	d45Qo6IxTEmy1EuK5oE0lJBfEiA/xFO7rilvDIJIB8Ofizs7qx3P6k+UcShl9g+YGyIhw7HSec+
	uAzybF6BKhj7uvQTJGwNXKMmaOwhsh8hBbUANoUt8MeMHeMNogvCMG9NYFpkAfB7pQ==
X-Received: by 2002:a17:907:e1cb:20b0:c25:4835:3ad4 with SMTP id a640c23a62f3a-c2548353f0dmr206609166b.3.1787842286079;
        Thu, 27 Aug 2026 07:51:26 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a6fd00csm802601166b.15.2026.08.27.07.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2026 07:51:24 -0700 (PDT)
Message-ID: <b5576f02-fd88-47b7-95ae-fac662e1bdc3@gmail.com>
Date: Thu, 27 Aug 2026 16:51:23 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] XArray: fix index jumping backwards in xas_find()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <fc978b5d-df9f-4a06-89f5-d0fed8939e42@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <fc978b5d-df9f-4a06-89f5-d0fed8939e42@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Fix `check_multi_find_4()` so the patch compiles with 
`CONFIG_TEST_XARRAY=y`. `XA_STATE_ORDER(xas_split, xa, 0, 0)` declares a 
local object named `xas_split` and hides the `xas_split()` function used 
later in the same scope. Rename the state, for example to `split`, and 
update every reference to it. Also pass `xa_mk_index(0)` to 
`xas_split_alloc()` and `xas_split()` because that is the multi-index 
entry stored by this test, rather than passing the XArray pointer `xa`.

Keep the `lib/xarray.c` cursor repair and both intended 
`check_multi_find_4()` scenarios unchanged. The non-leaf mismatch must 
be restored to `get_offset(xas->xa_index, xas->xa_node)` before the 
existing single `xas_next_offset()` call, while the established leaf 
calculation remains unchanged.

Correct the commit description to match the retained report. It is a 
KASAN use-after-free read on a page-table page freed through 
`tlb_remove_table_rcu()`, not a slab use-after-free. Remove the 
substituted address and stack offsets or quote the retained report 
accurately. Use the lowercase `xarray:` subject prefix. Preserve the 
`Fixes`, `Reported-by`, `Closes`, `Link`, and Gemini `Assisted-by` tags.

On 8/27/2026 2:31 PM, syzbot wrote:
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
> access such as a use-after-free.
>
> For example, a KASAN slab-use-after-free read can be triggered in
> ptep_get() via filemap_map_pages():
>
> BUG: KASAN: slab-use-after-free in ptep_get include/linux/pgtable.h:495
> [inline]
> BUG: KASAN: slab-use-after-free in filemap_map_folio_range
> mm/filemap.c:3820 [inline]
> BUG: KASAN: slab-use-after-free in filemap_map_pages+0x1100/0x2090
> mm/filemap.c:3955
> Read of size 8 at addr ffff888192bdea00
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
> Link: https://syzkaller.appspot.com/ai_job?id=d9ef07ca-442b-4723-a4ca-51fdb4666218
> To: "Andrew Morton" <akpm@linux-foundation.org>
> To: <linux-fsdevel@vger.kernel.org>
> To: <linux-mm@kvack.org>
> To: "Matthew Wilcox" <willy@infradead.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Corrected offset synchronization for non-leaf nodes to use get_offset(xas->xa_index, xas->xa_node).
> - Added check_multi_find_4() self-test in lib/test_xarray.c to test multi-index entry lookups and concurrent splitting.
> - Updated the commit description to include the KASAN slab-use-after-free report.
>
> v1:
> https://lore.kernel.org/all/e62bb2ac-6ecf-41a2-823f-c13547d5db78@mail.kernel.org/T/
> ---
> diff --git a/lib/test_xarray.c b/lib/test_xarray.c
> index 5ca0aefee..7d0deccdf 100644
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
> +	XA_STATE_ORDER(xas_split, xa, 0, 0);
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
> +	xas_split_alloc(&xas_split, xa, 7, GFP_KERNEL);
> +	xas_lock(&xas_split);
> +	xas_split(&xas_split, xa, 7);
> +	for (i = 0; i < 128; i++)
> +		__xa_store(xa, i, xa_mk_index(i), 0);
> +	xas_unlock(&xas_split);
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
