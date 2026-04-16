Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E33D30FF20
	for <syzbot@lists.linux.dev>; Thu, 16 Apr 2026 07:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776323017; cv=pass; b=WUfYrF/qVMsO1TAqnRPOjF69nhEgm6sed18OIXoFf9ccQSXvK1QCwqmOEkvrSGwL54ZS0erUoQEPjqtFGlcomCmdqE/yyA3Yhgr+auL5ypH2n9WFpYe0pB59TFqPcRBnt+kwuMH5ZhpXCoIvHxRpGxkHVm0QnkLoBe0U8D+EL2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776323017; c=relaxed/simple;
	bh=n+dR8YfXQncGT+CRjXzrNhDXfYxH8eTpWXRDBxLWF/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YrpDwyBPfsgrTl5Ugz1OfAqTKRdi6P5Rn09rwQ+dPV3Tzonk3ZQgx8syEWbv5SspFWg2yn+vYwBSeHTAviBiQ3KoKXIzXGtk6d3Eydvd4huwXzBjg+Q4cMNGkAYpmfvu79vI8PEbq92u9rvBqnqyJ8v/tGeQfkjwZZrnJLktkWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hYVrtQlH; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hYVrtQlH"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7dbec19732eso6805107a34.3
        for <syzbot@lists.linux.dev>; Thu, 16 Apr 2026 00:03:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776323015; cv=none;
        d=google.com; s=arc-20240605;
        b=beJy23V/A5VtfdtZQ3IZPJhGnstvQlD8+fHwRIfHiPqPMsuDvVMiaNynQ8ykKhIBMN
         jSGx5m60IDTl/qIGOTNMNrCwQPZMOv5KRp+xo5YmPiLolusY9PsntYI9JaMo6VwovRzf
         W7ixnBQuVOoxnsHBi2WclJp42n/hXnK2N6P2Jnfzp4OByw4hmWV0THfrYRlG3m8c36NT
         2FOLlkEqKbkJXm48a90mtCfeRQPLGIJunbX4+/6GKEG9c2gKqCfs2mVyL8HsVbGHDm4+
         d3m1F+w/9MNdcoHz8afWv/bWjivrvhptnWgB6XHGYrMddEnOtCU9Yoj/Ea2mgiipoYG/
         iMXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IC+RwQ5eOjA+oThvClBtzJMQuIn5x1NQuX/PKwC6Leg=;
        fh=e8XZ1oCLb9nUApkcjrnaNkbgwz+CykV6pyPzMHxg6bI=;
        b=kg7cejJbdc8MGlJxxkh4A9YQjv3ysrI+jpUxPbyvlicegAR0p0vEHsMiu3inkJtFF/
         IVuIrg7kSL5/woxLuU7OWcHgvp3pqHC92HNiwQiBi2rnq9IDWWQE1Jayyt4+8bs2t1r5
         LdD6oBv5hdwLsxkNJjgCHRq5vCaNipFGr9iCsgz0Rufa8B4F1ZtIHc+sslHQHErkheqc
         /VsC5pbUELtnqs8Ini0PWSsA8cHTBsHRR/lcvtctrtyj72vVXZqOqjqHdBKeDuH80NYy
         zcfW81F5BVRM1rQojAJLly+Mr5puEAuxcps8RaBg/xOh53hLF/kN8/gzCHzsDnFZ/RVO
         1apg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776323015; x=1776927815; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IC+RwQ5eOjA+oThvClBtzJMQuIn5x1NQuX/PKwC6Leg=;
        b=hYVrtQlHcMUi2zVZ9DPnw2wc4S7REuIOBQS5qhvSzyUmOwCJOZ44PNJJGDyWKmNJyD
         2xuaQIRz5FEAPaojzEObLsS0LNm2yCBZqR9B949MpH8JWFj9vmGu9Ueb5BuB+5YPqbgc
         vDhggMTeG5QPdnmC8Rbbg2wVJs23dcIZmW1HU8GDI12cHlP4MoTnTiQhLUvNerASopkc
         r9Xc9KBXwPgXUQGJvF8jdBGQ1U7bWiFgAI5/bldbtYcUFs2g2kUEe2U+f58XoycfWTCZ
         mmiv2AmD2YdSrF7v+1G5si79mV6aAXh3J0rxYGcvAjqXDEfkFo+val7vWHiz+qfqGyCp
         noxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776323015; x=1776927815;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IC+RwQ5eOjA+oThvClBtzJMQuIn5x1NQuX/PKwC6Leg=;
        b=mfAjF/0VOOkozZ03tGwOQ1+rYOZfBHCKUHZGiP0ZG/ooAuO/IsRwb1PPnb60Ap7olB
         vHlQoyEr4Dh3X5HbkJU8rrvG0o6g7VpfRLX07fCsQD2d38W4YYQFZg7Z4hgSwrjzUskc
         Cl+fFI7IwTJ3dNfehbmNiubXH1xEAkyDgwKNIqta67iIR0DvBIkynv0bGAfpu0XuFyJD
         p+AafJtiPfIWD7L5xLYd1MlbmDSJfZxG4AeFeBika54kE5Vh296nyYX3l4h+D2PQz4jA
         mB2jwfVj2klvEp9PF3Gc14Hr1Lakx1PnV1/MmFTxL4mVIZkXLuoJ04xnJQT1KtDn445x
         Olxw==
X-Forwarded-Encrypted: i=1; AFNElJ+UtK0GfS0ZI7EbSF1BqkuniaZWfAfz4gvq7qtdRutlSFOmE2kdXSjxeuBg+2kQp7UpVxIRU5w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGcMsO+Yc3vdesdoUtls1y/pzugeJ42P7lM5GtkLmxR7lPFXJU
	oHYCB2HQw5tDOkeRicG90sL/vjytGyeRYu+IfCWXFZ+ouTQfYOwRJQN6jXmEp7AYaomdcRzd+Y3
	+sNmlKZwBQUC92bp+Qf/CNboMAYWNKiweYy+YW8JI
X-Gm-Gg: AeBDievZ9xVj9T04cDnSzmznnnuZdrU3OGU0uw//oKDd4GuuE2Zxmwj0oZgsoSneIT4
	yxYHw02zS4M8/Ds0YSNLrulfoyaHIZAIa+oJaZcelnt+3zNVLI+gVgf0M8DnYquilKzwn4Eh+zi
	Av4uiGs4Xo8E1hyMDLeLauYWfOeQcN9z2KHGUiOuIwDzus1JqqM9JAT6YyYlhLh+Ye28kJehPx4
	YeeiPMFtiyydu59Fj3Qhb4dLJ7LvPoywc0cfIbskIZdN9MBAHd3JAKy+4PqNXUVaj5wD8nB21gl
	yZaeMj9oaldzntCcBZJPXYXnC5GRew8opPGOq6X2e0VKtUzUeUpCfQ9v2CnxMmk5ocEfDpjWqB+
	yY0E5Q4wHNjeo8e0bKqnvgvbp0Kkl
X-Received: by 2002:a05:6820:1ca4:b0:686:48b7:d81d with SMTP id
 006d021491bc7-68be5f4ecd1mr13747622eaf.15.1776323014699; Thu, 16 Apr 2026
 00:03:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69e06fe3.a00a0220.8f24c.0176.GAE@google.com>
In-Reply-To: <69e06fe3.a00a0220.8f24c.0176.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 16 Apr 2026 09:03:23 +0200
X-Gm-Features: AQROBzDloD8lcg0vRH0ullcneid6_j-6_RVbMSd7CUOTq4mi9kdlxzkM7NXR1oI
Message-ID: <CANp29Y4tjkywVs08piSWXdnoDwBWX6pJCarDZtaUGR5Wac=DkA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: tunnel: fix stale transport header after
 GRE/TEB decap
To: syzbot ci <syzbot+ci7355195b2024957a@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Apr 16, 2026 at 7:13=E2=80=AFAM syzbot ci
<syzbot+ci7355195b2024957a@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: tunnel: fix stale transport header after GRE/TEB decap
> https://lore.kernel.org/all/20260416034610.8873-1-jiayuan.chen@linux.dev
> * [PATCH net v1 1/2] net: tunnel: fix stale transport header after GRE/TE=
B decap
> * [PATCH net-next v1 2/2] net: add DEBUG_NET_WARN_ON_ONCE for negative tr=
ansport offset
>
> and found the following issue:
> WARNING in udpv6_err
>
> Full report is available here:
> https://ci.syzbot.org/series/3886f2f1-a6d5-4c5c-8dc8-bc1cec577567
>
> ***
>
> WARNING in udpv6_err
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      1f5ffc672165ff851063a5fd044b727ab2517ae3
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/06cf41a2-60fe-4f9b-8f68-57eb6d1e4=
8cc/config
>
> ------------[ cut here ]------------
> off < 0
> WARNING: ./include/linux/skbuff.h:3239 at udpv6_err+0x1521/0x16d0, CPU#0:=
 kworker/u9:2/51
> Modules linked in:
>
> CPU: 0 UID: 0 PID: 51 Comm: kworker/u9:2 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: wg-kex-wg0 wg_packet_handshake_send_worker
>
> RIP: 0010:udpv6_err+0x1521/0x16d0
> Code: f7 b0 01 89 44 24 30 49 bf 00 00 00 00 00 fc ff df e9 ea ef ff ff e=
8 8e f2 66 f7 90 0f 0b 90 e9 2a f9 ff ff e8 80 f2 66 f7 90 <0f> 0b 90 e9 bb=
 f9 ff ff e8 72 f2 66 f7 90 0f 0b 90 e9 1a fa ff ff
> RSP: 0018:ffffc900000074e0 EFLAGS: 00010246
>
> RAX: ffffffff8a5e6c30 RBX: 0000000080000000 RCX: ffff888106e91d80
> RDX: 0000000000000100 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: ffffc90000007670 R08: ffff88810be30ae0 R09: 000000000000234e
> R10: 000000000000003c R11: ffffffff8a5e5710 R12: ffff888116513390
> R13: ffff888114c38900 R14: fffffffffffffff8 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88818dc43000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555561513898 CR3: 000000016fad2000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  icmpv6_notify+0x407/0x850
>  icmpv6_rcv+0x13b0/0x1d80
>  ip6_protocol_deliver_rcu+0xe37/0x1610
>  ip6_input_finish+0x191/0x370
>  NF_HOOK+0x336/0x3c0
>  ip6_input+0x16a/0x270
>  NF_HOOK+0x336/0x3c0
>  process_backlog+0x7dd/0x1950
>  __napi_poll+0xae/0x340
>  net_rx_action+0x627/0xf70
>  handle_softirqs+0x22a/0x840
>  do_softirq+0x76/0xd0
>  </IRQ>
>  <TASK>
>  __local_bh_enable_ip+0xf8/0x130
>  wg_socket_send_skb_to_peer+0x16b/0x1d0
>  wg_packet_handshake_send_worker+0x203/0x350
>  process_scheduled_works+0xb5d/0x1860
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
> [davem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.=
org jiayuan.chen@linux.dev kuba@kernel.org linux-kernel@vger.kernel.org net=
dev@vger.kernel.org pabeni@redhat.com pshelar@nicira.com syzbot@syzkaller.a=
ppspotmail.com tom@herbertland.com]
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
-upstream-moderation/69e06fe3.a00a0220.8f24c.0176.GAE%40google.com.
