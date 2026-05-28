Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9B8282F3B
	for <syzbot@lists.linux.dev>; Thu, 28 May 2026 14:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779978357; cv=pass; b=n+zVaTVMHcCH1UEGThpajrlCewHLk9DoJsb46+CX19B7MKeauCkUQX7FoUuEmbt3de6YKeQpJp9JboUhlSxjyR+z02/nLmB6XaJgIoWBOtgo4OGn5kw64uufjtQMLvMKhQMUSWPc+EjOD965imZAkl03qUS4cGxCp+gPOc+SKjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779978357; c=relaxed/simple;
	bh=eXyu/xAHrfzCm875nGlwBno6NxoY3iMxuz/fiHqnUsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mQeT2h2h3iiqs2nZNUiGNe5fUylceXCHM9/L852PdVmxhih/dAt2tsepelX9fXSujLB8WBakQKUGv3QAAAGyorJet++y5sj2fM5L2vl3wRI9M8S2gT7JlIdr90fdRqS4EBvhJZJGFKKJnzVU72kfwNGeegmihbBrQcSUACiTIYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n9lp3v6B; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n9lp3v6B"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-69d774f16ffso2577658eaf.3
        for <syzbot@lists.linux.dev>; Thu, 28 May 2026 07:25:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779978355; cv=none;
        d=google.com; s=arc-20240605;
        b=IGkcc0SR8fdhfxiuv9HCE0wWmfX2Uw6x/hpd5yhwVIbcwmYYPcq7mZ5UWd2ANGTUDd
         iIFlHJMdrxbmKSPxQXuCYB50PCuyPKkc1mhfDCsHYUNpS4+ban1zoywdofcjKyK9C4y+
         aLvADDyQPd/ydAe+TscVzl8TnfW3ZfY+50Ok5SMEM5PeWYQpIXIlSbNyo8WxtkJfmFVk
         Ht40IshFERag1qdz7gRo6g36WmkmLa3Ln6bImDaqAVJt2IDxZjjvVLIHGeskwkLEARXa
         /b2xizgj51B70YeO5ipYJYzqBcKrlCVSUwptUY/OG6lpGlurOkaPm3ueFgrLj4DRLMKk
         fh6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+TOv3sNGcs8T2URhbncFyFgwzM10sVAjZsr3C6ulk2A=;
        fh=7uFowdhcKd2AMmlibHN3reA+nbPRjoHGB4hp0lghga8=;
        b=f7fLOR2JZl3lwqZM9DRxB65761FNNSJz7F2BYGORqfO6UiAkLP6OVnb+YNcNlGABpU
         c1XQeg/5PCyEdksgcatYDXy9EDGclvowMKhxohVDU6G6KACDlX4hnB+nlF4ceJ8i5fzq
         NKDI8S7dJ3CjCyWiUxdTA/p0lw+SXoWB/VTeLGd0YUce7CUoPg2BIdaL6FIjxrt/46rx
         9S1OvqTTRiwjFSE+6iGGTDsUjDtUfAvECnGIjlzWhSiChaXfzDWvKvJUro//KgCATgjt
         key+ghtlGAkRz/qYFDMcgYYavYXZ0jpaIBZ3wEGpPitAXdhLgfhdljKnCgc7UAHNLP1I
         69Mg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779978355; x=1780583155; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TOv3sNGcs8T2URhbncFyFgwzM10sVAjZsr3C6ulk2A=;
        b=n9lp3v6BYrhciWaMKSGBEOyX6fVeMjflTa4kDdoudxosHFtL60jW2QVHZ9mQG4EJre
         w+galz+dIkk5nTn2DRe/SIBHHQRRP4QOA9gZ7U2W/+4naqCGTZkL3LU55os9n3E4SNk+
         VuA4zcVRT++WUS6XjmKTQo8vDj9KntuiqII1O0nYgI6sCzVULjR0Kjde0WCXbjvWM+XV
         ka6e5BCunYTEIEgXo2Aq79Jvnyt9P4Gayrq99ZfB44cKxaa8OoxjlyrbhI/vnCLADvQh
         VL5DpnT636folY4woVWn1leQqJwlupHBi+7kKj7jRoqFHIlhQ/zezNPxnJmjeGLVgBLC
         sIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779978355; x=1780583155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+TOv3sNGcs8T2URhbncFyFgwzM10sVAjZsr3C6ulk2A=;
        b=rsiSjOmejInWv1sCWUNSsSKls/9/YEHA88UhDLduZDadazXFzHIUftvD6lExqMZn5y
         +3KRnc9ZFST0pwprs/VS2B3vqKWgNfBLnGZ7mfMYIWda20kkORSMaap+yz4ZIMmD7/ee
         XJ74PchLjhMHlYFmjVTTFZTMzYKYDiABTJnSyXdgTOdNcvV2bxfJtofeqiOm0LwIemEP
         VKCLYpZ49zWSNIdzmN5v7+RieFzkjJxmcj/FZQw8/OmkkNYFG8V9Lth7FzvYH2Sx3V79
         l4OGoQy9/1HrNXcrUah7pRQzE6RhJG+R9WvBnUECPFSoDg8UrLnvHRJWgfwAKMrN/fDI
         +xkA==
X-Forwarded-Encrypted: i=1; AFNElJ+GyoOvBZ1bKQzSKrfXh2BexoKcklA7EZRVwKGawJTiS3eVg9fsugM4yy5V0Qh9INj8if8imvA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyT06IX3HkaBKOu8ysP+UWKbD7LOzdSjlp+3gB7FLpEmjR6HMeJ
	r2kYm/9+5yEKEUaqZqpce3Y2c1MlnNCy6HNPkrfALjvhlUEpQq6TWfDs/5aCottOzKexQYryMr5
	HS9jFMJlTzQANLC0+sMCmBvDBpGQVkyLzq5Tcuame
X-Gm-Gg: Acq92OHtFTsn8iDQO53Ews+SjlOaGuLNnG6j46gclMF7bwdwGiMlt80LJHo2WlBjKtM
	3Yz8mGDyibOsexTuKXQbOBL8a5S86W7PbRYURQ+4Z49z1jFY0MP1yOaXesOhQ+7lm2SeT2Yp9T/
	ffDfpsVsggD8fP+KoBRkruPXg1JqE8bR6Y83TioK8HdzDSoEQxHiZi+o2Ha6Erq66uKQhiUsSZz
	SLF4Il0DJ5QduFqO2J0hvW3CYFHuKrEOjV2X95dy/pBMgufWjN7tr9TpdAG70rF4B8yLWGNFYVy
	uT/dI7c+sLdwOV97kwlK2gKsju0w1RsxJNjwFOvul1tVG1GD/1/4ZIzHDJnzjwYuLXgWUTgt/FR
	mYCAp
X-Received: by 2002:a05:6820:6ae2:b0:69d:f58b:8fc5 with SMTP id
 006d021491bc7-69df58b9299mr1547258eaf.57.1779978354260; Thu, 28 May 2026
 07:25:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a184cb8.7f45b5d1.9d2a9.0002.GAE@google.com>
In-Reply-To: <6a184cb8.7f45b5d1.9d2a9.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 28 May 2026 16:25:42 +0200
X-Gm-Features: AVHnY4IQfJT_1Z4qf_tvOKyWcD9HqSFlg1kqLai3ugOPoYqbpFd-CGrxghTLgVc
Message-ID: <CANp29Y78=Oe=YFRy32WTTgaK_kEsapiEXuto4_vbyiHxOwv2Tw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: ipvs: fix ct refcount leak when
 template is invalid
To: syzbot ci <syzbot+ci0617f739889e28a1@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, May 28, 2026 at 4:10=E2=80=AFPM syzbot ci
<syzbot+ci0617f739889e28a1@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: ipvs: fix ct refcount leak when template is invalid
> https://lore.kernel.org/all/20260528072100.1163109-1-vulab@iscas.ac.cn
> * [PATCH] netfilter: ipvs: fix ct refcount leak when template is invalid
>
> and found the following issue:
> general protection fault in ip_vs_conn_put
>
> Full report is available here:
> https://ci.syzbot.org/series/fb773743-f223-4965-9f38-e5ea600ee724
>
> ***
>
> general protection fault in ip_vs_conn_put
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      aa064a614efcfa4c300609d1f01134e99a12ad10
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/3e6a154f-d578-4d43-94af-86e851702=
925/config
> syz repro: https://ci.syzbot.org/findings/518450a1-bd56-47bd-b214-be945f6=
ba221/syz_repro
>
> IPVS: sed: FWM 3 0x00000003 - no destination available
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000007: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
> CPU: 1 UID: 0 PID: 5812 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ip_vs_conn_put+0x2b/0x240 net/netfilter/ipvs/ip_vs_conn.c:608
> Code: 0f 1e fa 55 41 57 41 56 41 55 41 54 53 48 89 fb 49 bc 00 00 00 00 0=
0 fc ff df e8 40 cb c1 f7 4c 8d 73 3c 4d 89 f5 49 c1 ed 03 <43> 0f b6 44 25=
 00 84 c0 0f 85 9f 01 00 00 41 8b 2e 89 ee 81 e6 00
> RSP: 0018:ffffc90003d4eba8 EFLAGS: 00010203
> RAX: ffffffff8a03f980 RBX: 0000000000000000 RCX: ffff888169370000
> RDX: 0000000000000000 RSI: ffffffff8c28b740 RDI: 0000000000000000
> RBP: ffffc90003d4ee30 R08: ffff88823c6247d3 R09: 1ffff110478c48fa
> R10: dffffc0000000000 R11: ffffed10478c48fb R12: dffffc0000000000
> R13: 0000000000000007 R14: 000000000000003c R15: 0000000000000000
> FS:  00007faa344d36c0(0000) GS:ffff8882a9276000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007faa33472780 CR3: 0000000169de6000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ip_vs_sched_persist net/netfilter/ipvs/ip_vs_core.c:-1 [inline]
>  ip_vs_schedule+0x100f/0x1d90 net/netfilter/ipvs/ip_vs_core.c:688
>  udp_conn_schedule+0x391/0x7a0 net/netfilter/ipvs/ip_vs_proto_udp.c:78
>  ip_vs_try_to_schedule net/netfilter/ipvs/ip_vs_core.c:1659 [inline]
>  ip_vs_in_hook+0xc50/0x1bf0 net/netfilter/ipvs/ip_vs_core.c:2231
>  nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
>  nf_hook_slow+0xc5/0x220 net/netfilter/core.c:619
>  nf_hook+0x22a/0x3a0 include/linux/netfilter.h:273
>  __ip_local_out+0x558/0x6a0 net/ipv4/ip_output.c:120
>  ip_local_out+0x2a/0x190 net/ipv4/ip_output.c:129
>  ip_send_skb+0x45/0xc0 net/ipv4/ip_output.c:1510
>  udp_send_skb+0x7e4/0xf70 net/ipv4/udp.c:1161
>  udp_sendmsg+0x1937/0x21a0 net/ipv4/udp.c:1443
>  udpv6_sendmsg+0x996/0x25c0 net/ipv6/udp.c:1523
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x5c7/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7faa3359ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007faa344d3028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007faa33815fa0 RCX: 00007faa3359ce59
> RDX: 0000000000000000 RSI: 0000200000000400 RDI: 0000000000000004
> RBP: 00007faa33632d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007faa33816038 R14: 00007faa33815fa0 R15: 00007ffe8bd2ebb8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ip_vs_conn_put+0x2b/0x240 net/netfilter/ipvs/ip_vs_conn.c:608
> Code: 0f 1e fa 55 41 57 41 56 41 55 41 54 53 48 89 fb 49 bc 00 00 00 00 0=
0 fc ff df e8 40 cb c1 f7 4c 8d 73 3c 4d 89 f5 49 c1 ed 03 <43> 0f b6 44 25=
 00 84 c0 0f 85 9f 01 00 00 41 8b 2e 89 ee 81 e6 00
> RSP: 0018:ffffc90003d4eba8 EFLAGS: 00010203
> RAX: ffffffff8a03f980 RBX: 0000000000000000 RCX: ffff888169370000
> RDX: 0000000000000000 RSI: ffffffff8c28b740 RDI: 0000000000000000
> RBP: ffffc90003d4ee30 R08: ffff88823c6247d3 R09: 1ffff110478c48fa
> R10: dffffc0000000000 R11: ffffed10478c48fb R12: dffffc0000000000
> R13: 0000000000000007 R14: 000000000000003c R15: 0000000000000000
> FS:  00007faa344d36c0(0000) GS:ffff8882a9276000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007faa335ea540 CR3: 0000000169de6000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   0f 1e fa                nop    %edx
>    3:   55                      push   %rbp
>    4:   41 57                   push   %r15
>    6:   41 56                   push   %r14
>    8:   41 55                   push   %r13
>    a:   41 54                   push   %r12
>    c:   53                      push   %rbx
>    d:   48 89 fb                mov    %rdi,%rbx
>   10:   49 bc 00 00 00 00 00    movabs $0xdffffc0000000000,%r12
>   17:   fc ff df
>   1a:   e8 40 cb c1 f7          call   0xf7c1cb5f
>   1f:   4c 8d 73 3c             lea    0x3c(%rbx),%r14
>   23:   4d 89 f5                mov    %r14,%r13
>   26:   49 c1 ed 03             shr    $0x3,%r13
> * 2a:   43 0f b6 44 25 00       movzbl 0x0(%r13,%r12,1),%eax <-- trapping=
 instruction
>   30:   84 c0                   test   %al,%al
>   32:   0f 85 9f 01 00 00       jne    0x1d7
>   38:   41 8b 2e                mov    (%r14),%ebp
>   3b:   89 ee                   mov    %ebp,%esi
>   3d:   81                      .byte 0x81
>   3e:   e6 00                   out    %al,$0x0
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [coreteam@netfilter.org davem@davemloft.net edumazet@google.com fw@strlen=
.de horms@verge.net.au ja@ssi.bg kuba@kernel.org linux-kernel@vger.kernel.o=
rg lvs-devel@vger.kernel.org netdev@vger.kernel.org netfilter-devel@vger.ke=
rnel.org pabeni@redhat.com pablo@netfilter.org phil@nwl.cc stable@vger.kern=
el.org vulab@iscas.ac.cn]
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
-upstream-moderation/6a184cb8.7f45b5d1.9d2a9.0002.GAE%40google.com.
