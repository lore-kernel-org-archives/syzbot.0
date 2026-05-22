Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE32A3A1A5B;
	Fri, 22 May 2026 13:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779455993; cv=none; b=JND06S0+rqzWsH95tRasx0z3BfLQMNA5fUIlii6ZwF4nrOAPkHWjK5Q+0JrhsL60xLnnHIFr8ettZZBNPAcz75IoSzBGyVvjTX56oyBrjwXsNMkMGRZ1nB41nWQudi/r+0Eg+9nh8PNZe4Tmf3SxegCjbvlLnzsV6h/LeU+RZX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779455993; c=relaxed/simple;
	bh=67Nw31SHx5f3pBj4MpklV3IIJP9hLe1nVmml2RZqyIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWi/CSHnGCX4r/q+eOvJ9QUIVpJSNmXZeEE5UOZ498D8CNpRwurXHd/IjQmcwgKH7AsnLMDrWcGAvOFqPJB/vd0wm1B473XS8SYnHhZIeW9PqZTSSv8qsSKDHCqf5MjK6ZID6QtBaxea3bZhE5R9GLfdFB805CvqwEU9q+b235I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wl0mVc8N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wl0mVc8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9DB1F000E9;
	Fri, 22 May 2026 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779455992;
	bh=S7RoafszWP7asezUtxwq8wQdAcqcEhh8i70al/jw0kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wl0mVc8N+duyZp2xL5rH02hz4YZChNbNjnsRJwoPRxwl13odA3rJ1x7YjxGwkIV98
	 jAsjGGv1lSw0TD3knfVer9Zi8zVG0am1SBxGBu5f2ZyE1ZRL2QVjV7WrTT9ddcl1dL
	 3k+qwnbJSq6UNg1ssv4vj8f42m2R6P71QKNfQeQ0IP7EK7iLfAyZ7gYVAG/XX4jZG9
	 s+uqIIGTfWfpUH/QGszD3uE772OEcjA8dm2LGTFaGMoZh08xVzJMFwseTP4Z+pwC/a
	 dlIeStHg6bW9IQPXXm5/CmfleWchJ95/WZX6mDNvk16yuI3RH1DHa/KTvTdoIEC2KU
	 HN04mf0Gqy0CQ==
From: Christian Brauner <brauner@kernel.org>
To: syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org,
	Aleksandr Nogikh <nogikh@google.com>
Cc: Christian Brauner <brauner@kernel.org>,
	adrianhuang0701@gmail.com,
	akpm@linux-foundation.org,
	kexinsun@smail.nju.edu.cn,
	oleg@redhat.com,
	peterz@infradead.org,
	syzbot@lists.linux.dev,
	tglx@kernel.org,
	dvyukov@google.com,
	syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
Date: Fri, 22 May 2026 15:19:46 +0200
Message-ID: <20260522-enthoben-planquadrat-tanzabend-5072faf6ae6b@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521142240.2973022-1-nogikh@google.com>
References: <20260521142240.2973022-1-nogikh@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1433; i=brauner@kernel.org; h=from:subject:message-id; bh=67Nw31SHx5f3pBj4MpklV3IIJP9hLe1nVmml2RZqyIY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQJhH+aG93LdyTy8qtmlSO3jxgGvZi0eAKL92m/HKUHd W/nnZiT0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRp/GMDN3C1rNitvw6UBNS kKGjUXKh53rSrq/+jQ1xMx7N2ahrxcPwTyE5WFvQID84xNMzP/BsUMy0pScVJ4qb9krseadm6sn GBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 21 May 2026 16:22:40 +0200, Aleksandr Nogikh wrote:
> When a multi-threaded process receives a stop signal (e.g., SIGSTOP),
> do_signal_stop() sets JOBCTL_STOP_PENDING and JOBCTL_STOP_CONSUME on all
> threads and sets signal->group_stop_count to the number of threads. If
> one of the threads concurrently calls execve(), de_thread() invokes
> zap_other_threads() to kill all other threads. zap_other_threads()
> aborts the pending group stop by resetting signal->group_stop_count to 0
> and clears the JOBCTL_PENDING_MASK for all other threads. However, it
> fails to clear the job control flags for the calling thread.
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
      https://git.kernel.org/vfs/vfs/c/90918794a4e2
