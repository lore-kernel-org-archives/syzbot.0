Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAF9249E5
	for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760545063; cv=none; b=ZGPuwrKHaTsfIBysx4nn+F0JYuZqJorWe++C8PwcbRexcmD9dbr/uMEhQ1y9BS6ZSP+IY0kCtkxJcnWShTZMubmXCa4Y6cDjQomlulO/pdbDuc68cPAwrewUDZDgu1i8Dx1lyabkIDCKltYsrH2yOXvq+oBs4/8dVQ00b3ZO7z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760545063; c=relaxed/simple;
	bh=ZY6cuPTO4/Q78IUQNWgZGTYuKT8ydC3Ic9xLK4GT6EM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=hWRkJDj6ZO6IlykwJDSTvgNz8lD6tLoiPvoaPLEUCwaQDq6EGsEra8HP/qjs9AxiL7JLamR9UirK1vUFqE/PCv4eV1V3eZYzmE9PEktrbunJQV4in2SDcW1xBURjg7ICnDS2r/7dyYWoRJb4QhaG2tmgDS++5bjw9SO3lOMe8Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42f8a89bb47so177782255ab.2
        for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 09:17:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760545061; x=1761149861;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RZXkw0GgFEo08moVz/xyetvpF5rGEOtSJp/Wz/JQvyE=;
        b=UNo4qZ+vOn1bXe64PSMFekGg7t+OiCMztHT58oVh7r9MyD2QZ3KYEWkGRK+3VSNnrx
         DcJG2e793jROBvhm+pSqs/k1DJRn1QAJw7dmmdjkj4Dy+cGVeoqVAKe4d7hFV35wR4Di
         7VTF9MPvEcqZBZBxkPJMz+p6vVn2aoUT5fUvGzRoTih97fsTs0Eskt1lmb8RA+eJS375
         +1W4LUXmVvYsYlYxaP3seoMuSlILgEfv7+VX97aIBJ5O3ZHa1JiKtkFgeOpYjo3CiVzm
         gPI+Pe+iZYbkTM5jVLMjpqKnrJhEEGZIbm+p0JdO3aQt9m2KABrlf3X/hH3dyMtIeUdf
         Nt8w==
X-Gm-Message-State: AOJu0YyXH8GLUIzH/nBc4K8zYy8aaDjR5uEtMWudOuPFkIW/8YaF42wO
	mEyDNWBXiJjsoWUoEv/v6Hytmn/bNd6rsfxKtTORJorMMWklNisJ1zhbVVfCXunBWLedt09PRz+
	DCduQkqMPbXaFIjY7FoZix6sBZnpnZ1IhV6ZmYZ30OLqB9eHPlgzwKnv46Mc=
X-Google-Smtp-Source: AGHT+IEVZhPJPAbH7xI7mGZsXXSTm2O6V2biWq2Wuocu0pEcCmRHFo7U/0zfnIH4OUGKWwPBqydTUSrFxrpfDFVfnSOAoTG4jztG
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1807:b0:430:a183:85 with SMTP id
 e9e14a558f8ab-430a1830868mr86001435ab.1.1760545060840; Wed, 15 Oct 2025
 09:17:40 -0700 (PDT)
Date: Wed, 15 Oct 2025 09:17:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68efc924.050a0220.91a22.02a2.GAE@google.com>
Subject: [moderation/CI] Re: mm, bpf: BPF-MM, BPF-THP
From: syzbot ci <syzbot+cid561235c8b6f0f02@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v10] mm, bpf: BPF-MM, BPF-THP
https://lore.kernel.org/all/20251015141716.887-1-laoar.shao@gmail.com
* [RFC PATCH v10 mm-new 1/9] mm: thp: remove vm_flags parameter from khugep=
aged_enter_vma()
* [RFC PATCH v10 mm-new 2/9] mm: thp: remove vm_flags parameter from thp_vm=
a_allowable_order()
* [RFC PATCH v10 mm-new 3/9] mm: thp: add support for BPF based THP order s=
election
* [RFC PATCH v10 mm-new 4/9] mm: thp: decouple THP allocation between swap =
and page fault paths
* [RFC PATCH v10 mm-new 5/9] mm: thp: enable THP allocation exclusively thr=
ough khugepaged
* [RFC PATCH v10 mm-new 6/9] bpf: mark mm->owner as __safe_rcu_or_null
* [RFC PATCH v10 mm-new 7/9] bpf: mark vma->vm_mm as __safe_trusted_or_null
* [RFC PATCH v10 mm-new 8/9] selftests/bpf: add a simple BPF based THP poli=
cy
* [RFC PATCH v10 mm-new 9/9] Documentation: add BPF-based THP policy manage=
ment

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a8a425e8-ff46-4bac-bf93-1ee0aad0c36a

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      56b4d162392dda2365fbc1f482184a24b489d07d
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/7b9d324c-f37b-4dfb-bbb3-f6ff6b11b13=
6/config

kernel/fork.c:1133:2: error: call to undeclared function 'bpf_thp_exit_mm';=
 ISO C99 and later do not support implicit function declarations [-Wimplici=
t-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[21cnbao@gmail.com akpm@linux-foundation.org ameryhung@gmail.com andrii@ker=
nel.org ast@kernel.org baolin.wang@linux.alibaba.com bpf@vger.kernel.org co=
rbet@lwn.net daniel@iogearbox.net david@redhat.com dev.jain@arm.com gutierr=
ez.asier@huawei-partners.com hannes@cmpxchg.org lance.yang@linux.dev laoar.=
shao@gmail.com liam.howlett@oracle.com linux-doc@vger.kernel.org linux-kern=
el@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com npache@red=
hat.com rdunlap@infradead.org rientjes@google.com ryan.roberts@arm.com shak=
eel.butt@linux.dev shy828301@gmail.com tj@kernel.org usamaarif642@gmail.com=
 willy@infradead.org ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

