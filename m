Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEBE1CDFCA
	for <syzbot@lists.linux.dev>; Thu, 11 Dec 2025 01:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765417431; cv=none; b=DbP9W6ZkPTjwYdkIcCjRuUBwQTI9qDOwj6sE5Fhx0FSPRfgbTiKzJuWlOkx+AalPwzlYlLf6XfjVqi99z3sjewe+xr5SHi/9TC0VGMRkMUPbuaYNMXx9LjbXty7N/zR+6dy7l9fO1KxaYHs5MTqm++Q4ajkzqn+L/nZ1ZaaqBBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765417431; c=relaxed/simple;
	bh=00BymItzPSjH+ayglS7Em1VZbBQE6Ue0yLRqOFwqPfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dfu0D2eKuuw38zCWXhopf7WC6Ugu2Iv9xQ4PVq+ZvVUqGEZglmEirKepqiBBqDOSEmwFCfj2Vcv9S+rzOzwsaSSVsta1OMjrGSnxM+j7DJSvKbskCMM91XQiJzwY4X+6ubmBqVGHSDZ9lq5MwUjAEfmpk+f8z1x7dCmFOG/Rjrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ow8nDwv4; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ow8nDwv4"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6598413b604so280692eaf.0
        for <syzbot@lists.linux.dev>; Wed, 10 Dec 2025 17:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765417429; x=1766022229; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usVNvbF78mYPCJAOY1p+t1U8h2A8WHnphge3ylH0syQ=;
        b=Ow8nDwv4SLBB5ykU2jyEBciU3EBqSS3tEAan2kkO4MRQJQwJlaJ3L6NxUar0YcZZ0p
         bvPzsDE6wUvrF4JU/q5Tn5T3iXUBrl5Gh8vbHWNaGHeAIDhTx9N4qtYJuiKT/qr81CUg
         3/cwDcxo0QB9SwyzxMTIBWG7R+NcWAMI+82Dpm8RAuDqoGOfV74o2wreOGDMoVdJpnwx
         TpNVQAvYjBoz8M4/CH+itqLOliRBnvnZyvvbmg8VWUuPlDqrgDNXXd1xcdMICwVLpG6C
         K2GNBpmOWdX4s+uodC9FvSrdFmzUONdL/9sSw6wteN+BIzE5Kdo9HllRcqMKGk+zQPqp
         yPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765417429; x=1766022229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=usVNvbF78mYPCJAOY1p+t1U8h2A8WHnphge3ylH0syQ=;
        b=EAssb/5ml9JvV8CAVZzx+ZMi7FTMPlKpmVeTUARkgUG3R8H21V86bhAdcc5L74a3fb
         HYyMb5zZR2r1PbLW4EAl3GcYuFX/E4QlNBQsk3EJhtBmlq2xAMimQefP0uKWTS9yvbTe
         el/GEtvXdsLcyvboUnChqlwq6fOCVP1a9dGiXQbwTEPcwVtL7HIurlpvrs59+eSpOXze
         Fyn3Ch+b+8Au4ldq8WXP2zPljQCStuMMTqlx0xFuj+2EwZFYsF+x10JaTeXGbj+snf3T
         3Pi+egbkmDZCzC90nQyYVcNRUr9M6twbrDtgZI4VIlDzOGFz38QRU3AHWvphvP+Idh1c
         Tiyw==
X-Forwarded-Encrypted: i=1; AJvYcCWy0FTh4vYVAW5qVXUFdA1UYudoDsgwRujttWgmIN9ZjmB4Jz3vK7hl+I9Te6m4onp7hDxwtxY=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywr4O7AsbR8A15OMD+E3Fo7QzNm/XgDssA4l1RYuUtT2jb32Ukw
	1B6D3Me/3+6Vde3J6aVGFLfYSVG93gUQstIydOlVNQtEkq0rQh+bFYgJ6HjkIbwtZXB3buH8Yqw
	AQnQEp637S0wsQtet4bTZ4qc1/5+oRkfbQVWdj8h1
X-Gm-Gg: ASbGncs6js2rCcpLiYWV1/WwfHX/nk67PKOrj/4YeFnTL2EqSWjDDje2t8x4QPqnKHu
	MGiX+ETUzMwrCIf37m/s4hrfmkSanrY/Iwc0nFcaquKh9XpPzslRJFnhLGngF1h6tD4f6S4JLNk
	1Cs49pE1rPIeP/dGbQjIR1ottPwqJwhRBNVliPu/xoYsFFbKKvLUdcKy7xMk5qRp0ZEOzpEz7/p
	Bi4Sz4vE7wAAWjWJjloxYENAIwSRs97YenpcRKVfsQwNGj+lx0G/nhO8gcRLcsmJ2rDe4rF62jz
	QEEJzYbyll61hFR/lPdZ4EMd0bY=
X-Google-Smtp-Source: AGHT+IFrpqMF07dMCnq/Cj1eGw9jAc86PB9zFx8g0BOjCdgzul//j5bJJ9npoSOK88t4BbyxzdA/b5DsP/3abbpABTw=
X-Received: by 2002:a05:6820:5056:b0:65b:33a3:7c8 with SMTP id
 006d021491bc7-65b33a3095cmr842087eaf.30.1765417428559; Wed, 10 Dec 2025
 17:43:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6939b1da.a70a0220.33cd7b.0014.GAE@google.com>
In-Reply-To: <6939b1da.a70a0220.33cd7b.0014.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 11 Dec 2025 10:43:37 +0900
X-Gm-Features: AQt7F2rTZko7-8RWoVdvaVzU-roGgUdGQECG0QxbkfyD9SBCeniXvYy25k6GaUo
Message-ID: <CANp29Y5w6hzdmE12=Qz1xF3jSgWavjZrv1r6Co6YNTxuDHpOWw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fs: warn on dirty inode in writeback paired
 with I_WILL_FREE
To: syzbot ci <syzbot+ci0a1fc2eeba2ece8e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Dec 11, 2025 at 2:46=E2=80=AFAM syzbot ci
<syzbot+ci0a1fc2eeba2ece8e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fs: warn on dirty inode in writeback paired with I_WILL_FREE
> https://lore.kernel.org/all/20251210134303.1310039-1-mjguzik@gmail.com
> * [PATCH] fs: warn on dirty inode in writeback paired with I_WILL_FREE
>
> and found the following issues:
> * SYZFAIL: failed to recv rpc
> * WARNING in writeback_single_inode
>
> Full report is available here:
> https://ci.syzbot.org/series/c3a011ac-952a-4fbf-867d-b7f98dcaaf3a
>
> ***
>
> SYZFAIL: failed to recv rpc
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      67a454e6b1c604555c04501c77b7fedc5d98a779
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/5b151469-2ba7-47b6-bf4b-00ea2f6df=
1d8/config
> C repro:   https://ci.syzbot.org/findings/9adaaed3-7016-4f9d-9b65-1a4aa9a=
7a127/c_repro
> syz repro: https://ci.syzbot.org/findings/9adaaed3-7016-4f9d-9b65-1a4aa9a=
7a127/syz_repro
>
> SYZFAIL: failed to recv rpc
>
>
> ***
>
> WARNING in writeback_single_inode
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      67a454e6b1c604555c04501c77b7fedc5d98a779
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/5b151469-2ba7-47b6-bf4b-00ea2f6df=
1d8/config
> C repro:   https://ci.syzbot.org/findings/6a7382a1-4230-4aa8-8594-a23b236=
5ee14/c_repro
> syz repro: https://ci.syzbot.org/findings/6a7382a1-4230-4aa8-8594-a23b236=
5ee14/syz_repro
>
> EXT4-fs error (device loop0): ext4_clear_blocks:876: inode #13: comm syz.=
0.17: attempt to clear invalid blocks 2 len 1
> EXT4-fs (loop0): Remounting filesystem read-only
> ------------[ cut here ]------------
> WARNING: fs/fs-writeback.c:1870 at writeback_single_inode+0xa39/0xe40 fs/=
fs-writeback.c:1870, CPU#1: syz.0.17/5986
> Modules linked in:
> CPU: 1 UID: 0 PID: 5986 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:writeback_single_inode+0xa39/0xe40 fs/fs-writeback.c:1870
> Code: 0f 0b 90 e9 25 f7 ff ff e8 64 8d 79 ff 90 0f 0b 90 e9 9c fb ff ff e=
8 56 8d 79 ff 90 0f 0b 90 e9 c1 fc ff ff e8 48 8d 79 ff 90 <0f> 0b 90 e9 54=
 fc ff ff e8 3a 8d 79 ff 90 0f 0b 90 e9 47 fd ff ff
> RSP: 0018:ffffc900037c7558 EFLAGS: 00010293
> RAX: ffffffff824823a8 RBX: dffffc0000000000 RCX: ffff8881113657c0
> RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000000
> RBP: ffff888108eb4068 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff520006f8e9c R12: ffff8881b1810d08
> R13: 0000000000000040 R14: ffff8881b1810c38 R15: 1ffff110363021a1
> FS:  00005555567e1500(0000) GS:ffff8882a9e44000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f67c0f73ea0 CR3: 000000017655e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  write_inode_now+0x160/0x1d0 fs/fs-writeback.c:2926
>  iput_final fs/inode.c:1941 [inline]
>  iput+0xa77/0x1030 fs/inode.c:2003
>  ext4_orphan_cleanup+0xc20/0x1460 fs/ext4/orphan.c:472
>  __ext4_fill_super fs/ext4/super.c:5658 [inline]
>  ext4_fill_super+0x58a1/0x6160 fs/ext4/super.c:5777
>  get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1751
>  fc_mount fs/namespace.c:1199 [inline]
>  do_new_mount_fc fs/namespace.c:3636 [inline]
>  do_new_mount+0x302/0xa10 fs/namespace.c:3712
>  do_mount fs/namespace.c:4035 [inline]
>  __do_sys_mount fs/namespace.c:4224 [inline]
>  __se_sys_mount+0x313/0x410 fs/namespace.c:4201
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f67c0f90f6a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 8=
4 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc812989c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffc81298a50 RCX: 00007f67c0f90f6a
> RDX: 0000200000000440 RSI: 0000200000000040 RDI: 00007ffc81298a10
> RBP: 0000200000000440 R08: 00007ffc81298a50 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000200000000040
> R13: 00007ffc81298a10 R14: 0000000000000450 R15: 000000000000002c
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
> [brauner@kernel.org jack@suse.cz linux-fsdevel@vger.kernel.org linux-kern=
el@vger.kernel.org mjguzik@gmail.com viro@zeniv.linux.org.uk]
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
-upstream-moderation/6939b1da.a70a0220.33cd7b.0014.GAE%40google.com.
