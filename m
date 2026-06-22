Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6388B299A82
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 19:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782157537; cv=pass; b=up3qAbP3scVXffbeiMp9SpzmC6vCnPY6lSDTExfAEJAYHa68DkYvqWjQ9PeaZdf3R87hXlvXdaepzQeYtirgo2VhnVzdHUzGTeC3kj4SwDmcSCokClcleqlh6ZqTLnhvqLfb5Ov0gq8BZ0NbGULmB5p57Ru7c4/K9JvVWcusU3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782157537; c=relaxed/simple;
	bh=wLfi77vl6bxANim/wz75ppi/eF63rTePavhkomsCyFg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FDbQ1tYOlkoVgugoBN4Ee2Gi94rFuULtgn/NePQn9JeWWwS3PL4QR3xQlTLBo7pdS0TX07VJggoo4cnAsgOqkVLOg9fvzjkC3LqKi8izsY1PP9RMCc/aeDi0lwC8mwmibuIx1CImPs7CT3dUZ0rl2veQCjSatsGrDgQNJri43Ow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QgoGMeqM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h2QxUPGf; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QgoGMeqM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h2QxUPGf"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MJbK2E2122737
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 19:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KjoHWP/GNd8XzkURSsjarJERcmLz0FeprGXlq7m6kmw=; b=QgoGMeqMygnqk2Y/
	joGIOnPfDp06RjLx8Df6pM0vBcNl5GbpKU5S33Bs0SIAJLQ6pTovIWZ5NqQ6CXDo
	F/J9Vx4RaeWCDHgi97HLJ3yVOmg4do/SMz7fIBes++CZrkW2cCkeaJ8fbaf/HuVK
	avK3HNNor+QK8q+mbhnmE1cLRbp9CxZ9jtBijcAyEVHF0L1+9ythRuMz3oYcuBxp
	8528JW9aYMK8PLg4k9Y0coDTc2P1Ithl18BYKzFCv5hP/cnBEonlrrb7G9rp1CZr
	ZRwzaePlQEUKLtPZ3pNJIHloTFG4HI2yhA4Foh54ES8o4upQcKASI9HDw+pCOmuF
	S3pPVg==
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ey5n41f34-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 19:45:34 +0000 (GMT)
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7dbb5e586c1so102981897b3.3
        for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 12:45:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782157534; cv=none;
        d=google.com; s=arc-20240605;
        b=C1FNb7fJ41CY7Hh+55KVg8QwBaNnb8eZs5cOFmgqcX5sjvmma3ujMpi5iJp0s817fd
         gqslaq5TCaFuPKveUckCcbtsLCUYIWIIATlwpuSC6vJIEddE4LSDd6ibca5qb26IGeSI
         Dm1pnAYG53ehRxJWzXLsfLVaC/2cTnIGd64s4d3oB7omzXLIlzOZFmC14EJCWSYhKufz
         EBsFKEak1ddkgZMi4t/qr3LEhCo0nnnkcGw+WHLOaQUmEmBieWUVh/rsm8U12yXA0eG9
         aBg7ozWjS/LHgyOLOm8qukTCG6xudz84aSQKu/I2dQas5Uw7eP7CEVtgKMkBrCujMuoR
         eD1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KjoHWP/GNd8XzkURSsjarJERcmLz0FeprGXlq7m6kmw=;
        fh=cj8msWr5Y7LfuXXWKm3B5fiV9eRuoTAqeF5MdQz8+KQ=;
        b=MkZ9hXp0Sb4Mq0iNa/uOhayU9uUjyZme+n9L72qO6XeSXkybG3VaXWL58YsJV9KYQq
         iCrDBQgfVUbf65UrS+LgcqJgl7Zg2wTr4f8KiynF9NqyyfI+0IUGkbYpyUGo4DGpyD5y
         IOk+Zxbx9iN2JOvDBApZbFFicEw1gSjlgou+w+13Lw7AiZM46MUrl8jOTUlQ2sm+vsLW
         iKMhb7m/NVRiUNz9koxVuXA4T53UvOLq5BS8bWZ2MH4SjhWM64FXA+h5po7A0lPsdtYT
         imVEBolfc9RX4KgMbFlIQueZtn3dnibCGkxrrOn07gc4mIJi6r0XTxcRbuaPqMFTcwK4
         GbqQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782157534; x=1782762334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjoHWP/GNd8XzkURSsjarJERcmLz0FeprGXlq7m6kmw=;
        b=h2QxUPGfr7sSd+YS5/iixrWhKLucw8cSqW1VCgjKyxOw/ewIaPTvPKcYCu4VOlONnk
         ZwRFz40WVX32/+w78XQ46RCkcZe5IcQhu/oA9rf4SY4zrdxDh19aXU5Zt4a0EthfB7ia
         4dW7saYyoJVQoxRrHE3+KOlzVTXZcoPjrZlrtEotZzNzHMTFawx+fTHBeSY+WqM4J+9H
         i2sugi9by8vM19b5WvL9Dd8IYNquxycN7fcKISjjIWwRMmTaQoU0FH5De0gIFOKItcZL
         tWHwMCd4XzNsOlnz8vgq6kiqwTFsJgV0OvQGaPMHCtwbg5xKn7nqXBl8oUL8DPPbH07v
         SMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782157534; x=1782762334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KjoHWP/GNd8XzkURSsjarJERcmLz0FeprGXlq7m6kmw=;
        b=aNeuEMdTAPoxJF4yF2HA4H6C248W603heP/ebYzFBQ6Ut8XU/QGm4U7Szr7Kie71nN
         LIQOiH4ImHIPq8Zl1k2LonttRs/X5Y/KmPdgMzFTIC1xHcWbhTME575g7dH9F2v7eVmu
         ue/AueijNGMlGFcTppV9GSCMoNx2IdIBkMQ1MJKYRotLqL4lWACZkHh61NUwkmkj+S3o
         yKe+7Oywk69FSOxXYWPqGGIwU/XesdwdLchh13GgFTBggNZh38jjD/u5TAfvoJPCer2q
         70uXG37b5RyZDer0ExSHvFBacar1Tmcg6rLOl9mFVIAWQkXeSr7kcI8tOQngNfMHht8q
         przw==
X-Forwarded-Encrypted: i=1; AHgh+Ro04JxqT3zpVZUWq5hETPgiNfpIQm9wAxZUIBEcLxS58OeNS1qKDINCbAm2WNX/s8Og2Cl8b0U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxuQQzCRzQo5oN+ytk5dlwNQJgyDIduvzy7CYeb1gBrV+Q4IC3G
	Vro1DQRxo+yfiBS/g9Kb8IpE4oKV1Da9HAtn0dkSJgYbED/3Ucb2fJH7GDRxYxcblcWmbWe/RIN
	yf1SQAgNLJebxT95QCQLCg8+/IDkUw+svirhAZzzVMY8PzMNLFOPhaaJ2Bz2iN/5+6WzZi6GvG+
	glhUfObdckazpA1UfbnwNEHwQZjPxUj9TIkQ==
X-Gm-Gg: AfdE7cmRjk2qQD8WLZL8QCeLFPCz9ElsHahsBtNbLzhyovMh7iqb39FV6y1yYLZy2RT
	eNbwH0CAwueuCNnozesFX2BZ2Rf+maiXdYtLTdU/4RQRFfWgpyWYQZk+12DJpWncFo2tIxCxxZ8
	D2ZeLqi4/HYZcHp48bzx8wQg61vnLLLvbAiv76Sin4jkat3PI/2lsjBJQ5zmgRAPnDQ/VD
X-Received: by 2002:a05:690c:b14:b0:7bd:577d:7828 with SMTP id 00721157ae682-80134c787a7mr171856297b3.31.1782157534043;
        Mon, 22 Jun 2026 12:45:34 -0700 (PDT)
X-Received: by 2002:a05:690c:b14:b0:7bd:577d:7828 with SMTP id
 00721157ae682-80134c787a7mr171855877b3.31.1782157533540; Mon, 22 Jun 2026
 12:45:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a396a5a.ac26f6c2.9a9c4.0000.GAE@google.com> <88AEEEF8-B9D9-48C8-9069-00E8528BB619@nvidia.com>
In-Reply-To: <88AEEEF8-B9D9-48C8-9069-00E8528BB619@nvidia.com>
From: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
Date: Tue, 23 Jun 2026 01:15:22 +0530
X-Gm-Features: AVVi8Ce2VS_LW6HKwQlFH8hNBHkfiSM0A_5L0419nLeoXjFofdIM8pmW8_DIuuc
Message-ID: <CAEuHeqQ+AcNwQGB0a+Buqfs=_S339UD521ryez1NGmwZ_e0Jcg@mail.gmail.com>
Subject: Re: [syzbot ci] mm: page_ext: add count limit to page_ext_iter_next
 to prevent invalid PFN access
To: Zi Yan <ziy@nvidia.com>
Cc: syzbot ci <syzbot+ci8a7f89fd8f70a458@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, david@kernel.org, hannes@cmpxchg.org,
        jackmanb@google.com, kernel@oss.qualcomm.com, liam@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
        luizcap@redhat.com, mhocko@suse.com, rppt@kernel.org,
        stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org,
        willy@infradead.org, syzbot@lists.linux.dev,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE5MCBTYWx0ZWRfX3GnJfiwCpjcp
 MDqv/tZtMx1QpgQ67Z13HU1qY8thVdVRg/eqDJ3hqi1k07yraGUyCkwzLRRpN8NqjE0nkTvFhbl
 obJfRhidnbVzHSOQUG3qXU+vic59i7E=
X-Authority-Analysis: v=2.4 cv=R8Uz39RX c=1 sm=1 tr=0 ts=6a3990de cx=c_pps
 a=NMvoxGxYzVyQPkMeJjVPKg==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-ibLmwfWAAAA:8
 a=Oh2cFVv5AAAA:8 a=Ikd4Dj_1AAAA:8 a=hSkVLCK3AAAA:8 a=4RBUngkUAAAA:8
 a=Ddikh3kw0lfEB4zVT9gA:9 a=QEXdDO2ut3YA:10 a=kLokIza1BN8a-hAJ3hfR:22
 a=A6MkUVyZPcTV1i89ro0M:22 a=7KeoIwV6GZqOttXkcoxL:22 a=cQPPKAXgyycSBL8etih5:22
 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-ORIG-GUID: FdUmeVQvwxzr9XqIlqq7LDyo9PjtI-_c
X-Proofpoint-GUID: FdUmeVQvwxzr9XqIlqq7LDyo9PjtI-_c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE5MCBTYWx0ZWRfXxU5J6EtWXK4j
 BbLLl6NguXbun8HyixhLunRq7MTvyPLZpotuXRH+MtjVwibv9VuxPlW9UiLPAIprr+fBScOx+Op
 UbaWibnEmMGVACuUTYbB+SEyuHdgHpXqu7VSmUytgge0BjlH2xDkwFBSREpuL80XX3Jv40VWeDJ
 FPwfKLbfeKEtH8IgXXiqWCtqHRopt+7RwZFC37Bxg9QiuuViNNyjEkrlwEFo7QptU2ZLmoVGkXv
 /Y96hvJ4O3chUJy06hfo5Hx0yVKhe+x1cu3D9gskYjRt5EwU4jfjnDV8u9Djy+kOrj+OPhDTM22
 4blAwrjTTWQspMpJN5UXWgR7tQcbYaTCtz0gb8YVuj2apvE4FfPv2U7OqOvvzufvq5QT4g5qEE1
 vHlHVd/SJX+wW1Ehf9IJp27O63whltKPD7ff8ZpqXZXaWPzDmmSrVTuqpQ0LHIqVAXs2t6sWSwW
 AqKtY4yqOR0xVDBuyNw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_04,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606220190

Thankyou Yan.
i missed the post increment change from the last v2.
i am posting a v3 with pre incerement.

- if (iter->index++ >=3D count)
+ if (++iter->index >=3D count)

i think that is aligned with the fix you suggested.

Thank you
Ketan

On Tue, Jun 23, 2026 at 1:06=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 22 Jun 2026, at 13:01, syzbot ci wrote:
>
> > syzbot ci has tested the following series
> >
> > [v2] mm: page_ext: add count limit to page_ext_iter_next to prevent inv=
alid PFN access
> > https://lore.kernel.org/all/20260622-page_ext-v2-1-135d4cfbc42f@oss.qua=
lcomm.com
> > * [PATCH v2] mm: page_ext: add count limit to page_ext_iter_next to pre=
vent invalid PFN access
> >
> > and found the following issue:
> > WARNING in depot_fetch_stack
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/092dd7dc-cb78-46b6-8703-6044fff2631d
> >
> > ***
> >
> > WARNING in depot_fetch_stack
> >
> > tree:      mm-new
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akp=
m/mm.git
> > base:      e1201ff76176ef666b13d1a4ec6b6190ddc6abc8
> > arch:      amd64
> > compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1=
~exp1~20260514074407.73), Debian LLD 22.1.6
> > config:    https://ci.syzbot.org/builds/18f461a2-7098-44bc-9d42-634b56b=
a48d9/config
> >
> > ------------[ cut here ]------------
> > !refcount_read(&stack->count)
> > WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x91/0xa0, CPU#0: kw=
orker/u9:4/1114
> > Modules linked in:
> > CPU: 0 UID: 0 PID: 1114 Comm: kworker/u9:4 Not tainted syzkaller #0 PRE=
EMPT(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-=
1.16.2-1 04/01/2014
> > Workqueue: events_unbound call_usermodehelper_exec_work
> > RIP: 0010:depot_fetch_stack+0x91/0xa0
> > Code: 39 f5 72 d0 48 8d 3d 7e 1b 4d 0b 89 ee 44 89 f2 89 d9 67 48 0f b9=
 3a 31 c0 5b 41 5e 5d e9 87 67 b8 06 cc 90 0f 0b 90 eb ee 90 <0f> 0b 90 eb =
e8 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
> > RSP: 0000:ffffc900079a6ce0 EFLAGS: 00010246
> > RAX: ffff888168b94000 RBX: 0000000000000ce0 RCX: 0000000000000067
> > RDX: 0000000000000000 RSI: ffffffff8e215937 RDI: ffffffff8c28ab20
> > RBP: 0000000000000067 R08: ffff88810495a407 R09: 1ffff1102092b480
> > R10: dffffc0000000000 R11: ffffed102092b481 R12: 00000000019c0068
> > R13: 0000000000000001 R14: 000000000000010f R15: ffff88810afb1dc0
> > FS:  0000000000000000(0000) GS:ffff88818dcb5000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
> > Call Trace:
> >  <TASK>
> >  __set_page_owner+0x140/0x4c0
> >  post_alloc_hook+0x1f9/0x250
> >  get_page_from_freelist+0x21fa/0x2270
> >  __alloc_frozen_pages_noprof+0x18d/0x380
> >  alloc_pages_mpol+0x212/0x380
> >  alloc_pages_noprof+0xac/0x2a0
> >  get_free_pages_noprof+0xf/0x80
> >  __kasan_populate_vmalloc+0x38/0x1c0
> >  alloc_vmap_area+0xd1a/0x1420
> >  __get_vm_area_node+0x1f2/0x300
> >  __vmalloc_node_range_noprof+0x358/0x1730
> >  __vmalloc_node_noprof+0xc2/0x100
> >  dup_task_struct+0x28e/0x830
> >  copy_process+0x79d/0x4380
> >  kernel_clone+0x2d7/0x940
> >  user_mode_thread+0x110/0x180
> >  call_usermodehelper_exec_work+0x5c/0x230
> >  process_scheduled_works+0xa8e/0x14e0
> >  worker_thread+0xa47/0xfb0
> >  kthread+0x389/0x470
> >  ret_from_fork+0x514/0xb70
> >  ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> >
> >
> > ***
> >
> > If these findings have caused you to resend the series or submit a
> > separate fix, please add the following tag to your commit message:
> >   Tested-by: syzbot@syzkaller.appspotmail.com
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > syzbot ci engineers can be reached at syzkaller@googlegroups.com.
> >
> > To test a patch for this bug, please reply with `#syz test`
> > (should be on a separate line).
> >
> > The patch should be attached to the email.
> > Note: arguments like custom git repos and branches are not supported.
>
> #syz test
>
> Best Regards,
> Yan, Zi
