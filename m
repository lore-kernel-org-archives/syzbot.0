Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEF01F4297
	for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 05:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758346234; cv=none; b=bJBKF1FoMf5+SZnRwoP8jN9n1EH0fqqxuhmuAQGSvtFV82p+q8kbRff/unLcKukb16gcs56AMGY2BhQJyxivCwtlrJbCU1u7KsHF2sl7HTKOy8VCKYL3uPE1Bl8ANEsIWV2lZOk5zhNhvkcTUhSY9GOn7GvuBEno+6Db8bGoH5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758346234; c=relaxed/simple;
	bh=IafN7eEJzskanZKkiy1+BfOnjTh9MGo/yAtFoSav59U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bQf4VUjeTppsr24OwsRSXjN4zPnf5ce7pnhuNQZ+mzEK3FhEd2Aruuh3GT4sQ7vNjU01WNWQU05NKMj/kJLxJHLEZVt811xINSx0IyDlfpMzzZI7AC9RawbxcrPGA2UoCHiNgRg9p+fuQrJa+LLXjzTOoHch98lOSqykk3O8LpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ofgPv2l; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ofgPv2l"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-621a79a580bso752932eaf.2
        for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 22:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758346231; x=1758951031; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQdWmb0In29xsaK0QG7f1zZGadqKmfSrhetfaQl7ckI=;
        b=3ofgPv2lCoeZuJBLCI2NX18SOPKO6UW3CPD+nepV2CH1KxzRIp+u9ec7nrILOW1iVZ
         BeGzaViQBnTaWq53VvljqdL7wqPVpO2pr0cal1KbVW8HwAoMAIL3aHNoM0oK/Mwf0v9I
         FrehXOPN/EB4BbEexo+4zDKGaLn1vzy+NSQrEn/TaDee8LzUutBYSSRzHtZTDXM1Edea
         AkXfMfB2eDB1K3WwNGHhtxaPknh9NQrhs1tNWiG6ueVG41J7aGrYNEVRHpC+GcI3aO30
         Sczh7olSwfpxXCN0jhRHhW8bPThTK4Oins0JqGR25pFE6GqUu2r6/CkXudpzhm89YHGO
         rbTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758346231; x=1758951031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQdWmb0In29xsaK0QG7f1zZGadqKmfSrhetfaQl7ckI=;
        b=LKTkPnc0L+5L18m/qIMwI5vYP8d5EEyviE3FCztAbPtBc4+0oqkh85cfQ3RoSOp7PM
         XpKXw81dqA6bz3OobUTfzhm0lInXvL2+CRLZRAi3392KtbSg1jdGh/cY/UU2WSb3/aQl
         kG3MJV32m4DegAARyCzuca/X/hPnH7QBeqXYQA3/g0xJ3LligmVl3eNYm7e/nWDy2grS
         92vTDCiSprgTx/L4eaQz/PBdFuuWtmIcTRMDVmTWNKm970b5/MSUp5QqMv0iHT1nRG8W
         ti/Ox7VzueBGigqYqNchASMDdUhC0nNbS8WmikJ1TOlur63UgPcq4zj5HSWhDU3GM4KO
         yl6g==
X-Forwarded-Encrypted: i=1; AJvYcCXLINn7xtBcz6Su5gAzWZ/V13mVUROOzO2cWWbjLdyb97g+wVqmgVvwgBohJmDGDtxWxxfupq8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzvF2wKa8M+/Iwj1FGQGLs65NwGWmWPIp/rewpKUN+8M39klCGM
	trivBpNpB1UJLnBSsqbWhnuZ1fV4WBnWfRVEVqSkzWupmw4QTlwC+V57vYs47w8/hoTUg4TP/+G
	1w64hOD+e/t7eMBDMK6XGLKcdCud+Mc3fAErmNC71
X-Gm-Gg: ASbGncuRsItvdjh5ZLn24eGMCZr7RUh2sH7jc4D/0EOQELN2gPlwZuK+jOixnfmUHFx
	575oBX3NjT30blAhZR3xk96eUOR31UvlzhhjN90rZf9AbIUCmVjff08qAjWhrabfIXG94EZUYji
	pjzLP3M/7knOLBVDqAC7gpL2PZoYpcSgN6/aBYfd7tDLnP4b12370Gt/jDJnMJfuWlFCM3uFc3D
	7DDqLhZoQ==
X-Google-Smtp-Source: AGHT+IH6sciTFE0QETY07x0D+ea1TbIttP0blrywSveZBybC6GuN48+LxcPPBAc+zQPMxXHL7tJU6ByMaZCNymo/kjA=
X-Received: by 2002:a05:6808:19a3:b0:438:3965:28b2 with SMTP id
 5614622812f47-43d6c2a9e58mr2743065b6e.40.1758346231342; Fri, 19 Sep 2025
 22:30:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68cd38d5.050a0220.ba58e.0449.GAE@google.com>
In-Reply-To: <68cd38d5.050a0220.ba58e.0449.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 20 Sep 2025 07:30:20 +0200
X-Gm-Features: AS18NWCsQZz1yuQSjh5KTM23bjgf6qnPHbGdbf-9J8u15FAWMf8FjKPj1ytge4s
Message-ID: <CANp29Y699507Eu2Jw3LHjaEQCC4-_CS_pSmm2x7s-UNtsxNcqw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,16}MHZ
 flags
To: syzbot ci <syzbot+cib729075734784e16@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Sep 19, 2025 at 1:04=E2=80=AFPM syzbot ci
<syzbot+cib729075734784e16@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,16}MHZ flags
> https://lore.kernel.org/all/20250919122325.f0abcf092b9b.I04478fde87a79c79=
09f1cc4249430deaf71e8bd0@changeid
> * [PATCH wireless-next] wifi: cfg80211: remove IEEE80211_CHAN_{1,2,4,8,16=
}MHZ flags
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/56aae9dc-2280-4bc7-9761-a0d119923350
>
> ***
>
> kernel build error
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      f83ec76bf285bea5727f478a68b894f5543ca76e
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9c1d861d-4d4d-4c90-a946-8769043ca=
3e6/config
>
> net/wireless/util.c:118:20: error: use of undeclared identifier 'IEEE8021=
1_CHAN_1MHZ'
> net/wireless/util.c:120:25: error: use of undeclared identifier 'IEEE8021=
1_CHAN_2MHZ'
> net/wireless/util.c:122:25: error: use of undeclared identifier 'IEEE8021=
1_CHAN_4MHZ'
> net/wireless/util.c:124:25: error: use of undeclared identifier 'IEEE8021=
1_CHAN_8MHZ'
> net/wireless/util.c:126:25: error: use of undeclared identifier 'IEEE8021=
1_CHAN_16MHZ'
> net/wireless/reg.c:1734:18: error: use of undeclared identifier 'IEEE8021=
1_CHAN_1MHZ'
> net/wireless/reg.c:1737:18: error: use of undeclared identifier 'IEEE8021=
1_CHAN_2MHZ'
> net/wireless/reg.c:1740:18: error: use of undeclared identifier 'IEEE8021=
1_CHAN_4MHZ'
> net/wireless/reg.c:1743:18: error: use of undeclared identifier 'IEEE8021=
1_CHAN_8MHZ'
> net/wireless/reg.c:1746:18: error: use of undeclared identifier 'IEEE8021=
1_CHAN_16MHZ'
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
> [johannes.berg@intel.com johannes@sipsolutions.net lachlan.hodges@morsemi=
cro.com linux-wireless@vger.kernel.org]
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
-upstream-moderation/68cd38d5.050a0220.ba58e.0449.GAE%40google.com.
