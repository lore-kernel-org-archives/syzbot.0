Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC2E2E9EB5
	for <syzbot@lists.linux.dev>; Tue, 22 Jul 2025 13:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753190822; cv=none; b=ZuH36O/nfKBHXclT8QAMBxlduiz2thPbzFFnenOkFAXD7HZNxoHrlHo51qKtqofy4IDdhT51muFX3svLZvIqbyoJIrqk4UxI4yugsAUgP5QbI/Hw8ZLWu4W9faqz78r1W4btEHScBko6yx5Gtz+KDSBlfx8nZI7lJv6hUEdNyS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753190822; c=relaxed/simple;
	bh=ya14nsgz6yk3xbTox90Hfos+5rbsDCF8Ud8bj5Cb39Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rdeC1N3aa3VpDuqFeztzL9uag/9bBw9T7q+YEL2P7y+XUaB5WPc3VPUpIgL0ir9YZufzKbJtQmTz++gYQN6hUzDpyqnZ054U6DyH1OkdpqW9IWhe5dLSZlN7WAEGZhYAplFn+OPNXaCF+9rbkQFE+QHS2oQxHTBmETFbkZKFpp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dmD9BhF5; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dmD9BhF5"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-31a93a4b399so4573981a91.0
        for <syzbot@lists.linux.dev>; Tue, 22 Jul 2025 06:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753190820; x=1753795620; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2i2/2aEbvfR54buTS6AY0EGO5dKeiUh7aTn/ixnuXNg=;
        b=dmD9BhF5AWCZmyo7CL7cgzAtk2cyy12zBZdfxdmRXbQes+8igCOxwTnytwmupl+fOv
         ZGaWntJqqfws4N/Ih53PWbk3TJ16OeXB/9VW5bAElEi1/AJVf34kx95WG0GtUZ/17E63
         2/EtyOib1thEwJriHzIV14w//t1YBlijdxk1Mcn79oS0L8b005XyWWaub0t52aRAnO7O
         lDszDufBunLlB9r11rv61kjQ/aGy8srm0ZXCd9blJlm7C7CcdNHa6gype7eaLr7j2vAO
         JSQZqE3hXp2e8yHzOliOOZSl9Fej8bDuxXlW6VP9/CStnG7fTQmCtiNBqOyQfaLlAGNV
         O3mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753190820; x=1753795620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2i2/2aEbvfR54buTS6AY0EGO5dKeiUh7aTn/ixnuXNg=;
        b=ZQz4qh5Dj1Y61YWiU9zfLuqlu9MfPu1k3UZUNYKEC2KQPvhH4G+OmESQC4Utr9mdoS
         dx9rlmAiTJjoAlXM4NmLABQdvV48/zTKNlxbxDFFP6shglQ/+Tdp1ATOMhxnSnETmCBs
         0dTCHIEZy5fIWRnRUe1hRjTV+/JJTSD3c7ey/jQzjhoI320t25jwgE1Yr9ds8OsoU3Yw
         duZT0hZNFIPZpBb3/ZIukAC6BJZPSKX1BvBwCv8nhb3j+n14ZBMxBocnhjwuIETQ5y5u
         zZy8hg2MsIMPhN3rHe9Lc3HlkLYwa776Y2AGRfROZYtr0j43+gyzMoFDYo0sDvGGJiGH
         ePdA==
X-Forwarded-Encrypted: i=1; AJvYcCV0NbxM2EMRCyDImcJ/Bqf0x7aPafrEYxeIQn8KicJch53DEHHO6gCWEqXXpBLtgVoRw2BM1x0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoGjK++wnETb698LTnNn3aH2G6hsQgykSS+P1YB1ZR9DKBsQbw
	H2r6GfV9YjcpGW37jwEa8Ar4eqCv8GlBVhV1UTDQ9T+8Q9yRA7PmQ69da6MrLx8mx0x8SdkQqAc
	UgQ8t1xH+tbTelyViFwzs8AOKMtcmB3Xbb7rBe8k/Bc2Sam8/3TRruAyu
X-Gm-Gg: ASbGnctaJF+iPJ26zSmdWpYjYXTdyHaqSXo9pIcm9ZoUBzYCQvuhwCfNBOok+QAhY1A
	2HIE2rVDciAIdrEzzHe6pTWoJhMqy8OovypMkrsIGqhd5ZR90ukk/xOmz5wo598dsEFcjA1MEan
	h0V7ZD8HYIrtyTCymgDlN6VYG+dQ/YoYOMJPoWAJ/Fc26o9dl+eWfHDHC07x3jS2NywHKinnNVq
	i0ZESPyczFH+HiCrg4qJjuby44XhmFBz1nSCdKFmQGEDZnt
X-Google-Smtp-Source: AGHT+IF1Ntg7S2kwU24cny/lx0cs3aUy8pc2MkqHuqm5d6qC7U8yPMXIOCohp/KukhgSCzb+hfG8sFGw8J9DTP43rnM=
X-Received: by 2002:a17:90b:1d05:b0:30a:3e8e:ea30 with SMTP id
 98e67ed59e1d1-31e3e1d3cdfmr4778258a91.11.1753190819544; Tue, 22 Jul 2025
 06:26:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <687f73e6.a70a0220.21b99c.000b.GAE@google.com>
In-Reply-To: <687f73e6.a70a0220.21b99c.000b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 22 Jul 2025 15:26:47 +0200
X-Gm-Features: Ac12FXxzuq9JTbO0wHJCCLnu8yYd9cQRNSkghl8-ExMYEPbChU-B0y4iX-7O110
Message-ID: <CANp29Y4S=17E2iwqL-8DURMh01k107z2aU4JG=toQh5W7TNv7Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: Revert tx queue length on partial
 failure in dev_qdisc_change_tx_queue_len()
To: syzbot ci <syzbot+ci486d0f7ad816d3a7@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jul 22, 2025 at 1:20=E2=80=AFPM syzbot ci
<syzbot+ci486d0f7ad816d3a7@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: Revert tx queue length on partial failure in dev_qdisc_change_t=
x_queue_len()
> https://lore.kernel.org/all/<20250722071508.12497-1-suchitkarunakaran@gma=
il.com>
> * [PATCH] net: Revert tx queue length on partial failure in dev_qdisc_cha=
nge_tx_queue_len()
>
> and found the following issue:
> BUG: unable to handle kernel paging request in dev_qdisc_change_tx_queue_=
len
>
> Full report is available here:
> https://ci.syzbot.org/series/75b0a15e-cca4-4e46-8bf9-595c0dd34915
>
> ***
>
> BUG: unable to handle kernel paging request in dev_qdisc_change_tx_queue_=
len
>
> tree:      netdev
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      81e0db8e839822b8380ce4716cd564a593ccbfc5
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/2ee305f2-ddb8-45c6-8f47-2a150dc6d=
d22/config
> syz repro: https://ci.syzbot.org/findings/1e75a6d3-11ac-48da-af27-60753ab=
b61c7/syz_repro
>
> netlink: 'syz.2.18': attribute type 13 has an invalid length.
> netlink: 'syz.2.18': attribute type 17 has an invalid length.
> BUG: unable to handle page fault for address: ffffed4821fa6a4b
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 13ffee067 P4D 13ffee067 PUD 0
> Oops: Oops: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5980 Comm: syz.2.18 Not tainted 6.16.0-rc6-syzkaller-0=
0128-g81e0db8e8398-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:dev_qdisc_change_tx_queue_len+0x542/0x640
> Code: be 7f 05 00 00 48 c7 c2 20 d2 95 8c e8 27 db 27 f8 44 89 e0 48 69 c=
0 c0 01 00 00 49 8d 1c 06 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 1f af ab f8 48 8b 1b 4c 8d 73 18
> RSP: 0018:ffffc900024beaa0 EFLAGS: 00010a06
> RAX: 1ffff14821fa6a4b RBX: ffff8a410fd35258 RCX: ffff888020f2d640
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc900024beb90 R08: ffffffff8fa1d6f7 R09: 1ffffffff1f43ade
> R10: dffffc0000000000 R11: fffffbfff1f43adf R12: 00000000ffffffff
> R13: dffffc0000000000 R14: ffff88810fd35400 R15: ffff88810ffe2018
> FS:  00007fa854ede6c0(0000) GS:ffff8881a3c23000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffed4821fa6a4b CR3: 00000000295fa000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  netif_change_tx_queue_len+0x167/0x270
>  do_setlink+0xdfb/0x41c0
>  rtnl_newlink+0x149f/0x1c70
>  rtnetlink_rcv_msg+0x7cf/0xb70
>  netlink_rcv_skb+0x208/0x470
>  netlink_unicast+0x75c/0x8e0
>  netlink_sendmsg+0x805/0xb30
>  __sock_sendmsg+0x21c/0x270
>  ____sys_sendmsg+0x505/0x830
>  ___sys_sendmsg+0x21f/0x2a0
>  __x64_sys_sendmsg+0x19b/0x260
>  do_syscall_64+0xfa/0x3b0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa853f8e9a9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa854ede038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fa8541b5fa0 RCX: 00007fa853f8e9a9
> RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000000000000003
> RBP: 00007fa854010d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007fa8541b5fa0 R15: 00007ffe5a5f8288
>  </TASK>
> Modules linked in:
> CR2: ffffed4821fa6a4b
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:dev_qdisc_change_tx_queue_len+0x542/0x640
> Code: be 7f 05 00 00 48 c7 c2 20 d2 95 8c e8 27 db 27 f8 44 89 e0 48 69 c=
0 c0 01 00 00 49 8d 1c 06 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 48 89 df e8 1f af ab f8 48 8b 1b 4c 8d 73 18
> RSP: 0018:ffffc900024beaa0 EFLAGS: 00010a06
> RAX: 1ffff14821fa6a4b RBX: ffff8a410fd35258 RCX: ffff888020f2d640
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc900024beb90 R08: ffffffff8fa1d6f7 R09: 1ffffffff1f43ade
> R10: dffffc0000000000 R11: fffffbfff1f43adf R12: 00000000ffffffff
> R13: dffffc0000000000 R14: ffff88810fd35400 R15: ffff88810ffe2018
> FS:  00007fa854ede6c0(0000) GS:ffff8881a3c23000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffed4821fa6a4b CR3: 00000000295fa000 CR4: 00000000000006f0
>
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [aleksander.lobakin@intel.com davem@davemloft.net edumazet@google.com hor=
ms@kernel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org kuniyu@goog=
le.com linux-kernel-mentees@lists.linux.dev linux-kernel@vger.kernel.org ne=
tdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me skhan@linuxfoundatio=
n.org suchitkarunakaran@gmail.com xiyou.wangcong@gmail.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/687f73e6.a70a0220.21b99c.000b.GAE%40google.com.
