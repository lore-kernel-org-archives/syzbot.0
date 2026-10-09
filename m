Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D003CFF6F
	for <syzbot@lists.linux.dev>; Fri,  9 Oct 2026 17:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791568370; cv=pass; b=I5juD0c83zx/clNcG8aQrfQGwrDwnOjEyRsv+tmgZwEH0CsdG5hHPZVZ4B5D40l/KcHx6hDTIW1txxY60ISkupSUkx4goOqWHZJoBc3dCntWAJmKO/YAcEZVHP8Hl+K4gP3m5R6p2o7IppKEohcTbNhGvsJUAm7e2BExblk8pwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791568370; c=relaxed/simple;
	bh=nfbL8zkbk+WJnw7aAOIPMdrvdJOMD5EE0VbUS5Ma+Ws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jZcU5lM5ODvxArfNSVINF/xnNvPZxp8VViQszIIcRi8MyFjf/sBw+UZHgaAMRzVRpRBJENUP5gn8k4dHamo9/6S2jPSi01THE/XonRmF+1n6ujdwbsABredWKt+8G+aXXG3FEUex647wa/TC7TO31tj1KuCdPeaZcjiWTjLo2UU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jD9oLNVs; arc=pass smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jD9oLNVs"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-8245021651dso68479a34.0
        for <syzbot@lists.linux.dev>; Fri, 09 Oct 2026 10:52:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791568367; cv=none;
        d=google.com; s=arc-20260327;
        b=IsVVT1R516ta3EvF8OiV2FJSIXFC3OXDvnHmrK7kfwAgWYp9hSd8LpmQgs7eMqOMI0
         i/OoUauDz9sXq5C1AFB0F+sGPdbdPt+YDz+eYXD/u7+FQ9FscE2dvT0iuqifcKIuD9Li
         cbTgGOdJFRx9xAms2GS8cecjonXLkavCUm7FMPIv+7XIRn09ycXKPsR6CFjauMCkUH/S
         USUwXgmJXXo9JIwd6RuKeXMGe3aGs6EOAxf0CDPKWBWVMw0/dVvvfK37wXFT1d/Gdxgp
         QBKegOZWUFcMl3hFg8XO/k0jwXK8NJ/NK44BHwzuY5mqj1FI1DfHVF2v69fjLfkhSNKf
         UUwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1rAl3bI3nX0V6SfwbBwKDe+lCKn926qGG+84yDqeioM=;
        fh=5pXXflHysgkxa0MIUwgfQRishAD+8rvFi1cwKIJBnmA=;
        b=PvU6mupCVEOtrIDDq2IR/P3ZSNS0uEaDc+F6L7rD+lS7at92d8mIUYsOQD8xrwt1lv
         ZpPoLw85KBjo1+Hno5CWhfk6lHp4DeBzYX/fXcxN1Cn4LnMgtn6CgpxBJ68Y6r2f5vQK
         tqTWt151NB7m75V3oPiRnjbR4oYPPU3j87j9XCobh5V4fKHr7Yc1JwXOXkTa6FFFCFcA
         5Y+rQzF2ED8p/NXi11LRbyDuMOnXlmoaEs4qOASn9C/iH9m778XjxuxmgOrJqQJu0NMS
         Cgb1uD1tGvDPC2Gn4ScSes9IhYZNvg27zPPZW28aMw8eL+1eVuNQCBHUeG9E1ld8bnmX
         N3MQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791568367; x=1792173167; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1rAl3bI3nX0V6SfwbBwKDe+lCKn926qGG+84yDqeioM=;
        b=jD9oLNVsK8ZdoGRp0Zz/IB4ReHYC/7H+ti6cHJTIJ15qydFhJmya90qMRQIsNguX9i
         /rkBkEhGPrZdpgIodb1wDZmebvqyU2KuPyF4NUqPKeEddNSYwS/lvoOnc25rN/HyTekv
         VVxIdUYiYsC2Q8VLTInMibagB0SlDeil52rccAKKlYzNm1FtSBMZx4UBhgK3aEEOUUne
         XcLU+B/Mtml4Ty9Ssw6dpPIzluzki1g4oETSZlRIqwBOwcpVMDdW2AORf/7C2917jllr
         s84LE9PxV/pWTmSt2E2+UqQ63h6DIM+EgyvFYjBJu/H+9Wr77WQ0P75YEZWXUwRYaSxL
         t8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791568367; x=1792173167;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1rAl3bI3nX0V6SfwbBwKDe+lCKn926qGG+84yDqeioM=;
        b=HhspGV8TsXNRPSPAp0WnXNk4eOGnTh/T8/sH6CId4usoAWv7/hVsclssvHOzKFr3wc
         H7wzcgGj0RkM6UJVYeceDG6fGUBxHpNSLNLLfZEyW+zZQYGoJWI6VAuh7Nj+GzI6gXIm
         RCTNENg6yC5enIb1yAS/l1JybJNfX3fy+/uA9J+AFVp5+ipa8xcqWcMqPtinYV/thTEf
         gbZLNtTNkhUWhgKHMJqhzgIFrXqLAD7zN00GRhgL0PrMGfpHNUr8G302pbyvrYkiWq3o
         JSH5jy8yOEiAIAte6YrMYCgyLJpDWe5Qn2X7kOzzr58GYrlt9tdodiZdyZcJrHfW2Ge6
         pT6g==
X-Forwarded-Encrypted: i=1; AKwUvBxLzZVWQZ6dWRAogk/9z4K+pjQUw8zzoq/fqnvgbvgcQiBXOgM3MXA1F00pWzyqA6ZrJs4Cgxg=@lists.linux.dev
X-Gm-Message-State: AFuF++kHOFKQBHwSd4rt3M9Fq18xP3x6QvF0YDK3TO/KdIGI5HhUiOmZ
	8SHG6PsPjfcBxk3bWM0hwTzyvgAa1EswLofaZqoVgEU5JNS57ztrz1t/YBunukS9wiML/YvYDPt
	Klv3iIUi7fawPLbUNvdKJQCZBCoJ4YpUaAJAMDMHAOdcGGtsi2n5UUqzs
X-Gm-Gg: AYBFou0JqF9nUvChJJ0iCtFZyrxONKVK5ZfCb1yppe9pkve6zQjchz/3O9hZzLF5OPg
	xGJ7E/+GbTMEul3cth0RCNMuUSeybmxc3uHGn9oGMr2OXL+JP/quKg5Eie8y489aa3WAqWoPDFs
	0FFA+BZ7kI402rOUTvCP/6gaW9iYGiOV6DlqIKoqyQdRZGQ52SuM8QZdDJG238kcMNgz0EdlPK/
	dj+YBzsIDdCm606PaXW1MHemGULLqG1/I9L0NIHkU6Di05vomwu/Hmb2gQg26Ryo/RqdEJoQI6R
	gCIEo67taUCjCVROSvG5h425wQz0BGlXO8mOvS8Ta2l4X/5v9CiWT6813IRJwp26WWd9Hk2NGcE
	1VAsAJ7L7jDIUyKlxgBVh8pANUSGFJWwY04HQF9ir72KhhOVTRAlblumCCZBngYSQ2NACDpIYRJ
	zfMpUmzTMpD/WkAYyqcMijmsxNpQ==
X-Received: by 2002:a05:6808:17a1:b0:4ca:8d6f:4258 with SMTP id
 5614622812f47-50c5635486fmr2575748b6e.37.1791568366776; Fri, 09 Oct 2026
 10:52:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ac92631.70ed5d86.2ac85.0071.GAE@google.com>
In-Reply-To: <6ac92631.70ed5d86.2ac85.0071.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 9 Oct 2026 19:52:35 +0200
X-Gm-Features: AclHuK8u1gjGY2P1DWDfJAQuPiGsKdbxO4YGjgoebowo8WcdbAZCZWhHzDvfSUk
Message-ID: <CANp29Y5wcyF9rnoh75oE55RJH1iSU0cRHVSu_06C0d2vm3GO=Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: use iomap for regular file's buffered
 I/O path
To: syzbot ci <syzbot+ciffd583a12eb1575e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Oct 9, 2026 at 7:36=E2=80=AFPM syzbot ci
<syzbot+ciffd583a12eb1575e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v7] ext4: use iomap for regular file's buffered I/O path
> https://lore.kernel.org/all/20261009103033.2920530-1-yi.zhang@huaweicloud=
.com
> * [PATCH v7 01/31] ext4: simplify size updating in ext4_setattr()
> * [PATCH v7 02/31] ext4: factor out ext4_truncate_[up|down]()
> * [PATCH v7 03/31] ext4: set EXT4_MAP_NEW flag for delayed allocated bloc=
ks
> * [PATCH v7 04/31] ext4: recheck extent status tree before block allocati=
on
> * [PATCH v7 05/31] ext4: fix orig_mlen initialization in ext4_map_blocks(=
)
> * [PATCH v7 06/31] ext4: allow ext4_map_blocks() to start its own transac=
tion handle
> * [PATCH v7 07/31] ext4: avoid unnecessary transaction in ext4_map_blocks=
() for unwritten extents
> * [PATCH v7 08/31] ext4: skip block allocation for holes in the data subm=
ission path
> * [PATCH v7 09/31] ext4: add iomap address space operations for buffered =
I/O
> * [PATCH v7 10/31] ext4: implement buffered read path using iomap
> * [PATCH v7 11/31] ext4: pass out extent seq counter when mapping da bloc=
ks
> * [PATCH v7 12/31] ext4: do not use data=3Dordered mode for inodes using =
buffered iomap path
> * [PATCH v7 13/31] ext4: implement buffered write path using iomap
> * [PATCH v7 14/31] ext4: rework handle credit accounting for unwritten ex=
tent conversion
> * [PATCH v7 15/31] ext4: implement writeback path using iomap
> * [PATCH v7 16/31] ext4: implement mmap path using iomap
> * [PATCH v7 17/31] ext4: implement partial block zero range path using io=
map
> * [PATCH v7 18/31] ext4: drain writeback before removing extents on the i=
omap path
> * [PATCH v7 19/31] ext4: add block mapping tracepoints for iomap buffered=
 I/O path
> * [PATCH v7 20/31] ext4: disable online defrag when inode using iomap buf=
fered I/O path
> * [PATCH v7 21/31] ext4: add EXT4_STATE_DISKSIZE_GROW_PENDING state bit a=
nd helpers
> * [PATCH v7 22/31] ext4: submit and wait for pending disksize-grow I/O on=
 writeback
> * [PATCH v7 23/31] ext4: advance i_disksize to i_size upon disksize-grow =
I/O completion
> * [PATCH v7 24/31] ext4: defer i_disksize update while DISKSIZE_GROW_PEND=
ING is set
> * [PATCH v7 25/31] ext4: submit and wait for disksize-grow I/O in falloca=
te paths
> * [PATCH v7 26/31] ext4: clear DISKSIZE_GROW_PENDING on truncate or error
> * [PATCH v7 27/31] ext4: set DISKSIZE_GROW_PENDING after zeroing unaligne=
d EOF block
> * [PATCH v7 28/31] ext4: add tracepoints for DISKSIZE_GROW_PENDING set, c=
lear, and wait
> * [PATCH v7 29/31] ext4: add tracepoints for EOF block zeroing and disksi=
ze-grow I/O
> * [PATCH v7 30/31] ext4: partially enable iomap for the buffered I/O path=
 of regular files
> * [PATCH v7 31/31] ext4: introduce a mount option for iomap buffered I/O =
path
>
> and found the following issue:
> WARNING in ext4_do_writepages
>
> Full report is available here:
> https://ci.syzbot.org/series/3711c951-acf4-4ebe-a920-9cc89b6be2ff
>
> ***
>
> WARNING in ext4_do_writepages
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      3d399224425573875b6f6f1181bd8cf9a28cc7d1
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/c3c01f8c-846d-4c7a-955a-fd7427af6=
b0d/config
> AI triage: https://ci.syzbot.org/findings/154c3452-1386-4dfb-af0a-4d05325=
8470f/triage_trajectory
>
> ------------[ cut here ]------------
> !err
> WARNING: fs/ext4/inode.c:2512 at ext4_do_writepages+0x33b3/0x44a0, CPU#0:=
 kworker/u9:3/147
> Modules linked in:
> CPU: 0 UID: 0 PID: 147 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: writeback wb_workfn (flush-7:1)
> RIP: 0010:ext4_do_writepages+0x33b3/0x44a0
> Code: 0f 0b 90 e9 b6 d9 ff ff e8 6a e2 36 ff 90 0f 0b 90 e9 e6 dc ff ff e=
8 5c e2 36 ff 90 0f 0b 90 e9 94 df ff ff e8 4e e2 36 ff 90 <0f> 0b 90 bb ea=
 ff ff ff e9 ae f8 ff ff e8 3b e2 36 ff 48 8d 3d 64
> RSP: 0018:ffffc90003106ce0 EFLAGS: 00010293
> RAX: ffffffff8290e912 RBX: 0000000000000000 RCX: ffff8881053f9e00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc900031070f0 R08: ffff888025da4a37 R09: 1ffff11004bb4946
> R10: dffffc0000000000 R11: ffffed1004bb4947 R12: ffffc900031071a0
> R13: dffffc0000000000 R14: 0000000000000000 R15: 1ffff11004bb495d
> FS:  0000000000000000(0000) GS:ffff88818d6c9000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005555565a5a28 CR3: 0000000031f66000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ext4_writepages+0x241/0x3b0
>  do_writepages+0x338/0x560
>  __writeback_single_inode+0x136/0x1220
>  writeback_sb_inodes+0x9de/0x1b00
>  wb_writeback+0x41c/0xad0
>  wb_workfn+0x431/0x10f0
>  process_scheduled_works+0xc3d/0x1630
>  worker_thread+0xa47/0xfb0
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
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
> [adilger.kernel@dilger.ca chengzhihao1@huawei.com djwong@kernel.org hch@i=
nfradead.org jack@suse.cz libaokun@linux.alibaba.com linux-ext4@vger.kernel=
.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org ojaswin@lin=
ux.ibm.com ritesh.list@gmail.com tytso@mit.edu wangkefeng.wang@huawei.com y=
angerkun@huawei.com yi.zhang@huawei.com yi.zhang@huaweicloud.com yizhang089=
@gmail.com yukuai@fnnas.com]
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
-upstream-moderation/6ac92631.70ed5d86.2ac85.0071.GAE%40google.com.
