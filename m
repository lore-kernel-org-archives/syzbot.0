Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCCD129A78;
	Thu, 16 Oct 2025 08:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760601880; cv=none; b=BSwIV5K8Oku9/doOCpycdrofNAhH6MO/Bz8lag34wwNSss98S7SpHHmUgYlskixleqQ0oCg3DKWR555DmYhbO/wBkAYIJLp36z2HCjCqB50OBHgTC3mIUlxInxTA1A1LrvPdSQazMT4Xy36izi0j2F3Qfo60+LxTJTMT50sVlA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760601880; c=relaxed/simple;
	bh=ffNPg05OO9ZQ+iVrLLpApjwzhDydYcOe6ZOBkwVV7T0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kY2tvthMgDnmApl8Kp8N3gjuY+G4/lVUslsVTuhIodzzsEvjYEkp0aMa1bMfSNvz4g+FoG2WtZZOqAfZcQ7VjzuVxQfvZfZyqhY7sxNMpGHqckuOnStnwYT/FLDUj8xsudOV9odTft+AR3bDBKvWfGWlD59pGZKJ+Lt/OPmR6s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mehtNlDq; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mehtNlDq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760601879; x=1792137879;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ffNPg05OO9ZQ+iVrLLpApjwzhDydYcOe6ZOBkwVV7T0=;
  b=mehtNlDq38p7LqQtOw3B7XtD3t0NS5nPePXMkhVCbyUzTHEkePE3LQCf
   H8+PEuWEkLUo9vzx3QcG6XdowybTAX7xl0uYQPa6WmJfa8tgKNkdprelR
   sZW5aZob9jnkEpDhsEaMb2AW3xub1YVD24eQu6zvaNPqtlupsuu07l6gn
   HpxrNcPNYPAggnPWcULGF/qnNq9p68h3w6CS40sUZsvtLRRaMNJ+2A4Bu
   /Oig5KYtm6Z+Ki32P0JUplLuJgjmnnXdZv268HJ3KorgsS6+htdXhsZAU
   Jb4nSgOy38qanhixpR2r6+3ixORv98tcJ+Dfei19l5QHofpjekHfUe9jc
   w==;
X-CSE-ConnectionGUID: kpmnALsCTPy58gtUQJ4GBQ==
X-CSE-MsgGUID: Wsu4tmLDQ7CFUsM9sTQvHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="62830270"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="62830270"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 01:04:38 -0700
X-CSE-ConnectionGUID: cA4TqZ1TSxyq3V7qZWSmMQ==
X-CSE-MsgGUID: I4mYOUFQTfaDa93MhgX5nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="187674419"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 01:04:29 -0700
Message-ID: <8cdb459f-f7d1-4ca0-a6a0-5c83d5092cd8@linux.intel.com>
Date: Thu, 16 Oct 2025 16:00:47 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: Fix stale IOTLB entries for kernel address space
To: Dave Hansen <dave.hansen@intel.com>,
 syzbot ci <syzbot+cid009622971eb4566@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, apopple@nvidia.com, bp@alien8.de,
 dave.hansen@linux.intel.com, david@redhat.com, iommu@lists.linux.dev,
 jannh@google.com, jean-philippe@linaro.org, jgg@nvidia.com, joro@8bytes.org,
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
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <89146527-3f41-4f1e-8511-0d06e169c09e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 00:25, Dave Hansen wrote:
> Here's the part that confuses me:
> 
> On 10/14/25 13:59, syzbot ci wrote:
>> page last free pid 5965 tgid 5964 stack trace:
>>   reset_page_owner include/linux/page_owner.h:25 [inline]
>>   free_pages_prepare mm/page_alloc.c:1394 [inline]
>>   __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
>>   pmd_free_pte_page+0xa1/0xc0 arch/x86/mm/pgtable.c:783
>>   vmap_try_huge_pmd mm/vmalloc.c:158 [inline]
> ...
> 
> So, vmap_try_huge_pmd() did a pmd_free_pte_page(). Yet, somehow, the PMD
> stuck around so that it *could* be used after being freed. It _looks_
> like pmd_free_pte_page() freed the page, returned 0, and made
> vmap_try_huge_pmd() return early, skipping the pmd pmd_set_huge().
> 
> But I don't know how that could possibly happen.

The reported issue is only related to this patch:

- [PATCH v6 3/7] x86/mm: Use 'ptdesc' when freeing PMD pages

It appears that the pmd_ptdesc() helper can't be used directly here in
this patch. pmd_ptdesc() retrieves the page table page that the PMD
entry resides in:

static inline struct page *pmd_pgtable_page(pmd_t *pmd)
{
         unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
         return virt_to_page((void *)((unsigned long) pmd & mask));
}

static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
{
         return page_ptdesc(pmd_pgtable_page(pmd));
}

while, in this patch, we need the page descriptor that a pmd entry
points to. Perhaps we should roll back to the previous approach used in
v5?

I'm sorry that I didn't discover this during my development testing.
Fortunately, I can reproduce it stably on my development machine now.

Thanks,
baolu
