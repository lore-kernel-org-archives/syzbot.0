Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F332A328B7F
	for <syzbot@lists.linux.dev>; Wed,  5 Nov 2025 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355809; cv=none; b=hxXafhq22k9rHLBtp1OI5nIc92NNVICc2+dxdm6FNZaV0ptCcfoDwAEiJd0KsPnTy6+crX6DjQcunkzVMNQlxyI8K1MV8/z/gPYqELbCKvUoZ+dpcInGqlgxL02c1lrPr6WA8h6zdj1D390yWLGKObrSczDfmQFZ1wXRDpK7dXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355809; c=relaxed/simple;
	bh=ti8JMkexIb2lH7URfyqU6+VRlnDjYtrx5YHgQCv5olc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ozCCiC1hQ+6uYBadGu7owT341j+kEWkOqvhsFVoxwVvknVS7jU/wrYjSSi5TPFYNTMPNZexLDGLXhCfaA+sj8eNtQK9/NZQsYB73Pk7HYGAAytInUgPCaKQmkdDYf9NuqXD5y4gxp9hYtfBwA4H3Rj12nTPw2xdkZrEI4kspua8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4334affe616so4691695ab.2
        for <syzbot@lists.linux.dev>; Wed, 05 Nov 2025 07:16:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762355806; x=1762960606;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zXPXeEjwUvPwfNxNWtlPRzXp2acmp87X3CddG/a2pu8=;
        b=RN2bFOIpTF1PAYbspFcR977CccTee0UR7DhoKzHSXLEk5aF1c2EITfhNELywfu0z6+
         OiFOqCzRYCQO+y4NLv3P4+a0k2/ANneOV7xSx5gqGAWVWMaZMYONTQTiK6Pc+N6NXb5a
         AhLt+mvEe7KcmBLylyVfv/UgjIDJa2ejmtXrbdo8l7v6grjESDb3swjXzZ2aJy8ZReb6
         g6+Czs2rNQAXEgo2obvawLWX6u5jQzfbIYdzDhomFtGVj+iCzAx0+BN9zWLXb4SBci5y
         ZVUov1/qRf2G7XOgjP7yUE3BtP9+AFjrKriMtGhlEBwmBYoBwWvNAnz9uFvRZ0lOordV
         TxRQ==
X-Gm-Message-State: AOJu0YytF1DL4dTULJpleWe0HBZfCGDN3/cpqoM3hs5BDTkGMP+8TTlk
	7tvY324FluEw08Fdpw+MmOQb7fYHzrK5YX0lOn00LfEpFgmCrg8aKl0c7dQTm5I1O0wQRL0VtiN
	qUDsYB7zgl+x+oEtXkeGdn9vpupP4KQmsND85wtspxOkyADk3KBYS5Yg7d+I=
X-Google-Smtp-Source: AGHT+IH3qet7MpAXFGbHLCOI6l0fEvI9JV1HjKqRKloOwjK9/38HDAlKAtGZ+E2l3Eh7fsu5nKzSIZPLZ3BlCjE6p3v62jmvqQ0x
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3499:b0:42f:94fd:318f with SMTP id
 e9e14a558f8ab-4334077f59cmr54321055ab.9.1762355806114; Wed, 05 Nov 2025
 07:16:46 -0800 (PST)
Date: Wed, 05 Nov 2025 07:16:46 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690b6a5e.050a0220.2e3c35.0009.GAE@google.com>
Subject: [moderation/CI] Re: fs: speed up path lookup with cheaper MAY_EXEC checks
From: syzbot ci <syzbot+cib761f1e88b08edd2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fs: speed up path lookup with cheaper MAY_EXEC checks
https://lore.kernel.org/all/20251105135505.751454-1-mjguzik@gmail.com
* [WIP PATCH] fs: speed up path lookup with cheaper MAY_EXEC checks

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/c4dada2f-3672-4bde-bc0e-df942f9e3713

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      6146a0f1dfae5d37442a9ddcba012add260bceb0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/7791b58d-4b4c-4de6-843a-1cf68ac2702f/config

fs/namei.c:672:8: error: call to undeclared function 'inode_state_read'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/namei.c:673:3: error: member reference type 'struct rw_semaphore' is not a pointer; did you mean to use '.'?
fs/namei.c:673:3: error: cannot take the address of an rvalue of type 'struct lockdep_map'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org jack@suse.cz linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org mjguzik@gmail.com torvalds@linux-foundation.org tytso@mit.edu viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

