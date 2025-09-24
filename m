Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F0019D8BC
	for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 05:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.212.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758692782; cv=none; b=T80o6LDNl+OB5vlw8VBruAQx3r7N4xIzAfefmGtYHC/PlDghNcdFEN7JvPfVN3v7szRq0/2+9rMIr36+hTyTsAs4doIxmoBUlC5MI0Z+lb7J8yAzgrZF1WgGdsnyS4SrQj4WaXnVw7tS2F54VDNi9D6OYgibvZM2kBw2IuuKO60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758692782; c=relaxed/simple;
	bh=UQm9drVUemCLA6x87dfzCzESQo947Sjp8BVETWFiEQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C8ilVekwjLg595aQ22PhANzjdcJRKsw0aHHSWrv2To0wW1q5P7DSr2+8UE4IafFfKo7hQLHK5T5mycOZMdugxZKwL2cE0qDnrteBec4Gl9dLzQBe5Z1qompN+f7xjBR2OGVQHPWwTyFOOvv+7KYyhT6D0doy6EiXUexbrLJy7w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=konsulko.se; spf=none smtp.mailfrom=konsulko.se; dkim=pass (2048-bit key) header.d=konsulko.se header.i=@konsulko.se header.b=rVGfQL00; dkim=permerror (0-bit key) header.d=konsulko.se header.i=@konsulko.se header.b=/mmLDvlU; arc=none smtp.client-ip=46.30.212.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=konsulko.se
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=konsulko.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=konsulko.se header.i=@konsulko.se header.b="rVGfQL00";
	dkim=permerror (0-bit key) header.d=konsulko.se header.i=@konsulko.se header.b="/mmLDvlU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1758692777; x=1759297577;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=ceNeCilvWmvDqFapyK6FLjZjj+QYbrWfVKvkUR9mCAg=;
	b=rVGfQL00k6mSUNSSGnPAcEgyLaqqLxakIkTBof7Q+ftRDBwFHkbG/9DvMSEtvd2QCb8SOYfOBPxCR
	 N5/c6JN5n/HnV+4qkGDX1ngTXGp/tF3TEUcxUg0vKm3iUEyc0XgbWvfEFAPwnmVu+yH5NxFGapMKDD
	 WP8LPoBLSH10+RttR/fQ9K8HeqCkcWr7BUN41EcqFWtw8hpj1gkQGryZuAeBqq+Yjmx9Zx8tLgJOK/
	 o4KujiS68eGAdlPKkVZj3ahR6OBh46vwT43ijVv4aiD7rUKPf8ubyBnA7P4JD7X+kivX0siJk0C+O/
	 xGhiwYI+m8gABjB3zavHgzN4JkLZD0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1758692777; x=1759297577;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=ceNeCilvWmvDqFapyK6FLjZjj+QYbrWfVKvkUR9mCAg=;
	b=/mmLDvlUG9BCiHooLMXQhGuhyg6nbm5ZccML5W5+71RMPj83kQaXBl75QOy5lV5es2/cebmJCOEfN
	 KGadZpNAg==
X-HalOne-ID: c83fe29a-9909-11f0-85ca-fb5fec76084d
Received: from [192.168.10.245] (host-90-233-199-55.mobileonline.telia.com [90.233.199.55])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id c83fe29a-9909-11f0-85ca-fb5fec76084d;
	Wed, 24 Sep 2025 05:46:16 +0000 (UTC)
Message-ID: <aabca3ff-3cbe-468a-9b65-290d5239d987@konsulko.se>
Date: Wed, 24 Sep 2025 07:46:13 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: rust: zpool: add API for C and Rust
To: Johannes Weiner <hannes@cmpxchg.org>,
 syzbot ci <syzbot+cica6a1c285444b25f@syzkaller.appspotmail.com>
Cc: a.hindborg@kernel.org, akpm@linux-foundation.org, alex.gaynor@gmail.com,
 aliceryhl@google.com, bjorn3_gh@protonmail.com, boqun.feng@gmail.com,
 chengming.zhou@linux.dev, dakr@kernel.org, david@redhat.com,
 gary@garyguo.net, gregkh@linuxfoundation.org, liam.howlett@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, lossin@kernel.org, mhocko@suse.com,
 minchan@kernel.org, nphamcs@gmail.com, ojeda@kernel.org, rppt@kernel.org,
 rust-for-linux@vger.kernel.org, senozhatsky@chromium.org, surenb@google.com,
 tmgross@umich.edu, vbabka@suse.cz, yosry.ahmed@linux.dev,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
 <68d2cfc2.a70a0220.4f78.000a.GAE@google.com>
 <20250923215929.GA1122379@cmpxchg.org>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <20250923215929.GA1122379@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/23/25 23:59, Johannes Weiner wrote:
> On Tue, Sep 23, 2025 at 09:50:10AM -0700, syzbot ci wrote:
>> syzbot ci has tested the following series
>>
>> [v6] rust: zpool: add API for C and Rust
>> https://lore.kernel.org/all/20250923102547.2545992-1-vitaly.wool@konsulko.se
>> * [PATCH v6 1/2] mm: reinstate zpool as a thin API
>> * [PATCH v6 2/2] rust: zpool: add abstraction for zpool drivers
>>
>> and found the following issues:
>> * BUG: unable to handle kernel NULL pointer dereference in zswap_store
>> * KASAN: slab-out-of-bounds Read in zpool_get_total_pages
>> * KASAN: slab-out-of-bounds Read in zswap_store
>> * KASAN: slab-use-after-free Read in zpool_get_total_pages
>> * KASAN: use-after-free Read in zpool_get_total_pages
>>
>> Full report is available here:
>> https://ci.syzbot.org/series/e8b22352-ae56-4d7c-9113-75573acf2b64
>>
>> ***
>>
>> BUG: unable to handle kernel NULL pointer dereference in zswap_store
> 
> struct zpool {
> 	void *pool;
> };
> 
> struct zpool *zpool_create_pool(const char *name) \
> { \
> 	return (struct zpool *) prefix ## _create_pool(name); \
> } \
> 
> u64 zpool_get_total_pages(struct zpool *zpool) \
> { \
> 	return prefix ## _get_total_pages(zpool->pool); \
> }
> 
> You create the zpool by simply casting the backend pool, but then you
> deref it twice as if it were an actual container for the backend pool.
> 
> I'm guessing you didn't test this even superficially?

LOL, no, forgot to run git commit --amend so came up with a wrong version.

The Rust version is correct though.

> This also still proposes an API with no in-kernel user.

That's not correct, zsmalloc is the user.

~Vitaly
