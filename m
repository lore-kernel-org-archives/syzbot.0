Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253E238F231
	for <syzbot@lists.linux.dev>; Sat,  7 Mar 2026 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772909863; cv=pass; b=ns0bu9qojuuhoGOdgK7QyjHTdmq9e7PZaX2rvVLfxUpKRzevRPSHzdcnPPpOFbujMPmxYL9fCkXzjufLdB2fDftkcRTdHiqynZ5G1KXOSozdagSeCiC3Go+c/FNZukOCaQ0Veuw+5SR8b8HNXXiB6/NalITX/iSxnf6QQOOwESE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772909863; c=relaxed/simple;
	bh=EiyTF36dbhLafHC20gAmVSFBvicRD96fSnyuP6hQ6Po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k6NOmw20F6iroX8IDd58KVbyazSmQLc9lG5d4x3Y2UKL4tqNeuQmnjCIH31Rlt1+obEZrfGZ6ys7h+KVK7Iaz0wsyHrbkfFoNhwChRqzy7q5GBE6OYMOIPqGBPgQgM1H3TMC5+EQ5ez32W9kSAG80eZo7fvWTcr4O7gz7/9OLT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SlMfHAsZ; arc=pass smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SlMfHAsZ"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-466ec4c6852so399075b6e.3
        for <syzbot@lists.linux.dev>; Sat, 07 Mar 2026 10:57:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772909861; cv=none;
        d=google.com; s=arc-20240605;
        b=LFOgSJFp/AgesvWCaIdfuExejypvmWXwmpBYcKWJqf9E768FPjjlnAPzXAqJa8tBKF
         ygAZKPep6xQbN5tbJpC7EvHXPWR3WfUY/zvVyPFwQhZ1ZPF6Bd4Ca0kimiCCyKDSklAA
         1mDrNcpaBTAUo0wt/r058g2p1XKDql0eWiJzGs+piO+MJ6fkfoj+zyRwSRtJC4sp2rXW
         D4ahp4RQYHUQDlQF8Jdx6ktJjMfFrobj3V2JtfIjNUcWzgRegl4CAijFw0YTboNuAoFU
         05umpha5EhG0+53MPB+PfGDGdU07qyOqGzlK3tsEcdNgOSU6z75cNI2w+cZfOUF9iXPf
         Al3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mKDqUCjLHDl4Yt+aub/nSo6Yi/EaAFym3r8q+TW0gdc=;
        fh=acQ56NIUn5tvQ99WbJkBbgNoAfFwZ7h3t2oQvlLhJJo=;
        b=hKIMbIl7lenUYVso+TeT0LNUdpoUOzaH6heqTgt/tbAQy/kYIVr5Xe/OkGrMCwUK2i
         jQRBI30yA8izzYdehRwZfh8ItOr4q/s9mRAPDGX/w0V325ZGNpTufpFEP8xoxiSeTq1V
         y/+EjpxTZ0Un6skx8gxxvFsh39jXDD8V1Bz4V5yMYa3IkdPhK2pkJZ2KJ4KUuuop9wKh
         u4EEhphjXfVQqsbSz0Uo/aBcd36gLyvfN59rPPLd5jhX9rg7W3eBj9qfu1oZ3Pe1HAoW
         5qATcGBStw0Csr1QZvgnEb0a/l1tqaBSy9nHy9eb858KQHOwQwTVs/kf55ooPaBacgsT
         NgIg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772909861; x=1773514661; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mKDqUCjLHDl4Yt+aub/nSo6Yi/EaAFym3r8q+TW0gdc=;
        b=SlMfHAsZsNJImjA1gkmaGxP9aSA97jyHCj5Ufy4tHxIbJlzSvREuwropHLi3cJ35mg
         4/ubjjV1Ul3Gb9wd137zmK6YCKD7vMwUT1ggcGJNDb9tH+BYlJto4/W4qjCWDaNlYz2H
         MQ6LYeKWOLvTdihI1UbL05sjZ855+QWi7B3adUyLjEh31E6CzmFXITirs0mX+aCk0ZCM
         TeOpM4z1numCVZ3qC8okHfJ69w3OLNzo1s6ogsrC4mAdDLTkq//7M8D0nmS13psCETqM
         c3VFMEPxS8K3IM+JEvQvDcdHa1NZ+r5YYyST+npHRTMJ2Zd/CEMPOg336a4cdqr9FkXZ
         chvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772909861; x=1773514661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mKDqUCjLHDl4Yt+aub/nSo6Yi/EaAFym3r8q+TW0gdc=;
        b=oH058SRoRW01DJQh8Q8pK43pQhR4IEWmB5KOQM3IX8GvhHTRcuBy7NdXYGEcdewdvL
         O2KB/DLobdvr6tw+jwrP250z6LpXXYdEz9l18v6jiv+z5v7quGGVPKprpyUp8aXNxjzd
         hTz0Q2pbktUr0cAavxo/5sqf38fNad6/m6NzV3zmERebDJJR3FrjBzEkFZ32c5sHbKI2
         ZyYkbWQSrWVjQo9HBEqHPzWhkCvdGApz+btgoGlYM0ecxvl5UmTz9Y+KkpXZfNE1le0K
         70zNR2YnkiU55aYWZicDnadreKbM9pOgQw8ZQdsDRhec6aReL1Ui0ZAPqz7MKzU2n/9n
         AqvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHSo1dWQ0Hj9qQuVfS4/hcwwNxdVo99fDS2FrlrS/RqMFTQcjhpM2nRqVj/uAqyI+njyiy0SI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3hHq2O1LIWAdqRyTN1gHmDjo/z2sKVltqW++hQwIiE3XnD8Wi
	scUn5MWhnboymWtg+TDUfuHQeKOqsoF6Q4bQGAcpZmffP5lidVurwsvthK/d8HTIS/BrkN+6atn
	bnJCK+SWNdmFMVWSoIB5w/unwbtaSNBTt6HxsWMT6
X-Gm-Gg: ATEYQzzSLdRMn3y3/mftnxBe0koITHtKuzSv2c1Cr1fnu/ZNJZj26v0zBOyxqTa2g4M
	i5aTYVeNANE+bX+ELq1/lSRYwYerXeKgAD8bQP4x53cum4MrpfARCOcegHw+OVXHUr6mMvigAf0
	UIJpDKGwBlMkCe2/1T2n6SfbXursXebzVhs+Md9/ZMYfhu/fF34hyy2Uii8a25x8+MRWBngu3Hj
	uHJt7qncTtH4gEEY3crwpdf+SUck6ijmWHrrc8JM06mfSgddKXIa77+Ah2wUuMWcdffkL2HKLbA
	BtMbUa0Fp5t3HMclYwhC6ZD/BqaBMabAYhCQwylw
X-Received: by 2002:a05:6808:c228:b0:45f:434:9c1c with SMTP id
 5614622812f47-466dca167cdmr3217420b6e.12.1772909860784; Sat, 07 Mar 2026
 10:57:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ac023b.050a0220.13f275.004b.GAE@google.com>
In-Reply-To: <69ac023b.050a0220.13f275.004b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 7 Mar 2026 18:57:28 +0000
X-Gm-Features: AaiRm51_q3Cucant0gmsMAUtiZTAZNSxZOIlnOJ7xzYirpWGwyZ2bNpk0ws3uos
Message-ID: <CANp29Y5YqXRF5CW0yhcWwW1DxZM9KT0wu=eRmU=sQWYf3ZgDDQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: nft_set_rbtree: allocate same
 array size on updates
To: syzbot ci <syzbot+ci191df84c04eabe72@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Mar 7, 2026 at 10:47=E2=80=AFAM syzbot ci
<syzbot+ci191df84c04eabe72@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: nft_set_rbtree: allocate same array size on updates
> https://lore.kernel.org/all/20260306123649.2878676-1-pablo@netfilter.org
> * [PATCH nf] netfilter: nft_set_rbtree: allocate same array size on updat=
es
>
> and found the following issue:
> general protection fault in nft_array_may_resize
>
> Full report is available here:
> https://ci.syzbot.org/series/63a7af7e-7e81-40b3-ac44-4a537af34cdf
>
> ***
>
> general protection fault in nft_array_may_resize
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      488f6400e447d446ff4d5daef6988f3403dd948d
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7f67fa0a-1740-40ec-b191-899f77dd0=
2ce/config
> C repro:   https://ci.syzbot.org/findings/c4666971-4767-49ca-b29d-854930c=
3aace/c_repro
> syz repro: https://ci.syzbot.org/findings/c4666971-4767-49ca-b29d-854930c=
3aace/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 5957 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:nft_array_may_resize+0x17f/0x3d0 net/netfilter/nft_set_rbtree.c=
:649
> Code: 00 00 00 49 81 c7 38 01 00 00 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 7=
4 08 4c 89 ff e8 1b de 4f f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 28=
 84 c0 0f 85 e3 01 00 00 41 8b 2f 48 c7 c0 a8 c2 1a
> RSP: 0018:ffffc9000591ecc8 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
> RDX: ffff88816dced700 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff8881012f8473 R09: 1ffff1102025f08e
> R10: dffffc0000000000 R11: ffffed102025f08f R12: ffff8881012f8540
> R13: dffffc0000000000 R14: 1ffff1102025f0a8 R15: 0000000000000000
> FS:  000055557f50a500(0000) GS:ffff88818de64000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000009b40 CR3: 000000016f370000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  nft_rbtree_insert+0x161/0x2c00 net/netfilter/nft_set_rbtree.c:678
>  nft_add_set_elem net/netfilter/nf_tables_api.c:7486 [inline]
>  nf_tables_newsetelem+0x2a17/0x4450 net/netfilter/nf_tables_api.c:7618
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:526 [inline]
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
>  nfnetlink_rcv+0x1240/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg net/socket.c:742 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
>  __sys_sendmsg net/socket.c:2678 [inline]
>  __do_sys_sendmsg net/socket.c:2683 [inline]
>  __se_sys_sendmsg net/socket.c:2681 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fdff099c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff596fb518 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fdff0c15fa0 RCX: 00007fdff099c799
> RDX: 0000000000000040 RSI: 0000200000009b40 RDI: 0000000000000003
> RBP: 00007fdff0a32bd9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fdff0c15fac R14: 00007fdff0c15fa0 R15: 00007fdff0c15fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:nft_array_may_resize+0x17f/0x3d0 net/netfilter/nft_set_rbtree.c=
:649
> Code: 00 00 00 49 81 c7 38 01 00 00 4c 89 f8 48 c1 e8 03 42 80 3c 28 00 7=
4 08 4c 89 ff e8 1b de 4f f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 28=
 84 c0 0f 85 e3 01 00 00 41 8b 2f 48 c7 c0 a8 c2 1a
> RSP: 0018:ffffc9000591ecc8 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
> RDX: ffff88816dced700 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff8881012f8473 R09: 1ffff1102025f08e
> R10: dffffc0000000000 R11: ffffed102025f08f R12: ffff8881012f8540
> R13: dffffc0000000000 R14: 1ffff1102025f0a8 R15: 0000000000000000
> FS:  000055557f50a500(0000) GS:ffff88818de64000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000009b40 CR3: 000000016f370000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   00 00                   add    %al,(%rax)
>    2:   49 81 c7 38 01 00 00    add    $0x138,%r15
>    9:   4c 89 f8                mov    %r15,%rax
>    c:   48 c1 e8 03             shr    $0x3,%rax
>   10:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
>   15:   74 08                   je     0x1f
>   17:   4c 89 ff                mov    %r15,%rdi
>   1a:   e8 1b de 4f f8          call   0xf84fde3a
>   1f:   4d 8b 3f                mov    (%r15),%r15
>   22:   4c 89 f8                mov    %r15,%rax
>   25:   48 c1 e8 03             shr    $0x3,%rax
> * 29:   42 0f b6 04 28          movzbl (%rax,%r13,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 e3 01 00 00       jne    0x219
>   36:   41 8b 2f                mov    (%r15),%ebp
>   39:   48                      rex.W
>   3a:   c7                      .byte 0xc7
>   3b:   c0                      .byte 0xc0
>   3c:   a8 c2                   test   $0xc2,%al
>   3e:   1a                      .byte 0x1a
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
> [fw@strlen.de netfilter-devel@vger.kernel.org pablo@netfilter.org]
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
-upstream-moderation/69ac023b.050a0220.13f275.004b.GAE%40google.com.
