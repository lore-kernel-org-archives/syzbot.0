Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA1E46C849
	for <syzbot@lists.linux.dev>; Mon, 12 Oct 2026 09:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791797240; cv=pass; b=EGAfCqe3RaGr5xypgDcSfTaxw2DaHTlGAi3Np7M5XOzawr0N5DalnF0vum9Mam141kGCJBMwQsfl2zr3xrWyyC4QjtzLCkCa3CqScKsGJBR9DZfQa1Cdz2HLWxLLs9JKvqiATUVAaBQhnfqMXvYR1QvVv5eQzwYNu6DRyDgsRIg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791797240; c=relaxed/simple;
	bh=SLJHVNw0Rjyiu2EdyuGS4UlKRJiNf+Ah4gVVpGmMB1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NgNbkfLuzRgSJFdpq8qOrB7BDKTyxdfuxv3VodpEBV5ZF1QATaicm/fv34MfC6ocH3l9HzNwFDQP71LcfMOTEBr7AeE/pMUwQuA3cGWpqGuWTRT1HWXUVvNudAuyEUtqeZSVU0/j99Kve73o9eO2gwwtfD90X5l+pUehV9kD6bM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IjNVJ1Jv; arc=pass smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IjNVJ1Jv"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93e4f0d7d77so208804885a.0
        for <syzbot@lists.linux.dev>; Mon, 12 Oct 2026 02:27:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791797236; cv=none;
        d=google.com; s=arc-20260327;
        b=XJZeTiW9fBv7oCFyguVmf0t/eGVZmmDIObuaMk18TM+RZbdOLo3Cevr5OFEZHNh3iR
         d6uY8cr39rHzhYCVE7lhxUgAL4PaSTohG/zbPJIqG63aFrKok7lJpmmeUhXcjOvgnYZa
         6hokxHdRbGk8XUY+mPUALAhJacurr3BqiyMsJ4BSO+B77hgLgvi5/3Fdb3GGGeY+AucO
         wXkQwOXTPgm+inyrBRDEL5Q61bZHxULMZL5lvdczpt7jqQTNkTp8WWxO4f2Gu3bNyztN
         /9Eq+dGbaf9UPPMnEWGaZO6vAoyXBqhHGdorTpEoEPdSs2Y3nsdTuGw1dqrufYFK2lMg
         z9TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RMzjeF6J1GF1KHIlWgMX2tRT8IccSppy1j9FQS+HKF8=;
        fh=vPx6Bk9F+0v4UkINBeU5GR1fjzp9vSjEvMNvPR9oblc=;
        b=UXh7k7MW1X5VZg5uUR5FUDFgLGmflQoXOxLEIvfKP47HXvWlQJJeJp6Hqu2k7ykV4m
         ffFuSo+Tf7ZWuLyZA8n/CnUnjqmWeVd4yFmR6fEmJqWXc217/fgSDRVNtdqtgRx6C5w3
         2TjAZuWaf3wRTmPFivxtyNyQUs0aVOTC88b7SSRxiFmpVebfF4wzfYkemnrJGx5XZfcC
         Lw5WZbE7xmbfSbBzz/I7jkm1/UKTeG0DD7tRs7VZkOdz1SwcyK6B+FykumiYTWLgAmiI
         evovxZB8XF4l2d35wNKiW5mL8VeUTuI4SPgPXYfZAsJedY9HP0SaYCgvhHtIn9lTeWp5
         FhSQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791797236; x=1792402036; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RMzjeF6J1GF1KHIlWgMX2tRT8IccSppy1j9FQS+HKF8=;
        b=IjNVJ1JvHiJUWgllvtg5EwlfG2aUK/oh5M/DIKgTcgNVUUacAOXpJLiq+d/++ld9kb
         o6Jp1TSbtbzKYCKZHF+YqppX6f1UKJpihXNdyF3j4fq3/8RxWJ8KnHT+opUFXXhEPYnI
         7wi6dVwzNoyJMc5Pb1yB/IbyyivYeuwz+50DCiRDuclWhzfMfIrFPOLS8qgPh6qMd9El
         RnxBPeV4X2Wsg+4sywXcCL1+uwEKVJGRcZEW3KHlEozHH4cnwtZSlzBssbNYMCK83kS+
         tK9v1W5eN5dlTVxcSnDpe9HcJvEKRDEuc1f2Pc6O/XEc9BgKT78i3ded/Be7oFJdW5wk
         WWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791797236; x=1792402036;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RMzjeF6J1GF1KHIlWgMX2tRT8IccSppy1j9FQS+HKF8=;
        b=kxhvlpV/I7ADepdzxsqgyA/xCbOCPe/TfSXzkO1ZpIYMG8myezdMTf2ps98JuZ4Gmo
         PMAYSebX6MvfjUXrQ9j+hSETaKYEhK/A3/gTd4+SvFcqNTkICBm1TInXpuaQfEdM4wdn
         9lE4cyFKxh3OlWuInDtF0n2r7MpfqMrACsCC03Q1jtb8NbLhed6JoIijp6L1RQMJnshh
         ZY5e8VZLUW7iYB2u84kaJgh4nPvA8TKcEYuLYkhvZUt191YfkBxnTMIE+T4JmxkjavSE
         HM5RFyyJNQ0MC5uwuYc5H1ifRplQeBFxMHlgEzOxOyQHXBgW2L0DTd4RrwSt1uDZEumH
         gzjQ==
X-Forwarded-Encrypted: i=1; AKwUvBw857F3D6l+XYOo2xNYy2zszow5flrCbq34FSgip6qUBIjZycJtqh4WUKs9GRWbMJQTfulvzmw=@lists.linux.dev
X-Gm-Message-State: AFq9FYKwl04KyYoLLWC9rHXW1E4KU0TZRCn+vBUEz3h8ZXHJJ6dJE232
	Ep1tI8ScBIJepnJXTfgbeIw0D+WmQsTPiMmRKCd66tHv344VoEFrx+efgdP+cTeeiQAgD+fYcz5
	x7MclqHzwWW3kjMJL1wOa2p9W5FDpjOV1IZUMTdEQSeCF3420rk5HlJ28
X-Gm-Gg: AYBFou0F1SaQTQbl8/NNrccxLfLnvn+49hTt1GI/0sKIeTvGTs5siakJLBkwVCAwBVd
	OwSgxBuKYyyfO8WT57IePsYkznfT1BVw6cbImFWJrxAFvo8oIvkMqrocAnfu+LMKc3TgAUPYdtN
	gbXRZt4nmdwOQG6giUg3r+rjzQzgGghGCiPi3trGJwYbUweLKiJTJR+cN82UePmxAdjBn132Sqo
	UjhW2om0KzQgjVMwWxkgkcc+ddXmt1NTUzJS6FwzOtxaJ7eUv0fZJ8Hyr/6oKoRE14WZv8dVk2i
	hPCCpD0uRRYxzRr4hSbmFqr6lTs42OYSBaTozqdF3KAO0dFgeon1cjgUgKxTqxhFWiZHKUliBrO
	turp89syyARx9i8vtFdrk39Epsu2x5kRgp/EiRyU=
X-Received: by 2002:a05:620a:3182:b0:93b:cb64:25a5 with SMTP id
 af79cd13be357-93eb95e34cbmr1466248085a.12.1791797235178; Mon, 12 Oct 2026
 02:27:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6acca4fa.8cdf6287.1eb53.0121.GAE@google.com>
In-Reply-To: <6acca4fa.8cdf6287.1eb53.0121.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 12 Oct 2026 11:27:03 +0200
X-Gm-Features: AclHuK_1eZyQFOw7WfqW3aUrum9_XYENg7eW1p9EGuAN6MycTSCaLyn7kPc6Hz4
Message-ID: <CAJWNTGzPEoRj6bh7ysT8+7F5t2LcDE4Q2v3x3oyD+BqTTidL-Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/sched: sch_netem: prevent packet length
 underflow with negative overhead
To: syzbot ci <syzbot+ci0bf0ce1b639f8936@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Mon, Oct 12, 2026 at 11:14=E2=80=AFAM syzbot ci
<syzbot+ci0bf0ce1b639f8936@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net/sched: sch_netem: prevent packet length underflow with negative =
overhead
> https://lore.kernel.org/all/20261012044322.503949-1-dungvn2345@gmail.com
> * [PATCH net v2] net/sched: sch_netem: prevent packet length underflow wi=
th negative overhead
>
> and found the following issue:
> divide error in netem_enqueue
>
> Full report is available here:
> https://ci.syzbot.org/series/eff5cc04-13f7-4a28-9b83-b6e0de530bc2
>
> ***
>
> divide error in netem_enqueue
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      af32da41b0327b9c6a37856ba82b6760d6c8d10e
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/bf12d8a1-2cda-46fc-9150-cadd809b1=
c71/config
> AI triage: https://ci.syzbot.org/findings/421fe233-e7de-4584-b674-8e64cbd=
21195/triage_trajectory
>
> Oops: divide error: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 17390 Comm: syz.0.2912 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:netem_enqueue+0x20f6/0x3300
> Code: 8b 74 24 38 48 8b 44 24 50 42 80 3c 28 00 74 08 4c 89 f7 e8 cc f4 5=
1 f8 49 8b 0e 4c 89 f8 48 f7 25 b7 9c 8b 04 48 89 4c 24 78 <48> f7 74 24 78=
 48 b9 ff ff ff ff ff ff ff 7f 48 39 c8 48 0f 42 c8
> RSP: 0018:ffffc900082cf4b0 EFLAGS: 00010a07
> RAX: 3599740d73380000 RBX: 0000005c44b22572 RCX: 000000000000002c
> RDX: 0000000000000077 RSI: 00000000000001ed RDI: 00000000000001ee
> RBP: ffff88810e973000 R08: ffffffff917a717f R09: 1ffffffff22f4e2f
> R10: dffffc0000000000 R11: ffffffff81776d40 R12: ffff888026e62330
> R13: dffffc0000000000 R14: ffff88810e9732b0 R15: 0000020000176c00
> FS:  00007f87167196c0(0000) GS:ffff88818c4bf000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8716718ff8 CR3: 000000002756e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  netem_enqueue+0x16f1/0x3300
>  dev_qdisc_enqueue+0x4e/0x260
>  __dev_queue_xmit+0x1b6c/0x3920
>  packet_sendmsg+0x3f11/0x51a0
>  sock_sendmsg_nosec+0x13a/0x180
>  __sys_sendto+0x408/0x5a0
>  __x64_sys_sendto+0xde/0x100
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f871579e1d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f8716719028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f8715a25fa0 RCX: 00007f871579e1d9
> RDX: 00000000000005dc RSI: 0000200000000280 RDI: 0000000000000009
> RBP: 00007f8715835888 R08: 0000200000000140 R09: 0000000000000014
> R10: 0000000000004009 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f8715a26038 R14: 00007f8715a25fa0 R15: 00007ffc85273198
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:netem_enqueue+0x20f6/0x3300
> Code: 8b 74 24 38 48 8b 44 24 50 42 80 3c 28 00 74 08 4c 89 f7 e8 cc f4 5=
1 f8 49 8b 0e 4c 89 f8 48 f7 25 b7 9c 8b 04 48 89 4c 24 78 <48> f7 74 24 78=
 48 b9 ff ff ff ff ff ff ff 7f 48 39 c8 48 0f 42 c8
> RSP: 0018:ffffc900082cf4b0 EFLAGS: 00010a07
> RAX: 3599740d73380000 RBX: 0000005c44b22572 RCX: 000000000000002c
> RDX: 0000000000000077 RSI: 00000000000001ed RDI: 00000000000001ee
> RBP: ffff88810e973000 R08: ffffffff917a717f R09: 1ffffffff22f4e2f
> R10: dffffc0000000000 R11: ffffffff81776d40 R12: ffff888026e62330
> R13: dffffc0000000000 R14: ffff88810e9732b0 R15: 0000020000176c00
> FS:  00007f87167196c0(0000) GS:ffff88818c4bf000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8716718ff8 CR3: 000000002756e000 CR4: 00000000000006f0
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [davem@davemloft.net dungvn2345@gmail.com edumazet@kernel.org hagen@jauu.=
net horms@kernel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org linu=
x-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com stable@vg=
er.kernel.org stephen@networkplumber.org]
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
-upstream-moderation/6acca4fa.8cdf6287.1eb53.0121.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
