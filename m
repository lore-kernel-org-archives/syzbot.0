Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F53C403EAF
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 13:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784554284; cv=pass; b=csqnv47UXcerdl8v2JVHO5k8zA+B1xfzdpq41EkQeG7hk6BE/i7NP2nqz3q9tJP+KdjXh2wLeOXtWpJB/KPn36cPx/rfFYGx6f8srbA84ZsnApqwxTxufl3Fam7Y6Apj+SEjtMN8AoXURBTPfCsvEhApQJS6s0hMi6KCry7kta0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784554284; c=relaxed/simple;
	bh=1PpPFoZQmQnCTQ+MlQLNkdMC4by7/ldq0nTjhmcTt34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EdEVrt6btfy7rpiDGf/M02oGL1b6v5Ax2UHx5t/n/Z3x6vUc9Qx5krbzGxRIsKHKDq9HNmu5VvxXh1fGre/Jdx9Xq/lmLMQxU0q0TfNdsjI+XiuRnqykOAEEwRMgjawoTXJfWWH1hmQmXd4gq/mumeyB5u4720aaF/OlUctDpPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V0wklofT; arc=pass smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V0wklofT"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-44868d6a066so3017140fac.3
        for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 06:31:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784554281; cv=none;
        d=google.com; s=arc-20260327;
        b=DtOMM5NfDWa7sJZmN2VUgdtS9kyE7KKeYmHaLOppCO4X6I6uyhz0aHuPNAVcpKs11W
         uNYoW2yc05xNXdZahwe4G9mHU+i8ptvTeWJOqq1+TiEsmlcbEV0v2ymi85jQVzA5b21K
         mHte44POErwaIMkmhs8qqe0UbczPRDW2ga4RAGJPPio6F0bY9UgOrcxCTSW7l+z1U8ZU
         5hjGypRuyXxxYMlAsnFE3MqQf7X94qiUpjL+Ci+jhTwJnmiS02OmM5stDHI20ou7SrsM
         cj2ZJtGt6a/7mrgxlpPhZyP0MTmf4RAGBQ5lbDWY10U8fE37JljstForlceWhcdSB40t
         Mmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W30/+1qkXgmpiwKPLiQ3ZBmsYXTfTM2gm3YvSwwUbtg=;
        fh=+dAwrcS1IfQ1jZUpdTmrpjqbvEk+m7FUjmE9gHovj1A=;
        b=sfU761YKVjLT+TtaQqfsr+b4eUqKP2TUi6OdBGBrIWhnVaWicTO1Ubr62qqg+x0FJd
         oF9+tCtlskTKeN8JIEM2qsl3bNeM1gjNGYnsWO5INgC4XU8o6rfqv8RYcDtCDeuuzp+r
         9pfYsQ4uufaUSN5ABxVLquR92vVfYij3kqgDs0P1pH3rG3bLqJBDcOZ6fEv7DRj2Vlw+
         PUNs7S73eIC3dhPknYTI4YKv//x127QAIAhMGvFCyu/0shp1QF2k+R18zbQt70fO0DMu
         tKfriKGBqUv2bUkQIWfBOEsaO9BhMP9T6SkPu7m6fzvxM/LFxWqOaz0M/qfai9juObV1
         3A+w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784554281; x=1785159081; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W30/+1qkXgmpiwKPLiQ3ZBmsYXTfTM2gm3YvSwwUbtg=;
        b=V0wklofTQXVBdKxrpezCqY6ndvPeEgu1CUcy/O23dfn3qUFQ+uknFkDNBj9u5zrXK4
         5r3E3ygWCOkiQAa0EETuImjyPRDHSED1mMdDyti6WGQiK4AMnMiZUrCMS4p4ehEMSIak
         1Oi+N0plBuqWTi/ufdFOY6HHtmXQie8V36nUKkjbYmOY4DKj+YGERhL9VOctru1k2umM
         ar4Nsvxnfy8OFJHSdovtpvhyvFGZW3AFaQb0IMliJ1ySw1ItSaMoOCU6IptZFk3l4IQQ
         /+eA9gN6JSbYZGwrYYyIQLf9DszHlEo5nNu/nS92mSKtPbM6rbitbPuOZi39zkB3V4e6
         nJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784554281; x=1785159081;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W30/+1qkXgmpiwKPLiQ3ZBmsYXTfTM2gm3YvSwwUbtg=;
        b=sXL9YMwr7tSAqDzdfU6B5dBi84dART529vxgEe6jMVYIlepmRkzg/XS9kokCCu5n1c
         NgAQQNiQOmUFJRTm08MPtcrct/TyLXhYjkUzkd1E8CukQDl7UA5bpI1gkABxXgwjNkRj
         AcVDnT1svuFQko/mdAA6lGD4h0L1ZIJGLMAlHyTPmTVXIMD6J8XEpwl2y+eR//OqmiKt
         T2HxzknkNkw5JVry0aciPMKXcNSlFWPuI2lfjeID8NvjJGe6oa7E7Obl3V1sjJ+fowjT
         P+F48nm5kbfz8/c3LOwWzzAmuSI3qH+pXLIpmXOEhNZ0GXVFTlm6RK3GBFT1J4bRaj0W
         5yXQ==
X-Forwarded-Encrypted: i=1; AHgh+RpgIfGTh7437txHNV6gtluSX9UPsM3YmdpoDrbwIhKvk8IdtTsIUNXAIULOqjarTesBZ9WuCKc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaubfzubpSVkD/Jq8RRFIk0qy6bC0UCQOkQVnZXAxGMgTWufXV
	U5BTjUO9N6eioYeP1gUv92mFWgaftXGf78FcO+mRTy0YsF1wQ9EueSEcS4AcKB9jxnVjc3NQTGy
	y4OWejv/UL9h7lkIzWZTMfZa8jleVAsfLhT6UdrwB4ScKQrI5R8QTPibB
X-Gm-Gg: AfdE7clX+ZtzNsdb37brNxnrJlCG6gfGyMJ0VmTANeMuPg6NrXTLpBy+9obZtMKXvEK
	WkfI21xumk8sd15KYDu2I7Vok7LVGhlgEM9Vo5xEayzV196oMDUrM457ysChAQsRo2Lm7UmVeI7
	029m0Fb95KL1kUyaFDMXiWOwHJTUAIba0+ie+2za4acYOVaCiGOjEx2y3uiIByBjlgbkHAkIrBN
	0zwE5sNIW57uYBnlgNSkJ/QZcVO0qM+zPL0xUZD3lxIwnxK6AUealHu2LAlr/HdqqL/m5K82nDX
	o82qXIW8RKWQLvvCPhw14VPsehA9vL2Y9xYPtGgj821B4FA8gnX85Ec7HM0U0ur9idqaBa7omVD
	pQHKcp5Z3eKoFaLKEOe+IvZCsNK+x3j0CFQqhp3NDLspxnX3Bp2U=
X-Received: by 2002:a05:6808:318b:b0:496:1e4:1f0c with SMTP id
 5614622812f47-4a4d03cf749mr8839352b6e.16.1784554280375; Mon, 20 Jul 2026
 06:31:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a5e21f6.42649fcc.6186.0082.GAE@google.com>
In-Reply-To: <6a5e21f6.42649fcc.6186.0082.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 20 Jul 2026 15:31:08 +0200
X-Gm-Features: AUfX_myzGpjhEFrcxWQgp56JGL-5PVFZ7wvc6E1f4FxjbA_7518y6xxiGY5sDQI
Message-ID: <CANp29Y7NdScEowLFWqjN5b770XYJ4-PwVH1ntP_7+zPaSYFbWQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: sctp: socket: refactor sctp_skb_recv_datagram
 to use ERR_PTR
To: syzbot ci <syzbot+ci1ca46141c422550d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Jul 20, 2026 at 3:26=E2=80=AFPM syzbot ci
<syzbot+ci1ca46141c422550d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] sctp: socket: refactor sctp_skb_recv_datagram to use ERR_PTR
> https://lore.kernel.org/all/20260720082145.1072547-1-l1138897701@163.com
> * [PATCH net v4] sctp: socket: refactor sctp_skb_recv_datagram to use ERR=
_PTR
>
> and found the following issue:
> general protection fault in sctp_recvmsg
>
> Full report is available here:
> https://ci.syzbot.org/series/f979ded9-9743-486d-b911-69a904c9f4ad
>
> ***
>
> general protection fault in sctp_recvmsg
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      e13caf1c26587434f0b768193100440939c0fb91
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/e4b39daf-f862-498e-8aeb-c22b5a168=
551/config
> syz repro: https://ci.syzbot.org/findings/1893a3b4-56e4-49d0-9865-4ff919f=
027b3/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000000e: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
> CPU: 0 UID: 0 PID: 5830 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:sctp_recvmsg+0x28d/0xd60 net/sctp/socket.c:2135
> Code: ff 72 0d e8 35 6a d6 f6 41 89 ee e9 da 06 00 00 4c 89 7c 24 08 48 8=
d 7d 70 48 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84=
 c0 0f 85 2f 08 00 00 4c 63 7d 70 4d 39 fe 4d 0f 43
> RSP: 0018:ffffc90003a8f838 EFLAGS: 00010202
> RAX: 000000000000000e RBX: ffff888115ad1c80 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000070
> RBP: 0000000000000000 R08: 1ffff92000751ef4 R09: 1ffff11022b5a460
> R10: dffffc0000000000 R11: fffffbfff206639f R12: ffff888115ad22f0
> R13: ffffc90003a8fd00 R14: 0000000000000000 R15: 0000000000000300
> FS:  00007facf6b766c0(0000) GS:ffff88818dc17000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000055c0 CR3: 000000010a812000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  sock_recvmsg_nosec net/socket.c:1128 [inline]
>  sock_recvmsg+0x166/0x1e0 net/socket.c:1148
>  ____sys_recvmsg+0x1e6/0x4a0 net/socket.c:2904
>  ___sys_recvmsg+0x213/0x5a0 net/socket.c:2946
>  do_recvmmsg+0x31a/0x7f0 net/socket.c:3041
>  __sys_recvmmsg net/socket.c:3115 [inline]
>  __do_sys_recvmmsg net/socket.c:3138 [inline]
>  __se_sys_recvmmsg net/socket.c:3131 [inline]
>  __x64_sys_recvmmsg+0x198/0x250 net/socket.c:3131
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7facf5d9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007facf6b76028 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
> RAX: ffffffffffffffda RBX: 00007facf6015fa0 RCX: 00007facf5d9ce59
> RDX: 000000000400023c RSI: 00002000000055c0 RDI: 0000000000000004
> RBP: 00007facf5e32e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000300 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007facf6016038 R14: 00007facf6015fa0 R15: 00007ffcc05d60d8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:sctp_recvmsg+0x28d/0xd60 net/sctp/socket.c:2135
> Code: ff 72 0d e8 35 6a d6 f6 41 89 ee e9 da 06 00 00 4c 89 7c 24 08 48 8=
d 7d 70 48 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84=
 c0 0f 85 2f 08 00 00 4c 63 7d 70 4d 39 fe 4d 0f 43
> RSP: 0018:ffffc90003a8f838 EFLAGS: 00010202
> RAX: 000000000000000e RBX: ffff888115ad1c80 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000070
> RBP: 0000000000000000 R08: 1ffff92000751ef4 R09: 1ffff11022b5a460
> R10: dffffc0000000000 R11: fffffbfff206639f R12: ffff888115ad22f0
> R13: ffffc90003a8fd00 R14: 0000000000000000 R15: 0000000000000300
> FS:  00007facf6b766c0(0000) GS:ffff88818dc17000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000055c0 CR3: 000000010a812000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   ff 72 0d                push   0xd(%rdx)
>    3:   e8 35 6a d6 f6          call   0xf6d66a3d
>    8:   41 89 ee                mov    %ebp,%r14d
>    b:   e9 da 06 00 00          jmp    0x6ea
>   10:   4c 89 7c 24 08          mov    %r15,0x8(%rsp)
>   15:   48 8d 7d 70             lea    0x70(%rbp),%rdi
>   19:   48 89 f8                mov    %rdi,%rax
>   1c:   48 c1 e8 03             shr    $0x3,%rax
>   20:   48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
>   27:   fc ff df
> * 2a:   0f b6 04 08             movzbl (%rax,%rcx,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 2f 08 00 00       jne    0x865
>   36:   4c 63 7d 70             movslq 0x70(%rbp),%r15
>   3a:   4d 39 fe                cmp    %r15,%r14
>   3d:   4d                      rex.WRB
>   3e:   0f                      .byte 0xf
>   3f:   43                      rex.XB
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
> [davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org=
 l1138897701@163.com linux-kernel@vger.kernel.org linux-sctp@vger.kernel.or=
g lucien.xin@gmail.com marcelo.leitner@gmail.com netdev@vger.kernel.org pab=
eni@redhat.com]
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
-upstream-moderation/6a5e21f6.42649fcc.6186.0082.GAE%40google.com.
