Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F9C2FF653
	for <syzbot@lists.linux.dev>; Mon,  8 Sep 2025 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757353770; cv=none; b=Hfj1nMyvc6Yv4lGN+foPGWRP2roefaNizED9ZQaZ3PnqCFG2GZDzuDDiEsmLHQ747ReF57GYbJfw6CJWQmNIeKB6Q6Dqh9P0bKEcKxWoW8Lk6ZamJSK/PZYE7+3MJWvMOjwG2RCe8YO+EqzUmg1ekjxy7l/pAR2SWSu0PvakRqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757353770; c=relaxed/simple;
	bh=Nz8Wzc8Hftz3sg9iQPtxvQS7DMveXFBUll9BA7Ozal0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iU02lP/gbWbk6yc/4xSYrS1tp83MCqOAd6xvbjSH2T9vQoO/ZJZV8JxoViymr/8M1nxzop3flrxNqp2ILTcRwlD9a7Sb1BIdkXqjaNuCB3hF81eKOSxS9G6gT/UBRrjYJiwapHkmUy627E6Lj7/+7ZP+B1o5Mznw2XpX6cUoWX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPGTtoF8; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPGTtoF8"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45de6490e74so12128795e9.2
        for <syzbot@lists.linux.dev>; Mon, 08 Sep 2025 10:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757353767; x=1757958567; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pSRQ1ptpcI32Y0QelfghF7qMBMSqQwB11cAnuhMXi2A=;
        b=bPGTtoF8Ly7HxOoSnn9Tv2YoLIPf5QJcWpjvQg9Mwn77kGUZMLhHpcsJLs7VsE8t4l
         gR6yq+BUWAmXlMZEY/8VJZZbtDPmwaIEJ5EBePHqKUu9LhkbLTkrCUEw9+5cixqX9Mps
         PektBXvCElx7655XDIsGtPqrqaWBk/18hOvQ+CSFPURVdidHLCJkQbUktCtTnPJ8I3/S
         S0H6u+tiv/A4liz5r5mbdd38Pw/IEX10+Qt2AcssUC8uIaqea2WDZIdqzJm/uCVdXkWw
         DFwmDd8sE/1x2oTI0YF+NEKMSmBhsVhav6TMlvlGmv4t/NbtuXHM/SC+ngccMb6yi07w
         Y3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757353767; x=1757958567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSRQ1ptpcI32Y0QelfghF7qMBMSqQwB11cAnuhMXi2A=;
        b=Lz83GOxsDgarlM7xK8paalAu/OCKqRF9cP0jbVQxZMt3lFiS3Oe0gXTgojI6dpXcYb
         f4CUWCjcp+YlXcflkwYA7+cpNFd8cNqX4N0TFmdaIA/HmoG6OKSN76YDCOCuS0z1KC9W
         t3vR3fVgumZuX4RVXYJVE2GJJfF99KrywE1kDYCq5nw3df/L5RvsRAHEHOevKNGBg1TP
         vIhL76M8yeX7l0c4L/B+EuI01b0xTGfa/Zzyo4+DQtJ8uJZhzK/4aEj8yDK/qb8Yd/tn
         pmEv35nD4At52tBD6X4/1W9wtn8NZkbiKMtF22rYSKTnsHlZM/LtE7k+ccZQWjCajdUq
         BNcQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3sVE7b8IlRtq2RwY91i1YoLJA4X4/XarBYRewoKr0nkBvwQ/S1zBnF3/HyhvEHwDkVqmoTfM=@lists.linux.dev
X-Gm-Message-State: AOJu0YykCWYCVlhFQeEEY96Ly8yizkSfWgM7PmwNXu7KJyPyeGufQe2j
	dqWbPBsgKIelJ3qJaq/jnpu4kQAkGnkMqUazJ6Tpu4TNN3FhPimPv5PL
X-Gm-Gg: ASbGncsznZnfHh1d5jjf34I8IWFJIwpiPJmd9aw887Zq/G2f4RLH7eFFS5QDLVFGNbl
	RkbRbQkvDjgJISvTdi2k4R2fVg4Qk7BlzCIArBXTfCvaa0ffnjJy/nzs1CxeQW/ilA/mQwZW+7K
	xpI15VERgthEHLYykpTanEuLP2heolKwuHsBZVStAWlbf2Db/qVp6Wv3g4tajqUFSb11uiq2Cr3
	ySZ6FNduJn8cIArlPBZ6727iHdSyGp32yM/RcybN8RrYyvuHCIZSTG1Vg161GziZXw+T7ku3CHZ
	qA03FOyjwLXJ8nxLfXQZHo8+M/1Jtk2v/BpLArPsFtP2rS5qtsEnIfIDxKw9WtiUHnsy9HVNb2j
	uOXdR240F6Aopkr+5ZP62NfGL67Y4sQ==
X-Google-Smtp-Source: AGHT+IG6eTMGZlSvYS6870CgZ7yIJryNYolXHTtoC8ALrfKjoZtxsaUHa6cYySwR/CukO85ee0X7Ww==
X-Received: by 2002:a05:600c:4589:b0:45b:8795:4caa with SMTP id 5b1f17b1804b1-45dddeedbb4mr87688445e9.36.1757353767143;
        Mon, 08 Sep 2025 10:49:27 -0700 (PDT)
Received: from Tunnel ([194.65.32.126])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dcff67787sm203223935e9.16.2025.09.08.10.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 10:49:26 -0700 (PDT)
Date: Mon, 8 Sep 2025 19:49:24 +0200
From: Paul Chaignon <paul.chaignon@gmail.com>
To: Eduard Zingerman <eddyz87@gmail.com>
Cc: syzbot ci <syzbot+ci59254af1cb47328a@syzkaller.appspotmail.com>,
	andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, shung-hsi.yu@suse.com,
	yonghong.song@linux.dev, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: bpf: Use tnums for JEQ/JNE is_branch_taken logic
Message-ID: <aL8XJI_gpHjjvX7o@Tunnel>
References: <ba9baf9f73d51d9bce9ef13778bd39408d67db79.1755098817.git.paul.chaignon@gmail.com>
 <689eeec8.050a0220.e29e5.000f.GAE@google.com>
 <aKWytdZ8mRegBE0H@mail.gmail.com>
 <6d172613960339eff4b3a9261ef61a2c50f69dae.camel@gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d172613960339eff4b3a9261ef61a2c50f69dae.camel@gmail.com>

On Wed, Aug 20, 2025 at 12:37:46PM -0700, Eduard Zingerman wrote:
> On Wed, 2025-08-20 at 13:34 +0200, Paul Chaignon wrote:
> 
> [...]
> 
> > I have a patch to potentially fix this, but I'm still testing it and
> > would prefer to send it separately as it doesn't really relate to my
> > current patchset.
> 
> I'd like to bring this point again: this is a cat-and-mouse game.
> is_scalar_branch_taken() and regs_refine_cond_op() are essentially
> same operation and should be treated as such: produce register states
> for both branches and prune those that result in an impossible state.
> There is nothing wrong with this logically and we haven't got a single
> real bug from the invariant violations check if I remember correctly.
> 
> Comparing the two functions, it looks like tricky cases are BPF_JE/JNE
> and BPF_JSET/JSET|BPF_X. However, given that regs_refine_cond_op() is
> called for a false branch with opcode reversed it looks like there is
> no issues with these cases.
> 
> I'll give this a try.

Hi Eduard,

Did you get a chance to look into this? syzkaller came back (finally)
complaining about the remaining invariant violations:
https://lore.kernel.org/bpf/68bacb3e.050a0220.192772.018d.GAE@google.com/
If not, I can have a look at the end of the week.

Paul

> 
> [...]
