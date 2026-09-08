Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B036047D450
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 10:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861612; cv=pass; b=gDtNmF8ZfH5XQE3facnlX+zt8kdSSUmtok4hddvToBBq/7Twd1vdBzMdlDYDwBvyXIoR39wtATujYVmfurG2muEocF4DemFRigZMkxuh/HOQuHh2pDw5GQTnJMbxAyaz5v8Fg+RHyVaW4/5QprhwSxtQl+eKhIBHrIiT9ERVmVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861612; c=relaxed/simple;
	bh=hHkd/nxGuwicPcDhrpuxH+00JIOIZZWXcFLMogUQoS8=;
	h=Content-Type:MIME-Version:Subject:From:To:Date:Message-ID; b=T04sPGTM5/Po0H/ovxtef639Qo5UdRZzn4GGOfLfly277s57s/weO+2saeN/m68LQwrDHjVqqByw7Wra03ShzvoLsZWJgE7fh4LvyN2ZcTqOmbvPmXRAgZFhMEiLRoj9x8Gdzv/iqeRkRigzONwPXv+DYNnH5s2Vdk8+KmuDdWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=linuxtv.org header.i=@linuxtv.org header.b=fGD8J93/; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linuxtv.org header.i=@linuxtv.org header.b="fGD8J93/"
Received: by smtp.kernel.org (Postfix)
	id 69EA41F00A3D; Tue,  8 Sep 2026 10:00:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=140.211.166.241
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1788861611;
	b=roTVhjC5n850wqxb/YoSFtKjDYRhGi081rOnaKDUrxH6Lgxa/732RmRZhrypYMHRgGqk
	 jhGc40VhkaRAzAwWGsrB33DUf6uvHGl6GqZ/B4lSyUarj8NaTpAvZp/Zy70sPpeiyLdZX
	 eXnN8gNMAx/V7vz1Etzlxc6JH9FD8Cj4flzej3B4JmHoRFVbRwPBpzExaPPbYMxa2YBrp
	 USxq9hFSrIgC7Oi8vJueLSe4x+u4kY3M36RAthpDHNGLdu1WJTO5JD8xTJm3GDXNP7AxU
	 B5J5nyS716Tx+UlWgnfPe/y3J8P1TILjcH5iCpKHODzTPcLV/6noN8qh8AylcdSizOA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1788861611;
	h=DMARC-Filter:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:To:Date:Message-ID:Precedence;
	bh=Lp7PysHZ9delG6spwQzW8mqxLt8sYhP6tF46yFpCbNQ=;
	b=Kd1ngu4S6lmLw0Vk+2byDmnilkhQaC6iYzz+XSVWW5RjnxBXnHb8wRtpXI8yXydaYSjM
	 nH7JtxdS244cnwuSz1nY1bQu9wIVLH9aNf5hSiTXuDDIdILM69HdRQSDTAkQPgp36NGN0
	 8S9xDbp637u1+B66qvePB8mYqX4NL6wxpmlQgmSr1wrOZctmF85mSyANWCYD2vry0dnB8
	 Gl6rb5xkw67Ho69QpAzoOjWmEPif+ccLaJYZ2CAQrfHShWgqlvZLbHnJXIZ9EONLVJAyx
	 nQIBWcoBUPlfZEPxL0JGjW5ogxMbBHKjeJG4ekpym5QwjL652GrxuJxM68y+xP740/A==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=linuxtv.org header.i=@linuxtv.org header.a=rsa-sha256 header.s=s1 header.b="fGD8J93/";
	dmarc=pass header.from=linuxtv.org;
	spf=pass smtp.mailfrom=linuxtv.org;
	arc=none smtp.remote-ip=140.211.166.241
Received: from linuxtv.org (140-211-166-241-openstack.osuosl.org [140.211.166.241])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DEB7D1F00A3A
	for <syzbot@kernel.org>; Tue,  8 Sep 2026 10:00:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linuxtv.org header.i=@linuxtv.org header.a=rsa-sha256 header.s=s1 header.b=fGD8J93/
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org DEB7D1F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxtv.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linuxtv.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=linuxtv.org
	; s=s1; h=Message-ID:Date:To:From:Subject:Content-Transfer-Encoding:
	MIME-Version:Content-Type:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Lp7PysHZ9delG6spwQzW8mqxLt8sYhP6tF46yFpCbNQ=; b=fGD8J93/WBsbxIuIjIQFGsolR6
	fAa5UwDl4eEpe3/OC55rsNS48dB0l0KYA7ySktgT4pySxFgBAf6bYpqdYxaw+UWLLU2+iHqF7rtdU
	T6lynsZNH49MKHXsPprV4/HWzkiENKFaPQsQzjMYkR9/qz1RUZqzpxrZUAUDKg2Cfo+unHVcdzEct
	2tMO3ALmT780OLmLqvYHwPJ1M/cAAu+nErk7fiMcpytXVg1Nks4ol4oN3CLIiM4MrBVt1Kar9Lh/v
	5c3H0iyHkpIyPU8Oo0iQbcW/flNFJU7LqWEE+mxTQq2ejW/xZKEofqE5soLFEmTh979QgPBAiGU8H
	Key7vgog==;
Received: from localhost ([127.0.0.1] helo=linuxtv.org)
	by linuxtv.org with esmtp (Exim 4.96)
	(envelope-from <patchwork@linuxtv.org>)
	id 1x3sOy-0001mW-1W
	for syzbot@kernel.org;
	Tue, 08 Sep 2026 09:46:04 +0000
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
Date: Tue, 08 Sep 2026 09:46:04 -0000
Message-ID: <178886076447.6771.13750164062026142188@linuxtv.org>
Precedence: bulk

Hello,

The following patch (submitted by you) has been updated in Patchwork:

 * linux-media: media: usbtv: fix null-pointer dereference on disconnect
     - http://patchwork.linuxtv.org/project/linux-media/patch/df73ba45-4d7a-4cf9-bff4-821124045c55@mail.kernel.org/
     - for: Linux Media kernel patches
    was: New
    now: Under Review

This email is a notification only - you do not need to respond.

Happy patchworking.

--

This is an automated mail sent by the Patchwork system at
patchwork.linuxtv.org. To stop receiving these notifications, edit
your mail settings at:
  http://patchwork.linuxtv.org/mail/
