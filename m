Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303893988EA
	for <syzbot@lists.linux.dev>; Wed, 25 Mar 2026 10:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774434309; cv=none; b=LHv6qQY/tUNJ3w4ph0yCeDjNPvMcbBDkr+Y3688OaaL5elSLOjVIstMq0aB6Wgo/i7Ifw/56+p0SXOrorkAEfetASrTpI1b6iGLRregaQv7F/qnyFr7RhyvV+sMDtGLEZjTNb01rIFWPvU6RGaDA3l7+OgJ5sF0CsLQpeUGmDv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774434309; c=relaxed/simple;
	bh=2Yw1/0qq2ZX0Dk8BT+LH0lRvPRjj7AYRhSzwvM3xlt0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=VM3vqbJkgcjvO5+EH2dByG3E0wzY9u10zdPd+QlA9blICiHviZOg29ObYEYadlAFXwfr/LlxJejPK4SF0rl+fneI3hg/BGK9gBbL1rTuWzxiKxw+8C8c5dAz6fpmk57g4L+Fqpj2l0JbhVaIkPt/9AjFxVDkjyKhIieA8jrbrbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-40ef793e45eso21175879fac.3
        for <syzbot@lists.linux.dev>; Wed, 25 Mar 2026 03:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774434307; x=1775039107;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LqcQO+kP9f1PMJwlf854xLq3KBgI3FRSXYwybF1ft2w=;
        b=Ffr40EG0BNOMSe+hcBnpjFYIjH+WeFrJzfj7O9bm/2fnIYAZw6WsmRo3/95vBxToMi
         Hb3NOn4BSOuJM9GmV5yyiD3CO5T4QGhH8j+1+s1D6TBTqwN4AUtrvHolkGoZ4NUyYhiq
         +TeMxNdPwnMkHJdCPvnNBR+nQNB0s/BszvCO65jYJ+eUR+MH+nB33D8ud9VMjsgqgR9e
         LhqPEGydDY999cvQZIDrg7ZT2td4SY5XIY9/DhCxq37k3tjPou6q1WIWpnyerQ56N15l
         9+2jJkFBb4+WqRi2sYQ35bAEfP3GcARdRRZMHlxteDlxhZPhcpnhvTU51A1UfrMSSqgu
         FOIg==
X-Gm-Message-State: AOJu0YztN3M/z7OaAgyi+LzKm8zGwG1R9U38BF+A52st8hf9J0Q5dZQD
	U+bZxFQ30f3k27r12l5JUpktl4p0ocjA1EAL5mHYXA0ITUqWmLOC6tRoxrbGId13sO0Z2OioMKa
	grixxcamSTo1DwdTEFya8gS3Lci5u00Q8+IuTXmnS2W2i1x1uj7E2ioI8pk4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1625:b0:67b:d91e:55 with SMTP id
 006d021491bc7-67dff4672fdmr1445987eaf.7.1774434307045; Wed, 25 Mar 2026
 03:25:07 -0700 (PDT)
Date: Wed, 25 Mar 2026 03:25:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c3b803.050a0220.abc16.0014.GAE@google.com>
Subject: [moderation/CI] Re: Implementation of Dynamic Housekeeping & Enhanced
 Isolation (DHEI)
From: syzbot ci <syzbot+ci0db69c802d6f7a0e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Implementation of Dynamic Housekeeping & Enhanced Isolation (DHEI)
https://lore.kernel.org/all/20260325-dhei-v12-final-v1-0-919cca23cadf@gmail=
.com
* [PATCH 01/15] sched/isolation: Support dynamic allocation for housekeepin=
g masks
* [PATCH 02/15] sched/isolation: Introduce housekeeping notifier infrastruc=
ture
* [PATCH 03/15] sched/isolation: Separate housekeeping types in enum hk_typ=
e
* [PATCH 04/15] genirq: Support dynamic migration for managed interrupts
* [PATCH 05/15] rcu: Support runtime NOCB initialization and dynamic offloa=
ding
* [PATCH 06/15] sched/core: Dynamically update scheduler domain housekeepin=
g mask
* [PATCH 07/15] watchdog: Allow runtime toggle of lockup detector affinity
* [PATCH 08/15] workqueue: Support dynamic housekeeping mask updates
* [PATCH 09/15] mm/compaction: Support dynamic housekeeping mask updates fo=
r kcompactd
* [PATCH 10/15] tick/nohz: Transition to dynamic full dynticks state manage=
ment
* [PATCH 11/15] sched/isolation: Implement SMT-aware isolation and safety g=
uards
* [PATCH 12/15] sched/isolation: Bridge boot-time parameters with dynamic i=
solation
* [PATCH 13/15] sched/isolation: Implement sysfs interface for dynamic hous=
ekeeping
* [PATCH 14/15] Documentation: isolation: Document DHEI sysfs interfaces
* [PATCH 15/15] selftests: dhei: Add functional tests for dynamic housekeep=
ing

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/bb8ddd2b-bd3f-479b-b34e-c924fd9f53e8

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      63804fed149a6750ffd28610c5c1c98cce6bd377
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/968f9f5e-f0b1-4c6c-b75e-2dab0088f9e=
5/config

kernel/rcu/tree_nocb.h:1706:13: error: redefinition of 'rcu_spawn_cpu_nocb_=
kthread'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org anna-maria@linutronix.de boqun.feng@gmail.com bs=
egall@google.com dietmar.eggemann@arm.com frederic@kernel.org hannes@cmpxch=
g.org jackmanb@google.com jiangshanlai@gmail.com joelagnelf@nvidia.com josh=
@joshtriplett.org juri.lelli@redhat.com linux-kernel@vger.kernel.org linux-=
kselftest@vger.kernel.org linux-mm@kvack.org mathieu.desnoyers@efficios.com=
 mgorman@suse.de mhocko@suse.com mingo@kernel.org mingo@redhat.com neeraj.u=
padhyay@kernel.org paulmck@kernel.org peterz@infradead.org qiang.zhang@linu=
x.dev rcu@vger.kernel.org realwujing@gmail.com rostedt@goodmis.org shuah@ke=
rnel.org surenb@google.com tglx@kernel.org tj@kernel.org urezki@gmail.com v=
babka@suse.cz vincent.guittot@linaro.org vschneid@redhat.com ziy@nvidia.com=
]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

