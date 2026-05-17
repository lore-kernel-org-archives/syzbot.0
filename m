Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F7A2E414
	for <syzbot@lists.linux.dev>; Sun, 17 May 2026 07:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779003999; cv=pass; b=Do7V+j1ltpG0SjzB0hFt/VXXteYkrKtaIvptkwJWJI+3ViNLVYj/7OZfK3a9zDwki7RRNMQtfYIKHTw1aaxvNhK4MfB+VZh7ghNxLnMvyPMDWEfCsLSliIbYMU7P/85oQSWkFvmKHXt4oxW4vNOFmPEzi5CcJUnuP9swBStvx5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779003999; c=relaxed/simple;
	bh=u1NJdykKP6A/sH5vUy0iYTGvvxQ1deHxwdO9OM8GyN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H6LGzPV3CLZfqc5jbHXUtNymZ553ZB67HbUo/R/LqKYWUE55nSErRnntD3g6L1T3qNcTw8AoxLs9pi5J2h6D70AdFJi5+fysmndpnYGq7wahOoJzQLL6zPaMtY3iVODq0+JCG0f+qK5auxxka/zQ7tQZlYXzpqXRHuP+c2v1jDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n7mEX3hm; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n7mEX3hm"
Received: by smtp.kernel.org (Postfix)
	id D87CDC2BCC9; Sun, 17 May 2026 07:46:38 +0000 (UTC)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A452EC2BCB0
	for <syzbot@kernel.org>; Sun, 17 May 2026 07:46:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org A452EC2BCB0
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-38e97e73234so12915111fa.1
        for <syzbot@kernel.org>; Sun, 17 May 2026 00:46:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779003996; cv=none;
        d=google.com; s=arc-20240605;
        b=B8adQSU2ULa1Izd4YUbVovdq/hDahDSW+IwW6peUtugUko9p1kD5hNcLKFT9n7uFjm
         bPaShSXkV2jLo+TRcRFc2stTuSMrqgndDs/I1K6ahjamLFMmQ0sb0NBNxB7jM7EWJiLr
         k8/nt5PtdW6H7yUV9WkFUN4AmFH6Mzp24yKbOT/qY99e3q4V0P04yNvG0DMD09mUdOsi
         JBVxUsSPRgfN2WiFvbkO5oQgDFLP4a25RLDPV8d9wcwnKg/O/aASpDiO3HAqEMBaHKo9
         hwJVVdSx3mptLSoIXwZFfyQArEnywXPrnyBobBWjkVV5I3TlH2OTnhZZnCycZr4CmqsD
         +qjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WaYGeC4jn0bROq7PZJOG5dcY8eHe1ktn6lhXMCVQd2g=;
        fh=ulYMUyto5EEEwioyX4rOBMT44NsqyqsSIymNM6bWr3E=;
        b=g2MUqkwRUaZY0Jo23BPA2zdj50imRw9eE+9Rkp+4WED0mFdxGFWboA/5vmOD7xHNVF
         1Ty5i2uc7xvynA+KMQHfUMQwonYRKCSkqFQwxJLu9AgRRS/6Za1a6xnco+GxQ5E/JJ84
         5DYCn/msEBU6gVOJtgM5YKUQDbqP8rr3/QH1lgwDmbcB375BJAzGNfmkDuTFLVZIosh0
         WkxQc2hcwh5SEH2phG2W5iyBYfkwW7madCe+aqUBAGHTZ2zA87HeIRg8tcwu0QxC99DQ
         DSQJFdErXCwwcO6oka6pyHyCl/i3q8gkLwpnbnxCcpns66Cbr+c8+NqeS0/qp2SwktqA
         oFOw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779003996; x=1779608796; darn=kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WaYGeC4jn0bROq7PZJOG5dcY8eHe1ktn6lhXMCVQd2g=;
        b=n7mEX3hmKFr+fwWDRsYN/B9KrHBkLUhw9o3uTy2R9FELiaPRrbm1mlLCS7OdYUWo2U
         rrwNOQS4sIFxVSrS7Nm4R3SSM656A4KK0QGrUyFcXkPaz85uoPfjzPsLfVXGkcpt1ccB
         zkkTxH6/y1r6JbrETD2R/Ffk6WjXWr9o2gIou5/dKybHcgDfp4Xrr08ypl0Al5bEVIGr
         4XyYAiKgD5ZEdcAculjiwXb38U4dP/YkVNKJLh3yLy3vUtB6F1WACVdr/9Eh2JzMB3ab
         MWtff7J/w62URSSsRP7Sdy5S2QZrI+ubLC/DAIEmOrYsKmS+7EwIHhgWvs3X4wp71B7z
         /4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779003996; x=1779608796;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WaYGeC4jn0bROq7PZJOG5dcY8eHe1ktn6lhXMCVQd2g=;
        b=LrJN6KJ6XfQEP3De74EWCJksQeyIk+EZVcYLzkpNQMPd/GqsvO95F9yZ5sxdf93+sc
         VvqiNUhw75lvPegCuOxJ/MaCwX6CJuwitp6oJ64x6LipuNTtOj3NUWgyBmxp8OJLOulM
         3Gsp/06QSUm8fFLzJcdylxqEGM0G74xTMTmAP30LeKbbuQxuaD03RS1ZAngHFlZKYm/2
         BuIxigT/OXL+8Mp8KeBgXATd7hhyqNMKT+f94mg+8sSyRCLdpavGRprEk5xMJgOBTbNy
         F2KI5XpRvjuMzAT3mEOmLqC5XmwUgZ0wQBcm64YeI/7SavG4zV2YDPO6AAJaaIHdsEMm
         oxEw==
X-Gm-Message-State: AOJu0YxZNRByitJju6z+X/7TUAYesFAV+C9fOPV9AMkoXfxzKJlpd2Ez
	0XlwQKLAvlffP/NoQRY7T6IESr3pu/Zklc7WdackNGmjccCmbtlf74mP+S7IGbo37Ai0daPQBQS
	EhlAMqZegMf8zpS7jyen87KdidFpKTgPa0Gh4DJcTa++2cyHbx3QCKaWfxI0=
X-Gm-Gg: Acq92OGFLCOwSIxJT3JcT96e8vM4Ux/k+tZW4x7n/ZTYdgY58oUkhwBNH4z4ESk8jr5
	CyeOP2K60CMp8VMpbiXnXLPnQUUjumI9/VKv3p6BwBvm2pWli7LQDFhWNGvS2xcuPxMIe8kmjCP
	8/AUjaDv+k6S557MyhSh5RlFmo3DL4JfXzwmsAwXHG1GXmXA+nzttFYSZlzEz+v6ko9ZcXMMNNp
	etAUcCjrXPtwoFevKPb55uWh7JlOZT3t1UjpFI+G0YXAhKd0h9wjwr/azjCosunEzaElujMvRie
	C1kF/xoJBvDAmZMjf9v0JkqAXVUNUyLgi2RJ2rESLiuKOFJAEI+NeMQfwSVX
X-Received: by 2002:a05:651c:1503:b0:38c:6b7:ad39 with SMTP id
 38308e7fff4ca-39561a2b235mr28966281fa.13.1779003995229; Sun, 17 May 2026
 00:46:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <5749a52e-a4b2-4c05-8877-ba1aa2b5f5d0@mail.kernel.org>
In-Reply-To: <5749a52e-a4b2-4c05-8877-ba1aa2b5f5d0@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sun, 17 May 2026 09:46:24 +0200
X-Gm-Features: AVHnY4ICHzs2jNSzKMUWoqcdKfTKW38uaud0mHt6Rx2L02mZjx1aIDMOYy3Lzkw
Message-ID: <CACT4Y+YFGsWkURhF2TFm18tczpd4FwwB9Lm1B2E6Ohpkf3dXBQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] misc/vmw_vmci: fix recursive locking deadlock in
 queue pair broker
To: syzbot <syzbot@kernel.org>, Marco Elver <elver@google.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

v2 looks more intrusive than v1, and harder to verify
v1 looked reasonable to me

+Marco, is this something where locking annotations can help (to fix,
and prevent regressions)?
Namely, I think we want to prohibit calling vmci_ctx_put and
qp_notify_peer under qp_broker_list.mutex.

On Tue, 12 May 2026 at 12:34, 'syzbot' via
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
> Fixes: 06164d2b72aa752ce4633184b3e0d97601017135 ("VMCI: queue pairs implementation.")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+44e40ac2cfe68e8ce207@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=44e40ac2cfe68e8ce207
> Link: https://syzkaller.appspot.com/ai_job?id=e9b15cfb-e71a-4f95-a66b-628f0a2deaac
> To: <arnd@arndb.de>
> To: <bryan-bt.tan@broadcom.com>
> To: <gregkh@linuxfoundation.org>
> To: <linux-kernel@vger.kernel.org>
> To: <vishnu.dasa@broadcom.com>
> Cc: <bcm-kernel-feedback-list@broadcom.com>
>
> ---
> v2:
> - Moved the host queue pair support check and `vmci_ctx_put()` call from `qp_broker_attach()` to `qp_broker_alloc()`.
> - Avoided modifying the signature of `qp_broker_attach()` to return notification parameters, handling them in the caller instead.
> - Reduced the overall diff size as requested by reviewers.
>
> v1:
> https://lore.kernel.org/all/aec7cb16-64c4-4e01-a974-a6c1a51a046e@mail.kernel.org/T/
> ---
> diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
> index b777bc3fd..7552a5ae4 100644
> --- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
> +++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
> @@ -1044,7 +1044,7 @@ static int qp_detatch_guest_work(struct vmci_handle handle)
>                          * because we can't allocate.  We still want
>                          * to release the entry if that happens, so
>                          * don't bail out yet.
> -                        */
> +                */
>                 }
>         } else {
>                 result = qp_detatch_hypercall(handle);
> @@ -1575,20 +1575,11 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
>                         return VMCI_ERROR_INVALID_RESOURCE;
>
>         } else if (context_id == VMCI_HOST_CONTEXT_ID) {
> -               struct vmci_ctx *create_context;
> -               bool supports_host_qp;
> -
>                 /*
>                  * Do not attach a host to a user created queue pair if that
>                  * user doesn't support host queue pair end points.
> +                * This check is performed in the caller.
>                  */
> -
> -               create_context = vmci_ctx_get(entry->create_id);
> -               supports_host_qp = vmci_ctx_supports_host_qp(create_context);
> -               vmci_ctx_put(create_context);
> -
> -               if (!supports_host_qp)
> -                       return VMCI_ERROR_INVALID_RESOURCE;
>         }
>
>         if ((entry->qp.flags & ~VMCI_QP_ASYMM) != (flags & ~VMCI_QP_ASYMM_PEER))
> @@ -1659,15 +1650,6 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
>                 entry->state = VMCIQPB_ATTACHED_MEM;
>         }
>
> -       if (entry->state == VMCIQPB_ATTACHED_MEM) {
> -               result =
> -                   qp_notify_peer(true, entry->qp.handle, context_id,
> -                                  entry->create_id);
> -               if (result < VMCI_SUCCESS)
> -                       pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
> -                               entry->create_id, entry->qp.handle.context,
> -                               entry->qp.handle.resource);
> -       }
>
>         entry->attach_id = context_id;
>         entry->qp.ref_count++;
> @@ -1711,6 +1693,9 @@ static int qp_broker_alloc(struct vmci_handle handle,
>         struct qp_broker_entry *entry = NULL;
>         bool is_local = flags & VMCI_QPFLAG_LOCAL;
>         int result;
> +       bool do_notify = false;
> +       u32 notify_peer_id = VMCI_INVALID_ID;
> +       struct vmci_ctx *out_ctx = NULL;
>
>         if (vmci_handle_is_invalid(handle) ||
>             (flags & ~VMCI_QP_ALL_FLAGS) || is_local ||
> @@ -1748,14 +1733,44 @@ static int qp_broker_alloc(struct vmci_handle handle,
>                                      context, wakeup_cb, client_data, ent);
>         } else {
>                 create = false;
> +
> +               if (context_id == VMCI_HOST_CONTEXT_ID) {
> +                       out_ctx = vmci_ctx_get(entry->create_id);
> +                       if (!vmci_ctx_supports_host_qp(out_ctx)) {
> +                               result = VMCI_ERROR_INVALID_RESOURCE;
> +                               goto out;
> +                       }
> +               }
> +
>                 result =
>                     qp_broker_attach(entry, peer, flags, priv_flags,
>                                      produce_size, consume_size, page_store,
>                                      context, wakeup_cb, client_data, ent);
> +
> +               if (result == VMCI_SUCCESS &&
> +                   entry->state == VMCIQPB_ATTACHED_MEM) {
> +                       do_notify = true;
> +                       notify_peer_id = entry->create_id;
> +               }
>         }
>
> +out:
>         mutex_unlock(&qp_broker_list.mutex);
>
> +       if (out_ctx)
> +               vmci_ctx_put(out_ctx);
> +
> +       if (do_notify) {
> +               int notify_result;
> +
> +               notify_result = qp_notify_peer(true, handle, context_id,
> +                                              notify_peer_id);
> +               if (notify_result < VMCI_SUCCESS)
> +                       pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
> +                               notify_peer_id, handle.context,
> +                               handle.resource);
> +       }
> +
>         if (swap)
>                 *swap = (context_id == VMCI_HOST_CONTEXT_ID) &&
>                     !(create && is_local);
> @@ -1968,6 +1983,8 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
>         struct qp_broker_entry *entry;
>         int result;
>         const u32 context_id = vmci_ctx_get_id(context);
> +       bool do_notify = false;
> +       u32 notify_peer_id;
>
>         if (vmci_handle_is_invalid(handle) || !context ||
>             context_id == VMCI_INVALID_ID)
> @@ -2035,18 +2052,26 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
>         entry->vmci_page_files = true;
>
>         if (entry->state == VMCIQPB_ATTACHED_MEM) {
> -               result =
> -                   qp_notify_peer(true, handle, context_id, entry->create_id);
> -               if (result < VMCI_SUCCESS) {
> -                       pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
> -                               entry->create_id, entry->qp.handle.context,
> -                               entry->qp.handle.resource);
> -               }
> +               do_notify = true;
> +               notify_peer_id = entry->create_id;
>         }
>
>         result = VMCI_SUCCESS;
>   out:
>         mutex_unlock(&qp_broker_list.mutex);
> +
> +       if (do_notify) {
> +               int notify_result;
> +
> +               notify_result = qp_notify_peer(true, handle, context_id,
> +                                              notify_peer_id);
> +               if (notify_result < VMCI_SUCCESS) {
> +                       pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
> +                               notify_peer_id, handle.context,
> +                               handle.resource);
> +               }
> +       }
> +
>         return result;
>  }
>
> @@ -2086,6 +2111,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
>         u32 peer_id;
>         bool is_local = false;
>         int result;
> +       bool do_notify = false;
>
>         if (vmci_handle_is_invalid(handle) || !context ||
>             context_id == VMCI_INVALID_ID) {
> @@ -2185,7 +2211,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
>
>                 vmci_ctx_qp_destroy(context, handle);
>         } else {
> -               qp_notify_peer(false, handle, context_id, peer_id);
> +               do_notify = true;
>                 if (context_id == VMCI_HOST_CONTEXT_ID &&
>                     QPBROKERSTATE_HAS_MEM(entry)) {
>                         entry->state = VMCIQPB_SHUTDOWN_MEM;
> @@ -2200,6 +2226,10 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
>         result = VMCI_SUCCESS;
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
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/5749a52e-a4b2-4c05-8877-ba1aa2b5f5d0%40mail.kernel.org.
