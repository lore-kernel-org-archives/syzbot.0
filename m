Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E67A36B076
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 14:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773326098; cv=none; b=W4uqrNTj/Vhy2PSwdMTES0cBk66qb1KkSpQ2LKA9hweI829aFCuF5NG8UsLBC5Ih7RQyiajtVQqKsPoR22gbem0D/H/39XP06nJsPBJA3o7/6HM1jOkUNCsAum0TX+WM4/4uh5iTpHsSx0LHO20UDionbxpTcMVxpXXrfYEQF0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773326098; c=relaxed/simple;
	bh=6JtGac83PpZLOkb7JoNXF61Pp3hiImbveoEHI06tr0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aClEbVDGhEf+/ZDpg/UiGRswJ0c3H7dxjAksiZKKsfApz7+9mZSJx6J4Eo8wh1GVFGFuNQiDFwYhqGKAgT7dTTBCCv5mkYK12fSQrmbYYpkKm1mS/ABEZdO2Qgbmrm1vHyDZjV5PYE5LK4rorAxgXeM+E2L82efzJ97SNg0jWys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bePjBPIp; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bePjBPIp"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ae4e538abdso12708385ad.3
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 07:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773326095; x=1773930895; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Xo4CEzPoRnsxcWTwpZVwHi/yVVw3KlTALyiUcwtez0=;
        b=bePjBPIpnPrxs6v7/XitjJjAaKuJQl+oa3y3PYHa+FkMK1IMh9sNpeToOvVxn0BlD6
         +tcojv+/BDnanOvYt6q9vMZuIaThT3Cjp/kNPldYhkfycjacTCNsg34FtK8gNgnavr8f
         vPelIIeHKHL6uSo8O0cfxVp1W9HiyiaFf1JU1KOkKChZ28HKyRoEsMxSusUsbAN7LkJT
         2SIiM2nZIu3iZndhj7fN+8ScC6UGLWe6F72GPGgAbNOBWm9XaR/3UdVZwgJfVQ9F9bYz
         hPUPwTrldrh7uki40KZ73TCLEB1k4P7CU85UadiPwkkLdCUG84/CSyPJW79m4qdsUVTK
         4Tzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773326095; x=1773930895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Xo4CEzPoRnsxcWTwpZVwHi/yVVw3KlTALyiUcwtez0=;
        b=UGRVyr8S0JWMgJHfMtiV6h0jJtfmw/LHvMe3d7Dp5y71U2Y/0hsN5jv4ZkKv0wYxwA
         UNY6mNt4+ykNtlf3mRcIunjBP/37vSC0ZZ8giYl6OKMMaJn5S4W3YF2NJ5ITanA2gGG6
         zKO3mFFX6AbmqoBY/PAumm1ZnLrxqeHsNh5ImvH7hdaenVpUgHNd2Yz34hjzGbVEd/KO
         w8ObU/d8/oX+jQrP2KX4wwMdeo+m4Hm9kgHvofM4Yi4PQRUV7Q8qMbcu10fEgeei8GMh
         hLAwStxI7+m53XwMEF7Fn8E+UpvdDyOUHaSso6JSQatQiUqjkS71uVstWDDKySl2ZDf5
         Valw==
X-Forwarded-Encrypted: i=1; AJvYcCWnUK8nlcABEMFGcbSsh3Ua6UsXAmVumeskaRoCy5JQ8aZwz1yuFaV7Q2lE8uSAu/tFT1WVN2c=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBy9+vTqdu4lgRO9sc2Bf4PSYfz0bZO7I+Ghp+yQZQ/e8tiqiS
	rSZa8J3mE7TJU2gzHQ5u6SET9zTvN3h4gN/XsKPu5HwjU8tg76MhvSKz
X-Gm-Gg: ATEYQzx5yi9cu1kR2uXjIJtaiqQUVgDMjvALP8NBVLmVcPvVBccNxWPcinwW6V8JESb
	UaT4diN2U4ZPBzlrInxWxahiPLrKEBk/8YjcqCmZPvjZXJucBzki3SaYROX/+SDHBTZJe4gOmJ1
	ClnBd3DmeIms8kIO7o3gNfsN4H7Fk0my7Q4Qzv/DPS8obGx8Apmu/8sx8Z5iBsq9/VX4fg16FEh
	5Krhutwiy5C1gPwIg3tWyelhNDIi8H1cBYibqSK9ZnxqAxsF+3nLDP6TumCSI3eMnXC4/xRiXuH
	L4g5O1xkisYmCS5uk/bLa0rqA1IHeeOHfjrPTeeZFsLTGK41wXC2ZIYcc8Tx1Awv7VPNYIgpRGn
	0T0Fd2aYU+KhfnY8PgSnlloJUOrrC3seXd5HnA4f6PeVd4VQ8bTB1BoqKRaECm0XJVhGmtHzI0Y
	HQXMeNy99jfI+ksBm7jcvEne4sjWw=
X-Received: by 2002:a17:902:ffd0:b0:2ae:ac0c:5a29 with SMTP id d9443c01a7336-2aeae7640d3mr64159275ad.10.1773326095542;
        Thu, 12 Mar 2026 07:34:55 -0700 (PDT)
Received: from fedora ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae378980sm58269035ad.84.2026.03.12.07.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 07:34:54 -0700 (PDT)
Date: Thu, 12 Mar 2026 14:34:44 +0000
From: Hangbin Liu <liuhangbin@gmail.com>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Paolo Abeni <pabeni@redhat.com>,
	syzbot ci <syzbot+ci098fa7c1795eceac@syzkaller.appspotmail.com>,
	andrew@lunn.ch, bridge@lists.linux.dev, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, idosch@nvidia.com,
	jiri@resnulli.us, jv@jvosburgh.net, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	razor@blackwall.org, sridhar.samudrala@intel.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: move netdev_compute_master_upper_features
 to ndo_set_features
Message-ID: <abLPBEg_-j5rp4IM@fedora>
References: <20260310-offload_compute-v1-0-3df79c09ea65@gmail.com>
 <69b04e91.a70a0220.51e36.0000.GAE@google.com>
 <abBuLV3P6aTzUg3W@krikkit>
 <abC7rdjxv9ENw-tA@fedora>
 <abHcP3GTO29rfKML@krikkit>
 <bcc536ac-dde1-4b63-8fed-70850818472b@redhat.com>
 <abKf8Fg865Fhipwk@krikkit>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abKf8Fg865Fhipwk@krikkit>

On Thu, Mar 12, 2026 at 12:13:52PM +0100, Sabrina Dubroca wrote:
> > >> This patch calls netdev_change_features() after __netdev_upper_dev_link(),
> > >> Which trigger a NETDEV_FEAT_CHANGE notify and calls rtmsg_ifinfo_event()
> > >> to fill the new link info. Maybe the event is a bit early and macsec has
> > >> data not ready?
> > > 
> > > But this would still mean that there's a mismatch between
> > > if_nlmsg_size() and rtnl_fill_ifinfo(), and your patch is only
> > > revealing it.
> > > 
> > > I'll send fixes for the stuff I mentioned, no idea if that's what
> > > syzbot saw since we don't have a repro.
> > 
> > It looks like even the nipa CI is reproducing the issue, i.e.:
> > 
> > https://netdev-ctrl.bots.linux.dev/logs/vmksft/net-dbg/results/554921/17-rtnetlink-sh/
> > 
> > more failures here:
> > 
> > https://netdev.bots.linux.dev/contest.html?pw-n=0&branch=net-next-2026-03-12--06-00&pw-n=0&pass=0
> > 
> > the fail in mascsec-offload looks quite deterministic, could you please
> > have a look?
> 
> Ah crap, sorry Hangbin, you were right.  macsec_fill_info() returns
> -EMSGSIZE when the key length is unexpected, and at this point we
> haven't set it to its proper value yet.
> 
> Bandaid solution would be:
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index f6cad0746a02..0f7ef7bfbdde 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -4337,7 +4337,7 @@ static int macsec_fill_info(struct sk_buff *skb,
>                 csid = secy->xpn ? MACSEC_CIPHER_ID_GCM_AES_XPN_256 : MACSEC_CIPHER_ID_GCM_AES_256;
>                 break;
>         default:
> -               goto nla_put_failure;
> +               return 0;
>         }
>  
>         if (nla_put_sci(skb, IFLA_MACSEC_SCI, secy->sci,
> 
> 
> Proper fix (so that the notification we're sending during
> upper_dev_link has full linkinfo) would be to move
> netdev_upper_dev_link() to after macsec_changelink_common() and fix up
> the error handling. I don't see anything in macsec_add_dev or
> macsec_changelink_common that needs the device to be linked. But

If we move the netdev_upper_dev_link() after macsec_changelink_common(),
we will not goto nla_put_failure via default, right?

> anyway it doesn't make sense for macsec_fill_info to return -EMSGSIZE
> on invalid data, so the "bandaid" should be included as well.
> 
> Should this be part of this series (either just the "bandaid" or the
> "proper fix"+bandaid), since we never saw a problem before?

Since macsec need the "bandaid" fix either way. How about you post the
"bandaid" fix to net. And I include the "proper fix" in this series for
net-next?

BTW, here is my draft patch, would you like to review it first?

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f6cad0746a02..1f8da4c291c6 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4161,10 +4161,6 @@ static int macsec_newlink(struct net_device *dev,
 	lockdep_set_class(&dev->addr_list_lock,
 			  &macsec_netdev_addr_lock_key);
 
-	err = netdev_upper_dev_link(real_dev, dev, extack);
-	if (err < 0)
-		goto unregister;
-
 	/* need to be already registered so that ->init has run and
 	 * the MAC addr is set
 	 */
@@ -4177,12 +4173,12 @@ static int macsec_newlink(struct net_device *dev,
 
 	if (rx_handler && sci_exists(real_dev, sci)) {
 		err = -EBUSY;
-		goto unlink;
+		goto unregister;
 	}
 
 	err = macsec_add_dev(dev, sci, icv_len);
 	if (err)
-		goto unlink;
+		goto unregister;
 
 	if (data) {
 		err = macsec_changelink_common(dev, data);
@@ -4190,6 +4186,10 @@ static int macsec_newlink(struct net_device *dev,
 			goto del_dev;
 	}
 
+	err = netdev_upper_dev_link(real_dev, dev, extack);
+	if (err < 0)
+		goto unlink;
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
@@ -4200,7 +4200,7 @@ static int macsec_newlink(struct net_device *dev,
 			ctx.secy = &macsec->secy;
 			err = macsec_offload(ops->mdo_add_secy, &ctx);
 			if (err)
-				goto del_dev;
+				goto unlink;
 
 			macsec->insert_tx_tag =
 				macsec_needs_tx_tag(macsec, ops);
@@ -4209,7 +4209,7 @@ static int macsec_newlink(struct net_device *dev,
 
 	err = register_macsec_dev(real_dev, dev);
 	if (err < 0)
-		goto del_dev;
+		goto unlink;
 
 	netdev_update_features(dev);
 	netif_stacked_transfer_operstate(real_dev, dev);
@@ -4219,10 +4219,10 @@ static int macsec_newlink(struct net_device *dev,
 
 	return 0;
 
-del_dev:
-	macsec_del_dev(macsec);
 unlink:
 	netdev_upper_dev_unlink(real_dev, dev);
+del_dev:
+	macsec_del_dev(macsec);
 unregister:
 	unregister_netdevice(dev);
 	return err;

Thanks
Hangbin
