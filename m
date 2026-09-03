Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688D4A2042
	for <syzbot@lists.linux.dev>; Thu,  3 Sep 2026 13:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788441970; cv=pass; b=GGCIg0tyPQZAzL9FhkrSIf8N9hf8veYXCvdDwNHlkWFS/nLvWr43sqzzYpd+BWvKuOsQD8CrdDxYUCdxJ8ImF9x7qJ+J9B3xnXHz/Ju92a2XLCqykIs3QZ5QakqkPgzzZGI50Vr5KS3e1XXRi3UtnDH2iefvho3h/QSEkmx9G/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788441970; c=relaxed/simple;
	bh=6PsMyVnioFEj6ri3nKJSn41s0GH1CbNFQdFFnNXSGt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUHmx0DvWzjfueQ5P4yLRqi0mT1q7zcoIoRpf7z2FXA73qGSsXYYDzEy5EFOhILDtM0VL5ShQMHEzm4FkprmhebiVl12xfKLCOHbxBUnF25tOACP9FF802ie/tc41XxP7pizLqSuoMXV/7XlPk/WZvyWFwmohu7UPZ8hQ5vJ3mY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=XmerJ5hn; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="XmerJ5hn"
Received: by smtp.kernel.org (Postfix)
	id 5DF5E1F00A3A; Thu,  3 Sep 2026 13:25:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1788441945;
	b=pbTf33illQyCQy6jCihFzJr33wuadtbDhjXvozSuWxw6AgLmEus2omzKw2Ed2C7Uvh1r
	 Nk+CVXzRU4meNm/efE1SZZbEaeo+J6UkWwcSPjaEfBv3bZxqPHgX38FNqtFlHu1U+Etmp
	 333h7N3J+kIpaFPbK0mJ70amzjMQR18S1c+BB3EUSvHW7wZyPw4eXT89xOffwRNHGoJae
	 kyf/nbiPDkQx6lCDIMYf2ozFKcyzRz/mbJamx/x4kWwQLcKEZHPi5SmnPV1tfqEkBqwzn
	 XrNRv3F/K2lr7rGoUKl2xcz6/abZbACqAdosoUwxnSr2p2uOZUlDVd1UZfDHx+lJNdw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1788441945;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=p/ybH/O7PeIKoRGS9fzVgpTCl6aM2G7neoxilUwZr+A=;
	b=UHjbb8ZCtEJqm/oCofWD/nOsWV6hzaNfxwHs48p4m/U+4b69NuJS0JToJNOUaDk2J3rd
	 yYZqKBquzdcqKJ6PBJlhUdrOl1BkIEbTCmOSYBeDW//I6ccKMjwvTLAjCIPGUF9LEcOSe
	 u7JzYgsh5p3iGvpfsPdizubSzRkrM1xlQkCuNae/m12RnPX4RTd8+qp3n3A96Sq+and7p
	 0z0FU/bUky2TMa9DA2c66PNlC3EIVVewZ3Xu1ywrzUJ/60WffrpIC0M5dq1hw4eJYnnmN
	 AwZ8Aya7qKb0d364pCEyx7N49+vNpja19jVSs8Nh3qUoN2qyRR6ePo/mhdg304sv74w==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=XmerJ5hn;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2B4B21F000E9
	for <syzbot@kernel.org>; Thu,  3 Sep 2026 13:25:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=XmerJ5hn
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 2B4B21F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu,  3 Sep 2026 15:25:33 +0200 (CEST)
Date: Thu, 3 Sep 2026 15:25:31 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] sunrpc: reject socket already in use in svc_addsock()
Message-ID: <apl1S1gOgoQhkG2r@nr200>
References: <1613a189-598e-44de-8e58-e4b40633eda2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613a189-598e-44de-8e58-e4b40633eda2@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1788441934; bh=p/ybH/O7PeIKoRGS9fzVgpTCl6aM2G7neoxilUwZr+A=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=XmerJ5hnZw0S+W+o8eiLPODVJCQdUySpXsL1R2O/2owFAAwU96jXy99gh+838bbOV
	 JTARIz4rhLkSM7cN+yEhI2p7HySR9uWVl038zdmQk2JhNf8zhbEB5xaoOLaiTzvidu
	 FJ+er74tX8/5s9+RkHaH8e7IWvj2UlRJj5KaJwx4=

#syz upstream

On wrz 02, 2026 21:59, 'syzbot' via syzkaller-upstream-moderation wrote:
> When a socket is added to an RPC service via svc_addsock() (for example, by
> writing its file descriptor to /proc/fs/nfsd/portlist), svc_setup_socket()
> saves the original socket callbacks (such as sk_state_change) into struct
> svc_sock and replaces them with RPC-specific callbacks (such as
> svc_tcp_state_change). It also attaches the new svc_sock to
> sk->sk_user_data.
> 
> If the same socket file descriptor is added to an RPC service again,
> svc_addsock() invokes svc_setup_socket() a second time on the same socket.
> During the second setup, svsk->sk_ostate is assigned the socket's current
> sk_state_change callback, which was already replaced with
> svc_tcp_state_change. When a state change event subsequently occurs on the
> socket (for example, when connect() is called), svc_tcp_state_change()
> invokes svsk->sk_ostate, calling itself in an infinite recursion until the
> kernel stack overflows and triggers a stack guard page fault:
> 
> BUG: TASK stack guard page was hit at ffffc900030b7ff8 (stack is
> ffffc900030b8000..ffffc900030c0000)
> Oops: stack guard page: 0000 [#1] SMP KASAN NOPTI
> ...
> Call Trace:
>  <TASK>
>  svc_tcp_state_change+0x76/0x2e0 net/sunrpc/svcsock.c:917
>  svc_tcp_state_change+0x76/0x2e0 net/sunrpc/svcsock.c:917
>  svc_tcp_state_change+0x76/0x2e0 net/sunrpc/svcsock.c:917
>  ...
>  tcp_done_with_error net/ipv4/tcp_input.c:4877 [inline]
>  tcp_reset+0x176/0x380 net/ipv4/tcp_input.c:4909
>  tcp_rcv_synsent_state_process net/ipv4/tcp_input.c:6903 [inline]
>  tcp_rcv_state_process+0x13bc/0x48a0 net/ipv4/tcp_input.c:7197
>  tcp_v4_do_rcv+0xafc/0x1530 net/ipv4/tcp_ipv4.c:1876
>  sk_backlog_rcv include/net/sock.h:1192 [inline]
>  __release_sock+0x25b/0x390 net/core/sock.c:3260
>  release_sock+0x190/0x260 net/core/sock.c:3859
>  inet_wait_for_connect net/ipv4/af_inet.c:616 [inline]
>  __inet_stream_connect+0x863/0xe00 net/ipv4/af_inet.c:710
>  inet_stream_connect+0x66/0xa0 net/ipv4/af_inet.c:755
>  connect_socket net/socket.c:2141 [inline]
>  __sys_connect_file net/socket.c:2166 [inline]
>  __sys_connect+0x316/0x450 net/socket.c:2183
>  ...
>  </TASK>
> 
> Fix this by checking if so->sk->sk_user_data is already set in
> svc_addsock() before proceeding with svc_setup_socket(). If it is already
> non-NULL, return -EBUSY to prevent re-initializing an active socket.
> 
> Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead of open coding")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+c9834a0c0215e6d8697a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c9834a0c0215e6d8697a
> Link: https://syzkaller.appspot.com/ai_job?id=30de91d1-1d14-4676-8c38-a3564f7acf48
> To: "Anna Schumaker" <anna@kernel.org>
> To: "Chuck Lever" <cel@kernel.org>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jeff Layton" <jlayton@kernel.org>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <linux-nfs@vger.kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Trond Myklebust" <trondmy@kernel.org>
> To: "Trond Myklebust" <trond.myklebust@primarydata.com>
> Cc: "Dai Ngo" <Dai.Ngo@oracle.com>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "NeilBrown" <neil@brown.name>
> Cc: "Olga Kornievskaia" <okorniev@redhat.com>
> Cc: "Tom Talpey" <tom@talpey.com>
> 
> ---
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 50e5e7f5b..e8cc4329f 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -1541,6 +1541,9 @@ int svc_addsock(struct svc_serv *serv, struct net *net, const int fd,
>  	err = -EISCONN;
>  	if (so->state > SS_UNCONNECTED)
>  		goto out;
> +	err = -EBUSY;
> +	if (so->sk->sk_user_data)
> +		goto out;
>  	err = -ENOENT;
>  	if (!try_module_get(THIS_MODULE))
>  		goto out;
> 
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935

-- 
Slawomir Stepien
