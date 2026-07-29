Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF212455186
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 15:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340712; cv=pass; b=fVIcIwM6qujqKj/Tfmnx3VhZcntUAOGIWViQdwaXK3UcDAO3daUaWlQF7PX7qsNAk1ZrQ8nz1jLDnx2ouYd/Y5YvriaI6emeJ3Fansxe/0hfvR3ay9+tsqPkenQSgVtPD7LNVkAvrnhefiyaXTq4ITdbJUsBfG65qaOR3mctJYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340712; c=relaxed/simple;
	bh=6V1fZBPdOskYE7pYV0pSFKmKwC7mAUJAf/8zAcOVWOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I5fEV9bU+2vDV9JHlxRV9Le7jcTCWyp205cmbf7JtmeFRMA8Pzxye0X3XohoaiLp2FuOdXEt4tRgqQ9fmvoX7lpejCjjK62IbvX5zEHC40XHb/casvc0g4jqHDGQQ/znxfuMEMSuPlOVcUzMvrplDa1Ubt0lve5yaXKas7KFtVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nc94b2IP; arc=pass smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nc94b2IP"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e9ef94c0e2so728176a34.3
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 08:58:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785340710; cv=none;
        d=google.com; s=arc-20260327;
        b=qKuBmyLlsPpPtb/FeoBGxFDRXALRFjjpYdy88qoJ7RrVRoXAjD5zpdl5eKuqeHHPdo
         Bef2fMeUgGP5i3Qie8UmjAzYbnnfQF0Qs7krwUGpw4uq/9ODYPfHt5Q796hS8affEEeK
         knvJ8vNyAG0v25yEn+bkGhX+acd5vJnd6Zd+AZy8dy8Bk1S8336mhxdIH9dP96w0ebps
         ypLMerlNe7kSBdSxtFTv2szvZvllDpLmXNXfXwF7PV4xgHYluyv15CKy/WfCKtCiVpnE
         TG2KLo8uR9nEKf8nEWP3Qolr16MLbflmnr55T/Dyfa0R+EHcToGui+amLWOhZ5YpVxkz
         NKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sJeJ57DMeGrXV39zcTfKxp++JOc2byRCDqQQCz6EGkk=;
        fh=UnnelrfMwBEJ/s82ATZ2EfdNuQ+Jwooe7R1c+hpfXFg=;
        b=HSbkolNe6/vmwtvc3t54OzYppcBXZT763vohIs1uKJTtxibt7mbtF2TUYoo99Ev1um
         /QaDe3bi4I8UzlR6mGxzQ43ApOkHg7J5wrTqt0FSDzwPzNd2054uOSQkDXcf3eNCwWkU
         EXvOu7nYXyTF4TtZLYYqPzGo0lZYGR28DEc73JEHAxJ7oKlXdpo+wgDXZyzgBMKgeKC6
         Ddb5NjGv+6S/Da87d7mQ2Ksr3LutithhxMITjL1jvS7j0NB18IANBK6cnFjZSBRBKNm/
         aK4z9WLO1/p/c7udazlQtmXkBsI7wlaElmfbbvVVUOK7NMW45ZjdiQlnUtQoElHV0KV8
         Azog==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785340710; x=1785945510; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sJeJ57DMeGrXV39zcTfKxp++JOc2byRCDqQQCz6EGkk=;
        b=nc94b2IP/QPXSRmZEOQb4L0y8ChcdUDLYcgx1O7JLKrSGwi4qzVtYzPrZOOnjIRB1V
         0oOmUSM6Ce9mz90djmBsYLytHWiPLo+59P0tkKADUEqKLCcPLGs1kvyl7NlA6+4PiL1C
         Tt+6izCZgxXs6plNn6mSWipFC+UY+Il/uUgJYNlsLb3B6U3PBW9DuHB1jGBBlKp+ZyBj
         6TpxLUXUu2ph7qnlklmFGodsC+yLrq8YH+dJJIFzISLQOmOI0ap6yPkKSM0zi7MVOlEg
         NVfHdj9RkZ2hUycbb+OuGfgV/XkdyeYcJIr38sfiw9xMC919w4k5pO/KEUKiQPYjCef7
         N5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785340710; x=1785945510;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sJeJ57DMeGrXV39zcTfKxp++JOc2byRCDqQQCz6EGkk=;
        b=FE58tJ+5Bg5Vdc2wI975BHm7dVJHE8D/Fredb7c0LvRdl/6N8BwE7sBLJ5i1AQArmh
         hG5reSeHZsynzjj5SiuwO5bD4AV6KbVxl/RkpeDd31OvuXOHxpV2GMMySkMZZtGpncCx
         d6fX6MzUzRlofJnKBhiIbG4OJB5Ci3VhcXxyZfzz90qLqifh1VnKcTzZJ2ucYFh/PTbd
         UVo0luDRHzogcVpUhu/orhdqdMiQWyi50qNQciMlrDjVvY0JFUpsuYP1grvdJZakZrrh
         FMjZ2qoZjagwCqXHHGQ+JVhkMM3GG0XHaGHfvikNQl1cl1fccDFiMFwfJAmSfPiNfVmc
         bXBg==
X-Forwarded-Encrypted: i=1; AHgh+RqfteitJYvbOCbDuA95yvnWbTWvix2SRS6vk5xXTcd2XHLMcjWwqOxVFRYexwrApbeVJRv/AEg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8KEivf8YpG5fzso97TMe8vvsQV3vjnr/lrau8F2EW2hzCk2Gg
	1HICxXsx5gH6pHAOOCNN9yEPqBrnnXScH//m7lYdO0qJZULAyCHd54WJro0NQ9kYq2v8wwSH0Tf
	HrpXWECkNXUWp0j+UFQwCTL2BspL6kZNYsGUpzQeQ
X-Gm-Gg: AR+sD11CTjTUVmXnJZjqeKnyb/ikxA15gw91e61f6dMv6SFIsOwtLaHE2DLfeJEJULb
	jCLu5Uw6lOVqfaYjZpIWWrfDopRJ/tRIqz/HOtB1LFPBNLkdwXO3hIJbQrzzoFEpa7ugyWOZPe3
	R69mPhWb1SqRHzD6pNhjeEqUGUi5vCoG4NCPlHOb8z8qG76+h6MNwxQchHBa1oJHRcTMrYXpWup
	RLThOO1CQ6acxZC3a412YD0ws9vUTDWW9V+KwHcvBff8IHVrHHNBeqx4qIjuq8oFbZQeovzDCKu
	59DSCI8X01zFWl4TuLnS2zq2gRDmS5Daqat0mMGVdabyrKx1NvbkPWq5Pbzp9Qkd/s83k/63yfR
	k6kRUvyAIbfifP7+wERxxfb5GvysY73eI/FREy8AHeFYSGeSdUX+hYFP+6+lnE8LhPgR7TxmGAM
	Ig/K/Qm+URENA=
X-Received: by 2002:a05:6830:67f6:b0:7e9:b4d0:53a2 with SMTP id
 46e09a7af769-7efff2d6c92mr4262817a34.27.1785340709256; Wed, 29 Jul 2026
 08:58:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <c0546d86-1fb7-46c5-a37d-645407387aeb@mail.kernel.org>
In-Reply-To: <c0546d86-1fb7-46c5-a37d-645407387aeb@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 29 Jul 2026 17:58:18 +0200
X-Gm-Features: AUfX_mxGyG3lJtk7vQRU9QBidtIj56xiuhpfjK-Y7I5E_Lomai27riukdZb0eyw
Message-ID: <CANp29Y5URiKb-wanoAhy_57g9X9PkX07fOijeQ_tjMMMS7yqkg@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: gadget: f_uac1, f_uac2: fix invalid free and
 memory leak
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jul 29, 2026 at 5:14=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The `UAC1_RATE_ATTRIBUTE` and `UAC2_RATE_ATTRIBUTE` macros generate store
> functions that use `strsep()` to parse a comma-separated list of sample
> rates. The `strsep()` function modifies the pointer passed to it, advanci=
ng
> it past the delimiter.
>
> This causes two issues. First, if `kstrtou32()` fails (e.g., due to an
> invalid token), the code jumps to the `end` label and calls
> `kfree(split_page)`. Since `split_page` has been advanced by `strsep()`,
> this results in an invalid free. Second, if the loop completes
> successfully, `strsep()` sets `split_page` to `NULL`. The subsequent
> `kfree(split_page)` becomes a no-op, leaking the memory allocated by
> `kstrdup()`.
>
> KASAN reports the invalid free as follows:
>
> BUG: KASAN: invalid-free in f_uac2_opts_p_srate_store+0x225/0x2b0
> drivers/usb/gadget/function/f_uac2.c:2087
> Free of addr ffff888192cb7806 by task syz.0.17/6182
> Call Trace:
>  kfree+0x173/0x6c0 mm/slub.c:6692
>  f_uac2_opts_p_srate_store+0x225/0x2b0
>  drivers/usb/gadget/function/f_uac2.c:2087
>  flush_write_buffer fs/configfs/file.c:207 [inline]
>  configfs_write_iter+0x33a/0x430 fs/configfs/file.c:229
>  vfs_write+0x61e/0xbb0 fs/read_write.c:687
>  ksys_write+0x156/0x270 fs/read_write.c:739
> The buggy address is located 6 bytes inside of
>  32-byte region [ffff888192cb7800, ffff888192cb7820)
>
> Fix this by keeping the original pointer returned by `kstrdup()` in a
> separate variable `page_alloc` and passing a temporary pointer `split_pag=
e`
> to `strsep()`. This ensures that the correct pointer is passed to
> `kfree()`. Additionally, add a check to handle `kstrdup()` allocation
> failures.
>
> Fixes: a7339e4f5788 ("usb: gadget: f_uac2: Support multiple sampling rate=
s")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+bfca46c96ddf3b7d5c55@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dbfca46c96ddf3b7d5c55
> Link: https://syzkaller.appspot.com/ai_job?id=3D705307cf-805c-4e75-8f76-2=
a0acc541cb8
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Julian Scheel" <julian@jusst.de>
> Cc: "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/usb/gadget/function/f_uac1.c b/drivers/usb/gadget/fu=
nction/f_uac1.c
> index 85c502e98..f4b7bbd93 100644
> --- a/drivers/usb/gadget/function/f_uac1.c
> +++ b/drivers/usb/gadget/function/f_uac1.c
> @@ -1594,6 +1594,7 @@ static ssize_t f_uac1_opts_##name##_store(struct co=
nfig_item *item,       \
>                                           const char *page, size_t len) \
>  {                                                                      \
>         struct f_uac1_opts *opts =3D to_f_uac1_opts(item);               =
 \
> +       char *page_alloc =3D NULL;                                       =
 \
>         char *split_page =3D NULL;                                       =
 \
>         int ret =3D -EINVAL;                                             =
 \
>         char *token;                                                    \
> @@ -1608,7 +1609,12 @@ static ssize_t f_uac1_opts_##name##_store(struct c=
onfig_item *item,      \
>                                                                         \
>         i =3D 0;                                                         =
 \
>         memset(opts->name##s, 0x00, sizeof(opts->name##s));             \
> -       split_page =3D kstrdup(page, GFP_KERNEL);                        =
 \
> +       page_alloc =3D kstrdup(page, GFP_KERNEL);                        =
 \
> +       if (!page_alloc) {                                              \
> +               ret =3D -ENOMEM;                                         =
 \
> +               goto end;                                               \
> +       }                                                               \
> +       split_page =3D page_alloc;                                       =
 \
>         while ((token =3D strsep(&split_page, ",")) !=3D NULL) {         =
   \
>                 ret =3D kstrtou32(token, 0, &num);                       =
 \
>                 if (ret)                                                \
> @@ -1619,7 +1625,7 @@ static ssize_t f_uac1_opts_##name##_store(struct co=
nfig_item *item,       \
>         };                                                              \
>                                                                         \
>  end:                                                                   \
> -       kfree(split_page);                                              \
> +       kfree(page_alloc);                                              \
>         mutex_unlock(&opts->lock);                                      \
>         return ret;                                                     \
>  }                                                                      \
> diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/fu=
nction/f_uac2.c
> index 897787d08..336aeaec9 100644
> --- a/drivers/usb/gadget/function/f_uac2.c
> +++ b/drivers/usb/gadget/function/f_uac2.c
> @@ -2012,6 +2012,7 @@ static ssize_t f_uac2_opts_##name##_store(struct co=
nfig_item *item,       \
>                                           const char *page, size_t len) \
>  {                                                                      \
>         struct f_uac2_opts *opts =3D to_f_uac2_opts(item);               =
 \
> +       char *page_alloc =3D NULL;                                       =
 \
>         char *split_page =3D NULL;                                       =
 \
>         int ret =3D -EINVAL;                                             =
 \
>         char *token;                                                    \
> @@ -2026,7 +2027,12 @@ static ssize_t f_uac2_opts_##name##_store(struct c=
onfig_item *item,      \
>                                                                         \
>         i =3D 0;                                                         =
 \
>         memset(opts->name##s, 0x00, sizeof(opts->name##s));             \
> -       split_page =3D kstrdup(page, GFP_KERNEL);                        =
 \
> +       page_alloc =3D kstrdup(page, GFP_KERNEL);                        =
 \
> +       if (!page_alloc) {                                              \
> +               ret =3D -ENOMEM;                                         =
 \
> +               goto end;                                               \
> +       }                                                               \
> +       split_page =3D page_alloc;                                       =
 \
>         while ((token =3D strsep(&split_page, ",")) !=3D NULL) {         =
   \
>                 ret =3D kstrtou32(token, 0, &num);                       =
 \
>                 if (ret)                                                \
> @@ -2037,7 +2043,7 @@ static ssize_t f_uac2_opts_##name##_store(struct co=
nfig_item *item,       \
>         };                                                              \
>                                                                         \
>  end:                                                                   \
> -       kfree(split_page);                                              \
> +       kfree(page_alloc);                                              \
>         mutex_unlock(&opts->lock);                                      \
>         return ret;                                                     \
>  }                                                                      \
>
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
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
-upstream-moderation/c0546d86-1fb7-46c5-a37d-645407387aeb%40mail.kernel.org=
.
