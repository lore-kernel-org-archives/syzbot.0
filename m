Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF5D23E358
	for <syzbot@lists.linux.dev>; Fri,  6 Feb 2026 11:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375652; cv=pass; b=mGJ4oPILOhccECqKQ+QeoL8A3BVDA0J/n3TMhNR1KziVQW2O2DIcnJ7SYM7PRQvu0a0+nNb9qg9mPs4bKBORwAQgV+JJZQmkv3tNLo6fm62LJ8AfmMPUoYEsBv/LjTxCbwVEnPTSwTMBEdsbn2hRHGzrmCnL8EjF8czsXaeaTKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375652; c=relaxed/simple;
	bh=VAK9okmSlh+kEVTILHuW8LD1ZEVQtxU51ibTYBN6WxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QPAhcR4vN59Xq8ydoERNpqPYWQF2nBagn9qr4J7YXr2j/L9HwqBdNyy1tx3dNrc6nQspX7MfAMtx3FpXjXqNLbITkJdtynFudBlsIv0cCJ9Boi+vHP8BcLDq/wNKBh6wQM7QWPWUXV8913GkRFVfgybi1G2/UsEjraoGH0MCKcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NE+MI2g6; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NE+MI2g6"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-409521ba360so1285238fac.2
        for <syzbot@lists.linux.dev>; Fri, 06 Feb 2026 03:00:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770375651; cv=none;
        d=google.com; s=arc-20240605;
        b=S0ogZcGTcRP1sDONHO7P7Rkd+OIXXhoumhHBrkBaVaZFOuZzVKonLDHlJYDV9IZlRX
         KcgUuJl3xuihrUL7Tm342awnLvxh4UbLHwzVVTEUmpPrSYWDMwjkO7AaklQIWm7BL0HQ
         P7ZOe2ICQyNbQYLifYrnloBatPHfmB48q9KYW5LxwQSfezM3ETvkl88VBRTgaYh3e5ne
         w0MKcFIO55NBc9rHXJeDT68cE8arpcH4QpjzxHE3lhRilitUHZa0hMZntN2MBQX6lhv4
         NSGXycTsnkOybdlCLVexwD+u5+CeoR5fbJFKs4AWt41JOalQRlsitBDSowK6weFSS7+Y
         EWeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AbYiHAAsBIC6FMYSmd0KM2kp/3ZtcCI/+aIrZzSQzes=;
        fh=gtpvz3KPO4asHeabm3uMCLPcCDeONffHNIaCNKO84ZA=;
        b=InbYdM+QLdIfiR5W41Gu1/F0ihi1ZB1rSet2ZrX1klovIvFiPS10fqHzkLezSuCsdW
         IJRhCQ5uYyZSYFbyDxhBjLIUg7OA+y64oKeahNyVHb2HsY3A9h7eraQicYJn2kwQ1MoV
         vyFt6Q4LvYw7+5Kl3GrKnx+9WGw56b8u8ukdIQarJ4FEP1PFLz9+dCuQfvif/0uSk9y3
         IN5EU1ylVb8Dme7LXcdfNeDM5Zs3e21k1/q7tCKaOiG6F/iiamYGWyeaKBBcUfafCRnE
         rQfPQ0Hs8jPunSZtw+yWrGH6dYXB/3XU94bzpHICpokxnzbt9dY8tvB+TKFphumtOoYy
         zEHg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770375651; x=1770980451; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AbYiHAAsBIC6FMYSmd0KM2kp/3ZtcCI/+aIrZzSQzes=;
        b=NE+MI2g6wZjSTFICwPv2RtWkCm+kcr3YfaY3q8DafqQYlcMvGsZLXrwRxCS2pDwOxG
         rgnqHt09EDqZSZBFXdD5HpZdCJP3/g6Srh3iZlxFyu3+9GF7cBxzct9e/m0yLP3TC+RQ
         j3EJVRKJ6UHNXze/cfX7+GTH7I/C+UABvMMDclwdCcPyksXzqIzHteROGR0/evr9np0v
         EONeiSm6UU5iltE9TW6Y1G5z7vbtmsQH+axLWZ0d2QHwGj78FbqGNXK5wiG60vJ4YFfC
         zCVlrhU9akh8X2k+fS14/tEcph5H1ekTHLB4T7k0P8oRo21QUvYMPY3+Q5H5mbwSR2LD
         vIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770375651; x=1770980451;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AbYiHAAsBIC6FMYSmd0KM2kp/3ZtcCI/+aIrZzSQzes=;
        b=dmZvIZCm5zOUbQaxrbA5eFsXNCEKlLdP6xBZ3eKUNvSvCcvTFIn30FGPkIG9x0FovE
         rHtiii5tFVRzHDZt9Ua53kN8UNQ5aSicGFCBRT+QQsWCYnKPUj+CvEA1MQyIedcmUl9j
         V8CpRkypGHexGFHHqZfFXfiR6fqvWnlN/XPNBpvxlCKUSan3H+qnNaPdNMOizktzngCR
         SZmAIuNpvbCy/4ZJI78gf454u9iJ/3f2yZyYuhvEAuYYh2Zg+slg74MV9M+6MpgQdVNS
         flmPbIZmfRNCl5tflfzDvQPhGoKPL1qD9TCmU+boGYe25jH/B/OYGFmLPorJqBNOwzl9
         weww==
X-Forwarded-Encrypted: i=1; AJvYcCVmoGqiXON/TrdJVfiMR+Z3e/VhxE9xsGJ/3ROMuYQH9kolu82C03Q/2v9FofEXnHcm1fkAP74=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6qYaBbE9uwNUscHejb1TuIKXr16TnGxV0fnaHgXcmmxD4Mm6b
	lZ0ENFGMp2xV8Tkl8d+5KaVZp9gsnAtErbYxHBYi5XnobnGtjX/1KHq2tLRViqfm1bLIBKeYXNU
	1fQ+d1RmKBLktyRLe5i/Y3YFNSlm8Mx7sEnWheInc
X-Gm-Gg: AZuq6aIJIOlUadLm8d4yg+acp1AVmiehZ3AxTTlXW7nDAWqYup/EdKLLm8LuxhXuFG9
	LbuXkB6snXwVmmBZgPOySFEqYIwjjjZ4LMW+39YDNL4AnhOYeh/XefQcZIfQMHm0wG6h7V9rzgW
	GZRf9d1wJVouSsFkNYWLRDwyoL+EPylSJZYV5DFLkDXYFalar6r0xS+tw2H9ZdjYCTf77zIAQVl
	rDGaLUG9VGDuBHkABzcKVattTZpuKEROIfGrO6vkQwQOi7W72/Srk0BiyfAeXjk/1gZrBHyN46I
	X0QdzB1Lp/0ZDnU8q5LV3y4kpv2ZWax68BLjGmwVsE29AGPkqSVrP5UYOg==
X-Received: by 2002:a05:6870:1772:b0:3d4:6fba:31ff with SMTP id
 586e51a60fabf-40a96c41ff3mr1253156fac.1.1770375650604; Fri, 06 Feb 2026
 03:00:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6985ba66.050a0220.3b3015.003b.GAE@google.com>
In-Reply-To: <6985ba66.050a0220.3b3015.003b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 6 Feb 2026 12:00:39 +0100
X-Gm-Features: AZwV_Qg38m71ML8-oq-gYW64vucFXqjmdF55r6xBwPq4AOR5nqkMwuqKEDK4e7o
Message-ID: <CANp29Y4aD3a42OakgJ_w+Jd8BW=ANKaGv0fBq3pa9oHx3JCpeA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: test_run: Fix the null pointer
 dereference issue in bpf_lwt_xmit_push_encap
To: syzbot ci <syzbot+ci0c167ed6434812b7@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Feb 6, 2026 at 10:54=E2=80=AFAM syzbot ci
<syzbot+ci0c167ed6434812b7@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] bpf: test_run: Fix the null pointer dereference issue in bpf_lwt_xmi=
t_push_encap
> https://lore.kernel.org/all/20260206055113.63476-1-yangfeng59949@163.com
> * [PATCH v3] bpf: test_run: Fix the null pointer dereference issue in bpf=
_lwt_xmit_push_encap
>
> and found the following issue:
> WARNING in skb_dst_set_noref
>
> Full report is available here:
> https://ci.syzbot.org/series/ebdff606-6251-4db9-ab50-448f5433094a
>
> ***
>
> WARNING in skb_dst_set_noref
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      1ace9bac1ad2bc6a0a70baaa16d22b7e783e88c5
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/673700c1-fa90-4aa2-8342-e6b397961=
829/config
> C repro:   https://ci.syzbot.org/findings/ad5a5f81-3d84-45ac-90ec-9a169eb=
16405/c_repro
> syz repro: https://ci.syzbot.org/findings/ad5a5f81-3d84-45ac-90ec-9a169eb=
16405/syz_repro
>
> ------------[ cut here ]------------
> !rcu_read_lock_held() && !rcu_read_lock_bh_held()
> WARNING: ./include/linux/skbuff.h:1235 at skb_dst_set_noref+0x14a/0x1a0 i=
nclude/linux/skbuff.h:1235, CPU#1: syz.0.17/5979
> Modules linked in:
> CPU: 1 UID: 0 PID: 5979 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:skb_dst_set_noref+0x14a/0x1a0 include/linux/skbuff.h:1235
> Code: 5d 00 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 9b 80 e9 01 cc e=
8 95 58 30 f8 90 0f 0b 90 e9 2f ff ff ff e8 87 58 30 f8 90 <0f> 0b 90 e9 5d=
 ff ff ff 44 89 e1 80 e1 07 38 c1 0f 8c 76 ff ff ff
> RSP: 0018:ffffc90004487a20 EFLAGS: 00010293
> RAX: ffffffff89923f99 RBX: ffffc90004487ba0 RCX: ffff888103713a80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffc90004487be3 R09: 1ffff92000890f7c
> R10: dffffc0000000000 R11: fffff52000890f7d R12: 0000000000000000
> R13: ffff88817331d858 R14: 1ffff1102e663b0b R15: ffff88817331d800
> FS:  0000555590ae6500(0000) GS:ffff8882a9928000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2fb63fff CR3: 00000001139cc000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bpf_prog_test_run_skb+0xed8/0x1eb0 net/bpf/test_run.c:1164
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4721
>  __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6246
>  __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f21c579acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff4c8461d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f21c5a15fa0 RCX: 00007f21c579acb9
> RDX: 0000000000000050 RSI: 0000200000000780 RDI: 000000000000000a
> RBP: 00007f21c5808bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f21c5a15fac R14: 00007f21c5a15fa0 R15: 00007f21c5a15fa0
>  </TASK>
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
> [bpf@vger.kernel.org davem@davemloft.net edumazet@google.com horms@kernel=
.org kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pa=
beni@redhat.com yangfeng59949@163.com]
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
-upstream-moderation/6985ba66.050a0220.3b3015.003b.GAE%40google.com.
