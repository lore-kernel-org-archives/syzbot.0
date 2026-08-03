Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEEB40D590
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 13:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785762615; cv=none; b=rYtYn22d58aTHiWqkZagWNoeDr4NYnGBjcayRBR1YVLTXL11ux6TudesO8fX/TKSXPYNCryOThTS9EXI0QcDSaL3tWYHlIqFcbfRgN7nsBL+wY5up+CxfLrCBaxX3ywdITQI2HeWTeIIWQYbdxNL7Lgnb4OEC8szzT9cydP1CXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785762615; c=relaxed/simple;
	bh=skZ3o2C83bqo64O48eP2TbVWJScyinPe2K7YPqDQbl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEenR2X47QnlLlJfLupEndZ3LIuIxzacypvOvL4JxuOYyEXURGoKAHdUixDb9UE2pSizyEeHsxmNn3BFPV1Pc4s8wEz/uM7eqMz7/GH2lZSPH8rwmkFRYtm+EadaLQ2c/tR9+AY/lx8bpYtTj+6jPxViFz2OlRegoLyO+aZfd7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=Cf5mUZUO; arc=none smtp.client-ip=217.74.67.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="Cf5mUZUO"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon,  3 Aug 2026 15:09:58 +0200 (CEST)
Date: Mon, 3 Aug 2026 15:09:56 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: syzkaller-bugs@googlegroups.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
	syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mac80211: reject station addition if AP or MLO link
 is inactive
Message-ID: <anCTJFZ54Y93O8Qs@nr200>
References: <20260727074526.248393-1-sst@poczta.fm>
 <9a9a794ad16663cfd7a652b83455ff16156b9baa.camel@sipsolutions.net>
 <amcjYrOESqnHjbhe@nr200>
 <741854f0b9774ce2da1e5c2fb551631aa4028122.camel@sipsolutions.net>
 <amcyO4e4bnBPinrP@nr200>
 <amdckJhgBz7xT2F7@nr200>
 <28f4f5b6fbe594c41538d5068b2d77495250ecd7.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f4f5b6fbe594c41538d5068b2d77495250ecd7.camel@sipsolutions.net>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785762600; bh=H46BO01Jn8KSezBfJtXDje0ki6VhnDh0lE6fQuGUTGg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=Cf5mUZUO3/ttFfBwiAsUCylvrFvpdL87z6sC+BUah/XEpgDmKBHl1lyxwvg5fthYY
	 e2kC3TmoPtaGMJUjoPo5v8aXTEi6RBpZzvRgMazyPl2PV29Cknsvt6Xb03HoyCnTr/
	 Ek3IEKbSFyT2nHmKlaATAQi6EgBWpumed4+bCmA8=

On lip 31, 2026 14:40, Johannes Berg wrote:
> On Mon, 2026-07-27 at 15:26 +0200, Slawomir Stepien wrote:
> > After taking a closer look at this I wonder how AP_VLAN should be handled? Is there a way on
> > cfg80211 level to be able to check AP_VLAN's main device state?
> 
> Hmm, yeah that might be an issue? I guess in theory it could track it,
> but it doesn't.
> 
> > My code change would look something like this:
> > 
> > @@ -9404,6 +9404,12 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
> >         case NL80211_IFTYPE_AP:
> >         case NL80211_IFTYPE_AP_VLAN:
> >         case NL80211_IFTYPE_P2P_GO:
> > +               /* Add new station only after the AP and link has been started */
> > +               int link = params.link_sta_params.link_id >= 0 ?
> > +                          params.link_sta_params.link_id : 0;
> > +               if (!wdev->links[link].ap.beacon_interval)
> > +                       return -ENETDOWN;
> > +
> >                 /* ignore WME attributes if iface/sta is not capable */
> >                 if (!(rdev->wiphy.flags & WIPHY_FLAG_AP_UAPSD) ||
> >                     !(params.sta_flags_set & BIT(NL80211_STA_FLAG_WME)))
> > 
> > but the NL80211_IFTYPE_AP_VLAN case would not work here, right? Can I just do the checking only for
> > NL80211_IFTYPE_AP and NL80211_IFTYPE_P2P_GO and skip NL80211_IFTYPE_AP_VLAN?
> 
> Yeah it'd just reject everything, I guess.
> 
> I think in practice stations are added at the AP interface first and
> then moved to a VLAN, which would argue for actually rejecting

But are they moved and then this `case NL80211_IFTYPE_AP_VLAN` should match?
In my tests this case doesn't match, even after the STA is assoc with vlan interface (e.g.
wlan0.10).

My test is done using qemu with:

Files:
------
==> hostapd.accept <==
02:00:00:00:01:00 10

==> hostapd.conf <==
interface=wlan0
driver=nl80211
ssid=VLAN_Test_AP
hw_mode=g
channel=1

# Basic WPA2-PSK
wpa=2
wpa_passphrase=password123
wpa_key_mgmt=WPA-PSK

# Enable MAC-based Access Control and VLAN Assignment
macaddr_acl=1
accept_mac_file=/root/hostapd.accept

# Enable Dynamic VLAN interface creation
dynamic_vlan=1
vlan_file=/root/hostapd.vlan
vlan_naming=1

==> hostapd.vlan <==
10  wlan0.10  br10

==> wpa.conf <==
p2p_disabled=1
network={
        ssid="VLAN_Test_AP"
        #psk="password123"
        psk=c31c83ea62af5b750232dc32865586f7658777dce974a980446dd6bff0154913
}

Commands:
---------
modprobe mac80211_hwsim radios=2
ip link add br10 type bridge
ip link set br10 up
hostapd -d hostapd.conf -B
wpa_supplicant -i wlan1 -c wpa.conf

Results:
--------
# iw dev
phy#1
        Interface wlan1
                ifindex 5
                wdev 0x100000001
                addr 02:00:00:00:01:00
                type managed
                channel 1 (2412 MHz), width: 20 MHz (no HT), center1: 2412 MHz
                txpower 20.00 dBm
                multicast TXQ:
                        qsz-byt qsz-pkt flows   drops   marks   overlmt hashcol tx-bytes        tx-packets
                        0       0       0       0       0       0       0       0               0
phy#0
        Interface wlan0.10
                ifindex 8
                wdev 0x2
                addr 02:00:00:00:00:00
                type AP/VLAN
                channel 1 (2412 MHz), width: 20 MHz (no HT), center1: 2412 MHz
                txpower 20.00 dBm
        Interface wlan0
                ifindex 4
                wdev 0x1
                addr 02:00:00:00:00:00
                ssid VLAN_Test_AP
                type AP
                channel 1 (2412 MHz), width: 20 MHz (no HT), center1: 2412 MHz
                txpower 20.00 dBm
                multicast TXQ:
                        qsz-byt qsz-pkt flows   drops   marks   overlmt hashcol tx-bytes        tx-packets
                        0       0       33      0       0       0       0       3868            33

# iw dev wlan0.10 station dump
Station 02:00:00:00:01:00 (on wlan0.10)
        authorized:     yes
        authenticated:  yes
        associated:     yes
        preamble:       short
        WMM/WME:        no
        MFP:            no
        TDLS peer:      no
        inactive time:  5676 ms
        rx bytes:       3569
        rx packets:     30
        tx bytes:       410
        tx packets:     4
        tx retries:     0
        tx failed:      0
        rx drop misc:   0
        signal:         -30 dBm
        signal avg:     -30 dBm
        tx bitrate:     1.0 MBit/s
        tx duration:    0 us
        rx bitrate:     54.0 MBit/s
        rx duration:    0 us
        DTIM period:    0
        beacon interval:0
        connected time: 238 seconds
        associated at [boottime]:       30.496s
        associated at:  1785761454053 ms
        current time:   1785761692411 ms

# dmesg | grep laza
(this is just a print of this field just before the switch() call)
[   30.489902][  T189] laza: info->attrs[NL80211_ATTR_IFINDEX]: 4
(and yes, it is just one print triggered)

This index 4 is assigned to wlan0, so it will never have iftype == NL80211_IFTYPE_AP_VLAN.
Also the print of wdev->identifier will give 0x1 and not 0x2.

So, is it even possible that `case NL80211_IFTYPE_AP_VLAN` would match? If it will never match, then
do I understand that the change I proposed should be correct for other cases?

> everything being OK anyway - but then that shouldn't be because of this
> but rather by just removing the AP_VLAN case there, or so.
> 
> Not sure what the best thing would be though.

-- 
Slawomir Stepien
