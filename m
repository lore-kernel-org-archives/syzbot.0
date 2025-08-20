Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE552E7182
	for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755689660; cv=none; b=harbVh5aQa+E6WgoX2fYQpmBQG1adBS7znc/mAnlX8hgqHDBVfjZlJ7eA3ALE3jr7JW0HeAMBaooniRoMLDSlx+unqmloBngq0RURxHLebr76HxhMmOcBnIo7S0cJbN+0pzVFEkXZhmlyPghPhq4z2fn7MsPX1O07jvjxu1kz3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755689660; c=relaxed/simple;
	bh=d2CMTsFOfospJM6Ts49dEKniaIoVRgIPj7W278GzAJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YFfbqXfYY566FdW+ygyvKnliRNKkgC4ThjKVvn7711dfFWS1JLJef9Pc561zGyT0ymryjl9AD58ne+vkUys5apRQ9xOV8tVB4oPuISedsVYNIkoRbAWlRVelQE6aaB0kfWcaHq9O8sJj+Hk03H+l0ubkciDx/pjz6Td4tH/GcnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cM3u9h0F; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cM3u9h0F"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45b4a25ccceso2768835e9.3
        for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 04:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755689656; x=1756294456; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uXH+qPEUNUSeKVkwKxdBzrKxeCxplvf+HtayDB2icuw=;
        b=cM3u9h0FDpLS1ZH8gzkamdF38G8P8UEl55sVUrp/UyH1xQRNN+seNlJWSv5540tlIb
         xnHcZKpk3IK3gP4Y4rsGiQhKg+llH7s6xUQZ7XM1yg7O3CjAzB6jNAmuT0gt4+PaN4LI
         uiu5eZOeYmIWgODP/5LXHHjyNApJyHnxlfame/mE8WsogWRt4csRcDAUGTQOw+6hVglK
         mJTGUt9/UwC9NahcAA9GHHgnNA3sgLGMDtJUFur+VCga181hyRzGtRz00yB1/P5e9/7+
         YvV/Yi0ZogmINgDuzfmANX81GdiCo/pCj3xY2DyV+lEBbzvZwoA+XQblcvNNJrjcG2My
         K+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755689656; x=1756294456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXH+qPEUNUSeKVkwKxdBzrKxeCxplvf+HtayDB2icuw=;
        b=EP1ovdXQ3Fqas1AtHnLklH245vuwsCZDGmESC9b+RNckOstXbwqKH68KQcJyGmcsk6
         LbVEZrL3gctmfAi5jLBDgBSfl0MGJqE8EVIE0n08WZbFx4ctnJraMvgZ5CYiY/wbjL7r
         hvTg8y2Xm51pw9h0/aYVvp/A8mU2SD8aLMkhtHm2GL19x47YYmBUIPZOo0rgCdWKGWxv
         voNcojyyBtRyIzJ5U6Hds+XL+ItLCyo2qEo5+D/663NM1EpWqsk1CRskrrjC1TTa6MLb
         I4n5Ym8Yt/1jNRqEbjQdnjUn9Kuu9zajJjTyM3cwhacWkhhQXYiYc2+IvDnLDPsMurb4
         ZDOg==
X-Forwarded-Encrypted: i=1; AJvYcCX8OSWEMRvovOdw4YtHrepDtb66l1rWSlrbl0mwZuxZlnlfGVtCvUhQ4n3bEhxumtowGhWGg0A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxM5YGBqo4UvI9QkvquoR+dmqlIN2K0MlUnFv6uQGnnm8IhquhX
	TxsIGwzHRQbZ6ImKka/CFFQ5JGdZthTRly+OkQgRjRaKTrB6TbmjokfS
X-Gm-Gg: ASbGncsQEdU2IXVSSlWSNdEQ7fm/sv2EoLAvN9/GGwz/4cD0iiytEwYrcY4rKPiLJv9
	z78rAVKGStT+C6bHfJk0XENZKkcLcHPFPOkVk4d2Fa41fzP3go0eNbEfXp65/5GDhz5NtXx0FwU
	TgiQdYVDZFxiL3BmdnuLbhsDPkaCvYNoIlTDG5LibSmMyR2haHUYq/ChqGgxGpNKmjPqh3QsJVP
	21k9UaHT+pa5onqMw9+rf55ereJHDnWqny04VOJKgTNTxq+61CqHmEsi47zD8enyDHTkcspi/RG
	mLg1uLYycp+MUuP6iSqdDema/fMHrxcCksafJ/y+sfX5GWcpUWpj1ny7/IGI8dnn61PRNqz30fb
	9VR3zkT1hG3uBW2XTDKsP2IZzjOydcLQoKuOlICEJtbEdByTIPq23MU+G2Zj/c8Fl6emE4D3jBI
	wj3Soevdj2z/9ihHqcXrybPUh/YIOV/+E=
X-Google-Smtp-Source: AGHT+IECunXqBGlVdSyROfRgJ5fukZidvqWlPfHSoea9nFU4IDulE/wYai8mTkzdV1RYKNEodU61Fw==
X-Received: by 2002:a05:6000:2481:b0:3b7:8268:8335 with SMTP id ffacd0b85a97d-3c32fb2fe1emr1793826f8f.42.1755689655922;
        Wed, 20 Aug 2025 04:34:15 -0700 (PDT)
Received: from mail.gmail.com (2a01cb0889497e0086dd4a301ba288fd.ipv6.abo.wanadoo.fr. [2a01:cb08:8949:7e00:86dd:4a30:1ba2:88fd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0771c1677sm7546278f8f.39.2025.08.20.04.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 04:34:15 -0700 (PDT)
Date: Wed, 20 Aug 2025 13:34:13 +0200
From: Paul Chaignon <paul.chaignon@gmail.com>
To: syzbot ci <syzbot+ci59254af1cb47328a@syzkaller.appspotmail.com>
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, eddyz87@gmail.com, shung-hsi.yu@suse.com,
	yonghong.song@linux.dev, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: bpf: Use tnums for JEQ/JNE is_branch_taken logic
Message-ID: <aKWytdZ8mRegBE0H@mail.gmail.com>
References: <ba9baf9f73d51d9bce9ef13778bd39408d67db79.1755098817.git.paul.chaignon@gmail.com>
 <689eeec8.050a0220.e29e5.000f.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689eeec8.050a0220.e29e5.000f.GAE@google.com>

On Fri, Aug 15, 2025 at 01:24:40AM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] bpf: Use tnums for JEQ/JNE is_branch_taken logic
> https://lore.kernel.org/all/ba9baf9f73d51d9bce9ef13778bd39408d67db79.1755098817.git.paul.chaignon@gmail.com
> * [PATCH bpf-next 1/2] bpf: Use tnums for JEQ/JNE is_branch_taken logic
> * [PATCH bpf-next 2/2] selftests/bpf: Tests for is_scalar_branch_taken tnum logic
> 
> and found the following issue:
> WARNING in reg_bounds_sanity_check
> 
> Full report is available here:
> https://ci.syzbot.org/series/fd950b40-1da8-44b1-bd12-4366e4a354b1
> 
> ***
> 
> WARNING in reg_bounds_sanity_check
> 
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
> base:      07866544e410e4c895a729971e4164861b41fad5
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/c4af872a-9b42-4821-a832-941921acc063/config
> C repro:   https://ci.syzbot.org/findings/8dfae15e-cda5-4fa6-8f95-aab106ebd860/c_repro
> syz repro: https://ci.syzbot.org/findings/8dfae15e-cda5-4fa6-8f95-aab106ebd860/syz_repro
> 
> verifier bug: REG INVARIANTS VIOLATION (true_reg1): range bounds violation u64=[0xffffdfcd, 0xffffffffffffdfcc] s64=[0x80000000ffffdfcd, 0x7fffffffffffdfcc] u32=[0xffffdfcd, 0xffffdfcc] s32=[0xffffdfcd, 0xffffdfcc] var_off=(0xffffdfcc, 0xffffffff00000000)

My is_branch_taken patch fixes some invariant violations. The test from
the second patch is even adapted from a syzkaller reproduction manually
extracted from logs at [1]. Ironically, by improving the branch
detection, we can also sometimes degrade state pruning (as discussed in
the first patch) which causes the exploration of new branches.

All that to say the current syzkaller repro is not directly caused by
my patch. It simply causes a new branch to be explored, and there is a
different kind of invariant violation on that branch. The full (sk_skb)
program is below [2], but the end of verifier logs are enough to
understand what's happening:

    12: (2f) r5 *= r6                  ; R5_w=scalar(smax=0x7ffffffffffffffc,umax=0xfffffffffffffffc,smax32=0x7ffffffc,umax32=0xfffffffc,var_off=(0x0; 0xfffffffffffffffc)) R6_w=0x9fe719f2
    13: (65) if r7 s> 0x1 goto pc-7    ; R7_w=scalar(id=67,smin=smin32=0,smax=umax=smax32=umax32=1,var_off=(0x0; 0x1))
    14: (07) r7 += -8243               ; R7=scalar(smin=smin32=-8243,smax=smax32=-8242,umin=0xffffffffffffdfcd,umax=0xffffffffffffdfce,umin32=0xffffdfcd,umax32=0xffffdfce,var_off=(0xffffffffffffdfcc; 0x3))
    15: (1e) if w5 == w7 goto pc+0
    verifier bug: REG INVARIANTS VIOLATION (true_reg1): range bounds violation u64=[0xffffdfcd, 0xffffffffffffdfcc] s64=[0x80000000ffffdfcd, 0x7fffffffffffdfcc] u32=[0xffffdfcd, 0xffffdfcc] s32=[0xffffdfcd, 0xffffdfcc] var_off=(0xffffdfcc, 0xffffffff00000000)

The invariant violation follows the same pattern as usual: the verifier
walks a dead branch, uses it to improve ranges, and ends up with
inconsistent ranges. In this case, the u32 min value is larger than the
u32 max value. We can notice that the condition at instruction 15 is
always false because, if w5 and w7 were equal, the intersection of their
tnums would give us a constant (0xffffdfcc) that isn't within R7's u32
range. Hence, w5 and w7 can't be equal.

I have a patch to potentially fix this, but I'm still testing it and
would prefer to send it separately as it doesn't really relate to my
current patchset.

1 - https://syzkaller.appspot.com/bug?extid=c711ce17dd78e5d4fdcf
2 - syzkaller program:

    r5 = *(u32 *)(r1 +112)
    r3 = *(u32 *)(r1 +108)
    r0 = r10
    r0 += 85328110
    if w3 != w0 goto +1
    if w5 == 0x0 goto +0
    r6 = *(u16 *)(r1 +62)
    r7 = r0
    if w5 > 0x2007ff0f goto +7
    r6 <<= 32
    w6 -= 1612244494
    r0 = r5
    r5 *= r6
    if r7 s> 0x1 goto -7
    r7 += -8243
    if w5 == w7 goto +0
    r4 = r5
    r4 += -458748
    if r3 < r4 goto +1
    exit
    if r0 == 0x0 goto +0

[...]
