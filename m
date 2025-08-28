Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345CB13DDAA
	for <syzbot@lists.linux.dev>; Thu, 28 Aug 2025 06:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756363029; cv=none; b=VLdGnlpmr2rIqiUPafu3D4ZC//4Pk58ob1SLKDQnCj0OtKjXs0n3VHt8VNoujJGD00VVBxiVRcJ8N1EyGbJ4TjhOCdq7EMw3I7VPda0S8jguVs91yjL7rObS1zjEwwAZOPiPKBY539Lrvsr0O1AR+IGO5f6hh7trKG5nC1wxIrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756363029; c=relaxed/simple;
	bh=C8Zt/59AbyDRCXWkhmjatYOD3PfPvdHkfnZtJpR93+g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gjlSBUvRvZ1XOGjS2eSpl5iRc7xdSI+vSHBoFMnwA7KUC7zyhXf90vvnwQaupxXtVIcICeIfaUsZ/V+Jcex0UURunA6+rxdOthJ5MWODD2FQaFRkE24uWrM37C/YPOukIilF0TeiLNg5sNNdwzF8NeZo+HAfhfnYBtNMlHf3eFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3ee1d164774so21965115ab.1
        for <syzbot@lists.linux.dev>; Wed, 27 Aug 2025 23:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756363026; x=1756967826;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xUWEBZvBrtFuZuBhgBjXhKXUDTI8XBqEHBDJkFOQrXI=;
        b=gASlpkEXQvnjnGJcog1lf6YqceHAU75UCS0iSyY6XfE6sMyacRSMyJlp3TrFqUfvYL
         +Uhn1He6T0YtQz09zVUNmTRNzBjdsr/OKLT53DsY6UsWOpVga/YOMSnir+68dzEHm2DV
         n2GyHzJofLZ5D5YXS+gISYYUtU2EvCKMn8TeAIf1hOdC7wUmf0T+60165T6nQgMi7qHH
         huLTBa9yLeLG+f+lAS84PZmJm3/oisTR7ryI9CiGWZVN7RBQ7nE9X4NPW3kp4F+lgoIB
         xLMJpSSo5Uo8RpMmhbGYT/0X1YyJIHBGs2jAPCDu8ZI9tUInBQ9XLWMiYzwqtsAOueGY
         x8XQ==
X-Gm-Message-State: AOJu0YzEDREXXNgqUqhz9V6Ec6fs8i3lesoaRGhvVTYH3szNbI2l6/ig
	GqEQJZFWQLQ1Yty2PTiyj1YVM1k5eRLxp1C+PV+FVbR0s3RcZsPiVPQSw+QzHeNRFPJ8SkJ3wD5
	4IN0yHhF8HVDEVx25FCgcQVnu2pqqJJ/EUp9vJpEIol2UsOCOPCRNB54omwk=
X-Google-Smtp-Source: AGHT+IHQCkqIXNWcuw+YcyD2n7TNzdXQJFPsorkAepduMpKp4dOslU0hw84KezkMe8fu8PZZpn9Z2oveLufxCFe0OcVFC1PTyOJK
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1248:b0:3e6:7ac1:b8bf with SMTP id
 e9e14a558f8ab-3ef08858899mr87028705ab.9.1756363026314; Wed, 27 Aug 2025
 23:37:06 -0700 (PDT)
Date: Wed, 27 Aug 2025 23:37:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68aff912.a00a0220.1337b0.0002.GAE@google.com>
Subject: [moderation/CI] Re: sched: make migrate_enable/migrate_disable inline
From: syzbot ci <syzbot+cief93fb72b20f6026@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] sched: make migrate_enable/migrate_disable inline
https://lore.kernel.org/all/20250828060354.57846-1-menglong.dong@linux.dev
* [PATCH v4 1/3] arch: add the macro COMPILE_OFFSETS to all the asm-offsets=
.c
* [PATCH v4 2/3] sched: make migrate_enable/migrate_disable inline
* [PATCH v4 3/3] sched: fix some typos in include/linux/preempt.h

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/aac2d563-711a-4b4b-89c3-7365b1c03190

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      d3abefe897408718799ae3bd06295b89b870a38e
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp=
1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/bb1748d9-0b48-4894-b30e-ea91020f1c7=
8/config

./include/linux/rcupdate.h:968:3: error: call to undeclared function 'migra=
te_disable'; ISO C99 and later do not support implicit function declaration=
s [-Wimplicit-function-declaration]
./include/linux/rcupdate.h:976:3: error: call to undeclared function 'migra=
te_enable'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
./include/linux/sched.h:2402:20: error: static declaration of 'migrate_disa=
ble' follows non-static declaration
./include/linux/sched.h:2407:20: error: static declaration of 'migrate_enab=
le' follows non-static declaration

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org bsegall@google.com da=
niel@iogearbox.net dietmar.eggemann@arm.com eddyz87@gmail.com haoluo@google=
.com jani.nikula@intel.com john.fastabend@gmail.com jolsa@kernel.org juri.l=
elli@redhat.com kpsingh@kernel.org linux-kernel@vger.kernel.org martin.lau@=
linux.dev menglong.dong@linux.dev mgorman@suse.de mingo@redhat.com peterz@i=
nfradead.org rostedt@goodmis.org sdf@fomichev.me simona.vetter@ffwll.ch son=
g@kernel.org tzimmermann@suse.de vincent.guittot@linaro.org vschneid@redhat=
.com yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

