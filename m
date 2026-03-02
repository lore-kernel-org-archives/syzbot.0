Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA8230DED1
	for <syzbot@lists.linux.dev>; Mon,  2 Mar 2026 10:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772445928; cv=pass; b=sz9Nq1RQH81gpmmCDnHSTNQA3IOZvhudkJfOw+NXH6Xiu21qGyBghlpK2I/biqy3AgHc78C251ofyopiUoM0C1UEhCYVEPdU8OaBfpacsb4c/nKO00cR53tIIaFTzPks9UVJSOr2zdMfTzDpO//ROO1lond8joFID9aAuXhFRNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772445928; c=relaxed/simple;
	bh=KGfuzC0zMV+4wjooqfCmQrV7EtvEJSi85r9Ro93IBf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QuYZr8NYQURz+4JlehP90Zs7JPEpcgIIfYcaD/w4TBAeVx0UfRj2aep0AW0xxQkYub9ffBwjWrZ3TpwA06IndnZ+YHtOV3bZY7f4p+/P8oIvxOBHVT3+pxcR3NDtksFqxsNIIe3c4720ZCIxwdkk/axRbPHzEPwyarPzrBHmMPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fc5fsjOU; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fc5fsjOU"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-482f454be5bso46356185e9.0
        for <syzbot@lists.linux.dev>; Mon, 02 Mar 2026 02:05:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772445925; cv=none;
        d=google.com; s=arc-20240605;
        b=EcZiqpS2idBkbe+hV9RdKhAjwiD2RGPGp2lGsxROvwJ7qb4gEFfAlB7PdAmvfqH7JQ
         5cn2dEFJEWQhMRCuoMgIqsnmT2bsHBgi5r8YoFt/SnlbctF868n9bZku9gBEQuXMEZGw
         jD2emPNYhd5Hh0nzut8KNXIgN/2grNvb/0dlj4O05UhyL7VllglYZJUVVU21zURQCy71
         9GR4WD7E5SWvI2wKok2e25cFslLj8CZ0PERIQolnrZ8ZN9ck07Go2DPP7hb8y3LpM/IZ
         ALjtzVlZIrbLLaiaKy4RSBXOQAMt5cfN0DIHxF901cX2pIo/M95pvOUnvtzm+9cxphNX
         s98A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2DPREep6vvBx5xVDD6D+LItr7gi70KayYaPZWIRTJj8=;
        fh=pTxYj5lmKtL9JCyahqidgDld5631V/VVYTxhn2VA5P8=;
        b=hk4cKRftgTGpgOmXGMizQpV8oOu8UxWdANkEzfGCm4FWEpFoeY0kM+1fEPRUFJ8OC+
         ywtOJoUTNf7gGDOa3G2uxAn6IBWXKVytXGU9c5NbCu17RddN5F4QvpPdwEgjcNogQhIo
         BPLVXXi6lxGGvXb6IvZ9cDVO+mrXUH1jIeTaKsTJUg5YnvJjupxyNFxx+lRgDAbW9nlp
         bkGlnUgFtDrwcz9VpS+wKo9tTiA0SHaxicIGb/GhZydwVcmElHdSPgXkgf7oRbkj5qVr
         vmmQvY3H1nRfHR0OggZZpqRtR7y8lmDFcVEYqmDC7Tjk9NJoapfxmM5a/VZrnQ4Gteab
         PTzg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772445925; x=1773050725; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DPREep6vvBx5xVDD6D+LItr7gi70KayYaPZWIRTJj8=;
        b=Fc5fsjOUcLXwm3BAFydI+pAlsuIcsxhwjlfI5xXgWeoS+uPIX1XG+GawlqqNIzy4Wk
         QZWiVjE3j5g/tqGHyPzSQ4P8PZNJNdh55ypn7JrcQwHgdkjUcVg3dEZH95x09Ua0DEld
         jYoTyO+umWKc3fNbH8jnxVqXCycnEiXN/K4rPgEZ4wWok4tDPYUJU1fY7T7hJ5pB/hZZ
         BRVqAv4sBdaRLBUYDXDWZRZaSvj8J/q3GbslbSJagcZ8QWMg47SsPD5yKOu6QTk/IV2O
         A6WICV3TfVDMaaZsByRPxM9Oxhg3evv9IeDqFHOSFf555MHUj9oJucCr7zrk6Drafxc6
         Jjlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772445925; x=1773050725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2DPREep6vvBx5xVDD6D+LItr7gi70KayYaPZWIRTJj8=;
        b=mSC+H2vfD5DM2hrd4qSy2vylVQntz/iLnUCjdrxFx+KGLWgrofytxmVx66MZhv4wiz
         W2lOpjTRDqDpVeDGm0mW/0ifWM3ROQa8U8Jr4+JHGwcr7AAPn4d2WF4PkkSu3zwHpEWq
         VE7EZDnjTy3El4xOdbhDZHWShSgsQz7zeMaK7PiZXr+v8EwuD7sQc5eUQNLVcXUkeQ46
         qWrR5vitb2VOyMS7a821VDNGDM+5unG8nWnStM9UOBB5gFDe5xITW54ikBB3Xio1ys7l
         Aw2R4aIvJlwb88L/ez9ts04/i74Y3YLIUXc+KkZp+VF0YHkGOd1WY/JmSiGf4ZcQT30X
         Km0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWrJnbwv7jLFzfgV2xZMVyDIj0hQrYPU1FSHD5PX93BgjtWwZcNG/gRZHZWVwEd1dlppB7mTIE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwLdJ+Ef2bvliRUVTXoS9NcJX11rDU3xozDokCggWWTjshZXah
	iPFilUH9N3h3jqoOIWAyOP3buFA1qxgFb9m95tNSpSLA2pKJIbMYr8atkmG2eI6MPjaKSpnKfVI
	6ICxU7lzFtYRKh/nRpkDPbmbrtp6XZ8HWQBKjEtAN
X-Gm-Gg: ATEYQzwG0OVEwscbo6UaQZ8IZBTWIFyXFjyfMsw0YmmLrAXbWeAcAMmY4yPgWeFl+/E
	UZiDeume0hNogORny4H3eM3hEy5Q6uFz1vjoAzEGvVl+ODhuzUZL3j2s4DDEVsD5GijMh4p8Ytp
	UmaI8j/MW7hDvzKWw+0I41uGHfyhPv+QNzx/doE2zQw8E/PwVOuzpjYAKbmT54mtepOMnJVxmgH
	RiQho2Koc/umeU+u9UOXka+Savsle08elxDEkfu/OZeCj4cN9tAbPLH+q2L3A6FHBYIRI9DWpLr
	ySmWcpdGZtNNgTYGcn9dIFy7MzN0jehR/Mg2kw==
X-Received: by 2002:a05:600c:34c1:b0:47d:6c36:a125 with SMTP id
 5b1f17b1804b1-483c993a0e3mr214991125e9.17.1772445924269; Mon, 02 Mar 2026
 02:05:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69a3a81a.050a0220.8405f.0000.GAE@google.com>
In-Reply-To: <69a3a81a.050a0220.8405f.0000.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 2 Mar 2026 11:05:13 +0100
X-Gm-Features: AaiRm50b1wlt9sDTy5pXOcORQ0EjJipTuUJO-kuMMVspwG_zar5rT3bkojtx5yI
Message-ID: <CAJWNTGy3ezndDWw3_PMNv40=5dfhJTyNn0Re8S=wrZUQhdd=aw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: test if inode's all dirty pages are
 submitted to disk
To: syzbot ci <syzbot+cic23c5bac8a4912b2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Mar 1, 2026 at 3:44=E2=80=AFAM syzbot ci
<syzbot+cic23c5bac8a4912b2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] ext4: test if inode's all dirty pages are submitted to disk
> https://lore.kernel.org/all/20260228025650.2664098-1-yebin@huaweicloud.co=
m
> * [PATCH v2] ext4: test if inode's all dirty pages are submitted to disk
>
> and found the following issue:
> WARNING in ext4_evict_inode
>
> Full report is available here:
> https://ci.syzbot.org/series/b58ccb85-a946-44ae-9d57-c02bee2a43ba
>
> ***
>
> WARNING in ext4_evict_inode
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      4d349ee5c7782f8b27f6cb550f112c5e26fff38d
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/1accd9c8-371e-4c6c-9c4b-b930c65c2=
3be/config
> C repro:   https://ci.syzbot.org/findings/ccbdbde1-d214-4e90-aeb7-d4bbda0=
1329c/c_repro
> syz repro: https://ci.syzbot.org/findings/ccbdbde1-d214-4e90-aeb7-d4bbda0=
1329c/syz_repro
>
> ------------[ cut here ]------------
> !ext4_emergency_state(inode->i_sb) && mapping_tagged(&inode->i_data, PAGE=
CACHE_TAG_DIRTY)
> WARNING: fs/ext4/inode.c:192 at ext4_evict_inode+0xce7/0x1020 fs/ext4/ino=
de.c:191, CPU#1: syz-executor/5917
> Modules linked in:
> CPU: 1 UID: 0 PID: 5917 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ext4_evict_inode+0xce7/0x1020 fs/ext4/inode.c:191
> Code: f3 ff ff e8 ab 60 40 ff 49 89 dc 48 8b 5c 24 18 e9 ea f5 ff ff e8 9=
9 60 40 ff 48 8b 5c 24 18 e9 db f5 ff ff e8 8a 60 40 ff 90 <0f> 0b 90 e9 cd=
 f5 ff ff e8 7c 60 40 ff 48 8d 3d 85 e4 92 0d 67 48
> RSP: 0018:ffffc900057e79a0 EFLAGS: 00010293
> RAX: ffffffff82852b46 RBX: ffff88812000f5b8 RCX: ffff88811128ba00
> RDX: 0000000000000000 RSI: 0000000004000000 RDI: 0000000000000000
> RBP: ffffc900057e7ab0 R08: ffff8881111b6387 R09: 1ffff11022236c70
> R10: dffffc0000000000 R11: ffffed1022236c71 R12: 1ffff92000afcf44
> R13: dffffc0000000000 R14: 0000000004000000 R15: ffff8881111b6380
> FS:  0000555570b0d500(0000) GS:ffff8882a9464000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fff533fce88 CR3: 000000010b644000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  evict+0x61e/0xb10 fs/inode.c:846
>  dispose_list fs/inode.c:888 [inline]
>  evict_inodes+0x75a/0x7f0 fs/inode.c:942
>  generic_shutdown_super+0xaa/0x2d0 fs/super.c:632
>  kill_block_super+0x44/0x90 fs/super.c:1725
>  ext4_kill_sb+0x68/0xb0 fs/ext4/super.c:7459
>  deactivate_locked_super+0xbc/0x130 fs/super.c:476
>  cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
>  do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb75539d9d7
> Code: a2 c7 05 1c ed 24 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 0=
9 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007ffe2e6b7108 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 00007fb755431f90 RCX: 00007fb75539d9d7
> RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe2e6b71c0
> RBP: 00007ffe2e6b71c0 R08: 00007ffe2e6b81c0 R09: 00000000ffffffff
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe2e6b8250
> R13: 00007fb755431f90 R14: 000000000000f951 R15: 00007ffe2e6b8290
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
> [adilger.kernel@dilger.ca jack@suse.cz linux-ext4@vger.kernel.org tytso@m=
it.edu yebin@huaweicloud.com]
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
-upstream-moderation/69a3a81a.050a0220.8405f.0000.GAE%40google.com.
