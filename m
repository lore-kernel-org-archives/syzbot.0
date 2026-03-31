Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BE138F92F
	for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 23:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775001415; cv=none; b=RR6pxUZNNP9jlEMOygBDL14oXnD+bQOvsNCmixPDw32XVxdEuvkTNZ4ylkLjKhDtWQa5nkHCR2neriX0kIincPruyEEFGMdIWI+ad8HZoQvUmQEe9Nmu4MM/4QcDp8PhMmNiMZuQOlOq62CSZZs4VQnsb2+13fUYAMldZj2K3Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775001415; c=relaxed/simple;
	bh=uba9JzL+7wtFaRXoB7kWA+AebH86iDR3On6jDfXLsLo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=V2ZSBaf8+usc51s1J+K805vX/7ddFb6PoDkmR5tl45ey4Bn7rZeyAZsCj2ooWbC/a3g8O7tSTS7Y2bDVOCY3obewZjzuSLAzN47Hw4R+P6qG2sXbpFZcujXWzeTvPmrwtIpD3VBF4nqMGXqKxDDecjT/c6E1BI1LzPyD7NPFxvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d73e3cf94eso9210447a34.2
        for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 16:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775001413; x=1775606213;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vRzdiCzwbI/sH2FaGjkkHK5dv7HqbR40Sq4JPJft0XE=;
        b=g+ncEOGyILnEwaAqBohnTF+If1i/RRA7F4l0wZ6SmyUboawpU/JBEKmGamx0FWckPS
         fvNbpRLBRFryrVfAyV2a5WTpgcJC+T6RJdAVjFQmOS8qH/Z9e/5Pt4XT/Q53haxTGxNY
         tyVDZbwJqIfYcD7UWuZbAgvZrcuJJkJbd6a4vZRn4T6nNuuIdLFnFOpaByDlu/NdA4jP
         EbAnXZRDf34qb+olxXZLDmjFWtz1po0Tmm8BP/QsRPvDBth3uI7T7tgnoaz3vwRavFsK
         09e8cm/yZOLTKz17enYQVO8mzm8BQCFO7qeTEHQ44MeIK8bTi6NCww4JAFGiHafORVxb
         sTFg==
X-Gm-Message-State: AOJu0YxKaTnh8N1vrZrfTBPLxmsOZVYMEB60sa6arMQa1N005JgKdCUe
	1CCB3JxGIQXPx16kmgyW65u6rKp9mG2O53rJoh7LNqyY5TWN0miw+gNFJECVPRaGBYLPtg2lfm1
	g/nNGlXLf50uVMqsY1j9dABA7uIOUbT2lM2mNrg9SQPV2+3lCdHwmjRx6zts=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:8107:b0:67e:3e6d:f74a with SMTP id
 006d021491bc7-67fabbdb38bmr717534eaf.4.1775001412839; Tue, 31 Mar 2026
 16:56:52 -0700 (PDT)
Date: Tue, 31 Mar 2026 16:56:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cc5f44.a70a0220.97f31.02a5.GAE@google.com>
Subject: [moderation/CI] Re: vfs: replace ints with enum component_type for LAST_XXX
From: syzbot ci <syzbot+ci4923b488a39b1ae5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] vfs: replace ints with enum component_type for LAST_XXX
https://lore.kernel.org/all/20260331173726.3517440-1-jkoolstra@xs4all.nl
* [PATCH] vfs: replace ints with enum component_type for LAST_XXX

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/3feaee07-20f8-476a-aca8-283c9782b038

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      d0c3bcd5b8976159d835a897254048e078f447e6
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/923b0f49-bd29-4473-ac86-9a3d42aea01=
4/config

fs/smb/server/vfs.c:71:23: error: incompatible pointer types passing 'int *=
' to parameter of type 'enum component_type *' [-Werror,-Wincompatible-poin=
ter-types]
fs/smb/server/vfs.c:76:23: error: use of undeclared identifier 'LAST_NORM'
fs/smb/server/vfs.c:681:32: error: incompatible pointer types passing 'int =
*' to parameter of type 'enum component_type *' [-Werror,-Wincompatible-poi=
nter-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[amir73il@gmail.com brauner@kernel.org gregkh@linuxfoundation.org jack@suse=
.cz jkoolstra@xs4all.nl jlayton@kernel.org linkinjeon@kernel.org linux-fsde=
vel@vger.kernel.org linux-kernel@vger.kernel.org mjguzik@gmail.com neil@bro=
wn.name viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

