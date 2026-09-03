Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CEC37756A
	for <syzbot@lists.linux.dev>; Thu,  3 Sep 2026 08:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788423019; cv=none; b=kYazxfzdbzRDO8Vnv7Tk7hzeRsDtGGYaxQ0R4rXS/oGPA90posX+9jTXMnXnC7AJf2Po3ziliFSpHMF8DzDmCivK1LBOCp8kcr3sQsNAau06JyDU7fJZ+k9X7qWfbD32spZElsbDNmJiT3k2u7OIe02/rf25gy1Xg/D2d9mZE/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788423019; c=relaxed/simple;
	bh=ADlaQPSKPdbUCNdp/yaUJiLveTlqt8KsWFv4XigIDAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f+IsgmNMy+dhHtAmhT4mef1Gu4cMmJPinkjdX7fLlmGxdXK8TF/DLNpENT9xtvAJ+j2jmvVwe3IYbQvkOWbSmh79vtmxptKGlPEtOewdB4AkVKsQx8m8d3UxxGj48QS0T2blYJaK+alu8Or2y5kGwsmN4EDB3goA3K41gUI7l8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mxOwpZWJ; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mxOwpZWJ"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a6868f18aeso2983929a12.0
        for <syzbot@lists.linux.dev>; Thu, 03 Sep 2026 01:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788423016; x=1789027816; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N1g8XOn7bUyZBJMD7jrNfWtD1q/eNioZk3hVJJS420s=;
        b=mxOwpZWJhs16WtCZp4FoFUAfm57nbw/OUAWItm1Rff8bab+pj1cW35aiEZVIL2n+x7
         zo4+XROavhoS4uKlsuC3WzLeIe4M6nEZ/7YuJewhNtgHMn2QR0zlqyHg/GOssPj/gEfQ
         0KyurohU5IvAqNJiGTpHoqPwErSbLu5EbN93PGS3FSnR9wBaEOa96+YDLDVgc1i4BXiD
         KDZHXH5Wz97RxvsaoucG5SBEeXxCfieFSTzXSTAjUuz4j3k4XkZpSRNK1Xm+MBVOpBJ7
         r8jpzPkuvFL8CujFtOd+ehunOwdXt4FI+d9XRtulVmDTTIjv6Kkg6rx7zd9Lt8yKd43M
         0TGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788423016; x=1789027816;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N1g8XOn7bUyZBJMD7jrNfWtD1q/eNioZk3hVJJS420s=;
        b=F8nHSZrQ54HSMfAo9B1/to6mzDHq+nJQMII5ppnYZJJRl02CgZ/aiaCv1QM7JzuSLF
         80o7bhmr/I0mt0bURuv16zmwbIZ/VRXdbbvXqzijVAjPflR2W/gOLlwWiuTiLguPYYP6
         zF6WIZkZSGRUhpAWWVcFo6zCcwdIv48djH1dGNEfDvX50FM6F34jspamFBCN9w+hViby
         aHx2JasODQdri5RxDmOnr7QEjBRkhMUkTebCmvY+yiTSS+6vG7jl1Ntj1qHb6DZH2PYP
         oY0giBsZGrHEcgOUCyUIJZx5QcLX5kiE3jS2a+/xTN7vV7UuXaPtw/z5yL4YyDSqB6sX
         JRZw==
X-Gm-Message-State: AFuF++lfZD7XdTH+nwzqP0J9e5q9C5JCG3JqllvhjS//L06FtBzba6XA
	u0uULayUnl3Rhk+cwJLuDyzNkF4s7vpdI4trR5vhVMRQWSZbX0x+zTtBEoJEdihh
X-Gm-Gg: AYBFou2myg4q5z6F9icdhlfatV0ASBTkesIitBei7ZUrwdgv8nh8l0LSXFcvMD5HteA
	EXSn5VtXiKj9j5hhJdn6BiON83irG4jZD/G7HHStQmkb/XHk/+IsydN1zMf6M/SClahtYtq0qdl
	SssiGLAZkv9TzylRpMu+9hRBASjxvoIkB3NWaawTqr23awgqPvsWY2FNAS1R6d3vNuddcxWMVo/
	v6hPA2KWnWuPEl8b5wBbLMUuLGGpNzNJHODZ4cHKNY0ZJ8dsanPW1N9eBTd3L314+s8LTsntD5m
	IiKNIkIrgaivqa2ZYuBRtKod78I9a/ZYnPY6LT1Q6gAQ2Int94+wMlT/6BC7B5UFYpElaEAQFV3
	APrzcNMwBNnohhK377MMDny4UmDOIN9tvSaAefX3SuuezQ7HZN9VmR+OR+/rtSGj4xn/GfQg205
	6ytR5EkDue4WgaFGsLdEhgyyJrxSdSIQ54amz1akr/gusn4CKoflbXwe4uCS5sEW6pVXrTWtPPI
	u66du1RZF6fFnAu11b0pUYuvHNvKUMHdsGdnbuaBrormXgpvV+IEXnGtfEgXUHt3dW8FYKdwemI
	FEjH9azLKZrbvR9iq3lEfmxTT/klN6J2vmxUfVa8IU0uaWdwmnhy/umpNqD9zyJHoGXp4x0e4/S
	QV44ALIkTPPR1FOvjyERltzt+Ft26tjf8+gzl2B+noS7NOZ4=
X-Received: by 2002:a05:6402:3512:b0:6a3:691a:9d71 with SMTP id 4fb4d7f45d1cf-6a6829ada0amr5733280a12.11.1788423015837;
        Thu, 03 Sep 2026 01:10:15 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a67f895d7esm1887830a12.1.2026.09.03.01.10.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 01:10:15 -0700 (PDT)
Message-ID: <8b187e1f-abb9-4a0e-8748-a97b4ceac680@gmail.com>
Date: Thu, 3 Sep 2026 10:10:14 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] Bluetooth: hci_sysfs: Fix NULL pointer dereference
 in device_del()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <7649937b-a96e-44a1-8785-79b23c26ffe6@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <7649937b-a96e-44a1-8785-79b23c26ffe6@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Remove the quoted crash trace or replace it with the retained report 
trace. The retained report shows `PID: 14113 Comm: kbnepd bnep0` and 
faults in `klist_put()` from `device_del()` during `bnep_session`. The 
current quote instead shows `PID: 21636 Comm: syz-executor` and faults 
through `device_move()`, so it is not the actual report and contradicts 
the corrected subject and ordering described below it. Keep the code 
diff, corrected `device_del()` race explanation, `Fixes` tag, 
provenance, and report links unchanged.

On 9/2/2026 6:57 PM, syzbot wrote:
> A NULL pointer dereference in klist_put() occurs when a child device (such
> as a BNEP network device in bnep_session) is concurrently being
> unregistered while hci_conn_del_sysfs() reparents child devices:
>
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc000000000b: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000058-0x000000000000005f]
> CPU: 1 UID: 0 PID: 21636 Comm: syz-executor Not tainted syzkaller #1
> PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:klist_put lib/klist.c:212 [inline]
> RIP: 0010:klist_del lib/klist.c:230 [inline]
> RIP: 0010:klist_remove+0x156/0x340 lib/klist.c:249
> ...
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
> Link: https://syzkaller.appspot.com/ai_job?id=03299926-ecd5-4848-b5f8-a253b09af490
> To: <linux-bluetooth@vger.kernel.org>
> To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
> To: "Marcel Holtmann" <marcel@holtmann.org>
> To: "Dmitry Antipov" <dmantipov@yandex.ru>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Update subject line to reflect the NULL pointer dereference in device_del().
> - Replace trace with the actual crash report trace.
> - Clarify the race condition ordering between device_del() and concurrent hci_conn_del_sysfs().
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
