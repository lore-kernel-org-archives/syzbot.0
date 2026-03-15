Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8061B34DB72
	for <syzbot@lists.linux.dev>; Sun, 15 Mar 2026 12:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773577818; cv=none; b=NBfVfq3/rxJf1eM3yFm9ysuRUIEqql8qnanL1HOwPRD+PGOEstmLLbglYW+aFuIR0v8I2JL/6AVm3E+Jap9NLNFmVaTbZeF53KiRFsJUCkOVp21ZGdwLVZcRXGp+9JKkwWvEbyBWACou1I4634EeuT5apDvD6mIksy6lyR+N27k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773577818; c=relaxed/simple;
	bh=dAF6EzhmfYjPCbJTGwcPxZtm0/JEAGDbN+Fj66nWJ/4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ChN3nkECcFdSH7R4YYSMVxQCxMHDXXXVquVc9oxHCmYsLrEv654iP7dW9xL29NiWD2jseTKIHZ46u57hTS0dD8ae3ABSfb4TEpqYB+3MTYIHPwgT4iIPqdfCQ/NCWPgB/R9xOkOYoi+1j6mxL3h2jPqV76koLhdrtaV9fw0mcyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67bf3e1051bso16798118eaf.3
        for <syzbot@lists.linux.dev>; Sun, 15 Mar 2026 05:30:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773577816; x=1774182616;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I3L9arFEoq9A4E17prvbQNB9j3C1EDeY250Imyq4MNI=;
        b=DT6lum6hgg83ywhbOUsdpLu5n0oHlVbPzIgTdyYqBKLO5ZnEEEX64kQm8ORJp6qvoP
         kYqx01rEB1KpWuQliKEIuLJA651NlGva/jBPlSq2nijqxRk5/OJ8JZbMDE4datWsCeuN
         fDwZnG2jSyLV7JAA9VnMy1GecHy6O+1/cCquMv+/O5DxBritR8qkewd8//seUYRFgoVS
         f9FXK1mbK/kGWOa+olz25Eh8Ko4AMeES9lUcEYGUlkYWBKXF9QGvR60Bsf5KfQA2quvQ
         ltrPetNgYhNfYjqHhxTo/niwGzeZGtnRCVog7BIkFNssY/qzrG8ADsrJG5h423i1msLH
         MLKw==
X-Gm-Message-State: AOJu0YwvOxuio3g8bt67FakKhGMTR9UhyJ+YB/lZdp6zYCQGUfi/JWE4
	L2uQHxAz/crS4gnWJ4h3RCSqCk/gLjzY8Dqh4+aIv7xLC6N0NkycngJnbE3oyxGsg7M3w/bHn72
	Kcy/MwrmBSZdrrb3YFqfwtZq9Y8CqvACyEUSO0Vt+84JxQ31JQJpQBMn9Iqs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:610:b0:67b:b2a0:6955 with SMTP id
 006d021491bc7-67bdaa3213cmr6843122eaf.48.1773577816607; Sun, 15 Mar 2026
 05:30:16 -0700 (PDT)
Date: Sun, 15 Mar 2026 05:30:16 -0700
In-Reply-To: <9b8b9c7f7d533c96c0c1abe5b4aecb7dc19e2abf.1773306879.git.chleroy@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b6a658.050a0220.12d28.0153.GAE@google.com>
Subject: [syzbot ci] Re: fs: Replace user_access_{begin/end} by scoped user access
From: syzbot ci <syzbot+cid75770a461d6c546@syzkaller.appspotmail.com>
To: brauner@kernel.org, chleroy@kernel.org, david.laight.linux@gmail.com, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] fs: Replace user_access_{begin/end} by scoped user access
https://lore.kernel.org/all/9b8b9c7f7d533c96c0c1abe5b4aecb7dc19e2abf.1773306879.git.chleroy@kernel.org
* [PATCH v2] fs: Replace user_access_{begin/end} by scoped user access

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a2ff6791-00cd-4a47-8c1b-9224abc65d04

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0257f64bdac7fdca30fa3cae0df8b9ecbec7733a
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ab2718fa-ea35-4282-a430-1ceab5b149aa/config

fs/readdir.c:530:60: error: use of undeclared label 'efault'
fs/readdir.c:538:2: error: unknown type name 'buf'
fs/readdir.c:538:5: error: expected identifier or '('
fs/readdir.c:539:2: error: unknown type name 'buf'
fs/readdir.c:539:5: error: expected identifier or '('
fs/readdir.c:540:2: error: unknown type name 'ctx'
fs/readdir.c:540:5: error: expected identifier or '('
fs/readdir.c:541:2: error: expected identifier or '('
fs/readdir.c:542:1: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
fs/readdir.c:542:7: error: expected ';' after top level declarator
fs/readdir.c:543:2: error: unknown type name 'buf'
fs/readdir.c:543:5: error: expected identifier or '('
fs/readdir.c:544:2: error: expected identifier or '('
fs/readdir.c:545:1: error: extraneous closing brace ('}')

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
