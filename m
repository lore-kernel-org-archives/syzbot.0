Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686EF2D6E6C
	for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410006; cv=none; b=gz8NV7BlED4Cd4WgsA9OcFzLXqKuTmQ2tPAhjg8RcSatARVe+mvC2Ek8tjFSESU6qZ/yVbOXX3ymPrAXDJBfeI6PxtORh2NFD77J9bYjhvqg+mLxGZrey3mansQDzS9XrHgBjilOf7KTG5S3cjqjx7Yq6B69hU5hh0iskkFmPL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410006; c=relaxed/simple;
	bh=qMD097rL4v/47Cf7YdJxoq2t3jBjjVKPIxhNDUZFZmE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=CENcB3L8bxCdifsz2SArkpYIgc8iEsRo5GDOOM9uh/pNLLr5Jd8klq+CK0B/CLyQtEAMVv9eQiaDXAfSAblWI9kMapK32UKzNis1lb3XdW18rgO9YRyA3f4XP26Mz+sOW6LLvKi5bStw7WmoLLgGc0oahfhdZMV67zgfau/Zwwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7cfd10872d7so19877a34.3
        for <syzbot@lists.linux.dev>; Wed, 14 Jan 2026 09:00:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410004; x=1769014804;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=chCaX2qaXrNjllSZ7eN4H2hoAp+FRlPGK5B6xrxAEdU=;
        b=kMRnd8J/dytI8MZh8ZWC6KuPsimaI6a4vP1/58z+s2s7LzSZ7JOcZuR27d38Dxt1NZ
         DrpxSan0HGu/uvknGjKUDNxTCWt/ieYuSboq8TSDaFSogJ8qHUa0GwCMkD4rODumjwVN
         1k94gG1KgogZ7MBg5EgjdqNKXDjPL7J08LT7ETpnGVn3pdLAY0LQj4F/thme8svol4G0
         mghWciZl4DvcGxlkB6XYKdFfNH+5vDKMcli7Ji3BjvFpbVq7Iv1dZMbDv0ncs/oZihzC
         E5Gk6ChpetK6UmzcEdO25j9VyUmWOsucqQ446iGi8sWmfns06E4MoT4G69mgJ3gFWnrN
         8q8g==
X-Gm-Message-State: AOJu0Yxn7lVih56XHGgySwfd39yEjuVQrUOEfIPTcxKjujruCH/fXh1z
	/CPNJyZXRhBepqI9CP/gEumDZc7Yf9S5M8fueIrZet/0Z71JrlkqVVHuJWeA9dTFkfHNxQlfbzw
	eOws7cU3BhAYOE7b+wAs4Om0FM0LeWXy+3Ebz6PHUbZYZbPebgVekjNUstYI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4489:b0:65b:35fe:4323 with SMTP id
 006d021491bc7-66100706702mr2167709eaf.67.1768410004183; Wed, 14 Jan 2026
 09:00:04 -0800 (PST)
Date: Wed, 14 Jan 2026 09:00:04 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6967cb94.050a0220.58bed.0000.GAE@google.com>
Subject: [moderation/CI] Re: Exposing case folding behavior
From: syzbot ci <syzbot+cifc59c55d505d973a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] Exposing case folding behavior
https://lore.kernel.org/all/20260114142900.3945054-1-cel@kernel.org
* [PATCH v4 01/16] fs: Add case sensitivity info to file_kattr
* [PATCH v4 02/16] fat: Implement fileattr_get for case sensitivity
* [PATCH v4 03/16] exfat: Implement fileattr_get for case sensitivity
* [PATCH v4 04/16] ntfs3: Implement fileattr_get for case sensitivity
* [PATCH v4 05/16] hfs: Implement fileattr_get for case sensitivity
* [PATCH v4 06/16] hfsplus: Report case sensitivity in fileattr_get
* [PATCH v4 07/16] ext4: Report case sensitivity in fileattr_get
* [PATCH v4 08/16] xfs: Report case sensitivity in fileattr_get
* [PATCH v4 09/16] cifs: Implement fileattr_get for case sensitivity
* [PATCH v4 10/16] nfs: Implement fileattr_get for case sensitivity
* [PATCH v4 11/16] f2fs: Add case sensitivity reporting to fileattr_get
* [PATCH v4 12/16] vboxsf: Implement fileattr_get for case sensitivity
* [PATCH v4 13/16] isofs: Implement fileattr_get for case sensitivity
* [PATCH v4 14/16] nfsd: Report export case-folding via NFSv3 PATHCONF
* [PATCH v4 15/16] nfsd: Implement NFSv4 FATTR4_CASE_INSENSITIVE and FATTR4=
_CASE_PRESERVING
* [PATCH v4 16/16] ksmbd: Report filesystem case sensitivity via FS_ATTRIBU=
TE_INFORMATION

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/34455388-b093-447c-8b60-7680968a516c

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      c537e12daeecaecdcd322c56a5f70659d2de7bde
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2a1b505a-38bd-4edf-97f7-7e8f187fa6f=
3/config

./include/linux/fileattr.h:74:23: error: use of undeclared identifier 'FS_X=
FLAG_SYNC'
./include/linux/fileattr.h:74:23: error: use of undeclared identifier 'FS_X=
FLAG_IMMUTABLE'
./include/linux/fileattr.h:74:23: error: use of undeclared identifier 'FS_X=
FLAG_APPEND'
./include/linux/fileattr.h:74:23: error: use of undeclared identifier 'FS_X=
FLAG_NODUMP'
./include/linux/fileattr.h:74:23: error: use of undeclared identifier 'FS_X=
FLAG_NOATIME'
./include/linux/fileattr.h:74:23: error: use of undeclared identifier 'FS_X=
FLAG_DAX'
./include/linux/fileattr.h:74:23: error: use of undeclared identifier 'FS_X=
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
nel.org cel@kernel.org cem@kernel.org chao@kernel.org chuck.lever@oracle.co=
m djwong@kernel.org frank.li@vivo.com glaubitz@physik.fu-berlin.de hansg@ke=
rnel.org hirofumi@mail.parknet.co.jp jaegeuk@kernel.org linkinjeon@kernel.o=
rg linux-cifs@vger.kernel.org linux-ext4@vger.kernel.org linux-f2fs-devel@l=
ists.sourceforge.net linux-fsdevel@vger.kernel.org linux-nfs@vger.kernel.or=
g linux-xfs@vger.kernel.org pc@manguebit.org ronniesahlberg@gmail.com senoz=
hatsky@chromium.org sfrench@samba.org sj1557.seo@samsung.com slava@dubeyko.=
com sprasad@microsoft.com trondmy@kernel.org tytso@mit.edu yuezhang.mo@sony=
.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

