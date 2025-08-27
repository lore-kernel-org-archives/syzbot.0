Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31836205513
	for <syzbot@lists.linux.dev>; Wed, 27 Aug 2025 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756305789; cv=none; b=ClGRM/6VutA0CSPNxUBV0FMXQvWfWp7Kg8QXFs20Bgxk5b9NpaqkEytu1INUjH1K9RlZOJStTlSivaLb/u7xM6zM//0s114cKK5I0gbBtRYWuK7tsZ02eFVoTku6tBBPw8XVaP4PVHf3SxEqQLAu3/6czLqxFEZH831yMyCjOfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756305789; c=relaxed/simple;
	bh=/Gts48DtUiDPZHvOfjSwkbYpBoSytZ5vAQDjZ8RXrzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lpppyg4wCIef03lrXQUPCBU2VZ706x9Yl6DmL6g4WRqzlJs2Aa5Rqvja34ZgyOJhoXfCaPXOi/m0iRiStxQ6tMERmgJL4svWJCIwHtFB7+Kv54mNMlvZEORS5adY5b04eMVmFpqDBYNxUA4sKg7+wnLOTu8oVWGgfyogyN8KaOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e2sk6+VT; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2sk6+VT"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afcb73394b4so987165566b.0
        for <syzbot@lists.linux.dev>; Wed, 27 Aug 2025 07:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756305786; x=1756910586; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7IZRDRVBKlmRBjlak6RScREmXVoipJRAnzz5R2AIjQ=;
        b=e2sk6+VTYFnbSMzFUqXNQdGvosN9SaTuugvMUxQXS8tS6OZ2RvdSLoXZP7B/Jlzrvg
         12g5/cfSm9GfrMz7sHI+7Zo9WPVfiuJxcLpVh+d3lWSLHMAsM3FrxMiJYMUauKbt2UDm
         bW1lc/HfEhJzOV+cy9s3Q4wA0pHFY+Q27/r/DHkf3QPIHd+ZPb8ob9DBxV0BBvjw/GVh
         dwp8Zp1i0pSW2SNdWgi/1hRv0VqfLTLXVu7Rcd/Sg6qfJKCqFRhi5b3rxrT5wAmqhy9c
         XAaZuaBYOIXtKnkY0FtVgy76TCtp/fCR6bhbx76ZVuD891hcv1JT3NKrA8R2B+AeHeZH
         K5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756305786; x=1756910586;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7IZRDRVBKlmRBjlak6RScREmXVoipJRAnzz5R2AIjQ=;
        b=nkVuLv2HqZ7jdkk4dvn2QDsgXaay1RYxutKBObBqdt5xnj/jDJsYnXD9GfjkI3WCmP
         Usw4vtw0HCpeYzauhb2hhCZXk9RXDV/GqRMuwTmbioV3PdJs8YL/ET5BQhbdQxilnmYF
         O+AGMIwIsoXKaKThFklCFILCjiJ1V4t5kwFLeSIs0iyu85C3pg06tlGpl6tredn3EHjF
         n6F44O33PZ/5nmIMLr9OoywnycLHtf91/SyEYfOGzBowanO8hAVJSbw6xEBBH4HSD5Dy
         pVVuUZ+dy00RHUvl3HT3bb0srfGLUkTvnXqNa3BNFGGfmp1Tgfl1Lw+ASMgqkrO7SbA+
         yfqA==
X-Forwarded-Encrypted: i=1; AJvYcCWQhPI45mMDcRMcewj5T/8Q9uh6vK2+nE45aZKFQDU09/MIGpH/dDH7CPFqBHaH0YryFp32xCI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxGRy0WGnAW8bmKCUXduRWzAl/zqbwDlop4VHC//uxcp+cvpdmE
	NpuyQWB9hIR1JVil7NNDfVAKTSAomdKCyojw7e/P4rtZ/hCBCWVb8dZV
X-Gm-Gg: ASbGnctu0ardTr3uKZQy/rczE62YKNRMAjNBRLXQ/m3OL/unC/xBY7/5RtQFbdfEEeL
	Nh+dBcIdjPCbZmFfpZAWyXs/yc+gDI44hZ9+0G4ADyhCXknkTAXBDbKJLRHeXmbczaC7yhANa2N
	Bu1Ahu2Vd5MUTR1elY8yYFFKZQw1kUEoIIgY4rq3PSFGHj+8honS5w66k2ddkU4K0+RjVZf1zxv
	W6j3nSYdNLBxgiSHLXwDwt1WVY7sXQ625PFnRHcQeXBcHKqDYedEZ2Jhm9i2HwYuNQM92ME68BT
	0Yc4OQkp/4WJFHXs/qwCJaZ3RQElChJsEDgMr8lGlA3ete8hS5i8x9xBiCNL8yzm2RuNohFEfjo
	5GEizY6Nz6yo05QNORF70TOEmLQ==
X-Google-Smtp-Source: AGHT+IHF4tvA56wSqinjDHbP9DHVeUfxBR/Yo9eC0OQJ9ac9gpPoPbPgaeKveEpnCMnZsoBulPK9bQ==
X-Received: by 2002:a17:907:94cc:b0:afe:a7f0:80e6 with SMTP id a640c23a62f3a-afea7f08490mr664160266b.33.1756305786378;
        Wed, 27 Aug 2025 07:43:06 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afeb167670esm328732766b.112.2025.08.27.07.43.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Aug 2025 07:43:06 -0700 (PDT)
Date: Wed, 27 Aug 2025 14:43:05 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: syzbot ci <syzbot+ci5d256d8b5e60a751@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, richard.weiyang@gmail.com,
	vbabka@suse.cz, ziy@nvidia.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm/pageblock: improve readability of some
 pageblock handling
Message-ID: <20250827144305.pecww62n7sjz2cbr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
 <68aebc03.a70a0220.3cafd4.0012.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68aebc03.a70a0220.3cafd4.0012.GAE@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Wed, Aug 27, 2025 at 01:04:19AM -0700, syzbot ci wrote:
>syzbot ci has tested the following series
>
>[v2] mm/pageblock: improve readability of some pageblock handling
>https://lore.kernel.org/all/20250827021121.13645-1-richard.weiyang@gmail.com
>* [Patch v2 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better reading
>* [Patch v2 2/2] mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end
>
>and found the following issue:
>kernel build error
>
>Full report is available here:
>https://ci.syzbot.org/series/51db4b94-ae73-4ea0-8cf3-4ea5b7715cf1
>
>***
>
>kernel build error
>
>tree:      torvalds
>URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
>base:      fab1beda7597fac1cecc01707d55eadb6bbe773c
>arch:      amd64
>compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
>config:    https://ci.syzbot.org/builds/49ee15fe-3add-4064-a3a9-1461fbba8c85/config
>
>mm/page_alloc.c:373:2: error: call to '__compiletime_assert_1636' declared with 'error' attribute: BUILD_BUG_ON failed: __MIGRATE_TYPE_END > MIGRATETYPE_MASK
>

Thanks, this is noticed by Zi Yan.

>***
>
>If these findings have caused you to resend the series or submit a
>separate fix, please add the following tag to your commit message:
>  Tested-by: syzbot@syzkaller.appspotmail.com
>
>---
>This report is generated by a bot. It may contain errors.
>syzbot ci engineers can be reached at syzkaller@googlegroups.com.

-- 
Wei Yang
Help you, Help me
