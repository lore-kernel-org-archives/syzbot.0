Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4741F09AC
	for <syzbot@lists.linux.dev>; Sat, 22 Nov 2025 08:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763801598; cv=none; b=tdpZVwKAsJ2ol+ySr2zpTMzFxwQCChM7+NQptT0gKM15kkP8yZs+RdRUi0F1EWy68BYncHrqOAjA0dL3SB64k2tLVJ4nXcgXO8I5REDMtYcZQ7zqnPjw402lQpLExgSqE6rhm1hRFNxS0JZqiz1Rpkxd1FONv19zrGfugpzWu1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763801598; c=relaxed/simple;
	bh=5zKC06KWUgid7SZVYDlOBvk3MOGSTZYOttsBtolycX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RJ/9DVrVM/lRo6RzOksvGddaYMMi7RZJBYt4XL69E2uf4ABQVRc09oqNq6gpGnpZdKF59TGOMnMc9l4ksWGVn/KV1rQzdaufuIBfgfTUj1i7pfORY1J77OV1CNhP8UrXOvmNT+1c4AvIgSrXCYWCbZ68TYVJc+6+R8HcXhEEFBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1cU0yCDh; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1cU0yCDh"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7c750b10e14so944066a34.2
        for <syzbot@lists.linux.dev>; Sat, 22 Nov 2025 00:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763801595; x=1764406395; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XItUb0hOFmzfATPtcSQZKnDyhNDLtq6LrQnr1sui32Q=;
        b=1cU0yCDhHmBtQ5UosuihcFx1yEt91DQBNQWg1WqS3vRWLXGkWps9OYYLZEwHC+2L/w
         M/AfL/IJ/YUO16cycZeOEshYKZqp7OX6qNSJjSIwLQe6N1BqS1cD5jyGXJGOSgfa7eyg
         /mMgq3ms3G8TxJdHlvtpgBQCXTYZQNAiUTHjQ+wbGEsnLEN4mulmWiwDpWXYOkAPfiIu
         2FhZK6Zt3cEXPhMS1JaTEiW5R+eVvNrVAbZNu+RcKzn20H13kbfHqDIY97Qn8Bko2ji2
         E4xsEURtMewsDyZ+6QJSglzJqG5YYJKTKGixNHqsbMTsj71igsvZNoMEFnDI0rdAEfm9
         XtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763801595; x=1764406395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XItUb0hOFmzfATPtcSQZKnDyhNDLtq6LrQnr1sui32Q=;
        b=vTmScFQg/XwoaPVqnULPnPOZnR8MXsebf3fL9zNS1VuUzcS0m7ajk2iJhwzF6IQJOl
         oYxACUoh5pHNRVwbeULMwJmfJdffHQZjQfqNOmpXAJ4SP2nkOeSBCCS1ENh6WcKfh7TA
         r/kCBd2UydFM17cghskquFZQrITLaeg0HNtdt9xzxkcN6q6rYfXsB49o3eqL+yZV/Q+a
         kMyhD3nd8ABJn0QkBAIe/HjyPRwWx8yR6hAZzmgbaRVIBwCHoiZau2WKOaQyy4DRClQp
         CV1JdFeaxFYozq2R4Y29XyJUD0fwTQ0dUKAd65K18K1+IEcL+rDym7HaG0cOVxpm4dhe
         sjPw==
X-Forwarded-Encrypted: i=1; AJvYcCW0p4fnRusFi/EEyoPVU6b7/9/LPTXgxnwrPgsqp3xkiBk/hk+91E9FQPCRAeywwtu6wroFyaY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxAeBLCPx2/54NAtZSBRUzmJVo7o0NpPjd946x8YPT5kYXO3uu
	RUvNikxuXH3DDR4XrdV9VFXEo7E9RhU7yoTPLh96QzDAjvgdWhxlkh5EwsQybiRjAV58Vx++6zN
	cNV4lwvJUb1QoS0b9NwnoJPQGqN1M4awZ+zpTNps1
X-Gm-Gg: ASbGnct308IvDypDpMGhNpDf5ObdisX52MEb8fj1WJU+qfi1+zHp/uPJ/nqaPXTc+kG
	+RNkrtkXiCCrNK2tOaqDE7Xb8Env0XCiBSKNwagFn79j6ji9Vaaxne7MQpFdmexs/lek0gl1ttI
	YGbcHKcNYWvldwdx46DZ7gRifPGbu4GRPUBWFpqKFg4PUzKF4shS4AD0Y4+Tl0x6jlWi6SHvmDL
	WH0nUf+bHdbu6v/blNw6UIhncOP1fsr4fTKURRoYOVAeMJ/dhxnwYkkW3A/FNL4R8EDOjA1owCZ
	NmG8SwMDCmMnSQTyqA4+GnkEwSRxfkAQCYp61cEWfSkyMMCatgiPoAMjlhlk
X-Google-Smtp-Source: AGHT+IEk+Y3u4lueJLxkwmqC61fv31Ocg6dpL8iKpZ3K0bCJhAyN/taQqt+VFmns2FFc62s+Tw+Vssm/wVADzy+4Xtc=
X-Received: by 2002:a05:6808:2e48:b0:451:551:c0b with SMTP id
 5614622812f47-4511294e7c4mr1707616b6e.8.1763801594719; Sat, 22 Nov 2025
 00:53:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69217121.a70a0220.2ea503.0066.GAE@google.com>
In-Reply-To: <69217121.a70a0220.2ea503.0066.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 22 Nov 2025 09:53:02 +0100
X-Gm-Features: AWmQ_bmE6T635XwpNwo3ZkdEDJxhlXBfeJoPUPCnKMR_Avcr8v8-Qa_cq2ZWT_0
Message-ID: <CANp29Y7MfpEqaOiFprWYSDiHuAF_0AHBtA_ZYtUL+nXY8dUJQA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: fix unaligned preallocation with bigalloc
To: syzbot ci <syzbot+ci0809eb078654ccec@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Nov 22, 2025 at 9:15=E2=80=AFAM syzbot ci
<syzbot+ci0809eb078654ccec@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] ext4: fix unaligned preallocation with bigalloc
> https://lore.kernel.org/all/20251122024555.140798-2-eraykrdg1@gmail.com
> * [PATCH v2] ext4: fix unaligned preallocation with bigalloc
>
> and found the following issues:
> * WARNING in ext4_mb_complex_scan_group
> * WARNING in mb_update_avg_fragment_size
>
> Full report is available here:
> https://ci.syzbot.org/series/ba644d0c-b0cd-47e5-aac4-5bc33f8d2823
>
> ***
>
> WARNING in ext4_mb_complex_scan_group
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      23cb64fb76257309e396ea4cec8396d4a1dbae68
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/3d0f1523-91b4-4aa0-b4ec-0f13803a4=
e4e/config
> C repro:   https://ci.syzbot.org/findings/d24ca945-6ee1-4b64-827e-93a61ab=
96735/c_repro
> syz repro: https://ci.syzbot.org/findings/d24ca945-6ee1-4b64-827e-93a61ab=
96735/syz_repro
>
> EXT4-fs: Ignoring removed bh option
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: writeback.
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5962 at fs/ext4/mballoc.c:2531 ext4_mb_complex_scan_=
group+0xd64/0xf30 fs/ext4/mballoc.c:2531
> Modules linked in:
> CPU: 1 UID: 0 PID: 5962 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ext4_mb_complex_scan_group+0xd64/0xf30 fs/ext4/mballoc.c:2531
> Code: 81 c4 c8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d e9 01 f8 cc 08 cc e=
8 1b 97 43 ff 90 0f 0b 90 e9 3d fe ff ff e8 0d 97 43 ff 90 <0f> 0b 65 48 8b=
 05 62 e3 f1 0f 48 3b 84 24 c0 00 00 00 75 20 90 eb
> RSP: 0018:ffffc90003c069c8 EFLAGS: 00010293
> RAX: ffffffff827c6cb3 RBX: 00000000fffffff8 RCX: ffff888114d61d00
> RDX: 0000000000000000 RSI: 00000000fffffff8 RDI: 0000000000000001
> RBP: ffff88816ef5b000 R08: ffff888114d61d00 R09: 0000000000000005
> R10: 0000000000000004 R11: 0000000000000000 R12: ffff888166fec000
> R13: ffff888166fec638 R14: ffff8881b7ac0000 R15: dffffc0000000000
> FS:  0000555585e78500(0000) GS:ffff8882a9f3b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2ec63fff CR3: 000000011407a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __ext4_mb_scan_group fs/ext4/mballoc.c:2664 [inline]
>  ext4_mb_scan_group+0x116e/0x18e0 fs/ext4/mballoc.c:2955
>  ext4_mb_scan_groups_linear+0xe8/0x360 fs/ext4/mballoc.c:1146
>  ext4_mb_scan_groups fs/ext4/mballoc.c:1180 [inline]
>  ext4_mb_regular_allocator+0x90e/0x2970 fs/ext4/mballoc.c:3026
>  ext4_mb_new_blocks+0xd11/0x4720 fs/ext4/mballoc.c:6320
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
>  ksys_write+0x145/0x250 fs/read_write.c:738
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3f93f8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff83277a88 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f3f941e5fa0 RCX: 00007f3f93f8f749
> RDX: 0000000000001006 RSI: 0000200000000940 RDI: 0000000000000005
> RBP: 00007f3f94013f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3f941e5fa0 R14: 00007f3f941e5fa0 R15: 0000000000000003
>  </TASK>
>
>
> ***
>
> WARNING in mb_update_avg_fragment_size
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      23cb64fb76257309e396ea4cec8396d4a1dbae68
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/3d0f1523-91b4-4aa0-b4ec-0f13803a4=
e4e/config
> C repro:   https://ci.syzbot.org/findings/4f77b4c9-f795-4c41-ad77-5c5a174=
be3a1/c_repro
> syz repro: https://ci.syzbot.org/findings/4f77b4c9-f795-4c41-ad77-5c5a174=
be3a1/syz_repro
>
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: writeback.
> EXT4-fs: Ignoring removed orlov option
> EXT4-fs (loop0): can't enable nombcache during remount
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5969 at fs/ext4/mballoc.c:839 mb_avg_fragment_size_o=
rder fs/ext4/mballoc.c:839 [inline]
> WARNING: CPU: 1 PID: 5969 at fs/ext4/mballoc.c:839 mb_update_avg_fragment=
_size+0x304/0x450 fs/ext4/mballoc.c:856
> Modules linked in:
> CPU: 1 UID: 0 PID: 5969 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:mb_avg_fragment_size_order fs/ext4/mballoc.c:839 [inline]
> RIP: 0010:mb_update_avg_fragment_size+0x304/0x450 fs/ext4/mballoc.c:856
> Code: 5d 41 5e 41 5f 5d e9 1b 6a cd 08 e8 96 57 44 ff 48 83 c4 28 5b 41 5=
c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 7d 57 44 ff 90 <0f> 0b 90 48 bb=
 00 00 00 00 00 fc ff df 41 0f b6 44 1d 00 84 c0 0f
> RSP: 0018:ffffc90003a56f48 EFLAGS: 00010293
> RAX: ffffffff827bac43 RBX: 000000000000000d RCX: ffff8881037ad700
> RDX: 0000000000000000 RSI: 000000000000000c RDI: 000000000000001e
> RBP: 000000000000001e R08: ffff8881a9014007 R09: 1ffff11035202800
> R10: dffffc0000000000 R11: ffffed1035202801 R12: ffff88810b77e014
> R13: 1ffff110216efc02 R14: 000000000000001f R15: 000000000000000c
> FS:  000055557ed08500(0000) GS:ffff8882a9f3b000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9c75c3f000 CR3: 0000000112a5a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  mb_mark_used+0xfd8/0x12f0 fs/ext4/mballoc.c:2195
>  ext4_mb_use_best_found+0x192/0x7e0 fs/ext4/mballoc.c:2216
>  ext4_mb_check_limits fs/ext4/mballoc.c:2280 [inline]
>  ext4_mb_complex_scan_group+0xd27/0xf30 fs/ext4/mballoc.c:2596
>  __ext4_mb_scan_group fs/ext4/mballoc.c:2664 [inline]
>  ext4_mb_scan_group+0x116e/0x18e0 fs/ext4/mballoc.c:2955
>  ext4_mb_scan_groups_linear+0xe8/0x360 fs/ext4/mballoc.c:1146
>  ext4_mb_scan_groups fs/ext4/mballoc.c:1180 [inline]
>  ext4_mb_regular_allocator+0x90e/0x2970 fs/ext4/mballoc.c:3026
>  ext4_mb_new_blocks+0xd11/0x4720 fs/ext4/mballoc.c:6320
>  ext4_ext_map_blocks+0x161a/0x6ac0 fs/ext4/extents.c:4383
>  ext4_map_create_blocks fs/ext4/inode.c:609 [inline]
>  ext4_map_blocks+0x860/0x1740 fs/ext4/inode.c:811
>  ext4_convert_inline_data_nolock+0x249/0x970 fs/ext4/inline.c:1112
>  ext4_convert_inline_data+0x4b3/0x5e0 fs/ext4/inline.c:1976
>  ext4_fallocate+0x1e2/0x3d0 fs/ext4/extents.c:4793
>  vfs_fallocate+0x669/0x7e0 fs/open.c:342
>  ksys_fallocate fs/open.c:366 [inline]
>  __do_sys_fallocate fs/open.c:371 [inline]
>  __se_sys_fallocate fs/open.c:369 [inline]
>  __x64_sys_fallocate+0xc0/0x110 fs/open.c:369
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9c7eb8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd1029f7c8 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
> RAX: ffffffffffffffda RBX: 00007f9c7ede5fa0 RCX: 00007f9c7eb8f749
> RDX: 0000000000004003 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f9c7ec13f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000010000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9c7ede5fa0 R14: 00007f9c7ede5fa0 R15: 0000000000000004
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
-upstream-moderation/69217121.a70a0220.2ea503.0066.GAE%40google.com.
