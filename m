Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0512B41A516
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 09:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785923941; cv=none; b=lZz84p8RIpiftQmyVoHPEpaIUi3deGRWLwvDlmnPNmWvh86QWzbn4JSKDB46s7pLFEZIADKG6XH5LvQkpVy12J8uvhepM7Vcsy5Z3jT4YEy4TOdHGdkHta3EVx8xAFzzae9eySIIml5Z1vdIaq28M3vf1tSzYU0AEGMTQPVVhzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785923941; c=relaxed/simple;
	bh=c7YIVA+SG+qzFPXxkLgUdQa2D+RAa4Xove/Ai1/Z7uA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MO5bAEypaPbiefY+I2POzWWxBEqVtAwRgWveEvmQDGPrWVSNLEOtUOWKRd5YjMix7AF2pZxPfM7t67aAWRodShK6mSvNi43lcyOmRNVTnRe1F9zU/fBuAI7nxFKENdqFf61HIkEWLkTpt8bPm9PHZWI/5t6fqPw0botaa9Whrho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ripjS4f/; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ripjS4f/"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so6166405e9.0
        for <syzbot@lists.linux.dev>; Wed, 05 Aug 2026 02:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785923938; x=1786528738; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1/iHo2xERAnExVG+3ChTm788wqBgAkaZ40GV3g2etAI=;
        b=ripjS4f/wpQYKvQbbKYqqUydP5rLw1KOyRZUxIP5Z7J68iG0LzTPLctGy/PrDZiQIg
         16OU2K25F2SUJUcO8aW+h4MjHZ+zOb/w6plfN+xVeV3veo2ziOue7WFfblO5o15qyubZ
         EiD8x8XKN7LvDKz3M5Dvc6jpJJpzODf92X01wMcWz6Uw+NsoshaIP0Wi8bSYoFIycW5Q
         ZnEhkie8Tg4dOecx2GyZtrHbQ423dPpZzdDCPEnrlkPJUiaOOg1Ilufn4njnnCyZ+kxd
         qwlZPDXYp69I8zFj6mJ2LPyy4EjmfG9PUvaLGwrcKzNnQpMnL+I15a3dGD863L4G+nMM
         FQ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785923938; x=1786528738;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1/iHo2xERAnExVG+3ChTm788wqBgAkaZ40GV3g2etAI=;
        b=rkWWmKzVBw9e2a64qnPk8+H+j7zOSTvlUmXtMvtE92S2pkfkfDL5IrExIbVfURKEwb
         w/3IiNHx//CXqTWXlnMxtQgREZeyf9rleGwebIUoFHHYq7vXcyz6cnUr1I1WyhtnPbjB
         OnnwwMZGz85DyIThAWtDko7ccAczwHU/Fick6hO5nGtH86KZxofrGu8qiX9nBDRg5UYO
         OwOQUEduRBceHcm1jm/bJ81L0GiFDNe4zB/HWhLaH28Y7j0kcB80KkXZgyzfv95NvKNd
         sbjzixLaLoIP42mzP9haAqLnopDhq+1/gv7naI2R+m68qpkmGDH2b8FFmcLfSnwgYJe8
         LfgQ==
X-Forwarded-Encrypted: i=1; AHgh+RoyvEFrtvclEQ8VoRuILWkUrAi/2lxgL8U0LUyT1so0SnBqleeGHQJOdhta5Rl4urmdE5yISck=@lists.linux.dev
X-Gm-Message-State: AOJu0YybJ/rMIXHSiX3db+dR0Ktv1fb5iY9pz1P6TZbY/SHveI00aCzm
	DkBPqrQt0WV5FIkdslZD8JFVn+vXNP0FcRU9UIqvdf1+PUMDRW9ZY2Tf
X-Gm-Gg: AR+sD13ZXo7Pa3KjbOcTpzbwMeEuh15V+rhlTM31DaF4YUZa1qRgF/7yNZfz8VAW7VY
	pJ60We+H3FVASbCfxG4Daj2d+zmuEMIVFrfBIsLuT5V95XFpWod4LJ63Xxagxz5Bp+oz2wYNdDK
	VtvrO5L7t6Xky/GdKWgFkpJcWWh9zrD6Mw18pT2BNIteoT1PfAjDdBQa2yaAlvgHanIkmpelQQV
	7EQhpEFMf+dZyTTD0+fToxfLzcqzCLjlPO4LlEGX2IQMOn74Gpu+xCh89AlUMSiw07vSo/4UzBF
	kw7IU/yigcxNUibfoRE1MTmNKbe79zt04kjaZyL+Sd9DKZnGNo0NNP/XoMWJyhX3J9tUHJX25e7
	CjsNwNcQITl0WaEb5ZQc9njpkOHv0URyuBOGTs6wdiC2S0TpPoiUelPLkhs6pNMIIw9H7ha5hfM
	vESV6ZFeFiRUgc3nlxtp0cZ5L+d0j+YugsBBHCU2GQECbCw8mB93+gXKLx7QMBgYx0vzDWvTZG3
	e7ZiEXAol+ODg==
X-Received: by 2002:a05:600c:4e87:b0:493:e365:ace9 with SMTP id 5b1f17b1804b1-4994e7c0356mr61353515e9.11.1785923937984;
        Wed, 05 Aug 2026 02:58:57 -0700 (PDT)
Received: from localhost ([37.30.50.82])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49949fcb46esm188721605e9.5.2026.08.05.02.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 02:58:57 -0700 (PDT)
Date: Wed, 5 Aug 2026 11:58:56 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Yan, Zheng" <zheng.yan@oracle.com>, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] btrfs: commit current transaction in
 btrfs_relocate_block_group
Message-ID: <qh7zryk22vobwtwcf2swvi4hnspqu2rdrgqv7k6el64oxlyo7c@lqxxk46og5ju>
References: <a06b5077-baa5-473f-9c65-bf72ac651b14@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a06b5077-baa5-473f-9c65-bf72ac651b14@mail.kernel.org>

#syz reject

On Tue, Jul 28, 2026 at 08:45:36AM +0000, syzbot wrote:
> From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
> 
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
> Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
> 
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
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
