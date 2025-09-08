Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1812E2822
	for <syzbot@lists.linux.dev>; Mon,  8 Sep 2025 06:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757314406; cv=none; b=tkb12Q3rr/qbdEbvpDQKwdoBfMxPeEsfg5GrdzwQq3FrZmIi5V7S1DjhV8I96s+XIprl+S/P6vqygbZL85OG6cEj1YKufnFPd8dypZMks+JkcmYPrUBAUET0tO/Sb4JDAACNBMb0+g+x0qpQ+ACePjlsMpgdm7SNzKRsBIrhEek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757314406; c=relaxed/simple;
	bh=SkUyT305MPP0FJyad63aBCwRPCtHvKl6iVQ1v4QRhr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FJAqJ/Ptw3ysZ7LAsDpAhJtxRAO2k9peK5d+vaSiKtxUplQJIeTRtBpcvd2wTiR5bESfeIFa16l5Cras4xOAyd7rteONEjH79/M5fWYQCc7K3mxemgYV9aMHtNHFl8axXollWjV5iRvd0YFWsiiEGgeOdClduBkWBd9goeYxpKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A0u+nsNu; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A0u+nsNu"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-721c6ffab58so32358896d6.3
        for <syzbot@lists.linux.dev>; Sun, 07 Sep 2025 23:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757314401; x=1757919201; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25GY4neXGNw9B+oXJOrLcQkfyLux2MvDxSJPpzZRUp4=;
        b=A0u+nsNu07YkB6gojEjYaphx2iAr+tJkeT08u1L9GwvlbbytSXUPchMVETUIzTDAS1
         GP25J+mOcil7+LMiYOqV7k4YNhLKkyUtQsZVZZwakiHa4+XXcdlJkGneJ7cf/lUJ39d8
         mtrDHclFHgUlwXupKuxP0sQvbIa7R+vG40/aPTgjfcT3g8Ydx7GXEenpgOvR+rkiLTrs
         q7HiER4SbBYEaEKLXajEdCFixcTfjttSk3wcULifNVT6vrDyY+yFZVprvVrmejhCIOJI
         eGzDpmcT+09Dc33B3Zx21Gc/dykHZgzbQzE1JYzSd2EGlhj8CMei8TP2uLxVYLaVl0Pg
         OvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757314401; x=1757919201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=25GY4neXGNw9B+oXJOrLcQkfyLux2MvDxSJPpzZRUp4=;
        b=n116NLQfIvq4LH8lxS43anTF64ojlDSLMJQsYGgpBxBXY6VNBiSleqg01SZxrcWYeG
         SvV1cP8VYEj56WZVge+7Ivh/Z9wcNiag1q/vBdR5BcjQzguRY2h7jmXHQ/eK7Vepx8i6
         VqXonpbiJ1hfRTOPnV9dfQ66a7TbtBGWERgiiKOasSGu3QoW3UJAlIRbXtXHkOAT0BlE
         GAc9JsE5tbWu20rfNglMx1yMVo8SoxWpx3dZ/GyNcMzGy+v72l+oHZ1PEsyuGLtgH8Bm
         cYUniK7PL4on1qcs3NwKppahPtMC6imfAWkrefpZs/QI0shN6jqCzua0CRQgfmtg8NAi
         9uHw==
X-Forwarded-Encrypted: i=1; AJvYcCUzb028tk36CDrse4j89Andl26w4xORuVL/qChu7/PPX/yDBT+99+zwXY8HLwxs/fHyPUXw9Rw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw73Kltxb3NEN0jKuofAYLMcpi8Gs33pAp1hnD6aTKNkfH5R5Qt
	nrK8mbJqh5Lln2Xda+ptvCWroEFVrZugJC2HRWhqPlMXCKYMinFvm8v5cfejpcz5i74I4RgZmE/
	+zLx5gM37wx7Wpnr3GUgNw3NKfehIIRCEUdZPvFqDxEq3QqBhA1+JYVxXxas=
X-Gm-Gg: ASbGncsFgl0JdzSPGFzR+Bh02aMjt21/6T6Ipp0sQGywJ5RRJj9lDScc/qZ4w0ZEwCQ
	qqsnOURWYaNdQsbU+J8TZMmIVLoPcW387akJ2fIJwZEQHMMwBkywVRHNhwauRCuar4J4FhDx/QG
	pISvd/fIhphSeuzBfrZgOEQ4fO4hJcIOXfaYynzKUKMdeBdmiooSYCMd7MC0hk9EpfLZUjHec5D
	ECzj/XDkzR1C+qXwXpZ4kIymAsN9GlsV/LZx07KzjiUlcWipPF9UDFu7HAmPIG0
X-Google-Smtp-Source: AGHT+IFgV1yW4JgZl9GHOQLjthy5HmIHCGzXZUxBKN8ZxaZpmaQwJ9jDSLDV50QSZDeoSsFdz7ifRkq4j1vW850EqDw=
X-Received: by 2002:a05:6214:1c4a:b0:733:74d3:5fda with SMTP id
 6a1803df08f44-73932313967mr83673346d6.28.1757314400790; Sun, 07 Sep 2025
 23:53:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68baffc4.a00a0220.eb3d.0016.GAE@google.com>
In-Reply-To: <68baffc4.a00a0220.eb3d.0016.GAE@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 8 Sep 2025 08:52:44 +0200
X-Gm-Features: AS18NWCa4xwFgcJQq-HjX-tfAl7z7-9CjGt4tH4LAU9u6Ro-Ors4lwBXbL8RjUc
Message-ID: <CAG_fn=X5aWUJYTNs-n4j7WcvY8eeZByLWpmB6Z3T7kAEwTo5VQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/rmap: make num_children and
 num_active_vmas update in internally
To: syzbot ci <syzbot+cia1bdfaeb2fff6c1e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Sep 5, 2025 at 5:20=E2=80=AFPM syzbot ci
<syzbot+cia1bdfaeb2fff6c1e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/rmap: make num_children and num_active_vmas update in internally
> https://lore.kernel.org/all/20250905132019.18915-1-yajun.deng@linux.dev
> * [PATCH] mm/rmap: make num_children and num_active_vmas update in intern=
ally
>
> and found the following issue:
> WARNING in unlink_anon_vmas
>
> Full report is available here:
> https://ci.syzbot.org/series/8f2c8574-826d-4951-a11c-201f9e6fa666
>
> ***
>
> WARNING in unlink_anon_vmas
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/6702bc54-be0f-4db2-85d2-1488a2ec7=
040/config
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5260 at mm/rmap.c:444 unlink_anon_vmas+0x63c/0x670
> Modules linked in:
> CPU: 1 UID: 0 PID: 5260 Comm: mount Not tainted syzkaller #0 PREEMPT(full=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:unlink_anon_vmas+0x63c/0x670
> Code: 08 00 48 3b 6c 24 08 74 29 e8 30 7e af ff 49 89 ee e9 d0 fd ff ff e=
8 23 7e af ff 90 0f 0b 90 e9 4e fe ff ff e8 15 7e af ff 90 <0f> 0b 90 e9 82=
 fe ff ff e8 07 7e af ff eb 05 e8 00 7e af ff 48 83
> RSP: 0018:ffffc90001bef878 EFLAGS: 00010293
> RAX: ffffffff82102ffb RBX: ffff888109476118 RCX: ffff8880215d9cc0
> RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
> RBP: ffff88810f31e030 R08: ffff88810947611f R09: 1ffff1102128ec23
> R10: dffffc0000000000 R11: ffffed102128ec24 R12: ffffffffffffffff
> R13: 1ffff110212a6ce2 R14: ffff888109536710 R15: ffff888109476110
> FS:  0000000000000000(0000) GS:ffff8881a3c18000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8adf7b0440 CR3: 000000000df36000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  free_pgtables+0x72b/0x9c0
>  exit_mmap+0x444/0xb50
>  __mmput+0x118/0x420
>  exit_mm+0x1da/0x2c0
>  do_exit+0x648/0x2300
>  do_group_exit+0x21c/0x2d0
>  __x64_sys_exit_group+0x3f/0x40
>  x64_sys_call+0x21f7/0x2200
>  do_syscall_64+0xfa/0x3b0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8adf86ea90
> Code: Unable to access opcode bytes at 0x7f8adf86ea66.
> RSP: 002b:00007fffb8de8148 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007f8adf95f860 RCX: 00007f8adf86ea90
> RDX: 00000000000000e7 RSI: 000000000000003c RDI: 0000000000000000
> RBP: 00007f8adf95f860 R08: 00007fffb8de7fc0 R09: 00007fffb8de80a0
> R10: 00007fffb8de8000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007f8adf963658 R15: 0000000000000001
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
> [akpm@linux-foundation.org david@redhat.com harry.yoo@oracle.com liam.how=
lett@oracle.com linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.sto=
akes@oracle.com riel@surriel.com vbabka@suse.cz yajun.deng@linux.dev]
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
-upstream-moderation/68baffc4.a00a0220.eb3d.0016.GAE%40google.com.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
