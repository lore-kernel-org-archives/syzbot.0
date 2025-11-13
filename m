Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2FB347BC9
	for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763052526; cv=none; b=oBdhm1BJWPOK4i8N3m2lDxqNSn35yrc+0HQfKZgPsB5c9P7JEGCJsb4y79OgpK9wfw0PX31sZzKI4KcQeFmsfdLqK7KzzVqZpQTlei6OWnQ7COUr8cHCF6tdD4WKiAi70I41BcQcp3k7IUQVUeAhJcj9ngekW3WBaoF+29VBS5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763052526; c=relaxed/simple;
	bh=GcQCJjua/D8mklX/rr0KMH+1XU9pj8X0cJnaIhN8pj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbgIbTAmNjE7ScSYmQ6WpEsH6IvlzLDuq7+BNimbRcu5UqvSAkQn/cxWmYKNjvbT1lOTalFPAjFkaQvxCj6EG13lwffixdF1L01yW+616FSaoQjzxNf1k9SErCUHf3zICJhkyJNUq5B4MdxlS6Z71fPTt2c6bRv3/uP97yRD450=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bCZZ3+D+; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bCZZ3+D+"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-298287a26c3so11904595ad.0
        for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 08:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763052524; x=1763657324; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KtBw2QaKFUcY/ykNwr991VNkMXbEXUIubxDUCz9u1I8=;
        b=bCZZ3+D+sxp9UsUOa5IHkTjH8J3l5nfjulXuWW/41Xffq44DkF9Zgkb6f9ucpvCERl
         Io7uMSWqF5veCsObkKpQiTJBfUC1JrZjEvgPJwJyAO6i7g9Nbc+x/6KbSgWgFexHv8AG
         FboCIIeCAeUVP8BZ4WhMxNdhZ22JzQswOqXS/Qo+6K2O2UfXaGfBnATYI+oevCiPQqiC
         oCP/nDAMR288nyqX6JcUwYGQGYVeeCw5sJondovC1bFWQ9dNupUUwQRrM5vnjBexoq7n
         kAHqavG2BsVoa2tguFU95IxabCUJlY88R1xT/mfpOk9X5Pb/+9bAHpGteTcY3/KtEKaS
         +9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763052524; x=1763657324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KtBw2QaKFUcY/ykNwr991VNkMXbEXUIubxDUCz9u1I8=;
        b=vdXBY+u/NvfQerrvel3e6dLqUqEtSVESXDrvyT/zv+3alm/nqioI3E/nCH/aBHKil7
         oJn/+XOLy9keScq7OU743/G3BeZDxb9ymTgrLU8NZSZpbL4LT34J3yWLpUgXEg4vK/WT
         WZzAq4MZFZqU8sHH6sV1Ju+SaD6k0FEWprwgwrixmuaYKwZNtJVOy/jEAXC9veaMkrzZ
         mV0qn9EZ6EbEiP6Q33+np0KkmscAsfcRzstSNAi+vBjQwn6mlh+GQCvavVO4gBCrcTRR
         qDI21cBT4zXxtsloKGa3iG499+i5BnHu5u2JFvuq8elc/uIB3fUtPmz/nWVTVU3A6aeO
         MZHA==
X-Forwarded-Encrypted: i=1; AJvYcCWV9YG1uOe+byH+VwE2eKGLA+mvpDGDVPyzaa21v9LtsIPX0PCGnBt/drZMf6sxnTi/5fppFVg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDHuiV61eSaWr4G+dGW1IRs1EBsCpP3/TthHKScgPriLkn4KuT
	VKRfOEOGM1kwJprJwVYyr3g8xw1MpXW5tFSx/r1WUi08AoCGztdZ/cB+
X-Gm-Gg: ASbGncuxt7GAmyqHGlVpBwmHE5Pyy4kRMEUftidwF5tMTBmDkq0idVNwE19SMf7n7Fz
	wkYbWTX4CHoG4ohqHciJ+ZlwWa/WnMwZL/SqAAe4DTYtQe/ot2CYERQHrLjEWV1IeBGbVTkB0IP
	bJ/YMmZGwC97/anbG3lWakSnIJUVByHguceNDavp6Mg9PRddbh4iW3OrLnNkHIJl98szeWfDIFE
	juuhepLmQg17gh3AcG7fBsFUnGR3Y3/0rLrh4CyZHvyAm9LlSA+NJ219J4H1NasKHmLaBrNffmc
	eCAnA1CFhCHxG0avfHqD4KAqRyZPUoBxKCZdKyoXKbPnk/HMPpLXJGWfUGz6Idts52V6ocmuPjd
	mQcWKbLerj2TnN50JPWL0swoBDGMlPiZSJuH1q3WH8C/RLdCPSTgoJmxTFuC1Kw1O9+qr1TZgdZ
	4tCW+8TO1q+kn1Ll9QMrcrm2jyodjKU00D
X-Google-Smtp-Source: AGHT+IHeub5aNCvnanVAkTfvVdmm0rKNrZXKV+kknwHxz7AyPMKPAPWmPtn/96i7E7eHSTeZ/nnwWQ==
X-Received: by 2002:a17:902:d551:b0:295:82d0:9ba2 with SMTP id d9443c01a7336-2984ed7a01cmr100922265ad.1.1763052524113;
        Thu, 13 Nov 2025 08:48:44 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2bed2esm30948585ad.81.2025.11.13.08.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 08:48:43 -0800 (PST)
Date: Thu, 13 Nov 2025 08:48:41 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, bpf@vger.kernel.org, hch@infradead.org,
	hch@lst.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRYL6XVX5pfhLqBX@fedora>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
 <69158bb1.a70a0220.3124cb.001e.GAE@google.com>
 <aRXeK_C44xGb3ovg@milan>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRXeK_C44xGb3ovg@milan>

On Thu, Nov 13, 2025 at 02:33:31PM +0100, Uladzislau Rezki wrote:
> On Wed, Nov 12, 2025 at 11:41:37PM -0800, syzbot ci wrote:
> > syzbot ci has tested the following series
> > 
> > [v2] make vmalloc gfp flags usage more apparent
> > https://lore.kernel.org/all/20251112185834.32487-1-vishal.moola@gmail.com
> > * [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
> > * [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
> > * [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
> > * [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
> > 
> > and found the following issue:
> > WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> > 
> > Full report is available here:
> > https://ci.syzbot.org/series/46d6cb1a-188d-4ff5-8fab-9c58465d74d3
> > 
> > ***
> > 
> > WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> > 
> > tree:      linux-next
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> > base:      b179ce312bafcb8c68dc718e015aee79b7939ff0
> > arch:      amd64
> > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > config:    https://ci.syzbot.org/builds/3449e2a5-35e0-4eac-86c6-97ca0ec741d7/config
> > 
> > ------------[ cut here ]------------
> > Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> > WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#1: syz-executor/6079
> > Modules linked in:
> >
> Again bpf :)
> 
> GFP_KERNEL_ACCOUNT? I saw there have been __GFP_HARDWALL added already,
> IMO it is worth to replace it by "high level flag", which is GFP_USER.

Yeah I'll replace __GFP_HARDWALL with GFP_USER, and add
GFP_KERNEL_ACCOUNT. At this point I'll just add GFP_NOFS and GFP_NOIO
as well so its easier to understand the mask.
