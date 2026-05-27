Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E052EA47C
	for <syzbot@lists.linux.dev>; Wed, 27 May 2026 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779914647; cv=none; b=fJHsr2jUFrVPvi8mhOGj6O5xwIZx6eQ7SWzF3tzawzni4D7AAUZmIxUARlutPuN1f2akj+cjnStN/sn9fpSaLZFHOSxODcwllbb5tujP5ZFU9zeBdemH3uxggWrnQQyS79rectPv4HRXG6WBQlvjrg2TigJ2PmRczo3m2OQdzu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779914647; c=relaxed/simple;
	bh=MsymBjKuNXd3/JVGastShKSSF363j515ZA6NBtuI5Ok=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ZKHll76KAcQ/uItNb7O98P7EmpUClcw8tTFTJSt5M7gjKhveo5zDz3liC9yLlDuS9mcjZM+NgkJxITI2xVmFMVFa1DSqyF6w/saWGByLZyJxDskBd/ptT0qSp3NeYCXz2XNv1tR3n/xjK+0dxr02lpO4u+7MzMOyclvdp0/Fo54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e61d8d99dfso7547934a34.2
        for <syzbot@lists.linux.dev>; Wed, 27 May 2026 13:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779914645; x=1780519445;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gwkHraB6eOnoNn95bkNWzks4oVQG1GRt+iyXPDDv/0A=;
        b=aDyH0wsbT3J8bt0rKS2IUCw3PC18aTrBm0g0hO68vMI2nqH2x7RFkg5cDWSpr1JiNp
         xWerjoiAY2X0RXeGYD6rNGj0Cb8RoHxZCPZB4zPlbe4Gr1iWPDhroCASk1mO2iximmcb
         yg44xGMax6vgln+oQdA/q6R22R5YlbnlowTfWR2xDs/rWXvPi6cLdkx5dbS8Ja7yhrSp
         KelZGJcKs5OJojybIjzMNf01qiRofBEgHfqDC0qhx8kzIMa9qGdGMwJjsCCP97O6+33g
         v+nVRaGcNpc2KSwJ73f/c3dY3OiMyPhIdG9mE2CzQ2IHCz5+gkS7WLk8MqhmOBRh/PUj
         OyqA==
X-Gm-Message-State: AOJu0Yyg7bUP9rDlCLA0eX4GxynIGYfZ0vaGXasP0PYdrw/OYuer20c7
	cRnz+4sSAbkWrHkS3OtUbKggHMBW+qJ0AiuFSGO33RSwvt7y6aWlwWYVoJPkAJqQHWQAU2Iy0yI
	Nnf8stkXBMMyyAwPwMHCqAKTb9PpwrfgOIYzFhxZK5/gnumqxQTJiewtCayM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:983:b0:696:1cbd:27b2 with SMTP id
 006d021491bc7-69d7ec42e11mr11073862eaf.29.1779914645048; Wed, 27 May 2026
 13:44:05 -0700 (PDT)
Date: Wed, 27 May 2026 13:44:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a175795.52c88913.99dcf.0000.GAE@google.com>
Subject: [moderation/CI] Re: mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
From: syzbot ci <syzbot+ci96bfa5a8ff3778dd@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
https://lore.kernel.org/all/20260527110147.17815-1-tao.wangtao@honor.com
* [PATCH 01/15] mm/rmap: introduce anon_rmap APIs for anonymous folios
* [PATCH 02/15] mm: convert anon_vma rmap APIs to anon_rmap
* [PATCH 03/15] mm: introduce anon_vma_tree_t for multiple anon_vma topolog=
ies
* [PATCH 04/15] mm: switch to anon_vma_tree_t APIs in preparation for ANON_=
VMA_LAZY
* [PATCH 05/15] mm: add CONFIG_ANON_VMA_LAZY and folio helpers
* [PATCH 06/15] mm: add CONFIG_VMA_REF and VMA helpers
* [PATCH 07/15] mm: replace direct FOLIO_MAPPING_ANON usage with helpers
* [PATCH 08/15] mm: prepare rmap infrastructure for ANON_VMA_LAZY
* [PATCH 09/15] mm: implement ANON_VMA_LAZY rmap semantics
* [PATCH 10/15] mm: defer anon_vma creation with ANON_VMA_LAZY
* [PATCH 11/15] mm: handle ANON_VMA_LAZY in huge page operations
* [PATCH 12/15] mm: handle ANON_VMA_LAZY during migration
* [PATCH 13/15] mm: support setup and upgrade of ANON_VMA_LAZY folios
* [PATCH 14/15] mm: support merging of ANON_VMA_LAZY VMAs
* [PATCH 15/15] mm: enable CONFIG_ANON_VMA_LAZY on arm64 and x86_64

and found the following issue:
SYZFATAL: image testing failed w/o kernel bug

Full report is available here:
https://ci.syzbot.org/series/c401d17b-0a67-4742-b7dc-c49a853a31dd

***

SYZFATAL: image testing failed w/o kernel bug

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/69c9ca24-ff3b-4eb2-92f8-347468dba38=
2/config



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
[21cnbao@gmail.com akpm@linux-foundation.org apopple@nvidia.com baohua@kern=
el.org baolin.wang@linux.alibaba.com bp@alien8.de byungchul@sk.com catalin.=
marinas@arm.com chengming.zhou@linux.dev damon@lists.linux.dev dave.hansen@=
linux.intel.com david@kernel.org dev.jain@arm.com dvander@google.com gourry=
@gourry.net harry@kernel.org hpa@zytor.com jack@suse.cz jannh@google.com jg=
g@ziepe.ca jhubbard@nvidia.com joshua.hahnjy@gmail.com jparsana@google.com =
kas@kernel.org kees@kernel.org lance.yang@linux.dev liam@infradead.org linu=
x-arm-kernel@lists.infradead.org linux-fsdevel@vger.kernel.org linux-kernel=
@vger.kernel.org linux-mm@kvack.org ljs@kernel.org luizcap@redhat.com matth=
ew.brost@intel.com mhocko@suse.com mingo@redhat.com nao.horiguchi@gmail.com=
 npache@redhat.com peterx@redhat.com pfalcato@suse.de rakie.kim@sk.com riel=
@surriel.com rppt@kernel.org ryan.roberts@arm.com ryncsn@gmail.com shakeel.=
butt@linux.dev sj@kernel.org surenb@google.com tao.wangtao@honor.com tglx@k=
ernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

