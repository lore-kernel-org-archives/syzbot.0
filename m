Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6D6270ED7
	for <syzbot@lists.linux.dev>; Thu, 29 Jan 2026 13:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769693057; cv=pass; b=tE4H9WjKW5ScuP3qulBwSdbMPNRJ4XlOsSAMYvPsLEr/E6qX32KS87JquGQEtfUawRcJI6VHMbNPvQzwDRgRF5Gkh2PDwN0yostRp7Fm0hOYmvXa3ZzmzrPM28nG1BO/NBB/30fyHbLjyySj6FNKdH5LweWiRgNKIiH0dRb827E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769693057; c=relaxed/simple;
	bh=HmONVKzdfNBjt0QS5g6yaehIoJxF8oNL8Job0e0+NfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nBwgK8vOVkmx+5RwiZjVqHrSNVxKL6Tr0wu6l1s3B0tG+yPVHnglbj3B+FYm7Rvp7hSVsC/TBBMyMeyCM69NO5I1dZbxZJYNu5+n9+EKFtrJp/xSaXjvU9Isf7unQDiY2MIhdlCv3WLTiIA84wymv/UzPsVinjUBjI83O0urUbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ef/F6p84; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ef/F6p84"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-662f4faf95aso516779eaf.1
        for <syzbot@lists.linux.dev>; Thu, 29 Jan 2026 05:24:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769693054; cv=none;
        d=google.com; s=arc-20240605;
        b=NK4n9IpoeEMooLzEd2p+gV4JO3chq7PkY4zRcS14kL7Aqh6FNP47Ygc+/jyLD9OxzV
         irpD6bBKlrH7fR2EDBgmWNOjLbh9RCyf40qaVngMFHoD2nHEzqwnbQbkvKmTgOVhfWG8
         svTkBbfuXPI66oFvY/A8PebXRD0+sHkKH4pohVd2S9JyzTieJJWSMklACi43bMsNXk8E
         FBHWJQwpV3T2ZMmkoSPMQ2oF+wRpERKzTTHOG5mLA0xUe0NCs6uTtXnHMOHzsx1vX0W6
         DCUFICVJ0s/8auNfHq5wjwfUTBO6aEtnxy9Y5djI9PJGazO33GkTnqcSDszZhGk9MDLD
         i2Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2F3Fu6J0a3iVxG8w77hChmmLLEUzNRhHQYg0GBz0/NM=;
        fh=8ingbd6y8Yc/h3eDTuMjgnpooYJ49sK8JKg9YH/EKPs=;
        b=fVHdgjI5USAUC4C4KbiAu92wk3QeozOA2NhF3c2StU1VWhaJaEHP3LuGgowN+BAr60
         MxE8R3REN99svTymbHOuNiGKslS5Kfc5IFZWDDnPv4MgMIRjMEN/0dnchl2/K7gAhBYM
         OS1e1yvg6/PSTt7wzcQTRsay9yivw4r5+wpxRZ3LfEzMASm23RhMWA6+m1b9zFHjWrFK
         ko4hmPKSGmV1Wd5y9pC/cofD3wYzvTN288ZN6ho8Bjk83dU38exoOA/ALcqdZDMnOdYi
         fpst1kXTXGZTZ2NkYRmCKd3M8mrhYhMlw+faIB2qd1DN5mcO7uLCSzBhqoqGgj91zPks
         JvGg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769693054; x=1770297854; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2F3Fu6J0a3iVxG8w77hChmmLLEUzNRhHQYg0GBz0/NM=;
        b=ef/F6p84ccG67YvXui4JwjSau0EA3IF1hTqUHvHz/4XpqMp5H6KSooyJdJBnuB7mfN
         5ayFCHW781cABW123MNh5Ua0los3bFcni0SaSrRmdRhasjtN557dVSCTM0t1VCU81v09
         ShI26gERQrRm0cN2dY/kjKmOFRJ42cyOX/jTk5HraLhJ3nVLwQVf0Hy++ALsKmtV3dVm
         Quiimk3BQWSkxAW7tZzGfikQ9BamsJQeDHVxCYt+/IDwMxgi+VQ11DZo9PnbFaYyjmNo
         qBBfZbLou32wCMvaSscBzLoSOHjZIGQWqvF4KxmIriMVh1wLAjUPMSM0gTaJ6fhlO7aj
         6c4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769693054; x=1770297854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2F3Fu6J0a3iVxG8w77hChmmLLEUzNRhHQYg0GBz0/NM=;
        b=hiSo5HrEZDibDGuNkEr+kSmKkUKsOCLAGd8ELzPe8EugDGdwaCkYsH5JB7CmILqAUO
         P1SyDhnas+XOWFCz/YBpQdeedPTbTZqL0XT1g4XpQln7/tlfe9Gz3sjA0u7MS6TQcySw
         0fD16ztTmKT2fbFA1gLTUmn40SlbO80NJmxi4z7i0MkspQzBqqzVIXCdtoEJ48spfRWY
         M6xO4TfBo2lNCMYyCgaJmlmLtu2las7c1G1tzUBmBjGwogOOcnOG4TuEEhKtiWu/eR38
         /L4GztnPSJY0lE8uNofaKCi/nFfJDMkxwbj+vNmoS+H0IQk2uEnE7gomdAHk6EDjNJ2P
         iE6A==
X-Forwarded-Encrypted: i=1; AJvYcCUXlHX+gg+bZsF1U9+Y/l7jCmwVW9ybW45X/rNoxLSzO3QNKh9ul/2AC6K4c210bA6aPgIk5FQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdjAfqGfK+AXvWs5MP1toaJJkcuvPyYJW49II0YiLWFL6F0f3h
	kMv3kAEVg8g4XNi5/d2Orl96HJ1bZ+g2K24Cf8vjg33gDLsW1sihm9mzjjweeEggg/XxcjWJmRA
	yIEkKtTCkTKVb5Uz+g1mNZM9IXvp7VuxaUwjnzn3cOqQ7RqOnD6nK8i9N
X-Gm-Gg: AZuq6aI4INnXe+6CUrZTIVPxyOE6VD2X5PdSH9nhLmFQty1xr3FgbEwCz+wj2qoJTnB
	grVDGTX5c0po20XYnDZsey2G+BOCT24YcBpEibbfdRdf1d+CaHtQFelM08Sm7c0PKCHZK0ABAtf
	OWPNbol7jMmYkkIRPlS9aBVGInGnvHOL9dTnnNsROFyhHGV+1T/P22/2i6togi5I8hUja87RkOS
	miZAIgiY1VYz1JI3Xwqtlmfe7ZW5XwW1BQQBNpgaMFHwp0bs4vABVl3pg/hyedKGfa6yEvYWD8e
	4qralwREVoHG6tI8vjI2BXkJBQtJSKbm78nwan7gatUwVPSVLOkUE9/pAQ==
X-Received: by 2002:a05:6820:61b:b0:663:74a:f0b4 with SMTP id
 006d021491bc7-663074af4d0mr1345855eaf.38.1769693054319; Thu, 29 Jan 2026
 05:24:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <697b5413.a00a0220.35f26.0008.GAE@google.com>
In-Reply-To: <697b5413.a00a0220.35f26.0008.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 29 Jan 2026 14:24:03 +0100
X-Gm-Features: AZwV_QgbTJ2UnKFM9btApv2ekZlEtaoUCsp61zjkt_yAM6-l7Q8mv0vCnJq3GB0
Message-ID: <CANp29Y6d1=gfqS=4uJ_bUFjH2A-JFBttZ6WBfM=qsNG5XSyqxQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: virtio-net: add flow filter for receive timestamps
To: syzbot ci <syzbot+ci6ec41e9f54857adc@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Jan 29, 2026 at 1:35=E2=80=AFPM syzbot ci
<syzbot+ci6ec41e9f54857adc@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] virtio-net: add flow filter for receive timestamps
> https://lore.kernel.org/all/20260129-v6-7-topic-virtio-net-ptp-v2-0-30a27=
dc52760@pengutronix.de
> * [PATCH RFC v2 1/2] tun: support rx-tstamp
> * [PATCH RFC v2 2/2] virtio-net: support receive timestamp
>
> and found the following issue:
> WARNING in __copy_overflow
>
> Full report is available here:
> https://ci.syzbot.org/series/0b35c8c9-603b-4126-ac04-0095faadb2f5
>
> ***
>
> WARNING in __copy_overflow
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      ffeafa65b2b26df2f5b5a6118d3174f17bd12ec5
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/d8316da2-2688-4d74-bbf4-e8412e24d=
106/config
> C repro:   https://ci.syzbot.org/findings/96af937a-787b-4fd5-baef-529fc80=
e0bb7/c_repro
> syz repro: https://ci.syzbot.org/findings/96af937a-787b-4fd5-baef-529fc80=
e0bb7/syz_repro
>
> ------------[ cut here ]------------
> Buffer overflow detected (32 < 1840)!
> WARNING: mm/maccess.c:234 at __copy_overflow+0x17/0x30 mm/maccess.c:234, =
CPU#0: syz.0.17/5993
> Modules linked in:
> CPU: 0 UID: 0 PID: 5993 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__copy_overflow+0x1c/0x30 mm/maccess.c:234
> Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 53 48 89 f=
3 89 fd e8 60 b1 c4 ff 48 8d 3d 39 25 d5 0d 89 ee 48 89 da <67> 48 0f b9 3a=
 5b 5d c3 cc cc cc cc cc cc cc cc cc cc cc cc 90 90
> RSP: 0018:ffffc90003b97888 EFLAGS: 00010293
> RAX: ffffffff81fdcf50 RBX: 0000000000000730 RCX: ffff88810ccd9d40
> RDX: 0000000000000730 RSI: 0000000000000020 RDI: ffffffff8fd2f490
> RBP: 0000000000000020 R08: ffffffff8fcec777 R09: 1ffffffff1f9d8ee
> R10: dffffc0000000000 R11: ffffffff81742230 R12: dffffc0000000000
> R13: 0000000000000000 R14: 0000000000000730 R15: 1ffff92000772f30
> FS:  00007f08c446a6c0(0000) GS:ffff88818e32d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f08c4448ff8 CR3: 000000010cec2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  copy_overflow include/linux/ucopysize.h:41 [inline]
>  check_copy_size include/linux/ucopysize.h:50 [inline]
>  copy_to_iter include/linux/uio.h:219 [inline]
>  tun_put_user drivers/net/tun.c:2089 [inline]
>  tun_do_read+0x1f44/0x28a0 drivers/net/tun.c:2190
>  tun_chr_read_iter+0x13b/0x260 drivers/net/tun.c:2214
>  do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
>  vfs_readv+0x288/0x840 fs/read_write.c:1018
>  do_readv+0x154/0x2e0 fs/read_write.c:1080
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f08c359acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f08c446a028 EFLAGS: 00000246 ORIG_RAX: 0000000000000013
> RAX: ffffffffffffffda RBX: 00007f08c3815fa0 RCX: 00007f08c359acb9
> RDX: 0000000000000002 RSI: 0000200000000080 RDI: 0000000000000003
> RBP: 00007f08c3608bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f08c3816038 R14: 00007f08c3815fa0 R15: 00007fff6491da78
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   90                      nop
>    1:   90                      nop
>    2:   90                      nop
>    3:   90                      nop
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
>    e:   f3 0f 1e fa             endbr64
>   12:   55                      push   %rbp
>   13:   53                      push   %rbx
>   14:   48 89 f3                mov    %rsi,%rbx
>   17:   89 fd                   mov    %edi,%ebp
>   19:   e8 60 b1 c4 ff          call   0xffc4b17e
>   1e:   48 8d 3d 39 25 d5 0d    lea    0xdd52539(%rip),%rdi        # 0xdd=
5255e
>   25:   89 ee                   mov    %ebp,%esi
>   27:   48 89 da                mov    %rbx,%rdx
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   5b                      pop    %rbx
>   30:   5d                      pop    %rbp
>   31:   c3                      ret
>   32:   cc                      int3
>   33:   cc                      int3
>   34:   cc                      int3
>   35:   cc                      int3
>   36:   cc                      int3
>   37:   cc                      int3
>   38:   cc                      int3
>   39:   cc                      int3
>   3a:   cc                      int3
>   3b:   cc                      int3
>   3c:   cc                      int3
>   3d:   cc                      int3
>   3e:   90                      nop
>   3f:   90                      nop
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
> [andrew@lunn.ch davem@davemloft.net edumazet@google.com eperezma@redhat.c=
om jasowang@redhat.com kuba@kernel.org linux-kernel@vger.kernel.org mst@red=
hat.com netdev@vger.kernel.org pabeni@redhat.com richardcochran@gmail.com s=
.trumtrar@pengutronix.de virtualization@lists.linux.dev willemdebruijn.kern=
el@gmail.com xuanzhuo@linux.alibaba.com]
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
-upstream-moderation/697b5413.a00a0220.35f26.0008.GAE%40google.com.
