Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB54733291F
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 12:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786538289; cv=none; b=gT2CoqK8e01QYQHNNLWHMHllBudB/jeYwQkH10bu6AF/+2gNKfCG/l3h6t0qpZ2fWwM3sn0HlmsMyrhRXLDOEPu0JxHvpYFVomCPj+QWsINcUMICwp0bIOI1SPcG2jqnxr6JgOKybT0oetkR2oe6ag+wFRJOkukUsLumsz8doS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786538289; c=relaxed/simple;
	bh=hDUmZ0+SU/XnwrB9bmGVSrNy+dxnmQrE2zu5s/wyJZE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XhZXF1YYos5Bb3CrFHZ45lDk1kA1ty8RBDV3ju5DMw0LkHwygGc02CRX9iRGQNSolzbb+7dDOtjY6D8l/YKpxJyUML9tyd6PbON/GKd2liO3vf66TpHgzjF94SbBNz7eqO+MZOof2x4FoLrlUW2Lo7l1hXvPx+WUanYKsrnOiMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6a196857c7aso954507eaf.2
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 05:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786538287; x=1787143087;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1BedrlwT+aKK3XSzqfFGG8qYrSa3Lpzt7OgPbP3IDIQ=;
        b=fSwKxEIgr1FrcugTIlav2EeWebVrPl4S2p8LKm9KXevgWXjjeePaYSVs+kQZYADp+i
         h996I8TrZMB+uh2+gTzbIJEwRZi5AW8uMxlKhxFlFm5j9wJXs528yTqy0avWsb13qpH4
         x1hziLaNli5x9YU3/w+k4tqkMr0RpKhURd4ScBf4H7qgsGEmC7Bm3Dja7bgj3Nd7PveO
         t//xSeL3W3VM13oe6M6dU4TH7RKJRnSkcCZrQ7JLnmDBsRDRolv2qjrykFsBj39sg5GK
         r+swthn8coehZTKnv+6t2p4bXhtnh0vOSBS3WcCzBhP/Ha1vo/1cq3D0H8LMuJvpegnS
         M5dA==
X-Gm-Message-State: AOJu0YzVz9AV5W1e/NP+PfFwicaYvo6yZD1182Rx5MscwLO9qfJsJJqE
	TZFSnUIOvnI77E3LaaBbfJ8+aJFID0Gp742OTqzevWJBDPLYZyQYe2BIwvm5YmVNGRFxUZevhon
	1jeLnvrqSFAkg2DvsHhunuJrefZ7d6cHkQ4MTnSt8SyLL6jPpG/mloFfOFBs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1a0e:b0:6aa:8fb6:b951 with SMTP id
 006d021491bc7-6b0b2677a1amr3598831eaf.19.1786538286810; Wed, 12 Aug 2026
 05:38:06 -0700 (PDT)
Date: Wed, 12 Aug 2026 05:38:06 -0700
In-Reply-To: <df7a4fe7-d9be-4a5d-942b-5ca3c1fb1031@linux.ibm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7c692e.d5f0ebe7.22d851.000c.GAE@google.com>
Subject: Forwarded: Re: [syzbot ci] Re: net/smc: fix clcsock and lgr/lnk races
 in smc_diag dump path
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+cia7ddf4f17dfab266@syzkaller.appspotmail.com>, 
	mjambigi@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: Re: [syzbot ci] Re: net/smc: fix clcsock and lgr/lnk races in smc_diag dump path
Author: mjambigi@linux.ibm.com

#syz test

v4: Move hash(sk) to the end of smc_sk_init() so the socket is published only after it is fully constructed.

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 00403175b740..5e7560417ec7 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -409,13 +409,13 @@ void smc_sk_init(struct net *net, struct sock *sk, int protocol)
 				      "sk_lock-AF_SMC", &smc_key);
 	spin_lock_init(&smc->accept_q_lock);
 	spin_lock_init(&smc->conn.send_lock);
-	sk->sk_prot->hash(sk);
 	mutex_init(&smc->clcsock_release_lock);
 	smc_init_saved_callbacks(smc);
 	smc->limit_smc_hs = net->smc.limit_smc_hs;
 	smc->use_fallback = false; /* assume rdma capability first */
 	smc->fallback_rsn = 0;
 	smc_close_init(smc);
+	sk->sk_prot->hash(sk);
 }

 static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
