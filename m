Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E16326D44
	for <syzbot@lists.linux.dev>; Wed, 11 Feb 2026 09:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770801630; cv=pass; b=Efvy5oBF+8qIk0ViodOCmukb7SY4uDmXAtoMVnHcC8JABUYNt2J+oerC/UhaYzSL5sUZo43yUt/S+ylIQbluL8RrwFD0bFmQjLz3I/bnwjMW5e3LbqaDOm2ORS57rpT0sHBPV+pho/yPSzBeS7Q6b0+S8DiXUsOAhCJATaNATbc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770801630; c=relaxed/simple;
	bh=vKs/fcfJlu3vtuv0TpAxmcv1fcyY4x4sMOwLRZKoD/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e98NEgNtzLldrP1VJhz7sq4FK86EcTiUnbb7fX3h6+weByBG+f5/c1sixdVKQHNINBD2pIysuZhJaRNgQi8UH8p5Ec+DcKyxkIDIEGh6rDRQhFRLecAuhXdzTJvEAzAWRQwIaQdT9wzkV81f7ULBrP9eCZQ7qnao9SZz3V5FJ+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CZMlRrqz; arc=pass smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CZMlRrqz"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-4044854464fso3954709fac.3
        for <syzbot@lists.linux.dev>; Wed, 11 Feb 2026 01:20:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770801628; cv=none;
        d=google.com; s=arc-20240605;
        b=lAp8+pdUxVCikOMubpIYe/FFw1AthGbcNclcVsValFg/gkJ+wMl+ETxxAZSFOFEq3b
         3Wk4zM3N3ynDBcj1a4tmJVg1RQ97LzlU/gbAf7Yt9g9vmyhWLMxaD54+KAGKVhZDqJmY
         qEVDh0W4epZaHT+Wl42rbr15qwks92VJ9n9CDb4SJLb+PLbvcAxAmrgt6COz4WrE13Ps
         GoZ4YGGKYhrQnGd8G/xdc0ESlXcZBfnzrQpZ3vqC0T+JaErW2idKrFpfi5A/iRVWKuQk
         9zkwU1gXyV6aTh7zu7zKO7veVlgG3po2mzL+RiuuA9bKta61a8vxiuLKBpj/JLA2budq
         9lvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QE9RK3ICUz5KU52+EdANi+OIeojTj8f91dvkBYfMTkQ=;
        fh=nBwojvvLC/xFrGiDsw8pIVktvKsIbr3KtMq9TWRnlBA=;
        b=T77x0un7mBY5ReNeuuTuXMoTfkyZTvMhGuHpYH34MWR3waoUwMty5LpvGHWxMPtp5N
         hc23X1Fhr3AyjBM3HQSaDmetiM7FiDpxE9cumvM+y337/lXsjEqn9Twfr1YxfvVJdDCT
         UQsiOFaL1KsStZhUCRXevlAtlvjv58wvocYWLZ53O6NII+3ivcjkaUTWUcX2MgosVy5V
         kmHX87udHYzmjveN4zdotje+vBODl7kjVCnGOz9DlEak/iCiv7fbsubjRx9R7HH8fT8L
         bA8td4o3WIN+8IRoqCGQKpMBW2BAMZ+ZANucq74z6XSDrTs9FJAUh5bYdW7DBjmXkv09
         vfIw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770801628; x=1771406428; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QE9RK3ICUz5KU52+EdANi+OIeojTj8f91dvkBYfMTkQ=;
        b=CZMlRrqzr1/kAI9iL5SMc3zA4vm2hQHFgkOilTegdnxjfguG43Od9EFqkwjDTImqEJ
         fZV+lHp5BcmMGH0caQ0uCXWvpKiOwaOHfhhcEr2nDVlK9hSMRbLx1wy85PaqNClaGmY3
         gec+8zSCzgCZWp0fTvnGTQZE0t5tZYhNSj01pCesiyS1OBra6la6Mug85aT5qsnNNXuw
         YA6bLY1gIBHUmHzT/HTDcl1blmdtYmV+6BSUANl+Y3397o8m4GjuQeYQ9Qqa6/m0Awy1
         cfCzf5/6zTFs0i//eqYEhDg7FPMKiDh+2Ary9LP1wrsfXR1kaFteZmajN9hgp3lI8LRA
         G/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770801628; x=1771406428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QE9RK3ICUz5KU52+EdANi+OIeojTj8f91dvkBYfMTkQ=;
        b=Elrlibb/BjWXruZWFcT8dct5scTxZjvyCbv6RnXKByUf+JRjjL3i/71b7MB0YGNcSD
         ex3iyBmBnNLNto6+pXQ2UkrH33OVFk3eA0l8mzWsV2D553AO9g0aRiHKeuhs3PduV+Zn
         3Uplj1ebVC8e5Ymw34xIqkO/AisGVdbfMzuvx53HxGd+HRI4WHKrfwJPgSE8EsOYaCEM
         kGTngUqW0QEdBYOkzLHdGP01h59bFl2Jnv2jXB+uwuBm1zLxSOuCw6woCOsjxKksFgP6
         1Giwcib0lIJg9ly+H7DKbGn8B6itsdfmTQA3lTkw9c6HWkbzUO0JtSjy1Z+BDH8knMUg
         QfUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf6Din+lztd8Kwc8hXtsHj000zdrwoccalvMrFizqXqyAGmZ8QN/K5GInJ449aRuS1psp0jhA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhaKjsmV5+3jgJM15o1k4Kc1VqASl16y1u0cAJjwrNqYjxCXnV
	LgfdP9pCSxEX9E8Lc/kjzuY9xJAWbo9xL1IIzyDKFGPE5VEQx1B0Hfg21AJH8qRqWxO8lINWO9G
	gJbDEL/Q2efiR0AJEMlggC+viJOD3LO2Uln6fduY8
X-Gm-Gg: AZuq6aK6+AoKe/2GfZ+nQyEMbTHzo+OUbUBrVyS7ycem+95TwUU8zDIVB7fejl0+Wkk
	mjecFkEbKrj51kE6QcfzUZVCmBCaPya+77W/y3gBbiF8inoOK0z96Yke7VzMGKGEZkM/56xzvv3
	B2x1h8VkrW01HUMZN8F/uPWdvkFmymKT6yf3ngIctS14AFiSybLVMR9nkk7b4In2996YCmsz18h
	tP81xUUJXNgnkG4sA/qCnAG/lFO4WjernJJwBmFEROZNxdI6tHnRifijeFXX04AYvqesy8OSLqE
	cp27xnb/jI+PB5iPlecBBEEXyAHtCj6EGxrYuTTwjcoOAQwKUKZK0WaTkI+JShs7m5NYlfNdidp
	aPCaWrvg=
X-Received: by 2002:a05:6870:40cd:b0:404:3569:59ef with SMTP id
 586e51a60fabf-40eaf8c79b9mr725150fac.36.1770801627715; Wed, 11 Feb 2026
 01:20:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <698be798.050a0220.340abe.0008.GAE@google.com>
In-Reply-To: <698be798.050a0220.340abe.0008.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 11 Feb 2026 10:20:16 +0100
X-Gm-Features: AZwV_QiiBBg2rb6Z9GkpJS9UW_Nigkyl1loitHDbV7ZkYcUWsrliU2y1noVQ8Y0
Message-ID: <CANp29Y5kXSrhkJk_AfEVghnfjzJjO9hZfqH5rxXdmfV=XCQZ8A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fat: Add FS_IOC_GETFSLABEL /
 FS_IOC_SETFSLABEL ioctls
To: syzbot ci <syzbot+cicc5b9e6ee92cdb05@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Feb 11, 2026 at 3:21=E2=80=AFAM syzbot ci
<syzbot+cicc5b9e6ee92cdb05@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fat: Add FS_IOC_GETFSLABEL / FS_IOC_SETFSLABEL ioctls
> https://lore.kernel.org/all/20260210222310.357755-1-ethan.ferguson@zetier=
.com
> * [PATCH 1/2] fat: Add FS_IOC_GETFSLABEL ioctl
> * [PATCH 2/2] fat: Add FS_IOC_SETFSLABEL ioctl
>
> and found the following issue:
> WARNING in __brelse
>
> Full report is available here:
> https://ci.syzbot.org/series/2497ea10-8eee-4346-a692-2f79990b4572
>
> ***
>
> WARNING in __brelse
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      9f2693489ef8558240d9e80bfad103650daed0af
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/1d8ee174-a672-4f80-98f2-369e5475e=
b4f/config
> C repro:   https://ci.syzbot.org/findings/4c8d33e8-6c68-4ab8-ab0c-7be7952=
f7dcf/c_repro
> syz repro: https://ci.syzbot.org/findings/4c8d33e8-6c68-4ab8-ab0c-7be7952=
f7dcf/syz_repro
>
> loop0: detected capacity change from 0 to 8192
> ------------[ cut here ]------------
> VFS: brelse: Trying to free free buffer
> WARNING: fs/buffer.c:1237 at __brelse+0x6a/0x90 fs/buffer.c:1237, CPU#1: =
syz.0.17/5957
> Modules linked in:
> CPU: 1 UID: 0 PID: 5957 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__brelse+0x6a/0x90 fs/buffer.c:1237
> Code: 75 72 ff 85 ed 74 17 e8 c4 70 72 ff 48 89 df be 04 00 00 00 e8 27 c=
3 da ff f0 ff 0b eb 11 e8 ad 70 72 ff 48 8d 3d d6 ff a2 0d <67> 48 0f b9 3a=
 5b 5d c3 cc cc cc cc cc 89 d9 80 e1 07 80 c1 03 38
> RSP: 0018:ffffc90003f07b48 EFLAGS: 00010293
> RAX: ffffffff825206a3 RBX: ffff8881b6fd5d10 RCX: ffff888177b557c0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8ff50680
> RBP: 0000000000000000 R08: ffff8881b6fd5d13 R09: 1ffff11036dfaba2
> R10: dffffc0000000000 R11: ffffed1036dfaba3 R12: ffffc90003f07b78
> R13: ffffc90003f07b70 R14: ffff8881bba28db0 R15: ffffc90003f07b68
> FS:  0000555560eae500(0000) GS:ffff8882a96f5000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000080 CR3: 000000010b660000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  brelse include/linux/buffer_head.h:324 [inline]
>  fat_rename_volume_label_dentry+0x11f/0x1c0 fs/fat/dir.c:1444
>  fat_ioctl_set_volume_label fs/fat/file.c:174 [inline]
>  fat_generic_ioctl+0x751/0xfe0 fs/fat/file.c:195
>  fat_dir_ioctl+0x166/0x320 fs/fat/dir.c:816
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fce15b9bf79
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe48117898 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fce15e15fa0 RCX: 00007fce15b9bf79
> RDX: 00002000000004c0 RSI: 0000000041009432 RDI: 0000000000000004
> RBP: 00007fce15c327e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fce15e15fac R14: 00007fce15e15fa0 R15: 00007fce15e15fa0
>  </TASK>
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   72 ff                   jb     0x1
>    2:   85 ed                   test   %ebp,%ebp
>    4:   74 17                   je     0x1d
>    6:   e8 c4 70 72 ff          call   0xff7270cf
>    b:   48 89 df                mov    %rbx,%rdi
>    e:   be 04 00 00 00          mov    $0x4,%esi
>   13:   e8 27 c3 da ff          call   0xffdac33f
>   18:   f0 ff 0b                lock decl (%rbx)
>   1b:   eb 11                   jmp    0x2e
>   1d:   e8 ad 70 72 ff          call   0xff7270cf
>   22:   48 8d 3d d6 ff a2 0d    lea    0xda2ffd6(%rip),%rdi        # 0xda=
2ffff
> * 29:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2e:   5b                      pop    %rbx
>   2f:   5d                      pop    %rbp
>   30:   c3                      ret
>   31:   cc                      int3
>   32:   cc                      int3
>   33:   cc                      int3
>   34:   cc                      int3
>   35:   cc                      int3
>   36:   89 d9                   mov    %ebx,%ecx
>   38:   80 e1 07                and    $0x7,%cl
>   3b:   80 c1 03                add    $0x3,%cl
>   3e:   38                      .byte 0x38
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
> [ethan.ferguson@zetier.com hirofumi@mail.parknet.co.jp linux-fsdevel@vger=
.kernel.org linux-kernel@vger.kernel.org]
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
-upstream-moderation/698be798.050a0220.340abe.0008.GAE%40google.com.
