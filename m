Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F189C27AC31
	for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 08:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228134; cv=none; b=BWbRHPX+QFA3D1Ijf7GmTdjtRzDcQxPL5IbAB6UzN2fwN0B6f4KOwAk5NHvwctco+EKISiQmwN8eMRWbzM3SE2khv7RvIuuKD6jGVF7rBXnASOhqyc6E6tTjnyAJ48rYVQZjTyOfoJo2z+xH/mg1MXRmh5LUgZI6/vt6s/4pArQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228134; c=relaxed/simple;
	bh=nfFcPmxI+74EKN7q29+Rdper4rjWOK539kX8fjOxWDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tBsv+ljoKNnUCztSH6wwdawwPGiEyEvOvJ4QL6Ks3HXel1drM9Di6IEBVccUHmAuNZJ/oXD69VYgyWaxKg7wlUYYarsqHHdJM9wOuJkNG3KBE7y2qL1UFMLsbLLLThue2OLcq/b1eW8/g2nAeUlOrSrVkhATKobrglmDhZZHIL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rTF9sk8q; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rTF9sk8q"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f7854678bso1232423f8f.3
        for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 01:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785228131; x=1785832931; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bVH5hSQu8se2IRpTGtoJ/1TfrAKkJKAktGzo5AqeF7Y=;
        b=rTF9sk8qIXgdp1v445AMhxBd7lu1sNGTRoupVmUVgBVoLJkxVFe+zuGxgp5sFQD/kV
         k8gfVVm2Cy8krLFfi52BIiZOIgnrv0PMGQWuDDSH1KzhC94O7UT9y2VQayy8wE965LLO
         4L+Uzl7rb7agePrIw0cnqe1IqvWzsBIn8aZzghowFaTmVYKBNgN0t39DVi22Za/eKCJO
         ltLSfezOVeKiryA26bO/WL87jyE1Zc83GSxIzG/wU7t6Ak8s7VU/QMJ0fA+o1MY9rdXa
         Jb0LnCsnnTSetoMhTh0jG+aCY6HxKKpAHss16LOT5zR7/jKZDTVhbibBSWCX1Jv6Yqgg
         6X4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785228131; x=1785832931;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bVH5hSQu8se2IRpTGtoJ/1TfrAKkJKAktGzo5AqeF7Y=;
        b=baI5SA6ZwT5oASfs7nBHboAjTZBKK45Bj7gzcA9FM1e+3apZNb8lSihnYFXuwNIG55
         4ZUo4K/izeGUITrJf+zXQXlyjtA5IFfJAIT4SHeKs6dXL9arqCqEo8ktWrx7VRDZnNQ7
         KU3kThi+dSlbeIdpnQlJBbh7+lJh31+C3jsN8OPGrq80y+HrJkjR4NeybGsZmKvYBCTF
         olu995dnLDWYj1hDzOhIpSh0LWLJqDC9VOy61A9colDiCjtJcAJue45UzuFzxtHYIgJy
         esHte/Ys/G9DwmTS1z+gu9dpwhgoGKg3/V/YTHyVD038bn7WPIDgn1tIIbCg4DU2kuwZ
         e/lg==
X-Forwarded-Encrypted: i=1; AHgh+RqCbOJ2qjPuxUdh/oiMcfUzbWPhrVPalTmnPNF8ppyhceN+Cq0OgH4KZVD4E1GlSvhvOjjQPCE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJYkCU0Sje8hPXdU0tYvAHJ0breNc8F+9a4J9e9dik0DMQU523
	4aV1hzVOWRzq1WBATjYxJkLiXPaf4HjOEdwwRJS3px4/Id46avbJtJIXivl5av0rrg8=
X-Gm-Gg: AR+sD12oErMa77mzA3WBKn55AtihNYogfRogcm1CqArGoLDciTGqDlBbRY3q1oBY3JK
	BAiLO4KViueggVPm+WaCEFJOq6MxY3Q+HY/No+czOzEIc3Ur2Fj0y6Tla/R5BOAyNSjmd7Sr70j
	yB9b/999Wg94dPWH96EWRx05TJ94M36gIDcPvcZbnY6n/y09BL5RXUAh64ozvPxP/k27lTOcnCR
	/1UcMVzN1gRG5DloHd2F7piKA9sPRrTuW4IcsTNWxY1h97hCmwFtryFB5ph3+VJwa9jDKMHElf+
	ExCJ52Ho2kaGy+ATV5Dx8IVpL+mIYYYRfZrn7RaUnfIYz2utI23b42S3hndmVn5B7T+XlePozzd
	GYz2/WbTVhrZSeOrYxufGnDH1yHoCBuZCR4XelHyNqikYyBGPpA/CNVefvOh75dz/SmjSkCcZ50
	P65EkFHdQu+xc+gUAZKNa3msTdu/MD
X-Received: by 2002:a05:6000:990:b0:47f:8e50:93e0 with SMTP id ffacd0b85a97d-47fb1f16973mr1619510f8f.39.1785228130836;
        Tue, 28 Jul 2026 01:42:10 -0700 (PDT)
Received: from localhost ([37.30.44.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a5a2sm61853077f8f.7.2026.07.28.01.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 01:42:10 -0700 (PDT)
Date: Tue, 28 Jul 2026 10:42:08 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] btrfs: commit current transaction in
 btrfs_relocate_block_group
Message-ID: <tsuwlgwlnsgq36q7d336qhvt6he44keajnx7wi3xl6otoqsej3@qqj2ta2ov5iz>
References: <7937faea-63c9-4d7b-8d2b-673ff9c75df8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7937faea-63c9-4d7b-8d2b-673ff9c75df8@mail.kernel.org>

#syz upstream

On Fri, Jul 24, 2026 at 10:24:30PM +0000, syzbot wrote:
> During block group relocation, btrfs_relocate_block_group() is called to
> relocate a block group. It first makes the block group read-only by calling
> btrfs_inc_block_group_ro(). If there are pending space reservations or
> pinned extents in the current transaction, making the block group read-only
> can fail, leading to a transaction abort and a warning in
> cleanup_transaction() during the transaction commit in
> prepare_to_relocate().
> 
> To fix this, commit the current transaction before calling
> btrfs_inc_block_group_ro() in btrfs_relocate_block_group(). This drains the
> current transaction before the block group becomes read-only, ensuring that
> pending extents are unpinned and space reservations are committed. This
> does not claim global settlement of every reservation or later transaction,
> but it provides a clean state for marking the block group read-only. The
> setup commit in prepare_to_relocate() remains necessary because it commits
> the transaction started during the relocation setup (such as creating the
> reloc tree) to ensure everything is in a consistent state before starting
> to move extents.
> 
> WARNING: fs/btrfs/transaction.c:2068 at cleanup_transaction+0x727/0x7c0
> Call Trace:
>  <TASK>
>  btrfs_commit_transaction+0x262c/0x30b0 fs/btrfs/transaction.c:2664
>  prepare_to_relocate+0x3dd/0x4e0 fs/btrfs/relocation.c:3541
>  relocate_block_group+0x141/0xe90 fs/btrfs/relocation.c:3566
>  do_nonremap_reloc+0xa7/0x560 fs/btrfs/relocation.c:5323
>  btrfs_relocate_block_group+0x6e2/0xaf0 fs/btrfs/relocation.c:5490
>  btrfs_relocate_chunk+0x114/0x830 fs/btrfs/volumes.c:3647
>  __btrfs_balance+0x1b6e/0x29e0 fs/btrfs/volumes.c:4586
>  btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:4973
>  btrfs_ioctl_balance+0x3dd/0x640 fs/btrfs/ioctl.c:3474
>  </TASK>
> 
> Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
> Link: https://syzkaller.appspot.com/ai_job?id=ca6bd6c4-fbcf-4533-af07-79b4a0eba74d
> To: "Chris Mason" <clm@fb.com>
> To: "David Sterba" <dsterba@suse.com>
> To: <linux-btrfs@vger.kernel.org>
> To: "Yan, Zheng" <zheng.yan@oracle.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v3:
> - Updated the commit description to clarify that the new call drains the current transaction before the block group becomes read-only.
> - Clarified that this does not claim global settlement of every reservation or later transaction.
> - Explained why the setup commit in prepare_to_relocate() remains necessary.
> 
> v2:
> - Replaced the transaction abort changes in the commit path with committing the current transaction before making the block group read-only during relocation.
> - Removed changes to fs/btrfs/qgroup.c, fs/btrfs/root-tree.c, fs/btrfs/transaction.c, and fs/btrfs/transaction.h.
> - Added a call to btrfs_commit_current_transaction() in btrfs_relocate_block_group() before calling btrfs_inc_block_group_ro().
> https://lore.kernel.org/all/38fe7b3f-75f7-47c9-9554-db7628338b20@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/1586eaf3-2208-42eb-8877-7c4f83a6638c@mail.kernel.org/T/
> ---
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index fb85bc8b3..05f5110c2 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -5430,6 +5430,10 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
>  	if (ret < 0)
>  		goto out_put_rc;
>  
> +	ret = btrfs_commit_current_transaction(extent_root);
> +	if (ret)
> +		goto out;
> +
>  	ret = btrfs_inc_block_group_ro(rc->block_group, true);
>  	if (ret)
>  		goto out;
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
> -- 
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
