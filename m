Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A32E1F1315
	for <syzbot@lists.linux.dev>; Mon,  8 Dec 2025 08:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765183812; cv=none; b=VzVYoOQ67WXFsY4oPcI/ipbKwA1nov4yiBWQTFZZQeYaXnHSp3+NDwFFoG38hDAqV2fRYQwg+amChUfQY7yx3bJKIfQGL3pDx/RbPnWyKjIF1k9Up7aSHRYPErzFSlTMKR0QtOKVobSoavlvMhYLbVe3pfwtOY0tjbhVeGXUydw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765183812; c=relaxed/simple;
	bh=vXwK+LW6dKgi7LUCDPBAx4PbLuQmEBdM6TkgnF7/Z5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oUtyelUxfKVsR7qmSY84lJMaD6y3/KEJgUl80zigVPZ1FMTanQRdjI5QRSxzENTd7hOKV9fdYNcEQMbxNEa2h7yWdT9sHws6RsgrMgRg2kBBglJnk0OKvQXM5IWESpCYFMqLMHn4nazySQq7abT/4AQuH5VrsP3goT1cdsi+cAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J04ocNLS; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J04ocNLS"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so4576872b3a.2
        for <syzbot@lists.linux.dev>; Mon, 08 Dec 2025 00:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765183810; x=1765788610; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TW7hVvwD8xE2OhKSX+sw58GxhAMUZPXF36Fwaqok2uI=;
        b=J04ocNLSkaKOzmkddJPQMae/Wti+Ran8TxnLMvNHaKo10I4vy3gE6q3ILOkC8Yja6b
         QxX3DeOlmHtH4V6ACQ6/ax037zbqOIqCwJefAWl2aA1CdMatJbgQvqr5KBR2ASPICqJ/
         4rNdWlNHE13nxVT5fuz6CzmH88/VfgLBzvki4mVmggNmnnhjWyGJwoxbFr3FlspEH5/q
         VC3fxuG52MY6eCRzHA7kMlB2Lp7jSHiVplwi1mtIh/jOFhkzfRQaI758w2RtYQkZKGm2
         tXlvp80FL11IksuG3ZYv2mgLfS1J1+jLw+beRGrh3n9IxfwwWYuc1t7/q5tbW1Iynnph
         g8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765183810; x=1765788610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TW7hVvwD8xE2OhKSX+sw58GxhAMUZPXF36Fwaqok2uI=;
        b=GNEOLtxbk3bUnzj1hGT1YrjD7+Kenp58L452OZCTc1eCSLJbv4fy92PwD+aC4IppFG
         MnHb3bV4yf4eTXHmKgSn9UCBihu5ma58ZWjl/yOvHB/RtBM/Sh8fdN2AKsyHMSqG+Ccz
         fBPNaRD5HBnOiKsoSUanJ25Nz3JzVav6lPsiviK2+Ke/JVMbmjFbWaqtEA+IzXT1OCtD
         qGo1AeqOGQHPINGKYCouPBnZhKOzrE3BupwWOYo1E8A7T9wE4T/9AXGxnPqwj+ShhMdL
         0pcHzL2jfmsTf3qeRZF652BSWmnHfKU1/GH3g06Kf8oL/Iq6JJuhDpBSzJZEV4daNPC5
         9zBg==
X-Forwarded-Encrypted: i=1; AJvYcCXMQ5dT/6Ix73L6WN9d1ukVpfR0uasvXbuFww2I+0fevu7pW1hf8Uqim/UkqYkPlRbXSEjTvOs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYDZvliKFqa7xvmnUp6zm2Fahz+RTtf/BA0Al3I2t7NRMKKYsi
	G7ovL2huQHyyJ2At2u0QW4ZwJxn/+nSn86h7mdIAD2KR+XqfAg3VtGtzIEruKaEYdVAFyJVXiNs
	tRcNZk9s/JYHuJC7eIOlP+kPxEkTIXRoeTC2CCmsp
X-Gm-Gg: ASbGnct3VgFlqR1xbNRuhvf1p4FKvboqtuuHED5V3kkKggrkPeF2q2fIayMFNLsSxlj
	VnHVyIu8mi60UR88C1kIBk24YOaXQi5II9jA3kI2P/4ei1MWsSWAw4G0HNnqNeTaAwKKWvU4L9l
	+QQD37tvxpbTXEhjDJvNvF/FDs8BboR6JiBXHrEn6pkkaba4tlWKjTMwMRZXrxBeR53PeV8+24w
	F21jEt/wtJgNWoOYNo4q5huyrFcD35V+dg5pEKySACRKvLQtkKggkRNguoOXYrohNVuIU1pjyKX
	+1F6vcjMuTY2cntJNFsoDjn2qQs=
X-Google-Smtp-Source: AGHT+IFoUBKCqEP6VP9fjn8uOfJxEUf24ywuLDvKdLmrJKJv3ErA4+i6vtfsZb70ZmxRdDN3XQwKDtwdaEf9gTS0/7M=
X-Received: by 2002:a05:7022:43a3:b0:11e:f6ef:4988 with SMTP id
 a92af1059eb24-11ef6ef4ae4mr4455536c88.36.1765183810120; Mon, 08 Dec 2025
 00:50:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69366cbd.a70a0220.38f243.008a.GAE@google.com>
In-Reply-To: <69366cbd.a70a0220.38f243.008a.GAE@google.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Mon, 8 Dec 2025 00:49:58 -0800
X-Gm-Features: AQt7F2p-8M-wbazum1HowWIB0lSFfgSlauYTn655oRCqfWFDY3nkOTbHxFKR9Ww
Message-ID: <CAAVpQUAf1YeF6s96de+4n=pWBnJs8WAZ9QFAWks6aajSPGf7sg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/vmalloc: clarify why vmap_range_noflush()
 might sleep
To: syzbot ci <syzbot+ci21b11c7a77034dfe@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Dec 7, 2025 at 10:14=E2=80=AFPM syzbot ci
<syzbot+ci21b11c7a77034dfe@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/vmalloc: clarify why vmap_range_noflush() might sleep
> https://lore.kernel.org/all/20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8e=
cb08@google.com
> * [PATCH] mm/vmalloc: clarify why vmap_range_noflush() might sleep
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/ca5fb0b1-49a4-4066-b78d-d144e56e0d2b
>
> ***
>
> kernel build error
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      3f43be96f919cc611dcb2a4e38dd464831f4513e
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/1d630f58-694e-4568-8ac0-62e02ea8a=
59d/config
>
> mm/vmalloc.c:308:14: error: use of undeclared identifier 'GFP_PGTABLE_KER=
NEL'
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
> The email will later be sent to:
> [akpm@linux-foundation.org jackmanb@google.com linux-kernel@vger.kernel.o=
rg linux-mm@kvack.org urezki@gmail.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/69366cbd.a70a0220.38f243.008a.GAE%40google.com.
