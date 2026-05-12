Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B46395AC5
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 10:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778581172; cv=pass; b=usL1O30ljt3xQoG+bA4zVFurAYuQ+72fPq/eZYdVIe3MJBQVt5IDirZQCEI5EKVd/Ir15tSGtERHXJv9kKqVJOArhUDZ8nET/Q+pJYh//wdHIRxqph9H8GFgJV49cdCxS2ncmUws3FISCRCTRG4fa+q00fpIhk7Okf5pm1MjOIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778581172; c=relaxed/simple;
	bh=twRHwlYWmjcSM5grYSbqQaA61F8nfu1fdZyxhIS7KEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KyGrUNYJNi4s0pIFYmkElMQmkHj918tF0qmXuvj+zqVvknmzQ0K7Ee+Gzmz/bUhvYHVG24lB8kfirR7HSw4DSKtxxCJPznJ3tPRaAuchdTm8cdKIqA7PuEGWBKGcHyhcEyhSSOzj2/5WD+QV3bjh6m1o0aRqGjQWEMUwikNprFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Iv7qXwgn; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iv7qXwgn"
Received: by smtp.kernel.org (Postfix)
	id A06A2C2BCF6; Tue, 12 May 2026 10:19:31 +0000 (UTC)
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BD32FC2BCB0
	for <syzbot@kernel.org>; Tue, 12 May 2026 10:19:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org BD32FC2BCB0
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-40974bf7781so5102610fac.0
        for <syzbot@kernel.org>; Tue, 12 May 2026 03:19:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778581169; cv=none;
        d=google.com; s=arc-20240605;
        b=SwRny2nYYF6imPnxNMA9ZRV3SWUm5DayYO7nyCCZwct8N0bx1pDQ4cRFt3tdGjp34c
         wVOuat87DnNxNQ+XgsSJGBVdD/B6hinQrdCAZvpPfzry+yh/MZtqTbt3SNmA3oxaDqUR
         VSjwKHnFKcYHRDRemcZq8nxmhwGWhxdXhFsEoZUdggb03+W805t5+4XUBJGvGznlltWa
         R2oWJz5ndyFyyyzORlamtekSTyr0LkWssyWZ202krlUukymdutPlZGzMedzP8+3YT0lw
         bVrYU6+3XHNh11VGF9PY7A/B5ImzpQehJwMfPQynKxYNhkE28Kab7WB3RKKv1UhKaHHS
         uqfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V0FHgZHcxf0Nn1z25I8HI7FxlKr1gQwhnP+QXJFI4cY=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=SMjBhM/gdy14ExQvVbKVwKkKp704JDA8fexejAZ2qRwpy8K1yi5ShMcMsQ69+tvIpB
         jHuHmXMmhCg7DhcFfvELxDmManTdsA4ppx41ra48b251MSaeqh5gWhBc2hzxT5BgqQIi
         z1GF13y0CZyhR/8G5du16i1Rzo9XHtcPYAv/1V+1jcXnohGh4/sXzTwWcsmJe7J/NkiK
         hNg3yigOFsqJasnwGd+qV6FIrXaAgXSIZMbMnTuN3PuaaK5wZOcyCzYUzyY7EoEAhr72
         p4gky3yks2RANOc4hfZvh85s43Q2OvpMkfV5ytQQmk7aQPwJYJ/Rddl0QnAiZ6TCHzkH
         TRRw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778581169; x=1779185969; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0FHgZHcxf0Nn1z25I8HI7FxlKr1gQwhnP+QXJFI4cY=;
        b=Iv7qXwgnRODZl7dMwQkPlA7oTrb6dGnKwlpY/h2pN3vAa5JYbJ14VR2nQVCqtoD/53
         66Gi+40BHVwWeDQ19IdXYva6bRvBf7JVGkf7YtFk60duT5/zVUPSWuaPRHQIjknZ47ma
         Wl9Gwz9Baa2UIaRtoSL57g4WoRB3hhcLrAn5B8hYHTSKU6SGYHp1QKpA+iHn2Q38Ce85
         uj7cYD9UeagWnLRCTobi2fS5ujD2HJMfYxefxuxy54Pp2kx6fmiHSuiPY+mH7yARrO+I
         iqtAjrOXvru/mxPTduF4reM4Ak2XJaCcJRjf1Z9karAu24gB48K85Z9RSFOhDVeoSmBk
         pkLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778581169; x=1779185969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V0FHgZHcxf0Nn1z25I8HI7FxlKr1gQwhnP+QXJFI4cY=;
        b=ezDg1r3f0zXVqr4oVSJ5I5jy8SCdu6PvdYJS6+xqTUexe5bvH3zAXDosw5bz03Nh2N
         qc8tR/c7AkvauO3EZ9fy8KKvgTErT9tt84q8uJ56ueA9dtkhvq6iGV3c8iInlHnGB01k
         +tt9AOtY+YDw4HTM7Dl0hYdg1mlS/2cXhqrhFfoyW83P0zm0keajtRgELHsxAhPZ4Kts
         qP80x3rkxSqt6701yjqyNGYbFE41QVxTibxV7LP3Bt1Pffi3/rSjqvJXSNb8J78sCybf
         CL3tr226H4dL1m8sjvvS7a3dEpbBP/FYDnXZRmJcxK/t7Ruh4EI12R/uDySutXALetyl
         gL1A==
X-Gm-Message-State: AOJu0YyAuu263D2Vw25AG5FRPW3QFFQukMfQrhNyenhr7gCalVUHF1c0
	QAu3Js4ZZbvxijDUD0pFovQnmQlVZN0aE5OnddMU3vKswYDQEE7A9rqifQjCjMbcmznhT2gB/2b
	dvJX7wLUemf1Hr/bMImrKshKXRSdC+VTyMeUQGUuz7QAyP4B0p+f+HhUg
X-Gm-Gg: Acq92OFsLOsKMEbTF5B6g1YgiQqfQL5tOZW9c280Plpt4hG0dGAO41MpeB6zVLmqnEK
	We7nY5JKGKelVv2ICIhFC6vae6tEP5+EzVmmsd1sVK3FvU+mp1pHWHySEUbHdaWFLdk8OVxLL36
	E0khgIhraF0GbRSPlUYW063n66RXwTfRd7AA/dGOrgvDeqVRYX51c7XQrZi0LDMfLW+18booUdc
	F4ONk1QTjK3J3i1vY2qk4PBiitR47I/mv6psCHe49NFKIOmcKrm13v15gm0Kc8Jk2bqX9OsKsIZ
	uarMlZ4AW0GITUC+ZOVtIsdYGAWq50Q8P/dirMXB1+CNq5a9uGfTt+B1zzMeMUYlYlHXlmW6A1T
	pRX9w
X-Received: by 2002:a05:6870:2c98:b0:41c:4fa4:b568 with SMTP id
 586e51a60fabf-4399b5f37femr1739313fac.12.1778581169011; Tue, 12 May 2026
 03:19:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <8cbeab5b-2812-4567-845f-9baee48062fb@mail.kernel.org>
In-Reply-To: <8cbeab5b-2812-4567-845f-9baee48062fb@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 12 May 2026 12:19:16 +0200
X-Gm-Features: AVHnY4JkXTNV_Y3tWOYbkhgsYNlULBgkkMUrlQktnDTfnkDjSmRmVKctPL9RINI
Message-ID: <CANp29Y5CKaDdn=9y=yGG-_aSki5uVoEeZcyT=CBvS41yMEEKEw@mail.gmail.com>
Subject: Re: [PATCH RFC] media: pvrusb2: fix missing cleanup in pvr2_send_request_ex
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Why was it correct to replace return with goto done?

On Sun, May 10, 2026 at 4:30=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> media: pvrusb2: fix missing cleanup in pvr2_send_request_ex
>
> In pvr2_send_request_ex(), if usb_urb_ep_type_check() fails on the read
> or write URB, the function returns directly without proper cleanup. This
> skips the timer_destroy_on_stack() call, leaking a timer debug object if
> CONFIG_DEBUG_OBJECTS_TIMERS is enabled.
>
> Additionally, if the write URB was already submitted and the read URB
> check fails, returning directly leaves the write URB active. The next
> time pvr2_send_request_ex() is called, it attempts to reuse the active
> write URB, triggering a "URB submitted while active" warning in
> usb_submit_urb().
>
> Fix this by replacing the direct returns with `goto done` and the
> appropriate cleanup logic, matching the rest of the error handling in
> the function.
>
> Assisted-by: Gemini:gemini-3.1-pro-preview
> To: <isely@pobox.com>
> To: <linux-media@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: <mchehab@kernel.org>
>
> ---
> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/=
pvrusb2/pvrusb2-hdw.c
> index 3c270ef00..dd504b1c4 100644
> --- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> +++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> @@ -3669,7 +3669,9 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hd=
w,
>                         pvr2_trace(
>                                 PVR2_TRACE_ERROR_LEGS,
>                                 "Invalid write control endpoint");
> -                       return -EINVAL;
> +                       hdw->ctl_write_pend_flag =3D 0;
> +                       status =3D -EINVAL;
> +                       goto done;
>                 }
>                 status =3D usb_submit_urb(hdw->ctl_write_urb,GFP_KERNEL);
>                 if (status < 0) {
> @@ -3699,7 +3701,14 @@ status);
>                         pvr2_trace(
>                                 PVR2_TRACE_ERROR_LEGS,
>                                 "Invalid read control endpoint");
> -                       return -EINVAL;
> +                       hdw->ctl_read_pend_flag =3D 0;
> +                       status =3D -EINVAL;
> +                       if (hdw->ctl_write_pend_flag) {
> +                               usb_unlink_urb(hdw->ctl_write_urb);
> +                               while (hdw->ctl_write_pend_flag)
> +                                       wait_for_completion(&hdw->ctl_don=
e);
> +                       }
> +                       goto done;
>                 }
>                 status =3D usb_submit_urb(hdw->ctl_read_urb,GFP_KERNEL);
>                 if (status < 0) {
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
-upstream-moderation/8cbeab5b-2812-4567-845f-9baee48062fb%40mail.kernel.org=
.
