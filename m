Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6FD3AF67F
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 20:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778703003; cv=pass; b=G4ofMXZfl1cT5/4gNRtxFvs4tEdxLnR8zbwc44MWYdoYOfoOmKLcvYofzFCDArptYY/MWVfdzmy3JYNtjIJbsyeytQTeh/+OqlX2gDXdpe7uCfzZXoPQfMpJfJ/n/HjvQllY5wA5Iu5jbipXczhD9Hl4muM789AXGuU89Sa6OSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778703003; c=relaxed/simple;
	bh=IfmiBq/Qf7ZO6YgNBXdtysf2PpHdmxZ0F0ZkYZZNqok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ANdd91/3QannUZvz7y3kiOCIaL97OhYg03s9fl6NRkBRmujivN/FX/3D3mDDAj3msUt0HfeVSmtK3M44RG/nhakFIf8QWN7tFt9GQd0QR1sUiS4tcMnXhEmH7JV0Zh+hU78oGK4jnljl8N+X0+ugkQB5yJqPxBMrG0DL4BWApQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YBoknxwW; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YBoknxwW"
Received: by smtp.kernel.org (Postfix)
	id 1706CC2BCB7; Wed, 13 May 2026 20:10:03 +0000 (UTC)
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 263D2C19425
	for <syzbot@kernel.org>; Wed, 13 May 2026 20:10:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 263D2C19425
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-408778a8ec4so4006254fac.0
        for <syzbot@kernel.org>; Wed, 13 May 2026 13:10:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778703001; cv=none;
        d=google.com; s=arc-20240605;
        b=PPyrUpyveWd232quHp8YSA0mgRMDwDr4EcqYQ6S5t0EQS1ut9InIwWXPF3NUkZj/fs
         BXPRwJt38Q8BUJZyAb924DePGHM1N1WyY44ESIMHWGgLOYUnxg+7PbMC9fGG+F3eed6K
         +k4VvCwbY87wrivj+QW0ABclapRwOIinAwXTSxSbiFsc/nVrR/1JHM1ENeqALEkDp9+D
         eIc+Spjm/HOPX5eekuhynEaW+zAvPcFV8B6hI3vECfKzXunv2emwNFjI1hlYHAPgaUT1
         oW/OebkbPyaSNzw2XY1gTRy/bKi0roYJur+tKQ1s81X5Gq/rNJbqNcYYLe/efpI1yprE
         G0Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9FN9Ag4yWbA97j4vwDvwIHNgGdFVfW/O8GGWhymSzGw=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=dJC5nil2NlwAdO/KhgEbySJqlrFR4ukbBuR5cg5mz9rftkaF+d8Fg7wsjDdO7pECSj
         +pd599QpsjxDAWMFC+AuqUW8GxBGH1bVlyYspxVk18YxnoO8OV/O0MBrKXI8/kNUCofm
         B7c+rlovR1IE6YrHD35b0XL43LGWwvuQzrrLaRrqjFYfj2EzKvhGGxmUv4bRTg+vKOJi
         bojoBnA6wmRxu4PQcBlBrP+UgQiF/CpUgs7LdnWFEgksVtgI5eOf46af5/Ce1E0ss56Q
         0InvxHRazJ5zcbeyrwKvSYBxM8JZ0xSYoJ4Eh2ZyJbhM/5AZ3d92Vz/VoYK3TA2uoqRC
         Yoig==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778703001; x=1779307801; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FN9Ag4yWbA97j4vwDvwIHNgGdFVfW/O8GGWhymSzGw=;
        b=YBoknxwWIMYhMCNCiyUV3MyMWxcdqT/e8jOg7NFys5cBtIYxk/bHKG8mo2L6jgY960
         +YGuIwcKkmLr8TY1pZrYVO/04ngKOG276vP7Fl/O/2gNSy7UlVmRsIpojgMu0UMfKYW5
         WWv9DLKyOY59OhbA3d1oCQSNKfJ9uBXbI00S8j8fklFmbpm/ReStOYMuDwyiogWhc+FX
         SY5gsoK9imDXOMhMPAqz/OBRDejOOWhzkdMJVOFnYBgzIam+A2fcnB3Fn1XbeCX/Tzea
         qCUjY1BEzEv598snAecjspdXPCqWTQsuWBvUNRvmUTzW2ZDBTfBFTA+ZAoVz3YAQ+pPz
         PvPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778703001; x=1779307801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9FN9Ag4yWbA97j4vwDvwIHNgGdFVfW/O8GGWhymSzGw=;
        b=aYKZzmvviiwRP12RwnpWL3UJjCjqb6fu0q/No8VyKBH3RI1eMcK5EorvE2jE+KBR+2
         CCGOl6TY0EM8Xd0ECkFKNmC3wvXdPixnrAOGWMe/UTTFtmYEYh7qFxudkRr/4tgel6Jo
         Jf0qNf0QcWM5WfuY/vQgH0btlYi8KolHerxy25xdnKZKeByDWaNAfebiUgog3W7OIRsn
         B5hgR7W+i7wsjbd3EKRKP56nKSlWRdgyGcyzyg9RD7j8dHFKp8uffAPS/B1T0LOYXn+U
         A5zEUvvEjNmf1IuqhVrP1t6g/2wPaGIpII2SO7ZONB6kV7zQD7RHNUKkVP1tgOT1NztK
         /MHQ==
X-Gm-Message-State: AOJu0YwR3nqIISLj7swpoqp+zxggDpqdB/YavAYU/2CJiEBvxPkSh1gM
	Gw5qrTpdY4y2GvmxUkfrwFtN+sEIIQOgMFJytElM5D3faU9euHnQ4LkwU+6bRR/FkYzdPHdgShL
	ypSBKf/5OLAj8sZUrNve/CkdZxzFIsZVILyI6mqMN1UNdq8UdLeQImTNS
X-Gm-Gg: Acq92OGshRNwr+RgrAHZAQhXZOqVHnW/GhX1V2uI4O7Jyxxth512tViSKuMtUTo4gog
	PZKfvOgYu7zQ+w5Q5M+B2v7CyDkng91BI0XOX4DrqoUS3HuAg70s67p/SYagUnc+6BeIHb3Bg6n
	DURFQRijYwvWXu6CgnDS50LhcFVjmIZUGcuvOtdcKMnHQYuuyefq0tgw3klumYJMKK1wFg9tB+I
	K6Nfth1KO88+kB25P0hL1sEjVOnW2UXnITYwmv1S4hGA5gZGE7zBgFEXeVq4IGC4tLlKfvXFalz
	utx2IrGeibjyMMmKWyiAHFVD/v0Zj+CONxSq7TiZWPHhae94rctwjVVQZWIOAqfKUitNXihynTt
	c0GUndHN0bwW5v/aRqQ==
X-Received: by 2002:a05:6870:2895:b0:434:10d:d372 with SMTP id
 586e51a60fabf-439d3056963mr2458541fac.28.1778703000654; Wed, 13 May 2026
 13:10:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <b0890704-e83c-4e0f-a7f4-5fa40dfee9c8@mail.kernel.org>
In-Reply-To: <b0890704-e83c-4e0f-a7f4-5fa40dfee9c8@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 13 May 2026 22:09:49 +0200
X-Gm-Features: AVHnY4L-AWGwTLLat2wINwXiK1D2f1RFjDFdyA91KMNyZADByw5dZoQEoFehS0k
Message-ID: <CANp29Y4EZ-L0hzAybhcU=qS0vUNuejVMzZRzoQRyJQjdtWvE=Q@mail.gmail.com>
Subject: Re: [PATCH RFC] jfs: fix slab-use-after-free in lbmIODone
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Did this bug really exist since linux 2.6?

On Tue, May 12, 2026 at 11:21=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> jfs: fix slab-use-after-free in lbmIODone
>
> A KASAN slab-use-after-free was reported in lbmIODone(). The root cause
> is a race condition between lbmRead() and the bio completion handler
> lbmIODone(). In lbmRead(), wait_event() is used to wait for the I/O
> completion locklessly. When the READ bio completes, lbmIODone() clears
> the lbmREAD flag and wakes up the waiter before setting the lbmDONE flag
> and releasing the LCACHE_LOCK. Because wait_event() evaluates its
> condition locklessly, lbmRead() can wake up and return immediately after
> the wakeup, before lbmIODone() has finished its execution.
>
> The caller of lbmRead() (e.g., lmLogShutdown()) can then reuse the same
> buffer for a WRITE bio. Meanwhile, the original lbmIODone() resumes and
> erroneously sets the lbmDONE flag on the reused buffer. This causes a
> subsequent lbmIOWait() on the new WRITE bio to return early and free the
> buffer. When the WRITE bio actually completes, lbmIODone() accesses the
> freed buffer, triggering the use-after-free.
>
> Fix this by replacing the lockless wait_event() in lbmRead() with
> lbmIOWait(bp, 0). lbmIOWait() properly synchronizes with lbmIODone() by
> acquiring LCACHE_LOCK before checking the condition, ensuring lbmRead()
> will block until lbmIODone() has completely finished. As an added
> benefit, lbmIOWait() correctly returns -EIO if the bio completes with an
> error, whereas the previous implementation unconditionally returned 0.
>
> Fixes: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+1afe7ef2d0062e19eeb3@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3D1afe7ef2d0062e19eeb3
> Link: https://syzkaller.appspot.com/ai_job?id=3D5deba876-6901-4e25-bb74-5=
f9dc95dd56a
> To: <jfs-discussion@lists.sourceforge.net>
> To: <shaggy@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
> index 306165e61..cf62a8564 100644
> --- a/fs/jfs/jfs_logmgr.c
> +++ b/fs/jfs/jfs_logmgr.c
> @@ -1984,9 +1984,7 @@ static int lbmRead(struct jfs_log * log, int pn, st=
ruct lbuf ** bpp)
>                 submit_bio(bio);
>         }
>
> -       wait_event(bp->l_ioevent, (bp->l_flag !=3D lbmREAD));
> -
> -       return 0;
> +       return lbmIOWait(bp, 0);
>  }
>
>
>
>
> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
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
-upstream-moderation/b0890704-e83c-4e0f-a7f4-5fa40dfee9c8%40mail.kernel.org=
.
