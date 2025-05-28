Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B93D1DE8AD
	for <syzbot@lists.linux.dev>; Wed, 28 May 2025 20:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748464992; cv=none; b=XPjrxf18oyLYaLnsbuBSHAxdFBeZ+anl0vqTgBw5mqu55iGc/jjHPVVV3xbQaZIqhHnjQG1ZeEBIrkitriIcjUDIsxCnOqEI6vFG/uMQFe0EUk667JQPINgMSbjgyavDwTSsWq2vnJLnf+9xmQNgVZScPVgEsdNpqO0qDW+fGZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748464992; c=relaxed/simple;
	bh=WJmt7O2BcfA1xO1fpxCYC9fYo/AX85JbpyGDQeiuX08=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Im+WLYNbm9Rq8U2XT6j/bCQLJV7Kst1Zoqu/0UMSV+nCrzkaK9fQb4SeTPtNo/tJMyCRmeESPn+A49PQXxXU4ldaYKWCzbHEWxBCHFFnxILwppoCMuW1vDPNBxMzWL77AiD+/7Ch6Ye7GwUYXODA9WPi4JgHyUA6myz3jTXXM2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykKXSj5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykKXSj5E"
Received: by smtp.kernel.org (Postfix)
	id 6C039C4CEED; Wed, 28 May 2025 20:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C57C4CEE3;
	Wed, 28 May 2025 20:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748464992;
	bh=WJmt7O2BcfA1xO1fpxCYC9fYo/AX85JbpyGDQeiuX08=;
	h=Date:From:To:Subject:From;
	b=ykKXSj5E5qThgZhourLn62IweHTVSAkCAJH8Lp84PEQ1UkOludQJIc5feaAMUaiOM
	 bRorwuE9YA1s98opanza3O6ISm2hjYvecMlZK6+2CVzR3iDM1r9kU84HA6tTcJUjHf
	 y6FgcwIP+Zm5reElu0mPtXJMowRdYRj+Bf48dzi8=
Date: Wed, 28 May 2025 16:43:11 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: syzbot@kernel.org
Subject: Test another alias to syzbot
Message-ID: <20250528-lush-thistle-gecko-181880@lemur>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Another delivery test.

-K
