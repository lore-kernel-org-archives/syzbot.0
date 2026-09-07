Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1764037BE93;
	Mon,  7 Sep 2026 09:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774441; cv=none; b=AgMQN4fSiXfmdWS2fm2cfSL7pbFAaTzmXfdt4gsGgtEcZYuB/D7YWRDYOSgQN5cXZex7tCDuCTR+TH3XIfqxVzt14/ZLltzDLmfrpMlGQ/pgPep+ksa4raQenUUqpiIvOx2cBa3AxZUDFKZKDAFohYp8yV9xzIXosKwEll7cR7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774441; c=relaxed/simple;
	bh=43b7EzOAzU+8AHXIAeUmr9FriOvzo5/nVUwwv8bvaTs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NkMH1elk9IsedtHChFreX88iHY0HIVPKX9BFKbexVp+Y5OlnONy+kTQ6yRAOvJdmdJFZLRJG+acDw2PScfJq39EyP0uqya/UwbvA4qWoKHRStBq/tO74HoQxSn4L/uaijjg3kNrwR19MSMa7uRVen4zlmp8YmDuNFpNlS/FmBuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=SuDq/sX2; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="SuDq/sX2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Hnr58vE73LK7YGXuPdZbJ4n+GfIeo3BTqA/oxTPuMs4=;
	t=1788774440; x=1789984040; b=SuDq/sX28I8gz/809ms59Vb6c35+deDjoj8zbMNufXtbQfu
	uDgJfo7UP3GLtu/22DY/pXskSJ8zNqeekCDHqBTJkdYcqS/Ntpj/CRkyrLBcF5TuSn73rBfiu93fG
	HIS/LmHRCZI+3cM09N2gl+F2iMlS44GL06jKYCbrhnSRRNLgwf1eI/qOnU28d38tDP163ScBY5wkD
	8ygfXJzPTp9jf839U7ZvMMjle6CgJZfLeqwt7j+d0pL80Pr7pbUHdT5henyQp4cVBxrhsq9DZrgBQ
	zXVItT2Obcj8iLNkQvzZSamkPgDeLOuwsdxSwIIpTMjL+Jq9dEoknBWNC4BYbO4g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3Vwb-00000004S9x-0yPF;
	Mon, 07 Sep 2026 11:47:17 +0200
Message-ID: <87f5112aeea92eb84350eaa19ef8ccdf4c630c96.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] wifi: cfg80211: check if AP has been started before
 adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, 
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Date: Mon, 07 Sep 2026 11:47:16 +0200
In-Reply-To: <ap6H7U3j0CgPj2IR@nr200>
References: <20260813090434.2071318-1-sst@poczta.fm>
	 <20260813090434.2071318-3-sst@poczta.fm>
	 <113768c35523738bdc7ab8441ecda64a063900bf.camel@sipsolutions.net>
	 <ap6H7U3j0CgPj2IR@nr200>
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

On Mon, 2026-09-07 at 11:46 +0200, Slawomir Stepien wrote:
> On wrz 04, 2026 11:25, Johannes Berg wrote:
> > On Thu, 2026-08-13 at 11:04 +0200, Slawomir Stepien wrote:
> > >=20
> > >  	case NL80211_IFTYPE_P2P_GO:
> > > +		/* Add a new station only after the AP and link has been started *=
/
> > > +		link_id =3D wdev->valid_links ? params.link_sta_params.link_id : 0=
;
> >=20
> > max() maybe?
>=20
> But wouldn't that blur the intent here? It's not about a bigger value. It=
's about MLO or not MLO
> device handling.

Yeah, true, was thinking more of the pattern than the semantics.

johannes
