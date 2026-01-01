Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB18E9463
	for <syzbot@lists.linux.dev>; Thu,  1 Jan 2026 09:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767260736; cv=none; b=WRDpVXADlgDbeLMo2+SPCzKenPaZGk0R5o+Akij4dJSW1xH058R4db49hW64BY1rBjxms99qL8EM0rc+ouSyh+usMVpqoI4tdQG9nOfchKXQdgz0H/j+RFYjpn0ODlugEr4Wubl0cwxex1U6bTOCj3G5kiPwi3FfMEiOmycD4p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767260736; c=relaxed/simple;
	bh=/W1lJNhDucVcFxI/aRWdfE1WF+Top4NgrhfTkNkiCAk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pskMQNp6rIfbl664WJHZYkK3NAkRyedyeBNNwIV1f43lymqNFzGNzBoR9KIwwq+REJ0c4m8OGHPvBjMyI+Tzl3qhaZ8exlq5YOJPcZoi5Tx3GZXxGCu1Ep2krN44vlxUjXPJbuFK3l9jim/Teha+5AWK1VOOggRkBa/h5XBjRd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L36u8lUJ; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L36u8lUJ"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-3ece54945d9so4052416fac.0
        for <syzbot@lists.linux.dev>; Thu, 01 Jan 2026 01:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767260732; x=1767865532; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNBjijVZAnGH9fesqKVdpkF+QDcfLS3WQdx6ipL4D9g=;
        b=L36u8lUJ+d2DvHhpnjG9uI+3H2c6tiMA2aKcTWPrThipAJVTs9SfG8LlgT8ytYWH7w
         BGJ/17NdeIDd4xYIqtU1RudsbCsdPKL7Tw8G5cD27Z7KMi1HX2FGoLo7MaS8xodqQe80
         kBVY9YX+MJnP8W8OFeBKuZmE6SCocHOQbEaJJnU3IeXTIrwJMhq7zJOwi1HvQWPBGBOJ
         PiZF/EGn0MrnR47krjj/RqmqwD3bmfsWuW/KHuLNAnDsjIH9B0hKlt+HXaN//hdexuC1
         B8Itxi4k/Q8GBxclEzNfYONQQlKfKJXhtzVI8e1ENtiwiP9fPJIr8koki+Q1iiJgC22a
         KMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767260732; x=1767865532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aNBjijVZAnGH9fesqKVdpkF+QDcfLS3WQdx6ipL4D9g=;
        b=j7H81u0pK6aqVAgIekqwirATJWVOh1djjFBijs3lPyJtHFvHfPFHeUwp7BfryR86qx
         baFVczxQtYJuZhCZJ02gqE9ls1RoLcs+h+RyRGGAWEhyHi00uIusWNoG3qBl9OK0DOsx
         bvDZq326dZwRzMHFH6MgUCl6t1yD+s5GYL20pb4I0FNM8vpP7ocG0AYYEHDKcC/Qj87z
         gl2gDMR5mHFmwwL9kASC/0L50Dkc0CmWggQd/GcY+tn3xuHp2fzTjYpo939MmOLr6LCn
         iCzYYbz080ISNhfDD64nowmpomOS5AkIOEEGI8t6ok0x0ZVPDB0g0dLOMXFRu671El0q
         sEYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGU6F37oE/lp2GMTLTLi7Z8ap+L7627tfOBwnvEStv3BTP+S2972/w93Lqmj+tpkFFk8yqX1I=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVDcWyhsLFdPpH2jPubC5m8TVW/PHqvzLkECRk50sOuONHpZu+
	8cC/Fr7yOMJjloTpYKPS/1lgPUBvsp6gSGXRTcoLI1ZcMZRLQLmyEtkZY3r++anNXcRsV5C7hyY
	Y3VqRKY/oYoPr0qX1eSdYcZDNyhUYAZrjqPWI6e6y
X-Gm-Gg: AY/fxX4va2iW5dI5BagfFyxnAR7h73PxkApwc3KgyHvQ770pcy/qyZMuy4qus6/tJZo
	tGntvXFx3BJZLytz9YzV+UwVEH+LqUmACLpuDdfRCnn8B+4ZzeNc7IcgCBnFFtRd6AdBAyTgE3m
	jRtUcXUBbHjXIsYfQU/ugiNJXCSwIZRV6Ut56zuJhalTkSxoyUNTLbwc/Gw3Zv3A+BPJEiNEzS2
	ubfblEagH+Q+SJikuHSpMA0iB5Xf+nwMB9sbDg5/0186pdfZ9CQocT8+JPUeoRgkfWW7kgUNu04
	Y4Pxa/j13Rpa0dz5xQ5sr5FeSTQ5ppfrQ+KHAFBVtXE/EuUf9AWwHogIvng6NKqRCm2kfOI=
X-Google-Smtp-Source: AGHT+IGNQZRT1yA0RARvLt+mZ70SEfJM4byouuHgdXo/XPz/CyhFDYuCo8/eWadJE74Gihm1edYq3BpMj/V4pzMSy9A=
X-Received: by 2002:a05:6820:6bc1:b0:65f:1012:69bc with SMTP id
 006d021491bc7-65f10126b29mr861536eaf.58.1767260732224; Thu, 01 Jan 2026
 01:45:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6955cf29.050a0220.a1b6.032f.GAE@google.com>
In-Reply-To: <6955cf29.050a0220.a1b6.032f.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 1 Jan 2026 10:45:21 +0100
X-Gm-Features: AQt7F2rdSmmWXq6eWZ-xvq8FPr72CJaqAzYe7vSFFx3laCXBTIOOL2KsaOHELIY
Message-ID: <CANp29Y5ptcsWhLnoWHYmNMFwvc6UXEVSC7JEBHXqqPb5HR+RPQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: lsm: Add hook unix_path_connect
To: syzbot ci <syzbot+cifad45bc79e094e2c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Jan 1, 2026 at 2:34=E2=80=AFAM syzbot ci
<syzbot+cifad45bc79e094e2c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] lsm: Add hook unix_path_connect
> https://lore.kernel.org/all/20251231213314.2979118-1-utilityemal77@gmail.=
com
> * [RFC PATCH 1/1] lsm: Add hook unix_path_connect
>
> and found the following issues:
> * KASAN: null-ptr-deref Read in unix_dgram_connect
> * general protection fault in apparmor_socket_sock_rcv_skb
> * general protection fault in unix_stream_connect
>
> Full report is available here:
> https://ci.syzbot.org/series/c288b2d0-af95-47d8-b359-79ff653da27b
>
> ***
>
> KASAN: null-ptr-deref Read in unix_dgram_connect
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      dbf8fe85a16a33d6b6bd01f2bc606fc017771465
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/9f532f02-856f-4157-a897-26c37e30c=
537/config
> C repro:   https://ci.syzbot.org/findings/d6706e7e-97bc-45af-910c-fb20c32=
8ac02/c_repro
> syz repro: https://ci.syzbot.org/findings/d6706e7e-97bc-45af-910c-fb20c32=
8ac02/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instru=
mented.h:68 [inline]
> BUG: KASAN: null-ptr-deref in _test_bit include/asm-generic/bitops/instru=
mented-non-atomic.h:141 [inline]
> BUG: KASAN: null-ptr-deref in sock_flag include/net/sock.h:1048 [inline]
> BUG: KASAN: null-ptr-deref in unix_dgram_connect+0x356/0xc20 net/unix/af_=
unix.c:1550
> Read of size 8 at addr 0000000000000060 by task syz.0.17/5977
>
> CPU: 0 UID: 0 PID: 5977 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  instrument_atomic_read include/linux/instrumented.h:68 [inline]
>  _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inli=
ne]
>  sock_flag include/net/sock.h:1048 [inline]
>  unix_dgram_connect+0x356/0xc20 net/unix/af_unix.c:1550
>  __sys_connect_file net/socket.c:2089 [inline]
>  __sys_connect+0x312/0x450 net/socket.c:2108
>  __do_sys_connect net/socket.c:2114 [inline]
>  __se_sys_connect net/socket.c:2111 [inline]
>  __x64_sys_connect+0x7a/0x90 net/socket.c:2111
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f78e4f9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc8b576858 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 00007f78e5205fa0 RCX: 00007f78e4f9acb9
> RDX: 000000000000006e RSI: 0000200000000280 RDI: 0000000000000005
> RBP: 00007f78e5008bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f78e5205fac R14: 00007f78e5205fa0 R15: 00007f78e5205fa0
>  </TASK>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> general protection fault in apparmor_socket_sock_rcv_skb
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      dbf8fe85a16a33d6b6bd01f2bc606fc017771465
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/9f532f02-856f-4157-a897-26c37e30c=
537/config
> C repro:   https://ci.syzbot.org/findings/7e600b6d-75f6-48a2-a2a0-c69a3aa=
daa9b/c_repro
> syz repro: https://ci.syzbot.org/findings/7e600b6d-75f6-48a2-a2a0-c69a3aa=
daa9b/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000096: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000004b0-0x00000000000004b7]
> CPU: 0 UID: 0 PID: 5987 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:aa_sock security/apparmor/include/net.h:57 [inline]
> RIP: 0010:apparmor_socket_sock_rcv_skb+0x3a/0x350 security/apparmor/lsm.c=
:1513
> Code: ec 10 49 89 f7 48 89 fb 49 bd 00 00 00 00 00 fc ff df e8 99 57 6f f=
d 48 89 5c 24 08 48 81 c3 b0 04 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 17 54 d6 fd 44 8b 25 20 70 74 09
> RSP: 0018:ffffc90004237530 EFLAGS: 00010206
> RAX: 0000000000000096 RBX: 00000000000004b0 RCX: ffff88816872d7c0
> RDX: 0000000000000000 RSI: ffff888110f4e600 RDI: 0000000000000000
> RBP: ffffc900042376d0 R08: ffffffff82447acc R09: ffffffff8e341b20
> R10: dffffc0000000000 R11: ffffed102388124c R12: ffff888110f4e67e
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888110f4e600
> FS:  00007f36295926c0(0000) GS:ffff88818e40e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3629591ff8 CR3: 0000000113938000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  security_sock_rcv_skb+0x8f/0x270 security/security.c:4333
>  sk_filter_trim_cap+0x19b/0xd90 net/core/filter.c:156
>  sk_filter include/linux/filter.h:1102 [inline]
>  unix_dgram_sendmsg+0x7bc/0x17b0 net/unix/af_unix.c:2173
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x500/0x810 net/socket.c:2592
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
>  __sys_sendmmsg+0x27c/0x4e0 net/socket.c:2735
>  __do_sys_sendmmsg net/socket.c:2762 [inline]
>  __se_sys_sendmmsg net/socket.c:2759 [inline]
>  __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2759
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f362879acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3629592028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007f3628a06090 RCX: 00007f362879acb9
> RDX: 0000000000000002 RSI: 0000200000000ec0 RDI: 0000000000000006
> RBP: 00007f3628808bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3628a06128 R14: 00007f3628a06090 R15: 00007ffcf5635f88
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:aa_sock security/apparmor/include/net.h:57 [inline]
> RIP: 0010:apparmor_socket_sock_rcv_skb+0x3a/0x350 security/apparmor/lsm.c=
:1513
> Code: ec 10 49 89 f7 48 89 fb 49 bd 00 00 00 00 00 fc ff df e8 99 57 6f f=
d 48 89 5c 24 08 48 81 c3 b0 04 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 17 54 d6 fd 44 8b 25 20 70 74 09
> RSP: 0018:ffffc90004237530 EFLAGS: 00010206
> RAX: 0000000000000096 RBX: 00000000000004b0 RCX: ffff88816872d7c0
> RDX: 0000000000000000 RSI: ffff888110f4e600 RDI: 0000000000000000
> RBP: ffffc900042376d0 R08: ffffffff82447acc R09: ffffffff8e341b20
> R10: dffffc0000000000 R11: ffffed102388124c R12: ffff888110f4e67e
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888110f4e600
> FS:  00007f36295926c0(0000) GS:ffff88818e40e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3629591ff8 CR3: 0000000113938000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 2 bytes skipped:
>    0:   49 89 f7                mov    %rsi,%r15
>    3:   48 89 fb                mov    %rdi,%rbx
>    6:   49 bd 00 00 00 00 00    movabs $0xdffffc0000000000,%r13
>    d:   fc ff df
>   10:   e8 99 57 6f fd          call   0xfd6f57ae
>   15:   48 89 5c 24 08          mov    %rbx,0x8(%rsp)
>   1a:   48 81 c3 b0 04 00 00    add    $0x4b0,%rbx
>   21:   48 89 d8                mov    %rbx,%rax
>   24:   48 c1 e8 03             shr    $0x3,%rax
> * 28:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2d:   74 08                   je     0x37
>   2f:   48 89 df                mov    %rbx,%rdi
>   32:   e8 17 54 d6 fd          call   0xfdd6544e
>   37:   44 8b 25 20 70 74 09    mov    0x9747020(%rip),%r12d        # 0x9=
74705e
>
>
> ***
>
> general protection fault in unix_stream_connect
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      dbf8fe85a16a33d6b6bd01f2bc606fc017771465
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/9f532f02-856f-4157-a897-26c37e30c=
537/config
> C repro:   https://ci.syzbot.org/findings/b05720e7-cc44-4796-b729-e2f0c0b=
9e015/c_repro
> syz repro: https://ci.syzbot.org/findings/b05720e7-cc44-4796-b729-e2f0c0b=
9e015/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc00000000dc: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000006e0-0x00000000000006e7]
> CPU: 1 UID: 0 PID: 6000 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kasan_byte_accessible+0x12/0x30 mm/kasan/generic.c:210
> Code: 79 ff ff ff 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 9=
0 90 0f 1f 40 d6 48 c1 ef 03 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 07 3c=
 08 0f 92 c0 e9 40 68 4e 09 cc 66 66 66 66 66 66 2e
> RSP: 0018:ffffc90003f47c00 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: ffffffff8b7776ee RCX: 0000000080000002
> RDX: 0000000000000000 RSI: ffffffff8b7776ee RDI: 00000000000000dc
> RBP: ffffffff8a18a569 R08: 0000000000000001 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffed1037900903 R12: 0000000000000000
> R13: 00000000000006e0 R14: 00000000000006e0 R15: 0000000000000001
> FS:  00007fe5e870a6c0(0000) GS:ffff8882a9a0e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe5e77e8400 CR3: 0000000114c7e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __kasan_check_byte+0x12/0x40 mm/kasan/common.c:573
>  kasan_check_byte include/linux/kasan.h:402 [inline]
>  lock_acquire+0x84/0x330 kernel/locking/lockdep.c:5842
>  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>  spin_lock include/linux/spinlock.h:351 [inline]
>  unix_stream_connect+0x469/0x1010 net/unix/af_unix.c:1692
>  __sys_connect_file net/socket.c:2089 [inline]
>  __sys_connect+0x312/0x450 net/socket.c:2108
>  __do_sys_connect net/socket.c:2114 [inline]
>  __se_sys_connect net/socket.c:2111 [inline]
>  __x64_sys_connect+0x7a/0x90 net/socket.c:2111
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe5e779acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe5e870a028 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 00007fe5e7a05fa0 RCX: 00007fe5e779acb9
> RDX: 000000000000006e RSI: 0000200000000000 RDI: 0000000000000005
> RBP: 00007fe5e7808bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe5e7a06038 R14: 00007fe5e7a05fa0 R15: 00007ffcf198af58
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:kasan_byte_accessible+0x12/0x30 mm/kasan/generic.c:210
> Code: 79 ff ff ff 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 9=
0 90 0f 1f 40 d6 48 c1 ef 03 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 07 3c=
 08 0f 92 c0 e9 40 68 4e 09 cc 66 66 66 66 66 66 2e
> RSP: 0018:ffffc90003f47c00 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: ffffffff8b7776ee RCX: 0000000080000002
> RDX: 0000000000000000 RSI: ffffffff8b7776ee RDI: 00000000000000dc
> RBP: ffffffff8a18a569 R08: 0000000000000001 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffed1037900903 R12: 0000000000000000
> R13: 00000000000006e0 R14: 00000000000006e0 R15: 0000000000000001
> FS:  00007fe5e870a6c0(0000) GS:ffff8882a9a0e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe5e77e8400 CR3: 0000000114c7e000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 4 bytes skipped:
>    0:   0f 1f 40 00             nopl   0x0(%rax)
>    4:   90                      nop
>    5:   90                      nop
>    6:   90                      nop
>    7:   90                      nop
>    8:   90                      nop
>    9:   90                      nop
>    a:   90                      nop
>    b:   90                      nop
>    c:   90                      nop
>    d:   90                      nop
>    e:   90                      nop
>    f:   90                      nop
>   10:   90                      nop
>   11:   90                      nop
>   12:   90                      nop
>   13:   90                      nop
>   14:   0f 1f 40 d6             nopl   -0x2a(%rax)
>   18:   48 c1 ef 03             shr    $0x3,%rdi
>   1c:   48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
>   23:   fc ff df
> * 26:   0f b6 04 07             movzbl (%rdi,%rax,1),%eax <-- trapping in=
struction
>   2a:   3c 08                   cmp    $0x8,%al
>   2c:   0f 92 c0                setb   %al
>   2f:   e9 40 68 4e 09          jmp    0x94e6874
>   34:   cc                      int3
>   35:   66                      data16
>   36:   66                      data16
>   37:   66                      data16
>   38:   66                      data16
>   39:   66                      data16
>   3a:   66                      data16
>   3b:   2e                      cs
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
> [gnoack3000@gmail.com gnoack@google.com horms@kernel.org jmorris@namei.or=
g kuniyu@google.com linux-security-module@vger.kernel.org m@maowtm.org mic@=
digikod.net netdev@vger.kernel.org paul@paul-moore.com serge@hallyn.com uti=
lityemal77@gmail.com]
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
-upstream-moderation/6955cf29.050a0220.a1b6.032f.GAE%40google.com.
