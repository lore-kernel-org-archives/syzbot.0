Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFC13EDE6C
	for <syzbot@lists.linux.dev>; Sat,  5 Sep 2026 07:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788591969; cv=pass; b=nvVi/Xe6qN+iHKgIZYjh1ZIl6qSZ+p16QntpEIgAGuQDoDesoOThg9M9ktAzYwxinnqr9djvBn7PJ20g10qjJK7uNFjhemDRff1mLZ3eiPwj3boJ0a3vhiPBt+s1l49qdEmq2kywt09FvUiujBc15LjnPdMFs/xWbDm5FnxWulo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788591969; c=relaxed/simple;
	bh=0+tCeNOEErAO7v6KSjFmMZiVJ5uh7XQnzHAmHngqysY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qddth74EKWXeI2aoQaPSofym0pkAKah6tKjNmnG4LK5oZ5MexlxVlR6sFpQ5C+UMl2F3An6Cx4hSaXNZJCeMdXkzU/cW/7yiWnylCnxNmRszRf3bZd5kXcjvE70BQR+YcedLSe8nlKv97qf3QZal3chPhMwc9+Ojvv2w473Xy30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pff3UShR; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pff3UShR"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-90e8535619bso30284836d6.2
        for <syzbot@lists.linux.dev>; Sat, 05 Sep 2026 00:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788591964; cv=none;
        d=google.com; s=arc-20260327;
        b=nHps19yb+GEUUkjA1SeYdUDoPPSI2ctEZTU/8ZokY9DrKQdbmx9dESHZqmZoT0hoG6
         hkK/wDKDVH0VrDoqIzCxfLnTn5qRXtZ83nSp8EbRuXxsyO3h+CgYPgEXuuHtnFNAp+TC
         2s85PbR7fRgQs50tU7Em074Q+DqsjZ929mGZRcB5MCCeJR4ZHlLDMR7sHfeTk9XwbObc
         lpxqhU4V0F91Y93kPGY+PF9jCgVH6eecW1gHc0PbyS2rVeMp4XMHYrPxb028hZdx7rie
         nQv9J4/RzFqrLqK9iQ5lWs8Fc+gHue7mqLHi0cAVZkNi+vUSoN8H1kmYaYolGPPAj1U9
         SDyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6fsKcr7lFa2LpN5h3hWfHmWEAYRSADOgxsv2gGDcoW0=;
        fh=mnAHkNmvGdqsKABSOsksAc2HfAyh6ICduddkXXYsn9k=;
        b=RFJ5PBz/L67He+2HUI5nGPi+W88p52I5weeFmxE4fIMIQpn7c9oBHaD8PXjbazW7bh
         bNvi5x/48Qi13G8LTbwH20UUAl6Rt62DV6GSojWYxzprMmsjCSR8+cL4KdHHAvuZyYbe
         dtAc/epPi45X/qD/uvbn1/B0hsoJvBAxHKSvSZVmFonWHIZq61RRo6HfPnazZCBoAmBV
         97QVnNxJ+SCYFwQpfd0bqARzat3Qe296cOIvIKilM4pzLlNQMd7fiY2s8xkanoFlQDhM
         S4H4Vh7SzYHygHcF7BxCdYQdY/ZMdIrUgovFDQShdfsRCFrGj1m78yw/giY43G3mILcw
         Rtyg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788591964; x=1789196764; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6fsKcr7lFa2LpN5h3hWfHmWEAYRSADOgxsv2gGDcoW0=;
        b=Pff3UShRneG09fAuKSz+qsG0WFFo1oPkEjy7xjljgTjeFdrY6Wx9J5OXkH4UEZBYyC
         0KJdwtOOluRQcQk0FDi9I2HA+9Zs1u57OLPRanOkyxnxvFSdZEfwzyx8cEmaFty7Zop9
         TrGFamPvrUEyiR87vQs/SAgctVZw5TD/T3SlzdLS2j1GxI+yK1j3eHnwZ0Qg09H4jFSd
         gRbGB+w+idG3Hc77ukUSPE15+irP4NQufiXCwsSqK6DevgI4HPQ+fH/BLb1Ys6L/fCdo
         E9ivRWsgw9XhtBgplR19cm6xOCwlUBevCUnGuOm+DDbKICrtJw3v+My/1U27YvIIPNb6
         AXEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788591964; x=1789196764;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6fsKcr7lFa2LpN5h3hWfHmWEAYRSADOgxsv2gGDcoW0=;
        b=EhHyVPDVuu3uOzEZUKye1oie8ulgDgEZ7gpS/k/bEqZSiNgQUa6JJIJPRFd7KK4VUv
         /hq8HRyl7gyeQX6TKUmrjSkXzQUVg8OQfPWf/l+dMxSn0jDvR9EugT+Q9855/ICuI2Wg
         ZE3khqZw3WD7+PAw063Og6GOi3F8NwQyPyIHU6qQtR2iXPSFzufPneATXmfi0RDbqF5K
         68PqC+O3iFfK0/a5ww9jGWRdYT9S1flcj/93ocjmzF0ETkVZrugCu5a/jlfpfouQE7PG
         g9tg6qegilT6tbVsYVzUhsu83Jp8PqhfAqrCcTR2QF9xMr9UhAlAftJy4YiLDJA50i80
         49/w==
X-Forwarded-Encrypted: i=1; AKwUvBx2xxQmi81QTgUeWHJRaWfA4XsEZnJ6KdwlGm3XLLPMw252bHQVYLOfXkgElUKEQv6jhkykH24=@lists.linux.dev
X-Gm-Message-State: AFuF++lTHccWWZStV8GQaUWYSDtV/Exv6Q5cixrF+A4oD2cnu0DyFq6p
	pfMOboeStUn351xyD8C1AhnfTSunO324HOhRM+WYLnsHPhT8kKEJPc0Vwt4kolTCjWc1pEMpqdJ
	ZUmXr7XY72PeqhruhICoRdZjra6zQqO8C3VuPWBK9
X-Gm-Gg: AYBFou2gngHa9LvDONoVkkPSXlprKFEyTJlB0CWOBDh2thwYPTh+jdnH2q1UPiWmBXJ
	BCEgx5f1o5tOCl5FsNFeUb086Cf6EftdVjobnt5LrnoNOeCB9HP+CQ8PK1PhsU+I+LYO/izGFYq
	2sxr06nZx8N++s+87oERSeA5KnlwXB+Bb5VnQOnP8hsd348lPc1bBXHfFDQKFFEBTbMqr3Wc73Y
	Q5UBQFEnih/4C9jlzE3OTjfpjm5C90hFf5ENAzLGPojH+xU0gD6afKTAYN8Z6yRDvT/y8togwkv
	ZM9NetuZ1m/m+oArVSfJBlgdENDWmfdxFh7cZjwTYG0Np0IxP68FA7fTkEUvyIs0rvs85wSZk9w
	T6Kw=
X-Received: by 2002:ad4:5dc8:0:b0:910:49d1:3a7d with SMTP id
 6a1803df08f44-91049d14570mr8527696d6.3.1788591963430; Sat, 05 Sep 2026
 00:06:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a9b5243.b5d4176b.238c3e.0008.GAE@google.com>
In-Reply-To: <6a9b5243.b5d4176b.238c3e.0008.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Sat, 5 Sep 2026 10:05:51 +0300
X-Gm-Features: AcwNN1UNDdKoue9peOlNhIjBZq_1fbnXJPQw6xz9CpRcF0G9UhhbJLKlMvcu1EY
Message-ID: <CAJWNTGw4JBMV2YXw2973sVXPBG-Emmbx2_3G5jOp=WZcWk1+_Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: f2fs: enable buffered RWF_DONTCACHE
To: syzbot ci <syzbot+cif2741c11656adb66@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, Sep 5, 2026 at 2:20=E2=80=AFAM syzbot ci
<syzbot+cif2741c11656adb66@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] f2fs: enable buffered RWF_DONTCACHE
> https://lore.kernel.org/all/cover.1788438786.git.qiwenjie@xiaomi.com
> * [PATCH v4 1/2] f2fs: complete dropbehind write bios in task context
> * [PATCH v4 2/2] f2fs: enable buffered RWF_DONTCACHE
>
> and found the following issue:
> general protection fault in f2fs_write_begin
>
> Full report is available here:
> https://ci.syzbot.org/series/cbb9ded8-1388-4a7b-bfa7-44082b04025b
>
> ***
>
> general protection fault in f2fs_write_begin
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/e5903709-6ea2-4b1e-9dfc-f073e3636=
7f7/config
> syz repro: https://ci.syzbot.org/findings/d05a5d64-e9a3-4714-9b41-43042ea=
aa82c/syz_repro
>
> loop0: detected capacity change from 0 to 40427
> F2FS-fs (loop0): invalid crc value
> F2FS-fs (loop0): f2fs_recover_fsync_data: recovery fsync data, check_only=
: 0
> F2FS-fs (loop0): Mounted with checkpoint version =3D 48b305e5
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000004: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> CPU: 1 UID: 0 PID: 5791 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:f2fs_write_begin+0x181/0x28e0 fs/f2fs/data.c:3893
> Code: e7 e8 23 21 d4 fd 49 8b 04 24 48 89 44 24 40 41 c6 45 2c 04 c7 84 2=
4 a0 02 00 00 00 00 00 00 48 83 c3 20 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30=
 84 c0 0f 85 e9 23 00 00 41 be 80 00 00 00 44 23 33
> RSP: 0018:ffffc900037af7a0 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000020 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: ffff8881b465c918 RDI: 0000000000000000
> RBP: ffffc900037afad0 R08: ffffc900037afb80 R09: ffffc900037afba0
> R10: dffffc0000000000 R11: ffffffff8463a450 R12: ffff88816b91e678
> R13: fffff520006f5f1c R14: dffffc0000000000 R15: ffff8881b465c918
> FS:  00007f65b5e096c0(0000) GS:ffff8882a8cd9000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f65b4e70050 CR3: 000000016a860000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  page_symlink+0x27a/0x440 fs/namei.c:6556
>  f2fs_symlink+0x5fc/0x970 fs/f2fs/namei.c:714
>  vfs_symlink+0x18b/0x330 fs/namei.c:5794
>  filename_symlinkat+0x1cd/0x410 fs/namei.c:5819
>  __do_sys_symlinkat fs/namei.c:5839 [inline]
>  __se_sys_symlinkat+0x4e/0x2b0 fs/namei.c:5834
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f65b4f9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f65b5e09028 EFLAGS: 00000246 ORIG_RAX: 000000000000010a
> RAX: ffffffffffffffda RBX: 00007f65b5225fa0 RCX: 00007f65b4f9e159
> RDX: 00002000000005c0 RSI: ffffffffffffff9c RDI: 0000200000000700
> RBP: 00007f65b5035024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f65b5226038 R14: 00007f65b5225fa0 R15: 00007fffb6ecc0c8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:f2fs_write_begin+0x181/0x28e0 fs/f2fs/data.c:3893
> Code: e7 e8 23 21 d4 fd 49 8b 04 24 48 89 44 24 40 41 c6 45 2c 04 c7 84 2=
4 a0 02 00 00 00 00 00 00 48 83 c3 20 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30=
 84 c0 0f 85 e9 23 00 00 41 be 80 00 00 00 44 23 33
> RSP: 0018:ffffc900037af7a0 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000020 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: ffff8881b465c918 RDI: 0000000000000000
> RBP: ffffc900037afad0 R08: ffffc900037afb80 R09: ffffc900037afba0
> R10: dffffc0000000000 R11: ffffffff8463a450 R12: ffff88816b91e678
> R13: fffff520006f5f1c R14: dffffc0000000000 R15: ffff8881b465c918
> FS:  00007f65b5e096c0(0000) GS:ffff8882a8cd9000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f65b4feb840 CR3: 000000016a860000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   e8 23 21 d4 fd          call   0xfdd42128
>    5:   49 8b 04 24             mov    (%r12),%rax
>    9:   48 89 44 24 40          mov    %rax,0x40(%rsp)
>    e:   41 c6 45 2c 04          movb   $0x4,0x2c(%r13)
>   13:   c7 84 24 a0 02 00 00    movl   $0x0,0x2a0(%rsp)
>   1a:   00 00 00 00
>   1e:   48 83 c3 20             add    $0x20,%rbx
>   22:   48 89 d8                mov    %rbx,%rax
>   25:   48 c1 e8 03             shr    $0x3,%rax
> * 29:   42 0f b6 04 30          movzbl (%rax,%r14,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 e9 23 00 00       jne    0x241f
>   36:   41 be 80 00 00 00       mov    $0x80,%r14d
>   3c:   44 23 33                and    (%rbx),%r14d
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [axboe@kernel.dk baohua@kernel.org chao@kernel.org hch@lst.de jack@suse.c=
z jaegeuk@kernel.org linux-block@vger.kernel.org linux-f2fs-devel@lists.sou=
rceforge.net linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org lin=
ux-mm@kvack.org qiwenjie@xiaomi.com qwjhust@gmail.com tz2294@columbia.edu]
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
-upstream-moderation/6a9b5243.b5d4176b.238c3e.0008.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
