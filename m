Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABBB420488
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 13:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787750935; cv=pass; b=mR1KFmWwKTHhZH8BHIFhx7nljFhtFEXB8AgpMBJBj8ZOaTZHveo6SUoqMK80j9tAIKpWH2Its9/IM4GPsGab1zJ3pbcO/upvXaixUsYwNi/R43tbZ7NIdUPxVvM9sv3s12jyRUIneQ9XkX9yunwb7THfWJ4Qyko3VSgeYthDYd0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787750935; c=relaxed/simple;
	bh=+VLTGuxNrZSVqZv6ytH0WhOOdBFfC+XvJLF1f1/v9Rs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTnlJr0iO6xjAweJlF/7XLURKpnRqIYC3U7KVslmioIqybyNrZ2mSuyQCy89NQs2ZSQuzK56rvP38YrKnImYBO8K8rR6SwN+nphyiusbZJIZEyXz/xvZPBTTl/F1iyxSgDyxphcEnnXsBs3UlIqlAIXcmgJiHOS1QyNLx/g8GYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=fAaIczbt; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="fAaIczbt"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-52b3934af3fso10374061cf.1
        for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 06:28:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787750932; cv=none;
        d=google.com; s=arc-20260327;
        b=iw6B5NH9HoWCrhYs2csTusgaL2ncjkScM3LnE3y98Bk87EL5AGF00u2dm7BByG/0CQ
         MCluTWkGTWaHeF8kKzHgVjI6co5Ijx1u34c1dEUMI4Ghwj0eWNiOoP89yS2sxplHzrHH
         hu4wt8LJN/HTDmeuOLKsHjgwdyrGixDYpWuXTj4CWw0TawG+4jre2nf2C/k7b/QJvUUL
         hLvTZjNLIdHi1++lX8UXg62z1stpeQdzRFj6oXDoPNTrvEzK/qXDDr29QnyhDUbBBd12
         +/7oH0g5lFFDnosShJXr8/o0A+muglzYpxqelqUJT8HrJg+/CrrloiXqviUjBnZkQoK1
         9mYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=g4RMaWFMxncWKjk5/j6ryLpkwNl+5YtCqnC/Ijuyn+A=;
        fh=Fd1daXNgmha5BTdAJjiRdVPU6WR46hMfPyPpi8eCHvM=;
        b=SW7VCOmxndG3TOxGYrhC4Tgp6R7hNxxmBQwdTxMWcpM1G+JTo+Lt13Pc4vnIqDGY/a
         UgrRHrvZL5DCbxMuyx1LZvCP/d43Jtsnst+M1lyTshqdKz8BAka3G1Ty0inmrrgivyqr
         IlfK6MQjUFQ/zGyqmnugXZPxLw7f4DTtoo0aKRZ3bAveOMwK2afVAiPAjzZTwolHe5aL
         X5JqwbPEJWPw5NkYs4ZKIl19eLqMaSkOMGUQnh4lTmWjPK8P86l3vbqDgeN1L8TKJYov
         izTRDFSLKjHh7dMxHtZ2KNS8BqkJ+V30I4/paffQKuKKRr+Vqj//MDpzPJ7ulnt4SCyo
         5YvA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787750932; x=1788355732; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g4RMaWFMxncWKjk5/j6ryLpkwNl+5YtCqnC/Ijuyn+A=;
        b=fAaIczbtUWwvWiQoMNrVzXFBerbRpXI12FYzTSUFvbVh6JB7ZNkrjVpwSpF3Nw0G80
         zY67FkvNUKMdNb+jpgh1e3f6a0d8TH5li6Pt3CHz4FEft2gvQbQczBekeyOsbu3bWZch
         m8EPLdnzRVMfpyf89Jiz6R881L9rjKYZPoaQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787750932; x=1788355732;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=g4RMaWFMxncWKjk5/j6ryLpkwNl+5YtCqnC/Ijuyn+A=;
        b=sp5UVCLGGXFt3iVofkXboq1WorgqfIPodoCzFSh8iEQysv2jNOORQW7wpR/k02bpqx
         KjvqIoYSEKBYm6jJRfCoBFt7GuVBo+8zaj8afSZBvH1uaV1iavLu2CkSl+X/LA8Mz4sE
         h8EbJ3ARb7eEieFzWY7Sun6e5hWQcPI6FXiGpwDpGFWms/TbefwpjHK9lZbboPKt7ZFG
         0uzl4uLcgUtkU/HmZtcjHfqBTuNv85NXqs8OMt/LRJBkz+Ys8c5ZYJLMFJq2quNAdj/e
         jzIyKxTvPefNwhvmR/ecup9N/ao6G/WbQzBTId/9aTvmbEb4g8LgilZcX8FAxlLR0ILf
         fkBw==
X-Forwarded-Encrypted: i=1; AHgh+RomsVo2OK2XR4U+muWCqTAb3IjkJHCv7MS+hc5ICu+/CfDM2Npjj2+TefVFzhOlE2zLdutODos=@lists.linux.dev
X-Gm-Message-State: AFuF++n8NZbhG70KoHW/xB0VI7lbAWb0WhiZ4NN6zNTADejVsEXhKwam
	hT4zn8v60VkhhsFIRVDYEjwxH07brvDsgbinIy7jK9UQbVb64+Z5w3pFb6TWDLtPzImXApFppRJ
	4jTeequTOdmJf8aCU55ciWZqpnysI0tb/cXKLk8evqg==
X-Gm-Gg: AR+sD10qLOS9OKcYrIjTlWQanX1DlzibGiBbuyJAK/ljhc77caRMDuGbWBMQrwWTrq+
	noA2TAbQIA6logpIKItpnVH6cwAePYRsAUm58OM8uGAa2kYHNxtGP7V+6EAdw+HDp2D2dxU9hSd
	12YpNxspmkgZ61V+9IfnPVoYnHBXXLCtSFix9no7KOyAhDvD5131BJEZHmvAhM93jpivx4w3sY7
	cP+4uc5oDS3M6ExMsrZtIOHoxfvVSlBBOiRzx7n+7nS0N52rGihR99He4KPKUqgDgUVv4jI+RVo
	Bmm2YP8xMe/OE9+v6OvlDAqRCCMhl/l0N09ORtLjgIqhwvYu8h5Ot5J+5kPP5NzsqpYisDoZNi/
	Mfoi4WBFrMbLzVg==
X-Received: by 2002:ac8:5e4c:0:b0:51b:ef2c:7bf0 with SMTP id
 d75a77b69052e-52e423dda91mr62183301cf.35.1787750932189; Wed, 26 Aug 2026
 06:28:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9650a974-ec3b-49d6-b6f8-89159d399239@mail.kernel.org>
In-Reply-To: <9650a974-ec3b-49d6-b6f8-89159d399239@mail.kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Aug 2026 15:28:40 +0200
X-Gm-Features: AcwNN1W34QF2PZAcvy3R9PLtw4HgRT6ulwuI-xiElq-21GqRFQaQZlS-b0FIZNg
Message-ID: <CAJfpegvhRK8QqRM_dsdNAxyEAGBNR2iFh1mOtH50QC0gMKyiag@mail.gmail.com>
Subject: Re: [PATCH] fuse: abort connection on /dev/fuse flush to prevent deadlock
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Kusaram Devineni <kusaram@devineni.in>, 
	fuse-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 27 Jul 2026 at 19:30, syzbot <syzbot@kernel.org> wrote:
>
> From: Kusaram Devineni <kusaram@devineni.in>
>
> A single-threaded FUSE daemon can deadlock if it mounts a filesystem and
> opens a file on it. When the process exits or calls close_range(), the
> kernel closes file descriptors in ascending numerical order.
>
> If the /dev/fuse file descriptor (e.g., fd 5) is closed first, filp_close()
> decrements the file reference count but defers the actual release (fput) to
> task work. As a result, the FUSE connection remains active.
>
> Next, when the FUSE file descriptor (e.g., fd 6) is closed, filp_close()
> calls fuse_flush(), which sends a synchronous FUSE_FLUSH request to the
> daemon. Since the daemon is the same thread that is currently blocked in
> the close() syscall, it cannot process the request. The FUSE_FLUSH request
> uses args.force = true, making the wait uninterruptible. The thread hangs
> forever, eventually triggering a hung task panic:

If the server doesn't reply to a FUSE_FLUSH request, the calling
process with be hung.   It could be due to a hung network connection
or whatever.

Is this special because sysbot was able to trigger this?   Why isn't
the fuse abort code taking care of this?

Thanks,
Miklos
