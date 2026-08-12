Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E2D3090C2
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 12:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786537956; cv=none; b=JlqADjOObITLQZEHEIG5QXH18hzunNbF+Mw5j+G4yEW4u+yziDbpMXBwEsDOkNrB9hLU3TIuM5QKHu0oQodo+P/WrqU1UpIfN/VA0lTRArKW02R/OP8CCXTWJXE+CLOCHB1IZCL3ajWc0heNUuSeOlM9ooiK8l5niZlB+uf1MJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786537956; c=relaxed/simple;
	bh=05MHW+RuUyfdiyM3q97XQPXPl4XlhON8gb/aYk7Tf+I=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=s0t9SZzitr0FQURRfSdwzUIc24IOSoYiqJqvEsHoeRgk2RFLgFDGHLzRJKSrpgC1bXvqPdvbig7P2G/H1b4/licLVtBMM9wdNc9cTQcfIicJQKp04ZtDnyforJx5BRLzTT/1g8jLmFWUSM+m/bfEJcSPGFcWKBXgEGz903JRhzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4959c49e054so599793b6e.3
        for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 05:32:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786537954; x=1787142754;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4CK77C8fMTre4qY+kDnHPxlCFTbMt/T8UpUDR5ZG5Ws=;
        b=seim9r3xy7W3qv6tn49bZB7yPxoKjoZ3S54zTbjy+jgMY4AvRREwjR+DL59ttQfB7/
         Zc9dSL2Bdr6wJDCKDMPE76MoakscTNa1d0grEWInbhk4KVa3fBDsMWD8hGslCH86tQSf
         BDYghS5/lFau2YKE8LIlaSBzwi4fcYgkePFseZn0ojekY194jojJvUGViz+YEwdbiP41
         yrBHxXEIaLL2oWu0tYMkgJuQW6Ul8CcV/IAyvrn03GllkaNXfkTtYBQ50858AcF+pLoj
         bWz6BwvDuPiG0mbzMRhvykYIYdfiftv5VjEayGVS1RWpcdUlv2Iclc1yulr4Zo+L4PnF
         LzRw==
X-Gm-Message-State: AOJu0Yw5b1/lxVGjTYiSJLovPFROctIaZS8vsZVErjb2pbsH0bIJuzPR
	6FT9nMHYAAgP2mIE6GpWfHu/ki3javYHqhAvPpOZadpqsQxiqgx7HJK7660mVF0IlgljRoCJMBd
	y1sQsjWARDl1khGyI4vAHEbju8tYmpd5bgrALReTIoqYGkng2vW73p0whtuM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:17a2:b0:4ab:2764:1911 with SMTP id
 5614622812f47-4b210c23d78mr4114041b6e.19.1786537953767; Wed, 12 Aug 2026
 05:32:33 -0700 (PDT)
Date: Wed, 12 Aug 2026 05:32:33 -0700
In-Reply-To: <3fed64ca-e62e-448f-ba4c-7cd1f0543899@linux.ibm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7c67e1.a2bb2777.31c27d.0014.GAE@google.com>
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

#syz test:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

v4: Move hash(sk) to the end of smc_sk_init() so the socket is published
only after it is fully constructed.

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 00403175b740..5e7560417ec7 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -409,13 +409,13 @@ void smc_sk_init(struct net *net, struct sock *sk,
int protocol)
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
