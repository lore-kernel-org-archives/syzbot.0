Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30B81B808;
	Mon, 20 Oct 2025 05:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760938699; cv=none; b=EHWX8/2pD68sVq+DbXJwzrWYbLemkdwEstHd60roi5cMsvvv9MSNdSZmqNqK+oy9ETq74LEWT3DpS6tNvVydp8AVgZX4D7Skc4ZIaR8+jammXjdKsZyRXRX4TBV1o79bc+csfveEhGppO6k9bj8RrQDVvqzJk+//Mf5dDxQ72bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760938699; c=relaxed/simple;
	bh=34fldmSOk8nJAh4latVatdAliKdxeQL60mo7ncKT1OA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1cGt4NHCNVkyG7oAT7GNsdXdRtN9ZQHxJNzwhQ833+oV34SI/09DWsJXBcNblYMfFdfbzIjyJ17THJhuS+cB3ChmrqjBBPdvCF2VOb+5ntYWvM3jVM0LSfCijidT17kwVdNVPlIREjU55BYKyzce1+w1WAhuO9Pjly5X3egcDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VpY6c1/I; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VpY6c1/I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760938698; x=1792474698;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=34fldmSOk8nJAh4latVatdAliKdxeQL60mo7ncKT1OA=;
  b=VpY6c1/IlTY5DVddxOwIUc3Msx45rpZIYjHT4HjaQQicmBSSVjCSMXNs
   473TGjX6/GG7LGVjjMvJpLz1MUx75zvTNz8HuXvBcheSQOdnj5Sefv7rB
   id4BvPlelJKulmM97Q3ta5ygsHxha8Z8sgW5SUGjc7VHN1UaXwxESFw8C
   9GuU37csQKzN3ewtS0YWyhqqhAs7dj1yvm4fYG5EYhPB+qOoZOOlMEGOx
   7IjKYsUSjBwC/TsFYrsebcQZyVnzX2Onk6eL76qGzefxf/qKHD6rnXSqR
   q3CIcwxC7zDpaf4cHI+UoZ37r8nEaDXf1ZQLMpbv55PlFsRR1fy1uOudp
   w==;
X-CSE-ConnectionGUID: QQ3R8sTCRkmEDkCieiOCbA==
X-CSE-MsgGUID: w87zB9e0RIy0rhNpRnfuNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66887190"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66887190"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2025 22:38:18 -0700
X-CSE-ConnectionGUID: 3+CThLmvSO6V5/F4GDCApA==
X-CSE-MsgGUID: RsoVDXakTFCTuMkAqrRqsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,242,1754982000"; 
   d="scan'208";a="214214521"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2025 22:38:11 -0700
Message-ID: <13d660ea-9bff-47dc-9cd7-ae74869edc5a@linux.intel.com>
Date: Mon, 20 Oct 2025 13:34:22 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
To: David Hildenbrand <david@redhat.com>, Dave Hansen
 <dave.hansen@intel.com>,
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
 <d1a6c65c-6518-4227-8ec3-f2af4f7724ad@redhat.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <d1a6c65c-6518-4227-8ec3-f2af4f7724ad@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/18/25 01:10, David Hildenbrand wrote:
> On 16.10.25 10:00, Baolu Lu wrote:
>> On 10/16/25 00:25, Dave Hansen wrote:
>>> Here's the part that confuses me:
>>>
>>> On 10/14/25 13:59, syzbot ci wrote:
>>>> page last free pid 5965 tgid 5964 stack trace:
>>>>    reset_page_owner include/linux/page_owner.h:25 [inline]
>>>>    free_pages_prepare mm/page_alloc.c:1394 [inline]
>>>>    __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
>>>>    pmd_free_pte_page+0xa1/0xc0 arch/x86/mm/pgtable.c:783
>>>>    vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
>>> ...
>>>
>>> So, vmap_try_huge_pmd() did a pmd_free_pte_page(). Yet, somehow, the PMD
>>> stuck around so that it *could* be used after being freed. It _looks_
>>> like pmd_free_pte_page() freed the page, returned 0, and made
>>> vmap_try_huge_pmd() return early, skipping the pmd pmd_set_huge().
>>>
>>> But I don't know how that could possibly happen.
>>
>> The reported issue is only related to this patch:
>>
>> - [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages
>>
>> It appears that the pmd_ptdesc() helper can't be used directly here in
>> this patch. pmd_ptdesc() retrieves the page table page that the PMD
>> entry resides in:
>>
>> static inline struct page *pmd_pgtable_page(pmd_t *pmd)
>> {
>>           unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
>>           return virt_to_page((void *)((unsigned long) pmd & mask));
>> }
>>
>> static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
>> {
>>           return page_ptdesc(pmd_pgtable_page(pmd));
>> }
>>
>> while, in this patch, we need the page descriptor that a pmd entry
>> points to.
> 
> Ah. But that's just pointing at a leaf page table, right?

Yes, that points to a leaf page table.

These two helpers are called in vmap_try_huge_pmd/pud() to clean up the
low-level page tables and make room for pmd/pud_set_huge(). The huge
page entry case shouldn't go through these paths; otherwise, the code is
already broken.

Thanks,
baolu
