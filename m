Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC222C08AA
	for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 07:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758265567; cv=none; b=K+VQG6NDZ388x7I57vO5/BPFVwjrOE+euFWSCzdymuTVON/42oR6vVbvuQO1j8ljUK6X10yYC86yWZbitkIwMelGDwyIeTrpWvam1Arep3um+SM5j8kiHasKbKnvmMc2rSBBz8w9YZD+dqLKZUBFvZJV2bmOYx7NLZgsTaoUjV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758265567; c=relaxed/simple;
	bh=ItZKaGQl9It/js9gzPNXCsAEXczA+CYbzua9BHh+ovk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gFxppYKBVuaqrFjNOM1Z/tfl49iSEwJY31yTktCq56jdEuwpi/pwfViLuPEwbl+z0yvrM3beBTYQZf9kImjl3UvURSI/mK65HtF/4AzAr+nw2e8UuhEyvfJXUAmxBAIdx2rTu116JZ5nYHVAZVLxG93hPd9Iwo8wtttM3AenUEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AE4+VVtL; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AE4+VVtL"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3ee12807d97so1291523f8f.0
        for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 00:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758265564; x=1758870364; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Klo+L3KBBL4ssbFZ2YOqJt7BcxJ8M+dYCfYzeUYYBY=;
        b=AE4+VVtLgpatTSTUzspGOTpIYM909p/UpznHttQjQ6K9WHvPPsIjLf5s7st0io5iIE
         gixFHTcdI9ytsIyg7rrHH0LwTX/d7NUzgEfZFz1uS7n5E/I/QEecrlFpsl4UJ77I3giP
         ADCq/DN4ASrzIS3IVuPY1YpgnXtobWkCynZVyJJrfa/phWZgzFziJc4voR7ixxwCdO04
         W/L3Lvl6t9RQGYgPKpKqhhD2BbJw+BB+V8476uQtReZp7DSs1tQestwAdDklAWC91Cu/
         woXDiqhM44s+tmds2RzdjtbOZL0DvXVV9+pDRRHI9VYB40mKFQYTEC+CUBGzgJbIF8VQ
         +pJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758265564; x=1758870364;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Klo+L3KBBL4ssbFZ2YOqJt7BcxJ8M+dYCfYzeUYYBY=;
        b=jMUjJXjFYJtCbrwO7bz/jQ8Cygjj2+lvHd1QdhQDwAAksX7usQ1Jm3oKB9OkZqqlhf
         548nc9ydAUGY1nmXYveBHpqRbdIYfH/ZRw9bAqoCAOyvn6F27MOD4DPiHnIdjgcv+NnR
         55+MgmbJljOrA1MggdKpbxD1WzdNlcfgOcPtbgomxYTMSxHoLGQuWW94oximZuLMZTJv
         vWQPqDQhAMec9aySl04Q/BjZEhp2okPri9KT289Bvk1rpWQQRlp/AEfaUsrj/sxYQT0S
         ql4XiZYmtMJbX3tXY1sqSqGHoZ93BmR9jR2VA2DOpTuVD8l9fkxKwtry0qXJMJPAjQTO
         44dQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6hkRPa7jTaVg4RMB55Zg41y36rmEJiH3KWdPnqXOxf0hl/LnxdTV6ZSvOf4k5cQRRvCZWvQ4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWQJJBE2lRMqea+0Eu9MPUf3v6qDZsu4cFhiQ8f8ODxJUf+fgH
	lNsnPPhAolbsLbZfwJOQLxBQK+akq+fio8WavIa/Wxxj+DOc7esx6Nm/Y76ovRoI/g==
X-Gm-Gg: ASbGncuerlJejA/8R6EX/8yeZf3nbGwhdh58eNlnutCE+lWDJz0PWkHx+Za1E4zjpfR
	vbq1mivpTv7zdA1BD9KeEzSuG7/ZoaRfvxy58vE0SQJXBWfz35ejZaBzS+eH1L/DJ+eBl8s+gOn
	hHWUcV+PyhWdsSvQKMRKDbbEtyljyWXz0uyBgTcDv0UhUGNJIB1gByppUBvkhzCk5Un8tgk5NGA
	jqaZeAwi4A/yE+BUGc+dSPvxhkYcFeNxM6xEM8oPBr6a6jfH1rfSK7wAvCQm89xuxXnHL6u1RuT
	hQMAuA7BEHesetJP2Mu0ZWhNXtb/WYG/At1w+jMQEyfgYB9Tr4leiNcCvSBGDtxD0+SBZzkFzDd
	jy7dvKo0oexJyz+Plt2dXydim+BNtSicBJCjGzuoPlwphPPhnRa9wBQbS6iE=
X-Google-Smtp-Source: AGHT+IHPi1pgPaxjy0qFYAQQyA+9c6RpQAFZf3vA/UzVRkHTrs+JR5MqjC9zARfGu5kWXbLyHGkoeg==
X-Received: by 2002:a05:6000:2c0b:b0:3ea:6680:8fcd with SMTP id ffacd0b85a97d-3ee7c925245mr1570227f8f.13.1758265563176;
        Fri, 19 Sep 2025 00:06:03 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:1f7a:8520:7568:dac6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbf1d35sm7200088f8f.55.2025.09.19.00.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 00:06:02 -0700 (PDT)
Date: Fri, 19 Sep 2025 09:05:54 +0200
From: Marco Elver <elver@google.com>
To: syzbot ci <syzbot+ciac51bb7578ba7c59@syzkaller.appspotmail.com>
Cc: arnd@arndb.de, boqun.feng@gmail.com, bvanassche@acm.org, corbet@lwn.net,
	davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
	frederic@kernel.org, glider@google.com, gregkh@linuxfoundation.org,
	hch@lst.de, herbert@gondor.apana.org.au, irogers@google.com,
	jannh@google.com, joelagnelf@nvidia.com, josh@joshtriplett.org,
	justinstitt@google.com, kasan-dev@googlegroups.com, kees@kernel.org,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, llvm@lists.linux.dev,
	longman@redhat.com, luc.vanoostenryck@gmail.com,
	lukas.bulwahn@gmail.com, mark.rutland@arm.com,
	mathieu.desnoyers@efficios.com, mingo@kernel.org, mingo@redhat.com,
	morbo@google.com, nathan@kernel.org, neeraj.upadhyay@kernel.org,
	nick.desaulniers@gmail.com, ojeda@kernel.org, paulmck@kernel.org,
	penguin-kernel@i-love.sakura.ne.jp, peterz@infradead.org,
	rcu@vger.kernel.org, rostedt@goodmis.org, takedakn@nttdata.co.jp,
	tglx@linutronix.de, tgraf@suug.ch, urezki@gmail.com,
	will@kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: Compiler-Based Capability- and Locking-Analysis
Message-ID: <aM0A0p4-3lwLeAWF@elver.google.com>
References: <20250918140451.1289454-1-elver@google.com>
 <68cc6067.a00a0220.37dadf.0003.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68cc6067.a00a0220.37dadf.0003.GAE@google.com>
User-Agent: Mutt/2.2.13 (2024-03-09)

On Thu, Sep 18, 2025 at 12:41PM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v3] Compiler-Based Capability- and Locking-Analysis
[...]
> and found the following issue:
> general protection fault in validate_page_before_insert
> 
> Full report is available here:
> https://ci.syzbot.org/series/81182522-74c0-4494-bcf8-976133df7dc7
> 
> ***
> 
> general protection fault in validate_page_before_insert

Thanks, syzbot ci!

I messed up the type when moving kcov->area access inside the critical
section. This is the fix:


    fixup! kcov: Enable capability analysis

diff --git a/kernel/kcov.c b/kernel/kcov.c
index 1897c8ca6209..e81e3c0d01c6 100644
--- a/kernel/kcov.c
+++ b/kernel/kcov.c
@@ -497,7 +497,7 @@ static int kcov_mmap(struct file *filep, struct vm_area_struct *vma)
 	unsigned long size, off;
 	struct page *page;
 	unsigned long flags;
-	unsigned long *area;
+	void *area;
 
 	spin_lock_irqsave(&kcov->lock, flags);
 	size = kcov->size * sizeof(unsigned long);
