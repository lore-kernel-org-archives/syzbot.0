Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8DE3596E1
	for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 08:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773994574; cv=pass; b=aN5Hsh67C9cmTQaIksTQpuQT/eCaBI7pB1J5zXYjlV9nDMXdUy0ZgESDWouxcEhjDz9ie17Kyg8o7ABFNwhK9YedvfwwSHbb+bqS73O58p9664IPKLnxsErE7zb+7IclzGSFRzVdqNHJo14g/Sol9ToXq5QdJaVprwwX3zzvBso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773994574; c=relaxed/simple;
	bh=7TQyixHw3W1H0S5a+lgPSWMZwJAK+AMCJLpwjbVlJ4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AGrJA/LWwdZ7f6zgELLWZPM6ffZV7BlujU7jkP42sZSEfYDcloHgFTB1nsyFkhftjUHx1gqnM2C4IbXKO4KxGBPbeb51aBdLeiyuW3Q4lXIlwiaBYxGXybllm0ikAj2aWa70cJuifM4NLIRyTcaWsxDnXo0Aw0zWB8vlHf5arf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=quvT1Y4F; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="quvT1Y4F"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-67c250b84c0so128143eaf.0
        for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 01:16:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773994572; cv=none;
        d=google.com; s=arc-20240605;
        b=DLvBhu5PCjg2yEP/iUJ1pgWUXz+bEuZ6VZPcQ2Lqy3dTB3jVZTPIUQ2Uw1suOktE9Y
         8Nk0SQnbh3qJkSeok4mhmqZ9Qguh4K/OE74QKgFyBXgQS1MkT1tNrFaxf+By+OziuAjL
         xhebkrO2SCNLThPWFhA/rbm4qrDWYfVMNF3uhZjQJiJvsmSrHRodPBeZr10HSdDt+ACs
         QwDWuWJXhHgXYeKeCoFAP/JQmklzVnSFnnPxRUG4X+8fVlos1UdZbKHx94j9FB7UJBxk
         Vb4Tpxhd3NnsB063jQrhqTTDspo0Lnyq05Yevv+l48cZee0gSgVRjVlHuJIJW2xVR7zU
         5NIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KYlWJwh1rKPinup/zAWGU9gOT5weMKWgRJMQAkdOHYs=;
        fh=xPAt57yFowgjntDPnXuXQjtkcAzUpzyY1kaKS+JmGNY=;
        b=K9AbwAepybJXIdukZPrgMYg0uc9xu0KtrNaf8JvXUrjtSLF0TR/J6BUnozNowRPEOD
         3C/cqtUtKG6ZEaCP49pj1g7Z5JnmkcJC9jb4VYb+L4UES5fpUYamrMZKjA/JYazoPYVF
         D5u6Fww4saXt6bJxHvYOlMvxKsXgl9ZvPWy351mMFA1PhKsqgKuI2iHxDagQZbGwDgjp
         HjBLVEsdVNAjuchkg1zyEcy0Fjgp+e+91LR90z/nogi9AnOYdcQ75HdwLdhsrPh19ATH
         KKS7LqiFq2slkWhOffiCdZ5dIRPLfitQFJqEL2HVszeREsTZwIgo/NLSEKvRTnhUsoSp
         EvEw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773994572; x=1774599372; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KYlWJwh1rKPinup/zAWGU9gOT5weMKWgRJMQAkdOHYs=;
        b=quvT1Y4FBRYxAxsTT2jT38+OvuHBZ/GogZ8URaFD+biH0XzLHEoeWr/M9fLR5LyaAN
         cWCeusJxmYmH7pRSGgX3OdtNYvWYj9lp5o93a4mWrFL0nksm2fGCZpSMI/BZhdXdVKrB
         o42v4n+8/0OOWXMfm1owsa52pkuqjfaYbycy4t4aSY9pkOAnkhrMiyOBafj17gWsmo2Z
         +6o/TfvmsuELjEiIdy3O0wEZKEIbZro9tAuVXKgvn5wBdguOatZJt8SEWhK+ZkAPEfu6
         w/R8/5ugTjTEKMgSQqyrCE75B9vmELD3/cSfq3WWAeFPzW40PXprX9jE3zvkUItGJeBZ
         cjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773994572; x=1774599372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KYlWJwh1rKPinup/zAWGU9gOT5weMKWgRJMQAkdOHYs=;
        b=AFJI4lkO9iNVcsfWCDZpNlYpfe+kbS4JAUoV1A2ED9Xld1qv1UpN7PQPsd3NPcdhyo
         UC95VYy/TVyREXBLoRokVZiJQKBMif5bit6IfxiIqmP4bRXdoQYnfCU//jfRzo2e/0Xb
         6DYBprY8IyHFwOEyaLXbMzJz5Ebny7KGMxDxpgwBO2wwtypvn6TRlSaWf7jLRWmJb56T
         Ga4fPTgHRVJplheZFHlidRP+TTCkCdUEApMAb/g/LrJMDja9WmwevVitr3rl6wDAi1jq
         PxJz8fj1cGFu/M4zOXnmdLlJOTpNHvX6OwBNHsj8Ocat/R5mtQm48eaYbdCLisdzO1aR
         YZwA==
X-Forwarded-Encrypted: i=1; AJvYcCWpitPmlDigJiISpMAwEAM+yvoEJzwbdZc8qEip9vBgf/NO0Hyi+iqu3hQbsaZind1wtERLOzM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/iu4V35U9G/Zz4jiuCcYZnoAyTmwj/pMA3ni6pUKLF7NGeiMy
	iYF2ovDJ35nruozxsZE5sxRZqfehQFDrE85KhIZrhIEEX6tqE4svsuKj0hA/w2Z155n2C2bFtKb
	qrMLuU3k7AWU1ZjPll7/ECBIkfy4f7oU6eKVWxx+U
X-Gm-Gg: ATEYQzyr3YF+aSLl2KzgLGhlpAR6ACADJE7cO0/oEKO1clcqKY2iPUm4cLZeDTvXPMs
	Fv5uRrlCYLiqJ1wBsGTNQcX10hCYGURknO9gWC3i/XaCrANye1qN0UCskTm8iMiKmW+0yG0KJg3
	TWtW83voWrsifSclT73Uahty37+RHB3IAb1HpuEmsaAq6E+8uma73K8cOa1Zj+RVVtnJYcxkcJS
	EyveEP2VSK1KAqhlsNBbkZP5DPS2X9De8qNxqpLjASDHWu59Q8aOXFP9eYUIxkH9SquUGEC65C7
	N+nq2+8qdaHRWiYj0UgYhqQRkXtCDz+yUG4zfroWJXXn6lYhtDTHeRwjAKoYfnkHvwF0bdI0
X-Received: by 2002:a05:6820:1897:b0:67b:d3b4:2d7e with SMTP id
 006d021491bc7-67c22fcc1c7mr1523359eaf.68.1773994571707; Fri, 20 Mar 2026
 01:16:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69bcdf9a.050a0220.3bf4de.000c.GAE@google.com>
In-Reply-To: <69bcdf9a.050a0220.3bf4de.000c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 20 Mar 2026 09:15:59 +0100
X-Gm-Features: AaiRm52lACj9KDgVZKCw32pIdj3gOZzhOahgHeACjVysT28LWtuD1hX-h7mecHI
Message-ID: <CANp29Y6DGV-dU8fNkWHHixdesPPKBVQaXTm+i+eKj7wrhfwqvw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: exfat: add limited FALLOC_FL_ZERO_RANGE support
To: syzbot ci <syzbot+ci46232943661a65b8@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Mar 20, 2026 at 6:48=E2=80=AFAM syzbot ci
<syzbot+ci46232943661a65b8@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v0] exfat: add limited FALLOC_FL_ZERO_RANGE support
> https://lore.kernel.org/all/20260319043553.301185-1-dxdt@dev.snart.me
> * [PATCH v0 1/1] exfat: add limited FALLOC_FL_ZERO_RANGE support
>
> and found the following issue:
> WARNING: lock held when returning to user space in exfat_fallocate
>
> Full report is available here:
> https://ci.syzbot.org/series/a58a79c9-a4e7-40b7-a5d3-8d4da244a00c
>
> ***
>
> WARNING: lock held when returning to user space in exfat_fallocate
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      b5d083a3ed1e2798396d5e491432e887da8d4a06
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/6a43cfef-5b9a-4b39-a6b0-7d34bfb0f=
7b7/config
> C repro:   https://ci.syzbot.org/findings/87d27fd2-e5b7-4174-8faf-3b746f7=
aa18d/c_repro
> syz repro: https://ci.syzbot.org/findings/87d27fd2-e5b7-4174-8faf-3b746f7=
aa18d/syz_repro
>
> exFAT-fs (loop0): failed to load upcase table (idx : 0x0000fd4f, chksum :=
 0x395e47cf, utbl_chksum : 0xe619d30d)
> exFAT-fs (loop0): valid_size(150994954) is greater than size(10)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: lock held when returning to user space!
> syzkaller #0 Not tainted
> ------------------------------------------------
> syz.0.17/5982 is leaving the kernel with locks still held!
> 1 lock held by syz.0.17/5982:
>  #0: ffff8881bc75c110 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inod=
e_lock include/linux/fs.h:1028 [inline]
>  #0: ffff8881bc75c110 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: exfa=
t_fallocate+0x163/0x4e0 fs/exfat/file.c:131
>
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
> [dxdt@dev.snart.me linkinjeon@kernel.org linux-fsdevel@vger.kernel.org li=
nux-kernel@vger.kernel.org sj1557.seo@samsung.com yuezhang.mo@sony.com]
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
-upstream-moderation/69bcdf9a.050a0220.3bf4de.000c.GAE%40google.com.
