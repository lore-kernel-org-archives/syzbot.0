Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DC530E0E5
	for <syzbot@lists.linux.dev>; Mon, 17 Nov 2025 04:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763354214; cv=none; b=U5Chu1uj7JVHMO0PU/NNGUbf4GRM2zwkKc6ww4Wfw2vEFkqmSDx7N7tFjjbtrIMV1NBq/fjzwrpwCKK+WL+jOgc1v6dA8iFnt689ydGotkznK459jAEAZEuhyAxEk1bSaY/Ls23sDXB/D9EdGx7YW/oq586WhgEgg/wcYRptZME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763354214; c=relaxed/simple;
	bh=4ERRihdnTQbF6lIDnzkMoJI5c/DeBTSxbWf8YsQZp4A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=A5bO4CwH/ROha1e1XBDVctF7pHqwDjmTu/myX4rwrnikQkBFhg4acM6jihU4DwxXqvyX8Xg3CCCstCmSUh6chNZrBbm3362v02mPL3Lr6P2PVanAyiY/6vSIP9h5aEh4dnbvNwVKfy9M0TZUa8K/kvezc0nyHgoTvEN0gQRZYuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-433692f7479so95293465ab.3
        for <syzbot@lists.linux.dev>; Sun, 16 Nov 2025 20:36:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763354211; x=1763959011;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DJsEMHeHZI50pgw02QQleUlGVopVoBfOpS5JpxbALIo=;
        b=sfhfKfiY8HHeaXIy43BAoYl/WLoGCYS4Z86IudYTOjjLPXv9s55UywQKwWO0y9ka7N
         sQyHX0n2PGr+Nc0F5jpmRYcLCBiPOYSKiXn3jpJDajek5sUb4mvwI9yq0nzUn5hM/6xr
         tKVNzjdaBRouG5ADOCrjZJ5/XKNdXLSDQUQw2jrgKESbeRsU9nSxMNR2DI+rfxRNcn7d
         uZqMCc2lr+97sN2w9zJ0QeKqqnsMyj9GMP/35r0N3le8FUZsm+hhk0oZvgV5c8MYBsBG
         TlyAJsZCG3RLmAuCQL+gpAhUiqWL+Xibz8UU7andX2dzMiGVQJkOLgLY1xsjdSmmjQds
         UfCg==
X-Gm-Message-State: AOJu0YxfJsoq2x22H8QeX+o3WeZMDpBJbjeSbops+tA+ywHTxoPIjyAd
	YMWuQEKmWn//DIuGBoSXSgV4KI22MYzlaNgYrxdFyRBN0OYhry6WPTDfKC5HgVDDJrJLgSFzWj1
	HUmA5UkMDCL+x7c5OhZWhi5AMHGGeLs5UXqPIWVW0YUwDtYFJHh7HO5hw+PY=
X-Google-Smtp-Source: AGHT+IGJkoq1oBPaZK9Rp91JV8UKPbsIs/TlX+eTUorhUz69ZivlpMfGVln+wyx7Fq5HObzBsYoI2b/oigKBtjXvQhhMGXfT2L/O
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1542:b0:434:96ea:ff79 with SMTP id
 e9e14a558f8ab-43496eb02e3mr128813585ab.33.1763354211192; Sun, 16 Nov 2025
 20:36:51 -0800 (PST)
Date: Sun, 16 Nov 2025 20:36:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691aa663.a70a0220.3124cb.008f.GAE@google.com>
Subject: [moderation/CI] Re: bpf trampoline support "jmp" mode
From: syzbot ci <syzbot+ci13fbaa7d5915781a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] bpf trampoline support "jmp" mode
https://lore.kernel.org/all/20251117034906.32036-1-dongml2@chinatelecom.cn
* [PATCH bpf-next v2 1/6] ftrace: introduce FTRACE_OPS_FL_JMP
* [PATCH bpf-next v2 2/6] x86/ftrace: implement DYNAMIC_FTRACE_WITH_JMP
* [PATCH bpf-next v2 3/6] bpf: fix the usage of BPF_TRAMP_F_SKIP_FRAME
* [PATCH bpf-next v2 4/6] bpf,x86: adjust the "jmp" mode for bpf trampoline
* [PATCH bpf-next v2 5/6] bpf: specify the old and new poke_type for bpf_ar=
ch_text_poke
* [PATCH bpf-next v2 6/6] bpf: implement "jmp" mode for trampoline

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/b597c752-a7b9-40fa-9a32-641b73182e64

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      4722981cca373a338bbcf3a93ecf7144a892b03b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/53f87e2d-9838-46d8-afda-0347a66e697=
a/config

kernel/bpf/trampoline.c:500:11: error: incomplete definition of type 'struc=
t ftrace_ops'
kernel/bpf/trampoline.c:500:22: error: use of undeclared identifier 'FTRACE=
_OPS_FL_JMP'
kernel/bpf/trampoline.c:502:11: error: incomplete definition of type 'struc=
t ftrace_ops'
kernel/bpf/trampoline.c:502:23: error: use of undeclared identifier 'FTRACE=
_OPS_FL_JMP'
kernel/bpf/trampoline.c:534:12: error: incomplete definition of type 'struc=
t ftrace_ops'
kernel/bpf/trampoline.c:534:23: error: use of undeclared identifier 'FTRACE=
_OPS_FL_JMP'
kernel/bpf/trampoline.c:536:12: error: incomplete definition of type 'struc=
t ftrace_ops'
kernel/bpf/trampoline.c:536:24: error: use of undeclared identifier 'FTRACE=
_OPS_FL_JMP'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net =
eddyz87@gmail.com haoluo@google.com jiang.biao@linux.dev john.fastabend@gma=
il.com jolsa@kernel.org kpsingh@kernel.org linux-kernel@vger.kernel.org lin=
ux-trace-kernel@vger.kernel.org mark.rutland@arm.com martin.lau@linux.dev m=
athieu.desnoyers@efficios.com menglong8.dong@gmail.com mhiramat@kernel.org =
rostedt@goodmis.org sdf@fomichev.me song@kernel.org yonghong.song@linux.dev=
]

If the report looks fine to you, reply with:
#syz upstream

