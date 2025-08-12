Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4262F238142
	for <syzbot@lists.linux.dev>; Tue, 12 Aug 2025 07:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984806; cv=none; b=ghlyWlFr9PzGBq0wvMyvb5+0/lWr8mRJHWYnat0Zj6N+jXRjP+oWPfN7C126iFyHQ50ev/w8NxBIKZ1qXo9Elud6O/c/E/yAFT2YpUUG7HJKt3QPOvsNuFo98ibivFKKjfyRjlk4uqqwbPHNr5Q3QoYY8k2qTvKJLYDJeFQy3cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984806; c=relaxed/simple;
	bh=7veAhauFbzmeZ6VPaXhAIl+1EidQymqZFBkfOM5A+nY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=i5TJBN7kChs+T/kgEMeOpj+HJ0QKvHc/EhFKCiDjYarWvgvr+XZpIzCHAObeoyY8EcwdkTkMUkFt1Fsvs9V1B2wzfhYEpFHEhr2TnvwO47JWSsiXRkB+Puk0jXN6PW5aBHvckLoAjT6n39Ir/dR7PuDEf0uohsaOuHUWTjqD1X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8817ecc1b33so1197148039f.2
        for <syzbot@lists.linux.dev>; Tue, 12 Aug 2025 00:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754984803; x=1755589603;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Umk1YoadKdpa6fyzaimwqq35auuAfEV1rwGDtpJveWA=;
        b=hbewgWHkpCiCW13Xq973JXf3IBdkg6+1jpvRqAIZ5ENhnE8reCwVNM8H/sdPuMQirD
         m6Jnm+YnUZfvkVx0dGsiOG1fiRGE5IQwU9t7/1BGaFVz59TpQYoPECjJVskCEUWKOVXN
         b/Ijm4PoixEitpDyknkL8HFstT+7zL6S6KuUdD5EoNW4mXm84r08iJ7vdmEfgytgpbWF
         e1HF3jWMpkEHgToFlyTntGEU0JL8K4fPqlIBYJ4a/LfIv0T89bCfgRG4v9ZLsagMNosO
         aq69TBNz9iSPrM9eVesANtnF24UA+6PgguCAsqd9eExyQcJP+/JEE/2BokgntjyOkA/3
         KdBA==
X-Gm-Message-State: AOJu0Yw0tMcgyrI3V6SJuhGFdE9MC8meYJNkD1/pLIsnr0o4PbBhJHD8
	zrek8ww5FJzRwBA5IonXNrJKKjdGk8N9Ob4iAjahlBE1gciQut/PgV+qDuoYKVMAOwK/pxWyto+
	qe0A0kkH5wCvIS88od+4gXFZyaeJj7bLGvwjCgsXeTvBaln1RRdYmoWW2v8s=
X-Google-Smtp-Source: AGHT+IGMO5NHQ7t/8SdMDmkMxxHOO+f+f98qggqnhfBOuHrFo4tBxoy7lI5+nUzI68F7dY4bFrEZVQmeL1OqGTmyoq+dADo+nkMr
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:7187:b0:881:9412:c917 with SMTP id
 ca18e2360f4ac-8841bcc009bmr501638939f.0.1754984803514; Tue, 12 Aug 2025
 00:46:43 -0700 (PDT)
Date: Tue, 12 Aug 2025 00:46:43 -0700
In-Reply-To: <20250811173116.2829786-1-kuniyu@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689af163.050a0220.7f033.0112.GAE@google.com>
Subject: [syzbot ci] Re: net-memcg: Decouple controlled memcg from sk->sk_prot->memory_allocated.
From: syzbot ci <syzbot+cic0c8bc3087cfc855@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, almasrymina@google.com, cgroups@vger.kernel.org, 
	davem@davemloft.net, edumazet@google.com, geliang@kernel.org, 
	hannes@cmpxchg.org, horms@kernel.org, kuba@kernel.org, kuni1840@gmail.com, 
	kuniyu@google.com, linux-mm@kvack.org, martineau@kernel.org, 
	matttbe@kernel.org, mhocko@kernel.org, mkoutny@suse.com, 
	mptcp@lists.linux.dev, muchun.song@linux.dev, ncardwell@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, tj@kernel.org, willemb@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] net-memcg: Decouple controlled memcg from sk->sk_prot->memory_allocated.
https://lore.kernel.org/all/20250811173116.2829786-1-kuniyu@google.com
* [PATCH v2 net-next 01/12] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
* [PATCH v2 net-next 02/12] mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
* [PATCH v2 net-next 03/12] tcp: Simplify error path in inet_csk_accept().
* [PATCH v2 net-next 04/12] net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
* [PATCH v2 net-next 05/12] net: Clean up __sk_mem_raise_allocated().
* [PATCH v2 net-next 06/12] net-memcg: Introduce mem_cgroup_from_sk().
* [PATCH v2 net-next 07/12] net-memcg: Introduce mem_cgroup_sk_enabled().
* [PATCH v2 net-next 08/12] net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
* [PATCH v2 net-next 09/12] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
* [PATCH v2 net-next 10/12] net: Define sk_memcg under CONFIG_MEMCG.
* [PATCH v2 net-next 11/12] net-memcg: Store MEMCG_SOCK_ISOLATED in sk->sk_memcg.
* [PATCH v2 net-next 12/12] net-memcg: Decouple controlled memcg from global protocol memory accounting.

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/6fc666d9-cfec-413c-a98c-75c91ad6c07d

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      37816488247ddddbc3de113c78c83572274b1e2e
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/a5d5d856-2809-4eee-87ca-2cd1630214ae/config

net/tls/tls_device.c:374:8: error: call to undeclared function 'sk_should_enter_memory_pressure'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
