Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794295192;
	b=kr2dOExZRMUVM769vXcMFwv7DrvnXtP3Iq/BW7v6LA7wZp1wicCvHfMa20lXHSsNlN8R
	 wkgJfTGJ+M5NZiM8OZqUDZsJgp+UO+uz3y0Xk/adkLh5Gl7cm4jiG9wDYPWHy0hkCNzQG
	 +s/Yrkf19wfsmR04mMzsmztR3pPy7hOaHYJQm+V4Uu2pt7K1qZwH2ZPNQcXIsJSli8H1G
	 +VLnoHcps9VWfY/LdQuIpQ3XTwRyP3nvZ9zviG0ixCfhaZ+lF5FpIhu/tCJtHO9vrynvD
	 yYehzrdjFteIcxJcLWF1desg9MJnUlNUogDLdlBFe0BQRGgHF3STWbEhotaRaM/E+dQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794295192;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=rn+y8L+7s1LIwuXhuSBgnB6h2dlhff1bgHSWvQihd74=;
	b=Gsttiea9JBfYJ+vbRKQHMoBnTb1BZeUuMgiA231Hqy1+ZmcxtZITp/Q3P04eNo4v4cbV
	 ryEblCcf4xI+eKXkBAs7PoKHbNTtUBrDUIdTEzGv9wQbUphUc/MlPozbW5Y9f6cfLxAyW
	 yibv+gf4px29RpRBZHhnctInWxLWq1c7nGNOHHauET7OuSzq4Iy1QawBNYtsmFz1v2rD8
	 VLO/b9XCyurkn2QO4DN9V6sF3/ThIsm8+HJiuGpBrkemToEsXrA8sGrW5h+VQKy5lQlIc
	 zhsvdihmzLkBc+g8Uo0yhYugeOJ1NgAB8WbN+50j3t7/7kNFaONXFmwTUZvFMDug58g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=agKwMmb6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA68A606D637
	for <syzbot@lists.linux.dev>; Tue, 10 Nov 2026 07:19:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA68A606D637
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=agKwMmb6
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-70b875f6f1fso1280219eaf.2
        for <syzbot@lists.linux.dev>; Mon, 09 Nov 2026 23:19:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794295191; cv=none;
        d=google.com; s=arc-20260327;
        b=pVYg+mNPI6FI0Dtke+Akp/nAQj8nBzuys4B0GzGD5cfjIT31FeHI556jbuGGdFK+BF
         5T9vK/j/ImmxUFL/6CebB3i2DmgOAj2dLzf6Vk5qrq21FkuFzRUtnDIzkMrZHanqSNiW
         H82oBuBnbQNuPdzxbvbEqmKZdZisekafsZeex0Pz7FOM/MadWbYHRgBSGhViYftIp2Mh
         8+TgVjs32ol8YhZdZEQwOdiKtruqG8R0aDaCVYEJWy1Fe7fWlrIl/LSIFUuXKrsvwwpR
         Oz+VFtOj1ueWawi+DnQqXB98SBeeHp7aXpqfDYNdW0zjLjachQ6vxlMxQ1znSJ+zgCPF
         LAKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rn+y8L+7s1LIwuXhuSBgnB6h2dlhff1bgHSWvQihd74=;
        fh=iDtNPjVdMza9LPVsvFDPRNlkFmZDQ7gjgSeM9HB8elE=;
        b=Tm5lEvxzemPreRqEDyxvhhZJuv2jFS+4RwbRSzg8n9WxjubpbaoXwR2btjChP3sfS0
         HiYr2gGjOXYbkPVb7ppbteXwn3a5sbmlb+14zArNfjNW0weqDiHIu/xcawLJEERB4RTK
         Xv44WxbjqnKcdSA6iFy5EhxxbB9VSoGb55tl9ZOFUq8mDMgPPJ3bWBKkd8Gm2z784qND
         HEH6pVPAeQO8CHrMAM/0e1jH+ly70uQaKx5vLsmZRnNyMDx4PQb/1np47R3SpsA5JU9M
         RdD+Fpsz9CuIui4BtOVSZUibP9f6yRPoPzjXNzePpal89ocHGSopk77QkNr8OsyoPVix
         hC/w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794295191; x=1794899991; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rn+y8L+7s1LIwuXhuSBgnB6h2dlhff1bgHSWvQihd74=;
        b=agKwMmb6nZyEBzRdDmswxaChmXnG9vTkk3HsmqCGWgbiG8ekwgswilVYVpoz+H51XO
         ukDOF97fMtFH3JX8DByT+TPueituO559qac64lIzoomtVqCm0AC/4/gUKiRhuoxG5z14
         um66Lk8wzLJTbLZK46NfKIx+YnYJVHZJkHcqBChfBq/iwo4jPJH0SQJTJFcFcOz315Lx
         UOZgNJzLQfyyuYMQ8HeiW7OQYHUvE+LfzQvrHUMdCc2UCpKTGeubF0A5t8TuWErtWZ0X
         v+ZWsftbEX+0TT2L92N7DbcCGcngXUyDCvNg3gH+xa9hkIhEot8iH98IeGIe5lgEssBW
         kgbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794295191; x=1794899991;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rn+y8L+7s1LIwuXhuSBgnB6h2dlhff1bgHSWvQihd74=;
        b=jvjfWLdKNgDEW1CuFBYUSrRvpjHq36ZXi7mpKZh48ry9GMAzSeQc+QSF2+wwx/qoZ1
         ts9BDJKxBNluoAvyxbor8jLy5+JOkK/gSElvyx6AQ7ruZLq0xXwLy04mSBGbcpq+a1eK
         cqUKlJOMkH9auFIrRz/I9vgd2kYc3OnO+w+DP1DmGH/9Y/HDN9GfwlRd1OtDSja3jNBe
         tfWfRyGJG4uwVVhdWGL3twpd7xwSTyYmXGl11HWRFeYGCcApwBpHc2N9LrmadrdXwxab
         fPdejbnfamXuNEElcGwCrp2FyJhQnz9ptS6w9uAq2RDc6ao6GuUythLeQI8Yv70FxDx4
         gzgw==
X-Forwarded-Encrypted: i=1; AL+hErFSblRmS9GJFK7zPV895J+JX65N4tGqVep95VpIoj0mmSgUAx4DTybnvC53q8Z1NdwqbZUaqPw=@lists.linux.dev
X-Gm-Message-State: APuU4Z/WjHIQyCbfSP1gnHejwv+fUNHaalD9EpfnH244CF2uo/W0yynV
	OPqdTib9Da3IUZldnH0z+rvz5pLCGXfSnTxWwenHU0zuSz01CiPQCl35Xi3Xa+8FZvNc5uNGa9a
	iIooqu5PCSpuAqLgPum6wMdliMMC29Ro1dWyW5gPOG1+WEhAvLBWJZpP7
X-Gm-Gg: AYBFou2nDlaxS+4Q7G70UFORAtDCg3Kx62R3ttuEvtC6JJsxlRG3jpcNoudRlhT8wzC
	B0KQFmdvV49WySmg1PHZ5JN+9rqtFnYMBHWHnP+DUoWVgeY6sOTWabw44tfOSmIOXr+OZKzG/Td
	t/4xbRPStvYYagrExYt7muRKRETpuH28/8Rlv74QUNRmxrgBb20Vyj/SnbHBU1bjtUb4PRlpeTi
	0iUkZY/kjwCP6l9/OZja0/qugTCRpLiEreJDmCldtb3bdE0kylD4klndBP5241LiHM10EwfpzRI
	z3er1AH2BDWt9pgMONmEJLZVb564j1wHXJkdFSVz4JKkaGF/8kyv5t+EdPhjTgX46yg8iVIRywV
	UVGw+m5rsULCqm9Km11xepCGquPvVMZhj8inCTgZaJmIBIAeNmnhU0xhhNI8yPlIrezt2E4DomG
	uDqIjGxWX/G9/nClviQCuIaRe2oUNYPlha8Dm+gSOi2DxKg/rXmybMJyExp1EwPjRO3WYyq+QZd
	Ih4X3jIbQ==
X-Received: by 2002:a05:6808:e90:b0:4fb:ac9b:b06a with SMTP id
 5614622812f47-5683cd2ca4dmr1384226b6e.48.1794295190143; Mon, 09 Nov 2026
 23:19:50 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6af2c19a.4dd4714a.f8d02.0022.GAE@google.com>
In-Reply-To: <6af2c19a.4dd4714a.f8d02.0022.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 10 Nov 2026 08:19:38 +0100
X-Gm-Features: AclHuK8Ie8dj60ANfjSmh4I1cQ-I1KEpde4rPn5gY8f7GzAZ2xWKZ_Kiv50mjlw
Message-ID: <CANp29Y7nvGO3ku7+rGVe0a7JnjjJO=SfcQ0AXUq2tkNGLyHkYw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: xfrm: fix IPv6 atomic fragment policy handling
To: syzbot ci <syzbot+ci45a8a6066bea8b92@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Nov 10, 2026 at 8:02=E2=80=AFAM syzbot ci
<syzbot+ci45a8a6066bea8b92@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] xfrm: fix IPv6 atomic fragment policy handling
> https://lore.kernel.org/all/20261106202910.723098-2-Jeremy.Jean@oss.cyber=
.gouv.fr
> * [PATCH net v3 1/2] xfrm: fix IPv6 first-fragment protocol decode
> * [PATCH net v3 2/2] xfrm: fix selector matching for IPv6 atomic fragment=
s
>
> and found the following issue:
> WARNING in __xfrm_decode_session
>
> Full report is available here:
> https://ci.syzbot.org/series/9d92ff08-0b82-4440-b345-9628353f5181
>
> ***
>
> WARNING in __xfrm_decode_session
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      2d2200551ccc3b9e444aecb59c4b53287e169266
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/fe2ead38-2a3d-497a-9bae-e5da0ee59=
933/config
> AI triage: https://ci.syzbot.org/findings/072b992e-75d5-4bd7-b9e1-5247e37=
4123e/triage_trajectory
>
> ------------[ cut here ]------------
> len > ((int)(~0U >> 1))
> WARNING: ./include/linux/skbuff.h:2856 at __xfrm_decode_session+0xafb/0xe=
d0, CPU#0: syz.0.121/6184
> Modules linked in:
> CPU: 0 UID: 0 PID: 6184 Comm: syz.0.121 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__xfrm_decode_session+0xafb/0xed0
> Code: bf e0 00 00 00 4d 03 3e 4c 89 f8 48 c1 e8 03 42 0f b6 04 28 84 c0 0=
f 85 11 03 00 00 45 8b 37 e9 33 fd ff ff e8 c6 c7 30 f7 90 <0f> 0b 90 e9 8c=
 f7 ff ff 44 89 ef 8b 5c 24 20 89 de e8 bf c9 30 f7
> RSP: 0018:ffffc9000e926b60 EFLAGS: 00010283
> RAX: ffffffff8a9849aa RBX: 1ffff92001d24d74 RCX: 0000000000080000
> RDX: ffffc90006ec1000 RSI: 0000000000000c7f RDI: 0000000000000c80
> RBP: ffffc9000e926c90 R08: ffff88816dd8bc00 R09: 0000000000000002
> R10: 000000000000000a R11: 0000000000000002 R12: ffffc9000e926bc0
> R13: 00000000fffffff8 R14: ffff888105f226d8 R15: dffffc0000000000
> FS:  00007fc136da96c0(0000) GS:ffff88818be0d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000002cc0 CR3: 000000017256e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  icmpv6_route_lookup+0x44a/0x610
>  icmp6_send+0x114c/0x1b50
>  icmpv6_param_prob_reason+0x32/0x50
>  ipv6_frag_rcv+0x927/0x2b40
>  ip6_protocol_deliver_rcu+0xe8c/0x1680
>  ip6_input_finish+0x191/0x370
>  NF_HOOK+0x336/0x3c0
>  ip6_input+0x16a/0x270
>  NF_HOOK+0x336/0x3c0
>  netif_receive_skb+0x278/0xbf0
>  tun_rx_batched+0x1de/0x790
>  tun_get_user+0x2b78/0x4470
>  tun_chr_write_iter+0x113/0x200
>  vfs_write+0x612/0xba0
>  ksys_write+0x150/0x270
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fc135f6974e
> Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4=
d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f=
 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
> RSP: 002b:00007fc136da8fb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007fc136da96c0 RCX: 00007fc135f6974e
> RDX: 000000000000004a RSI: 0000200000000700 RDI: 00000000000000c8
> RBP: 00007fc136037f6d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fc136226038 R14: 00007fc136225fa0 R15: 00007ffcfeaad798
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [davem@davemloft.net dsahern@kernel.org herbert@gondor.apana.org.au idosc=
h@nvidia.com jeremy.jean@oss.cyber.gouv.fr linux-kernel@vger.kernel.org net=
dev@vger.kernel.org stable@vger.kernel.org steffen.klassert@secunet.com]
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
-upstream-moderation/6af2c19a.4dd4714a.f8d02.0022.GAE%40google.com.
