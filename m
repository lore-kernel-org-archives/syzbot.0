Received: from mx.swemel.ru (unknown [95.143.211.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEDE3ECBF5
	for <syzbot@lists.linux.dev>; Thu,  1 Oct 2026 10:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.211.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790851549; cv=none; b=MuV/iFLRboG1e0BHGII9WHcWlUKppP88OPvB9X1asQqQ/TqK+e5fBwmoTfXRQa4M+2U/duqD0gKbiNyuoWaL4hpAxXEp+YQ5eF+NAAkuev0KiQJnRrW/ytW7UsMPnisiQUGSNkiBJgRf8ImnCmpSIXanKIeOYOMcZ+omfK7ZVHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790851549; c=relaxed/simple;
	bh=SaWjJYGUQ7c8OMKwCk0VdRzn2DP0wuxI578A85RVXjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcIvv1hV1oROQ/ydIneMqSQ/mV4fAlgHr5z5zM+VHcF3E5IloN4CfdZeht0vCggWc81418hY7dyB6+h2MksRywxVLl8d79MuLyShYWo8fhbHdGiCLCnQzARt6SfTDQd2jNLigTwsohVpgtjOt3SoTSVAViTVS32Sc1wiWBDw6vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=swemel.ru; spf=unknown smtp.mailfrom=swemel.ru; arc=none smtp.client-ip=95.143.211.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=swemel.ru
Authentication-Results: smtp.subspace.kernel.org; spf=tempfail smtp.mailfrom=swemel.ru
From: Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1790851066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ws6HwGRYvEC9/7mLPTRmtGGSscHu4/UF85e0oD/ZwUg=;
	b=XcoLnISB/1Aa+vGGAEYRoNxFcz6ICLWk8HLeHMEjY/TwxHMSNhgPlAbszi1YrR1oyJn6VZ
	1rr7tvlMzYVMzIeQNU3bMqZDtRjCpLXMe0RMJGfLsXXPSiU8Lc3x5BPQwKbaz5J2xbDtiA
	CPpQLGGdE+23ez8HGlxur91d69V1GAo=
To: syzbot@kernel.org
Cc: gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org,
	nogikh@google.com,
	stern@rowland.harvard.edu,
	syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com,
	wangjinchao600@gmail.com
Subject: Re: [PATCH] usb: gadget: dummy_hcd: prevent unbind via sysfs
Date: Thu,  1 Oct 2026 13:37:46 +0300
Message-ID: <20261001103746.11108-1-arefev@swemel.ru>
In-Reply-To: <18ec3122-7566-49e5-9964-1028857405b1@mail.kernel.org>
References: <18ec3122-7566-49e5-9964-1028857405b1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello.

I would like to gently ping regarding this patch. 

It addresses a clear null-pointer dereference vulnerability in the dummy_hcd driver
reported by syzbot, which could potentially lead to a use-after-free race condition
under certain scenarios. Disabling sysfs unbind attributes via `.suppress_bind_attrs = true`
seems to be the most robust way to synchronize the lifecycles of dummy_hcd and dummy_udc.

Are there any concerns or further changes required to get this patch accepted?

Thank you for your time!

Best regards,
Denis Arefev <arefev@swemel.ru>
