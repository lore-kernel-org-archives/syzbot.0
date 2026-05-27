Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637C350A10
	for <syzbot@lists.linux.dev>; Wed, 27 May 2026 20:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779913240; cv=none; b=p+1JMsVnevJNHFJ86ZGaJeGPCC0f4qFyLUP9As3t4tHaTNaTxRPJvaTyfq9kW9CZHlzKluU1bnPccqiitGXoJ37SbhiiNFLx0xlA9DCXlhAAqQsQ4ZBd9GFGleY9//ewmGIoCEscVWg5CScl38Sc3hPpZRf0KyjTmWRgOhdsDwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779913240; c=relaxed/simple;
	bh=Lz2Wk+9A+sgEW8C+KqJarswd/Pwh0Uc7JssVUpYsyJ4=;
	h=Content-Type:MIME-Version:Subject:From:To:Cc:In-Reply-To:
	 References:Message-Id:Date; b=PGOON885g2ZTcm0fIowsonwzo07U+mwLGBlHBw2OjQ7ziPkxdmYjQh/22QYqqS5v5CpDuhh302y8t5yDYPpqYr5OtZVX1mikLCPSG2b7icZub7jh7t+0nTbcYkaIwU45nrwm0qJheUUJHBhiBag4rH9aEKeNX9VX3dWWEi18UII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chatmhzJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chatmhzJ"
Received: by smtp.kernel.org (Postfix)
	id A29601F00A3D; Wed, 27 May 2026 20:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E5C1F000E9;
	Wed, 27 May 2026 20:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779913238;
	bh=MAi4fWZAa3fkgj3C6W/XoKSk0GCapnQpCMAt3Vb+n9A=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=chatmhzJm0rWmAnUaNICSsmVdgNOJccIEpmoTzOlfQn3hT5LC4fQF+0ifge19PASh
	 IhuAkdsbh7/m6Y9vQfk5NKnwCbTgNDDkQEwzHXgbigKjZiVfTX0gH82Zn6kJT9VXyR
	 m0X5d4Qg+h/Lr2t4Z2g3LeT7xkZeJnr0FNNjQvI8OnraF4toCwu5E5BWnpczlG+d3H
	 Y2S0fGr0x5xP69V4ojFtu0zf4mYo/99OhOew5tQgr++j6t0m8AzOdqOsgcAkG6f54c
	 WZ8Q0Tjf55xWtQKi2IuxYQAnj+2v9H/2+hvw1b8zOsZubTpEoy/SWAfdlsZPgYnfLf
	 RtwVQKmdm9KfQ==
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ieee802154: fix kernel-infoleak in dgram_recvmsg()
From: netdev-bot@kernel.org
To: syzbot <syzbot@kernel.org>
Cc: kuba@kernel.org
In-Reply-To: <62795fd9-fc0c-48eb-bb82-05ffc5a57104@mail.kernel.org>
References: <62795fd9-fc0c-48eb-bb82-05ffc5a57104@mail.kernel.org>
Message-Id: <20260527202038.74E5C1F000E9@smtp.kernel.org>
Date: Wed, 27 May 2026 20:20:38 +0000 (UTC)

Welcome to the netdev mailing list!

We noticed this may be one of your first submissions to netdev
(at least with this email address).

See https://www.kernel.org/doc/html/next/process/ for kernel
process guidelines, and most importantly:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
for netdev-specific guidelines.

Here are a few ground rules which are frequently broken by newcomers:

 - You must wait at least 24 hours before posting a new version to give
   reviewers time to respond. This is a hard rule, no matter what your
   reason to repost is.

 - Each new version of your series should be a fresh / separate thread
   Add a https://lore.kernel.org/.. link to the previous version to
   the cover letter or changelog, instead of threading the submissions.

 - Until you gain experience submit one of two patches at a time,
   do not send multiple changes at once until some of your changes
   were accepted. This avoids reviewers having to provide the same
   feedback on multiple patches.

 - Avoid changing the subject of the changes or cover letter unless
   necessary, it breaks our patch tracking.

 - If you're submitting changes for issues discovered using automated
   tools - commit message should explain the discovery and testing
   process (for drivers explicitly mention that you don't have access
   to the device, it's not a blocker).

Happy hacking!
