Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F96431D734
	for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 18:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798946; cv=none; b=qw2oRzWmUyUmRQaSxwJHUVp6PewYNkNp5310PEdDUUHobreWm8IIjDSJKSXrUQ6bYcP7QRRjLOZhStWY1fwC4juIfkxT4GviFtpmb49JQNscUCheVrzTqmziUwhtwds3EryqiEgEYsHM4FWFptJype2ugl8tb+Yc+RfqCDUPfuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798946; c=relaxed/simple;
	bh=WNCvp7lObRT7YNh1tdx7MwdvHCleXY7fn0OmT9F1ng8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=GElTZKxshV8yko7oCd2JEJNhkH9ZHI9UqiwOxGI/mSGqBQKDMgzyXshle229VJLfMsZkCk3BNtk0wr/A32W0a+oDQFNMylrvxo6tMg9GuKK//5ghpbixt1deKk7uZb7F+LDw7ejK1MlVJ++LdMirqrl313sNLhHgxFttgm4eW/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-940f98b0d42so463321139f.3
        for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 10:22:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762798944; x=1763403744;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=//izLCJQRMLj4Quqh5j72BQyVorb/nFCP5bVf1zSroA=;
        b=YI5etHaQglQvZAy9Mk/NeiXw+/vj3ywK2zET14k5B9eEISHjLcmoPqA7luNvGDBJNK
         WW69FboVZg9C16T6B/zr4LUFcu3wkeRPMrycS6EX+BWZpq/+qAH+URx0eFUHx+4lo6UX
         +5Sx5i5ytD5Gdh46hez/K1h1VV4nIrAACBYM+/2VSTFB7WF+qknFK9Qj9yEv+/KCc1P/
         6S1yLqDqcY0M/vAbWU5webJT2xRzAaERkOoY3rMKZxoaPS9dUhFM7BoRDAFg4BVRn9sO
         ysWQUMfcSOKeVvnt3O4MH7FtmxEvfW2ECy95KprChzs0htggtqxduF3it01ZvyQfwKmc
         NGAw==
X-Gm-Message-State: AOJu0YyMyJdh6V7/M0BoLFlOy832r0fBvgqFWBMesYXAmjL5jh8ORrvM
	8XGVtmU7GLV/nkwGmSQP1IXn2PSFcXgm+pzMnfYs7naOe0Cq6sR7dVFOIow5fsBGE9yNlP66tqW
	U0Z2VkUgDYawVtVYvVmMqENhLXZ7Y7lWK2Z0X5+9k0XNhqiiQZlymrFO6854=
X-Google-Smtp-Source: AGHT+IHK/kOfa1qqqoxQxC8o/83YHkoJO8s/RBO9rDa5uOMITrPwksqi+FOEIrrowwGQv1wkzSdFBunqmdaXbEnrOtkQBEYRohq6
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3d87:b0:433:7083:dd0a with SMTP id
 e9e14a558f8ab-4337083dedamr111029815ab.25.1762798944265; Mon, 10 Nov 2025
 10:22:24 -0800 (PST)
Date: Mon, 10 Nov 2025 10:22:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69122d60.a70a0220.22f260.0100.GAE@google.com>
Subject: [moderation/CI] Re: drm: Reduce page tables overhead with THP
From: syzbot ci <syzbot+cic4590ccd2dbf62e2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v7] drm: Reduce page tables overhead with THP
https://lore.kernel.org/all/20251110155000.2936-1-loic.molinari@collabora.c=
om
* [PATCH v7 01/11] drm/shmem-helper: Simplify page offset calculation in fa=
ult handler
* [PATCH v7 02/11] drm/shmem-helper: Map huge pages in fault handler
* [PATCH v7 03/11] drm/gem: Introduce drm_gem_get_unmapped_area() fop
* [PATCH v7 04/11] drm/gem: Add huge tmpfs mountpoint helpers
* [PATCH v7 05/11] drm/i915: Use huge tmpfs mountpoint helpers
* [PATCH v7 06/11] drm/v3d: Use huge tmpfs mountpoint helpers
* [PATCH v7 07/11] drm/gem: Get rid of *_with_mnt helpers
* [PATCH v7 08/11] drm/panthor: Introduce huge tmpfs mountpoint option
* [PATCH v7 09/11] drm/panthor: Improve IOMMU map/unmap debugging logs
* [PATCH v7 10/11] drm/panfrost: Introduce huge tmpfs mountpoint option
* [PATCH v7 11/11] Documentation/gpu/drm-mm: Add THP paragraph to GEM mappi=
ng section

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1ecba15f-79c3-40ff-99c6-8f3540bddf65

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      9c0826a5d9aa4d52206dd89976858457a2a8a7ed
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/bbe8396b-ae74-40bd-a351-2850eb51f8c=
e/config

drivers/gpu/drm/drm_gem.c:1315:10: error: too many arguments to function ca=
ll, expected 5, have 6

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[airlied@gmail.com akpm@linux-foundation.org andi.shyti@linux.intel.com bag=
asdotme@gmail.com baolin.wang@linux.alibaba.com boris.brezillon@collabora.c=
om brauner@kernel.org corbet@lwn.net dri-devel@lists.freedesktop.org healyc=
h@amazon.com hughd@google.com intel-gfx@lists.freedesktop.org jani.nikula@l=
inux.intel.com joonas.lahtinen@linux.intel.com kernel@collabora.com linux-d=
oc@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org liviu.du=
dau@arm.com loic.molinari@collabora.com maarten.lankhorst@linux.intel.com m=
canal@igalia.com mikolaj.wasiak@intel.com mripard@kernel.org mwen@igalia.co=
m nitin.r.gote@intel.com robh@kernel.org rodrigo.vivi@intel.com simona@ffwl=
l.ch steven.price@arm.com tursulin@ursulin.net tzimmermann@suse.de viro@zen=
iv.linux.org.uk willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

