Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48FD33AD85
	for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 20:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764101752; cv=none; b=h+T2Ct4aA3vQoBS+Pg00uF9x783XVHQ/Hyy45LETBq6taRAP/rPMW1/1MkqTVCJQHPxsLXSZyKk8RG2/A2aNOZgjHAWyzV6JMAhDo2R047/Tio3kM/0lNr5D0hXN09cPsiMGkjd0xp09NTNmrE8poKXFpMxklPQlYLC4e8OdXXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764101752; c=relaxed/simple;
	bh=99XxdgQlALExmrApDG3dG2nBk9DtjVls0yqUzxvlCCM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=jjZzH9QOdo9MkR6PmPeECQveNiJDUTg33vlbgr2oKFWSB5JRGQUlXpTtZDkXjs3l8e/5UlvoNYwo8RUvVhBWRJy/mJtuPBdtKbtVr1/808qktis/4FkQV6zs8Sg2mFbz+NPMOq0sRIAn8HMBl0JM5zDyVZ0mpB6Jz+ZPz314x7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-9486c2da7f6so373481639f.2
        for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 12:15:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764101750; x=1764706550;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TBTqXGlp1gGa69x7u2HqR0jSMQKxVvPalxaM8lUgKxc=;
        b=NUKnxeayejeSmApRt9U+JgzsiryVGYMUkGbcjb1jnNAaTFOnsznxulkaAD1Z5WVTg3
         n5bOp+ozzqg3Axh31uvO0U8RKc6XFwGsUjoZgzG+m242g/ymh6v50E7JFgvDHcNG1dH3
         yssozlXuDkTK417ZzkrctYYJpe9YXpEy/TqQZF/Jh5WVa4QJiv/r0cMY3kbWFDvaAT2h
         vIR/aC3nUepinLZdkbwlC2qBIJMtnYJH2QI2yQl8PzcQkzLYWfrAIFlHvdkwBHogtpzp
         Z0uV+kk2jgbWTMuksu2VJNVpPl1fAxtKCq5T2FqNwPEvh1aV0bdqTrp4WXWRrcIdt1gd
         ya6g==
X-Gm-Message-State: AOJu0YzFm6k7UNXVGTt2F88MdN19R5H/UvdPOcWRz7bOCAL9kpyc0La5
	7F8lYDJETSWF9oy6VWF9fj/qsuSdGJZ4QnDe+GJNrCZRtg5e7ruxxMCQ6TbRu4TBP4NQQur4wXY
	FQXNkB9pW/w6Uk7W9ZzFW3ZbjEN77DDORBgA87MavSBpk1GEtZdQl5ey0nZM=
X-Google-Smtp-Source: AGHT+IGCvfGkzbs+f8RW6gSV01JPioAU1JUOJt5ZCpfPfbF1sDA4tq4Pj/kNUEJ3n7MoNbQ9llZLFfRNoDYEm9HP5ZGr9qmorNBx
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3312:b0:433:27e9:8690 with SMTP id
 e9e14a558f8ab-435b98d0175mr134186025ab.21.1764101750008; Tue, 25 Nov 2025
 12:15:50 -0800 (PST)
Date: Tue, 25 Nov 2025 12:15:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69260e75.a70a0220.d98e3.00b6.GAE@google.com>
Subject: [moderation/CI] Re: mm, kvm: add guest_memfd support for uffd minor faults
From: syzbot ci <syzbot+ci2b15fe0c5f4eb676@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] mm, kvm: add guest_memfd support for uffd minor faults
https://lore.kernel.org/all/20251125183840.2368510-1-rppt@kernel.org
* [PATCH v2 1/5] userfaultfd: move vma_can_userfault out of line
* [PATCH v2 2/5] userfaultfd, shmem: use a VMA callback to handle UFFDIO_CO=
NTINUE
* [PATCH v2 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
* [PATCH v2 4/5] guest_memfd: add support for userfaultfd minor mode
* [PATCH v2 5/5] KVM: selftests: test userfaultfd minor for guest_memfd

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/c33aebdd-3f84-40f5-9760-fe082979ee00

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      23cb64fb76257309e396ea4cec8396d4a1dbae68
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/42033b52-7f41-4fed-a635-cff301ad81f=
9/config

arch/x86/kvm/../../../virt/kvm/guest_memfd.c:401:22: error: redefinition of=
 'kvm_gmem_get_folio'
./include/trace/events/f2fs.h:1436:3: error: expected expression

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aarcange@redhat.com akpm@linux-foundation.org axelrasmussen@google.com bao=
lin.wang@linux.alibaba.com david@kernel.org david@redhat.com hughd@google.c=
om jthoughton@google.com kalyazin@amazon.com kvm@vger.kernel.org liam.howle=
tt@oracle.com linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org =
linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.com pbonzini@redh=
at.com peterx@redhat.com rppt@kernel.org seanjc@google.com shuah@kernel.org=
 surenb@google.com vbabka@suse.cz]

If the report looks fine to you, reply with:
#syz upstream

