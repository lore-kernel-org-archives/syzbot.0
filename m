Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0750E348C47
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 07:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779350194; cv=pass; b=R0DLVlq6k8ezzfzDlSToy3AQGY7w42y/gfqCOr+4ShB4Yrkp6Fm5lz/0shnonH3e1NSxBAYE4gzhsLVhZUIondjWLqevYprYrPIsYEIXmyBZhvw64a2F4IBR8Rmiu5w6/YRIgjJHGE5wj6tnq8hBHZBlqazMVI7a++yx7FDbuUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779350194; c=relaxed/simple;
	bh=ZrFNKapCFFkx1BbS1Qxc9aTbMEjTW63l27OJOF5P/lM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JJxx2BZ/Q3l6oUi8DxOSjKMndLooYm4yLWSyQsgv2bUXTMycUYu221SxFxTGJb0oXnVN1Rr3d25R78rdu/rqpYORfedwaiDiTxH1YtWbGo6ZbeEWuvzZqgPHCP31AxeJIDKCFKuzEgM2NBFXPqP2p4cXZanxscwMGv+Jj+Nvzog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mNsXRNdT; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mNsXRNdT"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50d87c138e1so64129671cf.1
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 00:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779350192; cv=none;
        d=google.com; s=arc-20240605;
        b=HS8yMaLDempmOEacxtsIo868OPIciUkBfX+K3gj3+Nb756PJbY7C/D5KNLoGUk98D6
         8VCWHEH1VK1UfGMHkrTr1sJ5PPGyhzijvPeORh+1qtTlfrWqh4f9ihO6lahRO/Bt3xSq
         H4rPcs49eMq8vse+OUsE7i9F5YxoKma4sARRdR68z/3E2s0655fN6IUQldxR77GgpFnc
         ZgK0FWdxYsldIKlB2/gv4UCvaSVyyMFkLIg4VVZYqmfhOILFItMY5dIQNyPdrpQ0eBc5
         5NHtHKEw85q78ggHHfCqI888ewkuZNpcwSlipBKBeFvwwYwaWnTStKD1US3v2YfYZI26
         SXGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l6dzjPb9v6rF2RK/ksscSJvgqG4isO5K4S1Tpj/a4nA=;
        fh=0TKvKbMR6N2wDqUwzpJf3SV5fL9W0oDXm6JSCs+l97w=;
        b=Q0624nSIN13cdiTLBIFHWz6CZvbeiHgAo0PtugybPCHpE6cNjb88Q3mADEULEC46nR
         OY4Ng+TtiF1CtADtzb+JO+gML6x8x3AVxjm5ICgfEY9+hovflWUZQueLLbb+zwmh7l7d
         zbZxXg5j2VM9ruGDPy+zeUHG3psJjxSg7gyaZgTpUf3HwfPnVET2B8Ah+XDIfcTc9kkm
         pZ0fIglNn1cInCiccIZk6/mA3emZ53S+g2tg8Cxo2xd/Fxt7C3NVBa6jNYmAN9+mQY1t
         5W+a/Ytp7QYkvHQ9vhdeK29zDvzrIntic/t3LDN4BPwcRrP7dS/2mQ4Mdj6AxETmMM0/
         b74Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779350192; x=1779954992; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6dzjPb9v6rF2RK/ksscSJvgqG4isO5K4S1Tpj/a4nA=;
        b=mNsXRNdTjWtjL4JbBnfcyCoxS2msbpSt6aWMEXz3mv5hCcQGeTm6xN9VaOw+yX4loL
         Xtb3YWhvucgt0AYjWPgL6CIl82evSQZj6N2bPmKI4Ul4LT9PwdlfHN3StPZmGDd620ak
         YYRLJ4soNEs3GjLEeuEyYMMbL9T/fxxHTYupTdQa9qiR+9BOZf3h3R0fIeEru7ooUOGN
         Y6YnI66UmCwGNbH7ypyliXFyTBQ+rL8uMwrDQ/K6X2+4+521kOnmsKCd1wc/wvVhJ5NR
         EX4v4XINDOY86qCMIv+m32XfEcrw7UexUFqHGvlkLZ3jIDyt4/jckuANHhKOb/TwbAEY
         Zbxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779350192; x=1779954992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l6dzjPb9v6rF2RK/ksscSJvgqG4isO5K4S1Tpj/a4nA=;
        b=AGvMcJMr3dG65ACemDdFFxIZ9ce0WwRBXOKS1OcQ4iC2b6Y3R0ukskOwgsyDf9WUlX
         K6q3L/g/tNgAnBFBPLVKtUtH/QWA9pBzMlDOcfIIHyyHNA3yr/UaGN2nnteU3RTsq0jf
         3X0yoV58OInlsuFJnMfxTtK8l/65vf0aM/zUOhe2FCfwMQ+1nGpezYxNyVaMFyU/NxnY
         0bgX0tH00NbN65KNQ0jwQTvUly4aTWX5taixv+OR3Lp0psa3NNOHycpH0lLcI5V/9Hdm
         zk7np3xLIZXfBoe1+V164ewgutXi9dtoMK8mC/w3/SjRYP2z6Q/6q5Kwb9h22dkKvBtB
         9/8A==
X-Forwarded-Encrypted: i=1; AFNElJ8VmOOXrprRt9kWORemJwp0/+nUhLIliTA3QNVOrula3ORqEOUQ5WdB9EBmD2gqyM9/c9RHCTU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTnp3Bfx75XKV8g06+WlHMCnon0tLWTvSipKSoqLm5PKH98OR+
	ptHkAWErE5IVUektm/3Z/MmZ/+5qhsLZU6DLOHfaQBlmmnLf6XKM0TEpLloUYReZRTFI6NXGHm5
	hCp4T8RETaeFVaPc1C+yZPRAUfQ5VUvV2Og8ncCs1
X-Gm-Gg: Acq92OEPE81O4EMxf2qAKhHT5VW2jzdch6yaE+f74jtGbrhcdDh0iipQ3M2BLIUORwx
	pdaDlqrLCA1hFKQxffYOXyolAXzSn1lMjk8XypDq6I2D5QpVwjHR23obPLxFwIkqOHi5nik5CUO
	GYg2f02X7CiPoexEZUA+K8TjgEB6jFmT9Li6U2RPHA2BRKjBvep2QSsYXn25+P5/n+dy3Hr3306
	mGqOt0xs26/kC+w9EITt76JHRmeMifs9K/Gbydk14GkcoCueDXtGrr8Y10nUSrAUlumv0p8ErFJ
	joxNelguWaSLljcOj/Qvlg6O6wbtBY76Ty8I1fxktJ9toNM=
X-Received: by 2002:a05:622a:99b:b0:50f:c36a:381d with SMTP id
 d75a77b69052e-516c553cbe6mr24672721cf.29.1779350191346; Thu, 21 May 2026
 00:56:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <b552544a-89cd-407a-845c-fbd83d6ba021@mail.kernel.org> <CANp29Y43Bk=mV09_QOZLr9EZcp-17FwcYscG5_tJkkBuJGnFBQ@mail.gmail.com>
In-Reply-To: <CANp29Y43Bk=mV09_QOZLr9EZcp-17FwcYscG5_tJkkBuJGnFBQ@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 21 May 2026 09:55:54 +0200
X-Gm-Features: AVHnY4JpxUuG4i01z3bQy59HUAv2AAUyPlhPC5N_k7rRvcTziJ4z9syzudOvDs0
Message-ID: <CAG_fn=UrK-Yh=UFWPksxDcef3L5-npyqvvC6n+z9dY4T2BpCJQ@mail.gmail.com>
Subject: Re: [PATCH RFC] signal: explicitly unpoison sigqueue in sigqueue_alloc()
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 9:44=E2=80=AFAM Aleksandr Nogikh <nogikh@google.com=
> wrote:
>
> Alexander, could you please check if it's reasonable?
There's an ongoing discussion about KMSAN behavior in some corner
cases, so can we maybe hold this off?


> On Thu, May 21, 2026 at 3:22=E2=80=AFAM 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
> >
> > A false positive KMSAN kernel-infoleak-after-free report can occur when
> > a BPF program executes while KMSAN is in its internal runtime state
> > (kmsan_in_runtime() =3D=3D true).
> >
> > When bpf_send_signal() is called from a BPF program, it allocates a new
> > sigqueue via sigqueue_alloc(). If this happens while KMSAN is in its
> > runtime state (for example, when a BPF program is attached to a
> > tracepoint triggered during KMSAN's internal operations), KMSAN ignores
> > all instrumentation to prevent deadlocks and infinite recursion. As a
> > result, the newly allocated sigqueue is not unpoisoned by
> > kmem_cache_alloc(), nor is it unpoisoned by subsequent initialization
> > like clear_siginfo().
> >
> > Later, when the signal is dequeued, the siginfo is copied to the local
> > stack, propagating the stale poison. This eventually leads to a false
> > positive kernel-infoleak-after-free report when the siginfo is copied t=
o
> > user space.
> >
> > Fix this by explicitly unpoisoning the allocated sigqueue in
> > sigqueue_alloc() using kmsan_unpoison_memory(). Unlike standard KMSAN
> > instrumentation, kmsan_unpoison_memory() bypasses the kmsan_in_runtime(=
)
> > check and safely unpoisons the memory. This is safe because q->info is
> > always fully initialized immediately after sigqueue_alloc() in
> > __send_signal_locked(). If copy_siginfo() is used and kmsan_in_runtime(=
)
> > is false, memcpy() will still copy any uninitialized bytes from the
> > source info to q->info, ensuring that real bugs and infoleaks are still
> > caught.
> >
> > Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
> > Assisted-by: Gemini:gemini-3.1-pro-preview
> > Reported-by: syzbot+cfc08744435c4cf94a40@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Dcfc08744435c4cf94a40
> > Link: https://syzkaller.appspot.com/ai_job?id=3D2e44af35-fdc2-4fc3-90b2=
-1d6176362a03
> > To: <linux-kernel@vger.kernel.org>
> > Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>
> > Cc: "Christian Brauner" <brauner@kernel.org>
> > Cc: "Kexin Sun" <kexinsun@smail.nju.edu.cn>
> > Cc: "Oleg Nesterov" <oleg@redhat.com>
> > Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
> > Cc: "Thomas Gleixner" <tglx@kernel.org>
> >
> > ---
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index 2d102e025..0ead5d607 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -48,6 +48,7 @@
> >  #include <linux/audit.h>
> >  #include <linux/sysctl.h>
> >  #include <uapi/linux/pidfd.h>
> > +#include <linux/kmsan-checks.h>
> >
> >  #define CREATE_TRACE_POINTS
> >  #include <trace/events/signal.h>
> > @@ -459,6 +460,7 @@ static struct sigqueue *sigqueue_alloc(int sig, str=
uct task_struct *t, gfp_t gfp
> >         }
> >
> >         __sigqueue_init(q, ucounts, 0);
> > +       kmsan_unpoison_memory(q, sizeof(*q));
> >         return q;
> >  }
> >
> >
> >
> > base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> > --
> > This is an AI-generated patch subject to moderation.
> > Reply with '#syz upstream' to send it to the mailing list.
> > Reply with '#syz reject' to reject it.
> >
> > See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patc=
hes.md for more information.
> >
> > --
> > You received this message because you are subscribed to the Google Grou=
ps "syzkaller-upstream-moderation" group.
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkall=
er-upstream-moderation/b552544a-89cd-407a-845c-fbd83d6ba021%40mail.kernel.o=
rg.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
