Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E036CE0C
	for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 19:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755718670; cv=none; b=OE4tUYytwbVwEXBnOmdWHNUzTxG8afWEQdzgMVR9KFB0Bp1/feD0zpV0J3EINmxB5sfhGIh/np4w+vCsyE17MejUoJ7M6Ms/Pi6YY157WxuMSUyx4d0gXKgJTr+k3oM/O0rkTP0fsYcWnEV7+gOS2OdXKIy4JMyhpM026sDT5Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755718670; c=relaxed/simple;
	bh=BUM2rK0xOxORB1dKeU1g6C2tjv6DCOl/j122K9iH2r4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BgO4P46Cn/Cv+IbMjXIqVV7fqzqrHLNSj8iS9wOksvl4IOlgrutxvjsjmukEU2RZGHhjoXJMMFkNk+6GUhIjG+uGGCRAE+91Yta0xASGS5vA0aL1IGsTcfXevMYi6Dlaz5LYNS4qDCyXHPshKn9PXwmYvsghwXQKpiph/Dee3Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BAX53rI+; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BAX53rI+"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so295644b3a.1
        for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 12:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755718669; x=1756323469; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BUM2rK0xOxORB1dKeU1g6C2tjv6DCOl/j122K9iH2r4=;
        b=BAX53rI+v03n2Lqx3M8AOLJ2Shpt8LOpGuUAMLUu30blHILu13r0gPYKSb1zi6pC3h
         TeLeDlgb3xpwlLLiVwPqXGYgUfR7ANAaI+6YRd3c7q6HJGwMZFpjJDRS1IuXvhd8Lcr2
         XUy/YC9JK6hJbSGGFDlIFQAWfKrMPqrmIQOjtZ5F7pQ+AXexasNp9U07/CWRYv8YLbDl
         Ndm6NIH1SIs9q+4Rq8BM4IkyFs3sPI/Nq1orV3LSCbDC3fOG0yWmGpZvtQknuj/0MHCg
         TaP+Hg5/q2UC0ToAUci9EAemEafFb6LAaHFInHAe3YmldpvKhWwItJ5/V/oueOQuyK62
         YrZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755718669; x=1756323469;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BUM2rK0xOxORB1dKeU1g6C2tjv6DCOl/j122K9iH2r4=;
        b=dRFxrOc+0+BriN98cuUlL97KXWBKZZrtAK6DC1a5EWhhQdiPnXjvdLcGHn5EuAaSTa
         qo/v/7FSxeMnaKzcrtIjt/mAL6LcPc7kb4vP/U0o/9+1RmvgMGmNGVdbcC69gGl6o+wI
         F+FfWttuGrNjZI/xP05g9PgyX/Wp6u2eUbg52XEl4C+FeMnw6UyUUaEF02IXUOg7XrDX
         Mc50FgfKjYFIr0rp/idqk6ct0iQo6W1sjvO8KBABsiOCms+jTqOmIeHfgqTfz7hup6po
         QrRykfruEN29w2yeBqqpUqCTF+S8D0s2w85mJAk0tkgNIvzJLd/Y3KdNfTA76IEiWgfu
         wEBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNBC9JbTctnJQotBHXUugLQhcASurf8j7ZFk2LpmSy+rUebJBrL5+gCFcggL2IYVbhi9iGXF4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxVMEWRQlaBhkJPqs8bmXTMtyCNsxWfC1243sOAzeuzDp+ECcj
	EHWf7S/dunCa8A7IutOG53XWxdIxTNwo/w7b6dPI0+Lm9FWgbIA5G5jn
X-Gm-Gg: ASbGnctwEq4vV4cXoBqK0NOPKCuo+O4DgzYcch/XfQHfEKzmtJeROXETvLVFNonD7nY
	ChmPcot9/373dfUfUAH7uHLmpSHBUwzWyJYZJcyJbj1TqYtwQowuKXujKfgeFe78KqWLkY6909W
	hmQ6oYXnTn+HWmL0jVDA0FG1mQIFayMi8o1IHZ0063xT/3hOzI0slPc3e95OfbPfc4pgX/GYOEv
	ZcpRqzpsarGjjFVtBnem2epkLVd7jkOGEWaGOozlY74AuXbD5xuPAqmgJ7bR/DfGFsMWRNUWa+s
	EtgHxjnc0PCCFiHUq9BDd5i+PVT5UkgmR30KLnZX9wkKcQvpjEuwW6uM4nM+vQgouW0ZPll8D2u
	PbfwtQyE1RIZh06Zmi6sPoR+frzb2
X-Google-Smtp-Source: AGHT+IEgcqxQXp0DtQiZzjrKj3RNca/SxPqPpD87Z2MPAvBr195OBZlxFJVCjwkb4fbbV7O+pyP/Ew==
X-Received: by 2002:a05:6a00:188c:b0:76e:7aba:cb44 with SMTP id d2e1a72fcca58-76ea0091dfbmr989496b3a.16.1755718668546;
        Wed, 20 Aug 2025 12:37:48 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:14a::8c7? ([2620:10d:c090:600::1:f668])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d4fa74asm5959100b3a.56.2025.08.20.12.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 12:37:48 -0700 (PDT)
Message-ID: <6d172613960339eff4b3a9261ef61a2c50f69dae.camel@gmail.com>
Subject: Re: [syzbot ci] Re: bpf: Use tnums for JEQ/JNE is_branch_taken logic
From: Eduard Zingerman <eddyz87@gmail.com>
To: Paul Chaignon <paul.chaignon@gmail.com>, syzbot ci
	 <syzbot+ci59254af1cb47328a@syzkaller.appspotmail.com>
Cc: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
 daniel@iogearbox.net, 	shung-hsi.yu@suse.com, yonghong.song@linux.dev,
 syzbot@lists.linux.dev, 	syzkaller-bugs@googlegroups.com
Date: Wed, 20 Aug 2025 12:37:46 -0700
In-Reply-To: <aKWytdZ8mRegBE0H@mail.gmail.com>
References: 
	<ba9baf9f73d51d9bce9ef13778bd39408d67db79.1755098817.git.paul.chaignon@gmail.com>
	 <689eeec8.050a0220.e29e5.000f.GAE@google.com>
	 <aKWytdZ8mRegBE0H@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-08-20 at 13:34 +0200, Paul Chaignon wrote:

[...]

> I have a patch to potentially fix this, but I'm still testing it and
> would prefer to send it separately as it doesn't really relate to my
> current patchset.

I'd like to bring this point again: this is a cat-and-mouse game.
is_scalar_branch_taken() and regs_refine_cond_op() are essentially
same operation and should be treated as such: produce register states
for both branches and prune those that result in an impossible state.
There is nothing wrong with this logically and we haven't got a single
real bug from the invariant violations check if I remember correctly.

Comparing the two functions, it looks like tricky cases are BPF_JE/JNE
and BPF_JSET/JSET|BPF_X. However, given that regs_refine_cond_op() is
called for a false branch with opcode reversed it looks like there is
no issues with these cases.

I'll give this a try.

[...]
