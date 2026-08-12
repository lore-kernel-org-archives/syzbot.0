Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FA23515E9
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 12:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786538077; cv=none; b=BjXQfeO61eXiMfMXaCd+L1d/560hiuFa0I5kkdy/0enwNPP6ykF8UlEqEcdyipWOLxxzD6apqWjSXlr+/OJTiUKOCKMM0rJTM8t72SD7bLMy+1VRCc3w87gcY0kpdoNO3GBpzcZ2gigrIlOZ+r8LYaHVLP0O4bmJErA3LEs9Ipc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786538077; c=relaxed/simple;
	bh=m+iu8iM5DXt2gHzjnxiOgn2Dj1KucJ73saFbSVx/12U=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=LLrhTqXZ+NfP9stosuUgrXnK0YZ3toA0imMBlCzYbSVOAmbDOKj4CFA1r6IBOcUDev/yxQx25muUaFjguYGV7eq7LOs2xtaDK4zbPEgl1/4i2OezgT+y93dxcSi/la8tKEnKx3Z+NLiDlIBtKmOhstgpUgDMgt4RKxkjBExBcAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b1bd347d5fso537241b6e.3
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 05:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786538075; x=1787142875;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=biLbNyuEIj7jQqSzTr+j9iATbyzAoDLyAG+sd1tby+4=;
        b=SOwvFkI3Zxq0ZnqL1vXvTDP8S8nrJRhXS/5tbArZ7e9YgUFKuUGCkk6CL4Ht7tjY4J
         4PdVX9cM2aJRXLl8jXQPoiQR4pnvT2HdjOrK68H06e1DtK4qcggOU2sB17rp0EPCd1E3
         zZKwJDb4h0boGmx50oZf+gbwTe/ZpsLvsXF4Lc6Rv3VwwDc87emRUqOnPTQ3eNNDxk8R
         wZcJz+lcs95vqgyyy5VAoBKOD1gKJrUGxVT3fvOquMyxMKk52vDdLg3vWCLrqdi7u44U
         8i9t+qbekCtDrIMPcO2WUs73ou7QN3epTRaqc+S8ewSIGqdlFjBtQvIQ42OBgjWg3m0N
         HACg==
X-Forwarded-Encrypted: i=1; AHgh+RprGWuFKg2oBpT1AFT73Ndz1H5eH+GD1pFrD+jUZidizJooyvhr4LI1+5YJHDe8YQpmPMLijDs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTh7GmWxpUHxSaD4HGf409nO9PyZKt7mBC/yqXXWlsahG7Tfsz
	70Rrvrszs4DUXzhBZ8aEoqq8DOKc/WyqLKsGGvoYksE/BOFVKHjz88S7DcsaahmbxpSwSbTj/qL
	UmOFcFCSqHkGh4t1me6NEwPZs1jTLrIfZIlMnSQ4NidlzqMz9Auw8PNbCU9k=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1998:b0:495:e92e:d797 with SMTP id
 5614622812f47-4b210b20e2dmr4574550b6e.11.1786538075158; Wed, 12 Aug 2026
 05:34:35 -0700 (PDT)
Date: Wed, 12 Aug 2026 05:34:35 -0700
In-Reply-To: <6a7c67e1.a2bb2777.31c27d.0014.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7c685b.c5ad36c8.12f49d.0027.GAE@google.com>
Subject: Re: Forwarded: Re: [syzbot ci] Re: net/smc: fix clcsock and lgr/lnk
 races in smc_diag dump path
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: syzbot@syzkaller.appspotmail.com
Cc: mjambigi@linux.ibm.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

> For archival purposes, forwarding an incoming command email to
> syzbot@lists.linux.dev.
>
> ***
>
> Subject: Re: [syzbot ci] Re: net/smc: fix clcsock and lgr/lnk races in smc_diag dump path
> Author: mjambigi@linux.ibm.com
>
> #syz test:

syzbot-ci does not support `#syz test` with arguments.

> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
> v4: Move hash(sk) to the end of smc_sk_init() so the socket is published
> only after it is fully constructed.
>
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 00403175b740..5e7560417ec7 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -409,13 +409,13 @@ void smc_sk_init(struct net *net, struct sock *sk,
> int protocol)
>  				      "sk_lock-AF_SMC", &smc_key);
>  	spin_lock_init(&smc->accept_q_lock);
>  	spin_lock_init(&smc->conn.send_lock);
> -	sk->sk_prot->hash(sk);
>  	mutex_init(&smc->clcsock_release_lock);
>  	smc_init_saved_callbacks(smc);
>  	smc->limit_smc_hs = net->smc.limit_smc_hs;
>  	smc->use_fallback = false; /* assume rdma capability first */
>  	smc->fallback_rsn = 0;
>  	smc_close_init(smc);
> +	sk->sk_prot->hash(sk);
>  }
>
>  static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
