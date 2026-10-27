Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793090698;
	b=u9DQ+anlGEhnrHOo840xP5nkeX1aPoyh6B0PQqrpqrW1WoZf1kKtOzvF3rc5sQ/Z3XLo
	 cP1JHIl0c4/A7Qp0mBoUualrykkhWSkTxtcRvw+yegLvbWkx/zpDeGmnbyZfUSB+lpO+b
	 Ze74CV0GvYdex7UnnFGsaXUvcFJ1nRu+kcNKwZb6GkDOQDmjSXaus2MvAcbq5qrcqtEM6
	 56axHSRzMFO0Cnq8GFaD4s3K3wDFpjStYMVEiP6Hf9wZYJPCTNyNWMg9deIDAOant0tvF
	 0zGLlO4zw1OxmnORQl7BBgcenxqlgXv67NkiY7glULzMS+i3bCLPk9E5LD+mRtvRLfg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090698;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5hmg84mIRF03/Xid63O+K6GrXX3NyXW4csl+QFThRr0=;
	b=q+gxsgez8HjslbnHiFd8zAqNc1TSyhFYoV7mV2gbgYs/dvWz8/IaMTX+Ppe9ouXZoHX4
	 OwyulA2DchpuhXwPz7WCnEWw42c8NYV3Ovr3vOeVUTuZkkw2aHS/fv8kOo5kSJEq51ksR
	 vOi7rULFlkPmty6Wm5kLINM9M/7rQewcWA6OEKJdIMiVkJLRU33A18wikscM94RignNOy
	 ueDOGWwCZ1YLbqzklVRXgXsUyWrPaM3ZHDzAi3q603JtEA2ne40ZFj6kUZkrgLPZ900a0
	 V5rcwp5QkRYN7GTwJnGwRr9qK9gbtsKpP2KGM98wXQnnY1tVU6NPN/xfPULRQEm0G3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=mLrQj0gf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.50
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B395B606A31B
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 08:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B395B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=mLrQj0gf
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91c6ce60697so10474466d6.3
        for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 01:44:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793090697; cv=none;
        d=google.com; s=arc-20260327;
        b=L70zIJUgRjgsLoRPrLWWdr6wVPj8b5Vd6uJJO2DP129QKxHR/PszXdgnJ6mfd1f/P5
         86FbstZcRl+iIFa5ybQCHPwuGWgobPY8lL4VtFVPapeZ1zrhC7TCWqiyy3PcVRWE0Ab/
         8KksvoifmLCU09uwUFxm9xVSitvimOuMBtSIvMqRvSgJ1X+Ea9Re7tkqqqmCBHEi+iYB
         u912+x7hfxSXVWKG+sjBPsFjVxdyCZ+sk6pJTMpIEImBXlup9l5k3EtfUoMD/CdqQ5K5
         vEHv3WwLKeuPWRzlaiPvbfVQ2f/pUxSnygjOgie/MUlI+0D1f5/wXGpQsrmt1njE9C5o
         ra8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5hmg84mIRF03/Xid63O+K6GrXX3NyXW4csl+QFThRr0=;
        fh=tTB89mAwdI6DdmlTcZpulSf2yhnqzKBmlmhCl6WCVcg=;
        b=PD34ZZ8/bene83AStX0VyHI5HS2y8y6E/6zmjl0yX2ymUvbzNOxP/G0f/3310j+jcu
         HvV4fLNdSR6C8n8d8nlULFtEIZJlKXaapbWN2h5+bIi6t87uWaHjc8jU5D0yh8mdSQBz
         xyjSu66ZyjUHQBPWWf59lzWC9LhFxTq0R98GQN4/sLm56BJqDJ9nNsPqmBdj9Vg5AsWT
         IjMTvSPxDDEHAnZV5lV8fI5z8szj2SwU1vmk0WjbKdFCuEEdR/PUNxCSiTEp/b/VBt05
         8SKICCasZvQAQcQJzFj7vK+Uo8uO+HhHTMGwChX0C5O0MASAeNJIhSZMG0NooAdndJ2a
         8Xhw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793090697; x=1793695497; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5hmg84mIRF03/Xid63O+K6GrXX3NyXW4csl+QFThRr0=;
        b=mLrQj0gfOG3lEU3BG54cN2lPH9u6eyErm8QB34+pyqmlgRvCfmIvRqiqaAHCpKa3q9
         QqdaYcBNOJii817I52Isa0wNPnM1TTpnFOwWyREi86oe3tmm+MdcA48Nvu+EaTsTN6v7
         pQdRs5oflg8J6zcB3jMyPmaZdLYpFEMNtpkuFhUcsuvPby7DRSNMxZs4IjrBGqVD4FRj
         PEvARslCnAROEi+QVq+kD1TBRu4mvKr+xe/75W0TwVxc05u/Bl6VdPZvnq7nPd6yml+i
         K6vsNX+MKWLn9qKwwSDKAGPZzmyjeN8LvFBvUKFHRvS7i+iX0ook1YS+ZExqVXdzFEzK
         l5ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793090697; x=1793695497;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5hmg84mIRF03/Xid63O+K6GrXX3NyXW4csl+QFThRr0=;
        b=0qfXoe8nSaLa3fyDTeqjo4CeDqD7ylZW+QrOT+ODuGCo20EjBiPCYmLIQOTJ6CqCSY
         NIx2OT1bPFSQPWUFZS15bHMYBxt5zeJD3yixRvy4ZWpeLJjjSZON2VNDoSvNrirtAXDo
         ONOp2dkKadsNJ9AEn3k0AyqwinFcIuRkFFIzXCFZbZClI/EWX4/UUg3/kzckktSZsp1P
         DHWZ2lEYJRMrZQ3g/DpukDcULO0sOy2tWazfH4F6ArG/JFzHSJhEO+xaiDGotXg32TOi
         L/cQtF4wsbZXTI20chUQbz8CbtKnPasnXzpbZXii3ZG01GUdrytzK4Tyf2uXS2urIVdP
         QVWw==
X-Forwarded-Encrypted: i=1; AKwUvByDWmzn36Wup2qyznpde/dVm8l6rp2cmdc3eQgFj9ad9YOEGSFty4/Dr4t3WVEIJ7ON/7kZd3w=@lists.linux.dev
X-Gm-Message-State: AFq9FYIx+aLS8lG7rS+See7lpNJWrhl/7b0H8gGIcpXhJyfdfNFkBxi+
	nGnpckYdscccUxWTBo7A20Pv5meJh133PeD8gsngZdM9eCjv1N3CPfEyugEexGJofwt2hs6yUjJ
	O3wsb1FVRv2GSIT0h0zucarE2WBxCQ0N1J3+HDQ+c
X-Gm-Gg: AYBFou1YYvizpPeRc3T/U+ab19ATJQI7KXPDeKektcjpvMXxe/gCEqvc3p0ciRdgTPW
	JQFA4FqV71+8PLljJyCaSUzUbpG9yKvKTbVWF8Gt0VyOiB/JqiwFoQQz5se47IFx/gbEVa46rY9
	XIgWjTniq19TI7mloJlU9iQf/m/ys+LNtZetGv3wuaUDvPwUcJth375qthExSHjxFC8OKl7+vY6
	E5CIMdLX77f/vvc1pPVjKrNDQZfTqf4baFeYnLuTeFzaOGBf8MqDoxLD7cByA69OX+SoCfyGirl
	OTvBp5qxuoyoEewsLXhN3AP1opIRKnDniY8CLqaWLUPRu+WgqCIkQbclphNHKe9iC4lnWC5jbxc
	+z9Jh0yQaOu+/XWg3jfvKy/zsTfIo8rHK1wIQ7ImDE3aLpQNuaCc4GUZWIf9UdL89TmX7qlcOfE
	yZmSutHvEO/3lXyC4yu6h3
X-Received: by 2002:a05:6214:4611:b0:91c:7460:6eb9 with SMTP id
 6a1803df08f44-91c74606f83mr11403966d6.39.1793090695998; Tue, 27 Oct 2026
 01:44:55 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae0399c.6200f071.51519.0f2c.GAE@google.com>
In-Reply-To: <6ae0399c.6200f071.51519.0f2c.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Tue, 27 Oct 2026 09:44:43 +0100
X-Gm-Features: AclHuK_11dIvJR9hgPf7rVtSzjSVQBHbPYMdrxzgxe1fV59tpr3gxNmuiHkkk0c
Message-ID: <CAJWNTGz+u0tJ4nxUcSEn256EL-XnpAszE4g4A=bK7jOKr-t2Pw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: buffer: warn when a buffer is attached to a
 second mmb
To: syzbot ci <syzbot+ci06223a9c9e2b7f52@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Oct 27, 2026 at 6:41=E2=80=AFAM syzbot ci
<syzbot+ci06223a9c9e2b7f52@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] buffer: warn when a buffer is attached to a second mmb
> https://lore.kernel.org/all/20261026213626.301480-1-aurelien@hackers.camp
> * [PATCH] buffer: warn when a buffer is attached to a second mmb
>
> and found the following issues:
> * WARNING in __ext4_handle_dirty_metadata
> * WARNING in fat_add_entries
> * WARNING in fat_alloc_new_dir
> * WARNING in fat_remove_entries
>
> Full report is available here:
> https://ci.syzbot.org/series/2d872051-106e-44e2-912e-9f5ffc88fe5f
>
> ***
>
> WARNING in __ext4_handle_dirty_metadata
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf=
2a1/config
> syz repro: https://ci.syzbot.org/findings/e505c7df-1483-4020-9400-461d434=
eaf84/syz_repro
>
> ------------[ cut here ]------------
> cur && cur !=3D mmb
> WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c=
:639, CPU#1: syz.2.20/5867
> Modules linked in:
> CPU: 1 UID: 0 PID: 5867 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
> Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 4=
1 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39=
 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> RSP: 0018:ffffc900030bf238 EFLAGS: 00010293
> RAX: ffffffff82615d19 RBX: ffff8881bd1af460 RCX: ffff88816f9a9e00
> RDX: 0000000000000000 RSI: ffff888165b29280 RDI: ffff8881bd1af460
> RBP: dffffc0000000000 R08: ffff8881bd1af467 R09: 1ffff11037a35e8c
> R10: dffffc0000000000 R11: ffffed1037a35e8d R12: ffff8881bd1af4b0
> R13: ffff8881bd347348 R14: ffff888165b29280 R15: 1ffff11037a35e96
> FS:  00007fa2891f26c0(0000) GS:ffff8882a7cbb000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2e2cbf40e8 CR3: 000000016e66c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __ext4_handle_dirty_metadata+0x2f5/0xa00 fs/ext4/ext4_jbd2.c:418
>  ext4_xattr_block_set+0x24dd/0x29a0 fs/ext4/xattr.c:2107
>  ext4_xattr_set_handle+0xed9/0x15f0 fs/ext4/xattr.c:2461
>  ext4_xattr_set+0x257/0x340 fs/ext4/xattr.c:2563
>  __vfs_setxattr+0x442/0x480 fs/xattr.c:223
>  __vfs_setxattr_noperm+0x12a/0x660 fs/xattr.c:257
>  vfs_setxattr+0x163/0x360 fs/xattr.c:344
>  ovl_do_setxattr fs/overlayfs/overlayfs.h:328 [inline]
>  ovl_setxattr fs/overlayfs/overlayfs.h:340 [inline]
>  ovl_check_setxattr+0x15a/0x320 fs/overlayfs/util.c:898
>  ovl_set_opaque_xerr fs/overlayfs/dir.c:276 [inline]
>  ovl_set_opaque fs/overlayfs/dir.c:290 [inline]
>  ovl_create_upper fs/overlayfs/dir.c:383 [inline]
>  ovl_create_handle_whiteouts+0xb9c/0x13d0 fs/overlayfs/dir.c:643
>  ovl_create_or_link+0x14d/0x270 fs/overlayfs/dir.c:685
>  ovl_create_object+0x29d/0x3b0 fs/overlayfs/dir.c:722
>  ovl_mkdir+0x34/0x50 fs/overlayfs/dir.c:742
>  vfs_mkdir+0x40c/0x620 fs/namei.c:5420
>  filename_mkdirat+0x285/0x510 fs/namei.c:5453
>  __do_sys_mkdirat fs/namei.c:5474 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5471
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa28839f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa2891f2028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007fa288626090 RCX: 00007fa28839f559
> RDX: 00000000000001c0 RSI: 0000200000000400 RDI: ffffffffffffff9c
> RBP: 00007fa288436b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa288626128 R14: 00007fa288626090 R15: 00007ffd68374848
>  </TASK>
>
>
> ***
>
> WARNING in fat_add_entries
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf=
2a1/config
> syz repro: https://ci.syzbot.org/findings/39f0a1b2-b9af-4d73-a1fc-ce1cd04=
779b5/syz_repro
>
> FAT-fs (loop2): Invalid FSINFO signature: 0x41615252, 0x80417272 (sector =
=3D 1)
> ------------[ cut here ]------------
> cur && cur !=3D mmb
> WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c=
:639, CPU#0: syz.2.19/5813
> Modules linked in:
> CPU: 0 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
> Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 4=
1 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39=
 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> RSP: 0018:ffffc9000404f660 EFLAGS: 00010293
> RAX: ffffffff82615d19 RBX: ffff88811c3c0a80 RCX: ffff888113c71e00
> RDX: 0000000000000000 RSI: ffff88811bd3b3b8 RDI: ffff88811c3c0a80
> RBP: dffffc0000000000 R08: ffffffff0000ffff R09: ffffffffffffffff
> R10: 0000fc000f003000 R11: 65006c0069006641 R12: ffff88811c3c0ad0
> R13: dffffc0000000000 R14: ffff88811bd3b3b8 R15: 1ffff1102387815a
> FS:  00007f0b764146c0(0000) GS:ffff88818c4bb000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010ebc0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  fat_add_entries+0xc9a/0x2320 fs/fat/dir.c:1410
>  vfat_add_entry+0x2dd3/0x3570 fs/fat/namei_vfat.c:675
>  vfat_mkdir+0x16c/0x300 fs/fat/namei_vfat.c:866
>  vfs_mkdir+0x40c/0x620 fs/namei.c:5420
>  filename_mkdirat+0x285/0x510 fs/namei.c:5453
>  __do_sys_mkdirat fs/namei.c:5474 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5471
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0b7559e3c7
> Code: 00 66 90 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 db f7 f=
f ff 66 2e 0f 1f 84 00 00 00 00 00 90 b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0b76413e58 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007f0b76413ee0 RCX: 00007f0b7559e3c7
> RDX: 00000000000001ff RSI: 00002000000000c0 RDI: 00000000ffffff9c
> RBP: 0000000000000000 R08: 0000200000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00002000000000c0
> R13: 00007f0b76413ea0 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
>
>
> ***
>
> WARNING in fat_alloc_new_dir
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf=
2a1/config
> syz repro: https://ci.syzbot.org/findings/ac218fc3-8274-46ed-ad15-c964510=
8042b/syz_repro
>
> FAT-fs (loop2): utf8 is not a recommended IO charset for FAT filesystems,=
 filesystem will be case sensitive!
> FAT-fs (loop2): Invalid FSINFO signature: 0x41615252, 0x80417272 (sector =
=3D 1)
> ------------[ cut here ]------------
> cur && cur !=3D mmb
> WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c=
:639, CPU#0: syz.2.19/5804
> Modules linked in:
> CPU: 0 UID: 0 PID: 5804 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
> Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 4=
1 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39=
 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> RSP: 0018:ffffc900037bfac0 EFLAGS: 00010293
> RAX: ffffffff82615d19 RBX: ffff888022008000 RCX: ffff888113ad3c00
> RDX: 0000000000000000 RSI: ffff8880222733b8 RDI: ffff888022008000
> RBP: dffffc0000000000 R08: ffff888022008007 R09: 1ffff11004401000
> R10: dffffc0000000000 R11: ffffed1004401001 R12: ffff888022008050
> R13: f8f8f8f8f1f1f1f1 R14: ffff8880222733b8 R15: 1ffff1100440100a
> FS:  00007fde7c2926c0(0000) GS:ffff88818c4bb000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000022c3e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  fat_alloc_new_dir+0x7c5/0xb90 fs/fat/dir.c:1223
>  vfat_mkdir+0x13a/0x300 fs/fat/namei_vfat.c:861
>  vfs_mkdir+0x40c/0x620 fs/namei.c:5420
>  filename_mkdirat+0x285/0x510 fs/namei.c:5453
>  __do_sys_mkdirat fs/namei.c:5474 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5471
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fde7b39f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fde7c292028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007fde7b625fa0 RCX: 00007fde7b39f559
> RDX: 0000000000000040 RSI: 0000200000000100 RDI: ffffffffffffff9c
> RBP: 00007fde7b436b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fde7b626038 R14: 00007fde7b625fa0 R15: 00007ffee0058de8
>  </TASK>
>
>
> ***
>
> WARNING in fat_remove_entries
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf=
2a1/config
> syz repro: https://ci.syzbot.org/findings/09b74141-73df-447f-b681-310eb6b=
bab31/syz_repro
>
> ------------[ cut here ]------------
> cur && cur !=3D mmb
> WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c=
:639, CPU#0: syz-executor/5735
> Modules linked in:
> CPU: 0 UID: 0 PID: 5735 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
> Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 4=
1 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39=
 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> RSP: 0018:ffffc9000385fb98 EFLAGS: 00010293
> RAX: ffffffff82615d19 RBX: ffff8881130f0ee0 RCX: ffff888177e8bc00
> RDX: 0000000000000000 RSI: ffff8881188ead68 RDI: ffff8881130f0ee0
> RBP: dffffc0000000000 R08: ffffffff917a837f R09: 1ffffffff22f506f
> R10: dffffc0000000000 R11: fffffbfff22f5070 R12: ffff8881130f0f30
> R13: ffff8881188ead01 R14: ffff8881188ead68 R15: 1ffff1102261e1e6
> FS:  0000555564cc8500(0000) GS:ffff88818c4bb000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fff31a07d40 CR3: 00000001768a8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  fat_remove_entries+0x196/0x470 fs/fat/dir.c:1090
>  vfat_unlink+0x283/0x330 fs/fat/namei_vfat.c:836
>  vfs_unlink+0x27b/0x6d0 fs/namei.c:5659
>  filename_unlinkat+0x3cd/0x610 fs/namei.c:5729
>  __do_sys_unlink fs/namei.c:5764 [inline]
>  __se_sys_unlink+0x2e/0x140 fs/namei.c:5761
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb725d9e647
> Code: 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0=
f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 57 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007fff31a08398 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb725d9e647
> RDX: 00007fff31a083c0 RSI: 00007fff31a08450 RDI: 00007fff31a08450
> RBP: 00007fff31a08450 R08: 00007fff31a09450 R09: 00000000ffffffff
> R10: 0000000000000100 R11: 0000000000000206 R12: 00007fff31a09540
> R13: 00007fb725e35f63 R14: 00000000000114de R15: 00007fff31a0b700
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
> [aurelien.desbrieres@gmail.com aurelien@hackers.camp brauner@kernel.org j=
ack@suse.cz linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org viro=
@zeniv.linux.org.uk willy@infradead.org]
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
-upstream-moderation/6ae0399c.6200f071.51519.0f2c.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
