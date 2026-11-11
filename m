Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794418531;
	b=byZaIoh0FnXXlGG5eeew6GsGqVt8y+zKxXncxXgOGpO0XUbgjArXo/mhpatzGD+fIhzl
	 wCELaCY9ZT+JzbQbe9ZmGy2XgLyRLe2ThSVtYkBBAfXQIbWObsmdiL/JiCdoIW/QN1ofJ
	 cIe/kJ51M0qnaTIOEKOwrl4brG0eXyZjBPfC/1VILdxZVVmGsZ5Z0c/WlPvpTRR62qsql
	 PmHj/fRSq5CZLoqP2jryGk/8R1Afur9seniNeKO7CnEfQmfueMcPny0Xfmopqqt2LlUCP
	 GqgRqkWZbb6iVMdgex/0Pq9fP+FL3Kk6dyOp3dxZbIi7g9D5xfSVZDCmKIL6hU/7fuQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418531;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=prgnZ+03/dXBKA03G/2xgVJ454mK8PwewSpL3vRBHSQ=;
	b=iwqG7eKCzQTj6q0NqeFQZM/ye1S7QOu1o7/RsK1f84ayd1duk5BqGdYfnAx6+Nw0lxRe
	 dWYvbnfe1uvNkmadllgCAaAvyUkjTeqkzEOQRXIR58cBD1CcKWIcWCzOtukXMk3sLLkqm
	 077n+s0FTd/OpsecIMIhrq0TFTeo8XjuXr03/wvj3kch18o/AZ/s/IeQ9XWq4QMZrQ05y
	 HM4iFwCPBGyvCU9eEhDRFX0iCP8Pz94Xl6HJwRtxDNBnobto+TpUjXW04wLDcKg/l2nIf
	 vRtuWmIrgJ6Yn7JRAY4ngCpAQ8gTxMiLwieUNsCyj7o6FXWOZhpQCXJ/xiEsG1Ey9XA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=babyFduR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.47
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45964606A321
	for <syzbot@lists.linux.dev>; Wed, 11 Nov 2026 17:35:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45964606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=babyFduR
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-451a49abd8aso3249793fac.3
        for <syzbot@lists.linux.dev>; Wed, 11 Nov 2026 09:35:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794418530; cv=none;
        d=google.com; s=arc-20260327;
        b=ewZ3dY+pvmZgxntW3AOQ4v0oD9OTjVYM36sWdcFxnDmKxFzF4mH6Pbyon03m2bk/yj
         5jQX1MYJNrrYGzLeyH4QoM+S6+PoSUd8Jc+kzRRcgZeIugUzsKyAmaeOAI7JNnsiejPx
         fHQwrX+UBrq2cXXw6OxESaJ4GX79nHmsV28+OZn6nKfRGE3QKQU8OJikVERy5zRjq4lq
         7zV0uE/CNpunMrpBlyUndnAJMhkMLkgdZeDJchdq10licNycVI+nJjWwCV3Ml7mlUEXw
         vHHjfgxh0nlw4llZmGkA5XVb4n92mR/4S1UIMQVwA072UUzXWjkBMjVP0L/ecqPWB+fc
         Hq8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=prgnZ+03/dXBKA03G/2xgVJ454mK8PwewSpL3vRBHSQ=;
        fh=Jnf4YMB6+BIRuWT4tpPXHWlrk+Yp0RyGoSK2crj6poM=;
        b=VPNjh1jD2vuR9S/aQsUpVx/wnQ++bEH0T/7+VEL/DuUIE2QElMHQHpoYT/AjLDehct
         QPXK8Ol/ZpI1dCPEp5qovqKD7bcnvWQSSKLGwMK41h88NB6ZfLGPGqMPdtrUXANgjqMf
         9BBlFgdj6p26X487J0jWAsje5JY04aQZ8I3ql8FapVcMZ6RVgJgc/rtVUHhoNM6lGcR2
         cNFloYQOk41h1Ldo5LVoAPqKdTfOdPIyiUYwHAwLEWJhVl07Pv8dX4ftWRaN6Abx+LeZ
         FEOsVHpheCM6If/XTmz50D25PXn+TApohViLM1084rQu7g0pOfXlSCXdrUD9mab0yhu3
         2Wrw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794418530; x=1795023330; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=prgnZ+03/dXBKA03G/2xgVJ454mK8PwewSpL3vRBHSQ=;
        b=babyFduRt8dTFO3X37IWe8pZ/62qU8y4ZYJIe0SSbaI0sy8sitw/nbOcxaNYhgI5G5
         7ilYg7r/M9SOPc+jNEYqZyFDYBnEqm8HqpmFZDxkjsddAT5bsQmJfYXnm6zHy25VVXo1
         cqRLgWMzGDf0rIzr5g39UnFwqy65DNK4RhN78AxZp6BS5PuB9jSrUh15rEdDBfKUuQKM
         ozNkeuMrdHzSln4DAF7oxeLf5s3TNxghGN9PdVYZp/rTekxcjgEyOOges5plP/fpS444
         yN7VxZfMVRFo0ZvgSiPOSgjOTh/+5woNDcAlaz/53CfBoyykew8dxs6Ft8LRI/WMJnC4
         5K5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794418530; x=1795023330;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=prgnZ+03/dXBKA03G/2xgVJ454mK8PwewSpL3vRBHSQ=;
        b=XW6R/G4Di7cVDL6nht/bOuSHoXrUSZ3B2Jdb9rHhRFPXo8UjenWgNG9e9nTgxLGK0E
         0zHSuOUCzt2QRrTvmY/HPOdtNYKoZPo6YEuEU41dEi5jk3lFC19p++e6jSTzGopf/khY
         N+z+G5p4A549DxsLkPcHLHfMRUD88IKv2glSUjQTxubref2Pbi3IzBbgHnRTfzbma+ip
         gUKMBIB9buy/IOoAFjLc8jMSc6TLcvznY/CmGDi8ZqCqksEGy1rCK0sIQpff2BYDZBXb
         EY+PD4OunXf3o4oi4qMK/L2mU4AzwHfuMqp8JmPc/E+RwNSm6EI813f/21LJA4NbYkDX
         vECg==
X-Forwarded-Encrypted: i=1; AL+hErGilGmSpVYe9fvGWFezBdJSBrx7FXSKmMi2GzRR2lFObwtzMcDcU9V10N6Qq4av7f3oJ8lkq1Q=@lists.linux.dev
X-Gm-Message-State: APuU4Z9DhSSkrbeMuZP+tJOKea7qTFQuwa+bZpS48fgXrAI5uHtVKmLg
	324ziHLIKrMbVIvClylC6p+Y0ZvGdZfuyDm18+FR9LhzsfO7ysWg5bINRyBnshRL7UM2xois7NX
	Xi30MNek4niIhwER/UHdZD5FPAdssb4OGB84Hd0Qn
X-Gm-Gg: AYBFou0SXm+SxfgbcQkPNxVPtveybOLRtHLzR8Q2tdNUr+Yzf3OeIjtKq38OCbiORFV
	GXpNQA6V33jzVVO/ylX91c1QaqtqZUHWlVt1RCbv0fdfK5eNxL4IhYaa8ZcqP7YKvAt/bhmX+d4
	GKAdmGUBPIbiCmdLU+wF8GvduK1MwTDwSIbbHtsP0snAbxECnXt4t/4EsUGr66mV/XJ2ZL/C8Wt
	CSz6VibC+7sJlQ0AtKoSI7cJ9+/hdC3A8B+GFvZzE1OUtQUR+RNNSUsC2xs4mGi9O6VywOxewm5
	qPrJEDqpu5zG5Kj6bbMRakYZSOQBCLEjJkI3/XaiMgmvusIVtub+deHvSZug/eRISVo+tSmeITF
	2OLlWbVW9FoLTnnALnrIjs21DWyagfoEahtnZB1MPuCeEdwd+jqH0OdEYdrscpf2pMKhXuW0hVy
	7qiQE0NFVJOEgXXSmvoVzyulvK4vOr/egc65XWPxbvd2YC/3OmznEAUNhkMl4xi/YpPHf85P+h9
	R30VYWy
X-Received: by 2002:a05:6808:4fe4:b0:4f9:a153:8446 with SMTP id
 5614622812f47-56b975054cemr3209109b6e.38.1794418529392; Wed, 11 Nov 2026
 09:35:29 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6af4a572.ad703688.70d19.1af0.GAE@google.com>
In-Reply-To: <6af4a572.ad703688.70d19.1af0.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 11 Nov 2026 18:35:18 +0100
X-Gm-Features: AclHuK-5mggzHGSLDdFAjInieED-eMwCxss808uAJ6r9ayhfwn_lOKWzzoeyluw
Message-ID: <CANp29Y4sUzidZvs9k2dHK4b0Vbuq3pnUvAGmCsNgvtqZu7tCNg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: tipc: bound reassembly size in tipc_buf_append()
To: syzbot ci <syzbot+ci466aa6a3db8114ff@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Nov 11, 2026 at 6:27=E2=80=AFPM syzbot ci
<syzbot+ci466aa6a3db8114ff@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] tipc: bound reassembly size in tipc_buf_append()
> https://lore.kernel.org/all/AoU-V5M5ZCKF37bLl8ILhgeNdsnCEaiaQNuWP4K56kRfJ=
snhkIexZ8tFRLq7uzGiA0qNqK6shXcSZ5E4hyV0-QI0ZWSuKiJzKvMrv3NfqCg=3D@proton.me
> * [PATCH] tipc: bound reassembly size in tipc_buf_append()
>
> and found the following issue:
> general protection fault in tipc_buf_append
>
> Full report is available here:
> https://ci.syzbot.org/series/3856f5b1-55ca-4bc2-885e-034eb8af1bdf
>
> ***
>
> general protection fault in tipc_buf_append
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      c4c470912125ec8a1a427a70f4085d8a731b00e4
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/28264169-6c3f-405e-9f6a-339572b43=
e52/config
> syz repro: https://ci.syzbot.org/findings/e9e2a2a5-41e6-4866-89fc-45c75bf=
e992b/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000000e: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
> CPU: 1 UID: 0 PID: 5915 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:tipc_buf_append+0x389/0xa20 net/tipc/msg.c:153
> Code: e9 b5 01 00 00 e8 97 ea 29 f6 48 8b 44 24 20 42 80 3c 30 00 48 8b 5=
c 24 28 74 08 48 89 df e8 8e 74 a1 f6 48 c7 03 00 00 00 00 <41> 0f b6 46 0e=
 84 c0 0f 85 ea 04 00 00 8b 1c 25 70 00 00 00 4d 8d
> RSP: 0018:ffffc900039defa0 EFLAGS: 00010246
> RAX: 1ffff9200073be13 RBX: ffffc900039df098 RCX: ffff88810d335a00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88816af130c0
> RBP: ffffc900039df078 R08: ffff8881ba5f6ee3 R09: 1ffff110374beddc
> R10: dffffc0000000000 R11: ffffed10374beddd R12: 1ffff1102d5e2617
> R13: 1ffff9200073bdfc R14: dffffc0000000000 R15: ffff88816af12ff0
> FS:  00007fbe193e76c0(0000) GS:ffff8882a7809000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fbe193e6ff8 CR3: 0000000117562000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  tipc_msg_reassemble+0x230/0x3b0 net/tipc/msg.c:807
>  tipc_mcast_xmit+0x254/0x19e0 net/tipc/bcast.c:392
>  tipc_sendmcast net/tipc/socket.c:887 [inline]
>  __tipc_sendmsg+0x2074/0x2b60 net/tipc/socket.c:1470
>  tipc_sendmsg+0x55/0x70 net/tipc/socket.c:1404
>  sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
>  __sock_sendmsg net/socket.c:818 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
>  __sys_sendmmsg+0x273/0x4e0 net/socket.c:2858
>  __do_sys_sendmmsg net/socket.c:2885 [inline]
>  __se_sys_sendmmsg net/socket.c:2882 [inline]
>  __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2882
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbe185a8f19
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbe193e7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007fbe18825fa0 RCX: 00007fbe185a8f19
> RDX: 0000000000000300 RSI: 0000200000006740 RDI: 0000000000000003
> RBP: 00007fbe18637f6d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fbe18826038 R14: 00007fbe18825fa0 R15: 00007ffeceeefb38
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:tipc_buf_append+0x389/0xa20 net/tipc/msg.c:153
> Code: e9 b5 01 00 00 e8 97 ea 29 f6 48 8b 44 24 20 42 80 3c 30 00 48 8b 5=
c 24 28 74 08 48 89 df e8 8e 74 a1 f6 48 c7 03 00 00 00 00 <41> 0f b6 46 0e=
 84 c0 0f 85 ea 04 00 00 8b 1c 25 70 00 00 00 4d 8d
> RSP: 0018:ffffc900039defa0 EFLAGS: 00010246
> RAX: 1ffff9200073be13 RBX: ffffc900039df098 RCX: ffff88810d335a00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88816af130c0
> RBP: ffffc900039df078 R08: ffff8881ba5f6ee3 R09: 1ffff110374beddc
> R10: dffffc0000000000 R11: ffffed10374beddd R12: 1ffff1102d5e2617
> R13: 1ffff9200073bdfc R14: dffffc0000000000 R15: ffff88816af12ff0
> FS:  00007fbe193e76c0(0000) GS:ffff8882a7809000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fbe193e6ff8 CR3: 0000000117562000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   e9 b5 01 00 00          jmp    0x1ba
>    5:   e8 97 ea 29 f6          call   0xf629eaa1
>    a:   48 8b 44 24 20          mov    0x20(%rsp),%rax
>    f:   42 80 3c 30 00          cmpb   $0x0,(%rax,%r14,1)
>   14:   48 8b 5c 24 28          mov    0x28(%rsp),%rbx
>   19:   74 08                   je     0x23
>   1b:   48 89 df                mov    %rbx,%rdi
>   1e:   e8 8e 74 a1 f6          call   0xf6a174b1
>   23:   48 c7 03 00 00 00 00    movq   $0x0,(%rbx)
> * 2a:   41 0f b6 46 0e          movzbl 0xe(%r14),%eax <-- trapping instru=
ction
>   2f:   84 c0                   test   %al,%al
>   31:   0f 85 ea 04 00 00       jne    0x521
>   37:   8b 1c 25 70 00 00 00    mov    0x70,%ebx
>   3e:   4d                      rex.WRB
>   3f:   8d                      .byte 0x8d
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
> [davem@davemloft.net edumazet@kernel.org jmaloy@redhat.com kuba@kernel.or=
g linux-kernel@vger.kernel.org netdev@vger.kernel.org noahweinberger2003@pr=
oton.me pabeni@redhat.com tung.quang.nguyen@est.tech]
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
-upstream-moderation/6af4a572.ad703688.70d19.1af0.GAE%40google.com.
