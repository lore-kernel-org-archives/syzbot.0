Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4211F291C16
	for <syzbot@lists.linux.dev>; Thu, 10 Jul 2025 09:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752139354; cv=none; b=imoWaO2eZhthDDqD6zRoPw9JnFQb0f5scpRm0G5Aio4ftz54e1A8HVxV55BphQPy0aUXDfEwVkYUeqfkyVVHmvzrXjBsCL7az3M9MitE0k35/cHbo9y8VF5IeH5Ce9UU1OK76onY1Uu1Q7AnT0Lr71NaOJwjO3BZIBgiP6fE+lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752139354; c=relaxed/simple;
	bh=Ubho0Q/2TDR7/a7MnTFePohUzBFTM+KIZOvucZ2b+aU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=S+654Xrf3XMWSiyq6dR9nxi6OhxUkSupXJiKmaOxZdtO6SP3BdS/c0zv+aNaP+fSHgAOW2VqCbPtdYZF3gckKGIx1inx/sYvit15lPyPVFhC2vPQB3sThPPSmvtkK5ZAz5MRXqVpuyx5hucaXDpu7eDCKZxhqFjeO0TIWrix+pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ddc0a6d4bdso8496305ab.0
        for <syzbot@lists.linux.dev>; Thu, 10 Jul 2025 02:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752139352; x=1752744152;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=811L7On//zc6KEnnmxGDxm5a2GIyhecKCVEm858mvYE=;
        b=JaYztu0KR5/NPusz0NAqy+iJ05kQHJf+25GlFaq1lgN/F/lqAz6Tu/qO85a4/DsrRP
         LFlt/1wScOxy1tyuAyuk+gZDd1l267l2J1QWf2zKJYmP16OxP6Q2FN6/sHR9/AOzDTdz
         ox7dBFHEw5S5/b7T23v4MyU7BNT646mWnojSBBU2ut0mY884mkzochzTBLMRaE8GqO3Q
         5GeqN9QFaMZCPAw++RLqJH/GrT5DQgOm5WVqL4GcB8U5L96z/E25GSepfUiHHiXiVFsX
         gUxXZIfmWo9OgpHxk/r8nkUPF4CYT1t0+6oW/PY3sMzB3yKIOT/kcF+t8ZrCT7MeDQKK
         u7xg==
X-Gm-Message-State: AOJu0YwX39WLOsntejee/LCWZ0GrLVdBD5uMI7Y71myIlBoH5nEuHysG
	tDMd7MF51GpXbDArZQHHXaWwotUG5ZZK8Gzxw2QNnRSwJxOUCoFd3ILfv2qOgnKGwMFdTO8E4wW
	Pa8HKULJktOu0m8igvnMRta5PDc+bLodDbJmH2PQygsEViuFL9uH2AFMBJYA=
X-Google-Smtp-Source: AGHT+IFn7OBz6zYUiDaBI7QWgiT7X+JflZyM0Tzal8RJ5aZaPgPD2P1iW2azUHL2SrJSRiu2eO0U9CxyDZSERdyHClrP487ZQEy2
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a4f:b0:3df:39e2:f1a8 with SMTP id
 e9e14a558f8ab-3e2461e0fcemr12490965ab.16.1752139352338; Thu, 10 Jul 2025
 02:22:32 -0700 (PDT)
Date: Thu, 10 Jul 2025 02:22:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686f8658.a00a0220.26a83e.0009.GAE@google.com>
Subject: [moderation/CI] Re: ipv6: Drop RTNL from mcast.c and anycast.c
From: syzbot@syzkaller.appspotmail.com
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has processed the following series

[v3] ipv6: Drop RTNL from mcast.c and anycast.c

* [PATCH v3 net-next 01/15] ipv6: ndisc: Remove __in6_dev_get() in pndisc_{constructor,destructor}().
* [PATCH v3 net-next 02/15] ipv6: mcast: Replace locking comments with lockdep annotations.
* [PATCH v3 net-next 03/15] ipv6: mcast: Check inet6_dev-&gt;dead under idev-&gt;mc_lock in __ipv6_dev_mc_inc().
* [PATCH v3 net-next 04/15] ipv6: mcast: Remove mca_get().
* [PATCH v3 net-next 05/15] ipv6: mcast: Use in6_dev_get() in ipv6_dev_mc_dec().
* [PATCH v3 net-next 06/15] ipv6: mcast: Don&#39;t hold RTNL for IPV6_ADD_MEMBERSHIP and MCAST_JOIN_GROUP.
* [PATCH v3 net-next 07/15] ipv6: mcast: Don&#39;t hold RTNL for IPV6_DROP_MEMBERSHIP and MCAST_LEAVE_GROUP.
* [PATCH v3 net-next 08/15] ipv6: mcast: Don&#39;t hold RTNL in ipv6_sock_mc_close().
* [PATCH v3 net-next 09/15] ipv6: mcast: Don&#39;t hold RTNL for MCAST_ socket options.
* [PATCH v3 net-next 10/15] ipv6: mcast: Remove unnecessary ASSERT_RTNL and comment.
* [PATCH v3 net-next 11/15] ipv6: anycast: Don&#39;t use rtnl_dereference().
* [PATCH v3 net-next 12/15] ipv6: anycast: Don&#39;t hold RTNL for IPV6_LEAVE_ANYCAST and IPV6_ADDRFORM.
* [PATCH v3 net-next 13/15] ipv6: anycast: Unify two error paths in ipv6_sock_ac_join().
* [PATCH v3 net-next 14/15] ipv6: anycast: Don&#39;t hold RTNL for IPV6_JOIN_ANYCAST.
* [PATCH v3 net-next 15/15] ipv6: Remove setsockopt_needs_rtnl().

and found the following issues:
* failed to build the kernel

The series was applied to the following base tree:
* Tree:   
* Commit: 

Full report is available here:


***

failed to build the kernel




---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[]

If the report looks fine to you, reply with:
#syz upstream

