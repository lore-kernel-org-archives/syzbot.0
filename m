Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABDF2C15A0
	for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 11:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789903677; cv=none; b=h0onydTSao/Yz4HvhQctYXPj/i6ybqnQBrH5tPxAlkZw1mdDkRAshs+KUC1mwUKIjWK4GANWPG5f7i6lzGTFxQXLF3YYasojez6AfX9BzPFNUKtO74rEMcy46tZnIaYgAXQtzO/ufjyvouORd1+24qUgQqaUp+S5qpUr6qJdjyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789903677; c=relaxed/simple;
	bh=8YOGwoIjJHiHarVQIoKvCM4+4cK5+Lq6ifxzY8Z7JLQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=BGHuWQftXg/yeLHxvmD+Dz/DfjE3MaTLYGcdvwOlyI79ajzBpmi37bCSx7z4fXcNL4A3eX+VYP590kywJd4pwIbKJ4ZAbcMBxkWvLLUwnthQ5ovHY1hxBkgKCUAp1sL8eAPvvlYwBN9vCHSscLzKS+w+laKYC6A1lJgT3QHIjGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6c07dcbe60eso2540944eaf.3
        for <syzbot@lists.linux.dev>; Sun, 20 Sep 2026 04:27:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789903675; x=1790508475;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1wkt2DV+rvzlKoQ0mQ0jqSIWxgLyI4nPP3GWz1CLiB4=;
        b=vbm27LjHMX7/bvsiiuRobAXTdYw2L77FwpZUQbkrJyDe1ewQznujgkMfgDLnsJbdoV
         ftRlLS6IM0g6twFsNnkEmRmc00qemFk0k9QSHC6mFGb7wactmbMOhRbrCSWrvBVuNkbG
         st1aSVEVidHHBWfGBWR4tFOMC8MdEwtR+khyOPPyBhlWFltckzDvN/njF1yBQ2fxzhXq
         agBYCnGgU6A3BBwJJXg+tWLjjDyTTCSe/5i2c2L0wNcSfBcdAABhKz6KOCsuD24q2LJA
         3QxfQJP3XPJdJ7WLGw0FUn/H3JkYai6uH2f3gIJMy/6/DZRwMw8aThuTT4h7xzuYkixj
         E9+Q==
X-Gm-Message-State: AFuF++nFF0uiF1lTz3N+uVdL2FArMMle9HJ4yYGNsjwTf/G6LTwrDuQB
	XYVYx6ealqjNaG+h7KXxNf+Vo0+vcSjXMEjaibRISLxO5xMNKL6qgXZSZc8PfwoJEcUs08vDXgl
	Wh3OsWQGi/3wpblanO4IyS9IqfZUUmgUbXanEE+918bMKulWIIo3hXLAsaO0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:188a:b0:6b3:619f:25ce with SMTP id
 006d021491bc7-6ca9b530193mr6770145eaf.30.1789903675023; Sun, 20 Sep 2026
 04:27:55 -0700 (PDT)
Date: Sun, 20 Sep 2026 04:27:55 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aafc33b.3179f8cd.1e36b2.000e.GAE@google.com>
Subject: [moderation/CI] Re: hfsplus: validate b-tree fork extents at mount
 and inode read
From: syzbot ci <syzbot+ci6541064be2703b1b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v6] hfsplus: validate b-tree fork extents at mount and inode read
https://lore.kernel.org/all/20260918083945.918170-1-ngocthang2710.1999@gmail.com
* [PATCH v6] hfsplus: validate b-tree fork extents at mount and inode read

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ca4e98a2-e000-43ab-9baa-64778481f09a

***

kernel build error

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      33d280b462dfabeae3264b462d4e91339320be00
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/d2a7a421-8b64-4a48-a055-fd4026cbbfd4/config

fs/hfsplus/inode.c:562:5: error: conflicting types for 'hfsplus_inode_read_fork'
fs/hfsplus/inode.c:571:11: error: call to undeclared function 'hfsplus_check_fork'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/hfsplus/inode.c:574:17: error: use of undeclared identifier 'HFSPLUS_I_CORRUPT_TREE'
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

