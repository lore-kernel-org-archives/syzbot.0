Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308B88F6B
	for <syzbot@lists.linux.dev>; Wed, 28 May 2025 20:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748464688; cv=none; b=O4hj0mflmFwR05IcAbHgOoDa0IjQA4ANWZSIYgPwVbcN/EzF1omWZE6ViPAajQeRRQ3R5CV7ExidbRdkqxusSuTapZSSIj/3NF6Tmur+r4hCmmZyR0EE+3oJdHvRRzqeoHo/XZtjE4/D8ou9D8C+paCGsbCGFIQ4dVOCiw6Fu0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748464688; c=relaxed/simple;
	bh=BXAxBjm7rLD8LmlYyVNi3uhm3nwD4SOdNematLSaw4c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ex4JO3dIB03V5pVLRWKnA+nl3oIM8LeGstN3LtWXtxGz6yUqwTBP9kpMW3ipXhS7USlRpnlO4sgQ4nWQMOCqLjP4iixO8p6bgdz+hnmPLEy/4ZzWP2Y4KFeswjRTbZRfOqd1ySwEEqTeSDB2oVvqKeuBwHO56Jv6QfBYYxrc7Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j31kRFcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j31kRFcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816F6C4CEE3;
	Wed, 28 May 2025 20:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748464687;
	bh=BXAxBjm7rLD8LmlYyVNi3uhm3nwD4SOdNematLSaw4c=;
	h=Date:From:To:Subject:From;
	b=j31kRFcQ11V+SRhhEqB77XZftGFjcpxQ8L9Cru3i0KSuvYaDpyNlKE1GGF3Owrp3/
	 qa9cY6RmAHxcQyCMAvuapmZANUuLbblWghhuiBLEWjs1IwlccIwawfJsD0ttH4WL2F
	 Um3ZVSkbECUZvklZEsSgCaofmQNGhFUal/qyA0vc=
Date: Wed, 28 May 2025 16:38:06 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: syzbot@lists.linux.dev
Subject: Initial message to start the archive
Message-ID: <20250528-notorious-industrious-chamois-423f5a@lemur>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

This is a delivery test to start the archive.

-K
