Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E77C271475
	for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758834261; cv=none; b=YwFfzGSz1ivsaj6HmY6axuV/2bFqDsvpzKNs1amnvNTgp4oVxp1pjBWl1pBMiEHLxac/NRm2H+q5u6PqivK0qS8hsFXuEykUP0kuFo5aqJIeErRWdSSI1x2RjIEvIaazwBB8de29WZk4CSZA/Ct6v8J882wTlSoDrDZ2HYCPswU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758834261; c=relaxed/simple;
	bh=TaWAf47NGxaFmoeNTpkGyxNJMnL8dQG3IVYFte28oYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XQwtExunsaLyO2tNlfHCfVp7G94uFsHC0O8h54o3+Qeh5Rxzmx4KWauuOyQe5Dbxjq3u4tMykLFZKpUK1LExCPQOURycJYCPJi9yqbcEfTSNM0ErBPBVlKehtG37tI62Vk435JZv2kZzs5Byq5iPKyz1ywFNUSawNuMLThnVlhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c3H0n5KY; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c3H0n5KY"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-30ccec59b4bso1380208fac.3
        for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 14:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758834259; x=1759439059; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyWxjUm6H9Iv6Te7SGIIFl67BFnvPqof3mmPcEwJDv4=;
        b=c3H0n5KYRlmCt/y1rAjPt5xFxBE1vJfnWZ5Lu3bgZNWT7DWtDYvbSXOl0k+qw/4MOB
         xPlFktcjZiNK8TgcaV1nC4dTlVsmTlah7FlBzrTmZSqscWHz499/Venm14MyurQ4Rc7w
         BN8Vd6+e1jDUb+aFxvEqFoLNAYG08Qc1dSCdnMaVXmWqLTxzrefgLWf+oz8Y+zuPfYWK
         van322+FPx0N9xbpU+WzW0JYr8JJA9NKhtblo9B8mO3FnbJTi0v+UA7o9IARNiblrjb5
         Ut+TuvdcPxnFkf9p+WsZUqu30nMqRxGkcVc1vNLlCaKKwwWnepABU/tCiopD2X5FGOoR
         lXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758834259; x=1759439059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FyWxjUm6H9Iv6Te7SGIIFl67BFnvPqof3mmPcEwJDv4=;
        b=lsFhMv0bzWkGbnGDCVJyGaRWpCKg3ByspKXJsPxqJ1TGAzXE3h7t2axAlZXC1fulhE
         0ZJPAr9nQhNCeEnneNeQc2UiVlYLGivS+GVj32ct9sUAqe8y/VP4gSgGvjYLyGPvFyUK
         Z1WxspTjnhn9SeVwoV9KrvD1YkGXwqw0kuvulML+CQwFRqjT17GleypSY4iSPdYRTq5B
         XSwl1TkXCT44pa1blZjiW3zcNtcnb5CQYjsm/39mvn/jQZfZDKV6h8oOvJtR5a6qatNB
         c9T6bt9zKAIKZpECr/AGXQsRa4lmm+rnMpTo2zByGJbo8A6HmEpkcenGYvEQvbmVFiTZ
         Fwxg==
X-Forwarded-Encrypted: i=1; AJvYcCVKW+rZSn9tDnKlImXkdnQsc+r0Mn0i/FPSgP6QeWvSOMrEk+Z2/zT7TAOfs2LprvT2l1yeVoo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSZU4FgxT871erfrHyyVYiqgJ/DOK+VZL+6eEssy29Rko8eohE
	jL34AjkzjeveK0l7scEyUkG/JaDfQK3Pj/xOblzYTP8vTyrYQ7JIg5lb4hnv7kfiN9Opb+4Dgn0
	qehiZCBMjkMQJCqVXawfQ6YEfzT3X0KyBICd2StK3
X-Gm-Gg: ASbGnctXC6mw9ptv+CJtV9DcFiB7lhkk99kWHLYj1IQt97urZcHZd9EFhLIQFkTnHB3
	4Yl0kn8oheHPr9m40zhbOd6jt8l9UDr5K1OygCgjrR9zapWDkxIGBSQLbiqAFrfYOWLlwMEQyfV
	w1KjKT8aHeBr5eCgL1yo8dTfBJMQWdz4rcy0M0jmaLp6NCSpIXzEOPCXn/RX37kJPVdgx4B4dqq
	rQckvU9689BR/cnfG9OsJJK
X-Google-Smtp-Source: AGHT+IGAaB51zTE9AJ/jxxnQ6hMg5xFackwYJ7bHUuzgBSeZwnp+Uvo0WpTQG5sL6xoB6+S+lCd3H53mK7xpNpMOZ7A=
X-Received: by 2002:a05:6870:211:b0:35a:981:6997 with SMTP id
 586e51a60fabf-35ec2094e1bmr2680381fac.21.1758834258922; Thu, 25 Sep 2025
 14:04:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68d596a4.050a0220.25d7ab.0061.GAE@google.com>
In-Reply-To: <68d596a4.050a0220.25d7ab.0061.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 25 Sep 2025 23:04:07 +0200
X-Gm-Features: AS18NWCJrgQPhaf0gNWyoV9GS2hfRsakLx9a_6M2NvkMUpiPb0Ve7uTwLJttcsk
Message-ID: <CANp29Y6bB_rro=+L4ktZDPaN9omM0cwW0hhSizh_==h4GoyGrw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: hugetlbfs: skip VMAs without shareable locks
 in hugetlb_vmdelete_list
To: syzbot ci <syzbot+cibb3944405c273c2d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Sep 25, 2025 at 9:23=E2=80=AFPM syzbot ci
<syzbot+cibb3944405c273c2d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_lis=
t
> https://lore.kernel.org/all/20250925144934.150299-1-kartikey406@gmail.com
> * [PATCH] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelet=
e_list
>
> and found the following issue:
> WARNING: lock held when returning to user space in hugetlb_vmdelete_list
>
> Full report is available here:
> https://ci.syzbot.org/series/7d3a090c-ec8f-4d0c-8f7b-8797e63f1fde
>
> ***
>
> WARNING: lock held when returning to user space in hugetlb_vmdelete_list
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      07e27ad16399afcd693be20211b0dfae63e0615f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/06671e7c-eebd-4d11-9f0d-d9dae5637=
c0a/config
> C repro:   https://ci.syzbot.org/findings/75fcdb87-67fc-45ee-a70d-3064e8c=
1126c/c_repro
> syz repro: https://ci.syzbot.org/findings/75fcdb87-67fc-45ee-a70d-3064e8c=
1126c/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: lock held when returning to user space!
> syzkaller #0 Not tainted
> ------------------------------------------------
> syz.0.17/5991 is leaving the kernel with locks still held!
> 1 lock held by syz.0.17/5991:
>  #0: ffff88801f7dcce8 (&resv_map->rw_sema){+.+.}-{4:4}, at: hugetlb_vmdel=
ete_list+0x67/0x230 fs/hugetlbfs/inode.c:490
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
> The email will later be sent to:
> [akpm@linux-foundation.org david@redhat.com kartikey406@gmail.com linux-k=
ernel@vger.kernel.org linux-mm@kvack.org muchun.song@linux.dev osalvador@su=
se.de syzbot@syzkaller.appspotmail.com]
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
-upstream-moderation/68d596a4.050a0220.25d7ab.0061.GAE%40google.com.
