Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DED13DDAE6
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 08:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004467; cv=pass; b=lCKz6Mw0FcFould0CmXRX/I/LSHa047Acp1JP0AP4Cqao+C39aSc2Gz486XkqRs1ERB5+ykytuWRtW6mEqi4b9w5B7+k+ya39Z7fZeXIWdRt4EzZUWzb1VhcSg0Pxq5tw5vIVQq5Cq7vkn5Lch7+dtQSYMWFOiRSY0EVGo0NmkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004467; c=relaxed/simple;
	bh=DQm+7nJbWgzZOSgakIrQ2bxhOp+OLa+HAHWPLhyMNMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uvfC75sSEWfsu1C57803s5xTz2YmUnhO5GaXssHJBCFRTAhY3SSKPI9vay+FuCsA9Ldhl7vbudOWps1L0FRvppX+20OyD+M7OtUTSg/ZSvjLeFG8wyH8MdZSYA0pc2GnJU+UvGP1R0qEH53mGSCw5gVG3Ow2uvsI0CQxcS/4xo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AUJ8tdH5; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AUJ8tdH5"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7f0167e59a3so1129104a34.0
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 01:21:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786004464; cv=none;
        d=google.com; s=arc-20260327;
        b=JIS7WVqjpru2/sONyhMgosxlsh6Og1J64oW6WgcoYAC4d0WZznRKHRKGCnXCtMdj0s
         J5vgNuUPBJ08qfTdgUNmSkcRm07CngkPk1ym61B/gDaJ/r1oTcudBvfHXk9VwDwAqj9Q
         6VG7zckDlnnny5UIQrOg9lxPd0cjvRXydWub2REUUqct1zYR+sJ2rBZfAGf5LLj4cjvY
         T7E2A8iWAN2nsNHXpbvXJjiq5d+cjL5NNhZ01Z8ChEivr9Xve6j3Rf+CpuRe5EPlQ9gQ
         rr1jxgFiZBRaeRcwRbuUS4jLqnXSE07GdU+CnQBiK+GYakNN6aZ4QinAxrQaKk7YaYrm
         tj+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DQm+7nJbWgzZOSgakIrQ2bxhOp+OLa+HAHWPLhyMNMY=;
        fh=ByYxB3oSeh5nZmztms2b0oU84aO0oiU3bIixjlFsG5k=;
        b=cGE89YF5tuyMX4zBtRO45Wj93j+NpmVJmTp27swpRHi9yh+5yhQ4MvB9iC6vXtzsHQ
         Biw6+Ys64Z5xiuWxT63o66lxj2ucqwdGhMYmLeyCP3PRxycaudZp9ilSpBRzRLfYpBRm
         0UDWwR0Mm6/JYf0WE6S9MC3OoGQf5AZmXM0jQyTFNcM69rKjSsR43vPVSAQLVfSjWNQm
         0isox2hioJN1eLG/6BnX7jFj7kko+uYMW6XxFthEQvuXoC/QSKPkkQvm4dffSeuUwmfG
         uyoY1aHrGNM7R0/UhHiKnvSecicdmOsDOIYshwGO43Gt7hEPlLn3luQEvS+B3vKbZa4P
         2tlQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786004464; x=1786609264; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DQm+7nJbWgzZOSgakIrQ2bxhOp+OLa+HAHWPLhyMNMY=;
        b=AUJ8tdH5gOeXX53Te7W3F++DxNhD31CacDlZJE5EpbI9H7H8/F6j3w4g0yh1mc19kn
         TiMKl+I3Oj456hDOvrNRBcE2SyeESyiIYw9FcnBI0mGLf2+rhTU9FrMID58Zjw0UmUV4
         Xz9DMGLKnCWXa9d6u1U5/rXQmdpocar4EBC4C2lfOpXmXUm6MW6vI76POmiHZSHj4UT1
         WQZb0vR11q7rtBsajANJyOtOW/zOjRfM2Z71nojRGYCR7lUW5/Iu/TrygDuNyZLbbpZy
         ls/PcXmF8gHQwYasI4soL1FWJL/B/ASvzGXzKx0U+QiZ4XjVT6iMy/U4df8wSAmtPSMT
         Pzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786004464; x=1786609264;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DQm+7nJbWgzZOSgakIrQ2bxhOp+OLa+HAHWPLhyMNMY=;
        b=lZHRtvF755c4YfNe7vMJbFnNmt0VfdDSWzYQ/X4//dIH7QNHyY/VqxaxH4wQ48in4q
         vBV1luLBbiUQwt6jbQNctPzQHljnTvZ4syylkHQATCt37AWpsK84x+3ZD1su3H2xr5OF
         r2+yrJ0V/IH0yQ0Yxr4SpUkuu4B9cwtBSdbwrwC8BDFuS10CZ/uQTZiwwzZsGSo5tWSw
         UqIQBDDBdfs82GNHpr6CUkJohjtnkn4KEnmSA8HsmGYiRk8MSO5/LratzcL/JXOlEQIG
         eSRPH90h5XoQwqR4kNg6+69TX1db62q6SpGqzlngUQOnGwkRchy2TlMqq+0DjS1oB3nj
         6fcA==
X-Forwarded-Encrypted: i=1; AHgh+RrmHg9Hc8rLMFNCNEqa6osSRUxrVaUCzMqxFdmxSD97VCdeXmyLauMb9lpIXdILjgkc4d4DfRw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNceyk5FipHbGPHF/Wd8/1N9YKnEfbgbPi6xQhKqX8XZ0TpmUL
	IV4W2eqoMGponHokEYVBOuG95BBzTiAn+7CnyWkbQNMGimdZMEqQP4qhXCg4EsuIwiLum/VEQaP
	FMOun+L9LWIBdZytIDBh+OjV9QBbWze9XnIJ9TlXv
X-Gm-Gg: AR+sD10nt2EozYQAe0xJHOVy5vZBfGDIfW11dQ6rHeNUF1HdaUJz09TVI9N5bN+tSTm
	T8urIxqs1LX6mfnDeY0WTIepOn/JHcA5SibL1qqdumpiXSEeM3iSitpU0hgrZf6TGbQmc+/hhhe
	xg48QarRlwU6G9egMKAOj0uk/PYF72Mi20L/ntGYDIawe2RwRY30lsdbxzGvsTbnncyjyT55hFL
	Q5qul8dvzlcD12NWfyfajQCsw5tfjq3XcnGqSqYXuXR5OF3uYWqlou1P7RRpknJ8BjFA6BnWe7D
	SEQP3BDRUDJF8Gmh9Uzn26dxJWqe238FH/d+aBE7hMxZKDft/yX3Kw0omCo0SR4NcD0cqbeJqcN
	Zt/IBcRB7kDWKMNGPLjW9hEclNXoitGxXJhw07tiJVfJ8CmKDYaZ4YgFuAs2f1FXkcLrATyHnVI
	m9i3ZIV7WyEHqc
X-Received: by 2002:a05:6830:83b9:b0:7e6:f7fb:968b with SMTP id
 46e09a7af769-7f1e5c1183fmr8101196a34.2.1786004463813; Thu, 06 Aug 2026
 01:21:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org> <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
In-Reply-To: <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 6 Aug 2026 10:20:52 +0200
X-Gm-Features: AUfX_mx2KzgUvmSWxAEaAcPFDO07eE9PP75CLUmi62JzPJbq4FdUeANFUdNkvtM
Message-ID: <CANp29Y6sHOe5QY6BgzeUtKFGqc2pDyP8WAUzQ6E1-3oYgZTY0g@mail.gmail.com>
Subject: Re: sysbot AI patches and wireless
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, Slawomir Stepien <sst@poczta.fm>, 
	Krystian Kaniewski <krystianmkaniewski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

Thanks for reaching out!

On Thu, Aug 6, 2026 at 9:57=E2=80=AFAM Johannes Berg <johannes@sipsolutions=
.net> wrote:
>
> Hi,
>
> > See https://goo.gle/syzbot-ai-patches for information about AI-generate=
d patches.
> > You can comment on the patch as usual, syzbot will try to address
> > the comments and send a new version of the patch if necessary.
>
> I'm going to state, for the record, that I'm going to make judicious use
> of ability to ignore patches, and apply it to pretty much all syzbot-AI-
> generated patches unless a 3-second review says "obviously right".
>
> In particular, I will absolutely *not* "comment on the patches as usual"
> and argue with an LLM that can bullshit out code faster than another
> computer can even deliver it to me by email.

Some clarifications to prevent misunderstanding:

1. Every AI-generated patch sent by syzbot has been pre-reviewed and
approved by a human engineer. The person who approved the patch is
listed in the From: and Signed-off-by: fields.
You can see this pre-review process on our moderation mailing list:
https://groups.google.com/g/syzkaller-upstream-moderation/search?q=3Dpatch%=
20wireless

2. For the patches already sent to LKML, the bot *does not* send
automatic replies and *does not* automatically submit newer versions.
Once the patch is on LKML, follow-ups, comments, and iterations are
handled entirely by the human developer who signed off on it, so you
have not been interacting with an LLM.

I apologize for the frustration this may have caused. We'll stop
sending AI-assisted patches to the wireless subsystem.

--=20
Aleksandr

>
> Whoever is currently pretending to be the human in the loop *absolutely*
> needs to think about the patches, and if that's happening it's probably
> no longer an AI-generated-sent-by-syzbot but you're going to rewrite it
> and send it properly.
>
> (IOW: get lost, syzbot)
>
> johannes
>
