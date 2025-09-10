Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F5C30FF09
	for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 08:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757493443; cv=none; b=TVd4WWJT4W6eFMZ+8SYNVnkt64kMqBMB466nYn4wsJzIh7LPmtAFDAVYKkLPZ67NV09GLQlmt24lDM2CymdHB11PHnN+hn8iF2f5Qp1MbnIHe7uxAPUVrFKIXuV8WfBhrCyGr8r8NDD3gvfTg+ezd7mXL0Q1sv5EGFNL2PuJZMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757493443; c=relaxed/simple;
	bh=ISJqBA0dYYlxomHHFfV2M7e4q1fB8brAdFxz0loFl0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWfK3PdPveLqYFqry/q4Cdw8rCkA17bxkOY8uCgHawbUrkcDfgJVm36gYc5EgG3V4hn7FnXbesfF/Rr6qDPDhgKs4ksVt254bCo3us6t0OK72JCtXbxdMfGB9orZtMn/KfRHhqtaXc9ny+dnVbGbFrCSSn3xCQMAaIarlDio7rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tvlivK8H; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tvlivK8H"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-746d72028e0so3461043a34.2
        for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 01:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757493441; x=1758098241; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mgi9Laz+9vCkEAV1dE5ABTFkSFUEorFiUYE9kyz4bHE=;
        b=tvlivK8Ha7j/NkcUizISqlKDJZPhnYXhaglC1oDWkJ86q9nFthJxOXc+2sdQJxnNpj
         exzTWgLJc8TNPZHGxByw49RBQeoQ23FoNTGOCBKxYHkuu57r8DtDzAPTcKd12GugZ0JT
         ajAx2VYKD98ljzThJa/XrIkj+Q3qRovGzxyaLWWg6OPTHYXdS3EPngoeuY4ObMI6W06W
         G/6JyE8SR3vtw4gawbZ6/bTq5U6+W3k2ZHvnx1O2ea62nS7SRkfR2chLC6JRtKEXpmdQ
         I+hUDZaaY/lJ2bzVH2m4ebWxSGa7c+gtl3Ke2kvO+AVUs7ln+ow06wrm+b3U5EdA5rMo
         APVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757493441; x=1758098241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mgi9Laz+9vCkEAV1dE5ABTFkSFUEorFiUYE9kyz4bHE=;
        b=vQv4qdHRbqb8VCao/mBDFrkgXxinrLootNu1CZFsihvrrnlorPV2CAWN/D1bPENgrr
         JS3768x+76Aov7MnmsxVfEoEyNI/CWbz/COKWfYMCFRLY/YjgWb5PYAsIFv8oBtzXvkI
         /yNuLAiGnimmUWLlDbGLJtK1PXm/hSR5vDRPgSp46W25rFW/uEpYMPX+hsYjYUqSXuld
         hxH597MLy6mlws/U2KGV62isGjVBM3kLP9fJGqTY/trEj3+1XT4QhQfZkOFD5y/JpbKZ
         msvT5O0uIQGINWcpYnZdAsQ8Cz3ygFw7+f3pyiod5ebj1GE2+2BCQvxn+p2KKad2naqz
         OUGA==
X-Forwarded-Encrypted: i=1; AJvYcCXxR0GqIq4Ytx2zi/r5dvi2W+LlgyX0YX5KBuyVy40cdN58WpQGaW0r80M9OyLlnwUZAze0RdM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx98AZpw0t20xt/kvDy8Az6cTUcvkFstzL26nwcuFkUxfM3nSY7
	8ZT6Cu8u2zmlGZAmIz7R0sEzw27SWz9uVTyEMJuEkclt7BPV9ZL/ufE1+VhLDt2AHXcLbXMptmE
	F1SEEizI7pkixJLZLwNSRKviHGSXT+OAXzr+cJ6JZ
X-Gm-Gg: ASbGncvm4Q/ErionTRtxD4uAyQeGtXntS5shRQXnQItUd256C6Eykf5orBiu6V0toba
	KCS+B1Gki+jFPOFbjOwxJQHaUdm9gDDE2unKRw68/o5XqVs6I4iE9tH68+nvBx5TXkpVmRqduWR
	fZ5Nshmh67S71FayjrLiPhx10twz9RXM2jKkr/02nbinz5wELV2mJk/RIe+9IgcrP0wFHQzPNYC
	hoP1aK0LbIl/ov7h/Y4bBAAF6FeF2DAE00n3NAhWkhy2uRXe8eNpQ==
X-Google-Smtp-Source: AGHT+IGHPmsp4rhj9kFRzFp4Hhy469wN/hUk1hfH6UxCX/Ry1bPJQZ9CxLeFJnY2yp7TJGAjnpBE/wUTDQ1YFCyzlMI=
X-Received: by 2002:a05:6830:7007:b0:745:a3b9:182a with SMTP id
 46e09a7af769-74c7529ebc1mr8788633a34.19.1757493440639; Wed, 10 Sep 2025
 01:37:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68c0e09d.050a0220.2ff435.0008.GAE@google.com>
In-Reply-To: <68c0e09d.050a0220.2ff435.0008.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 10 Sep 2025 10:37:09 +0200
X-Gm-Features: Ac12FXwz1dSj-5axpgktcb9l6s-M1R0rjW2v1tkdI8gmjv4p4APVvk7x3TG63PE
Message-ID: <CANp29Y62+DAtpbAdq_u5HstV3S7wpx+66CoLVt1ny3PO+0Co=A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/slub: Removing unnecessary variable
 accesses in the get_freelist()
To: syzbot ci <syzbot+ci5ba01a2db6fa3664@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 10, 2025 at 4:21=E2=80=AFAM syzbot ci
<syzbot+ci5ba01a2db6fa3664@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/slub: Removing unnecessary variable accesses in the get_freelist(=
)
> https://lore.kernel.org/all/20250910005957.54108-1-rgbi3307@gmail.com
> * [PATCH] mm/slub: Removing unnecessary variable accesses in the get_free=
list()
>
> and found the following issue:
> kernel BUG in __smpboot_create_thread
>
> Full report is available here:
> https://ci.syzbot.org/series/832d6128-4556-4bd1-ab18-0676b8e7dbc1
>
> ***
>
> kernel BUG in __smpboot_create_thread
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      f777d1112ee597d7f7dd3ca232220873a34ad0c8
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/7bff7792-4edd-4680-a5e7-3cc9d97ac=
5ed/config
>
> smpboot: CPU0: Intel QEMU Virtual CPU version 2.5+ (family: 0xf, model: 0=
x6b, stepping: 0x1)
> Performance Events: unsupported Netburst CPU model 107 no PMU driver, sof=
tware events only.
> signal: max sigframe size: 1440
> ------------[ cut here ]------------
> kernel BUG at mm/slub.c:3832!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:___slab_alloc+0x13ab/0x1420
> Code: ff ff 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 3e 4f 0f ff 90 0f 0b 90 0f 0=
b 48 89 f7 48 c7 c6 3a a1 a0 8d e8 29 4f 0f ff 90 0f 0b 90 <0f> 0b 90 0f 0b=
 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 11 4f 0f ff 90 0f
> RSP: 0000:ffffc90000047750 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff888100028000 RCX: 0000000000800001
> RDX: 0000000000800001 RSI: ffffffff8dba8965 RDI: ffffffff8be33980
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff82189e55
> R10: dffffc0000000000 R11: fffffbfff1f47407 R12: ffff88804b03e480
> R13: ffff88801a441640 R14: ffff88804b03e460 R15: ffffffff82189e55
> FS:  0000000000000000(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __kmalloc_cache_node_noprof+0x29a/0x3d0
>  __smpboot_create_thread+0x11a/0x3b0
>  smpboot_register_percpu_thread+0xc6/0x420
>  spawn_ksoftirqd+0x2f/0xc0
>  do_one_initcall+0x236/0x820
>  do_pre_smp_initcalls+0x4c/0x80
>  kernel_init_freeable+0x30c/0x4b0
>  kernel_init+0x1d/0x1d0
>  ret_from_fork+0x3fc/0x770
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:___slab_alloc+0x13ab/0x1420
> Code: ff ff 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 3e 4f 0f ff 90 0f 0b 90 0f 0=
b 48 89 f7 48 c7 c6 3a a1 a0 8d e8 29 4f 0f ff 90 0f 0b 90 <0f> 0b 90 0f 0b=
 4c 89 e7 48 c7 c6 3a a1 a0 8d e8 11 4f 0f ff 90 0f
> RSP: 0000:ffffc90000047750 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff888100028000 RCX: 0000000000800001
> RDX: 0000000000800001 RSI: ffffffff8dba8965 RDI: ffffffff8be33980
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff82189e55
> R10: dffffc0000000000 R11: fffffbfff1f47407 R12: ffff88804b03e480
> R13: ffff88801a441640 R14: ffff88804b03e460 R15: ffffffff82189e55
> FS:  0000000000000000(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0
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
> [42.hyeyoo@gmail.com akpm@linux-foundation.org cl@linux.com iamjoonsoo.ki=
m@lge.com linux-kernel@vger.kernel.org linux-mm@kvack.org penberg@kernel.or=
g rgbi3307@gmail.com rgbi3307@naver.com rientjes@google.com roman.gushchin@=
linux.dev vbabka@suse.cz]
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
-upstream-moderation/68c0e09d.050a0220.2ff435.0008.GAE%40google.com.
