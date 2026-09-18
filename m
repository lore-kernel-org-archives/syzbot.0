Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AB439B956
	for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 14:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789742075; cv=none; b=sJq1KzDkYgSdAJ1CpR+NYXz4Pe3HXPdpghTtp1m3vah0hzQugYi+v4idxRYGiWu0fzw5PUrbF2nbV+HUQe0C142Q9mQ+3z3EeIC+QugmYTo1il/KSLFClAi72+FnjnMda3pPEYJ+Ju3rjlsj0xnVklwu/vgzIh68Mf+B9AiY4is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789742075; c=relaxed/simple;
	bh=6YT/83ylDltfzmW5h654WAW/ZBvtBchfgyG/KnCzXHg=;
	h=To:Subject:In-Reply-To:Message-Id:Date:From; b=LqdXki6PrHODGZAUFXxCOM+LSQIZQ5YJV0x3XdrhYTetFPjm8vWJLK+Wo+KxhQCrByZLfd4x3qXcWRtdgaBvPrrAHjGPQmrnpFOuIJ6KA8znHRl/CAEjZrHqlmSWJjEoLZqn0Jc3XW0QV7qe/ddUXu+/+mP/JoJ+2DV98K/6uhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix)
	id B24141F00898; Fri, 18 Sep 2026 14:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1E01F000FF
	for <syzbot@kernel.org>; Fri, 18 Sep 2026 14:34:33 +0000 (UTC)
Received: by mailmammoth.local.home (Postfix, from userid 5657)
	id 70F08202E6; Fri, 18 Sep 2026 10:34:32 -0400 (EDT)
To: syzbot <syzbot@kernel.org>
Subject: Out of office ([PATCH] ring-buffer: Fix false warning in ring_buffer_map_get_reader())
In-Reply-To: <15bc282f-669e-4a94-911d-bb435513461f@mail.kernel.org>
Message-Id: <20260918143432.70F08202E6@mailmammoth.local.home>
Date: Fri, 18 Sep 2026 10:34:32 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>


I'm off on my own Odyssey traveling on a perilous journey close
to the Mediterranean Sea with my fellow computer developers.
I will not only be battling the elements but also mythical AI
bugs and dealing with hecklers in my talks. I'll be coming home
to Ithaca, NY on October 10th. Until then, your email will be
at the mercy of the INBOX God! Even when I get back home, I
will be dealing with the aftermath of thousands of emails trying
to win my bidding. Good luck and don't let the Trojans in.

-- Steve



