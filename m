Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A454408607
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 10:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492949; cv=pass; b=MB9eam4iyiKoC2S595vMPRPxjJ5utlKVJ/aHUDIXcgkv67Bw9eR9y47tkOuBbKs69IZw4bcr0uxQHc0Tq7AHTZAlTkK1o/nLuK1HDgXtrGPSJQg/dDxz63c257WQvZo6Dz/odTTjA44q+6B067oAt32+e2MZ5OMZrW136L9Hf/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492949; c=relaxed/simple;
	bh=LXX8eivxKxrbAOK3pn025OPZrile2JurTBg3reT34hE=;
	h=MIME-Version:Content-Type:Subject:From:To:Message-ID:Date; b=rgeWl8OgnTHJIV03EhQpeD5EiT/RFC8ZYx5VdM6Yv998ZsKE5ciEyj9+EQUalffDNZzfs0Kxjiz/rK52iaugAuDPBNPYCoMVby0vzkpciqsPC1l/WqMgP979jtqzarNiY4qciWb2KjFQAQfAKor35E1YkqyPjQnZ0Ao6FbrJ81E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b=fNhi22JQ; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.b="fNhi22JQ"
Received: by smtp.kernel.org (Postfix)
	id 3B03C1F000E9; Fri, 31 Jul 2026 10:15:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=216.105.38.7
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785492940;
	b=1DgS2+d3Vsj/ySwIHXJgFm/rzj934UmOVwTta99Y8ug2gOASzRfbqqlOLChHNbg/wj9H
	 pw2YVuFHTauNoOoE/ghoOaY8EkvsIb8liKEClKv1BTuiIriWQEhXmp7S8ehwNSOK7heFt
	 SkNu26xuUs/b5A3vPGEULFVQbqCHzrytsOEqf1/xCboCubbaCwpcy8FbyAAhrKJuRLQ+v
	 Yk/wIDHiFPBAs+0OORzEjBxkDrHtJphvjODI/w0Wnd+BcGPiES/fWwEsmZfzbYkgTsaYS
	 hhR5fXPJWpml+5LFmWZVZy251zuUghJq7A4bDEBI5GjW7veClWWf1qDzoFTt12NfzLQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785492940;
	h=DMARC-Filter:DKIM-Signature:Received:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:From:To:Message-ID:Date:Precedence:
	 X-BeenThere:X-Mailman-Version:List-Id:X-List-Administrivia:Errors-To;
	bh=kEvxb85qDVbL2MynTLLXGY0pSQ6A8/YXuy5+ACWBXTc=;
	b=uW9fkt2seyKXF2pKmfbh0lcz8bSgk840QTCZ0FrtndZnba3WcJtsrtFgmdIwXXaRbQgw
	 uiKehOI1t9dm9N2z/KN8obMRZ7zyFJyjsVUzZzFcCoJnlFsaNn/LuExaXL56sPQWKTeb9
	 N6xGDtrtZIkLfqUyGvvsXGEPu86o4xRkBoiU/p3ICX9Thw0Q6XtWS8JGTQqIr+Q4Ucs6h
	 jw6KmYf5SWvCWq9ZPtqHKsVpUFIfjpMQ6kQdpwsEMahIYSszPkqqtnGMkfweFVd/3cW5K
	 F0hKZWOE9VxIZJnR/cxKr4mccZqOIh0oKIb2dcTzNx1p4r8T8fy5ZfUi8mpItyDgsZQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.a=rsa-sha256 header.s=beta header.b=fNhi22JQ;
	dmarc=pass header.from=lists.sourceforge.net;
	spf=pass smtp.mailfrom=lists.sourceforge.net;
	arc=none smtp.remote-ip=216.105.38.7
Received: from lists.sourceforge.net (lists.sourceforge.net [216.105.38.7])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B29861F00A3D
	for <syzbot@kernel.org>; Fri, 31 Jul 2026 10:15:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=lists.sourceforge.net header.i=@lists.sourceforge.net header.a=rsa-sha256 header.s=beta header.b=fNhi22JQ
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org B29861F00A3D
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=lists.sourceforge.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=lists.sourceforge.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.sourceforge.net; s=beta; h=List-Id:Date:Message-ID:To:From:Subject:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kEvxb85qDVbL2MynTLLXGY0pSQ6A8/YXuy5+ACWBXTc=; b=fNhi22JQHW8/Kj/tW29P0zapWA
	mGMdr0mYJF8JXFmxVrPAigSGXSVsrPtipbX23A8HD2kxIK/of7YZ0MweP8WliKTNCYKZZ85bMi836
	njolKGgZtsvZTHHoix03e0alDPFLj9dGjFkMApDRjuxwMSgqReLIm3l96fejq34yAl7o=;
Received: from [127.0.0.1] (helo=sfs-ml-2.v29.lw.sourceforge.com)
	by sfs-ml-2.v29.lw.sourceforge.com with esmtp (Exim 4.95)
	(envelope-from <linux-atm-general-bounces@lists.sourceforge.net>)
	id 1wpkHC-0003r5-Jg
	for syzbot@kernel.org;
	Fri, 31 Jul 2026 10:15:39 +0000
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
Message-ID: <mailman.108068.1785492938.1583.linux-atm-general@lists.sourceforge.net>
Date: Fri, 31 Jul 2026 10:15:38 +0000
Precedence: bulk
X-BeenThere: linux-atm-general@lists.sourceforge.net
X-Mailman-Version: 2.1.21
X-List-Administrivia: yes
Errors-To: linux-atm-general-bounces@lists.sourceforge.net

Your mail to 'Linux-atm-general' with the subject

    [PATCH] usb: atm: cxacru: properly kill rcv_urb on error in
cxacru_cm()

Is being held until the list moderator can review it for approval.

The reason it is being held:

    Post by non-member to a members-only list

Either the message will get posted to the list, or you will receive
notification of the moderator's decision.  If you would like to cancel
this posting, please visit the following URL:

    https://lists.sourceforge.net/lists/confirm/linux-atm-general/51bca878f37862e58da7b2f9b347edf0997350c4

