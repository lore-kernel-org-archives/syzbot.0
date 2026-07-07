Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4554921ABBD
	for <syzbot@lists.linux.dev>; Tue,  7 Jul 2026 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783459826; cv=pass; b=AEQBd4mxfHkdUIb0cwFjz9ttKGlVVCOzXadBDtcfMKviT3Kyd5n4oBa7g2f8Hy1kMIeYcZ15Q5OCbwxQRwyrx53aMuRmskcx/C2IQxeyGuOO0mdbPHuj7kosEMJ+D8bvcuhX8BVV12GhxlII+p9ZIX72HED3OkMJYwrCtt9KXYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783459826; c=relaxed/simple;
	bh=e5YhRhCK15CuEUQ/bu12LJR/XHhZSAS0LFWgRIDrwac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AenchDWHTxD53KnzyQY88otP74a7HnJ/ItQbu4OqQ6yddLT/CYzEc+M4X5MpVIBwcJExQ8661KC/2R/8qZdAAsqKbV2MVNNJig+w36t55KOzkUEtaGFNBLZhcpWkLvS3zglIsZe63sd9DNH0LpJxP3cvkSxzJK59v17FU8OMuZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I+I3j5bG; arc=pass smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I+I3j5bG"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-44d2204d195so8888fac.1
        for <syzbot@lists.linux.dev>; Tue, 07 Jul 2026 14:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783459823; cv=none;
        d=google.com; s=arc-20260327;
        b=meUQspjRbHm6PiLhg81qki15ZCWhKV8yKweQtbbyUZq4vmZWxiyodDNZVCl+eULsTr
         UELUBe4HDSHp/77JBjqw02icK8BixfPuk544TCrmH/h4ibDio4Y3twHBkMprSHCJY2MQ
         R7UNVbs51M87t3do7r2fWMD6lj5cPj5Njk0SI4ddQdfjgDCF3zow1EFWy21YCoH86n68
         MBmbVbt5Qe6SfaAsBbdRkRVylVu8XCBgKgtvyfY90WsatH8S+4wCpDfX1KGENmTU8sFY
         F4pqYgS77wEwHCt9BHGq6cH7VXdIj81zOU8uywN2juqTdnm5TaUEetBWi6BHasPJcWik
         OFQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iEXqSCMI6Qg1dAg+FUmGWd8V5GqUuM/nxotNR4wkAs0=;
        fh=eceKtA3sRNFfEO+kaHkvvVuVon/P362PQXO8kS5MaFU=;
        b=r6mI1S1y6JVtcDyy6HvB8mdvIzqHljxzgn1vu4OZFXP5h7qOOdHgkBwaw27wct/rFr
         M9d8qT5AGPy3RhZsBdCd3AH2opbDRq1XSUr4q8RMD5dTOmYr18vyfcE3hd1IIhUup8rb
         4bXBtrv2wWWh6zfPZ7zJaSU8MiIQCpiZmH1xQWbJca77UuPVp8z3PAEN9bi/f5RAsnXl
         GfbMrSUihv3xuybDjegCZxy6ErezIcrFHeHY3opeJ8rCmwuowNybdAC3mGpZ8iebBr27
         ebkzd+UnAaCnmGkJsXcCGnnboscbuClnKCCMcbdC4e03iSBcPy5mEQ8XUdJwA4aoPVV9
         YsWQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783459823; x=1784064623; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iEXqSCMI6Qg1dAg+FUmGWd8V5GqUuM/nxotNR4wkAs0=;
        b=I+I3j5bGj6WJtufpz2aXZi6+j3DqdAi3wsIYnni0e0SZ5vO/mEZnsVPnv7watgtCLN
         MmU4NOAA8JZe9y+ejworOF6el5oJcN3mzlghryNrXQxUjROx3zD2eBS1pXROI9p47/Qb
         yKdHyKg6WJR6Nd5Kr53niSbSTgRNrVRqJ6q4P1vzbMzL0fVQI8DugXfy/1B0bLuO0Rbj
         gWycibGY/phYMZjdEgAu57WAE6IiA7zqiF8zV8wL/U+lxwKM1pvx9UenKPwc9PPL9SZM
         6Xl/P2gzwrrBVGe9Qg88AcTQmbf4dnzWouxnNcs7HxJpSsNY8YZiIR1B65zfqmlW+4MV
         /gMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783459823; x=1784064623;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iEXqSCMI6Qg1dAg+FUmGWd8V5GqUuM/nxotNR4wkAs0=;
        b=iDV7CHFxyd36kERsdJzHMb9/k39Yn1rFcHPJImx12crsq4jTmTt7NcofgWELH8L9UM
         /bTm7VcFEdPhW3/A+p7SxYYyfBvwkuAp0edqOGBe42ynBHKb7f8bafAsGVEgisouuzB6
         fjzYlAI2OkQb6e/NZHuITt69/qyxrrhHMBIEJx3lQSHKcPclTUCNxDSgv6vk4yZRMgoE
         1ebJAIrx4udl6JP+NCxWS1CB4LH5g07Gu9+cX+4kGJETzqsbMeELc/1VARQFmg1qksrq
         5hmafpNDKzeXMbFQtpamOpJ62qPGb2ZiSIffbXSNeaTpU2lVvQ+w6VFASD+v+MelzVPo
         0oOQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq1faKAmoTFPtBMbMiWlHY5ZmqujdGlBWX0vUErtEAJw/wxjqu00Xmnz1UKorgwwma1aJy3IkM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSgTdTDXLrLc3yoA17/BXl/tbQn2VcJOJxJuCwtc8ouv2f7Oo3
	ClAI/1VvkTPBEj/tuINIGTmnKKKXgoBTLt6lQS86gyHW2HGEW4vf2BnVQF7EbhDbPYQklQTyN4F
	SimR6H/lQ0dZ1o3qVEAxtEJtKgN5GqvhFQPqi4SL1
X-Gm-Gg: AfdE7cnk7KuY5phS6LE0zdHADHKx0BOmd28TCfcjr3ilzdehIBEfeMCnqGm/Emczhci
	na9lyIwc2OG8nHJ66rZhqkzQtGLF1/pgmEMsYb8cQ9+LyVjDqf4NauTtlSEDDfovOpQrBBOBfge
	RnONEfhqIUbyzwjXu54r9brJC944opvxY0tBDqpS2vL+zLk20A3951ETpur0WvSEzKMHZcv2jFT
	WQGuJXuCgw/UO+YR6/AZ+R+pyno50vtQvGGAujt/sJwKYOV/hlMyrevPTlkIcdBheL37XlTYqVj
	rmYiEwYsbXpGnRPRmHNbY4OFsaeKD8xlDahJmkkD39VGS5UNm0yOnzuxulj3jS7CvuIdjok7AzJ
	XtKzj97OVhPljWfhg67wCTGSRHMN/8ND9LL4qlz8Nfw==
X-Received: by 2002:a05:6871:3a20:b0:447:4fc:1da1 with SMTP id
 586e51a60fabf-45105d71af3mr4451629fac.12.1783459822293; Tue, 07 Jul 2026
 14:30:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a4d45b3.c76b52dc.34afef.000e.GAE@google.com>
In-Reply-To: <6a4d45b3.c76b52dc.34afef.000e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 7 Jul 2026 23:30:10 +0200
X-Gm-Features: AVVi8CeslcO3jC3yRgfyKNAKTL7N194DECghfHoQvSIyiiqSgjCmz1WYuFfRTZM
Message-ID: <CANp29Y7igj98NU9TvakvdQpQmbo5w6RyBUG73wK6NBOjXvAEfQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: rework anon_vma and remove anon_vma_chain
To: syzbot ci <syzbot+cia0624a3957eaf595@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jul 7, 2026 at 8:30=E2=80=AFPM syzbot ci
<syzbot+cia0624a3957eaf595@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm: rework anon_vma and remove anon_vma_chain
> https://lore.kernel.org/all/20260707063308.29176-1-tao.wangtao@honor.com
> * [RFC PATCH v2 01/13] mm: add CONFIG_ANON_VMA_FRACTAL
> * [RFC PATCH v2 02/13] mm: implement helpers for ANON_VMA_FRACTAL
> * [RFC PATCH v2 03/13] mm: implement __anon_node_prepare for ANON_VMA_FRA=
CTAL
> * [RFC PATCH v2 04/13] mm: implement anon_node_clone for ANON_VMA_FRACTAL
> * [RFC PATCH v2 05/13] mm: implement anon_node_fork_with_prev for ANON_VM=
A_FRACTAL
> * [RFC PATCH v2 06/13] mm: implement unlink_anon_nodes for ANON_VMA_FRACT=
AL
> * [RFC PATCH v2 07/13] mm: handle rmap_base changes for ANON_VMA_FRACTAL
> * [RFC PATCH v2 08/13] mm: implement anonymous folio rmap for ANON_VMA_FR=
ACTAL
> * [RFC PATCH v2 09/13] mm: prepare anon_node replacement for ANON_VMA_FRA=
CTAL
> * [RFC PATCH v2 10/13] mm: replace anon_vma with anon_node for ANON_VMA_F=
RACTAL
> * [RFC PATCH v2 11/13] mm: optimize rmap for ANON_VMA_FRACTAL with PVL
> * [RFC PATCH v2 12/13] mm: shared semaphores for ANON_VMA_FRACTAL
> * [RFC PATCH v2 13/13] mm: Enable CONFIG_ANON_VMA_FRACTAL by default
>
> and found the following issue:
> WARNING: bad unlock balance in exc_page_fault
>
> Full report is available here:
> https://ci.syzbot.org/series/39466cf1-707b-420e-8f1e-11735bea6c66
>
> ***
>
> WARNING: bad unlock balance in exc_page_fault
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      8ff49efd1cf18086320f3b43d1bd483c0b9e7e58
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/c3a229e4-b949-4889-b309-dbdd1fadd=
95f/config
> syz repro: https://ci.syzbot.org/findings/29b52ad4-b463-41da-877c-4138356=
e3960/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: bad unlock balance detected!
> syzkaller #0 Not tainted
> -------------------------------------
> sshd/5593 is trying to release lock (vm_lock) at:
> [<ffffffff8bb5032a>] handle_page_fault arch/x86/mm/fault.c:1483 [inline]
> [<ffffffff8bb5032a>] exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
> but there are no more locks to release!
>
> other info that might help us debug this:
> no locks held by sshd/5593.
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5593 Comm: sshd Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
>  __lock_release kernel/locking/lockdep.c:5527 [inline]
>  lock_release+0x1f1/0x3c0 kernel/locking/lockdep.c:5889
>  vma_refcount_put include/linux/mmap_lock.h:216 [inline]
>  vma_end_read include/linux/mmap_lock.h:264 [inline]
>  do_user_addr_fault+0xab0/0x1340 arch/x86/mm/fault.c:1345
>  handle_page_fault arch/x86/mm/fault.c:1483 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
> RIP: 0033:0x5583206de68b
> Code: 04 25 28 00 00 00 48 89 44 24 08 31 c0 48 89 e2 e8 8c 5b ff ff 85 c=
0 78 13 31 c0 4d 85 e4 74 0c 48 8b 3c 24 48 89 de 4c 89 e1 <f3> a4 48 8b 54=
 24 08 64 48 2b 14 25 28 00 00 00 74 05 e8 5e 17 fc
> RSP: 002b:00007fff02a37e60 EFLAGS: 00010206
> RAX: 0000000000000000 RBX: 000055835a20d6fe RCX: 0000000000008000
> RDX: 0000000000000000 RSI: 000055835a20d6fe RDI: 00007fac5106c010
> RBP: 000055832073df00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000008000
> R13: 000000000000005e R14: 00000000000000b3 R15: 00007fff02a37f88
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org apopple@nvidia.com baohua@kernel.org baolin.wa=
ng@linux.alibaba.com baoquan.he@linux.dev bp@alien8.de byungchul@sk.com cat=
alin.marinas@arm.com chengming.zhou@linux.dev damon@lists.linux.dev dave.ha=
nsen@linux.intel.com david@kernel.org dev.jain@arm.com dvander@google.com g=
ourry@gourry.net harry@kernel.org hpa@zytor.com jack@suse.cz jannh@google.c=
om jgg@ziepe.ca jhubbard@nvidia.com joshua.hahnjy@gmail.com jparsana@google=
.com kas@kernel.org kees@kernel.org lance.yang@linux.dev liam@infradead.org=
 linux-arm-kernel@lists.infradead.org linux-fsdevel@vger.kernel.org linux-k=
ernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org luizcap@redhat.com =
matthew.brost@intel.com mhocko@suse.com mingo@redhat.com muchun.song@linux.=
dev nao.horiguchi@gmail.com npache@redhat.com peterx@redhat.com pfalcato@su=
se.de rakie.kim@sk.com riel@surriel.com rppt@kernel.org ryan.roberts@arm.co=
m ryncsn@gmail.com shakeel.butt@linux.dev sj@kernel.org surenb@google.com t=
ao.wangtao@honor.com]
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
-upstream-moderation/6a4d45b3.c76b52dc.34afef.000e.GAE%40google.com.
