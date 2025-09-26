Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0F01F1538
	for <syzbot@lists.linux.dev>; Fri, 26 Sep 2025 14:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758896845; cv=none; b=kCy1VebqhO5q8dFGajj4NKXKCZ7pFc8ZW5uBtIqo3xjZDzo8uzxKp7YKC0WtCfKOvL7rxycqclNgD4ubVUUMd4HUVAZRlgz98RKf2RZjOEYWs/O4gYU9DaVFFtPvkqX+UBq0eSOtUkLwkK4eVBf59vOSnBSE/3JeyH+EhfvwVIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758896845; c=relaxed/simple;
	bh=K76jz/H2Fo2gmJVDsUiFqUdfhGl+kusT8vt5ziZsz1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wxy2sYxK3ag0Yaj8vheD2O+wMrTXO5eP9typ3AAfDPALG62SgcTS4QABJHpI5+L85iEYXQvPasUKKbgFnfVwFJKVr9yk9FpbuuhReVr0uUyeMJTDY5Xq/M9g4sE2ySdn7z27/u3uRvWn4NWrGNvaD0A7rTIvPZ0iLEsC3nCyT8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mHqFnV3z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=o3fzeac6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mHqFnV3z; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=o3fzeac6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mHqFnV3z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="o3fzeac6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mHqFnV3z";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="o3fzeac6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 223696886F;
	Fri, 26 Sep 2025 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758896841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MW2kEKB150iY4GBcI+DbTA9hS/ZtCe8tdNa+w40U92Q=;
	b=mHqFnV3zMZJf46R7B06/zjVqbSItZVdPMmyWUjknI+X0m0C9ZWCSh8zWXNb82Qgs6aLSiD
	AOt1P93PW6hDvoV1wVTpYxVOFHIrPefnNh0Zf6s2WMVGfLVBwcHEn/wwj5+FYsCXR8JaTs
	rvOkfxFxDs5SlK4UaVJzPA8/D1UEZGM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758896841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MW2kEKB150iY4GBcI+DbTA9hS/ZtCe8tdNa+w40U92Q=;
	b=o3fzeac6Gu3iBGiDSXNUY8K2BqXlWMT4JyYNT6Ce3MhnWhMW6qUpTH9dmglkRaWBEH+CRw
	64BSjjrMYOn4L3Aw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mHqFnV3z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o3fzeac6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758896841; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MW2kEKB150iY4GBcI+DbTA9hS/ZtCe8tdNa+w40U92Q=;
	b=mHqFnV3zMZJf46R7B06/zjVqbSItZVdPMmyWUjknI+X0m0C9ZWCSh8zWXNb82Qgs6aLSiD
	AOt1P93PW6hDvoV1wVTpYxVOFHIrPefnNh0Zf6s2WMVGfLVBwcHEn/wwj5+FYsCXR8JaTs
	rvOkfxFxDs5SlK4UaVJzPA8/D1UEZGM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758896841;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MW2kEKB150iY4GBcI+DbTA9hS/ZtCe8tdNa+w40U92Q=;
	b=o3fzeac6Gu3iBGiDSXNUY8K2BqXlWMT4JyYNT6Ce3MhnWhMW6qUpTH9dmglkRaWBEH+CRw
	64BSjjrMYOn4L3Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E36591373E;
	Fri, 26 Sep 2025 14:27:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Y9c3N8ii1mgybAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 26 Sep 2025 14:27:20 +0000
Message-ID: <3cbe68f0-c449-4634-b5a1-690b3eaf33ca@suse.cz>
Date: Fri, 26 Sep 2025 16:27:20 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: rust: zpool: add API for C and Rust
Content-Language: en-US
To: Nhat Pham <nphamcs@gmail.com>, Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 syzbot ci <syzbot+cica6a1c285444b25f@syzkaller.appspotmail.com>,
 a.hindborg@kernel.org, akpm@linux-foundation.org, alex.gaynor@gmail.com,
 aliceryhl@google.com, bjorn3_gh@protonmail.com, boqun.feng@gmail.com,
 chengming.zhou@linux.dev, dakr@kernel.org, david@redhat.com,
 gary@garyguo.net, gregkh@linuxfoundation.org, liam.howlett@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, lossin@kernel.org, mhocko@suse.com,
 minchan@kernel.org, ojeda@kernel.org, rppt@kernel.org,
 rust-for-linux@vger.kernel.org, senozhatsky@chromium.org, surenb@google.com,
 tmgross@umich.edu, yosry.ahmed@linux.dev, syzbot@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
References: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
 <68d2cfc2.a70a0220.4f78.000a.GAE@google.com>
 <20250923215929.GA1122379@cmpxchg.org>
 <aabca3ff-3cbe-468a-9b65-290d5239d987@konsulko.se>
 <CAKEwX=P18Krj-+rXvTSCocRt+Q3o07Ghisv4nJLRCJ8tLus54Q@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAKEwX=P18Krj-+rXvTSCocRt+Q3o07Ghisv4nJLRCJ8tLus54Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 223696886F
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[31];
	FREEMAIL_TO(0.00)[gmail.com,konsulko.se];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,protonmail.com];
	FREEMAIL_CC(0.00)[cmpxchg.org,syzkaller.appspotmail.com,kernel.org,linux-foundation.org,gmail.com,google.com,protonmail.com,linux.dev,redhat.com,garyguo.net,linuxfoundation.org,oracle.com,vger.kernel.org,kvack.org,suse.com,chromium.org,umich.edu,lists.linux.dev,googlegroups.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[cica6a1c285444b25f];
	DKIM_TRACE(0.00)[suse.cz:+];
	R_RATELIMIT(0.00)[to_ip_from(RL7z7y9whu5c77jgra59km7rz7)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:mid]
X-Spam-Score: -3.01

On 9/24/25 19:38, Nhat Pham wrote:
> On Tue, Sep 23, 2025 at 10:46 PM Vitaly Wool <vitaly.wool@konsulko.se> wrote:
>>
>> LOL, no, forgot to run git commit --amend so came up with a wrong version.
>>
>> The Rust version is correct though.
>>
>> > This also still proposes an API with no in-kernel user.
>>
>> That's not correct, zsmalloc is the user.
> 
> A single user does not an API make.

IIRC what was suggested is to implement the zsmalloc API directly. What does
the extra inline function layer get us in case of a compile-time switch?

And do you need the Rust abstraction or just can make it part of the zblock
itself? You don't expect there to be more Rust-based backends than zblock, no?

