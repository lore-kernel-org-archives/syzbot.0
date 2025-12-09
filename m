Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17542ED871
	for <syzbot@lists.linux.dev>; Tue,  9 Dec 2025 02:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765249009; cv=none; b=mLLHTNvOobmjAMx87tr/Ov0zWG+e7CqmVLFZRHtjgdVdt2Am68DKaGaWlrz7TyD4EGIcmAhidvgeDfS4Vo9Dh6h9Bus/nuBEiOBl4bI0HYLGYVMfuB/TXgS1hZ2PbPe9qVfQbEp7jZpKunNr3CaGmlyHN6fepCm0hony45mDMuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765249009; c=relaxed/simple;
	bh=3I5nGggm3x3yWKIbR239dsxXAbPDTOoj5moA0+uZd9g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GowKTlv6y13R9C4KgwXkCQb4oAHJJyfPFeU+OOA2hI6QygojDhvhtfCVfqQ0e3hUh25d+91R3r54X0lr1PsT8nQtis04ssVNNNK7+u1wznBoN974U83f6Jx3r+CbFfUcEtDZC1amsl1XkSg4F9LmdqSoX5AJIC8pxLhos0oTuXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U9Z5jzmY; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U9Z5jzmY"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47904cdb9bbso44174935e9.1
        for <syzbot@lists.linux.dev>; Mon, 08 Dec 2025 18:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765249006; x=1765853806; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7EaRFbH/Lf9R0V6I929pmeRztGDYkW9+BODBzkEPjs=;
        b=U9Z5jzmY+1uRxUbgaFtYIlHr0z3Al/hb6iICrmCO4l0LtnXiS752Q/UdBSkhQzqlQb
         zp1kRj0ifsDUjOTxNmOH0YjbXguk/3XRcSNtgibxBMuUUg+WHSF0kCy7Jbf+mZ4FnITN
         uqvgQNfqYL3OE+m7cAWIW1RAPHkg5G1YC/BUD7krAqm3J4SrK4nWhnsM4fgaU4/lzceP
         7JACVukN8fAOKW1RuIPa8s4QSiISjvjirSzM5rmV/oc+slYubz7M9AKOOvGb2UILovAa
         npYpJKeTJ7HH8GRyXvu+KbgwT/+HkWbCpjGQdBsLZ0FdBb79VlCJoO4GJz+E8WBQ/WKY
         ZCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765249006; x=1765853806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7EaRFbH/Lf9R0V6I929pmeRztGDYkW9+BODBzkEPjs=;
        b=IsQSfiRRK3Dusi/XodrKDqHOxPTnfE8a3DRBFLbDo0G0vhcXUbDiZiTYd9QeXPoz0r
         WgQmZ03CVNl96EMsK9U4bSXFttfJp1MGfcdK0xJgNweaT11YhrIzWSVoC4xOergAbTGf
         1dzDuzhim04mCTO1tCWfYXc1QzlTqaD5CRlOp7n6/X8+q+5h5fuBY2f2ENvZwoGyROYO
         sJOI5eQo3z8Hft2IsYO40gOA8vAcYHwcykYgG3vlf8ajned8PMk4LqtTqRA9TzhO3QJ9
         VrVGzCUmaWapWRkoYMoUXZiTqMvyeA/I4UZxZF+lbE6HLSkXC3V29dg+3IVcfP5Cr1+0
         ykXw==
X-Gm-Message-State: AOJu0YzOAinvRVIGsrtDG+PMnzKmV6ZiYm9H4n+F6o6KXX80oOo5jXFM
	LR826fGj0C0Xd65tL89b1Jnxbd13cMPKhzvRRTjKLJ/W0nLmcIWmuHGch1fuWJFdNpJizLnvnS+
	d1zBnfk6VtggmZA==
X-Google-Smtp-Source: AGHT+IFm5Kmha7smcDj9tIB+hArhWUM5gz1offBTp6XSE0T88cKajhMxGRylJyGmYxNi+7S5qT5lVih1B/u4Zw==
X-Received: from wmsm2.prod.google.com ([2002:a05:600c:3b02:b0:477:3d56:ac34])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:844f:10b0:477:9d88:2da6 with SMTP id 5b1f17b1804b1-47a7f987e56mr294705e9.0.1765249005956;
 Mon, 08 Dec 2025 18:56:45 -0800 (PST)
Date: Tue, 09 Dec 2025 02:56:45 +0000
In-Reply-To: <693691ac.a70a0220.38f243.009a.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com> <693691ac.a70a0220.38f243.009a.GAE@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DETCJPVHXE8O.2A2XQ73M2QOGK@google.com>
Subject: Re: [syzbot ci] Re: mm/vmalloc: clarify why vmap_range_noflush()
 might sleep
From: Brendan Jackman <jackmanb@google.com>
To: syzbot ci <syzbot+cie262549d3c7e101a@syzkaller.appspotmail.com>, 
	<akpm@linux-foundation.org>, <jackmanb@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <urezki@gmail.com>
Cc: <syzbot@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Mon Dec 8, 2025 at 8:51 AM UTC, syzbot ci wrote:
> kernel build error
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      3f43be96f919cc611dcb2a4e38dd464831f4513e
> arch:      amd64

Um, so apparently I didn't even compile this code for x86? Sorry about
this.

FWIW, I do test my patches [0]! Apparently in this case I just decided
to post it without actually checking the results.

[0] https://github.com/bjackman/limmat-kernel-nix
