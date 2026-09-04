Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655F6488237
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 12:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524581; cv=none; b=TCQbbo6hv/yXEMNDALdJczyBmkJEeaTi6EtGng3Zqyu1rWN+srVEhelskzhcpfjmOMruH/LXhQfGOigkc47Qz9VsDka2gdnItu4R0Pc+cXnq8lUU7OVdPMSXWvbOiE+9JiDWpkh9gJUNLHUdMadj2ITZCqaL4R36C6tc6QFj8qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524581; c=relaxed/simple;
	bh=TM1wcmOa0uTkWc5bljBg1uBhEIfvfUGpj55XfMRoWLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=loqefFCI0fMjee5/2nxFlrVoi1K9h/Ai9BQP4HYIsjP4ct0+rCLTFbHJtM9IeHIPcW41LKS46d10xBo4F8r5ahMD5riAT4ziXjZp6yBoX933OMcul6UMmzhLOmx5UFSlKE4b5sDfIwxbMzqlXQ+xA7g4/wShutju0+7IZnx9WyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U7N7yn7E; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7N7yn7E"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a7ea0046deso969977a12.3
        for <syzbot@lists.linux.dev>; Fri, 04 Sep 2026 05:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524577; x=1789129377; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7rZkeM5YVupAHp74W0/DZnv7z1BQ9yVibngKH1KxPqE=;
        b=U7N7yn7ErE8pZ4iKcywdjOPT5+BBgKoPklDy21raMqpzflHRsP7y3H3mlXpM2IhzQL
         kekfKJ/QQY7GZUfprOWGGk6az4DItx9y9zLWUohBpqA29EKEYj10wNAEUCpFeCDBHern
         kEi4ceDS66thZyPtXiboBqh2IMWa9MEpDsEBZ5QIAju0yetmzkdaNW/C9Gvrg//ERGwc
         xT1X7qS57c5W4hPmKtlhyQVEsbA2HS0HZSnylPl74IvNkmQs4UNgxiCzhyC7Smoytx8u
         DDi8RuNN/mDNyrzxxT/NgzbqQ+VXecQZa9KPLlQam/740650rZgmgsz0deg4uNpB79rF
         F4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524577; x=1789129377;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7rZkeM5YVupAHp74W0/DZnv7z1BQ9yVibngKH1KxPqE=;
        b=k2sFkHDiHhQi6R+MX/k1OCohGe+Ih8AgA6ZuASTYEaV3q4HpBJoTSDpV5//6vr0Sma
         T95Tx366Nxhv3n0feCErPdKA+/W6OIsY0CXiMK7YYwTHOSJVN1X+sc+eCBoBNgMjmeMe
         cVY7o0Ka3xO/aErBLWZN+TnXcKEoLCiUm9nDja99bJ8kk8VHuEVzph2UT6H9leUtWRtP
         YmXFLlkPK7zTfsJLAhVwWfrGM1qJXPrV8DdYUMAknNWxtFm84knse8PB/Y73NBIzWbao
         0Jc9UghP1rNKLk+Y4Dtoexa0q3ydwDqnI27XGBtew0s6ME4CQbE3YoCBhhNo/VIrRTV4
         49mQ==
X-Gm-Message-State: AFuF++meuYWfO+ifUQITbXrZ2BiaGIOPYAHF/UFRtlULlAtXf+yixeMh
	t7FV7g8E74shhHmC6nzox4QifyHWgR8WvgJDht7dyUzdrma6uDZEXRa8rxT93wRm6Pg=
X-Gm-Gg: AYBFou0n2mvRvweOuddl/zL4DC7kyFJ0OhPEiMnjuuWDRfKc9Z9qhjYvanNLUgzLEbu
	/mVCUKMTyMljtoG9Kfy+sioIajvg+ea7C7NORowsSbrxq+sCSHSZhg9Twosc0mi0oP4QuOO3iUE
	dMz4ZlsOHFHruUbHa0cYO94bJiVErw0ze1cGUaq4BUPrhFfsMkNePC5o3cyWGn6B9poJNwHG8wN
	M78FDKBBNpSgwPm935XyepMAEM/Bc1qlsatGs7DSOJGAtbpBasstoGyhR09hibEYz5J0fCi/8rL
	sHs0dva1XdD5FTbHTifSw9UdJ/ONSR1HSwCTA/o19VlOL3bFn3WRdEYsTpLCpwc8kVjqbzqrIlv
	5xuNIVvXiX+GnQX3ML1yacqBeCE8cSKnNTyHl21Id6FCGa+ueJhDTQ6ia316+r2+buYFMRtnd7H
	5fyuesfGyMwgXJhpIMm1AYlNoTGEQPHhaNFwPhOzi0aOmrompsCa/Fc68wHp7j3SjWnUQ3yWRc8
	L49mwyhIDGDi2WrG4mWrF3h2FWZjZO+7P5/aV3eUGtm1A9IwP0xPjjAijN+3WoDdJpF+qRqMdOD
	8VFBKDkEvsSlgiSyRIEpfGgqQzMjefUWEzapPez1gDberXiRtmfjmXTJ+szyCgZlkM7t4RJAgWh
	LZ5f8YCzy/O0RNnE6RYaNpdmz2f0JVOZOs7A=
X-Received: by 2002:a05:6402:21d5:b0:6a6:7249:41bb with SMTP id 4fb4d7f45d1cf-6a7e8d25d0cmr1982292a12.4.1788524577210;
        Fri, 04 Sep 2026 05:22:57 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e6bf3032sm1098256a12.24.2026.09.04.05.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 05:22:56 -0700 (PDT)
Message-ID: <8c20ce48-96a8-438e-b7db-16f390d28e6d@gmail.com>
Date: Fri, 4 Sep 2026 14:22:56 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] Bluetooth: hci_sysfs: Fix NULL pointer dereference
 in device_del()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <e121f7b5-8495-40a5-b4f7-e015ab95904b@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <e121f7b5-8495-40a5-b4f7-e015ab95904b@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 9/3/2026 10:22 AM, syzbot wrote:
> A NULL pointer dereference in klist_put() occurs when a child device (such
> as a BNEP network device in bnep_session) is concurrently being
> unregistered while hci_conn_del_sysfs() reparents child devices.
>
> This is caused by a race condition between hci_conn_del_sysfs() and
> concurrent child device unregistration (e.g. bnep_session calling
> unregister_netdev()). During device unregistration, device_del() snapshots
> a non-NULL parent pointer. Concurrently, hci_conn_del_sysfs() finds the
> child device using device_find_any_child() and calls device_move() to
> reparent it to NULL, which removes the node from its parent's klist and
> clears knode_parent. Subsequently, device_del() calls
> klist_del(&dev->p->knode_parent) using the stale parent snapshot, causing
> klist_put() to dereference knode_klist(n)->put on an already removed node,
> resulting in a NULL pointer dereference.
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
> Assisted-by: Gemini:gemini-3.7-flash syzbot
> Reported-by: syzbot+6df45dd3d03e1a9aca96@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6df45dd3d03e1a9aca96
> Link: https://syzkaller.appspot.com/ai_job?id=f1c0e740-db21-40af-a9ff-84db0fd8b8bd
> To: <linux-bluetooth@vger.kernel.org>
> To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
> To: "Marcel Holtmann" <marcel@holtmann.org>
> To: "Dmitry Antipov" <dmantipov@yandex.ru>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v3:
> - Removed the quoted crash trace from the commit description.
>
> v2:
> - Update subject line to reflect the NULL pointer dereference in device_del().
> - Replace trace with the actual crash report trace.
> - Clarify the race condition ordering between device_del() and concurrent hci_conn_del_sysfs().
> https://lore.kernel.org/all/7649937b-a96e-44a1-8785-79b23c26ffe6@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/21c8fde7-0caa-4f2c-ae68-4bd3443ff0b5@mail.kernel.org/T/
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
