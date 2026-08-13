Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F9D361954
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 10:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786617818; cv=none; b=DjZaWyFwmQRJ0XUvT6cgq+5dI0rAr66BEVcXZqKW61SJwKmpeXjEP9FtRjq3a2aJ1yXDDw9qvzY5tkLxy6W/0OrbQnWVZ1C8b+l1qDhsXEIN1+Sk79m1nJoYqrLkSTO9jLMx/2jgVJLBvxNcmykt6DjcVAN+WU1Y3tlcoH+aa8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786617818; c=relaxed/simple;
	bh=i0oq+mQwHQbavIbANbnRbo/jC8WmXmu62BXdji6DlrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qgHLyKegxeRiDIFw4R+aKJj3OmC536YUfzcvibMB/aRtjVSZDB0eujWbpfTTnxCZwJxKpSLeKnxi7SwBa3pydj4vTh9sAD5rm0aFChV83KTvYREGZct9Uk0OP5qnxzD9AjGTYHGBTKAiNLICrJfxVVcq4u41CarHDtRUrohe958=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lwmz5VOG; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lwmz5VOG"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c197eaaab00so338960266b.0
        for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 03:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786617815; x=1787222615; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Ab5Po4fACXFsrSoFm+xVI7rVLwzegNo1v4Qi0IPgME=;
        b=Lwmz5VOGbI3taCGQbPYHnzHkdD5JRyCNqKsltjvZ+CVFIXxhBn6FiERA/BV35Y9KQx
         lXDvA6WXdTV9T4xKRr70B9lj5bKMRt+kY9ArMFJcj6iwyeHam0N5R+rySZhcvdRIpEPz
         AH8hIo7NTjzHZlrIbBBiEHfP19GZe6GuKaxgGYum21VkUAmxS1Ds17pdyoOB9QjVvcZ/
         XxwAbfLhuPCa5K+VHMD4hsEoZxZmAjmkX6oNXbOW+YDDyAtwZJmoOXzqRVyvn5qyqId/
         aR3/EuYWlC8z5Gdz+1YrcKNIKCcA9WubMRH35DLII//OGXNPR9hB19cbAuJlP7gmeiUU
         5DtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786617815; x=1787222615;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Ab5Po4fACXFsrSoFm+xVI7rVLwzegNo1v4Qi0IPgME=;
        b=VMGXLI1Nb/okQnunlVbIueTn97Y7QFZ/AP/v2p0lryx+giPjKVAM4L6KyE6ovVCspb
         fL9QNZDNttK5J1Lj+DRQ3fN/fze/sjqv9zyP2nolyJRonkEjxFmh85s+/2Nm2FpgGTtX
         vHoRcDosGauDkfmH8kAp1klk3HpvGOs+KCKPMiGSocP/LuhSfa9YWgpXnyvxYwATCgXF
         bYAtRIWY6MOU2RdyFUf7m3nD+it4AEiE0SmVlyrTn+H0KRibEirUIfK6p1bLbtVcxLiF
         yUhkvwxk7pue/s8mexjbmGIZOc4PSz/1yPsW65PzUpYy8RQSV4AjOU2zA5grgInXEg92
         2J0Q==
X-Gm-Message-State: AOJu0YylmyVd7vYLQtbs0rS96HsCQg85GHbYwStaqRSWzfvDjzEjADoG
	12zwZWyDl9VOmsZ6jLc+pBROt7qya/IlFCkTuFeLwXYj/8j4QW7MtZcY
X-Gm-Gg: AR+sD10Hyp5t9f4TwF0b160IhgkW0Qn9sexxfDxhYGpIjwu6/Cy+PbF7E8oShzO2jyT
	fe9pfFXIJjqdrsTGgASQbRw3OGuRfsoic/L/81aPr7omRziG0KsCGUImPm363MPyYS8KFySJB4I
	OCO/In8F3bYF6Rbx8VX8gyISLyNFhFIUaJV1QnGMd0rJCIvfl5/Ezo4bc3L0Swydla/cr9OZyWX
	/bOLKJi1L1uDMxfIVI/vJcl1PBB3NlWEC+xq0k1JdmmXhClJKjqQx8m1VoAqgxA1e0v6lypEIct
	lF+183dks1Z7vn8/PvsrfRvzVgJbIvLy6EqZmckYmrQA9bqW8++aF8nyXram0xRB+5hBWYiwDez
	aDJISVMok+DhmSVEvHOnHzcx925Y3FSJ8JnHKJGlOGf9xzhUqwEIuOL1gokw6PMRW30feUKmQU2
	vwjzB538lXNYdIWiS/kPtch6z17Kth1w1T56DEqvQzbUvBSP4TcrckEnWp1kj+xkFk8GQOYhLEH
	xTaspkd4nnqlFFW6aAccpccIMGBRU80AIapct3bNBTVNz0n3NE7sQ2Xs2RNdKJfXSon+VAGRu1U
	kGqdofmJxPTJsjanAHGTDcM3o52DfRY5Idf0iSlNnbnIiprh0UdHf0KAPDdVgEY32A==
X-Received: by 2002:a17:907:608f:b0:c20:88a6:8210 with SMTP id a640c23a62f3a-c2108ebd20bmr249032466b.9.1786617814181;
        Thu, 13 Aug 2026 03:43:34 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c21087e1ae1sm75483466b.40.2026.08.13.03.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2026 03:43:33 -0700 (PDT)
Message-ID: <2ee43e7a-2ee9-44be-9d32-a2b0676936af@gmail.com>
Date: Thu, 13 Aug 2026 12:43:33 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] Bluetooth: hci_core: Check HCI_UP before queuing
 tx_work
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <2c2febf2-fc12-4407-9c81-d3d9713f09a4@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <2c2febf2-fc12-4407-9c81-d3d9713f09a4@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Replace the producer-local HCI_UP checks with lifecycle exclusion on the 
shared
hdev->tx_work item. In hci_dev_close_sync(), disable tx_work 
synchronously after
the successful HCI_UP transition and before drain_workqueue(). Keep it 
disabled
through connection teardown, the final raw queue purge, HCI_RUNNING 
clearing,
the driver close callback, and volatile flag cleanup. Balance only the close
path's disable count near the end of a successful close. Preserve the early
already-down return and the outer disable count held by 
hci_unregister_dev().

Do not re-enable tx_work immediately after hci_conn_hash_flush(). A raw HCI
sender can pass its earlier HCI_UP check, resume after that early 
enable, append
to raw_q, and schedule tx_work while the device is down and close is still
active. Moving enable_work() after the purge alone is also insufficient 
because
enable_work() does not replay a queue attempt rejected while work was 
disabled.
Such a sender could otherwise leave an skb in raw_q after the final purge.

Protect the raw and user HCI send path from its authoritative HCI_UP check
through packet validation, queue insertion, and the matching 
queue_work() call
with an RCU read-side section. Release RCU on every error and success 
path. In
hci_dev_close_sync(), wait for these readers after HCI_UP is clear and 
tx_work
is disabled, before final queue cleanup. Keep allocation and user copying
outside the read-side section, and do not add any sleeping operation 
inside it.

Preserve the established drain_workqueue() and hci_conn_hash_flush() 
ordering,
normal ACL, SCO, ISO, raw and user HCI validation, existing socket 
errors, skb
ownership, UAPI, and the current Fixes and syzbot provenance tags. 
Update the
description to explain both the shared work exclusion interval and the 
raw HCI
producer quiescence.

On 8/8/2026 11:29 PM, syzbot wrote:
> During the shutdown process of a Bluetooth device, hci_dev_close_sync() is
> called. This function clears the HCI_UP flag, flushes pending RX and TX
> works, and drains the workqueue to prevent lockdep issues during cleanup.
> After the workqueue is drained, it flushes the connections.
>
> Because the connections are flushed after the workqueue is drained, there
> is a race window where the workqueue is draining but the sockets are still
> in the BT_CONNECTED state. If a concurrent thread calls sendmsg() on an
> active L2CAP, SCO, or ISO socket during this window, the socket state is
> still considered connected. The sendmsg() call will eventually reach
> hci_send_acl(), hci_send_sco(), or hci_send_iso(), which unconditionally
> attempt to queue the transmission work (hdev->tx_work) on the draining
> workqueue. This triggers a warning in __queue_work() because non-chained
> work cannot be queued on a draining workqueue.
>
> [ cut here ]
> workqueue: cannot queue hci_tx_work on wq hci0
> WARNING: kernel/workqueue.c:2306 at __queue_work+0xd4a/0x1090
> kernel/workqueue.c:2305
> RIP: 0010:__queue_work+0xd66/0x1090 kernel/workqueue.c:2305
> Call Trace:
>   <TASK>
>   queue_work_on+0x106/0x1c0 kernel/workqueue.c:2452
>   l2cap_chan_send+0x168a/0x22f0 net/bluetooth/l2cap_core.c:-1
>   l2cap_sock_sendmsg+0x33a/0x4d0 net/bluetooth/l2cap_sock.c:1180
>   sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>   __sock_sendmsg net/socket.c:790 [inline]
>   ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
>   ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>   __sys_sendmmsg+0x273/0x4d0 net/socket.c:2827
>   __do_sys_sendmmsg net/socket.c:2854 [inline]
>   __se_sys_sendmmsg net/socket.c:2851 [inline]
>   __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2851
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
>   </TASK>
>
> To fix this issue, modify hci_send_acl(), hci_send_sco(), and
> hci_send_iso() to check if the HCI_UP flag is set on the device before
> attempting to queue the transmission work. The HCI_UP flag is cleared early
> in hci_dev_close_sync(), well before the workqueue is drained. If the flag
> is not set, the work is not queued. The skb is safely appended to the
> channel's or connection's data_q, which will be safely purged shortly after
> when hci_conn_hash_flush() executes, ensuring no memory leaks occur.
>
> Fixes: 76727c02c1e1 ("Bluetooth: Call drain_workqueue() before resetting state")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+b6919040d9958e2fc1ae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b6919040d9958e2fc1ae
> Link: https://syzkaller.appspot.com/ai_job?id=59121999-1293-40a6-aeeb-713e2d7dc16b
> To: <linux-bluetooth@vger.kernel.org>
> To: "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>
> To: "Marcel Holtmann" <marcel@holtmann.org>
> To: "Johan Hedberg" <johan.hedberg@intel.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 5ba9fe826..d9f091af3 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -3242,7 +3242,8 @@ void hci_send_acl(struct hci_chan *chan, struct sk_buff *skb, __u16 flags)
>   
>   	hci_queue_acl(chan, &chan->data_q, skb, flags);
>   
> -	queue_work(hdev->workqueue, &hdev->tx_work);
> +	if (test_bit(HCI_UP, &hdev->flags))
> +		queue_work(hdev->workqueue, &hdev->tx_work);
>   }
>   
>   /* Send SCO data */
> @@ -3267,7 +3268,8 @@ void hci_send_sco(struct hci_conn *conn, struct sk_buff *skb)
>   	bt_dev_dbg(hdev, "hcon %p queued %d", conn,
>   		   skb_queue_len(&conn->data_q));
>   
> -	queue_work(hdev->workqueue, &hdev->tx_work);
> +	if (test_bit(HCI_UP, &hdev->flags))
> +		queue_work(hdev->workqueue, &hdev->tx_work);
>   }
>   
>   /* Send ISO data */
> @@ -3338,7 +3340,8 @@ void hci_send_iso(struct hci_conn *conn, struct sk_buff *skb)
>   
>   	hci_queue_iso(conn, &conn->data_q, skb);
>   
> -	queue_work(hdev->workqueue, &hdev->tx_work);
> +	if (test_bit(HCI_UP, &hdev->flags))
> +		queue_work(hdev->workqueue, &hdev->tx_work);
>   }
>   
>   /* ---- HCI TX task (outgoing data) ---- */
>
>
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68
