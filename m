Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA92728686
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 05:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778908636; cv=pass; b=dXcPHmPD+IGALwu9JEIAyJchzAj0Q67Cl0dIAdJK9OiQeGKxTg8oJYtBp+dkMsgeYVX13prLWK2gyLUgclTK/dpTvwAQcvkt+Rb1SRPKNdKXlXsV2oDV+pDBDq3hQj9IFGt/R5OtPhkAxIKkN+pFtC21iKkS5XqdVPw3deMwY0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778908636; c=relaxed/simple;
	bh=WSOaOv3C2gK2WseltaXlPsfCTAYXMscgAb5zJ3YX1+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j/fG4ZCBJ2MR5+Hb/AAS5leE3QfvBMTo9bXV1IHBViTLqkLMUs9hLri7YKCsNjWw/MLr+9P98jaGsVYstfAsMIiv0O2NXWLTDiiRKjGdqqpxqvPs7Lz8QatuKxFN3t5d0rzhyTySL04RYeETip6mRtu26O5/zYTVbBVfvgZQnvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EZHmOU52; arc=pass smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EZHmOU52"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-38e800deae4so6554761fa.0
        for <syzbot@lists.linux.dev>; Fri, 15 May 2026 22:17:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778908633; cv=none;
        d=google.com; s=arc-20240605;
        b=fQWfAhKv2btCPvLz4XDOWEtclTTg1+g9km/Pp5ECekLJmvEYa/G96kH5GxjDNrk9lI
         ZsT8PjFMrFGbBCEnhPwXtEZFnsKcwIhP8KI6eDSy5eAHn4RadyC7smYrvRnhhKYv1bvd
         7ubihQ3SXCM3MYCE6ofkFNks2skhlmYdyDkaqNxzqidALNuI3T+ALfDGCIg14yXLM/nR
         mQJqO3XuDena/lJTOEhcDOWgokE/j3/YmMPUaJRglnFzIG9/3pgESv7Gcu8RoWZ7i94q
         2YehpVt9EytxUdD/YIbnfeJBYwI0j9VfaZABKHdxjeRPH8T/AQy0qQqDm3tTqUzxgM6M
         VVYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Uwrt33kQKl/pB/AetbYNrxTlBSGaDTFTuIrOEvI62W4=;
        fh=XYQWT8duwAzjDzDZCgCV+AGKfq9xBYro4d/DbXHIdKM=;
        b=ibDPEXOk5Xcq43itQyvPAb/3C4nrvfXRcrWmGMw6xTSiRA/E/1YvvMVAAGIuvkS8HK
         pgoRoDGF1QLkXj8C9BW7pL1o+TH5nXJ06GGJ+kjvt6Wjdf1CXlz1uAFisF6oR1fPMa1D
         67p+Lxh3I8TNNUZJ0cFlmxhrZvQ0RJqCSpi1n+nfX5K5QHB87iwpv94mlKqVTyoZ5Gls
         blqqajk4fhLz0gQ+KFs2gh0W8zttNdseYLAw2ezuPTXpO3ctQOdJibPANtLPRVpod2WO
         Iao5HhGIV+5sthk3ikml5jZPKytimvzbfeK/tZk1HTtozWzyHzmOWEfT/Pd5igpV4CmY
         UETA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778908633; x=1779513433; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uwrt33kQKl/pB/AetbYNrxTlBSGaDTFTuIrOEvI62W4=;
        b=EZHmOU52tR5WmjOES4Fhp4p+u5XDwQU3If0yD3cXsNn6lciBs8oNyK43WJEf3h9EDN
         laDmeH8SS7fkyjPCLPodv3JbM0Hwu/GIARTtG/5iCL3fmRT5hkeHSHh34dC0FQccfT+O
         IuJxbVMSBkK0wNyrPd43xqjGooU45aa8KPkr0vclElDRVPpFP0+Z6MUvOV22OnfrCBtt
         IM6QhA4KP6gdVZgenGA9Ji5W61c1LIZMKl+0EYxtIqr9P1wXuDqrmiMem0jwUnAlD/ff
         hIV9UlAbRDGFnLWwqgObFMA7S4s88o+vIBsA+k3s5jwcrxv5wdN5ZiqkcCJz1dsuwwvE
         dmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778908633; x=1779513433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uwrt33kQKl/pB/AetbYNrxTlBSGaDTFTuIrOEvI62W4=;
        b=KP1bUYFfN1uSMgspibM5Nl2Zk0q9cxqp21dwDMFA7U0lAHd/RAF55a+ZKKUl1Gt4iG
         Qnx3+Rpu2ITU6m7gA7QLZHU/uZSaWNk5zGt1fQdrwFIYyXhBmVhcLRTZbKEN47v1osEg
         iOJ11V88n/VW7ZnEJGUfpvzurjdCO8gVPjUX6zgfM345NONIi6kDng3fOVAX5TLhMn/z
         ZEj0HKETku0w/RR4kSNno6SuvXB7s0yBMr2fJJ+Np1nBxPiaAJfhBHJMIcta/7A9opuk
         fjV5hbdaQSzS7T2sr1wgzXdD5SI6MPcRLZsR1uo323Dfi9Iob8exjyW/yU9LaKfgTNl1
         jUsg==
X-Forwarded-Encrypted: i=1; AFNElJ9fFA51morln5R/3Z93x7nJIUL+wk6V9ImZjyAYN/ECqlyw+ncmZktHa5xm6fhvlHtZHIA5MKE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9YiTzfY2DbZX6I+ubYjfEsx7maJFV4uby7c1cxiGc8QS3gn4s
	/gScnCd9Acwb4M+YnK4zpBRc1diOvWE8UjXuyojRlLmXkEnxu2CaOEEKR69YTzjasmcROYbmWYq
	KzEjAM9rwaeiP9m7ZRdnmR4BaruIHn/JowlALLeEp
X-Gm-Gg: Acq92OFKevW9NDTintpAv0QtssvNtKAdogqDU+WZz/kC0r7a2bvs1rDSi8FQsph21W7
	xmfAyweLSSc3OIEjwbYMiDHpXJ12jXID46EtbfWWUSLTjXznFSpp11Wfkl4koguK3B1bH+5gzzX
	E1kBAQea1/1OZTKnnSx4SRoePiiuGppG7FDj4+Wzy2vU/I910lpKwNoNKYw85cgPsNSRFGXAcfO
	zz6JSd65n+b43vNJ7Cb/nx4SP2qCTErWjeP4hR9AZ05B5XIeaC5uD7I3pVp+TvntxSdss5nbNxS
	X8QcBU4ADujMKC+tzK7CTAvaqLTCpH+ZP9UWfFU1lMCuJp6oKU+JFBRer/i9O8MizAoZlhJeR2z
	e8aA4E8A=
X-Received: by 2002:a05:651c:b2b:b0:393:a31a:ab3c with SMTP id
 38308e7fff4ca-39561ed7299mr19006361fa.25.1778908632754; Fri, 15 May 2026
 22:17:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6c0af3f2-ec3b-4331-a453-970522943a07@mail.kernel.org> <CANp29Y6UBYVzgcXCKCXW0qELqfBeb2XDKuK-eJeqUx_YAe9vVQ@mail.gmail.com>
In-Reply-To: <CANp29Y6UBYVzgcXCKCXW0qELqfBeb2XDKuK-eJeqUx_YAe9vVQ@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 16 May 2026 07:17:01 +0200
X-Gm-Features: AVHnY4KfBJMQancMs9v-OldREpD8UekbLzh5eLeMowbahj-7jsy52TexMygZD1M
Message-ID: <CACT4Y+Z3Kr9Lf=i3HJgD1wXxhg24vivAWyUYeJjnW0AbcpvmFQ@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: Fix null-ptr-deref in bpf_get_local_storage() on
 link update
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

There was a discussion about this bug, and a patch has already been propose=
d.
Asked upstream about these patches:
https://lore.kernel.org/all/69546dea.050a0220.a1b6.0306.GAE@google.com/T/#m=
8d8eb5927df4f06f1048c1afb2607e52224a14e9

On Fri, 15 May 2026 at 11:41, 'Aleksandr Nogikh' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> Why is the diff so large? Can it be smaller?
>
> On Thu, May 14, 2026 at 2:05=E2=80=AFAM 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
> >
> > The syzkaller reported a KASAN null-ptr-deref in
> > bpf_get_local_storage(). This occurs when a BPF program tries to access
> > its cgroup storage, but the storage pointer in the effective program
> > array is NULL.
> >
> > The root cause is a bug in __cgroup_bpf_replace() which handles
> > BPF_LINK_UPDATE for cgroup links. When replacing a program that does no=
t
> > use cgroup storage with one that does, __cgroup_bpf_replace() fails to
> > allocate the new cgroup storage. Furthermore, it uses
> > replace_effective_prog() which only updates the program pointer in the
> > effective array and ignores the cgroup_storage array. This leaves the
> > storage pointers as NULL, leading to a crash when the new program
> > executes and calls bpf_get_local_storage().
> >
> > To fix this, rewrite __cgroup_bpf_replace() to properly allocate the ne=
w
> > cgroup storage, update the storage pointers, and rebuild the effective
> > arrays using update_effective_progs(). This ensures safe, RCU-protected
> > swapping of both the program and its storage. The
> > replace_effective_prog() function is fundamentally unsafe when cgroup
> > storage is involved and is removed entirely.
> >
> > Additionally, fix a similar rollback bug in __cgroup_bpf_attach(). When
> > replacing an existing program (BPF_F_REPLACE), if
> > update_effective_progs() fails, the code restores the old program but
> > fails to restore the old storage pointers, leaving dangling pointers
> > after the new storage is freed. Save and restore the old storage
> > pointers to prevent a potential use-after-free.
> >
> > Fixes: 0c991ebc8c69d29b7fc44db17075c5aa5253e2ab ("bpf: Implement bpf_pr=
og replacement for an active bpf_cgroup_link")
> > Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-previe=
w
> > Reported-by: syzbot+4fe468a3f7fac86ea2c9@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=3D4fe468a3f7fac86ea2c9
> > Link: https://syzkaller.appspot.com/ai_job?id=3D8b1e4143-642b-4b3e-8be9=
-194c7a66e24a
> > To: <bpf@vger.kernel.org>
> > To: <martin.lau@linux.dev>
> > Cc: <andrii@kernel.org>
> > Cc: <ast@kernel.org>
> > Cc: <daniel@iogearbox.net>
> > Cc: <eddyz87@gmail.com>
> > Cc: <jolsa@kernel.org>
> > Cc: <linux-kernel@vger.kernel.org>
> > Cc: <memxor@gmail.com>
> > Cc: <song@kernel.org>
> > Cc: <yonghong.song@linux.dev>
> >
> > ---
> > diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> > index 876f6a81a..625140a6e 100644
> > --- a/kernel/bpf/cgroup.c
> > +++ b/kernel/bpf/cgroup.c
> > @@ -792,6 +792,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >         struct bpf_prog *old_prog =3D NULL;
> >         struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE]=
 =3D {};
> >         struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_T=
YPE] =3D {};
> > +       struct bpf_cgroup_storage *save_storage[MAX_BPF_CGROUP_STORAGE_=
TYPE];
> >         struct bpf_prog *new_prog =3D prog ? : link->link.prog;
> >         enum cgroup_bpf_attach_type atype;
> >         struct bpf_prog_list *pl;
> > @@ -844,6 +845,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >
> >         if (pl) {
> >                 old_prog =3D pl->prog;
> > +               bpf_cgroup_storages_assign(save_storage, pl->storage);
> >         } else {
> >                 pl =3D kmalloc_obj(*pl);
> >                 if (!pl) {
> > @@ -894,6 +896,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
> >         if (old_prog) {
> >                 pl->prog =3D old_prog;
> >                 pl->link =3D NULL;
> > +               bpf_cgroup_storages_assign(pl->storage, save_storage);
> >         }
> >         bpf_cgroup_storages_free(new_storage);
> >         if (!old_prog) {
> > @@ -918,51 +921,6 @@ static int cgroup_bpf_attach(struct cgroup *cgrp,
> >         return ret;
> >  }
> >
> > -/* Swap updated BPF program for given link in effective program arrays=
 across
> > - * all descendant cgroups. This function is guaranteed to succeed.
> > - */
> > -static void replace_effective_prog(struct cgroup *cgrp,
> > -                                  enum cgroup_bpf_attach_type atype,
> > -                                  struct bpf_cgroup_link *link)
> > -{
> > -       struct bpf_prog_array_item *item;
> > -       struct cgroup_subsys_state *css;
> > -       struct bpf_prog_array *progs;
> > -       struct bpf_prog_list *pl;
> > -       struct hlist_head *head;
> > -       struct cgroup *cg;
> > -       int pos;
> > -
> > -       css_for_each_descendant_pre(css, &cgrp->self) {
> > -               struct cgroup *desc =3D container_of(css, struct cgroup=
, self);
> > -
> > -               if (percpu_ref_is_zero(&desc->bpf.refcnt))
> > -                       continue;
> > -
> > -               /* find position of link in effective progs array */
> > -               for (pos =3D 0, cg =3D desc; cg; cg =3D cgroup_parent(c=
g)) {
> > -                       if (pos && !(cg->bpf.flags[atype] & BPF_F_ALLOW=
_MULTI))
> > -                               continue;
> > -
> > -                       head =3D &cg->bpf.progs[atype];
> > -                       hlist_for_each_entry(pl, head, node) {
> > -                               if (!prog_list_prog(pl))
> > -                                       continue;
> > -                               if (pl->link =3D=3D link)
> > -                                       goto found;
> > -                               pos++;
> > -                       }
> > -               }
> > -found:
> > -               BUG_ON(!cg);
> > -               progs =3D rcu_dereference_protected(
> > -                               desc->bpf.effective[atype],
> > -                               lockdep_is_held(&cgroup_mutex));
> > -               item =3D &progs->items[pos];
> > -               WRITE_ONCE(item->prog, link->link.prog);
> > -       }
> > -}
> > -
> >  /**
> >   * __cgroup_bpf_replace() - Replace link's program and propagate the c=
hange
> >   *                          to descendants
> > @@ -978,10 +936,14 @@ static int __cgroup_bpf_replace(struct cgroup *cg=
rp,
> >                                 struct bpf_prog *new_prog)
> >  {
> >         enum cgroup_bpf_attach_type atype;
> > +       struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE]=
 =3D {};
> > +       struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_T=
YPE] =3D {};
> > +       struct bpf_cgroup_storage *save_storage[MAX_BPF_CGROUP_STORAGE_=
TYPE];
> >         struct bpf_prog *old_prog;
> >         struct bpf_prog_list *pl;
> >         struct hlist_head *progs;
> >         bool found =3D false;
> > +       int err;
> >
> >         atype =3D bpf_cgroup_atype_find(link->link.attach_type, new_pro=
g->aux->attach_btf_id);
> >         if (atype < 0)
> > @@ -1001,9 +963,27 @@ static int __cgroup_bpf_replace(struct cgroup *cg=
rp,
> >         if (!found)
> >                 return -ENOENT;
> >
> > +       err =3D bpf_cgroup_storages_alloc(storage, new_storage,
> > +                                       link->link.attach_type, new_pro=
g, cgrp);
> > +       if (err)
> > +               return err;
> > +
> > +       bpf_cgroup_storages_assign(save_storage, pl->storage);
> > +       bpf_cgroup_storages_assign(pl->storage, storage);
> >         cgrp->bpf.revisions[atype] +=3D 1;
> > +
> >         old_prog =3D xchg(&link->link.prog, new_prog);
> > -       replace_effective_prog(cgrp, atype, link);
> > +
> > +       err =3D update_effective_progs(cgrp, atype);
> > +       if (err) {
> > +               xchg(&link->link.prog, old_prog);
> > +               cgrp->bpf.revisions[atype] -=3D 1;
> > +               bpf_cgroup_storages_assign(pl->storage, save_storage);
> > +               bpf_cgroup_storages_free(new_storage);
> > +               return err;
> > +       }
> > +
> > +       bpf_cgroup_storages_link(new_storage, cgrp, link->link.attach_t=
ype);
> >         bpf_prog_put(old_prog);
> >         return 0;
> >  }
> >
> >
> > base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> > --
> > This is an AI-generated patch subject to moderation.
> > Reply with '#syz upstream' to send it to the mailing list.
> > Reply with '#syz reject' to reject it.
> >
> > See  for more information.
> >
> > --
> > You received this message because you are subscribed to the Google Grou=
ps "syzkaller-upstream-moderation" group.
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkall=
er-upstream-moderation/6c0af3f2-ec3b-4331-a453-970522943a07%40mail.kernel.o=
rg.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/CANp29Y6UBYVzgcXCKCXW0qELqfBeb2XDKuK-eJeqUx_YAe9vVQ%40=
mail.gmail.com.
