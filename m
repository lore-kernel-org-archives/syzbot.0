Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32013D5C38
	for <syzbot@lists.linux.dev>; Fri, 28 Aug 2026 08:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787906607; cv=pass; b=jvWm7jsYT17RH/699d4TgXozjZy34c3oiH9gyAcAgjUMZOUxJE9NH3lJ+vO4WkQyr/csNRC/nwI7UiS8pjRrv+ZeqBi9TjGEb0H43EefXjp6BLOc0cymr9kxb0+kFK3aQAxH+bgD2g7zUi0BNwNIbIk8Nasc6ZQarDE8qn19E5k=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787906607; c=relaxed/simple;
	bh=1Y4HFeY/l6KnwWOl4zbCaeFX5mEHoKXg8qZCMEIjKxk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fbWW9Rr22r8TRbnEhXRRyN7dpal/GOxhXh5tJbKpvtiO02QikJSpVE5NQC5/6RnomgGh4Y2+W+NqrkTjKwig6GbgNPD3oueFjOtC/0VzVL4MF33NNzxkik9JnYk/4BbozKYjAcxyerGnbKFt+A5M+gygF1G2zBNoid1XqOcbWHc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P2BlVyvB; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P2BlVyvB"
Received: by smtp.kernel.org (Postfix)
	id 903331F00A3A; Fri, 28 Aug 2026 08:43:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.41
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1787906605;
	b=tfQoUUIqGLw4JAgcbSWaj0tx8AOnaLJz1txjC0qddPnbhvnf4Xz2uBh+2BfLAS4lkznW
	 mNprRo/0agEJ52hXlZZ+7wYN6m7aIcPbnTJsK6stcsx2oQ+wUUMF0VYE7RRxDK3inVd42
	 kEHFBxoSI5ufwcXRpq93BMSwP3KUw5M+Y7vS+4WP3xof+bxqyZuipSFPRSSVcxmd5tD5/
	 0MoaAFtrqB0KT2fX1frQJ74UxrGwaGfIgvyMjGEYA88jP6BeIEXUDidAmctLeQ4cSHJT2
	 aNcfMnYyWPJybWQqsESrJNadjIjNGwsUvqfSwB1YMKAAOIbVgtMYHfvn1oign853gEA==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787906605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=TnNi55ATCdzXtjs7iYSt2Vhzh/mN80+eEDeW4X1yUAQ=;
	b=ccKAFtJSS5fYv+Zh0f0uv6iqqJ52iTgvr1OdryQypaHorXdvF58ArWqMwk6uUxCssbk/
	 uE2+IW/khMoUcAnpVZXxXtcABpArh1zRvDjd0yx55yrKAExmOnKF40ldsGdW2UPzXC95n
	 03Vsopx6N/4hVG1dw/oMAApOm1jwKB25haW4fV+KQTIdNgeiKGrsJ5fE+qXBTGDia7zRP
	 Ffc6e9c75vX2klEGPEvDoYf4Jv5/Q2OOpEz2tOo0PbUTRwhQ3SaSyGSRS9vniCsRMFUbw
	 +ocvZRJCUoIq03P+DyaPLwcH4NMzWNs+bX2jqDw5YHMfDUHFXUKZbFAwQThKJz02E6A==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=P2BlVyvB;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.41
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DCD9D1F000E9
	for <syzbot@kernel.org>; Fri, 28 Aug 2026 08:43:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=P2BlVyvB
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org DCD9D1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e9ef94c0e2so701179a34.3
        for <syzbot@kernel.org>; Fri, 28 Aug 2026 01:43:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787906604; cv=none;
        d=google.com; s=arc-20260327;
        b=R6x0x64aOTcosWVZcHkhC0xjCW2qp8Uxid0f1/TNbrJPzzQktY0l9DU8Q5YLqCb+FK
         v4pL3yRrX+Tg98dKOnA+WTkhD0g6/PiDrZswmoeP7+7lzo39fzzAHRurGzAbwBjXvui4
         trqdJ7tdEXJo/k9Tv6C1IIIGtP4tJFwtPsVDLxoPqt5zbnhokXxD2qN01uF03IrKsL7S
         dhx4yZo0qv0ky6bTJ7AGT8fieYnmV/dxuMchhgnJbmSyyg+61sS63RVQD1rASEcQ1lcm
         fEwh0D8HDVqnjQO3friLz0agFdTaBIlkKn9blDHbkl2Rh+8z0XHczpGJWv4hztWDXUGM
         VF6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TnNi55ATCdzXtjs7iYSt2Vhzh/mN80+eEDeW4X1yUAQ=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=rOLQynW329Om6y6ZeMN3kFyvoanNCP9R/Hm+d1uiuAcmCiHbdjy/uNY83JQkcYVT3m
         xhPiuXNdmoY0kVJzIpnDtpb06N7NE9YEs+p0Ec3WPodf4ZYvgA+1OLNuHa6MyJZS2t/Y
         mOwTtH28ciI2bvr4HFdMyrEaVP4KftISwpTVUAAIoQOuTXFj0k3ZOtWauZrSNKf0K3A7
         eyhY4tyt4TIh29QwbpQ7mdkgQ2KsyRgFBMbY1pg6F202ODH+WCTPaYod/gFhx7qqf1Je
         y8vF7P31r8vWNZrr+ptr4drEuYmnnxdDU7nEwRmhHDKL+4JOnpp2UMNz6Z0CBW5jWIVk
         DqMg==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787906604; x=1788511404; darn=kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TnNi55ATCdzXtjs7iYSt2Vhzh/mN80+eEDeW4X1yUAQ=;
        b=P2BlVyvB3u9onCcX4xZLgEIPpo6vdusEzxQTeI8zDmpamtQ4/w6tzerbAct7PmL+d5
         bhw5qjBtrhYm/KAkVeT7Gphzcug2SXllkdhCpQQba/Ppe/QuG9vvtK29161cGsxTPvDn
         xXnRm7tEXdYdX3psobiSP4yObm17gigVBbIM3oRo3R6kBLKqneMd14+9fXHcv4oWnc2q
         HzIvaFhKmP8kvWGhAy55wFkJjO/mm0Jgjvec1Bn18fSFCgIIgEn0tKKG2OSPpxtWGk6G
         rO4ALH/Dnp60lbvnF6p3Uu4dgfrU+R378z6xabv3zFFJHO677UZQxY6VfAuqjJD+DnN3
         ShFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787906604; x=1788511404;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TnNi55ATCdzXtjs7iYSt2Vhzh/mN80+eEDeW4X1yUAQ=;
        b=bBHF1tX9GeZoF8GFc/NdULTfc5Ik+mSWOfZkbnPvaiE3anZ8d0oRZWvkV+ag4fG117
         ft/4wy10epTFtyTYGgvOTxZN/kn8MpzDF//IpKS71NQLh6vDVQw1UxKC4B8OwwnmvmzR
         MuPKcKURgt4GDAZVIdzreAIH7SSQ0r2hXEnNHbmxKwRAkdpuOEgSyiztUgeOSQgnBn2O
         +IU9lVEil2XFDwC3RAeRuIe2cXpaKMStJNcs7aN0c6Xwiz7cZQgHuhekwro2bhRNTJGT
         K02yYUN7i8qTJXOoir+hLdiADSZW2zEI2sQLuenjtminww2k1tRazBLk4zhLglEzkwzN
         pZ6w==
X-Gm-Message-State: AFuF++l8oKhzMC6urWjJ9ROJkKVIrhSbf0R58WQAXKWVTyeSLUdsJomj
	gnvmYwpt3wq6tP7QLRX4WJ4VIoUov1xGh8Ux7NNd+Id0QiU8cyzuBa8Fm/xZeow0L5kl6Yfct2c
	HFDYlHIL4Qjch/+wbCaAYufPAngFHCUjGtvaN6oTjXbd+B8gXhoq8Az68Qfc=
X-Gm-Gg: AR+sD10Z2GywSA+AARlRn5WqAukg5juPiD1QH8IxxrMbyXhZr/3rtzY7gGfiXbxqgIO
	FsD9C/ZFRGmilqeOwi87E1RtB00TNwQ2e+TawgFSDmeZdjB7MYVy85YzHW7g1+Sh0xnVpkk5LCW
	ARTrkrdTejAuHnL61sARes0fdu64zp3ITuaA1rxs4U/sG+04sEvXjMfqxiZqRap6bdrfDqrZJdu
	TWBf0HLd4M8sp1PPv5ppdRBt58WgfJVPbGpaz/XABrxLsw1vPapbRPU+UY2/NMKcFPyd2T/xZQN
	rPutJprKIgRnkFAiJsA+ruMSSzlhnT0et3T1nYWOWchVyNFRD4MVUF/TTanEmaOQwVjKgewe472
	5u6MC2VJUKmOiH9PKZS35pJLRfzpQgcXofZwEL8rzZd/6w3hzocbNiVFIZPz0I3OdecVIVuO+bC
	1udZ+JLKDNpXdofNir+ca5lPA=
X-Received: by 2002:a05:6830:6d4d:b0:7e9:e709:44f6 with SMTP id
 46e09a7af769-7f4f2392024mr7562135a34.12.1787906603400; Fri, 28 Aug 2026
 01:43:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a872422-fe69-4f50-8fa1-20fe34af5da2@mail.kernel.org>
In-Reply-To: <6a872422-fe69-4f50-8fa1-20fe34af5da2@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 28 Aug 2026 10:43:11 +0200
X-Gm-Features: AcwNN1VzTxO4unuvYJCUHYEHdh-7j-p88gMyIHdkzL1pZNNL2KfFOdzQbguYF-I
Message-ID: <CANp29Y7rD_CuFqOrft2YsJc9Ka3OYZW3D3hFMv9YXiVO3VHgxg@mail.gmail.com>
Subject: Re: [PATCH RFC] usb-storage: alauda: Track media_initialized per port
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Aug 26, 2026 at 2:38=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> Commit 16637fea001a ("usb-storage: alauda: Check whether the media is
> initialized") added a `media_initialized` boolean to `struct alauda_info`
> to prevent `uzonesize` from remaining 0 on initialization failure. Howeve=
r,
> `media_initialized` is shared between both LUNs (XD and SM media ports)
> supported by the Alauda driver.
>
> When the kernel probes LUN 0, it successfully initializes the media and
> sets `media_initialized =3D true`. When it subsequently probes LUN 1,
> `alauda_check_media()` sees that `media_initialized` is already true, ski=
ps
> the initialization for LUN 1, and leaves its `uzonesize` as 0. Later, whe=
n
> a read/write command is issued to LUN 1, the driver attempts to divide by
> `uzonesize` in `alauda_read_data()`, resulting in a divide-by-zero
> exception:
>
> Oops: divide error: 0000 [#1] SMP KASAN NOPTI
> CPU: 1 UID: 0 PID: 5849 Comm: usb-storage Not tainted
> RIP: 0010:alauda_read_data drivers/usb/storage/alauda.c:954 [inline]
> RIP: 0010:alauda_transport+0xbd6/0x43a0 drivers/usb/storage/alauda.c:1187
> Call Trace:
>  <TASK>
>  usb_stor_invoke_transport+0x115/0x1a40 drivers/usb/storage/transport.c:6=
11
>  usb_stor_control_thread+0x44c/0x8f0 drivers/usb/storage/usb.c:462
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> To fix this, move the `media_initialized` boolean from `struct alauda_inf=
o`
> to `struct alauda_media_info` so that each LUN tracks its initialization
> state independently. Additionally, explicitly set `media_initialized =3D
> false` when no media is present or before calling `alauda_init_media()`.
> This ensures that if initialization fails halfway through, the driver won=
't
> accidentally trust stale data from a previously inserted card.
>
> Fixes: 16637fea001a ("usb-storage: alauda: Check whether the media is ini=
tialized")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+dc208a8cf8d37cf3e5ac@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Ddc208a8cf8d37cf3e5ac
> Link: https://syzkaller.appspot.com/ai_job?id=3D87935d94-4387-493a-8061-b=
cb7752c517c
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Alan Stern" <stern@rowland.harvard.edu>
> To: <usb-storage@lists.one-eyed-alien.net>
> To: "Shichao Lai" <shichaorai@gmail.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
> index 691fe4700..807492f75 100644
> --- a/drivers/usb/storage/alauda.c
> +++ b/drivers/usb/storage/alauda.c
> @@ -96,6 +96,8 @@ struct alauda_media_info {
>
>         u16 **lba_to_pba;               /* logical to physical block map =
*/
>         u16 **pba_to_lba;               /* physical to logical block map =
*/
> +
> +       bool media_initialized;
>  };
>
>  struct alauda_info {
> @@ -105,8 +107,6 @@ struct alauda_info {
>         unsigned char sense_key;
>         unsigned long sense_asc;        /* additional sense code */
>         unsigned long sense_ascq;       /* additional sense code qualifie=
r */
> -
> -       bool media_initialized;
>  };
>
>  #define short_pack(lsb,msb) ( ((u16)(lsb)) | ( ((u16)(msb))<<8 ) )
> @@ -471,6 +471,7 @@ static int alauda_check_media(struct us_data *us)
>                 || ((status[1] & 0x01) =3D=3D 0)) {
>                 usb_stor_dbg(us, "No media, or door open\n");
>                 alauda_free_maps(&MEDIA_INFO(us));
> +               MEDIA_INFO(us).media_initialized =3D false;
>                 info->sense_key =3D 0x02;
>                 info->sense_asc =3D 0x3A;
>                 info->sense_ascq =3D 0x00;
> @@ -478,12 +479,13 @@ static int alauda_check_media(struct us_data *us)
>         }
>
>         /* Check for media change */
> -       if (status[0] & 0x08 || !info->media_initialized) {
> +       if (status[0] & 0x08 || !MEDIA_INFO(us).media_initialized) {
>                 usb_stor_dbg(us, "Media change detected\n");
>                 alauda_free_maps(&MEDIA_INFO(us));
> +               MEDIA_INFO(us).media_initialized =3D false;
>                 rc =3D alauda_init_media(us);
>                 if (rc =3D=3D USB_STOR_TRANSPORT_GOOD)
> -                       info->media_initialized =3D true;
> +                       MEDIA_INFO(us).media_initialized =3D true;
>                 info->sense_key =3D UNIT_ATTENTION;
>                 info->sense_asc =3D 0x28;
>                 info->sense_ascq =3D 0x00;
>
>
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
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
-upstream-moderation/6a872422-fe69-4f50-8fa1-20fe34af5da2%40mail.kernel.org=
.
