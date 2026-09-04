Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9FF44AB94
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 12:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524197; cv=none; b=rKItck5BsOATzRLMAdVHfItIlV6XNHr5p+v/gVpRlMQ0AHs48Eo3m4mkHLFjJCuwKG90rtvksi2/l20uMEEWwBpLwANNVGzgJdQW3/n04h8Ge0mw3WHrxHMrVobqwHF4ArOp8EUIdyqCG77QYj8PlVmZQrnK4OxTqmwaVctgw9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524197; c=relaxed/simple;
	bh=Mih/s/iaTNQ3AYU6LlfwTYiHV7v9uAhhnX40xc6A7xI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=RrjbZFtIrUpIwmgSdYLl1A/pRBsh/n5sv5etBmIaTpY0R5tLh5vJzX4gIMV0IdP3vxc5dI4rMrhl1XwLOCogIAxScJvKH2oyInoO82T65LlhA4L/OCA0dmAzMsMkYZxTy6ZHCSl61WfAAmCYQmFmEE4tVxriYXHC16j/xXAjOCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TBwm0mT2; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TBwm0mT2"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a623987d32so1341284a12.1
        for <syzbot@lists.linux.dev>; Fri, 04 Sep 2026 05:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524193; x=1789128993; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bmyMOpfaX4h3t7GBum5n74Kd1I2b9Qp+ODDo5tAvT2c=;
        b=TBwm0mT29sXTY2CVj0xxPjruKwJRg+jh0qrtjPG+ehRSA2Qfrr1n6WeO/GtceNRjqv
         K2/xn1lLD5ifMyQpxZBGpWL0caCFaPbSR/Zc4B/K+iUxOvAKq1tsfusniGoIrLOtm7Et
         cl9AlKbwlUMeDLNtuPghq8PsOmqQw5IBEP2yJaOJfq8rojGtf1VPXxfKZrybms/d2tcL
         nnXYsC16FLPX/3xRVXyOqgURa5eVpqcIbGzVpi0PSO5Luth5IH10LOSXRAhQ4y/braXr
         cIBfxl7kpZ1vM4+B5u798k2Fih3hUuLwdKDAcjrIb9JKfAM/RrbZgeF+hLjEr4WNfhxW
         kE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524193; x=1789128993;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bmyMOpfaX4h3t7GBum5n74Kd1I2b9Qp+ODDo5tAvT2c=;
        b=JLA/tPEyjlPz9fu+Osy10OD0kbWMG2v7d7H/IionoKWLvWVNRNSlPGBB6YdpTx3BRr
         TooebxTJQzZgaLVGH6KVBAYs1aWpAHFFBboafKx2UN3mvuHqcPVG68GFwac2gN/qsFz5
         lhIkLAcvYms91QyKFZg6pq0pz6DKqhYTXRlpqMg5VlaB9Hv7gKa+fRBtIO6fj3rfozWI
         uQQ70+AXLmL5IenxseSd1/XC826D6F0edEjdYpQ3q6xttj4nG3abhX/l4P52VcOYCQMo
         vFTc/NrE6Q97hI9DBvtfnLsftBATnB8bk+vfm2Np8tr9PXtelFTGcMimgJ5BUGeRJfey
         hH/g==
X-Forwarded-Encrypted: i=1; AKwUvBzspbTFxa7rizlMrgTMsL70ZBvThuCsgDfw67YU4oT4ZLrpUBsQ1Y9T2+Ia3IzI11gb9mq2IjI=@lists.linux.dev
X-Gm-Message-State: AFuF++nXgz5fsR0fiTR1C23sOqg7HempdQdCJiVkCtZjrSOXms3QVKQc
	pM1zQGnLTLJlq8y1N8OSof7qRaEIPS3zTENcbcxxLpJssQjk341JaEmj
X-Gm-Gg: AYBFou10ytdC5Q36BYYEIKixBLYbZpRgE42k7iweuj75mSMzMndS5bimAbYvQyQlok+
	srccSRuiR+hQ2AklF/71YYszBhbeIan1GFB+umsjqSaitSCGqFUlovwqm5/gwyqW9C+yZ+GyX1g
	VwpGC3hVO25LPL/5vrgYmVd7BdDQ9NwI96b22i32PEqxkSSDy4O7Hj0DYgSKLi2+9lCbvVPAYQT
	NLZW+M+qdcEIguIpEMog3mscUjiuq3739+zGSwEgYPTS3kc1HNuqvAq6xfGZgyOnpqdyErp9JSo
	bew7l23NlZGdyJz8Fro8s501vV8se09LmmjoZPASZuEsZ9uSoftqxDC0aBbvoOt+J1DMzcVD5d2
	vqWOfn4+lo6U012dJvHmRcZexo9T/Zgx84xSphJw8qkn2ycHzW7GKWdnydRPzJQFUPT74li204V
	KZIgjAM9P5XCYZQoT+Qqu5YMZh0y/bj6wgwjMpmreRtbt0sYm6GGzKvWcJw58yHK0v63XSEmuek
	z0bQtFmMCroQYhnRLHmJofqIDGXoVPmVdwBoKc9dac7wYQw4fc3oqUYgYz82F6eoGwE0yYzDN3x
	81drBnGFxzH58mZdCFjTZgjxIFYPazeWtQRfqOEnxH65B+VAErNX9eoRzZG1Kc8borOzW04MCut
	8od/56EtEGpFheSwfdyXTB+Cyt3v6vjH4QD/qhATXJ2kWUA==
X-Received: by 2002:a05:6402:4592:b0:6a6:35ca:af8f with SMTP id 4fb4d7f45d1cf-6a7e8e92b23mr2244160a12.16.1788524193458;
        Fri, 04 Sep 2026 05:16:33 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e6bf337bsm1063392a12.26.2026.09.04.05.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 05:16:32 -0700 (PDT)
Message-ID: <493efefa-308b-4d3d-a6e9-841a3b118283@gmail.com>
Date: Fri, 4 Sep 2026 14:16:31 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xarray: fix index jumping backwards in xas_find()
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, syzbot <syzbot@kernel.org>,
 syzkaller-bugs@googlegroups.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <2992424b-2120-489e-9010-f45f46ed52c8@mail.kernel.org>
 <20260903112251.6114f91af953412d2355e5b3@linux-foundation.org>
 <app_o87YogZExbwm@kernel.org>
 <CAGJbn0f+s3U0G=1yUx7a10-buHgA_yu0REG01M8hgFo=t+3Y1g@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAGJbn0f+s3U0G=1yUx7a10-buHgA_yu0REG01M8hgFo=t+3Y1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

I have fixed the test issue and submitted patch as v2. I'm sorry about 
issue v1 caused, hopefully v2 is going to be fully correct now.

On 9/4/2026 10:41 AM, Krystian Kaniewski wrote:
> Hello,
>
> Thanks for running tests on my patch. I've quickly looked into the test
> result and the problem seems to be related to check_multi_find_4() test and
> not the fix itself. I'll send a v2 patch once I get the test fixed.
>
> pt., 4 wrz 2026 o 10:22 Mike Rapoport <rppt@kernel.org> napisał(a):
>
>> On Thu, Sep 03, 2026 at 11:22:51AM -0700, Andrew Morton wrote:
>>> On Thu,  3 Sep 2026 13:48:55 +0000 (UTC) "syzbot" <syzbot@kernel.org>
>> wrote:
>>>> From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
>>>>
>>>> A bug in the XArray iterator xas_find() causes the iterator's index
>>>> (xas->xa_index) to jump backwards when iterating over a multi-index
>> entry
>>>> (like a THP) that resides in a non-leaf node and is concurrently split.
>>>>
>>>> When iterating over a multi-index entry in a non-leaf node, xas_load()
>> sets
>>>> xas->xa_offset to the base offset of the entry, but leaves
>> xas->xa_index at
>>>> the requested index. When the caller subsequently wants to advance to
>> the
>>>> next entry, xas_find() is called. xas_find() attempts to synchronize
>>>> xas->xa_offset with xas->xa_index before advancing. However, the fixup
>>>> logic was incorrectly restricted to leaf nodes (!xas->xa_node->shift).
>>>> Because the THP resides in a non-leaf node, the fixup is skipped.
>>>>
>>>> As a result, xas_find() simply increments xas->xa_offset and
>> recalculates
>>>> xas->xa_index based on this new offset. This causes xas->xa_index to
>> jump
>>>> backwards. If the THP was concurrently split, the entry at the new
>> offset
>>>> is a node pointer, so xas_find() descends into it and returns the
>> folio at
>>>> the backwards index. The caller (filemap_map_pages()) then calculates
>> the
>>>> PTE pointer based on this backwards index, resulting in an invalid
>> memory
>>>> access such as an out-of-bounds read or use-after-free on a page-table
>> page
>>>> freed via tlb_remove_table_rcu().
>>>>
>>>> To fix this, check if xas->xa_offset matches get_offset(xas->xa_index,
>>>> xas->xa_node). If it does not and the node is a non-leaf node, set
>>>> xas->xa_offset to get_offset(xas->xa_index, xas->xa_node) before
>> advancing.
>>>> Also add test cases in test_xarray to verify xas_find() behavior when
>>>> iterating over and splitting multi-index entries.
>>> Thanks.  But the changelog omits vital information: a description of
>>> the userspace-visible runtime effects of the bug.
>>>
>>>> Fixes: b803b42823d0 ("xarray: Add XArray iterators")
>>>> Assisted-by: Gemini:gemini-3.7-flash syzbot
>>>> Reported-by: syzbot+b72767277f29b6407083@syzkaller.appspotmail.com
>>>> Closes: https://syzkaller.appspot.com/bug?extid=b72767277f29b6407083
>>> I see from there that it was a use-after-free, detected by KASAN.  I'll
>>> update the changelog and I'll add cc:stable.
>>>
>>> I'll queue the patch for testing while awaiting review input.
>> The testing shows there are issues with this patch:
>>
>>
>> https://github.com/linux-mm/linux-mm/actions/runs/33815757662/job/100847425973
>>
>> And since it's in mm-unstable now it breaks all CI jobs :(
>>
>>>> Link:
>> https://syzkaller.appspot.com/ai_job?id=a01c56bd-74d0-411c-afb4-ee6f0cb6cb61
>>>
>> --
>> Sincerely yours,
>> Mike.
>>
