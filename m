Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB759155757
	for <syzbot@lists.linux.dev>; Fri, 16 Jan 2026 17:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768584253; cv=none; b=LT9jzj/s7gpgBoI13joVD4NbvVdTek8eXZuAkMAv3qzT3iLgZeonlteYEweGpqnQxpbDMxbVMVkTcmUQ9AZfHkVZmgHcf6taSfESt6joyEDv6a+KnrsEDkiIbsN5ERkogcw2L5ZsNHO1jjcocotyDDSKJ5fht7RwYZxuonwRe7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768584253; c=relaxed/simple;
	bh=eaUWx5a17+WlY7sVsrTG564/uSOkWvKgew6Wa/5VwQU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=a5yaSawoWy3CG9dErHL4G5IAtaxQPjmJ7pGj0NbYPsx8aZptS+vFhOyEucp6WKilYDOSq8zWJrPXy6E7MXh5/AH4TEARXF0ldf3u/HZj6oxI9WJmnPLiBTf0MAPJn/5wNZr409+M9JRsvOj0S/dVN5ks64LoohrafpRPbnGjjMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-65f6e15ad5bso5918595eaf.1
        for <syzbot@lists.linux.dev>; Fri, 16 Jan 2026 09:24:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768584251; x=1769189051;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YNe+S83duNDP96HRfgv68+YPmahu3nLB2ZxrKF8/Nho=;
        b=YqKlt2ff5/3HqD96TQ4U14O8vm68PIA6yUIXypdtiurv7AXLHl2zXW1jmxSEb3OZto
         u7iTQrYlpHccAnriLZzmpAjI6NaSU1na9JYYa0ZUaftxcTSa7FnXhBlCfn0fcuvOIUL5
         MtXC1iNayCnwLrpR+qLtwr/U+E9j7KyoSfPCimKMoHXO5him17HbcybxxlpvD5JNDJzb
         DTP/mqOdehp6UPAfG4MVq2b1W3H3lNtryXUwAZLami6oSQtOAVUoICItetTrfeKR6tle
         b8VKXzB2xThM3ZY5D+dYxOtZqY8oPBSncstg/igqTRnv9Ifkd+6yGvS/ilIK8iD8dMjh
         qO6g==
X-Gm-Message-State: AOJu0Yy1SCtTuNBM4tZJa2OxgMIAxLyZytF6bax7J35BYOmYcezSaJQ7
	RCf+u44wqDcVS6CaDAOmHpbdgnm+kkpXjZHEWPywjBpeQ9IQlfQiPp8PxGtevR23eTtawUq81A7
	oRCtxaxkll+UpPGrFfs1VKGE4a7Hrf24MDrkSy8zMmKdPRfR4WjFm6r8Txvs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dfc:b0:65e:f5db:f478 with SMTP id
 006d021491bc7-6611796e728mr1410405eaf.22.1768584250853; Fri, 16 Jan 2026
 09:24:10 -0800 (PST)
Date: Fri, 16 Jan 2026 09:24:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696a743a.a70a0220.31956c.0019.GAE@google.com>
Subject: [moderation/CI] Re: Exposing case folding behavior
From: syzbot ci <syzbot+ci65852280ef93a8af@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] Exposing case folding behavior
https://lore.kernel.org/all/20260116144616.2098618-1-cel@kernel.org
* [PATCH v5 01/16] fs: Add case sensitivity info to file_kattr
* [PATCH v5 02/16] fat: Implement fileattr_get for case sensitivity
* [PATCH v5 03/16] exfat: Implement fileattr_get for case sensitivity
* [PATCH v5 04/16] ntfs3: Implement fileattr_get for case sensitivity
* [PATCH v5 05/16] hfs: Implement fileattr_get for case sensitivity
* [PATCH v5 06/16] hfsplus: Report case sensitivity in fileattr_get
* [PATCH v5 07/16] ext4: Report case sensitivity in fileattr_get
* [PATCH v5 08/16] xfs: Report case sensitivity in fileattr_get
* [PATCH v5 09/16] cifs: Implement fileattr_get for case sensitivity
* [PATCH v5 10/16] nfs: Implement fileattr_get for case sensitivity
* [PATCH v5 11/16] f2fs: Add case sensitivity reporting to fileattr_get
* [PATCH v5 12/16] vboxsf: Implement fileattr_get for case sensitivity
* [PATCH v5 13/16] isofs: Implement fileattr_get for case sensitivity
* [PATCH v5 14/16] nfsd: Report export case-folding via NFSv3 PATHCONF
* [PATCH v5 15/16] nfsd: Implement NFSv4 FATTR4_CASE_INSENSITIVE and FATTR4=
_CASE_PRESERVING
* [PATCH v5 16/16] ksmbd: Report filesystem case sensitivity via FS_ATTRIBU=
TE_INFORMATION

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d2ea26bb-bf32-425f-9fcf-cf458006a00a

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      623fb9912f6af600cda3b6bd166ac738c1115ef4
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/80203eeb-b91e-47ef-a88b-7b916a9b702=
4/config

./include/linux/fileattr.h:75:23: error: use of undeclared identifier 'FS_X=
FLAG_SYNC'
./include/linux/fileattr.h:75:23: error: use of undeclared identifier 'FS_X=
FLAG_IMMUTABLE'
./include/linux/fileattr.h:75:23: error: use of undeclared identifier 'FS_X=
FLAG_APPEND'
./include/linux/fileattr.h:75:23: error: use of undeclared identifier 'FS_X=
FLAG_NODUMP'
./include/linux/fileattr.h:75:23: error: use of undeclared identifier 'FS_X=
FLAG_NOATIME'
./include/linux/fileattr.h:75:23: error: use of undeclared identifier 'FS_X=
FLAG_DAX'
./include/linux/fileattr.h:75:23: error: use of undeclared identifier 'FS_X=
FLAG_PROJINHERIT'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[adilger.kernel@dilger.ca almaz.alexandrovich@paragon-software.com anna@ker=
nel.org brauner@kernel.org cel@kernel.org cem@kernel.org chao@kernel.org ch=
uck.lever@oracle.com djwong@kernel.org frank.li@vivo.com glaubitz@physik.fu=
-berlin.de hansg@kernel.org hirofumi@mail.parknet.co.jp jack@suse.cz jaegeu=
k@kernel.org linkinjeon@kernel.org linux-cifs@vger.kernel.org linux-ext4@vg=
er.kernel.org linux-f2fs-devel@lists.sourceforge.net linux-fsdevel@vger.ker=
nel.org linux-nfs@vger.kernel.org linux-xfs@vger.kernel.org pc@manguebit.or=
g ronniesahlberg@gmail.com senozhatsky@chromium.org sfrench@samba.org sj155=
7.seo@samsung.com slava@dubeyko.com sprasad@microsoft.com trondmy@kernel.or=
g tytso@mit.edu viro@zeniv.linux.org.uk yuezhang.mo@sony.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

