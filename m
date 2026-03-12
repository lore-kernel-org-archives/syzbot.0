Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21D2390C94;
	Thu, 12 Mar 2026 17:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337448; cv=none; b=hdTibXkz51khJIhgMNWKHnck0dxkwqyPXkTTPtTx33woh4FdRtzRGWvsHzyaD+wnerJMqz63fasZVM3+F6G9m7lp01bR1sJXX+YLtfEXbRcVMnSE3mXr/JajPKUf/Ci3Nzr/azJ+BJleMpNr3/qjznDF0a7VwJU/pl7sthlYtC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337448; c=relaxed/simple;
	bh=+wTst7GwwIZgLldUwvGmR8J7bKS0OJjukGseSnExEsE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L0xqJf8oTwv1q1Fhou2cmJiTLDYVSDN4Huasqq7YGCkoLzZJawWFWcnxusfoRf/eQtbT500IVk71ja28qFdcMfCFFO2YUwFudS9bkX3NQzt04fEhKrfBZfPxZHJp+lsDW9Bfx2OuXxDPx68Hp/0ReWAtBp2bwwUIoGpSUOtQxOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=X5k9pPli; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="X5k9pPli"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=EcHHqkSA7adMOLwG2Zw8JayfUW+5mWxn4kV/u34Uhuc=;
	t=1773337447; x=1774547047; b=X5k9pPliiqVD0jDZXBmqA8D+7rGRgJvknFO3cWPFRRMJGNO
	BBANIM+9ozBOk9KSMsO/Sh5wSwueADbCgASOo1jv5NEFmVsLyknFRCVXW/T5PTvAbf8rIztkchH5B
	wMXYLLscMz5a7KCQlu6iXhXeAkudnl29wPdY+IiLaVyDZLex/imcU668W6BJPJrHcHqntLCauNXpX
	HG7x8ch5viRRm3IZXNl/RnT5fZSfdCCojpMnFScJy8dtUKXAScXCkEi/OqUMcBnRfqIqzUmzQhJwd
	7ohrC96EJ9ouhrXNN7OUFbNCEclZP/fAT2pvmmdgUL9M/Z3NBH+LMQXFKeRZ5tCQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1w0k4n-0000000G08R-0Q8q;
	Thu, 12 Mar 2026 18:44:01 +0100
Message-ID: <c6aec6f5dfc420faf56185684a61b200fe37a6cd.camel@sipsolutions.net>
Subject: Re: [syzbot ci] Re: iwlwifi + mac80211 stability
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>, syzbot ci
	 <syzbot+cibf86f11719f1261d@syzkaller.appspotmail.com>, 
	linux-wireless@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Date: Thu, 12 Mar 2026 18:44:00 +0100
In-Reply-To: <1e6b8cbb-0f89-6b9b-b2cf-d21ca80dd7a2@candelatech.com>
References: <69b2ccdb.a00a0220.707e5.0016.GAE@google.com>
	 <1e6b8cbb-0f89-6b9b-b2cf-d21ca80dd7a2@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-03-12 at 08:25 -0700, Ben Greear wrote:
> Which would be triggered by this from patch 0004, I guess.   The phyd
> pointer appears to be an error code -13 instead of clean NULL, so I guess=
 I
> need to add checks for where that is created as well.

No ...

> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -680,6 +680,12 @@ void debugfs_hw_add(struct ieee80211_local *local)
>   		return;
>=20
>   	local->debugfs.keys =3D debugfs_create_dir("keys", phyd);
> +	if (IS_ERR(local->debugfs.keys)) {
> +		pr_err("Failed to create local keys debugfs dir, rv: %ld phyd: 0x%px\n=
",
> +		       (long)(local->debugfs.keys), phyd);
> +		local->debugfs.keys =3D NULL;
> +		return;
> +	}

That's just never going to get applied anyway, so what you _really_ need
to do is stop sending this crap.

johannes
