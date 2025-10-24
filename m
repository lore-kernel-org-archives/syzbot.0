Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FB52E7F1D
	for <syzbot@lists.linux.dev>; Fri, 24 Oct 2025 20:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761336913; cv=none; b=EhcIFv0/LiGycx8/cVr92DSKh/m48xV9Y4CULsLEXFH8KBSBAhEc3tOz67Q0o5avuJ4rXQJ9S6GqRpFHEsqbSBegwPSN2lZ+//tWHeHZzUDOixffiGjrR9ZMjTEWKeO2nuR+1yhX/gte6i2LwMAz5zyQ58c/s+9uCjPSRvNKKMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761336913; c=relaxed/simple;
	bh=9qjM/p2/ly2yeYK+M2MaF9ZfXyVXQUd6hlxo0Hyu5H4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=F0sNbIQgb7QJ0QAGf7uiVb1/Q+2J0RtRNLRfBhYvbRh52gwj4WggPowLfwcscs0YLBo9kfXD7oPSjIAIW+ne7/XWyAOwLcVOjrItwT74/S1aoNkb6ZfUr7KjOZqnV33X5yV/X9Wxsb4IOi3XSqA/2g+4fe5bX0+CETS/Mt8QJIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-430d0cf9b85so92060685ab.2
        for <syzbot@lists.linux.dev>; Fri, 24 Oct 2025 13:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761336909; x=1761941709;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CFZizCra+5BvQ4wI1JtV3MPKxIrV08EJSui5ZcNE1Oc=;
        b=RTnElrr/SeWfvoTWVEugS5XT/2DNegGhRjqFrUKRUdF5Q0AkUMQSKEvKwa2+Q1HR1d
         JIRP/pTLm6xjziofOL4veRSZPQQzmGl0L8erQxN2XUZrvT9CudZx0yilm0FqWFC25C5I
         D0CFEJZA22MWi5CRhp77oTzlNYXCkqEVYCyfrdKbCQLSnCZBIi8zINcJCmZzDu0CEIKh
         fuMzlPKkz9OSCNKf0l/uxYA95hen5p/j1ccEkKoSSECse2rgsUcOM0aXl92owNSK4yrU
         Nio11ww86sYgO1rfxtNQ3WJ5OlMUfiXXiJjb28F27tAvFZ9zd5dqQ2nCvqb695MiC2t2
         63Pw==
X-Gm-Message-State: AOJu0YzWqFpzSljx9Foq3AW7pOj6tbUuYa1NlKhNUNExbEBBhjDyPeGD
	WZUfJ6fe5J+i03P619RTh3SQ77oOByI+O1m78Y8T48rc0zfI7zS56DhItIFVIOBVD6sFBQjqKGD
	1/PYhpN3Wft3cL9YPI8vWccmm/DJ6firlrBCbAWnvmekRsCcmewrrO9/0sLA=
X-Google-Smtp-Source: AGHT+IEoA55ZQ35bMGjZIDvj0EWOF4EOuXiC3Q4Q51zYV9VCL8DAOISAl6iBC/GAP9sNp7imCDaQ0LMWvA32cI3DrYl3Ud8iRTjV
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1546:b0:42f:8b0f:bad2 with SMTP id
 e9e14a558f8ab-431ebedf889mr51156495ab.10.1761336909185; Fri, 24 Oct 2025
 13:15:09 -0700 (PDT)
Date: Fri, 24 Oct 2025 13:15:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fbde4d.050a0220.346f24.0171.GAE@google.com>
Subject: [moderation/CI] Re: Fix ftrace for livepatch + BPF fexit programs
From: syzbot ci <syzbot+ci6f0efd85fecb43d4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] Fix ftrace for livepatch + BPF fexit programs
https://lore.kernel.org/all/20251024182901.3247573-1-song@kernel.org
* [PATCH v2 bpf 1/3] ftrace: Fix BPF fexit with livepatch
* [PATCH v2 bpf 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_di=
rect()
* [PATCH v2 bpf 3/3] selftests/bpf: Add tests for livepatch + bpf trampolin=
e

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/00cb80f1-d683-4670-ad05-00eaba93a8ff

***

kernel build error

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
.git
base:      7221b9caf84b3294688228a19273d74ea19a2ee4
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e69229e6-e6f5-44d1-87a9-ce16781a327=
6/config

kernel/bpf/trampoline.c:229:11: error: incomplete definition of type 'struc=
t ftrace_ops'
kernel/bpf/trampoline.c:230:11: error: incomplete definition of type 'struc=
t ftrace_ops'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrey.grodzovsky@crowdstrike.com andrii@kernel.org ast@kernel.org bpf@vge=
r.kernel.org daniel@iogearbox.net kernel-team@meta.com linux-trace-kernel@v=
ger.kernel.org live-patching@vger.kernel.org mhiramat@kernel.org olsajiri@g=
mail.com rostedt@goodmis.org song@kernel.org stable@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

