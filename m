Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8491F401486
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 14:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779373955; cv=pass; b=cmQxDDloIr+pgi9T5Vxq8ebT93vZshPwt25Pi04ADlOAvCc0zOD5ffG0/tIdGoDwVoykjhJVemyI9zS2BzUxc7V30OwDC+//K94shudbNM0MzsaVYW5lZJXanuXo8WKMmGRkgK2yyLyLZSZHCup98czBytbqzrC6fai9iHnUFCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779373955; c=relaxed/simple;
	bh=qS277raqTpI/J8B7aqdqkYDsfRhUx2nuT1N+aO4hiMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ss4IULONtCPQyeYSPSWEUr/oFpeoC3YRJmi2XvGK5kH19BbriBuJwsEOQ6+ba3UFF6HMCo56ScfruSv5OXJhQo5C8clunaHGTOKpQHOlpjWHjpEe2QfXCE5He2qu8HJfDpaqXIdKkVb62nGgkDjklAOOQNnGww0QhaBdpN1Zza4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I6bZzs4v; arc=pass smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I6bZzs4v"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-69d7aa0ac14so168959eaf.3
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 07:32:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779373952; cv=none;
        d=google.com; s=arc-20240605;
        b=KbwjrlOYgqHode4Ss0rj3Qf9WzObKjfu8GH9Japh3v+j8if9fmHnwzWpbmobTEk6Eh
         lN/s4NzmsMpIj+yHVRm8sWjMsDBQC91hVnlr4LIV3WjnrOobhrjX90l1DoWm7Djln863
         K0SEYe0Zs6cu0BMlCBGCCEBmc7xQ5cwocJKLQMMNV23Me+3T/iTuuKs+xR5IBm1dup+M
         qNUwQUOuUO6YU9jzZUgCu3YbHvcWpcy9vgqUvo6Cc2c0phGCKgolDAQ07S4HdE3ixryN
         HJJCVWrZCrOzYXSlx4hPnkeNZbmsKKqHaMuEN1kwOkXKVChiy+8ljBM6Ejc80u2HrBA2
         XpiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qS277raqTpI/J8B7aqdqkYDsfRhUx2nuT1N+aO4hiMM=;
        fh=9LbYgvyukpqdUNLvKl4J7+t2T+xswNPtm9O/hwWpuu4=;
        b=QLglbV2a3k5iRvDM8dm333y2UJPIYPyLYKQwUFcO9HVtTOJPPes1pSEWdRtRXbXPg0
         yAUyBEshfg39T7qci2R+L9txFeTHZv5vmK0WaiMEGZTHrMgmZDzIVw2VbIataddD+G4F
         U5/XjV4o5QidOYjo0velw6bEeqOAW3IZ7uIXvwo8KkQW9jt2YGFk2ZD3eRaNf7KKJO61
         1DFc0zNzfEd48F0Ahhxtq4zg/ZtD6YpTPcUK+fG4dPGrAPRlfwpCMfo5Nfz4Inv2wt8v
         jpPGxlhAc+9Niv5tckFWyP4wmGj44nPPkfLLWPSVExZz3Nz3AkVKGIXzM3RAmuqYzPD/
         sCIg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779373952; x=1779978752; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qS277raqTpI/J8B7aqdqkYDsfRhUx2nuT1N+aO4hiMM=;
        b=I6bZzs4vuZNyWoNTAEi8R1i3KULRKqvg7uE+iGdacLiR+kkYaHLiJ1bszvmmLNns1S
         2VMa50R8zCW4SIjXq+eghENu1xtGBOoiNJh/+Zo0AWD7lK0Bnavo65+cZodjnxsuSrYZ
         mQiSJVTTUPyWXSjnfMDoaiq+olIDoY7w8W4aC3ceBmJzrnp9k87dGx5LPNL/TJ1XwHcO
         +o5r3ISOrSa5w6PtF1QKHnv4f8tblc7XGKw8nrdtVwJPmXNEFAKA+b+hOKF+iygaTc0v
         JaT2/0V0qGLbNlGDbQZXyaFGsKxvOihFBLbBloBHgMZjwFNHcfWr/NQKaN2bitfIHWyQ
         3ajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779373952; x=1779978752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qS277raqTpI/J8B7aqdqkYDsfRhUx2nuT1N+aO4hiMM=;
        b=qYLdMwuIiBIAD3s4p3FmVID8e5FObVZLOC6F9nrTDkrWz/Hk9qcIY3sxS/0bpvqra7
         8dtc/4wCT1VNi++H0kpcb0WrowrjkwV6DrQsosEEopozv1ocYWbCTg4bIYBHwUnfax9I
         EGrLWvN16Wc3ZnHrjkofO1Tb8AtRib75V8pY0UcmN48gVBxTEuZyKZ5gP4taKaSNWCQg
         ihiSJmGyJ9ZswIo/nxJ7XEGoXKamWABIL+tcrrE5XPJzoS7pIVnsB/HqLnpFB8NmtLQH
         ynR+Hy/b52cLv1ThB/hv+8TkygzxIkodjlj9oRukDyaopb3EPcyRB7basQ+teRM2C5qH
         vyiQ==
X-Forwarded-Encrypted: i=1; AFNElJ+IOwrv/WIZwhqWLTa/HTRNpUVvHBJJI8zikiIAsYw8WoS6AHqsr4SNNq1qU522eUJ51vSAaMA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKFI4Y+NyCyRfbIbJptgLFMmclo9q7LMonhzZBXAem0SxxcK0C
	OeKw/bE9hE9H2Q0nTEW/wW6g63yQMJBfk8JlVl3Fyk/rLAyo8g3h1IbD9eEHrO9hwKF1ze0f/84
	Sr1mQFO8HC1fcK8mHfiwJhubOYmgYc4B6Fv2/B3Re
X-Gm-Gg: Acq92OE9hzNGjyQF81bAQmSLm3RT1WOWBSVheT00B6xrDpG54gfDOZbdNV8CmGfq8wp
	WHB0n3lNMfG5myaWfWVXG6enXKpsSkwUCxdYgpaX+E6NOxjy0lcJm4nZirlMTqp2L7dOeOu5Q/x
	+BOlU0U86+veXKgeLIheT1dHZ7n7uyemuZH2ToHvxd7FodGgv3JR3v+WWk5V4TrnPHQEov9b+lF
	2Ewr+iuaidPqp5YhT1cw3gmZAaOv0U2xZNLIBd+JsNZJzZ9QPmpg2MSUVdk+lu4lzhB1osljeax
	OWLn51yrQnc5WSFWaIs1q/dUjQ65ENB3NDXEUtcPGMfHEfcoNMIoRdNG9Poz+a/sWa1A6r6XV+c
	YgpPT
X-Received: by 2002:a05:6820:16a1:b0:696:15bf:ca5f with SMTP id
 006d021491bc7-69d6ee61d3amr1467678eaf.19.1779373951835; Thu, 21 May 2026
 07:32:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
 <20260521-kultur-zahnpasta-f09198836179@brauner> <CANp29Y5Cjy6k2vLp2+2O9FXwRXAmNP_ja6seORVXVQnrdUwH3g@mail.gmail.com>
 <20260521-wehrlos-beeilen-f02efdff924d@brauner>
In-Reply-To: <20260521-wehrlos-beeilen-f02efdff924d@brauner>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 21 May 2026 16:32:20 +0200
X-Gm-Features: AVHnY4JI5RjYA0cHAePuXNbABMbfo4GXhchF5A-TJ8V1UZUJVEgjG2nOEezZmvc
Message-ID: <CANp29Y4ZCpD5W1pECgjz2DXRzv7vgpVL0VikSet3yhFR68ejFQ@mail.gmail.com>
Subject: Re: [PATCH] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
To: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, syzkaller-bugs@googlegroups.com, 
	linux-kernel@vger.kernel.org, syzbot <syzbot@kernel.org>, adrianhuang0701@gmail.com, 
	akpm@linux-foundation.org, kexinsun@smail.nju.edu.cn, oleg@redhat.com, 
	peterz@infradead.org, syzbot@lists.linux.dev, tglx@kernel.org, 
	Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 3:17=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, May 21, 2026 at 03:03:35PM +0200, Aleksandr Nogikh wrote:
> > (+Greg)
> >
> > Hi Christian and Oleg,
> >
> > Thanks for reviewing and accepting the patch!
> >
< .... >
>
> Submit under your name just like you would with a
> coccinelle/sed/grep/script generated thing?

FYI I've just resubmitted the patch under my name:
https://lore.kernel.org/all/20260521142240.2973022-1-nogikh@google.com/
