Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54592D3A7B
	for <syzbot@lists.linux.dev>; Thu, 28 May 2026 06:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779948037; cv=none; b=RZgqaXZFrnZl1sxvAllMdf67cuX5qBE12nWmatvEsbIfox7v99SRwm0kSqCF6e8v2j9VUWwZ8Ldr1NpkAAGNL/6Q6hYM2v8WJyaJH38T42bRcoffSV4QxdbmvGxalhTZHNrBcnKpMpDaHfulWkEbSZPAnu1GhOcbY2REFX17VdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779948037; c=relaxed/simple;
	bh=Qo8+siPIPZX5h+CpY+gIBlRBkdx4bHqmyvPKHS1biEM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=FbvmzmTF/Ac8rj5fD/Y3UROsznDq6OBt34V6T7/G1yYNvgxKOU/F/q+tVG+kJ/mYrcMcvTPvkrVYeQ2g5VyXvsvSDGIfLnze+S9/6TnAyqoGAS/QTcH4S6y876rRnoUADMaBd2L6jD4n2m445gjkrKBkk5TXi3JArDuRgCbOB7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-69d86a152d6so6563100eaf.1
        for <syzbot@lists.linux.dev>; Wed, 27 May 2026 23:00:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779948035; x=1780552835;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=baLksnVAanA5SWwkLG3hsy/rKltiR203R1UfQgkjLak=;
        b=RxsUWwRavyqD2b94RjcDDHHNehGZ/uPBO85b7YGTq7Himnz8ellYp9Y8ccYoQLYA8f
         oH7Y3vdyrBBgSZdZ4Nx332SjYul2NqBl2y5eQYqFd3alDSoLBNJFS4F9pastCjc9Z0+D
         T7ZA86d2UiNMMkXry0u25BsRuoGDhYJpMPKtTQKb2zceJUfds4Z9VJAnkRUnoRbJwlIP
         pkeLM2vRQpk4q3lrRPgAoGD6ZmGriMlihmhjgmiggVPzzKHuzEWmkQETms6m/mhJ/wlk
         1klp208Bd/sCuUJkxOiWPPd5ErAFH0uR2AgVyTVDNVGBGd+CGEMJ09d/7chxad3WVBny
         Jzfg==
X-Gm-Message-State: AOJu0YxiY3VGcfNYcQ/qI9k2g0L3HNU3aslHzx5pBFjoleavMm9uoVcg
	h4ucq/TAesCdwjZk3Ul2ggc+fgzaZC5+tzKCe1VmeBZo7ukEfhyc85JmFYVVQi0jAv1XYnjaf2G
	xOhgFl3C7jr97ZOaocJJWdcqMbeQe343sDiRts/7xttIlvSh0zwYwAgBKcXA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ec4c:0:b0:69d:6bfd:5a3f with SMTP id
 006d021491bc7-69d7ece2eafmr14674415eaf.51.1779948034727; Wed, 27 May 2026
 23:00:34 -0700 (PDT)
Date: Wed, 27 May 2026 23:00:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a17da02.d07c18fe.1069e4.001a.GAE@google.com>
Subject: [moderation/CI] Re: mshv: enable kexec with Hyper-V donated pages and partitions
From: syzbot ci <syzbot+ci1e21bcc277045ad6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mshv: enable kexec with Hyper-V donated pages and partitions
https://lore.kernel.org/all/20260528004204.1484584-1-jloeser@linux.microsof=
t.com
* [RFC PATCH 01/20] kho: generalize radix tree APIs
* [RFC PATCH 02/20] kho: store incoming radix tree in kho_in
* [RFC PATCH 03/20] kho: add a struct for radix callbacks
* [RFC PATCH 04/20] kho: add callback for table pages
* [RFC PATCH 05/20] kho: add data argument to radix walk callback
* [RFC PATCH 06/20] kho: allow early-boot usage of the KHO radix tree
* [RFC PATCH 07/20] kho: allow destroying KHO radix tree
* [RFC PATCH 08/20] kho: add kho_radix_init_tree()
* [RFC PATCH 09/20] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
* [RFC PATCH 10/20] kho: extended scratch
* [RFC PATCH 11/20] kho: return virtual address of mem_map
* [RFC PATCH 12/20] mm/hugetlb: make bootmem allocation work with KHO
* [RFC PATCH 13/20] kho: add radix tree freeze and del_key() error reportin=
g
* [RFC PATCH 14/20] kho: Add crash-kernel-safe radix tree presence check
* [RFC PATCH 15/20] mshv: Use page tracker to manage MSHV-owned pages and p=
reserve with KHO
* [RFC PATCH 16/20] mshv: Add debugfs interface to page tracker
* [RFC PATCH 17/20] hyperv: Reserve crash MSR P2 for page preservation root=
 PA
* [RFC PATCH 18/20] mshv: Exclude Hyper-V donated pages from crash dump col=
lection
* [RFC PATCH 19/20] kexec: export kexec_in_progress for modules
* [RFC PATCH 20/20] mshv: freeze and vacuum partitions across kexec

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/3ae14a59-1f75-49c7-b968-ba5197b42ec3

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      e7d700e14934e68f86338c5610cf2ae76798b663
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/90866729-fbd8-4e80-afc5-b8813f0533f=
a/config

mm/mm_init.c:2705:2: error: call to undeclared function 'kho_extend_scratch=
'; ISO C99 and later do not support implicit function declarations [-Wimpli=
cit-function-declaration]

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
[akpm@linux-foundation.org bhe@redhat.com bp@alien8.de catalin.marinas@arm.=
com dave.hansen@linux.intel.com david@kernel.org decui@microsoft.com graf@a=
mazon.com haiyangz@microsoft.com hpa@zytor.com jasonmiu@google.com jbouron@=
amazon.com jloeser@linux.microsoft.com kees@kernel.org kexec@lists.infradea=
d.org kys@microsoft.com linux-arm-kernel@lists.infradead.org linux-hyperv@v=
ger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org longli@micro=
soft.com mario.limonciello@amd.com mhklinux@outlook.com mingo@redhat.com mu=
chun.song@linux.dev osalvador@suse.de pasha.tatashin@soleen.com piliu@redha=
t.com pratyush@kernel.org rafael.j.wysocki@intel.com ran.xiaokai@zte.com.cn=
 rppt@kernel.org sourabhjain@linux.ibm.com tglx@kernel.org wei.liu@kernel.o=
rg will@kernel.org x86@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

