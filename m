Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A902175A68
	for <syzbot@lists.linux.dev>; Thu, 30 Apr 2026 01:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777514136; cv=none; b=UvgG3E/hwjbyctqcSP3inUlk1D/5Q5TKkj+5mfLMMXZ3RtbR9hLoiTxzbfdFPrgMo9cqIzWbswnaRxnfKKQl60oADR1OEyQfjrSIABPyQaoqtLLiAwOMjfBALngaGHV5NeLd6c5htCGsy8R20qa00dPBVUZfpM9Y5RN7tmGjXOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777514136; c=relaxed/simple;
	bh=4lftk16KYhw+aVeAER8Zq2mBgEJf5z8VXBvHkxh3Fe4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=EmHb2bC8+CqFYDUeDpKpShX+VeDoTKgINDyMzvkDFybBz3wzyop6WoLGxGQ/91FfsWVHxp9VukaWzOcRwl9RBLu6sqkq3mgRY4J10xYsKj9I8gXkKImm2qVByqZb/jXQQTEmw2+DAeEUY4rB5vOnozdjLzlk6ZQBCKXi7g5Ns7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6961e8fa90bso959604eaf.0
        for <syzbot@lists.linux.dev>; Wed, 29 Apr 2026 18:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777514134; x=1778118934;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fR+S9RO1SNNYiWaLMXSwt+W6CSvQYQ6AaQ8PGGasH+Y=;
        b=YKFpfqXaByoeTol7K5cOi/4PUvdo0h2QEKqgH6x5i4Uq4y9DoIXlm4Ef4YDHA5GAn8
         q+kDG78VraLdu49cwZX3mgAFburDjVPtEaBgOsWcDJ/DQQgh2QzkuggIsWEb599Fvsu4
         uQ5QXQkKNWSOKTrDWp3404hMUU+nPU/hxF0mW3bHxCssc94IRVBQ6pdOHXctwmiamIbl
         w6cP4BdjStR4mvGfkqRvN11jV59mJCXX8ejkluEyNY+efjEQZioyew+puU6/QgFpgzS9
         OY52aPvEWUcACsxgJE9+Q/TSrFpxQgaBfpCjXzrqxB9cE4t9j3RbnH4/hKum7t50ZxrI
         /nSQ==
X-Gm-Message-State: AOJu0YzGqVgD4pTG6w9NaUNVnWrCeDBDeYJPjWZ0rcrXsqqDEM/uuz2k
	CHcY+GWgeDfz6l1paBb3V2RUjinPsboKKXAsU/oLfC7rOnOlrVEOvqjObW+W/dzq+0b9KkaFIhY
	mGJ5W4USaIFOaYDXGbw7OCLSlzaPvsZ+wnuMY/G2gMzIsyfRFplBQ3KJmgBk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2016:b0:694:6d72:9fd0 with SMTP id
 006d021491bc7-6967a56709fmr538191eaf.16.1777514134085; Wed, 29 Apr 2026
 18:55:34 -0700 (PDT)
Date: Wed, 29 Apr 2026 18:55:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f2b696.050a0220.11c491.0007.GAE@google.com>
Subject: [moderation/CI] Re: Optimize this_cpu_*() ops for non-x86 (ARM64 for
 this series)
From: syzbot ci <syzbot+cic1fbba0efd11a7fa@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Optimize this_cpu_*() ops for non-x86 (ARM64 for this series)
https://lore.kernel.org/all/20260429170758.3018959-1-yang@os.amperecomputin=
g.com
* [PATCH 01/11] arm64: mm: enable percpu kernel page table
* [PATCH 02/11] arm64: mm: define percpu virtual space area
* [PATCH 03/11] arm64: smp: define setup_per_cpu_areas()
* [PATCH 04/11] mm: percpu: prepare to use dedicated percpu area
* [PATCH 05/11] arm64: mm: map local percpu first chunk
* [PATCH 06/11] mm: percpu: set up first chunk and reserve chunk
* [PATCH 07/11] arm64: mm: introduce __per_cpu_local_off
* [PATCH 08/11] vmalloc: pass in pgd pointer for vmap{__vunmap}_range_noflu=
sh()
* [PATCH 09/11] mm: percpu: allocate and free local percpu vm area
* [PATCH 10/11] arm64: kconfig: select HAVE_LOCAL_PER_CPU_MAP
* [PATCH 11/11] arm64: percpu: use local percpu for this_cpu_*() APIs

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/56a62ce3-67e8-406b-a1b8-9466bcf47f99

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      254f49634ee16a731174d2ae34bc50bd5f45e731
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b8a79ddf-dd8d-479d-96f7-cf60aed2e82=
2/config

mm/percpu-vm.c:190:28: error: use of undeclared identifier 'percpu_pgd'
mm/percpu-vm.c:283:32: error: use of undeclared identifier 'percpu_pgd'
mm/percpu-vm.c:299:28: error: use of undeclared identifier 'percpu_pgd'
mm/percpu.c:3292:32: error: use of undeclared identifier 'percpu_pgd'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[agordeev@linux.ibm.com akpm@linux-foundation.org catalin.marinas@arm.com c=
l@gentwo.org david@kernel.org dennis@kernel.org gor@linux.ibm.com hca@linux=
.ibm.com linux-arm-kernel@lists.infradead.org linux-kernel@vger.kernel.org =
linux-mm@kvack.org ryan.roberts@arm.com tj@kernel.org urezki@gmail.com will=
@kernel.org yang@os.amperecomputing.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

