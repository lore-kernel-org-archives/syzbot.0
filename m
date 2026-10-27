Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793103048;
	b=zhEebPRSopshECSr/XXruLUIeS/Vq2CTCGLbLba0EUkfuC5WetrgtXvd16p+nlZKaqxq
	 HyyEl0yBRxKu7QF18zaCzeQYxjZ8o9LsCwhhHBpXxunZeVj7DMfTooWOaNPWXgCbMCpfH
	 WcydHyGW/VbpwpAoXlnyPmyH1ScBllLbdqRR36ocNWVxKR+oYGh0DsE6I8QpffMPOSHLo
	 ib4mjdyTb0+ko+4jFRizFXtK1bTxQizDY/0Gq+N9vr/jJ5tb70MUYyIiyz/OW/XrM8l4L
	 ro8mdPKurTW0riYVsncxu+fPE+TFzBaEPjV55+2pX49XH5WlMjoXBM7xFKedvnEPN8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793103048;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1VQjrw1Euxi4TbH9hbPniZhHv8s080YQR+PmEDM4C/c=;
	b=SRHoby8Az3UEZ8gRSoOmV5jsOu8qg7B2d1vndmZdqGLmkCjYQScpMOy3r33SU2mncv+9
	 xAPU363EKoGjCNUjGwjiwB1nUvEw/LYeDBELacphCr7/WE66IEenPNAcqksoz6SEpyl4w
	 4UZBCyukkSxOLZRNVgh6qpZUpLaVQHeZF+F8HA8BvQIKyCPTb0Qri/nyk/pIIzF0Zk8Ht
	 HsodxPeJrSqtYv/A4l/D//hAiKZuYv+kAMH91HVRGOY/HqHFvUTUs+PROFI7bvJlUPEAk
	 zY6eEsJEPmIZPvfcCS4wm8lz4Udtwbfm/L42X0pnHOvpTRzHsKdcGXVpcf2UNgrFjRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=hackers.camp;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928BE606A321
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 12:10:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 928BE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48afcb1e5f9so583595f8f.2
        for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 05:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793103046; x=1793707846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1VQjrw1Euxi4TbH9hbPniZhHv8s080YQR+PmEDM4C/c=;
        b=rAs9ONdSihlNf+Jq0SQvz6cXMM7F51ORYdmliVki2kSL3AUkBodx5s5dc0NfjVneji
         Ogjr5s3soQvY2wBw2+0IcfvnH/RN8RHMRxot2kzaz/B2hXbVds0Y5HNmdYRUYJoxA2og
         eLfOhhPMzXNJF/5aiYL0Q1K8CWh23xB+VNP+GyY4Bo2wKzHcvg+d8ZTgqRbvS550CC5T
         eEiP6PouK8UvCE3u/wFjzfNsklBiFe0AIZdVgeQdzBMWbkHhvKrtKMZKVyshyB3lruB5
         UUF+WlJfZrv05kvBbaiuTQ13bD5Jzg47NZhEPahcifOxCEzJyImWE3Hpi4JwdARtb36V
         rQ1A==
X-Forwarded-Encrypted: i=1; AKwUvBwSUyZeHVyn0cTgBTBJo9IliE1KSEaJsJpUhRkb7dCtRpey54PndwPa+4n/PYgDxvg0hLZOzYY=@lists.linux.dev
X-Gm-Message-State: AFq9FYKx1Dgf0qOJETeFgSmjPO+gsYhbfGaThImGpJN55H3nasTHjvEQ
	aYdjcMJEu4J5cRnsZ0R37omV8hAhxDZ8+Ibq9S1amaxJXOfpeDLf1KWM
X-Gm-Gg: AYBFou1mWxQqxzaSVu5J5XBVRTlRXQMuyuLkXq+3GZlm0tMsQq8kOvU7agwR9Nkdqr/
	GElELziijULuUx0cRdbIJcQTqC+9+9LjtNkSpL5DGS55SCH1pa0KiWlv9ehi+ZWWEXkYRpL60cx
	h2beP4jRkIu3/Y7jmpmtkR5qgQMWkYoicnOmkPWniahpF4Of3DiVc/6qXnuh3stcVtK87I3hpUy
	+JUHs4iOyWkHpEKlDIH0wGi758ldyzxuts8BOO5U2on1kOZ3hVcigNNsYwDZDRVWeyz1aRpjGe/
	fr/Esu4xE87kMbkAlYoOnS5Km7jksy2BTDt6jZu8/wFgY9+s6Ja/ZxWeTPxOQXQIZOUTbP2n7sD
	SIQiFpfs02dAAadqrhr+m1luVjaYDtbVIpIuSh4K+xJWoQ61UmGF9L4cq7UcsgH+wYIV5PJknrv
	vwiNi1MmVQZ75YhagVNaxv0nedyUtzP2aW/gVzYt+dL7RrmmZYwwfEiJnJsq+PFnB1pm1FNPJqN
	e+zYW5aLcGbT22v+L6LqGUvUfIP4h7ZHlBZnpLCdquq9DoegVB9XG6C3g8oDufpPpcuG3PwdTA5
	ZGAVdoy+zPpy8pdwUQ==
X-Received: by 2002:a05:6000:2406:b0:48c:6611:82 with SMTP id ffacd0b85a97d-48e3eb2b637mr20593069f8f.1.1793103045646;
        Tue, 27 Oct 2026 05:10:45 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3eb8f387sm22239473f8f.4.2026.10.27.05.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 05:10:42 -0700 (PDT)
From: Aurelien DESBRIERES <aurelien@hackers.camp>
To: jack@suse.cz
Cc: brauner@kernel.org,
	willy@infradead.org,
	viro@zeniv.linux.org.uk,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	aurelien.desbrieres@gmail.com
Subject: Re: [syzbot ci] Re: buffer: warn when a buffer is attached to a second mmb
Date: Tue, 27 Oct 2026 13:10:41 +0100
Message-ID: <20261027121041.68485-1-aurelien@hackers.camp>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6ae064e5.768774f5.3237ab.0015.GAE@google.com>
References: <6ae064e5.768774f5.3237ab.0015.GAE@google.com>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue 27-10-26 01:46:29, syzbot ci wrote:
> and found the following issues:
> * WARNING in __ext4_handle_dirty_metadata
> * WARNING in fat_add_entries
> * WARNING in fat_alloc_new_dir
> * WARNING in fat_remove_entries

Jan, thanks for the Reviewed-by. Before the patch goes anywhere,
syzbot answers the question it left open, in two different ways.

The three fat hits are on crafted images (two of them print "Invalid
FSINFO signature" first): directories whose clusters overlap, so the
same buffer is one directory's and then another's. That is the
multiply claimed block the cmpxchg comment is about, on-disk data the
kernel does not control, and a WARN_ON there will be filed as a bug
for every new image syzbot finds. If the assertion is to stay, it
should not be a WARN on that path; a ratelimited pr_warn naming the
device would say the same thing without a splat. I can send that as
v2 if you prefer it.

The ext4 hit is different. It is the nojournal branch of
__ext4_handle_dirty_metadata(), reached from ext4_xattr_block_set() at
the "reusing; refcount now=N" point: an xattr block that mbcache
deduplicates between inodes, by design, marked dirty through the mmb
of whichever inode reuses it. That is one buffer on several inodes'
lists in turn, in ext4 without a journal, the shape the warning was
written for, and the window in mmb_sync() applies to it. I have not
reproduced it outside syzbot's repro and do not know ext4 well enough
to say what the right fix is there (mark_buffer_dirty() alone for a
block with h_refcount > 1, or a list of their own, as we did); that
one is yours to judge.

Aurelien
