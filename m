Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88763C76BE
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 14:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780063369; cv=pass; b=hqbvdsOMhbDM/UjOrQv7YC5gcu2pptPajvnkvKhYEyxgYgjHbq3HTnsXGIdp2Qc+AfCFfaV50ndAVR6ucw+jV7D+zuAr5MFdPi6oTo5QGqNgjRLlwTtr9bWs/4IPofa8SAmCeTE2IQboEorcpDYnPCGzjYFQg1IaDBXyoIPSvbI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780063369; c=relaxed/simple;
	bh=wn8x8yiu9TO/swWXe/i5hE/xXtMlHfa0T6i/P6LJ+fg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g1C5E127V0IEZEsqWFV0QAbhmdMT9xCqaG7KPHx3PeJz/GG5NB3JKUS2pcodyKHT5fdYp7nGoTBJocbOj2G1UyXCm5gGtlVMEtx5kwlSTfOR+0luRRQ7udLpdUCCPk3dH0XqjZVLUVBNzBYCeV3pFcEZ0VRsGIRz/IuetI0OugM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s+oEvwbR; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s+oEvwbR"
Received: by smtp.kernel.org (Postfix)
	id 5D03A1F00898; Fri, 29 May 2026 14:02:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.46
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1780063364;
	b=SGw42FnntF1+Wf8igvFlQf/Gp+qWqxeqtz6kq2lCOwlvcORjqUS1Xlnz7Fud4+hAQeu9
	 PaSN0A1PzB9izCo0svwgrz5ggtI6511ZFQzg4JtPrgr1kkyh2lC/zrTpXA3EIw8eTllRU
	 wNdNkgntra9rLYXVlaDF9QBptp41YLjdHVrZiWhUmVwKfY3cZYV6ql6n3cNgklnb1KDC7
	 pIvN7gWsqAEXNGynWrlWviEdJI5uWQlRETsktY/xxh7S33YASedoe1p+E7lPaZ6nCuGqI
	 96Pw3XsIkG9qbEEOuVdHfk2T6xnRi+DSBZQ3jDcQ67VmzMSd+6goyCk1Z0NjnsZiiDA==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1780063364;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=0OQF+30KxRu/3EL8/7FczUevTFhdt44HuBafeyC6noo=;
	b=Nbc7QPXs+zNq6oEtUYm4oFK14fpBRVwWQ9Zj/nVhpIM5xIySHo4HfQzE9xjVISzETOYp
	 mUwZGfygLYR2A+aDXlcJhtTI0jbvK9W7oeCPjcYCrwNUAJcO6b+1Wasrn8nUNuCaGpjdv
	 QdS1ZbiyFedlD3sbIqQ6nLRMAjDatVlbdbVitiD+zQHQJsJ8Xq0u4Nf3/G82PNBJerIJ1
	 YX3HWXJavplpRzHVJwOxEtffs1rGjallbDFOY3ZxdzwQuVmJpUsn9hCL4Z3hfX/oAI21L
	 OWW2ux8CUK0x+wzDtZmgVsFF8dMG1ok9JRrpAmzOCgKJ1D4cIBLaCjybXTb3mio8RwA==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=s+oEvwbR;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.46
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C54671F00893
	for <syzbot@kernel.org>; Fri, 29 May 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=s+oEvwbR
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org C54671F00893
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e61da76fd9so4756813a34.0
        for <syzbot@kernel.org>; Fri, 29 May 2026 07:02:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780063363; cv=none;
        d=google.com; s=arc-20240605;
        b=Z6HrhVBrAcjjbaFmUXdk1ulWRywdePx/c0d6NDCuH9V6Hxlz8p5h8zufWmZd/y8hDW
         UQH+oQMqma6OSEfgcVmzta5fiXgKrbOvxEisFEVEuCZm3oJiy/F47mx2e2elkwWJ7Vwv
         u7xKcS2yag8jAyPztqguAQIVAhR3VQkhWCeK68pNPLcaOJpM8FnVrhGFNfC4eKnzKSl/
         QIsYssKu7RgM5uafyiPtzBG73ChJUW/FSinWw1kae8IWzfyQ06tmGgKSju/beI0+pZ1T
         jurkNDnWNDxdIF+wTM0fRNl7Kn9kDZE+P+F57Ku86WXbPSvjo5tZ+XKqKiU6qE+BV1gg
         +D0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0OQF+30KxRu/3EL8/7FczUevTFhdt44HuBafeyC6noo=;
        fh=ZdIFEji1OgyuQXgcoEzcmXuEqszblyCHGIjqUFa2lsQ=;
        b=K4FZxcvrJ+ehMzenoHsqKI92pep6DkOkJBMYpDDmBAIWU+YqCTbigJ8G2HIUScCeLP
         tiAke3PVKe7lyhaUrDelzcgtFoh+e11a+3gTwKQ+DRw+YEsirK8VmXaD8v0Qufu6SD7L
         xdVARPB05JgXSN94J4tVj/tIuePdNze0ABxcRq2HQUrVPeV27MdhE43Zt0EEOeRNvMUo
         eM/qfzMFfAOrxWsG5EqcXbpPgIWFkcPUbam0KEbArLIiyy7eWfgFcjlMTa0+Ays6rwBj
         I0LuWNwfy1fXJnD2l6sZsZf7u/6xwaFFDKrvYANWryynhbPwyTNeJ/bIvetpxTSGkd2w
         K8rw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780063363; x=1780668163; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0OQF+30KxRu/3EL8/7FczUevTFhdt44HuBafeyC6noo=;
        b=s+oEvwbRNg+5qN7mQ4tl1QLP+3YwS2BeklJHGeyeJlOg8dXcJR06lRQezUhwSiyQP8
         Y1W9QDDAmZvAQ9xP6B4e1h5s8Xs7DVaVKB2fISZx6U0cIWYBYejA5CHzW52U1jsTXUdw
         OgU9uD/2In2Or1tMKSvVqC92T5gKPeyVNo7w/bhksh9eqMMa0qf68WMEJt9ZnGO5AWqI
         y7IhNbm29pJLsZAk1RVfPUkXfFDA5o7p+nNaYf1byOT4zw7D3RLT12jyErh/YoWmlPZS
         NIY25vY2LSX8Cl/zHuX877FwP1DlwkptRN2H0ORoO6vQzaOZXH/O4GcOSC3+fVCVOQx6
         fH8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780063363; x=1780668163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0OQF+30KxRu/3EL8/7FczUevTFhdt44HuBafeyC6noo=;
        b=NXGNdsaU2gPQUJ6QrNvM1jEqrHaciI0GF90O6A7uqf0QSNPBEzmiQkqb1+8BiSChsf
         rDqwzPuJxc5TrEe3VIF7C8Zr5pD4Pk7YR9vq7N5499u/IAsGOFBZJDb9Fzd6C3pwMetj
         0Lt2wfoM2jwV+LXVdbKuKU/fwlJH3toTmme5rDnn2xveyhEwcZEQAq0UVNWkO0ZA837U
         9RbbKzsvd1bFhDg9LGKUazE+pWEzSRCARLNVtRllisLsYQCMPyly+0hBVLlPJpRgnV/l
         fK6OtJLXbW/LNSEoTvfSKBwtivQCia2ikNGzOXwUkTRI7EqIKvr86I5gQScPELPbSiQD
         bk4A==
X-Gm-Message-State: AOJu0YwNkd2h8MSoI8ZcRxbRW+ng+OWlZCA3aHeBipIJI4oc/EMtGaAK
	S+2ndg65ajiS0IdNRRbAuC5IQc728q/T+XSn7KSGv5b/rU6IoqJQ/6s7lrMPeDU0ansHxUFpakr
	/zCwBOKqGbOi1oJfQksJ0S+pOOAHY7Z46tMApu483DYySqL5tlDp+/Gbd
X-Gm-Gg: Acq92OHLiszQpGuSB2kZdYZDmBeTTfT3vcelV+4oiEHNxIhB/dcHBCC1Skbya80RTqR
	li9a5f2wKYngCrGOyjV/wXUECt/E01iGFShl/wnA+3RPkQOgt/o8UUYyDCYpI8ZlR1MDG8ZGFAk
	d6Okt6vaP+SC37TniSCwDncGJOB+eDd6a32/lixEbKJ1r2DqYo1PLC+kLGBDDVGGorb0feW89GT
	i/Xg/L5cNX8z99LxX0OKH9BkGkMEyp5PbZMiXb6YQpFmEsenO36dY3omnCuqdtVTzyXOpTaqmCF
	kakSyq6cng8NKJgOOLUpGiPb5EZUDMwBXJDo75TCezE/VCH64Nn7cR8APBV4QtflEWYWGxtLKdm
	tOv1X
X-Received: by 2002:a05:6830:6b0d:b0:7e3:d199:3164 with SMTP id
 46e09a7af769-7e694cca3f2mr2538621a34.11.1780063362380; Fri, 29 May 2026
 07:02:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <dff1dcc7-59bd-40c7-981e-bd805ae6b3c1@mail.kernel.org> <CANp29Y7ja8YqZPQ2V5LEz3Lpgjpdo0b2BO3ghc1pwhSRBhe3cA@mail.gmail.com>
In-Reply-To: <CANp29Y7ja8YqZPQ2V5LEz3Lpgjpdo0b2BO3ghc1pwhSRBhe3cA@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 29 May 2026 16:02:31 +0200
X-Gm-Features: AVHnY4J9ZovMdNH2XHsqEplaeOJewAs9pq7oiOX6lq88zfgS50pTuJuQiN9IKH8
Message-ID: <CANp29Y5=L7v0iHor=RsSURBuEv1B2oLN3pFuMkUdTXLNvo+_tA@mail.gmail.com>
Subject: Re: [PATCH] firmware_loader: Fix recursive lock in device_cache_fw_images()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Also don't reply to any comments. Just send the patch again.

On Fri, May 29, 2026 at 3:55=E2=80=AFPM Aleksandr Nogikh <nogikh@google.com=
> wrote:
>
> Please send the patch again.
> Don't change the description or the diff; in the change list note that
> the patch is resent to follow the rules.
>
> Now the sending mechanism will automatically set the right From: line.
>
>
> On Thu, May 21, 2026 at 1:30=E2=80=AFPM 'syzbot' via syzkaller-bugs
> <syzkaller-bugs@googlegroups.com> wrote:
> >
> > A recursive locking deadlock can occur in the firmware loader's power
> > management notification handler.
> >
> > During system suspend or hibernation preparation, fw_pm_notify() calls
> > device_cache_fw_images(). This function acquires fw_lock to set the
> > firmware cache state to FW_LOADER_START_CACHE and then iterates over
> > all devices using dpm_for_each_dev() while still holding the lock.
> >
> > For each device, dev_cache_fw_image() schedules asynchronous work to
> > cache the firmware. If memory allocation for the async work entry fails
> > (e.g., in out-of-memory conditions), async_schedule_node_domain()
> > falls back to executing the work function synchronously in the current
> > thread.
> >
> > The synchronous execution path (__async_dev_cache_fw_image() ->
> > cache_firmware() -> request_firmware() -> assign_fw()) attempts
> > to acquire fw_lock again. Since the current thread already holds
> > fw_lock, this results in a recursive locking deadlock.
> >
> > Fix this by releasing fw_lock immediately after updating the cache
> > state and before calling dpm_for_each_dev(). The lock is only needed
> > to protect the state update. Concurrent firmware requests will correctl=
y
> > see the FW_LOADER_START_CACHE state and use the piggyback mechanism,
> > which is independently protected by its own fwc->name_lock.
> >
> > Fixes: ac39b3ea73aa ("firmware loader: let caching firmware piggyback o=
n loading firmware")
> > Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-previe=
w
> > Reported-by: syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3De70e4c6f6eee43357ba7
> > Link: https://syzkaller.appspot.com/ai_job?id=3D8cbf9f7d-812d-4db3-89fa=
-0aaef3ce3a2f
> > Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> >
> > ---
> > diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmwar=
e_loader/main.c
> > index a11b30dda..c96312ac2 100644
> > --- a/drivers/base/firmware_loader/main.c
> > +++ b/drivers/base/firmware_loader/main.c
> > @@ -1503,9 +1503,10 @@ static void device_cache_fw_images(void)
> >
> >         mutex_lock(&fw_lock);
> >         fwc->state =3D FW_LOADER_START_CACHE;
> > -       dpm_for_each_dev(NULL, dev_cache_fw_image);
> >         mutex_unlock(&fw_lock);
> >
> > +       dpm_for_each_dev(NULL, dev_cache_fw_image);
> > +
> >         /* wait for completion of caching firmware for all devices */
> >         async_synchronize_full_domain(&fw_cache_domain);
> >
> >
> >
