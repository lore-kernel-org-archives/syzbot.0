Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8D92253FC
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 20:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778702947; cv=pass; b=ibHs0XuVkpj7y0L/Ux713HQjiq9XZVm6TPTTJDJT1dHiL3hvZsgxKaO8heBFQ9zlBGwGji3LCZqlIg/ikTTJOEPqVfsZUX4tOiRnaMHglEqSf4grQ5oHnCGj0MdJbqUb1wss/ozlmKiI9Jo3eM71jRY0pNM8d8txyV5gN4aAJN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778702947; c=relaxed/simple;
	bh=TrgOymjwI8kyhGITRmU0tEe8Z4uVOw1cAOpMcCWyVv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rimmWtduPyUBxx5G0rB6yZJFSwUtfmVvVl69OKXH6g9tOmqecl9F4BWGucCNF05TPMCyTzelyPoFl/7AOCZT+Lpt3bjDGIQXJWfWDBYS9/fSPsC2VvmwLART6Gv7oMxxc/gbfXPJV41yORjpkXxvuj8fNANatld5BKRbHHjq4MI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eGId7/5+; arc=pass smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eGId7/5+"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-43587e63a8eso2771762fac.0
        for <syzbot@lists.linux.dev>; Wed, 13 May 2026 13:09:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778702944; cv=none;
        d=google.com; s=arc-20240605;
        b=L1/MrYfbUnua5nukUp9s/vcZSAkNEQX1GjQi7oAtS/ky014ml/ruJhiI/abNFfTq+9
         enp6+mtxEFA5O+bHTRTUySAig7HVlvbXH1M52HSOILmJsaaGjbRUR+oxJ2LeZLgTWifi
         4aGpb6yB/GiKXkd9QH0+l6jV5pDMnbaZMw9eeoD+lO8CEJuYyC2by6enXcnpFGMAXl2S
         Uv9HwxgJWFyqE128a/96PwDMQNrxa4NYJ1UD+Gkb+cfD1YkPD16TmfTMSp43HUfYQF1N
         LlX1HQvf9FKGgsXyydywPyPPNbbAss9TuDcL/DxNvqKjHG0As6MMed+zF/wsBONGiLCU
         V24Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A2tjs9/U8ineyYMk9K/AuJFj0lZKvkC1MGISNcfWFCo=;
        fh=OyduF7q/jmaT79NXxs068m7Qx0sDxv80MgbAFddbSEE=;
        b=knXAbx8Kcdtneiz1iD4+vcLKCmCAKUUPL56oXrqggLXcEznS3LEMIBFlV2vGX3+kGO
         ktIywVRerFKi8vfei7FsNTr7HKuxzsP+nOW/l9gkj86af8n8FhsZ95U6z9wBEoSfQAOB
         Tqg9Tg57V7HgHFpO7ZE3mebpWyyhjEbQDK1Qa358C8xK6ypl5MCWJwbxjxtYcOEYyTg8
         +6qzposUwU4K7hgicV1rmqpxFB7x+yyHK7KTPRQoIv3FBFelBzPfRSkMtPuxdrPASoVB
         D8yS4/Ha5YjGOZ/bU888wSqi6WQzlQpYJrKjmlBDwhpTCinrnLubAbpUvsasoWwfq2T4
         HMfA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778702944; x=1779307744; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A2tjs9/U8ineyYMk9K/AuJFj0lZKvkC1MGISNcfWFCo=;
        b=eGId7/5+AngTlFtPghT+U0L2YzUyxi5NCM0PoTy1nu7wfrJ91oXo+2dY/iSbWGmlju
         aZrtP6pQuRc2XV82tJgV2Psd2gpRUzr9nNMO4x7XFbj8LKZMQ3gsW+w5VCkGIWsvnlub
         lIdHwCAZez619O0hnuhWpCJHlt7gh25sCp6snW9QnbQEqQeT/9GK4Kg7twO9K9zx+Eu2
         fPaX8BYJdNqc6wQGRJuuENk8CTtRS/HmWFwj5gD36n5/6xmr8NLutQ1SwJNr1IR8Y0iZ
         xaukPwsohsu4n+UxS/A1vie4SoJ/M2UNzWNV+Um7u0+mK5hOkMxKmGv/gNbtTKgcAvxn
         3ujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778702944; x=1779307744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A2tjs9/U8ineyYMk9K/AuJFj0lZKvkC1MGISNcfWFCo=;
        b=ELhF4SQr8kmIuNeke/aIaMhmuffhlEvM3awm7FmKxmIb1gWesCIvTAXXrriFE3ys8G
         AEnhQ76pFXjvuTrv7PG/AEbsWyUWr6nLgC8xgpmihUX3HNyNM1o5dM374ZJfAQu3ZgtC
         kvvpJ2IKLdD9jwYYsYR3gVOQE7o5Y2DINbgTDgPzrcAZaGtEC02mivdem/fFB09a1Zay
         xG6IvJO4nPcN9joifJ5KfVKQXDicX0Kxrevw6bJqKO97J9qmv1dVw0FlcZRBCwu2rhJv
         z9P7xAT+B83/i/P8uSycdGQBHrPV/Q1azMkmfaFlEkCc9yyEenkvzfmyCN0JLBlGWHKI
         Y+0g==
X-Forwarded-Encrypted: i=1; AFNElJ9oSruOi1eaBVu9ZLjrOXk1PAcFpZJf1cx8meIDtZ8+G3ZFUNaEdoBQvfn7elk+DSQooVPaVjw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvVD2RRx2Zg1E5TlmKC+MMIY+I3Ex5e2SWljZnb3Ma4SLpr9yD
	ndGo/wnw83Np8vgRXybiVtAyEY5/YXp1XsXP5BWV2KoO+F23oWbn113kP+L5mQtwcPSIpmzxvy8
	CrZxK4Krt9/uR4LsKB8trFif6mbcLbF6CE/fZMCQm
X-Gm-Gg: Acq92OF6YSgIp9CBqPef0rEGRNpyBXzBS+GpvuY7521xpoZ8pIKq+/EcpVBusd6Uu2v
	4euNvmr19tHi6Ll/UgRTicaA/VvUY0BOfkZHP/E6mAIXxWvUdDK/2ZXyCCiupEJiiyflZ/Fp+LF
	HAlwV1IfNZgI5xszJwnT0ZjT9pqplA8QReH7wIA6m6SYkq4CLINhdwTFV2X1vqE9QFzNvucFa8Z
	1n/HBfVgHXEWIeSg7RipAdpkOivC/K2AxjKTEglgFeRutitNWeWJQcV3iGOq+5c/mtmxVFI+lXc
	F8FKnYz/Qs4Mm84mCf7vvSBMN5FqkmNZACm5gENCYbMBMNpVo7/cYHGIh/REDai4b6DCbT2kI5F
	siMkPfVA=
X-Received: by 2002:a05:6871:7426:b0:417:4693:ca0 with SMTP id
 586e51a60fabf-439d2d48ff9mr2437541fac.14.1778702943558; Wed, 13 May 2026
 13:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <54bfa402-a284-4649-94d3-a25a88a6c475@mail.kernel.org>
In-Reply-To: <54bfa402-a284-4649-94d3-a25a88a6c475@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 13 May 2026 22:08:51 +0200
X-Gm-Features: AVHnY4JB0Hkgq7VHBvSB3rS-kOFCWxD9rTI0mamiAO6eIrqygh5z5Bn6zuoNSmQ
Message-ID: <CANp29Y7x+sgu8HcjZ6Q6Tm-BDBg9EPvn0iObwL03s3O3GhArkQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] btrfs: fix delayed transaction aborts
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Why is the patch so long?

On Wed, May 13, 2026 at 2:03=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A transaction abort with error -28 (-ENOSPC) can trigger a WARN_ON in
> cleanup_transaction(). The stack trace is somewhat misleading because
> the transaction abort is delayed until the cleanup phase of
> btrfs_commit_transaction(), hiding the actual function that ran out of
> space.
>
> When a highly crafted, extremely small BTRFS image is mounted and a
> BTRFS_IOC_BALANCE_V2 ioctl is issued, the balance operation joins a
> transaction and immediately commits it. During
> btrfs_commit_transaction(), the filesystem needs to update various
> trees. To update these trees, BTRFS must COW their root nodes, which
> eventually calls btrfs_alloc_tree_block() to allocate a new physical
> extent. Because the crafted image is tiny and has no free physical space
> left, btrfs_reserve_extent() fails and returns -ENOSPC.
>
> The -ENOSPC error propagates up the call stack to commit_cowonly_roots()
> or commit_fs_roots(). Crucially, when these functions receive this
> error, they simply return it to btrfs_commit_transaction() without
> calling btrfs_abort_transaction() themselves. The error is caught in
> btrfs_commit_transaction() and execution jumps to the cleanup labels.
> Inside cleanup_transaction(), btrfs_abort_transaction() is finally
> called. Because the failing functions neglected to abort the transaction
> when the error actually occurred, this call inside cleanup_transaction()
> is the first abort, completely hiding the true source of the -ENOSPC.
>
> To fix this and ensure developers get accurate stack traces for
> transaction aborts, explicitly call btrfs_abort_transaction() before
> returning errors in functions that can fail with fatal errors during the
> commit critical section (commit_cowonly_roots(), commit_fs_roots(),
> btrfs_qgroup_account_extents(), and create_pending_snapshot()).
>
> Also, add -ENOSPC to btrfs_abort_should_print_stack() to prevent
> printing stack traces for legitimate out-of-space conditions.
>
> Fixes: 49b25e0540904be0bf558b84475c69d72e4de66e ("btrfs: enhance transact=
ion abort infrastructure")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+dafbca0e20fbc5946925@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Ddafbca0e20fbc5946925
> Link: https://syzkaller.appspot.com/ai_job?id=3D02e7fe36-adb2-44f9-a682-3=
83b083c294b
> To: <clm@fb.com>
> To: <dsterba@suse.com>
> To: <linux-btrfs@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Consolidated btrfs_abort_transaction() calls at the end of functions un=
der cleanup/fail/out labels instead of calling them at each error site.
> - Dropped unrelated workqueue and super.c changes addressing lockdep key =
exhaustion.
>
> v1:
> https://lore.kernel.org/all/f77b5e84-af17-41f8-9357-e8f4cd4b8438@mail.ker=
nel.org/T/
> ---
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index cdf736d3a..a645110df 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3076,6 +3076,8 @@ int btrfs_qgroup_account_extents(struct btrfs_trans=
_handle *trans)
>                                                           record->num_byt=
es,
>                                                           record->old_roo=
ts,
>                                                           new_roots);
> +                       if (ret < 0)
> +                               goto cleanup;
>                         record->old_roots =3D NULL;
>                         new_roots =3D NULL;
>                 }
> @@ -3093,6 +3095,8 @@ int btrfs_qgroup_account_extents(struct btrfs_trans=
_handle *trans)
>
>         }
>         trace_btrfs_qgroup_num_dirty_extents(fs_info, trans->transid, num=
_dirty_extents);
> +       if (ret < 0)
> +               btrfs_abort_transaction(trans, ret);
>         return ret;
>  }
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 248adb785..18e2d679a 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1372,21 +1372,23 @@ static noinline int commit_cowonly_roots(struct b=
trfs_trans_handle *trans)
>         free_extent_buffer(eb);
>
>         if (ret)
> -               return ret;
> +               goto out;
>
>         ret =3D btrfs_run_dev_stats(trans);
>         if (ret)
> -               return ret;
> +               goto out;
> +
>         ret =3D btrfs_run_dev_replace(trans);
>         if (ret)
> -               return ret;
> +               goto out;
> +
>         ret =3D btrfs_run_qgroups(trans);
>         if (ret)
> -               return ret;
> +               goto out;
>
>         ret =3D btrfs_setup_space_cache(trans);
>         if (ret)
> -               return ret;
> +               goto out;
>
>  again:
>         while (!list_empty(&fs_info->dirty_cowonly_roots)) {
> @@ -1400,18 +1402,18 @@ static noinline int commit_cowonly_roots(struct b=
trfs_trans_handle *trans)
>
>                 ret =3D update_cowonly_root(trans, root);
>                 if (ret)
> -                       return ret;
> +                       goto out;
>         }
>
>         /* Now flush any delayed refs generated by updating all of the ro=
ots */
>         ret =3D btrfs_run_delayed_refs(trans, U64_MAX);
>         if (ret)
> -               return ret;
> +               goto out;
>
>         while (!list_empty(dirty_bgs) || !list_empty(io_bgs)) {
>                 ret =3D btrfs_write_dirty_block_groups(trans);
>                 if (ret)
> -                       return ret;
> +                       goto out;
>
>                 /*
>                  * We're writing the dirty block groups, which could gene=
rate
> @@ -1421,7 +1423,7 @@ static noinline int commit_cowonly_roots(struct btr=
fs_trans_handle *trans)
>                  */
>                 ret =3D btrfs_run_delayed_refs(trans, U64_MAX);
>                 if (ret)
> -                       return ret;
> +                       goto out;
>         }
>
>         if (!list_empty(&fs_info->dirty_cowonly_roots))
> @@ -1431,7 +1433,10 @@ static noinline int commit_cowonly_roots(struct bt=
rfs_trans_handle *trans)
>         fs_info->dev_replace.committed_cursor_left =3D
>                 fs_info->dev_replace.cursor_left_last_write_of_item;
>
> -       return 0;
> +out:
> +       if (ret)
> +               btrfs_abort_transaction(trans, ret);
> +       return ret;
>  }
>
>  /*
> @@ -1492,6 +1497,7 @@ static noinline int commit_fs_roots(struct btrfs_tr=
ans_handle *trans)
>         struct btrfs_root *gang[8];
>         int i;
>         int ret;
> +       int err =3D 0;
>
>         /*
>          * At this point no one can be using this transaction to modify a=
ny tree
> @@ -1510,7 +1516,6 @@ static noinline int commit_fs_roots(struct btrfs_tr=
ans_handle *trans)
>                         break;
>                 for (i =3D 0; i < ret; i++) {
>                         struct btrfs_root *root =3D gang[i];
> -                       int ret2;
>
>                         /*
>                          * At this point we can neither have tasks loggin=
g inodes
> @@ -1533,9 +1538,9 @@ static noinline int commit_fs_roots(struct btrfs_tr=
ans_handle *trans)
>                         spin_unlock(&fs_info->fs_roots_radix_lock);
>
>                         btrfs_free_log(trans, root);
> -                       ret2 =3D btrfs_update_reloc_root(trans, root);
> -                       if (unlikely(ret2))
> -                               return ret2;
> +                       err =3D btrfs_update_reloc_root(trans, root);
> +                       if (unlikely(err))
> +                               goto out;
>
>                         /* see comments in should_cow_block() */
>                         clear_bit(BTRFS_ROOT_FORCE_COW, &root->state);
> @@ -1548,16 +1553,19 @@ static noinline int commit_fs_roots(struct btrfs_=
trans_handle *trans)
>                                                     root->node);
>                         }
>
> -                       ret2 =3D btrfs_update_root(trans, fs_info->tree_r=
oot,
> +                       err =3D btrfs_update_root(trans, fs_info->tree_ro=
ot,
>                                                 &root->root_key,
>                                                 &root->root_item);
> -                       if (unlikely(ret2))
> -                               return ret2;
> +                       if (unlikely(err))
> +                               goto out;
>                         spin_lock(&fs_info->fs_roots_radix_lock);
>                 }
>         }
>         spin_unlock(&fs_info->fs_roots_radix_lock);
> -       return 0;
> +out:
> +       if (err)
> +               btrfs_abort_transaction(trans, err);
> +       return err;
>  }
>
>  /*
> @@ -1745,10 +1753,8 @@ static noinline int create_pending_snapshot(struct=
 btrfs_trans_handle *trans,
>          * insert the directory item
>          */
>         ret =3D btrfs_set_inode_index(parent_inode, &index);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>
>         /* check if there is a file/dir which has the same name. */
>         dir_item =3D btrfs_lookup_dir_item(NULL, parent_root, path,
> @@ -1759,17 +1765,14 @@ static noinline int create_pending_snapshot(struc=
t btrfs_trans_handle *trans,
>                 goto dir_item_existed;
>         } else if (IS_ERR(dir_item)) {
>                 ret =3D PTR_ERR(dir_item);
> -               btrfs_abort_transaction(trans, ret);
>                 goto fail;
>         }
>         btrfs_release_path(path);
>
>         ret =3D btrfs_create_qgroup(trans, objectid);
>         if (ret && ret !=3D -EEXIST) {
> -               if (unlikely(ret !=3D -ENOTCONN || btrfs_qgroup_enabled(f=
s_info))) {
> -                       btrfs_abort_transaction(trans, ret);
> +               if (unlikely(ret !=3D -ENOTCONN || btrfs_qgroup_enabled(f=
s_info)))
>                         goto fail;
> -               }
>         }
>
>         /*
> @@ -1779,16 +1782,12 @@ static noinline int create_pending_snapshot(struc=
t btrfs_trans_handle *trans,
>          * snapshot
>          */
>         ret =3D btrfs_run_delayed_items(trans);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>
>         ret =3D record_root_in_trans(trans, root, false);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>         btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
>         memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
>         btrfs_check_and_init_root_item(new_root_item);
> @@ -1821,10 +1820,8 @@ static noinline int create_pending_snapshot(struct=
 btrfs_trans_handle *trans,
>         ret =3D btrfs_copy_root(trans, root, root_eb, &tmp, objectid);
>         btrfs_tree_unlock(root_eb);
>         free_extent_buffer(root_eb);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>         /* see comments in should_cow_block() */
>         set_bit(BTRFS_ROOT_FORCE_COW, &root->state);
>         smp_mb__after_atomic();
> @@ -1837,10 +1834,8 @@ static noinline int create_pending_snapshot(struct=
 btrfs_trans_handle *trans,
>         ret =3D btrfs_insert_root(trans, tree_root, &key, new_root_item);
>         btrfs_tree_unlock(tmp);
>         free_extent_buffer(tmp);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>
>         /*
>          * insert root back/forward references
> @@ -1849,25 +1844,20 @@ static noinline int create_pending_snapshot(struc=
t btrfs_trans_handle *trans,
>                                  btrfs_root_id(parent_root),
>                                  btrfs_ino(parent_inode), index,
>                                  &fname.disk_name);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>
>         key.offset =3D (u64)-1;
>         pending->snap =3D btrfs_get_new_fs_root(fs_info, objectid, &pendi=
ng->anon_dev);
>         if (IS_ERR(pending->snap)) {
>                 ret =3D PTR_ERR(pending->snap);
>                 pending->snap =3D NULL;
> -               btrfs_abort_transaction(trans, ret);
>                 goto fail;
>         }
>
>         ret =3D btrfs_reloc_post_snapshot(trans, pending);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>
>         /*
>          * Do special qgroup accounting for snapshot, as we do some qgrou=
p
> @@ -1887,27 +1877,21 @@ static noinline int create_pending_snapshot(struc=
t btrfs_trans_handle *trans,
>         ret =3D btrfs_insert_dir_item(trans, &fname.disk_name,
>                                     parent_inode, &key, BTRFS_FT_DIR,
>                                     index);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>
>         btrfs_i_size_write(parent_inode, parent_inode->vfs_inode.i_size +
>                                                   fname.disk_name.len * 2=
);
>         inode_set_mtime_to_ts(&parent_inode->vfs_inode,
>                               inode_set_ctime_current(&parent_inode->vfs_=
inode));
>         ret =3D btrfs_update_inode_fallback(trans, parent_inode);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>         ret =3D btrfs_uuid_tree_add(trans, new_root_item->uuid,
>                                   BTRFS_UUID_KEY_SUBVOL,
>                                   objectid);
> -       if (unlikely(ret)) {
> -               btrfs_abort_transaction(trans, ret);
> +       if (unlikely(ret))
>                 goto fail;
> -       }
>         if (!btrfs_is_empty_uuid(new_root_item->received_uuid)) {
>                 ret =3D btrfs_uuid_tree_add(trans, new_root_item->receive=
d_uuid,
>                                           BTRFS_UUID_KEY_RECEIVED_SUBVOL,
> @@ -1928,13 +1912,13 @@ static noinline int create_pending_snapshot(struc=
t btrfs_trans_handle *trans,
>                  */
>                 if (ret =3D=3D -EOVERFLOW)
>                         ret =3D 0;
> -               if (unlikely(ret)) {
> -                       btrfs_abort_transaction(trans, ret);
> +               if (unlikely(ret))
>                         goto fail;
> -               }
>         }
>
>  fail:
> +       if (ret)
> +               btrfs_abort_transaction(trans, ret);
>         pending->error =3D ret;
>  dir_item_existed:
>         trans->block_rsv =3D rsv;
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 7d70fe486..593f398a5 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -237,6 +237,7 @@ static inline bool btrfs_abort_should_print_stack(int=
 error)
>         case -EIO:
>         case -EROFS:
>         case -ENOMEM:
> +       case -ENOSPC:
>                 return false;
>         }
>         return true;
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
-upstream-moderation/54bfa402-a284-4649-94d3-a25a88a6c475%40mail.kernel.org=
.
