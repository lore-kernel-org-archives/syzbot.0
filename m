Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5F7409601
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779201354; cv=pass; b=R9TvDaSbhJe4klJlRHcUKuFBmNJXEWVZ0+iaYJp7aFan60j2J6fzc2+H9w2+61TcPUFVwh8YTKd/9zH4eq69S6WkNjHZFqk2z23GxuyVD8ofqDa0F2wTxiOFqwhnaD6qbZmpSHFLDTwyULrBED27YXVPbwMyaQi9YqryaePcuqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779201354; c=relaxed/simple;
	bh=rbxXNmpAc5lyEtTuDXm+NFxgdeZXn3v5hFpxRBl1JRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XNAb8z4VhOSUSeV4wvkCnzqKj84PA8YuX0YfDfn0H1F9L0+OLVwVFhxf7atyn0Jcpy/o3pelHldVwIvG3POfFx6WYMQPBs20DmaPQgAH3lwOmQ7Hk7rB2NTMkUK7AFGJV9k/tt83eS5jkwrKF6kCHS1PobyuIjsDm8xr4sAHxzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SHriA9s5; arc=pass smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SHriA9s5"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4043b27ddeaso2190175fac.1
        for <syzbot@lists.linux.dev>; Tue, 19 May 2026 07:35:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779201352; cv=none;
        d=google.com; s=arc-20240605;
        b=JxlQWbN1m5xfnnC5gic39no3UuADukou8aU7J1FldRnARUcOs3aJH1gP7s/AmbTkPq
         yTN/VOJyi+TiAO+N8sI7yxwvhrJEoietMEfwL8zVX/KgW4MWRNwZcC54zMxCCRZ5XvSG
         rpVDBQ+aALT9S56POWoJB+iMJmC6kJI/0IC1p40kAzlpvKiyBiJ2fX1jAcjFygG/CoNu
         BUjTirD72+sJBDFKudsWmKhapsSx0ldPuWJQqWN6Df3YBdr/b0nNnjsb3L/M+Y2M7hpB
         mhXLbC22iQwEg2dsj05m3KFqrEuOX39EAeN9t40k8mTaB39Husiehv2/uj3ed6Pm5quG
         WGNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UjN5aQSx/GSPVzw9zrncqkCqjjzgWsIojnx6D3NDYaU=;
        fh=1uQ0rV3CkYlR1Ns+OJZXxSHkp6wiW6xuN+hrFK3Fba0=;
        b=ZJn3vfYTtlyBu1tv8FVa19MNcx8l0KNVqAt/yIdfak0tMMrjXoN+MGC5d1WWFHK4Yv
         ZKLD6frgXWQJP/ZtdfNbbTV0Gy4RHeHNUoIEhStoOi+HMeLArWAU+LotvsifzC5lcCRm
         Fwc16VIRF/bbNRBPWhM3ZpUVjFSir7k1Fwu95kT7a1W655JB7QRk60701J3k1SCEhLFD
         +R+MuS4gvJnNqd78I/BDkVRgcqm0x2KspWYY7N9LfuGH0xXe3EYz0D3yKEQMN/4rDXA0
         9MofF8EdZI8k3Urf89vArCPyIKV+iEIGpWwwOidh/fJ84ZGCeuuszq5qZHtQ3bspOpeI
         7B1Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779201352; x=1779806152; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjN5aQSx/GSPVzw9zrncqkCqjjzgWsIojnx6D3NDYaU=;
        b=SHriA9s5tp6wukoNhB22Fwzxzp9l/Qg7114Q+wGNk1hec9qZ1bQM3OxPkU/C5rYkLf
         vR7l4Hi1McC1K1TJMUNDECTAGa9LzBg5NFpoppKAi2s24iAAaSDCC/mRokdsaVdygyz/
         1n4Gf+Ykf7euASpS0nmCpFe0TJWghLTYfY2zoHcA+LvUyHzNI4KbiZPHKonVwmj7k6vo
         iUzg54IFYCjHmTv7m/IloN2joPFaKLwDNmwQE7cRcEbc7zQ7sR7uDw/923QMqDp25cJ3
         o/rM7tFMgc3krI3RO4jUu2r70kJMI3xYX0mI/BHPLCyR7ME8wr6hT5CSNIbdcnIvpOVB
         oMsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779201352; x=1779806152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UjN5aQSx/GSPVzw9zrncqkCqjjzgWsIojnx6D3NDYaU=;
        b=ePPup4wMjOf45w5UGb1T8C48laTbScvzqfyv/no3UDgbdHmzKVTb+qLYgNkSULHtcX
         8TqHbS6iuJUurOob271491lP+CYR9fWTefIr+41d1x9D2BxO7jLozcppltQAJIp7gRLj
         IOamAYZuAFnS4z+wziRg/7SrhJrKTr588aRTKTG0Wg2F/yQSoiFUvEO4jXUsn/CAet1S
         pT/eU4k6x3fOPYaW8bkKUCqL3SAx+ULJlpwds8hW8IziFBD7JmDRyb6tIG9Olrknjfq+
         Af2oKON476c5abiU98EpK5W7JNmpILtS4jwmq/XQasWSZJfmBdJKmiq7w7rB97xjc408
         mctQ==
X-Forwarded-Encrypted: i=1; AFNElJ+nYmXJnMECNY0ppPnCbPx6cYC1Sw+Y54Icno/gMHUknnGv1bvLnqYRDrhFl4IHmvRZ71OMYHA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnWjW98o+OggX+ISoWUAVCcTylYOXbzxv2QUNmi0CfmUxhLR6m
	5TUxzvCi0y27KFRjhB3C8I2Ho903iqKupbfV715xim2wGovThgVaMqVNyH9kYdrkC0+7pIESC+U
	MbmiqTCIhrYks7S88b1d7DyF8U4dwkae4Yvjj28obeoYDHDJN1l1vUZuZoG4=
X-Gm-Gg: Acq92OFqVoiQun6Mp6Sj5QoeYmYvUbXzWq5HcUAMzESQh8OSaf9zfX74xeN3zN0y7IT
	Vgq3Q7qVJh/9e0m7Ta7Lm44UTQdpO5yapRJEyPMBgXbr5Gh3udu/6YQ4AMst4+mfX76mX9uc0Re
	8qoqPh+gYuOCSH9FgCIAkWuMfzOaNZRrad6DaLuD+vNjeTGEeOX2s38QcsdzZK9nL/vj2mkyLCm
	BX1uiW+spKPxN3Lj1Nhe9eynByclfRKUzt8UVq8GBNm5KxKSja030+7eL5kwaPXh28MJ0tdk+d7
	wk2j4zHOcDaRhmxalxvwQlmvcKJmLUcEQZnJDQx34jC3f7vAm1BI75aTBdBuGq+5uFNYQc8ilLY
	mE7QkCf47VHcGbw==
X-Received: by 2002:a05:6871:331b:b0:409:5560:72f8 with SMTP id
 586e51a60fabf-43a2d48fc2dmr12103231fac.0.1779201350531; Tue, 19 May 2026
 07:35:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CANp29Y4EZ-L0hzAybhcU=qS0vUNuejVMzZRzoQRyJQjdtWvE=Q@mail.gmail.com>
 <d2e21234-5532-48b1-b042-1fbe9efc7d30@mail.kernel.org>
In-Reply-To: <d2e21234-5532-48b1-b042-1fbe9efc7d30@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 16:35:39 +0200
X-Gm-Features: AVHnY4ITScRGflzt9NJ1LPm6uKLnMgfoFgX5w2iKSAt24RMgXrchS41NNo13RYA
Message-ID: <CANp29Y79CO3C0Fx44QyVVcK0fACMKJJ8UT4djqPeRN0qAj_Pjw@mail.gmail.com>
Subject: Re: [PATCH RFC] jfs: fix slab-use-after-free in lbmIODone
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev, 
	Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is a fix for a different crash: "KASAN: slab-use-after-free Read
in lbmIODone".
The original (target) bug was "UBSAN: array-index-out-of-bounds in dbFindLe=
af".

I don't know if it's a flaky reproducer or one of the issues in the
kernel got fixed in the meanwhile.

On Fri, May 15, 2026 at 12:33=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
>
> > Did this bug really exist since linux 2.6?
> Yes, the `wait_event(bp->l_ioevent, (bp->l_flag !=3D lbmREAD));` logic in
> `lbmRead()` has been present since the initial git commit (Linux
> 2.6.12-rc2), so the bug has likely existed since then.
>
> --
> This reply was generated by an AI model.
> See  for more information.
