Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2580518E3F
	for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763040817; cv=none; b=r1mAPtzHyvymBHvE7PWUAkmvdZjqbF/B4doy5B0RovANMRw/Tcr4433R9Oko7WDmIlMQHMXzokXe41jJ6SqWGuzCl0B4DX9C7QLTwOyhcWm/aU2Z57KAZbm+BsD1WsuZ8vWMUZEAi1h6GvsUx1LjyMF1nyBFzXH3BhRLGUK1omQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763040817; c=relaxed/simple;
	bh=JoJN7+tJKIXlTim12KYLa40sY14YfzETVU9Njrvls9M=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SuqJeJYuA/dbX3obEDETIucEIvCr7jMG9iOE7gDp4OZg3Qaky7IU/sjBV+lYjPNiHq0ZgAwz9S+1vic6Fc8gGUO1nI8FQ8WhGKeIr7/ZdhmhX8PAXO/7SgMAAuGiF8UzRC7jc529iEUQWCqfM7X/V4pSlSBVkJBzd82t1SwWZwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ltIRSSPN; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltIRSSPN"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-595825c8eb3so427053e87.0
        for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 05:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763040814; x=1763645614; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MhHd/vd5PilZlak+JY6GVryWSDKciGyRf9y3293OwHk=;
        b=ltIRSSPNL9hDpTkBcBRbuu9nAeysRAzED7X3VvVmAV8t9EdUZW/w4KdMoMCLyyw61z
         +gIArIxCLs29xxI+xbSz26hvtq0bVpBIZIGHqeAuSRDnhYyKFnsGKRrQSiEHLQg4cbTB
         fSCie5yP2YAGf5GuYGY6wH79u1M8s9e+fFk9KOxcYRi2UD3ka8N5a0II7LV8IQCbpQaB
         hkp3ANi/2jnc/gcaXAPGIHirjGrrWLkXObiv+ls3yZCVol3PiY6fUguBSkMkyGgP9HIL
         IMADZpMcDgvhjQIj9BJTIPgPnt0ASwfHDobGLXED98BqggWZugxFUscKdXLaibZos1i/
         v+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763040814; x=1763645614;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MhHd/vd5PilZlak+JY6GVryWSDKciGyRf9y3293OwHk=;
        b=K8BdzpxyfNwrV2wUCyCoCwRntypyDUoFG284TILe1xdERjqBeFc/s1uAkVGzth9Or1
         REJlm4zz/FfAGvxc9kjAQ4rk+uQZKzo+l1PxD/JjG82TZEWBD4Hb/IXEZfh7n7X2z0iR
         OryFhRqJIuAT+6ntU3+zp2CrQ9oiv9XnDZXzyuLvv8urV3wiiKlWkXoryUotjALhT9Ay
         lyqHLgfBJMcPupQ9XLp2A2OmyA2LCStqqJCHxuC4IdhyYJACWAyiugiGBoYS304iUgwN
         ADcCq7l7++PI5n1e1rnvEW8jxU2x46ittnhJw/V3BJkEPRHWeV/lcsYECAQPsvR3ydhI
         I7wQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1N4Zgs1ZJ4ii4eu0fw1nAAUZT/BgKB8CPJQ6baWtt/HCbRJd34XBHmaByLbvpQqrc6UVHZEE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkEt2BWrcnEaHetURMAsg4w/9O2QRwjj7PP48FendX02wTzeOv
	dYhwVL699fR7cPzZYyDXbyDU5noD8DX+DRpwDhZgkN7X+cfDt7Zrgdlj7cMwpK3/
X-Gm-Gg: ASbGncvEXOuUPmKOj0n/4xDcxGGF+uUEQg9F1nCSIg2vAyLhtL1rF8SuzBS+oH5eQnH
	vo7ZaCur+9z3Yd78ubTkA/31p0nFJ+XBr8pkx87RYxFMtBuSf7dHhoD4prWJ/qvR2AL2W+OiDNj
	3iPowmhBfNtM99nMOjIDOQ9AAfIW1WEVlP4zc2EoH6pNZMMdCOGl1TpaKSPc95kVyUycI3CAzUZ
	Zcv5KGNjTnVE36IGCVSxtdlgS9rqa/nNRJQrGm0wKlDqpFuFe/7hhgGLQfcFQqXx3y1EhsL+o9Q
	5t3PzwMl6MBTVcR9Z4Mk/nmPMBxSqDZRBFmXObWXKCFg4MVZZPnunsSdjwI78BfIDrgotS/2ftW
	ibHJFXKkPp52e7UaYsePLv2iDfLg4m8DSNMW+dmY2+14=
X-Google-Smtp-Source: AGHT+IGUL4qC6K+DHAMyAznh1nPqOVVG3vBedGscK4G1HhCq8iWh/Gjrhh8TEulXo726uPx2/aO9Jg==
X-Received: by 2002:a05:6512:b85:b0:594:34b9:a817 with SMTP id 2adb3069b0e04-59576e19be4mr2460400e87.33.1763040813955;
        Thu, 13 Nov 2025 05:33:33 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595804128c6sm394619e87.111.2025.11.13.05.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 05:33:33 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 13 Nov 2025 14:33:31 +0100
To: vishal.moola@gmail.com
Cc: akpm@linux-foundation.org, bpf@vger.kernel.org, hch@infradead.org,
	hch@lst.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	urezki@gmail.com, vishal.moola@gmail.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRXeK_C44xGb3ovg@milan>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
 <69158bb1.a70a0220.3124cb.001e.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69158bb1.a70a0220.3124cb.001e.GAE@google.com>

On Wed, Nov 12, 2025 at 11:41:37PM -0800, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v2] make vmalloc gfp flags usage more apparent
> https://lore.kernel.org/all/20251112185834.32487-1-vishal.moola@gmail.com
> * [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
> * [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
> * [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
> * [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
> 
> and found the following issue:
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> 
> Full report is available here:
> https://ci.syzbot.org/series/46d6cb1a-188d-4ff5-8fab-9c58465d74d3
> 
> ***
> 
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      b179ce312bafcb8c68dc718e015aee79b7939ff0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/3449e2a5-35e0-4eac-86c6-97ca0ec741d7/config
> 
> ------------[ cut here ]------------
> Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#1: syz-executor/6079
> Modules linked in:
>
Again bpf :)

GFP_KERNEL_ACCOUNT? I saw there have been __GFP_HARDWALL added already,
IMO it is worth to replace it by "high level flag", which is GFP_USER.

--
Uladzislau Rezki
