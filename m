Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDE653C3C2
	for <syzbot@lists.linux.dev>; Tue, 13 Oct 2026 19:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791920093; cv=pass; b=Klo54K0/7SBX+nzteeWNsubSQSBFNxajzVyt3+a6m/l8eOcE6kOktaV74+wgYMb5WBgphAztxxgFiD0G1NErh+pxc9YhydSa5sPzvzbPfDb0wJhaZ20pRtYanqKEuYWkGhGw8qmGyrPRb+iBKYlvBwfARio6vTfTYLNrr6iR4mE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791920093; c=relaxed/simple;
	bh=6ARtGKJEfCY2YC6ZQpSSsyuloVQgbg5EsKaHX5y92zQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TVsVdtSbB0XSDmO4r1FCgq9Jz7tEgAjyIDEMzjNCy7wh2IHLwBZgDQd9I/ZDR5WXheCV+qKobxYV6i7AezpZNwscXO0TZC6IXmpgs1KbEIkot1oF3lz9FmYsJ60bHHLHpbmzP6MQjjxDhl/YzflLUvGazTYK2iuIqPFJ4Yadtic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iBhTxg2P; arc=pass smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iBhTxg2P"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-4f66bb2ab57so1410840b6e.3
        for <syzbot@lists.linux.dev>; Tue, 13 Oct 2026 12:34:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791920090; cv=none;
        d=google.com; s=arc-20260327;
        b=VIkiRJjzJzXuAmJqmzumQrSWHKpPKcFHYnwjKmZOpCzdHmGqL5XNf1E5u6pBmLSXPZ
         A0UeXhBlVDSyItxizZu+Q9WhO4m7+FphoriBoXxWtMHXyQF6uXOn/M4SjJ3QScsS9cCf
         UkWN6lR7iPPxSxw4Kg6nmMbmo2okJhDnB37h/WHGEG1LAmamiRgCH/c/LEWH+LEd8aV7
         8eXdyFwQNzwABUUdoktGN0Ltcz9DKS28xo3LXzdYZ80UrRxeRmsDJA4OLUIxrLGlWlhP
         pW6Ukji5HvLkYM1s3hTvaUuT8p3yAoq2v+VpdvDJPralbAaDZ/09sjyd79isKaBZIPVg
         DLfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+7jWUVnR7tiKqf0x88asJZrKpgwGapnk/juO0xomG54=;
        fh=r8q5hWbUdFeT67FVZvunhlgDdTapeCKBji/UL92f5i4=;
        b=NYbKrjwjNBRtw3J3vdTA227PBNZCjB53f02CWHZ9zN7QXPMbp3R6n4/evZbgQEcpHx
         g/bmrkD86DG7JKEaFQWVNyFSStKU/1/3t/Gg3Nze21EvL1rP6R/fiRfN8FiEfmMPPrCK
         7f+J8WwHa/vyV5SZjwxQFpufSEFjQnCqoVhT13tAqzhhFraWh1QC2XRLiPvaNFdCp1e8
         zUw443bBz0pwp4l4dfcgxSOxxt050VYlkkXNW8k4eD21QgZ1g1VmxU/h32JlTWtTDNoX
         bL/9Xf8yb0158xXs7bmI7YVJcbzlgxZrj/qbH9tf//26gcHIG2lOEI7+fUGtvV4eKDli
         dwXw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791920090; x=1792524890; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+7jWUVnR7tiKqf0x88asJZrKpgwGapnk/juO0xomG54=;
        b=iBhTxg2PvniysaqKsU6Bw3H/Ri7YaU/49y9MJdqOtd9fUz/Q/3Kla+v9r/jaRWRkjH
         uaLzuDK2g03Gnk30v6NYNODq84gZR7fxTdKQSQ3B6OvL1tvUnmePSGg4l2XnE0LOpfCF
         F9+tilF7WBqemoOdKBifu9KLWiebDq5LtDRo7tDb8YXoVZ06/onCagfZh9wsvxdRaz//
         eRQSHXSh9ZcpnecrcXuaSI97Y7rcFHeqBg61TO9JEEKmVqpJqwPguqIjVz4K3r0JOwQg
         TfzULDTQ8IRfyOS6bov6NFkkpjwROQoQveuQhv71f43NLQ4rCLjWRYNZQAUZwdHZneDH
         MIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791920090; x=1792524890;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+7jWUVnR7tiKqf0x88asJZrKpgwGapnk/juO0xomG54=;
        b=0nN4FIyEyzI1WdXzggCkMopLoFnHyTEPnfnJHbTJvG8RkFlIttonb/soVZxAABAcEu
         bccGJA2spDESB2bv9htVIgYemnDwyVpyoZ5J5TU1ZanCRpCIz+X0KdEnQTTN21P8VUmq
         2uNrIMPcL1jC01PZvV7WE5XmvI7uuRKhUHYzgu/h4ALVGXlrFbYlEQWFxY0sp3At6TN7
         0/2oyG8GCpcuiX4eW2UwMevGycYP37mo3IFtZaCokxpHQkFkULbxrVdFWLa3VZqnT3yY
         xHWdlhua2z9qYUHX6N9Kp9sd07Yo/mM1uZtD8b+86XzYLTBzFNp9uzgQOyVVB9m8wS8Z
         rbiQ==
X-Forwarded-Encrypted: i=1; AKwUvBwrkbZ6G+7jQYCSAFwApDinqLjWTT/7k3B9KFJohW8BGO49yTr4nv5uWQwPzINh9FQ/OwZm2Zw=@lists.linux.dev
X-Gm-Message-State: AFq9FYIpeBks6Qcv5WMQXtWDdwVHCq/nImCH5rovYZd22t1OAu8+sp6O
	//NvW/pCu8OAK6eow1hOoE2rKHXwxAZv6uhYy3vftNjOgqrpzjCqofvakEgHPx5nksNNR8FkfyT
	427o+UV8Ez2/z+7r9zBR9AWL7woloieAXjMsi1P1v
X-Gm-Gg: AYBFou2gOrtKkqL/Vp+iwJVlw4oCBf4CGhhcrHPGsh/WfxrEgQ1e4mox+WQZYOiV8zA
	EAascU+yaFXUpoIc05FawcYOM6o6H5d5uA1iKOgCXOWArs2bYAmI6f9966rciG9dCbd7Myzfeu0
	Z9VMFZg03W4nV4PLCy7BlOMpLR/gzGfnRMZn30cqRJGiGY5/pK5SpEjdyLtJtRJTeQAd776T6TN
	f0nOI1CCntxquG+28fXSxxq0JtGBpV/ZbYTUx0QU6O6+AnMRXzZrsIshKFgrC1t2YCUpxcYEAQh
	amYv1nBLRbG1Pqb5xp310m8dT5PkxCGGR1pjOcuJpRqVJggQFB6pfPseQI5X2VbDGjDuwxqmeFN
	lxSzu7lgxmrucB3u3Kmudd/psrYK1BTsuk0J8StBCUPcqsTFMvFGj2yMPTYUcUN6cfSoDVTm1OT
	X/OUGjGYivx8bWwm7tMU+Q1Wxgrg==
X-Received: by 2002:a05:6808:17a5:b0:4f4:7696:452f with SMTP id
 5614622812f47-50c42173089mr14564890b6e.1.1791920089757; Tue, 13 Oct 2026
 12:34:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <3a72d0ff-b0a3-41de-b2d7-bb629cf3ca02@mail.kernel.org>
In-Reply-To: <3a72d0ff-b0a3-41de-b2d7-bb629cf3ca02@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 13 Oct 2026 21:34:37 +0200
X-Gm-Features: AclHuK8bne-9OBz0wV4nRDxqN80vwVuaqTZ1mZKP55aos2ZMUnNQnR5Lf3MF34U
Message-ID: <CANp29Y5-2hEXmVY7xc94d6_GfgpAi_RBztekq5j+Hdw6E_n6Eg@mail.gmail.com>
Subject: Re: [PATCH RFC] fs/ntfs3: use ni_lock_dir() in ntfs_readdir()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Oct 13, 2026 at 6:26=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A circular locking dependency warning is detected by lockdep between
> &ni->ni_lock and mapping.invalidate_lock when getdents64() writes into a
> memory-mapped buffer while an operation such as fallocate() runs
> concurrently on a regular file:
>
>  WARNING: possible circular locking dependency detected
>  task is trying to acquire lock:
>  ffff88819b6dbb20 (mapping.invalidate_lock#3){++++}-{4:4}, at:
>  filemap_fault+0x6e0/0x13c0 mm/filemap.c:3585
>  but task is already holding lock:
>  ffff88819b6997e8 (&ni->ni_lock/5){+.+.}-{4:4}, at:
>  ntfs_readdir+0x717/0xf70 fs/ntfs3/dir.c:541
>  which lock already depends on the new lock.
>
>  the existing dependency chain (in reverse order) is:
>
>   -> #1 (&ni->ni_lock/5){+.+.}-{4:4}:
>         ni_lock fs/ntfs3/ntfs_fs.h:1247 [inline]
>         ntfs_fallocate+0x56a/0x1080 fs/ntfs3/file.c:535
>         vfs_fallocate+0x663/0x7f0 fs/open.c:338
>         ioctl_preallocate fs/ioctl.c:289 [inline]
>         file_ioctl+0x5db/0x7e0 fs/ioctl.c:332
>         do_vfs_ioctl+0xc2a/0x1550 fs/ioctl.c:576
>
>   -> #0 (mapping.invalidate_lock#3){++++}-{4:4}:
>         filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
>         filemap_fault+0x6e0/0x13c0 mm/filemap.c:3585
>         __do_fault+0x138/0x2a0 mm/memory.c:5565
>         handle_pte_fault mm/memory.c:6558 [inline]
>         __handle_mm_fault mm/memory.c:6707 [inline]
>         handle_mm_fault+0x100a/0x28a0 mm/memory.c:6876
>         do_user_addr_fault+0x746/0x1340 arch/x86/mm/fault.c:1394
>         exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
>         filldir64+0x2bc/0x620 fs/readdir.c:-1
>         dir_emit include/linux/fs.h:3610 [inline]
>         ntfs_dir_emit fs/ntfs3/dir.c:388 [inline]
>         ntfs_read_hdr+0x8a7/0xc10 fs/ntfs3/dir.c:429
>         ntfs_readdir+0x9ab/0xf70 fs/ntfs3/dir.c:589
>         iterate_dir+0x3ea/0x8a0 fs/readdir.c:114
>         __do_sys_getdents64 fs/readdir.c:404 [inline]
>
> The warning occurs because ntfs_fallocate() on a regular file acquires
> mapping.invalidate_lock and then calls ni_lock(), which locks the regular
> file inode's ni_lock with the default subclass NTFS_INODE_MUTEX_NORMAL
> (subclass 5). Meanwhile, ntfs_readdir() on a directory inode also uses
> ni_lock() with subclass 5, and while holding the lock across directory
> traversal, calls dir_emit() to fill directory entries into the user buffe=
r.
> If that buffer is backed by a memory-mapped file, writing to it triggers =
a
> page fault (filemap_fault()), which acquires the mapped file's
> mapping.invalidate_lock. Because lockdep sees mapping.invalidate_lock ->
> ni_lock (subclass 5) in fallocate and ni_lock (subclass 5) ->
> mapping.invalidate_lock in readdir, it flags a circular locking dependenc=
y.
>
> This is a false positive because the two operations involve distinct
> inodes: readdir holds the mutex of the directory inode, while the page
> fault acquires the invalidate_lock of the regular file whose pages back t=
he
> user buffer, so an actual deadlock cannot occur.
>
> In ntfs3, directory inodes are intended to be locked with ni_lock_dir(),
> which uses the lockdep subclass NTFS_INODE_MUTEX_PARENT (subclass 6). Thi=
s
> subclass hierarchy is already used by other directory operations like
> ntfs_lookup(), ntfs_create_inode(), ntfs_link(), ntfs_unlink(), and
> ntfs_rename(). Replace ni_lock() with ni_lock_dir() in ntfs_readdir() whe=
n
> loading subrecords and when traversing directory metadata. This changes t=
he
> directory lock subclass to NTFS_INODE_MUTEX_PARENT (6), establishing the
> hierarchy ni_lock_dir (subclass 6) -> mapping.invalidate_lock -> ni_lock
> (subclass 5) and eliminating the false lockdep warning.
>
> Fixes: d62cf685d12e ("fs/ntfs3: hold ni_lock across readdir metadata walk=
")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+7736960b837908f3a81d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D7736960b837908f3a81d
> Link: https://syzkaller.appspot.com/ai_job?id=3Dfae916f3-c2b4-47da-86b5-0=
63a011b5c01
> To: "Konstantin Komarov" <almaz.alexandrovich@paragon-software.com>
> To: <ntfs3@lists.linux.dev>
> To: "ZhengYuan Huang" <gality369@gmail.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
> index eb9152e9f..8bf62d2fb 100644
> --- a/fs/ntfs3/dir.c
> +++ b/fs/ntfs3/dir.c
> @@ -522,7 +522,7 @@ static int ntfs_readdir(struct file *file, struct dir=
_context *ctx)
>                  * Load all subrecords to avoid 'write' access to 'ni' du=
ring
>                  * directory reading.
>                  */
> -               ni_lock(ni);
> +               ni_lock_dir(ni);
>                 if (!ni->mi_loaded && ni->attr_list.size) {
>                         err =3D ni_load_all_mi(ni);
>                         if (!err)
> @@ -538,7 +538,7 @@ static int ntfs_readdir(struct file *file, struct dir=
_context *ctx)
>          * once is not enough if concurrent writeback can still compact A=
TTR_LIST
>          * entries and free the record that ntfs_read_hdr() is currently =
walking.
>          */
> -       ni_lock(ni);
> +       ni_lock_dir(ni);
>
>         root =3D indx_get_root(&ni->dir, ni, NULL, NULL);
>         if (!root) {
>
>
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/3a72d0ff-b0a3-41de-b2d7-bb629cf3ca02%40mail.kernel.org=
.
