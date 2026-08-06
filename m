Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5993E009F
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 07:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786003042; cv=pass; b=Ou1hpGtpIPXm46P8PeEFiivhQcCj7iu94Hz+w9Oa5vmkmVQ29QKSSdN+t7u5EEhOhhL2UmFg8EwUnYzswVN+Nz/CLCiD2H4t/70qC9pnBmzO9D5A24MBu6XGWngD7BU+VNa4NpzDJUYTJ5UIvt7KQzotZC9ReaiPGaqnne8sIoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786003042; c=relaxed/simple;
	bh=O5sbEBCRRFAg6x4wU9GXPuB33BhdLkx1hxZNd5hg7vk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qTfw0JI2VXW2Gr+E1yodgOfSPt/D5ClWHgZH+gMMgRDe3oiBMk9WPKB2RXlbVHT0ZRwMbd74dNezTh/Q1HxB/+8FF+DZXwdMzQE8Lvfbp8nOzp7cf2TzKEQz/9dJVTsYEHFiP55UmxhC+YUtOfpviYA28POJKPFUHidmnG6Da/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=RYT1BOhD; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="RYT1BOhD"
Received: by smtp.kernel.org (Postfix)
	id 29FA51F00A3A; Thu,  6 Aug 2026 07:57:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786003040;
	b=d6apUfLfnw+ByhLtga9bN5xh/VXuE2fkvdg4BbBZdktKpRyGY0PK6ES8w+qO1omJNex2
	 LlGk7v7db+159RL5VSoOy3mUFKK+DvvYPFn2kcv7DHTcX0EMeHy/Qmoz1mFyC0Wc3m35S
	 uKJg3dWyvRKvfzu+1bPr0R/EXNpJXXg9Psc8qgJNGHq0YeWbqC/ca0Kz5YYt3HYpTgzLM
	 n29k1ciVTFgqObJhYMqr0NTzaWRCmAPE3qGzdD9JjZY9eEY3zgefLlA3xPhoDG9UTJgNs
	 oNpC88AmBuf1iILl63GM+wrwZvukKAwXJnYP9kHxO4HN/7PD9N/NvlM0dsC4YhwrrdA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786003040;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=O5sbEBCRRFAg6x4wU9GXPuB33BhdLkx1hxZNd5hg7vk=;
	b=mKoENlN2s/ZuJOWU/I2sxoQOD/J8o38GNin0JDNUgnC1TzFlVqNOlrKXtYmWNZ724Asa
	 DZWuQcrKRtP/uihi9Zur1JjyFSF20XpVJcdZ+iRt6DidAoAcRh/smEcO1LhfJwBKpdu5j
	 cJi7M0zlfyYSFeqlAGmbI8cnZ9iDXsup28+tgICOjtbCY0TI2BxPgp757tW6SlFvSvw5v
	 CqNDn1jpPpc5pbbMxu/nHlLeDzWmDtsr/VgYomZG/LXgX2Ea+g4cr3C/rW3L3pkcxPVEd
	 y0zL4fU6Xvbbgccr0RU7669Dn2MvLrZTv2ChjCmBiVRKuV38SqWl/Df1igmXOSd1M8Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=RYT1BOhD;
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E7D341F000E9
	for <syzbot@kernel.org>; Thu,  6 Aug 2026 07:57:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=RYT1BOhD
Authentication-Results: smtp.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=O5sbEBCRRFAg6x4wU9GXPuB33BhdLkx1hxZNd5hg7vk=;
	t=1786003038; x=1787212638; b=RYT1BOhD0Bv/gFRJOhiAQk8ppWLqHlo2fV9FzHrHIvJpUwp
	1sVxvuDS8dD3aLaeD1ap6Ex7D0ZJB07xJHBUv4x3OgIWKlT2Ey3bvNqaaS8znAroLJCPZu4c1t1Qz
	MBsXyo3dUB4+B1PdLxvznD6J26KYFY9cEIDRuyTTdgbj3yZv8fD94ZVqB9dZOcRVJki5eC+1MBgvP
	SS8rNTwILoj2fcYbYLUQMDLLvx1KlyaO1V9I0HA/nSjfBs+WCH8KL7AEPukr1+cY4yO6kC+WjBMi8
	s0p7gxdjoTQkIKhxYfulglyhehpEdm/E8qKZigRRo70m0ADrVLtCT6T/rE9nuCAg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wrsyY-0000000CdAR-1SH7;
	Thu, 06 Aug 2026 09:57:14 +0200
Message-ID: <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
Subject: sysbot AI patches and wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, Slawomir Stepien
	 <sst@poczta.fm>, Krystian Kaniewski <krystianmkaniewski@gmail.com>
Date: Thu, 06 Aug 2026 09:57:13 +0200
In-Reply-To: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org>
References: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.

I'm going to state, for the record, that I'm going to make judicious use
of ability to ignore patches, and apply it to pretty much all syzbot-AI-
generated patches unless a 3-second review says "obviously right".

In particular, I will absolutely *not* "comment on the patches as usual"
and argue with an LLM that can bullshit out code faster than another
computer can even deliver it to me by email.

Whoever is currently pretending to be the human in the loop *absolutely*
needs to think about the patches, and if that's happening it's probably
no longer an AI-generated-sent-by-syzbot but you're going to rewrite it
and send it properly.

(IOW: get lost, syzbot)

johannes
