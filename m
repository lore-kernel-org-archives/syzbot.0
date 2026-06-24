Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D7A248893
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 05:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782280069; cv=pass; b=XjLXBAgLF/YpXIpdt7Mp03wYUqk0wVVT9C/I8wn+cY4sudwn3h5V1/38Ty+RNAsmj6UGX+K6H0j8he3bny7jJJK62gHmFj9FNUcAciYO/SoBGg612VRvtaXf/igetKUdrOWYivihGkrJRDtx8oZFlnGU2OahxySYjSc4/CQEo6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782280069; c=relaxed/simple;
	bh=0O+9q+/WDfISwZonZzQlX8vcUEoyfy6s5MBIVwFE4SM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q9Kg2y788lFClAmR+LOUpgpKWS/Z1MUCP5HKna9IMxcAziH4lYKASAV8NLKjsi+Ub599pel7pRZ5eJ73s+FX5ABJCsjYIlrmDypajAe5ANGpbxCvq/11dnrUxKnQmb+7hd9LxMA2ckEpKRa9hDo7GbSPkBPOp0UmIoJDH4ZIOts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W5tdxCGU; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W5tdxCGU"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so5763495e9.1
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 22:47:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782280066; cv=none;
        d=google.com; s=arc-20240605;
        b=O48e4rdb8xOSvSb18UmS6nP4fn/L2gDclm/ddhPDLAeJmW9xSRAWB9nmtGyBrKn1yd
         l4x2OhjBGlgsPCx548WuF0DS7a+hQICm9KQZW2HW7EGl3WbpaE6m949u6Le0Hct9FwKh
         sLtkE0E+t3WJCJzcPOkNMr+oKIhmkqfWkcB8CXl3zmumLyXhEnR5JV8V8kZMNBK2Xm1R
         e9/6+6LwCznXnJHYO2qGtdkoAZDcdFYPCDZbWK/ePXUHzpgOmuBFCzv23ZZ5B3cyW2vX
         FoKyWVrxUa/trCcwLwTe7H4Yhsxzpxadyttem42h/OI2Zpw9pqTBR8UhMkDKhioBbIhA
         ziLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q1KuCqcOoHR1B0hS101TnbcsdH3J1O+iYkrnJ1K0LaM=;
        fh=4/45+rnfPTxeNfzPv0M+RMw7IPnkFxvoOHlFdJqZVO0=;
        b=YoMPHVdkhFLTmk7+NbqZWXwAWqBW0cd37jOWywMQd5qXSinDkD9PaBv0Rt2YXB1F9e
         42gFVisqsWW+ucnDRPLYQmB/1YaG+hSPueALaP4X5KELlYj35jtSVkokLFajux9vNJxP
         gU5iTwK1XtB7V4kIJZU7XopHRgubVSvrYyc1jx2RZVaFxA8j4HDI0i6VIz7ukwW61adF
         5f4byecIEMmmSbnZ3fFXn+Gn4AE7Jzv1cdQNmWiHe8LrEc6YrZL8NtHV/3nN25epVU56
         g0+LnDoq0sDC74QkyE1Yw8mcQL98+Cz98tiUGmF5U8LVhgmlHUZ7BrqG9wB2tKe/ORhT
         o7ug==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782280066; x=1782884866; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q1KuCqcOoHR1B0hS101TnbcsdH3J1O+iYkrnJ1K0LaM=;
        b=W5tdxCGUnIZ39WfK9nW9Wun+EikB4NbEP9Kc8taZ6CNzpfWX/AqxBayxSZLmdfAHgW
         aWf82jXNmYs1u5huziflKFz7FJtFrYlLmE9RMiiwyHGFx5F7u/xkUZwn4yPSashzpknZ
         oe2GKMNZaKdfDlnuet1n5S38GNWzPbsBa3EPj0k3gnjnWPOFPKFszrzN1iizyofFW8wh
         h7YbcxL19UKkrDxyNvD0/8duyWjbDI27p/y0d0hvY+Tkk6kqbWYftGLNA+Kh4Tswtw0V
         Jf5zI2clmE8Llj/Sj7mVnpnDmdt3pJ8Fr21hh2joUTAmqEqSICUmSB55wPXDBLwnckbI
         qP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782280066; x=1782884866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q1KuCqcOoHR1B0hS101TnbcsdH3J1O+iYkrnJ1K0LaM=;
        b=AFPU41M3J/Zf5k+rI4R8EtoF5cqDgk7eJXFT9vSsukZ2cjymrUnCD2koOq7Wl4EdHk
         V++JR1l5TmapO02yDElLY9fK+gjQwh/jczXTTcBay0cVsb3snz+TaJwmU5eknc/SE26k
         D9pyXyVf27FN2DV3pg9fo/7B1WoKkxAjmRPfvapUtA8K2Fq7GRr6KwPw3EAuY4GYIJaG
         jz6ZPAdXy9VjWpl2aLEiB2PfK+coiuJX/8xkY2RI1sajf+f+ZDBhzrGEJfPof7JmtyI0
         gcMgutisRw8jlGC8YJsAHr1dtXd0cP1+7jX7Duih38BKfux7n2yKfeFHZ0qUOfOD6uLq
         rCvw==
X-Forwarded-Encrypted: i=1; AFNElJ+84n5Ruo6iH+KcuJbbWXDRC4Agu+9cad+E9Sm/yX7/qNkOt8bDW+3qOgflW9/q/8yTmwe38bY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcO0btLQ91KTPDUGasfJSquW77DeLTXTgG2PVUqMrl8L4oYUuA
	leyfZxUbPK8Qin0AljUviQ+p7CoSks0xIL/DH3JPjV1M2yPlnz577iaUnqy6QmkHJgXJUhl131t
	YqZzjYjQEfGyh5ltV0ijmmxbNNoKIOGVhRHeBJHiT
X-Gm-Gg: AfdE7cm6v9w0hHEeffdB1S2XdgYWwKMUY5XOdG5GIkwLyTEG0tf+4WqCBEKxXzHGxvd
	IX0mqF7d/X060D0DjHFHP1W/pIYK1JRh1sY6BX2o033/vW/Eh9QHQRX9IY1HmaAvdIoER6OxtTk
	tHm3tOWVGgmLcy9o6pGhazMzSPmB5HJRaR03GRTae04iX17B7erdZK0N9Xzyo9PSi9HHuIf+X2A
	kFsaKQCF05ql8YmHOWjOUF4zXZe/VaiyRelCzcH8QwpWV0G1DOiTUB4PpEV/rF4AkxhP499V0/3
	sfElYScNwcI9hDzUPZYbP4ouc3GbAUk6KphHCOKYnR+tUw9INOP/BgmBN+GSRmo=
X-Received: by 2002:a05:600c:1d16:b0:492:5855:1548 with SMTP id
 5b1f17b1804b1-4926087830amr20117655e9.27.1782280065130; Tue, 23 Jun 2026
 22:47:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a3b41a1.c358b6d0.89040.0006.GAE@google.com>
In-Reply-To: <6a3b41a1.c358b6d0.89040.0006.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Wed, 24 Jun 2026 07:47:34 +0200
X-Gm-Features: AVVi8CdK5jyC5o5PvzrgM0x7uirhymTPK3CtqcCr0kUdyFcWTeJGkcojy-d4tUY
Message-ID: <CAJWNTGz83f5hOXmywTTWAWTO9CUAWnnDkyfUG_1pVohVgn2a8Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: nfc: nci: fix uninit-value in nci_core_init_rsp_packet()
To: syzbot ci <syzbot+ci5398511bc95c05d5@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Jun 24, 2026 at 4:32=E2=80=AFAM syzbot ci
<syzbot+ci5398511bc95c05d5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] nfc: nci: fix uninit-value in nci_core_init_rsp_packet()
> https://lore.kernel.org/all/20260623222402.175798-1-sam@bynar.io
> * [PATCH net] nfc: nci: fix uninit-value in nci_core_init_rsp_packet()
>
> and found the following issue:
> UBSAN: array-index-out-of-bounds in nci_init_complete_req
>
> Full report is available here:
> https://ci.syzbot.org/series/2a9a8657-37a3-4dce-8cb5-2035027791dd
>
> ***
>
> UBSAN: array-index-out-of-bounds in nci_init_complete_req
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      a986fde914d88af47eb78fd29c5d1af7952c3500
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/80f835c3-e998-47ff-aaa5-24c578af3=
b4e/config
> syz repro: https://ci.syzbot.org/findings/65008893-2498-4786-b913-f2c474a=
7b34a/syz_repro
>
> ------------[ cut here ]------------
> UBSAN: array-index-out-of-bounds in net/nfc/nci/core.c:192:7
> index 4 is out of range for type '__u8[4]' (aka 'unsigned char[4]')
> CPU: 0 UID: 0 PID: 5905 Comm: syz.1.33 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>  __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
>  nci_init_complete_req+0x255/0x460 net/nfc/nci/core.c:192
>  __nci_request+0x7d/0x300 net/nfc/nci/core.c:108
>  nci_open_device net/nfc/nci/core.c:529 [inline]
>  nci_dev_up+0x8c3/0xdc0 net/nfc/nci/core.c:643
>  nfc_dev_up+0x165/0x350 net/nfc/core.c:118
>  nfc_genl_dev_up+0x89/0xe0 net/nfc/netlink.c:775
>  genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:775 [inline]
>  __sock_sendmsg net/socket.c:790 [inline]
>  ____sys_sendmsg+0x9b9/0xa20 net/socket.c:2684
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>  __sys_sendmsg net/socket.c:2770 [inline]
>  __do_sys_sendmsg net/socket.c:2775 [inline]
>  __se_sys_sendmsg net/socket.c:2773 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f55ead9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f55ebcb9028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f55eb015fa0 RCX: 00007f55ead9ce59
> RDX: 0000000004008054 RSI: 0000200000000200 RDI: 0000000000000005
> RBP: 00007f55eae32e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f55eb016038 R14: 00007f55eb015fa0 R15: 00007ffcba11c798
>  </TASK>
> ---[ end trace ]---
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
> [davem@davemloft.net david@ixit.cz edumazet@google.com horms@kernel.org k=
uba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org oe-linux=
-nfc@lists.linux.dev pabeni@redhat.com sam@bynar.io stable@vger.kernel.org]
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
-upstream-moderation/6a3b41a1.c358b6d0.89040.0006.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
