Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFCD2C08C0
	for <syzbot@lists.linux.dev>; Mon, 17 Nov 2025 17:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763401340; cv=none; b=BJzweIZtEsUF3oy6GEw6e4kyI4Ack+9bPFLPEPqFp+ZvKJtAIJI5wIMmrEKnG5W+jjq3uKjeVHFUBptbyndQlx6opTg1/btcpTzPJAT2aKYj8fpKezOBA2n8JroN8hwE8+5Z0PJVdD6K1eGzw6v22BdFB+k08LQ9hgBs4kWE5QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763401340; c=relaxed/simple;
	bh=y1MKzWFjTgqmjlKAfqP58WQ4RySwKbU0ZXkAHm8ppJQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=J1Dk5k5nLYV4T8k77nHEFXe1X0WwT84Rmjkmy6VHgYEnlTjemjeyK/vRfRQj/4zURWelEnnN0+1LTxLDLXBSO2Etkth6Z4sT0C2Uhrfbzvh1/EylFOpOs/3in2xaOXdNhCVZE/NRYw0OTyYtGLxgqPsTHI3ENvwU2PI/9LzcZ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4337cb921c2so49944945ab.2
        for <syzbot@lists.linux.dev>; Mon, 17 Nov 2025 09:42:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763401337; x=1764006137;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cV5/HemhElpQUJCupDYIED0BzPGYBe3j6gSNEYuGFs4=;
        b=JAhlB318/lhb9/8a1tew1dB2JeoPaXYNE9BOkaf70x8/1cWnvWxt2EES7brw1hiHwF
         TL4udK8bMPX/Rqw0LB+rOJQXEEfYo3bmLTY6Iov+uyj3VtA4n1uhYCXxpXHTX7tc4EW3
         41ck5oi3oOAX6ZtDTx/51EafsYB4Hs+ErgwhCsFQiUYRuMkDno8uzHwN+6Vd0oOVU8OR
         8YuT3LiIS4uLmCHVv8aD9kM6nlQ0Efk7QcRPB/OpAGxmsXC7lsJyo6bJqMNq/Y/M48tE
         4Hr966yZ47a7f+e/EVqJp3L1Ku58sZpm5QctlLCdB2iisMBuU+mVx7mN7vW2L4EEhx3t
         go/A==
X-Gm-Message-State: AOJu0YyiHvLwSpc14SiDvoHUSTKrjca4liwiOZx3tMhn+Eh881zZlVY4
	qvDS11ts6GGlCP2+P1Ynt55c2KWTxgCTkjRr6Eokaf75unKf0r6H9ezMPfjO8JFnYmPE4z27WzH
	rkWXUckyRgQU7q+ziEbhXyExpq0xidBWoSDyz2nB9s0P/g3SsfuSd62PcQ4M=
X-Google-Smtp-Source: AGHT+IGQJEB/RbRHRebV8Gk8m9Rq4e0odXt6CjIblqZ+wXL2y3ATjLgnlGPeglq71F4XYoeIMRpkH5vOgv0tVqdbBvKrHd8f3kAF
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3812:b0:433:7b22:c2cd with SMTP id
 e9e14a558f8ab-4348c8be2b8mr169346295ab.8.1763401337697; Mon, 17 Nov 2025
 09:42:17 -0800 (PST)
Date: Mon, 17 Nov 2025 09:42:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691b5e79.a70a0220.3124cb.00a6.GAE@google.com>
Subject: [moderation/CI] Re: uaccess: Prepare for masked user access on powerpc
From: syzbot ci <syzbot+ci77807743ed5cbacd@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] uaccess: Prepare for masked user access on powerpc
https://lore.kernel.org/all/cover.1763396724.git.christophe.leroy@csgroup.e=
u
* [PATCH v5 1/4] iov_iter: Convert copy_from_user_iter() to masked user acc=
ess
* [PATCH v5 2/4] iov_iter: Add missing speculation barrier to copy_from_use=
r_iter()
* [PATCH v5 3/4] scm: Convert put_cmsg() to scoped user access
* [PATCH v5 4/4] lib/strn*,uaccess: Use masked_user_{read/write}_access_beg=
in when required

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/771de1b6-9b18-4cc1-b1ba-006b1799d4b5

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      c99ebb6132595b4b288a413981197eb076547c5a
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/f324fa8a-207c-4830-8eec-90b212598e3=
8/config

net/core/scm.c:276:3: error: call to undeclared function 'scoped_user_write=
_access_size'; ISO C99 and later do not support implicit function declarati=
ons [-Wimplicit-function-declaration]
net/core/scm.c:276:51: error: expected ';' after expression
net/core/scm.c:276:44: error: use of undeclared identifier 'efault'
lib/strncpy_from_user.c:129:9: error: call to undeclared function 'masked_u=
ser_read_access_begin'; ISO C99 and later do not support implicit function =
declarations [-Wimplicit-function-declaration]
lib/strncpy_from_user.c:129:7: error: incompatible integer to pointer conve=
rsion assigning to 'const char *' from 'int' [-Wint-conversion]
lib/strnlen_user.c:102:9: error: call to undeclared function 'masked_user_r=
ead_access_begin'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
lib/strnlen_user.c:102:7: error: incompatible integer to pointer conversion=
 assigning to 'const char *' from 'int' [-Wint-conversion]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org andrealmeid@igalia.com brauner@kernel.org christ=
ophe.leroy@csgroup.eu daniel@iogearbox.net dave.hansen@linux.intel.com dave=
@stgolabs.net davem@davemloft.net dvhart@infradead.org edumazet@google.com =
horms@kernel.org jack@suse.cz kuba@kernel.org kuniyu@google.com linux-block=
@vger.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org=
 linuxppc-dev@lists.ozlabs.org maddy@linux.ibm.com mingo@redhat.com mpe@ell=
erman.id.au netdev@vger.kernel.org npiggin@gmail.com pabeni@redhat.com pete=
rz@infradead.org tglx@linutronix.de viro@zeniv.linux.org.uk willemb@google.=
com]

If the report looks fine to you, reply with:
#syz upstream

