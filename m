Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BFE3290CA
	for <syzbot@lists.linux.dev>; Fri, 27 Feb 2026 07:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772178648; cv=pass; b=fQrJcFPDpfFTaLdCH+iu6ShGCjCzYEtXTQFTV4zVul/uKC4OsmmpSuGmhYFZNVkYATjsBv05q4+Ol2NVJ81BwWf5QImaGDSUq2ElK2XioD5nZmlz1+ZzJoP1IoHpDD0cYYHfvXG1LsqnAnpzf89F9wmhdQtDpTOkSxAY0mf750I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772178648; c=relaxed/simple;
	bh=OAHm8fv6l53YMIDS+0NZRwMiRKCWETA0Ly0PN/LqcQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ualbE/Iwk3CdnQErImXXh7M9irCiSxcs7IHv4Cf9LpfcRjYeByEyGpCVaKGTkbjisGIlEUGNo5JQLXOyukwVFmYC+28psXtWYQD21cy4GtgfWGS3XdnxS/JF20TAOiahko0ddjU5YzfvHZ/YN7XzpGPxQg+dTxn+SAwK8cOgM1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TBtpEjOR; arc=pass smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TBtpEjOR"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d18d0e6d71so1379173a34.1
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 23:50:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772178645; cv=none;
        d=google.com; s=arc-20240605;
        b=SVMxqIwMNAwgCgPw5RLHHLRjua8/whqJGlZZBL6/3yFGBQHviRYetx0n/XdMzxJTQ3
         y0CIWObTRGiepzQtcjSot+BAvx0egeaKXwjYO8uy5tpop38Kqmh0fuf7cZf/Vc4zpZYW
         sLCwPIO4gXRijWnGJlyUx15krNdo88fLTVNnDyZtZfld8OcUVpDHOCzNrQZ43mFcXDZS
         Y5NhOju1gfO4kcOK8i+D/Nf/Skm04oaIO6xnch7troz6aB7HYwSV71QE1BDkCVNY1FeO
         N4AFfGuVY8ruNBb3uhwBdHIEdf1TbpnKhFy9TadNSAE8pBwqL2Unoh/Ooilay8DXSoTC
         izow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pmAlur92OkM9uwEhWs4JqLLaeFTFC/t0oCLyKd4Lhpk=;
        fh=GdWXRo9TNxU0hMklZnDcOQt2ZZgBwPlZx4PnXu1huA8=;
        b=Fc1tdTCkDD5JcXXPNAQnJ0t7pZI64SpnFpiiU9OsAkq3Yu9NuN+yOXVpbehWcvCEZw
         /31eoz9zJeVBR/coW5/eWsMQGDM2fxMMFVYI2t9HhD6TqxZ1w3dmoLwOZjoDdzL7Z6Yy
         9IOpnwf7wgCX/gx7c/dom7pikM4V1P1GVNyl4v0+5Vbdcsgj1jc2nXF7t/EHG1IxxdrR
         yt/KeVanYNfPdRYIA8vjpM1ob0rMdY14hHvmVRQmhoVBrfGY7e2WQ6znv3/vW85SjosS
         EsuZ1ngerPkDRVxai/jmS8mFjv/YU1SUK/DkReTo/uzWJT+ElwpaO3duHVQEBMF1J2vg
         KWPQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772178645; x=1772783445; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pmAlur92OkM9uwEhWs4JqLLaeFTFC/t0oCLyKd4Lhpk=;
        b=TBtpEjORntKjvkx6eGupRzM95OsyxqP3G1Ij+FYpDzLQkIGv1VxGbdvskTiK/81MN+
         vmwAy12P4QVpxH3GAwMZduqvvxPpz6MM2Q/LZRLiOMySpOmD9KCKEtsNhOCrYGDOMmMk
         zGJTvuQaZLgzDwjmkwHNT0zEC1IxTxlZG5wtCwcxAwz8vw0zo0CxF4vsAfpGRt7A9IQI
         NdXC2ZB6fVqaYKlBOabIdo7/NOAfqXwcC09u7Ah2XdSaBtf8Hp5FLjTesXDwzg30c1XC
         jEG8P97Qo6uTJjLnGfpMxt5T10A/4wtgmokj9pNwDVkB94gjFaJQG/IuOCWY8/cd2oKj
         F5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772178645; x=1772783445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pmAlur92OkM9uwEhWs4JqLLaeFTFC/t0oCLyKd4Lhpk=;
        b=mtgzdKn7Pe9lrxcVQN9Z6bcT20U05/52w0xDBM/MtDPL9DK6Q3AEVxK7rSBlEscNyV
         Ca0CKPVNPtzYE9wK8ckQmjSaD3Ipg/lam2yhOBiNhSOm8P9OgCSU+sEqlxLNKIQipUyj
         Ac6b78u/tnPgRCVE7kSKTvYmTPIpaBJhigxvwEqmjh9RJRCFQ6nmmsT/O7Ncgch9TV9F
         dxyS8EViQU8OFF+KDtGm9nQwhXPn+BJcED9hoiCE1AG0cbzw2zlAqejJW2iedsjhvWyu
         0JKNN2Bepi3Mre7BUgK29aarxYv2Lt/9nMskKnrcJXf1Y50AQ+RNx6/gZRpsFb6XceLW
         esJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVY+93GH3YcWkdBGPZzMPQzhF1z1xNYMt2CjKgRUCvBo4BNf+JVHdoLKxnnCplY1IlnGMkQCpg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzfud9JTxQ3xZLRblubUgmMGHSiLd/OB7Zi0o4P6ARp957D3+ea
	OszLyQIUFqMKzQQ8Iq4AChnr9lts9hIdeS3P+kRgzVRcVH7VTik4os4xCavhrFNTaa1rDtr0aT0
	s1cTweBTEtMKHtFEx1iYCTRi7m1vkHoYsVKUHC+Cu
X-Gm-Gg: ATEYQzz3cg/Cv2chmNtaEaYTknwgAgGV/qy++l6BhjZ+I4EWCVw9eoVGtZ0G9H9AfRF
	GkHL0eXshD+hYXLOk7PXqssPDnoahOOv4SL7qgsvMWQVTsGGN4mJXY7PSValXDXG/tQTijQ6t0f
	D2wWNgrlJedr6JtGRWYnKelb7Sy+aubA2FtthIMgCDTA06GYPNQ1CqNmldXoj2USRDTVymgqJlU
	XPK2WP91wozNKBocRWGxbCl4sBCLZrVEsawfDAdp0XlsvF9xO9mLdyU7sepFXAmrrvgN4froJg6
	Nhy7bNE8pO2RVw485FBgVuf3mKOQiJeqf2FW58p5wtrTXhDAN71QsQyG6A3JD9l6+yLCPoTe
X-Received: by 2002:a05:6820:4b91:b0:662:c0f7:bee1 with SMTP id
 006d021491bc7-679fae72b16mr1217391eaf.26.1772178644946; Thu, 26 Feb 2026
 23:50:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69a11cc2.050a0220.3a55be.0010.GAE@google.com>
In-Reply-To: <69a11cc2.050a0220.3a55be.0010.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 27 Feb 2026 08:50:33 +0100
X-Gm-Features: AaiRm52ZQ1rbeEVcjVlWr9OA1i7bJElh7hQrkLvWNGNB35L27OFj0lP4yQGXVW8
Message-ID: <CANp29Y5fs6PM3LPej455i7o7y9kocvjdijhnzTAkV5BVbfi1Pw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: test if inode's all dirty pages are
 submitted to disk
To: syzbot ci <syzbot+ci92a34e6b917e60e2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Feb 27, 2026 at 5:25=E2=80=AFAM syzbot ci
<syzbot+ci92a34e6b917e60e2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ext4: test if inode's all dirty pages are submitted to disk
> https://lore.kernel.org/all/20260226110718.1904825-1-yebin@huaweicloud.co=
m
> * [PATCH] ext4: test if inode's all dirty pages are submitted to disk
>
> and found the following issue:
> WARNING in ext4_evict_inode
>
> Full report is available here:
> https://ci.syzbot.org/series/8f9434e5-a73c-4b31-be9f-e9b76f1c2596
>
> ***
>
> WARNING in ext4_evict_inode
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      f4d0ec0aa20d49f09dc01d82894ce80d72de0560
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7053c6f2-2ee6-4a1d-9f74-d2f56facd=
9f9/config
> C repro:   https://ci.syzbot.org/findings/4f7c2b91-8121-443d-9a4f-991feda=
8057c/c_repro
> syz repro: https://ci.syzbot.org/findings/4f7c2b91-8121-443d-9a4f-991feda=
8057c/syz_repro
>
> ------------[ cut here ]------------
> mapping_tagged(&inode->i_data, PAGECACHE_TAG_DIRTY)
> WARNING: fs/ext4/inode.c:191 at ext4_evict_inode+0xbdc/0xf10 fs/ext4/inod=
e.c:191, CPU#1: syz-executor/5915
> Modules linked in:
> CPU: 1 UID: 0 PID: 5915 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ext4_evict_inode+0xbdc/0xf10 fs/ext4/inode.c:191
> Code: ba 2c 02 00 48 8b bc 24 a0 00 00 00 e8 bd 49 14 00 e9 71 fe ff ff e=
8 43 63 40 ff 90 0f 0b 90 e9 e6 f4 ff ff e8 35 63 40 ff 90 <0f> 0b 90 e9 f2=
 f5 ff ff e8 27 63 40 ff 48 8d 3d 50 df 92 0d 67 48
> RSP: 0018:ffffc900048b79a0 EFLAGS: 00010293
> RAX: ffffffff8285287b RBX: ffff88811d980298 RCX: ffff8881027d8000
> RDX: 0000000000000000 RSI: 0000000004000000 RDI: 0000000000000000
> RBP: ffffc900048b7ab0 R08: ffffffff901181b7 R09: 1ffffffff2023036
> R10: dffffc0000000000 R11: fffffbfff2023037 R12: 1ffff92000916f44
> R13: dffffc0000000000 R14: ffff88811d9804b8 R15: 0000000004000000
> FS:  000055557d541500(0000) GS:ffff8882a9464000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c00003e720 CR3: 000000010f9d2000 CR4: 00000000000006f0
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
> RIP: 0033:0x7fcf3c79d897
> Code: a2 c7 05 5c ee 24 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 0=
9 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007ffe2362cef8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 00007fcf3c831ef0 RCX: 00007fcf3c79d897
> RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe2362cfb0
> RBP: 00007ffe2362cfb0 R08: 00007ffe2362dfb0 R09: 00000000ffffffff
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe2362e040
> R13: 00007fcf3c831ef0 R14: 000000000000f11c R15: 00007ffe2362e080
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
-upstream-moderation/69a11cc2.050a0220.3a55be.0010.GAE%40google.com.
