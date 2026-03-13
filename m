Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625D52EA159
	for <syzbot@lists.linux.dev>; Fri, 13 Mar 2026 03:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773373419; cv=none; b=amLg2gPurSWtLTJ8YpywaiczKQLC69JORt43xgMVcJ+N1XJwsmfAB/iExOzdvpq1+KVXqKeZBgGpqoaWry+Gr4W35EdHJKSXf/uQ4F/1rRclDHmOJGKNHIUrTw312QPhFYA/ZFy+BNlrLld+dzY9/lErc0GEx6QPzhTZVHoedkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773373419; c=relaxed/simple;
	bh=KR8qpuWxKgDee1xpXpQiPBS+XkB/yLWd9HoeOvNJzXQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=BbQ7mTFEdXFHk/FODb47AgOmWWF+KN6eaeH/bdUMhGE2QUWKffipQ89WSP+QiVAK/ZJeOlz4kzVIQ7Ez3gndKxWvGdqeV1A3sf5p/Ug81Ssn9ixvOeJ2MrnHd+QTrnc92vRigqF8VsUnGRKfOYrcm4O2tRPr9pQR1nfXuTWuoe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67bbf529d09so29899411eaf.1
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 20:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773373417; x=1773978217;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dk6HUdvUqP8hKo2jfpq5y7xsGhW9kMctjQxQjtjblNs=;
        b=YMAroNS0Crfz1iPpid9WJKLejNLeF/0b56GVCrCLHYOCgbvU07LBR7r/ZgjvPMTHJ0
         UoLgn8vP6lEZg+X6Qpy+R+BV5ctOmT4M2J+sZceaIc9oSz3NE5BV4n1XKB6jEEm9jdZH
         ikR/EN8PKvNjlKXNqNE8wphwK+VgE4uGR/f1ErZCs6/wQFx6Cq9bvpY5cim5yBjAR9h5
         uzcGg0mYQPuEMUB4qOHd7LR1wx2dc0pG11rl0t67tzSgpxtXEvljCjp2zgvCYTFYyf3v
         DWj7a7JVcpsmyxOdgUO10xzDero+UgQsDoxdlW8XNmSxGwQ3cdaeQ2VDUAVkUr6TTEJx
         Wseg==
X-Gm-Message-State: AOJu0Yw2JLPSQOlYGNoobSoo/+KPxtEq0X1ajTO1npmY7xfpbyTRYiKj
	7LoBOSDrVSeMX3Tlj/o+LAWYnaWs+1mB5dk8xD0oG6EVBkbN51aqxJMy4hwDJs57mLmuQ0q05xR
	QMHwSwcBqexlN6Mj3OB1dGizcilHC2tmBDVPic+7Dljk6rMSidbqlWCinGoc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:986:b0:67b:c59b:465f with SMTP id
 006d021491bc7-67bdaa67609mr1154464eaf.57.1773373417332; Thu, 12 Mar 2026
 20:43:37 -0700 (PDT)
Date: Thu, 12 Mar 2026 20:43:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b387e9.050a0220.12d28.00bc.GAE@google.com>
Subject: [moderation/CI] Re: fs: Replace user_access_{begin/end} by scoped
 user access
From: syzbot ci <syzbot+cif7704bc886472a27@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[brauner@kernel.org chleroy@kernel.org david.laight.linux@gmail.com jack@suse.cz linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org tglx@linutronix.de torvalds@linux-foundation.org viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

