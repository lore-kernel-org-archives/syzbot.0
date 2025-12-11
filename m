Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B91E265621
	for <syzbot@lists.linux.dev>; Thu, 11 Dec 2025 23:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765496605; cv=none; b=HU5WW9j9bEOaAZG/6raWxnZhzCZQyvHsTpyOEyXiH+H6faRb2nhbm9rfU07AH5k8ZXar1RLiFZspuuNmbIAEMYQ/tksHmGvh9fmCfvcrkHBboeZpZ3rOSljBObi1X2akMCuQ4BvNvzfgLPuI1uC+MdhpmX+cSTgEZ8j69MOQA58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765496605; c=relaxed/simple;
	bh=2KnUONs/4oEhlzRlJhlgnsu+boXSeLbJF7hoXNNpkQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YptU5tsbAsh5506pIWmefh/nYU4E94ohHKtxwBl+/2nd2idc+80NtT8o3RTlMhOCAiCEuuR+8J8QTAYpfgGJ/W+Ke0F1O0M0ePYwXjV/xU7C868K8wJU8Lca4RhngAhdlmHAZSuoWlfWX7vytg7gUtDF64AyBK6YAPqbXlf2qQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wagalXzL; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wagalXzL"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-3f0ec55ce57so392378fac.2
        for <syzbot@lists.linux.dev>; Thu, 11 Dec 2025 15:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765496602; x=1766101402; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKP8u6jt3++m2XqP4Va6OhTkrRYyjaDcn1NEIrxD/8w=;
        b=wagalXzLXHmG51KWNRw8IIsWG67o+aaLQ6fK5a/MV+yU2LGaVqUUl0MLBRXAMXFpAt
         UknlPzBbSZBwIY4EEJZUKksXfgwi/ZicrLw/EWyOayi9Jbw/nIU/l+faKzjqD+PRmE3B
         JHRM+evvhiJAmrW7l65Dx9q1fTXaR9gvFH29vTSYIGvMhTlnyukz1CdElEJNBfgBstCv
         3IWduMA6XfVJOHIIUpFvrXyg15jrnfRmncE/QehO2FW1vHL6Pz0y94tqGzk98j2WLB40
         6LWGnzPpvMrRc0epQ1zycK97yb1G3hfkHyKcSOCAm7sVCKoM0EdoDyMbp10+E60JhaSb
         +jFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765496602; x=1766101402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YKP8u6jt3++m2XqP4Va6OhTkrRYyjaDcn1NEIrxD/8w=;
        b=Wym036M8yJUqeJkZfoKOBJKOY7Drax6AfA1/y+DlsAa8rJxlQyw3IdO9i4JUJ6C0gx
         cDMkNVzGzN5CYQRYhn8Mfh1lnDpofyerO/i2HA5JreICkmnN1rJmdpxvoghQTfBvzdhk
         SBuzWZPbvu49ZivmIEOhIv4WpMKWnBWmh0H3rmmoRMbKIiSpIqDNDrQGU8Z59SRT/WBD
         wl6KtX0nMrNLrofACi4MZGBQFNbD8knxyqaYyStshlu/mbfF5ljt5VKZNdP504DCjfGi
         OtI9DjmUEd8x803PA5zuYJnNPwb0Qb895WUlBkoLS8D/eYlStb9a8lt/0o36HjPvGAD0
         xmBg==
X-Forwarded-Encrypted: i=1; AJvYcCWhMN3Wk5+SE9sDfMbP0/a0XB0tZLxpy8uDyYcsADJFQXgV3vM4MzjGq/bDn4n+PjbF6xdmVJs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1pXXaF4XpUuLodA6DpOXFuiEBg8Nxkdqk0p8AoQ8CtREWybBq
	sKqfEVYCOQm3371znB5u7iTeVlSuRrXv87+S1WOjmdmft1qfZuJP/20WMhPznaWfj/QGFEno0/K
	pwTiHNbtIDJyJ/19TLNSjfRi5mK3UaTV5xGek75YA
X-Gm-Gg: AY/fxX6USN3NT+qKWz7LXuQhW466f+X3amMd3JBVuq8c0Q3JJxfGKTE2eMKatI37GlP
	oObC3HsnW5RuoxcC47XpWiYqOtGeAfka5eS08UP1lECCo5rN92FfTcughIB3fbqVQy1GgbLF2I5
	whseAmWoIXIXlqABeF6+FGrjpPChxx1nEaFJbGf7coixurVykclid0ZEoD1St0t+nLJtJJwZ2Am
	N8fTGN5m49+q2+c/rv6dbDSZdQM4JWh3er8sv66kQbQeDVhj8OJSNsO2LRD83U+QvzWXh3w0E+c
	8Z56JJV+QZBKV1AbYtlgxRBu2Q==
X-Google-Smtp-Source: AGHT+IFmR7B+e5m24iCdeHYkATqoRTe7V8g2FjZCmpBIuHMcqllJ7enjjuCr3GqmAqoudPVgjjfGsv1re69m2H0r/L4=
X-Received: by 2002:a05:6820:4deb:b0:659:9a49:8f9b with SMTP id
 006d021491bc7-65b451914c7mr118062eaf.20.1765496601844; Thu, 11 Dec 2025
 15:43:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <693af480.050a0220.4004e.03c5.GAE@google.com>
In-Reply-To: <693af480.050a0220.4004e.03c5.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 12 Dec 2025 08:43:10 +0900
X-Gm-Features: AQt7F2qj-w13cOSZNaVrAV6G5a8BCwdD7pIgCGI1ka1axLOpHQ6d25Felrr4bNg
Message-ID: <CANp29Y55nij_TNbKp-EOetha3MMiubLepN03D_5GyoMX7u_J0g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: nf_tables: avoid chain
 re-validation if possible
To: syzbot ci <syzbot+ci3c6f9b9cf7ea73f4@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Dec 12, 2025 at 1:42=E2=80=AFAM syzbot ci
<syzbot+ci3c6f9b9cf7ea73f4@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] netfilter: nf_tables: avoid chain re-validation if possible
> https://lore.kernel.org/all/20251211123038.1175-1-fw@strlen.de
> * [PATCH nf v3] netfilter: nf_tables: avoid chain re-validation if possib=
le
>
> and found the following issue:
> WARNING in nft_chain_validate
>
> Full report is available here:
> https://ci.syzbot.org/series/498345c4-bb9b-4e13-9cd1-42a483844f55
>
> ***
>
> WARNING in nft_chain_validate
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      6a107cfe9c99a079e578a4c5eb70038101a3599f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/e56f0271-a9ee-403c-ad73-fe3d0fb22=
785/config
> C repro:   https://ci.syzbot.org/findings/c4c03a63-b1c1-4815-b601-f7c763a=
99b6c/c_repro
> syz repro: https://ci.syzbot.org/findings/c4c03a63-b1c1-4815-b601-f7c763a=
99b6c/syz_repro
>
> ------------[ cut here ]------------
> WARNING: net/netfilter/nf_tables_api.c:4112 at nft_chain_vstate_update ne=
t/netfilter/nf_tables_api.c:4112 [inline], CPU#1: syz.0.17/5982
> WARNING: net/netfilter/nf_tables_api.c:4112 at nft_chain_validate+0x6b0/0=
x8c0 net/netfilter/nf_tables_api.c:4176, CPU#1: syz.0.17/5982
> Modules linked in:
> CPU: 1 UID: 0 PID: 5982 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:nft_chain_vstate_update net/netfilter/nf_tables_api.c:4112 [inl=
ine]
> RIP: 0010:nft_chain_validate+0x6b0/0x8c0 net/netfilter/nf_tables_api.c:41=
76
> Code: 31 db 89 d8 48 83 c4 50 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc c=
c cc e8 2d 32 42 f8 bb fc ff ff ff eb de e8 21 32 42 f8 90 <0f> 0b 90 49 83=
 c5 78 ba 04 00 00 00 4c 89 ef 31 f6 e8 ea 18 a8 f8
> RSP: 0018:ffffc90003df6fe0 EFLAGS: 00010293
> RAX: ffffffff897f183f RBX: 0000000000000000 RCX: ffff888102f93a80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000040 R08: ffff888102f93a80 R09: 0000000000000002
> R10: 0000000000000010 R11: 0000000000000000 R12: ffff88816a79c510
> R13: ffff88816a79c500 R14: ffff88816a79c500 R15: dffffc0000000000
> FS:  000055555e417500(0000) GS:ffff8882a9eb1000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000005000 CR3: 000000017531c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  nft_validate_register_store+0xf6/0x1d0 net/netfilter/nf_tables_api.c:117=
50
>  nft_parse_register_store+0x225/0x2c0 net/netfilter/nf_tables_api.c:11787
>  nft_immediate_init+0x1cf/0x390 net/netfilter/nft_immediate.c:67
>  nf_tables_newexpr net/netfilter/nf_tables_api.c:3550 [inline]
>  nf_tables_newrule+0x1794/0x28a0 net/netfilter/nf_tables_api.c:4419
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:526 [inline]
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
>  nfnetlink_rcv+0x11d9/0x2590 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:718 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:733
>  ____sys_sendmsg+0x505/0x820 net/socket.c:2608
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2662
>  __sys_sendmsg net/socket.c:2694 [inline]
>  __do_sys_sendmsg net/socket.c:2699 [inline]
>  __se_sys_sendmsg net/socket.c:2697 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2697
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f577a58f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe377887c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f577a7e5fa0 RCX: 00007f577a58f7c9
> RDX: 0000000000000000 RSI: 00002000000000c0 RDI: 0000000000000003
> RBP: 00007f577a5f297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f577a7e5fa0 R14: 00007f577a7e5fa0 R15: 0000000000000003
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
> [fw@strlen.de hamzamahfooz@linux.microsoft.com netfilter-devel@vger.kerne=
l.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/693af480.050a0220.4004e.03c5.GAE%40google.com.
