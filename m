Received: from mx1.secunet.com (mx1.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5002130EF8F
	for <syzbot@lists.linux.dev>; Mon, 24 Aug 2026 05:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.96.220.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787547700; cv=none; b=oBAJ8IoStuOtizy79hS2Y7s5/5Qn6IRMePZft7rbQAQPODQYejKl7eWcH9Ul66B2bSN1tM2d3lROMxJgEp7Lis4UIdhYMXjLU6HQ+jqZNeZrczT8/npDCcRW4/fcGqLdd5kP+74tSs401fmd8y/tLMeEA1JC2bvHNqO9M0TvGn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787547700; c=relaxed/simple;
	bh=3kOnMbz6YK0oYxPecTpv/ySEXOTdvlddtFfIca4MF00=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5gc4hScqCkvXC96hHjYCNsqbFiRckQckHJ8Vc0Y+aMr38+drzYQZDwtg4HKSDOcVitFLXCnh4FqE0vh2ffJi/2lgoMP/gSrsNOJOgDMO+VfnBZbFTIy86p6hf+vhZ3H9O021HPsrsNxwC6DYH/rXMHnOw6D+4OrqUpbuTh9E7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com; spf=pass smtp.mailfrom=secunet.com; dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b=m13/T8lk; arc=none smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=secunet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=secunet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=secunet.com header.i=@secunet.com header.b="m13/T8lk"
Received: from localhost (localhost [127.0.0.1])
	by mx1.secunet.com (Postfix) with ESMTP id 1F67F2050A;
	Mon, 24 Aug 2026 07:01:36 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from mx1.secunet.com ([127.0.0.1])
 by localhost (mx1.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aeY8I9Fjm2Lj; Mon, 24 Aug 2026 07:01:35 +0200 (CEST)
Received: from EXCH-01.secunet.de (rl1.secunet.de [10.32.0.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.secunet.com (Postfix) with ESMTPS id 4BD202080B;
	Mon, 24 Aug 2026 07:01:35 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.secunet.com 4BD202080B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secunet.com;
	s=202301; t=1787547695;
	bh=27IwY7gvSwjny5QliwoW4ojo/uMZgTiwKd/w3NbsxFU=;
	h=Date:From:To:CC:Subject:References:In-Reply-To:From;
	b=m13/T8lks9tRSp5ZnnlAsb08DtUsK0yXBrp/8xK/1qgR9sDLhk84avueYLPfIaKNX
	 iwW7Y0T+h8r1sU1K07jJFzK5qy4izb28VDGWs7d1wn1+dTy9Y4OCw0blvvSgpMzGdk
	 6ntV+hjYooX7W8Ka6qCE2TThb8LC4pnYEiy50/8QNiO2724MrsVpgHfqmuPO1ADKLa
	 R1+vyRRIHN6TwE3fQNDOpM2YhS1AL0dsX9Z2/avzRpCC2H66VazqsOUSWF6T8eZCym
	 L5wCHJoG34d0z6Qxz8OxvrAU6yOctdENRtCXiKSoyj37lt0wBBs9ZH4ifMcfQJsSm3
	 ugx5sbyKfTZ2Q==
Received: from secunet.com (10.182.7.193) by EXCH-01.secunet.de (10.32.0.171)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Mon, 24 Aug
 2026 07:01:34 +0200
Received: (nullmailer pid 653382 invoked by uid 1000);
	Mon, 24 Aug 2026 05:01:33 -0000
Date: Mon, 24 Aug 2026 07:01:33 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: syzbot <syzbot@kernel.org>
CC: <syzkaller-bugs@googlegroups.com>, Aleksandr Nogikh <nogikh@google.com>,
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Jakub Kicinski <kuba@kernel.org>,
	<netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, Antony Antony
	<antony.antony@secunet.com>, <horms@kernel.org>,
	<linux-kernel@vger.kernel.org>, <syzbot@lists.linux.dev>
Subject: Re: [PATCH] xfrm: add missing RCU read lock in
 xfrm_send_migrate_state()
Message-ID: <aovQLX1EsvRQOjWQ@secunet.com>
References: <2f866679-25c2-4b17-9fa6-086d4c3b593f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2f866679-25c2-4b17-9fa6-086d4c3b593f@mail.kernel.org>
X-ClientProxiedBy: EXCH-03.secunet.de (10.32.0.183) To EXCH-01.secunet.de
 (10.32.0.171)

On Fri, Jul 31, 2026 at 10:06:20AM +0000, syzbot wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> xfrm_nlmsg_multicast() requires the RCU read lock to be held because it
> safely dereferences the net->xfrm.nlsk pointer using rcu_dereference().
> When it is called from xfrm_send_migrate_state(), the RCU read lock is not
> held, which triggers a suspicious RCU usage warning:
> 
> WARNING: suspicious RCU usage
> net/xfrm/xfrm_user.c:1630 suspicious rcu_dereference_check() usage!
> 
> Call Trace:
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  xfrm_nlmsg_multicast+0x1d8/0x1f0 net/xfrm/xfrm_user.c:1630
>  xfrm_send_migrate_state+0x870/0xae0 net/xfrm/xfrm_user.c:3340
>  xfrm_do_migrate_state+0x1749/0x1e90 net/xfrm/xfrm_user.c:3507
>  xfrm_user_rcv_msg+0x7a8/0xf30 net/xfrm/xfrm_user.c:3907
> 
> Fix this by wrapping the xfrm_nlmsg_multicast() call in
> xfrm_send_migrate_state() with rcu_read_lock() and rcu_read_unlock().
> 
> Fixes: a9d155ea9b44 ("xfrm: add XFRM_MSG_MIGRATE_STATE for single SA migration")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+c0e99a1aa85a286d7a3b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c0e99a1aa85a286d7a3b
> Link: https://syzkaller.appspot.com/ai_job?id=8977f559-3a7e-4bb5-b4d6-1196956260b6
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

Applied, thanks a lot!
