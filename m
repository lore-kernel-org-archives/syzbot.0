Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E77370D64
	for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 23:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773185219; cv=none; b=JZxUj358/IkHkwq1p6CdHizu/qJ9CTwni5n2pJjTfyyO8F1G/xTlghybjQ6MtlnWw8aHnTVZnKbWhsi0XBExCUepXLCyE92KBB4eeHdFTWf+Bz89j4hr5cYb3GoAaxCFMnGWWL9+ZzaAGtVMIZsVJGki7j+KulpH7pHfKlJdUH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773185219; c=relaxed/simple;
	bh=S5OMo3e6SIaoplG3HYe1t8b4qlgEd1TdjdUECHVNCeo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=BFk+41En/dvZRY7YG2XJdPMKx3o6AWRkV0Ovu3eqbD0ODXICBPIkPeU4V7iE4Tv2eEPn1eUiHOy5bxJtLjKrCeSfTL5uXD7IEEPfhS3kfTzmJWOTC2vvNkMu+E6YK5YKM1NS3y2RNlFdbm3czzde4I01UFNuckn3KdktZza9wcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-4172c136f7bso20921145fac.1
        for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 16:26:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773185216; x=1773790016;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nshtyac552m43QNL1kjbF3MkIqXofD1TA4wE5ziD9Qk=;
        b=Fp/bfFtka2Ef8AhBtjP3RR59vq3EFJxLx6dCJxXDKqPQ5W40UwhW1u/X9RvZ5IC/gD
         2ehapp7t8LhYatpkpxMbTvzflpJwB3YvssxctmM7fxFur5FXsY/qrhnxahiGi0/J15PB
         M/x2OdyiuVCP/tI9GYhFYaeG1AxIniMB6tCRRJEo4cHZbWEXRHV5QWI8SlJkenC4e/Gd
         y29yWukzD+m3K2nG8yha8fAwqm3mKN7gZ1dtB0QhjWcRw9RLQfR4F91vbYBHL1LTlOEg
         P4Xpvz25aG89Bp2i+28yTIn1gI0S9EXN11DHCYlfA/PuORUR3cnbCJ/znDDZqw1deuZb
         Lsbw==
X-Gm-Message-State: AOJu0Yyo047pXiMa/4hv9VBppuqvKsI1iNEhSogAuCgoRL3b2ekzjpIm
	clPMzfe3Qm+hDlLLmdV95DKhOOpLrTBMGnYDnmKY3JbmmdnuCpviKQz5fqvZ1irFUk/fzIwDOF+
	FajjlI8JjRLRUpjwd3+XXRIH3SBJ7qdu87TsFW8r3JatjiQefMxDENDzhKKc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f0b:b0:67b:b735:9cb7 with SMTP id
 006d021491bc7-67bc8875459mr429157eaf.5.1773185216631; Tue, 10 Mar 2026
 16:26:56 -0700 (PDT)
Date: Tue, 10 Mar 2026 16:26:56 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b0a8c0.a70a0220.51e36.0004.GAE@google.com>
Subject: [moderation/CI] Re: fs: Replace user_access_{begin/end} by scoped
 user access
From: syzbot ci <syzbot+ci13de108e9834717f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fs: Replace user_access_{begin/end} by scoped user access
https://lore.kernel.org/all/5021aa325554b3d2437341514ab0a2977e158274.1773153431.git.chleroy@kernel.org
* [PATCH] fs: Replace user_access_{begin/end} by scoped user access

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/c5ff6b4a-5474-49d1-84d5-d436ae5ee0ef

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/376590a1-6630-4285-a1fe-4d05a61dc629/config

fs/readdir.c:454:26: error: too few arguments provided to function-like macro invocation
fs/readdir.c:452:2: error: use of undeclared identifier 'scoped_user_write_access_size'; did you mean '__scoped_user_write_access_end'?
fs/readdir.c:454:29: error: use of undeclared identifier 'efault'
fs/readdir.c:532:60: error: use of undeclared label 'efault'
fs/readdir.c:540:2: error: unknown type name 'buf'
fs/readdir.c:540:5: error: expected identifier or '('
fs/readdir.c:541:2: error: unknown type name 'buf'
fs/readdir.c:541:5: error: expected identifier or '('
fs/readdir.c:542:2: error: unknown type name 'ctx'
fs/readdir.c:542:5: error: expected identifier or '('
fs/readdir.c:543:2: error: expected identifier or '('
fs/readdir.c:544:1: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
fs/readdir.c:544:7: error: expected ';' after top level declarator
fs/readdir.c:545:2: error: unknown type name 'buf'
fs/readdir.c:545:5: error: expected identifier or '('
fs/readdir.c:546:2: error: expected identifier or '('
fs/readdir.c:547:1: error: extraneous closing brace ('}')

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org chleroy@kernel.org david.laight.linux@gmail.com jack@suse.cz linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org tglx@linutronix.de torvalds@linux-foundation.org viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

