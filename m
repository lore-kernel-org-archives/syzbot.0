Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284C453445A;
	Tue,  8 Sep 2026 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870368; cv=none; b=RiEQ4YJUX6o9ZIl2r3d8vjH3Jvf5OP4oXiSiRoBVU0TShzeJZaiKxcTtYUFU0R89H3NpiA3+8doRVr/DpAmZp/OivgF31Y8O73foHoPdWau5Qy2fLJ273WOMyGYU4IDbm33raaiu8LHesvDJuK5XRMQwGExQA56lTU7eS2DQ+As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870368; c=relaxed/simple;
	bh=QXOH7qEx4pUaa6qTcmb8GkT1aSElZQSeAUuSjfI6go0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CIRMNsOl51FMyOeJo2X08x4Mpj94hp5ienI5aSuBtOqUVLwSECxo5BhbW5FtxZe3VdlSypXHEq51lb/u0xUODPHKceqdiSiJGYYGm3z+KrOl5V2eb4jjPuamwv2B7NvZ1bJ8g0vctTP8cHYiFZRXIJr1jrj5cyeq5R51gJ5zsOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=T+CF2PE4; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="T+CF2PE4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3TTkjK4efW9roUyrSzJPTQ13MVqEKMUhdpq/+UHmD+8=;
	t=1788870367; x=1790079967; b=T+CF2PE4k+3v7J0XnnoV99n7fkM0xh5cpFsbzItFvuFRpEf
	BcLzAbljRfVjYsEPlMkZhsv8CiY/QnXt/8If+jWsY6d0tQJ9dAIz90k8hjx0cggj4wryIi7PROgh/
	sGmUCycpR8e5zvCy3uuq3Alhhr5eseW9WDoNMNP8VhY9FSNi0DDIH16y9r4U1l72CEhYUm/OtyUBg
	GHPySYsI872xdkDuU8qIJ1ELSlghoWJ0F3Yv2YT6991DQ/K1T++WLZ5UbcYqub6e1zh3aJmF79EPf
	ZehJEj5meBRLInOMmeaDsE+AzK7oy6nlaEB72Y1edGca43uNGf/juUlRa4uwO/Kw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3utl-000000066si-0IbY;
	Tue, 08 Sep 2026 14:26:01 +0200
Message-ID: <22e7ddfc50d7a6a16c437b876dab5fe223799610.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] wifi: cfg80211: check if AP has been started before
 adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Date: Tue, 08 Sep 2026 14:25:59 +0200
In-Reply-To: <ap_4hS6M8g4u6z--@nr200>
References: <20260813090434.2071318-1-sst@poczta.fm>
	 <20260813090434.2071318-3-sst@poczta.fm>
	 <113768c35523738bdc7ab8441ecda64a063900bf.camel@sipsolutions.net>
	 <ap_Y8OD0eBAnB8QS@nr200>
	 <8934029f86b1c0e75f777185b2768f8e9755cae5.camel@sipsolutions.net>
	 <ap_4hS6M8g4u6z--@nr200>
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

On Tue, 2026-09-08 at 13:59 +0200, Slawomir Stepien wrote:
> >=20
> > Don't think you're missing anything, there's just the block handling
> > param->vlan in add_station, it's dead code now. But why not kill it?
>=20
> For the reason explained below (in my previous message).
> There can still be a command from userspace with AP base interface (as wd=
ev) with
> attrs[NL80211_ATTR_STA_VLAN] set and this block will be executed in such =
case. Right?

D'oh. Going too fast, I somehow managed to not connect the two things.
Sorry!

But it's another messy code path - if you have AP A and B, and VLANs A'
and B' belonging to A and B respectively, then you can

	add_station(A, vlan=3DB')

and it gets added on B/B', and B must be IFF_UP (because B' must be
IFF_UP) but doesn't need to be beaconing and we're back to the bug, it
seems? Maybe I'm missing something.

Since VLANs have to have the same local address as their AP (i.e. we
need addr(B') =3D=3D addr(B)), I guess get_vlan() could check this though,
if it's indeed a problem, and that would avoid it through the chain of
other invariants (IFF_UP, beaconing, etc.)

johannes
