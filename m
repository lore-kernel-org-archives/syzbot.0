Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E91314B66
	for <syzbot@lists.linux.dev>; Mon,  3 Nov 2025 16:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762185808; cv=none; b=bam4aym2Hu1CMi6EJPeN5RtWhBFi5oq7Wz+um8jJICR3iZKgp0aqf/ZGF2dDJc5DYtxNWXUIxUMvXth+0HYVY1S0l+jig5JBQneF5XL35UByCwm0NZFAy/ELCZ/eAg/0+VxVyrIvAQgO57oyl4/h4skI+bfbxZ3hD9maBDDiZbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762185808; c=relaxed/simple;
	bh=tz5ESNKBX5IL3Q2KgtVozlERU/cZT6xQ19mj7/Fm7+E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=qHbfJQPNJqmwZnC/Nv+SqRPULi1CDtWu4ZeDnY2zvE1/GVCUHLJZdRaUS5nvSZ4rlU3RqsWRIw3avIuF+6N15Uib1Hbj0DAcPVMGWquarSoFU/MstgP4kujJ9YqvAAIhyrI6PA6C/DYusEepO8o5AWTJXPVq/KmaLxWk8n60xwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-43333f50556so16195695ab.1
        for <syzbot@lists.linux.dev>; Mon, 03 Nov 2025 08:03:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762185805; x=1762790605;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vBJ2qAg7Mw46MvpNcOCwoDTAGvIFBIiskVd+BBAc10o=;
        b=eE2LQr+PT9vxgQLIWqZXS7iL9B8nyk75WFEjAe/ksTQKc1/tCiNg5L1gtyiqiejHIC
         hrsHIzcPIbLjncnsW65q286QdvJZqWmD694P1GXZbfRGD99GSAZRZExn4KOwysWwQCKC
         B9ruQSYtqMVy+f3b5uKfRSHbGcb/JCQCRVhJsX5VI2/muJhkK2uJeiH2hTPpMOVON+QP
         POQXpLoiJnpXHOcXQD4CgR5z302bPcdYXDjkO3aMLrXBcRa5xDoAtZjSRt03eBJE3sXX
         Nn57V6L20R+Z5HadCOY4S/cJEVydugTb0yzCra3XFxF9gEyNpTw784vhlhCa0gsJcw2n
         KXGg==
X-Gm-Message-State: AOJu0Yzgf0M3gSkgyNDUKEZOACzws10/A6n5X4Uld2E6CB6DpCtQBa0C
	nOUokZ7Y1Nw/DRCETlbfOEeKpW5Au4VR8/sr4egVRHIXsiPhtzB68df8pFb+UW5dM5RcM1bnrgl
	bm368BkK2QVGCwWEHZzUdWkOOXXhH5bYKY04l3IN+anr355bQLWUANEQdi48=
X-Google-Smtp-Source: AGHT+IGUAZOmAlvOX/Dkr5TheLlWuYE1guXiAPVSqKLaxCWf6Bib9TBTK1yXSyRuR4ML8DWkvmMGgw7KYttM54r2KlJmFvgaXxV2
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1606:b0:430:ab80:66f9 with SMTP id
 e9e14a558f8ab-4330d1224c8mr92173605ab.1.1762185805435; Mon, 03 Nov 2025
 08:03:25 -0800 (PST)
Date: Mon, 03 Nov 2025 08:03:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6908d24d.a70a0220.88fb8.0001.GAE@google.com>
Subject: [moderation/CI] Re: credential guards: credential preparation
From: syzbot ci <syzbot+ci5e4ad3c7015479b4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] credential guards: credential preparation
https://lore.kernel.org/all/20251103-work-creds-guards-prepare_creds-v1-0-b=
447b82f2c9b@kernel.org
* [PATCH 01/12] cred: add prepare credential guard
* [PATCH 02/12] sev-dev: use guard for path
* [PATCH 03/12] sev-dev: use prepare credential guard
* [PATCH 04/12] sev-dev: use override credential guards
* [PATCH 05/12] coredump: move revert_cred() before coredump_cleanup()
* [PATCH 06/12] coredump: pass struct linux_binfmt as const
* [PATCH 07/12] coredump: mark struct mm_struct as const
* [PATCH 08/12] coredump: split out do_coredump() from vfs_coredump()
* [PATCH 09/12] coredump: use prepare credential guard
* [PATCH 10/12] coredump: use override credential guard
* [PATCH 11/12] trace: use prepare credential guard
* [PATCH 12/12] trace: use override credential guard

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/385f1cbe-556f-4703-85f1-6cfa32c2eeee

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      ea7d0d60ebc9bddf3ad768557dfa1495bc032bf6
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/90b238bc-4b66-45b9-9103-4a75a3aed2d=
4/config

fs/coredump.c:1199:2: error: call to undeclared function 'scoped_with_creds=
'; ISO C99 and later do not support implicit function declarations [-Wimpli=
cit-function-declaration]
fs/coredump.c:1199:25: error: expected ';' after expression

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org cgroups@vger.kernel.org linux-aio@kvack.org linux-cifs@=
vger.kernel.org linux-crypto@vger.kernel.org linux-erofs@lists.ozlabs.org l=
inux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-nfs@vger.ke=
rnel.org linux-trace-kernel@vger.kernel.org linux-unionfs@vger.kernel.org n=
etdev@vger.kernel.org samba-technical@lists.samba.org torvalds@linux-founda=
tion.org]

If the report looks fine to you, reply with:
#syz upstream

