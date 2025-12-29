Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD88221FCF
	for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 08:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766996174; cv=none; b=YETeD1HYtaXnCWoCDY7kZNGIHsx0dWJiBbJwDVhyKWF9eBE3YQzFCOobFCW0QfbYaXlATqax/ysdftpoW8T7TwJ35ayhqr0ZPuFD4vaQ0dAhbWrza3yp7mW0BHfZdLPNp3MOOXD6dbDkHhQ5fscU4XlWSxuIe3nlmxiqBe5ljeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766996174; c=relaxed/simple;
	bh=fM0A5CphGyqi3TxNfuPCo+8miCTnm2/KAxfxyyWSKK8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=PQEDhMrWjONpCgssruPe2dYJmbfS4wJbm3UfLzzgyAtDhuzgczbnvvb9XlmxgzlSIsPRbmc8RbAbH09IZPNSWWHa81QkWtH3uex4W1PqOWXynKGuNwCGPsuM2xtWbnjEO4WCWpnRck8Bkg6WLfCGwuQpoWA3Ox1UbBB5wZ3pYXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-656b2edce07so15872277eaf.0
        for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 00:16:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766996168; x=1767600968;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kwW+DWhJjtes0IzqhyPEXa7oiGdoG2mBRHBApr5aMDc=;
        b=Q9tNeHjOFZxpzOXEynBbFHoufn67CecHpb0y4Nr9JxZG7USWmG/GAOoL2doSch91GT
         aB+mfxdnhf04Y7UHlheOQseA/gGInhAHTkCXO/qcYim/Mzk534hE60R7GDlrC2Z5Xwjn
         nUeYgUjW+msaO4mD7hMGP67K+fSTP8PmdPUoTV7ooI98xEGIGV5okgDttxuWyxePRLVK
         VXZrxmJbbL6tkbxoBhc4IF9tYEixFlv++pjFSEq6//kp4OrE521b1TUoodJ5tN/vJmQt
         pmjEfSUPPrmlXfZpm5ZC/kD6n5b6C4wC7SQHuRY0mH5pAmkB6D3MQVYnPJBPEOjydach
         87yw==
X-Gm-Message-State: AOJu0Yz3PITuUMaIb/YZ/mE3mFkCV54nkMpNgqTJlQxWbPXlx1bxsx6o
	2SuzUlWZGZVPzNQBPWIbqoEaW9gh37+yUM+R4obn7V3MrYi1T3frFMj0QrNb8+hBDtqLXGdgGE5
	1bMZkXhYLSEEL7ytVXmdScoHCtRsDv0dPFA1xqmFwZQjN2V9WQ+2pf4pU558=
X-Google-Smtp-Source: AGHT+IGy8JzbjpDukX8A02f+jeZrpjccgMYdnxQrNaoJsNCPeV3Mt5Fvnd1ypMlYV/XyPjfNB/DsbQQv6UvApUlCdbC26qIQktw9
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c89:b0:65d:1bf8:bb74 with SMTP id
 006d021491bc7-65d1bf8bdd5mr11281517eaf.61.1766996168549; Mon, 29 Dec 2025
 00:16:08 -0800 (PST)
Date: Mon, 29 Dec 2025 00:16:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695238c8.a70a0220.90d62.0031.GAE@google.com>
Subject: [moderation/CI] Re: fs: remove stale and duplicate forward declarations
From: syzbot ci <syzbot+ci69006877028fe598@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] fs: remove stale and duplicate forward declarations
https://lore.kernel.org/all/20251229071401.98146-1-ytohnuki@amazon.com
* [PATCH] fs: remove stale and duplicate forward declarations

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ad51ab29-ea25-4a27-9aa2-d6f51fbde5cd

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e0921965-abbe-44c3-86e3-54af83a1ad1=
1/config

block/ioctl.c:565:33: error: incompatible pointer types passing 'struct hd_=
geometry *' to parameter of type 'struct hd_geometry *' [-Werror,-Wincompat=
ible-pointer-types]
block/ioctl.c:599:33: error: incompatible pointer types passing 'struct hd_=
geometry *' to parameter of type 'struct hd_geometry *' [-Werror,-Wincompat=
ible-pointer-types]
drivers/block/rnbd/rnbd-clt.c:965:13: error: incompatible function pointer =
types initializing 'int (*)(struct gendisk *, struct hd_geometry *)' with a=
n expression of type 'int (struct gendisk *, struct hd_geometry *)' [-Winco=
mpatible-function-pointer-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org jack@suse.cz linux-fsdevel@vger.kernel.org linux-kernel=
@vger.kernel.org viro@zeniv.linux.org.uk ytohnuki@amazon.com]

If the report looks fine to you, reply with:
#syz upstream

