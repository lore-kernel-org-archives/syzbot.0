Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4AD3D5C0B
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782217745; cv=pass; b=U4If2bz56XJLQ617T4/8iIJeAyaOX13H+mcffD7gYpLr4q5bRkW7STIRtPLfXTXGhX6te6Yt218L0sjEz11s5Gonocem8QugmoiY1yY6T1zdZVYgHwqFoLvHf+z/FAX9K8A9RsLSnKL9+rQ+UNHpQMvqPhEjVu1kf8nuEJPUNg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782217745; c=relaxed/simple;
	bh=SkTAWcw/yJMuq/9U43ivEKJcwp4pn2AVIrZuljkcObA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CPdPiyXDO1Tb5k6cjSsUqHtmA/0Df9RqzMJSLceFunzsK4Ai4lJbECo+070cmFQSMmW70OiBUdSMvF+fJBepPDnlgrrqfih3J5xG/x39T+HpzYgTCoIO+6NkwnJBnnnP4l/KVLtxpJ1lW66R45hziP7KT+iSl+pAZTieoup0+K4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KacvlOQ5; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KacvlOQ5"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-440ebc72386so2662637fac.3
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 05:29:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782217743; cv=none;
        d=google.com; s=arc-20240605;
        b=ScHFJk90MK4qN/EfQDfPolsSor8tYFORoiPEUJJjRP4RgnUt8ektIoB0zlUmLXsldv
         W0ujMoa5zUHEmSQoSYpFOHk71yVcYk1Z8mbwIjakM9SyL4n/UYImFHEA5yISPOgIxChh
         ufeGu4yLzQI6Xr9/4OTi3IACblFe21s4RXuxdQp3NY4hDeVRuhsrAQk5kbcLHXF37xr2
         NfzthW1VmI6ZOXA7iOtwwH145FAaZCu3vIYfIi/S4YtkRAdaZtmXDA+g80yZp3y/mnAR
         2k6OxmoscDmSzg/1wxfpFJTPL/6u3SVTEfhPjHi7ZNuUPlR5jTb3eUvvxF6OmvrYFdeO
         PC+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OQg1O1L/mqp3hn7sk6vw1u1uwiywQu+iCUfCnwkpcHw=;
        fh=xMHdJwtngA4DtPC8KPmao4JyhfxFvwTCpTUKfYn7HDE=;
        b=Ou070xd94KhC3rs29cynF/msgYHTqkJQjdoejzqRqNJ1vbOPypDnkagSrHwPmH5lgI
         XG2kYeNbrCm7vdjWtvX7PN7Lhm21LpDcfMTZciiCwk/KJA/NpDC03/43w19DvlSOoeLa
         X3T1jiOLJ9kmgESViXsrgwds3ZMHMhdnx9jnN/q99wYBEZhIZ7HRY6n7HTpWu4B3czMK
         jNu3Uz0us3jXRzuVk7zxNAOgs2FrTjnrkKmv9ZXCfVu9nyHkBQgp4SosPM+j8ewspuIe
         OJhPdBD8+aGtC+ICP8gmiOUApuIQq9TSToY+ceSnrKJ0Ih1tk+7I+2u2XcZkJ9cHEsfM
         /vhw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782217743; x=1782822543; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OQg1O1L/mqp3hn7sk6vw1u1uwiywQu+iCUfCnwkpcHw=;
        b=KacvlOQ57a2+TQeh2YXcMM7k5j8LwmE/mIFIq2Qi6cHYKRcTgwi4+LBZubaNf2lpfB
         qP6RgPWr08qAHv74THtfLoRYw5aApGCSBc2GTx08pLWbgSVHhLTNxxtO9CurFhB4mtcv
         u97OtuWe5AOuaY49+WPqtcI2nmcPnrRhTItKK89r98U8VYTnsrHEBeKrTxwzT6dtVOvQ
         9zcETVu2/VHyhY0qUiGHf1dsiN143RMl08m5GhEpnFvr+0rp6tWgZcX28cDiodH+xCST
         yuu1psBIFoypnvk8fo7hmQLD1bUoWGJHksgHeh/12Ut5lwgBb7N5UmNSLKjEkEx9B6YC
         rhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782217743; x=1782822543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OQg1O1L/mqp3hn7sk6vw1u1uwiywQu+iCUfCnwkpcHw=;
        b=cN48/mLP5KzmS/Ax9UOBbjvaa4u90aZTyGwveQJQCU82UCYOXhdkRYEMQSB+rFEFIZ
         FPvebCRGDn19Pd06eP41Zf2RsbH+FgZq/o9xUxUx8cLGStrXssFHtXaZ45GuIrJXERwk
         NlghOT20EkLxmNuVlIHHRAakpzgIufWtJBYh1vz/6UUz/UMyBn3/FQCdis/gf2Idc6Bk
         Nbb3kMzD+rq4xSBZBk9kkRV5oqTHascTG1amTvDhxqCL/VdeHDONsz0aeZdebS55bVaR
         1poUa/1ESGwBKHf5R1H9Bh33Qlfw5RlVwvXIJyi7MthKr7PDxZlutt1atICvIEsOAH+V
         +qsg==
X-Forwarded-Encrypted: i=1; AFNElJ8AiUDHliI6eWWdjiD2Sgv3l5U3vof8VOYZ53qvi85T41v+PnbiB8Q/6thHHnZ7kGGTp0/AYNE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9GGzf5G2B8FT+T+9gw387hWF92Xx7Rc1714Ais798OLNxMCoO
	mGKzkqoUEtb46D6MhxFh+h98ZTbuDIhicFlWK4NmwYQCxaTzPKN4JjqYf4F1eOn/LxZsWFHeFTi
	JCiUZh9+JlrWfP3ecvYZYI53fyBZLRGrcWpgk4wbm
X-Gm-Gg: AfdE7cnOjavc/N+oWxGS3pxSLHlIICiVaUyTJ4ZWroFGPqiqIFOW3lPMAU+dPCpF3PX
	R557t8nn/5XFSdfjHCFflqd77l1Tjpj60ZklQrVkWVjRtVtpdAsy4BNajDzpuaYgrqfV2tkg38Q
	LH7Qfy4tV6gMuj8FYCcfOoJBn8XeE/G+x2Zfk4ENwqAIiKYOfMdVNZmlLiI1N4NxnxF5eS2diVR
	GxL3fDQB83/+JN7uASxrB5RwAOejqd7OJzGe8csP7Md5hBr3xQTR5gf1Za9MXoRJvsiN1ns64zi
	FKeGDa8z/9HKRVzMnUlytYIDI8kE9S3HstcbneZWvuAJRdrSIY+7KohT1hkvLdoRvohyPYN9cw/
	oErFIXG3NsxvWlQS9zLhx0ZCQfktVYqhWToqndYE4
X-Received: by 2002:a05:6870:9e9c:b0:447:6a30:8a1a with SMTP id
 586e51a60fabf-4476a309f85mr7798906fac.19.1782217742391; Tue, 23 Jun 2026
 05:29:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <8daab965-ddc0-492c-91be-c49f4fa692b9@mail.kernel.org>
In-Reply-To: <8daab965-ddc0-492c-91be-c49f4fa692b9@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Jun 2026 14:28:50 +0200
X-Gm-Features: AVVi8CfEjJ5f0fWRyU5RrkL26Oc5LqSwm_LLurAqgNEJdQMg7IpOIKhoHouKUdg
Message-ID: <CANp29Y6y7o=xE2S4pFQgisQ=xakg-L1XWJwMkE_6JbO7dduzdA@mail.gmail.com>
Subject: Re: [PATCH RFC v2] udf: Mark LVID buffer as uptodate before marking
 it dirty
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Jun 22, 2026 at 9:38=E2=80=AFPM 'syzbot' via
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
> Link: https://syzkaller.appspot.com/ai_job?id=3D05f8e20f-f080-4c7f-a206-0=
8dbc15cb4a1
> To: "Jan Kara" <jack@suse.com>
> To: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Introduced udf_mark_buffer_dirty() helper to encapsulate the workaround=
.
> - Used the new helper in udf_open_lvid(), udf_close_lvid(), and udf_sync_=
fs().
>
> v1:
> https://lore.kernel.org/all/4d9eb3b8-5227-4e03-81b0-c53b7a296eac@mail.ker=
nel.org/T/
> ---
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index cad2e15d6..7fa2e52cf 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -2040,6 +2040,17 @@ static int udf_load_vrs(struct super_block *sb, st=
ruct udf_options *uopt,
>         return 0;
>  }
>
> +static void udf_mark_buffer_dirty(struct buffer_head *bh)
> +{
> +       /*
> +        * We set buffer uptodate unconditionally here to avoid spurious
> +        * warnings from mark_buffer_dirty() when previous EIO has marked
> +        * the buffer as !uptodate
> +        */
> +       set_buffer_uptodate(bh);
> +       mark_buffer_dirty(bh);
> +}
> +
>  static void udf_finalize_lvid(struct logicalVolIntegrityDesc *lvid)
>  {
>         struct timespec64 ts;
> @@ -2075,7 +2086,7 @@ static void udf_open_lvid(struct super_block *sb)
>                 UDF_SET_FLAG(sb, UDF_FLAG_INCONSISTENT);
>
>         udf_finalize_lvid(lvid);
> -       mark_buffer_dirty(bh);
> +       udf_mark_buffer_dirty(bh);
>         sbi->s_lvid_dirty =3D 0;
>         mutex_unlock(&sbi->s_alloc_mutex);
>         /* Make opening of filesystem visible on the media immediately */
> @@ -2108,14 +2119,8 @@ static void udf_close_lvid(struct super_block *sb)
>         if (!UDF_QUERY_FLAG(sb, UDF_FLAG_INCONSISTENT))
>                 lvid->integrityType =3D cpu_to_le32(LVID_INTEGRITY_TYPE_C=
LOSE);
>
> -       /*
> -        * We set buffer uptodate unconditionally here to avoid spurious
> -        * warnings from mark_buffer_dirty() when previous EIO has marked
> -        * the buffer as !uptodate
> -        */
> -       set_buffer_uptodate(bh);
>         udf_finalize_lvid(lvid);
> -       mark_buffer_dirty(bh);
> +       udf_mark_buffer_dirty(bh);
>         sbi->s_lvid_dirty =3D 0;
>         mutex_unlock(&sbi->s_alloc_mutex);
>         /* Make closing of filesystem visible on the media immediately */
> @@ -2397,7 +2402,7 @@ static int udf_sync_fs(struct super_block *sb, int =
wait)
>                  * Blockdevice will be synced later so we don't have to s=
ubmit
>                  * the buffer for IO
>                  */
> -               mark_buffer_dirty(bh);
> +               udf_mark_buffer_dirty(bh);
>                 sbi->s_lvid_dirty =3D 0;
>         }
>         mutex_unlock(&sbi->s_alloc_mutex);
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
-upstream-moderation/8daab965-ddc0-492c-91be-c49f4fa692b9%40mail.kernel.org=
.
