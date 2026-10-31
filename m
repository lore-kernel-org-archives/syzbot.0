Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793437150;
	b=sSbzt5p9FTGffHnhCrykKBaace4IdmTY2+5MHwb+CfwK5oBRx9eb16gpyT/2T507coW8
	 Qtcz6TrW9RqmvBQU5gSLzyftut0tf6NcvFbevwkGTlxKxvhADY7oPjdHHp9PhM/K4go/+
	 7mK+JFqAqQrN57P67Qng5GnB/3Z8gDnhfBiijK1iDjMSOswfgmJfX2bdcFqGIEk3ChNqE
	 UZy1/gU1yBtKoPZFNDL6xIdIjGyUAmO6sICL8VQmiT3Phy73qzkEPCXeKo6ekoLDWQHJm
	 U4/JjKuBDPeSU3v62qp/+XxZWaDVbbXBtGBCoLCJ65PLBypw+KLx9Q6MF73QRYO5kuQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793437150;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=nvtnw/eWCkHfx89vuBIs6OjNVpGXTG7XuIO+9jBClv4=;
	b=i4E/MZSJ7OJ/Eqk9fGAYHEpngmZOK1GqgfiqfXBaYgCIwSxBDB1zGjxUWYML6/5EKcyg
	 CpBiQ20n/HZFi6cZXBDxYsOtLus7iGm9h9n+pCl7CcPvjOFAUWlJQmT7eDRQXKr8d14no
	 n70jxAv5y8rOE2nvFBYUcSXyFrvBkPVuQPvY0zv1Y925KyPAktLrdqBwqo2k1jTK8G2r1
	 DyP0H3P7j89Q+peEvm4ycv+HnPhGEb+T2wdFemwAd/mepawZWKV+cyg9+fTe6E0zEVXdj
	 72kdR5zBTZuls/wOXm8AjLHQTCYxp61fblWEyd1vEFZQ/jGClBZAq3FUwBRTcMFVHZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aC2vktbb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.44
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21887606A327
	for <syzbot@lists.linux.dev>; Sat, 31 Oct 2026 08:59:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21887606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=aC2vktbb
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6deb848ddd7so1207182eaf.0
        for <syzbot@lists.linux.dev>; Sat, 31 Oct 2026 01:59:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793437149; cv=none;
        d=google.com; s=arc-20260327;
        b=IQPEsW4s4vvPFv0+OHtNS/oE0oq/WgZZBVHQn7uzeGHetDqRNKIE8jeShGihS9vNcS
         zNCp5LJaYBd5cTJmaNrurivCu+bnR1SljqfNrPpRMkXTZm+aiHVNbNfgPg+7HVpjBYSs
         /NG3OXyMD73ZO2EGiLw3BTG9su8eGyHNzow9KhJVS3i1U3vy2/gjepBDjFmqwnfiOPPP
         asDfVkwZ6kMn7ID1hcCVyhc3zT4eQhnEIaH7J5lCSB1WOC+1/Dclx6vl06N1BltbXw1D
         prciEzShvUB+C/vHL5SkVjEhqhPdfojmm6SKtFYw5lFRCysZhLhlulQtXMJoldRnQZOO
         y4PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nvtnw/eWCkHfx89vuBIs6OjNVpGXTG7XuIO+9jBClv4=;
        fh=CdQvdZfhQDoEgXAL2PLrjxJL0TrmkMXP43rk/+00FBA=;
        b=sQXOy0JpTjBCnQhHdeT+z18EihUKp33omeO9xs4NSMfgl2HX9bjRLINBpkYatSUfHK
         IXqGvPGx1ojwVfVmfgUxvuAmYNm51/4B6dnrauCAQAmptjLYVvj/mB5JkPth9EYMlLf3
         vKmOPfgqb6Ex+k1+4mJ1TeBq3DYW8UWt4gsle6F4Xs3dyBvBS2ymjF4LihyW3xlLfMaV
         25zkG4UJm6smU0aixVx0C/sUCd9vg+CboJBi3HIk4I+f4rSbd3h8v5PviYzTENSVnuNa
         wxbE5+8ro8H9OIvam4VuW09RZI6kNclYMdfm/PGkxTeA6+EnmLppoh1O62CeUlQL1pbo
         VLPA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793437149; x=1794041949; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nvtnw/eWCkHfx89vuBIs6OjNVpGXTG7XuIO+9jBClv4=;
        b=aC2vktbbHL/qPu75y87Spb2EYJKnzCmavyqaFXjiEu3vxB8UYhXmrss+62EWKx6zkT
         k0dzbUkxunTwT1T6+pLXzoXQ63lGjCu2hceQtxLMbiKGNBrv2l9r2ThVISwBlVvPMqhk
         qDuWq6VKwh250eq/6dgvh1mJcFnnXuy/bQvtw3dtfTCWWSSLoDc/qiw0a/wKiEiNrM7H
         086Gs6rQSAq7R5WFGNhXAwefnYLb20WB4Q1X3Rb6Qe8NA4OH5NUtIZIQB9boKjnbUANF
         nTq1I4EJ5zivpNr+FkqqXNuKPslY1RV9G9gb9OtVgOfPV5B/1xUI9jwJ4qrHaRNAo2Ce
         GJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793437149; x=1794041949;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nvtnw/eWCkHfx89vuBIs6OjNVpGXTG7XuIO+9jBClv4=;
        b=xmq2n7UCT+4KGUamutTwOZOaBftpZXjk9S+nfahKwaUDCxx8zwlDp5Xu7ZSN7qhpnG
         z9YKRGPe6X+gzRSIHVnJhG1JR9Oq/UcP0Ccesx1AOvhKvpaJ/+0Vm20jin5SFDRVfDXm
         E51npQswuGewMXyxeCMNZUeGSd6TqlBRvxWWXEIMPgXR8g4/00KJSW8qdSaVGN2G0FFb
         T5HeQXC0KugCKUBGb4HPQ3TDHxTMBf/06LG4cjg/0LNJKko7z0GqwIdXRexR5eQHhCs1
         k6B79c/Ycmv9bJPAz0GSKfx5hUNAHvkSPkmbWO4eoOx+dUUOWe3a5YFceTZKrEeGzACD
         qywg==
X-Forwarded-Encrypted: i=1; AKwUvBzNkAs8TAvHmp5zOkAQYgowQxfgVDjnJGr4HeKLbIG9wAhz94a6nP2jDWgw7qqZogirajxxVSQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYIEGxuUnnrbtY7r+Auo+po3aw4tFl+3s362fys0Cjdtuguu6t/5
	Q9X72h97aL8+NSolGLghhyHjkpebjVlwjBbQqvgH7LyGPrTRKBqwU+qKh7/ckolB34D0O9DAHFi
	OdJx9Gmsew5Dws9xxeNqYb5E/VUQbPcJJA7Lrs+07
X-Gm-Gg: AYBFou1ykbCYtzKaWD4Y1+n22FqhatiiMEj5tXtAQGeWqtozVQIFEZJQ3R93p5543WQ
	HMJncu8fZjd/hUl4bTABw0B4WaJIsraTW1qCpep+OjaGOLgVRPewn8PqOOGFz2b8q+UWAfLqE9m
	jt732BEJ3B7YSox5VGKrFzD8ENO9luBILXe9XSiZmwpo/ok1YD+TAL7HQkA+A8ohmfi79112ZeQ
	Ab+OAOgw30b9MAWLjXUbHXgQsVYJ/3q0kiZ6Ab77SWhDVjvNkIIYiporSqAiC+gESaVhooCYFla
	2dm0QyU58p0vkvGCEhL1CIsFJYlPcXuRKVVL8YPhM5snM1L7fiG997T50QZd0nUM4NP4HQF69+t
	qGsKg8+OwqCu7nuvykdVPyyyaurTWd6U4EikiS31xafm0NIpOXuE5eN5aPHnpB1AZ0tUNWtop3L
	JBfhbbf6UrDK0GnYuKaAVkS78AURlTXVw+9i9YkXzg3QxcgKFosHrFM9jC8dIKQH4Gx+bbgqnC9
	yxk+HQZZqQ=
X-Received: by 2002:a05:6820:1517:b0:715:453:c6e2 with SMTP id
 006d021491bc7-7150453d24fmr1203273eaf.33.1793437148347; Sat, 31 Oct 2026
 01:59:08 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae591da.041e992e.a2316.0003.GAE@google.com>
In-Reply-To: <6ae591da.041e992e.a2316.0003.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 31 Oct 2026 09:58:57 +0100
X-Gm-Features: AclHuK8zs0zqPPkiY60Wi6VoDJUNpA08_4Pg1ErmOuxWYViFux1Xnf70NaxNlmE
Message-ID: <CANp29Y6BpNB7XKWuzKaHa4bDd9E4az76UnYwx2BivucykjbgHA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: hfs: fall back to buffered I/O for direct
 writes past phys_size
To: syzbot ci <syzbot+ci1b6ddb72e99ba3b6@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Oct 31, 2026 at 7:59=E2=80=AFAM syzbot ci
<syzbot+ci1b6ddb72e99ba3b6@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] hfs: fall back to buffered I/O for direct writes past phys_size
> https://lore.kernel.org/all/20261030042903.4160506-1-hengyul@cs.unc.edu
> * [PATCH 1/2] hfs: fall back to buffered I/O for direct writes past phys_=
size
> * [PATCH 2/2] hfs: remove the dead grow path from hfs_file_truncate()
>
> and found the following issue:
> WARNING in hfs_file_truncate
>
> Full report is available here:
> https://ci.syzbot.org/series/f8323fc4-a62a-40ea-9106-bff8391323a3
>
> ***
>
> WARNING in hfs_file_truncate
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      a804c5742bff224d4cb4d25dd383554d598be32b
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/734131df-1170-4dc7-a0ec-85ffb659a=
eec/config
> syz repro: https://ci.syzbot.org/findings/95638e3e-6c06-4f46-a68b-e468dc2=
87d1e/syz_repro
>
> ------------[ cut here ]------------
> inode->i_size > HFS_I(inode)->phys_size
> WARNING: fs/hfs/extent.c:494 at hfs_file_truncate+0x7cf/0xa50 fs/hfs/exte=
nt.c:494, CPU#1: syz.2.19/5839
> Modules linked in:
> CPU: 1 UID: 0 PID: 5839 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:hfs_file_truncate+0x7cf/0xa50 fs/hfs/extent.c:494
> Code: 8b 05 ed eb db 11 48 3b 84 24 20 01 00 00 75 1f 48 8d 65 d8 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 88 09 33 09 cc e8 02 10 0b ff 90 <0f> 0b 90 eb 9b=
 e8 67 00 30 09 44 89 e9 80 e1 07 80 c1 03 38 c1 0f
> RSP: 0018:ffffc900034afaa0 EFLAGS: 00010293
> RAX: ffffffff82bca45e RBX: 1ffff92000695f68 RCX: ffff88810ca50000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000852
> RBP: ffffc900034afc08 R08: ffffc900034afb97 R09: 0000000000000000
> R10: ffffc900034afb60 R11: fffff52000695f73 R12: 0000000000000000
> R13: ffff88816b59b100 R14: dffffc0000000000 R15: 0000000000000852
> FS:  00007f4cc5ac36c0(0000) GS:ffff8882a7c97000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000560c8ef2a008 CR3: 00000001bd922000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  hfs_inode_setattr+0x4d0/0x730 fs/hfs/inode.c:698
>  notify_change+0xbba/0xea0 fs/attr.c:556
>  do_truncate+0x1c2/0x250 fs/open.c:68
>  do_ftruncate+0x4d4/0x580 fs/open.c:194
>  ksys_ftruncate fs/open.c:206 [inline]
>  __do_sys_ftruncate fs/open.c:211 [inline]
>  __se_sys_ftruncate fs/open.c:209 [inline]
>  __x64_sys_ftruncate+0x8f/0xe0 fs/open.c:209
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4cc4b9f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4cc5ac3028 EFLAGS: 00000246 ORIG_RAX: 000000000000004d
> RAX: ffffffffffffffda RBX: 00007f4cc4e25fa0 RCX: 00007f4cc4b9f559
> RDX: 0000000000000000 RSI: 0000000000000852 RDI: 0000000000000004
> RBP: 00007f4cc4c36b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4cc4e26038 R14: 00007f4cc4e25fa0 R15: 00007ffcf07cc2c8
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
> [frank.li@vivo.com glaubitz@physik.fu-berlin.de hengyul@cs.unc.edu linux-=
fsdevel@vger.kernel.org linux-kernel@vger.kernel.org slava@dubeyko.com]
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
-upstream-moderation/6ae591da.041e992e.a2316.0003.GAE%40google.com.
