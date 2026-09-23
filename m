Received: from mail-oi2-f26.google.com (mail-oi2-f26.google.com [74.125.231.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678B55275B0
	for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 19:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.218
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790193511; cv=pass; b=QBpPsQAZiLCAdoWXSARrgUJn5VI4f5U/V7NEcDXw8kaVceD1V68dx/nP56ftEoNnVBSfgRWu5jiIHkbGGAhwM3rj4XhweB+Mx5CzeTm377tUNsws2YWS10RdqadasA1WxpOM+lARUNICZzJ2t+DIX+c0pzqniXneFW+j2aDWOvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790193511; c=relaxed/simple;
	bh=4LvsLgusYh+gFytFAM1GeYIcPBtIQ9g2ObIYXGiRfHs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dg5vBsxvM5vQTbNSlPOEvoWZ2VO1fwKtMIanRsOMLmr40SsQYXOAMgeSKHn10D/F9FbzMFwRdHh89EkpIQZUlapvuMiO5tZ0Ji7jrbh7xfdNNkzdDy4x2JvfYhjF8GPpZGh8dRncj5JG5KZ50JpN95FX7hDTYtI0NfydMEXBiaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DmWePSLK; arc=pass smtp.client-ip=74.125.231.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DmWePSLK"
Received: by mail-oi2-f26.google.com with SMTP id 46e09a7af769-80a18990c76so1078731a34.2
        for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 12:58:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790193505; cv=none;
        d=google.com; s=arc-20260327;
        b=LP8Dx7kTYXfHHO/ySuFa+Av8clBff831YqrcfjQlIKrEqnefS/RfpLqatvtQTHSmFM
         cmqGE2/24M9EMB4BJylGLVJU3cJ0S+woDhXG/6rRZGrNq0aJPvxbC/myE6VVHXdzG2Bb
         HdvFPGKc7FXg5DiSfUbaOlOY2wdgE8iNKuCPERbOOuI4lEipMoRqHDsPcTDxrwhHnwqx
         8EH/pEgQvwqpi2tTKMqMbd+pZnRFBgY+xJX/IBx+9pY45apDti5f6jiQf6NVFz462YHy
         VNtP87C9GsYMgPBpsmsalsbhWf8t5UHqvA+v1Fpmbo3VIHC4NP7kmsQZTyDzxJ4/Fr9J
         xfMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZQmeVHd39pt+nASONiZqSYGjAx4XKYxOeS2j/8UXcOk=;
        fh=xxruW2Z5/4Gic1yFIorgyGcFHtnadVItPXOoMVMRFsQ=;
        b=W5EaCazXdb22uCVIEEz8MoFOT7x9gy97AM4XLsl2Lpz/PRmJsnLVm7D31ZpUZfu+mA
         g6oAY+nxr/c/T8E6i6d3hQAvoE6kHuskY3uJEnOHFSv4cgHvTkEpLuhxX2MOCAKGjiLm
         Vduk5TsxVJnKDfaU0au0+qCW/RvqjL6boBHgqUErjH+M5PWO9vUS+EdW6jj8FuFtcJdm
         cGdl+RVYR5VbhIg0QvG+WpQSD8uKnc0Xemo3CF2hbt9rmGBz1/PFD54SqM7AE1PVnjhm
         RFW/q0mH8XYSnXnotmpfRLp7sJbGmXuoHPfXVv9u4PscdHoduzPct6zi3gQRhgSGF2rR
         psvg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790193505; x=1790798305; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZQmeVHd39pt+nASONiZqSYGjAx4XKYxOeS2j/8UXcOk=;
        b=DmWePSLKENjYOHIzHWyhh46q2wOjGcCQJY+flWNTzanSYHNjc4bgMWtl5be292Ko3L
         xwB9gz4RcU34mhAhgz5M2XQqHjBLgyN+o3b0LMj0D/6kMnf0CeWegTzm2UdhslisUBYv
         aswS0qcVH6x9mhoQC4bdW8t9gbL4DQrimt3OsqQcX2kt2a/N6+6+MNKSMYSOk7Ffdka2
         q72DhGI+35WAjECrfHNDbxa8LVqI40nblGNKa4wRxv+19l9G0k1twnc8z0N1dj2Oa8QK
         PoTKSaLH/igcne/6p/WuL31kiVskNgAh6DOqEPjVuCw2FRSIp8C4GamqjNenONEdESUl
         MwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790193505; x=1790798305;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZQmeVHd39pt+nASONiZqSYGjAx4XKYxOeS2j/8UXcOk=;
        b=rdixSn73a6JvhblI0XdC2rki6ckDinfRqx28l//ptiPpojsNZopCqTFJicT2gxuqwY
         KaeHHffZeN0EL0VLits/Wg55BgXRy5+SAcQrZs9EUuUfCS+wMU/jawEwWPmg7wL9W+u3
         Ob08Oca2eThvbJ/Gl6Xvc0Wsas3e44fBjJUdeZuHh6fdxwDQ2x1PcL6WjVAOuljwf9hG
         BVm1WZqpSpLIuqOXhuQE/STsLRME5+L8N3WCZh94fEtm5zvWUILW0dyO1wGJNVaxjsRb
         Wi5cHp61Zz/a7Q+hCYJetBSXeOs5OGPmM8pTaz+aHB0o3TgXH/2rHok5B7PitMpN0Icq
         //1A==
X-Forwarded-Encrypted: i=1; AKwUvBxdbfJp5kjU3L06Z52XwVUXQ0+Lt+Md3cg0uwGi82Jqb2VgXM+xQUIZKrAXVUNnsByZL1kzSU4=@lists.linux.dev
X-Gm-Message-State: AFuF++kkYzBehbXt0EYMUFt0xdvClgGFWbet8kiGMbnbIZG5TL9Jo7gU
	+b8gI2V5uDxSb7hHVrPazOcvwe5ftfQ3pjV+Y4hBXCEBum5LygiKWp0MdG6zS5kz4DOEIErsywk
	3Km6Vl1QzMGYChAzynVV8F+uOnREFMdB0wGsfeaWk
X-Gm-Gg: AYBFou25xtS4FCBSAZXF6pIDGyZBiM/J614P+0F1C+jJDj2GVa99nXnFva+LNgkokgm
	ptjsYbe5L+hi3hd+0aEJSmS1NAqes318b++izePzfshJXOuc0Gv4LgS+fB5NsMyoeyhyNKgNQIT
	Rsf5v2yU92LeM2GOGx22cNr8ozitY9pELTxy69p2iV6I77H5uFOPUmz0KjDGJIlMUAxUCmA9247
	ZdR4wpAeYQeR0W44eEgssb1zPpaLps91W74zynlQG4xgIL+RG9aBbfNogf/oMr0WC6zDFkfLdpH
	Amm62Pz/uZ9TOxsfC9uLAfckgBoLwIHczfzY1Wre5nqvvD+a/PQRPwMGWe441EYYkwy/awraObV
	fYiaIwhJqZNm8M0i/gOplwV4bznF8W6tQjQOsaRvA1y4mXv8CB8JzMFf/8QENvAuN8Qtc9HEm9t
	K/taqbYLnm2KRYAqwGZPW+snw=
X-Received: by 2002:a05:6830:6382:b0:80c:d34f:5f59 with SMTP id
 46e09a7af769-81782d85abfmr340553a34.18.1790193504584; Wed, 23 Sep 2026
 12:58:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab419fb.71f81b7d.15fa6d.0051.GAE@google.com>
In-Reply-To: <6ab419fb.71f81b7d.15fa6d.0051.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 23 Sep 2026 15:58:13 -0400
X-Gm-Features: AclHuK9pS7geeBsmvrKxmH-MnlyMKuPWgZ-7u66s78C5l9lCff1Wybb4NNS2H-0
Message-ID: <CANp29Y7u5HSxht5qftWiRSYmdNk5WkpDc2iRreAhpQ0rikKxRg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Type2 multipf support
To: syzbot ci <syzbot+ciabc64b91bcf1d980@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 23, 2026 at 2:27=E2=80=AFPM syzbot ci
<syzbot+ciabc64b91bcf1d980@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Type2 multipf support
> https://lore.kernel.org/all/20260921191239.4249-1-alucerop@amd.com
> * [PATCH v1 1/4] driver core: Rely on supplier driver binding at link cre=
ation
> * [PATCH v1 2/4] cxl/region: Add region reference in memdev attach
> * [PATCH v1 3/4] cxl/memdev: Add support for multi PF devices
> * [PATCH v1 4/4] sfc: add multipf support
>
> and found the following issue:
> WARNING: synchronous SCSI scan failed without making any progress, switch=
ing to async
>
> Full report is available here:
> https://ci.syzbot.org/series/cce74032-73a7-4071-a29e-65a7ec02c350
>
> ***
>
> WARNING: synchronous SCSI scan failed without making any progress, switch=
ing to async
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      93f51579e7df248780214094418f205253383cc5
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/50697200-bc23-49c1-b943-c9c91049c=
f06/config
>
> ata1: Failed to create link to scsi device 0:0:0:0
> scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devic=
es might not be configured
> ata1: Failed to create link to scsi device 0:0:0:0
> scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devic=
es might not be configured
> ata1: Failed to create link to scsi device 0:0:0:0
> scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devic=
es might not be configured
> ata1: Failed to create link to scsi device 0:0:0:0
> scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devic=
es might not be configured
> ata1: Failed to create link to scsi device 0:0:0:0
> scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devic=
es might not be configured
> ata1: Failed to create link to scsi device 0:0:0:0
> scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devic=
es might not be configured
> ata1: WARNING: synchronous SCSI scan failed without making any progress, =
switching to async
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [alucerop@amd.com davem@davemloft.net ecree.xilinx@gmail.com edumazet@goo=
gle.com icheng@nvidia.com kuba@kernel.org linux-cxl@vger.kernel.org netdev@=
vger.kernel.org pabeni@redhat.com rafael@kernel.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6ab419fb.71f81b7d.15fa6d.0051.GAE%40google.com.
