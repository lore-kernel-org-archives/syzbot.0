Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D038739659E
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 05:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783576313; cv=none; b=U4Cz8dcLxtGIA5JXfJNN/+MVyib8ky73WpxDCoNRRftykkESxs7qgoIugndQl7t9Iq6RUNOqz5OVAtsVRvN3PA3txiGt3eIWLe5X8/JYiEph8YVCCccEgo+8UBd105LUDNh/d8zO7CTSTCMBLSkvv1JZ5AlhoD/eVMwjvo8aJZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783576313; c=relaxed/simple;
	bh=8Q0uA3a6FBUL/axFAIrzxftpF8xhrSE0JYgzr4Uext0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=JjsigH9/sOw6MZqSKDDsSN/t/XBhugGVqFzyxgZjj+cRk+spqhFShJEEAu32xBdlQSFaFOvb6qVKnHXRqJ4P6GPOFG3cYlpPr6SrYHS4BFZbGVeYQtQScaODnU5J3Ske+ZnkZu6KNCDgaPT1DsQspw/Lv4uenZb2ILUkaeKPd+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-495b4a78694so2388200b6e.0
        for <syzbot@lists.linux.dev>; Wed, 08 Jul 2026 22:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783576311; x=1784181111;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6IqMlUlTx9M+0vVUZY+6Rif1csfA/bbH5gy/wUHRNlo=;
        b=h+WXQ6P+myIyojoeVnBiegZ8hDXq1uPjuWbHK+li9TY8DwC3jR2wa/Pez0kOhQvrkH
         QLn/cJL0DqYJr51aGRrSjWzgx5FHktt01UQMH+47N567+HcYyC29NKcXNix5+yLYU10Q
         Usm3y0gsYMFL4SgUFeLcC1I+eRIGSfiljaMQBkL/pv93gYhhwrlef/W2WvWi1e9VVRkM
         5nLEZPL4CFEdCIiqzpf9a2+w68CfQ5ZqxrPuIjymrqQHi0ZNZdcYq/B1uXN5++/dtV5S
         W+IDRRe53n1pv3gckoQjX/RiQMazRGfAGQAbGzl+Z1hev3xP6D0BLxcEMbBo/nzWIH20
         O5qA==
X-Gm-Message-State: AOJu0Yy2POVAGQx3RErg8bQwlf1fKmsNk7ylRSO2SiqFXGa2WR1jLNlY
	ivJKYTDj7lmQ0hTLKbN+DfdobtyMDK1q7xfg4mFf0jHOrTd6/61V2i1HPYDHSY8XUMVFmVQrNK6
	Kh9WI0Alonr2GraBhMNq6NzfAE4ipEiH4HMpxvqMmtGZ4phiCqNx7sYgalyo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c413:b0:492:44c0:6ef8 with SMTP id
 5614622812f47-4a207124e14mr6018907b6e.43.1783576310930; Wed, 08 Jul 2026
 22:51:50 -0700 (PDT)
Date: Wed, 08 Jul 2026 22:51:50 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4f36f6.57639fcc.86d58.001a.GAE@google.com>
Subject: [moderation/CI] Re: Introduce meminspect
From: syzbot ci <syzbot+ci25d62f6c5eac0d59@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] Introduce meminspect
https://lore.kernel.org/all/20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qu=
alcomm.com
* [PATCH v3 01/26] kernel: Introduce meminspect
* [PATCH v3 02/26] init/version: Annotate static information into meminspec=
t
* [PATCH v3 03/26] mm/percpu: Annotate static information into meminspect
* [PATCH v3 04/26] cpu: Annotate static information into meminspect
* [PATCH v3 05/26] genirq/irqdesc: Annotate static information into meminsp=
ect
* [PATCH v3 06/26] timers: Annotate static information into meminspect
* [PATCH v3 07/26] timekeeping: Register tk_data into meminspect
* [PATCH v3 08/26] kernel/fork: Annotate static information into meminspect
* [PATCH v3 09/26] mm/page_alloc: Annotate static information into meminspe=
ct
* [PATCH v3 10/26] mm/show_mem: Annotate static information into meminspect
* [PATCH v3 11/26] mm/swapfile: Annotate static information into meminspect
* [PATCH v3 12/26] kernel/vmcore_info: Register dynamic information into me=
minspect
* [PATCH v3 13/26] kernel/configs: Register dynamic information into memins=
pect
* [PATCH v3 14/26] mm/init-mm: Annotate static information into meminspect
* [PATCH v3 15/26] panic: Annotate static information into meminspect
* [PATCH v3 16/26] kallsyms: Annotate static information into meminspect
* [PATCH v3 17/26] mm/mm_init: Annotate static information into meminspect
* [PATCH v3 18/26] sched/core: Annotate runqueues into meminspect
* [PATCH v3 19/26] mm/numa: Register node data information into meminspect
* [PATCH v3 20/26] mm/sparse: Register information into meminspect
* [PATCH v3 21/26] printk: Register information into meminspect
* [PATCH v3 22/26] remoteproc: qcom: Move minidump data structures into its=
 own header
* [PATCH v3 23/26] soc: qcom: Add minidump backend driver
* [PATCH v3 24/26] soc: qcom: smem: Add minidump platform device
* [PATCH v3 25/26] dt-bindings: reserved-memory: Add Google Kinfo Pixel res=
erved memory
* [PATCH v3 26/26] meminspect: Add debug kinfo compatible driver

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/7c1c745b-0789-4516-aa2c-423182a6da3d

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      302dfbff3e73be2ba5723237c6303244ec27cebb
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/c521c853-b48a-430e-b3d4-94e50203ef8=
e/config

kernel/configs.c:69:2: error: call to undeclared function 'virt_to_phys'; I=
SO C99 and later do not support implicit function declarations [-Wimplicit-=
function-declaration]

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
[akpm@linux-foundation.org aliceryhl@google.com andersson@kernel.org anna-m=
aria@linutronix.de ardb@kernel.org arnd@arndb.de ast@kernel.org atomlin@ato=
mlin.com baohua@kernel.org baoquan.he@linux.dev brauner@kernel.org bsegall@=
google.com chrisl@kernel.org cl@gentwo.org conor@kernel.org corbet@lwn.net =
coxu@redhat.com david@kernel.org dennis@kernel.org devicetree@vger.kernel.o=
rg dianders@chromium.org dietmar.eggemann@arm.com ebiggers@kernel.org ehris=
tev@kernel.org elver@google.com eugen.hristev@linaro.org feng.tang@linux.al=
ibaba.com frederic@kernel.org gary@garyguo.net guohanjun@huawei.com hannes@=
cmpxchg.org jack@suse.cz jackmanb@google.com joel.granados@kernel.org john.=
ogness@linutronix.de jpoimboe@kernel.org jstultz@google.com juri.lelli@redh=
at.com kas@kernel.org kasong@tencent.com kees@kernel.org konradybcio@kernel=
.org kprateek.nayak@amd.com krzk@kernel.org leitao@debian.org liam@infradea=
d.org linux-arch@vger.kernel.org linux-arm-msm@vger.kernel.org linux-doc@vg=
er.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org linux-remotep=
roc@vger.kernel.org ljs@kernel.org mathieu.poirier@linaro.org mgorman@suse.=
de mhocko@suse.com mingo@redhat.com mukesh.ojha@oss.qualcomm.com nphamcs@gm=
ail.com peterz@infradead.org pmladek@suse.com robh@kernel.org rostedt@goodm=
is.org rppt@kernel.org saravanak@kernel.org sboyd@kernel.org senozhatsky@ch=
romium.org shikemeng@huaweicloud.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

