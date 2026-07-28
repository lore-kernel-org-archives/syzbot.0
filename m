Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C313FB060
	for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 08:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785227778; cv=none; b=OcWpGgc6JqzINLqI4TGfO2JZWz0DVVD1JevOs+CesBS3wtSRk4cQ0RI9Lxt/EbJkUvx+qqbLKzxr07cqvNv82qnH7tIvxKdgmCZtYwdAN+GeTSyHemDYp9T034gI5NLc3COI+faZEqB1JLUWXzNeDw/a3yLqcQcUwCoSvbaMOHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785227778; c=relaxed/simple;
	bh=5PSbJVR0cDfdzWpOQt1jhTwup4uTYmSZAD/f6e1fwAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lFY99n6xbSUfNcv/6QZjti66SjPcwgq4JaYoXB4yVyij6uc1Vw7X6sDIlEKKKPZ97Pd9blG3iXleDYSsPenjINnLV9FK2qQgN7quxqO2SiMIUbTX6Yyl7q/VM24MXKIdGZPlOQ0KvwUT3gudNULJ7WF1yglPvsfAytC7ymlP6qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U69PAjDg; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U69PAjDg"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4955de8797cso22485715e9.3
        for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 01:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785227771; x=1785832571; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ez0SqqLJj7JSz8/qLiUmEpNJBu1y8F4e5nAxaEOZ2gU=;
        b=U69PAjDg9MKHR4+w31OsHK0g4PWwkcOKovU2PwTrF8+mI+2Dk/6DMQCu+CGI+EqWQr
         2+kN25KBdeleLEtlUyI6YNftZVfMzh8BBdsSXy0NvYBiH45dP6o+QaG3tqVBFoAw3C4E
         56YqWTXI41n6PU+sHJ4c24jPcP5LqdK3aSyhTbOM1p/Eo8jMFI2aCkP3k182K0KbsAGJ
         PmUPA4k5o6jHzyGT0zKIarAvucoopvb55eiW3BgCDihjQgXEgntNI80kovLCQmvdtBIE
         2SbqfVqAaR0GEp/QIBSZLT4JukqBgk1AgbM2YCXI4tOsz87GR/JtlpSvg6AgV2Tw2gp0
         BqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785227771; x=1785832571;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ez0SqqLJj7JSz8/qLiUmEpNJBu1y8F4e5nAxaEOZ2gU=;
        b=DqvSxeRdvtIhNOdaC7umpfMRuy4saOyMHu1Jm6VHMlvnzt3RC/WYJiyc7HqGMkDH5Y
         YIWMPHYMYlWyJSXhiNPFbQ9sh15GKCNNwYjKY4o7n8ZNPxRPAdJ0yxI+Yij2nH3kYgRf
         GOu8WZTK1MzMABHz8soY6SjdeX3Jek5k4JD+LzORjQBo+gqsUDvqEIeTjRJXAbgL9Ef5
         RtXLdFLYHF966IPVH9GYW3xVECpq9k1tJVorIPBPzXNpTQILYKylJUiSDtVE+nHbq8nM
         Uxu3NpIchGAJo+mEU4O7tyAu7w2/pJGW3LRUASnXTduiyuKrs2t3t9dy5d+Pg1L3gVax
         lSvA==
X-Gm-Message-State: AOJu0YwYAKOFCb2Jic9a2Rax988X80U03U7+vxRAc3YpVEaHxS9AjHnC
	mt07cFKl8y436OVtHwOfWAHJcMeLgnxqW7lmuj/I/pOHLiBVUgMInRkg
X-Gm-Gg: AR+sD13Gq5LHTqn7I8aQzE6glhviwZ5N86FgbXI2kn9tXQVQoEG6vrIpzuqhGCVtvVH
	djvHuC53+d/ygfV4B642fHD/AUQsIwA0nE+m3XrdV8yTj4TmaM1gqSu7hjiOw9vrUeF3uRGiDt5
	vAfpaKSvdp7KZHtKAL184Xaa/X7673n8BnvQVLXL7SzJQ4lc6Cdth48Mb/mlsod4DbSzJe/8bif
	VEF3y5x5702Danju81M9mC3of9Ttr5p7jglCLkbC9MmZ3jTKwnL9ERGCRgzZ4PmZqjkHfv8yM+R
	Ty937LdUjOmxUa1JVNuXca5juxSNnqCFJMBJgUQ78I+pYx4yC8q3aKjuSFK2oAcJ2nMRR4vIS29
	R2V2lDH2mPpuACqrtzrs4gKDZf1OE6s5FqfbXKJ1AxXaA6I+qBHL8FUcqnXRNVuH5Fyw/K1UPAx
	iGBnhK7/U8jFkx6PA2Yjf9HADBln3DjwQtw6hMdGCMr0jsWkFbw4VSpFHxmttGbR2CEZzUasB5F
	k+k4X95oeU0QHLnCIs5l/Cyh/cgbOrlS+TU/hyKLvooluxvEBdsZN/uY/3vpBOu/V5UIVbM
X-Received: by 2002:a05:600c:46c4:b0:493:bd2a:93be with SMTP id 5b1f17b1804b1-496c653e0d2mr14829535e9.6.1785227770991;
        Tue, 28 Jul 2026 01:36:10 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c45cbd09sm54397785e9.10.2026.07.28.01.36.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 01:36:10 -0700 (PDT)
Message-ID: <00a5b5be-74c3-4666-90e5-b331d3090272@gmail.com>
Date: Tue, 28 Jul 2026 10:36:10 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] ipvlan: keep lower device alive until private
 destruction
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <07edf3e0-84dd-47b0-8203-e0b8f3b9d5b5@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <07edf3e0-84dd-47b0-8203-e0b8f3b9d5b5@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 7/19/2026 2:49 PM, syzbot wrote:
> Commit 40b9d1ab63f5 ("ipvlan: hold lower dev to avoid possible
> use-after-free") added a reference to the lower net_device owned by struct
> ipvl_port. However, this reference is released when the last
> ipvlan_uninit() reduces port->count to zero and calls
> ipvlan_port_destroy(), which can happen before all outstanding external
> references to the ipvlan netdev have drained.
>
> Specifically, RXE acts as an asynchronous owner in this scenario. RXE
> queues RDMA device removal on NETDEV_UNREGISTER, meaning it can retain a
> reference to the ipvlan netdev after ndo_uninit has completed. This allows
> a later SMC port query to reach the ipvlan device and access its phy_dev.
>
> This leads to the following sequence:
> 1. The shared ipvl_port owns the reference to the lower net_device
> (phy_dev).
> 2. The last ipvlan_uninit() drops this reference by calling
> ipvlan_port_destroy() when port->count reaches zero.
> 3. RXE retains a reference to the ipvlan netdev, keeping it alive.
> 4. The lower net_device's refcount drops to 1 and it is freed by
> netdev_run_todo(), leaving ipvlan->phy_dev as a dangling pointer. A
> subsequent SMC port query accesses this dangling pointer, triggering a
> use-after-free.
> 5. A new per-device hold keeps phy_dev alive until ipvlan_dev_free() runs.
>
> The KASAN report illustrates this use-after-free:
>
> BUG: KASAN: slab-use-after-free in netdev_need_ops_lock
> include/net/netdev_lock.h:30 [inline]
> BUG: KASAN: slab-use-after-free in netdev_lock_ops
> include/net/netdev_lock.h:41 [inline]
> BUG: KASAN: slab-use-after-free in __ethtool_get_link_ksettings+0x230/0x250
> net/ethtool/ioctl.c:463
> Read of size 1 at addr ffff8881988dae09 by task kworker/1:3/1289
>
> Call Trace:
>   <TASK>
>    __ethtool_get_link_ksettings+0x230/0x250 net/ethtool/ioctl.c:463
>    __ethtool_get_link_ksettings+0x11f/0x250 net/ethtool/ioctl.c:464
>    ib_get_eth_speed+0x180/0x7f0 drivers/infiniband/core/verbs.c:2052
>    rxe_query_port+0x93/0x3d0 drivers/infiniband/sw/rxe/rxe_verbs.c:56
>    __ib_query_port drivers/infiniband/core/device.c:2129 [inline]
>    ib_query_port+0x16e/0x830 drivers/infiniband/core/device.c:2161
>    smc_ib_remember_port_attr net/smc/smc_ib.c:364 [inline]
>    smc_ib_port_event_work+0x147/0x920 net/smc/smc_ib.c:388
>   </TASK>
>
> Fix this by holding a reference to the lower net_device using a
> netdevice_tracker in struct ipvl_dev. The reference is acquired in
> ipvlan_init() and released in the priv_destructor callback
> (ipvlan_dev_free()). Releasing the reference in ipvlan_dev_free()
> guarantees that the lower net_device is held until outstanding external
> references to the ipvlan netdev have drained and before final private
> teardown and object release. This mirrors the behavior of other stacked
> devices like macvlan and vlan, and safely covers ipvtap devices as well.
>
> Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5fe14f2ff4ccbace9a26
> Link: https://syzkaller.appspot.com/ai_job?id=3e3edd19-4e52-49d3-bfdb-ebdde1bda5c3
> To: "Andrew Lunn" <andrew+netdev@lunn.ch>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> Cc: "Dmitry Skorodumov" <dskr99@gmail.com>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v3:
> - Updated the commit description to correct the explanation of the lower-device reference release and the role of RXE.
>
> v2:
> - Updated the patch subject to "ipvlan: keep lower device alive until private destruction"
> - Rewrote the commit message to clarify that commit 40b9d1ab63f5 added a lower-device reference owned by struct ipvl_port
> - Described the lower device generically as a lower net_device
> - Replaced the full KASAN report with only the relevant call chain
> - Corrected the description of priv_destructor
> https://lore.kernel.org/all/7d8162e1-a546-40b8-b9ea-7c0e164ef8e8@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/e66f374b-905f-471b-989e-60a3e0505873@mail.kernel.org/T/
> ---
> diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
> index 80f84fc87..13cdad002 100644
> --- a/drivers/net/ipvlan/ipvlan.h
> +++ b/drivers/net/ipvlan/ipvlan.h
> @@ -64,6 +64,7 @@ struct ipvl_dev {
>   	struct list_head	pnode;
>   	struct ipvl_port	*port;
>   	struct net_device	*phy_dev;
> +	netdevice_tracker dev_tracker;
>   	struct list_head	addrs;
>   	struct ipvl_pcpu_stats	__percpu *pcpu_stats;
>   	DECLARE_BITMAP(mac_filters, IPVLAN_MAC_FILTER_SIZE);
> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index ed46439a9..b1435296a 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -162,6 +162,9 @@ static int ipvlan_init(struct net_device *dev)
>   	}
>   	port = ipvlan_port_get_rtnl(phy_dev);
>   	port->count += 1;
> +
> +	netdev_hold(phy_dev, &ipvlan->dev_tracker, GFP_KERNEL);
> +
>   	return 0;
>   }
>   
> @@ -673,6 +676,13 @@ void ipvlan_link_delete(struct net_device *dev, struct list_head *head)
>   }
>   EXPORT_SYMBOL_GPL(ipvlan_link_delete);
>   
> +static void ipvlan_dev_free(struct net_device *dev)
> +{
> +	struct ipvl_dev *ipvlan = netdev_priv(dev);
> +
> +	netdev_put(ipvlan->phy_dev, &ipvlan->dev_tracker);
> +}
> +
>   void ipvlan_link_setup(struct net_device *dev)
>   {
>   	ether_setup(dev);
> @@ -682,6 +692,7 @@ void ipvlan_link_setup(struct net_device *dev)
>   	dev->priv_flags |= IFF_UNICAST_FLT | IFF_NO_QUEUE;
>   	dev->netdev_ops = &ipvlan_netdev_ops;
>   	dev->needs_free_netdev = true;
> +	dev->priv_destructor = ipvlan_dev_free;
>   	dev->header_ops = &ipvlan_header_ops;
>   	dev->ethtool_ops = &ipvlan_ethtool_ops;
>   }
>
>
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
