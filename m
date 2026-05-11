Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B56370D4D
	for <syzbot@lists.linux.dev>; Mon, 11 May 2026 21:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535157; cv=pass; b=NbOimh3RLMlNhSDrtBFUNrx/FHSv2Ar18kFl2rgUtqDoKPHReRlIfOkuXO98tt2i8yGEJnlDMS9Not6ENUp9ezyGBWrbPbu3tVvVsDyv71roQA5kv2jLGwNinJPxDre6AqPGeSvAef9mLGcIrJDaKBUEjUdRvOAQxMsw7U1s040=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535157; c=relaxed/simple;
	bh=aSQm8tTS06gfBHOF5YVv5dgpPF+Vieky0lEGOSxrBQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H2sRRyowHoia4MDIkkn5av/Y5M9TDcVHHtwM10aKxK+LxANgvvNgRIOO83PSBNOgfviba+MuABRVzU3/QyCd74OPAO8h9pvCQmZ0JNfH4ZPu2IsUdFVWGrIVi0Z/z8zJXeaVVm9KVnbUtjrMyS45Us+IPkoOdrx++EzHMPEbxSE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mLcxv/4h; arc=pass smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mLcxv/4h"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-69489b43d66so1339401eaf.2
        for <syzbot@lists.linux.dev>; Mon, 11 May 2026 14:32:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778535155; cv=none;
        d=google.com; s=arc-20240605;
        b=aPZcEODkrtPVVfmV7TgcgahlYROqC9wdh8MRjOppqKrL+AzmPOumjAhqe3urrxuQF+
         TM87DiFybCTuYMi7Gq01b7nXRVtaPEnQlejeQA8y5m8kriyrxE1QFTao7IeViCAqsHtr
         SvpyRqfiL1a/b6rrpktOMz0S+xASjooebGihMHPCAyt6aigvISXx2oq/YCWBbXYX9Wql
         Gt5lnNCqqVcbh/bgg1en7q9ATIuFfwrKP/vCjw1eZNpU3jBlKRjVTxubJ+lbRlUgqGCu
         uTJSZexwAtwX3FpleX+yxmCPjKAoAVHJaxFKiL7PksHKundjYXBr/MqlLynr9HHOZ+KN
         QIog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UaIC9t1fQgpAXaTFFpFO+vfONy666zV+8kTTlKbrVM4=;
        fh=Pa9zWoZJRcFfwSvyJHrJ0/50rqhEewhwv1xp2L+URCg=;
        b=Au/1NBgRuSEMq2mp00C2vQvO/l3mmr+TKhJJLC2q7981ihs0cHTfU/hRtXU0TPtmxC
         K9CVHG+2lyeIiNN51dzGK0USUXtFtjqQZRXRma03YEU2csa25F3EVUep29HKl6fcblnQ
         jmrvfEF2DXfxpfWMiRg0K9vYO5j/HUXdoAc9oHcXQcfb1Z1bnSF/B0DfCSE3A9+UoMMw
         MahEzmphmcK7NK5vZ73LcAMAcPbXwcABx26JVJ3UB5IwBTLmtjrvmTogHqlu1mkHjO2X
         QAFQEUZHELBHRZspRyWcI8nEsBJvamky2EuC0XG6gdiqvKmB+PFiws/tSM9vWM0un/yp
         IDEA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778535155; x=1779139955; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaIC9t1fQgpAXaTFFpFO+vfONy666zV+8kTTlKbrVM4=;
        b=mLcxv/4hwsg09WhAgOpyeIno+DVIhpyatSYFKhu5R86BhYc4JmmVU7jwrjQ55UExLT
         zu0/sp0NOnrLO48VP5DIN/CsurESGkBusKakubHr5N7CS1bAaTqKzcCSqbdsT+xv5lME
         ujZYXGvQq+CO/VVCxO9XiHbWN8IYZkqmpHfKlm4y567bfveQb4F7j81Hka232GcrB6VP
         FvaT61hL+hrKj4P/pP/OAAUeG/+ilbQ5Bh8r9/t/UgNT59L9EeJaZTdF1wQOmvUHRhRi
         Hy4Ld5AvgNyyXljDmxMy8BD3YU+mVnSs1gapby2ujEMxHt2nOdIAwXlQMPILpgSLEP7/
         g4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778535155; x=1779139955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UaIC9t1fQgpAXaTFFpFO+vfONy666zV+8kTTlKbrVM4=;
        b=K0RqFElNNJkKs+J00+lqfKWk4vuc7RPZh8Q3aPIWT6iIawFyWpaQBKdgmyfP9LTeJ/
         TRw0zy4D7iitAOuL9UZ+c/Bypj/xz6q//d05rMdx8bPyCd7TWYgi9mpwyEjjyQtpHtiO
         E1bRkAZNlUl1oiqQc66yqk6Xp+DJj5P1awkf25emINMZMSgwpHthzPU6EE8tE5v1IOXi
         L76t1IEEHTC+wtGtNkSO7cFiBgsScVUKKtzU3VWAmXYfQnoegYvQSwq3VogqIfzuwNIl
         NMrAydLXnEs6Lq6HmOToy6t/6QMleHvodMdGDRNbJVO+9TauyyDudS/SxdckQqI+DX8N
         tRGA==
X-Forwarded-Encrypted: i=1; AFNElJ8n7t20x46BsHWxj23tXVmEtuN87GQkIwDPF/qlQ/0mN4V3v7x90rxHLUmysnDI1WiMzJskIk0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbdBJB2G9BkAHNsigxp57RC2V6yDYrp58WLruDIkoCWfo5IOK3
	xzjrJja7UdVDM6DeC0QWWkAaUKDmRgIpmLUnT++2hhFYefbREuQQF7gnRD0V7+oLrK82MBUu+ap
	algjYmVjHCn5qJLHIR6nFDQaOhB79hfMMC55MhHgqd7ZjhIFO9T5j7H0R
X-Gm-Gg: Acq92OF9g7lGjwcFQp7V1MuXKePHF6pVkcBQYqoiqac4b1Gpc4/b02vkkl75jWkJkE/
	3H4mb4Ff5iyJ5npqhouEHrcRSu5HR+nCuGBXSQkGY+Ds2muxgkxqY3+mo2nz+2kb7Ea6pUVZO49
	3y3IUojKOyxKyQ9jHpwi1MHSDs8nIEPLjJ29r1coBF/bqIFLXys2xonA4wdaMyjwWe944GsCjAe
	rT5YTDXVKEVbv2k8RtMJfPmiZb2kEA8UI/ot/MNLtokKiw63WI/bMl4FpSWhe/UmvVoRA+rBmsd
	DcALSpJV7QDYoHQon2bt+Id2L6+26EqM/MjqVI5ekMbKN/auaxhEKxILCVMQStFU3ZgOjZ6cl3r
	UEoiypVc=
X-Received: by 2002:a05:6820:180a:b0:69b:4186:164 with SMTP id
 006d021491bc7-69b69f4308bmr90278eaf.59.1778535154757; Mon, 11 May 2026
 14:32:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0bbb511f-6f0a-48b1-b3a4-e55eb907a1b4@mail.kernel.org>
In-Reply-To: <0bbb511f-6f0a-48b1-b3a4-e55eb907a1b4@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 11 May 2026 23:32:23 +0200
X-Gm-Features: AVHnY4KSBr3y_qye0eHIDJLmjxzVxW1ajxt-awz-iaXLBmCNYa6yOYNEjoZsXTw
Message-ID: <CANp29Y6J7Lw3UX43NKS=ae9nJTcjk=WVwM4qmff8=PuDD7uPUA@mail.gmail.com>
Subject: Re: [PATCH RFC] hfs/hfsplus: fix lockdep false positive for extents_lock
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Note the duplicate lines in the patch.

On Sat, May 9, 2026 at 7:50=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> hfs/hfsplus: fix lockdep false positive for extents_lock
>
> syzkaller reported a possible recursive locking deadlock on
> &HFSPLUS_I(inode)->extents_lock. This is a lockdep false positive.
>
> In HFS and HFS+, extents_lock is used to protect the extent allocation
> information of an inode. The problem arises because the lock is
> initialized uniformly for all inodes, including both regular files and
> special internal system files (like the Allocation file, Extents file,
> Catalog file, etc.). Because of this, lockdep assigns the exact same
> lock class to the extents_lock of all inodes.
>
> When a regular file is truncated or extended, its extents_lock is
> acquired. During this process, the filesystem might need to allocate or
> free blocks, which requires reading or updating the Allocation file (or
> other system files). This triggers a read on the Allocation file's
> mapping, which in turn acquires the Allocation file's extents_lock.
> Lockdep sees the same lock class being acquired twice in a nested
> fashion and flags it as a recursive locking deadlock.
>
> The exact same issue also exists in the older HFS filesystem (fs/hfs/),
> where operations on a regular file can trigger updates to the Extents
> or Catalog B-trees, leading to a similar nested acquisition of
> extents_lock.
>
> To fix this false positive, assign distinct lock classes to the
> extents_lock of special system files using lockdep_set_class().
> For HFS+, add lock class keys for the Extents, Catalog, Allocation,
> Attributes, and Startup files, and apply them in hfsplus_iget().
> For HFS, add lock class keys for the Extents and Catalog B-tree files,
> and apply them in hfs_btree_open().
>
> Assisted-by: Gemini:gemini-3.1-pro-preview
> To: <frank.li@vivo.com>
> To: <glaubitz@physik.fu-berlin.de>
> To: <linux-fsdevel@vger.kernel.org>
> To: <slava@dubeyko.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
> index 2eb37a2f6..fc262d703 100644
> --- a/fs/hfs/btree.c
> +++ b/fs/hfs/btree.c
> @@ -12,9 +12,17 @@
>  #include <linux/pagemap.h>
>  #include <linux/slab.h>
>  #include <linux/log2.h>
> +#include <linux/lockdep.h>
>
> +#include <linux/lockdep.h>
>  #include "btree.h"
>
> +static struct lock_class_key hfs_ext_extents_key;
> +static struct lock_class_key hfs_cat_extents_key;
> +
> +static struct lock_class_key hfs_ext_extents_key;
> +static struct lock_class_key hfs_cat_extents_key;
> +
>  /* Get a reference to a B*Tree and do some initial checks */
>  struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_k=
eycmp keycmp)
>  {
> @@ -49,6 +57,10 @@ struct hfs_btree *hfs_btree_open(struct super_block *s=
b, u32 id, btree_keycmp ke
>         mutex_init(&HFS_I(tree->inode)->extents_lock);
>         switch (id) {
>         case HFS_EXT_CNID:
> +               lockdep_set_class(&HFS_I(tree->inode)->extents_lock,
> +                                 &hfs_ext_extents_key);
> +               lockdep_set_class(&HFS_I(tree->inode)->extents_lock,
> +                                 &hfs_ext_extents_key);
>                 hfs_inode_read_fork(tree->inode, mdb->drXTExtRec, mdb->dr=
XTFlSize,
>                                     mdb->drXTFlSize, be32_to_cpu(mdb->drX=
TClpSiz));
>                 if (HFS_I(tree->inode)->alloc_blocks >
> @@ -61,6 +73,10 @@ struct hfs_btree *hfs_btree_open(struct super_block *s=
b, u32 id, btree_keycmp ke
>                 tree->inode->i_mapping->a_ops =3D &hfs_btree_aops;
>                 break;
>         case HFS_CAT_CNID:
> +               lockdep_set_class(&HFS_I(tree->inode)->extents_lock,
> +                                 &hfs_cat_extents_key);
> +               lockdep_set_class(&HFS_I(tree->inode)->extents_lock,
> +                                 &hfs_cat_extents_key);
>                 hfs_inode_read_fork(tree->inode, mdb->drCTExtRec, mdb->dr=
CTFlSize,
>                                     mdb->drCTFlSize, be32_to_cpu(mdb->drC=
TClpSiz));
>
> diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
> index 40a0feda7..e1345a6fe 100644
> --- a/fs/hfsplus/super.c
> +++ b/fs/hfsplus/super.c
> @@ -18,13 +18,35 @@
>  #include <linux/slab.h>
>  #include <linux/vfs.h>
>  #include <linux/nls.h>
> +#include <linux/lockdep.h>
>
>  static struct inode *hfsplus_alloc_inode(struct super_block *sb);
>  static void hfsplus_free_inode(struct inode *inode);
>
> +#include <linux/lockdep.h>
> +
> +#include <linux/lockdep.h>
>  #include "hfsplus_fs.h"
> +
> +static struct lock_class_key hfsplus_ext_extents_key;
> +static struct lock_class_key hfsplus_cat_extents_key;
> +static struct lock_class_key hfsplus_alloc_extents_key;
> +static struct lock_class_key hfsplus_attr_extents_key;
> +static struct lock_class_key hfsplus_start_extents_key;
>  #include "xattr.h"
>
> +static struct lock_class_key hfsplus_ext_extents_key;
> +static struct lock_class_key hfsplus_cat_extents_key;
> +static struct lock_class_key hfsplus_alloc_extents_key;
> +static struct lock_class_key hfsplus_attr_extents_key;
> +static struct lock_class_key hfsplus_start_extents_key;
> +
> +static struct lock_class_key hfsplus_ext_extents_key;
> +static struct lock_class_key hfsplus_cat_extents_key;
> +static struct lock_class_key hfsplus_alloc_extents_key;
> +static struct lock_class_key hfsplus_attr_extents_key;
> +static struct lock_class_key hfsplus_start_extents_key;
> +
>  static int hfsplus_system_read_inode(struct inode *inode)
>  {
>         struct hfsplus_vh *vhdr =3D HFSPLUS_SB(inode->i_sb)->s_vhdr;
> @@ -84,6 +106,51 @@ struct inode *hfsplus_iget(struct super_block *sb, un=
signed long ino)
>         memset(HFSPLUS_I(inode)->cached_extents, 0, sizeof(hfsplus_extent=
_rec));
>         HFSPLUS_I(inode)->extent_state =3D 0;
>         mutex_init(&HFSPLUS_I(inode)->extents_lock);
> +       switch (ino) {
> +       case HFSPLUS_EXT_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_ext_extents_key);
> +               break;
> +       case HFSPLUS_CAT_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_cat_extents_key);
> +               break;
> +       case HFSPLUS_ALLOC_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_alloc_extents_key);
> +               break;
> +       case HFSPLUS_ATTR_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_attr_extents_key);
> +               break;
> +       case HFSPLUS_START_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_start_extents_key);
> +               break;
> +       }
> +       /* Set lockdep classes for system files to avoid false positives =
*/
> +       switch (ino) {
> +       case HFSPLUS_EXT_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_ext_extents_key);
> +               break;
> +       case HFSPLUS_CAT_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_cat_extents_key);
> +               break;
> +       case HFSPLUS_ALLOC_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_alloc_extents_key);
> +               break;
> +       case HFSPLUS_ATTR_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_attr_extents_key);
> +               break;
> +       case HFSPLUS_START_CNID:
> +               lockdep_set_class(&HFSPLUS_I(inode)->extents_lock,
> +                                 &hfsplus_start_extents_key);
> +               break;
> +       }
>         HFSPLUS_I(inode)->rsrc_inode =3D NULL;
>         HFSPLUS_I(inode)->create_date =3D 0;
>         HFSPLUS_I(inode)->linkid =3D 0;
>
>
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/0bbb511f-6f0a-48b1-b3a4-e55eb907a1b4%40mail.kernel.org=
.
