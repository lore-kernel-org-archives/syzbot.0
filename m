Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A24357CEC
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785966418; cv=pass; b=NTAw3axqQpcclNQjttuc7DOSo/yTu/wXK5yKWK+2WIH/ugcXnZ8ueBWwmXNLaHaZ6AUeS3zEmFUjaR+SvZZmQN/FhOgrECd7DjWjtvPAjKbywJRkQxC07kKBAm2roqKcCIKYuljn8KJQxWlbJw9dA5ud34ktzLmcUXrC5G8d71k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785966418; c=relaxed/simple;
	bh=Zz4yzGKTLZ5c0wGarcASTJ3+9l+z1cY0i8hwenG2ufo=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c2waa5QPRFkP3UlqT2klN1/mIaxJi+1Q6SfGGofdhzG7nnuLp2g1ykq2mkfD4zqD1a5XXCpWAIRjbe+6ww0Vurzftp1/FmlWioSM/eGPLWNW1DbrRQHKBxO8HfZ//GUPM2w3Hd3rtnR3QEJzVTbNzRVlphTpQk7GMTQa+h8QfsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Yt+e4x2z; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Yt+e4x2z"
Received: by smtp.kernel.org (Postfix)
	id CD1DB1F00A3A; Wed,  5 Aug 2026 21:46:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785966415;
	b=zxYD2dwH7Q4sbifdLz53dBQ66ioGbSIsH9CFtMR3EvNQsF9sAq6b7S1lPmKBjAzLL2WV
	 yM6dRhzp51dKxgeaIJWjDsjUo04jHIkLRQUFSD6QzJZtWg2fFi7aDImB38n+CkxsyKZ27
	 0MuwB1hLpqDvMotQOXmGbsNDNJUzKfrNfcHFyRk0k178BWLJPjfn5n4mxDgkNOTMj6ZBb
	 SqBown+NqbpUpnn3FNldmzUCP4dAswU5F8wdOzsTvhlg0mmPlKs3CPRdhpOmifOLLzMCi
	 g3xkKO55v8JaEGU1wirG9qrgC1BjzewVrj14MhIu1X6Eow8EX/oms0E2UIMC/TmfFoQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785966415;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version:X-malware-bazaar;
	bh=9zq5dLUVn/QlfgqXjyEMeokp6x4gdMKxYzdEEjIPO+k=;
	b=qupCdMZyodguHk1RaTHC806Tpm/EdEJJvJE6MG/0mvKx7XYQ1Wwqg201w25CxSt2r26V
	 z6DrBuVcE8pPwpY0q7DBN31SuoS/GB5ZvnlZvuZCz6+cOLdJBPtXkZmeLoDyYlfu9eyR0
	 O+0qP7Ng0jCTn6e19Hu897ksI0oQK/JFOwmPvvxyUZ9lgnckoRMQaN5XebVRkW/yCyb+f
	 jbiWOgKf1pPkSQbHU6OBT8HsOG7Bebtl0DDDwrhKgpiECmxx4eG3iimxQsiJn2JzKJkU6
	 bQDoFoL0jkIYCdWQO4UySc7pXPNJvILUuuwNTyFC3wt2t4N5JhYNHKk6k15Mprazu8g==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Yt+e4x2z;
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3C9F81F000E9
	for <syzbot@kernel.org>; Wed,  5 Aug 2026 21:46:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Yt+e4x2z
Authentication-Results: smtp.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9zq5dLUVn/QlfgqXjyEMeokp6x4gdMKxYzdEEjIPO+k=;
	t=1785966413; x=1787176013; b=Yt+e4x2zsT31czB2SMD2AomdZp5Qjy07QxwfTxmGVKKSe9v
	AmGT1zQHWRF/10Z9r/tb70jexiN/ULA6jViA/QtLZpXWCu4FWdkbSFddEZm8duAlQAyZ6l+Spwgrq
	1WXQzQY04BcazppKwa1VuIjESaVPyRmtCsJMsl9x8BMbie/ZN9ZsUgtZf7wKd1kpqUEHO3vyFXD9w
	pSGkmR//gE/YuIvZtfScxPNXUMcwHLNM0OTBla6eLA67duyJb89W8iru2ayNouXi/i3Crp1yr6HRf
	YMBjor1zc0usN8SRwKX+XsCLYQuIjn1jYEnF1xXL/Wpo2UFhRJYgoZ0FN0YlNSlw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wrjRl-0000000015r-10To
	for syzbot@kernel.org;
	Wed, 05 Aug 2026 23:46:45 +0200
Message-ID: <5e9b89e5694ed5b568616483d76ed58b298cca87.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: fix BSS RB tree collision during
 channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot <syzbot@kernel.org>
Date: Wed, 05 Aug 2026 23:46:44 +0200
In-Reply-To: <1e64e12d-7785-45f0-8ece-b87724e7c9af@mail.kernel.org>
References: <1e64e12d-7785-45f0-8ece-b87724e7c9af@mail.kernel.org>
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

On Wed, 2026-08-05 at 20:35 +0000, syzbot wrote:
> From: Slawomir Stepien <sst@poczta.fm>
>=20
> When a station processes a Channel Switch Announcement (CSA),
> cfg80211_update_assoc_bss_entry() is called to update the channel of the
> associated BSS. Because the channel is part of the BSS Red-Black (RB) tre=
e
> key, changing the channel requires removing the BSS from the tree and
> re-inserting it.
>=20
> Before re-inserting, cfg80211_update_assoc_bss_entry() searches for any
> existing BSS on the new channel that matches the associated BSS so it can
> be unlinked to prevent an RB tree collision. However, the search loop
> incorrectly uses cfg80211_bss_type_match() to filter candidates based on
> their capabilities. If an existing BSS matches perfectly in cmp_bss() (sa=
me
> channel, BSSID, and SSID) but has different capabilities (e.g., due to a
> malicious or misconfigured beacon setting both ESS and IBSS bits),
> cfg80211_bss_type_match() skips it.
>=20
> This leaves the colliding BSS in the tree. When cfg80211_rehash_bss()
> attempts to re-insert the associated BSS, rb_insert_bss() compares them
> using cmp_bss(), which ignores capabilities. It finds them identical,
> resulting in an RB tree collision and triggering a warning:
>=20
> WARNING: net/wireless/scan.c:1675 at rb_insert_bss net/wireless/scan.c:16=
75
> [inline]
> WARNING: net/wireless/scan.c:1675 at cfg80211_rehash_bss+0x1e6/0x540
> net/wireless/scan.c:1732
> Call Trace:
>  <TASK>
>  cfg80211_update_assoc_bss_entry+0x3cd/0x660 net/wireless/scan.c:3478
>  cfg80211_ch_switch_notify+0x3b1/0x780 net/wireless/nl80211.c:22366
>  ieee80211_sta_process_chanswitch+0xbd1/0x29e0 net/mac80211/mlme.c:-1
>  ieee80211_rx_mgmt_beacon+0x1dc6/0x32a0 net/mac80211/mlme.c:8309
>  ieee80211_sta_rx_queued_frame+0x6ac/0x4e40 net/mac80211/mlme.c:11793
>  ieee80211_iface_process_skb net/mac80211/iface.c:1766 [inline]
>  ieee80211_iface_work+0x552/0x1010 net/mac80211/iface.c:1823
>  cfg80211_wiphy_work+0x29e/0x420 net/wireless/core.c:538
>  </TASK>
>=20
> Fix this by removing the cfg80211_bss_type_match() check from the collisi=
on
> search loop. The RB tree uniqueness is defined solely by cmp_bss(), so an=
y
> BSS that evaluates to cmp =3D=3D 0 must be unlinked to prevent a collisio=
n,
> regardless of whether its capability matches the connection type. If the
> AP's capabilities legitimately changed, cfg80211_update_known_bss() will
> safely update the capability later.

I think you should be able to explain the change yourself. If you can't,
don't send it. This wall of text isn't helping. :-/

johannes
