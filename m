Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB74F63CB
	for <syzbot@lists.linux.dev>; Sat, 26 Sep 2026 15:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790434845; cv=none; b=inNZ9PLEcmnkc4DywRu/PbuVPz1UuM5FALRwwUF2wnQ+aeNuR4TSL98bfb6TTjaNX58fpHj97pOyvFPS+AxpT7tCYIbKYh/MFJN7CEvTFjbXdnf0xW3Wa6KxIhTy3y9wX86KaJeI1AQ0wns6dmfFVHGJSU1gzw3O/4+q+3XCT30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790434845; c=relaxed/simple;
	bh=tc2q9aXdXzTWxdW7E5okr8YRuhqJPf5HhZhFIOyM/Ng=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=efWnZCfYqWbidgHteSHVl7eF9mfXeVllaeZqzkNY+zxmna0v0efAFKM/U3RGyBtNjThg8Gbfvjpx2RMOovya2WyS2KVv+eLFMYeSmnUugLh2SsZgx58tT3P6GXjKTta3fdHmC4gwjEycK8hIzEt6DjogVVG79eICrooMnYZI8vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a45b3f0bdfso3012841b6e.1
        for <syzbot@lists.linux.dev>; Sat, 26 Sep 2026 08:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790434843; x=1791039643;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SIC4k0VnJx2xtqlfymS/EyK2KrItGu/PSqfUSnyEvYU=;
        b=gdfnQqzLiiWukQUvxa0L3Gt8qjkuBhyCPl8rHBzJo3QTKvb+hfdClxnv0L1A1Qz41j
         zlZ2ciZjY4XwWz+mTOvjY4tzMUqahddsYyWFmnWJZJFVmj2D7P2PqOsIk49hkYuoWPsT
         yRtr2+yp/3q03v3AD55t7/8P4Ku+sOS3eIAMFEvvubY6Q3/NzwFRtQOE8b18vteoDQ/j
         iZof2hMdTEErmZxRy5b6Q0ItH98CsvLBvzJDpcMDG9O3B8UzEgpY4A9dtyCn8JA1wopa
         9YfTezGmz1Pe6Uto7MwK9rcPu0elP4ZeZPMqNg3tbcWKEeeotfQUsu8RrtGMnJg+6/t3
         c6iA==
X-Gm-Message-State: AFuF++lKwnyJEiS+5cniba5wUHM+JLHJTC0ZdUXPduwuxxosYqajHd5C
	H+OKArt8MKtCoIniiux4ScF1DIeRZSsVOg705xhny6U0EfAqoyH4RVZ/y879UfbQx6VCab+dFwx
	39E4hQMuivflOOEQcNL4JspKmAkNgCSfa7NQS1RbJ0KUZKKLgya9miwHuzIs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:250b:b0:4c3:4e34:c69e with SMTP id
 5614622812f47-4d72892486amr8426494b6e.8.1790434842853; Sat, 26 Sep 2026
 08:00:42 -0700 (PDT)
Date: Sat, 26 Sep 2026 08:00:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab7de1a.e548f532.1ca396.002e.GAE@google.com>
Subject: [moderation/CI] Re: migrate on fault for device pages
From: syzbot ci <syzbot+ci8e1d2d3902f1476b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v15] migrate on fault for device pages
https://lore.kernel.org/all/20260924065313.899730-1-mpenttil@redhat.com
* [PATCH v15 01/11] mm/Kconfig: changes for migrate on fault for device pag=
es
* [PATCH v15 02/11] mm: add helper to convert HMM pfn to migrate pfn
* [PATCH v15 03/11] mm/hmm: preparations for HMM to participate in migratio=
n
* [PATCH v15 04/11] mm/hmm: do the plumbing for HMM to participate in migra=
tion
* [PATCH v15 05/11] mm/hmm: migrate collection in HMM pagewalk - pte level
* [PATCH v15 06/11] mm/hmm: migrate collection in HMM pagewalk - pmd level
* [PATCH v15 07/11] mm/hmm: add lazy MMU mode support for migration in HMM =
pagewalk
* [PATCH v15 08/11] mm/hmm: implement rollback for device page migration in=
 HMM pagewalk
* [PATCH v15 09/11] mm: enable device page migration from HMM pagewalk
* [PATCH v15 10/11] lib/test_hmm: add a new testcase for the migrate on fau=
lt
* [PATCH v15 11/11] Documentation/mm/hmm: document migration through hmm_ra=
nge_fault()

and found the following issue:
kernel panic: Fatal exception

Full report is available here:
https://ci.syzbot.org/series/e83269ed-df96-404f-95bb-3815267ab7b6

***

kernel panic: Fatal exception

tree:      drm-next
URL:       https://gitlab.freedesktop.org/drm/kernel.git
base:      2abe8e7e33973dda5dd24b89aa3ee52470a78265
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/8d10dc50-efeb-4533-8f7a-d7fcf6b5a3b=
3/config
AI triage: https://ci.syzbot.org/findings/cf11d87e-9315-4738-a194-f8ccc16c2=
736/triage_trajectory

FS:  0000555594951500(0000) GS:ffff88818d6c2000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f384eb3aff8 CR3: 0000000171b40000 CR4: 00000000000006f0
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled
Rebooting in 86400 seconds..


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org apopple@nvidia.com balbirs@nvidia.com david@kern=
el.org dri-devel@lists.freedesktop.org intel-xe@lists.freedesktop.org jgg@n=
vidia.com leonro@nvidia.com liam.howlett@oracle.com linux-kernel@vger.kerne=
l.org linux-mm@kvack.org ljs@kernel.org marpagan@redhat.com matthew.brost@i=
ntel.com mhocko@suse.com mpenttil@redhat.com rppt@kernel.org surenb@google.=
com vbabka@suse.cz ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

