Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC8655295B
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788881395; cv=pass; b=gR46HX5UE6SGYm4f5/9fq1vPEvljarpampCxLeZu/mz3ReIJG7HEjO1/lDC5jKLl6Pq4F1yBGsymu1PHyZz54fttzEkS1Kf1eVxnfcv2OnbsuOz7CQk55RAGQnASmltQu7JPZrrOenHL83tO8NYa9B91jPcB/hvEl5EoBWBf/vM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788881395; c=relaxed/simple;
	bh=6AZCeLXM1ETwdyg3xiRZ6hOTSB9F53sVyiXiDvxBT68=;
	h=Content-Type:MIME-Version:Subject:From:To:Date:Message-ID; b=rvxesh6jP/tcjE7iALltuZqgIpoSmWNWzDOEgMtD2aisQe2sKNHt9ouhYPhQfhWgjzpoeNlSDAh6tsvGIPagGMs4h4bLRMBHnZQcmLoQUybbcW3L1Kc55lOXU+R3jpWqqUS0S2YzuykidzJPUPhKFXLbsPE2SRU+UKgY/54Ay/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=linuxtv.org header.i=@linuxtv.org header.b=aC4yyQ0m; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linuxtv.org header.i=@linuxtv.org header.b="aC4yyQ0m"
Received: by smtp.kernel.org (Postfix)
	id D89651F00ACA; Tue,  8 Sep 2026 15:29:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=140.211.166.241
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1788881384;
	b=rANEQ9IHwH7RR/gaPBAgn5cJ2Hpyyy3H8ojb/0thUIyc8pTV404U31COwjciFMN8nT9B
	 FGtjobM/Tk/90QOykuSZpp7EWbkz8UbccKUH7L92r30kU1rycfCelGy0meL3noi1Uhca/
	 y6mHA7d05vAOp5Jw8eAJwRWxBBR/tlJQgBWb+sU8/aN3g0d/74HFBthX51lNJI26kPHyt
	 bFo4eJfBfpbQY6tMn+sH4D0HM8sk+V789hjQIKe5g3TNV9YqQq7WwxyglQREbraFrTc/Z
	 0N8qV29J0x9UaaVcclJhvQICvWC6sUsiIaXhH5HZz0pfkINs7TcAFf50NZAlQCFaOMg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1788881384;
	h=DMARC-Filter:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:To:Date:Message-ID:Precedence;
	bh=qVwSTWjVSB0OUpO+ICF6REhtkzYZFG4c0BINoUyIMZ4=;
	b=3mJXOJiDbtEZiigJgxDBkDKD9PCYEL4rr0ysY3L7yxynJUrxItCyaqSVAgufnABQT0dI
	 BXLPN4+oBZmTyon4MNFV2ZOJX6c7c2X3l34K2uwODel2GhZ2LytuBJdGkYcCO8Y1QoeSV
	 14/Pl0ia1LQqirrpKlIJSmpYJmwTPDL+6F9IsCO7ztkFvcWMUjbNHN7BrzADmYOpZCCCM
	 uDuJiVCrNszE4PBxU3s7HHlI0wt+VceJeR1z9/22MWIA+T+73j6X5kxSD0RhEBrRriDPM
	 OhcJArGC6SyxrL1TJeWLzMAg7yHYjiJ4pu4liHk47pHHbPTYQXlFDWAoXIxOBXMDtuw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dmarc=pass header.from=linuxtv.org;
	spf=pass smtp.mailfrom=linuxtv.org;
	arc=none smtp.remote-ip=140.211.166.241
Received: from linuxtv.org (140-211-166-241-openstack.osuosl.org [140.211.166.241])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 82F371F00A3F
	for <syzbot@kernel.org>; Tue,  8 Sep 2026 15:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 82F371F00A3F
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxtv.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linuxtv.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=linuxtv.org
	; s=s1; h=Message-ID:Date:To:From:Subject:Content-Transfer-Encoding:
	MIME-Version:Content-Type:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qVwSTWjVSB0OUpO+ICF6REhtkzYZFG4c0BINoUyIMZ4=; b=aC4yyQ0mdGyUQyo8Dub+HdQ3vo
	76fi2ewnvZ1IB0D7QBHoiYTAUTWa4siVhA35mu+IuAHAd2+VM5EQH4G+NXP0oxMyNwkYDI/9nYmtD
	pZZZT8rQ7OJ8hty6I9KSHhFCamN+qF4cJdhBFdy3KguxMHD9mmGPsi0DjO8gs0ndTqRtxbPnVgGkQ
	Zw0L+JsCTnu7h1lC3QjKbzKWHlyOIADF3z7MWAhal32N/DPYH4AzoxaRoTXmJO+htBEAAMhsAG+zk
	Vv3i1hVUA2O5oPYpuzDysaKQGXS7qingNzaLg+TUK5xo4Mb+ChdzAfwAM6SR8CBaYgp5YZCZmXeK6
	FSYvy7tg==;
Received: from localhost ([127.0.0.1] helo=linuxtv.org)
	by linuxtv.org with esmtp (Exim 4.96)
	(envelope-from <patchwork@linuxtv.org>)
	id 1x3xTU-0005du-2B
	for syzbot@kernel.org;
	Tue, 08 Sep 2026 15:11:04 +0000
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [linux-media] Patch notification: 1 patch updated
From: Patchwork <patchwork@linuxtv.org>
To: syzbot@kernel.org
Date: Tue, 08 Sep 2026 15:11:04 -0000
Message-ID: <178888026467.21619.10599332313476200825@linuxtv.org>
Precedence: bulk

Hello,

The following patch (submitted by you) has been updated in Patchwork:

 * linux-media: media: usbtv: fix null-pointer dereference on disconnect
     - http://patchwork.linuxtv.org/project/linux-media/patch/df73ba45-4d7a-4cf9-bff4-821124045c55@mail.kernel.org/
     - for: Linux Media kernel patches
    was: Under Review
    now: Accepted

This email is a notification only - you do not need to respond.

Happy patchworking.

--

This is an automated mail sent by the Patchwork system at
patchwork.linuxtv.org. To stop receiving these notifications, edit
your mail settings at:
  http://patchwork.linuxtv.org/mail/
