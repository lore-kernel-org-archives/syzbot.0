Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD753F6C4E
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 09:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779181243; cv=pass; b=pc/gaNs5mItpSONnzV+9ZEpamreOz+BFHbwqmpBRj+eUkqMmHXGiG1BMs5XhxdKV5tFCTbBfOcGqWdimjFzojyv5QJJjxiyJOWcGpYxuRxuaQlWZ+BpmC1Zv9rb7zjNWPbRsSsQTvYSTbPjIimEvf+7ZxFfjxRe3JA3mraulaKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779181243; c=relaxed/simple;
	bh=uiSC4WbQx9BGtRe37BuV15cBKEPu5/YBM94SjG0kLeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oaqh9xF81EaW7VrutpECJU2qTv45xSJ5JE0g2RlPFgqxt8dASWl82aQm1IpywPVXLdtfUwY6DkLPO73zPiU4Jna9hYEWky2FwFYd2Tgasb9xJhr/lJpe397jtwkDUo6TnNwLesQtPBAeWaqdh7pumhP1EKh5hGvI1oK5LQ6zZdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=idDXFswh; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="idDXFswh"
Received: by smtp.kernel.org (Postfix)
	id C46DAC2BCB3; Tue, 19 May 2026 09:00:43 +0000 (UTC)
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 546D3C2BCC9
	for <syzbot@kernel.org>; Tue, 19 May 2026 09:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 546D3C2BCC9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6948fb494a0so1790766eaf.2
        for <syzbot@kernel.org>; Tue, 19 May 2026 02:00:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779181241; cv=none;
        d=google.com; s=arc-20240605;
        b=Hj1p6ra3g8b4+ridq95F5TvYX1UY/varsyGSCIJPHvqkZ8M5VPgbZw+JgRmn6ZgxHG
         xstEy7DROPJ6eoZRjAUX4ccoukOjtOd/tS9gl94q8HY+KsipRJ/Ul04e1Bt+I6xffThd
         cV3rT698B+rXeeoAQzBIIJtsmG/2gpu+6W6tI9fzeuZuDTzKHcPLsRM5i8szMrbXX97+
         edufiUHn7tHtUEerqO00DO4I+GwMi+sXRnDRCR9HeIsMvpa/GgF97t7gPLSqhGoJJORZ
         V6ROFk+idoxTeQm5JkpT1B3QKTGGtds/YbwNlkXFildUqX4hHJNHG1ko3QpbSx5ILlHS
         YHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V0S/AdSvKtL3ahAyhw36hFA+GFXjjDuXc9yBZ9vHmkk=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=Mf/eLSft7Wv8bFZZ2zCAaoNXR5lOXS3/fFtMUN4M+sJLssQJ3YYtcQO2ltc3U1OPzC
         1NLRXKsc3OjObnxx1+lqfGV7iYNivNJ+YFNZLXKrahEOC8+Z3dCowOnilAkUymfH6JCQ
         BeWJFGi9ZrIbIMoI6NDRICizEnV3t2qBYCmpBSGvywfB6F5LwANyzMe9jrZhkV6f97le
         3cYkb+uGPxLeq2XfiE5bEOLBOYNFCD6OeZVVqWgrbPzxevKorT1MCtXh4i7/I1++LVI3
         D+rlp9EZQAvhmejYRFBYj8y0q3DHJ6UZX8igxnu0VPJeb8a2eg17Zl3MVBCrjIIKgXjE
         eUKA==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779181241; x=1779786041; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0S/AdSvKtL3ahAyhw36hFA+GFXjjDuXc9yBZ9vHmkk=;
        b=idDXFswhtV4gUSfVIiBceaTrOrmOb+x/iEahkYDmJWnMjt6+7cPn1ZBdGddcy48aT0
         39eIgeApAU1GbhY3fvlJJIbKYojbEfZn5Fbl9MT7eoxpE2moPfbh/DE+83CtO4q4iHW5
         2qJ+hh6KZlX6wQEI33OfycZpJfJVLdhy2e4jFUQ/rmvZIaHPiwUUpVpmu/B6onijmUkl
         OI2KtTXAYwJfKOieC1IA+w/WVrS7vE5W+Hix9L7qNvhydHmw7RQ89YAmdRFnuMThyk42
         06xeQrpcrmJfNf9U2KsP63Sz55csRqjMtxHdXaThqPBqcNoYUfIcgntdOAb9uHl5hSm5
         LWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779181241; x=1779786041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V0S/AdSvKtL3ahAyhw36hFA+GFXjjDuXc9yBZ9vHmkk=;
        b=pf95trZqku2xujcIqbSZpxXQkNrXXsXGoxtnXJkaze8Uh08fJl8uaQ0ZMWYfS0xGjV
         6UUtDD89wUbZBvLph6z5SFRzDlXFUCgNJtOdS2yjW6uNSwiOHQ0LJt8Kh9moIfsqYoOz
         1nGasXxcDyN0a3427Rua9UERbrhLRL+GnWUEV9OpgkZL6SakjmUKwowYuAsKzWGv1J+Q
         alo50ReQY5e7/S046JHaG9yhhVJ/D2Rpxxn4CXT5ra2g3x7qyH/TtnTlUIwmUcnf+NNB
         tiasrTwVDPhyDSsw53hDSnpWFEYOXT/Fcmlcg7j3wKOgK3K5Wb4olHxIkp9ZSJGCBdEN
         cMAg==
X-Gm-Message-State: AOJu0YyUkx+hFSELLdM/6dAbHgK5oFewhdxrTil0cwmvffinbrp93Y2c
	jc14CpiMwDs7fnKVFdRzB/FzVo9CnqFp9J+bZdPYSf96ZOEPlkZucnrxCBrfj0T7EpcnPA80RYf
	yxYAZ28fYe0A5Z/4lOlL+mxBzmQBsOFBDMgTS0mzyNGAmIA1ekLw4f2Rk
X-Gm-Gg: Acq92OGQI3aJ3JN0sQkx7Ms0X2xguzEP55e9vvBcLUYm0E24sUQ+BcRX7v00AIXnNWs
	TfPxaHk9BSJY5SAOYIjT8PK/u1SWpX2M06vY7HrDmAoiirpshA8+S3MS6/n2AOu0Yi1hi2Hs1ow
	izXvDPyR7ha3ZU/7RH7N/5HILlxeelLLXe5/WMry8eQdTHSesUj9RdHOqSO0scedpqHrSg81S8k
	ghBODXPhXMhtr0+p6Nc8FVPQhL4pdOH0xh0PLTD0qkbiTRNjRYbqknfmT3R7pmPlpIavJAuq5zs
	bpPO0k6MwxBSamyEMyy3y55AF26lQ+vkSIX1LDxYYDHLhWZgcpM3lb270Agql0+IcHJ/OXa2ivv
	BG7Z9
X-Received: by 2002:a05:6820:8185:b0:685:7678:b53c with SMTP id
 006d021491bc7-69c9bfb085cmr10174956eaf.46.1779181240558; Tue, 19 May 2026
 02:00:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <d56161b7-1f00-4e88-94fe-9e6d4db29ae0@mail.kernel.org>
In-Reply-To: <d56161b7-1f00-4e88-94fe-9e6d4db29ae0@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 11:00:28 +0200
X-Gm-Features: AVHnY4L__oGrg9vEHGBruWduKsGrVtLcvDZrqKjtndZlbUjwhI1KKsMbdVCwO7M
Message-ID: <CANp29Y4f6VyeHoGyWhmmp+_CgqVWj4Lbif07goqkYb23H_j8EA@mail.gmail.com>
Subject: Re: [PATCH RFC v3] btrfs: fix delayed transaction aborts
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz reject

On Sun, May 17, 2026 at 1:42=E2=80=AFAM 'syzbot' via
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
> commit critical section (commit_cowonly_roots(), commit_fs_roots(), and
> btrfs_qgroup_account_extents()).
>
> Also, replace the WARN() macro in btrfs_abort_transaction() with
> dump_stack() to prevent transaction aborts from triggering kernel
> warnings, while still printing the stack trace.
>
> Additionally, use lockdep maps for workqueue allocations to address
> lockdep key exhaustion.
>
> Fixes: 49b25e0540904be0bf558b84475c69d72e4de66e ("btrfs: enhance transact=
ion abort infrastructure")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+dafbca0e20fbc5946925@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Ddafbca0e20fbc5946925
> Link: https://syzkaller.appspot.com/ai_job?id=3D96c50581-2f5c-4140-ad4e-b=
f2cccae111e
> To: <clm@fb.com>
> To: <dsterba@suse.com>
> To: <linux-btrfs@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v3:
> - Dropped btrfs_abort_transaction() calls in create_pending_snapshot() to=
 reduce patch size.
> - Replaced WARN() with dump_stack() in btrfs_abort_transaction() instead =
of adding -ENOSPC to btrfs_abort_should_print_stack().
> - Restored workqueue changes addressing lockdep key exhaustion.
> - Moved btrfs_abort_transaction() call in btrfs_qgroup_account_extents() =
back to the error site.
>
> v2:
> - Consolidated btrfs_abort_transaction() calls at the end of functions un=
der cleanup/fail/out labels instead of calling them at each error site.
> - Dropped unrelated workqueue and super.c changes addressing lockdep key =
exhaustion.
> https://lore.kernel.org/all/54bfa402-a284-4649-94d3-a25a88a6c475@mail.ker=
nel.org/T/
>
> v1:
> https://lore.kernel.org/all/f77b5e84-af17-41f8-9357-e8f4cd4b8438@mail.ker=
nel.org/T/
> ---
> diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
> index e6f33d094..634b7b578 100644
> --- a/fs/btrfs/async-thread.c
> +++ b/fs/btrfs/async-thread.c
> @@ -81,9 +81,10 @@ static void btrfs_init_workqueue(struct btrfs_workqueu=
e *wq,
>         spin_lock_init(&wq->thres_lock);
>  }
>
> -struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_i=
nfo,
> -                                             const char *name, unsigned =
int flags,
> -                                             int limit_active, int thres=
h)
> +struct btrfs_workqueue *
> +__btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info, const char *name,
> +                       unsigned int flags, int limit_active, int thresh,
> +                       struct lock_class_key *key, struct lockdep_map *m=
ap)
>  {
>         struct btrfs_workqueue *ret =3D kzalloc_obj(*ret);
>
> @@ -109,8 +110,14 @@ struct btrfs_workqueue *btrfs_alloc_workqueue(struct=
 btrfs_fs_info *fs_info,
>                 ret->thresh =3D thresh;
>         }
>
> +#ifdef CONFIG_LOCKDEP
> +       lockdep_init_map(map, name, key, 0);
> +       ret->normal_wq =3D alloc_workqueue_lockdep_map(
> +               "btrfs-%s", flags, ret->current_active, map, name);
> +#else
>         ret->normal_wq =3D alloc_workqueue("btrfs-%s", flags, ret->curren=
t_active,
>                                          name);
> +#endif
>         if (!ret->normal_wq) {
>                 kfree(ret);
>                 return NULL;
> @@ -120,9 +127,10 @@ struct btrfs_workqueue *btrfs_alloc_workqueue(struct=
 btrfs_fs_info *fs_info,
>         return ret;
>  }
>
> -struct btrfs_workqueue *btrfs_alloc_ordered_workqueue(
> -                               struct btrfs_fs_info *fs_info, const char=
 *name,
> -                               unsigned int flags)
> +struct btrfs_workqueue *
> +__btrfs_alloc_ordered_workqueue(struct btrfs_fs_info *fs_info, const cha=
r *name,
> +                               unsigned int flags, struct lock_class_key=
 *key,
> +                               struct lockdep_map *map)
>  {
>         struct btrfs_workqueue *ret;
>
> @@ -137,7 +145,13 @@ struct btrfs_workqueue *btrfs_alloc_ordered_workqueu=
e(
>         ret->current_active =3D 1;
>         ret->thresh =3D NO_THRESHOLD;
>
> +#ifdef CONFIG_LOCKDEP
> +       lockdep_init_map(map, name, key, 0);
> +       ret->normal_wq =3D alloc_ordered_workqueue_lockdep_map("btrfs-%s"=
, flags,
> +                                                            map, name);
> +#else
>         ret->normal_wq =3D alloc_ordered_workqueue("btrfs-%s", flags, nam=
e);
> +#endif
>         if (!ret->normal_wq) {
>                 kfree(ret);
>                 return NULL;
> diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
> index 04c2f3175..f43f5feb9 100644
> --- a/fs/btrfs/async-thread.h
> +++ b/fs/btrfs/async-thread.h
> @@ -29,14 +29,40 @@ struct btrfs_work {
>         unsigned long flags;
>  };
>
> -struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_i=
nfo,
> -                                             const char *name,
> -                                             unsigned int flags,
> -                                             int limit_active,
> -                                             int thresh);
> -struct btrfs_workqueue *btrfs_alloc_ordered_workqueue(
> -                               struct btrfs_fs_info *fs_info, const char=
 *name,
> -                               unsigned int flags);
> +struct btrfs_workqueue *
> +__btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info, const char *name,
> +                       unsigned int flags, int limit_active, int thresh,
> +                       struct lock_class_key *key, struct lockdep_map *m=
ap);
> +#ifdef CONFIG_LOCKDEP
> +#define btrfs_alloc_workqueue(fs_info, name, flags, limit_active, thresh=
)   \
> +       ({                                                               =
   \
> +               static struct lock_class_key __key;                      =
   \
> +               static struct lockdep_map __map;                         =
   \
> +               __btrfs_alloc_workqueue(fs_info, name, flags, limit_activ=
e, \
> +                                       thresh, &__key, &__map);         =
   \
> +       })
> +#else
> +#define btrfs_alloc_workqueue(fs_info, name, flags, limit_active, thresh=
)   \
> +       __btrfs_alloc_workqueue(fs_info, name, flags, limit_active, thres=
h, \
> +                               NULL, NULL)
> +#endif
> +
> +struct btrfs_workqueue *
> +__btrfs_alloc_ordered_workqueue(struct btrfs_fs_info *fs_info, const cha=
r *name,
> +                               unsigned int flags, struct lock_class_key=
 *key,
> +                               struct lockdep_map *map);
> +#ifdef CONFIG_LOCKDEP
> +#define btrfs_alloc_ordered_workqueue(fs_info, name, flags)             =
      \
> +       ({                                                               =
     \
> +               static struct lock_class_key __key;                      =
     \
> +               static struct lockdep_map __map;                         =
     \
> +               __btrfs_alloc_ordered_workqueue(fs_info, name, flags, &__=
key, \
> +                                               &__map);                 =
     \
> +       })
> +#else
> +#define btrfs_alloc_ordered_workqueue(fs_info, name, flags) \
> +       __btrfs_alloc_ordered_workqueue(fs_info, name, flags, NULL, NULL)
> +#endif
>  void btrfs_init_work(struct btrfs_work *work, btrfs_func_t func,
>                      btrfs_ordered_func_t ordered_func);
>  void btrfs_queue_work(struct btrfs_workqueue *wq,
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index cdf736d3a..f9acfab14 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3076,6 +3076,10 @@ int btrfs_qgroup_account_extents(struct btrfs_tran=
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
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 248adb785..aa0ce0c59 100644
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
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 7d70fe486..f816e62f3 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -246,27 +246,21 @@ static inline bool btrfs_abort_should_print_stack(i=
nt error)
>   * Call btrfs_abort_transaction as early as possible when an error condi=
tion is
>   * detected, that way the exact stack trace is reported for some errors.
>   */
> -#define btrfs_abort_transaction(trans, error)          \
> -do {                                                           \
> -       bool __first =3D false;                                   \
> -       /* Report first abort since mount */                    \
> -       if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,     \
> -                       &((trans)->fs_info->fs_state))) {       \
> -               __first =3D true;                                 \
> -               if (WARN(btrfs_abort_should_print_stack(error), \
> -                       KERN_ERR                                \
> -                       "BTRFS: Transaction aborted (error %d)\n",      \
> -                       (error))) {                                     \
> -                       /* Stack trace printed. */                      \
> -               } else {                                                \
> -                       btrfs_err((trans)->fs_info,                     \
> -                                 "Transaction aborted (error %d)",     \
> -                                 (error));                     \
> -               }                                               \
> -       }                                                       \
> -       __btrfs_abort_transaction((trans), __func__,            \
> -                                 __LINE__, (error), __first);  \
> -} while (0)
> +#define btrfs_abort_transaction(trans, error)                           =
      \
> +       do {                                                             =
     \
> +               bool __first =3D false;                                  =
       \
> +               /* Report first abort since mount */                     =
     \
> +               if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,      =
     \
> +                                     &((trans)->fs_info->fs_state))) {  =
     \
> +                       __first =3D true;                                =
       \
> +                       btrfs_err((trans)->fs_info,                      =
     \
> +                                 "Transaction aborted (error %d)", (erro=
r)); \
> +                       if (btrfs_abort_should_print_stack(error))       =
     \
> +                               dump_stack();                            =
     \
> +               }                                                        =
     \
> +               __btrfs_abort_transaction((trans), __func__, __LINE__,   =
     \
> +                                         (error), __first);             =
     \
> +       } while (0)
>
>  int btrfs_end_transaction(struct btrfs_trans_handle *trans);
>  struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *ro=
ot,
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
-upstream-moderation/d56161b7-1f00-4e88-94fe-9e6d4db29ae0%40mail.kernel.org=
.
