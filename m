Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD532FD1CB
	for <syzbot@lists.linux.dev>; Fri, 17 Oct 2025 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760721007; cv=none; b=NZuDCP93MoVb1LA8Muo3zHZZRrm63wSgaZRdoobiL0GeiUBgG0GAZFdFTQKbjZH4+/IeQO8NvrG9wK46H7BVpk34vEkUNBQYOc9cCiUROLa2a2f8ifrQ487iqkF+4xD5o7c0eOSijDDN9iilvFfC3tl3YTHc8nR//lW8qkEgJJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760721007; c=relaxed/simple;
	bh=8aNbOf/uWN47P7/EpPIV4Epb3z4n4VFrQyARacmY46g=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=TfdVklwSahJY0hqeftX7vvW6cAUn+qXy+zzZ8WNYjsLFiQ3BWSHoGAKeHP898mbVtHfHh1d7pF5oKR6BOVWZsn3+FbSBAj5syLSd2W4bYtQPpDyQZjEvFpPUKNqzOdgB+gtZvNqPOMuYf5KHmE3TzkkeBfThznAC1tzOVnKMUW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-430b3c32f75so19262215ab.0
        for <syzbot@lists.linux.dev>; Fri, 17 Oct 2025 10:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760721004; x=1761325804;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4cL78gEmmmg17Tz9dd3vD7oXHpI0TTNLU87vJiTFxU8=;
        b=mow3wzLr00YsU8fCh7LA+P3szIX66iuUTAaXDkaaDdDgdMp9kLHnrSQEYwjHJwtFva
         Q5TSXd9FHjg54GdRxEQB1bjhd5nPYqbiXXqF+bxxJEYbKDr34DxsjV85zcEeKGAx8TQ2
         kA4IOnR6b5O4lqThOZm1oQKvaLSlTaPtlQiqLJ8p477lQIwpP05iga1xQEGfWyUs6+aP
         IlxBJsqahItLHX5tZC9iAFBpq1NdndvAmpMSY4u4QJgIAPG5rSdvEUBrJagcihNls9JL
         DM0cQVD0Zv9K1+6mcr5D7xIoyjZ9SeSaxt4yt4/MBdNRldq+l2QV2m1uvJh4Kyh7mT7W
         Gz5A==
X-Gm-Message-State: AOJu0YwdZV6hxXh3/T7eN+ugfvDZdRe17aWAWaah+ZWtxJAewLG9upUs
	+TSCzamWkx7aTLXMTlTmsKe8hOvJxKBPrAvt8eRf7xmxxgQV5cIuAL04Sg3y9ZTGvJrs7+tq7/5
	fdiqyVNzU7PAEKPzTNakCnSMwf1rvCmYtUiJAUmMftFfUmlbCbwaOJaW82tk=
X-Google-Smtp-Source: AGHT+IHQr2W57b8Mc2GtehvHbVPq2/b2mJrgrs1IC9RoJ07J3z7c35ulf4MA7IQFoMziBdiDWVv/ZTvCcitWwAWOLEpHGinkXIF8
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b44:b0:42f:983e:e53a with SMTP id
 e9e14a558f8ab-430c5292341mr70497725ab.29.1760721004195; Fri, 17 Oct 2025
 10:10:04 -0700 (PDT)
Date: Fri, 17 Oct 2025 10:10:04 -0700
In-Reply-To: <23ddfb9b-1d22-4055-b60c-9a32d2dbf8ac@iogearbox.net>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f2786c.050a0220.91a22.0427.GAE@google.com>
Subject: Forwarded: Re: [syzbot ci] Re: netkit: Support for io_uring zero-copy
 and AF_XDP
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+ci7c73a60f40f79ce2@syzkaller.appspotmail.com>, 
	daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: Re: [syzbot ci] Re: netkit: Support for io_uring zero-copy and AF_XDP
Author: daniel@iogearbox.net

On 10/15/25 8:46 PM, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v2] netkit: Support for io_uring zero-copy and AF_XDP
> https://lore.kernel.org/all/20251015140140.62273-1-daniel@iogearbox.net
> * [PATCH net-next v2 01/15] net: Add bind-queue operation
> * [PATCH net-next v2 02/15] net: Implement netdev_nl_bind_queue_doit
> * [PATCH net-next v2 03/15] net: Add peer info to queue-get response
> * [PATCH net-next v2 04/15] net, ethtool: Disallow peered real rxqs to be resized
> * [PATCH net-next v2 05/15] net: Proxy net_mp_{open,close}_rxq for mapped queues
> * [PATCH net-next v2 06/15] xsk: Move NETDEV_XDP_ACT_ZC into generic header
> * [PATCH net-next v2 07/15] xsk: Move pool registration into single function
> * [PATCH net-next v2 08/15] xsk: Add small helper xp_pool_bindable
> * [PATCH net-next v2 09/15] xsk: Change xsk_rcv_check to check netdev/queue_id from pool
> * [PATCH net-next v2 10/15] xsk: Proxy pool management for mapped queues
> * [PATCH net-next v2 11/15] netkit: Add single device mode for netkit
> * [PATCH net-next v2 12/15] netkit: Document fast vs slowpath members via macros
> * [PATCH net-next v2 13/15] netkit: Implement rtnl_link_ops->alloc and ndo_queue_create
> * [PATCH net-next v2 14/15] netkit: Add io_uring zero-copy support for TCP
> * [PATCH net-next v2 15/15] netkit: Add xsk support for af_xdp applications
> 
> and found the following issue:
> WARNING in netif_get_rx_queue_peer_locked
> 
> Full report is available here:
> https://ci.syzbot.org/series/19b5990a-1eef-44da-a6f0-ffb03bd8adff

#syz test: https://github.com/cilium/linux.git pr/netkit-iouring2
