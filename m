Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FFC2E1F1F
	for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757627898; cv=none; b=rF2Q43uwUZ03iP+e+u7DlcA7mY7+Yk7OKLFqt1QJw0x55exz7JF5tcXuRMc72vXD86PCkzBjzg4R7CJY/bfmtc/R2En3h/NAv6arD8uZ8cTKzBAPENubsghZz6qfjbdN6JaQn2aoTgL5BMySyjXZNqJ8zKL2wHmTLFYrUakmxp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757627898; c=relaxed/simple;
	bh=68pKP6lHrNCkCT8/RtaCJnVNqQJ8/CLctda9VgSZtfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+/9m9OtAGmJZCSzOGvmvMqnML/FvHVlNp8MZ0+PU58ZciRN71ihoi/PkWBfatcOY6dLisoMnAFbY2ksLaB3uuD4iiHX//nQ/aTa2uKe9YElJq6CAbE3109kzO6M5entUTj1ThXD80a7RBlU6beN6+nzCxumR+Nr/1D9k4TxQzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L3sJ1yAF; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3sJ1yAF"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45dcfecdc0fso12139615e9.1
        for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 14:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757627895; x=1758232695; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GP6RF6kCjZ3VDkcp5w1NSNG2p/MkocRDipud3ftD670=;
        b=L3sJ1yAFHGNAARykgSkxz0sYvXiNJrUNJEmpr+pwVduicUIzx1Drg1PekcaB8uT6Gs
         6fauSv07kQriWS76IJPGPehOyvAen6Ys5gb0IYFsY9u6hBxylKUmEwMKdHfinjDEDK9l
         E9AxxliMCB+ENN6CY2J83vTkjsVi30/ZtRcZtrDPsiU//3m/0rMPXulDBK99WbrukDAL
         HyuEuxLtM9pcP9FSXDeLSgMHz11i2N6hShtm3ohuw2UY4RPmXT3mReuLbK6lZ3K414PJ
         LyJhopXdmsdvRC4NGsCaMoyDefn4OhyREPPL95L+ehK1iHU5STzIvkutNjIb42kcKG3I
         3Blw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757627895; x=1758232695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GP6RF6kCjZ3VDkcp5w1NSNG2p/MkocRDipud3ftD670=;
        b=rTLa/QuRy4OVPmHrKcDpJfjkGV+wWjIR5Dwgz10LW+7sYokSI9/yEgHbyjKRuHXgxz
         /sIZka5vzyPbIhHABqIoWhVhHdc/m3K3ILO0y0N7yCdL90mQhIU0AK9Qv1yjPO+kqSr0
         ebqf9hCWMiB9AAnKsuxgXNDeiXWe+3ARSdm5bHbVPuKoldxopABTPmjh185Eev58OO5X
         tS89YVENXm9ljJlJNiZkG8dp2vwRffxjc5i+R7mjwuKd6Ug3zdqmOLbHD4xCqi9o8Ijr
         A1GS2Ylpy3kyOJO+a9+l2eH990afTxUuG5f9ndTXNLDD60JBx0+oHHiqkaGmZMB8JMII
         MD5g==
X-Forwarded-Encrypted: i=1; AJvYcCVkL49Rl/U/YG7ky413Rwd3dJYgBlb0a4i1qeGacdBg0GeRteyaB9Q5SNaGG6gklXATAcVRe98=@lists.linux.dev
X-Gm-Message-State: AOJu0YyE9kEhV+l72eHBcdlYZ6PD+vdP/NJuskXk5ybF6auDrZ/LoILG
	VZkr9JHJE/Kdyj0VhKRuiIbOvejgQtL7MF7R61jvVj+DqZ7Nmm0BCIAeX+l2gxR7aCUq9AUreaf
	6jP/nzlHlJyi99O7ilJby3D2E1LucPr8=
X-Gm-Gg: ASbGncunOT/jcgAoVkhNnvGfXVvje28aQgJIU/B38g7SnDLNt9RoH8pPd4kZTTtyh46
	mP9kxOMB9Q9/DK14GIuIgs7AlJMiEMzD7yY8t5Mz2w8EtFWkwlMTKOqI4CKceBLNagrZWCYcrYz
	Jj1QWhcrgkIjBiMdKMl3+cQ2EBQekNWUh9H67mwodlqC5giJ7WojguOrBvTuCnLiGwhNh1kHN3g
	XVtOlh7qzmJUziPFIl/rQZxSA8um7OZyv+V
X-Google-Smtp-Source: AGHT+IEVWhz35ntPFTjYvctt0a2DeSRsRSpvM+yFAL+cwwpq2/9cGWb1HCO2KujAOrIcy2YD8YWE58MCgePG2chULos=
X-Received: by 2002:a05:600c:138a:b0:45d:d97c:235e with SMTP id
 5b1f17b1804b1-45f211c8caamr9675615e9.12.1757627894088; Thu, 11 Sep 2025
 14:58:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68c272e7.050a0220.2ff435.00f3.GAE@google.com> <03440441db6f719e8576cafe0318aa9994621cab.camel@gmail.com>
In-Reply-To: <03440441db6f719e8576cafe0318aa9994621cab.camel@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 11 Sep 2025 14:58:01 -0700
X-Gm-Features: AS18NWDNK5jIn3ZXKIPIjDFRrjiHS2Qn0_gdDvA7KEClycS3Kv4Ateq65CqC5gE
Message-ID: <CAADnVQKy-M2vZHaJKD1KJw9kqtL+8Ddn7NYcQTQfG4izE82FkA@mail.gmail.com>
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

On Thu, Sep 11, 2025 at 2:09=E2=80=AFPM Eduard Zingerman <eddyz87@gmail.com=
> wrote:
>
> On Wed, 2025-09-10 at 23:57 -0700, syzbot ci wrote:
> > syzbot ci has tested the following series
> >
> > [v1] bpf: replace path-sensitive with path-insensitive live stack analy=
sis
> > https://lore.kernel.org/all/20250911010437.2779173-1-eddyz87@gmail.com
> > * [PATCH bpf-next v1 01/10] bpf: bpf_verifier_state->cleaned flag inste=
ad of REG_LIVE_DONE
> > * [PATCH bpf-next v1 02/10] bpf: use compute_live_registers() info in c=
lean_func_state
> > * [PATCH bpf-next v1 03/10] bpf: remove redundant REG_LIVE_READ check i=
n stacksafe()
> > * [PATCH bpf-next v1 04/10] bpf: declare a few utility functions as int=
ernal api
> > * [PATCH bpf-next v1 05/10] bpf: compute instructions postorder per sub=
program
> > * [PATCH bpf-next v1 06/10] bpf: callchain sensitive stack liveness tra=
cking using CFG
> > * [PATCH bpf-next v1 07/10] bpf: enable callchain sensitive stack liven=
ess tracking
> > * [PATCH bpf-next v1 08/10] bpf: signal error if old liveness is more c=
onservative than new
> > * [PATCH bpf-next v1 09/10] bpf: disable and remove registers chain bas=
ed liveness
> > * [PATCH bpf-next v1 10/10] bpf: table based bpf_insn_successors()
> >
> > and found the following issue:
> > KASAN: slab-out-of-bounds Write in compute_postorder
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/c42e236b-f40c-4d72-8ae7-da4e21c37e17
> >
> > ***
> >
> > KASAN: slab-out-of-bounds Write in compute_postorder
> >
> > tree:      bpf-next
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf=
/bpf-next.git
> > base:      e12873ee856ffa6f104869b8ea10c0f741606f13
> > arch:      amd64
> > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1=
~exp1~20250708183702.136), Debian LLD 20.1.8
> > config:    https://ci.syzbot.org/builds/6d2bc952-3d65-4bcd-9a84-1207b81=
0a1b5/config
> > C repro:   https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b00b=
3121701/c_repro
> > syz repro: https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b00b=
3121701/syz_repro
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > BUG: KASAN: slab-out-of-bounds in compute_postorder+0x802/0xcb0 kernel/=
bpf/verifier.c:17840
> > Write of size 4 at addr ffff88801f1d4b98 by task syz.0.17/5991
>
> The error is caused by the following program:
>
>   (e5) if r15 (null) 0xffffffff goto pc-1 <---- absence of DISCOVERED/EXP=
LORED mark here

(null) ?
Is it jset again? but insn_successors() handles it already.
Or pc-1 infinite loop caused it?
but we have pc-1 selftest...

>   (71) r1 =3D *(u8 *)(r1 +70)                     leads to instruction be=
ing put on stack second time
>   (85) call pc+2
>   (85) call bpf_get_numa_node_id#42
>   (95) exit
>   (95) exit
>
> And this is the fix:
>
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -17840,6 +17840,7 @@ static int compute_postorder(struct bpf_verifier_=
env *env)
>                 stack_sz =3D 1;
>                 do {
>                         top =3D stack[stack_sz - 1];
> +                       state[top] |=3D DISCOVERED;
>                         if (state[top] & EXPLORED) {
>                                 postorder[cur_postorder++] =3D top;
>                                 stack_sz--;
> [...]
