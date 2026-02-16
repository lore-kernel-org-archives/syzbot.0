Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139DE3770B
	for <syzbot@lists.linux.dev>; Mon, 16 Feb 2026 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771264067; cv=pass; b=p1Q2eB2NzQiEVus6FgDIW8BsKDtFT49N92dqUXq/pnKtgDknh6dguaU7sx0rHLFmKY+RM8xMh/e8Qm9iu68qC7Yy1g3exP+9vxC4Fvm0XLuGY8IkTWTJzM/FKvP8inn0ssTKuOUPEOqO5/5nKdnlD9KfE08dfEax3Vw/W6LYoC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771264067; c=relaxed/simple;
	bh=nHeGYluRKaulOrBXoKgKmb41db5/3m56E0AiC8l6s04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ocjguSdPO7fVm/ac5eg3YlZrdDvHhqRdPRKJDbDhnIhZ7rMiF8M4BfFjHrLqKc4o5ta3FT2cEL2zWR5AQxo7GlsjiAInM64+z3D7Z+i7HYN0dO+pPT8dAx+8c4TTrvnfWbcJuvDZTbJdSVRGxdM270CHpaySZnwllrr4YMuScik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s4okWC4k; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s4okWC4k"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-676e5c56fe1so1179631eaf.1
        for <syzbot@lists.linux.dev>; Mon, 16 Feb 2026 09:47:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771264065; cv=none;
        d=google.com; s=arc-20240605;
        b=iCvt8kXyhHeP7jgVYbuBVsCGgeMnmTAvw5nhJ1xdwh4sSsNts0UzElhorRmqcQbrlq
         P5M2A9aK8x+wzo5AyyTnLTfSyySOClSo4HBEcf7iTZXfGfVdbDbRh3T5OXywXreuH/3X
         2ixSJF85rYzH0YpWS3zGhczDJiqwcWmCTKANcrTJKpbu//mp0poykwYxi4bhc/H4KT59
         VD+CsSNZQpck8LZgktBNs1WpX4htfUHZt1zFfFvZqvm8f7iDVMkV7bdAYWywAmTE0QpT
         mWNx8ysNBX3nWFdGs1VvvAK5hDA88HAkIGT4wLU/kjah+kz3AvkGrM932mES4wwiQnS4
         5BXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fiz9vNkfNVq/gHFV0vWF/BjW9v8x3UMDLwSp/LcBcI0=;
        fh=NVsiJWuyz7c70e7VjSF1X9mykpVxfKdMhJyIlpCW14w=;
        b=Tb4uPlAihPvk7bI7QsXR6ucQ9tZ6M+10UQE97MjdlMc0P1g+F++FphT28b+LJZhZEt
         BfkRkR6RQoI6V6HJE0qMd0wNZTWMw0cODiYLCKiq5mNLjJaU8GPIC71eiJ7lzzDtQpMa
         /pxUKNxmBAQ1RDleskioIRwzA7/oeaNHtZv/9jBuBRJCS8HqFn+npQrQGy0NH9e6x6bQ
         fpcMJXdYUfjFIrEpEd9GUCelYFgVhri6X/f0QoER/hsYqxNFkTmr0JuTqOMCcwUfJJnf
         U3qnFJw59boNZtmCvgnAhQDVanwZHsEcdRaJeiWp8Ta+0iWUOlC0xzmkiO0Ighz/wkUm
         yHdg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771264065; x=1771868865; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fiz9vNkfNVq/gHFV0vWF/BjW9v8x3UMDLwSp/LcBcI0=;
        b=s4okWC4ki7/cwfgQGpSjtVUviBQvpqg+EDQeY8Gkz7wuhnCBu1YX5amYbb9TqKeKRe
         9AQZ8S1t8JqAelofDWMhUFx2yYUIrm8lB/o9JhVGyY4XaZ9Ebxd7kI71yw33CNkJIUSm
         W3+6dnOi60NY4JpCdvDOqPi7Cp7lT5dQ9R6H4u0gIacpBmomw8dEwMKLfkpz4v/4ZVjD
         Wu0YtsBhWRznYdys8V4bzdQdKxol31/12lOFbemG1mWkRb+1jVrI+Mo+fgCoV1t84hRA
         gx/fGuwVUzxfEssXvm5H0o4WMdCnbQebxwMCy9o87NXc9R4GiLYHqEm3QWZrj6zdFS7i
         7wZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771264065; x=1771868865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fiz9vNkfNVq/gHFV0vWF/BjW9v8x3UMDLwSp/LcBcI0=;
        b=k09Y9aLcdzM0t7ds5VIdTMIO0ejH6R75aMzDoxHQN0JuJO8kz4Xztj4w1AyLmYKVY6
         2IHhy+3tKlDEmrw0gnt/AGXj3cNIWh+HFxzmpS/iu8rZF8ktCHSqBFQosZlsjoZADJSU
         cdxQB+JWWKKlvf2jpjsEjUWolqNBCB4Eb1PohAd6AgAXTUkuNsil3waa3M+UyUnQleAP
         JUaKaf8Yww+CRbTSYz2SC4D0mm+pfM7MaKIwm4gbEnGfux5OF2bq771AvK2B4XI36qSo
         DT3iqXJaKEFVYZuwpWXFG9DW9rzIqvwW208iOu2+7IAbeD9z5fQR1fhk3aoGBx069IrB
         6oFw==
X-Forwarded-Encrypted: i=1; AJvYcCXyDV8t50gqRXBmOf5RbIYLQVTa4P6UNf96sTvOTn257jLF7jxHRtvdgNmI9WaBzqJ8eamdmks=@lists.linux.dev
X-Gm-Message-State: AOJu0YwF77k2DBhXyAEDxhHvM+XgcV7yvs7B0BUFZBr41+Tp/9bBultG
	DGFmt0a/A3w51HItUEMPzgx7RdRk+9wRc+rvHPhbeNMk14+L3foPpVJ/8uzuU9Rm3QzyCcZzjVF
	LItpo0cmphAJAcLugOgeDEDF0od6DI9vpTwpReVtL
X-Gm-Gg: AZuq6aJmhrSfOuZ5XViOTmEg4F35bkZzZM4pCfs/qGbi00UGla8axSGypzkKM8Ot9U/
	+DMUciWmuqA2pR7xQdeE12Eu3Hw85uAwOhIzDK2/+Cw3730cIeZXFgtM5MkGa9CEjQqqnW4HMQr
	kQnb6vjkwhGP38WE19+hjDwoOsZwN57uhLAWqPM/5zNd/K13J3SsE19bPSmxR54S+Ucz9IYwZ9c
	MKThqBGfpxKNC2Xv78Cs+cEXlG3WqpIVIXYL0fqLURH8NI0+etMrUq3cEQUCsJyqKR88PeG35H3
	zXE2/ZMN0NEmJtRkO5WA38qppXydFzS16Krs1A1TNyc60dH+uNpiprdOlfgX+7H4usxSFa9b
X-Received: by 2002:a05:6820:1623:b0:674:db9f:2e2a with SMTP id
 006d021491bc7-6782342442cmr5012252eaf.35.1771264064498; Mon, 16 Feb 2026
 09:47:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69935769.a70a0220.2c38d7.00f3.GAE@google.com>
In-Reply-To: <69935769.a70a0220.2c38d7.00f3.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 16 Feb 2026 18:47:33 +0100
X-Gm-Features: AaiRm50HIoZAHjH1jzdKvyYdpbYNA45WUQQqXbHgvZkRAco0rruns9hYGh0Wlck
Message-ID: <CANp29Y5YnX21T-aP_EFCjVvRc1=x5rExoOhuuUO3zzzXZr0FpQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: pidfs: add inode ownership and permission checks
To: syzbot ci <syzbot+cief838c6543b45863@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Feb 16, 2026 at 6:44=E2=80=AFPM syzbot ci
<syzbot+cief838c6543b45863@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] pidfs: add inode ownership and permission checks
> https://lore.kernel.org/all/20260216-work-pidfs-inode-owner-v1-1-f8faa6b7=
3983@kernel.org
> * [PATCH RFC] pidfs: add inode ownership and permission checks
>
> and found the following issue:
> general protection fault in pidfs_fill_owner
>
> Full report is available here:
> https://ci.syzbot.org/series/d1c7b2f5-ccdc-4ca8-af27-dd6c97fd9e90
>
> ***
>
> general protection fault in pidfs_fill_owner
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      72c395024dac5e215136cbff793455f065603b06
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/a2c9422a-a065-455a-83e1-f304e9567=
e3e/config
> syz repro: https://ci.syzbot.org/findings/b2100115-a69c-42ec-8aa0-29353ad=
7bd45/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000003: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 0 UID: 0 PID: 5803 Comm: syz-execprog Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:pidfs_fill_owner+0x1f5/0x500 fs/pidfs.c:743
> Code: ff 49 83 c4 20 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e=
8 3a f2 da ff 4d 8b 2c 24 49 83 c5 18 4c 89 e8 48 c1 e8 03 <42> 0f b6 04 30=
 84 c0 0f 85 7b 02 00 00 41 8b 6d 00 4c 89 f8 48 c1
> RSP: 0018:ffffc90004997850 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: ffffffff8251bdfe RCX: ffff888175390000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffffffff8251bdfe R09: ffffffff8e558220
> R10: dffffc0000000000 R11: fffffbfff1fdf4ef R12: ffff8881078adaa0
> R13: 0000000000000018 R14: dffffc0000000000 R15: ffff8881169793f8
> FS:  000000c00007a898(0000) GS:ffff88818e0d7000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c002961200 CR3: 000000016d248000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  pidfs_update_inode fs/pidfs.c:766 [inline]
>  pidfs_stash_dentry+0xf2/0x280 fs/pidfs.c:1073
>  path_from_stashed+0x463/0x5c0 fs/libfs.c:2258
>  pidfs_alloc_file+0xff/0x290 fs/pidfs.c:1182
>  pidfd_prepare+0x14e/0x1b0 kernel/fork.c:1898
>  copy_process+0x1f3a/0x3cf0 kernel/fork.c:2259
>  kernel_clone+0x248/0x870 kernel/fork.c:2654
>  __do_sys_clone kernel/fork.c:2795 [inline]
>  __se_sys_clone kernel/fork.c:2779 [inline]
>  __x64_sys_clone+0x1b6/0x230 kernel/fork.c:2779
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x4a7d4d
> Code: 24 10 48 8b 74 24 18 48 8b 54 24 20 49 c7 c2 00 00 00 00 49 c7 c0 0=
0 00 00 00 49 c7 c1 00 00 00 00 48 8b 44 24 08 41 5c 0f 05 <41> 54 48 3d 01=
 f0 ff ff 76 12 48 c7 44 24 28 ff ff ff ff 48 f7 d8
> RSP: 002b:000000c00001d5b8 EFLAGS: 00000216 ORIG_RAX: 0000000000000038
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004a7d4d
> RDX: 000000c00001d644 RSI: 0000000000000000 RDI: 0000000000005100
> RBP: 000000c00001d5f0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000216 R12: 000000000049fd97
> R13: 0000000000000000 R14: 000000c000002380 R15: 000000c000010020
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:pidfs_fill_owner+0x1f5/0x500 fs/pidfs.c:743
> Code: ff 49 83 c4 20 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e=
8 3a f2 da ff 4d 8b 2c 24 49 83 c5 18 4c 89 e8 48 c1 e8 03 <42> 0f b6 04 30=
 84 c0 0f 85 7b 02 00 00 41 8b 6d 00 4c 89 f8 48 c1
> RSP: 0018:ffffc90004997850 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: ffffffff8251bdfe RCX: ffff888175390000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffffffff8251bdfe R09: ffffffff8e558220
> R10: dffffc0000000000 R11: fffffbfff1fdf4ef R12: ffff8881078adaa0
> R13: 0000000000000018 R14: dffffc0000000000 R15: ffff8881169793f8
> FS:  000000c00007a898(0000) GS:ffff88818e0d7000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000c002961200 CR3: 000000016d248000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   49 83 c4 20             add    $0x20,%r12
>    4:   4c 89 e0                mov    %r12,%rax
>    7:   48 c1 e8 03             shr    $0x3,%rax
>    b:   42 80 3c 30 00          cmpb   $0x0,(%rax,%r14,1)
>   10:   74 08                   je     0x1a
>   12:   4c 89 e7                mov    %r12,%rdi
>   15:   e8 3a f2 da ff          call   0xffdaf254
>   1a:   4d 8b 2c 24             mov    (%r12),%r13
>   1e:   49 83 c5 18             add    $0x18,%r13
>   22:   4c 89 e8                mov    %r13,%rax
>   25:   48 c1 e8 03             shr    $0x3,%rax
> * 29:   42 0f b6 04 30          movzbl (%rax,%r14,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 7b 02 00 00       jne    0x2b1
>   36:   41 8b 6d 00             mov    0x0(%r13),%ebp
>   3a:   4c 89 f8                mov    %r15,%rax
>   3d:   48                      rex.W
>   3e:   c1                      .byte 0xc1
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
> [brauner@kernel.org jack@suse.cz jannh@google.com kees@kernel.org linux-f=
sdevel@vger.kernel.org linux-kernel@vger.kernel.org luto@amacapital.net vir=
o@zeniv.linux.org.uk]
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
-upstream-moderation/69935769.a70a0220.2c38d7.00f3.GAE%40google.com.
