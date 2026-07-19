Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156D2346ACD
	for <syzbot@lists.linux.dev>; Sun, 19 Jul 2026 12:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784462978; cv=none; b=HiOXKGqRyVZZzA/TewsYZYxOiwOm9HxscephY91g0AlhmZCUWyjS7AbYQHct3MsZGxSTvIgV30QSCbSxmeeOTwYwvmnI9aE6Rggc9la+zwLTDfKHdfRQwnkXsPOgE/zOsZbygUYBZONs/SidaH98sn1c4hX1f7Rqac6U/zcpETA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784462978; c=relaxed/simple;
	bh=7VrOyimPzWLk0SYXWHCVVescv/LT2FB9qT9gp4uLLQo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nSRwOJ+SvdJJeRBjbzbzziTsVvjVNb109xpVhCmWnH3Pp0RQ7W8YWLkxkLFDJY0sBgYP4K5hutyniBvHkMbnhv+HW4D/WgG1fqtGBukB8xxoZ0bn9DUou6yUAgEoSRM2NqKha99kAPKasFouQUSHqtfCbU/AAo7oC9T7+SL4Fsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MNhPzXKT; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MNhPzXKT"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39c62764c7cso24310111fa.0
        for <syzbot@lists.linux.dev>; Sun, 19 Jul 2026 05:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784462975; x=1785067775; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=If/3NttIdeF9uV1/s5gNt0cAJEUGB9b8zFi6Gi5A9Fo=;
        b=MNhPzXKTpdpo1qaGF8WPsUYWxfozOU8wUKQEQFyCPnjcYElWKz/cXusBHyVq9V/b1T
         xoIN/eGa4WMA53BzYyQoM4aML9XiEssR6rwRbtUf3HglBe3VouvtJJLDUZ2QbrTVW41x
         p1E/roEthD0P3+JSD5PTrrU1b2RCjqvi0++zlPCDuJQSuBI/7Nz+JEqMEABAwff9LMlC
         JVh8f71tSBv9vD/1Wou4kGt4CqdYI7L8JDMhP5k1NkRz54z9kQWYu1BbiYlBDSm3CUsT
         jdACbv8Ai6LG9vBY9qzlp+dg1uMMtcjrYOOiea9cjplskd5mQm6cxK9OOBes2oOxDajP
         kybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784462975; x=1785067775;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=If/3NttIdeF9uV1/s5gNt0cAJEUGB9b8zFi6Gi5A9Fo=;
        b=KHc/uqOXx2xs6b9YULCZH4F/YNfMd9iTaHV9xKy/IFZ3kuCGendWw28nGHWbhZ/c1i
         pt/JZEM3xrjzwPzp3pTEOkpvPuGuWWAceU4U7hY6BTjpObgLjeNuyaSzuUit8M9Nmb/3
         Rx7GRvo9det8CtGKBviqH/AYWybuHA49hvDNIHdyDPreQFnONrUvHzfaaln/grBb0gfG
         lfmSbVPrNsfYOzedFqdwWpokQ85p53Ln5dIZ9tOYLK44Gjmn4R6CYFU+NQFu+N4uz8NE
         RZL5pxQNZ+NkcU6NrfdTHWQlfxNwhtGbBvPChQaK3fBz1VHsRCJd2XxUwun6cZljUuzw
         Omrg==
X-Gm-Message-State: AOJu0Yx1a5v4eebzvNKwoc+c2SruxLdvqy+7A4DLmBho0EUzbgSlyOII
	8UUI+MUjFbNB30duOOnka4TLy+mTm203zBVUXZKSg7bv7pR8IvbNaPRB
X-Gm-Gg: AfdE7cnfDrZUYF8OqfLXBBcd3pTbmIpCO/OdPXrFgpvoyYOqyGsvxvDE9D30HULsWqV
	rGrmViwQWJsZbth5FBqwg7CxTPLcPNh36fSC3+/N9jqARRIOFjf2+AUYam+yMUBbCMO/T8nec7M
	VnCuTwFakHPmdjzIU0YCN4WUxZUhlMr7rOYp2A7+CSnovX8IawacW2m4oSbKrndJfw3uYLM/Jda
	YamP3BotjbayfdRiJurfXzzksC6LBbQShyhs7t55iKB0DqEFcTMjQXb5Wzf2507+/Jkdsr4vBVK
	nRABB4+wN/7PKaTgHJuUU9FN73ZlcI79atn929WkfBsBesv9ngHO56n6AeeD7NmtMAAgmz3y5vI
	zy623d2MuvTwdsJ8fpwV4eSrpgnvnuz0gpMfnjXe8a4CJYhOGDAr22zq1fhvz4vtc1pylwE1gmI
	XZSJ0jj9jyQ8P6HeUrATGHJrZTK/VqB+YWu0WYI/mL/vS1zh2UUsJOFyhKy72ynGcAZh3qsjpnl
	r+1ftJyJAZE3tvot/yd5swDSP5ftWIOE66vulvJnmbqjfduN/IsRKNGt3uQ5EVi5rRCochC
X-Received: by 2002:a05:6512:3b82:b0:5ae:b7c1:f7a with SMTP id 2adb3069b0e04-5b2904966a0mr1846320e87.30.1784462974832;
        Sun, 19 Jul 2026 05:09:34 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b291e18a04sm1724051e87.55.2026.07.19.05.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 05:09:34 -0700 (PDT)
Message-ID: <5092566d-d97f-42eb-ab89-81cacc946c69@gmail.com>
Date: Sun, 19 Jul 2026 14:09:32 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] ipvlan: keep lower device alive until private
 destruction
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <7d8162e1-a546-40b8-b9ea-7c0e164ef8e8@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <7d8162e1-a546-40b8-b9ea-7c0e164ef8e8@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Please generate a message-only v3 for syzbot issue 5fe14f2ff4ccbace9a26, 
based on AI patch v2 from job ecee4f7f-c35a-40b5-85ed-47bebd5cb0d1 and 
kernel commit 8cdeaa50eae8dad34885515f62559ee83e7e8dda.

Keep the code diff unchanged. The implementation correctly gives each 
struct ipvl_dev its own tracked reference to phy_dev, takes it at the 
successful end of ipvlan_init(), and releases it from the 
ipvlan_dev_free() private destructor. This also covers ipvtap. Keep the 
current subject and all existing tags unchanged:

ipvlan: keep lower device alive until private destruction

The v2 commit message still contains two incorrect lifetime statements.

First, do not say that the lower-device reference owned by struct 
ipvl_port is released whenever an ipvlan device is unregistered. The 
port is shared. Its reference is released when the last ipvlan_uninit() 
reduces port->count to zero and calls ipvlan_port_destroy(). An 
individual ipvlan netdev can remain alive after that ndo_uninit because 
RXE still owns a reference to it.

Second, do not say that ipvlan_dev_free() runs after the ipvlan netdev 
has been freed or after its reference count reaches zero. 
netdev_run_todo() waits until netdev_refcnt_read(dev) is 1, invokes 
priv_destructor, and only then performs the final kobject_put(). State 
that ipvlan_dev_free() runs after outstanding external references to the 
ipvlan netdev have drained and before final private teardown and object 
release.

Describe RXE explicitly as the asynchronous owner involved in this 
report. RXE queues RDMA device removal on NETDEV_UNREGISTER, so it can 
retain the ipvlan netdev after ndo_uninit. A later SMC port query can 
still reach ipvlan->phy_dev through ib_query_port(), rxe_query_port(), 
ib_get_eth_speed(), and ipvlan_ethtool_get_link_ksettings().

The revised explanation should make this sequence clear:

1. The shared struct ipvl_port owns one reference to the lower net_device.
2. The last ipvlan_uninit() destroys the shared port and drops that 
reference.
3. RXE can still retain the individual ipvlan netdev while its queued 
unregister work is pending.
4. Without a per-ipvlan reference, phy_dev can point to a lower netdev 
that has reached final release.
5. The new per-device hold keeps phy_dev alive until external references 
to the ipvlan netdev drain and ipvlan_dev_free() drops the hold before 
final object release.

Return the complete replacement patch email, including the unchanged 
diff. Do not introduce code changes or unrelated cleanup. Verify the 
destructor ordering against netdev_run_todo() before describing it in 
the commit message.

On 7/19/2026 12:28 PM, syzbot wrote:
> Commit 40b9d1ab63f5 ("ipvlan: hold lower dev to avoid possible
> use-after-free") added a reference to the lower net_device owned by struct
> ipvl_port. However, this reference is released when the ipvlan device is
> unregistered, which can happen before the ipvlan device is actually freed.
>
> If a stacked network device configuration is created (e.g., a lower
> net_device, an ipvlan device on top, and another device on top of ipvlan),
> the upper device holds a reference to the ipvlan device. When the lower
> net_device is unregistered, the ipvlan device is unregistered as well. This
> triggers unregistration of the upper device, which queues asynchronous work
> to drop its reference to the ipvlan device.
>
> During this process, netdev_run_todo() waits for the refcounts of both the
> lower net_device and the ipvlan device to drop to 1. Since the ipvlan
> device's refcount is elevated by the pending upper device unregistration,
> it is kept alive. However, because the lower net_device's reference held by
> the ipvlan port is released during unregistration, the lower net_device's
> refcount drops to 1, and netdev_run_todo() proceeds to free it. This leaves
> ipvlan->phy_dev as a dangling pointer.
>
> If an operation (like querying port attributes via ethtool) is performed on
> the ipvlan device while it is still alive, it can access the freed lower
> net_device, triggering a use-after-free:
>
> Call Trace:
>   <TASK>
>    netdev_need_ops_lock include/net/netdev_lock.h:30 [inline]
>    netdev_lock_ops include/net/netdev_lock.h:41 [inline]
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
> (ipvlan_dev_free). Releasing the reference in priv_destructor guarantees
> that the lower net_device is held until the ipvlan device is actually
> freed, after its refcount has dropped to 0. This mirrors the behavior of
> other stacked devices like macvlan and vlan, and safely covers ipvtap
> devices as well.
>
> Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5fe14f2ff4ccbace9a26
> Link: https://syzkaller.appspot.com/ai_job?id=ecee4f7f-c35a-40b5-85ed-47bebd5cb0d1
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
> v2:
> - Updated the patch subject to "ipvlan: keep lower device alive until private destruction"
> - Rewrote the commit message to clarify that commit 40b9d1ab63f5 added a lower-device reference owned by struct ipvl_port
> - Described the lower device generically as a lower net_device
> - Replaced the full KASAN report with only the relevant call chain
> - Corrected the description of priv_destructor
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
