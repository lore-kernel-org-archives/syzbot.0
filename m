Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D017BA2
	for <syzbot@lists.linux.dev>; Sun, 19 Jul 2026 09:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784452859; cv=none; b=RSJk2FlzDyV0IxAlYrCsIvt03oYQlRK3PfoaTi+juwbeXakfkxI/8VYVcDgEtmFm3jBd5d3eYDk/ozUUd9uIBkMwIKi7+GGgOholElpPk0hrl619dp+fxSBm/M/CWb78/RhXTv0amg5QO8UW8cQXj0ptSkKcpFnh7Z//tqxaoKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784452859; c=relaxed/simple;
	bh=e6m1LGswlDTKtwI66jPxPV7iKLokXHDGSj4bz/rJQTI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=av1q/xvQecZ8WEF4inutEg8Q5evcXVmXyatH5AspcXlXJog+Jzj9QkllfjxbOygtYHcRmhJihKpa8xFBZUkNLqnasMrypJNxUr63RqBSzu2W4ntFxyWf1yhXrag/6ngJujQn0sXPBKypgE8kIPVUO4knS3bTjodtj18Jjz4X1JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jmide8+G; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jmide8+G"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aeae771c49so10629611e87.3
        for <syzbot@lists.linux.dev>; Sun, 19 Jul 2026 02:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784452855; x=1785057655; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C7uDv0a3Sq6g02w6r7XjkyS8y2h10JMwbv91mU+15V4=;
        b=Jmide8+GIAL2DA+UL2GiH80dBiBlD446VigsgQ8mZisEbyf/jqoyWrMfadkdVhNE3r
         NRuEyoAlhfvLjnwRH9c2TdT8lm6nVfH+ctaiC66H2lRddhqqUlom+piE5UB7aNNaxcsq
         HGk61MC6usmJh6mfeaBzeIwqmeqkqIbmrt7Vz8A1tsy3a7BAV5rVIyqQyV8Eoty7p0Kk
         tVhJfSG2pSCxp3ChVIJbfB99qT2Jr4MQq4wB3FAPNpjIJjPH0sK9kknNZop/vny85pTq
         SUUaX3DCrp3k/JrAigU6TZJyeCE1b40xrH6J1Oiv0EImtvX24CN0c8xv3HX+cM1Ojtww
         CWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784452855; x=1785057655;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C7uDv0a3Sq6g02w6r7XjkyS8y2h10JMwbv91mU+15V4=;
        b=c0rGmMJq3cVkCo8phL47+rBevodJuDqJoSENhKNNmjDAXceyRVUKEHQ/95DSIy38fp
         IUSu6ctP4BQ/kEXMDvVPzL7egFEY9VX4RUULTMBmpJaxsjbrBZWWdaBfq/pBCbeOVVb/
         eJzK70N0ZrQxyE9XzLzcA+sKFyAuZ7ofRn3EHxIB0jeAOdszJW4MFT5MVsjWwUlCxygc
         Uvy3DJjKYS1OajGpfI7NMPfmvkBmkMzYDOgLEBL+x4LQb99jWmqz+INe5I1qM+9mzoz0
         KnLIHhqsy5PLPdyZuApVYe2moCa7cVgX9IYp4HtoTDDJfLgu/lSmo1lWtKMzDrCLUB6S
         pTmg==
X-Gm-Message-State: AOJu0YwHi4rzc1id0Ok16ClHE/SLiXnyr42XMF5053A3a/TAKj/Zwswp
	93ZE8R6A/4OvCfUUt5LGXsbPAUXaqUxX0VQnt1V/7Rs5U+DbVlugIukr9szBedwcWKU=
X-Gm-Gg: AfdE7cnTp4xxOmoihFwhdtNs+s/nyBEjLbucr7y6g/M8oK5CAUM6G1PZiavU9xWQJnv
	chXGLUxBGOzvRyNHRX9F9xLsIptsPFiNpdSuSm/BMpif1bbQ9hhBZcdLIguuu+fvMjmWmlidXUY
	rxJeEQRust2cjTop1/bGeQlnOptRI2f6313THz2bSRCkWEcCeLgsjDb3xlXjHcDk1ZIwdRvWPTc
	HkqSrXkBiyduSnw1Um30M0GclIL746kn/MWunjUEYer/VthULjZmGsGmNld7XX/Kcu3zAbriLSi
	L1FjV879h37UdM5bH4/AO5DdlfjECuRyYMF/KJMW1mD8C3kxXaRwW6iiSEruqqxzqZfje4MPtBv
	Ffb6Kz2U+tabDX72WXlpTuZTSRdiT9ELIIsbnkH25zL9cRHK2RygNsmsA33Yw8gNfP0zZfMagDS
	aGO/WZqMiJropfJcK+UbiKdgOAT2uNwbymZ1/bPxmWQevyNQwOMD9Ix6qA8CrPQDBUT0xus2eVY
	k1hzmVRBHM3vFPUl9xYQZhtqsklAy2rSsc8iTb/3qais44yBnFLnrAv2osZEUhYkhCuaDSN
X-Received: by 2002:a05:6512:688c:10b0:5ae:b952:6c with SMTP id 2adb3069b0e04-5b28f858617mr1234056e87.13.1784452855218;
        Sun, 19 Jul 2026 02:20:55 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b291d8a490sm1654258e87.16.2026.07.19.02.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 02:20:54 -0700 (PDT)
Message-ID: <b5c7b21f-73c6-4400-95d0-0dd7201b2177@gmail.com>
Date: Sun, 19 Jul 2026 11:20:53 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] ipvlan: hold reference to lower device to prevent
 use-after-free
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <e66f374b-905f-471b-989e-60a3e0505873@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <e66f374b-905f-471b-989e-60a3e0505873@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The code change itself looks correct. Please send a revised version that 
changes only the subject and commit message. Keep the code diff unchanged.

Use this subject:

ipvlan: keep lower device alive until private destruction

The current description incorrectly states that ipvlan does not hold any 
reference to its lower device. Commit 40b9d1ab63f5 ("ipvlan: hold lower 
dev to avoid possible use-after-free") added a lower-device reference 
owned by the shared struct ipvl_port.

The actual problem is that the last ipvlan_uninit() destroys the shared 
port and releases that reference while an individual ipvlan netdev can 
remain alive because RXE still holds a reference to it.

Describe the lower device generically as a lower net_device. Do not 
assume that it is always a veth device.

Replace the full KASAN report with only the relevant call chain:

   smc_ib_port_event_work()
     ib_query_port()
       rxe_query_port()
         ib_get_eth_speed()
           ipvlan_ethtool_get_link_ksettings()

Do not describe priv_destructor as the absolute end of the netdev 
lifetime. It runs after outstanding references to the ipvlan netdev have 
drained and before its final private teardown completes.

Please use a commit message close to the following:

Commit 40b9d1ab63f5 ("ipvlan: hold lower dev to avoid possible
use-after-free") added a lower-device reference owned by struct ipvl_port.
The last ipvlan_uninit() destroys that shared port and drops the reference,
but an individual ipvlan netdev can remain alive after ndo_uninit while RXE
still holds a reference to it.

This can happen when a lower net_device, an ipvlan device, and an RXE
device are stacked. RXE queues asynchronous removal on NETDEV_UNREGISTER,
so the ipvlan netdev can still have outstanding references while the lower
device reaches final cleanup in netdev_run_todo(). Once the port reference
is dropped, ipvlan->phy_dev can point to the released lower net_device.

A later port query reaches the stale pointer through:

   smc_ib_port_event_work()
     ib_query_port()
       rxe_query_port()
         ib_get_eth_speed()
           ipvlan_ethtool_get_link_ksettings()

The existing code change gives each struct ipvl_dev its own tracked
reference to phy_dev. It takes the reference at the successful end of
ipvlan_init() and releases it from ipvlan_dev_free() after outstanding
references to the ipvlan netdev have drained. This follows the lifetime
model used by macvlan and 802.1Q VLAN and also covers ipvtap.

Keep the existing code diff, Fixes, Reported-by, Closes, Link, recipient,
and base-commit information unchanged.

Please test the patch with the supplied reproducer using KASAN and
CONFIG_NET_DEV_REFCNT_TRACKER=y.

On 7/9/2026 3:44 PM, syzbot wrote:
> The ipvlan driver does not hold a reference to its lower device (phy_dev),
> allowing the lower device to be freed while the ipvlan device is still
> alive and being accessed.
>
> If a stacked network device configuration is created (e.g., a veth device
> as the lower device, an ipvlan device on top, and an rxe device on top of
> ipvlan), the rxe device holds a reference to the ipvlan device. When the
> veth device is unregistered, the ipvlan driver receives a NETDEV_UNREGISTER
> event and unregisters the ipvlan device. This triggers a NETDEV_UNREGISTER
> event for the ipvlan device, which is caught by the rxe driver, queuing
> asynchronous work to unregister the rxe device and drop its reference to
> the ipvlan device.
>
> During this process, netdev_run_todo() waits for the refcounts of both veth
> and ipvlan devices to drop to 1. Since the ipvlan device's refcount is
> elevated by the pending rxe unregistration, it is kept alive. However,
> because ipvlan does not hold a reference to its lower veth device, the veth
> device's refcount drops to 1, and netdev_run_todo() proceeds to free it.
> This leaves ipvlan->phy_dev as a dangling pointer.
>
> If an operation (like querying port attributes via ethtool) is performed on
> the ipvlan device while it is still alive, it can access the freed lower
> device, triggering a use-after-free:
>
> BUG: KASAN: slab-use-after-free in netdev_need_ops_lock
> include/net/netdev_lock.h:30 [inline]
> BUG: KASAN: slab-use-after-free in netdev_lock_ops
> include/net/netdev_lock.h:41 [inline]
> BUG: KASAN: slab-use-after-free in __ethtool_get_link_ksettings+0x230/0x250
> net/ethtool/ioctl.c:463
> Read of size 1 at addr ffff888118fece09 by task kworker/0:2/919
>
> Call Trace:
>   <TASK>
>   netdev_need_ops_lock include/net/netdev_lock.h:30 [inline]
>   netdev_lock_ops include/net/netdev_lock.h:41 [inline]
>   __ethtool_get_link_ksettings+0x230/0x250 net/ethtool/ioctl.c:463
>   __ethtool_get_link_ksettings+0x11f/0x250 net/ethtool/ioctl.c:464
>   ib_get_eth_speed+0x180/0x7f0 drivers/infiniband/core/verbs.c:2052
>   rxe_query_port+0x93/0x3d0 drivers/infiniband/sw/rxe/rxe_verbs.c:56
>   __ib_query_port drivers/infiniband/core/device.c:2129 [inline]
>   ib_query_port+0x16e/0x830 drivers/infiniband/core/device.c:2161
>   smc_ib_remember_port_attr net/smc/smc_ib.c:364 [inline]
>   smc_ib_port_event_work+0x147/0x920 net/smc/smc_ib.c:388
>   ...
>   </TASK>
>
> Fix this by holding a reference to the lower device using a
> netdevice_tracker in struct ipvl_dev. The reference is acquired in
> ipvlan_init() and released in a new priv_destructor callback
> (ipvlan_dev_free). Releasing the reference in priv_destructor guarantees
> that the lower device is held until the absolute end of the ipvlan device's
> lifetime, after netdev_run_todo() has finished waiting for the ipvlan
> device's refcount to drop to 1. This mirrors the behavior of other stacked
> devices like macvlan and vlan, and safely covers ipvtap devices as well.
>
> Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5fe14f2ff4ccbace9a26
> Link: https://syzkaller.appspot.com/ai_job?id=43c4fc37-40e6-4515-8ae6-40bdb52bb303
> To: "Andrew Lunn" <andrew+netdev@lunn.ch>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> Cc: "Dmitry Skorodumov" <dskr99@gmail.com>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Stanislav Fomichev" <sdf@fomichev.me>
>
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
