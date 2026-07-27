Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E7B3EC2CD;
	Mon, 27 Jul 2026 09:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785144345; cv=none; b=rQrN0wVxe0ZXh3MaizPMz6EMw76Rhn8f89YmOdrnyphKg2wYhgbvzHnfGcDDueq8JMAuuILPRvNe067HZp+/kqmMBM2XTDd5Y5x+H3LbkHEpCeY9SBmxLdfDtC4tVTwGxvi1R8/uRDtTeu6NjVJz3U/aFYSUgupEubbo80UfCp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785144345; c=relaxed/simple;
	bh=t+KNA1DlaG572JZgRp39HOVKTQPicflI+luNRNAHIto=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D5Xcrslzayl1wFlM28QljYKZU0YJjUgoeWekpGf6naorIWXYUEfONtfUF//GU3B2jf2mSmHci0GgpBVdmn/hAmjW1DxT/AgUCeXzB3iBzH/bfogrUbq3LA81Qkzn8mWs5dBbebwpBIVWoUzU4UgEsFlioljl1mkJXZa8Qjeoc3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=jcLCF90u; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="jcLCF90u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=t+KNA1DlaG572JZgRp39HOVKTQPicflI+luNRNAHIto=;
	t=1785144343; x=1786353943; b=jcLCF90ukixigHxIo1vReI853fAiIjuSdNiSmp4EnBOZkuk
	VN1j/teJudRxkDSHzqIuaXtGc/6NPToCWZYMypIepHLaftClDf84VEtb2yTXJiw7TVFFu71U+dXuU
	vCFI8uRZdOuo5Ool6hRq4NLMAwthTx08zoqsYYivC9gTWu2JI5fEp+7zaJnrPxdWeDTBQn7NuPvTB
	U+mbWaX+QKSUmVwe7rB8i1z/TJfpr2pd+mOQtY/kxzUdLriFTswUV6NiHq2G6sdNrWcwjvXoR3Jqt
	T2/8wT3kBUK4oxx/v1DMsIEnvFOfMa/JGMcyk6yMgXXWFODZw7RmbHr1ro0XwNlA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1woHae-0000000Emrz-0JOb;
	Mon, 27 Jul 2026 11:25:40 +0200
Message-ID: <741854f0b9774ce2da1e5c2fb551631aa4028122.camel@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: reject station addition if AP or MLO link
 is inactive
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Date: Mon, 27 Jul 2026 11:25:38 +0200
In-Reply-To: <amcjYrOESqnHjbhe@nr200>
References: <20260727074526.248393-1-sst@poczta.fm>
	 <9a9a794ad16663cfd7a652b83455ff16156b9baa.camel@sipsolutions.net>
	 <amcjYrOESqnHjbhe@nr200>
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

On Mon, 2026-07-27 at 11:22 +0200, Slawomir Stepien wrote:
>=20
> I think we do not have. I'm looking at the struct wireless_dev fields and=
 I see that there is just
> info about what the configuration should be, not info about what is the c=
urrent state of the device.
> I also do not see any callback in struct cfg80211_ops that might help to =
get such info. If I'm wrong
> then please correct my observation!

I think we maintain wdev->links[].ap.beacon_interval?

> Beside this, do we think that all devices would always need this rejectio=
n? What if firmware of
> these devices would benefit from *lack* of such rejection? Just thinking =
aloud, not that I know such
> devices.

I don't think it should be legal in the userspace API, and even if they
did, we'd have to add a flag to let hostapd know about it, and then when
(probably never) we did that, we could change the checks along with the
API.

johannes
