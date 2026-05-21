Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11189362137
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 07:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779349454; cv=pass; b=rtJK7ujXc1rYp3iNCa6GdV4Q6ZAylxT8cv+Bdn65XB8Pc+/9lNchArluAk54Xk1JowBprcg7SrqjKKNqwrb96Z8tRH7ScjHfmkhj0IeSS3VrR6NO2ky2qp+Tf5yLnvgl18701hPcBeiLGSMm/prVTGZUcgM3tF1vcL0xgeVLE0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779349454; c=relaxed/simple;
	bh=qk3xrGaFHkzYKKWsw9E5UnyeIMfYhOQa25NEY8N46pc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b6mwAbgGePIcKkdwOezqBbF6ONZ2/EFLCQXvbRLyMq7acEdANu1Unoa4Oz63jtLLwIa1noxMzUGIkI+2hqtUcfTGXn5hJUtsBbuivuoatxeLscWRhHmi4Pu8i4r/71Nqd7gN7etVsFCNwGzvMbwy5HyihMe0287MfAwyg4Mmtjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TPLNd89K; arc=pass smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TPLNd89K"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-47c7b282d73so3814692b6e.3
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 00:44:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779349451; cv=none;
        d=google.com; s=arc-20240605;
        b=lSWDMObnctn4p5JZog6Qa52qkcbIecIePkaL53yMHS0sA3wLNEd8wueQcQ6/DkNYG9
         f4XUoi7OQFcBjDg34j5UHLv1bOD8ANy7mpzC/Sb7l2Lvdg2e6ZeFUNCHPTI4Ldk5vg7d
         4ZRhqssaTwqPZj0RXiQAMY7ksIQxvqm4QJLloM/+w7BmXYDn6QILRfvVRuhdlPbVnuTT
         QputzEH9rmOV5fIW5sPQjAUrlS98PM9SZ5oVlx67OnTimXEUChXxIaKOXBULbDQgX6XI
         SnFWXoHw+3wzrzal/sd90FFsR1y8nJYfcKlKzV+t+JMxmisiXkMaqIidw9lBUqRNA2WX
         LBRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y/8wyR4E2hyn6DoucUgHWEiE9DF/3Q4khS1ROlq8xJw=;
        fh=4iAUvEWNm2ZS+uj3iShr5sAspTcr7/V6H4QETyni61E=;
        b=ks3i1c9wMN79SdGW5DOK8TYRtSB1vhTIrFjVjIKl8o+8/R3tq/M25psMupicjMBVgX
         kqqfqjQnwtBuRceqxUWGrdalJYAEk3jIY++TCh5gYM/CW8+GACoDHQtsuS2yNVTGlMmB
         TF5QPOaFYf+KCyMx1ghaGpSzZYvTnnIkqSvf+Cxd2rO2/hBHtpcgBxmFaGRuYe+r3/T7
         /u7oZ6pS1i49rF9QvG72+r2hOtXjIv2C5IphYuSJcLVI1Z5BY2s0sXUuPOdLa6R8kVJx
         bVjDRK31mqMXSSaDicXQThzpSuFhFZZV2obkHzG267CnpenJ21rVoPiTd2oGDmm91+9d
         0mdg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779349451; x=1779954251; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/8wyR4E2hyn6DoucUgHWEiE9DF/3Q4khS1ROlq8xJw=;
        b=TPLNd89K7ylQwL5jue3SJgXOwdyHy7FynkrViA/loxfPMT3FZbZtOxo3pSFXk6QA3o
         ny7Nu7k9LojsbrkDfNnAGTtTt/l5xgMFvUA66DhFT9dDD66HQtE8eSWtJOGpFm8rDhFV
         17sQ7FEp370TQzIglNVf650YZNmMW89qNMbwb5jQdkJwPtPWdf+w8SETZukArU2dHk+L
         A9ihwuo650FbPCXFratYCtvU8nUTcUoaph3I1fVfWM84qkgWDbiLY5tlrtYZUK4LS7WZ
         W5IL6yocSmUUnrJWx5/wbRt8bftFC5rbw1VJ/xFoeMDF2p08mUkKiU4ZoYF5DjK/qhlB
         j0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779349451; x=1779954251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y/8wyR4E2hyn6DoucUgHWEiE9DF/3Q4khS1ROlq8xJw=;
        b=ZHD+EGfaYjQg9t6bLfvIbXtSX6rKhFtDEwmla5KuDeIEUoYU3hY1MIPrYlODjGw4qu
         f2j7TMvJcXUQpoO+gCaGL9ODJvhI+fu70FshAnFUKuzox8LUETnxHWn8lgKbDCpMB6DV
         cTowNb/Puh9BLVNVkw3imynT75ERqtUsShcfjtldqybkJ1e7hl2wudEv6WNrrPSs8auS
         ws6OjUeKaBFciYhOgATs2TRVB6jB4rYPlkEPugwrrBY6eykdYMN7pMEEY0Ekl2yKle/n
         EPxk85oi/d/GziZqXCAUJYl3R/5FJ33rrXFljpMLh32mhnOp0a63BUK3X/8ksvUbMDPH
         5ZoQ==
X-Forwarded-Encrypted: i=1; AFNElJ+TVPx/a50i49JkDqt7i+aaxZ/vBjzFWgUzSKsIu2rdQv4sEIxjZ/1PtlRWSALMNoSiGA1zJxM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFfeoL2L+klxl+c5LkrUTFLIsSWUfeEZOseMSVyeS92wI25jWL
	OmKa5jW0gwZFP6ohMi/hEWmheqc07Xi8Htb8bhsBH89LreOZ8HS5b8w+UAZycTccRi/j9UlmkXr
	URrxTd5LW8yel8JznU+Y+0cslX5K95FauXrtVnxMJ
X-Gm-Gg: Acq92OHLTh/aM2FCREcR6yQdjJjKE23W58Ks0Tsa5IEf2zto555Ut3U0tROgIVYFiri
	sHtp2sndtT73eI8Ki0XuxAXKrFvZiVRI7UhGXjY9fx/RovPFfj8QW253NZC6FshACnNdbJs88sY
	GpO0FHQd52DHPAOqWlJDb9dWP1pB1fpkdNUw5sxiTY1tHZqy9F554FVU9k//mSLi/SXN3wMxkpz
	XeaToi/HmZ162oO88sKR80JFdBzRWkcSP1kq1WAcJq/AAxbwYVzcm9iOa3K686H9FFcYa/utwRY
	DmOLo7wngtqr8dWiTjEqYkjFrbeD/uAEKyMVW3CXkU+rMrXTOIVkR7Kz5c4rXIMfK378QUPMStK
	tDq3J/4UhdB6QVYg=
X-Received: by 2002:a05:6808:1211:b0:482:ab19:b1af with SMTP id
 5614622812f47-4852ec6ec75mr888441b6e.11.1779349450545; Thu, 21 May 2026
 00:44:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <b552544a-89cd-407a-845c-fbd83d6ba021@mail.kernel.org>
In-Reply-To: <b552544a-89cd-407a-845c-fbd83d6ba021@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 21 May 2026 09:43:58 +0200
X-Gm-Features: AVHnY4KgcVoGi3LjpY6DnZOGyYiV65E392U6AhLsLhlbug7FjiZ6-R1tC99COqs
Message-ID: <CANp29Y43Bk=mV09_QOZLr9EZcp-17FwcYscG5_tJkkBuJGnFBQ@mail.gmail.com>
Subject: Re: [PATCH RFC] signal: explicitly unpoison sigqueue in sigqueue_alloc()
To: syzbot <syzbot@kernel.org>, Alexander Potapenko <glider@google.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Alexander, could you please check if it's reasonable?

On Thu, May 21, 2026 at 3:22=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A false positive KMSAN kernel-infoleak-after-free report can occur when
> a BPF program executes while KMSAN is in its internal runtime state
> (kmsan_in_runtime() =3D=3D true).
>
> When bpf_send_signal() is called from a BPF program, it allocates a new
> sigqueue via sigqueue_alloc(). If this happens while KMSAN is in its
> runtime state (for example, when a BPF program is attached to a
> tracepoint triggered during KMSAN's internal operations), KMSAN ignores
> all instrumentation to prevent deadlocks and infinite recursion. As a
> result, the newly allocated sigqueue is not unpoisoned by
> kmem_cache_alloc(), nor is it unpoisoned by subsequent initialization
> like clear_siginfo().
>
> Later, when the signal is dequeued, the siginfo is copied to the local
> stack, propagating the stale poison. This eventually leads to a false
> positive kernel-infoleak-after-free report when the siginfo is copied to
> user space.
>
> Fix this by explicitly unpoisoning the allocated sigqueue in
> sigqueue_alloc() using kmsan_unpoison_memory(). Unlike standard KMSAN
> instrumentation, kmsan_unpoison_memory() bypasses the kmsan_in_runtime()
> check and safely unpoisons the memory. This is safe because q->info is
> always fully initialized immediately after sigqueue_alloc() in
> __send_signal_locked(). If copy_siginfo() is used and kmsan_in_runtime()
> is false, memcpy() will still copy any uninitialized bytes from the
> source info to q->info, ensuring that real bugs and infoleaks are still
> caught.
>
> Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Reported-by: syzbot+cfc08744435c4cf94a40@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dcfc08744435c4cf94a40
> Link: https://syzkaller.appspot.com/ai_job?id=3D2e44af35-fdc2-4fc3-90b2-1=
d6176362a03
> To: <linux-kernel@vger.kernel.org>
> Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>
> Cc: "Christian Brauner" <brauner@kernel.org>
> Cc: "Kexin Sun" <kexinsun@smail.nju.edu.cn>
> Cc: "Oleg Nesterov" <oleg@redhat.com>
> Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> Cc: "Thomas Gleixner" <tglx@kernel.org>
>
> ---
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 2d102e025..0ead5d607 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -48,6 +48,7 @@
>  #include <linux/audit.h>
>  #include <linux/sysctl.h>
>  #include <uapi/linux/pidfd.h>
> +#include <linux/kmsan-checks.h>
>
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/signal.h>
> @@ -459,6 +460,7 @@ static struct sigqueue *sigqueue_alloc(int sig, struc=
t task_struct *t, gfp_t gfp
>         }
>
>         __sigqueue_init(q, ucounts, 0);
> +       kmsan_unpoison_memory(q, sizeof(*q));
>         return q;
>  }
>
>
>
> base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patche=
s.md for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/b552544a-89cd-407a-845c-fbd83d6ba021%40mail.kernel.org=
.
