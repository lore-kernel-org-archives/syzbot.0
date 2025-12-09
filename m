Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112D123EA82
	for <syzbot@lists.linux.dev>; Tue,  9 Dec 2025 14:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765289772; cv=none; b=SVxPK3ZWznUvuKsL9byFrw6SCEl43eiqtaEWl6frHkxWgxmS0xhCAKxsDxlDsk0J4+RB1VREp1rjwCojcsQk4DAo5OUxvSp4lbYwcBsyd3AeRXtgllo+lpUbGioyTdKk1+J28M+B6TvWizZbhE4oHl2LUWOP7mNa10AnS4JEtJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765289772; c=relaxed/simple;
	bh=ObJQRj35e3yqnSavRIIuBMYvs+Iakm3iCJonVEahKtw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C6sIeshs+SGjM0heW72eZwXkT1mJ44VSwdSFj5fVxx+43kYOn94wlJea4aVNjEq+pp8LwouGkTLjdNOyfc5/LbfFYpZX5CAfjCs3TvrTsffZj63TOfQjlzvOfOgrfkZJZxsNKvfAZu2c21DShbPnUCUkdapS9NxqNsDx01D/rT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MUPnTh/C; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MUPnTh/C"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-65745a436f7so3080878eaf.3
        for <syzbot@lists.linux.dev>; Tue, 09 Dec 2025 06:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765289770; x=1765894570; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTCpCM5eQQT+LNew2iNT1MCWNL6y4aTIGwqOYDOo1Aw=;
        b=MUPnTh/CkVluqsMW++xfYZrI1qZ0v5mtJzPhLLOhwHaVB5NmX7O45pKVsLZG3GFEgB
         59fQMTTAe1BIOVKZrUS3+B8Jn3JfXlPVTU2+F8SvK9qEclmWU7RRMm4Yy96HUs+faqf9
         zyniL/Pq2yLLKmVUANLEA6jrOm3tYJcSbB7fwOiqFV1m32Mjph4vAJ6mK1KySc2vkEdH
         n22i4ZYqlUJEG8Y7U2sUQqvX2wJZfsXyO1UG7sQFtuKF9ea2Oa8MONWsGhM+OUL3aESh
         Rg+KhrN3/mmBuPOHkubXKnGShvKJB2EL85pz1bP+cCciV7CEZmNM4AS7HQNMiiYBQSGm
         qtqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765289770; x=1765894570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KTCpCM5eQQT+LNew2iNT1MCWNL6y4aTIGwqOYDOo1Aw=;
        b=KfG/+ckfgwqw08oLzPzi/zdv9MeOizKB9Iv0JQaNJafmaFN+VkfwSVm1HDxWn+ZeuK
         rmwtTS6m2P4qVxwJgN9m1RkL5EdoXBA91sa1ovTCgUdl5QU9WbPdVzA3n2NJm9LQs6XV
         GwP+2OmD+z1wXPCHJ6npfKfavNntIZQMTAIkXRyboH7/qwK/71ruXJQp5DdgLNdMdNub
         TrJMSbjoDJAYMe+KPUQ9NPKmMk6kVTZbmSGWgaNiZsfgVIb4gLb9lOZ11LmK552Zm8AA
         v0HyqFAcbcp1+iCGNbmVHU7JwPcFIZSNQ+RLFnjGvx8HfmCBXSb851BG2wpUfXk3a7IZ
         yPng==
X-Forwarded-Encrypted: i=1; AJvYcCVB/nnDgpO9NGRojJvsClLywbZmvcq+5lQL+2c9oVehYtDbznpNU/aBJFgklm0OtQVU2p+jaL4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyffGEKP6kcaCq9YoQKbgeseupFqeBkOgQsXvkQ/ITS7QXbOkdv
	6H9uN+/Qx8maiUwiGvbpoSUPAjm9AnSTtmTD3YB36O88WCH/cT1ODnJJp2iLpN+mTnaIr3JOVS5
	dya3D8VDFkubKt+Ls4cRST+WY7qYKp2o=
X-Gm-Gg: ASbGncsoskVm0n5nFlUvCRrgzR47eN0VL0ZOn5HBO1EBo7B1XlnsDuzPErYBL7ppYwu
	OPOzZ1keQ8XaE6baL+18x3pAJyu+eB7x79mRTEHv7R1qlbiK2GBJkwbjlug8f1wLatCScgOIarO
	5DmfKB/BicNobs3teBFyVDmb4Z57F2LfVkt6wqcKt0MD1OoCV8VGZGQA+J1Eh2ot12BVgFXTeFP
	fTzTLI7Go5bTKQkqzO8vX+ZHc7amZjE/gX9Dy18Sar+jdvw0BwFhY8oIlgEoJ/A3jS/SQ==
X-Google-Smtp-Source: AGHT+IGPMqlgWHIaMp7E5vVJZ+Kw8xiwpJ/jT2d2L4xHn6G9TNOzpaO9ZrHeA1eoKhkU0mdlrVEdIBgQ/VLLCaSUiyk=
X-Received: by 2002:a05:6820:6ae4:b0:659:9a49:8f72 with SMTP id
 006d021491bc7-6599a9736aamr4955015eaf.55.1765289770034; Tue, 09 Dec 2025
 06:16:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251209031628.28429-1-kerneljasonxing@gmail.com>
 <6937d508.a70a0220.38f243.00c9.GAE@google.com> <CAL+tcoDfvz9fR4XK6FPH8Ng+OfF67UX86=fZL2xxZGnuA2Rs5g@mail.gmail.com>
In-Reply-To: <CAL+tcoDfvz9fR4XK6FPH8Ng+OfF67UX86=fZL2xxZGnuA2Rs5g@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 9 Dec 2025 22:15:33 +0800
X-Gm-Features: AQt7F2obHLWItrZASuCEOfprudVlFROW94sp8_ik3Y9kP4YAauQjAnXys-nnZlE
Message-ID: <CAL+tcoDQ6MyuGRE8mJi_cafqyO0wfgOw5WTqnCvKGbQBhKOGpA@mail.gmail.com>
Subject: Re: [syzbot ci] Re: xsk: move cq_cached_prod_lock to avoid touching a
 cacheline in sending path
To: syzbot ci <syzbot+ci28a5ab4f329a6a88@syzkaller.appspotmail.com>
Cc: ast@kernel.org, bjorn@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	hawk@kernel.org, john.fastabend@gmail.com, jonathan.lemon@gmail.com, 
	kernelxing@tencent.com, kuba@kernel.org, maciej.fijalkowski@intel.com, 
	magnus.karlsson@intel.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	sdf@fomichev.me, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 8:12=E2=80=AFPM Jason Xing <kerneljasonxing@gmail.co=
m> wrote:
>
> On Tue, Dec 9, 2025 at 3:52=E2=80=AFPM syzbot ci
> <syzbot+ci28a5ab4f329a6a88@syzkaller.appspotmail.com> wrote:
> >
> > syzbot ci has tested the following series
> >
> > [v4] xsk: move cq_cached_prod_lock to avoid touching a cacheline in sen=
ding path
> > https://lore.kernel.org/all/20251209031628.28429-1-kerneljasonxing@gmai=
l.com
> > * [PATCH RFC net-next v4] xsk: move cq_cached_prod_lock to avoid touchi=
ng a cacheline in sending path
> >
> > and found the following issue:
> > BUG: unable to handle kernel NULL pointer dereference in xp_create_and_=
assign_umem
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/d7e166a7-a880-4ea1-9707-8889afd4ebe8
> >
> > ***
> >
> > BUG: unable to handle kernel NULL pointer dereference in xp_create_and_=
assign_umem
> >
> > tree:      net-next
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/net=
dev/net-next.git
> > base:      0177f0f07886e54e12c6f18fa58f63e63ddd3c58
> > arch:      amd64
> > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1=
~exp1~20250708183702.136), Debian LLD 20.1.8
> > config:    https://ci.syzbot.org/builds/d327cc4b-7471-413b-b244-519c6d1=
6d43b/config
> > C repro:   https://ci.syzbot.org/findings/c8f7aeaf-0e2e-43dd-ae9c-ea2dd=
8db8d34/c_repro
> > syz repro: https://ci.syzbot.org/findings/c8f7aeaf-0e2e-43dd-ae9c-ea2dd=
8db8d34/syz_repro
>
> Interesting. Only rx logic is initialized while tx not. That causes

Actually, it should not happen or we can say the usage is against what
we expect because at the first time cq and fq need to be both
initialized and then the shared umem function can be used[1]. But the
repro tries to directly use the shared umem at the first time.

[1]:
net/xdp/xsk.c +1401
Corresponding patches can be seen here:
commit 7361f9c3d71 ("xsk: Move fill and completion rings to buffer pool")
commit fe2308328cd2f ("xsk: add umem completion queue support and mmap")

The above two patches make sure that in xdp_umem_validate_queues()
(which was renamed to xsk_validate_queues()) doesn't allow _only one_
of them to be initialized at the first time. To put it in a simpler
way, cq and fq are required to be initialized. So now what I have in
my mind is can we have the same test when using XDP_SHARED_UMEM?

I think this repro found an existing bug before this patch, IIUC.

Thanks,
Jason
