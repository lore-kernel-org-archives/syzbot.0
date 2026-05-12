Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A9C395AE4
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 10:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582908; cv=pass; b=tM0nnFXO3JS60BLvatkgOt0YepiwhGvcrmCzietpzw3pW7sp+gE4v1TGz1MAV49vXPkmJ7LSEagHW2bXWDewQDlPIg4+afCGo6OX3ete3aGvpcTPzoXrocFZcU8H9nkB+rYNxgqGVyCCMgAt4xstZDJFAiix+y08h6TA8SUFLlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582908; c=relaxed/simple;
	bh=ZSPTbJrAbnmy3mYMT0Q3w2uQ+ylP+i8TQpQDgaxjAog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ULfQWE+AZ6d4onTu8NKUPqbCu/Dy51Sy8ZCyOIS9jjshhoP1J6spFiwy35+hGkZ0FVta87B+jhDDW1sLiTtdkvObLVAEHb5W+QilMBXqB58xyeH+3C0ysPAEFxFS85M8cCgY19jTwvTkNdaNjTvg//QrHRFKe6Xzf532j60/FCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HhnMto6y; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HhnMto6y"
Received: by smtp.kernel.org (Postfix)
	id 2CF36C2BCF6; Tue, 12 May 2026 10:48:28 +0000 (UTC)
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F3082C2BCB0
	for <syzbot@kernel.org>; Tue, 12 May 2026 10:48:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org F3082C2BCB0
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-691de293326so3180253eaf.3
        for <syzbot@kernel.org>; Tue, 12 May 2026 03:48:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778582906; cv=none;
        d=google.com; s=arc-20240605;
        b=jxCnHWCX3BlUdfnCpxPCMjyW9XpZVrjMXCUcnpJU0aVpWA9qC3XFiVYRmygflmEkcs
         1JLTxtfsgjRUabWE0e4MMOYfGP/l7FOT64EvD1wD6ElBceUdB1jFiHD6FNiTspwDlfBw
         G7hf91IAzrpP3I9VReYHjgXnnQYGMePPOTda2XEYHqMU9I9r0Q9gsUIQt3CQTl9Kqurx
         t82gDvGUwoC9LAPdIUjnhIVVuKP0bBEF/Y+AOtuQGyyEXb69LHzugCfw+iQF9cDPPnLC
         6L7Lg/qbN3K51D/OGO7tUem4NnVB3GPUjWu3DSWlVjj8ADbFv237aMU87uBnCyoIy3pc
         Q6JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JuUqFBPtKbvIZrmvrRNu78YQ9tWn/FI2hnG4mHcDw9k=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=WntGJY6YpKN5PFFpNtX+yS2oq/OF5vv3um6MrIN3ow/cphM6LzMXomv1yPDGb6os7j
         dKiihwnP2ICLVqfYdhyikYFTkCEmS0dt30FH9MkmTuAKMgRKRy79n4juzsX6nhW5q8Sx
         MjNt2rBWMLBgur7TZsev5M6QRW/w6Y88DArrqBQOts8Y7uWfqsb9rmP5rhtnPynitBur
         fE0hs7BjIu4kYRR6uujHoIkqkdSeu9NVjwWMOZ7T1U1+sr5D/0mJU8jkesbvnNoEg0H8
         bybn8mqY4m6sxZjAYWux3QUFp1SPpaL5HcrK75yhBZKpRvvYkATv9AcphkDyRhwttgdi
         Hgjg==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778582906; x=1779187706; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuUqFBPtKbvIZrmvrRNu78YQ9tWn/FI2hnG4mHcDw9k=;
        b=HhnMto6yMExkr/7oj1DfjweHdgL13pFBfLnDCgCf703i0lZ+JVk9aL2hOWPXVtAO6G
         yyym08KWIxT5QzMVVlmtoFBQAaLAYgEZ7/7qG9wXc9S7xf0pi4ojHn3ecIiO+omD9rIS
         zGORZyKjXuGK21M5SxR44jdiYPUdz7IhbQHZzY4X/ugXqwVC27H3vTEm7kVam0FGwSAq
         YVOom/BJzsuKQVPgOhr/Hb8mibdrAh+7VuNlDuEenktA2gBXbqwhlfjBNK0xSfCT8lK+
         fsdaeZwq53KxGCjg2b7D7pV7nKXnXOBDhc8iSPyuIPs9HA/THcdTtlS4J2fBtJ4AOn9I
         i+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778582906; x=1779187706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JuUqFBPtKbvIZrmvrRNu78YQ9tWn/FI2hnG4mHcDw9k=;
        b=HGy2GTkjWfLqJHWicF+z+OBLZNZzjRyc0Kv05LFEiyYh5GW0S4UNm4sFO8PzAwQ+M0
         hPW9TPVdagFVBDyF+a6dXu/1i5pfmi3SS5dGzEmndVF/W1zq+WMWYDy0OJ+1miXeOXNd
         acCVeJFu4lGAoz7DoNBoakKmCN3O2eoi0skIqYcHGpj5wrZuhREbdP7lbjkdNUyCAWg4
         dTwkvN+3iuotB2R9j2AxPir1fk+EESsWrnR7c13sGEHRIZyHZMVlejr/HZaYzuobaRqH
         O5az1qfpWagBEC5d8I0YKpM+uAbfPiIJN5LoZubH1FISmcZX5LxJViTi8Dh8RVJP182m
         dMBA==
X-Gm-Message-State: AOJu0YzDDDPAfham8tWjrWeu0R9kc6H4J1hpN+sVI+gW7yZskqO6CqUO
	msSTmOirTANN1nKniXQ6HFdiNlT/xgdkeQrh9LSKeKS9XOnhWMNNYNY8UvINlfx7g+2GI1bGF05
	0KjczJAKP6L5vpUYD8bn4vBrJLGiGlvUlTpcXUyMgb9F7Zy2IvZlTVhNe
X-Gm-Gg: Acq92OFRgrNF9tpaKjj70eoRXYbTvhVIX/kqG/pSHEjloFxdfJPDUOkeZXoRET0SjtS
	8HkWVKHYZynomWwuVyNP/oIxEyEU+0TF/+CI9S1/xsBSnx0Iky3S/FleeHr8kD+Poz8fmnjjYU5
	kUSSn4vy4d0v2LLrypdkKVrMiTe8QIRYavcOP5ytJxa72Jzvv2h4szNmlHr8axh4TdeRSffWYBz
	piKD8cGyUtVze6Swigfx4ybmgt5ubbAReSmGrl/sPgNV0nEipbSC/Dl8ZKvavyrVLxhnVEEh+81
	Z78PiAKh6UHiln/wMjWFal4HWRr5OJ7C1DO8lchK0cR3563h+yfXpCyx329lh7VIhQGslwMrcBo
	AoNyD
X-Received: by 2002:a05:6820:4df4:b0:696:806e:fd6 with SMTP id
 006d021491bc7-69998d299cemr16483838eaf.40.1778582905300; Tue, 12 May 2026
 03:48:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <c672c95e-82f0-4c76-9ba0-09e5133639cc@mail.kernel.org>
In-Reply-To: <c672c95e-82f0-4c76-9ba0-09e5133639cc@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 12 May 2026 12:48:12 +0200
X-Gm-Features: AVHnY4Jjko-TwFJxGLIAgSonPQRSc4NyZRuZJhQjdnnykL4PVteFHCjhpBciEbA
Message-ID: <CANp29Y6f4sQZJFZ=8fbETYSDUiMNTRa4J+Zv6s_OzLFbNY8q1g@mail.gmail.com>
Subject: Re: [PATCH RFC v2] hfs/hfsplus: fix lockdep false positive for extents_lock
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Have a look if you can further minimize the patch.

On Tue, May 12, 2026 at 11:19=E2=80=AFAM 'syzbot' via
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
> Fixes: 895c23f8c39c0c8d7b536bb2566d4aa968d78be2 ("hfsplus: convert the ex=
tents_lock in a mutex")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+b7ef7c0c8d8098686ae2@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Db7ef7c0c8d8098686ae2
> Link: https://syzkaller.appspot.com/ai_job?id=3D8c05b019-0a6c-4a92-8e06-c=
7a648023928
> To: <frank.li@vivo.com>
> To: <glaubitz@physik.fu-berlin.de>
> To: <linux-fsdevel@vger.kernel.org>
> To: <slava@dubeyko.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Removed duplicate lines (includes, lock class key declarations, and swi=
tch statements).
>
> v1:
> https://lore.kernel.org/all/0bbb511f-6f0a-48b1-b3a4-e55eb907a1b4@mail.ker=
nel.org/T/
> ---
> diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
> index 2eb37a2f6..9182ca939 100644
> --- a/fs/hfs/btree.c
> +++ b/fs/hfs/btree.c
> @@ -12,9 +12,13 @@
>  #include <linux/pagemap.h>
>  #include <linux/slab.h>
>  #include <linux/log2.h>
> +#include <linux/lockdep.h>
>
>  #include "btree.h"
>
> +static struct lock_class_key hfs_ext_extents_key;
> +static struct lock_class_key hfs_cat_extents_key;
> +
>  /* Get a reference to a B*Tree and do some initial checks */
>  struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_k=
eycmp keycmp)
>  {
> @@ -49,6 +53,8 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb=
, u32 id, btree_keycmp ke
>         mutex_init(&HFS_I(tree->inode)->extents_lock);
>         switch (id) {
>         case HFS_EXT_CNID:
> +               lockdep_set_class(&HFS_I(tree->inode)->extents_lock,
> +                                 &hfs_ext_extents_key);
>                 hfs_inode_read_fork(tree->inode, mdb->drXTExtRec, mdb->dr=
XTFlSize,
>                                     mdb->drXTFlSize, be32_to_cpu(mdb->drX=
TClpSiz));
>                 if (HFS_I(tree->inode)->alloc_blocks >
> @@ -61,6 +67,8 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb=
, u32 id, btree_keycmp ke
>                 tree->inode->i_mapping->a_ops =3D &hfs_btree_aops;
>                 break;
>         case HFS_CAT_CNID:
> +               lockdep_set_class(&HFS_I(tree->inode)->extents_lock,
> +                                 &hfs_cat_extents_key);
>                 hfs_inode_read_fork(tree->inode, mdb->drCTExtRec, mdb->dr=
CTFlSize,
>                                     mdb->drCTFlSize, be32_to_cpu(mdb->drC=
TClpSiz));
>
> diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
> index 40a0feda7..17147d5f5 100644
> --- a/fs/hfsplus/super.c
> +++ b/fs/hfsplus/super.c
> @@ -18,6 +18,7 @@
>  #include <linux/slab.h>
>  #include <linux/vfs.h>
>  #include <linux/nls.h>
> +#include <linux/lockdep.h>
>
>  static struct inode *hfsplus_alloc_inode(struct super_block *sb);
>  static void hfsplus_free_inode(struct inode *inode);
> @@ -25,6 +26,12 @@ static void hfsplus_free_inode(struct inode *inode);
>  #include "hfsplus_fs.h"
>  #include "xattr.h"
>
> +static struct lock_class_key hfsplus_ext_extents_key;
> +static struct lock_class_key hfsplus_cat_extents_key;
> +static struct lock_class_key hfsplus_alloc_extents_key;
> +static struct lock_class_key hfsplus_attr_extents_key;
> +static struct lock_class_key hfsplus_start_extents_key;
> +
>  static int hfsplus_system_read_inode(struct inode *inode)
>  {
>         struct hfsplus_vh *vhdr =3D HFSPLUS_SB(inode->i_sb)->s_vhdr;
> @@ -84,6 +91,29 @@ struct inode *hfsplus_iget(struct super_block *sb, uns=
igned long ino)
>         memset(HFSPLUS_I(inode)->cached_extents, 0, sizeof(hfsplus_extent=
_rec));
>         HFSPLUS_I(inode)->extent_state =3D 0;
>         mutex_init(&HFSPLUS_I(inode)->extents_lock);
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
-upstream-moderation/c672c95e-82f0-4c76-9ba0-09e5133639cc%40mail.kernel.org=
.
