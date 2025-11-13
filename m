Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CB93596FC
	for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763052862; cv=none; b=NlXivdHPawsA7dAyJhm/7iZF5cSdHiiFJSwYAdcqD2CgSENl00vm05/7oMLx93bQPeRRvZq859ruy9T3PKedVEJSzyQIGsuFTCCOVFs6dZSdrSm7EBhsIq/pvKrJ6QKyzcplOC4riHmQmpE3jvdJp09xtiZp+fmIz0C2vKwrtd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763052862; c=relaxed/simple;
	bh=XQKSNRiFdFgqas04TlGNKyX+jgREILg+oYD/Bn1ut4U=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFlvkwd6m17feyKp7UBWi6SRm/pQsoLQLqbPer1R/nWgp6x4Ce5hkV1ay0DN3cB+8DL70+fHFsaHB//Oj6FL5DhLeBvSJCYzsHppIW9ZClYuEVudASNv2zN0BRgLq6sibeUIZ7mhkrFM7wZ3oxy2L4XMDBXhvYEQhJAksCsA+Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R+yLQRHM; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R+yLQRHM"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-37ba781a6c3so3825131fa.0
        for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 08:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763052859; x=1763657659; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=etMtDfwD+3QZuYUqVZKqjI6mrl2ackYWEvqoK5GuUAQ=;
        b=R+yLQRHMWX945pgRqeOvHTS7EOu81VwfAMvdFKpnkOeynejkMXYs8UwXqwdM2gqHPl
         SMNMFwN/+vqNBhxdwEB6RdbRzYpySVYeJ/wuK658ZRMxOWsUNbvl1JLjyCfWbOtVx/9O
         arcW+e5dCw6nAS3W2wM1jY6/meJTF89Tpwyw6YC37/K16MdhNe4KBvXBBL1RL0fw7VYK
         M7FertqNDHOZfcGdwDXjFh9GAx97c6JnGqM3bRTwe7dUMngIUiZmyByFF1UpgjUzyTOM
         AiP85zaeGGRs9eJOah3BA4GhwTREhmOo040jMfAitxdx7A33cRiAYQMODBqADWe92BNu
         CFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763052859; x=1763657659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=etMtDfwD+3QZuYUqVZKqjI6mrl2ackYWEvqoK5GuUAQ=;
        b=mLFygX732e2OI9J7sOvQwUrXpKArTfJh/jJc+/fWNJMs1QqENoLMVyEUBwbZvCMxpC
         a65tzpOdxm7ug385PB+N4qv/s65vyMN1A7oI5iXNo2I86lENI+vvq1ajfafDCAaqRIy8
         bCHDpeiUIMd5ugop8K3V25s/HQGNFGEIS/mYBfAdPbXBskpHrU8imhrhV+WNUntlWLdG
         j4sYbTdlmU09nIVmsz0nY27Z9rN+hiwudpIRDyIWGoTQ1gONMfOg5/EScCePEHdkXC03
         I1MfAQ61g4z3npNrTXi9FWgnsDdGfgbwxKk1e1N+ddmomPBITkPC01AbWZfLS7O5RInH
         Ay3g==
X-Forwarded-Encrypted: i=1; AJvYcCWMGTl3QycodT8tpcUjbBZL0GpuWhbPzKHSb1Qco6QYYwhT3OsHua/b3QG1l4DCVZ2ld1k0e6s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhK+0NRMlKm69syQ/9THVsxmb/iCXqmJNGMuxr59nt8Im3pQOg
	MK/2rvX605Loli9ZUGBYP/j1Kgr+IFHKapZw1s5WTb15MnZxTtLxQ2Gz
X-Gm-Gg: ASbGncv/I6F2TfwBRoJx1J/qC6zEF+a7j+U4MOvK64DL7/76kJVpZ07/Ydx9SeviIUB
	P7sS/K2LukQFzyRf5VVXcQ5Khvl50GQkpfMJXCCliE/lLIjymbeV4UxA4RlxplVkK+1B3R2Dje1
	8pnPgXYMV2eZoL0z2LYz1LpunzvnoZu5vvC6UqEtwQHjYkbwYWuNDWBl6HTZ/VpIVfApoIK24ai
	kpbAuBdlxkHzMOU1xRuEsxr8FrN6t68KlDRJ8xzGsJKGXizGatzeGz4zUqSxjr4ezh02S9nMLD/
	GNONokGLYp5uzmBg8aL3onUJmPfijaHcCn6hU5NfG+iH8uB6+/dF/HodB0J35AW5GwAIpFO/jg+
	vbUTDH3sPR0VvSVTh1GD1+YBhcuWfrOvrFYSm9SDSR9U=
X-Google-Smtp-Source: AGHT+IEPT42mAJ6MUQqgjo5ZM8rlqgnxDoAaqQlhU3CiG0tihICqar5Ppn5XfbeoxErgayfhRkMTWw==
X-Received: by 2002:a05:6512:b20:b0:594:35d5:9a1f with SMTP id 2adb3069b0e04-59584265411mr32340e87.50.1763052858346;
        Thu, 13 Nov 2025 08:54:18 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5958040576csm507458e87.88.2025.11.13.08.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 08:54:17 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 13 Nov 2025 17:54:16 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, akpm@linux-foundation.org,
	bpf@vger.kernel.org, hch@infradead.org, hch@lst.de,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRYNOIQ0A4g6BClW@milan>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
 <69158bb1.a70a0220.3124cb.001e.GAE@google.com>
 <aRXeK_C44xGb3ovg@milan>
 <aRYL6XVX5pfhLqBX@fedora>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRYL6XVX5pfhLqBX@fedora>

On Thu, Nov 13, 2025 at 08:48:41AM -0800, Vishal Moola (Oracle) wrote:
> On Thu, Nov 13, 2025 at 02:33:31PM +0100, Uladzislau Rezki wrote:
> > On Wed, Nov 12, 2025 at 11:41:37PM -0800, syzbot ci wrote:
> > > syzbot ci has tested the following series
> > > 
> > > [v2] make vmalloc gfp flags usage more apparent
> > > https://lore.kernel.org/all/20251112185834.32487-1-vishal.moola@gmail.com
> > > * [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
> > > * [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
> > > * [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
> > > * [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
> > > 
> > > and found the following issue:
> > > WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> > > 
> > > Full report is available here:
> > > https://ci.syzbot.org/series/46d6cb1a-188d-4ff5-8fab-9c58465d74d3
> > > 
> > > ***
> > > 
> > > WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> > > 
> > > tree:      linux-next
> > > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> > > base:      b179ce312bafcb8c68dc718e015aee79b7939ff0
> > > arch:      amd64
> > > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > config:    https://ci.syzbot.org/builds/3449e2a5-35e0-4eac-86c6-97ca0ec741d7/config
> > > 
> > > ------------[ cut here ]------------
> > > Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> > > WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#1: syz-executor/6079
> > > Modules linked in:
> > >
> > Again bpf :)
> > 
> > GFP_KERNEL_ACCOUNT? I saw there have been __GFP_HARDWALL added already,
> > IMO it is worth to replace it by "high level flag", which is GFP_USER.
> 
> Yeah I'll replace __GFP_HARDWALL with GFP_USER, and add
> GFP_KERNEL_ACCOUNT. At this point I'll just add GFP_NOFS and GFP_NOIO
> as well so its easier to understand the mask.
>
Sounds good!

--
Uladzislau Rezki
