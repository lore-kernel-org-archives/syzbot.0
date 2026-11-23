Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795418078;
	b=xrv3t9l9chEOJE4AFHFfdGFy8W2qbfyJBqXBVYYd088kgQ65lUpkVLn8JJFBqDhqW6YE
	 ElkArkNgxZfrEMzvOWtUhB0/G1JL6Q+InUJklWjCrUo72Nh27keSahlcX/YK1sOYsn+BN
	 +fcTBnxMvfmzZnOGTtlvqmz/7SuP1z+e6n8ty5qRTE7j+P8qc3pbtrgtI4KFo4t5fNimk
	 klAefKq9v/CXh4XiOy1hrZztgUMKRWsCLXONANyQhxlcseuLv3dgd2Cre7PIoQ7u8gSgc
	 dqEAzystSLUSQIehL1yPy4+SwX3SHRk2QoMV+zxvXqKbxwtqV89sI4VIGy8MazYXfqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795418078;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FqSAcHueU6p0b5snOdW+Qe27kC6rnp0JEZ72HTc08cE=;
	b=dsK7zmdpRDlnKcaXdhZv6z3uf4ZQojuoValXZOkMZBdw6kF0qz/z65GYFx8bbplRRp4H
	 o3WzLLrHI3HRcp3kIQw+WA0KkjeCvGgaN3tWoK+eThOqVMbkWK/fA9c+21eyUwnN6966Z
	 IAEDKwdVzIgjLpmSxBWOMa5vZI6mEuZMYCbjGutjjMxb/uWPx0MHUbVNj+q/1ADX1zVRD
	 SBB+hBmf8xD1Jncd2Tt16HBFZ1TwVPFJi7ICVhXTZJZn2f647IWdEti+xzIx1gegH9joN
	 ZUc+uJbNvTQrFGjxdfHLeJ0t1m9YVQlTqsQ5TVYHAR/CJrApX7/UNlJZk2Hbjx2UDYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kOgeYAf7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.46
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2506606A31A
	for <syzbot@lists.linux.dev>; Mon, 23 Nov 2026 07:14:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2506606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kOgeYAf7
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-717080a2d50so2943956eaf.0
        for <syzbot@lists.linux.dev>; Sun, 22 Nov 2026 23:14:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795418076; cv=none;
        d=google.com; s=arc-20260327;
        b=XLyDIUCsxU2D92RtqIjJMO0vz5Sg9uL6GeLe7h0/f42s1hABHBqxfEnRoG8+usGh2D
         HfDownRlQ/0dUMJ/PnvbWFMA9ToAB5/IIcp7/tPBKjuQDFAxoRg3If9iP/Jwg4EfsOcr
         pP/4ZSbbOANApvuIDALIw3KJbJayU//m+EdTX2ezkJNFXw1BGxCtqnYaQrtzAB4KJN93
         ZlKFzFfnDV43G/doWyUcYHgHXfs+pXPbeizA0IdjxpbsE+CjzipNLBpAXhgGAjkGCMup
         IOw3JIdLjzuCLvULAwGICITcLPWXY9zw0zJK6gRHPcSrNzB2XeFaVPqli9yAmXtEAPQs
         ZTXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FqSAcHueU6p0b5snOdW+Qe27kC6rnp0JEZ72HTc08cE=;
        fh=Mp8iQFkld0OgiksU6KmLNDjN9100du6YbSP27xopgnI=;
        b=LgL8y9FWhDVB393s7gPxhrLuh/KuTybxCGdzBjHT3UCiUcDBdDtjjdDKL7B+XEdNYQ
         7uc3KM3auI1QhM4BHlCJCzpTSkKycI0PkIEZHafDfgJFJ2toXkB7/pE3g7SxkocuxiVU
         VW3RauybOZn7+wfvQ5qx6hl2qTYh4fzw8W98R9noaVcs3mo8sCpFLYo2bxKj81c7eYru
         R5Qfz91lZZag+ouAwxzhqkvDOf0CMkuatFLzl+V4OrhF7gllso1QPn9Azj4XbL/ISgzY
         5QV23Qjdr3W6xsgtjef2ssiydQl0whG9ZzIFxkDFVR1HaOSn3VwFXDmDXg5oks4gnptV
         llWw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795418076; x=1796022876; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FqSAcHueU6p0b5snOdW+Qe27kC6rnp0JEZ72HTc08cE=;
        b=kOgeYAf7aL4GamxivUDiurb+7DffDBNupqMad0yxdMPMfl9E0aeDLpt8WH7LxlAEUE
         EmXK6R7vTLeX3icks4J4QZj8jF3TM/5TC2LGt7NDQPWQ0urIGrSefr+4vIvF6KsFZzF/
         g4zo76Wiag6QR+GBYuYRI1KRUckT9Bfty6AnHdcm3tmHhFynbzpTXJWhiGIZZ6dThA4A
         gVBq1zVUgpeCqpZhLvd1lDBsaqky+hADonrWOzIF7xjuxAKVjLxGExbBBAX9d3Xf5X9Z
         mR0CfC1oiuGXfK/4pFxQ+jfHT8jZT7qwVWO6FHc+K3Zgp3occpUmi6TVfsSNJHmsnkWl
         sNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795418076; x=1796022876;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FqSAcHueU6p0b5snOdW+Qe27kC6rnp0JEZ72HTc08cE=;
        b=asbtyirxBjFegrq1kn54qbsPZenbEniicoNlhJqKLbMkFOB1qEqOGsFqQWvxmzzKMx
         l9Ja9Uc038chFHS0D6DnE3FtywFqjU9/+2UsEQFCGV3XEG0E3/thMtUoLm0TWTBLy21i
         2fFt5NLqGFEau0Wa+h6waABghJZ5g9rr6uLmyxFkx6nntaa/L9RhTG0kMNIveeRhxfLN
         Awxna6Z9ggg6de7ukKiBMpEia6v8pYZrYgDcGaFwTgAdaXBHM+wo2ueR5R97wUooPdQU
         g3PrZc7Tkl68tNmQSbZYPIMMCFc5t2sAtERYCHCeS+ijJYNlCjahdcWNyjag274a2w3j
         xg8w==
X-Forwarded-Encrypted: i=1; AL+hErF93esOzhHfaqBJEd6aFZS/+s5ddyEcEDJ4SXw+9uxIIMCZVM3NJc992MTvylpB1OjYKrAiJVA=@lists.linux.dev
X-Gm-Message-State: APuU4Z8w+M8efbgTHGcj9RZSYrsjN2BkLykRGxuJaQk5lMSiBR5hyfJy
	uK4JC7SNbYRml0taQhThatAEgsQ6e0jQgGGhW/HfWrf5Hx9xV1IbpvjqwbHgQVZB7KubQQemWQb
	6aYyEhTb1+9BwzEVNHU3MdvdiveUveuRwLquDywS+r8JMrHb0uahQXFwd
X-Gm-Gg: AZFdTZcCMAUDSnYKeOHdaIIVe+QkUDJf0tFDfUQzSC4JNJo+AkW4NnlL4cCCtGNoe7E
	RhW3sCqEKsLlbyu2jfa+blP7i2SaNUC9PRnNOXx0yFuYf8pNHf8HG6aOmNeKKHHetM77LD5vqV0
	eIaQ62J4JRaHT3sMdj/WQXMA1fy3r5eByMEYH5p93EZ2T+uUuPwJLT5DmvKpIg8FCqKNM5inkKt
	8CEABpjEbJj8Fm9fD9XtsrA0k0+pwc8OpRZJYcUE6u8gYiTyCddwhtf1F95CVapeaGO4btShojw
	ygvxIGmtVUktBX9j3SoljyNuVsi2ay2m/LnyrPVzfkuAzbyolbR9W2Dnh1lZygTlHSEO/GMDLkg
	pc3n7fFJGWPPNPEZjHEluKtbkMHHfhRoiRV0wu7GR9dd0XUsILuD0SFn5Y2EByKwyGW/+gAiAU3
	tGgG0gjERUer7NlVs9EB1Kd/pdvTsNDusYsFs8Uhr2jS08qBiJ1IeSNFut9stKt89epgfKQN9LD
	xWwcaO6nw==
X-Received: by 2002:a05:6820:1607:b0:71a:f1f3:557a with SMTP id
 006d021491bc7-71b39487e26mr8571373eaf.42.1795418075962; Sun, 22 Nov 2026
 23:14:35 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6b03419d.71deaa98.2984e6.0005.GAE@google.com>
In-Reply-To: <6b03419d.71deaa98.2984e6.0005.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 23 Nov 2026 08:14:24 +0100
X-Gm-Features: Aa3M54rJRFXowrBs0I9shGct2wSJUFs4T59nS4uYISfvPATh343urtk2YHBeSDE
Message-ID: <CANp29Y5BzjzKVJREuKvGFbsESmQ4oO6R7J7949h6epcUFkQ9Lg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ntfs3: clear VMA_MAYWRITE on read-only
 compressed-file mmap
To: syzbot ci <syzbot+cidefe10906dc7c4bc@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Nov 22, 2026 at 8:25=E2=80=AFPM syzbot ci
<syzbot+cidefe10906dc7c4bc@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ntfs3: clear VMA_MAYWRITE on read-only compressed-file mmap
> https://lore.kernel.org/all/20261118132710.29751-1-suruurism@gmail.com
> * [PATCH] ntfs3: clear VMA_MAYWRITE on read-only compressed-file mmap
>
> and found the following issue:
> WARNING in mmap_validate
>
> Full report is available here:
> https://ci.syzbot.org/series/2cf8a8c7-bfcc-4bcc-bfda-dccd333a025d
>
> ***
>
> WARNING in mmap_validate
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      b3f1631d362539cfe14571ccfd7db919ffbc08c7
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/92ccdff0-04ed-4a0e-80d7-77102143b=
eb7/config
> syz repro: https://ci.syzbot.org/findings/189d2e19-2002-455d-a0ed-c3a0150=
48eaa/syz_repro
>
> loop0: detected capacity change from 0 to 4096
> ntfs3(loop0): Failed to load $Extend (-22).
> ntfs3(loop0): Failed to initialize $Extend.
> ------------[ cut here ]------------
> was_maywrite && !is_maywrite
> WARNING: mm/vma.c:2872 at mmap_validate+0x1c3/0x1e0 mm/vma.c:2872, CPU#1:=
 syz.0.17/5893
> Modules linked in:
> CPU: 1 UID: 0 PID: 5893 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:mmap_validate+0x1c3/0x1e0 mm/vma.c:2872
> Code: 5c 41 5d 41 5e 41 5f 5d e9 1a 34 d8 09 cc e8 e4 8a 98 ff 90 0f 0b 9=
0 eb 1f e8 d9 8a 98 ff 90 0f 0b 90 eb 14 e8 ce 8a 98 ff 90 <0f> 0b 90 eb 09=
 e8 c3 8a 98 ff 90 0f 0b 90 41 be ea ff ff ff eb bb
> RSP: 0018:ffffc900041ef428 EFLAGS: 00010293
> RAX: ffffffff82309662 RBX: ffffc900041ef9a0 RCX: ffff8881686c3c00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000200000000001 R08: ffffc900041ef9a7 R09: 1ffff9200083df34
> R10: dffffc0000000000 R11: fffff5200083df35 R12: dffffc0000000000
> R13: 1ffff9200083df34 R14: 0000000000000001 R15: 0000000000000001
> FS:  00007fb956e196c0(0000) GS:ffff8882a7809000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb955e71a20 CR3: 00000001baeae000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  call_mmap_prepare mm/vma.c:2975 [inline]
>  __mmap_region mm/vma.c:3075 [inline]
>  mmap_region+0x12d8/0x2800 mm/vma.c:3173
>  do_mmap+0xe0a/0x1300 mm/mmap.c:573
>  vm_mmap_pgoff+0x27a/0x520 mm/util.c:581
>  ksys_mmap_pgoff+0x4dc/0x760 mm/mmap.c:619
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb955fa8fd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb956e19028 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 00007fb956225fa0 RCX: 00007fb955fa8fd9
> RDX: 0000000000000001 RSI: 0000000000400000 RDI: 0000200000000000
> RBP: 00007fb956037fed R08: 0000000000000004 R09: 0000000000000000
> R10: 0000000000010012 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb956226038 R14: 00007fb956225fa0 R15: 00007ffcdbaed6f8
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
> [almaz.alexandrovich@paragon-software.com ntfs3@lists.linux.dev stable@vg=
er.kernel.org suruurism@gmail.com]
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
-upstream-moderation/6b03419d.71deaa98.2984e6.0005.GAE%40google.com.
