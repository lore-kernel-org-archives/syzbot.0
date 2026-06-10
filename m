Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B343815FD
	for <syzbot@lists.linux.dev>; Wed, 10 Jun 2026 08:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781078722; cv=pass; b=b1ijbIrumk4AB70Gu88LAYeN9KTsKSTN8wQ30SxlVt+tu9HH4wgTiI6SVn+0EVuQVv9y2JNUomO2bkXhNQ8M759tU6XXrPe5SRhMsBHScwPGa//imy3dZp3y+wTWk5m1DMtcNcsYozqnqzhhTrGYwrqIzFTkbg5e8KwmM3W+30g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781078722; c=relaxed/simple;
	bh=UZJU4lAPUAR4Uos8ldsksApGy1Z68VdbpYerKVt397o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lm/5V6RNvxU76LGVwdQKZ7dGCbYeo2SkzUrpWTx1VjwQZMZjJaaB31UO0wGNMM54j3FBrDCIesdxrTHZXHFbFJNAsRT0JGx7bDzBQi+QqY8DD0PH0Tc3CGVyjKD11GTT5Y3k601T94HI2ufFCszXvsBjhMIqNOIlr9W39Gc95eA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tw0Korsg; arc=pass smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tw0Korsg"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-69e66e11386so2465984eaf.3
        for <syzbot@lists.linux.dev>; Wed, 10 Jun 2026 01:05:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781078720; cv=none;
        d=google.com; s=arc-20240605;
        b=hLj+g2PWgj9RTdXuV1G+uu/dB8ic+iSqHjdswNsolDY3kRY777X9g9jl6e4uDJF/yz
         OE0b/8nltHO7X9CEcsT9PjIVSZ2PB8oc1yCN/WMz5fIcO6QMqt2L10e7P24fV6UV3OH0
         P9TgleaTDs9BCxGPLPPvE+AWZGsuV+DhzdoDqE0X/C31eUDoihBHhKAPdTP8kBD9H1sU
         0W2lpx5Gt+dzgvHEEAtXJF5GVrjin57LhgsrOxkxrQF5qm7xnngh5nuwydIhi70fcLNf
         nRZ1W9PA06nneiDVdXBhHfvF/5kWSwenjSU7umt56JVo2WEYhbySIWx+EjzA3hsNEFe7
         Uiiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z1iAB2kxBQdkluCserpo/wtWTA81cYywJVuveV2SI7A=;
        fh=LQ1vs/YPyRgabHX4K6e7yuFdeB7Y23teNh6+u/xKFk4=;
        b=feQpOWCMmAwL/ZlZ1rpOMgEMHefjhjauu/NlrZXa+wjjBRve1ACDtGWYZUTTzsuVd/
         38WsMLvMHkvss2uUvVwWQJkAZLz/j6FyBUhqsmNUv1+pClRGlDyNWR8yCy4TadzTB0Fn
         UCLS4j4Kx1y1NMsR52CUpBBQEnTBhiofEemCgW7j6Cggzh9U3qtm8iiaeH8ha+yQhlb4
         8c/v/RUSayYpi9vtLHuV+C/GBgFCc5f3s4CLvnLOqPHTZwzOjfZgEcTBW3gKj2rrOOCM
         GllYCxlm8dz5PcD/xWFrw4Ioe1DWvJakpeuHKrUtSjGJ5H+4unL8kZ18p7UoHigliCZu
         SQaw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781078720; x=1781683520; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1iAB2kxBQdkluCserpo/wtWTA81cYywJVuveV2SI7A=;
        b=Tw0Korsga3wVBF2v/mueOSN+buHFEyEbZUqC2A7BRjy95xONhaJEliSr7RVuFUUY/s
         6rpdG2qbS1bKuoxqRGv/cbBQCWr5C2TVfTXIcJfiide98Fm5T5Vgd73VxhBkt/gXeETI
         q1UD4ul2mVAY4LgAYKcIkeca/mydCn1TDe4rfuq4FeoxHuxWA3l+FvqawveRAHxWXLQU
         IzbM45dZ8yTEWItQyL7foqKHTtLNu1jfvcTOCWuAf7MvV2Jim7en63gAFR05WkTvKr8w
         yrAeApcHtXH8tCJ+noBsNxnZhQdTW8mXVX8HKhSl3FSlppjOu77EMZJ4tlUTkipVUUwm
         0v2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781078720; x=1781683520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z1iAB2kxBQdkluCserpo/wtWTA81cYywJVuveV2SI7A=;
        b=Vl1by4h2nMh+nCgedDIFfmkpHFy7qw+7rS3y4yJt/kvg8eW9jMqUIQBlXkkMEHQ2Y9
         c45jC+n4Y19XRbjAwFPsUGdks/w8TtcKWUOwjQ/nJ9akI3J3ritetlCJPktzbqGw08Fh
         ffScpX9nE9TTYFOq/kpiurx6ARSPCkgJmm5hWxOHLapIB5cdkP0mc2id4SAjZkrBlS8V
         0PqSH9Dm1nibX066mRYYRznUBVXGkk67cUJ3SGVOQTggWz0UIP8gbOqgw8JIPtKS9b4G
         CBwoHPhcmw47TMdwpaLEjV7+k7nZRVrQ8m1NnSCmuDbmUu0rdEQx++yKp1YuegPJX/9w
         z3Dg==
X-Forwarded-Encrypted: i=1; AFNElJ8ZcPZu13BGjytSRzCCY2eKWsR7loCr14Q43O2aW6pZhzYYqOE7hRizghXriOj5gXpHePmjtwU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTTtnngqyfbjj6vonSrEbIDVExm15ThGu+moDbtTMvuHaG1Wzl
	NOF2a4QVb0+rU2M4Me9kWO2zov9UWbZWpb6rAgZIV69L4M13K/3kz+cSMPoXXEheHirMldHW5Fx
	WLtLElKiG3hayUkML8NobL1CeuIPxh3KZqdZMtLTh
X-Gm-Gg: Acq92OGL7X9fdYRV+uECXtJBxdVPXmjD+MXbBZHCrvjt3NFzvg0STPOtil7+9t2ckzc
	tE43vdIH6d1S61wCaoIz0AjDrk3ThwFCjNcYckcQY5RTlFOQWoygMnnIFmE6sGDO1DrKgzCCDo1
	n9ItHYwCR8DKklef6cuZvH7CYG287rm/JqVRH/iYHQ1KpmT/5QXah8N62rgb2lQLPLwz3i9EHpX
	ZyPENuuptxqPKjnNt0WwiuZA2jyhcMGo9gWSfd/Y76QyfNUSHI9NFTbThd1e8TWbwXt0W3Erj45
	7pyyrBClw5EebgWHWxF1pE319RnnyPuEJ2tnejueXYyT4xcQHSMU3pfpi8VZLnfLnpC19TO4X1l
	7yCvn
X-Received: by 2002:a05:6820:168d:b0:69e:8a71:8a58 with SMTP id
 006d021491bc7-69e8a71b33bmr9633735eaf.41.1781078719124; Wed, 10 Jun 2026
 01:05:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a291329.39669fcc.33b062.00b7.GAE@google.com>
In-Reply-To: <6a291329.39669fcc.33b062.00b7.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 10 Jun 2026 10:05:07 +0200
X-Gm-Features: AVVi8Cf7_z_sYgjnlY24zDTD0u4JaYAMJrzA6HMMUzqK0rP3LbXKLYnotdXdgIs
Message-ID: <CANp29Y6tj_j-Q8aeLGXYC9axTm4-18wiThzotc5vktoHnckhRQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: move inline data cleanup to
 ext4_writepages to fix deadlock
To: syzbot ci <syzbot+ci721caf2cd61b2e01@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jun 10, 2026 at 9:33=E2=80=AFAM syzbot ci
<syzbot+ci721caf2cd61b2e01@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ext4: move inline data cleanup to ext4_writepages to fix deadlock
> https://lore.kernel.org/all/20260609154505.2104659-1-yun.zhou@windriver.c=
om
> * [PATCH] ext4: move inline data cleanup to ext4_writepages to fix deadlo=
ck
>
> and found the following issue:
> kernel BUG in ext4_writepages
>
> Full report is available here:
> https://ci.syzbot.org/series/1ede6029-df2a-4e08-bffc-05540c1f4934
>
> ***
>
> kernel BUG in ext4_writepages
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      2d3090a8aeb596a26935db0955d46c9a5db5c6ce
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/63ee0324-2d17-4b32-aca2-c6230ff64=
be6/config
> syz repro: https://ci.syzbot.org/findings/676a447c-ea73-43ea-9949-054dac1=
961e5/syz_repro
>
> EXT4-fs warning (device loop2): ext4_expand_extra_isize_ea:2860: Unable t=
o expand inode 15. Delete some EAs or run e2fsck.
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/inode.c:3047!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5875 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ext4_writepages+0x622/0x630 fs/ext4/inode.c:3046
> Code: ff e9 61 fc ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c de fc ff f=
f 4c 89 f7 e8 f9 2f a8 ff e9 d1 fc ff ff e8 ef d7 3c ff 90 <0f> 0b 66 66 66=
 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc900034df2e0 EFLAGS: 00010293
> RAX: ffffffff8288dfb1 RBX: 1ffff9200069be60 RCX: ffff888110555940
> RDX: 0000000000000000 RSI: 0000004000000000 RDI: 0000000000000000
> RBP: ffffc900034df410 R08: ffff8881b48c2f0f R09: 1ffff110369185e1
> R10: dffffc0000000000 R11: ffffed10369185e2 R12: dffffc0000000000
> R13: 0000004000000000 R14: 0000004610000000 R15: 1ffff11020c6fcc5
> FS:  00007f033e9346c0(0000) GS:ffff8882a92a0000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005556842f3058 CR3: 000000016d5c0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_writepages+0x32e/0x550 mm/page-writeback.c:2571
>  __writeback_single_inode+0x133/0x10e0 fs/fs-writeback.c:1764
>  writeback_single_inode+0x4ac/0xdc0 fs/fs-writeback.c:1883
>  write_inode_now+0x1c2/0x290 fs/fs-writeback.c:2974
>  iput_final fs/inode.c:1950 [inline]
>  iput+0x8c1/0xe80 fs/inode.c:2009
>  ext4_orphan_cleanup+0xc38/0x1470 fs/ext4/orphan.c:472
>  __ext4_fill_super fs/ext4/super.c:5701 [inline]
>  ext4_fill_super+0x5a19/0x6330 fs/ext4/super.c:5824
>  get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1754
>  fc_mount fs/namespace.c:1193 [inline]
>  do_new_mount_fc fs/namespace.c:3758 [inline]
>  do_new_mount+0x341/0xd30 fs/namespace.c:3834
>  do_mount fs/namespace.c:4167 [inline]
>  __do_sys_mount fs/namespace.c:4383 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f033d99e0ca
> Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 8=
4 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f033e933e58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f033e933ee0 RCX: 00007f033d99e0ca
> RDX: 0000200000000040 RSI: 00002000000016c0 RDI: 00007f033e933ea0
> RBP: 0000200000000040 R08: 00007f033e933ee0 R09: 000000000000840e
> R10: 000000000000840e R11: 0000000000000246 R12: 00002000000016c0
> R13: 00007f033e933ea0 R14: 000000000000042f R15: 0000200000000080
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ext4_writepages+0x622/0x630 fs/ext4/inode.c:3046
> Code: ff e9 61 fc ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c de fc ff f=
f 4c 89 f7 e8 f9 2f a8 ff e9 d1 fc ff ff e8 ef d7 3c ff 90 <0f> 0b 66 66 66=
 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc900034df2e0 EFLAGS: 00010293
> RAX: ffffffff8288dfb1 RBX: 1ffff9200069be60 RCX: ffff888110555940
> RDX: 0000000000000000 RSI: 0000004000000000 RDI: 0000000000000000
> RBP: ffffc900034df410 R08: ffff8881b48c2f0f R09: 1ffff110369185e1
> R10: dffffc0000000000 R11: ffffed10369185e2 R12: dffffc0000000000
> R13: 0000004000000000 R14: 0000004610000000 R15: 1ffff11020c6fcc5
> FS:  00007f033e9346c0(0000) GS:ffff8882a92a0000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005556842f3058 CR3: 000000016d5c0000 CR4: 00000000000006f0
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
> [adilger.kernel@dilger.ca daeho.jeong@samsung.com jack@suse.cz libaokun@l=
inux.alibaba.com linux-ext4@vger.kernel.org linux-kernel@vger.kernel.org oj=
aswin@linux.ibm.com ritesh.list@gmail.com tytso@mit.edu yi.zhang@huawei.com=
 yun.zhou@windriver.com]
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
-upstream-moderation/6a291329.39669fcc.33b062.00b7.GAE%40google.com.
