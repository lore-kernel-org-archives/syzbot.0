Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB4647CC94
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786625242; cv=none; b=ZA8QFBX6agQB0a+mzfthVpA8Gb2NhrgxX05IqnG1WirZXa2QYwp7J3ciqypGk6UI+6iEj+6bnvHxJaBBKJtkJX9ebkXYZw8igNsogWycAX5fl6GjJdy1hXPyVQlrt4fLEm7DzOU9DK4Sv8TTgRWOSud8ChLQNQBLNGTJ04HiBqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786625242; c=relaxed/simple;
	bh=fRSj/lFjmF8LVacGa9DFPctuuu8MPwfKLvPMYNv+VUE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQvbXYj8vIq+WxOOM9Xsu5Yd3yXKr6XtUs7nSS6Pod5w9LoDkWANjl6FA/6oH5VLjFw33R0ibbGo24QUL7Z4USWuZGce2rv24RlBSUj42di1HNr5h/36OklG06/z9HPELq7cQzYU8BBOU7tImvqrLIeIbFLVM530Myihw9NdLKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b/wIc2r3; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b/wIc2r3"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47fecbb7000so361580f8f.2
        for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 05:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786625239; x=1787230039; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zy7YXAjbqxTJqsTZlth0aaiS1A5PFyiiJQU0lrRsvA0=;
        b=b/wIc2r39gABqb0pHfj3Rq/s/rl48xefieHd5XOI5SFp0wg2CiubKpfetoNo5CVSiW
         C0lYDNxPQkKjYqackRGvlKTB/Je/hCdWr/Ollm3f7Vr0lzUAbCTEr9F0ZXlR+bIDBRZn
         8pCZm5rBYKeuKwFSrVpGyA29xW2Xg8LcpadrRqx+0DEZdPdyy70VFjauu31xUs6gRtXc
         /on3cr6QNYfn30yDHSjHbkTj4W5mXYyRiQv/n2uzynwzFybH5DWddIIgCRYPAGxm8E/H
         WSdsMM1Y5AY9fOZa3rY70H1wt+H7FUenG8OFgAhhPGhfTlMTyqTIxXwafFk7wH0eWvJ+
         vj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786625239; x=1787230039;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zy7YXAjbqxTJqsTZlth0aaiS1A5PFyiiJQU0lrRsvA0=;
        b=RWcvS776cYIZt6y4OYkz5TmUXxyWG036Vrq65J4sRqOnzIyCPcIsuSb1MCnIfj6nSO
         KyxtpnoLysxqk+10GkDGP79JJHluCDL3DhJ/6vFfBeH8vhD5AJ8Cg9b7bL02dkLe3fiY
         m0kIzl/TceD2ZOhVkR/70rX/2HXX+Wupppk382pYzhALieOXmLgTThBSm6L7WoEZzqCX
         3SaJXihKP6VRvh82ff8uJsmwyW97E/SgeLuqvwNNZjy77bT+83/zAPsycjZiYA+W1b+2
         DZDOGOooTCxDkroY+KD68Myq/5q6uFBigNqI9f9SzoGLiJX/OdNFDgXSfoLC4gUDqkUA
         hoNw==
X-Gm-Message-State: AOJu0Yy2qWua+1OtW9AqIv5sZqFEz30+HasK/IkY77oloh3jcOc+LRad
	/58E+TCbfpFd2/4pJBtmQDQJ4LRmwX1zwYLh7PEO8GF2EzrS5y4E0eQJ
X-Gm-Gg: AR+sD11dGkRYqU+v4CF9wBN1ZGTbi4jm4q+TIcVAGG6o7jISYOD9N3wTCkMAJAljxBd
	XqlGzbIcO/c5hBTZkwLdrdGh9JgQjJIdY57sIVUL9mzZMgt++rdRux3f8eJ5G/rSqDaQkyI4ml2
	Iq4Li6dmjmQtifKznmMxJ8whc4fXUXXOWb4522A9wlzG+4mK9loTDKWmQB++2FflDxgHTcjDwy8
	S+aDt13Khhlj5RtMZhcCi0SMldAqyoHjtSmkHM5b3499l84fp4jqKxh+4RLYWH+XAs00q6dc4z2
	dqlrtJCGEdb8ubOhfr1qyk8AGkm8JkgNq8r9NqqmIZQMeiodYXaHA+mkayLf/pPmlVpzu8TkfjL
	ul1T6YpuDKlx8n/+BNV0+OBzHryTJOBaUwBxd7z7YbbMs9Jp5DX4Nbe09EvrSG8cMpFjoWR1iGa
	8cT+KIkCTAgqw0r806O0nl8rwewAn3CNl0V68uYiXFvMoYuAA1oiYAW4Y4aXXc2Q6uyCND053+6
	55YQBAt4KT1o4xGQoyPgdo9DqM2ETf+iYuIIqU3yp1rLYVI55cvvMinNajbEqQQd2gXdVOzCVW7
	X/p2czUyKnRlhiO2Kkj2jzL/6zz8VDqlr2rgbNRhTROksCP9/TvB+Pc=
X-Received: by 2002:a05:6000:288c:b0:47f:6f6a:6a7f with SMTP id ffacd0b85a97d-48159cbf3dfmr8111174f8f.8.1786625238363;
        Thu, 13 Aug 2026 05:47:18 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a56123asm6962814f8f.8.2026.08.13.05.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 05:47:18 -0700 (PDT)
Message-ID: <25ed8131-ec9b-409b-b601-8ca692ba8dda@gmail.com>
Date: Thu, 13 Aug 2026 14:47:17 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] Bluetooth: hci_sync: Fix tx_work queuing race
 during device close
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <2df2fce5-9a9d-4baa-8b00-c1ccaf72d400@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <2df2fce5-9a9d-4baa-8b00-c1ccaf72d400@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Preserve the existing flush_work(&hdev->tx_work) in hci_dev_close_sync() and
call disable_work_sync(&hdev->tx_work) immediately after that flush. The
current patch replaces the flush with a canceling operation. This can 
discard
packets accepted before normal close without the transmit attempt 
performed by
the existing code, and cancellation is not required to close the scheduling
race.

Keep tx_work disabled through drain_workqueue(), connection teardown, final
queue cleanup, HCI_RUNNING clearing, the driver close callback, and volatile
flag cleanup. Keep the final balanced enable_work(), including the nested
disable behavior under hci_unregister_dev().

Keep the RCU read-side section in hci_sock_sendmsg() from the HCI_UP check
through validation, queue insertion, and scheduling. Keep the matching
synchronize_rcu() after HCI_UP is clear and tx_work is disabled. 
Preserve all
socket errors, skb ownership, UAPI, Fixes, Reported-by, Closes, Link, and
Gemini provenance tags. Update the close comment and patch description 
so they
state that pending TX work is flushed before later scheduling is disabled.

On 8/13/2026 2:12 PM, syzbot wrote:
> During the shutdown process of a Bluetooth device in hci_dev_close_sync(),
> tx_work can still be queued by concurrent transmission paths or raw HCI
> socket operations after HCI_UP has been checked or while workqueues are
> being flushed. This causes __queue_work() to trigger a warning when
> attempting to queue work on a draining workqueue:
>
> workqueue: cannot queue hci_tx_work on wq hci0
> WARNING: kernel/workqueue.c:2306 at __queue_work+0xd4a/0x1090
> Call Trace:
>   <TASK>
>   queue_work_on+0x106/0x1c0 kernel/workqueue.c:2452
>   l2cap_chan_send+0x168a/0x22f0 net/bluetooth/l2cap_core.c:-1
>   l2cap_sock_sendmsg+0x33a/0x4d0 net/bluetooth/l2cap_sock.c:1180
>   ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
>   ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>   __sys_sendmmsg+0x273/0x4d0 net/socket.c:2827
>   </TASK>
>
> To fix this, replace flush_work() with disable_work_sync() and re-enable it
> with enable_work() in hci_dev_close_sync() to establish a work exclusion
> interval for hdev->tx_work while the device is closing. Additionally,
> ensure raw HCI socket producers in hci_sock_sendmsg() are quiesced by
> holding rcu_read_lock() while checking HCI_UP, paired with
> synchronize_rcu() in hci_dev_close_sync() right after disabling tx_work.
>
> Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b6919040d9958e2fc1ae
> Link: https://syzkaller.appspot.com/ai_job?id=bb132695-7f6d-4df7-8464-0dd1708b1661
> To: <linux-bluetooth@vger.kernel.org>
> To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
> To: "Marcel Holtmann" <marcel@holtmann.org>
> To: "Johan Hedberg" <johan.hedberg@intel.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Replaced per-send HCI_UP checks in hci_core.c with disable_work_sync() and enable_work() on hdev->tx_work in hci_dev_close_sync() to establish a work exclusion interval during shutdown.
> - Added rcu_read_lock() protection around the HCI_UP check in hci_sock_sendmsg() and synchronize_rcu() in hci_dev_close_sync() to quiesce raw HCI producers.
>
> v1:
> https://lore.kernel.org/all/2c2febf2-fc12-4407-9c81-d3d9713f09a4@mail.kernel.org/T/
> ---
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index 070ca388f..8345ebbbd 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -1850,9 +1850,10 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>   		goto drop;
>   	}
>   
> +	rcu_read_lock();
>   	if (!test_bit(HCI_UP, &hdev->flags)) {
>   		err = -ENETDOWN;
> -		goto drop;
> +		goto drop_rcu;
>   	}
>   
>   	hci_skb_pkt_type(skb) = skb->data[0];
> @@ -1870,7 +1871,7 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>   		    hci_skb_pkt_type(skb) != HCI_ISODATA_PKT &&
>   		    hci_skb_pkt_type(skb) != HCI_DRV_PKT) {
>   			err = -EINVAL;
> -			goto drop;
> +			goto drop_rcu;
>   		}
>   
>   		skb_queue_tail(&hdev->raw_q, skb);
> @@ -1885,7 +1886,7 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>   				   &hci_sec_filter.ocf_mask[ogf])) &&
>   		    !capable(CAP_NET_RAW)) {
>   			err = -EPERM;
> -			goto drop;
> +			goto drop_rcu;
>   		}
>   
>   		/* Since the opcode has already been extracted here, store
> @@ -1908,14 +1909,14 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>   	} else {
>   		if (!capable(CAP_NET_RAW)) {
>   			err = -EPERM;
> -			goto drop;
> +			goto drop_rcu;
>   		}
>   
>   		if (hci_skb_pkt_type(skb) != HCI_ACLDATA_PKT &&
>   		    hci_skb_pkt_type(skb) != HCI_SCODATA_PKT &&
>   		    hci_skb_pkt_type(skb) != HCI_ISODATA_PKT) {
>   			err = -EINVAL;
> -			goto drop;
> +			goto drop_rcu;
>   		}
>   
>   		skb_queue_tail(&hdev->raw_q, skb);
> @@ -1923,14 +1924,16 @@ static int hci_sock_sendmsg(struct socket *sock, struct msghdr *msg,
>   	}
>   
>   	err = len;
> +	rcu_read_unlock();
> +	goto done;
>   
> +drop_rcu:
> +	rcu_read_unlock();
> +drop:
> +	kfree_skb(skb);
>   done:
>   	release_sock(sk);
>   	return err;
> -
> -drop:
> -	kfree_skb(skb);
> -	goto done;
>   }
>   
>   static int hci_sock_setsockopt_old(struct socket *sock, int level, int optname,
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index c8d14128c..bad83313b 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -5472,9 +5472,11 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>   	hci_leds_update_powered(hdev, false);
>   
>   	/* Flush RX and TX works */
> -	flush_work(&hdev->tx_work);
> +	disable_work_sync(&hdev->tx_work);
>   	flush_work(&hdev->rx_work);
>   
> +	synchronize_rcu();
> +
>   	if (hdev->discov_timeout > 0) {
>   		hdev->discov_timeout = 0;
>   		hci_dev_clear_flag(hdev, HCI_DISCOVERABLE);
> @@ -5576,6 +5578,8 @@ int hci_dev_close_sync(struct hci_dev *hdev)
>   	bacpy(&hdev->random_addr, BDADDR_ANY);
>   	hci_codec_list_clear(&hdev->local_codecs);
>   
> +	enable_work(&hdev->tx_work);
> +
>   	hci_dev_put(hdev);
>   	return err;
>   }
>
>
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68
