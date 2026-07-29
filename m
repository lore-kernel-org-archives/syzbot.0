Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5A3484240
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 13:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785331311; cv=pass; b=rcwK3rv8UNPVodcEWJ8LyOVL98jQ5/rK1uOZ+cChj7/3Sw6RZIUfqyiopmn8Cs87saJPu8wAvc1OLOB5SrPFyJ3ikkA+OAZkBsKdwYB7YbSN/H/jIJlCNXDSnLPnboKol3A64Fhsww5dyqoYzUnRJ4RqVvXtHf1xlOTR9Pl31LY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785331311; c=relaxed/simple;
	bh=5yoruW7tCFP1re0JSKRZf6Li/ZNHa7XbGn72o4UR+pU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sZQUGPkkGt6LOsUlz6Hm/uDkwVI8vS40EBh9vUFNBSZ34RNamGWo6gYe+Bvz/t8/dyObvSRXhXPNB6l9Y2H8ycnm1drynaFAaCafcj/SQphLO6466SH46PSa737BkKulOMf3u+ntwndGh4CTx34xmFrIhFykIz5Y3pos9thX4Fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S10KCP+0; arc=pass smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S10KCP+0"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-497e6956acfso759676b6e.1
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 06:21:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785331308; cv=none;
        d=google.com; s=arc-20260327;
        b=Sum/SkL5pjFCQcxIb0dABYWDcmX1LunCEeconLak4Qbs+t7bUi9yKj1MzKuQvtRnbn
         B7PhLyT+D0xBUJUqksI1VStmmhbzQWktHfE/6aqEry8pN8SpcJzdrk2ukrrawL6BYXY8
         M6QRMHNJTejrh66tCFxrJhww8inSvEMdcfYaNtWi0woEIDXE8r/x1eBsoblwPHZcJ4aZ
         Gw+LQxJSz+wbl65/oWJMknomE7E/kCCi/wdFuRmnYgaxjPSSeOmzKL7GtDjsyKZ8eUNC
         mDhFiFRzJnrwyD/UtIdCnnbSyT5/lcAEgE087tiwj0/zGYy+GUABnEqX0PjflKCAoVql
         j3Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z4gWSSTArCAJUJvNz4VLl3E9Cl3syB0JCjUd2pmQuJQ=;
        fh=sU1oQ+qLB51gKQAsd/knfITBY+760Vlxkx87unBkQ6A=;
        b=OngcD93cN3tQYdSaHwAL/UND6n8DDx2w5wsVHHJF19w0qLzGUB9nqOVn0L/Uo7cBtO
         Yuxk3bolAcMKboha6syxNiOnHlILesA7h2ZavQrjW7Hu/SilkDaY8taXeD/t74fJcwDh
         SShr+B3Nwqe4VOcg5d1OYudAX9egXdQou6x1rXXp3Ka8NdccpSqj5NajUvbjPSWRkXL4
         99+52kZHbzmwVAeeEEIkDanFj6xfJHh1IwipmCZ5PP6ZxOIYTY85iiNQcgt6pndG5jEb
         twVFgsA/LhEScqPeLO7eNHYojxgrs6XvGzQGPvyXgApoPY5VRD45VUDHp+1diiYycbyr
         1cvA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785331308; x=1785936108; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z4gWSSTArCAJUJvNz4VLl3E9Cl3syB0JCjUd2pmQuJQ=;
        b=S10KCP+0Kz77S8kV+rB3T5T9Mr+N3P5giT4TFkVx+8odfN11xldz+ci1yXGs8EVmv3
         sJxxrZM05IdbIeKfz1PQlRZe4B0TXJKtsBZ5Em8Jp89YBN4sm7Teh2+wgKVnLsH1ehUa
         BEcawta4liJBDtqcQxLKcm/IEOpUmpuw88IePGRMfKyUHQayHmJnjTshwZ9zTJkz5K/E
         BwsDzmumyAgNIiNQ38DxtD8WiAIRfNLDzYZ5wb1rNkNr2efrK6INaDvP5aT2Mg/peayx
         ty4wL1wIkjrh7LhoXfQSrEnkVFZc9g5rdqrlSa0lDOeY5OyO5lGeMz/m/EhqMRshO5XQ
         Z+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785331308; x=1785936108;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z4gWSSTArCAJUJvNz4VLl3E9Cl3syB0JCjUd2pmQuJQ=;
        b=ODhiwUauBOPFk90BruJwHADcaWKB9/R4rvnD1psI4Ywk+zdrEuRKEuJbHd191UyEwl
         wMeAX+wNwDWEC0GS5gWfEnp1GCDobpJfeBuhhoN1N/Gf5lgmoeqBS2Jep72DVlZT3OUm
         HSJSJkKdv+yEqizOsHbGYOm64kJfSzHJMQ/qLLsvmW4LMAgU8VkfKfR8FiOhni5Xq9Hv
         6DlBzCD+3f6AjTWY4yptUQQ2fdMHS1fs971lMcj6fXfpMqW7VSgzvLRIy4ho7buMZvbC
         VVkWffdNIM48rO4M+rLaLHTdMEm2+1AQcgdKarWvjN/8EByCYxG9wDi2J61eIe4mUPD3
         3Rqw==
X-Forwarded-Encrypted: i=1; AHgh+Rr6pGqlF/YHoh9ufiMNGWq8TlXD47utBPi2STR7gJTjgjL5N6O3gWvU0051PLOynL/g3PfT4BU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz78MKioaXm1NVEPt+RXJNS8cCldELsau+YR1JR0t6QEi+2tvq9
	baV0Xbxs2VVKB2k4EolaqBMKFDaSLfe2pEa4x726Xxx0SEPnzPGOQ4dPKgFbZIVavcdo5UO/TYs
	4ps+PilVyAOqfoqtyBiUUa7vkEmJxpIUCUCC58w1V
X-Gm-Gg: AR+sD11SJpC3Kc73X/7KliDzGkplh23XafVd27TlRdr2iCdK593kNuaBk4MKFXeJR5a
	VOSlHpWDzswma5tSXbawYJ/JTlQP8+PWO1sDDQcXP0hG+4jjPWZ5TULApcNzgcJddFjCZPVqF7j
	2v+1Kq3KRc0eZ9gOQAtaCk1s77qoYgCjIswC0QGk8UIksUZrdG6RIO5rAfrGj1EvpB9QkOVRr2X
	0CnVziAk6eLwxsXTO9Xyd4vvz3/7GW/F+w6hH1MVt60O9PEzPePx2A2Ls1KrD334F3GQ9Uhm4pM
	pyxVpNu/14ZfbkeSWTtSNCbeNf3YgABQI8wnfHoWgCowlOymJbMQAibPQ3hxY6l4UnO5+4hgIb9
	H02YaOjCTAkGPHMR8xGzYsT+xkXV0wa3/1kqcxckuDnIGTCFpr67c1g9PNAyDNFUO2g74hFzE9k
	Isv9iXo3Vl6KgrBWfrHWxaqrI=
X-Received: by 2002:a05:6808:c1fb:b0:495:f8a5:8797 with SMTP id
 5614622812f47-4ad72c9f4f1mr949975b6e.0.1785331306185; Wed, 29 Jul 2026
 06:21:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a144cc7e-406a-4896-9299-9f425c722100@mail.kernel.org>
In-Reply-To: <a144cc7e-406a-4896-9299-9f425c722100@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 29 Jul 2026 15:21:35 +0200
X-Gm-Features: AUfX_mzXDYwm5lEnraBPE8NKL-xZw_alx-oL7gUHItMOG3NiPzugPrLJ4IO6fdg
Message-ID: <CANp29Y5FVs_k4fjVWxFNUcAkX-xvg3ZJR1eysYttfe1A-qReBQ@mail.gmail.com>
Subject: Re: [PATCH RFC] KVM: pfncache: Check gpc->active before sanity
 checking GPA and HVA
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Based off the discussion in
https://lore.kernel.org/all/20260309075629.24569-2-phind.uet@gmail.com/T/

Moving the `!gpc->active` check into `__kvm_gpc_refresh()` is too late
because `kvm_gpc_refresh()` calls `kvm_gpc_is_valid_len(gpc->gpa,
gpc->uhva, len)` *before* calling `__kvm_gpc_refresh()`.

On an inactive cache (`gpc->gpa =3D=3D INVALID_GPA` and `gpc->uhva =3D=3D
KVM_HVA_ERR_BAD`), `kvm_gpc_is_valid_len()` will still end up running
`offset_in_page(uhva)` on an invalid HVA.

`if (!gpc->active)` needs to be checked at the start of
`kvm_gpc_refresh()` right after acquiring `gpc->refresh_lock`, before
`kvm_gpc_is_valid_len()` is called.

On Wed, Jul 29, 2026 at 3:18=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When attempting to refresh a gfn_to_pfn_cache (gpc) that has never been
> activated, KVM triggers a sanity-check warning in __kvm_gpc_refresh(). Th=
is
> occurs because an inactive cache naturally has both its GPA and HVA
> initialized to error values, which violates the condition that exactly on=
e
> of them must be valid.
>
> This can be triggered via the KVM_XEN_HVM_EVTCHN_SEND ioctl. If the guest
> has not yet set up the shared info page, the shinfo_cache is inactive.
> Attempting to deliver the event returns -EWOULDBLOCK, prompting KVM to
> attempt a refresh of the cache, leading to the warning:
>
> ------------[ cut here ]------------
> kvm_is_error_gpa(gpa) =3D=3D kvm_is_error_hva(uhva)
> WARNING: arch/x86/kvm/../../../virt/kvm/pfncache.c:267 at
> __kvm_gpc_refresh+0x1510/0x1710 virt/kvm/pfncache.c:267
> ...
> Call Trace:
>  <TASK>
>  kvm_gpc_refresh+0xe1/0x110 virt/kvm/pfncache.c:382
>  kvm_xen_set_evtchn+0x14f/0x220 arch/x86/kvm/xen.c:1945
>  kvm_xen_hvm_evtchn_send+0x120/0x1e0 arch/x86/kvm/xen.c:2036
>  kvm_arch_vm_ioctl+0xfad/0x1a10 arch/x86/kvm/x86.c:7523
>  kvm_vm_ioctl+0x8f7/0xd30 virt/kvm/kvm_main.c:5381
> ...
>
> The warning can also be triggered via vcpu_info_cache if an event is sent
> while the cache is inactive, causing the vCPU to attempt a refresh when
> injecting pending events.
>
> Fix this by moving the check for an inactive cache to the very beginning =
of
> __kvm_gpc_refresh(), before the WARN_ON_ONCE and before acquiring the
> gpc->lock. It is completely safe to check gpc->active before acquiring
> gpc->lock because all modifications to gpc->active are fully serialized b=
y
> gpc->refresh_lock, which is already held and asserted at the start of the
> function. Bailing out early also avoids the overhead of unnecessarily
> acquiring and releasing the lock (which disables and re-enables interrupt=
s)
> for a cache that cannot be refreshed.
>
> Fixes: 721f5b0dda78 ("KVM: pfncache: allow a cache to be activated with a=
 fixed (userspace) HVA")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+cde12433b6c56f55d9ed@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dcde12433b6c56f55d9ed
> Link: https://syzkaller.appspot.com/ai_job?id=3D4e819403-979c-4f19-96ab-2=
8961c06eab0
> To: <kvm@vger.kernel.org>
> To: "Paolo Bonzini" <pbonzini@redhat.com>
> To: "Paul Durrant" <pdurrant@amazon.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 728d2c1b4..fcfd5555b 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -263,19 +263,17 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cach=
e *gpc, gpa_t gpa, unsigned l
>         void *old_khva;
>         int ret;
>
> +       lockdep_assert_held(&gpc->refresh_lock);
> +
> +       if (!gpc->active)
> +               return -EINVAL;
> +
>         /* Either gpa or uhva must be valid, but not both */
>         if (WARN_ON_ONCE(kvm_is_error_gpa(gpa) =3D=3D kvm_is_error_hva(uh=
va)))
>                 return -EINVAL;
>
> -       lockdep_assert_held(&gpc->refresh_lock);
> -
>         write_lock_irq(&gpc->lock);
>
> -       if (!gpc->active) {
> -               ret =3D -EINVAL;
> -               goto out_unlock;
> -       }
> -
>         old_pfn =3D gpc->pfn;
>         old_khva =3D (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
>         old_uhva =3D PAGE_ALIGN_DOWN(gpc->uhva);
>
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
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
-upstream-moderation/a144cc7e-406a-4896-9299-9f425c722100%40mail.kernel.org=
.
