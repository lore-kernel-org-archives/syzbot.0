Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BA12E5B1B
	for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 22:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757628420; cv=none; b=gcQPIgCjs7iuoD1sj1fuSv525oJ3LpwR9bGwi/yUIghTOYX9jNS8vrQ7d+/sIOJCog+AzTPdiIya/s12LxPHv70Tp+YBVOTg6rtvZVTyyR62ywUes12HSzCHbjTterGCmyfcBRoLVpqOlQiUG0AnS7nRlA1tbnw4ssPU9xMfpKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757628420; c=relaxed/simple;
	bh=ZZJ2grqLL8Fqy5I4BP+Z6fTe+JP94/SaKVMrj4tLpLU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Se6jI9cZMpy5MhWfUQjfjRBBuKszR4Q3ZmleFwnFkiTjhL2IMvH3VYao5FPsvFq3xJ/03E+eWuVPWFsLTQUbuItWeuvhrtF7YqoVkRjvUmgxE2+SQyzJJp+RruYwo/ddqR2UAmZV1+Fx9KlB2mKSZDsC1VTDAdPd/4ulv5V5Rj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EHQWuq05; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHQWuq05"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-32dd1238843so1215421a91.3
        for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 15:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757628419; x=1758233219; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bonWt9ZGWLjOJbFQA74GLeDy739Dy64l0gYa4dZMRGE=;
        b=EHQWuq054jpt1Ud+wUXHcU0yWTTyqa4kzA6//OuNKZXL5zZKStXE4q9aH5aNybNz+/
         znmERz6PiHInhcTy/PKdKTpfwn/UrjMVOzFQnLeQJSM9250FcfIteqrEXFtwhQqOESze
         SV6//NBgQYP4rcyLA7gqhtWZ4KbVbdFukn5JYW5t1dQwq4zFZur8UMNggvwaqsGxvuY1
         439PM5y2RMrYMtIUmoswGUDknwQz9z/J522Q8mVxLjBJq0lCY9FhNaJT78g27vnF3Rlv
         uN00amimygsVNcZjH2X3yqMSwwumOsBxfpzXkjoZUC6hX1qlsYiDSzYd+dDrlRlk8xdd
         kSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757628419; x=1758233219;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bonWt9ZGWLjOJbFQA74GLeDy739Dy64l0gYa4dZMRGE=;
        b=VJtOPXbBOW7ltsITCUcRf9+TOlyJdjTvo+mamWBuKphoS5qwXzG89u4/VvsKm/xXh7
         RtdO4UOKYKkhHdHfLBQDQmRToi4LGKGOoF99YvD5nl6uRQKWPuPnIugCIpmJjsqsk0AV
         4MJGVT8smEuqYl2H+dT9muzOSpWiMV6fmyIzBkXlp9evYRRq2jvGOu/YWI8c7nIjItFs
         wvB/4sDEoOrVWww8heYT6cFR2QJZmoGu+f19MLQ0E7luVTetI/ew5Lzo84BzxdhvewZ7
         p54HS6bnISnyHUBVVckRVePqxTzd7x5I+/9ScQCPboHv308iG8T7Z11FN0tcj+FbxW37
         hEbA==
X-Forwarded-Encrypted: i=1; AJvYcCU4vqIORi6P9AoFv7RHDYT2R8+32YyulJGHq9FBa0ZeZDuURGP0rIIKxZnTcRqZrOrtz6X89Bw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZ1VLIEjo1Ezw3fzbb66FpwAmP1/Hwt5JGvMmBI9PiXgrDrnFo
	Cmf7s+qGlunmGEd5Zy6bMy/4TL3onRO3Hk2ovvI6t2HEUpiEFlR6OkfG
X-Gm-Gg: ASbGncv9RZeDN5SJ1Vw5zvzlH8lzhZvliEJCwkM0zvW0O2LylgcyOgraaLtwE0FGqhR
	T3f9hrSOv19ifEhRUfPxDYnFgUeoG1HDol2dAQ7hs5YefDUtuW6QxaSf2ct1H/l/VGcUY5rIgrN
	0OSmhzt/sJdVDszx6d7fOEHzePhrcdePC/15UaVeQ5OO6alfLu+VksMnBqBo6C/Lydwr/VzgL4J
	OiQPvwlVIs+PbDyKtsGc8zu6+LutZIcaxOvlJ/zmFpZYWXi78pGb8trTns+Ha24HCaOskLqbZ8d
	1XcnPwsDgQrh3fj7lGs1cDO/7ey8s/dKYyZ2ER8wGTAs9uIUF64za5NXk7GEIVeRpbcsBgPxT8d
	kKxbhWAFdpWoGVx6eMKduO1VMDnULIg==
X-Google-Smtp-Source: AGHT+IFdY15i8F6EfNnCGUseItDeh0p6MR37I8aTzP+cpxUS/SuvO1rf0YfM/xLlIwhuq2caGPq/8g==
X-Received: by 2002:a17:90b:4a8e:b0:32b:94a2:b0d6 with SMTP id 98e67ed59e1d1-32de4e7d0d1mr715598a91.3.1757628418576;
        Thu, 11 Sep 2025 15:06:58 -0700 (PDT)
Received: from [192.168.0.226] ([38.34.87.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd63268dcsm3804654a91.26.2025.09.11.15.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 15:06:58 -0700 (PDT)
Message-ID: <5f0ef19a7961a6f703ea6e035ca2239865227abc.camel@gmail.com>
Subject: Re: [syzbot ci] Re: bpf: replace path-sensitive with
 path-insensitive live stack analysis
From: Eduard Zingerman <eddyz87@gmail.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: syzbot ci <syzbot+ci8e503a0d4aea89ba@syzkaller.appspotmail.com>,  Andrii
 Nakryiko <andrii@kernel.org>, Alexei Starovoitov <ast@kernel.org>, bpf
 <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team
 <kernel-team@fb.com>, Martin KaFai Lau	 <martin.lau@linux.dev>, Yonghong
 Song <yonghong.song@linux.dev>, 	syzbot@lists.linux.dev, syzkaller-bugs
 <syzkaller-bugs@googlegroups.com>
Date: Thu, 11 Sep 2025 15:06:55 -0700
In-Reply-To: <CAADnVQKy-M2vZHaJKD1KJw9kqtL+8Ddn7NYcQTQfG4izE82FkA@mail.gmail.com>
References: <68c272e7.050a0220.2ff435.00f3.GAE@google.com>
	 <03440441db6f719e8576cafe0318aa9994621cab.camel@gmail.com>
	 <CAADnVQKy-M2vZHaJKD1KJw9kqtL+8Ddn7NYcQTQfG4izE82FkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-09-11 at 14:58 -0700, Alexei Starovoitov wrote:
> On Thu, Sep 11, 2025 at 2:09=E2=80=AFPM Eduard Zingerman <eddyz87@gmail.c=
om> wrote:
> >=20
> > On Wed, 2025-09-10 at 23:57 -0700, syzbot ci wrote:
> > > syzbot ci has tested the following series
> > >=20
> > > [v1] bpf: replace path-sensitive with path-insensitive live stack ana=
lysis
> > > https://lore.kernel.org/all/20250911010437.2779173-1-eddyz87@gmail.co=
m
> > > * [PATCH bpf-next v1 01/10] bpf: bpf_verifier_state->cleaned flag ins=
tead of REG_LIVE_DONE
> > > * [PATCH bpf-next v1 02/10] bpf: use compute_live_registers() info in=
 clean_func_state
> > > * [PATCH bpf-next v1 03/10] bpf: remove redundant REG_LIVE_READ check=
 in stacksafe()
> > > * [PATCH bpf-next v1 04/10] bpf: declare a few utility functions as i=
nternal api
> > > * [PATCH bpf-next v1 05/10] bpf: compute instructions postorder per s=
ubprogram
> > > * [PATCH bpf-next v1 06/10] bpf: callchain sensitive stack liveness t=
racking using CFG
> > > * [PATCH bpf-next v1 07/10] bpf: enable callchain sensitive stack liv=
eness tracking
> > > * [PATCH bpf-next v1 08/10] bpf: signal error if old liveness is more=
 conservative than new
> > > * [PATCH bpf-next v1 09/10] bpf: disable and remove registers chain b=
ased liveness
> > > * [PATCH bpf-next v1 10/10] bpf: table based bpf_insn_successors()
> > >=20
> > > and found the following issue:
> > > KASAN: slab-out-of-bounds Write in compute_postorder
> > >=20
> > > Full report is available here:
> > > https://ci.syzbot.org/series/c42e236b-f40c-4d72-8ae7-da4e21c37e17
> > >=20
> > > ***
> > >=20
> > > KASAN: slab-out-of-bounds Write in compute_postorder
> > >=20
> > > tree:      bpf-next
> > > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/b=
pf/bpf-next.git
> > > base:      e12873ee856ffa6f104869b8ea10c0f741606f13
> > > arch:      amd64
> > > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976=
-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > config:    https://ci.syzbot.org/builds/6d2bc952-3d65-4bcd-9a84-1207b=
810a1b5/config
> > > C repro:   https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b0=
0b3121701/c_repro
> > > syz repro: https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b0=
0b3121701/syz_repro
> > >=20
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > BUG: KASAN: slab-out-of-bounds in compute_postorder+0x802/0xcb0 kerne=
l/bpf/verifier.c:17840
> > > Write of size 4 at addr ffff88801f1d4b98 by task syz.0.17/5991
> >=20
> > The error is caused by the following program:
> >=20
> >   (e5) if r15 (null) 0xffffffff goto pc-1 <---- absence of DISCOVERED/E=
XPLORED mark here
>=20
> (null) ?

The `code` byte is 0xe5, BPF_OP(0xe5) =3D=3D 0xe0, which is an invalid
opcode.  But opcodes are verified after check_cfg()/compute_postorder().

> Is it jset again? but insn_successors() handles it already.
> Or pc-1 infinite loop caused it?
> but we have pc-1 selftest...

It's not infinite, but it causes instruction to be put twice on the
stack array, and this array is allocated expecting max prog->len
instructions. KASAN would only catch this error if program really
needs to consume full stack depth during postorder construction,
as far as I understand.

[...]
