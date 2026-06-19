Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F8A3B83FE
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 16:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781887844; cv=pass; b=TtURZYTz9WBdphsilZfhvfGZoGwv9csg1uqEgeoDj6fXpvwPM52cNz8Ad++5Cov1JXH6NXJihTXQRi74x3ncXxJsLR9t96Rw4ffQ3okW6xUcnEEQ1lOuGsZmxIWA97TJS9WL7Rsdl6uqq0C0ySqDInol+rCL9CY4HH1G6OQ0REk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781887844; c=relaxed/simple;
	bh=gma+cMEHLIYG4aYn9do4E31EErDpvgPp8AMrQk+wZ+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JKq5rWblZhrEkJUYCwKjzmZcRDbxygCrtAyfneiXdukQ52dypD5EpamNwNb94CTC7cWipE7DspzQMHaLOO7gVX2g6BFZaoT4yV3Uub/JPDw+yEfxRZuIKkdPoPGg2RwB93Q5fHCadGB42RMiuof5dYDgD2kyOPeM72t30dkMYeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HkHc6gQV; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HkHc6gQV"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e6e21c47e6so1393685a34.1
        for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 09:50:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781887842; cv=none;
        d=google.com; s=arc-20240605;
        b=eOgAOVJ1su4Yi6CvUM5eNu+hoSKWhPUsXhvr8wvhtHJgqGlQlr39y2PO7JZaT5yf4s
         tbCmbqUN/el5EvpC2kEi30Z1VcIhqGHjNJVh745lHOL+VFTWC8xoHfzD8oL+u0NtZIJJ
         C1bx+6GCb6YKR/BlstbDFh6XY4AmFNfLUqjWOmCtoezurzUT53tJakUimr2bYncM559C
         P3QYqZQUkImrpTCkVmStS776GSPdu5tXay7+MbiQyNJDx76ZbdXtukRBI3xOsLYzcA5n
         8xoI9fAUIMM7A1opG9woyi/k6WYS2ongcZoIAR6PPRcNib8xoZK9fKnWjpkJmQQIimwQ
         g7/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gma+cMEHLIYG4aYn9do4E31EErDpvgPp8AMrQk+wZ+w=;
        fh=hz4WOqwAxbLGYmbUscDTQzKRFtfJIoUmZ3siel7Hm3o=;
        b=THXjAlDWaWbsnCjfGveCq+dSGfJvfhHdgaBo4kiL06mSNmrrrtyeGgXB0i52L0H0BL
         0ZLh7iwq52K4XFTT80p6DLTKLAfy31znp/Cza2ox+7I4Q4cUAA1fJl95MCzqsMnhP9/J
         X0StErLf4See2PrvyZsxmnObsSmd80208KaDZgRP+SP8URIMNOgAyqsu+2hjRgCXstNP
         H9f7po9ZG0cjm/fyCVb8M9un3o27lwrlEQOBIjL5w653hfnSJOhy+pCLGGr8XDAytvAE
         1Z6mITPHeVnP3sasgILo4d3a5je+pQlCmqvPtVXg2yc1O+7AWo3n+hk4t7ZQFTlTDTOE
         k8FA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781887842; x=1782492642; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gma+cMEHLIYG4aYn9do4E31EErDpvgPp8AMrQk+wZ+w=;
        b=HkHc6gQVeCTEecckcVRDqReev/pPOTgeM8M6SCHGBA2/xW9N9gCShf4sAHrJ+KbtQt
         AF5Q78rUkzHhPWJ6csfyGWtMmNWZMNMnSQNCvuwjQ8xlXHkzHwdlRJdsukjdS5NWWmQI
         aMYWtw5EH0UTTSV/2NG5qDXks91hcFQkkuwJ7GOoZmZgbvWQbNCZrNemSac4zdBvfSiv
         sJYA2F3c58zQ8gIiRxx3xHdAzOzDi4h9AHLplmLvjwsevRpZh8/D65k/+OJ691tSPM0B
         tymCU1hubF71KOK/U4BPFZ55JRzmixjRLsMRAZD6Wnh5YZ9TN2uZYVDroU9KQcGMUzh1
         V07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781887842; x=1782492642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gma+cMEHLIYG4aYn9do4E31EErDpvgPp8AMrQk+wZ+w=;
        b=WwfQDvYr3U2X1iYc7gnplrYxuGgk5IUskgxHNh1UGDTWGsIex3ebHxY3aHH88xErhY
         NmE1n81/HaTtip1/Ifakp6VgM7Uacst24QWP8WaF5fzobiUjDt1kH8XePofQfq6bcOSL
         ZJ6dL9JElPLQQ/fOPJhSOXXTUpNPz+uMXTR/Mb/gUFMtCuTLAve6yQ1L4Ddrq9btlSl4
         Si6Q9tMHAAIwv3OenlZTloDWcXmEKikdpm/jV1L5zbPXL9roYq5iPzM+tM/qf8WIStm+
         vgCbR02vT5W3hPafYZeA2MCwXIa98QboVMbu/NjqanikWcuqzCJv+7YDvyIS0G6W+JAz
         wsOg==
X-Forwarded-Encrypted: i=1; AFNElJ86ZRQjuZhzMbu0AnbYP/3nKlYipAx6HV7McGdgmBfUvOfZtJPRpHggoUKvBNQEHgKPPGNRLhI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7uxIoz80xZd41BPhYAu+i5e3Wjn3ay7gmcKSOJ8xRa7FQ+yTr
	kp47SsQ5bd1l7SUS79mXJzHu04mKE3lwdfjS/xPg2m13GqezMTl0wZyA9lBQsNrjnbr2nEbHzhh
	0skucUZUIL6QKKbPzhJOcPpRXOlAzf+uH8QBWR45R
X-Gm-Gg: AfdE7ckPN0F4A8vCBFGpNSvkEo32w8ZndmEg7zIqd+EIW9pLkLV5qC3zpn8Bjk/KVwf
	c38ICfHYn5cJgegeGbeem635gqq2Bdf+B2TuInGlrnNviQ9hdjcppXYlYxcJp33R4foSPwLxedH
	GFcNwhcLvpbLXj1tKIucq4KsHSGLyhO/2yRXkTFjCh8gQZHC6pY8TM/njAt5inU49Byjue8KMSU
	vxQrF5uihqTmOTkuBY561Z1qh2H3JOp9fI8cO3STeP8e3Y6Fc4dulJgxHcnXOaSzlukkbCzocjY
	ouUWsUFn6sjk1UO5OmD7C9/w7W79l4ZweNyFdpXmKK8F/QWcNDvI3trObv6tK4WxMWXu02HYnS1
	iNxee+ES/RA==
X-Received: by 2002:a05:6808:1a13:b0:485:467f:a307 with SMTP id
 5614622812f47-4896ac96fcemr3348961b6e.42.1781887841709; Fri, 19 Jun 2026
 09:50:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CANp29Y4dHrcS6TCKSJbDJDLHbXippnwxXSWEUX2bvs=mpd0zYw@mail.gmail.com>
 <536678a8-7162-4e58-9209-ded8094bce97@mail.kernel.org>
In-Reply-To: <536678a8-7162-4e58-9209-ded8094bce97@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 19 Jun 2026 18:50:30 +0200
X-Gm-Features: AVVi8CcS6HcpN0HdGqlmw_uc8oqQMLHTK1xS2ho9oSvje5YsC6cvFicHS0hix_U
Message-ID: <CANp29Y6riOfNcg9g1+5MJA79EcvmWr7oO1QM6iXjNh6uJaVymQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] netdevsim: fix UAF by explicitly cleaning up
 debugfs files
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Would swapping the teardown order (nsim_dev_port_debugfs_exit,
nsim_destroy) help make the patch simpler?

On Fri, Jun 19, 2026 at 4:21=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
>
> > Why `debugfs_lookup_and_remove("ethtool", ns->nsim_dev_port->ddir);`
> > was not enough?
> The BPF debugfs files are created directly in the port directory
> (`ns->nsim_dev_port->ddir`), rather than in a dedicated BPF
> subdirectory. Because the port directory itself isn't removed until
> later in `nsim_dev_port_debugfs_exit()`, we have to explicitly remove
> these individual BPF files here to close the use-after-free window.
> Removing the "ethtool" directory only cleans up the ethtool-related
> files, leaving the BPF files vulnerable.
>
> --
> This reply was generated by an AI model.
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
