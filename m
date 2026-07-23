Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F6E330D24
	for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 14:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816331; cv=none; b=fkXVM8/bTv7Fe+u+TT0Acn4t+RCh/ZHcxAWOjarKSw7aybzdt8atY3SdBXLXGV3cKUnQR0Uab1dMHFI+RJac/KAkbpUbFmcKLie+rPQCmHg0woyAgy1fLLguZU+JUDtG0RvochZ2qZBOFz37EmkCLaCi3+/0S93jqem453Lig4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816331; c=relaxed/simple;
	bh=fSOsLMqFsNwQ6LfeGbqpjkkwwQ0uemHptk+1w1uT+xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDuV2A4FdpjJ2IsXvDjY3RZYl2C1j95Y7mw+LsJh9Sj0TrCrWeTUkyMUJB63V/uXB43P2QH1jfZTq2S1GFKtZhPTR+Up+0uPlJ39M5FZeNHCC6yjQqSVBZasTdr8f2TnlkeFFFEnh/jut6yfK3S5U1TFoCWWajunhszP/mj6+Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hM4HDjnO; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hM4HDjnO"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so642440f8f.2
        for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 07:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784816328; x=1785421128; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k7YPn/3Uc65SEdSr61RZf3k1k3PjwWDYhrEN1V+kRhk=;
        b=hM4HDjnOY+0Bo1SOAwj6WcrAY3kmZjOG0YmiIykhBwaiefi0U+3oKuyqcrsVK3lgsJ
         os4yqbKbkaEABT06SHcu0aaGJMmabgQEhH/McsMwnYpgrzoKiKBto6JDtcQBQR4QN1Jt
         baqV3AtCsmekJi8YskctT0gXh6XXzd4ID2J2dRJO2sORKEvQptKgTcpzTBktCzhfhwTT
         u+iM63AmIKb+aCrRUffxe57FDKHDM3/oAqhac0nE0DD9gsKA5lHKy0TRGJefAraXA7UM
         SfRKe0gXMlAFt7NEhcDEN5OcE+hNzVTjrtYXyR+RNd7jOkLbj12rl+cPEfJwYfhvfqsD
         VzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784816328; x=1785421128;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k7YPn/3Uc65SEdSr61RZf3k1k3PjwWDYhrEN1V+kRhk=;
        b=GT5xP7/qzuYk4eqcOimaRKdl8Wdky24t2YKDb4qDfmcbe9qAP1DQDuyT2hSzPTXHmU
         Gms7Y/JmJS5bo00PYdVsijvmONya3yOqRNQPfoIPY7X8/lu5YKmXavtytZH2OLqqNFWn
         +uwDWFBfrD0jxi3TglSq1bMjN2SzvFEHnMnqQu3NHAa/g+xJGqHbbDieX42A2OTehTXM
         eWd31owVajFPB4Q242aYmQIVl1HyP8ex/uVoKjzM24DUAhJDmFbtr8+vegBrHv15g6y8
         GcsprPbZAUd86iD1ssMgfMBwwTOf5ag8pQE96x77TTRNmM4oqlPD2mn2RfzaodGbttLe
         pjHg==
X-Forwarded-Encrypted: i=1; AHgh+RqTRMscLi43mB7bNs87zufZcP8hwdEOKSOzxC4vzfj8twx9F52J1Ibum5K8k1U+wDwRfkgJhvc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyul1049Wy0LwVARFbDKDNyy2v3JWIXZFbJ6dxmYN2JQuSKdJwO
	Z47+vdYZlCoZni7OmDn3vJsXhGW6cfqjL/BF8K+sR/I37V07W7JNw9LI
X-Gm-Gg: AR+sD11beOm1505PK5nKrKZlccQXo/xaynOSw6pFaJUEKpaTxJBQEEH+y61xJe0yKJ8
	kBONstIGjXhpWY684nv8VO4aH9ynqW8t66gUFvMt9AbOboBZDpl+sODXKoReDb+7a4O8GmcuG56
	N6RmoqxJshN8UxXSeF+p68xO3psKzonBRS5SdSZWzbbB6Tq32CQFZvBtLid5HD4zisuAhiwMPc7
	XIovHyC+Uc3Fc6mc3TenCD/vFYNBumEgD0oFiWxrlBzbjLkzoTiZ+oOHNUE8MbCDa05rPK3cZ3q
	y0hc9smiwPcIBfYnl5HOno9EY885DmNWUMZkHJgmKh3RjVdFzVjjlxF860uShzNbYpWLBL76Mqq
	RcknHnHBOzalhQT8aih9b9ZFg2cmzcUC8YLriPWNBencNAYfx/DzenYxRdfRPX16sY0UXeS4JXE
	DrzQRsnGga1tmredNtu/rbiYbZr1DO3JqUDoKq+w==
X-Received: by 2002:a5d:5f55:0:b0:47f:93d8:f480 with SMTP id ffacd0b85a97d-47f93d8f4f3mr882130f8f.39.1784816327187;
        Thu, 23 Jul 2026 07:18:47 -0700 (PDT)
Received: from localhost ([37.30.48.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a5a2sm17253833f8f.7.2026.07.23.07.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 07:18:46 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:18:45 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] btrfs: abort transaction directly on errors in
 commit path
Message-ID: <n6vtyhyk7dcb7zf3tko5grqqcfod7co6uxvzyyy47u5bffevzo@7d6qolowq4gh>
References: <1586eaf3-2208-42eb-8877-7c4f83a6638c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586eaf3-2208-42eb-8877-7c4f83a6638c@mail.kernel.org>

Aim for minimal patch:
btrfs_relocate_block_group() should call btrfs_commit_current_transaction(extent_root) 
after relocation starts and after the relocation control has the target block 
group, but before btrfs_inc_block_group_ro() marks that target block group read-only.

Check return value for the out: cleanup.
Iterate on patch development until the patch passes CI pipeline resulting in "Correct" 
status.

On Thu, Jul 09, 2026 at 07:08:55PM +0000, syzbot wrote:
> When a transaction commit fails due to filesystem corruption (-EUCLEAN),
> some functions like btrfs_qgroup_account_extents() and btrfs_update_root()
> return the error without explicitly calling btrfs_abort_transaction(). This
> forces the generic cleanup_transaction() fallback to abort the transaction,
> which masks the actual location of the failure in the stack trace.
> 
> This results in confusing warnings that do not point to the actual failure:
> 
> BTRFS warning (device loop0): Skipping commit of aborted transaction.
> [ cut here ]
> btrfs_abort_should_print_stack(__error)
> WARNING: fs/btrfs/transaction.c:2068 at cleanup_transaction+0x727/0x7c0
> ...
> Call Trace:
>  <TASK>
>  btrfs_commit_transaction+0x262c/0x30b0
>  prepare_to_relocate+0x3dd/0x4e0
>  relocate_block_group+0x141/0xe90
>  do_nonremap_reloc+0xa7/0x560
>  btrfs_relocate_block_group+0x6e2/0xaf0
>  btrfs_relocate_chunk+0x114/0x830
>  __btrfs_balance+0x1b6e/0x29e0
>  btrfs_balance+0xaa6/0x1180
>  btrfs_ioctl_balance+0x3dd/0x640
> 
> Fix this by calling btrfs_abort_transaction() directly in these functions
> when they encounter an error. For btrfs_update_root(), -ENOSPC is a normal
> error when updating the log root tree (e.g., during btrfs_sync_log()), so
> we only abort if it is not the log root tree or the error is not -ENOSPC.
> 
> Additionally, btrfs_abort_transaction() triggers a WARN_ON for -EUCLEAN and
> -ENOSPC because they are not in the ignore list of
> btrfs_abort_should_print_stack(). WARN_ON must not be used for conditions
> that can legitimately happen, such as encountering a corrupted filesystem
> image (-EUCLEAN) or running out of space (-ENOSPC). To prevent unnecessary
> warnings, add -EUCLEAN and -ENOSPC to the ignore list. To ensure we still
> get meaningful stack traces for debugging, add manual dump_stack() calls in
> __btrfs_abort_transaction() for these specific errors.
> 
> Fixes: 72bd2323ec87 ("Btrfs: do not abort transaction at btrfs_update_root() after failure to COW path")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
> Link: https://syzkaller.appspot.com/ai_job?id=36e1fafd-13a6-44c6-a988-98fb6981cb2b
> To: "Chris Mason" <clm@fb.com>
> To: "David Sterba" <dsterba@suse.com>
> To: <linux-btrfs@vger.kernel.org>
> To: "Filipe Manana" <fdmanana@suse.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 502fb4a55..1870595f1 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3068,8 +3068,10 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
>  			if (!record->old_roots) {
>  				/* Search commit root to find old_roots */
>  				ret = btrfs_find_all_roots(&ctx, false);
> -				if (ret < 0)
> +				if (ret < 0) {
> +					btrfs_abort_transaction(trans, ret);
>  					goto cleanup;
> +				}
>  				record->old_roots = ctx.roots;
>  				ctx.roots = NULL;
>  			}
> @@ -3082,8 +3084,10 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
>  			ctx.trans = trans;
>  			ctx.time_seq = BTRFS_SEQ_LAST;
>  			ret = btrfs_find_all_roots(&ctx, false);
> -			if (ret < 0)
> +			if (ret < 0) {
> +				btrfs_abort_transaction(trans, ret);
>  				goto cleanup;
> +			}
>  			new_roots = ctx.roots;
>  			if (qgroup_to_skip) {
>  				ulist_del(new_roots, qgroup_to_skip, 0);
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 90659b287..13695e4f4 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -142,8 +142,17 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
>  		return -ENOMEM;
>  
>  	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		/*
> +		 * Abort the transaction if we are not updating the log root tree.
> +		 * In btrfs_sync_log, -ENOSPC is a normal error and should not
> +		 * abort the transaction.
> +		 */
> +		if (ret != -ENOSPC ||
> +		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
> +			btrfs_abort_transaction(trans, ret);
>  		return ret;
> +	}
>  
>  	if (unlikely(ret > 0)) {
>  		btrfs_crit(fs_info,
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 8f9419728..aa53eb831 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2751,8 +2751,16 @@ void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
>  	if (first_hit) {
>  		btrfs_err(fs_info, "Transaction %llu aborted (error %d)",
>  			  trans->transid, error);
> -		if (error == -ENOSPC)
> +		if (error == -ENOSPC) {
>  			btrfs_dump_space_info_for_trans_abort(fs_info);
> +			dump_stack();
> +		}
> +		if (error == -EUCLEAN) {
> +			btrfs_err(
> +				fs_info,
> +				"Aborting transaction due to filesystem corruption");
> +			dump_stack();
> +		}
>  	}
>  	/* Wake up anybody who may be waiting on this transaction */
>  	wake_up(&fs_info->transaction_wait);
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 5e4b1106f..ec66a60cc 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -237,6 +237,8 @@ static inline bool btrfs_abort_should_print_stack(int error)
>  	case -EIO:
>  	case -EROFS:
>  	case -ENOMEM:
> +	case -EUCLEAN:
> +	case -ENOSPC:
>  		return false;
>  	}
>  	return true;
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
