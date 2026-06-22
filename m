Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA4218AE2
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782151353; cv=pass; b=RYkzBoTDlbWN3qDYEAdkXGcrCE4dFDQjTFvi1sSIUVJQzeDi5K3jgzeQdqcUFFiuOoIewm1lQ9qZmqLuOGbx4abHOWoGceDZWoYPhJKc3SKFoNpXinPjz/aqM5JTX3v9kyyEX8AQDRvkB5R53V5qjVoH6F4UkrHI+81Giuyaj9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782151353; c=relaxed/simple;
	bh=q5XR9rxJK4vJ7+QPn/6yM29Tc9PLxpYW3mLi0hp8K68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PrIYcH28qaMtWocMWgxblQyH9KUShwOsG6dk6jICfQlFlgEAO2IZiPzpdc3j5lCI+R/EaR+B/gLMeIrk52F8wdwpiKx8qHF9eUCn8Wvq8a6BI1nNluzShkzjWJTOUE44qXwwQ56Xfuoen+M9VyJz4+ziwhomOOlLRzBEtkdDkas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZE/KAu9h; arc=pass smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZE/KAu9h"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e93f93ed01so2066639a34.3
        for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 11:02:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782151351; cv=none;
        d=google.com; s=arc-20240605;
        b=M6TTHJ2FGk2khEvIo0lmTWTa+23gBc9gqjGxkAIAHPAel3l4TxxTZvNb+R2EdbsDnS
         tWjye+JMnaAQObV/FLJvkrAV8+g4zdvtzsb0iIOFS5NMcS3LnkaqmaizGAkCiREy8NTp
         5K3hVhi9oomX9f7PCAinCVLJJ8IwJV8ECmB7Zwtwe9s1ItEbzpvEnGUC2kHNld6mudTg
         XfRwfCC3ftJ5d4Km6O+e3QsNIvCQZd8baOuFelkEnXIJQZCuvqCCmsaSKcHf3w3wtMrr
         Hj3F7Jv/sHMMoWbYhXGOQlLQ02Ty7olvv0ro8RrxVug+pdAOeoEJ/3Q2FuUOb0xBMhS4
         s8Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a8Ci/26Z4Vo3/EOqNeVuSshiukQVg5iGmEMDbT+uGxA=;
        fh=hLBdteMXxsIMAOmxaLko/NUbUm4Fg7PhznNBCr1maVo=;
        b=FeyMjpUAXqAsM7zqQvNeCho08+tv1kCfQ84q/51ldfIX40N8LbjNSEJa5Tu7bkUptq
         mls7DWP1brhK9HGhBvYG7IOjAr7T08SFGoZlcpPorE5PzX7ZBUeZQLHvt5lgJBifzf/G
         SPsAfupAdsZgC1EAPpA29zKosPABRUOaSviSou0BB4xOiFodf8/zta7RWRACmvsLBSJv
         haQIJcByOHdx3jyMj9XGZlddS7vYLlfoaDJ++dcBkvCsHKTButB24EPkS0tLM/0RR0RK
         DP9KvqOizRGRFXexbyLWlpoSk1T7zg6t1oaGfoQYq+DN2ZaJ1M8nst13ZfcvS2elWGTs
         4Drg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782151351; x=1782756151; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8Ci/26Z4Vo3/EOqNeVuSshiukQVg5iGmEMDbT+uGxA=;
        b=ZE/KAu9hCHTBboyg7k8cbF4NEsai6Wc92QvcICXicECmA3IPojEWpl29kzZBhTlnd/
         Ei5tVTikzN2pfjguQd3517P79byST8R5NQca6IPjw2e4rgy4rGCQdIixu3GY2miMhSTw
         RFmbjKDagz5sqSnI/TrW+hjifZIn3PLZmkuaAmsHv2/tS/T0UGl0feh2YZcHqdshh2eS
         hv36GvOMICyi72OjuWd0mcI/W7mcJQLmlcmx88qtN3AGM/qXXif6RUfTLwwxsuWQCqbF
         DY32fzwJdRbR4zs9Y9QMY9TUAsE5KKoJueZUaC3qnFOdd25/lTY/lzHgJRtQ4JT7GyGZ
         40MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782151351; x=1782756151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a8Ci/26Z4Vo3/EOqNeVuSshiukQVg5iGmEMDbT+uGxA=;
        b=bQ/ffgbAD9dA7BLsqoerJS82GdE3NC6I/rwLYy+CXtIz1151SP3kzh1jDENNeTIWJn
         69/xDAqVpHaU9+sH9Czx7Cg1fBHaCI9nO+QPqpsV9hRnAf9yzrQSNjZVsFqjeaxUaIUh
         HdMJQQ3GseZPfsnIsHXHaDksDhU/o6nAplJIwU/xfOL/XBX5tiAVMjxsx58/XMXsN6UO
         DFGgnmRF+SuK79pf5PZqmdYX5KO2q7bq+DTfohRdd1QRX6bbxY5NwEAjlfohDSwzk+dc
         ao1Q+JCkJZO3XghHpTa03d6s1G8j1rK5x2wZtvldEU2IdYSq7/34pm5cQw86AFZxNkLh
         otqg==
X-Forwarded-Encrypted: i=1; AFNElJ+G1bfEIYpgnha4grWajh+OqytanZQ/8mTJMspM1aoBDWphKTNrwX6WVgAEzrsVcPIFBes/ifY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXx+2pF9lTJnOTe7dzsSuUqPNVT6plYAnvSqO2JPSA/k+zAulS
	zBcj/Ck8haRacmAm13knCQETlf2DqYMZXZX647OajEzkKP8nJNMEqXBiHEJQjxGqrGBauKbZIMi
	7eCCF+sGzXCe9dc8aAtWYIBPoSwS5dsyIewxU0pPj
X-Gm-Gg: AfdE7cnm7nWq0V0q8Ki1JTOPdM3XXhUKCvYHe70Xz+YxFZOSDTVCqi7/J0Ay4pdMn3m
	nfrWxu/sZr88jS7eObbyJFW1MLozCTxHnjJNOv6F939SmuotdlhoHb2fUl79xf+QLlD752G9U2B
	kvNLaFFRCKmXFE6etHh8glckBtITjf95h1nRSBPxCFYXliuxDiNkq9RbgPH3fxnB1+yHI+u8KOx
	x8ajyc3ef91X0DTLUQJJzY3QXDH13A3BBRSSffY3Y8vK2SVtMoKPTHIeHBnXJt6/PsXDCWsT52p
	7GyTIgJt599iLDfVJ6rR66dwSg3y9VgWJHT5Ty+N+mU5TKxWc2g/s11TujRSRWLaFwjHM/3YEx0
	837KokpRe0kcILU+fCZXEmW14L0KcdkV8wCPNSIxQRA==
X-Received: by 2002:a05:6808:81ce:b0:48a:e496:b4d9 with SMTP id
 5614622812f47-48ae496ba35mr7085083b6e.31.1782151350226; Mon, 22 Jun 2026
 11:02:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <4d9eb3b8-5227-4e03-81b0-c53b7a296eac@mail.kernel.org>
In-Reply-To: <4d9eb3b8-5227-4e03-81b0-c53b7a296eac@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 22 Jun 2026 20:02:18 +0200
X-Gm-Features: AVVi8CdIk_Og1Oia32_Jhh2EDCFlY2WAPEV5nCW63mRJzaQZdB_xDAJul9JypsE
Message-ID: <CANp29Y7uPLnov_1+-t8RWezAQ+_zp7hWPkxZ5bK3mEtr5jgbSw@mail.gmail.com>
Subject: Re: [PATCH RFC] udf: Mark LVID buffer as uptodate before marking it
 dirty in open/sync
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2026 at 7:43=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When an I/O error occurs while writing the Logical Volume Integrity
> Descriptor (LVID) buffer to the block device, the block layer's completio=
n
> handler (`end_buffer_write_sync()`) clears the `BH_Uptodate` flag on the
> buffer. However, the buffer still contains valid LVID data in memory. If
> the filesystem is subsequently remounted read-write or synced,
> `udf_open_lvid()` or `udf_sync_fs()` will modify the LVID buffer and call
> `mark_buffer_dirty()`. This triggers a spurious
> `WARN_ON_ONCE(!buffer_uptodate(bh))` warning in `mark_buffer_dirty()`
> because the buffer is not marked uptodate, even though its in-memory
> contents are valid and are about to be overwritten.
>
> To prevent this spurious warning, unconditionally set the `BH_Uptodate`
> flag before calling `mark_buffer_dirty()` in `udf_open_lvid()` and
> `udf_sync_fs()`. This acknowledges that the in-memory buffer is valid and
> matches the workaround previously applied to `udf_close_lvid()` in commit
> 853a0c25baf9 ("udf: Mark LVID buffer as uptodate before marking it dirty"=
).
> Extending this workaround ensures consistent behavior across all LVID
> updates.
>
> Buffer I/O error on dev loop0, logical block 128, lost sync page write
> ------------[ cut here ]------------
> !buffer_uptodate(bh)
> WARNING: fs/buffer.c:1087 at mark_buffer_dirty+0x299/0x410 fs/buffer.c:10=
87
> ...
> Call Trace:
>  <TASK>
>  udf_open_lvid+0x369/0x5b0 fs/udf/super.c:2078
>  udf_reconfigure+0x336/0x540 fs/udf/super.c:679
>  reconfigure_super+0x232/0x8f0 fs/super.c:1080
>  vfs_cmd_reconfigure fs/fsopen.c:268 [inline]
>  vfs_fsconfig_locked+0x171/0x320 fs/fsopen.c:297
>  __do_sys_fsconfig fs/fsopen.c:463 [inline]
>  __se_sys_fsconfig+0x6b9/0x810 fs/fsopen.c:350
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  </TASK>
>
> Fixes: 853a0c25baf9 ("udf: Mark LVID buffer as uptodate before marking it=
 dirty")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+0306b38d9ed6ef71467d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D0306b38d9ed6ef71467d
> Link: https://syzkaller.appspot.com/ai_job?id=3D83a8a238-e94a-44e6-8088-8=
640cf9cb7e0
> To: "Jan Kara" <jack@suse.com>
> To: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index cad2e15d6..7a5e9bd11 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -2075,6 +2075,12 @@ static void udf_open_lvid(struct super_block *sb)
>                 UDF_SET_FLAG(sb, UDF_FLAG_INCONSISTENT);
>
>         udf_finalize_lvid(lvid);
> +       /*
> +        * We set buffer uptodate unconditionally here to avoid spurious
> +        * warnings from mark_buffer_dirty() when previous EIO has marked
> +        * the buffer as !uptodate
> +        */
> +       set_buffer_uptodate(bh);
>         mark_buffer_dirty(bh);
>         sbi->s_lvid_dirty =3D 0;
>         mutex_unlock(&sbi->s_alloc_mutex);
> @@ -2397,6 +2403,12 @@ static int udf_sync_fs(struct super_block *sb, int=
 wait)
>                  * Blockdevice will be synced later so we don't have to s=
ubmit
>                  * the buffer for IO
>                  */
> +               /*
> +                * We set buffer uptodate unconditionally here to avoid s=
purious
> +                * warnings from mark_buffer_dirty() when previous EIO ha=
s marked
> +                * the buffer as !uptodate
> +                */
> +               set_buffer_uptodate(bh);
>                 mark_buffer_dirty(bh);
>                 sbi->s_lvid_dirty =3D 0;
>         }

Now there are three places in the super.c file that do the same and
have the same comment. Maybe extrat it to some function and call it
from the 3 places?

>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
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
-upstream-moderation/4d9eb3b8-5227-4e03-81b0-c53b7a296eac%40mail.kernel.org=
.
