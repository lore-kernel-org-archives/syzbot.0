Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5CB2BDC1B
	for <syzbot@lists.linux.dev>; Wed,  3 Dec 2025 07:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764747253; cv=none; b=qU5yLpCFajkERMgql6Y2ASdK1G7XAeopqjvWThFvf4+2dbZyzpBkzh5ojVgKo4guCytdQmLnONFNKrv164A9vWHAqf61MU8mHosBac/3Os1J5U+oGpJryJZ+cz5opmZIWbBFluwV45+MLJJp9pkUyqIjHs/4NppL+L0fC3y09cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764747253; c=relaxed/simple;
	bh=jfjzvozGJjmEfwJ+ICRarMskBpsHAW1DqMQGM2d8mLg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=c7yYOBudHFJ5+CFUHeydsljQK3ZVCMvZIX7iKUpP1fc71WbbYhXliQ8LYPPmSij578yymaL0sOv5W6GLnak3O95t1zdccwk5ftbDc7E+VAxcbVDFHnoBNmSa5XpQ57zq1XhFfWM3MPhb/uq9eV/QokvOpxuY3WabAl639RzQ6dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-453565f0ef0so2977714b6e.1
        for <syzbot@lists.linux.dev>; Tue, 02 Dec 2025 23:34:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764747249; x=1765352049;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RCkI9znBr494DnIIRKNG3VrRvVSyPN9a6x5z0t/trV4=;
        b=sQ4OQ63t2Cl8ao3+WszS1faqFZLMjSaAKzqxagy4UJ/dqX7MG2XYQZOOVT3Tj5TTqQ
         +VauUzOUZRHlzbDOiK+LQQaEOGLqgEhVEwxnVTor4dSdo7Jr0Tc+OCOhUbkFRoDbEryD
         88PLtdKbdljaOGEe08nLq3R+nSNG7rkKPzRXNHnyMQUDIha9WywP/8XqLuD/luzfv6TR
         FVBzaG0V8xxD7JqcRvp6pSDAYyBsvYKp+IhFyuuQAA+TVrdh/wJf2epA//VyccXd38NY
         PpvOW7KWWXCD2vNkgBV8ULgIkf/LZsyUmxRdWlxRQ/USmHVMrjHLsOJlqm20xpcaGqPm
         /gmw==
X-Gm-Message-State: AOJu0YxF7W9aXyAsmWSaJ/0VX78HsNRrCGIhSpUgTL/9/NM4DZllvD5h
	cMqrFYSvSt7dKE/DQyKi11O8GTJeSWSl5LAolDsDvKBSJabpqcUIB30t1yqbwoJ8x2CpEBCiBEK
	1keNkSyBPU0M6HZnc9TuYU72vqyAVpW3PCw513rDphMDO9+4L/146g4n/gao=
X-Google-Smtp-Source: AGHT+IH14BZ0/4newnLrVkBls7aWim1PcH1NjDnYr2PDOJtOKG3NGLe2JeYil2B0xMS+eRlAdzcTdIubilX3yQkTEkRe9nIt0sLC
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:a608:20b0:450:f3e4:eb02 with SMTP id
 5614622812f47-4536e5eb7eemr460629b6e.63.1764747248994; Tue, 02 Dec 2025
 23:34:08 -0800 (PST)
Date: Tue, 02 Dec 2025 23:34:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692fe7f0.a70a0220.2ea503.00ce.GAE@google.com>
Subject: [moderation/CI] Re: mm, hugetlb: implement movable_gigantic_pages sysctl
From: syzbot ci <syzbot+cib059e4db694a9a62@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] mm, hugetlb: implement movable_gigantic_pages sysctl
https://lore.kernel.org/all/20251203063836.187016-1-gourry@gourry.net
* [PATCH v3] mm, hugetlb: implement movable_gigantic_pages sysctl

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/5bce48e5-d70e-4ec1-9666-1f14392595e8

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      2178727587e1eaa930b8266377119ed6043067df
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b4b9db59-1680-4276-95d5-480b673d064=
7/config

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

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[00moses.alexander00@gmail.com akpm@linux-foundation.org corbet@lwn.net dav=
id@kernel.org david@redhat.com gourry@gourry.net kernel-team@meta.com liam.=
howlett@oracle.com linux-doc@vger.kernel.org linux-kernel@vger.kernel.org l=
inux-mm@kvack.org lorenzo.stoakes@oracle.com mgorman@suse.de mhocko@suse.co=
m muchun.song@linux.dev osalvador@suse.de rientjes@google.com rppt@kernel.o=
rg surenb@google.com vbabka@suse.cz]

If the report looks fine to you, reply with:
#syz upstream

