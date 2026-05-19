Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A424028CD
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 14:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779200659; cv=pass; b=UfrNbdU3Zyy6xJj/SFCOMEVLnKd0JpinUk5OuzZ567gTGUKqcwfHLHdm3K5daQJaNEeIIQRXNCNKSpg+2e3lYh0qpsRGkLY/MJ+MZ9n3i5ldNdiNr10eWfek6JO6lUZ6oPzaOx0+SpteC+lOHf70qhhBIPz7WSSMVVGIAw1yu8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779200659; c=relaxed/simple;
	bh=mFx9h7e6en72K1g2nuIY41NZGrHIDhOaSVwFE/IhuuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s9gX4g8letL5hE9fLi7fYb2SMUrBeufvsROaOZyjUHlI+u5xL6v5s6+eE/THoukRzMvCE/T2871ouIUscuY/42Kou2be8ao9H/usEpX9A2DMLrzXQ4GDUQb0cqD7N0gSN6bF//U5UoRnGfoepTmbqZcCnOPClL3UKn1/6Fx5hXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=di+G0aq9; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="di+G0aq9"
Received: by smtp.kernel.org (Postfix)
	id 4A4F4C2BCB3; Tue, 19 May 2026 14:24:19 +0000 (UTC)
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 58266C2BCB8
	for <syzbot@kernel.org>; Tue, 19 May 2026 14:24:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 58266C2BCB8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-43ad01fe217so486742fac.0
        for <syzbot@kernel.org>; Tue, 19 May 2026 07:24:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779200657; cv=none;
        d=google.com; s=arc-20240605;
        b=ZvpuwEtcUibBb/H6pjIkl3sakHr7pzW18Ug5sL8w+KdABWuuMG6hs+7ftCWiErGAvP
         TjAJpGx85RivbLDdyiox+5C8uvJ4ZFyFPgEw6H1bq5IGk0AlnPGZXIaNkdUhPeLlP9Y1
         +ay2V7F4Em1+5cp4EZU4k91F9Q2SbomH/7F1N+r8YtnT6o9n8zsbGIOyoOhKiAulcoUR
         9d11DCSSNvihpcYPWxyqwRiVbNT1m1PnrnY75vHm0SM30vM0/P1zwcUOL7UcYfs5gqxG
         SDNNhAtBICB8iu9LbYw5wMSaMlbd61EmF7dKtAf9j06a+qJ8JmJAv7VaqZQ6J5HoOPYw
         3gNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tEhCvOXMPaxnMPLbRd0AsjfC92x893uv31B5cs12bfo=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=XqXXLNmaJa81WrZayeJ74BDwTt0Qj2J6/SVUdjmiKZXExpXCynjHXE8cE4sgVltqFh
         KduYgP0PtuIdvKkSbx6xx6TxrqNP1CYN2eg32zYOSHlJjcB2WIclSnfTLGllyYB9d0TO
         KGJOfxdr4EXtolxylqqYu5eemZDsIkdSYi54kpO4xjn+XUbuyxAHdDGPhtmwLkgm8OAk
         HE7I2VLSNuCjIiw3Kt6alJI0O5MLzwvcVvZfGzXPbTkRjc3qDJ+k2TY6M6BeVVmAo3r/
         Gx3RdgiMyyWxS8ojWr3GixXhi1/iSJrm1DlAuAA6gh70PChTUAbyUrOc0JgA4i5PJav6
         k8BQ==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779200657; x=1779805457; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tEhCvOXMPaxnMPLbRd0AsjfC92x893uv31B5cs12bfo=;
        b=di+G0aq97PsL324Ki2h4YWebFnR1geFgFb7GF/9eYnywmFEaWZiXvHcY7140et7pXI
         iQ/C4/yt9VrWplLPqJmVTv6/3S25hYqcfY7lmay/8SaovMP2lanjNDBEhDhcyThdJbWL
         imtojmRTR00F7FH8ZCoSGYxGHp7j/rEQG3jSOZt1h5jaJmnF2H4S91/SCkl0frgrFaqC
         iKXOTkmZ8sM+RdqSrBQ/fKXvBEKUFG3NVXhemVe3ifekyVg2VtHZC9ctjvqTj9iZVk7F
         eYBilHk8sXrE2Fq/FzWqwyJ4N4gc1N27/xp4Ornde72MRyTtLpUT69QaJB89xZDsQIM6
         OGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779200657; x=1779805457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tEhCvOXMPaxnMPLbRd0AsjfC92x893uv31B5cs12bfo=;
        b=RbKq5qYfiFuH/BzsFUQx0P4qYQz7pFUPJAyDyGu2AZzoLK4kSnvgdlkGDk+Cj6llRj
         PiLigCwzRW8Afr6pVOTD58h+FDGjA7GhaQ/zoFbl0IHXhULBaodO7uH/jep1CIJCMW+M
         0z65oeUw4dqJhVdXIGyn3lBa/uJAh5lzh6Erkb26mDhAXJS3bA9Z39kFRzvsFZeGJHDO
         BEgDGd6TJjiR/Zq35XMJHXnce09OZumjOnBcj3JsNSZRmPLAS1L6Oxt3rElFiXorwYkR
         KpLIv7uhWVyLrm5fUEyCPbuPZyWd1zuD5m2ZBAB0Wm+zrRpNqCpIMnM9f9Sq0ywMw4P3
         yl9A==
X-Gm-Message-State: AOJu0YzPOzuji9jOo1QQ7kWO1PIiUJmRFSamD4HU9xd1JWHEyWJPzr9q
	ZR/5eY7IIAJj0lmTdWRAg2rvxWRxCuxyQvLXxBZfvrmcZFbrpQQD5Ei8PhdbSXXuMS5WXog77xE
	bhQO7QzDgjs2fc836CQWrQz1rG59NUfLlUrcQunT9AUUC8FhjYTgTvkAi
X-Gm-Gg: Acq92OGjzpJuT8LxsKVLYGcHkiE+ZIpyxhHumLW9Tt8NAhnHk0/ApIp2ngwF5PgEine
	/hXOHzAEnY4SwHWgBbaZC1qV5brcBAdvIDTQdiO3zeurc3hTy8vUruE8N+pUSNu44jv3QHseurN
	AEkdoj+K/BWS/JTg81RrYl19UrrpUa/0Ij6SLFyzak5ps+9scCIXycrRTQQJES5iuWocjTP2iXA
	E+JynNZc9dx39mNwx9N21YVet6sGHPQ6PRFGwdEGSx9MHpKa3LKrFnXIJwCiW/pwXRm2D2gXnQx
	fYbhmg6/+r2F2t68cV194mcsurxezbf4L5W4aevYnpcUI1HMezF30g+1yJ+VkyRh4URfUIDJW+Z
	8s4r540lXkiiJbg==
X-Received: by 2002:a05:6871:c64c:20b0:43a:f95e:cf14 with SMTP id
 586e51a60fabf-43af95f4fc6mr297640fac.12.1779200656672; Tue, 19 May 2026
 07:24:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f98a17ac-9a06-46f2-af52-ba19ff0ead38@mail.kernel.org>
In-Reply-To: <f98a17ac-9a06-46f2-af52-ba19ff0ead38@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 16:24:05 +0200
X-Gm-Features: AVHnY4JTEbAFkObWnLp9zqN_Z56MEwxCFbwtr5W8XodOfoTLNTCCynisGwtwmxk
Message-ID: <CANp29Y6a2q+bn6zL1+R5Vac8Wa3tNX682WQB1s-aYAmyHS8syg@mail.gmail.com>
Subject: Re: [PATCH RFC] wifi: rt2x00usb: fix NULL pointer dereference in rt2x00usb_disconnect()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz reject

Syzbot apparently got confused by NULLs in the strace output.

On Sat, May 16, 2026 at 8:22=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> In `rt2x00usb_probe()`, `usb_reset_device()` is called early. If this
> reset fails or detects an unexpected device state (which is common with
> malicious or rapidly disconnecting simulated USB devices), the USB core
> schedules an asynchronous logical disconnect for the device. If the
> probe function subsequently fails (e.g., due to hardware allocation or
> registration failure), it cleans up by freeing the hardware struct and
> setting the interface data to NULL via `usb_set_intfdata(usb_intf,
> NULL)`.
>
> Due to a race condition with the asynchronous disconnect scheduled by
> the early reset, the `rt2x00usb_disconnect()` callback can be invoked
> even after the probe has failed and cleared the interface data. When
> `rt2x00usb_disconnect()` is called, it fetches the interface data using
> `usb_get_intfdata()` and unconditionally dereferences it to access
> `hw->priv`, leading to a kernel panic since `hw` is NULL.
>
> Fix this by adding a NULL check for `hw` at the beginning of
> `rt2x00usb_disconnect()`. If `hw` is NULL, it means the probe failed and
> the cleanup has already been performed, so the function can safely
> return early.
>
> Fixes: bf4c02d5e772903be5bf8952bac730a2956d0619 ("rt2x00: reset usb devic=
es at probe")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+e84ecca6d1fa09a9b3d9@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3De84ecca6d1fa09a9b3d9
> Link: https://syzkaller.appspot.com/ai_job?id=3D63946763-bd49-4c8e-b059-d=
7248e547b72
> To: <linux-wireless@vger.kernel.org>
> To: <stf_xl@wp.pl>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net=
/wireless/ralink/rt2x00/rt2x00usb.c
> index 174d89b0b..ea6ceb3a1 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
> @@ -858,7 +858,12 @@ EXPORT_SYMBOL_GPL(rt2x00usb_probe);
>  void rt2x00usb_disconnect(struct usb_interface *usb_intf)
>  {
>         struct ieee80211_hw *hw =3D usb_get_intfdata(usb_intf);
> -       struct rt2x00_dev *rt2x00dev =3D hw->priv;
> +       struct rt2x00_dev *rt2x00dev;
> +
> +       if (!hw)
> +               return;
> +
> +       rt2x00dev =3D hw->priv;
>
>         /*
>          * Free all allocated data.
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
-upstream-moderation/f98a17ac-9a06-46f2-af52-ba19ff0ead38%40mail.kernel.org=
.
