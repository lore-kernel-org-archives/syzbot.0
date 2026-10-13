Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9509D4FECC8
	for <syzbot@lists.linux.dev>; Tue, 13 Oct 2026 19:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791920018; cv=pass; b=ii7/ZBeTztOjS/BB2eYWIfw9RIXo3+/u6CXhhBuzcGmymOZZCEzNy6c3sm5Hc/25zijYMTCVRAf/R2g+MqY4wTz4vJ4Vji2pw3dikA5MdR5I1Jb9O0VU3nUKw4v7DQttofHlN85BLe77Gli4wTDz1qwyLORebzUpXps+Gg3ltPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791920018; c=relaxed/simple;
	bh=RHMG6qkTEAPV0SdRj33HMGJHC1vgO3ieH6wEOXR1dQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R6EoTipnKBFXquBiEuPBSFw98BKf1xNQzsyLsDQB9kZ5T41tP9mT7Kt2yj9Zj8V38RsjUSmiii7eeu+gkcXXxlrNNSeIhSjIyOn0dKdhl2+rRU4SRDfUO9Ip97gjCCg33jcKcP7DE/6SsbG5CLMQAqcchZSqHfGIrsmQth644nc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E2MmmgKY; arc=pass smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E2MmmgKY"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-4b1fcd3b1a9so1229015b6e.0
        for <syzbot@lists.linux.dev>; Tue, 13 Oct 2026 12:33:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791920015; cv=none;
        d=google.com; s=arc-20260327;
        b=n1AmwGAdlRs4dpfXI/DuAFi9FSitTYS6fhrb2DfB6Nfo2o+OhZpG3SxpQOxbdXG8kL
         SKUNRuhefNPgJPnfTB0fpI9VfyPSkj4CFsQdQL2EqtZnpmFJIB2vNkiJ/P8HzpKvmAV/
         tcSCkB73n5PqdMT11PugqE/e1rUWzo7EKsYgS+AooRxqBn1cqpFVN7pkOfRe3SoNh/PC
         WyDDN1C5Kp/tcJGM8EhLiBYT9MtnNqvAzuJKDq1cnOKXAqnREaDY4Rlev02G5dLyVoDX
         bKu3vnmnc4L8yYqAa8UagPPpy5iVaW+K+UZIRlLwA1/FjP3kkMImgsVpB0Jg0IIDjUSD
         Ut0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xt1eAbzcvAsuG0gfhEvJQzvw1eXHsW6Oe4sxouGqH24=;
        fh=N1PEjkjxxQbbP9JvkDHmwwGi0N2tTNkcHiu03PmwuFY=;
        b=kXIjz82ygdlgYXtkMZ/isLV1jL31UwqoPiq2c6LovIN2jSH1XGZWR8dBb9GZFX8DA3
         qd0jH4VkcV9+XauYfp8yLOwV/IblKhCuRyr9riN3R2A1Vje+lIX0l/vCkD9i30594xiQ
         KP7wuxd01Tstw7FQYC/I/xWshN7zaIag3oRfPzopmP0nHP64fDNOk1m7jQfmf2MzTilz
         Mc3Y/INlfhDjak5U8HpzcBQk3nIgYks+2/u7pvvrmcVrOlS8LI1onovO+IrsnXaIUWHh
         Onp+S4idajjLCWBc0PX3VpVX/KrofoRU0zuDQ+47HE+PhEuFjfWphjX42NGk2Z4PURSn
         6UAQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791920015; x=1792524815; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xt1eAbzcvAsuG0gfhEvJQzvw1eXHsW6Oe4sxouGqH24=;
        b=E2MmmgKY4Wof3IqB39EGSNtv/opxILpirINpWRBOLTTDggIpZq/dfYUwUIUXD71K6h
         Dn8w8gxM5S+5cljWAZB5XVcjvMgy6vQeAmQFpOP0yMDyj/sN9/KrlFjvWCqznpKQRI4h
         WVOjSKGM+miuX9ubxebSuo/UxSLTa70k2fEYax0Dgqx9To0yao6+DfJ0XPV3ONGsmERT
         o56QteY99LA9IXQBqKWcvHvOuniGFS5f67N1K6FaqgToipraMMm2O8z7SeheXhXICdAf
         PyA79ZL0bbOOzz62o0BaT3mATTP2ZYZG8nMU/YawxV2fhZwul7LnpdIp7Gq/DYpbPYJQ
         DftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791920015; x=1792524815;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xt1eAbzcvAsuG0gfhEvJQzvw1eXHsW6Oe4sxouGqH24=;
        b=i0dVquZVaZg755DIDGaM5AtjZwRzh4UPW2p3C8YUEQbdHNXZG2+TRJAFb12V0Vy1yg
         vEsik6DfSLZrNA/XKDXBj6xAKEDqOYdlcdcEW3sW07Tth4GPgeAwclTqVX+CAiFkoSUY
         raMaqReVyVtbEg9jptxpwsJbgbA7+qBdNXBsp04uVQgBX/TBvKSGop+1jd4L0+ajjdQ9
         UvLhRPeCdHsJtC3wdmyVOAFzfrdhYJObaNmb575y0dshA/Md8pfL5zUeWwZG+rlmzN1X
         TxV/Cg2l4RkSgVSeFb3yG/liJ5szV6K1t2NQtokLqgeTNGpwF6jlrSYJqEjznfzO6VuC
         f5+Q==
X-Forwarded-Encrypted: i=1; AKwUvByVkQC86M9l0oV/UApVHNj9B0sTOOfPuF5D4CFgMU2Nlg04mjE6fyGjUuN4STq4vgQV6WRkf/E=@lists.linux.dev
X-Gm-Message-State: AFq9FYJunMiCyFbt81dKDO7sN33gV/85zwR9P21tnd3EQJGhBQlSn6eB
	Vbe0mWYpBrx/JKDCg9aghMt6YdoXZ/KoyAxUmuAxJq8phJ+AtU0SO2OORw/jHrmRCg6MPiigx3/
	q5WDOg/Zp9eiyBh3sP9S/3Bur9BktXYC6uQYlCJQF1Ks2sg28G0dZnyWZ
X-Gm-Gg: AYBFou1/28WyccPIJeriG8TL/wRT+WvCmOncIfmF/KC3LQ+b70i8jv+MGAShc+0T4SP
	4fp3aWOfI5akdCGYGxrbzIX4sOBwTRv+2MmN39Cesmp+8MR7diSda6vh2iiCR7wzTq0XMECbrpf
	4DcFyooZn7Q2JfJZ3WXK1V/wRMMoYbMn2V4vdN42BSlEFv7exqscQK3BoXlevZRDDjvWbP4hXij
	JkOL8fhRsIKbFx6xwItNYzcokWdpituFjgy2IY4OO2rd+gwua/SxIwFmGBCEkmG5CwhUjCa0Lir
	KgNFoXm/OTN9trXn1vk573O6gRSyKffhKhtiPC2nmtJBUjU4jqk5l+n1RxX8rZOO+Xq0rAEXWdS
	ZTSiIgugzG3vy1ca9j14ZYHxlNsCr8O3t+4N30NLppzfFrNkvo/k5fHNtcuZtzpPATExcrUHnvi
	J1lQJ+wkr/bvw9BMZHKM3aV8ZVDrhGsqz90Eym
X-Received: by 2002:a05:6808:320c:b0:4f5:41f:fdba with SMTP id
 5614622812f47-50c4ed3dc19mr12745651b6e.20.1791920014614; Tue, 13 Oct 2026
 12:33:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1aa7350c-565f-4f86-a95a-28fabee9abba@mail.kernel.org>
In-Reply-To: <1aa7350c-565f-4f86-a95a-28fabee9abba@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 13 Oct 2026 21:33:22 +0200
X-Gm-Features: AclHuK8ERQHyS1tWLJqbpRQm1L_2vNWCBAWB0f-eXCWBFlTmLZ_R9FG2SNIUDE8
Message-ID: <CANp29Y6GYwxgV02cyPRqkEBHX3v8-v9E9rSHmKUmg=qMKDR7Ow@mail.gmail.com>
Subject: Re: [PATCH RFC] minix: restore buffer uptodate flag on persistent
 metadata buffers
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz reject

(there's already a pending fix upstream)


On Tue, Oct 13, 2026 at 12:09=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When a minix filesystem experiences a writeback failure on a block device
> (for example, when an underlying device is detached or encounters an I/O
> error), the block layer I/O completion handler clears the BH_Uptodate fla=
g
> and sets BH_Write_EIO on the failed buffer head. In minix, the superblock
> buffer (sbi->s_sbh) and bitmap buffers (sbi->s_imap and sbi->s_zmap) are
> read at mount time and kept pinned in memory in minix_sb_info throughout
> the lifetime of the filesystem mount. Although their in-memory data remai=
ns
> valid, when subsequent operations modify and re-dirty these buffers=E2=80=
=94such as
> during unmount in minix_put_super() after sync_filesystem() attempts
> writeout, during remount in minix_reconfigure(), or during inode and bloc=
k
> allocations or deallocations=E2=80=94mark_buffer_dirty() checks the uptod=
ate state
> and triggers a warning:
>
> !buffer_uptodate(bh)
> WARNING: fs/buffer.c:991 at mark_buffer_dirty+0x299/0x410 fs/buffer.c:991
> ...
> Call Trace:
>  <TASK>
>  minix_put_super+0x16d/0x460 fs/minix/inode.c:70
>  generic_shutdown_super+0x13d/0x2d0 fs/super.c:751
>  kill_block_super+0x44/0xa0 fs/super.c:1903
>  deactivate_locked_super+0xbe/0x110 fs/super.c:586
>  cleanup_mnt+0x204/0x2a0 fs/namespace.c:1392
>  </TASK>
>
> Following the pattern in ext2, ext4, and udf, fix this by restoring the
> BH_Uptodate flag and clearing any write error on persistent metadata
> buffers before marking them dirty. Introduce a helper
> minix_set_buffer_uptodate() to clear BH_Write_EIO and set BH_Uptodate if
> the buffer had an error or was not marked uptodate. Use
> minix_clear_super_error() to log any prior superblock I/O error via
> pr_err() and restore the uptodate flag before dirtying the superblock in
> minix_put_super() and minix_reconfigure(). Similarly, call
> minix_set_buffer_uptodate() before mark_buffer_dirty() on block and inode
> bitmap buffers in minix_free_block(), minix_new_block(),
> minix_free_inode(), and minix_new_inode(). Transient metadata buffers (su=
ch
> as raw inode blocks and indirect blocks) are left untouched so errors
> propagate normally.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+d35de3666410c93fd821@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd35de3666410c93fd821
> Link: https://syzkaller.appspot.com/ai_job?id=3D6f8ed031-e95a-4ac4-a2bd-3=
033ec4cadd9
> To: <linux-kernel@vger.kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> Cc: "Christian Brauner" <brauner@kernel.org>
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Cc: "Jan Kara" <jack@suse.cz>
> Cc: "Jori Koolstra" <jkoolstra@xs4all.nl>
> Cc: "Michael Bommarito" <michael.bommarito@gmail.com>
>
> ---
> diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
> index abec43833..1650d22c3 100644
> --- a/fs/minix/bitmap.c
> +++ b/fs/minix/bitmap.c
> @@ -64,6 +64,7 @@ void minix_free_block(struct inode *inode, unsigned lon=
g block)
>                 printk("minix_free_block (%s:%lu): bit already cleared\n"=
,
>                        sb->s_id, block);
>         spin_unlock(&bitmap_lock);
> +       minix_set_buffer_uptodate(bh);
>         mark_buffer_dirty(bh);
>         return;
>  }
> @@ -83,6 +84,7 @@ int minix_new_block(struct inode * inode)
>                 if (j < bits_per_zone) {
>                         minix_set_bit(j, bh->b_data);
>                         spin_unlock(&bitmap_lock);
> +                       minix_set_buffer_uptodate(bh);
>                         mark_buffer_dirty(bh);
>                         j +=3D i * bits_per_zone + sbi->s_firstdatazone-1=
;
>                         if (j < sbi->s_firstdatazone || j >=3D sbi->s_nzo=
nes)
> @@ -207,6 +209,7 @@ void minix_free_inode(struct inode * inode)
>         if (!minix_test_and_clear_bit(bit, bh->b_data))
>                 printk("minix_free_inode: bit %lu already cleared\n", bit=
);
>         spin_unlock(&bitmap_lock);
> +       minix_set_buffer_uptodate(bh);
>         mark_buffer_dirty(bh);
>  }
>
> @@ -243,6 +246,7 @@ struct inode *minix_new_inode(const struct inode *dir=
, umode_t mode)
>                 return ERR_PTR(-ENOSPC);
>         }
>         spin_unlock(&bitmap_lock);
> +       minix_set_buffer_uptodate(bh);
>         mark_buffer_dirty(bh);
>         j +=3D i * bits_per_zone;
>         if (!j || j > sbi->s_ninodes) {
> diff --git a/fs/minix/inode.c b/fs/minix/inode.c
> index daf83e4ff..c715f37a5 100644
> --- a/fs/minix/inode.c
> +++ b/fs/minix/inode.c
> @@ -59,6 +59,18 @@ static void minix_evict_inode(struct inode *inode)
>                 minix_free_inode(inode);
>  }
>
> +static void minix_clear_super_error(struct super_block *sb)
> +{
> +       struct minix_sb_info *sbi =3D minix_sb(sb);
> +       struct buffer_head *sbh =3D sbi->s_sbh;
> +
> +       if (buffer_write_io_error(sbh) || !buffer_uptodate(sbh)) {
> +               pr_err("MINIX-fs: %s: previous I/O error to superblock de=
tected\n",
> +                      sb->s_id);
> +               minix_set_buffer_uptodate(sbh);
> +       }
> +}
> +
>  static void minix_put_super(struct super_block *sb)
>  {
>         int i;
> @@ -67,6 +79,7 @@ static void minix_put_super(struct super_block *sb)
>         if (!sb_rdonly(sb)) {
>                 if (sbi->s_version !=3D MINIX_V3)  /* s_state is now out =
from V3 sb */
>                         sbi->s_ms->s_state =3D sbi->s_mount_state;
> +               minix_clear_super_error(sb);
>                 mark_buffer_dirty(sbi->s_sbh);
>         }
>         for (i =3D 0; i < sbi->s_imap_blocks; i++)
> @@ -153,6 +166,7 @@ static int minix_reconfigure(struct fs_context *fc)
>                 /* Mounting a rw partition read-only. */
>                 if (sbi->s_version !=3D MINIX_V3)
>                         ms->s_state =3D sbi->s_mount_state;
> +               minix_clear_super_error(sb);
>                 mark_buffer_dirty(sbi->s_sbh);
>         } else {
>                 /* Mount a partition which is read-only, read-write. */
> @@ -162,6 +176,7 @@ static int minix_reconfigure(struct fs_context *fc)
>                 } else {
>                         sbi->s_mount_state =3D MINIX_VALID_FS;
>                 }
> +               minix_clear_super_error(sb);
>                 mark_buffer_dirty(sbi->s_sbh);
>
>                 if (!(sbi->s_mount_state & MINIX_VALID_FS))
> diff --git a/fs/minix/minix.h b/fs/minix/minix.h
> index 78722ce22..b0806cd23 100644
> --- a/fs/minix/minix.h
> +++ b/fs/minix/minix.h
> @@ -5,6 +5,7 @@
>  #include <linux/fs.h>
>  #include <linux/pagemap.h>
>  #include <linux/minix_fs.h>
> +#include <linux/buffer_head.h>
>
>  #define INODE_VERSION(inode)   minix_sb(inode->i_sb)->s_version
>  #define MINIX_V1               0x0001          /* original minix fs */
> @@ -43,6 +44,21 @@ struct minix_sb_info {
>         unsigned short s_version;
>  };
>
> +/*
> + * Persistent in-memory metadata buffers (superblock, inode/zone bitmaps=
)
> + * are read once at mount time and kept pinned. If a previous writeback
> + * failed, BH_Uptodate was cleared and BH_Write_EIO was set. Restore the
> + * uptodate flag and clear the error before dirtying so that mark_buffer=
_dirty()
> + * does not trigger a warning.
> + */
> +static inline void minix_set_buffer_uptodate(struct buffer_head *bh)
> +{
> +       if (buffer_write_io_error(bh) || !buffer_uptodate(bh)) {
> +               clear_buffer_write_io_error(bh);
> +               set_buffer_uptodate(bh);
> +       }
> +}
> +
>  void __minix_error_inode(struct inode *inode, const char *function,
>                          unsigned int line, const char *fmt, ...);
>
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
-upstream-moderation/1aa7350c-565f-4f86-a95a-28fabee9abba%40mail.kernel.org=
.
