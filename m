Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16594AA016
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365067; cv=none; b=ICuDXJemwQ/v/sMD4BwhFvjf98yHucWJLnIjBrFG79RtsNIZflY5I8JpKsmTknYhwD/2mw80mAl8coJQMJ/Sd/+x0iL6mb8ylv/0+CZSU/0/0egQnBjyutCDgIWQNCDHCwQGnJgl46frb+YmX3uid1BGTrNYkqEYsdzno5+XA70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365067; c=relaxed/simple;
	bh=Nl6cVS9V1CulL27UsFI8XEaH2umQebp228hR8wGUz44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LjB1pDRfe9WUaxL617gPCGgmERMaIQ4mPsQMefkNL/T62wXGdaw4Pr8ZKKAugWnRMcU0/Gi+1QnYY3+GOSadawE6P07VZehydeh52QZrFmthhKyx37i/Suk5DGDs95zfo3sP47rxL5MKvXaljZQx1HRp/judYHGciMA5zQHp36w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fdouZvx3; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fdouZvx3"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2530cabcf4so202206466b.0
        for <syzbot@lists.linux.dev>; Wed, 02 Sep 2026 09:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788365063; x=1788969863; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lNv022dtyMr8TSV7zZGBArAxkb4uJYWIeRmjJBD+xZg=;
        b=fdouZvx3LDBthRGJbkxFcL7mmF0320p7PfcZS7Eml1zsLPdjUBLFcWXRzojdgjq8+G
         BB3lzbaBDTjromZR4Z6WzYtTdzbrpQYQYOKZmKVquRCgmXr5demuo0k0RCrPmP8LXH5e
         CBfF/hRfJxXYU/vlqbgDixwwzDSkBIKCecazKZOAn9/NI82twKGhSsDt2OF73F1oEvV/
         uEPzOCpwM0VcFXu4NPctIetLx08KMTc/ox9mvEcrjVuUoDgZHfcCp7eH9H4+IiY9wBvc
         0j54/5ef3FgS629ISCfyyhhIEUjKUavVbcqpTyrJiHHYdzj7rxateHmgLXM4jCEhnSbc
         Zpsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788365063; x=1788969863;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lNv022dtyMr8TSV7zZGBArAxkb4uJYWIeRmjJBD+xZg=;
        b=rW50al367btkAmTCj5soQsaXcanZkj7GQA2VNcg7+Jm1QBcL6peVEbsJ0bN1t2i7EY
         kXWjs/lfqmCc1GF7EP/J2fr1QvD4EwZf2fnqwHcFDnVopxeJOwJyw0xUDiKHFgDryENc
         0RR/oVSoy3Tq9G5N2yx+oJYDJpqpq6KIGgjwL2Qze9CLLwfNovaTDUDXCAlhuluZ3Je3
         QLmhidemVj3o+l4JoBV6UjhhKJvI2YN18zqAFfqbYbN+u0DYecOhLaAZ7IufL6IXTzMk
         PrEHhkwf51LYecXeQa6Nq37llDyn8wH22cLPfGr3EUWH8f4YT0pv99JVgYCoquLDI7y+
         ol9Q==
X-Gm-Message-State: AFuF++kQgZDUaNJw1qkOlL7ipVwB6uAUbbiBZHfAtg5X2dk1AmdO0fs7
	fkizYbF9QFAut6Gt8vqyku5l4rrp94RWiXuzK91dC54bmwqGmFoSZ7bL
X-Gm-Gg: AYBFou2TB6GbIfbvayK1ssQSe1WJVauOHLz5m+Xwv5M6YrtaxEmcqcBDhee7QpIbR6z
	dhlmPEuLHRfd5T+4ba3mMbQtgbhExmii5ZK8IdtKAOzXiSLxp3QqM4KA169BgAEFHuZ8/En/2qt
	ZWJ2WHWBH3NKMIvnp5KNXUdXI4CFIX2W9mB6eyXS2E4Wb+PzLD9Xm1rXjBaWo9VpSCUn1RQlpVv
	AJ1Fpq7BCnAQwMNRXmpTV3O3TYGLRyVxzELZcoeq071QYBnvsfzrZubMIS/ssIUum+3mSQPE969
	P41Q1UjEUv7dZvPyM8HSpCJpsVZftH+f82DoBh6zTSyvEgB72G9EcbnwZgJRD6sC64YjVlniwyv
	zbQRrO2Mc7cEZPCdD24JlC5UFR8FBb1AWM0szoLmd8Kvd06f5z7fEzAfP74Rhusl6iTip7yD8+y
	3MRsLNsnD6OXYmEV68tupLcJ++BflVSleFBgxmkN0x/E1pmjHFduPzOvMYxnXfTlolL7YLemskf
	IEKUcvfN3LAuE9gWePhmTPGvn4aBH+e3NJ8idN3ELNVl5QSMiWJoYgrFtgKtvQpr3/Yn334LihR
	AwTdDG7YI3I/uzAn8kgNl7biXft18bt5XhqPIJggOx+TVgPEoUaWrvY=
X-Received: by 2002:a17:906:6a03:b0:c24:d6f0:1223 with SMTP id a640c23a62f3a-c25d5474dfdmr343625666b.12.1788365062343;
        Wed, 02 Sep 2026 09:04:22 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c25d041d4a8sm163316766b.54.2026.09.02.09.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 09:04:21 -0700 (PDT)
Message-ID: <768120d6-29c8-487c-adc2-48eaefec9b4a@gmail.com>
Date: Wed, 2 Sep 2026 18:04:20 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] Bluetooth: hci_sysfs: fix null pointer dereference in
 device_move()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <21c8fde7-0caa-4f2c-ae68-4bd3443ff0b5@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <21c8fde7-0caa-4f2c-ae68-4bd3443ff0b5@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Correct the subject and commit message to match the retained crash 
evidence. The report faults in klist_put() from device_del() during 
bnep_session, not in device_move(), and it does not contain the quoted 
PID 7415 "Comm: task" trace. Remove that unsupported trace or replace it 
with the actual bnep_session and device_del stack. Describe the observed 
ordering: device_del() snapshots a non-NULL parent, concurrent 
hci_conn_del_sysfs() moves the child and clears knode_parent, then 
device_del() calls klist_del() using its stale parent decision. Preserve 
the code diff, which correctly restores the RFCOMM-only move and retains 
hdev->dev until the connection device release, along with the existing 
Fixes, Reported-by, Closes, provenance, and recipient tags.

On 9/1/2026 12:16 AM, syzbot wrote:
> A NULL pointer dereference in klist_put() occurs when hci_conn_del_sysfs()
> attempts to reparent child devices to NULL while a child device (such as a
> BNEP network device) is concurrently being unregistered:
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
> CPU: 1 UID: 0 PID: 7415 Comm: task Not tainted PREEMPT(full)
> RIP: 0010:klist_put lib/klist.c:212 [inline]
> RIP: 0010:klist_del lib/klist.c:230 [inline]
> RIP: 0010:klist_remove+0x156/0x340 lib/klist.c:249
> Call Trace:
>   <TASK>
>   device_move+0x18e/0x720 drivers/base/core.c:4702
>   hci_conn_del_sysfs+0xb8/0x1a0 net/bluetooth/hci_sysfs.c:75
>   hci_conn_cleanup net/bluetooth/hci_conn.c:170 [inline]
>   hci_conn_del+0xc3d/0x1200 net/bluetooth/hci_conn.c:1318
>   hci_conn_hash_flush+0x189/0x260 net/bluetooth/hci_conn.c:2747
>   hci_dev_close_sync+0x7fc/0x10c0 net/bluetooth/hci_sync.c:5593
>   hci_dev_do_close net/bluetooth/hci_core.c:502 [inline]
>   hci_unregister_dev+0x232/0x5b0 net/bluetooth/hci_core.c:2681
>   vhci_release+0x16d/0x1c0 drivers/bluetooth/hci_vhci.c:700
>   ...
>   </TASK>
>
> This crash is caused by a race condition between hci_conn_del_sysfs() and
> concurrent child device unregistration (e.g. bnep_session calling
> unregister_netdev()). When a connection is cleaned up, hci_conn_del_sysfs()
> uses device_find_any_child() to look up child devices and calls
> device_move() to reparent them to NULL. If the child device is concurrently
> deleted, device_del() removes the node from its parent's klist via
> klist_del(&dev->p->knode_parent), which decrements the reference count and
> clears the node's n_klist pointer to NULL. When device_move() subsequently
> calls klist_remove(&dev->p->knode_parent), klist_put() attempts to
> dereference knode_klist(n)->put, resulting in a NULL pointer dereference.
>
> This race was introduced by commit 27aabf27fd01 ("Bluetooth: fix
> use-after-free in device_for_each_child()"), which replaced
> device_find_child(..., __match_tty) with device_find_any_child() in
> hci_conn_del_sysfs(). That change was intended to avoid a use-after-free
> where conn->dev outlived its parent hdev->dev when child devices held
> references to conn->dev, because conn->dev only held a reference to
> hdev->dev while registered in sysfs.
>
> Fix the issue properly by taking an explicit reference to the parent device
> with get_device(&hdev->dev) in hci_conn_init_sysfs() and dropping it with
> put_device(parent) in bt_link_release() when the conn device is freed. This
> ensures that hdev->dev remains valid for the entire lifecycle of conn->dev,
> resolving the underlying use-after-free. With the parent reference held
> properly, restore the __match_tty filter in hci_conn_del_sysfs() so that
> device_move() is only invoked on persistent RFCOMM TTY devices as
> originally intended, eliminating the race condition with unregistering
> network devices.
>
> Fixes: 27aabf27fd01 ("Bluetooth: fix use-after-free in device_for_each_child()")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+6df45dd3d03e1a9aca96@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6df45dd3d03e1a9aca96
> Link: https://syzkaller.appspot.com/ai_job?id=2d312ca9-20bf-457f-8a4f-728831a400af
> To: <linux-bluetooth@vger.kernel.org>
> To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
> To: "Marcel Holtmann" <marcel@holtmann.org>
> To: "Dmitry Antipov" <dmantipov@yandex.ru>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
> index 8957ce7c2..c2065abf7 100644
> --- a/net/bluetooth/hci_sysfs.c
> +++ b/net/bluetooth/hci_sysfs.c
> @@ -13,7 +13,10 @@ static const struct class bt_class = {
>   static void bt_link_release(struct device *dev)
>   {
>   	struct hci_conn *conn = to_hci_conn(dev);
> +	struct device *parent = dev->parent;
> +
>   	kfree(conn);
> +	put_device(parent);
>   }
>   
>   static const struct device_type bt_link = {
> @@ -21,6 +24,16 @@ static const struct device_type bt_link = {
>   	.release = bt_link_release,
>   };
>   
> +/*
> + * The rfcomm tty device will possibly retain even when conn
> + * is down, and sysfs doesn't support move zombie device,
> + * so we should move the device before conn device is destroyed.
> + */
> +static int __match_tty(struct device *dev, const void *data)
> +{
> +	return !strncmp(dev_name(dev), "rfcomm", 6);
> +}
> +
>   void hci_conn_init_sysfs(struct hci_conn *conn)
>   {
>   	struct hci_dev *hdev = conn->hdev;
> @@ -29,7 +42,7 @@ void hci_conn_init_sysfs(struct hci_conn *conn)
>   
>   	conn->dev.type = &bt_link;
>   	conn->dev.class = &bt_class;
> -	conn->dev.parent = &hdev->dev;
> +	conn->dev.parent = get_device(&hdev->dev);
>   
>   	device_initialize(&conn->dev);
>   }
> @@ -69,7 +82,7 @@ void hci_conn_del_sysfs(struct hci_conn *conn)
>   	while (1) {
>   		struct device *dev;
>   
> -		dev = device_find_any_child(&conn->dev);
> +		dev = device_find_child(&conn->dev, NULL, __match_tty);
>   		if (!dev)
>   			break;
>   		device_move(dev, NULL, DPM_ORDER_DEV_LAST);
>
>
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
