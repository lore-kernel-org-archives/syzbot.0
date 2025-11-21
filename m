Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7FF341066
	for <syzbot@lists.linux.dev>; Fri, 21 Nov 2025 09:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763716386; cv=none; b=sA7WZJvSkul9l/6lEDDJADTjUNBROA9zUesWv1Jt/hsND9Y0mnYrlddK2r5FvqYENp2lLJRd2d4gGialHL7IHfQn6V0C2qt7Ft0adh6lMpgKPLekR780k3DfrD5a+BvGvAnb2hTDXaRsSc7mxbqkiLfm/PvTHLrFtCCsvXaneds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763716386; c=relaxed/simple;
	bh=PvBhOtFHTDa8dFhI6PXi5SLESfr5mk8RcR4gBKcaDds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cuUTWqigAhjQfOM6p69TMNUjimpecL7fDYMJM1WZkNon54UG4l6+BW1mjL8AvTp9jCtZKW3GS6xmdrh2iMGTVxLfQHwP2ZMvCVFDQzTYkTdyc8XahpNtmzaXDMGFsb9+1XjYHNbAh0f0YF+rhUAb3rY1xnxb4ug1sxJ6tRIf76w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iHDiqh2N; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iHDiqh2N"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-65745a436e6so687057eaf.0
        for <syzbot@lists.linux.dev>; Fri, 21 Nov 2025 01:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763716383; x=1764321183; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKm7gToiWDKnGcPSdakw3WmgXCJQML2wU0ijGuTaRik=;
        b=iHDiqh2NooLRHVPTX0lRKsV0TrDm2yy6jyykpgKljMyM9sGRzoFp5csF5JB8uZBk4/
         fl8xGbjs+YYXaagkpSHctXPtC/xqhcYMXdAWAWg1y40BcMfAnuGNfnT4aouv4XssW+pT
         5KGcVKcOccLhoOlCF4empXhV8vETC/l/mME4oclk0xhe2MHGRZMHWXQ9I3U4q3/aVwr9
         o/IRIuWsVaqxbVKELRNo6ZAFpaforLfQdhmen9MU7D3i5ok069Ta1gzdwlzJRu13nsfH
         VGYc2KD4lDm5Mfjf2FgLh0Cvrkoo/tDOOxq0uwzedXOWG1ylkhlDF5fJgaHcrlMhawkW
         Eumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763716383; x=1764321183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tKm7gToiWDKnGcPSdakw3WmgXCJQML2wU0ijGuTaRik=;
        b=RVNUFD2Mh2V+L/avtCC9uLwsuo6HHxranlAZOHMaR9rq9rq1w4yFfTBfwCWclLZO0R
         mEjt2NptJoTr/3vioDRGQK9F+K/smw1A9BBIrc6av7vdyalzw4c57zJFqpDExN26qz2h
         4pBL5FUS8fhRYNuUk2Jk3X6T+Z3VopnxJ/TvwylwOQyER0pw5Vzok2PbAV4Ar9oXEeuU
         Q1TcFYN74Qz9dkg8okd+yT73XJwgyGBU4UwqDfO6+Ez0g2u8W4iXxwgJaEix9AZPHrn8
         BDB8+tnhuJwf3AggvSugrd5SIVYNwACnNCSIoatQtXaK+CPkWtdYsByjrfzgvkKJ0Feq
         XRWA==
X-Forwarded-Encrypted: i=1; AJvYcCUPXcqd+1FHqGOV8wbVnWGPaToixLAVryLkR9DRYgoYd5/3U3pUv0hRYBeMkFkxXEbL1m8fxmw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0LY/UtXPz3EXoJsZ6W5tuIAttsSLYI2i8pZ7Tq1d44R8SJ6Hl
	+ux3iFob6z6KLJeT2dOYfujwqyqT51x5h0YU1hHqDh/83FFznRrhq8nhczJKjndI5kdD30oV+96
	gSdhG5qecqYMYiN5LqLT/wxpPxxqnHqEiu38yjaXO
X-Gm-Gg: ASbGncut72xQ3QihCdyHUHf2Ijz/Vk91vKDLJfoatj8WqaE9PtHAXIQzJOP6zKwp3gj
	qReOSQnpc+LKk6/ErT/I/uAc/oSrru2OdDwBDeuhsWsqlKUG//mhnIMkH3JBGlDRshFkhQDy0FI
	9qX/EwjW8B+yZwrXjgepP0wmNjs6czTDzPGBpxvlqpGkWrC3QrqtZy6Axqz+0Hk9piYDmbh4QB8
	I2wfILtqSPRzsqk+AWAqfEMeua7t7+RULMIp7zgqMkE0YqYvkW4QR+JnDftGyzXbBCdMgorbRBN
	lsdCOfB71RWwW+tpb43IgfzMNBrg2Yon/tXi6QVMkZgOcXxQ77ctQdecPpawpG4U0av7
X-Google-Smtp-Source: AGHT+IE1fYnNdIm6iun/CRIu+v5svFEz9sWDZsXJheyQn4v52niloyY2gtKiz1hvQ0MzKjf0G09gTJdHV+k6uyhMCWU=
X-Received: by 2002:a05:6820:81c3:b0:657:48ac:99f4 with SMTP id
 006d021491bc7-65790a02601mr622716eaf.1.1763716383014; Fri, 21 Nov 2025
 01:13:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <691fe828.a70a0220.d98e3.003c.GAE@google.com>
In-Reply-To: <691fe828.a70a0220.d98e3.003c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 21 Nov 2025 10:12:51 +0100
X-Gm-Features: AWmQ_bnYHBONYUi1LJU-zaz1gjgkWOPoLERTK6eH5yNNFOUkHrDxuQUDItzm1W8
Message-ID: <CANp29Y7s+UfHm+vSiYD+1gmDZ90EXmuCQsfaQ8Pm3-8i-n0DWA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: fix unaligned preallocation with bigalloc
To: syzbot ci <syzbot+cie1c4a55027512f5e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Nov 21, 2025 at 5:18=E2=80=AFAM syzbot ci
<syzbot+cie1c4a55027512f5e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ext4: fix unaligned preallocation with bigalloc
> https://lore.kernel.org/all/20251121002209.416949-2-eraykrdg1@gmail.com
> * [PATCH] ext4: fix unaligned preallocation with bigalloc
>
> and found the following issue:
> kernel BUG in ext4_mb_new_inode_pa
>
> Full report is available here:
> https://ci.syzbot.org/series/5fbb06a2-0d5c-4936-94b6-d73abad55373
>
> ***
>
> kernel BUG in ext4_mb_new_inode_pa
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      23cb64fb76257309e396ea4cec8396d4a1dbae68
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/3beb0e0f-6449-481d-8a5c-870149d28=
caf/config
> C repro:   https://ci.syzbot.org/findings/891b93f7-ef7e-4890-8c4b-ed438fa=
3fa28/c_repro
> syz repro: https://ci.syzbot.org/findings/891b93f7-ef7e-4890-8c4b-ed438fa=
3fa28/syz_repro
>
> loop0: detected capacity change from 0 to 1024
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: none.
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/mballoc.c:5312!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 5990 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ext4_mb_new_inode_pa+0x144e/0x1520 fs/ext4/mballoc.c:5312
> Code: 5d 04 00 eb 2c e8 42 d8 43 ff 90 0f 0b e8 3a d8 43 ff 90 0f 0b e8 3=
2 d8 43 ff eb 3c e8 2b d8 43 ff 90 0f 0b e8 23 d8 43 ff 90 <0f> 0b e8 1b d8=
 43 ff 31 f6 65 ff 0d 82 24 f2 0f 0f 94 c3 40 0f 94
> RSP: 0018:ffffc900037c6a88 EFLAGS: 00010293
> RAX: ffffffff827c2b9d RBX: 0000000000000201 RCX: ffff8881ba628000
> RDX: 0000000000000000 RSI: 0000000000000201 RDI: 0000000000000210
> RBP: 0000000000000190 R08: ffffea000418ec37 R09: 1ffffd4000831d86
> R10: dffffc0000000000 R11: fffff94000831d87 R12: 0000000000000004
> R13: ffff88801b03f2b8 R14: dffffc0000000000 R15: 0000000000000210
> FS:  0000555557696500(0000) GS:ffff88818eb3b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2f863fff CR3: 000000016b520000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ext4_mb_try_best_found+0x33e/0x440 fs/ext4/mballoc.c:2389
>  ext4_mb_regular_allocator+0x9fa/0x2970 fs/ext4/mballoc.c:3040
>  ext4_mb_new_blocks+0xd11/0x4720 fs/ext4/mballoc.c:6319
>  ext4_ext_map_blocks+0x161a/0x6ac0 fs/ext4/extents.c:4383
>  ext4_map_create_blocks fs/ext4/inode.c:609 [inline]
>  ext4_map_blocks+0x860/0x1740 fs/ext4/inode.c:811
>  _ext4_get_block+0x200/0x4c0 fs/ext4/inode.c:910
>  ext4_get_block_unwritten+0x2e/0x100 fs/ext4/inode.c:943
>  ext4_block_write_begin+0x993/0x1710 fs/ext4/inode.c:1198
>  ext4_write_begin+0xc04/0x19a0 fs/ext4/ext4_jbd2.h:-1
>  ext4_da_write_begin+0x445/0xda0 fs/ext4/inode.c:3129
>  generic_perform_write+0x2c5/0x900 mm/filemap.c:4254
>  ext4_buffered_write_iter+0xce/0x3a0 fs/ext4/file.c:299
>  ext4_file_write_iter+0x298/0x1bc0 fs/ext4/file.c:-1
>  new_sync_write fs/read_write.c:593 [inline]
>  vfs_write+0x5c9/0xb30 fs/read_write.c:686
>  ksys_pwrite64 fs/read_write.c:793 [inline]
>  __do_sys_pwrite64 fs/read_write.c:801 [inline]
>  __se_sys_pwrite64 fs/read_write.c:798 [inline]
>  __x64_sys_pwrite64+0x193/0x220 fs/read_write.c:798
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3f2c38f6c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff15880d18 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
> RAX: ffffffffffffffda RBX: 00007f3f2c5e5fa0 RCX: 00007f3f2c38f6c9
> RDX: 0000000000000001 RSI: 00002000000005c0 RDI: 0000000000000004
> RBP: 00007f3f2c411f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000004fed0 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3f2c5e5fa0 R14: 00007f3f2c5e5fa0 R15: 0000000000000004
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ext4_mb_new_inode_pa+0x144e/0x1520 fs/ext4/mballoc.c:5312
> Code: 5d 04 00 eb 2c e8 42 d8 43 ff 90 0f 0b e8 3a d8 43 ff 90 0f 0b e8 3=
2 d8 43 ff eb 3c e8 2b d8 43 ff 90 0f 0b e8 23 d8 43 ff 90 <0f> 0b e8 1b d8=
 43 ff 31 f6 65 ff 0d 82 24 f2 0f 0f 94 c3 40 0f 94
> RSP: 0018:ffffc900037c6a88 EFLAGS: 00010293
> RAX: ffffffff827c2b9d RBX: 0000000000000201 RCX: ffff8881ba628000
> RDX: 0000000000000000 RSI: 0000000000000201 RDI: 0000000000000210
> RBP: 0000000000000190 R08: ffffea000418ec37 R09: 1ffffd4000831d86
> R10: dffffc0000000000 R11: fffff94000831d87 R12: 0000000000000004
> R13: ffff88801b03f2b8 R14: dffffc0000000000 R15: 0000000000000210
> FS:  0000555557696500(0000) GS:ffff88818eb3b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2f863fff CR3: 000000016b520000 CR4: 00000000000006f0
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
> [adilger.kernel@dilger.ca albinbabuvarghese20@gmail.com david.hunter.linu=
x@gmail.com eraykrdg1@gmail.com linux-ext4@vger.kernel.org linux-kernel@vge=
r.kernel.org skhan@linuxfoundation.org syzbot@syzkaller.appspotmail.com tyt=
so@mit.edu]
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
-upstream-moderation/691fe828.a70a0220.d98e3.003c.GAE%40google.com.
