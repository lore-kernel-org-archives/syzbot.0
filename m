Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8513F369D63
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 10:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786356133; cv=pass; b=CkpSbqKu+gJJGbuuqChv4tTmbBWUMwVAIy/1ydIwu7rmd/YYklt4MS/bJS/caveUBZZIX94zLvBy/vjuNGbLA/1suSy2DH3OFCCNBDC3vW2oKQ9RIk8jCxNgCt30pJBAtySm+3uFmuQ/9HDrzSgkwO300mOECVlzuyoKVvn3c3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786356133; c=relaxed/simple;
	bh=sNPzfvJ8hF09z/hhul6Ull/Ueo8EuLtxjj+7r8eyjB0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KumQFOQDg0K3AzP0qIEyGqQIJ/nVFBBBuPzY8I750Rtnbj9HUelu4C/7w3oEhgSzDEaw0D+eduudT2S0pNl4AWkgAXOkTuo056P/7DT9uS8qwvaXb7Kuhm/KtnRzXlSBGM/wG4ubKf4sjC432q7kqFNw7ZA34Qvh+IkVbomHRpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ywk+x6tb; arc=pass smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ywk+x6tb"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-495c49f8eccso891172b6e.3
        for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 03:02:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786356130; cv=none;
        d=google.com; s=arc-20260327;
        b=ivlcJHWzMWyB1fD74ApFY8yv8AGW/B8v85X1cfWQJJPP/Lcp9C7TMYOq7jLPf4UEFK
         wcY4v6fIVK3YtclNPUTmECJfxVi0Sb1w8i/99k9jc4DDwHRWJeUlTiUOqBHss/EG0jzA
         eD/NOaNQY7L4qJ54KgDl3X3UAWHGx/CzmZ1wrR4twO0oz+yJZBSluEIiG9TQHib0GfNg
         nZpuyrHZKVZK2C3yz6PBaSfh1Nb2JfvuDmX0/jdX2OFbfCaWmkXZo/QjvWyLDJaGC9iz
         Bn57V6EQWZuIgXS37gYexEOTJt/wQMBXrsMdxcS0Qlh57Y+o1QtEKzaoctvgtx/nRjtD
         2U5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mwLMUN63hWIUVb0CiGRwvzKuQTdm9tfNxS/or+sLekM=;
        fh=C/HbQoLQziJ3LhCaMDYP6VrIBhvnD+xfIMoYcEBq1Rw=;
        b=cIuxJ17Fj2vSkDa/7TJoAnf0OibKXQu4FBNOYzimtMzORTG35w56JuZehBemwE727B
         BeKtd1iCMDwE+f/bkiyOntDqTD93IQ4v2dkZ//uZgnBMihZQGuIGCmNRfofPFwWLXgzg
         eDY4AqcL/ixkxV1TVrWTA42ynda9Gkr5hJCgnvCPLyVMcQnVvnpoFYhzt6t+wYoGNfMx
         upcTqkQrLHJ0leJHdM1YwXXBy+6qLoMjuPiXMSveyKUozwwXo46Q6OEY95UvcrCnGIWX
         oTOFD2pGEAEwnMelqKDO0Vk75ZiM19tELltESB5i+5ukSvZf5G/sD0u+9xifPa39ydXc
         IPAw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786356130; x=1786960930; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mwLMUN63hWIUVb0CiGRwvzKuQTdm9tfNxS/or+sLekM=;
        b=Ywk+x6tboprOwhk39Rvfef29FubBj148eeBJ09TTVnz6glezwih5c6RJ5Lx/ydVstF
         m4o91+/KIxwwu7Yv2mX0Y1Z4rWIlKNAzrA42U2ppX7Jv3GSez+/Mr5ZZdxu0RsbxzCTa
         49kWvp5KhMcZe2gRQtAIu0vJ8Q8B7rF2S+wONqR6UuXs16pVqDPyqLvi46yfh6VQIyC8
         QGl4ivszsFR0JGNIPKIXBqK7CsqsPrG81+VMFEdAcbitiHZsfIXEq6VFOkmRHbaNxvo3
         rW9+v5wiSqMy6LUwsDjlsHwVa4EdqVyMUyzAID5waTlq2cm0rNdQePtjIlBEIi2x9s4Q
         I9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786356130; x=1786960930;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mwLMUN63hWIUVb0CiGRwvzKuQTdm9tfNxS/or+sLekM=;
        b=D3jnmNOb1FCiW7S+Jn/hyxvmix+Fe5hpUFDdURksfN739kq1ud58lwyRSgpA8NX6gX
         tFE6NXb0fe3qFZwDLqp4RoVwKe/9L0uX2DCZegRzKaE/d72kd/0/aZZMv9vB0Y99nfNy
         GO2BQF53Uqx/ZYHmsc1oGZ7o5elFAW8PAhs9SLLyOt7IXSpQnP/SInnh4/WSWwfWImRw
         28YCTd2UlUz+szfJU5gH8e0eZ7bVqSAwXSEQLugM+wHJ7lCleE2iwxvgWFcSASL/WZPR
         bpVR31WrQrzceK4TFmczrw3yKqxDQeQaOjZ4PHONmH41RbPgNtGVwTq4KHa1QJxe/xJg
         QVLw==
X-Forwarded-Encrypted: i=1; AHgh+Rrx/WaFlRCdcAkecUWMDPx2OF4cOejIcDNmGQFXz+wv0CzXc8TJHzCH6dbpkR7/Pzkx+6B/Qso=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmAbWUS00EI12UkghTy9cNO9kRqu2iN258CXqQakLBCiAXepNk
	Dp0ImxYM3c/tqicxoNiu38m8QQsVEHL+kf5i3qbHo2YjFgNwEjKAMtEqSZYHTJD4Qg/bAXJE7BJ
	35DBpsIwbj0frFMuUDCi+ef+ebPGviKGu3q24U9Ew
X-Gm-Gg: AR+sD11dpGkGDtw/3l34gTbYRK+z+O77Gu7pUjUTacndJyFCub0XtKye2/FX/7dsj8n
	LIxn698FJSyCbGtLeYOYfC8leBpbnsPqOeeqqERXaogNDliJcowyclqVCjFHhCqrAkKA+R6wQF+
	VQQS+k+DBmeaSRbCZU34ux+6V021XTSAeapOy7P6tRYo9EC2ctgMCW3SV5SDMpOZrzc8gDVDeZU
	Vw8xulakhdsOLy02reLGGEFnB02iqfT9gWVGp0ZBTIuAVAbbEPuSU0ANLAMY7yNK/7yKl7zJHRp
	ueot3iasaqTb328JMrTu+5jjM8w297WP7nJ2uDkn4asnO/TiSw5DA3/aqRurnffeqx7xeecZcqP
	DsiKUxVD9ekXnzjT27nbY8p41qyA5JE628vJtXSxGw00Ulj2fDZY5oa1QuQj14X/JNBnVqvpQJ5
	Arxc4PeYTeEWf9
X-Received: by 2002:a05:6808:182a:b0:4a3:4598:f390 with SMTP id
 5614622812f47-4b1a1011552mr13601164b6e.17.1786356129393; Mon, 10 Aug 2026
 03:02:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <9ec9dff3-f779-4ac6-ab8e-fcedd8a467b0@mail.kernel.org>
In-Reply-To: <9ec9dff3-f779-4ac6-ab8e-fcedd8a467b0@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 10 Aug 2026 12:01:58 +0200
X-Gm-Features: AUfX_mzplJgekMgozx0B2VS9mgPtmFvPqRrmneWQF1C3vm-U-Jsu7GjBNt7qqEM
Message-ID: <CANp29Y67g9oxPXTVPfCowAT2sLq0SCrNMm_BvJGotUHgiN8nxA@mail.gmail.com>
Subject: Re: [PATCH RFC] libceph: replace WARN_ON() with error handling for
 network input
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 8, 2026 at 11:53=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The Ceph messenger v1 and v2 protocol implementations currently use
> WARN_ON() to assert that the server's response adheres to the protocol.
> However, network input from a server can be invalid due to a buggy or
> malicious server. WARN_ON() must not be used for conditions that can
> legitimately happen, such as receiving invalid network data. While WARNIN=
Gs
> are not fatal by default, they pollute the kernel log with stack traces a=
nd
> can lead to kernel panics on systems configured with panic_on_warn.
>
> When the kernel Ceph client connects to a Ceph server, it initiates a
> handshake and reads the server's reply directly from the network socket.
> The reply is then processed in process_connect() (for v1) or other
> processing functions (for v2). If the server sends an unexpected value,
> such as an incorrect connect_seq, the client triggers a WARN_ON(),
> resulting in the following warning:
>
> ------------[ cut here ]------------
> con->v1.connect_seq !=3D le32_to_cpu(con->v1.in_reply.connect_seq)
> WARNING: net/ceph/messenger_v1.c:902 at process_connect
> net/ceph/messenger_v1.c:901 [inline], CPU#1: kworker/1:3/5645
> WARNING: net/ceph/messenger_v1.c:902 at ceph_con_v1_try_read+0x3335/0x6eb=
0
> net/ceph/messenger_v1.c:1366, CPU#1: kworker/1:3/5645
> RIP: 0010:process_connect net/ceph/messenger_v1.c:901 [inline]
> RIP: 0010:ceph_con_v1_try_read+0x3335/0x6eb0 net/ceph/messenger_v1.c:1366
> Call Trace:
>  <TASK>
>  ceph_con_workfn+0x208/0x14a0 net/ceph/messenger.c:1577
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> Fix this by replacing WARN_ON() assertions on network input with graceful
> error handling. If the server sends unexpected data, log a descriptive
> error message using pr_err() instead, set the connection error message, a=
nd
> return an error code to abort the connection. This ensures that invalid
> network input is treated as a protocol violation rather than a kernel bug=
.
> The fix is applied to both messenger v1 (process_connect) and v2
> (process_hello, process_server_ident, process_session_retry, and
> process_session_retry_global).
>
> Fixes: 31b8006e1d79 ("ceph: messenger library")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+21f8628595b2061c438d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D21f8628595b2061c438d
> Link: https://syzkaller.appspot.com/ai_job?id=3D56e865ad-bcea-4dc1-9df8-6=
18a118f27c9
> To: "Alex Markuze" <amarkuze@redhat.com>
> To: <ceph-devel@vger.kernel.org>
> To: "Ilya Dryomov" <idryomov@gmail.com>
> To: "Viacheslav Dubeyko" <slava@dubeyko.com>
> To: "Sage Weil" <sage@newdream.net>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index c9e002d96..df2248b7b 100644
> --- a/net/ceph/messenger_v1.c
> +++ b/net/ceph/messenger_v1.c
> @@ -898,8 +898,15 @@ static int process_connect(struct ceph_connection *c=
on)
>                      con->v1.peer_global_seq,
>                      le32_to_cpu(con->v1.in_reply.connect_seq),
>                      con->v1.connect_seq);
> -               WARN_ON(con->v1.connect_seq !=3D
> -                       le32_to_cpu(con->v1.in_reply.connect_seq));
> +               if (con->v1.connect_seq !=3D le32_to_cpu(con->v1.in_reply=
.connect_seq)) {
> +                       pr_err("%s%lld %s connect_seq mismatch, expected =
%u, got %u\n",
> +                              ENTITY_NAME(con->peer_name),
> +                              ceph_pr_addr(&con->peer_addr),
> +                              con->v1.connect_seq,
> +                              le32_to_cpu(con->v1.in_reply.connect_seq))=
;
> +                       con->error_msg =3D "connect_seq mismatch";
> +                       return -1;
> +               }
>
>                 if (con->v1.in_reply.flags & CEPH_MSG_CONNECT_LOSSY)
>                         ceph_con_flag_set(con, CEPH_CON_F_LOSSYTX);
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index 05f6eea29..966a5f800 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -2237,9 +2237,16 @@ static int process_hello(struct ceph_connection *c=
on, void *p, void *end)
>                      __func__, con, ceph_pr_addr(my_addr));
>         }
>
> -       WARN_ON(ceph_addr_is_blank(my_addr) || ceph_addr_port(my_addr));
> -       WARN_ON(my_addr->type !=3D CEPH_ENTITY_ADDR_TYPE_ANY);
> -       WARN_ON(!my_addr->nonce);
> +       if (ceph_addr_is_blank(my_addr) || ceph_addr_port(my_addr) ||
> +           my_addr->type !=3D CEPH_ENTITY_ADDR_TYPE_ANY ||
> +           !my_addr->nonce) {

Don't we actually want to leave my_addr validation as it was - it's
not coming from the remote device?

> +               pr_err("%s%lld %s bad my_addr %s\n",
> +                      ENTITY_NAME(con->peer_name),
> +                      ceph_pr_addr(&con->peer_addr),
> +                      ceph_pr_addr(my_addr));
> +               con->error_msg =3D "bad my_addr";
> +               return -EINVAL;
> +       }
>
>         /* no reset_out_kvecs() as our hello may still be pending */
>         ret =3D prepare_auth_request(con);
> @@ -2529,14 +2536,33 @@ static int process_server_ident(struct ceph_conne=
ction *con,
>         con->peer_name.num =3D cpu_to_le64(global_id);
>         con->v2.peer_global_seq =3D global_seq;
>         con->peer_features =3D features;
> -       WARN_ON(required_features & ~client->supported_features);
> +       if (required_features & ~client->supported_features) {
> +               pr_err("%s%lld %s missing required protocol features, my =
supported 0x%llx, server's required 0x%llx\n",
> +                      ENTITY_NAME(con->peer_name),
> +                      ceph_pr_addr(&con->peer_addr),
> +                      client->supported_features, required_features);
> +               con->error_msg =3D "missing required protocol features";
> +               return -EINVAL;
> +       }
>         con->v2.server_cookie =3D cookie;
>
>         if (flags & CEPH_MSG_CONNECT_LOSSY) {
>                 ceph_con_flag_set(con, CEPH_CON_F_LOSSYTX);
> -               WARN_ON(con->v2.server_cookie);
> +               if (con->v2.server_cookie) {
> +                       pr_err("%s%lld %s server_cookie is set for lossy =
connection\n",
> +                              ENTITY_NAME(con->peer_name),
> +                              ceph_pr_addr(&con->peer_addr));
> +                       con->error_msg =3D "server_cookie is set for loss=
y connection";
> +                       return -EINVAL;
> +               }
>         } else {
> -               WARN_ON(!con->v2.server_cookie);
> +               if (!con->v2.server_cookie) {
> +                       pr_err("%s%lld %s server_cookie is not set for lo=
ssless connection\n",
> +                              ENTITY_NAME(con->peer_name),
> +                              ceph_pr_addr(&con->peer_addr));
> +                       con->error_msg =3D "server_cookie is not set for =
lossless connection";
> +                       return -EINVAL;
> +               }
>         }
>
>         clear_in_sign_kvecs(con);
> @@ -2618,7 +2644,14 @@ static int process_session_retry(struct ceph_conne=
ction *con,
>         ceph_decode_64_safe(&p, end, connect_seq, bad);
>
>         dout("%s con %p connect_seq %llu\n", __func__, con, connect_seq);
> -       WARN_ON(connect_seq <=3D con->v2.connect_seq);
> +       if (connect_seq <=3D con->v2.connect_seq) {
> +               pr_err("%s%lld %s connect_seq mismatch, expected > %llu, =
got %llu\n",
> +                      ENTITY_NAME(con->peer_name),
> +                      ceph_pr_addr(&con->peer_addr),
> +                      con->v2.connect_seq, connect_seq);
> +               con->error_msg =3D "connect_seq mismatch";
> +               return -EINVAL;
> +       }
>         con->v2.connect_seq =3D connect_seq + 1;
>
>         free_conn_bufs(con);
> @@ -2651,7 +2684,14 @@ static int process_session_retry_global(struct cep=
h_connection *con,
>         ceph_decode_64_safe(&p, end, global_seq, bad);
>
>         dout("%s con %p global_seq %llu\n", __func__, con, global_seq);
> -       WARN_ON(global_seq <=3D con->v2.global_seq);
> +       if (global_seq <=3D con->v2.global_seq) {
> +               pr_err("%s%lld %s global_seq mismatch, expected > %llu, g=
ot %llu\n",
> +                      ENTITY_NAME(con->peer_name),
> +                      ceph_pr_addr(&con->peer_addr),
> +                      con->v2.global_seq, global_seq);
> +               con->error_msg =3D "global_seq mismatch";
> +               return -EINVAL;
> +       }
>         con->v2.global_seq =3D ceph_get_global_seq(con->msgr, global_seq)=
;
>
>         free_conn_bufs(con);
>
>
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68
> --
