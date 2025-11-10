Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5853132C33F
	for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762792783; cv=none; b=RvojBMHl72sOKQZZ6lYENB+SpceCXs5AQ1CpEH3hz9YTCiiuRg0KQeDI22eMJLKwA4SifgAVO1UGg7Tw9r+xWKCPiYoCYaIn0U48hlXiCv8xXjp8Jh5xMiJOewdZWTnhHj9llbVZtdpVk/T001UtvsbdQz+K1UvQvcB/RFD8ii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762792783; c=relaxed/simple;
	bh=4XTq/oOT0lleu40A2JbN8A9gToU04PMJTmAYqDSJ4io=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FjtLxTSuer6qayxnT8cErefWGylJ4wr9bNYV5833aZKICFIqTInzq3ZCly+Fwj3H9kxN6F2ROQbw5efm121T8KgqHCeSfoXHlAxB7nj8TiSxGtCbNhHYzwk7Q5j9HFRZaCPoJ1ZJI7YJ00ZTb4tSDAX33HDgij5qi/X+gl9bgmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WQmOVBQs; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WQmOVBQs"
Message-ID: <bfe5a925-69ce-46af-a720-14e1d2fd30b5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762792779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=71k4Aqcvt4zm4pBIL7nawrN8cq1oW6fljiRuZFAJCXA=;
	b=WQmOVBQsVjvEFIIj0Mr4IysESvSJeCebhz7JgSaXEHGHMXWSBEtauuome72QY6HLZ+jstl
	k25tc83o1SIDPXXr/QSG4/rmeYeNnzPruMBz9F0cHC+221wIpjZl+dn2xKyWRvbKsos/hu
	wsT28tzQqqwPz2nZcJBqz7N2vNheEXA=
Date: Tue, 11 Nov 2025 00:39:29 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA
 unmap paths
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org,
 syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com,
 syzbot+ci5a676d3d210999ee@syzkaller.appspotmail.com, david@redhat.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev,
 osalvador@suse.de, syzkaller-bugs@googlegroups.com, syzbot@lists.linux.dev,
 syzbot@syzkaller.appspotmail.com
References: <20251110111553.88384-1-lance.yang@linux.dev>
 <aRHX1XIyymGGWKHd@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aRHX1XIyymGGWKHd@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2025/11/10 20:17, Harry Yoo wrote:
> On Mon, Nov 10, 2025 at 07:15:53PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> The hugetlb VMA unmap path contains several potential deadlocks, as
>> reported by syzbot. These deadlocks occur in __hugetlb_zap_begin(),
>> move_hugetlb_page_tables(), and the retry path of
>> hugetlb_unmap_file_folio() (affecting remove_inode_hugepages() and
>> unmap_vmas()), where vma_lock is acquired before i_mmap_lock. This lock
>> ordering conflicts with other paths like hugetlb_fault(), which establish
>> the correct dependency as i_mmap_lock -> vma_lock.
>>
>> Possible unsafe locking scenario:
>>
>> CPU0                                 CPU1
>> ----                                 ----
>> lock(&vma_lock->rw_sema);
>>                                       lock(&i_mmap_lock);
>>                                       lock(&vma_lock->rw_sema);
>> lock(&i_mmap_lock);
>>
>> Resolve the circular dependencies reported by syzbot across multiple call
>> chains by reordering the locks in all conflicting paths to consistently
>> follow the established i_mmap_lock -> vma_lock order.
> 
> But mm/rmap.c says:
>> * hugetlbfs PageHuge() take locks in this order:
>> *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
>> *     vma_lock (hugetlb specific lock for pmd_sharing)
>> *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
>> *         folio_lock
>> */

Thanks! You are right, I was mistaken ...

> 
> I think the commit message should explain why the locking order described
> above is incorrect (or when it became incorrect) and fix the comment?

I think the locking order documented in mm/rmap.c (vma_lock -> i_mmap_lock)
is indeed the correct one to follow.

This fix has it backwards then. I'll rework it to fix the actual violations.

Thanks,
Lance
