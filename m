Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6625D30100D
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 13:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780062937; cv=pass; b=H2P7HnxF8tiayl4MUJZyL22+5Now4vkXCXztxaNblhhYe9lAjmWGHUwdL11ifVcYFa5i9pVJCZTjF8LvS9nn1m8uyzPkANiaWnO938KIC0hzcJJ1ZK3YFIJkTs4BRTlVzDhfbaHN7l3VwMShKYeMZknY33wsbWnfro0lzeBF2i4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780062937; c=relaxed/simple;
	bh=KB6wk+sJHKkjJDUM6Gc15PzKQrbuhbxAKYuRR2LKCK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HRlkz/m+7/PKLiPdrPBCNJrm/dpsppJy6HgJXnAeExORg77AZmNIdIzTZt+ejNQPPaCXS6QtFp4l60ZSsjutQj3Ovj3IstvR2QMNzWbnk5/YDdNZflVdPWeDF8v6ZBrxcOFylCMlwE9bze+p4xjtlH3BybvoSdL2NgtsnLXYxwg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hbPH92pf; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hbPH92pf"
Received: by smtp.kernel.org (Postfix)
	id D3B1C1F00898; Fri, 29 May 2026 13:55:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.45
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1780062931;
	b=u/YgcLDLlt7Ku2a7m6hPdq6i/TSBY801uJ7075EK5+RNzWbo48s+D3CxaBBjfyC45O+W
	 k9eMYaqnhqIdU2mKf89+ku8tCw3NsajzQVhLLCzQUA23Ut6cEiIWjFOrlEXzePJARDDXX
	 ILRl2oTq+7fqD8Sdu+KDmQz6IeRmFpC2m+ZniCmjK+cqGRHwXuAHblmS9+THAdy/5GaRT
	 eSRYNATw7domH7iXToA+heWtDphEd+zra3cJjovT6ALMZvyB+86VtZRU4cQ6IXvkIa32o
	 ex5uOL+IVQi4lOZ6axx+KBe+V/+qg2byTCGvZ0qEjLdGm1OtmSE+p8wnIM6gmI9H4Xg==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1780062931;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=pwBfMxM1w8AKsgP1lVYfvn3RaEkRI/UmjXsnYV0WhRo=;
	b=LIDvl+P0E+w5pLxcLWNQBQTy+fW05YsvT3z/jTemBTKu8VZO+PH2gPWqgx05wR7GLg8c
	 tfDSQvsIqK3OgfdNUKD4x6ZUIGfHJIFm8vugDAsSDEJRyJl4GOIqurhG7ndL1BcMCY873
	 TjYjzKj4fwb5KfTKCjm6oBLdQdg2wljZuuOoAqIaJbc76y/aPkIf2aYnJ9TocV6favxLq
	 xmZzQTGJTTAihDCu8UrIBefdxKQR7nrdAL4C4W8sq5fvlSsaK0B7bMCEqcBTkYpgtNNYh
	 TydzC3YPRRUyyj4rDuY7+YkOPVr3D7BR2UmUfrFjLY8Dz1vPiDBtannBjuJBLXV6OhA==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=hbPH92pf;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.45
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3C4151F00893
	for <syzbot@kernel.org>; Fri, 29 May 2026 13:55:31 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=hbPH92pf
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 3C4151F00893
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-43b4dad80a5so5479210fac.2
        for <syzbot@kernel.org>; Fri, 29 May 2026 06:55:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780062930; cv=none;
        d=google.com; s=arc-20240605;
        b=YJbkjfwuo9G7r7scEW4ZIzTq/lxhY5wXCoYY9TrLfgtbR6hOGwSVf4Ic4ubcmcm0Ts
         d3n4CP0HODPiuTfx6WvX2EXR3VMQ9VUoZyKQ6UW3AbZsa9fch6IYdBkLVm02Gia2ZH6g
         Ho0TM2qF/F1/R5qnZXzvc2Xi54/Lz7huz1T8PJSjsKm8DWh0/yc+cxKJ135ZUsbyrvWv
         YvnLWGJgLIXe1FA1oFu4FhZp4X1mBqxpD3p8XAu1GFPloOch65G3UxSTk9LNYaX2Rodq
         WcW/2IepePPECsMSZP5dpwtpVCiTnvmDgiI0x3Ar6T3G364/x0rZ4wvriml2deAzn0+i
         0/Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pwBfMxM1w8AKsgP1lVYfvn3RaEkRI/UmjXsnYV0WhRo=;
        fh=ZdIFEji1OgyuQXgcoEzcmXuEqszblyCHGIjqUFa2lsQ=;
        b=NO7GYraxBMsPjhq3PAj0qFqVx+yI+8nbUwbSVVzCcmw8YO/y8bijHexkgQCCroiqxW
         /tRPhQ+CCphwtbGH5FB0b6qp0g0+NqP6PYZpKd4DsOuy1BWswHOd1YusHc1qK43avb2Q
         QYriukDbEFgUt2NHDJFOE6dFBDb79PPS46+2UciE7NdKDdfEgFzHObtfi5qeeu3vMhAv
         2Hyg9JYn4iOQtT2d8Dvpd5Z8Jo1ZNKpayj6FBYL7uE6a+UlB/oOGye3KwE8a5EzcvI1J
         pUwr+PjvTea9bo7wWzCShd/wD1yklIWQKwg/9EXf2gWGUBZpVsRWwqZsLHjx83vNgeug
         3+Cw==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780062930; x=1780667730; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pwBfMxM1w8AKsgP1lVYfvn3RaEkRI/UmjXsnYV0WhRo=;
        b=hbPH92pf808EgZZXq8O8Olm+q1F6UNT5RO1gQMy7dn8m0Hx9U8jwiC6g5q1xNEK2W3
         SeXHyJ2n9Ho19fdbUgFj5ryJa2fYE1h5EUmkpT1GvZXG3OI/LpYRacFDS5HfnUyxBxP1
         Hhjp5/JUgvcrEc/2m/NXZ7r5UBHUnGJSstxqg0v1jvqkz8RXCaBVXfa4VSd9aIIf9fPg
         Oe3jeYFJ54rIvQXZ1NNIEncLwoHjVzsL1Qtqt1PkRbvNjx+6R8S6amhwJ0NIKJfQBAUB
         lNSDxJDAn5RR4KWzPVC8aCk58oSx7c18vNw1RulFGEcvIZmufharly/SJmCM/94bvnjt
         1IfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780062930; x=1780667730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pwBfMxM1w8AKsgP1lVYfvn3RaEkRI/UmjXsnYV0WhRo=;
        b=W9BwkfgqEqjaPqlR5xAY0RBFI+iZIPEpfbLPoir7dvrqbVKTKmZL/mp7WbcL420M3Q
         PX0UmpJC/jn5jlShul9oo0uA/VDgWKAIkbxTSTZM7v8VhMVqLXJxBDLSz/aF7xhQ7soA
         Kf9QxdSOllTOfA9sO5UR9foc4sIAxIKte7NCGYAj9oS2Vs9q3r6vlt4ekWYkiABihnZn
         LpBEkmVSaj2bLLyWAOHJWHnRja8s8wMmai+zMVNvu0OO7+ogYzzwMVw8r1HUmllceXnF
         sVYempfIj27DdnuHdb57xNEP3j8xch9rICoI2fWqNwx/7opes+FUi5dTi9xvRa3t2DkI
         PweQ==
X-Gm-Message-State: AOJu0YxmeCJvjxHtFJg+zLjuths5dMsS+SvJUKsYENf+kzDlvQM9ZB+J
	syckgSNNX9kQWmq2+qKG6Ot45mZGL9eu4TAY/1z9yQuvKj5XPQwyMEvkKwKQoeqYusW7HETQ4hP
	4RLMh6gA7Vwyj0eyu9bgXn+0wy54N6216Htos/NmAxb/GUJjor4lItItb
X-Gm-Gg: Acq92OEFt1lhIaXcf5dG6OapGfnhioWm8z8gcrieZqdeZTiz9nmeQztE9Qr4swrx0LK
	Gh+I9MOC6SMTr9w+CjhBM4xSfbm8r/DiElt8sk2jU611rXS1ArosbucG0nbgSF6Dd/1CFy2ooXx
	Rt7mSP8SMhAbONislEI1fwoLw8GUIiLiZ8keSBq+i4wthaWUMUFV51s4VLBpO3gzlHBTQy1Unr3
	LRiz55q2XcSZJtbCdJP4V19PSt7EDXSH0x6TS/j+9cGNDpWK1ri9xGZ4fZGOtEwRhQbMvN3N1cE
	rY9eiGgdrP+bmFEhje6iKYlUXwNnP+UlJo5RBr0hYK57fgA0KJQbBYwV5RPxAcfKXyBPdzS82Jg
	OvG/0oMu++QEg06A=
X-Received: by 2002:a05:6871:4707:b0:435:25e8:35c6 with SMTP id
 586e51a60fabf-43c8c57683amr1309788fac.23.1780062929720; Fri, 29 May 2026
 06:55:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <dff1dcc7-59bd-40c7-981e-bd805ae6b3c1@mail.kernel.org>
In-Reply-To: <dff1dcc7-59bd-40c7-981e-bd805ae6b3c1@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 29 May 2026 15:55:17 +0200
X-Gm-Features: AVHnY4LULtFHOOUscAE6h3Ha-BiFp25eIH81ac_biAMPdB6h4ljczjsE3dFk7DE
Message-ID: <CANp29Y7ja8YqZPQ2V5LEz3Lpgjpdo0b2BO3ghc1pwhSRBhe3cA@mail.gmail.com>
Subject: Re: [PATCH] firmware_loader: Fix recursive lock in device_cache_fw_images()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please send the patch again.
Don't change the description or the diff; in the change list note that
the patch is resent to follow the rules.

Now the sending mechanism will automatically set the right From: line.


On Thu, May 21, 2026 at 1:30=E2=80=AFPM 'syzbot' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
>
> A recursive locking deadlock can occur in the firmware loader's power
> management notification handler.
>
> During system suspend or hibernation preparation, fw_pm_notify() calls
> device_cache_fw_images(). This function acquires fw_lock to set the
> firmware cache state to FW_LOADER_START_CACHE and then iterates over
> all devices using dpm_for_each_dev() while still holding the lock.
>
> For each device, dev_cache_fw_image() schedules asynchronous work to
> cache the firmware. If memory allocation for the async work entry fails
> (e.g., in out-of-memory conditions), async_schedule_node_domain()
> falls back to executing the work function synchronously in the current
> thread.
>
> The synchronous execution path (__async_dev_cache_fw_image() ->
> cache_firmware() -> request_firmware() -> assign_fw()) attempts
> to acquire fw_lock again. Since the current thread already holds
> fw_lock, this results in a recursive locking deadlock.
>
> Fix this by releasing fw_lock immediately after updating the cache
> state and before calling dpm_for_each_dev(). The lock is only needed
> to protect the state update. Concurrent firmware requests will correctly
> see the FW_LOADER_START_CACHE state and use the piggyback mechanism,
> which is independently protected by its own fwc->name_lock.
>
> Fixes: ac39b3ea73aa ("firmware loader: let caching firmware piggyback on =
loading firmware")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+e70e4c6f6eee43357ba7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3De70e4c6f6eee43357ba7
> Link: https://syzkaller.appspot.com/ai_job?id=3D8cbf9f7d-812d-4db3-89fa-0=
aaef3ce3a2f
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
>
> ---
> diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_=
loader/main.c
> index a11b30dda..c96312ac2 100644
> --- a/drivers/base/firmware_loader/main.c
> +++ b/drivers/base/firmware_loader/main.c
> @@ -1503,9 +1503,10 @@ static void device_cache_fw_images(void)
>
>         mutex_lock(&fw_lock);
>         fwc->state =3D FW_LOADER_START_CACHE;
> -       dpm_for_each_dev(NULL, dev_cache_fw_image);
>         mutex_unlock(&fw_lock);
>
> +       dpm_for_each_dev(NULL, dev_cache_fw_image);
> +
>         /* wait for completion of caching firmware for all devices */
>         async_synchronize_full_domain(&fw_cache_domain);
>
>
>
