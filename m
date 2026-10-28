Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793196789;
	b=zIBtGcEUfSw7gIz189IHN3CRp3FI/BeuiPtBDYEHfx/T3I8/ycdWVPc4BXO7LL0pZhTf
	 bDooXvj9BXSkIml5gxsxiKnihLyF7ozBrjqYFoQbXrxQgX5Nnrfb0KdF4isPoTGoh++ee
	 ckJjjpv4zJNQCA6OaNX/O/oWjQs9StUmKaR1s3qErSFdEa0Nf/0mPbiz06v53F/Lz48Nq
	 QRu2IjeoBwnDsj19Z0e75VALVuiXfP6lQiaxAiP7sVZ0C4RPZGvZaiHGtRtDdPCpb0hMv
	 2K9s+QO+hUO48sQvBWp8LY3gDFepeF9Ln0zxfF+ieyCX/MfpcvKmNoE0aZHY0m68vOg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793196789;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=/2mF4ANYi9/Xtiv6UyVJcozbB2HgqLb7qT1Ij+dMp2A=;
	b=cdJjO3H0a0b3oCP940lGK4M9PdRrZfhcsWAAVinQIYkRis5Ee/UXBUVaHbRaQpZsHSJU
	 zGoApivC1W4VDw3eZeJPa4Pizinv+7cnOroVl29It9mzzNk4Bsv9p8nGVdSSWzZehvtFe
	 I8+8SdW2kU/4w/6HHqVuEpUjKotnPHG3nfPpGjjWbW7XbMwDLoX8KuIm3Dddyy+OH4NSL
	 pMrt6sDF1deFKctiBOwYJkdGwDgy+JqFAHR1FOBIVmxTVlhHbZwqcS5GLWtF4C0tNQDBU
	 kamGSGc4PYJOFJ8Kmu2bS/j1fI7MWY5nViIAdULuitiZXF5E2qX5/Y+jmg9otCjNelA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d2zFjkAV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.180
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8E8606A31A
	for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 14:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C8E8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d2zFjkAV
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-53394bffe0fso21957801cf.1
        for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 07:13:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793196787; cv=none;
        d=google.com; s=arc-20260327;
        b=VvtXeuavjMjdc2y3pKnoG6mvV0E8B521f8MWX4C8pnSBPZn2Ihe1lB2qZqNBAq+5Bo
         0PbkEm49pPTYffcU6spAS9ICmPc4RA+3L6oICxJy/C4JCAAu22eZDE2Qs5v1ePjbmpYL
         4J3bS37K6TH9OFjWLFfdQu6xGp/LYghxQNnnhuW2Ulr4cJdGGY9/v/4MJYYWDyXY8plD
         jWb+yboSQZe0vaTURrvo1kHRfVccMyHjLSUZGD7IaGD/4sUOAbFZE2MeskKSnfA2X9rf
         HYTiP9romXzEfwA2dBMs/OVIGLxXL/tlKy8AgXBn8jhVCWLi1hjDesRiHDSx6cEzAU1j
         v85g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/2mF4ANYi9/Xtiv6UyVJcozbB2HgqLb7qT1Ij+dMp2A=;
        fh=RbHM8OpK+AJs51v79IgCjYgI8ugzJ773vNElD3bQjEI=;
        b=BxGpNXn1Km+RMwNhVNjb5pKLekdp0EB73iNX0ma74oj2nhm/cnA2Md5moMVYcV1Vng
         PqZsmAsri4yics7vhNLHsxYeu0mToXyOaHhp0Ce/hOj7OXiszfpF3+kybkqdrG7f73gb
         sSpwLlHIdRGXRHHVIpQH371dnhCIJtYQpQwGL8sISDR+ydopHC3GvsPmNGmPnZwmo+Xe
         s0kuFk2iOMP+qxLskrzMa9QKRu0XajEDWPocL6U2YLq0iqr8NZdGA2iiKxCQHqfTQ07e
         voqZ4EBFh5BagY8nd1rsSVvKTM0IepHybDouj2YZ0TmEpSDi+wa28sOaK8fqT/eB/KkU
         2bIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793196787; x=1793801587; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/2mF4ANYi9/Xtiv6UyVJcozbB2HgqLb7qT1Ij+dMp2A=;
        b=d2zFjkAVooz26HCa5M9/YAQgKjTUyZD0M1cfA70WLs67AVEVx9T1xvFQOWQotzSeKw
         vkm3xQ/LnMvHfZAK1SDHEg06JUqDdaxTtBFtQgvO/ntphFpjrhRysGTPr5PuqSlvE+q1
         UkwNyZ+5DhZF4CTzTF+fD/9PBx8Q0AyHdH4UYLlRlK/ENdLZg9D75r6a5xczBJn4gu9p
         B0sfMu+6gAgEuVzl++gGSTkJohU2h1+dZp/yS7f8NGG0dQKvCGaqvrJBbMP3nFaOFodX
         lxvfl5JsQ8fgiLz5WStYQQFjy+yynkzcahztkJIu8LyNzNqldcPjCFvZHCbE/ZX3ni4G
         INTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793196787; x=1793801587;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/2mF4ANYi9/Xtiv6UyVJcozbB2HgqLb7qT1Ij+dMp2A=;
        b=w6gmWVv0I1PKPtYxDa9f5iar8pY0BImdH9c1Yjs6RWYn1ya2YtitftK+IKB3AqKi5F
         dewAFpO4c0mqdomQ1nwJZU32z1zI8hpREDcQEfpMsOnfTYmrgKJP2dOwK08wsjz4LxJQ
         SHplOJFxmB0CBAvBZD1knpnaSh8FmFlISoDEz2QCebB5XBgmegRUdrk+xwGNcfjfzcM9
         hR8rdCtFRyKGr4qKipC2DA0SwjDBCZJi+9XjP3uaeBRXCL6AmZJ5nhV5D18IEEeBSPIE
         9GdNc4qXmRE0oZSPuSInYQ7bOJ+gtfuJPotNAc3BruQ7FI3SP5B75alyzgEpIuhpOU1U
         dwxA==
X-Forwarded-Encrypted: i=1; AKwUvByS2p3Jn47EmMegbivDjubVuO7iyEAVe2jGkb+rfFga7FFUXD+L7dzFk5HrdqhIVyyaaF0/YBc=@lists.linux.dev
X-Gm-Message-State: AFq9FYLkIaGyIDD94ueGMAvko3zyarjsWJqFMzOTSYuE6Gv9Wm3zRgTJ
	f2os0KMj/IVcZ3VO0OsRdayl32CHsx2YoUuNLTzcbICNmT7McUaYu+Mjfo45tYOgerwNx5Am+Ht
	O4d59eO/RPY0VR2tv2BJQ+QXS1z2FxL50QF13YrOPIcuNDHsQC28m9o06
X-Gm-Gg: AYBFou3SJha1Pjshd8/rpH1/hrx7hAVfCM911PS0mbiLcTjB76uSEUiIBWbJ7DQfAFL
	AHesGTx5O7JJklE2taqr3MT0lIX+0FtpXxa435BkNGTtq+UeVhQZOSogkHkpIaHP5EZCcgXuEWU
	BoihmZ5ACLjQIptIBaQY478l1EdnAFSiufH2pp8UHnSuHjhju2/YxgwiX5j+XUAD34wptTobaLl
	8LH4jPFWSRcNjlHoXctvbtYH0XbUoA5E5QwzAviggGGbOibHslVfWLEJKRT8tJrltuCOKpIFlj6
	JTti7RpIAUkGN0ns2vhu/AZzI8qOCZKXzgI2d5VkPCDHqFWYRo7KfQuGAlujmgn9g9cz5hidMnU
	drHpBq2Q32069JRXtGax1sDayuRfhceEgAZolwPRMVE5jKGmlTKYtX6HHAowf6buXms2x+mU3YI
	Ut4IVlAUq2a5LZGWfzNqlJtQ==
X-Received: by 2002:a05:622a:5806:b0:535:a5f7:d599 with SMTP id
 d75a77b69052e-53e40c60d48mr97041351cf.40.1793196786728; Wed, 28 Oct 2026
 07:13:06 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae2020f.cbab20e0.42a9b.0005.GAE@google.com>
In-Reply-To: <6ae2020f.cbab20e0.42a9b.0005.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Wed, 28 Oct 2026 15:12:55 +0100
X-Gm-Features: AclHuK_DYjggWe4vAmpCHpaBY2pguxpN5CHXtsmj1DZu9c98rU-WyHIsnxvifog
Message-ID: <CAJWNTGxFzD3SqA+gBpFb=xfDp54g8f3xPUQgc2db+6PU-KeOyw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: hugetlb: supports unmapping private mappings
To: syzbot ci <syzbot+ci4afffd1cc25e4433@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Oct 28, 2026 at 3:09=E2=80=AFPM syzbot ci
<syzbot+ci4afffd1cc25e4433@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] hugetlb: supports unmapping private mappings
> https://lore.kernel.org/all/20261028041528.269829-1-eadavis@sina.com
> * [PATCH] hugetlb: supports unmapping private mappings
>
> and found the following issue:
> WARNING: bad unlock balance in remove_inode_hugepages
>
> Full report is available here:
> https://ci.syzbot.org/series/bf349aec-df0c-48a8-ab82-9f71361a3830
>
> ***
>
> WARNING: bad unlock balance in remove_inode_hugepages
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      7d1f84f1b94e79cb95d974ab3ec54cb3a4d64f5b
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/7d19c5c0-63db-4726-978e-d863eedfb=
488/config
> AI triage: https://ci.syzbot.org/findings/dcd884e0-680c-4d8d-82e4-551dbfc=
daeae/triage_trajectory
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: bad unlock balance detected!
> syzkaller #0 Not tainted
> -------------------------------------
> syz.4.862/12304 is trying to release lock (&vma_lock->rw_sema) at:
> [<ffffffff82b5a0e7>] remove_inode_hugepages+0xc57/0x1220
> but there are no more locks to release!
>
> other info that might help us debug this:
> locks held by syz.4.862/12304: 4, last CPU#1:
>  #0: ffff88810729e460 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5e=
0/0x7e0
>  #1: ffff8881aa537b00 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: huge=
tlbfs_fallocate+0x3f7/0x11c0
>  #2: ffff8881683dc638 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: re=
move_inode_hugepages+0x370/0x1220
>  #3: ffff8881aa537da8 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: remo=
ve_inode_hugepages+0xa44/0x1220
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 12304 Comm: syz.4.862 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  print_unlock_imbalance_bug+0xdc/0xf0
>  lock_release+0x252/0x3c0
>  up_write+0x2d/0x4a0
>  remove_inode_hugepages+0xc57/0x1220
>  hugetlbfs_fallocate+0xc51/0x11c0
>  vfs_fallocate+0x65a/0x7e0
>  madvise_vma_behavior+0x2cf5/0x43b0
>  madvise_walk_vmas+0x576/0xb00
>  madvise_do_behavior+0x385/0x540
>  do_madvise+0x327/0x3a0
>  __x64_sys_madvise+0xa6/0xc0
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0c8dd9f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0c8bff6028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f0c8e026450 RCX: 00007f0c8dd9f559
> RDX: 0000000000000009 RSI: 0000000000c00000 RDI: 0000200000400000
> RBP: 00007f0c8de36b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0c8e0264e8 R14: 00007f0c8e026450 R15: 00007ffc9fc94698
>  </TASK>
> ------------[ cut here ]------------
> DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) !=3D current) && !rwsem_test_oflag=
s(sem, RWSEM_NONSPINNABLE)): count =3D 0x0, magic =3D 0xffff88810b4c2608, o=
wner =3D 0x0, curr 0xffff88816ff4bc00, list not empty
> WARNING: kernel/locking/rwsem.c:1413 at up_write+0x35c/0x4a0, CPU#1: syz.=
4.862/12304
> Modules linked in:
> CPU: 1 UID: 0 PID: 12304 Comm: syz.4.862 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:up_write+0x40f/0x4a0
> Code: 0d 8c 49 c7 c2 80 33 0d 8c 4c 0f 44 d0 48 8b 7c 24 10 48 c7 c6 20 3=
6 0d 8c 48 8b 14 24 48 8b 4c 24 08 4d 89 e0 4d 89 f9 41 52 <67> 48 0f b9 3a=
 48 83 c4 08 e8 f3 6f 45 03 e9 d6 fc ff ff 48 c7 c1
> RSP: 0018:ffffc900040cede0 EFLAGS: 00010246
> RAX: ffffffff8c0d33a0 RBX: ffff88810b4c2608 RCX: ffff88810b4c2608
> RDX: 0000000000000000 RSI: ffffffff8c0d3620 RDI: ffffffff917dda70
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffff88816ff4bc00
> R10: ffffffff8c0d33a0 R11: ffffed10216984c3 R12: 0000000000000000
> R13: ffff88810b4c2610 R14: ffff88810b4c2660 R15: ffff88816ff4bc00
> FS:  00007f0c8bff66c0(0000) GS:ffff8882a7c83000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8981484378 CR3: 00000001ad2de000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  remove_inode_hugepages+0xc57/0x1220
>  hugetlbfs_fallocate+0xc51/0x11c0
>  vfs_fallocate+0x65a/0x7e0
>  madvise_vma_behavior+0x2cf5/0x43b0
>  madvise_walk_vmas+0x576/0xb00
>  madvise_do_behavior+0x385/0x540
>  do_madvise+0x327/0x3a0
>  __x64_sys_madvise+0xa6/0xc0
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0c8dd9f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0c8bff6028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f0c8e026450 RCX: 00007f0c8dd9f559
> RDX: 0000000000000009 RSI: 0000000000c00000 RDI: 0000200000400000
> RBP: 00007f0c8de36b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0c8e0264e8 R14: 00007f0c8e026450 R15: 00007ffc9fc94698
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
> [eadavis@sina.com linux-kernel@vger.kernel.org linux-mm@kvack.org mike.kr=
avetz@oracle.com muchun.song@linux.dev osalvador@suse.de syzbot@syzkaller.a=
ppspotmail.com syzkaller-bugs@googlegroups.com]
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
-upstream-moderation/6ae2020f.cbab20e0.42a9b.0005.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
