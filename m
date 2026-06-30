Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CFC331EA1
	for <syzbot@lists.linux.dev>; Tue, 30 Jun 2026 09:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782811346; cv=pass; b=Qih+c9DsObMZWLpEUvX/Zk6T7sh5fUTubmTGWcybyZR85MkzrlBD89Eo2zGtwwM29jC/blypqGbq4pAnTyDMgCL5b2jHqgudJCxSe02YsRxd+vJKS2aYVWHGEiSZmfirzj8J1H+vLo0r/Gh3zWRVGZqI0fIMXlO6HkcJLNkT1tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782811346; c=relaxed/simple;
	bh=q2ep8XvAFc2N8bmMcLyy4tIYBKIQWE7K7d8ExwIe+dw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F+rF8jsQOgCsEiIcrke5fn7brFKkLx1fG5lTdSGoZLA9lrbqBuzaf0iasCfSD1VqVlbzO/AS+jaYIbROSNKA9hxhoqURfsWmyjvcsyub6kZM6facDuLoNoCEM0ZzOlTvRRLbRCJtY/M9XfdcVEfPxGeDZCLlOW0jznJOPfTJtcM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dCWfrc/g; arc=pass smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dCWfrc/g"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so30975545e9.0
        for <syzbot@lists.linux.dev>; Tue, 30 Jun 2026 02:22:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782811343; cv=none;
        d=google.com; s=arc-20260327;
        b=c3Rce5jW4MNWuQG87FIPLPEZ4SxLQFcxnmrIWHqrzKKzmWj5i9cMu+wP3HfeUgBwhk
         gCBNxicJtn1e4xmOcg5hHoSB8skz8o92NYsv3vQEDn1eFRaBD5jG8vMrgGsZHp00h5aq
         PPLzboOGtFfeHozaPsyd0ExVzHuCIJauDlEBLSBswI8/xAG4Oqjmlh/23VyAQbqkFBPd
         LGK6nGRE/E1M5VFfjVccm7x4CPxUXxKtVoxkZNunFmKrSXa0HKV65xXU+q2sEouD6eVG
         Kx8iqx+Z1hCQmR/C3jpggl81eUbCavxEf9Rkozzg9/5IF67OtTxDKXGvKpiQ1z3CmuNr
         oaVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QMnX13QEvTFRGVrHREuB38I9h2CbGiRPKI1tnzBeGR0=;
        fh=LmG8td9YKjRivIGggptD7xgksbZZLPjHqT9376kSy50=;
        b=bbC5B9BaRwURL23SmCa/zTWOl+YHpFltMtphOqj1cZQ5MdCIUy8+KEO/8RKPoPm8u9
         3JHUeYfyMKMIFomDt5D0wrfTLhKs5F5OKhxDEmD2omxKkbUokwfZmCfT1Zc8FPj4yt/H
         0/iNq9x96gNtQBMyXbDZQdfevZTtubdy9wM9Oab5zIJL/8PNDYm1zEWOyeykpaWeq4Wp
         gQRTw0YA+xCF7+Oqtz3pkt6NNe5HoQxvEg3X4swrFeE9BL8BA5pE8WE5ZdhpT297qAG0
         Bi6RAZ7pgRFnoDCEnfEaRO/tcWVPOR0WSvWg28EHCpeUm4SlAlToKV0t8G/Z57amV6V3
         P1nQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782811343; x=1783416143; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMnX13QEvTFRGVrHREuB38I9h2CbGiRPKI1tnzBeGR0=;
        b=dCWfrc/g90IgwyvVdB4fpBjx+nTTQrTjL2ajH1PRKYCY+UwHPDEYHLrWC7IAW66MxA
         m/EC+ED6UB/Zh1gYXf5y8SwA6L2YxTqsMbyu2q3fLiTSZcIzS2KeR96TJ+npIvtzD93O
         V0so64qmv2bumit0R1uF2FkiVNgwjniHflMzYvahd4TxUlfooXeAKnZf78DoFsATw7pk
         /qlrt61RLUdmp7DQs1AwgEb5NnTYn38ZTGhjHew2WJKxaEZo8eQj41V5xfEkM40EMiXB
         xCUl6pIhpn8Krg03TCFSfGUlRdKckZo/pMuHP6S20c940jhMq7DD13BpnWlp/O1dmbnh
         9jCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782811343; x=1783416143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QMnX13QEvTFRGVrHREuB38I9h2CbGiRPKI1tnzBeGR0=;
        b=NHb7S0XRCE+DAVFqcMRWOibYDHMpUFtoTnGRwB1jOtV8Pr33TThL4b9e9/G9W/lt8R
         nq1bqNHA/Oy1b4XpGjeS/7C1VE7v3eXm0ZEVKedqFkEr+1QRCP7hPDEIIXNAXiGGh603
         9wz65PelUERROYNYzCGpoQ3GapSMUpPT5P1T/mpF6wtld7tJdwMKmbwSFYwzra8ytOuR
         9ritzyN+rI5NWztTw3d3cjKFwW7Zy71lHTj6yzLCzYMl1wfX1h8cBmzL040XVP22PLhw
         5weJGHvevOUmoe4BM6TmA50Fe+7KHEKvnCN7W4U7M9R5MJUG2aZr4vqBXet+Jt0bf0Dq
         PFTg==
X-Forwarded-Encrypted: i=1; AFNElJ/nmgTbVL28kyrY21GrXgh40M9ajURIYxtH2RV9IjrviU2IeMZ2RsAgHw/c7DOi7oCMD/NdEWk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7aEu9fAmj8rtJOJQqpsPvvN+WeLxTVBdv/QtkgBynb9saRAWT
	bHCb04Wj05aJYLpLxevaDF5+aplaqu8HyelhhS+dpnvktNvh9WXE8yRL7P2Xv0z0eCLNMcUIzwE
	98eoxhZzwdX7aoQQv0CRq2FAkERmGPXaFis+CSvZN
X-Gm-Gg: AfdE7cmAPlMN8xoxhx8S+QiwF/5bfnv4U4UAF3KVN5/lj38fdsBCPEJatwF+rKJ+MEj
	7daIWmV6skkhcvaLdz0Lg9zYuWhOakWXNBmGo6BDOCqHHA+7lDr29pyh/UdldudZFdOZsNx8Cim
	Aw28ZTl94CfUxvP6u1LfpnJrzLSvaZBgMAFowOZ8a4TmGoQl+KhScy+aD1gIaVySiPplPVM2oow
	tf0b2IH3gUh38HbdNACqcFuMPePnRrpODR3DUgf+Uw0vlZpmMVVXzezJKwekuowxCr4KvuU6rus
	ao+Fk7425LteTXCYZAb6eY5590RQLb9+8+EJLrbsXML6ryzixEJuva9Kfg==
X-Received: by 2002:a05:600c:8012:b0:490:be78:1861 with SMTP id
 5b1f17b1804b1-493b827daf0mr42406975e9.4.1782811342158; Tue, 30 Jun 2026
 02:22:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a433f04.b42ede87.8e801.0002.GAE@google.com>
In-Reply-To: <6a433f04.b42ede87.8e801.0002.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Tue, 30 Jun 2026 11:22:10 +0200
X-Gm-Features: AVVi8Cefz9A2yPC8OZlAVg3RNetZCyB06z_vgUWI-675P6-GVs7vGCNCqRiIq2Q
Message-ID: <CAJWNTGwbZMNBXpH3ipgv3+JrffFFXa+wJBa8kyucU4KAnvgBPA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Fix use-after-free on mm_struct in bpf_find_vma()
To: syzbot ci <syzbot+ci738420217ba889a2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Jun 30, 2026 at 5:59=E2=80=AFAM syzbot ci
<syzbot+ci738420217ba889a2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] bpf: Fix use-after-free on mm_struct in bpf_find_vma()
> https://lore.kernel.org/all/20260630023443.3026627-2-sanghyun.park.cnu@gm=
ail.com
> * [PATCH bpf-next v5] bpf: Fix use-after-free on mm_struct in bpf_find_vm=
a()
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/f0ce67c9-2c09-418c-bbe2-c698246e9c7f
>
> ***
>
> kernel build error
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      53435562a725962e4de0c29653223129ba11643a
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/a434cf48-2810-46a3-bb75-064be88b9=
6be/config
>
> kernel/bpf/task_iter.c:1017:3: error: call to undeclared function 'bpf_it=
er_mmput_async'; ISO C99 and later do not support implicit function declara=
tions [-Wimplicit-function-declaration]
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.ne=
t eddyz87@gmail.com emil@etsalapatis.com haoluo@google.com john.fastabend@g=
mail.com jolsa@kernel.org kpsingh@kernel.org linux-kernel@vger.kernel.org m=
artin.lau@linux.dev memxor@gmail.com puranjay@kernel.org sanghyun.park.cnu@=
gmail.com sdf@fomichev.me song@kernel.org yonghong.song@linux.dev]
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
-upstream-moderation/6a433f04.b42ede87.8e801.0002.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
