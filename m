Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111AB29E0E5
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 07:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786518986; cv=pass; b=Q+AwNe+WoiNbg1k6efjf++8E0MrSCZgeSjnLB6teUBfxLFOXmPaVCVdLKl23K8dEnmwgo9rTXBPrlnRbrZZsXB11otVEI+TQK6KD/8aLMqLqU0uEKLwH/Iw2Kr3LPTH0KqjppJweVRgf84VdW/6sKkTDmKRFOqtZuw5+0Mm5L5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786518986; c=relaxed/simple;
	bh=RwalvQ70POx0n1YKFYLTPXPTuexCDXYeuO3mB5ccpmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s93NC2ubRb/LkXFQick3FLq6sRc0l4OHE4goWZ9FuGWWWnzer9lZyQxgzmbugfUs8jTmpPwu2bnXQ2rdAws8d2HhFgEBeoofTkf4bgrWoZNMHDa9umTSDNsOG1XLOPyRd7VP4WDUnBjsmIp6M9MtEN8cLZL0d4QD7Eol2XcKlck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v+lrqy7N; arc=pass smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v+lrqy7N"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e6b5737bb2so497302a34.1
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 00:16:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786518984; cv=none;
        d=google.com; s=arc-20260327;
        b=p8eFH3KOK+c+TMiIZY67Ewpa5E238v3CY7fmMNTCpRwZE0t+PTRbtAjMvEWzqjZHwO
         FhNUCiTjReecYeYwhTVoJe8BPxUM66kfDzLzp2010lr/5V5lx8XgBue38YYyqLBZWVu9
         Z3bQ1Vm2qpL3Ol3GzbdKxeltPiq6wO6mx8h7qqPgdV+bnag6m4cTvktzowIPttAd11O8
         fJXbLbzoIPYZY5Bt/L7ptI/Chs5FJCiLU7QD1zt7o6UnI6FXptsTolxSNt24obZ43NWq
         zIvJBKsJVMv/Os35G85O7r/vpe02fdd1IxfR4f5Shr4BAAwrNQofITWXEJXZRjF5s+iL
         LLeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K2Yzk5ZifOyx59gcznYXfrn/hOsoEggad+H1oriYg1U=;
        fh=GwScZW9dfsclDRtRa8hDZC5fN6SKfFissE73+Hi0iQc=;
        b=qGUFKmQ9X6pj4mP4Wk5AUs0kVkdTZzX9sEnEgAqk5cI6S0RWS/7Akc7XPKEubGGldz
         woCvABmfW72i3s0J4PPoTUm3YvhM4OmBLWlB+8rwitkxIxwZUZ0ls1aef4jK2+4cxht+
         FU8ZBDq0STRRuyDzrXku4sINyr3BowXd6iEH/5Dm2n9uaq40eiUVh9LoqtEdzTjg6d8X
         Tq3ubR8E3fuM3p3J/6jnjcGUZHwTwZGPXwp7LHb1v0/64go+szb7LlHhM/FEzYJQEzj7
         2EVlcm9xyKG35AnCtYcwull+JMFKdVdXzrACZfp7iAEYeATDhNzaLM/Hll33BeNblD+6
         hgCw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786518984; x=1787123784; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K2Yzk5ZifOyx59gcznYXfrn/hOsoEggad+H1oriYg1U=;
        b=v+lrqy7NfWM3MH69BcoAt9OE7p9W1lypwJP1A+xlZzBye78xzn/YRMulqpVp21rvI3
         SYAs6/YNzy7p3BDOp2+CqZtT2vUjmujByUtVWWRdG6eM7uqrA3Xj5977NIpNQqnliTxk
         /J/smGEJF7XXYHg+Yxeq/iWlTJeGlAOWdH9IEga8DBs8FJnoROUS7Z59Bw/cDE2kPR+O
         qfBscUQk4lZVuSZxVL71R9UHipgSxiOf49dZSxrxA+4zLC2dNEdny9GiTwW7CLKJOS6t
         JymveXdf/lMFF8O0CVZaEgwlv/keg8A4YTqE/7LnMdLItuIqI6iYJq5oUbYjJCCQE1LP
         NlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786518984; x=1787123784;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K2Yzk5ZifOyx59gcznYXfrn/hOsoEggad+H1oriYg1U=;
        b=sHyI6s/cbnCbkFNAhchu/iB3r/I5/xLyTzs5EVFXP47tNmrNKhBKXdDKHuwESLGSOz
         +9Vg97TqhEeEB4c2WlQJGpoKyn8Z1p7+S79JyqV/xy2uqOefANVL93hxTIYEJiB6+Q6H
         r6HZx6x3XrNsTc5Z15snPnHZc4AGnofvo8cUY/ROn8xlFrwUr5drU7HIS52370fXD5wn
         UqB75AF0/nqFzAUmAtng6pFX1TUn8bBE1d2LNl8+kyw/DdqTjjx/4x/xEgs2k2686029
         DbaEHpfaVd787mJ71c1SRocfjvAawcWsHqqpEMjYg7mnbzdz9nc7JjX5ZhWCtTg6nDRP
         lkmQ==
X-Forwarded-Encrypted: i=1; AHgh+Ron2b0LJMfm+BdLnY8qz5ISKVTfDMEIbcWkS8ksBvZ6VWUr3S7DVg4e98wC4F2PUJ0dQkM0/eA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz92tGj5aFQjzgNMtG/Z2i6/9dvoOTeR31lp+KXWFb4dqTRKq7i
	3TCV8psCgEnBehygrdoJF8WtxRUgws5PjWEI4MLfdHRygNOSBpol7BRqc7e8zYI4nCgB/loLZAg
	kE2619+o3VziF/lOmU7rP/7J1HusLc/1zQDTh7bPNS+bxX6yGqOl1P6Qj
X-Gm-Gg: AR+sD12ZlZIa7ljfaWYorI5gVCEYAsDLVxUToxA1cBGZZxFZOvf5P17nTpBkzvZUg1b
	15GPor3utUc2KsxGoyz1aDbS3R59fhFsA6z7SDpX7PFsSCatNDFFwbDv70ZFOX30cpU7c/21e93
	yCiWZZpZyruF4Em2GyTHSXurhhrEk0OpJQCyX6Ftd1LilJgb16PV7LXjCDlFbhfa5chGNHgB6wX
	RcR9MzW1LLCCmCpQ5gdZKBM8mZIz2mze0xxNrFduJxdsK6LAzJMJ5VpK6BKoiGOF8+kWJQQjmbL
	BnLeAPImf6wZWm4KxQxU2uD/Vy9PjSz7rpfI6oQqaGsfhs9rNUCmwoGq57xoM+tlDVe9d9Iv2G9
	LELDOQxJs+9eBJubiPp+wQnT36LcqUQMc45vPO32v/GUIurD+TWXj0W8aih8J5BXAfgkC/L7aJT
	8awUWsct2Py7SZ
X-Received: by 2002:a05:6830:a92:b0:7e6:f7fb:9678 with SMTP id
 46e09a7af769-7f3b76f6c42mr2866621a34.1.1786518983309; Wed, 12 Aug 2026
 00:16:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a7bce19.d5f0ebe7.22d851.0004.GAE@google.com>
In-Reply-To: <6a7bce19.d5f0ebe7.22d851.0004.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 12 Aug 2026 09:16:12 +0200
X-Gm-Features: AUfX_myNgAJFj4k3RUErlU7bzsNHQVEdkOKTDn8KZCtF7xvDaKhGNmgIkmpPSDQ
Message-ID: <CANp29Y5qW58Eh8yarbwg_45CxYCvNSo0qrY0POAzU=9sFSKZCQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: wifi: mac80211: guard drv_net_setup_tc()
 against unbound AP_VLAN sdata
To: syzbot ci <syzbot+ci59a1ab611e254e14@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Aug 12, 2026 at 3:36=E2=80=AFAM syzbot ci
<syzbot+ci59a1ab611e254e14@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] wifi: mac80211: guard drv_net_setup_tc() against unbound AP_VLAN sda=
ta
> https://lore.kernel.org/all/20260811210926.11422-1-ayushmanrout27@gmail.c=
om
> * [PATCH] wifi: mac80211: guard drv_net_setup_tc() against unbound AP_VLA=
N sdata
>
> and found the following issue:
> WARNING in ieee80211_netdev_setup_tc
>
> Full report is available here:
> https://ci.syzbot.org/series/db0f7870-cfa6-4a9b-b78b-225ce86c2a89
>
> ***
>
> WARNING in ieee80211_netdev_setup_tc
>
> tree:      wireless-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wirel=
ess/wireless-next.git
> base:      ca800a9302764c445de0da0e84d2252400a770ee
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/e40f4f29-7949-48eb-9c12-006be4046=
454/config
> syz repro: https://ci.syzbot.org/findings/4c184dbd-070a-4d74-8afd-085fa1b=
5f0a2/syz_repro
>
> ------------[ cut here ]------------
> syzkaller0: Failed check-sdata-in-driver check, flags: 0x0
> WARNING: net/mac80211/driver-ops.h:1719 at drv_net_setup_tc net/mac80211/=
driver-ops.h:1719 [inline], CPU#1: syz.1.18/5848
> WARNING: net/mac80211/driver-ops.h:1719 at ieee80211_netdev_setup_tc+0x2f=
0/0x550 net/mac80211/iface.c:938, CPU#1: syz.1.18/5848
> Modules linked in:
> CPU: 1 UID: 0 PID: 5848 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:drv_net_setup_tc net/mac80211/driver-ops.h:1719 [inline]
> RIP: 0010:ieee80211_netdev_setup_tc+0x345/0x550 net/mac80211/iface.c:938
> Code: 48 8b 02 48 8d b0 20 01 00 00 48 85 c0 48 0f 44 f1 0f b6 04 2b 84 c=
0 4d 89 ee 0f 85 ad 00 00 00 49 8d 84 24 68 0a 00 00 8b 10 <67> 48 0f b9 3a=
 e9 16 fe ff ff e8 cc ee 86 f6 90 0f 0b 90 e9 75 fe
> RSP: 0018:ffffc900042ff078 EFLAGS: 00010246
> RAX: ffff8881709e9928 RBX: 1ffff1102e13d325 RCX: ffff8881709e9938
> RDX: 0000000000000000 RSI: ffff8881709e8120 RDI: ffffffff9068ed60
> RBP: dffffc0000000000 R08: ffffc900042ff157 R09: 0000000000000000
> R10: ffffc900042ff128 R11: ffffffff8b3fff60 R12: ffff8881709e8ec0
> R13: ffffc900042ff120 R14: ffffc900042ff120 R15: ffff8881709e8000
> FS:  00007f5cd6df16c0(0000) GS:ffff8882a8f66000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000012c0 CR3: 000000016f0fc000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  tcf_block_offload_cmd+0x235/0x3b0 net/sched/cls_api.c:838
>  tcf_block_offload_bind net/sched/cls_api.c:875 [inline]
>  tcf_block_get_ext+0xfe0/0x17d0 net/sched/cls_api.c:1498
>  tcf_block_get+0x67/0xa0 net/sched/cls_api.c:1543
>  multiq_init+0x72/0x2b0 net/sched/sch_multiq.c:246
>  qdisc_create+0x7b5/0xf00 net/sched/sch_api.c:1337
>  __tc_modify_qdisc net/sched/sch_api.c:1771 [inline]
>  tc_modify_qdisc+0x17af/0x2390 net/sched/sch_api.c:1835
>  rtnetlink_rcv_msg+0x7b9/0xc00 net/core/rtnetlink.c:7121
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>  __sock_sendmsg net/socket.c:790 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>  __sys_sendmsg net/socket.c:2770 [inline]
>  __do_sys_sendmsg net/socket.c:2775 [inline]
>  __se_sys_sendmsg net/socket.c:2773 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5cd5f9e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5cd6df1028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f5cd6225fa0 RCX: 00007f5cd5f9e0d9
> RDX: 0000000000000000 RSI: 00002000000012c0 RDI: 0000000000000004
> RBP: 00007f5cd6035024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5cd6226038 R14: 00007f5cd6225fa0 R15: 00007ffc6aba2558
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   48 8b 02                mov    (%rdx),%rax
>    3:   48 8d b0 20 01 00 00    lea    0x120(%rax),%rsi
>    a:   48 85 c0                test   %rax,%rax
>    d:   48 0f 44 f1             cmove  %rcx,%rsi
>   11:   0f b6 04 2b             movzbl (%rbx,%rbp,1),%eax
>   15:   84 c0                   test   %al,%al
>   17:   4d 89 ee                mov    %r13,%r14
>   1a:   0f 85 ad 00 00 00       jne    0xcd
>   20:   49 8d 84 24 68 0a 00    lea    0xa68(%r12),%rax
>   27:   00
>   28:   8b 10                   mov    (%rax),%edx
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   e9 16 fe ff ff          jmp    0xfffffe4a
>   34:   e8 cc ee 86 f6          call   0xf686ef05
>   39:   90                      nop
>   3a:   0f 0b                   ud2
>   3c:   90                      nop
>   3d:   e9                      .byte 0xe9
>   3e:   75 fe                   jne    0x3e
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
> [ayushmanrout27@gmail.com johannes@sipsolutions.net linux-kernel@vger.ker=
nel.org linux-wireless@vger.kernel.org nbd@nbd.name syzbot@syzkaller.appspo=
tmail.com]
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
-upstream-moderation/6a7bce19.d5f0ebe7.22d851.0004.GAE%40google.com.
