Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1D32BEFFD
	for <syzbot@lists.linux.dev>; Thu, 18 Dec 2025 16:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766074968; cv=none; b=j/bwYHjfczraHGPrhIXLO71QEbGFzjVItMYont7bTHwvqP8rzFLZnB4tSCPv56mncEc+9xy5lbQCxVPX4QE8GACTRAsIfw+8jcOz3G4xp0DjcqLvPIhle9E/iIWGFznXMsAiom9iaYx3O9/osUn0Emt4nPxGI64noNR+4Lnu5zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766074968; c=relaxed/simple;
	bh=DCRFJzipGD1nJ2uxH5TTRDlNen/kNiOxmaO88sFDkUo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=rpeUUYVQLzK1Ue7xfpNp4vctyt3vUMFrJcz9xu2ifmjUAbQj8krP06JbmrkbgIfC4J5p0lTnxpgp8k/HuJJMY6GOLZJEUzZ7bh9UDxSCifObdyzrJDbx5MnLGvGgYqpliDucN2iuQKk1Iy4GitYm+1PNq6lRfjMNDA57GhSdQZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4537c9e1c14so430466b6e.1
        for <syzbot@lists.linux.dev>; Thu, 18 Dec 2025 08:22:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766074965; x=1766679765;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+SMZeAsOgP783n1ZGCX1G7aSnp6TJ0fGu+hL/RhI2o=;
        b=YXfedDZMkXV/0IthrWqnyA8wgHxx2DxuY1EnLEdyFDTBg13R+XjVXzUDseLaoWkCqR
         GBPYpKTON2ulfzTcQaOxoFtyyYEibBs5ATEbAox+rUtWSAPMtKIJ9fdeJ37QBj7OU0Em
         /xe/Rz75jQk7HC5z7/b7AmCpIbTUeFZX0mZoXz9wb/Y8qwsNow8CLs0xiGUec3zie4/E
         iOXMqlH3YjesjD2jeVrfn+1nsFxg4M2iywvdxTxwUd/I9k5AJGShPFzCSiqWRBsi6lAn
         8pfHseAWkPEleGrTvzyc4DOvtQf4obUWXHoDhnLHIuefqAU/fNTNtIucTvKMWW1pEMAs
         PRYw==
X-Gm-Message-State: AOJu0YzNnXIw/bkus4ij/tbOBQoRmzLLrfIbmhPE33m1s6e9p0qWaFti
	guqel4wPWPTvP5UGHO21VmYjYTK99a7PGvV4IQR6mbYSZwIcN9maljnSh9VBdD0/AonFNYucJA/
	S6gTk7TtvCVIIRElpHqf6jRmcMn11eddTTiBahYbw1EQQQXT4Wq6bj/W7xPM=
X-Google-Smtp-Source: AGHT+IH5LpY/6ZdaBJUoOrCs3iKVOJ/Ah6stSA9O5BJhSk9q3JhRt7RSKRLwU2a4vCwi86ysVBGVFnlqOJc0Ojv22+mMgq1prYjF
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:82b:b0:65b:8574:2e84 with SMTP id
 006d021491bc7-65b857435cfmr3278248eaf.84.1766074965160; Thu, 18 Dec 2025
 08:22:45 -0800 (PST)
Date: Thu, 18 Dec 2025 08:22:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69442a55.a70a0220.207337.00e6.GAE@google.com>
Subject: [moderation/CI] Re: mm, hugetlb: implement movable_gigantic_pages sysctl
From: syzbot ci <syzbot+ci49b1eaed80c7d30c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] mm, hugetlb: implement movable_gigantic_pages sysctl
https://lore.kernel.org/all/20251218151211.1237411-1-gourry@gourry.net
* [PATCH v4] mm, hugetlb: implement movable_gigantic_pages sysctl

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d52fdf02-5dcf-4301-a1cf-3f4ef9cfc4fc

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      c642ecda5b136882e518d8303863473c0d21ab2f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2bd0cdd1-8fa9-4367-a9fc-9255e4e05b9=
6/config

mm/hugetlb.c:505:9: error: incomplete definition of type 'struct hugetlb_cg=
roup'
mm/hugetlb.c:506:19: error: incomplete definition of type 'struct hugetlb_c=
group'
mm/hugetlb.c:517:16: error: incomplete definition of type 'struct hugetlb_c=
group'
mm/hugetlb.c:587:39: error: incompatible pointer types passing 'struct huge=
tlb_cgroup *' to parameter of type 'struct hugetlb_cgroup *' [-Werror,-Winc=
ompatible-pointer-types]
mm/hugetlb.c:646:26: error: incompatible pointer types passing 'struct huge=
tlb_cgroup *' to parameter of type 'struct hugetlb_cgroup *' [-Werror,-Winc=
ompatible-pointer-types]
mm/hugetlb.c:659:16: error: incompatible pointer types passing 'struct huge=
tlb_cgroup *' to parameter of type 'struct hugetlb_cgroup *' [-Werror,-Winc=
ompatible-pointer-types]
mm/hugetlb.c:776:45: error: incompatible pointer types passing 'struct huge=
tlb_cgroup *' to parameter of type 'struct hugetlb_cgroup *' [-Werror,-Winc=
ompatible-pointer-types]
mm/hugetlb.c:909:4: error: call to undeclared function 'hugetlb_cgroup_unch=
arge_file_region'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
mm/hugetlb.c:930:4: error: call to undeclared function 'hugetlb_cgroup_unch=
arge_file_region'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
mm/hugetlb.c:938:4: error: call to undeclared function 'hugetlb_cgroup_unch=
arge_file_region'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
mm/hugetlb.c:944:4: error: call to undeclared function 'hugetlb_cgroup_unch=
arge_file_region'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
mm/hugetlb.c:1107:9: error: incomplete definition of type 'struct hugetlb_c=
group'
mm/hugetlb.c:1109:24: error: incomplete definition of type 'struct hugetlb_=
cgroup'
mm/hugetlb.c:1287:3: error: call to undeclared function 'resv_map_put_huget=
lb_cgroup_uncharge_info'; ISO C99 and later do not support implicit functio=
n declarations [-Wimplicit-function-declaration]
mm/hugetlb.c:1479:18: error: call to undeclared function 'hugetlb_cgroup_fr=
om_folio'; ISO C99 and later do not support implicit function declarations =
[-Wimplicit-function-declaration]
mm/hugetlb.c:1480:18: error: call to undeclared function 'hugetlb_cgroup_fr=
om_folio_rsvd'; ISO C99 and later do not support implicit function declarat=
ions [-Wimplicit-function-declaration]
mm/hugetlb.c:1483:6: error: call to undeclared function 'hstate_is_gigantic=
_no_runtime'; ISO C99 and later do not support implicit function declaratio=
ns [-Wimplicit-function-declaration]
mm/hugetlb.c:1545:6: error: call to undeclared function 'hstate_is_gigantic=
_no_runtime'; ISO C99 and later do not support implicit function declaratio=
ns [-Wimplicit-function-declaration]
mm/hugetlb.c:1807:2: error: call to undeclared function 'hugetlb_cgroup_unc=
harge_folio'; ISO C99 and later do not support implicit function declaratio=
ns [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org brauner@kernel.org corbet@lwn.net david@kernel.o=
rg david@redhat.com gourry@gourry.net hannes@cmpxchg.org jack@suse.cz joel.=
granados@kernel.org kernel-team@meta.com laoar.shao@gmail.com liam.howlett@=
oracle.com linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@=
kvack.org lorenzo.stoakes@oracle.com mclapinski@google.com mgorman@suse.de =
mhocko@suse.com muchun.song@linux.dev osalvador@suse.de rientjes@google.com=
 rppt@kernel.org surenb@google.com vbabka@suse.cz]

If the report looks fine to you, reply with:
#syz upstream

