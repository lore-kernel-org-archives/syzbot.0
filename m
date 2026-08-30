Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A90E72630
	for <syzbot@lists.linux.dev>; Sun, 30 Aug 2026 05:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788067304; cv=none; b=euLAkBfZSSlyNWfCESfkAAWWDQLPjxjG23XABrhfvpGg2qBRO6DsrX28CWAuTCrCxW1QMNFfz/PpAD+dAytvOPR+OBcedyYaMK/shDJm5hvdVLus6TrvBDxxvWdqeqe3ZesYBZHnjQr/zykbef5OkZN4IXVDl5Um6nO3CYogufs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788067304; c=relaxed/simple;
	bh=eUS0aEjlACgDpjOcQoaLFCK/CKF96kfGlat2O61h9ZE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=EA51X49k9UAWkWmPs/ku8PFzuqC2bDLIGX8k1gxkaeBzeeA5JWfpIsj16Y4XVgD9jrnHaBKF54p9r13QN2hyOMUW7SzIeOZzMz+1dIe0R2XKGU/t/2nmn80wM5QIJWzEgJmexfXntXfOy3S8Er/uWSO+c9hQHXRiymisPAg3wBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b37733badcso4285274b6e.1
        for <syzbot@lists.linux.dev>; Sat, 29 Aug 2026 22:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788067302; x=1788672102;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RZGus1Sk/FDoDPEE3ui3zfErjsQr2y+kT9RbYtrKGsk=;
        b=ZXpjlcRQW5SNhvAsqvAO1EjnwgsBqXuGGGlyB3d4DNvCoPQzgohQOkjmTHuWQuWEsB
         8Y5RKaiCtOwNoIA1n0hAIePZu4P9bCoCtPHmzYbvNzwKHwHG5J5lg8dWJQ2jScqRCuIS
         lRgeoArUPdqgM5V5GKl1/pU6ce1Cgm0IGgqq2MErj3/g3ZcZfnCjz8apMU7HwAfy44E2
         XWpIBsjQ4m3UF53QwKRlthoT4aoQtQ4EKcfgyPVAtSRjo469k0QtE6cZAbPSg/F1EoqM
         gk6+xhwwNHMWeNLWTuMGXEGFXFF3A+VvmnXzgXodYZE/FktqyEawTIiyw0kY3yzhJjKz
         hLlA==
X-Gm-Message-State: AFuF++kmDqd7l7PtVVA84l8bheHKbK9ZE7kTMbkT1rZhpxlPI8pppoZ4
	RJJP7jRHjzxPA8WjCo+VJCxTmlXsht9p9z+B5fbWz1dAPQ1XptVsy6NLdFyuAIqEzb2xpw1ImsM
	Fs9/rJ6Y8oV9kQSiSX6Q+k+grfPeHLNM0CtYs8FurA6L83B+Hcn3B45iVYVY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fe8:b0:4b3:8d45:aa2b with SMTP id
 5614622812f47-4b398446f03mr20504157b6e.16.1788067302133; Sat, 29 Aug 2026
 22:21:42 -0700 (PDT)
Date: Sat, 29 Aug 2026 22:21:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a93bde6.4d659fcc.734b4.0035.GAE@google.com>
Subject: [moderation/CI] Re: Remove FGP_NOFS
From: syzbot ci <syzbot+ci4061e751499e87dd@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Remove FGP_NOFS
https://lore.kernel.org/all/20260830041901.2668-1-willy@infradead.org
* [PATCH 1/9] mm: Improve memalloc_nofs_save() documentation
* [PATCH 2/9] ext4: Remove uses of FGP_NOFS
* [PATCH 3/9] erofs: Remove redundant FGP_NOFS
* [PATCH 4/9] nfs: Remove redundant FGP_NOFS
* [PATCH 5/9] ntfs: Remove FGP_NOFS from __ntfs_inode_resident_attr_pwrite(=
)
* [PATCH 6/9] ntfs: Remove redundant FGP_NOFS from ntfs_wof_collect_dest()
* [PATCH 7/9] squashfs: Remove use of FGP_NOFS
* [PATCH 8/9] filemap: Remove redundant FGP_NOFS
* [PATCH 9/9] filemap: Remove FGP_NOFS

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/30b4b362-31a6-46cf-a7d0-8df2be654a16

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0bf0117c-21b3-4384-be5f-29194d5ea5e=
4/config

fs/f2fs/data.c:3903:40: error: use of undeclared identifier 'FGP_NOFS'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[anna@kernel.org chao@kernel.org christian@brauner.io hyc.lee@gmail.com jac=
k@suse.cz linkinjeon@kernel.org linux-erofs@lists.ozlabs.org linux-ext4@vge=
r.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org lin=
ux-mm@kvack.org linux-nfs@vger.kernel.org ntfs@lists.linux.dev phillip@squa=
shfs.org.uk trondmy@kernel.org tytso@mit.edu willy@infradead.org xiang@kern=
el.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

