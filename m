Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4E12D8DB0
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 14:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786112449; cv=pass; b=i/FM6shqKMtedVf8q/Ua2svauffRUWPF9YeARsC7eFJqTPBAYBW0usBV+KHMCZt/nmk4til7Wmo4EehnpszUeugrKqNyX0DLy/nJXtB9Ay6ODNKxL3WHmMadxXM1EK1nSZqldnEnT9XosSOCEApK/m+ydIz/jUREAgfDNvf6OLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786112449; c=relaxed/simple;
	bh=u7K34fmBQWA4PFnGPjUHudRU7iHajGGvem82zHIbrzM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gs64LhRTSKcpsLUT8aVlsnnk9fzCpw9wrlqJnqcf3x4cbyKvSN8TAIGZCp5rwUjgEtLQ42P0jHtrS+IMXqZ9PmBLlvBYHLDXQ84zNopkdFosZmTKgFmqE5usMICU9d2+VBeluZP3MaEf3uO69TLFD3pnl7x/Rq/5Nuiqf21sBE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UxJk3gYG; arc=pass smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UxJk3gYG"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7ee50eb2db4so2466768a34.3
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 07:20:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786112446; cv=none;
        d=google.com; s=arc-20260327;
        b=h/2LTzNo5eefmiV/VHR9KD0cfSQVgWiDDlFLG4yZ9pLHQWok7d4g1DE8NU8M3lPEK8
         pjLSfHQiffpXZlml28BiZhOm5tF2nxd6LSgyUcvLvhdRTlzEalJD44UVgLIT177yAUH0
         +9H242LkpeYOzzgOPV9B7sbbVLGlwY3pIkE5TgEl/IpkB2XOBamB54VuS8BQYS4FJOcj
         LYH4hio9NnO8WJ7DH53hUxCAsZ/25oBv10yxaiJO2T+SUZJa1Jqu9GA4zyJZG1WWvcEP
         mNlVGIfPfOJQT2fZYDpU4WYtWDJkKE77hZk0DnHCsorr3v8PrmUPBD5TL/qj8I4MoXQp
         BVDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7pqn2IRmhHra3zJfK3pJ5/oGe0tl5HjQk+bPM6ciYEM=;
        fh=DDnSl7qO3MR1ifmgq9EkIeNF6NwV9IoMTipu9OR3tLU=;
        b=XfGbiZZFXxVwwmlZIGBEY6tw4l99xF9h/4GXa5hCb6A4McKyjBA+Q4hnqPAmMS7B4j
         AmCi8D/O+gbrtoyof/+S2uhlBKsKx0v8zygQoSHgggXbT0ITeDUyet/VQKCuJYISy4RC
         dq7m8LybDhhQ9VmIdINCiVcaj0NTQmZ6uRX5GNFpRB9Ij5ZLD7rPCLXoofs2wH+8wX2I
         nOm4+mKjVTwLFuhvqryDzOi+KRRv89C0j1wMDCLXTU0N22xqg1uSZQKnvFzFYuyN70qw
         ssk42w+jmm7OLlBQQilMcGFQvM2zJSXwJiYFzA2FrStIGFudmh9IX+oeFFWGMztx8jYf
         SVJA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786112446; x=1786717246; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7pqn2IRmhHra3zJfK3pJ5/oGe0tl5HjQk+bPM6ciYEM=;
        b=UxJk3gYG+YpsjmcP6jGrBi+jeRHpeNqxd4wn+UJju40twj45kq6Gw3PPFXxcMYTmjw
         d3xEZGbPAgPXfGASqOsV2aYChs3I6mkmgnyMp4sGFhewA34DLIYubM4hkO9/r6y+0Zt+
         MMJscJFs9QJHWx6Mg1gOpbQhZZdroA1VdL7kJBaIGgh09Y0s+0XD76kxNgP+8TpqmwFC
         ki9aF1PjYc9Q/Znfizt3xDhoCXmEEmmnCn35NMGPtL/zEkoFsQAE6iUK3TZRoBVPFIfz
         bqB+SELuPjc66F16060MpqyIpzOGO4bg8NNIJyu4L/C9Rx6r2VjPtq5ZrQO/nO3wyG40
         k2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786112446; x=1786717246;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7pqn2IRmhHra3zJfK3pJ5/oGe0tl5HjQk+bPM6ciYEM=;
        b=esE+nGY070oqp16Murz7fdsPc8icNew6/EP5qriPYljYyUWPjfO5/EDFzHzjtA2VXs
         txK+xZlat+nmC7hpmEoCMX121WjxU26yyc5683Q7l3isLBVRD9X2o9cz3e51p7JPyBSB
         cXnyt9KQfGe8ZMcpfEWHp0XdTmTcuHzRdpu4wDFzjh2cDHnCRtxdt78iU0LC79uADf3F
         vdy+UfU4XJx3sy75WLCBQleE5ccQzrhZ1lzsPU9jAWAxUNxg5C1LkSMGHM+MieIMg/Ts
         nqFjqX5PTAYp+8KX+VW+s3SJrIgLUWOmGyzDig+eJJCICVJDFsBkOOYG54yKu9zKYESi
         NlWw==
X-Forwarded-Encrypted: i=1; AHgh+RonuAt45q5Hh5mj4y34XuSpzuaURqvEONxJ/dfNVP0SUAPauQuydLZZzjI7PU4yMnpqWFZLuUA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXOoX7/ZjrXX8l/ugHCrDaGtxqB/zIo3Y1ZPOzTsQsrG6TqD/I
	cCyRSR3vj9KnhA+eihXnkMUVh5/+d13tmgUiTn2Mwy2L+u/gZ3ZEgxHAsw+8zGUHROOq03YcXBK
	49+N0CY9nsXJgxYE1Lw2WngriHcDtckJehX+41hxL
X-Gm-Gg: AR+sD10cK5u/bYT2+2h2ZYZd/k1ybYXGdGFEEkNCOjsfl0Ci/N75gadUwUWGBXXSSB0
	WbegFeuW+Ax8Ks15hVt1fDxo/Li+LXjXmP1Q+bx2Ye1sTC/Us0fTsdz3OQ/peW2qp/zoNp7ORjk
	bAm9B4vixbgIzidnPmeNIWw12M/os9LE3jKD3LeNuMAbbbf2UNMOU06Zz48iK3oco0uHKJsokcY
	vun4/TZP4bQhwSy/sIyESfIBclYabjZdH+QYUVr1EMJxgTFY9kTQKzucgfvqDjn1qjCyHtZOGSB
	MHn8VvQ2VafVXsYWBIeiAQ/4vb2K7jGWCNNlGZqlXrHep55idGK7P27NST50cxZKCzA7/OeiF5f
	pUqLb/AnKcpQMhIb/jJTCyOTpRA5em7zA8HWU6qcti3kG9duI15SOG7TiEgqis4uoLmhkp4VKZe
	LJR/IAemoZ7nUv
X-Received: by 2002:a05:6830:81ca:b0:7e9:f8e8:d905 with SMTP id
 46e09a7af769-7f35f1cee47mr2458727a34.16.1786112445520; Fri, 07 Aug 2026
 07:20:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <eb1357dd-f393-49f1-8e3d-60888cbb683c@mail.kernel.org>
In-Reply-To: <eb1357dd-f393-49f1-8e3d-60888cbb683c@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 7 Aug 2026 16:20:33 +0200
X-Gm-Features: AUfX_myTaCi0V_Uj6o4BC8UjwgdIS359G8ynt_5YIiDJRfks_ostFqbNLjnICto
Message-ID: <CANp29Y7bgpsUue2Sja_x9Qc-yf9Er_1y2KtMuugbWVf6c8wYhA@mail.gmail.com>
Subject: Re: [PATCH RFC] firewire: ohci: fix NULL pointer dereference in ar_context_release
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Aug 7, 2026 at 12:09=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> During the error handling path of the driver's probe function, a NULL
> pointer dereference can occur in ar_context_release().
>
> When pci_probe() fails early (e.g., if pcim_enable_device() or MMIO mappi=
ng
> fails), the devres cleanup mechanism invokes release_ohci(). This functio=
n
> unconditionally calls ar_context_release() to clean up the asynchronous
> receive contexts. However, if ar_context_init() was not yet called,
> ctx->ohci remains NULL (as the fw_ohci structure is zero-initialized by
> devres_alloc()).
>
> ar_context_release() immediately dereferences ctx->ohci to get the dev
> pointer before checking if the context was actually initialized, leading =
to
> a crash:
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> RIP: 0010:ar_context_release+0x3f/0x380 drivers/firewire/ohci.c:543
> Call Trace:
>  release_ohci+0x3f/0x60 drivers/firewire/ohci.c:3567
>  release_nodes drivers/base/devres.c:546 [inline]
>  devres_release_all+0x1a8/0x260 drivers/base/devres.c:576
>  device_unbind_cleanup drivers/base/dd.c:597 [inline]
>  really_probe+0x451/0xae0 drivers/base/dd.c:772
>
> To fix this, move the assignment of the dev pointer after the !ctx->buffe=
r
> check. If ctx->buffer is NULL, it indicates that the context was never
> successfully initialized and there is nothing to release, safely avoiding
> the dereference of the uninitialized ctx->ohci pointer.
>
> Fixes: 5716e58aecdd ("firewire: ohci: release buffer for AR req/resp cont=
exts when managed resource is released")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+d30aad27833a559defab@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dd30aad27833a559defab
> Link: https://syzkaller.appspot.com/ai_job?id=3D10a18617-7893-42dd-bf1c-c=
d49e19e95d9
> To: <linux1394-devel@lists.sourceforge.net>
> To: "Takashi Sakamoto" <o-takashi@sakamocchi.jp>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
> index 8153d62c5..e947227e0 100644
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -540,11 +540,13 @@ static void ar_context_link_page(struct ar_context =
*ctx, unsigned int index)
>
>  static void ar_context_release(struct ar_context *ctx)
>  {
> -       struct device *dev =3D ctx->ohci->card.device;
> +       struct device *dev;
>
>         if (!ctx->buffer)
>                 return;
>
> +       dev =3D ctx->ohci->card.device;
> +
>         for (int i =3D 0; i < AR_BUFFERS; ++i) {
>                 dma_addr_t dma_addr =3D ctx->dma_addrs[i];
>                 if (dma_addr)
>
>
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> The person who has signed off on the patch is responsible for
> addressing comments.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/eb1357dd-f393-49f1-8e3d-60888cbb683c%40mail.kernel.org=
.
