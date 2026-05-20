Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000F23BD644
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 13:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779285169; cv=pass; b=OMhkWyyUrqr1PHLy1ja9GzO0d4MPCe8MaLAevOGNw34Zrg0C79GoOtxs0uyrMkKXT5WDa+UMsREtlDs9KJ++EzX6vAaxMHCefQGhT1tZ9aXkttR0dZAjY9UF6Nv2SZKbB8T0+1m++FPKAVSDAJOccwdVR/bFk9A2Wqvgxn3Iy0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779285169; c=relaxed/simple;
	bh=l8QFt8GLcWkfNuqqLpX8SyRhX8Cfk3+UzFjQtG4YJvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s3bxM4J34WovWo0e5BMpmuJ2z45gsI460VDAck/ZjLIOlgr8Z9c2HBt5IUhAZyGicDigu7Ord4vOwQed0+FudE1Csrrd8nIiIWw7QX4hZzUYAKar68oL3GW7JYuo8aSwBNmypKfaJBjdglX1y4975gHF7QmyxKDyuKwy4qaO8iY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rcptfr/x; arc=pass smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rcptfr/x"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-484ba8bc89eso3195029b6e.2
        for <syzbot@lists.linux.dev>; Wed, 20 May 2026 06:52:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779285167; cv=none;
        d=google.com; s=arc-20240605;
        b=OR0qcYXIJkrjshuKVVKgA9gab77stdkqlnfe4KHoy95pu62YxkzfvF1dRcg80uvXNn
         gjp9HKPutTCLbqUCZjDmupiOu5NIaPazfMcZj2fGwW9ddj0YOLAUVlFeW64zQF35+q8y
         jVPVLnh1VtQDgbhxHLuzDvKEaXi8YI00ARLNKjRWEX2qoPTDQQSN3JK1KDgqiGv8AkR/
         yvsNZ5lyXMjd6gmvTi/G/NyzFj/8UStR6Z17H5bzXJ5gE5cWD9us3P/57Wzdsxcz5CoU
         8KhBbTTxp29E9C8/kxbMmcBc35C7detvz74/og79IsTXK3ll82YBqcxuCdfEfmxw1zIv
         TaGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WM/T8xY5gKfQix/PKP9DbDiPyy2bGzxmMt0Voq1SPM4=;
        fh=kYD3i5mA2pumtJgFptczgGaq0lRKlcAqzefUgDB2MSc=;
        b=MjYZKXhoi/blAPSsaIBE8UcVIzDh+BBE94QuEtWoZrWGwmZ+V/amIHgLh2z2Z37WkQ
         L+0XxJXAX7HyVoWsxFNVEIxDp2xUHe2Mi3bbnNh4pOdU0/tdNSevKshyC1ayH9YySdlb
         1alwpRj383Ugk4ER86H//hxHV0jY8R8plyifoJf0+UjAXcDw6LM1TIN84kvU+xdHCbO2
         RVL6MtA0K7SzBNmOXbHBUE9ftPfV5+Pa1n36yGmECOkkonnVHP/nE27we8cmqv2Bprfr
         /hUEjXcaWN23PwU3PE/lRe0Dkm1I7EzD05+d3S768OJS6ui2JS6G8M8aWJFlbN5+mYKf
         MQsA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779285167; x=1779889967; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WM/T8xY5gKfQix/PKP9DbDiPyy2bGzxmMt0Voq1SPM4=;
        b=rcptfr/xQRkrjwQr0tvg1MNmNlNhWfTEsQjegfGAOXNnE0ej+lWpp7tb2smoKkYdZ3
         br+rOl1goK9B6BBaonOsjcT4Kz8znB2JTQM9QjAuxjSIYJqmlCPD6fGKqXE7ZbGOKEMP
         yisuR8YGZ3XcfEgmQfZT+irsiYyT2GYtErYhPBQ5B2p4GM31vEeRH+md9EHTVEdQXMhO
         7FwuRXMd9LwayIIu5VRgXt8H6WqyhgvbFB0UgWFZpFvj6sVSI9dIS3WKupZfxFxeyqOW
         rhYARW7pJufpz5JrTPjmMbKIW1jBfgwZ6k+skqumLVtIcVTbJ9SUxhptkD4aTboGybkX
         ZecQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779285167; x=1779889967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WM/T8xY5gKfQix/PKP9DbDiPyy2bGzxmMt0Voq1SPM4=;
        b=WmgmFEzeZq1uEPAa+7vOQs3amQxttLCpCXCwuxQaattRzM2lTRurXRANdeugoQRLCD
         /5NOsxGlzWgte0z/QVzq6pqqHSG7eGkvSs4cbgWQkxMExPvy96mXUGog6JEXv9udfxSW
         e3Q211Da8OVNYtNQryyUJknGb7oHhLe14nuDrsxdkOwWdfC95n8lNN3sBhoKBM4jG7IG
         GLxMHVTzpA0gLPsKSblrWwB/svs0xJMbkeeJIcxeNByKZ08EGRtmInAZHLL9PwXF2J7g
         5xsf6EL8V18IjcxWs6AUrC80xUCSuUhGPQYf2jCLpU6SVRPiFDYjsBIBGr1AmDjO/JU+
         oFqQ==
X-Forwarded-Encrypted: i=1; AFNElJ81nMD515QzE4DPT3XVgcDgAP61lufUZQO3JTYd4ODI5MXUUNfLDU195G/v4gW/dPiuyYTNqXI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+FayliDDKR9c5yHjjs8zfL0GdE8aIPu7DORlUFzEpEjIUEPmV
	BMpm8ajYAtwIAZFdvzmX3aFCMJ8bSTGZlE/SCrOLbXXwEfLJ3Q1unOuiuzhzG19FYcBIB7lislU
	BoeLN5+27vRtBEA6NNk8fZG/d9O+dLMtn4uDlFY42
X-Gm-Gg: Acq92OHlV5HqnhAP7O5rkW9xrLPV2XpLml8SiBNITNWOBdgwFWp8pw+sb5bHhBHQe2c
	Z1S79r7SujpTDvEhispdmEKVRivxkx9+8GSUM6099ls77VyouGf2LUtXJ1mdQzyuLveRONnp+KL
	6MPZmmeqDcdtdBd+8s3Zdu5zEFN6yYYrqM/+z06VNYdkZz0Uua/Di0eAYU6P+7D5Ed+8bbFqjl6
	TVV/7yBFYnE6+ySD7y3BahpML7sCvRI0QD3IKtiIP1hBu1ZRXja9HHkQzDDHr1zX6BvimbDm5Ls
	gdOOOmMc7c96s5mB7jmxHQiFpV2Afi9t/HYVypHK6kJ1uQgCxlybqF3fX6LYpni6xN1t+r9CaTI
	BVQLb
X-Received: by 2002:a05:6808:148e:b0:482:462e:6a8b with SMTP id
 5614622812f47-482e572be3cmr15745988b6e.28.1779285166352; Wed, 20 May 2026
 06:52:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <b3adb77f-185b-434f-a19d-0a29728733ba@mail.kernel.org>
In-Reply-To: <b3adb77f-185b-434f-a19d-0a29728733ba@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 20 May 2026 15:52:34 +0200
X-Gm-Features: AVHnY4KeXXY6m27xMqfz8LeupixsuLWvWJU5tgjuYjxclysy9-jaoY4C0m_NN68
Message-ID: <CANp29Y4vV=YTTnFt8DONC87Q3_C-bm_6ZgpPPKMgwyOdDHperw@mail.gmail.com>
Subject: Re: [PATCH RFC] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 11:31=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When a multi-threaded process receives a stop signal (e.g., SIGSTOP),
> do_signal_stop() sets JOBCTL_STOP_PENDING and JOBCTL_STOP_CONSUME on all
> threads and sets signal->group_stop_count to the number of threads. If
> one of the threads concurrently calls execve(), de_thread() invokes
> zap_other_threads() to kill all other threads. zap_other_threads()
> aborts the pending group stop by resetting signal->group_stop_count to 0
> and clears the JOBCTL_PENDING_MASK for all other threads. However, it
> fails to clear the job control flags for the calling thread.
>
> When execve() completes, the calling thread returns to user mode and
> checks for pending signals. Seeing the stale JOBCTL_STOP_PENDING flag,
> it calls do_signal_stop(), which invokes task_participate_group_stop().
> Since JOBCTL_STOP_CONSUME is still set, it attempts to decrement the
> already-zero signal->group_stop_count, triggering a
> WARN_ON_ONCE(sig->group_stop_count =3D=3D 0) in
> task_participate_group_stop().
>
> Fix this race condition by clearing the JOBCTL_PENDING_MASK for the
> calling thread in zap_other_threads(), ensuring it does not retain any
> stale job control state after the thread group is destroyed. This aligns
> with other functions that tear down a thread group and abort group
> stops, such as zap_process() and complete_signal(), which correctly
> clear these flags for all threads including the current one.

Please send a v2 with a tiny change of the description:
include the warning message and a relevant part of the stack trace.

>
> Fixes: 39efa3ef3a376a4e53de2f82fc91182459d34200 ("signal: Use GROUP_STOP_=
PENDING to stop once for a single group stop")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Db109633ea805cac54a61
> Link: https://syzkaller.appspot.com/ai_job?id=3D5e1c6b88-c61a-462e-baa0-d=
014c2b72c8d
> To: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 2d102e025..9c2b32c4d 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1338,6 +1338,7 @@ int zap_other_threads(struct task_struct *p)
>         int count =3D 0;
>
>         p->signal->group_stop_count =3D 0;
> +       task_clear_jobctl_pending(p, JOBCTL_PENDING_MASK);
>
>         for_other_threads(p, t) {
>                 task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
>
>
> base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/b3adb77f-185b-434f-a19d-0a29728733ba%40mail.kernel.org=
.
