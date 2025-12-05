Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2BF13D539
	for <syzbot@lists.linux.dev>; Fri,  5 Dec 2025 20:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764966922; cv=none; b=URB35hhwvGvhGPma61Gc4VHroJjG/1701yC7G4+LnH4yzGCRg6NezjLobvLT0816Ps9YPy9XOHQ+9YvSBO+hQNBU+zau74YlMvyuEk88WFxdcUw3Cq0z2Rbo2ifzwmRjVN2Vw6zf3+VtKBBVDpUFHCiU5bigfgXD1l1xa+Hh6BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764966922; c=relaxed/simple;
	bh=HIP4H/oyJreZFgL5TKL77/IhvEtpt5DoieCwq4pjYfM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=SfaaNi5bQ/q02KqYYIgQjyxagAPsc7Q62gihUx1L72BddHrXsr8NceszJM/wZc4MltnLslDv9mbVXPYXyuV93e4TLgxD6k6uTGBemZ+58+1hkbmtdCbTDlfz7thJ7fZO5dbSfFk6kfZ2SpmuuzLnEEaezP2HKad3/4kQr53AmRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-65742f8c565so3289806eaf.1
        for <syzbot@lists.linux.dev>; Fri, 05 Dec 2025 12:35:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764966920; x=1765571720;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dBJ6NxXDZa9lA3+bh6oMo1+Rx6kQYI/UpFppVhKnwLo=;
        b=S7dtbdQV+MBUyQURzaPW/ugSZJdj/m3oaxbZgB7O0sTtM4pI5rjEGIliuuJBsYgAFA
         iVVAkRU8eodgOO5cgJxEJboB3HqDNCMiKwWvYyJvId3ctVyvZbQOHw5mhLgukbeJQOEe
         DpmXO76GjAJiY5+fAXnD93PVf85nn7tnIk3pAL9DVqJ7k3w4dcSHJNCTsmyaQ83x5nBn
         rWkZujezcrmnjgDEjYBqRRWvlPCJVtUEeAcen+a24FGnn/RVsupOI8lvVwILmK6Jchxe
         /4H0KvNfCvkJOvFmrNaZzASymyHM7tDTDCMwKbT3yXhU3Y6s/XZ/XzmmkAmxBFaJWH8z
         tpHQ==
X-Gm-Message-State: AOJu0YyC/B9KOHLGqtvqo2A7+sq0yq8u/9H/IoMiBHz1eebNUo8gKTM1
	8InEygwGKVdxfPiYiDeiE/T1mO2APg3YH1Crgfc0wk4hbCqutVd3tDuTv2xsqZBDo2pnTXJPv+n
	cEM4dqzwTR0zzTiLkbxQe8OWC2m7nnvk5WNPyW5dZQhQrPWU2DjL1IfxWjhE=
X-Google-Smtp-Source: AGHT+IEzd5PWJsVo1GcMT43h23po/oUUblKrN40Mme8aOh3M3hM/wVyp99pYk0E/siJfzk/jot8kD1fUJ3/BiIxy6H6qFtWB2Ij9
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:60a:b0:659:9a49:8fa0 with SMTP id
 006d021491bc7-6599a8d9d21mr241158eaf.25.1764966920380; Fri, 05 Dec 2025
 12:35:20 -0800 (PST)
Date: Fri, 05 Dec 2025 12:35:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69334208.a70a0220.38f243.0009.GAE@google.com>
Subject: [moderation/CI] Re: mm/hugetlb: Eliminate fake head pages from
 vmemmap optimization
From: syzbot ci <syzbot+ci19d6a3394b57f8e9@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm/hugetlb: Eliminate fake head pages from vmemmap optimization
https://lore.kernel.org/all/20251205194351.1646318-1-kas@kernel.org
* [PATCH 01/11] mm: Change the interface of prep_compound_tail()
* [PATCH 02/11] mm: Rename the 'compound_head' field in the 'struct page' t=
o 'compound_info'
* [PATCH 03/11] mm: Move set/clear_compound_head() to compound_head()
* [PATCH 04/11] mm: Rework compound_head() for power-of-2 sizeof(struct pag=
e)
* [PATCH 05/11] mm/hugetlb: Refactor code around vmemmap_walk
* [PATCH 06/11] mm/hugetlb: Remove fake head pages
* [PATCH 07/11] mm: Drop fake head checks and fix a race condition
* [PATCH 08/11] hugetlb: Remove VMEMMAP_SYNCHRONIZE_RCU
* [PATCH 09/11] mm/hugetlb: Remove hugetlb_optimize_vmemmap_key static key
* [PATCH 10/11] mm: Remove the branch from compound_head()
* [PATCH 11/11] hugetlb: Update vmemmap_dedup.rst

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/4fa90690-ec1a-4c64-84e8-f0cf29c125c6

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      2061f18ad76ecaddf8ed17df81b8611ea88dbddd
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/d01167aa-6df0-44ac-90bb-974914f50c3=
e/config

mm/kasan/../slab.h:142:25: error: no member named 'compound_head' in 'struc=
t page'; did you mean 'compound_info'?
mm/kfence/../slab.h:142:25: error: no member named 'compound_head' in 'stru=
ct page'; did you mean 'compound_info'?
kernel/bpf/../../mm/slab.h:142:25: error: no member named 'compound_head' i=
n 'struct page'; did you mean 'compound_info'?

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org bhe@redhat.com corbet@lwn.net david@kernel.org h=
annes@cmpxchg.org kas@kernel.org kernel-team@meta.com linux-doc@vger.kernel=
.org linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle=
.com mhocko@suse.com muchun.song@linux.dev osalvador@suse.de rppt@kernel.or=
g usamaarif642@gmail.com vbabka@suse.cz willy@infradead.org ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

