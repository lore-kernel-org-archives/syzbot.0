Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6E03382CB
	for <syzbot@lists.linux.dev>; Sun, 15 Mar 2026 11:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773575603; cv=pass; b=WczMgxVw/hBusbXiUVIXnZf+k7SA08ghLpBEbdBHu8/pFAYLLdVBPvpl1NZq4CbRl6iZ77K0ai7Tmty6Ii6R7cymEmECNJSJHUzWfZczWvSZVD14PDIX6tEl7MCuWFLZfotkz4scoW4dKzNq4xGNA/hstxppFSet1TX7V/RSOOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773575603; c=relaxed/simple;
	bh=p3mi6nAwlo+2xlqyM8fWBhlYNq1PqGqmIBaILUoRp7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=clUucohscOSwOsjZ2+xZsXz9dKMAyuUBrnk76hTu2RHpqqxiTwnUDcAe/zPLgmToMjFrIHGF+aDc+nQWr/EvhR0WlMMuONTOV9XHFy8SZtfAQ7wLrPlKEf61BZ5yzjv6fMAhpFVCs9nIF379XNzfo1HrhrEovzjylfqdqctdIos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ciOB7AVD; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ciOB7AVD"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d73ccee442so3961181a34.1
        for <syzbot@lists.linux.dev>; Sun, 15 Mar 2026 04:53:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773575601; cv=none;
        d=google.com; s=arc-20240605;
        b=VDiJh4A6fvbcIS9msMkt6YmsZkrNJovUH4YHvciVdcjo6hpd9JDgxsscEL2kNEE9WD
         7gkJ7LGdqll14yW5wCR11LoflxtXeFwKeKDI2+n++tg2AIItK5uKotQJUVHpgGYnstjM
         GWQ43Qn+ntcUVVNLZEg+C5PouomP6zNdeUtx5pWlLZsD+wMW1rl37o8pjYDNiL4Qss7d
         XOdOOylZ7UHWBt5JVNTuvkW4zBnevRbYX3rFFmy1CkFcNNYjuGQvuiOfJO0ZzFarYfuv
         IrGsC6e3XKIKxVKIKgpofZfBxVTKSGEwpWmT3NQdXRjz7Aqh8hq3/xGpSrbGmJck2Qxf
         7Eyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mss90vrk6X2mP0Md5mjB0h0/yogTKLYNDS3TUNajkiM=;
        fh=9/UaWrNIMYmqVGdoVK1u3JWhjRDOt1Mz3qp3nQc0Imc=;
        b=HTmxfEcAU53pYn/eceJ2PN2cY38o96gCIbuhq3tBItOJCQepM1d8BM+3NXHVo/2QrH
         hi8eZZWnXr+QLwQYbPAIYfnPPxv9jkvcUWWoK7Ka2ia3A8bCn2nci3Uv/1aSm63EEuXs
         lzxDbglQr/AWdeQ9uXes1Y+QiZ9ftmBoGNi1ziA4T1k9gnHAU70AXFaNbNN4vfh4T1l0
         NOAFPeMuxRdyLjY9ADQku63Wxf7J0cb/1cmJes5yGvg5b4N8RULR7ka3EZ3rt+evDkQ2
         fJIPO24Ju9Aij6GakVW3BAcyQzYhC6g7hooE/5cIFS+EPkV546u73Faak4FMaDV1O/hu
         r+cw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773575601; x=1774180401; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mss90vrk6X2mP0Md5mjB0h0/yogTKLYNDS3TUNajkiM=;
        b=ciOB7AVDcYwiCtPcVne30fGgLE79OkEaFe+sSyTYD6re2RTNF/xL1pjgW5pF2Izi6O
         rUV6cbZ2RzC3rf66xJIehJFDXKGACYJApRn1JJmjCsk8guX/Bw5fq0B+ZCucFtFFuMUW
         uno00cAIJWv6OLSi/RS/lCHjomInkJQp3J8yjj3NWfRwn80FYD5sEw+1yctKS3jQ7re0
         rgYLkURJrXdUZDIRt4xRd4IizZxae3zrkPNsp90NJUPNOOPVB3NuQutfvpYuCa4D4ZUc
         KlAzqUZwKp+k4r1AEYtNORdLC3n7Mo+kBvs3CwaaEjn12CfdMW65Fm27CDTazXQu+k6/
         U06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773575601; x=1774180401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mss90vrk6X2mP0Md5mjB0h0/yogTKLYNDS3TUNajkiM=;
        b=RC/W1mk2XVveI+Q7d2brgjV1rqoPLU64umWymMoJjHjXeXhOAYUuDgwgr/9yWx0A/w
         7O+dQ8rT8Ewwi8Wde8V2EEcWXQns+spPB8A2wW8WkxPKs26iQQy8LGVoq0lqFj2mzCAf
         +/fcPetvgjs93SVowWn20slxP5EHrk9MXQQIZwfnYs2gktGxpQsIA7vMGuKPJAOp8ln+
         7Yh/kquZDU64HGF03EHXQTLMGEjJ7cJB9/AbwLNh9LAiPzN/PXZzfIoOCUpN0xOc1K+S
         iYRQ5VBcyLsGgrVE9DsoI2OrHSazO+orPLe6vXR/P3giqwKTNtb09Fx3oqlCnFyblLur
         KqIg==
X-Forwarded-Encrypted: i=1; AJvYcCVuKprEb8M67wDrHl1AWa7ryQaxDE/POoUiJbXz93GuVLM3Faw6pQy7q7vk4PGa0dOxPWCG9cw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw81HcP5JlO2UkJUgjan3Qh6n53KIOE/G1D9vTkMK7CDF8BmNc9
	GHqEDrGfkSPVgb+f2T1tGtWKk8YBx67WswQjGwqY3CcTiX+0tfrLPeZwg8TYeSpqGl9pZ8vFrrK
	u0suVrm6+q5ihiL2h2BatiQjySrhkOKQE0xRmgKKJ
X-Gm-Gg: ATEYQzyXQwsBcAAMe4ta+yR3AgbOYdBHittRjUjEpHd9glmXox26A15iu6qCib69/YF
	eS+RtdU18TLk7uisOqZTdoJlam3Opo7PTmoG2EKHaDL/xaq1lgBRJlV1eg90EwDF1ShTulffPoy
	Bs+p3ZTw4kL6fRtvxl8q1Nv2RYzKpMnBx8tIDLR+JPMQAx/ETVajkla4vLAD5Qm00MfGljJqNjQ
	9TGco7boFqw8/bhl9yS0A7Vqsqaige+1I3pbukDQD4mAPvFbnNuTMusJnYkUl9gEa7vYMizQaVH
	HShu2i3y5phf/2cV7UXSJ7iFGuHllr7UtQ5Xs3hG9lUBzk8UEaCW2hDic5BDk4l1W7v7w+50
X-Received: by 2002:a05:6820:1c96:b0:67b:f380:497 with SMTP id
 006d021491bc7-67bf38009c5mr2059834eaf.12.1773575600422; Sun, 15 Mar 2026
 04:53:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69b5f8eb.050a0220.12d28.014c.GAE@google.com>
In-Reply-To: <69b5f8eb.050a0220.12d28.014c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 15 Mar 2026 12:53:09 +0100
X-Gm-Features: AaiRm52DQyEpiDrEbgYakVmY_G11TcCPV4j0xHC5n9rRjMxoNHdY9F-gRo4s-NI
Message-ID: <CANp29Y4k2JMEYUzvXVXfZxvLBOxkd1m+4ShLp3HP_TVKhq8SyA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Remove inclusions of crypto/sha1.h
To: syzbot ci <syzbot+cicc9d4ccd6ccced34@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Happened when the system applied the patch on the given base commit,
so it looks legit. Upstreaming.

#syz upstream

On Sun, Mar 15, 2026 at 1:10=E2=80=AFAM syzbot ci
<syzbot+cicc9d4ccd6ccced34@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] bpf: Remove inclusions of crypto/sha1.h
> https://lore.kernel.org/all/20260314210810.67348-1-ebiggers@kernel.org
> * [PATCH bpf-next v2] bpf: Remove inclusions of crypto/sha1.h
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/38f41420-5e88-492b-9239-7c260178aa25
>
> ***
>
> kernel build error
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      1c9982b4961334c1edb0745a04cabd34bc2de675
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/b5327796-0a46-46fc-a192-f0dbd20d9=
047/config
>
> net/ipv6/addrconf.c:3341:25: error: variable has incomplete type 'struct =
sha1_ctx'
> net/ipv6/addrconf.c:3344:13: error: use of undeclared identifier 'SHA1_BL=
OCK_SIZE'
> net/ipv6/addrconf.c:3369:2: error: call to undeclared function 'sha1_init=
'; ISO C99 and later do not support implicit function declarations [-Wimpli=
cit-function-declaration]
> net/ipv6/addrconf.c:3378:2: error: call to undeclared function 'sha1_upda=
te'; ISO C99 and later do not support implicit function declarations [-Wimp=
licit-function-declaration]
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.ne=
t ebiggers@kernel.org eddyz87@gmail.com haoluo@google.com john.fastabend@gm=
ail.com jolsa@kernel.org kpsingh@kernel.org linux-kernel@vger.kernel.org ma=
rtin.lau@linux.dev sdf@fomichev.me song@kernel.org yonghong.song@linux.dev]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/69b5f8eb.050a0220.12d28.014c.GAE%40google.com.
