Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5977301021
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 22:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762468646; cv=none; b=B/RGEaz2qM6qae51nujJXLBt7fRywWJ5AbrYXRfoabVkV8854Ym09j8seq90F7yw4eANkkDh5Gs2nn+eP9rsNBMKqOd5Pyhgtyr1uikZni7Ne16q2riI8xpACH+IADrtVOE/x720EueIhKX2PVkqnwATtsdDn9cUeheyYZdKJzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762468646; c=relaxed/simple;
	bh=Zq1qKA7EZccEUyWoFMZOaVBIr6IqNptziO3p9QoDC3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WumU5W1Ioe+tjPaQ6UGCEnKUnB5dEDCwU74yxXA2zX9LJfJo0p7sYcju/ze9eltI4M6hISBZRattgVbvMjF4KGcodjSO513Iv0nFXETzVdCnAq8skyzUwINkvnrBpyVxAokeSKGuQiOxUpl4iKkeHzBqdK2PRRaq5QDBSA+m+EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h/UWZrqV; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h/UWZrqV"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2953e415b27so1114485ad.2
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 14:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762468644; x=1763073444; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wqh/7rFu75Tw9K3uiwtNgsD2r+BPLCM0k5HVbPy8hps=;
        b=h/UWZrqV/xo4jj6qa8ALVl5h7dTj9zT809UPXWfiZlqVSLiFheIBQwho9v0GZm5d2C
         A6jzcV1ShNULSX9DAqWMruHMvrFsDAeP3vUJWTq1hRkvkyDZSUMCQGq2xZmlDLU5RqW0
         6EttvZcx4NdGf0l0kjp3hSegSXWAn8vUW3GNM3GEic+lLbmnqMDenJT0sLF9cwesSPXr
         9SmrwArVnWSXWEoWocDZxFmZZztl25Ha6W334fos3IXRyYxy3mE4PLcD/nVqODtxjv7T
         ysRwiwOqon6QfN2S4Dv4YIEiRE80DQDeoJlIPF4ihlIxSrmC5EhKIEVzGoDxTzKDs97h
         s4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762468644; x=1763073444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wqh/7rFu75Tw9K3uiwtNgsD2r+BPLCM0k5HVbPy8hps=;
        b=WW2hqtBMasbeAEwoTVHR/TVGL4rZFpK2AOZcCYbUwO/xfVfqC0FapbcMMWR2ftsI1a
         U40+Kjb50hiFyRbK3v6W0YmoaWaqLhfz6o2bFhcfpnV16K0x+rdqo1KVR0gHtXXc8nWN
         0YV1BDLj0wuO3zEgisftf95jK6rrjXAmaXgEsWu95b/Q+4bXO6hGQGp6A4n+1ksgPtLp
         yPEMvR5OSrnNpkoLwurvMX4dLeqGGUcXzP6/0qVJe6Qa87MyCOeL61WxHWJu1bcDqj4N
         JHdUaGszQEBnW9Rx76YlCyKALmLFKg78RNT1OBAbditI679vMvs/B3GJFI++BVOBpiME
         QlGA==
X-Forwarded-Encrypted: i=1; AJvYcCVhbrWQ+A4KtWKYH8zJSe9aXgmfn/Qqxy1/vMUthoi+NY6qSeWa+8ZRQeE8HgwJTgocp+GK/s8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwQZedjyCxeAgWmaBLBB70wr3byoF9wwns2eUum9RzCwPmBwsZ7
	Ecef+I22Qgb5GgzvBFq9E9mMIHvFJDaW1NJqR6usAL1zsitWCz+N73S8rnZdX6wtiEKjM9pmqI4
	uVcGESH3GFou25vEYoc3Mvqmg4P8yQSKoRVI9MKYt
X-Gm-Gg: ASbGncv7LpamNxKg3CPLSoxy4xhfD8mFVR74jz9JbXyTDKzxvTnKAa8Sp8WYdb7xTa4
	ChGH5id2TRbIlrWAWWvouRG0bz+Cjf+Hdpj1icdpW/ytjZK6ZDuv+As1JrQOZ3+CWcES3nyzRW5
	mnwyW6Y9LOAwkafzFlY+x0hWG9GDP/n15S/gPoqPIcqTkjxrOhFzGlrznMzGtStelMb5crZKj1o
	TLrVFRNx7JWYaIKgq8MaJ6tENrXq4QaKZf7iU4BdU/+B9ivJzXaZmRCsr7KSVEYYe+L6/KHjgmb
	pQ4w4MqUpvRSHOV+Dg==
X-Google-Smtp-Source: AGHT+IFmTgBghJ4Z63fdzU76btJu2WQ9IXUf7TvnuoUNE4+PNenxcDLQl4UARxupttHUWsPvt3LaA2/eg6SDP3jnrxo=
X-Received: by 2002:a17:902:da48:b0:27d:6f49:febc with SMTP id
 d9443c01a7336-297c038c617mr14658455ad.1.1762468644160; Thu, 06 Nov 2025
 14:37:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <690c6ca9.050a0220.1e8caa.00d2.GAE@google.com> <20251106175926.686885-1-kuniyu@google.com>
 <20251106143004.55f4f3fc@kernel.org>
In-Reply-To: <20251106143004.55f4f3fc@kernel.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Thu, 6 Nov 2025 14:37:10 -0800
X-Gm-Features: AWmQ_bksc9oUawq3yqH36NtmDo0ccenJFt0JFKuoavuRugfDXyvaxpAeV7_fcSs
Message-ID: <CAAVpQUBkFxS6Dm28n7uDoO+x63npwZWb925+Gs3UHz-gAZo7yQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: tipc: Fix use-after-free in tipc_mon_reinit_self().
To: Jakub Kicinski <kuba@kernel.org>
Cc: syzbot+cif2d6d318f7e85f0b@syzkaller.appspotmail.com, davem@davemloft.net, 
	edumazet@google.com, hoang.h.le@dektech.com.au, horms@kernel.org, 
	jmaloy@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 2:30=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Thu,  6 Nov 2025 17:59:17 +0000 Kuniyuki Iwashima wrote:
> > -void tipc_mon_reinit_self(struct net *net)
> > +void tipc_mon_reinit_self(struct net *net, bool rtnl_held)
> >  {
> >       struct tipc_monitor *mon;
> >       int bearer_id;
> >
> > -     rtnl_lock();
> > +     if (!rtnl_held)
> > +             rtnl_lock();
>
> I haven't looked closely but for the record conditional locking
> is generally considered to be poor code design. Extract the body
> into a __tipc_mon_reinit_self() helper and call that when lock
> is already held? And:
>
> void tipc_mon_reinit_self(struct net *net)
> {
>         rtnl_lock();
>         __tipc_mon_reinit_self(net);
>         rtnl_unlock();
> }

That's much cleaner, I'll use this.

Thanks, Jakub!
