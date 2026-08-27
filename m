Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D5F332601
	for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 07:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787814364; cv=pass; b=GC2vA2R2Zl+xGi3PUaCkOrRN1JbnScZuXwOZbRi/gYs3/ajd9zK2TQps6Q6Cr/oupq9mkIdmA3uMCGJnDhpC1ceWPnVjbJ6xGId7LggUFw34FbP2W+CSc8l2ukAw4cGZgiFd4YqDWuKxJOGyKGAad3GyMRca59pqxIXjVnpffLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787814364; c=relaxed/simple;
	bh=RpxJnKLz7a9oXeXcOTm9BWsDVbsh0g/XblPoGTA/bQ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hmWoHANlaus9X0jRB4Vw66i3aX5uBKUI0V3LzXFzJXgc/HWIxRakykPyLZZA74KRwTRYYLa3/KoZrBBnxb1+CM779vlmorc1bJw4X6oGNU/7hRdlvcQVklpWBDX9cjLffHstoc1j4jCB3+i5ps+sOETlTauJ4LoIqTsRXqOKtIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f+M4Yvzw; arc=pass smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f+M4Yvzw"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso3249457a34.3
        for <syzbot@lists.linux.dev>; Thu, 27 Aug 2026 00:06:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787814361; cv=none;
        d=google.com; s=arc-20260327;
        b=Ah0t/nHgoxFTz1fl35r/j2CBR43kH/fFaQCG+E24ik1E4mvL5p37kMMo8XNZ9TFryM
         QU0/0M5beihc6JT9VVS57Px8c99edXz66IHJOC2xuyVetCkXWpJSmOf4hPPHM0y4L0uy
         pdvLiIoQn7sud7Kqei1JMnbOtKay3WknzhgH4+isysZZh1NtJMP4FWAgAdMSQ3GBR96k
         uZgtObnSmKzdBoACJxxKWwWLM/YccbvjZIeKqZI/qjlTW8Sb8ziALH/ajnLo+g8WLGXC
         ckuTEiXs3vrsZhxjEESpNpMjyATKbTO+Qs2YQT9BSMDxxF14aAwBqngyCHIVj4Ee622j
         JFnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mtr7q9YzIaPXZYITzqmCsvHmfxlFWp2gNwnuXo51K5Y=;
        fh=Mqv9g4hURV82Ps6GzjqkVS80zsDSkHwpKcBTMZART8g=;
        b=eZwxm6gGSHARhksQMLWYnEtqsgLo65ArhClE+KL3UyTbHotvlxVdehFOCdb4llWMy1
         ousNDP0jNY3mgqipFStoYaIpWxICbY6lBTNInayQyTc+0BJesSpFxn5S+GeZI64Etex3
         lG/Fps2oSrQ0bUf6P3U87k4rJPNRWfcEM8DWAFtGSmZv0U2T4xRQ0LdDY3fyvGGXhPQh
         Gr5Fz/Ji6fjl0DKx2mljjSBrBEfklS7H9TVvsovBa2fOP7bewe3S9cbQi0Q+hsr3eFZm
         Rj3/BVH7uDlK+dk2mPkchb7ejV3ysyxIhMOrOON8XvETDz9pL+ZV3J57Kf7qEOSIVh9d
         AKLg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787814361; x=1788419161; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Mtr7q9YzIaPXZYITzqmCsvHmfxlFWp2gNwnuXo51K5Y=;
        b=f+M4Yvzwo300V1LVRhRgKsZclM1FPNpiLY8x/+6s9tb9ySPJB9vevm3oBt4cnHB+Xh
         JXzKPySlMb70koKnolPQ78elaS4AIeqLZPOCmSOiJCJNhHkirWYAfGXgHtIHkS1hEoWC
         yLasZeFI1a67/79LO6Q6ZOhl3WFwvU2pE+RYkU/Fu3TrJ+XIx9VMwQYB+ehZ6OucZpYy
         kGflmVCJ06/MM1HKlDlcKzqxx4WfQub1wvB0WCU0MzgjMQ6oCEUkBXFH0k0roKlamXPW
         bdnhY7aTuyKeBEU4qjxkHZSJ+EBvsmuMRdJi+8D1W0RDiMOO0tVsZPR6UvnZuLHLv6zz
         Zo5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787814361; x=1788419161;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mtr7q9YzIaPXZYITzqmCsvHmfxlFWp2gNwnuXo51K5Y=;
        b=FK3Bop9XiXDWJomo0rKrBFKN0WK+MmlcSmYs3pp3Gj8ksuBkDbVNC1bdg4qtf+zwxw
         BpQZjGQ6VdioB/PLvPjqgpU7H5Hnp679tV4XorBP51+z8TUqwarz/r7rEpMhjgRQBLNf
         nZ/XhSZkpXy1A2wJQYkwPKM4aKMwJTPsnzYUp54JABX/tIUkAbIc2Ei8P/A9nL4FH6Uk
         utRbPrOo/rl5AhkE+9ulZSVDrk5/RDEiWRbngT/oJdhdJX35zqgejFxmlMb2vqgasdrA
         YRXL9rPdXSegpucBdXxwUcKWyTp+tB94JUsbHhIZFIq+9RFzv0WRC1hmwFN0fapFiSct
         XsFQ==
X-Forwarded-Encrypted: i=1; AHgh+RrfP5hwtbJhZqCo4OPsw55cjFneWU72v6ebqyqitZ6X2OepLXfzGwcJYslVxeqH674BLqM3dJg=@lists.linux.dev
X-Gm-Message-State: AFuF++nFBP9dq3ClqZ4Zy8ONaqEVbMPICYBfehJozPZzeRKhFOoToRbd
	UXWq1rAjKNDeGY/TWscY3S2jPDLuJrjXZeKi8VlLVIjoZMHU7yGjFEWD86Wj9sxQKVlBznfn0JR
	xAaQjL1Bfe9B0n0uvfKSvNWLFM8FGBkGYOyBMELJb
X-Gm-Gg: AR+sD13/ZNkdgIBu4uvvZGbtMIVHug6wCm+/mQKLBZo+DL65PVWeAJWvVoDAvQ8ADdv
	2qOe6gRMlj91W5326XG0Ac4kErGcZTsjNbnJtUdCunohaSACZprs13F9LcTmlMhrsEfvS/mRCRm
	kBET2v0yVGvKAI3Jj21RuLC4cX1qYhtGr5uVvjy+FxTB8qqBYuK5NaCQjxFlYDnUAwzc0V+aCTg
	/dDVB+DRx+do4HcM2fvQ4mE0ihyxWnlvZfatynxW3Is7h3KC61kEodic+SfT8dfGERD7n5OYnn1
	CSkpAKVOY1x/4291bg+8BCUXcXMW9zUfiWD63O8VzIcpvBfttpu7nYZuJ80cPFs53v5EjlDaXXx
	T5dzvGzrWXF7iF6I/B7fkxvqI/vk8YfElG9g2EoiCJccID0jCGfg95k9zkV2pFzmOA65wDg5FsA
	H90QUjhM6uHEX5i9Zh9bQZdo8=
X-Received: by 2002:a05:6830:3787:b0:7e9:ea28:4c1f with SMTP id
 46e09a7af769-7f4c4dc57d5mr14896419a34.8.1787814360494; Thu, 27 Aug 2026
 00:06:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a8fa9ef.27659fcc.2ceef7.000d.GAE@google.com>
In-Reply-To: <6a8fa9ef.27659fcc.2ceef7.000d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 27 Aug 2026 09:05:49 +0200
X-Gm-Features: AcwNN1VuhZBNyjEPc84DwKv0a26OAxL6PCMhx0kIfKvpS8OVV3ov6bu1eQiEqTY
Message-ID: <CANp29Y79g6G35wrhng0vtMnpHmiq7FiDSZwx_TvOPGNTMKEGUw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: hfsplus: convert regular file I/O to
 iomap-based operations
To: syzbot ci <syzbot+ci9bc407e580292353@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Aug 27, 2026 at 5:07=E2=80=AFAM syzbot ci
<syzbot+ci9bc407e580292353@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] hfsplus: convert regular file I/O to iomap-based operations
> https://lore.kernel.org/all/20260826225614.486112-1-slava@dubeyko.com
> * [PATCH v2 1/7] hfs/hfsplus: exchange hardcoded number of extents on nam=
ed constants
> * [PATCH v2 2/7] hfsplus: rework hfsplus_get_block() logic
> * [PATCH v2 3/7] hfsplus: take the bitmap page lock for allocate/free
> * [PATCH v2 4/7] hfsplus: add iomap operations for regular file data
> * [PATCH v2 5/7] hfsplus: move file related operations to file.c
> * [PATCH v2 6/7] hfsplus: introduce iomap-based file_operations
> * [PATCH v2 7/7] hfsplus: switch address_space_operations on iomap-based =
support
>
> and found the following issue:
> WARNING in iomap_iter
>
> Full report is available here:
> https://ci.syzbot.org/series/21631741-87b3-4cdc-90a9-ac84e2b3d36c
>
> ***
>
> WARNING in iomap_iter
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      5870ce43c013ad564b3b83bae330b160e056df67
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/c6a44359-3e63-48aa-be4b-563b7e0cf=
103/config
> syz repro: https://ci.syzbot.org/findings/eadf0b2b-9eed-4d75-809d-bfcd160=
8c785/syz_repro
>
> ------------[ cut here ]------------
> iter->iomap.offset + iter->iomap.length <=3D iter->pos
> WARNING: fs/iomap/iter.c:32 at iomap_iter_done fs/iomap/iter.c:32 [inline=
], CPU#1: syz.1.18/5854
> WARNING: fs/iomap/iter.c:32 at iomap_iter+0x976/0xf80 fs/iomap/iter.c:114=
, CPU#1: syz.1.18/5854
> Modules linked in:
> CPU: 1 UID: 0 PID: 5854 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:iomap_iter_done fs/iomap/iter.c:32 [inline]
> RIP: 0010:iomap_iter+0x976/0xf80 fs/iomap/iter.c:114
> Code: ff ff ff e9 86 fa ff ff e8 57 d4 5b ff 90 0f 0b 90 e9 09 fd ff ff e=
8 49 d4 5b ff 90 0f 0b 90 e9 3a fd ff ff e8 3b d4 5b ff 90 <0f> 0b 90 e9 95=
 fd ff ff e8 2d d4 5b ff 90 0f 0b 90 e9 c5 fd ff ff
> RSP: 0018:ffffc900036ff7e8 EFLAGS: 00010293
> RAX: ffffffff826b2d75 RBX: ffffc900036ff940 RCX: ffff88810a7ebb80
> RDX: 0000000000000000 RSI: 0000000000005405 RDI: 0000000000005400
> RBP: ffffc900036ff948 R08: ffffc900036ff770 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffffff82b1d450 R12: 0000000000005405
> R13: 1ffff920006dff28 R14: 1ffff920006dff29 R15: 0000000000005400
> FS:  00007f9b7a8b06c0(0000) GS:ffff8882a8f52000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe0db470000 CR3: 000000010d3a2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  iomap_file_buffered_write+0x262/0xbb0 fs/iomap/buffered-io.c:1308
>  hfsplus_file_write_iter+0x717/0xa90 fs/hfsplus/file.c:236
>  do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
>  vfs_writev+0x343/0x990 fs/read_write.c:1058
>  do_pwritev fs/read_write.c:1154 [inline]
>  __do_sys_pwritev2 fs/read_write.c:1212 [inline]
>  __se_sys_pwritev2+0x177/0x2a0 fs/read_write.c:1203
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9b7999e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f9b7a8b0028 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
> RAX: ffffffffffffffda RBX: 00007f9b79c25fa0 RCX: 00007f9b7999e0d9
> RDX: 0000000000000001 RSI: 0000200000000100 RDI: 0000000000000004
> RBP: 00007f9b79a35024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000005405 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9b79c26038 R14: 00007f9b79c25fa0 R15: 00007ffff695e668
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
> [frank.li@vivo.com glaubitz@physik.fu-berlin.de hch@lst.de linux-fsdevel@=
vger.kernel.org slava@dubeyko.com vdubeyko@coreweave.com]
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
-upstream-moderation/6a8fa9ef.27659fcc.2ceef7.000d.GAE%40google.com.
