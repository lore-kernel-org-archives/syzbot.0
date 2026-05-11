Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ACE285CB3
	for <syzbot@lists.linux.dev>; Mon, 11 May 2026 15:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778512901; cv=pass; b=osO8MQBrmo+nDfZUq1aNFEXo2lstBjTBBaVcHS9fE5japPEXcmjKRs04ZMbLGCBWkbbWoimyLrwAIhtArOrCe54b/XaE4GqkhaTN6YULZy6W42V7UK0RGdZ9pivtHo+GGHye6Yi49Ef4C5mAwaanWfIcjnyCYdPNG6ztbyjy4v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778512901; c=relaxed/simple;
	bh=NG+e+ZyEOsr76VpVHH+/jFeqmj3N/pCP6PNbsUa9MKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tBjy4v68iwdqPaI+I+pHGQudz4l02MQbNtMNWCiQnOZgtSvRg01xqFArqFn0YSOorey9uBHslUscwsjD6eurAGG8PbUoCr2iStPnr+h1QC+c04M2GNiIF1VReUv0sUS4rBDbevD+nbD0CmhvIEostAK4vY5ixAEzYe1N5V/6WF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T7q1SAtj; arc=pass smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T7q1SAtj"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e36bb16a92so1502856a34.2
        for <syzbot@lists.linux.dev>; Mon, 11 May 2026 08:21:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778512899; cv=none;
        d=google.com; s=arc-20240605;
        b=KE32jUhjVQn20VeMlFlJ6SOnpl0dCgOUE8fGaIo2/75zZwl4L5NAsQhdNa867Vu6xW
         zGEoV7G09Ctk89qV/jMXZFgiH/0voRTbS1GtnrAftJvCFMnm1UJgspIlhgI6nCr4bUGu
         tGFEeb6MyD4rMx+KL37otdH3L/C+KK+Rhb5FSq9MYVZ3LHuEoNAFpbBqTUOPr0MV0UH3
         u+LuZDpNk+mu7FEDTAaO6cJGs0n8OsFiLk+D3mpP6oJnzQ1tramY4hyKWFEAre0DBG44
         E0GxCbk1HiLMiPLWg4Ae/6IP/vCsy/Ipwu1T2D1FzkilBxgKbgxSxpqVRxjhcnN4blyz
         BKBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TviTUa0WVdoc+y6ud29YvqZf8nJGZK/b2BcnYbLttls=;
        fh=W+iA1RdwOdad8hByqz2UVy/25XZiqNS5wdZEfQp1zaQ=;
        b=ErowOJeM4+9G/2KB0T1uo1s11R4X6GP8BKASijhjowq678vL85QnmfM9Ua7A02hbXy
         u3E0+GrMn+GP8+7hU+dEyRApuOVePXaYwvHIlANZrRcPpDAc7sKhnInOO2KrLXDZVnjx
         y66P9qFZOWEWAGFMcGSY5jKDtbLJvrDex39Mu9AhKa9fpZ9a282vEeJ6BFIHfsSmL0kf
         UIf0cXLqRazz9ZjYmhH/f06mnmMIV9qquyrmAe+WtKqA/0QfIHYmKR/9DQyQK4aHM2X+
         /AZqQetpIjNhLYpGqpclQ/d+n01QOxbgedFBMKkBekqale7hws4BTiYAvGc1V5NMYNTc
         ovbA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778512899; x=1779117699; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TviTUa0WVdoc+y6ud29YvqZf8nJGZK/b2BcnYbLttls=;
        b=T7q1SAtjdz/Ce4cxlAr0cDRFPLNkR3WhBdthOtrg+zrDhjz6L/ac0F2OzNuIBQ1riO
         WBhKQ/E0/faJEefvmhsxyQpSXTfwLvehP56h+V+oMTN8ZrbNdUB47SoxEAHZ5QtI3mcX
         VTL3h4RnRdNJySyT78d+vco2EIkfSVVkXkme5XN41kBvIiTFre/mbgudIFZXvy2CnQ9d
         98d3Ktc6i966c/nzSKDicRtPqy26aopq9Ulez39Vj3N/gz0sCHYVwiYUGslURrv7CuXn
         QDCnXRBc2eB2WrfFGATSZA4OA/CCZ6LmAwMw7x/Dr793WLSCfu1NS8XMghxohjVSpzXR
         4XSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778512899; x=1779117699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TviTUa0WVdoc+y6ud29YvqZf8nJGZK/b2BcnYbLttls=;
        b=j0rporEf+hPdgWhjtEGglVTGLCl0FIi6591zlmGGF5r6wECEZdiC9NYFPS+I44uRB5
         7VJstgvdu63gA9zN1WR71sUSNUPmuuY9Szr5xwf64D0U+JcEha52aAFmf5T+17gajl6n
         3lNVUvATiLkahjCmtgu+QmbSfIN8Jn9I3lAAl3GNn7cYZhRrC9JWyy17crJBvZ/qY6Y9
         CGuF3toRt378HlO8t8Mdyxivk1IXDIkfy920Ks4IqkJdT0fzPDmkyE5s3JX0Q9CMOyN4
         4ghTCQLqgO1zQc0KG6V+ZffEyG77FRCxadPaVaV56aS2Mr1xWdZl81i231mQbS2bFjTs
         VvLA==
X-Forwarded-Encrypted: i=1; AFNElJ+5T/pIWLaufPVGcQbUmFRD9osuD276nGklIRAbNBQYRidpFlJnPf7ofx1QIHXbNWDB8LW3shg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3Dt6DvhB0D7hRPmbdRVXuG1b+uk490YZA7r9emYVEjByXNz5e
	VxNxhtBo4fOjEj2KKAw47WXApNaZXocsDI2AsJjMzAWEqmrupmsJ5oEuQiyLy/VRv8CcW3vjUnY
	kRTfCJHGCDZLktc+NZpe83vm1F5A/A9cA75EBwdKo
X-Gm-Gg: Acq92OEUznneM7g9w/GApu5Uj23o6I4rB0Yq7cqARmnk9dVZvhhocjL8UNhJcXEDIRO
	emt5diaDvULBpFQGBNrZZ2i+7Y0YXJ7D9eTxmj0HiMsPb5zkMGhdYczbW7tj9aXibURZY9gDBn+
	8cvizqegewbGUHiNnT1RXa/us60lyfr0UnFj6PiSwf2RJwswMXVTSoEwXV8ntcemz/JD9IAyll1
	KPTCecD7sf2gaxHf9InhQ9C+YR5+/x3+su7yubbH+nEpTOsTRImJps2fxsEXTJIKZIIUdVGGB3L
	obd6u2Ax8mq77Zeo0Ct6F3DotaK2+ExB3lbz3fRi0O1Ck0pqIvCyVcRkm7alVVMjE6woncqhQ/+
	w4O8=
X-Received: by 2002:a05:6820:80cb:b0:696:6c93:e82c with SMTP id
 006d021491bc7-69998d34577mr13122969eaf.49.1778512898637; Mon, 11 May 2026
 08:21:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <aec7cb16-64c4-4e01-a974-a6c1a51a046e@mail.kernel.org>
In-Reply-To: <aec7cb16-64c4-4e01-a974-a6c1a51a046e@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 11 May 2026 17:21:27 +0200
X-Gm-Features: AVHnY4LIaXHaks8DdANCuvwuM52tODsjHghknepcnF4Px27ZYonwjVtMDhbDwiQ
Message-ID: <CANp29Y5F-mJL8RKN1xSuoiTC-6pRpT-vfwp-8oDFGeLFKSXCUg@mail.gmail.com>
Subject: Re: [PATCH RFC] misc/vmw_vmci: fix recursive locking deadlock in
 queue pair broker
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please check if you can write a smaller diff. Are all these changes necessa=
ry?


On Sun, May 10, 2026 at 12:59=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> misc/vmw_vmci: fix recursive locking deadlock in queue pair broker
>
> A recursive locking deadlock can occur involving `qp_broker_list.mutex`
> in the VMCI queue pair broker.
>
> When a queue pair is detached, `vmci_qp_broker_detach()` acquires
> `qp_broker_list.mutex` and, if there are still other endpoints attached,
> it calls `qp_notify_peer()` to send a notification datagram to the peer
> context.
>
> The deadlock occurs because `qp_notify_peer()` indirectly calls
> `vmci_ctx_put()` on the peer's context, which can drop the reference
> count to 0 if the peer context is concurrently being destroyed. When the
> reference count reaches 0, `vmci_ctx_put()` synchronously calls
> `ctx_free_ctx()`. This cleanup function iterates over all queue pairs
> attached to the dying context and calls `vmci_qp_broker_detach()` for
> each of them, which attempts to acquire `qp_broker_list.mutex` again,
> resulting in a deadlock.
>
> This issue is not isolated to `vmci_qp_broker_detach()`. There are other
> places in `drivers/misc/vmw_vmci/vmci_queue_pair.c` where
> `qp_notify_peer()` or `vmci_ctx_put()` are called while holding
> `qp_broker_list.mutex`, such as `qp_broker_attach()` and
> `vmci_qp_broker_set_page_store()`.
>
> To fix this, defer the calls to `qp_notify_peer()` and `vmci_ctx_put()`
> until after `qp_broker_list.mutex` is safely released. This ensures that
> the mutex is never held when these functions are executed, completely
> eliminating the recursive locking deadlock while preserving the correct
> logic and behavior of the VMCI queue pair broker.
>
> Assisted-by: Gemini:gemini-3.1-pro-preview
> To: <arnd@arndb.de>
> To: <bryan-bt.tan@broadcom.com>
> To: <gregkh@linuxfoundation.org>
> To: <linux-kernel@vger.kernel.org>
> To: <vishnu.dasa@broadcom.com>
> Cc: <bcm-kernel-feedback-list@broadcom.com>
>
> ---
> diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_v=
mci/vmci_queue_pair.c
> index b777bc3fd..3d61d5bf2 100644
> --- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
> +++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
> @@ -1508,17 +1508,13 @@ static int qp_notify_peer(bool attach,
>   * VMCIQPB_ATTACHED_MEM state, and for older VMX callers, it will be
>   * moved to the VMCOQPB_ATTACHED_NO_MEM state.
>   */
> -static int qp_broker_attach(struct qp_broker_entry *entry,
> -                           u32 peer,
> -                           u32 flags,
> -                           u32 priv_flags,
> -                           u64 produce_size,
> -                           u64 consume_size,
> +static int qp_broker_attach(struct qp_broker_entry *entry, u32 peer, u32=
 flags,
> +                           u32 priv_flags, u64 produce_size, u64 consume=
_size,
>                             struct vmci_qp_page_store *page_store,
>                             struct vmci_ctx *context,
> -                           vmci_event_release_cb wakeup_cb,
> -                           void *client_data,
> -                           struct qp_broker_entry **ent)
> +                           vmci_event_release_cb wakeup_cb, void *client=
_data,
> +                           struct qp_broker_entry **ent, bool *do_notify=
,
> +                           u32 *notify_peer_id, struct vmci_ctx **out_ct=
x)
>  {
>         const u32 context_id =3D vmci_ctx_get_id(context);
>         bool is_local =3D flags & VMCI_QPFLAG_LOCAL;
> @@ -1585,7 +1581,7 @@ static int qp_broker_attach(struct qp_broker_entry =
*entry,
>
>                 create_context =3D vmci_ctx_get(entry->create_id);
>                 supports_host_qp =3D vmci_ctx_supports_host_qp(create_con=
text);
> -               vmci_ctx_put(create_context);
> +               *out_ctx =3D create_context;
>
>                 if (!supports_host_qp)
>                         return VMCI_ERROR_INVALID_RESOURCE;
> @@ -1660,13 +1656,8 @@ static int qp_broker_attach(struct qp_broker_entry=
 *entry,
>         }
>
>         if (entry->state =3D=3D VMCIQPB_ATTACHED_MEM) {
> -               result =3D
> -                   qp_notify_peer(true, entry->qp.handle, context_id,
> -                                  entry->create_id);
> -               if (result < VMCI_SUCCESS)
> -                       pr_warn("Failed to notify peer (ID=3D0x%x) of att=
ach to queue pair (handle=3D0x%x:0x%x)\n",
> -                               entry->create_id, entry->qp.handle.contex=
t,
> -                               entry->qp.handle.resource);
> +               *do_notify =3D true;
> +               *notify_peer_id =3D entry->create_id;
>         }
>
>         entry->attach_id =3D context_id;
> @@ -1711,6 +1702,9 @@ static int qp_broker_alloc(struct vmci_handle handl=
e,
>         struct qp_broker_entry *entry =3D NULL;
>         bool is_local =3D flags & VMCI_QPFLAG_LOCAL;
>         int result;
> +       bool do_notify =3D false;
> +       u32 notify_peer_id =3D VMCI_INVALID_ID;
> +       struct vmci_ctx *out_ctx =3D NULL;
>
>         if (vmci_handle_is_invalid(handle) ||
>             (flags & ~VMCI_QP_ALL_FLAGS) || is_local ||
> @@ -1748,14 +1742,29 @@ static int qp_broker_alloc(struct vmci_handle han=
dle,
>                                      context, wakeup_cb, client_data, ent=
);
>         } else {
>                 create =3D false;
> -               result =3D
> -                   qp_broker_attach(entry, peer, flags, priv_flags,
> -                                    produce_size, consume_size, page_sto=
re,
> -                                    context, wakeup_cb, client_data, ent=
);
> +               result =3D qp_broker_attach(entry, peer, flags, priv_flag=
s,
> +                                         produce_size, consume_size,
> +                                         page_store, context, wakeup_cb,
> +                                         client_data, ent, &do_notify,
> +                                         &notify_peer_id, &out_ctx);
>         }
>
>         mutex_unlock(&qp_broker_list.mutex);
>
> +       if (out_ctx)
> +               vmci_ctx_put(out_ctx);
> +
> +       if (do_notify) {
> +               int notify_result;
> +
> +               notify_result =3D qp_notify_peer(true, handle, context_id=
,
> +                                              notify_peer_id);
> +               if (notify_result < VMCI_SUCCESS)
> +                       pr_warn("Failed to notify peer (ID=3D0x%x) of att=
ach to queue pair (handle=3D0x%x:0x%x)\n",
> +                               notify_peer_id, handle.context,
> +                               handle.resource);
> +       }
> +
>         if (swap)
>                 *swap =3D (context_id =3D=3D VMCI_HOST_CONTEXT_ID) &&
>                     !(create && is_local);
> @@ -1968,6 +1977,8 @@ int vmci_qp_broker_set_page_store(struct vmci_handl=
e handle,
>         struct qp_broker_entry *entry;
>         int result;
>         const u32 context_id =3D vmci_ctx_get_id(context);
> +       bool do_notify =3D false;
> +       u32 notify_peer_id;
>
>         if (vmci_handle_is_invalid(handle) || !context ||
>             context_id =3D=3D VMCI_INVALID_ID)
> @@ -2035,18 +2046,26 @@ int vmci_qp_broker_set_page_store(struct vmci_han=
dle handle,
>         entry->vmci_page_files =3D true;
>
>         if (entry->state =3D=3D VMCIQPB_ATTACHED_MEM) {
> -               result =3D
> -                   qp_notify_peer(true, handle, context_id, entry->creat=
e_id);
> -               if (result < VMCI_SUCCESS) {
> -                       pr_warn("Failed to notify peer (ID=3D0x%x) of att=
ach to queue pair (handle=3D0x%x:0x%x)\n",
> -                               entry->create_id, entry->qp.handle.contex=
t,
> -                               entry->qp.handle.resource);
> -               }
> +               do_notify =3D true;
> +               notify_peer_id =3D entry->create_id;
>         }
>
>         result =3D VMCI_SUCCESS;
>   out:
>         mutex_unlock(&qp_broker_list.mutex);
> +
> +       if (do_notify) {
> +               int notify_result;
> +
> +               notify_result =3D qp_notify_peer(true, handle, context_id=
,
> +                                              notify_peer_id);
> +               if (notify_result < VMCI_SUCCESS) {
> +                       pr_warn("Failed to notify peer (ID=3D0x%x) of att=
ach to queue pair (handle=3D0x%x:0x%x)\n",
> +                               notify_peer_id, handle.context,
> +                               handle.resource);
> +               }
> +       }
> +
>         return result;
>  }
>
> @@ -2086,6 +2105,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle=
, struct vmci_ctx *context)
>         u32 peer_id;
>         bool is_local =3D false;
>         int result;
> +       bool do_notify =3D false;
>
>         if (vmci_handle_is_invalid(handle) || !context ||
>             context_id =3D=3D VMCI_INVALID_ID) {
> @@ -2185,7 +2205,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle=
, struct vmci_ctx *context)
>
>                 vmci_ctx_qp_destroy(context, handle);
>         } else {
> -               qp_notify_peer(false, handle, context_id, peer_id);
> +               do_notify =3D true;
>                 if (context_id =3D=3D VMCI_HOST_CONTEXT_ID &&
>                     QPBROKERSTATE_HAS_MEM(entry)) {
>                         entry->state =3D VMCIQPB_SHUTDOWN_MEM;
> @@ -2200,6 +2220,10 @@ int vmci_qp_broker_detach(struct vmci_handle handl=
e, struct vmci_ctx *context)
>         result =3D VMCI_SUCCESS;
>   out:
>         mutex_unlock(&qp_broker_list.mutex);
> +
> +       if (do_notify)
> +               qp_notify_peer(false, handle, context_id, peer_id);
> +
>         return result;
>  }
>
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
-upstream-moderation/aec7cb16-64c4-4e01-a974-a6c1a51a046e%40mail.kernel.org=
.
