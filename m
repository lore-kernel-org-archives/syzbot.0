Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B301FBE87
	for <syzbot@lists.linux.dev>; Tue, 12 Aug 2025 07:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984661; cv=none; b=h/0xxqO7trgphbuU/+BQz81YY4agrtZ0ZYEGdKOT5LmdawKDSczkjpAtiBxmfKeBmqRnuL2/P+gXAEL0sSIz4QZN5bwJ5PB6mcndvVzmuv+CIVKw3fHNS1fSgvx0sBMb2EGBugmeNbnZMax7ApUETzBEwL+4lHYXzuM05K0ge08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984661; c=relaxed/simple;
	bh=1UvWIWiMQVEuf/Eav/GiyyQSdWl0ns8bS3gw2rGD010=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HkROrMELxFBgk6mmUGdWGrHLdxo1/uqKaTBj76AOM2CWYqZtdfrpOZ3u90/ByPjYoMPnwzo7hKaePK/ptF6ZyT8UnqksC5nDSnbXmhe7bfoEzFjjbPMe1+6zjtTPi1OmohyGmw+0h1stGrG1DI1QTmRyHu3fIGZ0/U2XSFPJJzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F096Z7XJ; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F096Z7XJ"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23ffa7b3b30so47744605ad.1
        for <syzbot@lists.linux.dev>; Tue, 12 Aug 2025 00:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754984658; x=1755589458; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69Z7ztnOk7Fb1qMRevOXuPGH6cNRe3KCNWiLA5EwDKo=;
        b=F096Z7XJrGJB8d+PQCcSEH0SMjY5RodmXpp1ldr2OQ7GrRb+Kd8Clh4QLZUpRSvxAE
         bKOYZEodI3nsczTfJMMRlMo1hA5qFko2y3XC/AqzS8kBS4mw6f0GYptmM/D80FotEyaw
         61Xke6NhKNHYl8oi9GNVxiP/Gn9mqduffTxmIuX0ckg7+imQnhnfrt4oSvUvT0R34hwa
         M9ng0SNzZu4ltmnOdxsrTtN9eoB6hAS7A4u62PXd/2J99SQPGXe08/tH9GhuO8F6c41u
         FpCR932jdOCci4nK1mIw7K5H9XzCOEKdHWKdfwAIYaHdCRPbs2TVG+lpyRrQ9ADje9WM
         Dk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754984658; x=1755589458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69Z7ztnOk7Fb1qMRevOXuPGH6cNRe3KCNWiLA5EwDKo=;
        b=NB5etPU3PLNNHc9HZJLuLLQ0qwRZW4BJbi8BoockMC/aZkrvHTijHdn8p1WmuIB2/C
         FhYrWlc3cmvdoCD4Rj7xVbyAjDeiQAb4cVYbceMBwm732bOy0Ydow906XwMBYi9w2Xlj
         0YhJluNsz2fQDCGPKkh+Ddr1ysbLc/dhLNIWobftKqgWOow9pjBlZ82C4xIysq33aWnJ
         ldF4QRVVlt9KDqQ0DkP2se7CFRhnUpCHfWz7AxaXCUy4yZRd9zJM2dciBr6DJVpeQHIG
         mkkf/lVjcJ5SKoKlTrRJtvZaJxbXT3lAQhRjjEy5UuYXVLxudPGfsjK5i4rtGBcbsygD
         05oA==
X-Forwarded-Encrypted: i=1; AJvYcCVQRMR/ds9KRaNv21r+cNhqt78TfeOKTjmv4ODe0IEL8k0+jceGgbDtuqMqReFryhePsAS9c/8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFbo1o0vG+Tkg96DGn4MAlGL3R1KVeZrpZYyaOVx76hWf6jjbN
	tPvLyIFuZvypD5v/Z3XlNFr8gV7veaz53h3IXNmRQeTm4/yEbFpSIkEAuOQe3V1pkStxnM9F8HR
	f6hQF7sx4AlWP+/otgtIbf1eiHLNdXVqoc+iyCPlA
X-Gm-Gg: ASbGncvWfAJ7PFpw01eTFwO2rC38jRs7TLGiPIAkjnwZtfgG0njFwNHDOl3mt278xn/
	Dcwhdl2PJFw/mWIKgZA7jfjXFZQCcAZf7t10Anx8sN8bbKmEbvpB85Mklbvc5Nh2P59l4Yj7sG9
	whPe6GqvFFrUItjPrlrwGmj2xNcv/zWLathVQSxebWwXzLs3rjsbSsGqInzq/isvWq6Iy5uq+vn
	XQxT7tFkV92c40mLJRLHCjj7beLrCiat5D68Xne/TbXskQ=
X-Google-Smtp-Source: AGHT+IEe3IbZ1mUBeHHkFHOPdc/FBKrWi8Bdo+oyryvLiGjvi3k8oOvoNUibG8m9itcc9ZvdZXwzGpMto6VaL6JOQgI=
X-Received: by 2002:a17:903:2310:b0:234:d431:ec6e with SMTP id
 d9443c01a7336-242c1ffcf60mr229547905ad.3.1754984657537; Tue, 12 Aug 2025
 00:44:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <689a5e98.050a0220.7f033.0102.GAE@google.com>
In-Reply-To: <689a5e98.050a0220.7f033.0102.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 12 Aug 2025 09:44:05 +0200
X-Gm-Features: Ac12FXwGpLh93hLQTDMsTycWlUxemQnoNxgfhQ4jM0rKeiDq-m581minsokGMwg
Message-ID: <CANp29Y41BXgtQvwqpmcTNDNy2b0EPxms5DyPXbPMyDN-Udik=Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net-memcg: Decouple controlled memcg from sk->sk_prot->memory_allocated.
To: syzbot ci <syzbot+ci5c068abc2c1451ef@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Aug 11, 2025 at 11:20=E2=80=AFPM syzbot ci
<syzbot+ci5c068abc2c1451ef@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net-memcg: Decouple controlled memcg from sk->sk_prot->memory_alloca=
ted.
> https://lore.kernel.org/all/20250811173116.2829786-1-kuniyu@google.com
> * [PATCH v2 net-next 01/12] mptcp: Fix up subflow's memcg when CONFIG_SOC=
K_CGROUP_DATA=3Dn.
> * [PATCH v2 net-next 02/12] mptcp: Use tcp_under_memory_pressure() in mpt=
cp_epollin_ready().
> * [PATCH v2 net-next 03/12] tcp: Simplify error path in inet_csk_accept()=
.
> * [PATCH v2 net-next 04/12] net: Call trace_sock_exceed_buf_limit() for m=
emcg failure with SK_MEM_RECV.
> * [PATCH v2 net-next 05/12] net: Clean up __sk_mem_raise_allocated().
> * [PATCH v2 net-next 06/12] net-memcg: Introduce mem_cgroup_from_sk().
> * [PATCH v2 net-next 07/12] net-memcg: Introduce mem_cgroup_sk_enabled().
> * [PATCH v2 net-next 08/12] net-memcg: Pass struct sock to mem_cgroup_sk_=
(un)?charge().
> * [PATCH v2 net-next 09/12] net-memcg: Pass struct sock to mem_cgroup_sk_=
under_memory_pressure().
> * [PATCH v2 net-next 10/12] net: Define sk_memcg under CONFIG_MEMCG.
> * [PATCH v2 net-next 11/12] net-memcg: Store MEMCG_SOCK_ISOLATED in sk->s=
k_memcg.
> * [PATCH v2 net-next 12/12] net-memcg: Decouple controlled memcg from glo=
bal protocol memory accounting.
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/6fc666d9-cfec-413c-a98c-75c91ad6c07d
>
> ***
>
> kernel build error
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      37816488247ddddbc3de113c78c83572274b1e2e
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/a5d5d856-2809-4eee-87ca-2cd163021=
4ae/config
>
> net/tls/tls_device.c:374:8: error: call to undeclared function 'sk_should=
_enter_memory_pressure'; ISO C99 and later do not support implicit function=
 declarations [-Wimplicit-function-declaration]
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [akpm@linux-foundation.org almasrymina@google.com cgroups@vger.kernel.org=
 davem@davemloft.net edumazet@google.com geliang@kernel.org hannes@cmpxchg.=
org horms@kernel.org kuba@kernel.org kuni1840@gmail.com kuniyu@google.com l=
inux-mm@kvack.org martineau@kernel.org matttbe@kernel.org mhocko@kernel.org=
 mkoutny@suse.com mptcp@lists.linux.dev muchun.song@linux.dev ncardwell@goo=
gle.com netdev@vger.kernel.org pabeni@redhat.com roman.gushchin@linux.dev s=
hakeel.butt@linux.dev tj@kernel.org willemb@google.com]
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
-upstream-moderation/689a5e98.050a0220.7f033.0102.GAE%40google.com.
