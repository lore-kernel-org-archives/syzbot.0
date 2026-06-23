Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B073225417
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782219087; cv=pass; b=hrFohxsT8OcR4fI5QOZIX3tB8zj+Kpa3qHxWcK/kakU9vAGXeq9Ao4sSvvDfOzdj/UyE+p94FxZJohkMkmlPHhq8WcL7RglEVshw9ExPYLDwW8yKs9vgjVojpG6R07jKIARSj3SDqFfqXjPEL/tZfwyiQeOAFcJ9Br5DhWArIdo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782219087; c=relaxed/simple;
	bh=s1eDyjrwmYIjiQZQrEillkLJJL6zCfLsYyKbwR5CnoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k6bZ6YUVl8en5qC3G0ZFxtpDSKnbaqXDVETIJeZ/pTIxCi+0Zdv97tDa87RQghWzx1XNUkOhwBPQr+KJIJ3BoMYU0WixyAA/3xt2tXGjdyS7sFTY4k/We3JR8odAHDr9X0wIGMC7XBd3DonydGshG981zB2iSdUcMsnhZq8/GhU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wGCIVQaD; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wGCIVQaD"
Received: by smtp.kernel.org (Postfix)
	id E0C021F00A3A; Tue, 23 Jun 2026 12:51:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.51
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1782219082;
	b=vZN9+eClf+ZaBU0cSqV/zz1JpR8IgbbpTFII2Mhmj7ds2+Qr3VkvlIGInm+vs4SyJsCe
	 kA9wsGWCxcjQNh4EyP96+en+NqUd3NE4/qQGngKo4oeZTD0nCvsQloTjlZkfyTW6cz9vf
	 QO0Ng3IKO1HKldF1YGG74naTtyY1e2QdddtDyT6GrmP5vJuSOLUmmM5B864SjPCfxZViv
	 BBjuZBYhkZzXSyLBid6H9j21fGp8J8V45uxw7wc6tKCI+tzkLfxRYb0FvWW0bIwhzjbpu
	 KwXs870mSFZHe1rUTma4JUNLrEC+UtagbNTOCBDKo3Ho3SRmT1mEWBAB3Z11tMQvLQA==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1782219082;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=UDgOT3kQbhMyHfLTid253F5cq7C7u5Y5nGsKtZeAMUw=;
	b=eR1Ix6WBmWe21K6ifYaJxaSRf0hwjtidhRvHZyg4E+jfG4urHu2pfGb9DyhM4Hh84KHt
	 2jTSqU1vFJbx58Dw/sBzmtdfoYuvN4WMXYuVGp0SBq9ZpFZlK8Si9888s4zlWVX/y/j6q
	 2TiwFep6xap7rwG3ZhQCn17yHAfLorc0r2+Tb61j0jCUSKuNd5WStKOe1N8JX88/1U24e
	 z3dKQtwy/KbB7GJO6JMaL8YbdLYSB5PaOABStlje0/bKuGO+b7K8yq4jL3Qltu9AWxffS
	 77sbCBcVnwUxJWw0OozuAXxr/AWWqGf6k8tME8bNbmu0pJo4UdIjJ2MZjd9csvlKPDA==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=wGCIVQaD;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.51
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3610A1F000E9
	for <syzbot@kernel.org>; Tue, 23 Jun 2026 12:51:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=wGCIVQaD
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 3610A1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-43ccd4f6f6eso3920278fac.0
        for <syzbot@kernel.org>; Tue, 23 Jun 2026 05:51:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782219081; cv=none;
        d=google.com; s=arc-20240605;
        b=ct5SplE2TUmjKvIVmulEUdtEHFuv5SRWDY0EjlZxcW1D77pEXTdCrXMw/GoK18ye09
         5WX8StNZuKRz4k/8X20ob7HUB0De377R9LzSJQwVGws0EVEGhmxnkMvUf9N/Jxv8FvYY
         ZUUVESz3DikqFUrHOQnYTpoWr5s40fk5duB4jV5XoIdrklnDs2rCWP4hTCdkoYDWuvOL
         ZuR+pYVIy//Q/RI1hRUd5KmVqxxjPN56pDpTETWkJYlVd6rFYfPminfotOJ6Ucg9Zv0g
         vyxdKr0hcrt2PFm22B8/W0Jx01xs2gsje/Hz8kM224QDbqk9Jm8RXdmr1MS4Pv563eBa
         m2pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UDgOT3kQbhMyHfLTid253F5cq7C7u5Y5nGsKtZeAMUw=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=bSx+QDyZdtumEmfiNTozGrzyey3kddfitPgZAlUXaKmQgHV0V4pBy+WEPmBz3k2NTv
         p1UIDlhItWQJ4rKTvAjdQk1SPKobTrMYpIEyv5AQMt1BK52iGWxfF1VvAwu1hTwQKHEk
         2qiMGVBFas1Lb01bdAhAf7so5GlFdMJ/1FKqIhMeV4S0MeTYhFwSYNqQg7aa1hHQHshv
         Wx296YL0WMFex/6Y+SHo58WB3CT0TtApkr17ds3ULJgpehqqzOC/ksWL8tgZIIaejbzs
         7JXJqHiYrU2nv2O6GtBqVTm1d5u6iqDWDjvTXg3gSKoxlpWLyd9Kqpz/oIHdXpmod7gv
         /HEQ==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782219081; x=1782823881; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UDgOT3kQbhMyHfLTid253F5cq7C7u5Y5nGsKtZeAMUw=;
        b=wGCIVQaDhTgJrIqFk8aUuf2JicNI0Kc1mR1414xQW8vCD7YDVSxT5YmE/9xQgcHqeg
         pmrvs4hCueq56yTf5GSHE4n5EAFcUMvS0zOKwB8vn9RKvLJ70GFBJ8yd7A4R3qYWyi5M
         Y/o7tSgibgQCMmR4giRs2hEWfgUm2Ba9uGS/IPn78dqHRsgSONrLFQAhNd1yhUbZr6LR
         ACl52CCwl/NfLvZnVV6Pjhd4f5SXKp7JhN9sq237ESyKLd/nQIdQ1Kafz2YeBsWvlLnW
         mfi2bUywXGNmfQL4DwomPfA/5X09R0SgJLNHy7Z8ykvbsuHxmo0yk2HnnFGpV3yZ2fLq
         BqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782219081; x=1782823881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UDgOT3kQbhMyHfLTid253F5cq7C7u5Y5nGsKtZeAMUw=;
        b=DoSZXRXFiC4TJdvARwIpY2t8D/dMxkV9rn2K+J3KgYOQbY7YmPW9lItVJ2gMgcTFZC
         NZRPf9DrC34l0jvR7U21J88ntdQYGhzsOxfV1BjSo8enVFJi8swU6vnJwOxQiHbg+Sr6
         urw+3BXNH/Ij5zSYAxlhiDcW59eKn+oWXzVolJADQV5amltqudxncf1V/giXctd6N7eI
         Moqd9VCMPe0QPYZH6/+EX3npZKr+Q/0XbfBXDSO/SjjPVz1B0CunpzEmPLBcZlWIZ0ip
         pVu+oMZy/NJpTOMFEe5wk1AiA1lbT12ASGPo6vfXMGTmKxvdHMWfLJ2NRMUpAEYcL68i
         T9mw==
X-Gm-Message-State: AOJu0YwpUL0GlSXucj8j2f3SJ1nt+cECNKHZsboDjYe6GHRBZ7PtwpPw
	ASd/I3GZKH8FHPlG1PM5mVZfCFRxYx68V/n3ewAx26r9unDGp21hzgW5Y7rjlCGd+lY8qZfDirF
	BXfBM1IkwRYcOpd/YZWqSB2Rw5gRDmOroBj27xdxCFwSzpHfln8tGkLe7
X-Gm-Gg: AfdE7cmxksEIQIbon+q2pZOH+VSfOVlw27Kzqg3OuEoxdLLD5vpbLPQlcITZAqHv1ew
	hrNvJ5+nHIaoIUSevinL4+d98sQymPW/psDIXyvL9VWHwsKCAlt5VmQwMkRL5w6UduA51Tl43xG
	AAq0ad9S25CjoW5JsxMWZHG0umq7d2hVCoKeRkfJUii5PK//diLMc8UjukY3K4PD8AFpmATOh6j
	WVefVlD2KCdyq3JViEBKMlbUSUetMi03r+JX2VpHV3ALfAoADONr3LntqfEGloMzJZJsWRN3dsF
	etZpa7PT8AP0irliQN+KeqCOQK3tBy2M+KiuQUkowJn+p2djhk0wgv0lnpwxW//UmKP+DGfTGEs
	7d7USWzFBnOxRva7LKSmO+SantcYJBHkTMxB/tcV3
X-Received: by 2002:a05:6870:568d:b0:42f:af81:2765 with SMTP id
 586e51a60fabf-44707e90156mr14457744fac.16.1782219080367; Tue, 23 Jun 2026
 05:51:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <00558653-6963-4e86-b4b4-3c0d4ee1977f@mail.kernel.org>
In-Reply-To: <00558653-6963-4e86-b4b4-3c0d4ee1977f@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Jun 2026 14:51:09 +0200
X-Gm-Features: AVVi8CclYXFVctgZW-w1oAvxSceLoJmYIoIBDxioo5OytEl6yThU-JDOx3BxrfY
Message-ID: <CANp29Y6BPvZTngiKH4iUxTx4g17MX1SvJ6SDa-y3ycF2UYEiDA@mail.gmail.com>
Subject: Re: [PATCH RFC] netfilter: bridge: fix VLAN protocol mismatch in nf_ct_bridge_refrag
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Let's try again.

#syz reject

On Thu, May 21, 2026 at 1:14=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The root cause of this bug is that nf_ct_bridge_refrag() expects
> skb->protocol to be ETH_P_IP or ETH_P_IPV6, and skb->data to point to
> the network header. However, if a VLAN tag was pushed into the payload
> during bridge forwarding (e.g., due to a VLAN protocol mismatch in
> br_allowed_ingress() or tc rules), skb->protocol becomes ETH_P_8021Q (or
> ETH_P_8021AD), and skb->data points to the VLAN tag instead of the
> network header. This causes nf_ct_bridge_refrag() to hit the default
> case in the switch statement and trigger a WARN_ON_ONCE(1). Furthermore,
> even if the switch statement was bypassed, nf_br_ip_fragment() would
> read the VLAN tag as the IP header, leading to corruption or crashes.
> Additionally, nf_ct_bridge_frag_save() and nf_ct_bridge_frag_restore()
> assume the MAC header is exactly ETH_HLEN (14 bytes) long, failing to
> save and restore the VLAN tag in the payload, which causes the fragments
> to lose the VLAN tag.
>
> To fix this, we need to properly handle packets with VLAN tags in the
> payload during refragmentation. We expand struct nf_bridge_frag_data to
> store up to 32 bytes of the MAC header, along with the actual mac_len
> and the original skb->protocol. In nf_ct_bridge_frag_save(), we save the
> entire MAC header (including any VLAN tags) and the original protocol.
> In nf_ct_bridge_refrag(), if the MAC header is larger than ETH_HLEN
> (indicating a VLAN tag in the payload), we temporarily push skb->data to
> the MAC header to use vlan_get_protocol() to find the inner protocol
> (e.g., ETH_P_IP), and then pull skb->data to the network header. This
> ensures nf_br_ip_fragment() sees the correct protocol and IP header.
> Finally, in nf_ct_bridge_frag_restore(), we restore the entire saved MAC
> header and the original protocol, carefully adjusting skb->data and
> skb->mac_header so that br_dev_queue_push_xmit() works correctly.
>
> Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Reported-by: syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Da8ba738fe2db6b4bb27f
> Link: https://syzkaller.appspot.com/ai_job?id=3Dd2874cff-e6fe-4bb5-807f-d=
d0552282866
> To: <bridge@lists.linux.dev>
> To: <coreteam@netfilter.org>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Florian Westphal" <fw@strlen.de>
> To: "Ido Schimmel" <idosch@nvidia.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: <netfilter-devel@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Pablo Neira Ayuso" <pablo@netfilter.org>
> To: "Nikolay Aleksandrov" <razor@blackwall.org>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Phil Sutter" <phil@nwl.cc>
>
> ---
> diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_b=
ridge.h
> index 743475ca7..7919223ba 100644
> --- a/include/linux/netfilter_bridge.h
> +++ b/include/linux/netfilter_bridge.h
> @@ -6,10 +6,12 @@
>  #include <linux/skbuff.h>
>
>  struct nf_bridge_frag_data {
> -       char    mac[ETH_HLEN];
> +       char mac[32];
>         bool    vlan_present;
>         u16     vlan_tci;
>         __be16  vlan_proto;
> +       u16 mac_len;
> +       __be16 orig_proto;
>  };
>
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netf=
ilter/nf_conntrack_bridge.c
> index 58a33d038..a2d85e799 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -6,6 +6,7 @@
>  #include <linux/netfilter_bridge.h>
>  #include <linux/module.h>
>  #include <linux/skbuff.h>
> +#include <linux/if_vlan.h>
>  #include <linux/icmp.h>
>  #include <linux/sysctl.h>
>  #include <net/route.h>
> @@ -320,8 +321,8 @@ static unsigned int nf_ct_bridge_in(void *priv, struc=
t sk_buff *skb,
>         return NF_ACCEPT;
>  }
>
> -static void nf_ct_bridge_frag_save(struct sk_buff *skb,
> -                                  struct nf_bridge_frag_data *data)
> +static int nf_ct_bridge_frag_save(struct sk_buff *skb,
> +                                 struct nf_bridge_frag_data *data)
>  {
>         if (skb_vlan_tag_present(skb)) {
>                 data->vlan_present =3D true;
> @@ -330,7 +331,12 @@ static void nf_ct_bridge_frag_save(struct sk_buff *s=
kb,
>         } else {
>                 data->vlan_present =3D false;
>         }
> -       skb_copy_from_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_H=
LEN);
> +       data->mac_len =3D skb->network_header - skb->mac_header;
> +       if (data->mac_len > sizeof(data->mac))
> +               return -E2BIG;
> +       memcpy(data->mac, skb_mac_header(skb), data->mac_len);
> +       data->orig_proto =3D skb->protocol;
> +       return 0;
>  }
>
>  static unsigned int
> @@ -340,11 +346,23 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const stru=
ct nf_hook_state *state,
>                                   struct sk_buff *))
>  {
>         struct nf_bridge_frag_data data;
> +       int err;
>
>         if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
>                 return NF_ACCEPT;
>
> -       nf_ct_bridge_frag_save(skb, &data);
> +       err =3D nf_ct_bridge_frag_save(skb, &data);
> +       if (err)
> +               return NF_DROP;
> +
> +       if (data.mac_len > ETH_HLEN) {
> +               unsigned int mac_offset =3D skb->data - skb_mac_header(sk=
b);
> +
> +               skb_push(skb, mac_offset);
> +               skb->protocol =3D vlan_get_protocol(skb);
> +               skb_pull(skb, data.mac_len);
> +       }
> +
>         switch (skb->protocol) {
>         case htons(ETH_P_IP):
>                 nf_br_ip_fragment(state->net, state->sk, skb, &data, outp=
ut);
> @@ -366,7 +384,7 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *=
skb,
>  {
>         int err;
>
> -       err =3D skb_cow_head(skb, ETH_HLEN);
> +       err =3D skb_cow_head(skb, data->mac_len);
>         if (err) {
>                 kfree_skb(skb);
>                 return -ENOMEM;
> @@ -376,8 +394,12 @@ static int nf_ct_bridge_frag_restore(struct sk_buff =
*skb,
>         else if (skb_vlan_tag_present(skb))
>                 __vlan_hwaccel_clear_tag(skb);
>
> -       skb_copy_to_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLE=
N);
> +       skb_copy_to_linear_data_offset(skb, -data->mac_len, data->mac,
> +                                      data->mac_len);
> +       skb_push(skb, data->mac_len - ETH_HLEN);
>         skb_reset_mac_header(skb);
> +       skb->mac_header -=3D ETH_HLEN;
> +       skb->protocol =3D data->orig_proto;
>
>         return 0;
>  }
>
>
> base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patche=
s.md for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/00558653-6963-4e86-b4b4-3c0d4ee1977f%40mail.kernel.org=
.
