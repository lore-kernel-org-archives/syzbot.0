Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84702E06E4
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 13:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666223; cv=pass; b=HCAQVQipvpH0pj3YgNCdTr1aWD0T7JWlhwIy/cUrGJ9dvI2XmL25yH2hEW+hV49n3uAd59rj5Ds6eIFIaWGMGQ/55qxI8JJJBoJqd9apZgSXGHujHE5GAqhRFIeDgy6HNEjKyhWgqv/aLgqB9/3FPpUZHZAzi0hD90MJJzBR7xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666223; c=relaxed/simple;
	bh=sywHAg8EjyDe1PRU9SDxRrVu6U6uCkQ7KJhkjrJpV1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aupCU+hp5wp86UEcT4TK/YS29H+pBfGxvpbqBw0IgWPM+tVk1RpfoyN9J7EMjTD3oVx2IsV1yzV29o0j3czHvugEU/xvCZj3htKYRCJvJqTGx8abYY5/uqW25bdY/QOmcBZXnyEbp7sjN/NOiDaT7VQNN9KFF06SX81RJIi6aGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g7rnmuqw; arc=pass smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g7rnmuqw"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc147d86bebso878022a12.0
        for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 06:57:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787666221; cv=none;
        d=google.com; s=arc-20260327;
        b=kFE/QfKcwkhUsxAmwyb0wbJlMAYSNqY/ecXYk1ia4ObXVIsvhJfrtXOK+EFVQhTxoY
         +vq6t+w9WBnURtvIKalaBxdOETDOJ9VKCnMIWQFg01g5GaZOfdLiJE4hFJNHQlwRPVTx
         LnMQmUz+JDWU7z8PBnMPzGaI2LA4RR6byFMddI28zL/JhwspNm+FPi0M8QvfkeDy8v5K
         YkdCQCvCCNSNNx1Dd09g7lie0+HBtK08hgkfI6hgG7/RpCGsPpmj5xGT9UyXD1jCiyHI
         c3a838t/IQIF9Qc6QnX+ly6GBkMKP1m07c6e6Io19tpKPrE/IcrDi+DjwAstyftQJ27q
         9wEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=p466jzYaVssXJ6dwZ0VbNwE9m6fg7ORrYv/Pu2TnjcQ=;
        fh=OqX7WHzQaJvvCBFTBsdiVdPZUpBJOgfUp4OiQYSLqzc=;
        b=IBHIug+GP531fjH2CC8zFxDFWRt//K8zX9KG84qFZWazHzT0nt/uj9UG8PCDEJP8SY
         b4VDCozdwjL+O+G7Zum278azIZFwXnHa13f5r84GWMEEs4C0PVtnXpP/UYQJALLfq7tg
         udPrXaPE79F/aWJtbG4FclTZkv69YypMwZSmelXb4GupTb+PlejS12YXZNV9Nlwds7AJ
         SIdxPfNtOuegQbYLSQoOY3Wn1jJb06IJ4wH86eNgEdWx60wlF0pz25frTsdjHS+D2i1o
         8n+Av1iQ3lILkXeSyMt3THL/k5db1iIHhETwYLQDXZ2mWQIdnnVgIPQKaaa07HPEZ++q
         pqEw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787666221; x=1788271021; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p466jzYaVssXJ6dwZ0VbNwE9m6fg7ORrYv/Pu2TnjcQ=;
        b=g7rnmuqwjniU+efpwSkt6xUdpw/Um4bGV/rC3zxXmCWMfkBHT/L5KgcbN0+dRVE/2J
         dY23zF+gX2vB0XruMmOgWKvxMag7zeNsafbF4s2P+VcemzKxDj40M8Eni4Cd0p7VMqAX
         kwqbcPX9PHEe070eLc5/vHaGH78vS/UJgDr4YJst48KVggJ1x9pILeefoEkQLGXI3nbW
         LMloGNRkNFgva5bQ4prpprRyhsmH7f9vYOuza3hIeeGYfxb3ZZSAIhhEoN/JUoBwLjBd
         hShxlYBLpORWxSObXjJONA68x/krt9AP9FheVPG6WlzOExFMOsz2gaI/gRWSOklJBNLm
         /ABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787666221; x=1788271021;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=p466jzYaVssXJ6dwZ0VbNwE9m6fg7ORrYv/Pu2TnjcQ=;
        b=iwbayQ72Mey7op03+HveZpKvhZfgEOlbjGVVEwWy646EHx2zZ2EaR7+qZZytx16DON
         +KSLYT5GFogGhcsiTVlYVR38jW8YdWX2UreVCPBeKBAU3wm7X1XONtzNw1TYhW5kKHmh
         3uLHj8mp+6UoEX3smx4zYUHlXJ1KcHsrC8hp8N0ZvDENpcn5jcZMfa+qs3Om3YG8kSxu
         aBpbOpijS8GwXlwMFJglxFhvWAPH3THlQbemF07IUGZ0jhgY+K+Xowjs+1FDO5ElmOVu
         3ygBJNozlE4iZPI2ka6On0fZiyCz+0FeUYJYYEv9a+m2kzUciCZMclqUtzlm9bqO5W/O
         KCDg==
X-Forwarded-Encrypted: i=1; AHgh+RrC8hUCEU8nlDAMwEGyUo5jmSEAFnJTe4z9+dr5q5HJWvFYY2SFnu2imw1byYSuFo9V2DFVRv4=@lists.linux.dev
X-Gm-Message-State: AFuF++kD9IKJw+rK6HsTl/pi/wyYV1Ym3Z1Bmjnpufx4tjuVJE9TVbc3
	dI2xm7Eo/ngs6F9deuNYrOIwdVSwnNEL61HGvHAaylAghZgLsfheopRK/rd2XWbx7ZWQXWCRBwh
	iEh5FEptYbSTaa8eIhY7H02k74zo99Mp5oRg9EZ1+
X-Gm-Gg: AR+sD12I6r5P01imXcGHZbh4dELZ6nD+URbNwYcQloTeyKMvtrl2rB5QUTVQzTKbUs5
	rTY9HczJqsbTlc9NH+DimYsFCh0FJZUFgo0tVbFz50VrwM+pq/l7IZPA4lVn8ihJHfT2k2x+vtt
	e/RboigIs24f5ZWdZQFOOwb8Os7w0cFftrlEeU6GEjsjJZo0rv1M2io8U7EOiS9D6avgh832hPV
	DHbDN26a0+0P8zG1SyWuncXRDtgZz3OIhId5VCF0eoWG/Uvo/8z3pxIP0tvCxE7rVzA8TQnECSN
	e6FdkdTTCzhtgqxKndC2JloBN6hOrVIKC+JbzaQJcU9biwFmCMy9iL/I6px7UpTO6xcpUbDU9u8
	=
X-Received: by 2002:a17:90b:1a86:b0:38e:9784:dd47 with SMTP id
 98e67ed59e1d1-39645829233mr9079435a91.1.1787666220257; Tue, 25 Aug 2026
 06:57:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <3b721f07-79ad-423c-9bd3-f945e97a1d9b@mail.kernel.org>
In-Reply-To: <3b721f07-79ad-423c-9bd3-f945e97a1d9b@mail.kernel.org>
From: Marco Elver <elver@google.com>
Date: Tue, 25 Aug 2026 15:56:22 +0200
X-Gm-Features: AcwNN1XPQafecyryYsiUwBCZjsxYD_S6mJq5XjUnZ6B1dZ0FCtBMboakcCbPgE8
Message-ID: <CANpmjNNbM1KGrknPaE6T0RTVF9in2+mLge-mLafDr+4LVvBTFg@mail.gmail.com>
Subject: Re: [PATCH RFC] thunderbolt: Validate BAR 0 resource type and size
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Aug 2026 at 15:40, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The thunderbolt driver can crash with a page fault if it binds to an
> arbitrary PCI device (e.g., via sysfs driver_override) that has an I/O port
> BAR at index 0 instead of an MMIO BAR.
>
> The driver maps this BAR without validating its type or size. When it
> attempts to read a Thunderbolt register at a large offset, the resulting
> I/O port cookie overflows the reserved PIO space on x86. This causes the
> generic ioread32() function to misinterpret the out-of-bounds I/O port
> cookie as a valid MMIO virtual address, leading to a direct dereference of
> an unmapped physical-like address and a page fault:
>
>   BUG: unable to handle page fault for address: 00000000000556c0
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   ...
>   Call Trace:
>    <TASK>
>    nhi_probe+0xcc/0x870 drivers/thunderbolt/nhi.c:1198
>    nhi_pci_probe+0x46b/0x580 drivers/thunderbolt/pci.c:479
>    local_pci_probe drivers/pci/pci-driver.c:332 [inline]
>    pci_call_probe drivers/pci/pci-driver.c:394 [inline]
>    __pci_device_probe drivers/pci/pci-driver.c:455 [inline]
>    pci_device_probe+0x431/0xc90 drivers/pci/pci-driver.c:489
>
> To fix this, add explicit validation in nhi_pci_probe() to ensure that BAR
> 0 is an MMIO resource and is large enough to contain all the NHI registers
> before attempting to map it. The NHI register space extends up to offset
> 0x39944 (REG_FW_STS), so checking for a minimum size of 0x40000 (256 KB) is
> appropriate.
>
> Fixes: 16603153666d ("thunderbolt: Add initial cactus ridge NHI support")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+97999b836ee62ddb0181@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=97999b836ee62ddb0181
> Link: https://syzkaller.appspot.com/ai_job?id=94fb1c6e-d9bf-4502-b2ca-abddc1e16654
> To: "Yehezkel Bernat" <YehezkelShB@gmail.com>
> To: "Andreas Noever" <andreas.noever@gmail.com>
> To: <linux-usb@vger.kernel.org>
> To: "Mika Westerberg" <westeri@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/thunderbolt/pci.c b/drivers/thunderbolt/pci.c
> index bbd186c29..052519bc7 100644
> --- a/drivers/thunderbolt/pci.c
> +++ b/drivers/thunderbolt/pci.c
> @@ -466,6 +466,14 @@ static int nhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>         nhi->dev = dev;
>         nhi->ops = (const struct tb_nhi_ops *)id->driver_data ?: &pci_nhi_default_ops;
>
> +       /* Ensure BAR 0 is an MMIO resource */
> +       if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM))
> +               return dev_err_probe(dev, -EINVAL, "BAR 0 is not an MMIO resource\n");
> +
> +       /* Ensure BAR 0 is large enough to contain the NHI registers */
> +       if (pci_resource_len(pdev, 0) < 0x40000)
> +               return dev_err_probe(dev, -EINVAL, "BAR 0 is too small\n");

Shouldn't this be a constant somewhere? We have constants for things
like REG_FW_STS (nhi_regs.h), so shouldn't 0x40000 be some adjacent
constant?
What's the most idiomatic here?
