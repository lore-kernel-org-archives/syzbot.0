Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622453E3C5B
	for <syzbot@lists.linux.dev>; Mon, 13 Apr 2026 19:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109639; cv=pass; b=YUu/9yqIy/pkZYn13FhER2xEPDphGvkE3cgYAmocBvFI+0PHWZAPeOOH29EZKyluaIYpAKfMPTDyOEWNGsF7EiSJ/Klf35patAH3lcb1hDKiFd7NHuHV0ookrsXALGY5y+D+lXgc6iDSkWIbAFnMWDEMUQvtgQCRHqu/MyxX44A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109639; c=relaxed/simple;
	bh=wkElOcQFCO1hrpkiPRLDtOviGgeV0mbZAKrihbuRmRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g8Zfje/I0U0A39ct6DceoitJhtDlGQ3z4NBsJddSrE4SLd+b5LKyI1lUsr9/Z4dKMavODKEyASGKJhdBGfU5bNGhRpIiAE4bPWjLz23YnxkMIzxcR+qyZZkE2167D1BQcOiopanros8hKQDoxQMmychFt8SN1pF8WEyAYxajoWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HBSoOBq8; arc=pass smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HBSoOBq8"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7dbcd61429cso2290940a34.2
        for <syzbot@lists.linux.dev>; Mon, 13 Apr 2026 12:47:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776109636; cv=none;
        d=google.com; s=arc-20240605;
        b=UnF+YhhdI5WFVDusYNyeq++20uhLri7jygZHGJasrn7Pi+qaz7a0tSDOBLAZW3BSZP
         OkywNA3kbCALqbWIE9c2gSuoZGC9rCxF5D32EVSI38LLzMBA9R9f0qjev2OMt86JJoCs
         nKQQnfmoIi7hwc8DxZTjqezUFot//CR1aMBZxDRRYaxmj0oy3hVv3cHJYeCzQPaKoQEi
         uw1sM6kGEhBVsqbHz+QL8wFiQq839CMHht/suFcFzrbP2wjcXbMveVQ44Y7hzFCJu3Ov
         Xy46QZ/Ui3ZFZYx+2jBoDeGev4eEvA3LJnFkXnKeBYydy87RbVcuxgryPLUjrWp2LAAS
         zy1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N0LCVJ+lzEO7uWM1FPrZthtwg31sY9kHmhgsHSHkdSw=;
        fh=5KE0p05yEAkpvHvnqI6keZZQHZqU538bWEw8Cq4Sm3A=;
        b=YdOKQtP0HM1k9xYOsU5hzgKqRpJHITC5b+VZy0JfAa+y03IHglCxDwPbYVd8Rp/cwt
         X+8MJAn2w5Khm6W9R6LZcjxUUFUidH/hMjhbZzSCMxgxo/E/Ga4q6NYa2S3WfsT2eP9q
         fKQllO1QvNI65t9tzzLaa6XYdaKuGQNbE+QyhyK/wb7nP3GpIwgikSA2HTgZkIq3DuHG
         fLvUx48F7ZuAw9S4tGS2ytPFiCBk6Hy2Ki+fipfaHmeNRPjL+EtJh7/G3iABpWySxpb9
         sY3kOMQHYSqJkHxUq5aisKgXEYTsYFsjvJWbZT7sdAgzOkLJIL3vE50uwI5nklztMHjW
         z4gQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776109636; x=1776714436; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N0LCVJ+lzEO7uWM1FPrZthtwg31sY9kHmhgsHSHkdSw=;
        b=HBSoOBq87pf2pyTue+ycxNaGGX0Jk1VbNzw/jzCdyWYCbE1Fef2mhiYj8pv0C+BVcb
         p/T9dTFRF4jj7yYg8fKon6ka/az02NGUbjsL+77ouAKx44+S3ypXvnqcLU3n6URxAS2v
         pP/EDnPcwKHF86YRhA6HKrkF8QX23Rg3HJf0PVa+Itg9+etQFMPgNzMdELT4rzXbyxon
         Xp9e5FwBKMYzbFUMlep995+vattvBPfJvQE4F2VQS0Go9JyvtvqprS22tjc8JhjvZKui
         xMyjSuFLzsvtjm7Iw6N8N8j06msYKVhlk3BTKzg7OfJwAK7f2Apo+wNno+31XOiQT8Hv
         8+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776109636; x=1776714436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N0LCVJ+lzEO7uWM1FPrZthtwg31sY9kHmhgsHSHkdSw=;
        b=Y1NV9TNLBMu6lz9563TnbNpiWgyVLRLhy/bkUJElXySZ3oB/ywgAmm/15eZrPwb/E4
         q+y7Vktxzw/r06TSjLwoLAdcWewBXc9H+8KVvf7sk96EyZDXbWiDKu1rEOciwUkrVBau
         4vSVUPoFA/SkqwWJtij5CB0ItY1rO/ZieDdawUfWBMh4nvQk4V8Zx0ihfK+Vp+bL5wmI
         dw67Io9WW5Dm5urkm5z27EaPNBEyny4HY3RjjJnMmVlGgZYNpuDWoi99SJkbLpFvtguA
         b3iZI/ObeATaZS0XvAvce/yNf/jbWExX24+PEbx39VkQqEc5QZNXkZEpoPCkUCj6pBD3
         hhAQ==
X-Forwarded-Encrypted: i=1; AFNElJ9YYwzEwPkV7PtQeVSAxflStnyNB5AQdfQUYkvOv08vdEA/dRLGKQAoSS1gG0PB6A+oyMYcQ1E=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkNIq81z6a6rkk3hxKXC5SxnzDqe8o6NnUSEHu2jmKWQibtOP0
	KGMhREEy/4IwOu9FR4DkTdoMJIuNv6aSwEUCNw/NmEgRNJElyvtkON+T7BC423XVd4vztyszBq7
	hn2DDco40zdTejoQejGwp+W5B4luBas9w1kjfyJlN
X-Gm-Gg: AeBDiessTwtOPKTTbmVUqW4Axw/vXGmPihd4C9A75CpNf7VAA2ugkbruRoxM0FwBG0t
	THYNVKwHQyi+uMu9tK3xolzFMKBPCxuh8H/bbpYCPdlG3hrbKEVnXPUzZsrMqSrTjOFHQrWdVZe
	TJHH58SmUZ4EevWr4z/BimX/Qnnp/XzBh5SW2HCGNSz0jMlQDTSj5KnkwrYyvHBBIePlGM65egv
	ml4KFRnrW74uoSgp4Ll+d9Uv69mlmxQsZVsw/t13wBo/V775gcHBArtZ+s62pod10oT5GH4sSwy
	Lnf0vzMfPaK2n+QpbZKzfV6fPIhCXUEqvKf5/G9mwuP6VmlhEYccJ98KbMC4IAOwy6hCo36PJjx
	JSWHg4z8iDeKuTZXS
X-Received: by 2002:a05:6820:810c:b0:67e:313e:22bf with SMTP id
 006d021491bc7-68be7de906emr6702713eaf.31.1776109635758; Mon, 13 Apr 2026
 12:47:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69dd2844.a00a0220.475f0.002b.GAE@google.com>
In-Reply-To: <69dd2844.a00a0220.475f0.002b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 13 Apr 2026 21:47:04 +0200
X-Gm-Features: AQROBzCNIN-0Kh82ZzQsKAwhQxVKAc64x3xMvHYZGRFcaRIWpFkoelicafmhyZU
Message-ID: <CANp29Y5YPcmNqTRDDgHmdJBqbMt7j6DwVGWyrZOLAgkQ8VSPFA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: veth: add Byte Queue Limits (BQL) support
To: syzbot ci <syzbot+ci7a77f1f31610a460@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Apr 13, 2026 at 7:30=E2=80=AFPM syzbot ci
<syzbot+ci7a77f1f31610a460@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] veth: add Byte Queue Limits (BQL) support
> https://lore.kernel.org/all/20260413094442.1376022-1-hawk@kernel.org
> * [PATCH net-next v2 1/5] net: add dev->bql flag to allow BQL sysfs for I=
FF_NO_QUEUE devices
> * [PATCH net-next v2 2/5] veth: implement Byte Queue Limits (BQL) for lat=
ency reduction
> * [PATCH net-next v2 3/5] veth: add tx_timeout watchdog as BQL safety net
> * [PATCH net-next v2 4/5] net: sched: add timeout count to NETDEV WATCHDO=
G message
> * [PATCH net-next v2 5/5] selftests: net: add veth BQL stress test
>
> and found the following issue:
> WARNING in veth_napi_del_range
>
> Full report is available here:
> https://ci.syzbot.org/series/ee732006-8545-4abd-a105-b4b1592a7baf
>
> ***
>
> WARNING in veth_napi_del_range
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      8806d502e0a7e7d895b74afbd24e8550a65a2b17
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/90743a26-f003-44cf-abcc-5991c4758=
8b2/config
> syz repro: https://ci.syzbot.org/findings/d068bfb2-9f8b-466a-95b4-cd7e7b0=
0006c/syz_repro
>
> ------------[ cut here ]------------
> index >=3D dev->num_tx_queues
> WARNING: ./include/linux/netdevice.h:2672 at netdev_get_tx_queue include/=
linux/netdevice.h:2672 [inline], CPU#0: syz.1.27/6002
> WARNING: ./include/linux/netdevice.h:2672 at veth_napi_del_range+0x3b7/0x=
4e0 drivers/net/veth.c:1142, CPU#0: syz.1.27/6002
> Modules linked in:
> CPU: 0 UID: 0 PID: 6002 Comm: syz.1.27 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:netdev_get_tx_queue include/linux/netdevice.h:2672 [inline]
> RIP: 0010:veth_napi_del_range+0x3b7/0x4e0 drivers/net/veth.c:1142
> Code: 00 e8 ad 96 69 fe 44 39 6c 24 10 74 5e e8 41 61 44 fb 41 ff c5 49 b=
c 00 00 00 00 00 fc ff df e9 6d ff ff ff e8 2a 61 44 fb 90 <0f> 0b 90 42 80=
 3c 23 00 75 8e eb 94 48 8b 0c 24 80 e1 07 80 c1 03
> RSP: 0018:ffffc90003adf918 EFLAGS: 00010293
> RAX: ffffffff86814ec6 RBX: 1ffff110227a6c03 RCX: ffff888103a857c0
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
> RBP: 1ffff110227a6c9a R08: ffff888113f01ab7 R09: 0000000000000000
> R10: ffff888113f01a98 R11: ffffed10227e0357 R12: dffffc0000000000
> R13: 0000000000000002 R14: 0000000000000002 R15: ffff888113d36018
> FS:  000055555ea16500(0000) GS:ffff88818de4a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007efc287456b8 CR3: 000000010cdd0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  veth_napi_del drivers/net/veth.c:1153 [inline]
>  veth_disable_xdp+0x1b0/0x310 drivers/net/veth.c:1255
>  veth_xdp_set drivers/net/veth.c:1693 [inline]
>  veth_xdp+0x48e/0x730 drivers/net/veth.c:1717
>  dev_xdp_propagate+0x125/0x260 net/core/dev_api.c:348
>  bond_xdp_set drivers/net/bonding/bond_main.c:5715 [inline]
>  bond_xdp+0x3ca/0x830 drivers/net/bonding/bond_main.c:5761
>  dev_xdp_install+0x42c/0x600 net/core/dev.c:10387
>  dev_xdp_detach_link net/core/dev.c:10579 [inline]
>  bpf_xdp_link_release+0x362/0x540 net/core/dev.c:10595
>  bpf_link_free+0x103/0x480 kernel/bpf/syscall.c:3292
>  bpf_link_put_direct kernel/bpf/syscall.c:3344 [inline]
>  bpf_link_release+0x6b/0x80 kernel/bpf/syscall.c:3351
>  __fput+0x44f/0xa70 fs/file_table.c:469
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
>  do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5bda39c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdca2969e8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007f5bda617da0 RCX: 00007f5bda39c819
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 00007f5bda617da0 R08: 00007f5bda616128 R09: 0000000000000000
> R10: 000000000003fd78 R11: 0000000000000246 R12: 0000000000010fb8
> R13: 00007f5bda61609c R14: 0000000000010cdd R15: 00007ffdca296af0
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [andrew@lunn.ch ast@kernel.org bpf@vger.kernel.org corbet@lwn.net daniel@=
iogearbox.net davem@davemloft.net edumazet@google.com frederic@kernel.org h=
awk@kernel.org horms@kernel.org j.koeppeler@tu-berlin.de jhs@mojatatu.com j=
iri@resnulli.us john.fastabend@gmail.com kernel-team@cloudflare.com krikku@=
gmail.com kuba@kernel.org kuniyu@google.com linux-doc@vger.kernel.org linux=
-kernel@vger.kernel.org linux-kselftest@vger.kernel.org netdev@vger.kernel.=
org pabeni@redhat.com sdf@fomichev.me shuah@kernel.org skhan@linuxfoundatio=
n.org yajun.deng@linux.dev]
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
-upstream-moderation/69dd2844.a00a0220.475f0.002b.GAE%40google.com.
