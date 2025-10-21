Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362B82F2600
	for <syzbot@lists.linux.dev>; Tue, 21 Oct 2025 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761057602; cv=none; b=skme05BCtMpWLCCo0JsntEGQ2UybG1in2d2P+XrNeGPtViDpZR/2+40OGDSdN3l52oiixOc35pUKJ86EN5pzabpxuNjUBJsrJmmiCaTfcv42P8WC/eRu9wOgy72M4rJ6a4h1HYFWsaTkLyRhnEaeH5nhU7kBO0FEhXfN8ewNi5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761057602; c=relaxed/simple;
	bh=3LJewJ9QOoge7ioNj9iUPEXUTdEE0NCPgrWF78Bdy7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qauoOuJmnNldMgWqmo9PZepoW1FopM+S/QnBSehMywtFEsDgPeboFLj/dqmBZZKvzjKsZc7GM+TswMrMWxEnGyi87SfVDiQN9SyKY+u6M+c51uRs5Axgc9iiLJsqMJgOXQUkOOvkH+1p0TTogbePSDVqQa26HHAXhHtcgXWE6l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tFtk1JrG; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tFtk1JrG"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-443ac11a7b7so1184067b6e.0
        for <syzbot@lists.linux.dev>; Tue, 21 Oct 2025 07:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761057599; x=1761662399; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQSxtQVPSg6srq2qVFdaSij1lIg4bjSp7TP8x/mkQEc=;
        b=tFtk1JrGMYOkZnzadptzJC2123bzozhRugyn5au9NS0KeW8ZfMOSQVETGbsJk0sAnm
         bebHLOZthsSVcZPILkm2zrxBh+AOB7n9idqXTU8hq7lsKym7XRntSwAKT7NuBSxms/N5
         FElLA8Y6H/b8StYKOFL2UsUR5phxQ9EW+UZ7T69T3nhqOitQSTly5W8ECus2YLGmM3WK
         r9TxkwsnI961XDgpKyPFGz4EdGOoHSl04Li6z5tSxlblu6F4Z2cva1BO+utuTjZSuBEd
         2d5UgIJFBdWaWqdAMsAIJUqIn+E/rYs7DRYzWsguXaqb7V9s0mAZ6rpSaQb9PL8xIVe9
         wPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761057599; x=1761662399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gQSxtQVPSg6srq2qVFdaSij1lIg4bjSp7TP8x/mkQEc=;
        b=LRU0wLPaBD+vJ68rEwEgwQEwgdi/BqULyX/H9wLYJSTopFn5ObFWtyREYh3NKR+0bP
         WrZcCqS+2Dz2sKHKmxmvLH19UFmBlisDjjfKXFi26TDKoz7wWZ2Zcci6GxgoYxY+gVO7
         DuIXo35ivjlEV/gjUfNLycyoTjAB5e3YjA0mCrGbcJ6JH71QcJZZpGiezud/A/h8+R2b
         +MJo9s0Xuw1TWuZEpkhyPOMrFqQkgezEzylEV1XtIQ3iyau8kTfRDZlMg8NBHNLK0JZl
         GwBdw0X3KF0MCqiHo9sK4UUaMpiFfX2JmzGWJrL0pfGAdhH7T5sEJVYoSGM136i5DDH1
         NljA==
X-Forwarded-Encrypted: i=1; AJvYcCW3n/ndrJimUTh5u3FEqwoXaeDTf2SI4v3XO7UbMhG4loHVQiQJM6WZ4Bm8NWLN1dN/EZFyfl4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2f99DtoqEo2ribrdlfXQzuavd+1jvlsraBl1kkr9Du9huOseP
	e2hMtHunT6O1W66ydNBqAFk4M/b4BNVJOYmqJv2v8YxkxNiqAnJRwDjJYitCpVKt5ueDRHjFk/O
	tWxFkw7dYtuIvxMgy6udI6STeOH0tJokkrOqnrM8j
X-Gm-Gg: ASbGncvXWASTIrLTam3Dl1Jhg+KTFjPrFG9iVeaIZU5z40EAITkhUqJl2pwqf82g8Ol
	j8ulU9ANN/voMYdfxJ3Cp6CV7LBSKQj42mmFFyMQRuzGvH7GJNfyKy9NvDOxoBOfa49Xi90fs5j
	X4hwaA6MtbfzimwhgAoBTJNX25IyFr9dx5pu1mqrpkBHYW8KRTyeUbU08gpa2E/FQlWs2FJxqfb
	yBe45gyu2EqsGktUUeCovrEHjZNPH+lXoR2ukGXdxOkb5na6manoyPk1tiQzJTFFXisnqAtTsGt
	StqtUPd3lvybPQQEJCsVgb+rnlBfnTQ/0ooR7AnR1Ve8oOKKTwlN9+/gvvrI09D1wOk=
X-Google-Smtp-Source: AGHT+IHT6+Wds68w67HIlyxDIfdNLI4wOI3CXuOR8lqebgoEe4Y6/7yoHczxWoQdKX1eu3ELGAAdbXcVPVQwp7Mqob8=
X-Received: by 2002:a05:6808:309b:b0:43f:45a5:c3fa with SMTP id
 5614622812f47-443a2babf85mr8110718b6e.0.1761057598866; Tue, 21 Oct 2025
 07:39:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68f7987d.050a0220.346f24.001e.GAE@google.com>
In-Reply-To: <68f7987d.050a0220.346f24.001e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 21 Oct 2025 16:39:47 +0200
X-Gm-Features: AS18NWArZ-ehHM_7xJ0z7mmyHgqk9u4HpRls7wD_RspxD5AIDkgDPZPDtT9PV40
Message-ID: <CANp29Y6UHmCGeD+J6p_trpafoDatn7Rj2q+Q=xG5LCm9efvzvA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: nstree: listns()
To: syzbot ci <syzbot+ci63c7f78281919a7f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Oct 21, 2025 at 4:28=E2=80=AFPM syzbot ci
<syzbot+ci63c7f78281919a7f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] nstree: listns()
> https://lore.kernel.org/all/20251021-work-namespace-nstree-listns-v1-0-ad=
44261a8a5b@kernel.org
> * [PATCH RFC DRAFT 01/50] libfs: allow to specify s_d_flags
> * [PATCH RFC DRAFT 02/50] nsfs: use inode_just_drop()
> * [PATCH RFC DRAFT 03/50] nsfs: raise DCACHE_DONTCACHE explicitly
> * [PATCH RFC DRAFT 04/50] pidfs: raise DCACHE_DONTCACHE explicitly
> * [PATCH RFC DRAFT 05/50] nsfs: raise SB_I_NODEV and SB_I_NOEXEC
> * [PATCH RFC DRAFT 06/50] nstree: simplify return
> * [PATCH RFC DRAFT 07/50] ns: initialize ns_list_node for initial namespa=
ces
> * [PATCH RFC DRAFT 08/50] ns: add __ns_ref_read()
> * [PATCH RFC DRAFT 09/50] ns: add active reference count
> * [PATCH RFC DRAFT 10/50] ns: use anonymous struct to group list member
> * [PATCH RFC DRAFT 11/50] nstree: introduce a unified tree
> * [PATCH RFC DRAFT 12/50] nstree: allow lookup solely based on inode
> * [PATCH RFC DRAFT 13/50] nstree: assign fixed ids to the initial namespa=
ces
> * [PATCH RFC DRAFT 14/50] ns: maintain list of owned namespaces
> * [PATCH RFC DRAFT 15/50] nstree: add listns()
> * [PATCH RFC DRAFT 16/50] arch: hookup listns() system call
> * [PATCH RFC DRAFT 17/50] nsfs: update tools header
> * [PATCH RFC DRAFT 18/50] selftests/filesystems: remove CLONE_NEWPIDNS fr=
om setup_userns() helper
> * [PATCH RFC DRAFT 19/50] selftests/namespaces: first active reference co=
unt tests
> * [PATCH RFC DRAFT 20/50] selftests/namespaces: second active reference c=
ount tests
> * [PATCH RFC DRAFT 21/50] selftests/namespaces: third active reference co=
unt tests
> * [PATCH RFC DRAFT 22/50] selftests/namespaces: fourth active reference c=
ount tests
> * [PATCH RFC DRAFT 23/50] selftests/namespaces: fifth active reference co=
unt tests
> * [PATCH RFC DRAFT 24/50] selftests/namespaces: sixth active reference co=
unt tests
> * [PATCH RFC DRAFT 25/50] selftests/namespaces: seventh active reference =
count tests
> * [PATCH RFC DRAFT 26/50] selftests/namespaces: eigth active reference co=
unt tests
> * [PATCH RFC DRAFT 27/50] selftests/namespaces: ninth active reference co=
unt tests
> * [PATCH RFC DRAFT 28/50] selftests/namespaces: tenth active reference co=
unt tests
> * [PATCH RFC DRAFT 29/50] selftests/namespaces: eleventh active reference=
 count tests
> * [PATCH RFC DRAFT 30/50] selftests/namespaces: twelth active reference c=
ount tests
> * [PATCH RFC DRAFT 31/50] selftests/namespaces: thirteenth active referen=
ce count tests
> * [PATCH RFC DRAFT 32/50] selftests/namespaces: fourteenth active referen=
ce count tests
> * [PATCH RFC DRAFT 33/50] selftests/namespaces: fifteenth active referenc=
e count tests
> * [PATCH RFC DRAFT 34/50] selftests/namespaces: add listns() wrapper
> * [PATCH RFC DRAFT 35/50] selftests/namespaces: first listns() test
> * [PATCH RFC DRAFT 36/50] selftests/namespaces: second listns() test
> * [PATCH RFC DRAFT 37/50] selftests/namespaces: third listns() test
> * [PATCH RFC DRAFT 38/50] selftests/namespaces: fourth listns() test
> * [PATCH RFC DRAFT 39/50] selftests/namespaces: fifth listns() test
> * [PATCH RFC DRAFT 40/50] selftests/namespaces: sixth listns() test
> * [PATCH RFC DRAFT 41/50] selftests/namespaces: seventh listns() test
> * [PATCH RFC DRAFT 42/50] selftests/namespaces: ninth listns() test
> * [PATCH RFC DRAFT 43/50] selftests/namespaces: ninth listns() test
> * [PATCH RFC DRAFT 44/50] selftests/namespaces: first listns() permission=
 test
> * [PATCH RFC DRAFT 45/50] selftests/namespaces: second listns() permissio=
n test
> * [PATCH RFC DRAFT 46/50] selftests/namespaces: third listns() permission=
 test
> * [PATCH RFC DRAFT 47/50] selftests/namespaces: fourth listns() permissio=
n test
> * [PATCH RFC DRAFT 48/50] selftests/namespaces: fifth listns() permission=
 test
> * [PATCH RFC DRAFT 49/50] selftests/namespaces: sixth listns() permission=
 test
> * [PATCH RFC DRAFT 50/50] selftests/namespaces: seventh listns() permissi=
on test
>
> and found the following issue:
> WARNING in __ns_tree_add_raw
>
> Full report is available here:
> https://ci.syzbot.org/series/03ca38c3-876c-4231-aa06-ddb0bc8a30ad
>
> ***
>
> WARNING in __ns_tree_add_raw
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      5fb750e8a9ae123b2034771b864b8a21dbef65cd
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/156cf21b-68f9-423c-807a-3dd094e6a=
ed8/config
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5816 at kernel/nstree.c:189 __ns_tree_add_raw+0xa92/=
0xb30
> Modules linked in:
> CPU: 1 UID: 0 PID: 5816 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__ns_tree_add_raw+0xa92/0xb30
> Code: 32 00 90 0f 0b 90 42 80 3c 23 00 0f 85 1e fc ff ff e9 21 fc ff ff e=
8 ed 78 32 00 90 0f 0b 90 e9 66 fc ff ff e8 df 78 32 00 90 <0f> 0b 90 e9 53=
 ff ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c ef
> RSP: 0018:ffffc90003f27c30 EFLAGS: 00010293
> RAX: ffffffff818e0051 RBX: 1ffffffff16db871 RCX: ffff88810ffe0000
> RDX: 0000000000000000 RSI: ffff8881bbf5e9a8 RDI: ffff88816d0e6e00
> RBP: ffff88816d0e6e00 R08: ffff88816d0e6e3f R09: 0000000000000000
> R10: ffff88816d0e6e30 R11: ffffffff81b988c0 R12: dffffc0000000000
> R13: ffff88816d0e6e40 R14: ffffffff8b6dc388 R15: ffff8881bbf5e9a8
> FS:  000055558630f500(0000) GS:ffff8882a9d04000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f5c3f03529c CR3: 000000010b5bc000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  copy_cgroup_ns+0x373/0x5f0
>  create_new_namespaces+0x358/0x720
>  unshare_nsproxy_namespaces+0x11c/0x170
>  ksys_unshare+0x4c8/0x8c0
>  __x64_sys_unshare+0x38/0x50
>  do_syscall_64+0xfa/0xfa0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5c3ef907c7
> Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0=
f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc62c39c88 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> RAX: ffffffffffffffda RBX: 00007ffc62c39c90 RCX: 00007f5c3ef907c7
> RDX: 0000000000000000 RSI: 00007f5c3f03529c RDI: 0000000002000000
> RBP: 00007ffc62c39d20 R08: 0000000000000000 R09: 00007f5c3fd1d6c0
> R10: 0000000000044000 R11: 0000000000000246 R12: 00007ffc62c39d20
> R13: 00007ffc62c39d28 R14: 0000000000000009 R15: 0000000000000000
>  </TASK>
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
> [amir73il@gmail.com arnd@arndb.de bpf@vger.kernel.org brauner@kernel.org =
cgroups@vger.kernel.org cyphar@cyphar.com daan.j.demeyer@gmail.com edumazet=
@google.com hannes@cmpxchg.org jack@suse.cz jannh@google.com jlayton@kernel=
.org josef@toxicpanda.com kuba@kernel.org linux-fsdevel@vger.kernel.org lin=
ux-kernel@vger.kernel.org me@yhndnzj.com mzxreary@0pointer.de netdev@vger.k=
ernel.org tglx@linutronix.de tj@kernel.org viro@zeniv.linux.org.uk zbyszek@=
in.waw.pl]
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
-upstream-moderation/68f7987d.050a0220.346f24.001e.GAE%40google.com.
