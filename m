Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC310F4F1
	for <syzbot@lists.linux.dev>; Sun, 15 Mar 2026 00:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773533422; cv=none; b=c3j5hWo6U8k2PdodG9X/iFtAJ9hOxh8SDg3bKGcgJ1Wrm8cK/WCp9yzkY31abLApeSzgrNmWEcJxqdCFYSQpI3/Z+BQGuNUmrR0jz7V0QufIJokDnZbYQynNDFqFXNugjcWWElCimLyurLkybCcgtaaIiuf7eErxZYpfytlwmhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773533422; c=relaxed/simple;
	bh=d7aYvLII0ZjuEhAlfVGlNeENy1JmrNyZFLM3Wmlp7t8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=D4t4TEpCXhsCjp+Ay/xves3IrnXpwoT6ffAB++v8sR8zA0pEKyF1YeMIKeiZFVqL7qtLwj9x5MW0bf0O6KKV7XdOTvA9n2BpKbAxxzTmIQprrfxHC2UmbJKLiDtfZdnFyhkx2rJElUO2r47HpEsEm2h5vkcKVeQHwNYIK+1tptA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-67bbb4e5f24so28122725eaf.0
        for <syzbot@lists.linux.dev>; Sat, 14 Mar 2026 17:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773533420; x=1774138220;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPYfNc//b8ORMuEKV72jI3IiZgYfEzT0Uz6/OrSH9TQ=;
        b=pq74L/1GWs27h/G1IPRM20eQDQC7EHnvt5yrcUKgpbTy3xJETgOZZRyK25k7s/woDA
         FECwSp9fce+te+wq9VeipUWECeECM/xjqqgh6J9FAUnUVjn7U9iBNwbyannJ8xaT0q8m
         KzbydAsxGZlp4jiBVTb6OqJ6wUt5tz8x5j69BDXVbM+jue8ROhpdqFGrVPVP4iGog4L7
         NfXL4VRB/4EPCp4OzkDvFn8CncGcbeKErsaPONNsAQDRh7Y5MYaj1TrbPeD79CIbDfU/
         npL1Hjh6ixZzbdtkSnlQyKB1huOPj8tZKR/Nd5O0out4FPNaWnaTMSarZ43Fk2lT8AHR
         g9gg==
X-Gm-Message-State: AOJu0Yz9sGsB7g6rdTmfr2p68XI9FqZB7v3bE9x4eJuJ6Lanb7vrHY+2
	muUZr406wpLtWwh7BzgjG0mKnqSq4BE7DfXmpo/13dDuZl41pt3YcLrDWuVmsISnsdZ3/9uP2Qp
	gGO/F+E8zwDcDru8TKpsTIIplBNcaWpnpkiwAF2pGvDTLuThaJDM+vpLGjm8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d06:b0:67b:d0ce:a941 with SMTP id
 006d021491bc7-67bdaa714e7mr5471533eaf.53.1773533419820; Sat, 14 Mar 2026
 17:10:19 -0700 (PDT)
Date: Sat, 14 Mar 2026 17:10:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b5f8eb.050a0220.12d28.014c.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Remove inclusions of crypto/sha1.h
From: syzbot ci <syzbot+cicc9d4ccd6ccced34@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] bpf: Remove inclusions of crypto/sha1.h
https://lore.kernel.org/all/20260314210810.67348-1-ebiggers@kernel.org
* [PATCH bpf-next v2] bpf: Remove inclusions of crypto/sha1.h

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/38f41420-5e88-492b-9239-7c260178aa25

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      1c9982b4961334c1edb0745a04cabd34bc2de675
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b5327796-0a46-46fc-a192-f0dbd20d904=
7/config

net/ipv6/addrconf.c:3341:25: error: variable has incomplete type 'struct sh=
a1_ctx'
net/ipv6/addrconf.c:3344:13: error: use of undeclared identifier 'SHA1_BLOC=
K_SIZE'
net/ipv6/addrconf.c:3369:2: error: call to undeclared function 'sha1_init';=
 ISO C99 and later do not support implicit function declarations [-Wimplici=
t-function-declaration]
net/ipv6/addrconf.c:3378:2: error: call to undeclared function 'sha1_update=
'; ISO C99 and later do not support implicit function declarations [-Wimpli=
cit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net =
ebiggers@kernel.org eddyz87@gmail.com haoluo@google.com john.fastabend@gmai=
l.com jolsa@kernel.org kpsingh@kernel.org linux-kernel@vger.kernel.org mart=
in.lau@linux.dev sdf@fomichev.me song@kernel.org yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

