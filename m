Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF2B2FDC56
	for <syzbot@lists.linux.dev>; Fri, 17 Oct 2025 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760721035; cv=none; b=WLbqDQnHqclszOFfa3eKYATIOpZPp19H1YgNn2/1fBtHmhqNmi9X0LTPDfRCbJu8czF8V9APhkVLRBiPk8+HsKVHzyBX2/7joqCqczI/6cHELFOPmVtDwglsHZn7dfZ4/44Z26sr7kPu8z3IBO6zJWLRI0v4Dp3qLn4grfoFm2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760721035; c=relaxed/simple;
	bh=EbgvQowcTpT0CFVtPsor1bVGvj7CjZAAIwTNi5v6oWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JVXsNKYeanaqw9otz0KYbpsdN9O94HyIH5D3uWB27y3J2QJxGHycL2JzAEZE64s4dND95T+D/8AwVspomSopMzmrVcsiOj54Hv3bCvrZCWdA61hmASmiIsdEmgfasizd562cKXMqH1g/Q7JAnM3Ouz6PT0wCk/e9NUk7ch33ffg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XeZXesqc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XeZXesqc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760721032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UK8HD9G+Kwd4HVQdRALdCmHeg5SXgo45lh6yR0QBxjc=;
	b=XeZXesqcKcSzCERaE+ZcHSi71eLSGGUmPpiJ0NzzPICe9ZNtBXkHYbNUEcXIqNieaFMd/E
	EWi43DUwrNcZJPWd4+gNN9GVB+9Hj0gnpu0O1uumyBFq9pPJ9Mcx2s4f0cPRH1QR/vTn+q
	Y7kCneCmgghxjcVwHKMGwuwZonO+NFk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-290-ZRF8SEFOOi6Qo50jA33dtw-1; Fri, 17 Oct 2025 13:10:31 -0400
X-MC-Unique: ZRF8SEFOOi6Qo50jA33dtw-1
X-Mimecast-MFC-AGG-ID: ZRF8SEFOOi6Qo50jA33dtw_1760721030
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-471168953bdso15403365e9.1
        for <syzbot@lists.linux.dev>; Fri, 17 Oct 2025 10:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760721030; x=1761325830;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UK8HD9G+Kwd4HVQdRALdCmHeg5SXgo45lh6yR0QBxjc=;
        b=egzcCLrwwTigKY1v3+UHlWd7T2SqicWz5P1o1K30dKgjJIffqoSLvHXisBg6lGGQCu
         e+cg4nRRQxMKQsy8mzZbCA0Tmpsumjk/Mj+aJoc5e5NJPWUb2PQX9S4m0+PnlYaSQRde
         6LiLinKB3vy6Nmva/N8+ylz/IhiIJaHXCCS91lF5oQngWjbjbs2O/B1AR2mv2AeIQ/Jp
         tQYHWioIBrSiJKXbUtb6j0NdZDB+yT5jAL4Bpm5KAnhhkBoDddJ+bdKMXO9wgsv3jl/n
         hZo0Rxj+VxoIGf8NN8DdMPbsd6vvOIW0CfrPXORGPHiDbP17dAk7LiXgKM6aRnzwAQQD
         e4Cg==
X-Gm-Message-State: AOJu0YwznWEsAUG3gk4xj+02ok9dL2Sir1tI50zdYqO1kYVJLdLPsupd
	fig1IwZcTZeNvHQQIh2GB8QMc7QVam6UPcDkuXO7Hlh863MTWGTdr1BdTrPblJeQ6+6rCjVFJlW
	4PcbBsxap59HpVbBoRNHVEXRrojxaTteypxUFDgISzY7GzOcZpTAgtoTFUw==
X-Gm-Gg: ASbGncvojl5hmCsTnlpQjnP4QcwiHIqJ8W4lw2SFgg2UB2XT1GL7JQ4s0SD4BtfdWd3
	B5kazK3hKwgwJlHDAY5iWHw637eQVcyhxi7sLUVDLIysCme07UKXC8d6S5KH03F7EVxdZOVnsKF
	PofAro/ir+PnBgv58rhFJiNkGdxwacPf+R1NLIM/bpIOBuTHc9RjNv7bJZ5ADHVifenCqYzlCtA
	iCgF9p/g/MzDg3neHDk2rbFwJC8UL08aMXoN0Fqw0gr1XlOS3DZ2AdVztuTbYVLj+PkGycQIeoJ
	R/nLULcQTQ/IGljR8PCsf5ZEEemLrLrOWdSTfPUAtDza4o/tnsusIHAxA3H3nCsvFCUsxBJhgH+
	z64Z9kmc/WZPeA5sTP4R1efV77lfupGTuYIT7aQQhVb/D1yY1dL0VbtkFPVSdHpfXb4NJ3VG7EH
	yGF04Kkjysbl5vPiN8x/oXqmPgWVo=
X-Received: by 2002:a05:600c:294b:b0:46f:b42e:e363 with SMTP id 5b1f17b1804b1-47109b5f8f4mr47517185e9.20.1760721030369;
        Fri, 17 Oct 2025 10:10:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvb0y9fCRtWnytuEMED2PPHaBvVSeuDvOip/abNeYWVJN8mhS8t8p9uAnDfOHyvUkNRDsLQw==
X-Received: by 2002:a05:600c:294b:b0:46f:b42e:e363 with SMTP id 5b1f17b1804b1-47109b5f8f4mr47516765e9.20.1760721029880;
        Fri, 17 Oct 2025 10:10:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715520dd65sm3981765e9.15.2025.10.17.10.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 10:10:29 -0700 (PDT)
Message-ID: <d1a6c65c-6518-4227-8ec3-f2af4f7724ad@redhat.com>
Date: Fri, 17 Oct 2025 19:10:27 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
To: Baolu Lu <baolu.lu@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
 syzbot ci <syzbot+cid009622971eb4566@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, bp@alien8.de,
 dave.hansen@linux.intel.com, iommu@lists.linux.dev, jannh@google.com,
 jean-philippe@linaro.org, jgg@nvidia.com, joro@8bytes.org,
 kevin.tian@intel.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org,
 mhocko@kernel.org, mingo@redhat.com, peterz@infradead.org,
 robin.murphy@arm.com, rppt@kernel.org, security@kernel.org,
 stable@vger.kernel.org, tglx@linutronix.de, urezki@gmail.com,
 vasant.hegde@amd.com, vbabka@suse.cz, will@kernel.org, willy@infradead.org,
 x86@kernel.org, yi1.lai@intel.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <68eeb99e.050a0220.91a22.0220.GAE@google.com>
 <89146527-3f41-4f1e-8511-0d06e169c09e@intel.com>
 <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mviw_bnC4667kph3ZnsM7AjT2IRmbx1gbym1RIRPJJE_1760721030
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.10.25 10:00, Baolu Lu wrote:
> On 10/16/25 00:25, Dave Hansen wrote:
>> Here's the part that confuses me:
>>
>> On 10/14/25 13:59, syzbot ci wrote:
>>> page last free pid 5965 tgid 5964 stack trace:
>>>    reset_page_owner include/linux/page_owner.h:25 [inline]
>>>    free_pages_prepare mm/page_alloc.c:1394 [inline]
>>>    __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
>>>    pmd_free_pte_page+0xa1/0xc0 arch/x86/mm/pgtable.c:783
>>>    vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
>> ...
>>
>> So, vmap_try_huge_pmd() did a pmd_free_pte_page(). Yet, somehow, the PMD
>> stuck around so that it *could* be used after being freed. It _looks_
>> like pmd_free_pte_page() freed the page, returned 0, and made
>> vmap_try_huge_pmd() return early, skipping the pmd pmd_set_huge().
>>
>> But I don't know how that could possibly happen.
> 
> The reported issue is only related to this patch:
> 
> - [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
> 
> It appears that the pmd_ptdesc() helper can't be used directly here in
> this patch. pmd_ptdesc() retrieves the page table page that the PMD
> entry resides in:
> 
> static inline struct page *pmd_pgtable_page(pmd_t *pmd)
> {
>           unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
>           return virt_to_page((void *)((unsigned long) pmd & mask));
> }
> 
> static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
> {
>           return page_ptdesc(pmd_pgtable_page(pmd));
> }
> 
> while, in this patch, we need the page descriptor that a pmd entry
> points to.

Ah. But that's just pointing at a leaf page table, right?

-- 
Cheers

David / dhildenb

