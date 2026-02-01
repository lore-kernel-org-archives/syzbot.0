Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFA522FAFD
	for <syzbot@lists.linux.dev>; Sun,  1 Feb 2026 11:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769946563; cv=pass; b=koyhtaNzoK5b7UCRJk/aPb31D+gbVczrw9tPBiUfQ8JZ8kfdfxd5aGiaSTWQc7atHnVw6ix5ZMjJ2GTHCn8jr1z94u2UB4DPtIre3l3xszKCJ85UuqJmnuI9IiNCWEFvSbiugo4FFFCWMG4WUMgR/qnqIrz40C4qhr3Hxvt1SAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769946563; c=relaxed/simple;
	bh=A1pTyCk88xRQUlZhkV6HO8A7FvhZxPaoD3dyjNXOZaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u1IlKuNlHv8yeygnt2qpio5YMekZ6DHIJyPmQ2YrjrfG1lm7jGfaYqbwkRcakKE0wyPO2x4EIsbdyfbdLeOdZxhcpH+nhBpUiOAekV/54MtZqzRVzPJoCwKyZw/7nI+BLhGJZlD916C5V2KAYWvMr+0VDoyR5P0F4Q+T0+mCO1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4MXjH0p6; arc=pass smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4MXjH0p6"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-662f30d3f1fso2453805eaf.1
        for <syzbot@lists.linux.dev>; Sun, 01 Feb 2026 03:49:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769946560; cv=none;
        d=google.com; s=arc-20240605;
        b=DCIU4WXhLX1V1oVWQ1VlJiNanY2T0VukIelXnB2XBBjEf9ujfo+mNDk0c7VHG/InUX
         buz5kDpk2IH2UlHfQoUyOE4dwj/70twnxPpJRd7lVBaQaSBFsPfywImnmfzEiUvab/O1
         1rMRFaE4LqjFA9UOpHP1UTY0JM9U5cpf4JmaLRMjDVM6zGHRUrkpEhd6sD8yK77VUgyC
         0/oB/n7o91OI97TuqL7dRxv6s/18tjuD2RL7jdrVe1LSpbcgnhy7uMLrFD6ND68zKaBi
         0zIh3Xux0mswor1Z4/oqZ5uJiR7ZK2Bhu7CwfhDp/0fzoCzcjaeoVwqXGjYFYevBrzdW
         FWyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=glzulbeVxZTPqsiFqjCiFcZssOXsbFKUDzg4Ig/ZgKg=;
        fh=VWaifbs878C8+rmxVeQbkSLV2tWOlVENrZYVudpcJPY=;
        b=GEwYzHtIzxWxhEx68JlIPkJ01UMHEutBEKEpf8+u2EJC7cAdUQqh+wilXZewNeRqjE
         AK9lWza8rB7D1JmLD53W3BZPi3sLUwAK6i5J+Gcjgx6CmwP8QlasquAjXqy2kbbHtkIj
         oe+xpw9YBQUaD99SNQGkkGv1FMHv6HaWJYN1KJaCwUmhIcv36RqUk4yCDjPnqbh68hjS
         vgGTXBgakAky/gxGWrTCR1CTi9iWHxKsTiuHd+UjlDnOXE8njgyKUiXooOa+xzKNe0/D
         na+CWM56B1YKnU90nK/Vec2Sk8p897uccwCYHjj2iGOckytRosBVErPpZVtGmtb4xSbC
         daAw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769946560; x=1770551360; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glzulbeVxZTPqsiFqjCiFcZssOXsbFKUDzg4Ig/ZgKg=;
        b=4MXjH0p6zjiVSGAwooIoQHqPtmmoNIuGshjWtEyNBb3aZTTQbgYJofIbPhUcmCfv5r
         GTiWAWKJyiepWL09ps0pqm7w8XdP4oqhmkmE8vQ4Gk07WaXbRNiERyHSj0MloFicBNP7
         RR3j+wVpvyeChiwmxDc51ZIVKBrjfcbyXof5i4+TBO/qghvAFsPLk1c34kG665i/+HAe
         Yul+dK8Atu64eCnedJP45PxydF094mb8CPY/rf+qift10VQLjdCaJQ7fZoYZw6Wt9Ema
         BcX4YNpKVu6RmjK4fZGmxBGEzJqD3cx5Y7NGzVrRdTVMwC6kWL0OcbUW5L4tQgJ4h/os
         +7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769946560; x=1770551360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=glzulbeVxZTPqsiFqjCiFcZssOXsbFKUDzg4Ig/ZgKg=;
        b=TlNYoyNMPLUv0JpSFgSuQ/3aohvwI5V3F07aYUfiwnlVPQgbN7O4DqsaC57w680bdj
         sUiza3xAT4tcRp8kHs6FI42BiXzwy6gYsw1YXGJ6dIwlDUOpiyaTeuDvR0Js9u6zp89n
         6SnFi0CdGL7SjtGcLoPCWzJjQ2UtsbhR/mz63fvAjLMvhxm3jkfh0sLtiRVUA37t5tkv
         BUdwAZY5bTXyZlgV+cZRnzo0chl5L/d/mRCL+7FQo2y6oloINWU7Xw6zAQTgITJ7dcdk
         jSpOEn3F+eeNxAum1rKt3yBPZBYOdGwMfXGv5XWpkQvfyaPsOhRldYutPoX0F1F01xbT
         FG6g==
X-Forwarded-Encrypted: i=1; AJvYcCUzxfzGij0DaNMQUnA2b8x+9B8PFvMcTDNZavvijJVSkkIyZVq6unrjNE1B7FEGs5U3pVAfYZE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTcSGWnhEf3GMUVxdtjS99SQJgWPAWccThDdEmB++HAt6ZW/hg
	dy9M/09ED2OJXNOR0FPxgv5nEcfJf4kJOlManVvO6QoMvNCyS/Kwxby68xXlaVzDrbJJejdQmGG
	0Ns9XCHsPxoTX/E20QpZa3sY/8ksDaQvQYB1zvCuRAyAZMLYsgFf3g9Ts0xo=
X-Gm-Gg: AZuq6aLVAN9S4/4tmb1ElwfpC6jh3LvvCCEdFC6ImnyAubtF1R5+T1jMQm7FvtKwX0H
	8G9DBryTGd/t/vm8mX0ze8SxW6fD0S+gV6qA/T0MRNfD0pXTYSv1mWp5teOjxmgo5fuH2B0YN3X
	yINPqGdhaqykFuO09bLzSLKAD/slMKWdd3MBQP+Ycpi/479/eSsAb3Elhh+vKCxNF/D4Tu68ODm
	NHu5/3dU8G6sc7mGVMwF8KLhs0/EGD3IKL4ZEK0d65NlBh9KkU+/iqO0qofq6bteX0MX3NXJc7Z
	kZes5Lq4Wj8OIriWpN4F3nV2WhJn1WwzlTMqzaSykcqPd2Fi9ZFLLhwmqwin
X-Received: by 2002:a05:6820:2904:b0:662:f763:c530 with SMTP id
 006d021491bc7-66310299eebmr3246247eaf.3.1769946559600; Sun, 01 Feb 2026
 03:49:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <697f3ce9.050a0220.16b13.00a0.GAE@google.com>
In-Reply-To: <697f3ce9.050a0220.16b13.00a0.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 1 Feb 2026 12:49:08 +0100
X-Gm-Features: AZwV_Qhv28PBCiJdw4Q1wC-8xMWkMx148a6MqPf5Mb6zc55Dwb66aaqN0DkcKQI
Message-ID: <CANp29Y6CdccOECNPEsHN3bnrRO70gMVreEpprz_oL7Vr4Cvx=g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fs/super: fix s_fs_info leak when
 setup_bdev_super() fails
To: syzbot ci <syzbot+cic03c8693696b6e83@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Feb 1, 2026 at 12:45=E2=80=AFPM syzbot ci
<syzbot+cic03c8693696b6e83@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fs/super: fix s_fs_info leak when setup_bdev_super() fails
> https://lore.kernel.org/all/20260201073226.3445853-1-shardul.b@mpiricsoft=
ware.com
> * [PATCH] fs/super: fix s_fs_info leak when setup_bdev_super() fails
>
> and found the following issues:
> * general protection fault in erofs_kill_sb
> * general protection fault in fuse_kill_sb_blk
> * general protection fault in ntfs3_kill_sb
> * general protection fault in xfs_mount_free
>
> Full report is available here:
> https://ci.syzbot.org/series/34ca307f-9eb2-40cb-881d-22abe7ea1c0b
>
> ***
>
> general protection fault in erofs_kill_sb
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      602544773763da411ffa67567fa1d146f3a40231
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/ff62b70a-8cc2-476e-8c76-3012c5b4a=
d76/config
> C repro:   https://ci.syzbot.org/findings/a774c7af-2849-4e3d-ae0d-489b13e=
32852/c_repro
> syz repro: https://ci.syzbot.org/findings/a774c7af-2849-4e3d-ae0d-489b13e=
32852/syz_repro
>
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
r/w without journal. Quota mode: writeback.
> ext4 filesystem being mounted at /0/bus supports timestamps until 2038-01=
-19 (0x7fffffff)
> /dev/loop0: Can't open blockdev
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000002: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 1 UID: 0 PID: 5991 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:erofs_kill_sb+0x4c/0x190 fs/erofs/super.c:906
> Code: 9f 38 06 00 00 48 89 dd 48 c1 ed 03 42 80 7c 2d 00 00 74 08 48 89 d=
f e8 82 83 eb fd 4c 8b 33 4d 8d 66 10 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 e7 e8 65 83 eb fd 49 83 3c 24 00 74 0f
> RSP: 0018:ffffc900039e7b58 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff88816ed88638 RCX: ffff88816c548000
> RDX: 0000000000000000 RSI: ffffffff8dad1d20 RDI: ffff88816ed88000
> RBP: 1ffff1102ddb10c7 R08: ffffffff8fcec177 R09: 1ffffffff1f9d82e
> R10: dffffc0000000000 R11: ffffffff843ef960 R12: 0000000000000010
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88816ed88000
> FS:  000055558ffb4500(0000) GS:ffff8882a9942000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30763fff CR3: 00000001127bc000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  deactivate_locked_super+0xbc/0x130 fs/super.c:474
>  get_tree_bdev_flags+0x4b4/0x560 fs/super.c:1698
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1756
>  fc_mount fs/namespace.c:1199 [inline]
>  do_new_mount_fc fs/namespace.c:3636 [inline]
>  do_new_mount+0x329/0xa50 fs/namespace.c:3712
>  do_mount fs/namespace.c:4035 [inline]
>  __do_sys_mount fs/namespace.c:4224 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4201
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xf0/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f3a7139acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff10bbdc58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f3a71615fa0 RCX: 00007f3a7139acb9
> RDX: 0000200000000700 RSI: 00002000000006c0 RDI: 0000200000000640
> RBP: 00007f3a71408bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3a71615fac R14: 00007f3a71615fa0 R15: 00007f3a71615fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:erofs_kill_sb+0x4c/0x190 fs/erofs/super.c:906
> Code: 9f 38 06 00 00 48 89 dd 48 c1 ed 03 42 80 7c 2d 00 00 74 08 48 89 d=
f e8 82 83 eb fd 4c 8b 33 4d 8d 66 10 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 e7 e8 65 83 eb fd 49 83 3c 24 00 74 0f
> RSP: 0018:ffffc900039e7b58 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff88816ed88638 RCX: ffff88816c548000
> RDX: 0000000000000000 RSI: ffffffff8dad1d20 RDI: ffff88816ed88000
> RBP: 1ffff1102ddb10c7 R08: ffffffff8fcec177 R09: 1ffffffff1f9d82e
> R10: dffffc0000000000 R11: ffffffff843ef960 R12: 0000000000000010
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88816ed88000
> FS:  000055558ffb4500(0000) GS:ffff8882a9942000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30763fff CR3: 00000001127bc000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   9f                      lahf
>    1:   38 06                   cmp    %al,(%rsi)
>    3:   00 00                   add    %al,(%rax)
>    5:   48 89 dd                mov    %rbx,%rbp
>    8:   48 c1 ed 03             shr    $0x3,%rbp
>    c:   42 80 7c 2d 00 00       cmpb   $0x0,0x0(%rbp,%r13,1)
>   12:   74 08                   je     0x1c
>   14:   48 89 df                mov    %rbx,%rdi
>   17:   e8 82 83 eb fd          call   0xfdeb839e
>   1c:   4c 8b 33                mov    (%rbx),%r14
>   1f:   4d 8d 66 10             lea    0x10(%r14),%r12
>   23:   4c 89 e0                mov    %r12,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 e7                mov    %r12,%rdi
>   34:   e8 65 83 eb fd          call   0xfdeb839e
>   39:   49 83 3c 24 00          cmpq   $0x0,(%r12)
>   3e:   74 0f                   je     0x4f
>
>
> ***
>
> general protection fault in fuse_kill_sb_blk
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      602544773763da411ffa67567fa1d146f3a40231
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/ff62b70a-8cc2-476e-8c76-3012c5b4a=
d76/config
> C repro:   https://ci.syzbot.org/findings/23ab56a2-425c-4ce8-ba8d-1743bb4=
b889d/c_repro
> syz repro: https://ci.syzbot.org/findings/23ab56a2-425c-4ce8-ba8d-1743bb4=
b889d/syz_repro
>
> EXT4-fs (loop0): 1 orphan inode deleted
> EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 =
ro without journal. Quota mode: writeback.
> /dev/loop0: Can't open blockdev
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 5983 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:fuse_mount_destroy fs/fuse/inode.c:2118 [inline]
> RIP: 0010:fuse_kill_sb_blk+0x210/0x270 fs/fuse/inode.c:2145
> Code: fe 4c 89 ff e8 d1 b5 ff ff 48 89 ef e8 79 5d 00 ff 43 80 3c 2e 00 7=
4 08 48 89 df e8 0a da ed fe 48 8b 1b 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 f1 d9 ed fe 48 8b 3b e8 f9 6a ff
> RSP: 0018:ffffc90003c17af8 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888118069d40
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000ffffffff
> RBP: ffff8881168e0000 R08: ffff8881168e0077 R09: 1ffff11022d1c00e
> R10: dffffc0000000000 R11: ffffed1022d1c00f R12: ffff8881168e0068
> R13: dffffc0000000000 R14: 1ffff11022d1c0c7 R15: 0000000000000000
> FS:  0000555591c2f500(0000) GS:ffff88818e342000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000002000 CR3: 00000001115be000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  deactivate_locked_super+0xbc/0x130 fs/super.c:474
>  get_tree_bdev_flags+0x4b4/0x560 fs/super.c:1698
>  fuse_get_tree+0x23c/0x4f0 fs/fuse/inode.c:2003
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1756
>  fc_mount fs/namespace.c:1199 [inline]
>  do_new_mount_fc fs/namespace.c:3636 [inline]
>  do_new_mount+0x329/0xa50 fs/namespace.c:3712
>  do_mount fs/namespace.c:4035 [inline]
>  __do_sys_mount fs/namespace.c:4224 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4201
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xf0/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f29dd79acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffc5c2bf88 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f29dda15fa0 RCX: 00007f29dd79acb9
> RDX: 0000200000000080 RSI: 0000200000000040 RDI: 0000200000000000
> RBP: 00007f29dd808bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000003000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f29dda15fac R14: 00007f29dda15fa0 R15: 00007f29dda15fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:fuse_mount_destroy fs/fuse/inode.c:2118 [inline]
> RIP: 0010:fuse_kill_sb_blk+0x210/0x270 fs/fuse/inode.c:2145
> Code: fe 4c 89 ff e8 d1 b5 ff ff 48 89 ef e8 79 5d 00 ff 43 80 3c 2e 00 7=
4 08 48 89 df e8 0a da ed fe 48 8b 1b 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 f1 d9 ed fe 48 8b 3b e8 f9 6a ff
> RSP: 0018:ffffc90003c17af8 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888118069d40
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000ffffffff
> RBP: ffff8881168e0000 R08: ffff8881168e0077 R09: 1ffff11022d1c00e
> R10: dffffc0000000000 R11: ffffed1022d1c00f R12: ffff8881168e0068
> R13: dffffc0000000000 R14: 1ffff11022d1c0c7 R15: 0000000000000000
> FS:  0000555591c2f500(0000) GS:ffff88818e342000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000002000 CR3: 00000001115be000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   fe 4c 89 ff             decb   -0x1(%rcx,%rcx,4)
>    4:   e8 d1 b5 ff ff          call   0xffffb5da
>    9:   48 89 ef                mov    %rbp,%rdi
>    c:   e8 79 5d 00 ff          call   0xff005d8a
>   11:   43 80 3c 2e 00          cmpb   $0x0,(%r14,%r13,1)
>   16:   74 08                   je     0x20
>   18:   48 89 df                mov    %rbx,%rdi
>   1b:   e8 0a da ed fe          call   0xfeedda2a
>   20:   48 8b 1b                mov    (%rbx),%rbx
>   23:   48 89 d8                mov    %rbx,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   48 89 df                mov    %rbx,%rdi
>   34:   e8 f1 d9 ed fe          call   0xfeedda2a
>   39:   48 8b 3b                mov    (%rbx),%rdi
>   3c:   e8                      .byte 0xe8
>   3d:   f9                      stc
>   3e:   6a ff                   push   $0xffffffffffffffff
>
>
> ***
>
> general protection fault in ntfs3_kill_sb
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      602544773763da411ffa67567fa1d146f3a40231
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/ff62b70a-8cc2-476e-8c76-3012c5b4a=
d76/config
> C repro:   https://ci.syzbot.org/findings/701e05cd-daef-4ecc-9716-2188883=
c4d68/c_repro
> syz repro: https://ci.syzbot.org/findings/701e05cd-daef-4ecc-9716-2188883=
c4d68/syz_repro
>
> F2FS-fs (loop0): f2fs_recover_fsync_data: recovery fsync data, check_only=
: 0
> F2FS-fs (loop0): Try to recover 1th superblock, ret: 0
> F2FS-fs (loop0): Mounted with checkpoint version =3D 48b305e5
> /dev/loop0: Can't open blockdev
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000137: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000009b8-0x00000000000009bf]
> CPU: 1 UID: 0 PID: 5980 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ntfs3_kill_sb+0x52/0x1c0 fs/ntfs3/super.c:1864
> Code: 03 42 80 3c 38 00 74 05 e8 6b 1f 0f ff 49 8b 9e 38 06 00 00 4c 89 f=
7 e8 bc a2 21 ff 4c 8d b3 b8 09 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00=
 74 08 4c 89 f7 e8 3f 1f 0f ff 4d 8b 36 4d 85 f6 74
> RSP: 0018:ffffc90004087b70 EFLAGS: 00010202
> RAX: 0000000000000137 RBX: 0000000000000000 RCX: ffff88810a281d40
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000ffffffff
> RBP: ffffc90004087c00 R08: ffff88811696a077 R09: 1ffff11022d2d40e
> R10: dffffc0000000000 R11: ffffed1022d2d40f R12: dffffc0000000000
> R13: ffff88811696a638 R14: 00000000000009b8 R15: dffffc0000000000
> FS:  00005555632f0500(0000) GS:ffff8882a9942000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f12cce706c0 CR3: 0000000173c4e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  deactivate_locked_super+0xbc/0x130 fs/super.c:474
>  get_tree_bdev_flags+0x4b4/0x560 fs/super.c:1698
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1756
>  fc_mount fs/namespace.c:1199 [inline]
>  do_new_mount_fc fs/namespace.c:3636 [inline]
>  do_new_mount+0x329/0xa50 fs/namespace.c:3712
>  do_mount fs/namespace.c:4035 [inline]
>  __do_sys_mount fs/namespace.c:4224 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4201
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xf0/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f12ccf9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffeb8b65048 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f12cd215fa0 RCX: 00007f12ccf9acb9
> RDX: 00002000000000c0 RSI: 0000200000000180 RDI: 0000200000000100
> RBP: 00007f12cd008bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f12cd215fac R14: 00007f12cd215fa0 R15: 00007f12cd215fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ntfs3_kill_sb+0x52/0x1c0 fs/ntfs3/super.c:1864
> Code: 03 42 80 3c 38 00 74 05 e8 6b 1f 0f ff 49 8b 9e 38 06 00 00 4c 89 f=
7 e8 bc a2 21 ff 4c 8d b3 b8 09 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00=
 74 08 4c 89 f7 e8 3f 1f 0f ff 4d 8b 36 4d 85 f6 74
> RSP: 0018:ffffc90004087b70 EFLAGS: 00010202
> RAX: 0000000000000137 RBX: 0000000000000000 RCX: ffff88810a281d40
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 00000000ffffffff
> RBP: ffffc90004087c00 R08: ffff88811696a077 R09: 1ffff11022d2d40e
> R10: dffffc0000000000 R11: ffffed1022d2d40f R12: dffffc0000000000
> R13: ffff88811696a638 R14: 00000000000009b8 R15: dffffc0000000000
> FS:  00005555632f0500(0000) GS:ffff8882a9942000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f12cce706c0 CR3: 0000000173c4e000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   03 42 80                add    -0x80(%rdx),%eax
>    3:   3c 38                   cmp    $0x38,%al
>    5:   00 74 05 e8             add    %dh,-0x18(%rbp,%rax,1)
>    9:   6b 1f 0f                imul   $0xf,(%rdi),%ebx
>    c:   ff 49 8b                decl   -0x75(%rcx)
>    f:   9e                      sahf
>   10:   38 06                   cmp    %al,(%rsi)
>   12:   00 00                   add    %al,(%rax)
>   14:   4c 89 f7                mov    %r14,%rdi
>   17:   e8 bc a2 21 ff          call   0xff21a2d8
>   1c:   4c 8d b3 b8 09 00 00    lea    0x9b8(%rbx),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 3f 1f 0f ff          call   0xff0f1f78
>   39:   4d 8b 36                mov    (%r14),%r14
>   3c:   4d 85 f6                test   %r14,%r14
>   3f:   74                      .byte 0x74
>
>
> ***
>
> general protection fault in xfs_mount_free
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      602544773763da411ffa67567fa1d146f3a40231
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/ff62b70a-8cc2-476e-8c76-3012c5b4a=
d76/config
> C repro:   https://ci.syzbot.org/findings/5b7b1e1a-4d82-45fc-a796-e0633aa=
2c690/c_repro
> syz repro: https://ci.syzbot.org/findings/5b7b1e1a-4d82-45fc-a796-e0633aa=
2c690/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> JBD2: Ignoring recovery information on journal
> ocfs2: Mounting device (7,0) on (node local, slot 0) with ordered data mo=
de.
> /dev/loop0: Can't open blockdev
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000034: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000001a0-0x00000000000001a7]
> CPU: 1 UID: 0 PID: 5983 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:xfs_mount_free+0x27/0x1a0 fs/xfs/xfs_super.c:815
> Code: 90 90 90 41 57 41 56 41 54 53 48 89 fb 49 bc 00 00 00 00 00 fc ff d=
f e8 d7 f1 41 fe 4c 8d b3 a0 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 f7 e8 9a 24 a9 fe 4d 8b 36 4d 85 f6 74
> RSP: 0018:ffffc90004077b68 EFLAGS: 00010202
> RAX: 0000000000000034 RBX: 0000000000000000 RCX: ffff88816aad1d40
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
> RBP: ffffc90004077c00 R08: ffff8881b715c077 R09: 1ffff11036e2b80e
> R10: dffffc0000000000 R11: ffffed1036e2b80f R12: dffffc0000000000
> R13: ffff8881b715c638 R14: 00000000000001a0 R15: ffff8881b715c768
> FS:  00005555782c2500(0000) GS:ffff8882a9942000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001200 CR3: 0000000174202000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  deactivate_locked_super+0xbc/0x130 fs/super.c:474
>  get_tree_bdev_flags+0x4b4/0x560 fs/super.c:1698
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1756
>  fc_mount fs/namespace.c:1199 [inline]
>  do_new_mount_fc fs/namespace.c:3636 [inline]
>  do_new_mount+0x329/0xa50 fs/namespace.c:3712
>  do_mount fs/namespace.c:4035 [inline]
>  __do_sys_mount fs/namespace.c:4224 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4201
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xf0/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f341a99acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff965f4398 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f341ac15fa0 RCX: 00007f341a99acb9
> RDX: 0000200000001200 RSI: 00002000000000c0 RDI: 0000200000000240
> RBP: 00007f341aa08bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000280c002 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f341ac15fac R14: 00007f341ac15fa0 R15: 00007f341ac15fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:xfs_mount_free+0x27/0x1a0 fs/xfs/xfs_super.c:815
> Code: 90 90 90 41 57 41 56 41 54 53 48 89 fb 49 bc 00 00 00 00 00 fc ff d=
f e8 d7 f1 41 fe 4c 8d b3 a0 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 f7 e8 9a 24 a9 fe 4d 8b 36 4d 85 f6 74
> RSP: 0018:ffffc90004077b68 EFLAGS: 00010202
> RAX: 0000000000000034 RBX: 0000000000000000 RCX: ffff88816aad1d40
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000000
> RBP: ffffc90004077c00 R08: ffff8881b715c077 R09: 1ffff11036e2b80e
> R10: dffffc0000000000 R11: ffffed1036e2b80f R12: dffffc0000000000
> R13: ffff8881b715c638 R14: 00000000000001a0 R15: ffff8881b715c768
> FS:  00005555782c2500(0000) GS:ffff8882a9942000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001200 CR3: 0000000174202000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   90                      nop
>    1:   90                      nop
>    2:   90                      nop
>    3:   41 57                   push   %r15
>    5:   41 56                   push   %r14
>    7:   41 54                   push   %r12
>    9:   53                      push   %rbx
>    a:   48 89 fb                mov    %rdi,%rbx
>    d:   49 bc 00 00 00 00 00    movabs $0xdffffc0000000000,%r12
>   14:   fc ff df
>   17:   e8 d7 f1 41 fe          call   0xfe41f1f3
>   1c:   4c 8d b3 a0 01 00 00    lea    0x1a0(%rbx),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 20 00          cmpb   $0x0,(%rax,%r12,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 9a 24 a9 fe          call   0xfea924d3
>   39:   4d 8b 36                mov    (%r14),%r14
>   3c:   4d 85 f6                test   %r14,%r14
>   3f:   74                      .byte 0x74
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
> [brauner@kernel.org jack@suse.cz janak@mpiricsoftware.com linux-fsdevel@v=
ger.kernel.org linux-kernel@vger.kernel.org shardul.b@mpiricsoftware.com sh=
ardulsb08@gmail.com slava@dubeyko.com syzbot@syzkaller.appspotmail.com viro=
@zeniv.linux.org.uk]
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
-upstream-moderation/697f3ce9.050a0220.16b13.00a0.GAE%40google.com.
