Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D068732B13C
	for <syzbot@lists.linux.dev>; Fri, 17 Jul 2026 21:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784323157; cv=none; b=t8LypozTHYcX35mYy5izCNc+dzAb4rvCsNqvV2C25nc/czKOTGXo8HUEjLunSGes3zi64Ue+1WOFMvhLZwWfjMbBHlyZeNPP2bdhijTVr6ZMW2ChUjNhFUee75piUcA1epHHkiQ3VAW92k8QV/XXfBOzWy/GTOdFH4ZJNX6oEoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784323157; c=relaxed/simple;
	bh=c3NNcbkOXk7bOrg5ThxdjSILMnAniXcuAGj9L58JhoM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=MtZbkiiPlHiEvDHepOelNLl0S3cRicdQP7GU87+7+HJF8ntrZ0O4fr43Pblk6ltiXKa6Pw1JTwYsHXTOJgpcZ46e+f/6FzT4PMsvS0AUHWiZ6NoNgQqr35n0tuT664jcs0ND0jWA8jVlVgRjIt87GeneUr8aztXDxdPy2mwcE/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4a441e90050so2358684b6e.1
        for <syzbot@lists.linux.dev>; Fri, 17 Jul 2026 14:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784323154; x=1784927954;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xzilv4elfYJ3hfUSs7Fd+4n7s1BYeXhRYxifHzjScGU=;
        b=JzyOmZ19Baa0tzNaVffSgVJjXaiphFEy6GD3VdR1WiZkZXiJVcd2ewSF3ia8oh33VO
         KDaXQZSEkxubOL2e3MQu+W7m/42doOrevscbxxKVgtPhbgTQ7ahCnHoYiM5gb4iEP8p5
         /+2iM59MYJs2ZMRDJi2aUTnB/lLsuT+5BWtbrbeQ90E4oP/hLLMK/ws97XGxozHBpu4o
         VUmcaern1kFyJPGRgNRx2I3uAY6MAmqIcNxjXrrsf1XFxcVav21BxQeQMLfcHCzUVep0
         tk6Jlc/oBz6/3AqXtz6Mm4pwQsREXfzGxrPNjwpelwHDuSzozQU0Zm3tg0qZ6hEuSnKJ
         p70g==
X-Gm-Message-State: AOJu0YyrUuFNljP2Fdcd9zBUzHaBenrPjiOKV6DIadf8KXZzaLF/l9XN
	ZQp1WE5H0HS3JoUhGj01DELxEcJOikYvyUe/nVfFfPVleNNCUIfxnu1L5rs03t+YnXibgly7ogK
	dAdXy6hoENZI84K9q2Anwl39U0WetzhYKxjJDocavueS3EOLu13AEihU8iuo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3097:b0:495:ca1b:7865 with SMTP id
 5614622812f47-4a4b20ec763mr6131290b6e.11.1784323154728; Fri, 17 Jul 2026
 14:19:14 -0700 (PDT)
Date: Fri, 17 Jul 2026 14:19:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5a9c52.f1649fcc.2a4208.0253.GAE@google.com>
Subject: [moderation/CI] Re: mm: introduce __ptent sparse attribute
From: syzbot ci <syzbot+cic1dcc0d9b21712a7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: introduce __ptent sparse attribute
https://lore.kernel.org/all/cover.1784292223.git.agordeev@linux.ibm.com
* [RFC PATCH 1/4] mm: use proper PTE accessors in madvise() and mremap()
* [RFC PATCH 2/4] mm: introduce ptep_get_nopgtable() and set_pte_nopgtable(=
) accessors
* [RFC PATCH 3/4] mm: introduce __ptent sparse attribute
* [RFC PATCH 4/4] s390/mm: implement __ptent-aware pte_t type

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/62b04622-8836-4d29-9a8a-0f9a1110d500

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      c3330b3115e013ea8160338e5d8b32a1fff26173
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/938e6a38-5507-4c5c-a6db-514b6c9a59e=
1/config

./include/linux/pgtable.h:500:38: error: call to undeclared function 'PageT=
able'; ISO C99 and later do not support implicit function declarations [-Wi=
mplicit-function-declaration]
./include/linux/pgtable.h:512:38: error: call to undeclared function 'PageT=
able'; ISO C99 and later do not support implicit function declarations [-Wi=
mplicit-function-declaration]

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
[agordeev@linux.ibm.com borntraeger@linux.ibm.com david@redhat.com gerald.s=
chaefer@linux.ibm.com hca@linux.ibm.com imbrenda@linux.ibm.com kevin.brodsk=
y@arm.com linux-kernel@vger.kernel.org linux-mm@kvack.org linux-s390@vger.k=
ernel.org linux-sparse@vger.kernel.org sparse@chrisli.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

