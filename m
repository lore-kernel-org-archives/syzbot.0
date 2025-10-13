Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B6149659
	for <syzbot@lists.linux.dev>; Mon, 13 Oct 2025 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760378094; cv=none; b=g9qKwwVhgr0ZjDViiroyOm1vHsGddE2pBk1xCNBXG2zig2yyr51vey/1LBsz4ejLpNG5sv4qVmwRRYIyeuuDvJeNN7gB3XoxlrnLqKbG/xyqlOQAFVeeyA4g6D3Vzmi0k7FvqNA9/1K4kISajWMPBvOZUDCaou5ZEtzqhPoO6eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760378094; c=relaxed/simple;
	bh=tFpI9SllS5mjHGNtJeZrx7ZpLqNCw4rpIgMgf6SavDA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ocgcDRo1JFWB5jVQQ892kRS8Y72mQWSH8z4w4QmUA57Qp1v4g+4Rs2VI2VqlWZ/GJgUVAU3PK1w/Z++PxprKu/ylXPCJhHCZKT/hYMmD/n0SkpjnJ8/VyzCZQ/XxciUGDtoignhXp19+P4IzzZ6T534JaTfDopLhofDtqO4rerM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4256ef4eea3so129245135ab.1
        for <syzbot@lists.linux.dev>; Mon, 13 Oct 2025 10:54:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760378092; x=1760982892;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bofdFRSNC71zTmqPB2Rh238TPQCwizrnqUW1avGK8og=;
        b=lRSh+n69MN8FkWg8T+0KVbjmjRNYM6fiPp7xvlh5FPtzkLODTShd6bu2ZL3bdaqP98
         OWN9pjim+dsAvEM2HOhkTmLE0SxrHpI8uXGtsX5FJ2KqC1WYBjMKZexU5Qz/CS3jKaPa
         ckdeMeA+FsDcnixFLHc6bl7KVzRAFBszktJSE1mdoDUZ+6Yz3BxSH/vFeHLvwMsbTjrn
         CWG/x4WqI6DtsmQrPZ4HNVcZfJxjpi35jAWiEtELl+D60WUEuIk4erIa98bc9D9j6j7q
         Ojy6hiBkUFKZO3xdTGl7JznQK0cJTIuVo1gEVWWxpsMBpiEyZhdMEznYB0RPyvm6T46c
         DOEg==
X-Gm-Message-State: AOJu0YyR+BM5mwrkEqIOXUA0/FYDiMxltgIXLzJ7Ur8SeBBBtl8yrfoB
	6qct+fQRC/aQgvhwHalInZPSEQibAWxDVrfVDHoBu13OaL9Xq9rMxb23HOQGqBypmitThE2EuB5
	jZmWybzNsgPh9yCBlOpLnu5/jFJ23hPDfS1rAiQRqhnipA796XTp/Fx4e6vs=
X-Google-Smtp-Source: AGHT+IEkNT7e4MnHDKyQz/kkZMWEKq5IqiINiSJEWu2UXfwNnq5KxDxmhrM7CV3EzjqB3f75035eboEWTzO19S6w8R5gGkeKfnpm
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a8e:b0:42f:9e92:a448 with SMTP id
 e9e14a558f8ab-42f9e92bb89mr117327905ab.7.1760378092321; Mon, 13 Oct 2025
 10:54:52 -0700 (PDT)
Date: Mon, 13 Oct 2025 10:54:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ed3cec.050a0220.91a22.01e9.GAE@google.com>
Subject: [moderation/CI] Re: virtio_net: Add ethtool flow rules support
From: syzbot ci <syzbot+ci454bc7cba78429ac@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] virtio_net: Add ethtool flow rules support
https://lore.kernel.org/all/20251013152742.619423-1-danielj@nvidia.com
* [PATCH net-next v4 01/12] virtio_pci: Remove supported_cap size build ass=
ert
* [PATCH net-next v4 02/12] virtio: Add config_op for admin commands
* [PATCH net-next v4 03/12] virtio: Expose generic device capability operat=
ions
* [PATCH net-next v4 04/12] virtio: Expose object create and destroy API
* [PATCH net-next v4 05/12] virtio_net: Query and set flow filter caps
* [PATCH net-next v4 06/12] virtio_net: Create a FF group for ethtool steer=
ing
* [PATCH net-next v4 07/12] virtio_net: Implement layer 2 ethtool flow rule=
s
* [PATCH net-next v4 08/12] virtio_net: Use existing classifier if possible
* [PATCH net-next v4 09/12] virtio_net: Implement IPv4 ethtool flow rules
* [PATCH net-next v4 10/12] virtio_net: Add support for IPv6 ethtool steeri=
ng
* [PATCH net-next v4 11/12] virtio_net: Add support for TCP and UDP ethtool=
 rules
* [PATCH net-next v4 12/12] virtio_net: Add get ethtool flow rules ops

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/92d05cd4-4dd5-492f-abd1-f6642ecc0750

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      18a7e218cfcdca6666e1f7356533e4c988780b57
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/fdac0019-d488-4540-91f7-9dfd607d464=
e/config

drivers/virtio/virtio_pci_modern.c:326:26: error: no member named 'support_=
caps' in 'struct virtio_admin_cmd_query_cap_id_result'; did you mean 'suppo=
rted_caps'?

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alex.williamson@redhat.com andrew@lunn.ch danielj@nvidia.com edumazet@goog=
le.com eperezma@redhat.com jasowang@redhat.com jgg@ziepe.ca kevin.tian@inte=
l.com kuba@kernel.org mst@redhat.com netdev@vger.kernel.org pabeni@redhat.c=
om parav@nvidia.com shameerali.kolothum.thodi@huawei.com shshitrit@nvidia.c=
om virtualization@lists.linux.dev xuanzhuo@linux.alibaba.com yohadt@nvidia.=
com]

If the report looks fine to you, reply with:
#syz upstream

