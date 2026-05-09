Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359DA35B63D
	for <syzbot@lists.linux.dev>; Sat,  9 May 2026 07:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778311861; cv=pass; b=eqE41RkFO0nmNPqr+3lFYDWoTBJxMZ4UIO///3QvwN+7oEDfSGBM/fR6TSiYU7HGLjfoV0+Sn0q1Of8d+Q9Qk1bHKt38n2sZXCYmjvossCy93znuulYnhBI1E//3OhlmAtQNGyw5Q1qD7wtB02sHy+4OdmXP7mRcoF+EfgoSiOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778311861; c=relaxed/simple;
	bh=6+SHCiirV1kK8v/Cmfwilakhq/axTGw51wUUU17AwhQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nt5maiFS7Xox9rOEQEQAUFZMl95FU5buCdDDEfbwA/02SAOHp/UsmbCa+XO6aYcurx6hNr+D95Mjgb+6TtHXWFp33vc4g2W3AbwY5ReVayfRPkhhDIH5rjorK1mzKogMgpSv4joyobjYvohU1EY9Tug9hHV5grhIsCyA5gQiewI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XsyEgQLc; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XsyEgQLc"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-38e8292423fso18938991fa.0
        for <syzbot@lists.linux.dev>; Sat, 09 May 2026 00:30:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778311858; cv=none;
        d=google.com; s=arc-20240605;
        b=bYjlEEpf3sNu+8XMmTCPNCpG2c3NPvCDJC27k7RENJA+gjXR8o+2uIUrTOhliNYMiP
         w1byho3V7pcA2q0FnUWKGMMrTTc/8EzmIu0mhss9dzBM5vGb8sP/v3kT9o+/JZep08fo
         P551/ypGjoLodad4sJr1nFNay+v9+evNBV6EokXXbdq5QJPCPTtDY3u67RI3Stb+v+Y9
         0LeK1GiESwosQ6IzTFfrNuv1Tk9HFoGIslMNf3BALEIe1ocvoXGHRt+pJNL6X/7hlBsr
         FthcxiaIXQ7LCsaBeeiydHRdUSuyozUE4VyE9KXDG6HHd+Nz22BWkM3ffE8UR00VbH1H
         zTiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7HxXCqnYM0a7RMiTnv5r/28EdpIByq0rIVh9R4mCHfk=;
        fh=+82yihRpc/THaAXp7TkAeKyxkwCQZGmvRHMDAnAdqj4=;
        b=OHVLbG8X92ZnAS4Ikx78sab4XuyeHqjiM9P7tLRgxmnI72KnXCg3zdswzsxxckOpsd
         PrjevA+PWyuZRnSlRh5nUy3xXaz8YARYMl0QcWTyhBuIYib35X9rzwRnTRY6+NsM+nte
         u0CIwJM3yBn3YSkFHXD/AGXfs4WszVoZDRlZ9epjUA+TihJrwiYmGyz44BBKOZ2Gf6uv
         ufYgFMkrx9APJPSSwqcIdH7UNEItZAqbr2jfDnmH8+tZu7fBXAb65ZnmoMqdqNJVgM3a
         1EZu/i/fG0BacuX1yx7+9wujoeJBP6rVOusuhi9MMf2mBsM7DifBGS9kWlaIOoYm56nS
         2ZYw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778311858; x=1778916658; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7HxXCqnYM0a7RMiTnv5r/28EdpIByq0rIVh9R4mCHfk=;
        b=XsyEgQLcrY+ffOUbklYj2oGw6F4UM6bqj4x/lBib7utbwgYLsJFWr08Qv+st6hiq1z
         gvny9etFEJOLYNnF9C6fmdvwxZy0PGDVL/g+a8ylpamkOlmacq+bLp5/pUEsRoPjTB7c
         WUclmIKxMfjtvojydtDt21XCzYfX66FKs5PP9PmJ6KWtpxSjYg4fkSJxUEEse289vXXJ
         WwFXTD8C5P805yEj6u3UmReXW+tzeGixCwWiqTGsOTzK3lwXqMNrFtA8Nl4JcWZ0hwDD
         CY+ExzcaJjkziIbqTIIYi6JAjXKJUKhIr6zG7Cp+aSuz8LCYBKCmHp7DbtNcE0o8xkY4
         YZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778311858; x=1778916658;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7HxXCqnYM0a7RMiTnv5r/28EdpIByq0rIVh9R4mCHfk=;
        b=U8BenimhE8zMqJpxCxcxZTQ7Yxq2eXkYyyZcSoPfQx928hRtzClG5iPFKicozysXla
         /PLT6C/LUPqmUC+r+Q39huj4DwcOY+cwS7IpfkC1fgD81TjGWehtcbRHL4+p1I0FqGc4
         ZtqknUoGMPI+igrZLPoE/T8Xiouco5jHjkPaP3OKJ24YzsfUn6brg7A1EkhZJPVifkbi
         QHYg7EYNa0N4QlJANAIg78VSMpWXS8VVW02Dq0R8lWq6V7lwwLtDKWUMqxbJauMCX3D7
         5mnLeuQIptMWfQRm34aMCSsco1Q4ZsWfhApgZKRmHvPCximjYfbk0b4cm5wFkkOcrNk9
         B8zw==
X-Forwarded-Encrypted: i=1; AFNElJ+w+efRot1nENJ3YZKBNozLGmyVMhODyqFtOvKR/xEx6+4luyOqdRxZr72qnwqd3VzzqVtkjjY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdIWyL6akBlqyKWQFPZf8Kzr+oIKN0b7h96F9t0JCcpHqdaROK
	GqO3Mp3TZEO39yB/zA2LkVdHW6wpJhpqmKpJZMS+pOjtBZTZKXCm/KXYcfBALo7gWdCWxL6ZrZB
	eM4x7XhQHPnX/jatL0P2yPvcYtMfyMDkJTkZ4Vl/gvoCw7BuyAoj8W4/ZJ/Q=
X-Gm-Gg: Acq92OEvgYLT4Om01FGunAIBdAh/qJglJOrX7tJxYqADbQA6c8PhlejAfn3mcHrc613
	x+uqnuqvNWnnARnjEOQJGmZgu6TsjjkWH0JT7p7yFCs3vR3MKcIg0K/HdVuGqZ/WlkieDLZOmia
	CLlsB1MVy7rWRtqPrpovbuWqlRyjiChPKSWucqVJf2hJXpl1csqmhoFF/EqDaAyWlWmCbS0VjCE
	LYbi+/V4sz2JysBOSLQyABmen2GuQp4O9hTVmeoT9D25OARYDLrKtGqrmYItm7kuos3G5Q8K1Yi
	t6INeGP67qGqcFuASUEg8p4dMwJof1XYMmIutAwHxTnjRrdzKzZPQzsQPxniSPUZXjZOQ5+Eyys
	WEBxS
X-Received: by 2002:a05:651c:19aa:b0:389:ddc6:a4fe with SMTP id
 38308e7fff4ca-393c42025bdmr62874281fa.24.1778311857942; Sat, 09 May 2026
 00:30:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cc1b2586-5c5b-45f1-ba7e-e6ca8265ab95@mail.kernel.org>
In-Reply-To: <cc1b2586-5c5b-45f1-ba7e-e6ca8265ab95@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 9 May 2026 09:30:46 +0200
X-Gm-Features: AVHnY4KSkt8IZGBd5APqXmFCOU7b8ozYj_H8dFoEMKo9D_pyLEe70RQ05ll21vc
Message-ID: <CACT4Y+a_ts-XVcHgwSBt8fwQ-QP-qkc21b_0kva0ET1FU_XcRw@mail.gmail.com>
Subject: Re: [PATCH RFC] udf: Replace WARN_ON with error handling in __udf_add_aext()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#syz upstream

On Sat, 9 May 2026 at 00:07, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> udf: Replace WARN_ON with error handling in __udf_add_aext()
>
> syzbot reported a crash triggered by a WARN_ON() assertion in
> __udf_add_aext(). The assertion fails because a maliciously crafted UDF
> image can contain a 0-length extent (which acts as an EOF marker) before
> the end of the space declared by lengthAllocDescs. When udf_next_aext()
> stops at this 0-length extent, epos->offset is left pointing to it,
> which is strictly less than the end of lengthAllocDescs, triggering the
> WARN_ON().
>
> WARN_ON() must not be used for conditions that can legitimately happen
> due to corrupted filesystem images, as it can panic the kernel if
> panic_on_warn is set. Instead, log the inconsistency using pr_err() and
> fix the corruption by recalculating and setting i_lenAlloc and
> lengthAllocDescs to the correct length based on epos->offset. This
> effectively truncates any garbage data after the 0-length extent and
> restores the filesystem to a consistent state.
>
> Fixing lengthAllocDescs before calling udf_write_aext() is crucial.
> udf_write_aext() calls udf_update_tag(), which calculates a CRC over
> the length specified by lengthAllocDescs. If we blindly add adsize to a
> corrupted (artificially large) length, udf_update_tag() will read out
> of bounds, causing a buffer overflow. By fixing the length first, we
> ensure the CRC is calculated over the correct bounds.
>
> Finally, replace the WARN_ON(epos->offset + adsize >
> inode->i_sb->s_blocksize)
> with an error return. If this condition is met, continuing execution
> will result in udf_write_aext() writing past the end of the block
> buffer. Instead of just warning, log the error and return -EFSCORRUPTED
> to safely abort the operation.
>
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> To: <jack@suse.com>
> To: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 67bcf8375..f7266551e 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -2078,13 +2078,30 @@ int __udf_add_aext(struct inode *inode, struct extent_position *epos,
>                 return -EIO;
>
>         if (!epos->bh) {
> -               WARN_ON(iinfo->i_lenAlloc !=
> -                       epos->offset - udf_file_entry_alloc_offset(inode));
> +               if (iinfo->i_lenAlloc !=
> +                   epos->offset - udf_file_entry_alloc_offset(inode)) {
> +                       pr_err("udf: alloc length %u != offset %u\n",
> +                              iinfo->i_lenAlloc,
> +                              epos->offset -
> +                                      (uint32_t)udf_file_entry_alloc_offset(
> +                                              inode));
> +                       iinfo->i_lenAlloc = epos->offset -
> +                                           udf_file_entry_alloc_offset(inode);
> +               }
>         } else {
>                 aed = (struct allocExtDesc *)epos->bh->b_data;
> -               WARN_ON(le32_to_cpu(aed->lengthAllocDescs) !=
> -                       epos->offset - sizeof(struct allocExtDesc));
> -               WARN_ON(epos->offset + adsize > inode->i_sb->s_blocksize);
> +               if (le32_to_cpu(aed->lengthAllocDescs) !=
> +                   epos->offset - sizeof(struct allocExtDesc)) {
> +                       pr_err("udf: alloc length %u != offset %zu\n",
> +                              le32_to_cpu(aed->lengthAllocDescs),
> +                              epos->offset - sizeof(struct allocExtDesc));
> +                       aed->lengthAllocDescs = cpu_to_le32(
> +                               epos->offset - sizeof(struct allocExtDesc));
> +               }
> +               if (epos->offset + adsize > inode->i_sb->s_blocksize) {
> +                       pr_err("udf: no space left in block\n");
> +                       return -EFSCORRUPTED;
> +               }
>         }
>
>         udf_write_aext(inode, epos, eloc, elen, inc);
>
>
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/cc1b2586-5c5b-45f1-ba7e-e6ca8265ab95%40mail.kernel.org.
