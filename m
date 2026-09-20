Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E03143A7FB
	for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 12:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789907714; cv=none; b=GKVXte/G2s/5Zz7nI/JHkhRRL7D7Nv7M9TYim7+V3jNzKytguIS1GGp30VhoWNHY8X0WqPqhGoIrb0i1N+S736p8bK4obSRL2ePJPvjSPjMqsp/citCJJmiTD+QgumO3WGuE0jlaA2WuL6DtJ165Iqv2WIdP4eg/2lel+KcAeqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789907714; c=relaxed/simple;
	bh=6krTSyy2BJMWzJj7pqOruZeNMVY5gkt6/KYk2hluBs8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gt704sotSkC9s+acVoXoN5dur2y3B0jkJmOY7L/aNXmtTq+uC8xQUkcaJnsTOKaSpA1mzWqvnBpPa0JxAGVeCcQBfEgY4tR7HnWJeEELHNK+LJuP8F29GE3BINgTeGr0xNjeIncfZAvM4SOeHX8Kyd803rL3bCeCume6KLPIW0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-482966c4f4fso5020035fac.1
        for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 05:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789907699; x=1790512499;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6vYeh1t71XOXT2uD26iZSXtrau5cFSa7ZoIXWwl78Ts=;
        b=LYjsqQqtzGDASmUhVxHVp+rKik2QpC6lWkitc5AnjXy5Qvo60mtLNqp/yiAiZGJMMn
         UEQm0GSAaOQ2M3QOffy6/WdfCz86NElhjBfDiKOmDjfELtZccxap+AltW/QUwz4VWeaV
         rr3uBXG79ml0V0bLZ4KS1CcQf4akcLiiJyIrG/c/pSt7nbi+Tztty4nppA75rzQpkWvj
         hP7wrrYfPM05eBzQKDckCJhtG/s3h0/X/dtdjLsCbJmyJrWbb3YVSL0mw4yJVI+GtDQd
         oGjnpd2pBk+y4Q4nMae6eStrTIurB1Uh8VEu3vJuOnL1A/2j9rty/v54gxiQ1KWhiL1j
         g6KA==
X-Gm-Message-State: AFuF++lclREOy9dPENFopxQdyKUcsb+cArryrL7/4YM1slb47jhYqmBN
	jCB5N5mIBjmtb8m6mqBLMHiTBtbcOT/b6QLkjiPIWOz6yKksge/Rm7UU+FfR7dIlGWEg7iPMoIf
	JqkxBYN02p8NAqVa0VhMW8dOoWDaHqgetEp1mN+1d3/LqRSiOTi/mfcPSE/U=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16ab:b0:6b6:aee6:c81f with SMTP id
 006d021491bc7-6c8ff30277emr9612010eaf.36.1789907699328; Sun, 20 Sep 2026
 05:34:59 -0700 (PDT)
Date: Sun, 20 Sep 2026 05:34:59 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aafd2f3.3179f8cd.1e36b2.000f.GAE@google.com>
Subject: [moderation/CI] Re: hfsplus: validate b-tree fork extents at mount
 and inode read
From: syzbot ci <syzbot+ci64b8b93d66db86d2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v6] hfsplus: validate b-tree fork extents at mount and inode read
https://lore.kernel.org/all/20260918085156.920842-1-ngocthang2710.1999@gmail.com
* [PATCH v6] hfsplus: validate b-tree fork extents at mount and inode read

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1a9ef6de-01d7-4a6e-a590-94670355d046

***

kernel build error

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      33d280b462dfabeae3264b462d4e91339320be00
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a34c3b73-64be-44d9-b975-48f355468b18/config

fs/hfsplus/inode.c:562:5: error: conflicting types for 'hfsplus_inode_read_fork'
fs/hfsplus/inode.c:571:11: error: call to undeclared function 'hfsplus_check_fork'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/hfsplus/inode.c:574:10: error: use of undeclared identifier 'HFSPLUS_I_CORRUPT_TREE'
fs/hfsplus/inode.c:580:33: error: use of undeclared identifier 'HFSPLUS_EXTENT_LAST_IDX'

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
[frank.li@vivo.com glaubitz@physik.fu-berlin.de linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org ngocthang2710.1999@gmail.com slava@dubeyko.com syzbot@syzkaller.appspotmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

