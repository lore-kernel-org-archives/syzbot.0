Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53C936D50F
	for <syzbot@lists.linux.dev>; Fri, 27 Feb 2026 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772216133; cv=pass; b=WnfErLpXzVraOBN26caWBNWEgIcOQ6Qqy5JZsiOycdIjcIky1iXJDqwa0EzgaV5C+77Hsg4Bb1X7HU/fd8gsDJMJ5J2JrHs5AMUAo6AKEMSja3MI7h81F/+0oL1kdGptFh82zTPJ+z2pDo72/F/+T78p5ov0b8zyd8esaa1DQ6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772216133; c=relaxed/simple;
	bh=f6XSY5+rhxj/u0yco4z3oJMI/f7j0d5kMpWZIX5uvLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CcOj6mtabuJ9Y7TZVOCtY8oIlR29AprfVT53tCsN6GpPXwoCVleEW8hNxJy7cPBt/SEsaR35KYzbrwbZjkpeZUwuVC4qDdRE3aB2ZhfxxggFLMDpBGRoWOWtIDXOYA+eH5nU2Cio+xXQ8+qiscaVdH+s5g390CGocrUuGnXKI9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lrXI93v2; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lrXI93v2"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b93718302beso193272866b.3
        for <syzbot@lists.linux.dev>; Fri, 27 Feb 2026 10:15:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772216130; cv=none;
        d=google.com; s=arc-20240605;
        b=KYJjvcHzCB6InikpAHMVgEmu2cKTJwg44x06YsjNjuzdBsU2fqc8ZbQ5AsaiwkmxaS
         18zh3D0K1iYWbqrLbUYlxAmi6c7sdn8XudVmVc7d1ogzk9anzzNFCHrCLtHCwTylXOzP
         duJGIbdf/2Nrin7zz5+Uh1SPrtAsH3xb08jPCk4Nx3y5hKaxELkgut22en8cTN/kaLTi
         iVjFbpLYaMjmdZEF0gu/8pyLTg8zzNgFr38BjPs1etDFvKpiiSPfkvl5XvwAcniE/HIE
         DLmJblQXGgB53szsp+ClgTc8rLbzieo+P1y6SzMfJ3LF0jpZx8gH8PcCgsZ4VwTlJwkX
         AhdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T7pbTyGLOpWFS0LV53aUEDdPkt4I7GzhVorgb1rxpf8=;
        fh=y3v1QrUsrX2wVtvmLA20HWixXnJSvPJZMmag1+YDJ8Y=;
        b=f/3bAiAnIu5Lo4doMI3svP/UJfR9vmwzCeBWEO9AHwg4Te4e3fjqLsiE4QzlV3TKOY
         h/lREN3dS/HWKksxRgeiUeW9M9lVhUdCzIlxOLN3JzCK+rX4CiopydGafkgpbLxvn3xf
         lHB0NMl2GuzWPbxixNhgDhGYuhfxNvTtVnvGMCPCvvSJlz0S7K/K/2xh1hxTaY8YHEyq
         SC53jUyiKjVYZkDyOpDn1OAb+TvKvM/Y6tJy3AbBZZjjoxpOunUPWHBWj6kgIXDq5ySa
         DZiLsguwZcq5maItj35lcJPnJ5jjHhofWyzb9mp1R+EBk4vl2T43hpkyi5vFHFfY0Xkz
         NNIQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772216130; x=1772820930; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7pbTyGLOpWFS0LV53aUEDdPkt4I7GzhVorgb1rxpf8=;
        b=lrXI93v2M441B0/b5wxjnlYRJY4Bpk1MNfOq8x/x3Zdte+evbFU2PhP+jt6WWlRcKi
         M9TH7oHO+n5xwuSaqBTArtZlSQJF+5139qb9IkHBkc/oBIsRkphlpGGFWun90Uk4bo3T
         nqGk218OyEnYRwfMbwfUsn6xI2zibVneKDh5N0orv1EiinVFSWd6yLuAiZQFdB4SfizB
         3AEc2VhDz0PjnQP527QMMazk+ZX1UPCfym/8O/KZ4JPosHMHfd4YWxyk1IaZilKcsakH
         9MfN8ViDCZUv0UYKEFMMpSFteEB2u7xIKtyi4xkb1zzTZw1cVU9EyXifsxs0i17h3QVd
         HJAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772216130; x=1772820930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T7pbTyGLOpWFS0LV53aUEDdPkt4I7GzhVorgb1rxpf8=;
        b=sAlzX7vvSor5DTL0DIQFsB2BUOjYabDNfD5lNJjOeLmZ0ZxnwfjMxrWptuG19D31++
         LwybQvEF5oB0FFnrtEnq2lfk/06LhDCRerb5E8ADBgcWMLpWbkun7HWoJlRkdqNWACoA
         3qYnWNXHX3YKMRJUkzn8XSEfqeODkrKx1W0DX4j9BkUkFa7NVz3anpV1ni7GvgEN7uvh
         xwppAiy9Gs0LjG/OOVZI6/ZXOWFv/B4M4QUnV6nh2cgokT9zo1f8CdsyIb0AIINAup6e
         pKSsqyvs1SYWmBt7ZhXS6lDNVHe/cXQsj3dqciYops86Hu3WnwYHOJO+kWrli/W7+3Nv
         0Uig==
X-Forwarded-Encrypted: i=1; AJvYcCVBxQTeeUZ3Dixlr1bx68oQxZ0NYjUHGWouHXeNKIwqdm2Wp0dU+9lXGHLlDFcmXNjXSAGQQ3k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1rZjBxQyPJ1RslkqrSjBxbs0Kfe6qc12cqArTXGU4srGhImBM
	409XcX0nSj51NKRr/DXA0Fm2AevSKf7GzEpz4p6lhQ/MtSlK/vvusN8LAAJ/CVqt1dbiHJkfrE8
	8CfV0r8HzNKHpLJrIsNvN6BAlv4FR1wHb7jIkv0PV
X-Gm-Gg: ATEYQzzyzbeT22oYBhbcw98+/JCV2TZ2nvFJpAcygRYlGlDgjOyXtugYscUGeKOAXou
	LLa2p8X1Fz5Mi6FvdLuXhdTuxjTHw+vLGa9Vu7HhPhx7NakDuKrfdL1d4C9ojWIO+7Ikw+KpBKZ
	foSrQIJ+szN2LcrTDdK4IriYnZXXg71Tz8WzV3VlaMuNN6HWraPsaICMp2PAOxbGKW8unK+pKmV
	CmH99VOzq5BVXzdaBubMKTWedKSdPRaTzwD7coS/ar7E+Vn9zC+rMhWN+0ETobp0Z2ccgxpCuml
	YI2aMGu6WogrrVgTbHDx2KqQb4bcb5Cr/MCExVb0Lo5utau+QYyHus1TVtnVyqPW+S1cMw==
X-Received: by 2002:a17:906:248a:b0:b8f:87a9:27b5 with SMTP id
 a640c23a62f3a-b9376554a31mr194420266b.41.1772216129473; Fri, 27 Feb 2026
 10:15:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69a1d23e.050a0220.3a55be.0025.GAE@google.com>
In-Reply-To: <69a1d23e.050a0220.3a55be.0025.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 27 Feb 2026 19:15:18 +0100
X-Gm-Features: AaiRm51SatTmUxcXgycnNqVshw8WZIE7k9WLVwCaje7lfsuwLgjAg6VxsLqqLQ4
Message-ID: <CANp29Y43HnEUm=F_DENRYAQ7V0M0oi7rKuUCxBLU9UTukVFP8g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: BIG TCP for UDP tunnels
To: syzbot ci <syzbot+ci60beb959ea6a7a80@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Feb 27, 2026 at 6:20=E2=80=AFPM syzbot ci
<syzbot+ci60beb959ea6a7a80@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] BIG TCP for UDP tunnels
> https://lore.kernel.org/all/20260226201600.222044-1-alice.kernel@fastmail=
.im
> * [PATCH net-next v2 01/12] net/sched: act_csum: don't mangle UDP tunnel =
GSO packets
> * [PATCH net-next v2 02/12] udp: gso: Simplify handling length in GSO_PAR=
TIAL
> * [PATCH net-next v2 03/12] geneve: Fix off-by-one comparing with GRO_LEG=
ACY_MAX_SIZE
> * [PATCH net-next v2 04/12] net: Use helpers to get/set UDP len tree-wide
> * [PATCH net-next v2 05/12] net: Enable BIG TCP with partial GSO
> * [PATCH net-next v2 06/12] udp: Support gro_ipv4_max_size > 65536
> * [PATCH net-next v2 07/12] udp: Support BIG TCP GSO packets where they c=
an occur
> * [PATCH net-next v2 08/12] udp: Validate UDP length in udp_gro_receive
> * [PATCH net-next v2 09/12] udp: Set length in UDP header to 0 for big GS=
O packets
> * [PATCH net-next v2 10/12] vxlan: Enable BIG TCP packets
> * [PATCH net-next v2 11/12] geneve: Enable BIG TCP packets
> * [PATCH net-next v2 12/12] selftests: net: Add a test for BIG TCP in UDP=
 tunnels
>
> and found the following issue:
> WARNING in l2tp_xmit_skb
>
> Full report is available here:
> https://ci.syzbot.org/series/8de1e666-84bd-4f74-b980-539c4b651492
>
> ***
>
> WARNING in l2tp_xmit_skb
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      fd6dad4e1ae296b67b87291256878a58dad36c93
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/f58ab8e4-fdf3-4b35-8063-129b877f1=
ed8/config
> C repro:   https://ci.syzbot.org/findings/a09a9cb9-7ad3-49ee-8662-3581bd4=
2cd46/c_repro
> syz repro: https://ci.syzbot.org/findings/a09a9cb9-7ad3-49ee-8662-3581bd4=
2cd46/syz_repro
>
> ------------[ cut here ]------------
> len >=3D 65536u
> WARNING: ./include/linux/udp.h:38 at udp_set_len_short include/linux/udp.=
h:38 [inline], CPU#1: syz.0.17/5957
> WARNING: ./include/linux/udp.h:38 at l2tp_xmit_core net/l2tp/l2tp_core.c:=
1293 [inline], CPU#1: syz.0.17/5957
> WARNING: ./include/linux/udp.h:38 at l2tp_xmit_skb+0x1204/0x18d0 net/l2tp=
/l2tp_core.c:1327, CPU#1: syz.0.17/5957
> Modules linked in:
> CPU: 1 UID: 0 PID: 5957 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:udp_set_len_short include/linux/udp.h:38 [inline]
> RIP: 0010:l2tp_xmit_core net/l2tp/l2tp_core.c:1293 [inline]
> RIP: 0010:l2tp_xmit_skb+0x1204/0x18d0 net/l2tp/l2tp_core.c:1327
> Code: 0f 0b 90 e9 21 f9 ff ff e8 e9 05 ec f6 90 0f 0b 90 e9 8d f9 ff ff e=
8 db 05 ec f6 90 0f 0b 90 e9 cc f9 ff ff e8 cd 05 ec f6 90 <0f> 0b 90 e9 de=
 fa ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 4f
> RSP: 0018:ffffc90003d67878 EFLAGS: 00010293
> RAX: ffffffff8ad985e3 RBX: ffff8881a6400090 RCX: ffff8881697f0000
> RDX: 0000000000000000 RSI: 0000000000034010 RDI: 000000000000ffff
> RBP: dffffc0000000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff520007acf00 R12: ffff8881baf20900
> R13: 0000000000034010 R14: ffff8881a640008e R15: ffff8881760f7000
> FS:  000055557e81f500(0000) GS:ffff8882a9467000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000033000 CR3: 00000001612f4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  pppol2tp_sendmsg+0x40a/0x5f0 net/l2tp/l2tp_ppp.c:302
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg net/socket.c:742 [inline]
>  sock_write_iter+0x503/0x550 net/socket.c:1195
>  do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
>  vfs_writev+0x33c/0x990 fs/read_write.c:1059
>  do_writev+0x154/0x2e0 fs/read_write.c:1105
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f636479c629
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffffd4241c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
> RAX: ffffffffffffffda RBX: 00007f6364a15fa0 RCX: 00007f636479c629
> RDX: 0000000000000001 RSI: 0000200000000080 RDI: 0000000000000003
> RBP: 00007f6364832b39 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6364a15fac R14: 00007f6364a15fa0 R15: 00007f6364a15fa0
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
> [alice.kernel@fastmail.im alice@isovalent.com andrew@lunn.ch daniel@iogea=
rbox.net davem@davemloft.net dsahern@kernel.org edumazet@google.com fw@strl=
en.de gal@nvidia.com horms@kernel.org kuba@kernel.org lucien.xin@gmail.com =
netdev@vger.kernel.org pabeni@redhat.com razor@blackwall.org shuah@kernel.o=
rg stfomichev@gmail.com willemdebruijn.kernel@gmail.com]
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
-upstream-moderation/69a1d23e.050a0220.3a55be.0025.GAE%40google.com.
