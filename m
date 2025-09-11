Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD6A342C88
	for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 22:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757628714; cv=none; b=UQpf1W/wD919TQ42r0qABHbNcQmBVvqlesn0i19YyH/HFv73nKDdekIygTkbloMO3D3FpPGZn0z8QG3pJA7O2OrHZfJGTR24HVgVHzJnl8mVN96r1Q+LIkhVHFacWg+qe0J14tdlmhoeLELYPAKYYA0+ubWiMkRPC5Nor++wLG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757628714; c=relaxed/simple;
	bh=/dtwzvh9M+PgQdX8hypJZzDko9hlbh7/OsgqgQkn4Go=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IGZatFtUGYffQlcXsZGui7fn+pJm4woPayAkSYdZ29TqjsCtXGpvYNeIQ82Q6PdA8YcPBqEvoGFzOuWC8QZXU0EtK400Aewd5xDIHr968QycDA7IXp6o8s4JYDcWxrJ1mfNunCB5c43F2nmY6598jjCCFcBiG1S54ziVa+PhCmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K8x9Yn2B; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K8x9Yn2B"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45df0cde41bso9167785e9.3
        for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 15:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757628711; x=1758233511; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tls1+yb1vfMgq/iZh3MeTOsXTDuu7dvV5qBYdDLIrks=;
        b=K8x9Yn2BqXK/W45xvjW58nUBQ6jyVfaEZiKyAoRhg+J+m2vPG3zxlTMGIjKkfTvbhj
         BnL6t2kSgvhoQ4K56BVjnNJuiKW3fBAOe+wvWSBXaL9vg04K8tW8nE04gMfX7fNB8pam
         5nPBo79iqrKMCsh0JXUf1xHOYYY+a0s8RW7JZ0CrOS6F2C0fnG0dWikWvFmmgleaHrEg
         YSB3KsbSUaQIuhHRy3ImFaV70qAS5m0/2yQQ3ukYDxEtWwS2mnqp9NXHj7zIg3oug9BZ
         d1kxmQWUZa93SMYbv0NDT5deHcoI7wcI1aYdUEX+8+i6GClVjoUKbsDcXtxx+kgZFkBV
         k+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757628711; x=1758233511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tls1+yb1vfMgq/iZh3MeTOsXTDuu7dvV5qBYdDLIrks=;
        b=e1RQie1zF+L87Sxp7YDAjl5PMJMKA1nLsPw1KArbFXp1/IpdwRO/v2c4YoAgjhVpCx
         jiqyxZ4+Xb6FN2yO9WRnfelQ41EdCgnNoJBEtotnHGxK69LHQcWMamvVFx7JMKUhAOp+
         WzGYp7MXES3+oTZrXv9QSIjA1hGjfhVnnrRV9zdMDOGPHdfqlkFWDPyODGQ1bEp+79+Q
         Xya3UF4rEaINBsxBdOULmSXxBknXMRKEZZSsUs7mCNPLnYM6ri0ZDJNnjE78Jpf3MeJD
         UwlkkDO1V433jcir/0i1E2KtRNy/enrkooUyoSdPToKXfOzFMMywd5G506b20USKnSWl
         6ELg==
X-Forwarded-Encrypted: i=1; AJvYcCV01vH7zuzHB3/e0S6XcuY59sSRYl/7AUcme8N1L2otya1ny6qFN0spFJXhlwghobjqaUiPgUg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzHri8FWfAkr+gIaiGNbDIFhr5W/4xW0I9AdSUASkAoBxYavgMs
	TY0IKV41ikIMw8MI4OhsyokAGvtQTFeOuLImo6WQeJL3W5zupLC3x8peMgqGNE/EHHeThWTtu1K
	H5LPkUHGxuFRFz2flbLYlEvfpuQQER/wJRI1E
X-Gm-Gg: ASbGncuxdYKL0UX5JDPbdeB7W88gZgcOoCJVJeDDZhVWApE6j/dDUsRwwJ8Ue40f7eO
	2Kg2s1FNkI+Sor8k/uPqSKzeQKqpqo4XARwitpa+89nZIk8lFimtYV7aWgxvK0R5JaR6W0RBxxk
	izFKeygCMjVNktotQeLgvuxrcTISW8R8ySNKHApI7XxqoDQsFp2Rkrj711wTbY7JHeuxFTdoa/t
	m15UJOmyRoI0eaNhp4B5Xx+Q/PJLW3GyQQBOHQMBwo0zEw=
X-Google-Smtp-Source: AGHT+IGDOzDXGaTONtyBMca5RofIcMwXveTWTnti2H6JgsJgzCzIDnWonFIjFrIoP8tZJCUM2ZghM4LjzuPaCH1mugo=
X-Received: by 2002:a05:600c:1c0c:b0:45d:d099:873 with SMTP id
 5b1f17b1804b1-45f212c9668mr7139165e9.6.1757628710902; Thu, 11 Sep 2025
 15:11:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68c272e7.050a0220.2ff435.00f3.GAE@google.com> <03440441db6f719e8576cafe0318aa9994621cab.camel@gmail.com>
 <CAADnVQKy-M2vZHaJKD1KJw9kqtL+8Ddn7NYcQTQfG4izE82FkA@mail.gmail.com> <5f0ef19a7961a6f703ea6e035ca2239865227abc.camel@gmail.com>
In-Reply-To: <5f0ef19a7961a6f703ea6e035ca2239865227abc.camel@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 11 Sep 2025 15:11:39 -0700
X-Gm-Features: AS18NWDxjnr9Upya1b6lQlbmMufgukF6m71ysgUMhCA8QiVyogBvm1XqAdM4WKE
Message-ID: <CAADnVQKf2zauKO78qqt73=mZZD7-1ejm+C_zOQh7HUw9ExrjJw@mail.gmail.com>
Subject: Re: [syzbot ci] Re: bpf: replace path-sensitive with path-insensitive
 live stack analysis
To: Eduard Zingerman <eddyz87@gmail.com>
Cc: syzbot ci <syzbot+ci8e503a0d4aea89ba@syzkaller.appspotmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <kernel-team@fb.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Yonghong Song <yonghong.song@linux.dev>, syzbot@lists.linux.dev, 
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 3:06=E2=80=AFPM Eduard Zingerman <eddyz87@gmail.com=
> wrote:
>
> On Thu, 2025-09-11 at 14:58 -0700, Alexei Starovoitov wrote:
> > On Thu, Sep 11, 2025 at 2:09=E2=80=AFPM Eduard Zingerman <eddyz87@gmail=
.com> wrote:
> > >
> > > On Wed, 2025-09-10 at 23:57 -0700, syzbot ci wrote:
> > > > syzbot ci has tested the following series
> > > >
> > > > [v1] bpf: replace path-sensitive with path-insensitive live stack a=
nalysis
> > > > https://lore.kernel.org/all/20250911010437.2779173-1-eddyz87@gmail.=
com
> > > > * [PATCH bpf-next v1 01/10] bpf: bpf_verifier_state->cleaned flag i=
nstead of REG_LIVE_DONE
> > > > * [PATCH bpf-next v1 02/10] bpf: use compute_live_registers() info =
in clean_func_state
> > > > * [PATCH bpf-next v1 03/10] bpf: remove redundant REG_LIVE_READ che=
ck in stacksafe()
> > > > * [PATCH bpf-next v1 04/10] bpf: declare a few utility functions as=
 internal api
> > > > * [PATCH bpf-next v1 05/10] bpf: compute instructions postorder per=
 subprogram
> > > > * [PATCH bpf-next v1 06/10] bpf: callchain sensitive stack liveness=
 tracking using CFG
> > > > * [PATCH bpf-next v1 07/10] bpf: enable callchain sensitive stack l=
iveness tracking
> > > > * [PATCH bpf-next v1 08/10] bpf: signal error if old liveness is mo=
re conservative than new
> > > > * [PATCH bpf-next v1 09/10] bpf: disable and remove registers chain=
 based liveness
> > > > * [PATCH bpf-next v1 10/10] bpf: table based bpf_insn_successors()
> > > >
> > > > and found the following issue:
> > > > KASAN: slab-out-of-bounds Write in compute_postorder
> > > >
> > > > Full report is available here:
> > > > https://ci.syzbot.org/series/c42e236b-f40c-4d72-8ae7-da4e21c37e17
> > > >
> > > > ***
> > > >
> > > > KASAN: slab-out-of-bounds Write in compute_postorder
> > > >
> > > > tree:      bpf-next
> > > > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git=
/bpf/bpf-next.git
> > > > base:      e12873ee856ffa6f104869b8ea10c0f741606f13
> > > > arch:      amd64
> > > > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b79=
76-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > > config:    https://ci.syzbot.org/builds/6d2bc952-3d65-4bcd-9a84-120=
7b810a1b5/config
> > > > C repro:   https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9=
b00b3121701/c_repro
> > > > syz repro: https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9=
b00b3121701/syz_repro
> > > >
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > BUG: KASAN: slab-out-of-bounds in compute_postorder+0x802/0xcb0 ker=
nel/bpf/verifier.c:17840
> > > > Write of size 4 at addr ffff88801f1d4b98 by task syz.0.17/5991
> > >
> > > The error is caused by the following program:
> > >
> > >   (e5) if r15 (null) 0xffffffff goto pc-1 <---- absence of DISCOVERED=
/EXPLORED mark here
> >
> > (null) ?
>
> The `code` byte is 0xe5, BPF_OP(0xe5) =3D=3D 0xe0, which is an invalid
> opcode.  But opcodes are verified after check_cfg()/compute_postorder().

hmm.
resolve_pseudo_ldimm64() -> bpf_opcode_in_insntable()
does it before check_cfg.
