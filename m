Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33A93D8903
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 11:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785497961; cv=pass; b=OwuSQMtTdTwrrzeBnYLz58s1R7WjlcXIORRn92v90rlycvu/G94vHkDxprtV3UNHwyvcED7DLrRHdLFR2Gd2UKV3T3CCN8FNFf7O+9ZOfkKZjcWRTfDCuIavD302BytTWQ9ZcrqcrWMyPhQRM55g5r6/g/mIo0nI6T4TZoYah8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785497961; c=relaxed/simple;
	bh=MBOjwnFavpWdUPFefBcBczoHeJbaF6MSpL/Hwj6eNoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgzCB+nLqOiJqsQNGQY82GkuU1+I3DUTmmqxgJATMEmXMThIMEtWtKQGKksCv4liY5BzAcYILGya7k8EhOIw4v88n3NNdLffyca2hu3sAUz0LC/2ffU+IuYAhr5cEadPHJZrbQZhQGsCfS2W1BW+HYFEWDNF926Nfja5AIOV+n0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=omEaN5Rr; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="omEaN5Rr"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-907ae240ac3so4349936d6.0
        for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 04:39:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785497959; cv=none;
        d=google.com; s=arc-20260327;
        b=Z/oHsSh4elN/+WDS+PXv7s3Q7pJxVqCTnvwHCWPv+d6WkZBBZa0lwHJLD0GsKOkFAc
         tLGDQgLu0SQZpmnwrXte/1jpiFa0H6RVwaCnZN7hgbdVMoF1wNxPl+qicO4D0pzmonQu
         ATKMcQB5D2fhGkjYb3w9QRKEC3zFkil9NEnD0k2XH+zmTuxD0/rmxPsDj0UMPnAnl23l
         9W4y4T5Fm+pqfChK29lwGnU5awgybYnIEIKK/gu3ovHXZAjey6Wkj3mb/xo1MmD/Ks2E
         +EuAfUSPyT9KEjtEH+f6b4YsRmseKIMQySp9UT4E+DkhWM6FnS+V1OBh790x0ci8P2Nb
         yu1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0hD0jwPN8iBRUIJG2KQ1Ee+ZLVL/r5Ut25mGmDTv7x8=;
        fh=hfr7AWMLDM/5r3ujuP3wEE9CwYZqmRhWelHhPHT6Lss=;
        b=lWLx1RE1JnD5KKYWkvUiiuDCjhHN1Cg25Th+Oj2c5XFEpRkA37eprKwS4fE7mGGi0m
         OPt5ayi8Zj0CPZ7P4CUB2hF//VvXjy3FSAbzXfg2z3XBfiDBjhIKUpbGZf2pobVhWCla
         ceGRnVZ7Mwc8F6tvqOXmwoXHeqCRYoGFPk4uNdaDVDofKECPWjchFly1PB5SZ7PdBthB
         e8e02evigkeBtAtrqRMEA0dgiEj2SZQ25W7R5/BdxK95DTQamtrpPKbTxOhv7zAEWzVw
         cqe5kvNYC2HbbBtqO3Ffzv/qCZCruJg157/Tgzop8xLMZmcBKtjPBWUiBfmDhtFfvXXK
         ZQwQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785497959; x=1786102759; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0hD0jwPN8iBRUIJG2KQ1Ee+ZLVL/r5Ut25mGmDTv7x8=;
        b=omEaN5Rr2rjKUPAPfTYjnb0n2ABW7VbXUaJYuTl1zHaP1XZydcFusSirrWkHoj2kOF
         bt7U+b1tRbs0M3/2kKSR8qP1vI0XlXZEcLe60/lH4bIe63yx52pFyFLTQxVXkRRwFr5V
         b4VKWfFj+rBhVjAzuPIcLpUy5kR3FwrFTdy12j+POEp5X1hifZQKxqU1tTIUH+iU2h4f
         eUj9cbOCyuqZ/9JlZdOk6+tEGgv0I8Gu+5IpC4Xl+7KgwNXsYVYgspISiwR3EzZs34IM
         kRwd+/Bk0FOYOLvrtAS39dGeSI686k671wBWLhBS5GoExZTk/lUNmgpbt/08g+lnj2+t
         bZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785497959; x=1786102759;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0hD0jwPN8iBRUIJG2KQ1Ee+ZLVL/r5Ut25mGmDTv7x8=;
        b=Jxd9qcYVHm741yrHLqzSbnQ+zfnkkSgfGCcDBlYJBqsCLKSmloy6Aj0WV2ev78a5hD
         XKSpHxhb3DYWZqqNz0Ij3vXHTfZ75L9E1qca3S6XT5gbTi6xnFrZQsNZzTqMjw4VaMoO
         NnCrw+s9x+hLTfWy+4vypUdArVLMrfgy0b3B+diRSDVHgozbBdB6arLe+LIjOAiEEjG1
         1LAYumCk+WMpg/NWytpFkyEUYpnr5pdnbuNRe1jSQo6IK3zgDcjmqp/QnZCKHe05QGPY
         c0qElRX0MYoqY8GhKHS4+Gu+Fe1PFjUqiXVaGa1DQASU1vddvcTNAototkKXQd84RTVi
         V6cw==
X-Forwarded-Encrypted: i=1; AHgh+RrWdDLYdqtwwum93Ygb2Bclbko6efZ4dWNuFemtz7SjrCXUvdoWG1kiqDhtpAdqKiRvLrsEOqg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx70Eq1lsRSQJUNEjhrCa91l9ES6+EkuyJYfEoYZ49zBpQnI+Pp
	taEGHsd9in0NDzqYdKzG/qNVKZoXCvlUfvmzkxj/VDfOSfIRk+OCB8xPqioblGgcxxDWbNvIG5a
	MDsk5QdsHO/JpPQ0M1oOBDhHpcZww+OSAoIHGKEeQ
X-Gm-Gg: AR+sD13A214femCmozXP8clK4kSlTg/PNED2yPnb+/dOmk6EtxANN3jRQ2mvRPnPZLh
	8cGT2osy8zsJ/pVLuWOe/5RMXBuCMG3/n71PQcrADbao9WFMKuxdUCmpkSd3MGg0+fsqg/Ex+1W
	K8zeSHsQjmZen5kZK4lBFVXW2Lhj+hpQqNvJbxRLF/fHtYeNWl0NKDB9Zrmji7U0MH6YstjlrEe
	9hXdQnpfPzVudHclQ1U8qOafRSH4H58aZJ7oGFP17ag9qngDb369mWgNO1P7s2bkdq680Bj//Mo
	o4AYf/wNS+/wavIsjefWvVV3oHXsvSlPGZHCsUsoI2bmE9Qb2HNuE6nNmsEEXcbC+/8UxrqPb7O
	Ok5nta9I5kOJ8BbINe4tuBo8fBSyQDA==
X-Received: by 2002:a05:6214:21cc:b0:8ff:b592:f0ce with SMTP id
 6a1803df08f44-90842192277mr27979866d6.2.1785497957759; Fri, 31 Jul 2026
 04:39:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a6c8925.1b55b669.19788.001c.GAE@google.com>
In-Reply-To: <6a6c8925.1b55b669.19788.001c.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 31 Jul 2026 13:39:04 +0200
X-Gm-Features: AUfX_mz0_9LEiLFTfiqkWcr_oHbPTPCCmvfMvhSMQphWMhHx3Tve754BoUjKinA
Message-ID: <CAJWNTGydQUh=8jg-UbLdc-BT-zF6MWb3N5qLGBeifcSpfcCKUg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: iomap: follow the alignment requirement for iomap_dio_hole_iter()
To: syzbot ci <syzbot+ci12a77832d4f2d757@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Jul 31, 2026 at 1:38=E2=80=AFPM syzbot ci
<syzbot+ci12a77832d4f2d757@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] iomap: follow the alignment requirement for iomap_dio_hole_iter()
> https://lore.kernel.org/all/e69cc8a4a9c3f641b97872b50f04c397880077cd.1785=
374485.git.wqu@suse.com
> * [PATCH] iomap: follow the alignment requirement for iomap_dio_hole_iter=
()
>
> and found the following issue:
> general protection fault in __iomap_dio_rw
>
> Full report is available here:
> https://ci.syzbot.org/series/81e0fbae-4715-4d62-8e9e-bcd19e46b164
>
> ***
>
> general protection fault in __iomap_dio_rw
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      70c2cbf8600c7d3a622b77e31136b83d6ac7d86c
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/8d5fee65-291c-46a2-9f9a-d512f8fad=
82b/config
> syz repro: https://ci.syzbot.org/findings/c9f79a18-3316-44ec-b805-b805b1c=
49325/syz_repro
>
> loop0: rw=3D2049, sector=3D53248, nr_sectors =3D 976 limit=3D40427
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000003: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 0 UID: 0 PID: 5842 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:bdev_get_queue include/linux/blkdev.h:1058 [inline]
> RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1403 [inline]
> RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:415 [inline]
> RIP: 0010:iomap_dio_hole_iter fs/iomap/direct-io.c:595 [inline]
> RIP: 0010:iomap_dio_iter fs/iomap/direct-io.c:643 [inline]
> RIP: 0010:__iomap_dio_rw+0x1142/0x2130 fs/iomap/direct-io.c:815
> Code: e2 5a ff 83 e3 08 75 5c e8 ab de 5a ff 48 8b 9c 24 68 01 00 00 48 8=
3 c3 18 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74=
 08 48 89 df e8 d0 75 c8 ff 48 8b 1b b8 58 01 00 00
> RSP: 0018:ffffc90003fef560 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: 0000000000000018 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003fef860 R08: ffff8881148d8fff R09: 0000000000000000
> R10: ffff8881148d8000 R11: ffffed102291b200 R12: 1ffff920007fdecc
> R13: 0000000000000000 R14: ffff888166b45340 R15: 0000000000001000
> FS:  00007fd77743d6c0(0000) GS:ffff88818d951000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000078000 CR3: 000000011606a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  f2fs_dio_read_iter fs/f2fs/file.c:4887 [inline]
>  f2fs_file_read_iter+0x60b/0x940 fs/f2fs/file.c:4950
>  copy_splice_read+0x5ff/0xaa0 fs/splice.c:362
>  do_splice_read fs/splice.c:979 [inline]
>  splice_direct_to_actor+0x4b6/0xcb0 fs/splice.c:1084
>  do_splice_direct_actor fs/splice.c:1202 [inline]
>  do_splice_direct+0x195/0x290 fs/splice.c:1228
>  do_sendfile+0x52e/0x7c0 fs/read_write.c:1371
>  __do_sys_sendfile64 fs/read_write.c:1432 [inline]
>  __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1418
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd77659df99
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd77743d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
> RAX: ffffffffffffffda RBX: 00007fd776825fa0 RCX: 00007fd77659df99
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
> RBP: 00007fd776634ec4 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000800000009 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd776826038 R14: 00007fd776825fa0 R15: 00007fff168f4a18
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bdev_get_queue include/linux/blkdev.h:1058 [inline]
> RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1403 [inline]
> RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:415 [inline]
> RIP: 0010:iomap_dio_hole_iter fs/iomap/direct-io.c:595 [inline]
> RIP: 0010:iomap_dio_iter fs/iomap/direct-io.c:643 [inline]
> RIP: 0010:__iomap_dio_rw+0x1142/0x2130 fs/iomap/direct-io.c:815
> Code: e2 5a ff 83 e3 08 75 5c e8 ab de 5a ff 48 8b 9c 24 68 01 00 00 48 8=
3 c3 18 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74=
 08 48 89 df e8 d0 75 c8 ff 48 8b 1b b8 58 01 00 00
> RSP: 0018:ffffc90003fef560 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: 0000000000000018 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003fef860 R08: ffff8881148d8fff R09: 0000000000000000
> R10: ffff8881148d8000 R11: ffffed102291b200 R12: 1ffff920007fdecc
> R13: 0000000000000000 R14: ffff888166b45340 R15: 0000000000001000
> FS:  00007fd77743d6c0(0000) GS:ffff8882a8f51000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007faa8f64dc80 CR3: 000000011606a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   e2 5a                   loop   0x5c
>    2:   ff 83 e3 08 75 5c       incl   0x5c7508e3(%rbx)
>    8:   e8 ab de 5a ff          call   0xff5adeb8
>    d:   48 8b 9c 24 68 01 00    mov    0x168(%rsp),%rbx
>   14:   00
>   15:   48 83 c3 18             add    $0x18,%rbx
>   19:   48 89 d8                mov    %rbx,%rax
>   1c:   48 c1 e8 03             shr    $0x3,%rax
>   20:   48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
>   27:   fc ff df
> * 2a:   80 3c 08 00             cmpb   $0x0,(%rax,%rcx,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   48 89 df                mov    %rbx,%rdi
>   33:   e8 d0 75 c8 ff          call   0xffc87608
>   38:   48 8b 1b                mov    (%rbx),%rbx
>   3b:   b8 58 01 00 00          mov    $0x158,%eax
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
> [linux-btrfs@vger.kernel.org linux-fsdevel@vger.kernel.org linux-xfs@vger=
.kernel.org wqu@suse.com]
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
-upstream-moderation/6a6c8925.1b55b669.19788.001c.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
