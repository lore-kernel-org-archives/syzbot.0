Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029DB33B964;
	Thu,  6 Nov 2025 22:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762468207; cv=none; b=KNf2ctDMsPH/g8sFNQzCiQiBRD97nac0SQPPZIzuNJqjM/mDZXVeijeit8y+u0UEd/Js/bDjauwaHN0ScRclT1Vh4IfTmCE+2wDGskir4WqFKRcLUDtM7c8fcLXgX+pY2a2dh8oMcUjC+WrXsxiUOA37d73H015QcL9HDDAF9Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762468207; c=relaxed/simple;
	bh=grgz70MrxjYE02neZOSjO46NidNyWXWXQVXB6qderrs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M4UVjmWAGkYaLxeJlT3xzs7bitiI4EpVQ7HwzpbstzwlikvTvZXSIzCV1r34vbgchiadI4oFDmpJ5Yc4XYwz52cQKwBDz9NzbMJeB+lRa9/Opqu9C1aa7rWidQ8QDP9b+e/LQMCXbfQgN46eBu5RU94aQ95b2MiebXZudJC7kbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pQfZOH8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pQfZOH8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22BCC4CEF7;
	Thu,  6 Nov 2025 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762468206;
	bh=grgz70MrxjYE02neZOSjO46NidNyWXWXQVXB6qderrs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pQfZOH8SEKQzmLDrtfnPo4yrX1IVp11TCu4VuBCWVDSTHw/Lmp8YY8wkXIR1eS2jg
	 OzetIqGFm4L52hQwGUYeYsI49ip/oJzu2Qy1ASidZ8VeW/AX0z2u8zI/9nTzbfkCiM
	 M3JJ5w+vMVMrTaCS4kDDWss9Off+mPxeMiogfAA0FgyK/1P860ah0itvE7lLdvkIwt
	 iSjdIVgRnVonGTsT0+l11h+D9y4xnPhmXo2lKNkGlCedOwDsqp080aZoBdmSZGU23K
	 c1FCltUiYDkAucmICAP89L/oLg1mKEQ+TDnxl/KIDF8JeZ7QMLIBgWO59fzoPKAoqi
	 S0H8kSCO76sDA==
Date: Thu, 6 Nov 2025 14:30:04 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: syzbot+cif2d6d318f7e85f0b@syzkaller.appspotmail.com,
 davem@davemloft.net, edumazet@google.com, hoang.h.le@dektech.com.au,
 horms@kernel.org, jmaloy@redhat.com, kuni1840@gmail.com,
 netdev@vger.kernel.org, pabeni@redhat.com, syzbot@lists.linux.dev,
 syzbot@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com,
 tipc-discussion@lists.sourceforge.net
Subject: Re: [syzbot ci] Re: tipc: Fix use-after-free in
 tipc_mon_reinit_self().
Message-ID: <20251106143004.55f4f3fc@kernel.org>
In-Reply-To: <20251106175926.686885-1-kuniyu@google.com>
References: <690c6ca9.050a0220.1e8caa.00d2.GAE@google.com>
	<20251106175926.686885-1-kuniyu@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  6 Nov 2025 17:59:17 +0000 Kuniyuki Iwashima wrote:
> -void tipc_mon_reinit_self(struct net *net)
> +void tipc_mon_reinit_self(struct net *net, bool rtnl_held)
>  {
>  	struct tipc_monitor *mon;
>  	int bearer_id;
>  
> -	rtnl_lock();
> +	if (!rtnl_held)
> +		rtnl_lock();

I haven't looked closely but for the record conditional locking 
is generally considered to be poor code design. Extract the body
into a __tipc_mon_reinit_self() helper and call that when lock 
is already held? And:

void tipc_mon_reinit_self(struct net *net)
{
	rtnl_lock();
	__tipc_mon_reinit_self(net);
	rtnl_unlock();
}
