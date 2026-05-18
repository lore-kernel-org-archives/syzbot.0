Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D39389452
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 08:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779091389; cv=pass; b=HLn7e8JWPWogxw+QNwJOsfbPujgqiWH5g/gtQkfP/0FOI7QSqQxlhuP/moBeJRzyHQnZIG1JF1eVcj4Yl5rRSMzqAUE0looFXwTM2lo3eSTt0n6oZeYjPeZQG0CSEklTY996+tXvGlgYdCqCLpZivpg8nisEK2Mr6FiZ+yRtBjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779091389; c=relaxed/simple;
	bh=zupsQxlEuq2kHcAndCgjlR0Ng3X78fctD1SRhG2QPAc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=da5049fYeBqrBpADY2FSV8jtJxPks/j22X2s6i3JMpiFMe8tAm73q0Kj6K5NxvWesNNaGPhpSF7foFYLHk+5gusLr/t3YcDbqtmlwxOGeUrFXOHSZ9+6Qhzwg+dJNlVpqzPoMiIdsmXPvFJgyG9Pig8KCwxSBCmi5fQY6sHwVpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LM6Mx+Jm; arc=pass smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LM6Mx+Jm"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-134fe980658so2311233c88.1
        for <syzbot@lists.linux.dev>; Mon, 18 May 2026 01:03:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779091387; cv=none;
        d=google.com; s=arc-20240605;
        b=ROeJDoP9gwWAYLNqmiQvNIVjvc7OUJcDMyPW4MwoZ/LICkuzhLosnM/CMVLIo5ihBZ
         NfLX8/9lXToDkHB1UVKUj8n313v8msB2ZwQgjZg7IKtiSxSmOhP8lGzDUGlWFAX+/ELb
         0wlPZDep28cEcQ/wlBQIwNZAs8ZGtabchyV8wHQIA+sG3Excy23yYigCb8xJfaSnMSZu
         cQh09SRNmgYSWVb465gqXxMsfsEK70lTLvFLoJu6T+k/kiXSday8a/ZtgfVRephDyeuf
         78ea9zVw4sQSLwwKhBX+n7LpDxlWAGmo06EH2D+CE38CA9OtxxGjqvIGSc52s2CKdrZW
         TfnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Hj/Jx6zJiPPAL/bf+P5Lwt5Q3VFM/uzFF+8OCel4gEs=;
        fh=IF66P5th3gqszDZMnGAikqPZkbSYqvgNxWHy3k8X00o=;
        b=YlDqaNSLwJ0e0XxKwGbKyJ5X8Zl+eAgayxVO57HGUYrfI5HAtmP95SxoAdpqiesttH
         HItUmbXLWBBu1NA6uQ/zO8bJty2/ywGbOHCe9HYnyCQjwWp6ZPkWInyDguCiYvAfL3UL
         WbJIi823d7Y4cB6zGsxoDmnvo9gnYWw8ETw/m3xLraWj3eHxIpV1xZKfMk5jF6Xugb2F
         ti5ucq69iYCWrZW8Rli+e/javOPGlJVVPKh/KBU5QSM1wQmKohmllONnLjWL9DyvgmEJ
         C78swK6kv1v1ARQP++pvUbBqo8MmB/EB822bFXVXU7Kn4utYk6LmLRw6xcVCJ4kqMa2m
         XEBg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779091387; x=1779696187; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hj/Jx6zJiPPAL/bf+P5Lwt5Q3VFM/uzFF+8OCel4gEs=;
        b=LM6Mx+JmiiIfNTZ9Vl14Vfca/VLnDTCxkKVpU71bqOC2KiW+Tc9RhFFPw8HZYfyxFl
         ELeuii1A6NRpOa4LsjObaUjYEiUjWlwsur8DW5Vq9Rn1KnWfVSw8hlL5KoDNjLRaNEIN
         ygey8biZcRVtR7FBOR7JluttmgHC5fClpqbqnZoTvPHHaNkQdGT75djEYhaS/TYxHBm2
         p9WEQJi87CGUKd98dhHa6HvMt7yKeJmKkTIU+Q9WVcTDjepqqNkV9puBVzOCiPI+9VmU
         o6YzjlQcdTWytTeh+ns7enWPlyxTjxkCRyeT24mZk4bRbJTvJMFT+rxD4GhqCGM6fhcH
         qfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779091387; x=1779696187;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hj/Jx6zJiPPAL/bf+P5Lwt5Q3VFM/uzFF+8OCel4gEs=;
        b=VBfqHbSvKIYEBDF8BCCZwDpPvZWj14BSnPI8weofnzI42u7MJMfbIxkMBVogh+4J0U
         /3CVb7QNHs8sWuZUc9MSYpz+e5J+/bdK/l0y2SmVFY63m+l3HTSBrq+N1IDS+EkkOA7l
         U/4398dJSQ9wgQOua349CIOB6wn58lpPOJ5N0jnX6MMpzGf+5ZpbC96bbpatAk4PLKWN
         VCpodaMo0OvgMpPWooTriX8MtnB9EdHQZPd0S6y8lhSlJn3Lq7x1mLO4KW40CbtNdbwW
         GV3I2r6ztgZBY2xTloRu8uHkFEZo+SvZeCPczfBwVnry9+SmA5xOfV+6ljVY5RLw2NTX
         9nWg==
X-Forwarded-Encrypted: i=1; AFNElJ+7m40czHRpsC3G+BJl10c/xoKy9I8fz+47roNRpe368xw8avcE+F6uztZwtbPfwroprwWxNcU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXHlbrRpAIgW+e4m+NFkMa+qmQcBIxwGqzC1H4ThYkRNBiu20D
	sBGV+UYHmkKuimsNvqdCBEcY6fL2L/mpb81t9P5Jiw9IAHNhvPlj2Kf4g8D6KSgpjFpq73aWFYo
	jN8cx/o4fpXkfOQspyFlUy/fQ+4G+dBB0IU/V86iF
X-Gm-Gg: Acq92OGjB4XxvoxCyssCj82lL4WRALrqwwHbd+DQ+zCIujmj78jvd18cVuYQrcXEw+I
	n3MRdwMckdGOh8T2aysnjgUl2x/+NFWc7DKGAZjM5vP5qNXTTtkO37fqO9Jk1EVH+/5vWqvOPl+
	4J/zLBUaq03Cpc5wA/cF8T7LmtpIa5s2heqCqWLt+vi7QWVimQu4N/BkO2lfPGs13rlxUq/+fNh
	tH7R4eEJuKppEDODj2aUK0NCVsYz4Guhfsdp78nqP6J9PoWWSnEEPCMJPN8KAL/OK4GilmZjw9F
	CR0Lw7bN2smppGI8rdw7kcIWY9QK+VMFop9eElN76MqSqrTYgw==
X-Received: by 2002:a05:7022:611:b0:12d:de3e:86b7 with SMTP id
 a92af1059eb24-1350592e133mr5543616c88.39.1779091386210; Mon, 18 May 2026
 01:03:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <5749a52e-a4b2-4c05-8877-ba1aa2b5f5d0@mail.kernel.org> <CACT4Y+YFGsWkURhF2TFm18tczpd4FwwB9Lm1B2E6Ohpkf3dXBQ@mail.gmail.com>
In-Reply-To: <CACT4Y+YFGsWkURhF2TFm18tczpd4FwwB9Lm1B2E6Ohpkf3dXBQ@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Mon, 18 May 2026 10:02:29 +0200
X-Gm-Features: AVHnY4Kx-BlYkDhyrkrijtyMviEY_EUFj3gVOMbXfAA6-q4s0A243Y9t2unIE2M
Message-ID: <CANpmjNPSxEtPaXM9e473LsaYGmpAe=ufyDmiTMah_O7mdqXJNg@mail.gmail.com>
Subject: Re: [PATCH RFC v2] misc/vmw_vmci: fix recursive locking deadlock in
 queue pair broker
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sun, 17 May 2026 at 09:46, Dmitry Vyukov <dvyukov@google.com> wrote:
>
> v2 looks more intrusive than v1, and harder to verify
> v1 looked reasonable to me
>
> +Marco, is this something where locking annotations can help (to fix,
> and prevent regressions)?
> Namely, I think we want to prohibit calling vmci_ctx_put and
> qp_notify_peer under qp_broker_list.mutex.

Yes, both functions can be annotated with
__must_not_hold(&qp_broker_list.mutex).

And context analysis must be enabled for the TU:

CONTEXT_ANALYSIS_vmci_queue_pair.o := y

... in the Makefile adjacent to this source file.

However, the CI system / patch-generator needs to use clang 22+ (soon
likely clang 23+).

> On Tue, 12 May 2026 at 12:34, 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
> >
> > misc/vmw_vmci: fix recursive locking deadlock in queue pair broker
> >
> > A recursive locking deadlock can occur involving `qp_broker_list.mutex`
> > in the VMCI queue pair broker.
> >
> > When a queue pair is detached, `vmci_qp_broker_detach()` acquires
> > `qp_broker_list.mutex` and, if there are still other endpoints attached,
> > it calls `qp_notify_peer()` to send a notification datagram to the peer
> > context.
> >
> > The deadlock occurs because `qp_notify_peer()` indirectly calls
> > `vmci_ctx_put()` on the peer's context, which can drop the reference
> > count to 0 if the peer context is concurrently being destroyed. When the
> > reference count reaches 0, `vmci_ctx_put()` synchronously calls
> > `ctx_free_ctx()`. This cleanup function iterates over all queue pairs
> > attached to the dying context and calls `vmci_qp_broker_detach()` for
> > each of them, which attempts to acquire `qp_broker_list.mutex` again,
> > resulting in a deadlock.
> >
> > This issue is not isolated to `vmci_qp_broker_detach()`. There are other
> > places in `drivers/misc/vmw_vmci/vmci_queue_pair.c` where
> > `qp_notify_peer()` or `vmci_ctx_put()` are called while holding
> > `qp_broker_list.mutex`, such as `qp_broker_attach()` and
> > `vmci_qp_broker_set_page_store()`.
> >
> > To fix this, defer the calls to `qp_notify_peer()` and `vmci_ctx_put()`
> > until after `qp_broker_list.mutex` is safely released. This ensures that
> > the mutex is never held when these functions are executed, completely
> > eliminating the recursive locking deadlock while preserving the correct
> > logic and behavior of the VMCI queue pair broker.
> >
> > Fixes: 06164d2b72aa752ce4633184b3e0d97601017135 ("VMCI: queue pairs implementation.")
> > Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> > Reported-by: syzbot+44e40ac2cfe68e8ce207@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?extid=44e40ac2cfe68e8ce207
> > Link: https://syzkaller.appspot.com/ai_job?id=e9b15cfb-e71a-4f95-a66b-628f0a2deaac
> > To: <arnd@arndb.de>
> > To: <bryan-bt.tan@broadcom.com>
> > To: <gregkh@linuxfoundation.org>
> > To: <linux-kernel@vger.kernel.org>
> > To: <vishnu.dasa@broadcom.com>
> > Cc: <bcm-kernel-feedback-list@broadcom.com>
> >
> > ---
> > v2:
> > - Moved the host queue pair support check and `vmci_ctx_put()` call from `qp_broker_attach()` to `qp_broker_alloc()`.
> > - Avoided modifying the signature of `qp_broker_attach()` to return notification parameters, handling them in the caller instead.
> > - Reduced the overall diff size as requested by reviewers.
> >
> > v1:
> > https://lore.kernel.org/all/aec7cb16-64c4-4e01-a974-a6c1a51a046e@mail.kernel.org/T/
> > ---
> > diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
> > index b777bc3fd..7552a5ae4 100644
> > --- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
> > +++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
> > @@ -1044,7 +1044,7 @@ static int qp_detatch_guest_work(struct vmci_handle handle)
> >                          * because we can't allocate.  We still want
> >                          * to release the entry if that happens, so
> >                          * don't bail out yet.
> > -                        */
> > +                */
> >                 }
> >         } else {
> >                 result = qp_detatch_hypercall(handle);
> > @@ -1575,20 +1575,11 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
> >                         return VMCI_ERROR_INVALID_RESOURCE;
> >
> >         } else if (context_id == VMCI_HOST_CONTEXT_ID) {
> > -               struct vmci_ctx *create_context;
> > -               bool supports_host_qp;
> > -
> >                 /*
> >                  * Do not attach a host to a user created queue pair if that
> >                  * user doesn't support host queue pair end points.
> > +                * This check is performed in the caller.
> >                  */
> > -
> > -               create_context = vmci_ctx_get(entry->create_id);
> > -               supports_host_qp = vmci_ctx_supports_host_qp(create_context);
> > -               vmci_ctx_put(create_context);
> > -
> > -               if (!supports_host_qp)
> > -                       return VMCI_ERROR_INVALID_RESOURCE;
> >         }
> >
> >         if ((entry->qp.flags & ~VMCI_QP_ASYMM) != (flags & ~VMCI_QP_ASYMM_PEER))
> > @@ -1659,15 +1650,6 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
> >                 entry->state = VMCIQPB_ATTACHED_MEM;
> >         }
> >
> > -       if (entry->state == VMCIQPB_ATTACHED_MEM) {
> > -               result =
> > -                   qp_notify_peer(true, entry->qp.handle, context_id,
> > -                                  entry->create_id);
> > -               if (result < VMCI_SUCCESS)
> > -                       pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
> > -                               entry->create_id, entry->qp.handle.context,
> > -                               entry->qp.handle.resource);
> > -       }
> >
> >         entry->attach_id = context_id;
> >         entry->qp.ref_count++;
> > @@ -1711,6 +1693,9 @@ static int qp_broker_alloc(struct vmci_handle handle,
> >         struct qp_broker_entry *entry = NULL;
> >         bool is_local = flags & VMCI_QPFLAG_LOCAL;
> >         int result;
> > +       bool do_notify = false;
> > +       u32 notify_peer_id = VMCI_INVALID_ID;
> > +       struct vmci_ctx *out_ctx = NULL;
> >
> >         if (vmci_handle_is_invalid(handle) ||
> >             (flags & ~VMCI_QP_ALL_FLAGS) || is_local ||
> > @@ -1748,14 +1733,44 @@ static int qp_broker_alloc(struct vmci_handle handle,
> >                                      context, wakeup_cb, client_data, ent);
> >         } else {
> >                 create = false;
> > +
> > +               if (context_id == VMCI_HOST_CONTEXT_ID) {
> > +                       out_ctx = vmci_ctx_get(entry->create_id);
> > +                       if (!vmci_ctx_supports_host_qp(out_ctx)) {
> > +                               result = VMCI_ERROR_INVALID_RESOURCE;
> > +                               goto out;
> > +                       }
> > +               }
> > +
> >                 result =
> >                     qp_broker_attach(entry, peer, flags, priv_flags,
> >                                      produce_size, consume_size, page_store,
> >                                      context, wakeup_cb, client_data, ent);
> > +
> > +               if (result == VMCI_SUCCESS &&
> > +                   entry->state == VMCIQPB_ATTACHED_MEM) {
> > +                       do_notify = true;
> > +                       notify_peer_id = entry->create_id;
> > +               }
> >         }
> >
> > +out:
> >         mutex_unlock(&qp_broker_list.mutex);
> >
> > +       if (out_ctx)
> > +               vmci_ctx_put(out_ctx);
> > +
> > +       if (do_notify) {
> > +               int notify_result;
> > +
> > +               notify_result = qp_notify_peer(true, handle, context_id,
> > +                                              notify_peer_id);
> > +               if (notify_result < VMCI_SUCCESS)
> > +                       pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
> > +                               notify_peer_id, handle.context,
> > +                               handle.resource);
> > +       }
> > +
> >         if (swap)
> >                 *swap = (context_id == VMCI_HOST_CONTEXT_ID) &&
> >                     !(create && is_local);
> > @@ -1968,6 +1983,8 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
> >         struct qp_broker_entry *entry;
> >         int result;
> >         const u32 context_id = vmci_ctx_get_id(context);
> > +       bool do_notify = false;
> > +       u32 notify_peer_id;
> >
> >         if (vmci_handle_is_invalid(handle) || !context ||
> >             context_id == VMCI_INVALID_ID)
> > @@ -2035,18 +2052,26 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
> >         entry->vmci_page_files = true;
> >
> >         if (entry->state == VMCIQPB_ATTACHED_MEM) {
> > -               result =
> > -                   qp_notify_peer(true, handle, context_id, entry->create_id);
> > -               if (result < VMCI_SUCCESS) {
> > -                       pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
> > -                               entry->create_id, entry->qp.handle.context,
> > -                               entry->qp.handle.resource);
> > -               }
> > +               do_notify = true;
> > +               notify_peer_id = entry->create_id;
> >         }
> >
> >         result = VMCI_SUCCESS;
> >   out:
> >         mutex_unlock(&qp_broker_list.mutex);
> > +
> > +       if (do_notify) {
> > +               int notify_result;
> > +
> > +               notify_result = qp_notify_peer(true, handle, context_id,
> > +                                              notify_peer_id);
> > +               if (notify_result < VMCI_SUCCESS) {
> > +                       pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
> > +                               notify_peer_id, handle.context,
> > +                               handle.resource);
> > +               }
> > +       }
> > +
> >         return result;
> >  }
> >
> > @@ -2086,6 +2111,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
> >         u32 peer_id;
> >         bool is_local = false;
> >         int result;
> > +       bool do_notify = false;
> >
> >         if (vmci_handle_is_invalid(handle) || !context ||
> >             context_id == VMCI_INVALID_ID) {
> > @@ -2185,7 +2211,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
> >
> >                 vmci_ctx_qp_destroy(context, handle);
> >         } else {
> > -               qp_notify_peer(false, handle, context_id, peer_id);
> > +               do_notify = true;
> >                 if (context_id == VMCI_HOST_CONTEXT_ID &&
> >                     QPBROKERSTATE_HAS_MEM(entry)) {
> >                         entry->state = VMCIQPB_SHUTDOWN_MEM;
> > @@ -2200,6 +2226,10 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
> >         result = VMCI_SUCCESS;
> >   out:
> >         mutex_unlock(&qp_broker_list.mutex);
> > +
> > +       if (do_notify)
> > +               qp_notify_peer(false, handle, context_id, peer_id);
> > +
> >         return result;
> >  }
> >
> >
> >
> > base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> > --
> > This is an AI-generated patch subject to moderation.
> > Reply with '#syz upstream' to send it to the mailing list.
> > Reply with '#syz reject' to reject it.
> >
> > See  for more information.
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/5749a52e-a4b2-4c05-8877-ba1aa2b5f5d0%40mail.kernel.org.
