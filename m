Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758CA3769FC
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779201938; cv=pass; b=haHcdM3ElKGE6q8+JTQZTiGsChT/dm+xeSrwE934erImm78OTxGJWvmTb7Twf3CzueaN45xOzFKplU0Wd7CtZaBmJpmeNUNot8LvhYFpvhkGTshZHVLf6k04eMOw//DDgUdqq0D4m+pVGpgechJNlzttVXXK6p8qG28xO12fHSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779201938; c=relaxed/simple;
	bh=+QTVUAjQGcPBrl+S84eEbv98EekExcSBHjdKdVg2OXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KebKtAYvHP66Mw08DEGrAluC56np5etpIC5lGMsLCsJS+cbvM+V9DGxhnGxLjTBokkXsmDLp3PKCzk9ASC9nlKKo7nar7IjyrgIG3y1TQBNIY2eK0ejEwsJ5PrEjKrvbyMqAoIn7FdFEJK8jAJUfxBjch9joOZdeG7Us8EOycU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fIFw4G2q; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fIFw4G2q"
Received: by smtp.kernel.org (Postfix)
	id 2890BC2BCB3; Tue, 19 May 2026 14:45:38 +0000 (UTC)
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 29035C2BCB8
	for <syzbot@kernel.org>; Tue, 19 May 2026 14:45:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 29035C2BCB8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-43a86d544c2so1654900fac.0
        for <syzbot@kernel.org>; Tue, 19 May 2026 07:45:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779201936; cv=none;
        d=google.com; s=arc-20240605;
        b=UCIXaD/mwbwF3lxqNE0Qy2PI8pXkl4BNAu6rIM9szEWxPOw6Ml1Xc/ZiwswPGwXTmv
         kElzx4dXvIJ83IptS43zKqy2rK98NhiCEk+vmjRco5uQk+RYKczGR1QBK3nVirwRXFe8
         8T69mRbm91KtkGQvuUc7n6ItkjlTxbO/wGpacdsYx1wZsakONGifoZ2KKQHVyEC8FIUB
         Ex4SBabNdFHnRNoxBdkJ7lEbC9XqIRyKbGhQYYOeTLBmQ8waQMNjRSNnwT2XLT0LNA+W
         G6K7itCjDEWSVxPUVpQ896J56dPcDZDnXO82YYpX9nTIj58DPuwuHwgjWZuqk79y/Kn5
         7OAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fn6GojOHYOwIw8CVgvVOVm29ZEtH1Pl1mlOpVogr1cc=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=ECqvYs8jPR/aKHQBui5fod8tF5RXU6v5rncNuXUzLIAP7kipYFnEEzisovwnDrfN4v
         VQ2rkA1DD+SIq3Y1ubdE+/HGZRTBFPatD4e9IRa1/0t6Vraka14agrVNu8HXlGrgh0iU
         p3IKWRaUanIjPxIOHFcgaAjz/dd0cd+uS95SWcWYe/2LFtdW53Ze8wcorW0cNf4K6VpF
         Ree6ThJJSn1g2dOvukrVmLiOKRTD6M3a0MIhp0hmKULIA4XHeJ71XdAgB5YTCPo7+5ol
         L3xqLWvVqXZdEPFSNy0zDu2JU5ve8dJbaHwWK6ua7ofwahp081NySIwcukQPAueObjay
         Smbg==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779201936; x=1779806736; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fn6GojOHYOwIw8CVgvVOVm29ZEtH1Pl1mlOpVogr1cc=;
        b=fIFw4G2qjhXSda8NmlRBy3jFAPKBLJnh7FbQF5jbIZWvvf1Zf+lb5weWj35JqrKfxH
         6yEKJ49dA9EbezwEyArfVG0XMFmRnZcLrz8mZ7K+OAIo0pEfNVbliSpmaTCGJ/0oy6r0
         EAdoOZGSLpEqLYM9yBYSSBb+cgz9WXzGXExgr2/BJxDBK5Whcz7fCPVtSgsUPuGr9nwd
         1JZoBUb/kvyHwgq/2JV03M6AJgwoz8WwPchIXHdWXudQadESpfTM+/vAZaevzvlCWnSF
         pDDIb+Q26ZZ7DGrOV8Q9wY/OjEaT8Po82Qg0IPyZQLHrkqtkagK7YdmXapyprNBRA+SJ
         RbCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779201936; x=1779806736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fn6GojOHYOwIw8CVgvVOVm29ZEtH1Pl1mlOpVogr1cc=;
        b=lA0Cu/9WJdkbzVvSiKRNo3hWTbdnwjnas29VMs/uItBVq9ETNQcd5UrMJS4W7FdK8K
         IqqpUGNQ/C5m7NSb9HihCMEqSgNERKqBU30Yo5VqWsISTG6Q8lD6XdfPflAQdKCxNLM0
         Xyd5vnBLJlE+dPzHRmCb+gH0M3Fc9i8Tr6DHR5ROJWsdom/xs/S2WfbR2RoSaXfzSHVU
         PfnpMpXiAG98ZKmk08qd+MR1upjJUrecPRCoiH/a5YrhzUztWV4Kq/4Piav7uCB5Fz3L
         TCHuluuQpXz7PsYmM6s+4YNTZppBAgxkUOLM2whMHQhcKwP9Fxb4ZJqAW5913aum5kNB
         SL2Q==
X-Gm-Message-State: AOJu0YyTxUXH7DTWrhHDBpbyUd/KRm5Q9h3sM1Hn8iGyWEPtnfMC3Cs0
	DmLpBIgPIn5A245qSiMlLyerisc5Yslhs0mmm0IPExfmpGtyC43aaiFjye/ZesbPwVJFGunCyIF
	yIcrtImv044Hoq/+kX3vizq3r0VZFyvD6NvgEqw9Sp2IPhzqD6sszdq+P
X-Gm-Gg: Acq92OE5S5rMUop2sEyL/EwvgyEY0AHlL6buF3Z27joYHXMTQa4TlsaU/bEW0PDIoTY
	+noTg1vY5cTz5iv15ZIFoWm3XND0y9uaQbbag5n79XI1ypRi29u2lYiC32CGHYVLtUcbKnY7DY4
	7A8UbOqQ9pWOocpHU0z54BbzhtZEIhQltemDkWrxvlh6k0wRZZ3DxREjagLty6UjwoUzTP9nq5Y
	CW0+LpNTRjTbf5EFyAZ0tcLFrVwO0UFQC/j+f984ydTuM2j/2zkXRTkiOvRy1xroY2bsGJBzXXp
	6SM1JT9PacwrCGvkg6GV8wjL7UHhc2dYa7iXPnNDldVrcMdeFt1YPU+kzU6wW7P1pSZM159skQ+
	KOXE=
X-Received: by 2002:a05:6870:91c9:b0:3d9:2fe2:f5c8 with SMTP id
 586e51a60fabf-43a2e0955bbmr12382798fac.32.1779201935503; Tue, 19 May 2026
 07:45:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2cdda92f-08ad-4bc5-a2cb-b2bf9c8d222d@mail.kernel.org>
In-Reply-To: <2cdda92f-08ad-4bc5-a2cb-b2bf9c8d222d@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 19 May 2026 16:45:23 +0200
X-Gm-Features: AVHnY4JRsHwcEHHV-O7_jYdqdT6Igc6as5BttOTHxWLD-nxj36S8Mr7dCcFPccE
Message-ID: <CANp29Y7GgGK_H4O3Z6SXwebcOOoLjCbpd_CKXUXXQRdGB3gbTQ@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: Fix uninitialized value in eth_type_trans()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Include parts of the stack trace in the description.

Also, regarding patch title: if it "fixes" the uninitialized value,
I'd expect it to initialize it, but in this case it prevents
uninitialized value access (which is good, but it's different). Please
carefully look at how other similar KMSAN bugs were fixed in the
kernel and what their commit descriptions were.

On Tue, May 19, 2026 at 3:36=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> syzkaller reported a KMSAN uninitialized value crash in
> eth_type_trans().
>
> The root cause is a missing check in __bpf_redirect_common() and
> __bpf_redirect_neigh() when an L3 BPF program redirects a packet to an
> L2 device. For example, when bpf_prog_test_run_skb() runs an L3 BPF
> program, it pulls the MAC header. If the BPF program then redirects the
> packet to an L2 device without pushing the MAC header back (e.g.,
> leaving skb->data pointing to the network header), the redirected packet
> will have an invalid MAC header offset.
>
> When the packet reaches eth_type_trans(), it assumes skb->data points to
> a valid MAC header and attempts to read the protocol type. Since
> skb->data actually points to the network header, this results in an
> out-of-bounds read. If the skb head was previously reallocated (e.g.,
> via pskb_expand_head() during bpf_clone_redirect()), this out-of-bounds
> read accesses uninitialized memory, triggering the KMSAN bug.
>
> Fix this by adding a check for skb_mac_offset(skb) !=3D 0 in
> __bpf_redirect_common() and __bpf_redirect_neigh(). This ensures that
> skb->data points to the MAC header before forwarding the packet to an L2
> device, dropping malformed packets early in the forwarding path.
> Additionally, add a check for skb->len =3D=3D 0 in __bpf_redirect_neigh()=
 to
> align its validation logic with __bpf_redirect_common().
>
> Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
> Reported-by: syzbot+0901d0cc75c3d716a3a3@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3D0901d0cc75c3d716a3a3
> Link: https://syzkaller.appspot.com/ai_job?id=3D4ec1a9c3-4883-4b6b-894d-8=
937ab4afc45
> To: <davem@davemloft.net>
> To: <edumazet@google.com>
> To: <kuba@kernel.org>
> To: <linux-kernel@vger.kernel.org>
> To: <pabeni@redhat.com>
> Cc: <andrii@kernel.org>
> Cc: <ast@kernel.org>
> Cc: <bpf@vger.kernel.org>
> Cc: <daniel@iogearbox.net>
> Cc: <eddyz87@gmail.com>
> Cc: <horms@kernel.org>
> Cc: <john.fastabend@gmail.com>
> Cc: <jolsa@kernel.org>
> Cc: <martin.lau@linux.dev>
> Cc: <memxor@gmail.com>
> Cc: <netdev@vger.kernel.org>
> Cc: <sdf@fomichev.me>
> Cc: <song@kernel.org>
> Cc: <yonghong.song@linux.dev>
>
> ---
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 9590877b0..86eb2d5c3 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2190,7 +2190,8 @@ static int __bpf_redirect_common(struct sk_buff *sk=
b, struct net_device *dev,
>                                  u32 flags)
>  {
>         /* Verify that a link layer header is carried */
> -       if (unlikely(skb->mac_header >=3D skb->network_header || skb->len=
 =3D=3D 0)) {
> +       if (unlikely(skb->mac_header >=3D skb->network_header || skb->len=
 =3D=3D 0 ||
> +                    skb_mac_offset(skb) !=3D 0)) {
>                 kfree_skb(skb);
>                 return -ERANGE;
>         }
> @@ -2430,7 +2431,8 @@ static int __bpf_redirect_neigh(struct sk_buff *skb=
, struct net_device *dev,
>  {
>         struct ethhdr *ethh =3D eth_hdr(skb);
>
> -       if (unlikely(skb->mac_header >=3D skb->network_header))
> +       if (unlikely(skb->mac_header >=3D skb->network_header || skb->len=
 =3D=3D 0 ||
> +                    skb_mac_offset(skb) !=3D 0))
>                 goto out;
>         bpf_push_mac_rcsum(skb);
>         if (is_multicast_ether_addr(ethh->h_dest))
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
-upstream-moderation/2cdda92f-08ad-4bc5-a2cb-b2bf9c8d222d%40mail.kernel.org=
.
