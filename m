Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D580C3E1696
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 10:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492639; cv=pass; b=RZlYdrvSgbcJNxPES7t2tDYidKScKm2r0G/hjKiHMpB1fM1mZZZtreh8/nfP0sVKtDe64/pJ9klUWAt3tjkosYsgdVdsn/mopxTGdmCJ4gIONDUOZZ+Q3WwqGLn3u+FPfzS/EbvoPf1VhMHYsqWsEovD2dPO085jjlzrG1QxcoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492639; c=relaxed/simple;
	bh=IbJwhBZmwMfBI422w5j+Sf1rz3qf9xg5Y7LrN3aiaD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a/CXoQjZC3Y2hdJyz/zAewwCG5hNh74HI3Zti4k42EfkMKMcR8QX2dtqJVaZIwIzQW0UYB2tOAJh7Gj083qEnJfi6BUNs8fPEaiQt6xJIR9aenOK2D2GMDd8xGl8rbWVGIsW/xSRdtO3dqhAhaLCsRIzwk0c0ZfV5YefdemVe2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sXOpBL9s; arc=pass smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sXOpBL9s"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-497deab2d66so576351b6e.0
        for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 03:10:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785492619; cv=none;
        d=google.com; s=arc-20260327;
        b=kMzAyGI7ojt8FkfIsr1I9BcNLlnMJTHxVpnN0oLFPQLQKW1tbX1jB+amJzozEaLato
         tU2zLtLVfhM3j+CzFcPhFKrrrwIswKQQcmyOji7FqcRr/DoHXmopnhyvVha8HsEvYIyX
         yOJyo+ZhqDIVgQM+CB3db0a2PtY5dCyNAwoKJPRbeb9LFU0rCltZ3gbNbpwP+fyALzzf
         8PxlcqOaWlPPnJ4whgYgdkVeduibyDqqpMzdY04QWwW1pvRNfNSICgM/lJEUfXw2ODsK
         zplS3U4mCIJc6hLCryKjL2V5nM8dr54d7HD27UVuYb42mi4zTfUi9sScKx6ltqm5w5zb
         bjfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QidHawpFrn7oagZ6gRmz2sTd6ybC7NSR1hzrfPHkUGw=;
        fh=h9lLtRBEY5+ClF3RtLTsYYJXaLQrb/fbBOn7WKZQWVg=;
        b=c0BJ8DQMqogg7B1R56+rMwlxEQtXDViCa0flzM4ezM4/Ko48WUG8XbNIGJc1OaMiv1
         +JDz/eE7soI01hTU/iLn0RW7pEsf7qfGW2Gb80TQr3Srxy+9gQxR+y6PzVU0A6QQlvLq
         Rvq9LLyd6nF6rg9cD0TkZDygK8nOJtgv5RZ/s19ukfonUmxFcFZT3RcRA/Pa7SqkFESe
         m/0cYt46NMvBxUsa6pyRXMlEhdl9TfQTUSYAp1mXPB1O+6kUO2pX8AUaFiyDXi6627qD
         36PEl5N644gJI1TMoWR9W5/B3d8cIBEDoGTPCSXmlPTsUiorGTWmPVOyup84ErrSpDu2
         gGqA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785492619; x=1786097419; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QidHawpFrn7oagZ6gRmz2sTd6ybC7NSR1hzrfPHkUGw=;
        b=sXOpBL9siEHJT5wyvcq0AL2u0PGUMyLVErxdW5Qdva3HO9s5SyzowYaGiMqhwrcNia
         hS/JXOin6zAPu4op/B33Bd33aw1gTrIc8SuCzdxk+kEatxeED4lf4bSSkwJHlUbp1LBC
         dC8JgwwHszsjT+xTRWbOob0RGRQ2uQy2W69Q2CMlkWLKCJgZCfGgekTwUP2awUNCnCj/
         pcyRlua6US1ZHSVqgLZGkNFm8cH4D484mpr+zh/zEvGcZCkJq6lS8n/UCoPjZVhsJDPB
         uAjGKdUSaZH0zKtdGzS+wdeCHxsjvKLGDZcTIFRNtozzKbF5dbdlKehbLl4WIyQBoLwZ
         aSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785492619; x=1786097419;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QidHawpFrn7oagZ6gRmz2sTd6ybC7NSR1hzrfPHkUGw=;
        b=OBPr+MToTJvhLkts+meI2wWgaO8u+mTPcWv1e3rWF7wOoq87QHfJgn8DbJKlv+IIUd
         UH2vvymyn7UwBkgw5tLAe08DBf8JpbRzg5WUnSv8UE7He+LRHRKNsPX2LTvVqUIAZeAH
         F58+j00K3wm+G0RuXdoJIY8+yVz/547nWxpm3d7g8ofKz6ckhlKJLBLvHdX+vqee/NX9
         S/AnAzhiSSTRzoPA7Uhf9N+Cajmd0I78c+HB1sVrQbP8Mio1m2FFoB7SIL1yHMB3ORKR
         0VfLtDY2aOQWtgDSs4yD50iBSgAefI0ApsDLQUrp7pjeYa6z2SfdsNOGqfOHriclebAE
         J3CA==
X-Forwarded-Encrypted: i=1; AHgh+RrfcLlM1QWDDYOQ2SxKa9SvCC4cwFDy2PmEPKhdtICVQOvYXxcWBFUknI6XGX6Z3kw7IkcRgl8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7H64GoJK3ABQXkfLdIlUXg11zNh5Jr9C5Op0voEqxd35hlH1+
	kM4G0PRm1zC8s4bo8dKJVnRpQ5wWfkkmJYga94X1Npmo8v4iHyWNf1qcIFacv8Hd/Zf7NZ1Zhwz
	omozuS8Q311a1Tj6KXTyoKeKx/uLr+JnPc1zLF5/Z
X-Gm-Gg: AR+sD13qs38oGRYtIDr/dqQ4falblRaXqU3KSu2ugv0I5RglG0F283lDT0Mo8lCiiu4
	dFAEBxwIujGPOzcLHc3O8tyR0FJ/7GTC1QX0LUgsShE1akQxx226NbYpuYrYQ9cgNz1bd5ZSvK1
	WemhRf3SvBiOPvuz6vJx8jXVAkhG9hjiQjkq5Z5dcu6X2WqRfwhL2vdlogAIpbznf+hsvnt0/xp
	CYxbrIOnlQH2DEjzQXi1YEpuESBoL5TpxIAiD6fM7GggZZT0UerhJVue7cwQXUUQLogg9Ze0yLa
	mdAPLKm1kpsDiFaEZL5pKhlwt6J2LTjtrIZc6ZigGlkr3LEt0675NmBDoCugX12yW4gXYAyCYR1
	eu+kx4VF5nI8oSHb5+9ltwXgvnSHzGXIy6NxmzDDQRogQa9OE+dgmZepGLpxj3KtJsVt5G1BDd6
	6ncz6YpnbRkQvlFa6KgKVvLKE=
X-Received: by 2002:a05:6808:309d:b0:496:1111:d7a8 with SMTP id
 5614622812f47-4ae318d4659mr1728414b6e.8.1785492618758; Fri, 31 Jul 2026
 03:10:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <10fa68ab-b588-4ca1-8ac1-dd13a95cff91@mail.kernel.org>
In-Reply-To: <10fa68ab-b588-4ca1-8ac1-dd13a95cff91@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 31 Jul 2026 12:10:07 +0200
X-Gm-Features: AUfX_myOzkvUAwKGbYNyWT-cknoQuAmu18Exdj5b377BE3D0uC-nSmQABYcQ_mQ
Message-ID: <CANp29Y6oPs4vTeE-pw+5EybTeK5UewTkLLbXT4EwO8gP__9SgQ@mail.gmail.com>
Subject: Re: [PATCH RFC] libceph: validate banner payload length
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jul 31, 2026 at 11:52=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When parsing the Ceph messenger v2 protocol banner, the `payload_len` fie=
ld
> is decoded from the banner prefix. If a client sends a banner with a
> `payload_len` of 0, the kernel sets up a 0-length socket read. This
> violates an invariant in the state machine, triggering a warning in
> `populate_in_iter()`:
>
> ------------[ cut here ]------------
> !iov_iter_count(&con->v2.in_iter)
> WARNING: net/ceph/messenger_v2.c:3129 at populate_in_iter
> net/ceph/messenger_v2.c:3129 [inline], CPU#1: kworker/1:3/5070
> WARNING: net/ceph/messenger_v2.c:3129 at ceph_con_v2_try_read+0x6634/0x68=
10
> net/ceph/messenger_v2.c:3159, CPU#1: kworker/1:3/5070
> ...
> Call Trace:
>  <TASK>
>  ceph_con_workfn+0x1f5/0x14a0 net/ceph/messenger.c:1575
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> According to the msgr2 protocol specification, the banner payload is
> expected to contain at least two 64-bit integers (`server_feat` and
> `server_req_feat`). Therefore, `payload_len` must be at least 16 bytes.
>
> Fix this by adding a check in `process_banner_prefix()` to reject a
> `payload_len` smaller than 16 bytes. This prevents the 0-length read and
> correctly aborts the connection with a protocol error.
>
> Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc and =
secure modes)")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+87c7c2d63c44e41c77a3@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D87c7c2d63c44e41c77a3
> Link: https://syzkaller.appspot.com/ai_job?id=3Dc8ca3d63-717a-4933-89ec-f=
3d761b8690d
> To: "Alex Markuze" <amarkuze@redhat.com>
> To: <ceph-devel@vger.kernel.org>
> To: "Ilya Dryomov" <idryomov@gmail.com>
> To: "Viacheslav Dubeyko" <slava@dubeyko.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index 05f6eea29..b323b61e7 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -2142,6 +2142,11 @@ static int process_banner_prefix(struct ceph_conne=
ction *con)
>         payload_len =3D ceph_decode_16(&p);
>         dout("%s con %p payload_len %d\n", __func__, con, payload_len);
>
> +       if (payload_len < sizeof(u64) + sizeof(u64)) {
> +               con->error_msg =3D "protocol error, bad banner payload le=
n";
> +               return -EINVAL;
> +       }
> +
>         return prepare_read_banner_payload(con, payload_len);
>  }
>
>
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/10fa68ab-b588-4ca1-8ac1-dd13a95cff91%40mail.kernel.org=
.
