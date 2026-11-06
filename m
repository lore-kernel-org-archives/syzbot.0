Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978211;
	b=D1R4zJ4hJ/36XDUM5jUkEs41qhR67xaKP0+45ibLKVU65xh1wOdPZa14zm8LYHZn4J1a
	 FlauX7t/AR45KkXpIp1+jfwNtWxG8keO71W2TM6WTz1jX0RbLaVmGN+IPv+gYaP+/TDK2
	 KGY4ZPb0gi3sYZxjPdtd4igcmz2Em0snJ7xDvi/ixDm4zBoBvluaJZn6xZmN8pXKce0zW
	 ZkW6FDxp+aaJhsCyyTHddn8gOSmXlE6inizbmvOu2jdBxMJT1CozNkme9od2L6idw1Hms
	 G8bhFlSn/YF54mjtJpNup8D73F4y9vD9sPsLCqBhhVgnfHMBm6GRdLDHyd8wIWkQWWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978211;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=r/KxoqxKYng4ngTydFyXC2axe3jiWtyFwSlZqXKrk7U=;
	b=bSX8RB9Q6MqkOHESTjiPKchjJxPaq1j8JbobdW2/vZhg1LN0ZC6MA0q+Ks/tC4fGIdu/
	 XYLlMwzLeMMq8THQ46Yp0CmmIFd4cJ+iC9PRB9eVAsd1y8K0LG+1lRRlKTXXTGt+qIwse
	 yNpBHsREzfrFFhz228lyRxalmG3y0x2Ny+m1wFpZlgluyyVJCp2J/1AD1ZKXeP2bb+95t
	 QyzQ5NN0KztyI8sxdT452bK/XG+iUZHHaD2pGBK70DYgo+4MEoTRYp44f9+BZlpl/zJQc
	 8A86ltiuRVK2jOFuLu6pmlRiqYdeYj2XPeuMuAp8gH9TZcMgpO6Qug+ryEdAFnX60qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lYKKsuXy;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABC6606A330
	for <syzbot@lists.linux.dev>; Fri,  6 Nov 2026 15:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ABC6606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lYKKsuXy
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c4697404c2bso95375766b.2
        for <syzbot@lists.linux.dev>; Fri, 06 Nov 2026 07:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793978210; x=1794583010; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r/KxoqxKYng4ngTydFyXC2axe3jiWtyFwSlZqXKrk7U=;
        b=lYKKsuXyUp8AR633egGjOM2ovfgPebxahdtADv9ez0tjYHuDYDPYJnJf3Fp/XQmNFp
         71ksE1TDCz/XbV7UuIr+oS8BOgzaGBkw3QoptwZhOagsYFpMqx9HdjixDG88NVGABxaD
         0flB+lG+TDeEbtfFsdml5YBUfMvvYb5d7KqnWGE3FIBE1dsS31pH7Vt6Z6w7gZVqgPlw
         GC6rqT5tjm0N3LYG1BBBYaufU9qoyMy5EG9cqEsSrfEOA6H9MQfYa9+4Z0R3d+aIFw17
         wyAiH3+8kLk0RI1dJ0I0yD79Zoq+cPTkBczbuJbR41M6eGfPZNqIHvfh7jOOhVBDo66/
         gnag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793978210; x=1794583010;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r/KxoqxKYng4ngTydFyXC2axe3jiWtyFwSlZqXKrk7U=;
        b=e7J62q8Z2Tyt2XVFoOMoErzkcapZDNNdY2aefGym6TkTZ5QziQUeL2rc/i2vozVjpV
         bBBIh3hCUtkFJ/J0DrpzfIPQD+CUlB3/wsFHlXlCjjYcHjxjIxcd+9pKeQumLx5SBRG+
         Chtuz0oajYnlG9lcegZet1xthEeuT5EHtTC3NlC02nVpkiW+p1W43v/XAH5C5aT0MMe6
         cPc1hCD6nB+/Wl7fbXKv0VRi7B3kRd9KXmhjOMDZ5CpkSjz7tuHYDmwo73QbodcJShf4
         fXJf1rzWjvsm/MAjzod+iQMPcMXslmq6oV8tigIfVa8KEeLx8utyDjmyrWp+TKs74GUp
         PlDg==
X-Gm-Message-State: APuU4Z/VguTD9HdWZukKFrukoO/1msg8lerfUiNzytrkZt4h2sqOmic5
	huZkym5o0QkH2kcy3xI8vUfPtBpAfj+P954O7+KR1b3mWuWVxifIbHKg6Y98/cgy0vgaWB4s
X-Gm-Gg: AYBFou2zI4JYg95a3vRMBpH2qwNG4pbZFpbiBvqvhwjCu72YJNLOCDUN/RyXSNB+jd5
	J8pBLZ2GLvZuB5IJQ1qTTyGQG1G6l6e8zWIhV+ouE4R1TIksywSyam9HOkM5tKzAyFEbZXLqB9b
	5+29UysZjkQODhE8VmRIfNekCcwN7f2A23v8h7lLVTx3URW01mnbsG3cqUAH/YyugkDGZBBUXCN
	rkb5ZptueUgJcwlMYropqv0U2FJUsFZA09cFFWCATDVSDntYnVV86/ebGuJjiSTfAaW6gyzA/NW
	ESSSCzozVPGIuxyVIODtfvqBqLh+Bw9nmCSm2IHAkXZuK2lwsSB9UVrrY314VdlFwK6fvhBaRkL
	D4osXcOi7IQDrXtrWAP1829Ss4fILxxALEmkNBT86rKh8QjmOFpT+F3Z0UprUKHZ7ioho+RWb0b
	lwu+sal6Zpw+IwYes/v376YroG3LyO1B1YwxDP3MBWdmPZMLvq0BRWJeGYfZH97ht93BxFu4jJt
	DUJ7KIdCjqkHz5uBtMMGkmTh+lK0Y2JjdonEPJ6wGlk3R24HoACnSt3ZNFAqfL0s9XCavMg15Cp
	GxCBHe9JB1jJtgM8iz7JVQ/f8f+eHD10ILuGPg+6JfQB05ZpzXjM/lD+1bTEhPrdv8xrHG/3O1G
	pA6NUdBJQISCEem3Xc9Lxb2b6C7T0BHbCN+uVOcsVXlHaFme2Ygg1ReRI+wROPR1o6vGZB6WdtK
	HEUE/MIpcMQX/9d8eN/uKad2SQQpNrZ9h6sE9Hnsh8+x7qMY04nRGVmDJKX0DW1aJMQg6UK9Yin
	ro4Po1jypBW
X-Received: by 2002:a17:907:7294:b0:c40:4965:72bd with SMTP id a640c23a62f3a-c4d34b9dcd6mr240284666b.19.1793978209530;
        Fri, 06 Nov 2026 07:16:49 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d3566e938sm87052866b.37.2026.11.06.07.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2026 07:16:49 -0800 (PST)
Message-ID: <9f58f49d-48e9-4567-b626-fa08d0a921a3@gmail.com>
Date: Fri, 6 Nov 2026 16:16:48 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] iommu: Fix dev_iommu memory leak in
 iommu_fwspec_init()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <57f56c9f-1822-4606-98fd-ebb96dbf8de8@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <57f56c9f-1822-4606-98fd-ebb96dbf8de8@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/26 23:44, syzbot wrote:
> In iommu_fwspec_init(), dev_iommu_get() is called before allocating the
> struct iommu_fwspec. When dev->iommu is NULL (such as during mock device
> creation in iommu_mock_device_add()), dev_iommu_get() allocates and assigns
> a struct dev_iommu to dev->iommu. If the subsequent allocation fwspec =
> kzalloc_flex(*fwspec, ids, 1) fails, iommu_fwspec_init() returns -ENOMEM
> without rolling back the newly allocated dev->iommu. In callers like
> iommu_mock_device_add(), this failure results in an early exit before
> device_add() is invoked, so subsequent cleanup via put_device() does not
> trigger bus release notifications and dev->iommu is permanently leaked:
> 
> BUG: memory leak
> unreferenced object 0xffff8881121d1340 (size 64):
>   comm "syz-executor358", pid 6003, jiffies 4294942186
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc 0):
>     dev_iommu_get drivers/iommu/iommu.c:408 [inline]
>     iommu_fwspec_init+0xe2/0x1e0 drivers/iommu/iommu.c:3086
>     iommu_mock_device_add+0x31/0x110 drivers/iommu/iommu.c:385
>     mock_dev_create drivers/iommu/iommufd/selftest.c:1026 [inline]
>     iommufd_test_mock_domain drivers/iommu/iommufd/selftest.c:1068 [inline]
>     iommufd_test+0x1e1b/0x30f0 drivers/iommu/iommufd/selftest.c:2104
>     iommufd_fops_ioctl+0x2e8/0x3c0 drivers/iommu/iommufd/main.c:556
>     vfs_ioctl fs/ioctl.c:51 [inline]
>     __do_sys_ioctl fs/ioctl.c:597 [inline]
>     __se_sys_ioctl+0xbc/0x130 fs/ioctl.c:583
>     do_syscall_64+0x126/0x350 arch/x86/entry/syscall_64.c:84
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Fix this by reordering the allocations in iommu_fwspec_init() so that
> kzalloc_flex() is called before dev_iommu_get(). If allocating fwspec
> fails, dev->iommu is left untouched. If dev_iommu_get() fails subsequently,
> fwspec is freed with kfree() before returning -ENOMEM.
> 
> Fixes: 72acd9df18f1 ("iommu: Move iommu_fwspec to struct dev_iommu")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+fe84fc6a684e0beb86e2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fe84fc6a684e0beb86e2
> Link: https://syzkaller.appspot.com/ai_job?id=54355447-b374-414a-9297-218fdbc7e977
> To: <iommu@lists.linux.dev>
> To: "Joerg Roedel (AMD)" <joro@8bytes.org>
> To: "Will Deacon" <will@kernel.org>
> To: "Joerg Roedel" <jroedel@suse.de>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Robin Murphy" <robin.murphy@arm.com>
> 
> ---
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index b486b8bbd..8da858154 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3083,14 +3083,16 @@ int iommu_fwspec_init(struct device *dev, struct fwnode_handle *iommu_fwnode)
>  	if (fwspec)
>  		return iommu->ops == iommu_fwspec_ops(fwspec) ? 0 : -EINVAL;
>  
> -	if (!dev_iommu_get(dev))
> -		return -ENOMEM;
> -
>  	/* Preallocate for the overwhelmingly common case of 1 ID */
>  	fwspec = kzalloc_flex(*fwspec, ids, 1);
>  	if (!fwspec)
>  		return -ENOMEM;
>  
> +	if (!dev_iommu_get(dev)) {
> +		kfree(fwspec);
> +		return -ENOMEM;
> +	}
> +
>  	fwnode_handle_get(iommu_fwnode);
>  	fwspec->iommu_fwnode = iommu_fwnode;
>  	dev_iommu_fwspec_set(dev, fwspec);
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
Please move the fix out of iommu_fwspec_init() and into
iommu_mock_device_add(), and leave iommu_fwspec_init() unchanged. The
same core-level approach for this leak was already rejected by Robin
Murphy on 2026-11-02 [1]. iommu_fwspec_init() is designed to run
together with iommu_probe_device() or with a caller that cleans up after
a failure, as of_iommu_configure() does. The defect is the early return
in iommu_mock_device_add().

The leak happens because iommu_mock_device_add() returns the error of
iommu_fwspec_init() without freeing dev->iommu. iommu_fwspec_init() can
allocate dev->iommu with dev_iommu_get() and then fail to allocate the
fwspec. The mock device has not been added at that point, so no bus
notifier will ever call iommu_release_device() for it, and the
put_device() in mock_dev_create() frees only the mock device. When
iommu_fwspec_init() fails, iommu_mock_device_add() should call
dev_iommu_free() if dev->iommu is set. The check is needed because
iommu_fwspec_init() can also fail before it allocates anything, for
example when dev_iommu_get() itself fails. The existing dev_iommu_free()
on the device_add() failure path is correct and must stay. One error
label shared by both failure paths is a clean way to write it.

Please change the tag to:

  Fixes: 2a918911ed3d ("iommufd: Register iommufd mock devices with fwspec")

That commit added the early return that leaks. The current tag names
72acd9df18f1, a v5.7 change, so stable tooling would try to carry a core
change to trees that do not even have the mock helper, which only exists
since v6.18.

The commit message has to describe the new placement: name the early
return in iommu_mock_device_add() as the cause and explain why nothing
else frees dev->iommu for a mock device that was never added.

While rewriting the message, please also keep it short. From the
kmemleak report, the allocation chain (dev_iommu_get, iommu_fwspec_init
and iommu_mock_device_add with their source lines) is enough. The hex
dump, the object address, the comm line and the syscall entry frames can
go. Two or three short paragraphs are enough for this change.

[1] https://lore.kernel.org/all/7e209fb2-4bda-4207-9109-c67c8df41e05@arm.com/

-- 
Krystian Kaniewski
