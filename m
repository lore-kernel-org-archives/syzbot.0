Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FB5407117
	for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774970739; cv=pass; b=FFmiB+F+E/chmOkCidxAIQJvZesrsgOdBP8flXkWkTldNnHQVfNUOMa/rGlADnBYtoNnYnpZ2GR8tPgnPQZb47ZYCjQ2QnsN33Epne97LlLjoKl6s8JtjFkfjlypslQYhbtNcAkl8gHmLc5Hoid2G5cpE1jcUkakFw1GSCt+YRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774970739; c=relaxed/simple;
	bh=d+ktr8h4Sc532AuZ4mndPaoaynnk1o/EUFZCMIymqXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gck8zfjLmz6d1jg1LQAqoTQEbP5KnNsEz2X81ahnLdMjiYI0KyMH8BPjNpnSTYaodKLcxNz3buSE0Qj3eU5r3uJfYrIjNrJePblJJmJ7kXddcRwPBuO/z9VyXR5RJAdiiN8XE70rCluCscCivD6IUvKNSBSaXB5MPchyofEPuRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ASNpbRPb; arc=pass smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ASNpbRPb"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-41c420d1460so2341567fac.3
        for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 08:25:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774970734; cv=none;
        d=google.com; s=arc-20240605;
        b=WiU936pOTHcfMbZSIS6PRTzr6zdmyVfRZZOj9kPeSVabc4y3huaULAVmgXaQoIgeQA
         5VOt8tKuOnPEz00QMP7kpFVaolmvnf0As8suV+CclUzcfiwGBa2q8PmJXCgE7Q1wGtt2
         UmX6z+Dz+k84W5Lx8U8+vWf3TuauJp7++QuZoWwh8fPtQxXxffOsdw7vdV8/L8ecThS+
         BnGZ91Kx0FOlpnSR912wk903R1RBbvU1JAB6xBFY+KMaVXXM9smD7seJhAIDtIoyf9Sv
         45dN4ObxksFnNlQNXOEeGLumiftm5X7qsLxSL1q4MlX7u2165wyNSzzNkYp+vtPvSucJ
         tA6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gp6Qfx3v54u93fGwidmBXnk4ybvR7hH3CQJm6k11EQc=;
        fh=R/eXLQXowv070Ddsx3aORWkxafoBoDpcYYiyEFek8g8=;
        b=jkdFU/DUeSJW+wRgC/jQXRfB/t2yZPi7C0qXsAtToMeC0tcHK32edZ3TZTeVqeqXwV
         RkGABF+JAvEJWOH1VDFp5SQQ28UJEcNGlERVBrBJOC4/m9P5XRJ4MKA8VMr1j6xV15dI
         Uc+wLbjAdrFb+AhJkq0CvN99ZMdZ6XSzLSZwDev6DVLTr32t+XD5hm252uCzyB3EOnEu
         XudEb+dv4gWoQu/6cIY0Rk19nqjEo1fij1b5y3/jElBT2sn3FgxOf34FjZIDlndoEgLn
         Nc+JXhbz6NVsf56mWoQWKy6CdUYEGvExnRWsio6ReAiEWQyq6zz/+zW5Qs1XxM6PQN9y
         odjA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774970734; x=1775575534; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gp6Qfx3v54u93fGwidmBXnk4ybvR7hH3CQJm6k11EQc=;
        b=ASNpbRPb3M2j09hYKkwg8Nu/GD740wm/fp9MCUvhZvGqsm6+FkHg972vPDE65kg7SF
         hQllGZRgvU8mWofiVW6SJnIHPQweQBqLhzgmkCjaiWBlsU+Y/yFZhXEPAGPvhEE0a2rP
         wlwTd6GoYCjAUC58MfF5VCibxsugVZbUDB45bUTgxoNWa3b+3/gUevtfNtBXtRX8HUCB
         Dg4XJeniURAFFb2QVn2YIGe9Sb9XG1Wmsx4TouSMS3zmOOGlI0ipcqcqhmRlNqOiCpHy
         o7GLa5GyldMWrgLftr+CwBCepv6c7qZNdlu3u4xG3MZd6U7S+1qM0dTnUAQLEBVqDupm
         zxKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774970734; x=1775575534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gp6Qfx3v54u93fGwidmBXnk4ybvR7hH3CQJm6k11EQc=;
        b=QmR3ChQg3slyDy4nCXGGLEjQt1eI+q4b0aa9k4K6ECEA6KpxSnxOvh45736HaJOZw/
         Xw+9Qi2ykVJLK+DaAvFVDh0nUyRNKDSCdueA9K13ZM2O42CBQtDWQ29gmDsaSLmvGu3e
         fijrmhje0hj7lkw53ZYJ4JtZ7q46JqvjRIDxLezxUzgr5B2J4LnNnmyKyz3LpkWjI3d2
         OUyyknAcoV6bC53U0xcEou9wS4PyJZuHWJCyP/o5aN8IZ5XizEa1xS6CBYvF5eQoQLgP
         W3MuiCz1gVBGXf6+HSVLm1g270cEVjocIK1HV6zI+AWnS8iTyqebddm2cdxzbNiazvRK
         fR5w==
X-Forwarded-Encrypted: i=1; AJvYcCVa+TK3Iur4EPFfFLYFSgHD98w4NPe19E/CzWWln+8nbuT4wpGdOWN8MIs529KvgftHpEbyJ4M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxadMlc/jE9d6Ah2hTW7jEqISLfFTK/FRb6YaXSV/D9oVyEgzY
	gdFIbr5RVCbuLlUMteZbP2CbWUpxz98YWvCGhawP5101Niodx0Z+HIh1/dY4vTe0URFnoSPjQh1
	p7/GMV76fY+U1olybp+eTWcR9p4BT5yeP3r/YZNRF
X-Gm-Gg: ATEYQzy8HXLr8bj4+jAmeUDQoudwPWGwNW7zrdvMkL4Vmb7X7Am9ADbfoC9kDLLXHVQ
	SstlxINeTnqzvQjGUnS7J/+l9JhOjw1tgQsloF5fTm5wXXkbI/Ztri53wkVdPJUJTj7++YGBf7h
	K+Pta57DDGlXPI7gsgHCrJoDn1uXJW5NO+Su0BuHWB8rYHKScBiXZJhIwgWHIQCoZgzbSy80dOQ
	Y4Qby3ZgSzL0W2vgntVfnAg8q567w9ZfD0IdQsmax36GLqSeoXImMEn4pwyYzh48WC6lQLc9yXm
	2169IMzOQ4AOvSGpIUCIUZ44lNBCOAifNmPzuIfUHoRlPNEM7yM8S7dpPDOtzyznDFH7uQ==
X-Received: by 2002:a05:6870:a19d:b0:417:3cc0:8dc9 with SMTP id
 586e51a60fabf-422cfdef345mr32958fac.24.1774970733737; Tue, 31 Mar 2026
 08:25:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69cbdf4c.050a0220.183828.002c.GAE@google.com>
In-Reply-To: <69cbdf4c.050a0220.183828.002c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 31 Mar 2026 17:25:22 +0200
X-Gm-Features: AQROBzAnrDT90fuqHHO30aHMwgQkPreqsso4Yt50Oikrz4l0qgT8MYeEVw4yyhs
Message-ID: <CANp29Y59HqBg5oMYYaFHhSiYA-=AdqAh6her7ZNue+mb-2OH8A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: exfat: unify FAT chain walking helpers
To: syzbot ci <syzbot+ci9ceaff8b64e368f1@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Mar 31, 2026 at 4:50=E2=80=AFPM syzbot ci
<syzbot+ci9ceaff8b64e368f1@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] exfat: unify FAT chain walking helpers
> https://lore.kernel.org/all/20260331091113.20882-1-chizhiling@163.com
> * [PATCH v1 1/6] exfat: fix incorrect directory checksum after rename to =
shorter name
> * [PATCH v1 2/6] exfat: introduce exfat_fat_walk helper
> * [PATCH v1 3/6] exfat: use exfat_fat_walk helper to simplify fat entry w=
alking
> * [PATCH v1 4/6] exfat: remove NULL cache pointer case in exfat_ent_get
> * [PATCH v1 5/6] exfat: introduce exfat_chain_advance helper
> * [PATCH v1 6/6] exfat: use exfat_chain_advance helper
>
> and found the following issue:
> WARNING in exfat_find_empty_entry
>
> Full report is available here:
> https://ci.syzbot.org/series/d9d5a999-e11a-43e1-ac76-9c718e136f25
>
> ***
>
> WARNING in exfat_find_empty_entry
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      d1d75eaf01abceb3d5cb50253375b5f254b6be54
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/177ab8e9-7eef-44cc-8b1d-6e8e2b44a=
daf/config
> C repro:   https://ci.syzbot.org/findings/9b0e35b9-b5be-440e-9461-2f19c03=
cb16a/c_repro
> syz repro: https://ci.syzbot.org/findings/9b0e35b9-b5be-440e-9461-2f19c03=
cb16a/syz_repro
>
> exFAT-fs (loop0): start_clu is invalid cluster(0xffffffff)
> exFAT-fs (loop0): valid_size(150994954) is greater than size(10)
> ------------[ cut here ]------------
> chain->dir !=3D EXFAT_EOF_CLUSTER
> WARNING: fs/exfat/exfat_fs.h:575 at exfat_chain_advance fs/exfat/exfat_fs=
.h:575 [inline], CPU#0: syz.0.17/5981
> WARNING: fs/exfat/exfat_fs.h:575 at exfat_search_empty_slot fs/exfat/name=
i.c:249 [inline], CPU#0: syz.0.17/5981
> WARNING: fs/exfat/exfat_fs.h:575 at exfat_find_empty_entry+0x754/0x13b0 f=
s/exfat/namei.c:318, CPU#0: syz.0.17/5981
> Modules linked in:
> CPU: 0 UID: 0 PID: 5981 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:exfat_chain_advance fs/exfat/exfat_fs.h:575 [inline]
> RIP: 0010:exfat_search_empty_slot fs/exfat/namei.c:249 [inline]
> RIP: 0010:exfat_find_empty_entry+0x754/0x13b0 fs/exfat/namei.c:318
> Code: 00 bf ff ff ff ff 44 89 e6 e8 18 56 1f ff 41 83 fc ff 75 10 e8 cd 5=
1 1f ff 45 29 ee 0f 8d ad fe ff ff eb 12 e8 bd 51 1f ff 90 <0f> 0b 90 45 29=
 ee 0f 8d 99 fe ff ff e8 ab 51 1f ff 41 01 df 48 8b
> RSP: 0018:ffffc9000499f340 EFLAGS: 00010293
> RAX: ffffffff82a639c3 RBX: 0000000000000020 RCX: ffff88816d588000
> RDX: 0000000000000000 RSI: 000000000000000b RDI: 00000000ffffffff
> RBP: ffffc9000499f570 R08: ffff888119e14a5b R09: 1ffff110233c294b
> R10: dffffc0000000000 R11: ffffed10233c294c R12: 000000000000000b
> R13: 0000000000000080 R14: 0000000000000000 R15: 0000000000000060
> FS:  000055557e214500(0000) GS:ffff88818de66000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000006200 CR3: 00000001bcf7c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  exfat_rename_file fs/exfat/namei.c:1025 [inline]
>  __exfat_rename fs/exfat/namei.c:1177 [inline]
>  exfat_rename+0xb49/0x1f90 fs/exfat/namei.c:1251
>  vfs_rename+0xa96/0xeb0 fs/namei.c:6026
>  filename_renameat2+0x539/0x9c0 fs/namei.c:6144
>  __do_sys_rename fs/namei.c:6188 [inline]
>  __se_sys_rename+0x55/0x2c0 fs/namei.c:6184
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f66f1b9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcad04e2e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
> RAX: ffffffffffffffda RBX: 00007f66f1e15fa0 RCX: 00007f66f1b9c819
> RDX: 0000000000000000 RSI: 0000200000000400 RDI: 0000200000006200
> RBP: 00007f66f1c32c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f66f1e15fac R14: 00007f66f1e15fa0 R15: 00007f66f1e15fa0
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
> [chizhiling@163.com chizhiling@kylinos.cn linkinjeon@kernel.org linux-fsd=
evel@vger.kernel.org linux-kernel@vger.kernel.org sj1557.seo@samsung.com yu=
ezhang.mo@sony.com]
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
-upstream-moderation/69cbdf4c.050a0220.183828.002c.GAE%40google.com.
