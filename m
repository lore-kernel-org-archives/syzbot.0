Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3523621D3CD
	for <syzbot@lists.linux.dev>; Tue,  9 Dec 2025 23:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765323366; cv=none; b=KE+YNVbIzV2ob6+ftzZras/vQB/zbnnbAPhkRCndAcChqR4357ey0rs4tr+VXrCuHXXIF91wD4QumGUGoDqSXVqP9h/AsyODzWab/nn4sVoaS0aaveRubpGTOy6foDe3QcHE0NhiXwUoYNSl1JlFsPVTRsmqTSIN2YTn9pURmaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765323366; c=relaxed/simple;
	bh=EReD5yjhK4fxCdKuLeEKGXaUaEIJ4HIpsl9PKa2c/kY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O0qeVHHszTIgFg2gxGEWCcx66V0lzwRiKSigkBrmnWbeP8spWcOHTMFlgS8QbyLhjNTKX/zukBTmfGWqKnAwiNDuCUjKBW50H2lewOHQmyz6WRSXmhMJS+12OG9d1CXSgYgN+wfDuacZK305dPo4VH90g3MgzvfvLWzC9tBxP2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WnKLu9al; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WnKLu9al"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3f11ad6e76fso4001319fac.1
        for <syzbot@lists.linux.dev>; Tue, 09 Dec 2025 15:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765323363; x=1765928163; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Y8yp30rN2hybgPt9/y+iy1ggeW2PbRAFS/Bc4pPrD0=;
        b=WnKLu9alPqVt+vWcXpNji/pevHlW/ckW7LpY3+8KigBYE59+Iiysp+zdCu9zZRUmxE
         mEwAimMRZQAW0TpqC/l9Jh5bbAJnxh4MncGRKsIfLpWJ5O8V99jKLs+ZaJJ4tlCch2TG
         Jd1RAW5ycrwxinDGNAV2npNM/NjwZcC3UtMzIORlyg1QlzTcymQ17YfKjZ1iYeNK9EcV
         U4i4kqJ625VU/GJF4kgrsEddX+DJJDN1RtI4yoWf5vqSazYe8H2DcslDkcc6wXlrfo3y
         FrHuTk3N+j3sSvTY+gD0jGmS0L/+20JjsSx29IR4w/eKHw8uM8zEevAnXeayHMHvCE5H
         HKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765323363; x=1765928163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Y8yp30rN2hybgPt9/y+iy1ggeW2PbRAFS/Bc4pPrD0=;
        b=Q8U2O8TXwC5SY8CdsbXp/e/hTDFqvabeofK3BZdkIXVPL1lC5M7ANbmd0kjhkL6EGP
         o8f2H+c05Fs8wY5ctXGEdETXc2KvhHrDffNtAy774E2E35MXQywT4lCWUKa/vPNyTxQh
         lUEPKjvyotrQ7C3CQNyaWyjtlobmBj9dbumkSovGo868Gh5ze6S51JKuA5vjS+9to68s
         nyK4gJbAvm1p4uwC2dWn8gMFjU850xEWMPNV9HgKT2drwXCg2+lACz29GUTO0CQIEwfb
         GXoPCJYOcN3FP5w3EM2f4Ud4CoBTaMS0hkek+ZHTKvNXUp5HJyjbJNV7SlSxI9nW2Iam
         36mA==
X-Forwarded-Encrypted: i=1; AJvYcCUdLZU15Gn3b5RfJ12DywSk0nwONH0Yg7CJJ56TYZ7Y9B1/AJVlEGopVbpXSXYvvkJ3sGC9T/k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwtU/rVrdPFlJkbiUSlOX0KmfRl1dia5EyTSQ1gB0WbpjersxDO
	1464Q82F4LB5E9WzZu/KWESaKKQKLW4t9JtVgA8VIgm3ings8PWyRXXA1WwTvEJTHptD/DBeNej
	o7WTqynHlXyRrFoR70YQ7boyVpkw+7cI=
X-Gm-Gg: ASbGncuZc1APy2be2ZejBaJx8Vc7W2OARsDvboBKKDqt+dV6LymYVgEzsN3TNo9IdjW
	SnVhQPyy8ByFWyyfqmVSLsJnGMgvZDyI3XuspshI0h39L39XjYe/fL5aWqMgg5trzFfXcqqms5h
	M+YtBdZyn2/kg3tTocQe/Px6pfLdi0rytrp0BMVFujyHuuhGgy9+OsJN904u7LbNX+C6Tz5mQX1
	jVqK53TMe2eqbgVadV01SQgx2tHYHy6uDSm1A7v3oa9OK0N3ZjaCaXDbmA8qg0W29t45Q==
X-Google-Smtp-Source: AGHT+IE9rmdzqsYCfcGOfLGCvc3m3B/v6SGmSE5uceWiBdfKlMyTlEF6tRBug3x/w/gQyLvvRdV7Bx35jU/5P/7+lW0=
X-Received: by 2002:a05:6820:f021:b0:659:9a49:9059 with SMTP id
 006d021491bc7-65b2ac652bcmr421138eaf.36.1765323363185; Tue, 09 Dec 2025
 15:36:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251209085950.96231-1-kerneljasonxing@gmail.com> <6938323e.a70a0220.104cf0.0008.GAE@google.com>
In-Reply-To: <6938323e.a70a0220.104cf0.0008.GAE@google.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 10 Dec 2025 07:35:26 +0800
X-Gm-Features: AQt7F2rfQziaWOQtkGJMlTgExjxOlJFo4UnYUxSgSgOQBZ2SZyEjLXRosxbeXD0
Message-ID: <CAL+tcoBfzeCfu7PF_TKP_+w_AMCACLMDdw_vvkqGbamBcyeMwQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: xsk: introduce pre-allocated memory per xsk CQ
To: syzbot ci <syzbot+cib018e69d32b0c0b5@syzkaller.appspotmail.com>
Cc: ast@kernel.org, bjorn@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	hawk@kernel.org, john.fastabend@gmail.com, jonathan.lemon@gmail.com, 
	kernelxing@tencent.com, kuba@kernel.org, maciej.fijalkowski@intel.com, 
	magnus.karlsson@intel.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	sdf@fomichev.me, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 10:29=E2=80=AFPM syzbot ci
<syzbot+cib018e69d32b0c0b5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] xsk: introduce pre-allocated memory per xsk CQ
> https://lore.kernel.org/all/20251209085950.96231-1-kerneljasonxing@gmail.=
com
> * [PATCH bpf-next v1 1/2] xsk: introduce local_cq for each af_xdp socket
> * [PATCH bpf-next v1 2/2] xsk: introduce a dedicated local completion que=
ue for each xsk
>
> and found the following issue:
> WARNING in vfree
>
> Full report is available here:
> https://ci.syzbot.org/series/5df45d2b-41d6-4675-b3ad-4503516a9ae1
>
> ***
>
> WARNING in vfree
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      835a50753579aa8368a08fca307e638723207768
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/726617c2-a613-4879-9987-91e65545d=
ba1/config
> C repro:   https://ci.syzbot.org/findings/0c82a0b1-8cb3-49ae-9fbe-fa3bd02=
c2ba0/c_repro
> syz repro: https://ci.syzbot.org/findings/0c82a0b1-8cb3-49ae-9fbe-fa3bd02=
c2ba0/syz_repro

Very similar issue that I've explained in another two threads. In this
case where xsk that is the r1 socket here only initializes the rx
queue rather than the completion queue, xsk_init_local_cq() reads the
nentries of pool cq that actually is zero. So in xsk_release()
clearing the 0 bytes lcq area led to the following warning.

Thanks,
Jason

>
> ------------[ cut here ]------------
> Trying to vfree() nonexistent vm area (ffffc900034e6000)
> WARNING: mm/vmalloc.c:3423 at 0x0, CPU#0: syz.0.19/5983
> Modules linked in:
> CPU: 0 UID: 0 PID: 5983 Comm: syz.0.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vfree+0x393/0x400 mm/vmalloc.c:3422
> Code: e8 72 1d ab ff 4c 89 f7 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e=
9 0c fa ff ff e8 57 1d ab ff 48 8d 3d 10 fc 6e 0d 4c 89 f6 <67> 48 0f b9 3a=
 e9 fd fd ff ff e8 3e 1d ab ff 4c 89 e7 e8 66 00 00
> RSP: 0018:ffffc90004e37c40 EFLAGS: 00010293
> RAX: ffffffff82162d09 RBX: 0000000000000000 RCX: ffff88816c66d7c0
> RDX: 0000000000000000 RSI: ffffc900034e6000 RDI: ffffffff8f852920
> RBP: 1ffff1102289d8bf R08: ffff88810005f1bb R09: 1ffff1102000be37
> R10: dffffc0000000000 R11: ffffed102000be38 R12: ffff88801eed1818
> R13: dffffc0000000000 R14: ffffc900034e6000 R15: ffff8881144ec608
> FS:  0000555574db2500(0000) GS:ffff88818eab1000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000000c0 CR3: 0000000112a48000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  xsk_clear_local_cq net/xdp/xsk.c:1188 [inline]
>  xsk_release+0x6b3/0x880 net/xdp/xsk.c:1220
>  __sock_release net/socket.c:653 [inline]
>  sock_close+0xc3/0x240 net/socket.c:1446
>  __fput+0x44c/0xa70 fs/file_table.c:468
>  task_work_run+0x1d4/0x260 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
>  exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7eff8518f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd6ca61b78 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 000000000001253b RCX: 00007eff8518f7c9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000001 R09: 000000086ca61e6f
> R10: 0000001b2f920000 R11: 0000000000000246 R12: 00007eff853e5fac
> R13: 00007eff853e5fa0 R14: ffffffffffffffff R15: 0000000000000003
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   e8 72 1d ab ff          call   0xffab1d77
>    5:   4c 89 f7                mov    %r14,%rdi
>    8:   48 83 c4 18             add    $0x18,%rsp
>    c:   5b                      pop    %rbx
>    d:   41 5c                   pop    %r12
>    f:   41 5d                   pop    %r13
>   11:   41 5e                   pop    %r14
>   13:   41 5f                   pop    %r15
>   15:   5d                      pop    %rbp
>   16:   e9 0c fa ff ff          jmp    0xfffffa27
>   1b:   e8 57 1d ab ff          call   0xffab1d77
>   20:   48 8d 3d 10 fc 6e 0d    lea    0xd6efc10(%rip),%rdi        # 0xd6=
efc37
>   27:   4c 89 f6                mov    %r14,%rsi
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   e9 fd fd ff ff          jmp    0xfffffe31
>   34:   e8 3e 1d ab ff          call   0xffab1d77
>   39:   4c 89 e7                mov    %r12,%rdi
>   3c:   e8                      .byte 0xe8
>   3d:   66 00 00                data16 add %al,(%rax)
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
