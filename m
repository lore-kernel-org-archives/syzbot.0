Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2727379E1;
	Thu,  7 Aug 2025 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754580421; cv=none; b=XvKmaaDcUVSMBvyyzPaGFZyDaAgwqpRufHdo08Bd76i35G0pb6WHRtZCTo8kMtNxN/lx/PLgPyqPZqV73LeLlvSgamM2cW4TutZecUP/ItD6FKXsyXbsFXTGhkM/NK44JoSskodbxeGAEWHXvosq6VqVNBT4W6bmiCn4Sc2i+l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754580421; c=relaxed/simple;
	bh=DKtBAt1he1GWqidXOcvcFrkHmeHlrduKhcDb4KsYqUM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fl5aYAG1CEAWEI+xuwr0kYlsnx1aC08w5Rjobxolf10yQLVhkvx+WaYrTtFUwyXu18MTGv6UopgEZ7rc0znQ40ojb5ZsJN9poTMIB1/AGu0UF6dCHyZlMMJQ7f4h9RWv0y5TzGAz+SOCE6JezKqiFrjSP0naV1dRbiWiob7uvgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGQQ+xCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGQQ+xCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63763C4CEEB;
	Thu,  7 Aug 2025 15:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754580420;
	bh=DKtBAt1he1GWqidXOcvcFrkHmeHlrduKhcDb4KsYqUM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AGQQ+xCFD6bRp6RgDSbTLx07O7SHFvVP2RBvVy0pDUmjcd6sHT2OYh2trUoSZV8kx
	 VBaSkFd19A0hxzXfefzajUQjMlCsE2loeji1Nv9rgwTDYKYVt95LtQdU4Mc3vTZ7Ir
	 iW+74tvYInVMa9ebubbo3RMTJPV1+066P+iANb1NM7xNOgYB0sndrWhfsdjSU/8tPl
	 bKwXiHdICGZurh2GxCPPZAQj7fcg63paks2BmIRPuVx0V6hY78gB2AJDHwX1upFlXV
	 8Gpve0YsUdoIdf5+g9Mu7XzsHasZ80OkSOLMR+v17j450i+LlOoTn/G+b25lUhT1W/
	 O0orEl9RAPRTA==
Date: Thu, 7 Aug 2025 08:26:59 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: dvyukov@google.com, linux-kernel-mentees@lists.linux.dev,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: Revert tx queue length on partial failure
 in dev_qdisc_change_tx_queue_len()
Message-ID: <20250807082659.5557e42b@kernel.org>
In-Reply-To: <CANp29Y5mZJJgn5LYDiLx11bH__NXZ32ut6VUTsEyXwqrOhksTw@mail.gmail.com>
References: <20250722100743.38914e9a@kernel.org>
	<20250723162547.1395048-1-nogikh@google.com>
	<20250723094720.3e41b6ed@kernel.org>
	<20250807064116.6aa8e14f@kernel.org>
	<CANp29Y5mZJJgn5LYDiLx11bH__NXZ32ut6VUTsEyXwqrOhksTw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 7 Aug 2025 17:09:24 +0200 Aleksandr Nogikh wrote:
> > One more thing, would it be possible to add / correct the DKIM on these
> > messages? Looks like when our bots load the syzbot ci emails from lore
> > the DKIM verification fails. I see a X-Google-DKIM-Signature: header,
> > but no real DKIM-Signature:  
> 
> Thanks for letting us know!
> Do these bots also face DKIM verification issues with regular syzbot
> emails? We send them absolutely the same way, so the problem must
> affect all reports.

I haven't checked, TBH, we don't have any automation for normal
reports :( For the CI reports I was trying to hook them up to
some actions, kick the patch out of our test branch unless human
confirms that the report is a false positive.

> We use the GAE Mail API, and its documentation[1] says that it signs
> emails with DKIM only if a custom domain is configured. Since we send
> from the default GAE domain, this would explain the verification
> failures.
> 
> We'll explore the ways to fix this.
> 
> [1] https://cloud.google.com/appengine/docs/standard/services/mail?tab=go#authentication_with_domainkeys_identified_mail_dkim
