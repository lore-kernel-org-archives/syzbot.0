Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E052701DC
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 09:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354209; cv=pass; b=Bw3FcbCooXGTP+Uwoo1ZgCX2lDqXNN0utrgDwEfctwdGunWndNLyiaXmwPg+SAeiQUGm+nP4p8I8iHMeW78NVw++c4kk7D1+/4zBkGCprOKD8dvefz1AsCS5sxwpiWJOOqqfXmF0Y+jifpf20WFciJY6/CV4RP5jX8VfC0m1y5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354209; c=relaxed/simple;
	bh=dKldEE4WAvGJJIut1irHIkPd6Hb4GfXoWSC9xm2eiEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ay46tipio8E2iH8LjBymoFczw33oDiMCB8XwKiShlZ5U/UsAFldw90TbCIqmwxMBtpUrY5CVfDDp+jKbz3wlB4TxreqLAugEYmhv0w07hdbDMMSI5BsDL+eg+iMm4J6rgkcYhDsQIKlxLoUeRd4hRY238mv0PD0lAYz4gZL0cK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dV/vhgwv; arc=pass smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dV/vhgwv"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4824b15c19eso4958809b6e.2
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 02:03:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779354206; cv=none;
        d=google.com; s=arc-20240605;
        b=gLg89xwhCSSORrWWQ8r2ak+X7EQek5ibTNGOandt5I26xaZ6VZJPpnaL77umeOX7LF
         1j48Mu/NB/jC6Lw5LxVsCwsndmmaa13OzlRCA3SklvTBAjLJWciU9Cp89mXm03UOjCFq
         fGqz0cfxA7S26QRnwKCFSjpQ/kFNJ7vRqRVXqcL6vjMhxJ18plXMl6L1UZJZXuVkcDXX
         yVTTCucU7Mp/fL/6SAm1uzQtg7G1ImQ+P8xJLkL1qsoxkpmFWraHFhhQup6t4gnaa2S8
         /83WbU3mH776jCRYEFiNJspQjygSD/XJ6cbsscw5DlK86txpL1kvV7MWUF5FOw9YtzuZ
         OgfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sgQRuQKYpWQErKt/0tVk/1bZFlhWxp+6IFmanqHwV+c=;
        fh=8TrppkfYJKNls9kWAk4k4aYmx7tWzhdPO474gEKeabQ=;
        b=hJFM2Q1oXWaW9KzJ/ek1dyPHTd4nnUG7/SUbMDwJ1kuV0MTrcfA73wCZvlo8XVaVuq
         pqbH7qg8H2P16pr4yAw7DZa9h9aXJq8pdgof6Ts3OsaJ9SzYtFU3LWszwLnj9tuD4WBh
         +HHNxVGYSJNSlaVGNKhBc8A2AatcejuGJ1Z2T0MMkPpi6eSWQMewFPcpPSL2gpL4omky
         ZV+X2zgesvL3cwJqEiLftGXXykWznptzYxc8KujekOo9g/KB06uPNDtIR6XATWmRFZTJ
         00+LvtGQ4G1r5rdu7RIw4iY6LHkDx0vh23VG4yQ+Vnfr3aXXk+uT+k6wvUNi6S4nkBzW
         PsTg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779354206; x=1779959006; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgQRuQKYpWQErKt/0tVk/1bZFlhWxp+6IFmanqHwV+c=;
        b=dV/vhgwvWwSl69FUB3WIyGZqiF1Fj/G6X7ZwVwPEOXrFRVGiG1qv1GIusjG9sJpELX
         87xAiH38VUlighqPoiTtY+IL2ug+Uiqa9GruuOAH9QC+gd8m5iQtw2eHBAGO1jBvre7L
         oopYKO1YmMMXax0Q7C4sAagPnke0ZFQa9vt/QwNtOGSIsyP6WAdABAuR4UCjVnJX+tR0
         w6aAe7pFwq3yz50TdDvRa0r1s7R0Ajl1TgWKhUXQlGGt8rXHC+mGZofXoZUem7ACYK+i
         ZzDoplSm0cPeVYj/yBbdagKWSuyWSF5Rr5A/OcH/4hSGT4H2Pu8k+BUe0zRIaIj81aU/
         vE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779354206; x=1779959006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sgQRuQKYpWQErKt/0tVk/1bZFlhWxp+6IFmanqHwV+c=;
        b=Q1d3L5jL0izCRxx5Gr/BzN4PnM2jiV6FxOVjmBwuABN2HfdjTgaa0xSLuSecsLGM/9
         qOuQeFnrmNm8UE0epAo+6WvbvGKDEd7cQ1qiB2cQ4H7F7xS6aNx5op1pwisiySA3knZW
         LxyukqLhXfIQ78ZQjuBQ63s+bZpz8IXrZqDNmznXoR//G4JTWEz/7T5ybW6QYPrx2eT4
         YC0vNJQ22bphsvFaTnh7u6OWzHfJGPacdOfPRGrAo6RGAHqQWCtrWgsVzAioR6nUf5wN
         lHmQkxHUuPlxUa0LdxU4VCnb86G6mdezGlUyBNUPT6GwFIxZetys0nLXrRZ/zMNy+b80
         lv1A==
X-Forwarded-Encrypted: i=1; AFNElJ9SAsWRKLw5stzKLP21nY2cBDi8oCGwUoqCEicgSpSR7CT7KcTNasnocnFFJtzixEbZ8SUvfrA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwRLPOoL4XUecmhPir9dOK6ghVo8oxzjUUfXs3qSSyZddENUpD
	5uJDQP1cKHaazTzHIB2L6y3WKbrGn0tyaObNzFRy6EZqYTd1/8jggiidjh+RZT8p6TGTxbAqa0N
	GxTP261IWXh2BNuJox5Qu6QOeazWvnt/0pq6REESrLlpbl75lOokWlgcs
X-Gm-Gg: Acq92OFeoI1oqhDZfBZhyKoKVCybkVEEpUXeo2kP0WdUvbLTxlvk/O+5SfRgZmVjtKB
	PdF2EYwGt4D5uhVGHaIQi5ItB1RiWArmPMJD7+5mpqVPAMxMrGHgIodG0y9dJuAg1TUtQSYCR0r
	WBYG6rldsrUMbw9f70Ts8semLxvfDvt1ApLm7r4tqMXMRN9BoD0+9OveX1tGXvOJritM5+tZtHt
	VCY+d2W2AERSEkSoFz3Upw9INQDxznASBccefHcRofJWbJX0Z0LQ0J1Uh2HTovkJByjHw9Pugos
	6hY6pA3dzvKZj6fJ/X5DCPOJdI9A45LBBqDRSu0KSbq3BFy869Z18EpPYUTjmrZeY6nkWBAgX4A
	/24Yp
X-Received: by 2002:a05:6809:2c4:20b0:485:3d17:df7e with SMTP id
 5614622812f47-4853d17e91dmr71736b6e.42.1779354205986; Thu, 21 May 2026
 02:03:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <4c5b9b97-0b9e-4b5f-8bc8-b2a274c1374b@mail.kernel.org>
In-Reply-To: <4c5b9b97-0b9e-4b5f-8bc8-b2a274c1374b@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 21 May 2026 11:03:13 +0200
X-Gm-Features: AVHnY4JANb2Zowqo9uAYQMRV8CSwpdDLKHQbmbi8nidKXg5hXWxcSEQFanLepc4
Message-ID: <CANp29Y4b7p05vrFmEXN6yyz+UExiEvNaGe79Fjga0Sjjd0-RFA@mail.gmail.com>
Subject: Re: [PATCH RFC v2] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, May 21, 2026 at 2:31=E2=80=AFAM 'syzbot' via
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
> already-zero signal->group_stop_count, triggering a warning:
>
> sig->group_stop_count =3D=3D 0
> WARNING: CPU: 1 PID: 6475 at kernel/signal.c:373
> task_participate_group_stop+0x215/0x2d0
> Call Trace:
>  <TASK>
>  do_signal_stop+0x3be/0x5c0 kernel/signal.c:2619
>  get_signal+0xa8c/0x1330 kernel/signal.c:2884
>  arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
>  exit_to_user_mode_loop+0x8c/0x4d0 kernel/entry/common.c:98
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
>
> Fix this race condition by clearing the JOBCTL_PENDING_MASK for the
> calling thread in zap_other_threads(), ensuring it does not retain any
> stale job control state after the thread group is destroyed. This aligns
> with other functions that tear down a thread group and abort group
> stops, such as zap_process() and complete_signal(), which correctly
> clear these flags for all threads including the current one.
>
> Fixes: 39efa3ef3a37 ("signal: Use GROUP_STOP_PENDING to stop once for a s=
ingle group stop")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Db109633ea805cac54a61
> Link: https://syzkaller.appspot.com/ai_job?id=3Dd70208cc-862b-4fe3-bf02-3=
031e10cd0b3
> To: <linux-kernel@vger.kernel.org>
> Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>
> Cc: "Christian Brauner" <brauner@kernel.org>
> Cc: "Kexin Sun" <kexinsun@smail.nju.edu.cn>
> Cc: "Oleg Nesterov" <oleg@redhat.com>
> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> Cc: "Thomas Gleixner" <tglx@kernel.org>
>
> ---
> v2:
> - Included the warning message and stack trace in the commit description.
>
> v1:
> https://lore.kernel.org/all/b3adb77f-185b-434f-a19d-0a29728733ba@mail.ker=
nel.org/T/
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
> See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patche=
s.md for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/4c5b9b97-0b9e-4b5f-8bc8-b2a274c1374b%40mail.kernel.org=
.
