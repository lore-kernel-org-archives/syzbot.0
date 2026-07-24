Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BA93264CC
	for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 17:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784912946; cv=none; b=Zd+euaiYdpQhRXCBAWKPN9VVctWrY2KiE4hXphkJbhmi+CiZ8HMrzUsITsehDsnw4l5GHQ3RnTPe428Evp/uK9DLwRX4VaOgCKbsIXAygTPrQhcBPjHn0AdZJAnmaRrzh/r9iTjUrtxzbhnOVtXd0FHA6IcrKMtbljpIwE95v0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784912946; c=relaxed/simple;
	bh=WSwCCFr9uUeLQf0ePG5IMrLy5xAWXXJCSxGRLiu/UNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOgt59hvG6NBswU0jeVtN3tzbisZgtOOvX8AAwzkb9eRqh/IcJNBgtHPZMf5N/F8EJJPcOlCbNXjH9IKH7txmacKj4TfinO2yK2JvdR5uvxmIPkELkvbtkG1d3um6j4R01yg2GlEloJLB0Fd5Z4FFuzl4vNuLod5K2U2zm5x+wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hwjPOpl5; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwjPOpl5"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49550ec592cso11621185e9.0
        for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 10:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784912943; x=1785517743; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sFqSbTBPsgjnSjR7z8FYH6XOOuY7exn09GLruisgu1k=;
        b=hwjPOpl5bDNy/GPvoby5RbNXM8pOo4GJZ2VF/mgFJ+qV4S1N4VVEn+fuw7vcHSqPj7
         cbWlz5gd7b0IEz1yn8eYrLSzzvAwORAaGaegDTEK4w5qxTyMuFCKqPlLDIwn75mwJbxB
         1AyxqdGFVLQ60r9Pz8syjkuO7KeN3Z/7Ha8i2Q/rLbY/Z3y7w2a9bIybI8GUoZQOhwR3
         YGy9v2Im1Nct60P5T1ORXu+4B8C6Mrc8HBMkeWubP5TDdGsYX2tZEPRl1D2to5vTa8zR
         MOGnPJUS03yodWaWociT8DXd16at9cvLzDdv100sgYVGavdZuoi3OOnfePzonks8ZACS
         DtBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784912943; x=1785517743;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sFqSbTBPsgjnSjR7z8FYH6XOOuY7exn09GLruisgu1k=;
        b=ommwp9Z+Uj8YV7Cf5xby9Kvuve5HIoy7CKixKkXwsdA5u2feMb0vR9HNw7nLgNXGRQ
         6hK/I2ijYWUfu1De+9NWf79b/lwimrYysL/xRONkwmuJ2VNBO5eo8Xm0AvN37y1MAFfV
         BedtbMXc1FXM/ANVWkGjbeJX4zo/8/3ZQJI2AnW5wXIdD5f2AlKM5S02QskE9ukPdrWx
         FjSyOrhVMfkEwjhH+FtukcQOycvvxivHohrt/mDAgcca4WS520+YxUJmccNkAiAiulHE
         COyvAbX5NluqOYQ3KdpsYIZBykbqflnCxCpHjNjcwclXtRAU3op8thF0zvztUzRZ2DMJ
         e3Nw==
X-Forwarded-Encrypted: i=1; AHgh+RpHf1LBMgWhbTdXSd+9hS+Oaqj8WorxKV+31YK7OIS0V3VSEdpWgg2x+QX6WU9XIW4qmoys8fM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjaN3A4h2XcvTitgo1WoG38K23+AeKB/Pkbb/ZcXo2OMPbfH/6
	HBq1LH19OBcyMQbU2BWtjICjCpM1rFM1qecTIQDUd01YEV7/jQeAQsWB
X-Gm-Gg: AR+sD11W6bBj27vsZ2A2jCbe6bI2uVr2kAAtjZ4tSTcqjysADYvEfFB8GJS/Nv18Kus
	5P1xzckFikptc02rkm4vehnw5X7Yqt3JZaaz6bKqSsVQDb6wr/+RHkIFaRmbkB4SChBo+pLKdeG
	n4WckKcGBlBRK4vhhFjnG6YYEHF+Ck43tiRysWKSsIa+t8+417HAH0xxpxucOJnsC8CbgWp8kiA
	zwNGt5cmLNIMEgIDChl/a7cbsGlycFwjixuJTBdKZM/gUlzhGrsV6IyYIAxvpLqlvjbNr9YwGzu
	+XX51lD7x4cUgQG6K/UZVcudIjNJ0tYTIpcO+LVlPsPmvzTh1QfwQArjetcBGzk8JEMvp8YhM4N
	t0qRcgcMf9R2uTyckb+0wqBBrZdQkqSzV0HCDskEsDGtHT/Ia0bfCuasr7qMHr0m5wdICDP00k3
	ymfP7UOqNRjhOaTYdxxN4CSJIWVKJl
X-Received: by 2002:a05:600c:8714:b0:493:f478:4c71 with SMTP id 5b1f17b1804b1-496997235cemr18413145e9.7.1784912942459;
        Fri, 24 Jul 2026 10:09:02 -0700 (PDT)
Received: from localhost ([37.30.44.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b48580f5sm5222755e9.1.2026.07.24.10.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 10:09:01 -0700 (PDT)
Date: Fri, 24 Jul 2026 19:09:00 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] btrfs: commit current transaction in
 btrfs_relocate_block_group
Message-ID: <hrj474vzjx3km6vsa24qhap7u4p2by7jfvt2pyqvzz6ihoc4y3@xenyhxrzl42r>
References: <38fe7b3f-75f7-47c9-9554-db7628338b20@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38fe7b3f-75f7-47c9-9554-db7628338b20@mail.kernel.org>

The v2 code change is correct: btrfs_commit_current_transaction() is in the
right place after reloc_chunk_start() and before btrfs_inc_block_group_ro(),
and the goto out branch preserves the required cleanup if the transaction
commit fails. The reproducer supports the fix in the tested scenario: the
target warning appeared in three of four unpatched VMs and in none of four
patched VMs. The patch is not ready yet because the Fixes: trailer and commit
message still need correction.

The new transaction drain does not replace the existing
btrfs_commit_transaction() in prepare_to_relocate(). The new call drains
earlier transaction work while the target block group is still available for
allocation. The existing call commits the relocation setup after
create_reloc_tree is enabled and reloc_ctl is published; relocation-root and
backref-cache handling depend on that transaction boundary. The warning
appears in this existing later call, but the ordering bug is introduced
earlier. Removing the existing call or changing only its error handling would
move or hide the failure.

The full build and both normal and strict checkpatch.pl runs passed.

Two parts of the commit message still need fixing:

- The Fixes tag should be:
Fixes: 3fd0a5585eb9 ("Btrfs: Metadata ENOSPC handling for balance")

72bd2323ec87 changed btrfs_update_root() error handling and did not
introduce the relocation ordering changed by this patch.

- Please describe the new call as draining the current transaction before
the block group becomes read-only. It should not claim global settlement
of every reservation or later transaction. Please also say why the setup
commit in prepare_to_relocate() remains necessary.

On Thu, Jul 23, 2026 at 04:17:10PM +0000, syzbot wrote:
> During block group relocation, btrfs_relocate_block_group() is called to
> relocate a block group. It first makes the block group read-only by calling
> btrfs_inc_block_group_ro(). If there are pending space reservations or
> pinned extents in the current transaction, making the block group read-only
> or subsequent relocation steps can fail, leading to a transaction abort and
> a warning in cleanup_transaction() during the transaction commit in
> prepare_to_relocate().
> 
> To fix this, commit the current transaction before calling
> btrfs_inc_block_group_ro() in btrfs_relocate_block_group(). This ensures
> that all pending extents are unpinned and space reservations are committed,
> providing a clean state for marking the block group read-only.
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
> Fixes: 72bd2323ec87 ("Btrfs: do not abort transaction at btrfs_update_root() after failure to COW path")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
> Link: https://syzkaller.appspot.com/ai_job?id=1627ee87-ad22-4097-8936-8e307d6ddb4b
> To: "Chris Mason" <clm@fb.com>
> To: "David Sterba" <dsterba@suse.com>
> To: <linux-btrfs@vger.kernel.org>
> To: "Filipe Manana" <fdmanana@suse.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Replaced the transaction abort changes in the commit path with committing the current transaction before making the block group read-only during relocation.
> - Removed changes to fs/btrfs/qgroup.c, fs/btrfs/root-tree.c, fs/btrfs/transaction.c, and fs/btrfs/transaction.h.
> - Added a call to btrfs_commit_current_transaction() in btrfs_relocate_block_group() before calling btrfs_inc_block_group_ro().
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
