Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6B4375F63
	for <syzbot@lists.linux.dev>; Mon, 11 May 2026 11:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778499920; cv=pass; b=RdwwdN5ZL9pnF+8gL+1w2n8GigAhQC5ugzikkrIWQfvI1UFKHi1xHMdHdsSWNrick6XD+QcIcdaxk8iuM5iUwcCp5NABLbzjh4LjTzxP1+HBdTuUDqid0rGCvvZQi74Sv9dVqEk46bszCx7fXqBZkZI11YLnRYbdM3e7+7YB+bk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778499920; c=relaxed/simple;
	bh=twjuxS49qHBL2aD6ps8mUw5W7XSTWfsmfc4y7aiZhd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NB+OolifBhB06fp/Bo/1aSvo4EfBHhiIpAycbAOjn7JLi/LUoGYKVOJ2LsDrbP94IvZESUQP2Kx1spEroyulybS0NAQN+ta0vbf9hcRTFBVjRdLg+N+zl0OXLr9VIV3Ekc+XpBgVmr7PotsDqWSUG7yDF0BKydqdsnv65ZvIrjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FZlsywN/; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FZlsywN/"
Received: by smtp.kernel.org (Postfix)
	id 970A4C2BCC9; Mon, 11 May 2026 11:45:20 +0000 (UTC)
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 55725C2BCB0
	for <syzbot@kernel.org>; Mon, 11 May 2026 11:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 55725C2BCB0
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40ede943bf0so3139017fac.2
        for <syzbot@kernel.org>; Mon, 11 May 2026 04:45:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778499918; cv=none;
        d=google.com; s=arc-20240605;
        b=LSUSJ5dPLi5BJO/vZP7SaxfAwMFSYG/vjTFPXVi+Bzw0I731PgySFzVDHnXVeUCWew
         Q+UWWlmwbUPatwmpFQnDXhHLYCsKDHsVIgO74OKW1DZzNLZRmmFFw56o3Z+nvUyNoymf
         LsefaS2yF5d5D+znvVyYnfdlJ4rS8/5rB8jmqtzGmTvXlQno50s0Jue0iMgwveJLwLXk
         kTTleUBECDv/uOhK3NTdPbk7esL3anATvs7XY+vD30tPvAuL8B26EUqf9PCUpOUoRgz/
         3P5PmI0YSPBGTmZv6/A8rD2V5OSGQb+rOik2CN02cL+/ui0cx6WqSHBAp7D03thD0r4p
         ZuPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sq6ALoeEnUVtjDVKWuGJC6Y1eNpNy0BS1dpifEk51Es=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=iEkVpL7UpSJwiKWcfuWybqxsZMRfKMyt4rrAV0mMeFKlEsi39SHp0jGUynxD0WuW3w
         is/Kfuu4mdQButP07DeRT4iVvg1bM/S6rRREH0uOKbmMa4VKrwpjHIuHHUqIfcIciLyX
         66FHW9HdXnvVbwgdacMrP/NZbl8oqN3yW8Dk2TnvL3QU1ioRryJ9fXkxBQkEwuWezUw7
         ox4KPjpvvJrUPbcbhrJvd/xClR9nG+Vjc7/vZyjqnS82EfNeulX03YPD0RWhtc8BdRoB
         I+AZVPKPEwzO23HgAq/bXJH7w2ko4E6VLodGotN8j/7pwoF0JAPvOfHDvAVeJ/SuzGUR
         9x6g==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778499918; x=1779104718; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sq6ALoeEnUVtjDVKWuGJC6Y1eNpNy0BS1dpifEk51Es=;
        b=FZlsywN/6M/JVVaWcBYLFPa6gCBmrgO6PjSObm4LftXjgX+VBbqSULWCKqP7lRD2ks
         3+PhRGDo+USPhw/JeZm1yA1xy7R/jq7o4rEGZdCOixUKnaRU0vvN110llyF5ofMtjmTG
         atzLSZXp0/Fo+Qowga4VFS993rZ5QVPi8du6hoVFdbEunXzdtcMy6xIGUvpmxCLLr8kf
         U/L3b73H2FPVmOytj1MvhrDSrSLK72f51BpXgRjxQzVwcanfjYK126Jrbg2Dd52ICBOO
         vfb3VQKy671hOShh952tlysMXCCWnZtibt70Vn2B1MOQtezk6v6WM7Wa6Grb7qVs8PRB
         xoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778499918; x=1779104718;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sq6ALoeEnUVtjDVKWuGJC6Y1eNpNy0BS1dpifEk51Es=;
        b=qo/dZKruu9jlcy7LucuXQTBcTX5U7fjZwo0j+HiklbdlrWRyN11hB15geHw1WpDjue
         6gnojdmtemkP03JrwWybM7NsBFH7Z7q6WYj+rY2Stl1hkEG3f7LnRyvyKqBxwsMWCnya
         KnYIp1lLP4O1+VmQyYvG2/9Yn4cmyX3OAErvFKmD6oU0cNX5HBWX83gPKaPs7LQAf+ba
         euTBOtbNOnq/ZAwoHy1p+jQKqOp+1HeXTq26SaXA0x4bSpZAJKlTCR8Oh+kPeIuXnocY
         rsi/OoMU1hE61x/jfkBQJyhuD1/m5ITEUUNX03ZU3Zb673qH5tZ4PNlBKf61aH9dj045
         MyNQ==
X-Gm-Message-State: AOJu0YwUFMtN0Wf7CvmA+Hep1MB7MZ2CAWgRd/5/JXSAZ8hsPIuOs1qb
	KmiiG1Pv1yt8z17dzYg/EgI0kAIvJHKKByrrcYi3iaq3RdHV9/SIkjpIuqw7Pq+stI26BTo0f5O
	4t/DMMjPc3ddUkHJlQnF1ewWaArx5yklsQ4NquxNTIn+74EaU8xMqLAyGVxE=
X-Gm-Gg: Acq92OEDMaWx40tDvoqm+OIN2FxOlMSp+re6JzOTmpcP4sbCimoo7Mq+vRAcYqJClY9
	vGfeIpUIvg9uDzcn+RUYOPUQAcsqGWQjw/d1Tyh5vQBNCQVwvBlJmcv4M9XRPykr8HnZdIEi2P4
	HtQ5ONDg30S1amTxvIiwaHBWr4TrcbJ/8AVucsWHUZPE94/ucwMOMeilFh0Mlh/t6FPAUyzffQ9
	GxSBTcp4C2mnrnRb/t56holxVgkVXv7zCJVnkAZNFWQCGponlkWOS3V4O1N3puuLdxSjfEQpln1
	MbwxVe+h9p2lot47mq7q6muVL9cOoAIQ/zPP3WkwR9wEYLbIU2+l7orh0mMGIeL4Zd1H4vQvH6x
	Zzy5T
X-Received: by 2002:a05:6871:28a0:b0:417:5a8c:feba with SMTP id
 586e51a60fabf-434f5866e4bmr14741202fac.12.1778499917507; Mon, 11 May 2026
 04:45:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f77b5e84-af17-41f8-9357-e8f4cd4b8438@mail.kernel.org>
In-Reply-To: <f77b5e84-af17-41f8-9357-e8f4cd4b8438@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 11 May 2026 13:45:06 +0200
X-Gm-Features: AVHnY4L2nvE9pmleYRRHiZhNlF0_tfQz1jte7bdhPdYrcVhaWqzjW-FyLqYYnEg
Message-ID: <CANp29Y7CCahNhzw7F327PaBvs2YP3cs1XJ2TOP=AXhGoJRUeLw@mail.gmail.com>
Subject: Re: [PATCH RFC] btrfs: fix delayed transaction aborts and lockdep key exhaustion
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please verify whether if would make more sense to put
btrfs_abort_transaction after the cleanup/fail labels?

On Mon, May 11, 2026 at 12:27=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> btrfs: fix delayed transaction aborts and lockdep key exhaustion
>
> A transaction abort with error -28 (-ENOSPC) can trigger a WARN_ON in
> cleanup_transaction(). The stack trace is somewhat misleading because
> the
> transaction abort is delayed until the cleanup phase of
> btrfs_commit_transaction(), hiding the actual function that ran out of
> space.
>
> When a highly crafted, extremely small BTRFS image is mounted and a
> BTRFS_IOC_BALANCE_V2 ioctl is issued, the balance operation joins a
> transaction and immediately commits it. During
> btrfs_commit_transaction(),
> the filesystem needs to update various trees. To update these trees,
> BTRFS
> must COW their root nodes, which eventually calls
> btrfs_alloc_tree_block()
> to allocate a new physical extent. Because the crafted image is tiny and
> has no free physical space left, btrfs_reserve_extent() fails and
> returns
> -ENOSPC.
>
> The -ENOSPC error propagates up the call stack to commit_cowonly_roots()
> or commit_fs_roots(). Crucially, when these functions receive this
> error,
> they simply return it to btrfs_commit_transaction() without calling
> btrfs_abort_transaction() themselves. The error is caught in
> btrfs_commit_transaction() and execution jumps to the cleanup labels.
> Inside cleanup_transaction(), btrfs_abort_transaction() is finally
> called.
> Because the failing functions neglected to abort the transaction when
> the
> error actually occurred, this call inside cleanup_transaction() is the
> first abort, completely hiding the true source of the -ENOSPC.
>
> To fix this and ensure developers get accurate stack traces for
> transaction
> aborts, explicitly call btrfs_abort_transaction() before returning
> errors
> in functions that can fail with fatal errors during the commit critical
> section (commit_cowonly_roots(), commit_fs_roots(),
> btrfs_qgroup_account_extents(), and create_pending_snapshot()).
>
> Also, add -ENOSPC to btrfs_abort_should_print_stack() to prevent
> printing
> stack traces for legitimate out-of-space conditions.
>
> Additionally, this patch addresses a lockdep key exhaustion issue caused
> by
> rapid mount/unmount loops. The exhaustion is caused by the asynchronous
> unregistration of lockdep keys in the workqueue subsystem. To fix this,
> wq_unregister_lockdep() is moved from the asynchronous
> pwq_release_workfn()
> to be synchronous in destroy_workqueue(), before the rcu_read_lock()
> block
> where the base references to the pwqs are put. At this point, the
> workqueue
> is fully drained and detached, and we are not inside an RCU read-side
> critical section, avoiding KASAN use-after-free and deadlocks.
>
> Finally, an rcu_barrier() is added in btrfs_kill_super() to wait for all
> RCU callbacks to finish. This is necessary because
> lockdep_unregister_key()
> queues an RCU callback to actually free the lock classes, and without
> the
> barrier, rapid mount/unmount loops could still exhaust MAX_LOCKDEP_KEYS
> before the RCU callbacks have a chance to run.
>
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> To: <clm@fb.com>
> To: <dsterba@suse.com>
> To: <linux-btrfs@vger.kernel.org>
> To: <tj@kernel.org>
> Cc: <jiangshanlai@gmail.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index cdf736d3a..fd322e87f 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3050,8 +3050,10 @@ int btrfs_qgroup_account_extents(struct btrfs_tran=
s_handle *trans)
>                         if (!record->old_roots) {
>                                 /* Search commit root to find old_roots *=
/
>                                 ret =3D btrfs_find_all_roots(&ctx, false)=
;
> -                               if (ret < 0)
> +                               if (ret < 0) {
> +                                       btrfs_abort_transaction(trans, re=
t);
>                                         goto cleanup;
> +                               }
>                                 record->old_roots =3D ctx.roots;
>                                 ctx.roots =3D NULL;
>                         }
> @@ -3064,8 +3066,10 @@ int btrfs_qgroup_account_extents(struct btrfs_tran=
s_handle *trans)
>                         ctx.trans =3D trans;
>                         ctx.time_seq =3D BTRFS_SEQ_LAST;
>                         ret =3D btrfs_find_all_roots(&ctx, false);
> -                       if (ret < 0)
> +                       if (ret < 0) {
> +                               btrfs_abort_transaction(trans, ret);
>                                 goto cleanup;
> +                       }
>                         new_roots =3D ctx.roots;
>                         if (qgroup_to_skip) {
>                                 ulist_del(new_roots, qgroup_to_skip, 0);
> @@ -3076,6 +3080,10 @@ int btrfs_qgroup_account_extents(struct btrfs_tran=
s_handle *trans)
>                                                           record->num_byt=
es,
>                                                           record->old_roo=
ts,
>                                                           new_roots);
> +                       if (ret < 0) {
> +                               btrfs_abort_transaction(trans, ret);
> +                               goto cleanup;
> +                       }
>                         record->old_roots =3D NULL;
>                         new_roots =3D NULL;
>                 }
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index b26aa9169..25c31eba4 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2125,6 +2125,11 @@ static void btrfs_kill_super(struct super_block *s=
b)
>  {
>         struct btrfs_fs_info *fs_info =3D btrfs_sb(sb);
>         kill_anon_super(sb);
> +       /*
> +        * Wait for all RCU callbacks to finish. This prevents lockdep ke=
y
> +        * exhaustion when syzkaller mounts and unmounts rapidly.
> +        */
> +       rcu_barrier();
>         btrfs_free_fs_info(fs_info);
>  }
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 248adb785..c4c3ae9ac 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1371,22 +1371,32 @@ static noinline int commit_cowonly_roots(struct b=
trfs_trans_handle *trans)
>         btrfs_tree_unlock(eb);
>         free_extent_buffer(eb);
>
> -       if (ret)
> +       if (ret) {
> +               btrfs_abort_transaction(trans, ret);
>                 return ret;
> +       }
>
>         ret =3D btrfs_run_dev_stats(trans);
> -       if (ret)
> +       if (ret) {
> +               btrfs_abort_transaction(trans, ret);
>                 return ret;
> +       }
>         ret =3D btrfs_run_dev_replace(trans);
> -       if (ret)
> +       if (ret) {
> +               btrfs_abort_transaction(trans, ret);
>                 return ret;
> +       }
>         ret =3D btrfs_run_qgroups(trans);
> -       if (ret)
> +       if (ret) {
> +               btrfs_abort_transaction(trans, ret);
>                 return ret;
> +       }
>
>         ret =3D btrfs_setup_space_cache(trans);
> -       if (ret)
> +       if (ret) {
> +               btrfs_abort_transaction(trans, ret);
>                 return ret;
> +       }
>
>  again:
>         while (!list_empty(&fs_info->dirty_cowonly_roots)) {
> @@ -1399,19 +1409,25 @@ static noinline int commit_cowonly_roots(struct b=
trfs_trans_handle *trans)
>                                &trans->transaction->switch_commits);
>
>                 ret =3D update_cowonly_root(trans, root);
> -               if (ret)
> +               if (ret) {
> +                       btrfs_abort_transaction(trans, ret);
>                         return ret;
> +               }
>         }
>
>         /* Now flush any delayed refs generated by updating all of the ro=
ots */
>         ret =3D btrfs_run_delayed_refs(trans, U64_MAX);
> -       if (ret)
> +       if (ret) {
> +               btrfs_abort_transaction(trans, ret);
>                 return ret;
> +       }
>
>         while (!list_empty(dirty_bgs) || !list_empty(io_bgs)) {
>                 ret =3D btrfs_write_dirty_block_groups(trans);
> -               if (ret)
> +               if (ret) {
> +                       btrfs_abort_transaction(trans, ret);
>                         return ret;
> +               }
>
>                 /*
>                  * We're writing the dirty block groups, which could gene=
rate
> @@ -1420,8 +1436,10 @@ static noinline int commit_cowonly_roots(struct bt=
rfs_trans_handle *trans)
>                  * everything gets run.
>                  */
>                 ret =3D btrfs_run_delayed_refs(trans, U64_MAX);
> -               if (ret)
> +               if (ret) {
> +                       btrfs_abort_transaction(trans, ret);
>                         return ret;
> +               }
>         }
>
>         if (!list_empty(&fs_info->dirty_cowonly_roots))
> @@ -1534,8 +1552,10 @@ static noinline int commit_fs_roots(struct btrfs_t=
rans_handle *trans)
>
>                         btrfs_free_log(trans, root);
>                         ret2 =3D btrfs_update_reloc_root(trans, root);
> -                       if (unlikely(ret2))
> +                       if (unlikely(ret2)) {
> +                               btrfs_abort_transaction(trans, ret2);
>                                 return ret2;
> +                       }
>
>                         /* see comments in should_cow_block() */
>                         clear_bit(BTRFS_ROOT_FORCE_COW, &root->state);
> @@ -1551,8 +1571,10 @@ static noinline int commit_fs_roots(struct btrfs_t=
rans_handle *trans)
>                         ret2 =3D btrfs_update_root(trans, fs_info->tree_r=
oot,
>                                                 &root->root_key,
>                                                 &root->root_item);
> -                       if (unlikely(ret2))
> +                       if (unlikely(ret2)) {
> +                               btrfs_abort_transaction(trans, ret2);
>                                 return ret2;
> +                       }
>                         spin_lock(&fs_info->fs_roots_radix_lock);
>                 }
>         }
> @@ -1737,8 +1759,10 @@ static noinline int create_pending_snapshot(struct=
 btrfs_trans_handle *trans,
>                                       trans->bytes_reserved, 1);
>         parent_root =3D parent_inode->root;
>         ret =3D record_root_in_trans(trans, parent_root, false);
> -       if (unlikely(ret))
> +       if (unlikely(ret)) {
> +               btrfs_abort_transaction(trans, ret);
>                 goto fail;
> +       }
>         cur_time =3D current_time(&parent_inode->vfs_inode);
>
>         /*
> @@ -1881,8 +1905,10 @@ static noinline int create_pending_snapshot(struct=
 btrfs_trans_handle *trans,
>         else if (btrfs_qgroup_mode(fs_info) =3D=3D BTRFS_QGROUP_MODE_SIMP=
LE)
>                 ret =3D btrfs_qgroup_inherit(trans, btrfs_root_id(root), =
objectid,
>                                            btrfs_root_id(parent_root), pe=
nding->inherit);
> -       if (unlikely(ret < 0))
> +       if (unlikely(ret < 0)) {
> +               btrfs_abort_transaction(trans, ret);
>                 goto fail;
> +       }
>
>         ret =3D btrfs_insert_dir_item(trans, &fname.disk_name,
>                                     parent_inode, &key, BTRFS_FT_DIR,
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
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 5f747f241..5989f1c18 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -5222,7 +5222,6 @@ static void pwq_release_workfn(struct kthread_work =
*work)
>          * is gonna access it anymore.  Schedule RCU free.
>          */
>         if (is_last) {
> -               wq_unregister_lockdep(wq);
>                 call_rcu(&wq->rcu, rcu_free_wq);
>         }
>  }
> @@ -6064,6 +6063,8 @@ void destroy_workqueue(struct workqueue_struct *wq)
>         list_del_rcu(&wq->list);
>         mutex_unlock(&wq_pool_mutex);
>
> +       wq_unregister_lockdep(wq);
> +
>         /*
>          * We're the sole accessor of @wq. Directly access cpu_pwq and df=
l_pwq
>          * to put the base refs. @wq will be auto-destroyed from the last
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
-upstream-moderation/f77b5e84-af17-41f8-9357-e8f4cd4b8438%40mail.kernel.org=
.
