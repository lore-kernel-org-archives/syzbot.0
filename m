Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97354217F27
	for <syzbot@lists.linux.dev>; Mon, 12 Jan 2026 22:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768256058; cv=none; b=KqzSDxbSUikqOQz3SSPPmQUYEq9LJBsuJNZAOLU/y7ZYmV1vmVxvVmCGif6/sjSnM/JOBU177n8j4nPSw6zY/lKqA1jm9DAv35P2qN8SxCfku3lILY5wxwbUyZnr7QP2xtDaFE35Oy5yhbz3jr1uiZduX7efa5w8kwiuu801GMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768256058; c=relaxed/simple;
	bh=Y9scepsmFplLkNUlSJ1uaZhCHrckXuruZATVngC1gZM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Mdh9Ho5so0WDoe5pubmI+Os6yEXMDDHE9qGc0c/BFHSuVzHMuGId7mCmPYYkElWtlsIoFFbjjtujDEIN7lNCwYGVqsoNFeqTYiZQhijSXgKmyEJh5L76bgsoBN1huPiJA1VI8a3FLPeQHXN8Cp4rklKiFVlXlKNXdoaLpdm6qBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-450be8a012cso13883738b6e.0
        for <syzbot@lists.linux.dev>; Mon, 12 Jan 2026 14:14:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768256055; x=1768860855;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XLkwqThjx4AkStKsHa9d1/rBkHvnRZcj9pWf+JO56oc=;
        b=rCU3kim0QxLZBM9/rAdLijEEr4R4sWNbyImX1C3HytyKgtRicndKlOexWEYpH4jskg
         vu7AhFJUG9L0s5T7rc7AKHZV/bCVRHJdTDdqllm31LYULk4I0nxB+WyUXGU7ARYJlu0N
         iz4DLgvv8t+W3T35h1u3DdIEYYsoQN2M/LOCYe1dMOaWvVsYlfTj7yfrKokbkW7/idLH
         ja9vHHobFzmo+/biilNXgbkC6NTRto8ZMgOm1IWX4wmkZKKm3c6M68uzreDDZoJLavom
         CREyWPi420eHeILWPSDfuZDqlWL4RPFPyB+ettqXa8xohFo+YSWrGnNRHXCLlESyDrmx
         dWqw==
X-Gm-Message-State: AOJu0YxFGUc4WHK1j2puLahjgwR7OvNZatB86Zc9RxOW1KyvHfypRq4M
	JU4LnDeM5rOnNACX7uHFQFdNyleyQORWt4AOalfSllJCz0XcSkBB73h+6FXwoXPZw6Ev9c/uYmx
	neOkQQLyqFkqznBiDj2bdIktLfFMC8tit/llzgJHxglS7FaWId3x6Pju9CJA=
X-Google-Smtp-Source: AGHT+IFl/3M50Hu08XFcODcX80O3rnnTI24tsqKCTNLIbxpSTUsYUI3E/7iF1kA3OiyCIKAtX8q49w2mcd/4ptCz1XOvq/gcDhqW
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9f:b0:660:e444:1055 with SMTP id
 006d021491bc7-660e4441a5bmr2020416eaf.59.1768256055501; Mon, 12 Jan 2026
 14:14:15 -0800 (PST)
Date: Mon, 12 Jan 2026 14:14:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69657237.050a0220.3be5c5.0006.GAE@google.com>
Subject: [moderation/CI] Re: Exposing case folding behavior
From: syzbot ci <syzbot+ci813d9da582e3e948@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] Exposing case folding behavior
https://lore.kernel.org/all/20260112174629.3729358-1-cel@kernel.org
* [PATCH v3 01/16] fs: Add case sensitivity info to file_kattr
* [PATCH v3 02/16] fat: Implement fileattr_get for case sensitivity
* [PATCH v3 03/16] exfat: Implement fileattr_get for case sensitivity
* [PATCH v3 04/16] ntfs3: Implement fileattr_get for case sensitivity
* [PATCH v3 05/16] hfs: Implement fileattr_get for case sensitivity
* [PATCH v3 06/16] hfsplus: Report case sensitivity in fileattr_get
* [PATCH v3 07/16] ext4: Report case sensitivity in fileattr_get
* [PATCH v3 08/16] xfs: Report case sensitivity in fileattr_get
* [PATCH v3 09/16] cifs: Implement fileattr_get for case sensitivity
* [PATCH v3 10/16] nfs: Implement fileattr_get for case sensitivity
* [PATCH v3 11/16] f2fs: Add case sensitivity reporting to fileattr_get
* [PATCH v3 12/16] vboxsf: Implement fileattr_get for case sensitivity
* [PATCH v3 13/16] isofs: Implement fileattr_get for case sensitivity
* [PATCH v3 14/16] nfsd: Report export case-folding via NFSv3 PATHCONF
* [PATCH v3 15/16] nfsd: Implement NFSv4 FATTR4_CASE_INSENSITIVE and FATTR4=
_CASE_PRESERVING
* [PATCH v3 16/16] ksmbd: Report filesystem case sensitivity via FS_ATTRIBU=
TE_INFORMATION

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/389a66d5-7460-40b3-9f6b-1cfae867c1c3

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      0f61b1860cc3f52aef9036d7235ed1f017632193
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp=
1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/5eaf1d58-f83f-46bc-a58a-4fd05cfab46=
1/config

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
m frank.li@vivo.com glaubitz@physik.fu-berlin.de hansg@kernel.org hirofumi@=
mail.parknet.co.jp jaegeuk@kernel.org linkinjeon@kernel.org linux-cifs@vger=
.kernel.org linux-ext4@vger.kernel.org linux-f2fs-devel@lists.sourceforge.n=
et linux-fsdevel@vger.kernel.org linux-nfs@vger.kernel.org linux-xfs@vger.k=
ernel.org pc@manguebit.org ronniesahlberg@gmail.com senozhatsky@chromium.or=
g sfrench@samba.org sj1557.seo@samsung.com slava@dubeyko.com sprasad@micros=
oft.com trondmy@kernel.org tytso@mit.edu yuezhang.mo@sony.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

