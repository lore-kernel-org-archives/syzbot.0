Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD64D23EA85
	for <syzbot@lists.linux.dev>; Tue, 21 Oct 2025 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761054375; cv=none; b=pfDi3JOhGy6H6xbHhgk+qJ6Y30BOuRngXHgz+kHo0qMB5m6a7dWScZoVzpI7DBQX0eJDT8OFGnsIEJ0d35jR2OVSc+h53Dat7KVo1GtM10RZMAc8wUHcFXO3mej3dlMlyeTi1fOCvqx2qG10whw1vlEkNRodin/y/RJkUwz2hNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761054375; c=relaxed/simple;
	bh=wSBT4WRUHcy2y7CRfbRp5HScwI4uqKIotM4kkWmE4IA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=KXXgFWYASkELileUxGYXW/Q4sV7YJSSbF/jkzcAeqgR/fDOtcR54fsW1RzP9AK17P6bCMZrOs2oX6gbbQc9oHuZgs8jhneF0YvV8NazRS6SyMMNViTVoNEJjqUgitBxBua6MKmCSbw9GqNdpgKNP865YNdoZeqq9PLjdTfq0jkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8870219dce3so595155239f.0
        for <syzbot@lists.linux.dev>; Tue, 21 Oct 2025 06:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761054372; x=1761659172;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEalx/s2eQ/HNb6VmIqPC5GkQaBiLp2HhUjm5DMsdaY=;
        b=M6RoaY6QFcJOEbUywyha0dHKR4+rQiDbu9ULJXydgecp2Si3kaVvkZDV4CQgeT/d1r
         7sQRpbupSMdjtKXliWqLUXB0+PqnC9Adcl5aSwWdxRYN2aACFYoFNO+DwfuAaReKZbLN
         2wvdWaqqgNCdawiBz+jSIt7IjQQ8CupJmEFDLG8H0Hjwn6AC4HBk4+MVTz/f58+M0f0Q
         45yPhr0WetGgKDrpZqAPNfrYeTxqTWq/qE9dEWtB4/nuOQCBWrDjB7A+Rkoze7BTEsGI
         UaFuyPw4ZMjDGofCccSAM8tOAzSNzaw00rgUkh78PI9jA+M3kVPwTIjbPTVMZBSkkvny
         e6Qg==
X-Gm-Message-State: AOJu0YwCUtvwyzDL1k1nbF8DzZEmS8v/dFK3rMnrYl6YjYlTaTeq1vJx
	+csOdX6iJBnZ7o51ggUwfnoNNBN9rgLJPuO7Pals6YZoPebY+ppayowXhBG2XKwkAhthxWr3+/S
	Oc7M1KQGA16f4KLazWkhFjKNQyQ/Nz1OpksptcYCP5Wmq5cWNNw4gfJlJz70=
X-Google-Smtp-Source: AGHT+IGC8RrcwGLawOCRB3Cg541qmmyg4uszPz/CpfYBrZZ5vwohi0L0m1ut2MHsHf2NCIDq8Ui3xeNtdzIs1pLWUOavHXBHCiJM
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17c8:b0:430:ae26:7c28 with SMTP id
 e9e14a558f8ab-430c524cea4mr53009805ab.1.1761054372005; Tue, 21 Oct 2025
 06:46:12 -0700 (PDT)
Date: Tue, 21 Oct 2025 06:46:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f78ea3.050a0220.346f24.001a.GAE@google.com>
Subject: [moderation/CI] Re: drm: Reduce page tables overhead with THP
From: syzbot ci <syzbot+ci79496dbac0c596d0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] drm: Reduce page tables overhead with THP
https://lore.kernel.org/all/20251021113049.17242-1-loic.molinari@collabora.=
com
* [PATCH v5 01/12] drm/shmem-helper: Simplify page offset calculation in fa=
ult handler
* [PATCH v5 02/12] drm/shmem-helper: Implement map_pages fault-around handl=
er
* [PATCH v5 03/12] drm/shmem-helper: Map huge pages in fault handlers
* [PATCH v5 04/12] drm/gem: Introduce drm_gem_get_unmapped_area() fop
* [PATCH v5 05/12] drm/gem: Add huge tmpfs mountpoint helpers
* [PATCH v5 06/12] drm/i915: Use huge tmpfs mountpoint helpers
* [PATCH v5 07/12] drm/v3d: Use huge tmpfs mountpoint helpers
* [PATCH v5 08/12] drm/gem: Get rid of *_with_mnt helpers
* [PATCH v5 09/12] drm/panthor: Introduce huge tmpfs mountpoint option
* [PATCH v5 10/12] drm/panthor: Improve IOMMU map/unmap debugging logs
* [PATCH v5 11/12] drm/panfrost: Introduce huge tmpfs mountpoint option
* [PATCH v5 12/12] Documentation/gpu/drm-mm: Add THP paragraph to GEM mappi=
ng section

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d2299587-6194-4c73-85f9-de73845f82fb

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      fe45352cd106ae41b5ad3f0066c2e54dbb2dfd70
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/13dfd2e4-f89b-4c17-9c86-16da12c742d=
8/config

drivers/gpu/drm/drm_gem.c:1297:10: error: too many arguments to function ca=
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

