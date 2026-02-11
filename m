Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025EA2FCBF0
	for <syzbot@lists.linux.dev>; Wed, 11 Feb 2026 03:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770782119; cv=none; b=sVXdPRAqM/kA0qQT71VmcyUwCpP7SWlfyxM+bqFCoFCEmdFOjh+1xqn1TnuRYB8G8/5Q+XcxPjCcAgAf3pm3oJKI+zokxhbXkgGKZXNDkCpMIYwXEHrzS8XS81JeJN90KbS4AfxVQkrkfv2qzaC1eFvRarCVvPJrREoe0jfZvRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770782119; c=relaxed/simple;
	bh=GVA22PENoNO2jAL2YZCre7PtKPSsK479tQwWn46P4GQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Gh2RA4Mbga0AsJuYwdu1m0G6oXGPrXNu018AT/ggyG61tqKILq2WKkk8coWj6f950y9y6PEOy+PisVCKcTNkEYKipbQKrq39rOb0MHucf/6/n2hIycVibITBs0M2czqsLZO75mJzWlyCHn200ZcfG02+KauD5+9BfWJ5MZmSKe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6630b0a016aso6731351eaf.0
        for <syzbot@lists.linux.dev>; Tue, 10 Feb 2026 19:55:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770782117; x=1771386917;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bRqaskFLT1Fzh7AYOoLyWo4K9tJzgtzAI4PxWKBsYT4=;
        b=kGmwxO0fXdSEX8NIkVhBpUcDF5eKcNL9lUA8cqvoAwIbYqLldL6h3jvwKTiOZDKgfs
         3q5OfdrdNT4KTUb/vi9IPktq+DF0ATlEatHI0j5naORiw8iB3u4nIMbM/2NdbAz77xVW
         auIMD0Wayw7N7incDWVp/tT62EnfgpJaHWDd27blXzFIkmAntT25E9WqFUGFqe9dNQC4
         Xl2MWqxYZNtaS0ndZ6RPfGgc9UIH8SUUsUNUAwZ4ESOMeZDFsJ57o3NLtAUQqdFK5EcV
         H2NJ3AcCdPml0v1tz1TP/ynbtutWQ5uFQHQYklxqW0crXFd1WRwwGzdrAzd5n/MDj11Q
         Nwuw==
X-Gm-Message-State: AOJu0YydikG6diAyj4Fzo33hlhC9V/5X16Mrz8N07oBoVn82zGblRwJl
	yxhjonklpUYKHXKwypXeWmkH4K0oiJqoa1biNogM2gsBpPXrHO2TFmrkqiiHnUnglhY2RQEx/mo
	gt8t9dsju/w0tDJIYf5H6W2fzELxM8x/k2tdbGdbVrduEGLdp/eJhshylYFg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:207:b0:662:fd74:61d5 with SMTP id
 006d021491bc7-66d09abf9b4mr7524929eaf.3.1770782116964; Tue, 10 Feb 2026
 19:55:16 -0800 (PST)
Date: Tue, 10 Feb 2026 19:55:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698bfda4.050a0220.2eeac1.0093.GAE@google.com>
Subject: [moderation/CI] Re: mm: khugepaged: make scan loops suspend aware
From: syzbot ci <syzbot+ci709c6b85505bf415@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: khugepaged: make scan loops suspend aware
https://lore.kernel.org/all/20260211030024.232964-1-senozhatsky@chromium.or=
g
* [PATCH] mm: khugepaged: make scan loops suspend aware

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/2ff9a9e1-d2c9-404f-abdc-6e4e11db1ec0

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      92dbb8c3997c9148eb37095eb0c2a4d02489ad12
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/60005f39-0e81-4ff1-a9f9-2981b6ac952=
0/config

mm/khugepaged.c:915:53: error: too few arguments to function call, expected=
 2, have 1
mm/khugepaged.c:2440:53: error: too few arguments to function call, expecte=
d 2, have 1
mm/khugepaged.c:2448:54: error: too few arguments to function call, expecte=
d 2, have 1
mm/khugepaged.c:2470:55: error: too few arguments to function call, expecte=
d 2, have 1
mm/khugepaged.c:2488:48: error: too few arguments to function call, expecte=
d 2, have 1

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.com =
david@kernel.org dev.jain@arm.com lance.yang@linux.dev liam.howlett@oracle.=
com linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.=
com npache@redhat.com ryan.roberts@arm.com senozhatsky@chromium.org ziy@nvi=
dia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

