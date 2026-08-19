Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A8F3CB578
	for <syzbot@lists.linux.dev>; Wed, 19 Aug 2026 06:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787122669; cv=pass; b=UV0LsN1hvR4Gihxo8Imje7ZNovIT019e/m+baphge9RPiQOQ6+oSRGULYp9PkDwWO1G9D9s0dmisLM6oz8fi0V4SqvhhLrA91W9ZlFQe8TUIVdr5X13qZb1i9G1YcIAric0STvei/xRmzsYwxiFSpb5Me/m8IxL2o7yUL0FBhRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787122669; c=relaxed/simple;
	bh=6Uy8GDL+h1NwxE+PbwdVLusUZBd7C7Dj0NFsNcGeXCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QE/UILdXHyVNK3iY62yumDnEDQG18QW3xke/a6HXTEQos15jQvsuX0af+ZpuU6EvkWR8KQPmdxeioSxMcne8LR51AvZsm3E0OqU5ucUEwcKUUy4DaYgW3dGEPInk+v3Rhar1D44s3OM8FdCN/HSXRwj7zUEodvURtyVLXIJ9UwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=c22iH4t/; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="c22iH4t/"
Received: by smtp.kernel.org (Postfix)
	id F2AF31F00A3D; Wed, 19 Aug 2026 06:57:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.63
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1787122666;
	b=KNTqpFRL0K2rPqcdp4P4DvqYMwF5vjIS59aDe6WLTbGzVjmnUK8+YRNBGciIxLJeYbqb
	 K0/GRbWmk68ZPw6EySJLWi3Py1IcdnnKd/V2DgfqBPDWF0oMUJaqFD+ZbP+u7i2LBIoCF
	 P/AyRJ7bw84mwPDF+oNM+IOyrKsQNjkZTXUJMgvC2/KyodtzAACuXEE2Zbmvp2Obz3Cvs
	 6JABRYs82w9JV3NF+Zw5FOhUmL9WuImT4h1Bd0ikrhLHL8NFDx7aQpj4VdDCy6dLOyscM
	 OdCPuySX9XhFZm/3un3EJQ+RjyFnfjAZ/wSFOXcuT+NT29Pg0nAP/KIYjjiqg3cqjUA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1787122666;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=FviUvuGAtT6z54sGM67pXWsnEGf1UaBg58FU3jC4D/s=;
	b=GkqS5hM0bnqMYC1bRwQB+yH7Nf3G4oKK70jRUXSl65W++Vit3XPwt7ymNdFTAWV5JJUE
	 wmz1VgTQmS4Zn4eZIK13QEvaZhak9HfkYnI1KdW4g+VnilzWbCrQ7lsMuw9UOIms6tHCF
	 XfaYiHIVo527bZ4yPr5qJI4CXTN+C31ECV82NrkDZueADHGDcpD4oK8ZpTy8Zx5gqBV/t
	 /TmCtzs5ZV348CIYtpz8jsRHCgk6E42B6W1gCE4RhVwaY/6dE4GIj3ElWcyTWBlP1Vt+B
	 k+XP8yOBeGf/ASVSZIOhc0ZU1wlYoX/MjRvWh+u06W5DFu3m+F2PcNj2YcfW8JJ4HFg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b="c22iH4t/";
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.63
Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BA8721F00A3A
	for <syzbot@kernel.org>; Wed, 19 Aug 2026 06:57:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=c22iH4t/
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org BA8721F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Wed, 19 Aug 2026 08:57:35 +0200 (CEST)
Date: Wed, 19 Aug 2026 08:57:33 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] nfsd: prevent hung task in
 nfsd_nl_listener_set_doit()
Message-ID: <aoVT3Y9EwlEgPnj3@nr200>
References: <851cf46d-c7e4-470a-8319-36811d8b1da3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <851cf46d-c7e4-470a-8319-36811d8b1da3@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1787122657; bh=FviUvuGAtT6z54sGM67pXWsnEGf1UaBg58FU3jC4D/s=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=c22iH4t/jdWY6vCxLP/vXLS8+/W+bF7p47haP1neFQ3XeLSdF9KEpr/6DWJDU3qya
	 tsSCt8ukOabCY8Yk+KoahQBOcsVYYOBglhXf3RIX4X11VuZTyw+PLZgXjZkj4yVT7t
	 PBVNI2pR2MUJE/1KOABz4TdOS1CRNfl+2lD0Wylg=

On sie 07, 2026 13:35, 'syzbot' via syzkaller-upstream-moderation wrote:
> In nfsd_nl_listener_set_doit(), the kernel iterates over all
> NFSD_A_SERVER_SOCK_ADDR attributes provided in a netlink message to
> configure NFS server listeners. There is currently no limit on the number
> of attributes a user can send.
> 
> For each attribute, svc_xprt_create_from_sa() is called, which may
> synchronously invoke request_module() to load the corresponding transport
> module. If a user provides a large number of invalid transport names,
> request_module() is called sequentially for each, taking a massive amount
> of time. Since this entire process occurs while holding the global
> nfsd_mutex, it blocks other tasks attempting to acquire the mutex and
> triggers a hung task timeout:
> 
>   INFO: task blocked for more than 10 seconds.
>   ...
>   Call Trace:
>    <TASK>
>    __schedule+0x17e7/0x5630 kernel/sched/core.c:7234
>    schedule+0x164/0x2b0 kernel/sched/core.c:7326
>    schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
>    __mutex_lock_common kernel/locking/mutex.c:726 [inline]
>    __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
>    nfsd_nl_version_get_doit+0x17c/0xd20 fs/nfsd/nfsctl.c:1889
>    genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
>    genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>    genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>   ...
>   2 locks held by task/5864:
>    #0: ffffffff90114168 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40
>    net/netlink/genetlink.c:1217
>    #1: ffffffff8eeb1a60 (nfsd_mutex){+.+.}-{4:4}, at:
>    nfsd_nl_listener_set_doit+0x135/0x1750 fs/nfsd/nfsctl.c:1964
> 
> Furthermore, the function does not break out of the loop if
> svc_xprt_create_from_sa() fails, and it suffers from an O(N^2) complexity
> issue because svc_find_listener() iterates over the serv->sv_permsocks list
> for each attribute.
> 
> Address this by introducing a hard limit of 128 NFSD_A_SERVER_SOCK_ADDR
> attributes per netlink message. The limit is enforced before acquiring the
> nfsd_mutex to prevent lock contention. Additionally, modify the loop to
> break immediately if listener creation fails, avoiding needless sequential
> request_module() calls for invalid configurations.
> 
> Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+41bc60511c2884783c27@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=41bc60511c2884783c27
> Link: https://syzkaller.appspot.com/ai_job?id=e7446d8c-5a41-495a-8af7-9f0d7feddff1
> To: "Chuck Lever" <cel@kernel.org>
> To: "Jeff Layton" <jlayton@kernel.org>
> To: <linux-nfs@vger.kernel.org>
> To: "Lorenzo Bianconi" <lorenzo@kernel.org>
> Cc: "Dai Ngo" <Dai.Ngo@oracle.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "NeilBrown" <neil@brown.name>
> Cc: "Olga Kornievskaia" <okorniev@redhat.com>
> Cc: "Tom Talpey" <tom@talpey.com>
> 
> ---
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index fa92e31d1..9c1cc02fc 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -1960,6 +1960,13 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
>  	struct nfsd_net *nn;
>  	bool delete = false;
>  	int err, rem;
> +	int count = 0;

The count can't be negative, so maybe use some unsigned type here?

> +
> +	nlmsg_for_each_attr_type(attr, NFSD_A_SERVER_SOCK_ADDR, info->nlhdr,
> +				 GENL_HDRLEN, rem) {
> +		if (++count > 128)

Can you make some nicely named #define with this 128 value?

> +			return -EINVAL;
> +	}
>  
>  	mutex_lock(&nfsd_mutex);
>  
> @@ -2073,8 +2080,10 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
>  		ret = svc_xprt_create_from_sa(serv, xcl_name, net, sa, 0,
>  					      current_cred());
>  		/* always save the latest error */
> -		if (ret < 0)
> +		if (ret < 0) {
>  			err = ret;
> +			break;
> +		}
>  	}
>  
>  	if (!serv->sv_nrthreads && list_empty(&nn->nfsd_serv->sv_permsocks))
> 
> 
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68

-- 
Slawomir Stepien
