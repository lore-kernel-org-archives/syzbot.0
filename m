Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FA743CEEB
	for <syzbot@lists.linux.dev>; Fri, 15 May 2026 09:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778838071; cv=pass; b=bEVzj9m1hAnh576e1UT50yub938OtDa3tPg/4WO6fkTd1kSVKe3WMS+X3+JZ7F/XQd94Ib7iy/YHKRkBy9Z3jhuSY3yZg5v1PeuslDWFrMFgphkKkE5hy8f03/7NSdl9fs+0smu3blIOILpLLPhrTmlSBuNQ1gPJbiMPU8Crupg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778838071; c=relaxed/simple;
	bh=U6gj8VYHhJOvpLwWlxOtmFf9UXNgzsP/7+m8S5agiuk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pd0i2PaaSegKZ93f9vFWi7S+xbPGwVFnHPpit/5lA5gB/QYRgDyYqZCtU9IUuUEhcE4V7F/aASqN3/WOAHwJkJRKh0ls1PuYA4OywBtH++L0WBve5z9xH5vpRXmn0pPTZtjE7el45Fq0vbpVVAzTtBIiamhOIH0zAwO9e/56iCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AKtUu1ru; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AKtUu1ru"
Received: by smtp.kernel.org (Postfix)
	id AC155C2BCB0; Fri, 15 May 2026 09:41:11 +0000 (UTC)
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9B243C2BCB8
	for <syzbot@kernel.org>; Fri, 15 May 2026 09:41:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 9B243C2BCB8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-40423dbe98bso4581229fac.2
        for <syzbot@kernel.org>; Fri, 15 May 2026 02:41:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778838069; cv=none;
        d=google.com; s=arc-20240605;
        b=Imdu6B7ywBgpqXbWNuC3nNkomzTkNqCLPSa/fGETZoni+0dl3Ff7qNquOUW3PsPDEi
         2pdqQDAh72tTcOOOZvj6jU+uMTTHsuBHbkmjtULnPzj19oqtFx0Db6O95dz/h/we3JUc
         Q/hL9QXXYqE2Pr6PKE0X/RE4ul/vAdetqbx4z5TpnaC2vW/wY8yV+G1rYuaf9zWejXjg
         LXsA35ZW1kimJ5L0/8Jl3oeDNzj1CExEzEQ46zKbLhw/D3VEKS3CNXk/9fV02Gq8gBUC
         ads2UldZnDnp+krv8Gj3duzpuwM8bjWG+yLIVLENGLqqrTwnRn5opK0rFdmXQwJ1bcsP
         fzsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mn46rWZav+zRXWvFKwBCNeC6/3njIuD6Ij4B7BbuvrI=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=A0vi4XlBReCr6FKA9Y2paFU3jwVL8NO6tYnunyYAA07wj/LvR9u/CcEXDG3LZpP4/F
         paiSrjCI5ex5vcjPiUwl86taf+e7he4/C5E6UFta4ETnkGeFbRdPbh7OwbkzHM0ww8l2
         ZUZ7/bDta2SicI8+jfh5JqP3VnHkNltKnGYTJtETv6qS9EJcqHRw8xwYFhKBMDgEEvoB
         fwg+y3tAqF99DwvcQJySGJYkDafMhqhJtehGTjG1rJudckXHlCiVbBAGqDm3BBKQJyAW
         PsscifhwnOfj8ElozZ5MAPzK0+TLfmy7kXADaGyvpO8olDC4PRaQEm43rbvaH0R7H7Lt
         lUhw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778838069; x=1779442869; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mn46rWZav+zRXWvFKwBCNeC6/3njIuD6Ij4B7BbuvrI=;
        b=AKtUu1rutgTTYtVmDMDp/a/MkbSVsKg841QWe1G7jWvm81icSicbrpruqRmuh00AqF
         waM2AqOa0of/2nGyd34DcSlIQ6VXwLxq0etH9Z9XsKHbGPxJxr2qhKj6RirRDaL8EYgy
         HlxQgdhg5nLRIKYr+8wPOCIDexhCRPZ0yEpr7SPN9SXy1G7h3xhRR3ve7do14JjJ3ihM
         Ac+3xKePjDywCawD+HY8+excAN1OBRXX/IVYb0U90k2N95ChvEQ4Rv2KtHdUeCPgKGLX
         KlrrNumuxtIIuDz6tujXzuTtmOc/AByyUYpS9Wj0kZzbom5xb09Vhcjs96SSaXacZPfo
         nicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778838069; x=1779442869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mn46rWZav+zRXWvFKwBCNeC6/3njIuD6Ij4B7BbuvrI=;
        b=kOdrmcbVcdCSxYi1OUfU+3PmqXMrvFRI0FP/74dQEkvqBKWesjA7pA9NG/gZcDVM1g
         WCMsIfoQdNnG+g6J2leDKJkXjQAlDdu8BT4Z7TmH8MG0vM5PcqaRicku5F1plUQLy85J
         JzW4C0INw1JCEqINIrYygvjqbGDCNoyolwqlZU3sU0xnjqKedQQStHaRqQP+qjw8lP6X
         RImlWeCfbS3yrPlHwksUPYl5ne8x1MuywwG/gfeW5su1DmK6JwDFmZhzRPAi6v9kqEc8
         dzV0EsLaAc4z8G5STK/X3wmYCEFQm9Acxy5gv61S9A8+8mFOIgI9MJiyQz0GRzg8a92i
         ErvA==
X-Gm-Message-State: AOJu0YzFUNjC3ttym/cbXMZLCqvUs7gKREqPkEluMf2V1vlrnjn5Hlml
	MaaaGOjbQ4Li1e6ASGOZzCsjkBSnm1tO/2Lg0z7JOAiJ1kq3BJMD0Vg/FCQHvsPJltK1ljCrW9S
	fSUPgFvJr6HV0u44rEcj6+4K22IN6I4+hQraKIlC+CIhH0M7TYQTGxaqx
X-Gm-Gg: Acq92OFX0jS/FivsPSdgfXPFn06VL3dzrwPyvs9Po7fkECqLmT3VtazY+4I5SAUG41z
	2+JlQqqIA37bwjocwnQ0fSb2cCOEsBC6A+Y0Be21zi+Hze4yi68duPJnrkaCV63lk5zxdOXJdqY
	OLQHhfNWHt6Ok25P6LEBeq9FtCrKvgYIjFDqGy4i2URx6E+bUhU3Bm3ZOlK3d+PQdj80bx+eyzf
	65LjZzktyclYpzdPNUqMgBoBEJnpF+PXbAh352iWnanp5dgJXwh2aE7o/Qv3opdwkkeqxZGeI8K
	bcsVA/pQgD2WvN6e5Lf5QA9IKJndSKM1Im/S2jBXyXJo7HR8+jvZZZhLGG8t6kVfMQH5t1OR/dr
	DhRxSYOWkHWRr1Xc=
X-Received: by 2002:a05:6870:ff43:b0:439:b290:d4cd with SMTP id
 586e51a60fabf-43a2dd178afmr2078779fac.22.1778838069203; Fri, 15 May 2026
 02:41:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6c0af3f2-ec3b-4331-a453-970522943a07@mail.kernel.org>
In-Reply-To: <6c0af3f2-ec3b-4331-a453-970522943a07@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 15 May 2026 11:40:58 +0200
X-Gm-Features: AVHnY4LezRG5wbTQ7ymVS9Z0pHV_oON9brFfAN0QBIx9bomNpIE0OKblwvoHvCI
Message-ID: <CANp29Y6UBYVzgcXCKCXW0qELqfBeb2XDKuK-eJeqUx_YAe9vVQ@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: Fix null-ptr-deref in bpf_get_local_storage() on
 link update
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Why is the diff so large? Can it be smaller?

On Thu, May 14, 2026 at 2:05=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The syzkaller reported a KASAN null-ptr-deref in
> bpf_get_local_storage(). This occurs when a BPF program tries to access
> its cgroup storage, but the storage pointer in the effective program
> array is NULL.
>
> The root cause is a bug in __cgroup_bpf_replace() which handles
> BPF_LINK_UPDATE for cgroup links. When replacing a program that does not
> use cgroup storage with one that does, __cgroup_bpf_replace() fails to
> allocate the new cgroup storage. Furthermore, it uses
> replace_effective_prog() which only updates the program pointer in the
> effective array and ignores the cgroup_storage array. This leaves the
> storage pointers as NULL, leading to a crash when the new program
> executes and calls bpf_get_local_storage().
>
> To fix this, rewrite __cgroup_bpf_replace() to properly allocate the new
> cgroup storage, update the storage pointers, and rebuild the effective
> arrays using update_effective_progs(). This ensures safe, RCU-protected
> swapping of both the program and its storage. The
> replace_effective_prog() function is fundamentally unsafe when cgroup
> storage is involved and is removed entirely.
>
> Additionally, fix a similar rollback bug in __cgroup_bpf_attach(). When
> replacing an existing program (BPF_F_REPLACE), if
> update_effective_progs() fails, the code restores the old program but
> fails to restore the old storage pointers, leaving dangling pointers
> after the new storage is freed. Save and restore the old storage
> pointers to prevent a potential use-after-free.
>
> Fixes: 0c991ebc8c69d29b7fc44db17075c5aa5253e2ab ("bpf: Implement bpf_prog=
 replacement for an active bpf_cgroup_link")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+4fe468a3f7fac86ea2c9@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3D4fe468a3f7fac86ea2c9
> Link: https://syzkaller.appspot.com/ai_job?id=3D8b1e4143-642b-4b3e-8be9-1=
94c7a66e24a
> To: <bpf@vger.kernel.org>
> To: <martin.lau@linux.dev>
> Cc: <andrii@kernel.org>
> Cc: <ast@kernel.org>
> Cc: <daniel@iogearbox.net>
> Cc: <eddyz87@gmail.com>
> Cc: <jolsa@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: <memxor@gmail.com>
> Cc: <song@kernel.org>
> Cc: <yonghong.song@linux.dev>
>
> ---
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 876f6a81a..625140a6e 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -792,6 +792,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>         struct bpf_prog *old_prog =3D NULL;
>         struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] =
=3D {};
>         struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYP=
E] =3D {};
> +       struct bpf_cgroup_storage *save_storage[MAX_BPF_CGROUP_STORAGE_TY=
PE];
>         struct bpf_prog *new_prog =3D prog ? : link->link.prog;
>         enum cgroup_bpf_attach_type atype;
>         struct bpf_prog_list *pl;
> @@ -844,6 +845,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>
>         if (pl) {
>                 old_prog =3D pl->prog;
> +               bpf_cgroup_storages_assign(save_storage, pl->storage);
>         } else {
>                 pl =3D kmalloc_obj(*pl);
>                 if (!pl) {
> @@ -894,6 +896,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
>         if (old_prog) {
>                 pl->prog =3D old_prog;
>                 pl->link =3D NULL;
> +               bpf_cgroup_storages_assign(pl->storage, save_storage);
>         }
>         bpf_cgroup_storages_free(new_storage);
>         if (!old_prog) {
> @@ -918,51 +921,6 @@ static int cgroup_bpf_attach(struct cgroup *cgrp,
>         return ret;
>  }
>
> -/* Swap updated BPF program for given link in effective program arrays a=
cross
> - * all descendant cgroups. This function is guaranteed to succeed.
> - */
> -static void replace_effective_prog(struct cgroup *cgrp,
> -                                  enum cgroup_bpf_attach_type atype,
> -                                  struct bpf_cgroup_link *link)
> -{
> -       struct bpf_prog_array_item *item;
> -       struct cgroup_subsys_state *css;
> -       struct bpf_prog_array *progs;
> -       struct bpf_prog_list *pl;
> -       struct hlist_head *head;
> -       struct cgroup *cg;
> -       int pos;
> -
> -       css_for_each_descendant_pre(css, &cgrp->self) {
> -               struct cgroup *desc =3D container_of(css, struct cgroup, =
self);
> -
> -               if (percpu_ref_is_zero(&desc->bpf.refcnt))
> -                       continue;
> -
> -               /* find position of link in effective progs array */
> -               for (pos =3D 0, cg =3D desc; cg; cg =3D cgroup_parent(cg)=
) {
> -                       if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW_M=
ULTI))
> -                               continue;
> -
> -                       head =3D &cg->bpf.progs[atype];
> -                       hlist_for_each_entry(pl, head, node) {
> -                               if (!prog_list_prog(pl))
> -                                       continue;
> -                               if (pl->link =3D=3D link)
> -                                       goto found;
> -                               pos++;
> -                       }
> -               }
> -found:
> -               BUG_ON(!cg);
> -               progs =3D rcu_dereference_protected(
> -                               desc->bpf.effective[atype],
> -                               lockdep_is_held(&cgroup_mutex));
> -               item =3D &progs->items[pos];
> -               WRITE_ONCE(item->prog, link->link.prog);
> -       }
> -}
> -
>  /**
>   * __cgroup_bpf_replace() - Replace link's program and propagate the cha=
nge
>   *                          to descendants
> @@ -978,10 +936,14 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp=
,
>                                 struct bpf_prog *new_prog)
>  {
>         enum cgroup_bpf_attach_type atype;
> +       struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] =
=3D {};
> +       struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYP=
E] =3D {};
> +       struct bpf_cgroup_storage *save_storage[MAX_BPF_CGROUP_STORAGE_TY=
PE];
>         struct bpf_prog *old_prog;
>         struct bpf_prog_list *pl;
>         struct hlist_head *progs;
>         bool found =3D false;
> +       int err;
>
>         atype =3D bpf_cgroup_atype_find(link->link.attach_type, new_prog-=
>aux->attach_btf_id);
>         if (atype < 0)
> @@ -1001,9 +963,27 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp=
,
>         if (!found)
>                 return -ENOENT;
>
> +       err =3D bpf_cgroup_storages_alloc(storage, new_storage,
> +                                       link->link.attach_type, new_prog,=
 cgrp);
> +       if (err)
> +               return err;
> +
> +       bpf_cgroup_storages_assign(save_storage, pl->storage);
> +       bpf_cgroup_storages_assign(pl->storage, storage);
>         cgrp->bpf.revisions[atype] +=3D 1;
> +
>         old_prog =3D xchg(&link->link.prog, new_prog);
> -       replace_effective_prog(cgrp, atype, link);
> +
> +       err =3D update_effective_progs(cgrp, atype);
> +       if (err) {
> +               xchg(&link->link.prog, old_prog);
> +               cgrp->bpf.revisions[atype] -=3D 1;
> +               bpf_cgroup_storages_assign(pl->storage, save_storage);
> +               bpf_cgroup_storages_free(new_storage);
> +               return err;
> +       }
> +
> +       bpf_cgroup_storages_link(new_storage, cgrp, link->link.attach_typ=
e);
>         bpf_prog_put(old_prog);
>         return 0;
>  }
>
>
> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
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
-upstream-moderation/6c0af3f2-ec3b-4331-a453-970522943a07%40mail.kernel.org=
.
