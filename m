Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DA64A3879
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788187256; cv=pass; b=era5JWhih9sE1XJPzzdXUu3AS/xUbdi6S0w2CF5rRt8iade4fYUH5fYd49GY2cO5HnBJj9BIxGXjiGcE/Kdi9bZqEkZOgSAQLB3uqyIrvZQHyM/zC2kfCD0hU+OzFtkqleWm8324PPVdzG4AWFNwvlu5rJNeazENIxRqjdUXzFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788187256; c=relaxed/simple;
	bh=/JLBX9lRrd/OuJ0flmOxwkrF94Yv4RTTIj1dzzbqCa8=;
	h=MIME-Version:Content-Type:Subject:From:To:Message-ID:Date; b=Q1ybuu9Ag55P1YQJu3FLFOmz/wAC+2ywva4+Likcleqb+1ll/E/VKWEzwNm/nr8RwujEfo1PzMGybOX/cCLuYvQwwq19xRnyH5XTS7dVQkylCwInlYiDfA7zfj8Il/lAcUAanuWE51YKNpj+zS9h+kxpP8mlAGzGl4u4MoWR26Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b=hlMHqr6y; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b="hlMHqr6y"
Received: by smtp.kernel.org (Postfix)
	id B60BA1F00A3D; Mon, 31 Aug 2026 14:40:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=216.105.38.7
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1788187255;
	b=OZx0PTRGOqpcUFB2OffH+soT9oS83uQ+UVLNmomZWnxNWotW4zr0MGpdlIhal4rvIU/7
	 OMCKPZxzPY/oXPh5LBdspiwxp2F3rkE7sYXpeo1xbc0Uj6m0g4VrAnSOpI0mpvJdmIiZE
	 PRbbxfZ4al2mWmgIzyIbnjoG/8xWRsWjNLF8SaRrFMfamoATDlwc8HQ5NnPitbKe89muL
	 9S6ov1wnuHKjvhpQcqfjjkMiwHdlf0/7KWrdHw1TLu/KMWprIXK2IQMxvd8N0QqFdP28n
	 Mr9OtKMppgCSldY7GwZMWtX+KELjPdzQKIoh+IXcrMkuNFwvkqeuJVaMdyBRK21pRaQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1788187255;
	h=DMARC-Filter:DKIM-Signature:Received:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Message-ID:Date:Precedence:
	 X-BeenThere:X-Mailman-Version:List-Id:X-List-Administrivia:Errors-To;
	bh=ONvbFPGcbVfAXsdFZ2E2dLtT7tWoJPwgbGufljH1qcc=;
	b=rtZMOsJ4Wc0yHC00DM9CzFP7lb60mZhX54JYTP2M4Anyu56ilT/vsSuyY3XVWXG3Sryq
	 oMg9l0xkSRN7XAuCpD0u2jXRgu9qdOs+fAkGw5W5ax0pMePRy08C4Qg/E9Fg0xBq8g3J8
	 kEr8cAhd6K9bEnnjiFittDFT+ovqrjRySFfaq9bbcImkh+41XHHW7wpo/B1XdydvcB1Gf
	 JX0fXk0wdq3qMC4DRxzSAkZBp9efSNU0U8OLPIiH0F1jJlsU6aYjfOegWryP1LSjtvxFd
	 HTqqHfKqsi2zqJ53eUTgOWXfNs8Rxi1wAUKJT+8kVVitwVCeNjzuMxrxKgYBGEjK2zA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.a=rsa-sha256 header.s=beta header.b=hlMHqr6y;
	dmarc=pass header.from=lists.sourceforge.net;
	spf=pass smtp.mailfrom=lists.sourceforge.net;
	arc=none smtp.remote-ip=216.105.38.7
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3D6841F000E9
	for <syzbot@kernel.org>; Mon, 31 Aug 2026 14:40:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.a=rsa-sha256 header.s=beta header.b=hlMHqr6y
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 3D6841F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.sourceforge.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=lists.sourceforge.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.sourceforge.net; s=beta; h=List-Id:Date:Message-ID:To:From:Subject:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ONvbFPGcbVfAXsdFZ2E2dLtT7tWoJPwgbGufljH1qcc=; b=hlMHqr6yv/htRUTQkf+InNtHam
	+B7Oj0QDg9137uBAPMzASd69e0aGxmL7DftiV1urUsKP1Zjscu/ELUd6pV0z+dfLDW7phzrkVgd5t
	Jz+9toIuRd2n0oFexnEvgl9e7WUGthBMY3METKDb+jrsG+PcGVWFxjfCzmT67f13hzVw=;
Received: from [127.0.0.1] (helo=sfs-ml-1.v29.lw.sourceforge.com)
	by sfs-ml-1.v29.lw.sourceforge.com with esmtp (Exim 4.95)
	(envelope-from <linux-atm-general-bounces@lists.sourceforge.net>)
	id 1x13Bx-0001qn-AV
	for syzbot@kernel.org;
	Mon, 31 Aug 2026 14:40:54 +0000
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: Your message to Linux-atm-general awaits moderator approval
From: linux-atm-general-owner@lists.sourceforge.net
To: syzbot@kernel.org
Message-ID: <mailman.36332.1788187251.1621.linux-atm-general@lists.sourceforge.net>
Date: Mon, 31 Aug 2026 14:40:51 +0000
Precedence: bulk
X-BeenThere: linux-atm-general@lists.sourceforge.net
X-Mailman-Version: 2.1.21
X-List-Administrivia: yes
Errors-To: linux-atm-general-bounces@lists.sourceforge.net

Your mail to 'Linux-atm-general' with the subject

    [PATCH] usb: atm: cxacru: fix NULL pointer dereference on
uninitialized atm_dev

Is being held until the list moderator can review it for approval.

The reason it is being held:

    Post by non-member to a members-only list

Either the message will get posted to the list, or you will receive
notification of the moderator's decision.  If you would like to cancel
this posting, please visit the following URL:

    https://lists.sourceforge.net/lists/confirm/linux-atm-general/415fc29b94582deb8f729500f071f294d69cf148

