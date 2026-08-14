Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CF433F5BF
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786708977; cv=pass; b=cNjhkEONEUXxolzyOyHSfY1phwNb5AcrKctpYz5cWGMoq87hExut+V3KI7eiNG8rXq1BKTHalxAE1i5CvYeVSXxwkcj6vZrJW9zUwHZmNGQ1DroDIg0khpBIBGR7KNuxaR3l0l23U/EJfwgsNpJNAuPWlccg5mzdKS9Hg5wnfpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786708977; c=relaxed/simple;
	bh=yY2CyOsxyF/VkWckK9aqhHaGxcaEbqBIjiN9bEPqadA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HRpe/Xr8CmY86Xs97itQoq+WboV2GVb564594TGGwP6A6m6gkvuRVtfITYFsP6UDDn4KWOwnVYDQk2C6QP1ZxP4mLyURGdGAZNjwlTWBaZNVtc1PX8wygeAtIuOp2N5piscdZecRvt2wmnOZSuSMXmAPZZD2F/CoxihNLrsgWnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dbW3f9+c; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dbW3f9+c"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7eb787dec99so659168a34.0
        for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 05:02:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786708974; cv=none;
        d=google.com; s=arc-20260327;
        b=fwVqlVRvmbs1mwZDun1MAdydlJfr00kGhpbTXi+Vnz6hgcU/nmDCanMpZdhFJx2K2j
         SfeRJuN8TQnWFOLF1bG+aVRnpzDLYATHqtyeIsjLH3MHl39AtrQWbw5BOFsAASeBPtQS
         YZAuT3iEg9NTdUUzUGGbSeGctLJlAyFKKjilmEZra03gCUAWOx1OuutV714vPDNqccEI
         Gj1unJqxklhdiMXzRBsujXd8zYauTH4c3TvW9ODAHQK1sfe13ItPboScaCcRAGGtmJCI
         UR0YBpMgVzH0Zvk6S685Tu7p1LZ2aVo2NL7KsbsTzCH5XGjVDrtD515GAUHt/+k9/WtK
         XBZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sEMrPipo9G5vm/AMYQ3sOyiiNjUzi8S2uUigowIce/k=;
        fh=vlPROLKc9MjsGufMkOJLJmge5gtTufR28KH4w/ebnxw=;
        b=l4y2qLx4fhR+GOHSyr9pO6fe805ooARWtKG9hpYf2dVLRSoXpIw1Dxa9LRxXyLjhuQ
         d1lz0Orf0cGuy7tQ8ksocXe1bb53lJb7iJrvqPinlWPaQ9SURRVtbuHHFkAD2u34Zg+0
         03B3rPn3qwWHsrHGVIx+AMAZyzzWIoNqJLhhcq8QajaXEq0OqWH/ImnrSVjnt47jMJ5B
         CgPR/UjqS++EewUMT+KKaJuLNWaQ5bJZFajIgraKNVGnmTO5a8uZK86213V/IbFW2Uf4
         Vz8+kb+lVlPSUwROTYuXFGarfTQ7nuKw9m1DAPZTK6xzRBIXwapMlNsQ2+3pXBx596c0
         6ZqQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786708974; x=1787313774; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sEMrPipo9G5vm/AMYQ3sOyiiNjUzi8S2uUigowIce/k=;
        b=dbW3f9+cZOV8GlPRvxhDQhIt/HZHVZMoDE+lB1/vlY3LAzpHnTPbx+SzegdQ5H/q5p
         HmgaeD92miuPEyaY6RdXHp0ZqPrZwTPcovqWZ5nUsg/8MCQospp4HlwamqXjjJJ08fzK
         2b+I/KM6Nwed7UAonXIy9K19rhDI0Zb61AtEYn3XoDoMav2kGHv0LNMAGuePXqCYApnQ
         kUs6Y9+ak7nSbJEMGDlzNaI2xTmmDVngXvnO4oiEA1Cgzkvsh1E9mMkfPakDeh39TGU9
         9BWVcbbqxGd7iIULNiO+6DUirSh+loQQrrCzXvnP1K9Fw9tOTxuXgpDJOB6y7B2l12G2
         HxIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786708974; x=1787313774;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sEMrPipo9G5vm/AMYQ3sOyiiNjUzi8S2uUigowIce/k=;
        b=k/MK1ugmuy7XHnZetcoNUN2o6LqJOloQaG4k5Uhe2+uesJ8GQaHKl2oQDFkj0rYqkU
         i5kcZVHyjT+YuIgw1gE9BFv0/IslHO8K0nM5sJNXrUs3Rdd4wC3MShmDKjaJMv+rpgMv
         BmMIRhxlmqz4jTShP91CcBnbtQL3hpy1hMmx1zDPdAaFSkfayZmdr+JrO4t9/0Ao4S/k
         bsAa2hxa8FcZpGKVu9us5nHPoeXoZXzk7FYuzx8BwCbFUr+9yk0fE/tjnrHs+HysBCq0
         j3J/98UJSPgcfDl2Pyukq7uSNAmBLrYUbfihHy8mzTSTkDheCNvzvQGWzQ63SvSE1MqX
         wFhA==
X-Forwarded-Encrypted: i=1; AHgh+Rr73wz3+N8XJ/y0eDbQJxzFN18dDLtNBKUFJ+ucme2ZK7C1XPIYx6AJP7UQuMuie6r/HV9tJs4=@lists.linux.dev
X-Gm-Message-State: AOJu0YymtQNZJni9YXnvwssuifsWpYBF46UQHvipq7QYitRRMgX6HkIl
	INeRgbjHAVAk2Ncz9REA8xfYkxZRvWpYjqFtP4QqQOo2l/b0jodw6Ob1OB3mr0//mn9pIVd9+Ua
	N/SQNneY9sDkSeIIckh9zlgK8hJqMhNpXt/L7t/9f
X-Gm-Gg: AR+sD10ppqijaizYV6ycQLkJ07xpDKF+FNDeVdBLvifMRsHL91IUC6wFkS9BE+G42xW
	yc/6gEP3ZKQs/Vr4tzCipQ2FJ+BVxNn1G281lHwOyxSrWaEmHMiuJ0vX3b2X4bzmcBe/ns7pnvS
	TnVO6Uf3OPxu0Xi2PBl7h+nnOjLDw0k1+yi8Ea5HQjaqz91DUIz+OTV4ZkM/6pvg9lAbhAJRjgp
	GvvznrcbUc0HkXyf/CzE98UBFyB1RztrMJPtPG8iJoHRsI0D2RqFI+Qn6+YC9GICzxhDmpJJ8LA
	28e5YlFIaCtFmIUTRSR+XPP9KtlLJSOVsYWkapt4fLUukP4B/oNka87n9S4Bga+wMwHNbMqng7t
	gaVQhUbytA2a3CQ3V+rK25xadAFZMg6GYrAGERfbdfVDsNd9KExtyxh45EoXkI9Agom7aj6/nXf
	atRSLdbkidMTNK
X-Received: by 2002:a05:6830:2708:b0:7e9:cad9:4bc4 with SMTP id
 46e09a7af769-7f3de64c4e5mr4028174a34.7.1786708973647; Fri, 14 Aug 2026
 05:02:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <b4cf9eb9-0e37-41db-ae44-125880a6740e@mail.kernel.org>
In-Reply-To: <b4cf9eb9-0e37-41db-ae44-125880a6740e@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 14 Aug 2026 14:02:42 +0200
X-Gm-Features: AUfX_mx9fWQcTSMiWkvlVHdDaCVyGCQammUzvaCHvrS6ax4gtrEQe3WJKCv2DHU
Message-ID: <CANp29Y5sjhFzBa9Vs84p_m0_+nbkn4cdRpMKPx0pEOCpw1f9Ew@mail.gmail.com>
Subject: Re: [PATCH RFC] ALSA: core: Fix use-after-free in snd_card_do_free()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Aug 13, 2026 at 9:56=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A use-after-free was detected in snd_card_do_free() when a sound card
> managed by devres is unbound while a user-space application still holds a=
n
> open file descriptor.
>
> For managed cards, the memory is allocated using devres_alloc(), and its
> release function is set to __snd_card_release(), which calls
> snd_card_free(). When the device is unbound, the unbind thread calls
> snd_card_free(), which drops a reference to the card's device. If the use=
r
> thread still has an open file descriptor, the reference count does not
> reach zero, and the unbind thread blocks on wait_for_completion(&released=
).
>
> When the user thread closes the file descriptor, it drops the final
> reference, invoking the device release callback release_card_device(),
> which calls snd_card_do_free(). snd_card_do_free() performs cleanup and
> calls complete(card->release_completion). This wakes up the unbind thread=
,
> which returns from snd_card_free() and __snd_card_release(). The devres
> core then immediately frees the memory block containing the snd_card
> structure.
>
> Meanwhile, the user thread continues execution in snd_card_do_free() and
> evaluates `if (!card->managed)`. It reads the `managed` boolean from the
> snd_card structure that was just freed by the unbind thread, triggering a
> KASAN use-after-free.
>
> Fix this by caching the value of card->managed in a local variable before
> calling complete(). This ensures that the card pointer is not dereference=
d
> after the unbind thread has been woken up and potentially freed the card.
>
> BUG: KASAN: use-after-free in snd_card_do_free sound/core/init.c:604
> [inline]
> BUG: KASAN: use-after-free in release_card_device+0x1ab/0x1b0
> sound/core/init.c:153
> Read of size 1 at addr ffff8881912ec909 by task syz-executor130/5857
>
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  snd_card_do_free sound/core/init.c:604 [inline]
>  release_card_device+0x1ab/0x1b0 sound/core/init.c:153
>  device_release+0xc4/0x1f0 drivers/base/core.c:-1
>  kobject_cleanup lib/kobject.c:689 [inline]
>  kobject_release lib/kobject.c:720 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x222/0x550 lib/kobject.c:737
>  snd_card_file_remove+0x331/0x390 sound/core/init.c:1125
>  snd_pcm_release+0x12c/0x160 sound/core/pcm_native.c:2986
>  __fput+0x418/0xa50 fs/file_table.c:512
>  fput_close_sync+0x11f/0x240 fs/file_table.c:617
>  __do_sys_close fs/open.c:1511 [inline]
>  __se_sys_close fs/open.c:1496 [inline]
>  __x64_sys_close+0x7e/0x110 fs/open.c:1496
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
>
> Fixes: e8ad415b7a55 ("ALSA: core: Add managed card creation")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+7061d72c26b7daebe2b4@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D7061d72c26b7daebe2b4
> Link: https://syzkaller.appspot.com/ai_job?id=3D24752a23-f0b6-49c1-bf20-4=
fa89c2e7eb2
> To: <linux-sound@vger.kernel.org>
> To: "Jaroslav Kysela" <perex@perex.cz>
> To: "Takashi Iwai" <tiwai@suse.com>
> To: "Takashi Iwai" <tiwai@suse.de>
> Cc: "Mark Brown" <broonie@kernel.org>
> Cc: =3D?utf-8?q?C=3DC3=3DA1ssio_Gabriel?=3D <cassiogabrielcontato@gmail.c=
om>
> Cc: "Cezary Rojewski" <cezary.rojewski@intel.com>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/sound/core/init.c b/sound/core/init.c
> index 56dde5bd7..577338526 100644
> --- a/sound/core/init.c
> +++ b/sound/core/init.c
> @@ -584,6 +584,8 @@ EXPORT_SYMBOL_GPL(snd_card_disconnect_sync);
>
>  static int snd_card_do_free(struct snd_card *card)
>  {
> +       bool managed =3D card->managed;
> +
>         card->releasing =3D true;
>  #if IS_ENABLED(CONFIG_SND_MIXER_OSS)
>         if (snd_mixer_oss_notify_callback)
> @@ -601,7 +603,7 @@ static int snd_card_do_free(struct snd_card *card)
>         }
>         if (card->release_completion)
>                 complete(card->release_completion);
> -       if (!card->managed)
> +       if (!managed)
>                 kfree(card);
>         return 0;
>  }
>
>
> base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/b4cf9eb9-0e37-41db-ae44-125880a6740e%40mail.kernel.org=
.
