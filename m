Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3E21F4613
	for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 23:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770938100; cv=pass; b=Zzdcw8JP4LdJmulDgR7QkLDgCeuj2Y+3a25v/MTD7/z/WFsk3yWCsux7pLj+f8vOhDJv+BruRu53yPitJ6PHSfpE6VpyEoVEc1X8FfgvHJmWuEvksBlLNLubod266n3E16QOj2ugbWcXIFOHgkaS2GXXFhfEC2V0gOlM+csm/mg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770938100; c=relaxed/simple;
	bh=uGGr/VyEKf1H87bAKfi809yaPB4XDPNbWFfR8bjtjcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C7MpnXiq42V9roB4VAfSNe5dGSRXcnFjrDPFDTzwJAyBpfOzlkS6j1jRYaXopdyNN+6F9DJfRwWLbmLQz+wtTH8FmSwB8hUf2DXHoqlEB9jUqtvO1O17abvZWwy21zaVrLBxNV+XTgL2hXnFBxSKAU7npXwFDUdpPeOnTrJ77ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NwbVe2+5; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NwbVe2+5"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40ea36b56b7so248929fac.3
        for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 15:14:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770938097; cv=none;
        d=google.com; s=arc-20240605;
        b=HNVkLGEEu4O5++x9i6k0PAFYAJh0JEQxZlm9BfS5dNUilbxEDJXp4yO9Ab2m9IB/FM
         /yAfquL1OaS2HfmF+BdfUFBjfz5Qh/ARVWUGHrmetwId5swrVw2uBprqicIQHrMid+nT
         NaraNLyDKmSXvT88cd741NVPv+LfJUij/uK5Y0X30c72HERvOg6RstVwYTpgERznRw5s
         HL2ilCGl9TlDYiKtiANawX1DL5CJUgQx+9HG6pJkdu+PCAc6USjxHDPldtTfMf/aZkd9
         lSljjcFXjOjHkqHaOjFcIqBLvlJIjIo/zdPN488SGQuOOm5gNm2VVoo3zuXYHXg1VqW0
         Z/dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mPQLra4NoHefweMiG2eU/wReqz7FvQKf51dr833YUM8=;
        fh=K+zbduCPnbhkH6cWnHEOvyqTGCnP+s93oWeQJ/3HWuU=;
        b=QtgN2O6S1CXxK6QiwXk5xHoPiWguGKghgm/Z1R61I5CiKYahxUzRfy9/lvlGq8tR+T
         xcKxJ9Az7dlKCmRzJGzOynqkg37DndSo9IdHJHpRwb2J0pUTb1Y+zEwB8MCdfvuTwsUa
         bmLOVOQBjHnj5F2o0M5wqDzjZHQ72+v8OdZcPPI+TZM4GX1EAUaz3MKSIGB+EPxL1O2/
         nBGuEcYzHHdz6DXfY1T/RkDMZnsCZyiscKCf5kgh3YijcydCK3YpAKh7ve+xFvGxWejr
         6jr74TkSl7eiVTTx/V8mAjO+xKFxdf3YrZocqnn+X7LYmZf2iR8mF+aOQCHPNi55SOBk
         hQLw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770938097; x=1771542897; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPQLra4NoHefweMiG2eU/wReqz7FvQKf51dr833YUM8=;
        b=NwbVe2+5uJxoXpDaSTEMeKfginySApERaN/GXDzg6SKzNI4GUmLL+qDd1xZRFk2aKR
         JyPuFWzhvaP+P1ortSY9KKKs5cLgoosERaDV62ZcUZ3Ursk7B771WETJ4rzh7kMpLXHO
         6mXCpEtEP/DQaK20/hgeLdA+P9tiwPu6s4AzXtUhNtrGC2m4vcI2tuFliqHr2Ws2dUmi
         asJVAnsTCNqmr6GyfuanZ5v5YYfQa/mIOcH5zNqWO4pxHrNDo3Qx+kRI33hWF050xqc+
         /8fSGoIbYdUhJTmXgQlO9CF0MTG9FiCMYffYpHQAUmJCZ0ZjZaywnHBWsjb22N4La904
         86Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770938097; x=1771542897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mPQLra4NoHefweMiG2eU/wReqz7FvQKf51dr833YUM8=;
        b=c+u0KB9L68UrONGWI2p75IFnUnXZQQmQKlVlwn2lvGWsHvUQrPJVxQrBundaXw1805
         5qam+3COxeZJA1uAXNMkvwlsE85i+ZRYjF1fM5f18KouRDxFwi+wnE0kTY3Rh1TDfRl8
         eGZQc2R91C/D8PQAz6cHMB+buji4dVviVQYG7slw/4syHYgQdQdeN6OYw+rcF2M+DA/w
         UmsLVsfS0NzppVzjfAifd7ucU1xAdYVJhK3ZVGYKi8c5BSn0V4ptPddlXvO/X7VChbzc
         7GdBsgGQH4UP0FicwhyIlQrpXlBHTEOOnQuGgM2r8OBKHumX7QxNnuOe48ySEVXtZ8lD
         gUtw==
X-Forwarded-Encrypted: i=1; AJvYcCUL5E/6CvFfPR9JT5H3ryXR6jjO56K+MWTnhP9k8QPWYKFv+KmsZfu2pbocny9d9VbkbwVvocM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRurAcjF7Ef2RFYSZIR4nNoo4pyzKno4q8NZsu6F/ZuiIaFkG8
	3az3mKZ2+kCClN69vySdeeoyGOuYRiQJrMtoPmUUnt8o+nquY8ZwrAPM/66t9txaZP4klOAw8Xt
	+CpDVvGqoWn42ld+/KrfEA81x0eJNHqxvNp1JIGxl
X-Gm-Gg: AZuq6aIAHILAkDB9HV7wvXxPiiyrqc6D7xeFIINgE4JlLfL+He9SQcddNuGEYOOSWEO
	wRikHMny/Qdph8/8HeSywwJFtjh0gbh/lARxYNZUwFt9Z9UJrautkrBGzNFzpVcYR6uCp9gMN+y
	OW3+HgxD99AmymDBm+LCKjih5VY0zyPPvKvzRArP6LaeWAcDlXJcofvQ+IPPqj7U2ALfTaBAwyA
	Eq2VRk1cAHGAFIdq0vlbA+qq8Ns1PWCa/JEbcZ7+9IT1S+Q/XtZ+33LzBlacbLcsZGrUpZ2ymjT
	gqOB7A87fX0krNg5F5v0eRhwx6BgoSBg4LzMIZ/ixhndJTM5YHZWvw42njNvrgv7IgUUCjqqG3j
	xPhekIw==
X-Received: by 2002:a05:6871:2995:b0:409:6da8:c8f4 with SMTP id
 586e51a60fabf-40eee6f3b28mr250122fac.6.1770938097187; Thu, 12 Feb 2026
 15:14:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <698e4445.a70a0220.2c38d7.00a3.GAE@google.com>
In-Reply-To: <698e4445.a70a0220.2c38d7.00a3.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 13 Feb 2026 00:14:46 +0100
X-Gm-Features: AZwV_QhpvlOq30zPO5KVMKRs0v77X7znXNSQR6Uaw6R8GjX5FXhmFzNcygSDufg
Message-ID: <CANp29Y7o2eAW7o0GLq2p=QTD5h=SKJh6Xc3Sx-bzK8_ieQ+2Ew@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fs/ntfs3: add delayed-allocation (delalloc) support
To: syzbot ci <syzbot+ci03b327bb4b4298d4@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Feb 12, 2026 at 10:21=E2=80=AFPM syzbot ci
<syzbot+ci03b327bb4b4298d4@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fs/ntfs3: add delayed-allocation (delalloc) support
> https://lore.kernel.org/all/20260212170849.12455-1-almaz.alexandrovich@pa=
ragon-software.com
> * [PATCH] fs/ntfs3: add delayed-allocation (delalloc) support
>
> and found the following issue:
> WARNING in ntfs_extend_initialized_size
>
> Full report is available here:
> https://ci.syzbot.org/series/13e78e99-d298-48f9-b81b-be0931799244
>
> ***
>
> WARNING in ntfs_extend_initialized_size
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      9152bc8cebcb14dc16b03ec81f2377ee8ce12268
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/b551b487-d04a-4a8a-89aa-575a75c69=
c23/config
> C repro:   https://ci.syzbot.org/findings/c8966f1e-fd77-42d2-8f24-1e7b54a=
c54dd/c_repro
> syz repro: https://ci.syzbot.org/findings/c8966f1e-fd77-42d2-8f24-1e7b54a=
c54dd/syz_repro
>
> loop0: detected capacity change from 0 to 4096
> ------------[ cut here ]------------
> is_compressed(ni)
> WARNING: fs/ntfs3/file.c:236 at ntfs_extend_initialized_size+0x1dc/0x210 =
fs/ntfs3/file.c:236, CPU#1: syz.0.17/5975
> Modules linked in:
> CPU: 1 UID: 0 PID: 5975 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ntfs_extend_initialized_size+0x1dc/0x210 fs/ntfs3/file.c:236
> Code: 0d ff 4c 89 33 31 ed eb 05 e8 70 8b a3 fe 89 e8 48 83 c4 18 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 9b a6 8e 08 cc e8 55 8b a3 fe 90 <0f> 0b 90 e9 31=
 ff ff ff 89 d1 80 e1 07 80 c1 03 38 c1 0f 8c e1 fe
> RSP: 0018:ffffc90004547c30 EFLAGS: 00010293
> RAX: ffffffff8322128b RBX: ffff8881a8229670 RCX: ffff88810ba49d00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000800 R08: ffff8881a8229737 R09: 1ffff110350452e6
> R10: dffffc0000000000 R11: ffffed10350452e7 R12: 0000000000000110
> R13: 0000000000000ef0 R14: 1ffff110350452ce R15: 0000000000000000
> FS:  000055555ee59500(0000) GS:ffff8882a9460000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f811e871980 CR3: 000000010f87c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ntfs_fallocate+0xf21/0x1220 fs/ntfs3/file.c:670
>  vfs_fallocate+0x669/0x7e0 fs/open.c:340
>  ksys_fallocate fs/open.c:364 [inline]
>  __do_sys_fallocate fs/open.c:369 [inline]
>  __se_sys_fallocate fs/open.c:367 [inline]
>  __x64_sys_fallocate+0xc0/0x110 fs/open.c:367
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f811e99bf79
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffecc78b558 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> RAX: ffffffffffffffda RBX: 00007f811ec15fa0 RCX: 00007f811e99bf79
> RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000005
> RBP: 00007f811ea327e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f811ec15fac R14: 00007f811ec15fa0 R15: 00007f811ec15fa0
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
> [almaz.alexandrovich@paragon-software.com linux-fsdevel@vger.kernel.org l=
inux-kernel@vger.kernel.org ntfs3@lists.linux.dev]
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
-upstream-moderation/698e4445.a70a0220.2c38d7.00a3.GAE%40google.com.
