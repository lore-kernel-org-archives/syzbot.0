Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3679E37CD34
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 13:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368630; cv=pass; b=qYwueqGdf/4/TT0fhL8oF3NPZhuCDaYRXT2fCtL77F0rU8LGo9gASeNxeQI8mNMc85Ai2qoqzIF2XRHxu7euPJkj06qVnZ959/dtxsrI65PGXlpF5SQfy0geLTUzbHVfCSC5y7yAwxxDp0oNvgX9B0+vegRhRmILKNg+T8HxoDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368630; c=relaxed/simple;
	bh=6dJ7X5Wne88nYcaPtxJpx7WGLKQsI8E8HLktCLlk72k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VifH+oSfW5JLpMYf4FiN8aUqO/9FImUXVY5W+BymuK5S/GlRQ7AJJqxdL5gvj1ZwMUGMqBO8BnumlL9pFI4ilpTWoiZHFXN6DpZnfzo6R8Su1Hm1fdLEfoo0GeMcUUspMTCfMuhD0h2FnAGn16xA/CNuJHPdPTKRwUoJjrTfeNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X9So7tRQ; arc=pass smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X9So7tRQ"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d4c383f2fcso5322168a34.0
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 06:03:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779368628; cv=none;
        d=google.com; s=arc-20240605;
        b=Xntee9XNLQj3RPWJHZ0jJB650rmZ2Ym4YKbJbacg2JN9aeB9gP8HX1yT3CIctfotc8
         ML38Hpmv1JIcniRGdxPUaZggP/nRMINyGuQYcy+nrYt5NbteCAfJ+y15IZWcE6SGwMNG
         8kC+YRCC1AfBZIJvZgrnqkb1vzsxMHHXdfRcd0TiA3SVmT92yCXgimrXJ2E3W3FzREw/
         9Ovx1yMqTRxTfCWijLHmTbwiZaFLcehQCf6kszk4kWLRv0cvZVzru3oN4oyFmO2HPeN6
         2BctVW3MmJdLsXu/xhJGvDTxYf0fJzarn/f9WwvgJgpVaRrHCJw0ZHdb0gG0xKnQypJ3
         QOfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qxCMHpyhnLEBRSycUeSbWzaS+FK0wWrNnYOU+YE1n1Y=;
        fh=gwd9bau6brKzAeUEYkdmVpphlYJ2xWvdftGx89VHQ8M=;
        b=c9NyYuH12HZdRzt45BCZEy6AJtZdDTDV1O09AwcVyIMyQQssWgeCsNvGMhf2SgRdkP
         0xhMzyQMISfu4E+Tqd8T/2enX9wODO1O66J1eS9NSwqPOQDGfvnVSX90qyc0Gasm/oPN
         UcTLkn3Y7kXRXXiqpe/YfJ7ZdSR9Px6GkNDzoYTRjFHELmpn6pEUSus/fIeDItx+6i6S
         GboMlsdnzKVJ3WdSLa855VTzoa00OPEdE9L3os9Ainaw5pQroGfH+x1cTbbWcdUwlRf8
         F6SXGVnQENAV80IHnfH14IqRWEvhNZfIBRKfJOvDTSeUgtiysMShYSUMtnKebf6qLn6w
         MRIg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779368628; x=1779973428; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qxCMHpyhnLEBRSycUeSbWzaS+FK0wWrNnYOU+YE1n1Y=;
        b=X9So7tRQbXjcK40iXJ/EdPSoGMs2qBR5RwYrRooliKYsu2MNdTGCwLebsLKeVDs28B
         13CW6EVIjrgxWjr5UiErnVD5TY9pNDfv6qx9LPWMxxB02ko9UORQORzhRv6RYr7pJWU0
         2Q7u0WIq7eX4EE1s+PDlKNuaL0lZzJcItpsFkLIsEaTU91kihjWqROvgSUg62YPK8wTm
         56CCOHU1Qgr9UzmoRGLK9nHRKCYF0hGjBBYlKLjcje09M5e239sC4C7QWqUVLp+2ORot
         /ZM72YB2A7ojAJ6SNYZF0iC3SNLrupVCFPxg2YaoYxlY4DHdAOEEeIJ8lbtx8gH/A9U0
         HQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779368628; x=1779973428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qxCMHpyhnLEBRSycUeSbWzaS+FK0wWrNnYOU+YE1n1Y=;
        b=YpRG8oBb3ZJ5sz99seTHLcD+Fq9e58C7lgwkVWenrM7ZuTTuZlnh5X/dFjDR1vDR6I
         wQPj+vx8BFamOny6i+NhMU4t0obkOVvl/1U6ftwimVMv6/+8CpPTxB3D3QG0CzMbl/o6
         yGsSiYj4taJYTQ3O/Fgi3CVmll6mxudfF4VySs0brKbKIxP4qrIDEVNeCek6rbEhqwkR
         B6gEi4mYJbqgdsWqy190sv/itSnLmpjv1a45IB34dZZSEt3HMb/GWecoZl7SbVe4sIHE
         mBRdUzBQ+QoDhJqIUc+hz65xSZR9DgjGCee2HEkBv3Jaed2DgvjqykeL1bw0UnyPyYkV
         ay2A==
X-Forwarded-Encrypted: i=1; AFNElJ+50JMgdxHhktw0rf4+HZYNi+VKz+VezimBwduXC6GTsIvnoJ5mRw6y57XxK1ksHMtEHN8Pvoo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHgT0Y+pdAeZI1xO72ZTlayXXARSDxKgZCwcatChFuHJEOPz0l
	jntPW+8CuwNFSGtaWukiMPj9WwIj4UTCKJgiq+lrwKDqubO6JInSgfsP/feY/SNZTF84qsr/6Sl
	hQCfko9Cj/Vb7wPueaWpz4sjvM2Q07rm5woLmCdvn
X-Gm-Gg: Acq92OFoo5UhiSPavpnvVVgE7N7XYcnA2eSRxtpdQ4hr0tPdUYCj3Uq7QumNurFQGLl
	J8kBbfZ4fbTKeDf5R78vDFi3Quxwiy600pospI3xD8FkW4c+IHScRQY6YRDJQS7Q5hqWnggL2aY
	Js1jnv1RLy5Wdip/79Lss/VZi47mtaNtCihqDrTeQCHV4bPSlH5XC9POEjgygUOboWw7Wy+mnZ9
	uW/90dA66TZdrqetoNCzI3tNVJyNzAJXs+tmeV2bAKwieKcyuXHUiLI9DJ0oNCZi88ySmxdZaKt
	O+VQg33a4Q8Jyzhd3I0v22cVyNgRdLr0QWz3skfPJekeIcDKirmYy46fxr4DbIUdtFQV9R5t6xy
	3LRqm
X-Received: by 2002:a05:6820:1ca4:b0:694:a23f:cb17 with SMTP id
 006d021491bc7-69d6ef7a509mr1193410eaf.52.1779368627369; Thu, 21 May 2026
 06:03:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org> <20260521-kultur-zahnpasta-f09198836179@brauner>
In-Reply-To: <20260521-kultur-zahnpasta-f09198836179@brauner>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 21 May 2026 15:03:35 +0200
X-Gm-Features: AVHnY4K2ohdGD9DiDdU8tQcc3npboR4OiC64xULTDh27OoISA-roSFVP6ZCY1qM
Message-ID: <CANp29Y5Cjy6k2vLp2+2O9FXwRXAmNP_ja6seORVXVQnrdUwH3g@mail.gmail.com>
Subject: Re: [PATCH] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
To: Christian Brauner <brauner@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org, 
	syzbot <syzbot@kernel.org>, adrianhuang0701@gmail.com, akpm@linux-foundation.org, 
	kexinsun@smail.nju.edu.cn, oleg@redhat.com, peterz@infradead.org, 
	syzbot@lists.linux.dev, tglx@kernel.org, Dmitry Vyukov <dvyukov@google.com>, 
	Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(+Greg)

Hi Christian and Oleg,

Thanks for reviewing and accepting the patch!

However, it seems that we first need to clarify how these types of
patches should be submitted to ensure we don't violate the Linux
kernel rules regarding AI-assisted contributions.

In a discussion under another patch by syzbot [1], Greg noted that
syzbot cannot be listed as the author. The official documentation [2]
isn't very specific about how to handle this exact scenario.

Once we know what changes are needed, we'd be happy to submit a v2
that fully adheres to the rules.

[1] https://lore.kernel.org/all/2026052107-recast-opt-946d@gregkh/
[2] https://docs.kernel.org/process/coding-assistants.html

Best regards,
Aleksandr

On Thu, May 21, 2026 at 2:40=E2=80=AFPM 'Christian Brauner' via syzkaller-b=
ugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> On Thu, 21 May 2026 09:05:43 +0000, syzbot wrote:
> > When a multi-threaded process receives a stop signal (e.g., SIGSTOP),
> > do_signal_stop() sets JOBCTL_STOP_PENDING and JOBCTL_STOP_CONSUME on al=
l
> > threads and sets signal->group_stop_count to the number of threads. If
> > one of the threads concurrently calls execve(), de_thread() invokes
> > zap_other_threads() to kill all other threads. zap_other_threads()
> > aborts the pending group stop by resetting signal->group_stop_count to =
0
> > and clears the JOBCTL_PENDING_MASK for all other threads. However, it
> > fails to clear the job control flags for the calling thread.
> >
> > [...]
>
> Applied to the vfs.fixes branch of the vfs/vfs.git tree.
> Patches in the vfs.fixes branch should appear in linux-next soon.
>
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs.fixes
>
> [1/1] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
>       https://git.kernel.org/vfs/vfs/c/71556f3d55ee
>
