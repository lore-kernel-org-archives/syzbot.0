Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3D63195F7
	for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762948931; cv=none; b=a8Zxh1HWs+PAjnwA6dgxUvReGmQ8ga2EDXOND2v/aKOwEaavBVj3PPL18Kmhm08kkQ4cS09c2ghiSlv7eI0GgNk2ZaY+iZ1rqkS24GCtbPfwVIwgDXEby/eTd0lCFM252B/YOZsHlvxKp739/MtxLG4rA+zJj5ON62cqsDuR53w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762948931; c=relaxed/simple;
	bh=4sUM7WH1+VY7rTzxu9qxTHMaY+e1s7RNkZKkLmmtrjg=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b11+fdTDj4//V6iEHTDzICeWBt6KxWDxT5UZ5fKTJdOZJQsyudAy7/jxJblo8+X/erai63/8kW+z4PufHhnWN9qX+FpOu0LtsS22XITWpPoeYg5bacPfXkyr4jP8BXM8Qsb/peLg3ZHSUFaBzrSIoRwrM3ZOJw1e1Un7BCxBiWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MVWrA+dg; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVWrA+dg"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59431f57bf6so674110e87.3
        for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 04:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762948926; x=1763553726; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eH+LicKzZZKQtDjwYrqOgwxCOyN5rsbgFwrU7hAVtFg=;
        b=MVWrA+dgFAfSY+uiThRG5A0R65PinqqCD10U9hG/wO53iL5Fu6/Z+25BmqnsfQENn4
         GyuVickGNxNQ9K8nXCL317zi8k0b8P48ToYA8fJ1Hsa+JbXfMM6H7iElto9gsJahvI9F
         gjE6KPG3yDIaurEu+aIAueeE2qEmzhdZLX8OVk7silSbwlqzUpl70H66c8yRn/9r8AWG
         rz0eRc8YlU8GHZl9imF0Y7teMqPcW2cBHwax9sDN+6UvfNAUl5qUl2oukZdzfAYfni/Y
         cg6hR2mATOuxvEChAe2uK6I1mDk3PaLuE/V5XkNwRLNpUugY5uMPuOC+YzTJyF4dUSdP
         BrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762948926; x=1763553726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eH+LicKzZZKQtDjwYrqOgwxCOyN5rsbgFwrU7hAVtFg=;
        b=Olt4HGEBliVHARkdg5RNER+scdyPK7ui7fqbjo6hmXOLiV7IgcbNfVU+MhXLEMPhpu
         snXXi+WvjSTe+7iL9kXLrbPqgzHsRiBUe8yubw7KrTmuq4efh06nB2jDVxShAy5ALCy9
         TiemNsjS8P/1dX6Ml2Gi259MpAcl+H8dPPMwTYF8+2hijvP7qUp9BuXbLN8i1EpcyOsi
         PfLuzCPA1D7+foGwvrvVY5Z6MOQDIpeCNDLZrf8oqeo3WBrDjhZoDG9xEtbmXN/WdMF6
         GHLVoT42Sogsyp4ZWFDKfYxqiGz8FlqF3X7d333YiZFDpmCgEDTiGRg+x3N81WAIyrQ3
         e5fg==
X-Forwarded-Encrypted: i=1; AJvYcCUG3Xecf2/JKnnbizkzQaXkSRT3ffAdzIkwFcVa3NQDmps50HwXge11i0TR+99trzvXA9xCVxY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmwRbKeT2Azb9RTbpjGjFWFgDvD4ovIEKJskTG0mAqrbRjqFLS
	B71GkeMk8+pz+CD1Gk6qgaUjk+sQ31+bU+muZea1bzxbXRHP/0uUp7Pd
X-Gm-Gg: ASbGncvmwYjw6RM6CnKzg878a+9I0ay0oAJzYN8XXkNj2oQSOKePLdmI+ud38S/n5O+
	7I2DnbPHQclnBqVV6puuG2tqbZKBTOgchnP9j2XGcjPvoWJq2x/6rSI1/MCHP47Bgf4HUm91Asi
	DTrpOsHocm0jvG/EZ4Cx++YzkLXv6sYlazHTI9+9tUjbi/VgEAitXAJXiFcTfZC/oLBYcW0LtvG
	WJUvf3GZcmRuw03VzEOW/o0V6nAW6dCOZjYbuUwWcYv4bvsyNIeVCMeRftsh/NBCXtFQdmT25QU
	XIgMOlmlsgllAEkbkfmWe9tzaJFwF5vYAPluC3WtCNUPEimmmahm1OG8tzK+Aro4Mc1n4X7W9xQ
	fszR9/bh3iQRFFd7vYga0pSdbdbHxArbju25wavHnABk=
X-Google-Smtp-Source: AGHT+IGeLcgI5bn0B3LCjEKOV3352o8Vh1fI0N1HmS2Z+2cWfmHBHleSetqNFG1K+QPTgI04aqR5aw==
X-Received: by 2002:a05:6512:23a2:b0:591:c898:e82b with SMTP id 2adb3069b0e04-59576dee887mr955091e87.8.1762948925597;
        Wed, 12 Nov 2025 04:02:05 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5957d7db7a5sm129387e87.20.2025.11.12.04.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:02:04 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 12 Nov 2025 13:02:03 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	syzbot ci <syzbot+ci9989da8336cb2bc7@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, hch@lst.de, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, vishal.moola@gmail.com, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRR3O7l2Ewx-VRoE@milan>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
 <69123b72.a70a0220.22f260.0105.GAE@google.com>
 <aROasppMPmek9Afh@milan>
 <aRQyMck_MeVvvCdX@infradead.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRQyMck_MeVvvCdX@infradead.org>

On Tue, Nov 11, 2025 at 11:07:29PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 11, 2025 at 09:21:06PM +0100, Uladzislau Rezki wrote:
> > > Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> > >
> > It looks like we need to add __GFP_HARDWALL to the white-list-mask.
> 
> __GFP_HARDWALL is part of GFP_USER.  Doing GFP_USER vmalloc sounds like
> a bit of an odd idea to me, but there are a few users mostly in bpf
> and drm code (why do these always show up for odd API usage patterns?).
> 
> So I guess yes, we'll need to allow it for now, but I'd like to start
> a discussion if it really makes much sense.
> 
<snip>
	/* plain bpf_prog allocation */
	prog = bpf_prog_alloc(bpf_prog_size(attr->insn_cnt), GFP_USER);
	if (!prog) {
<snip>

I assume that was the place that triggered the splat.

Vishal, will you send the patch adding GFP_USER to address the splat?

--
Uladzislau Rezki
