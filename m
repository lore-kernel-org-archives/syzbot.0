Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5326358B6C7
	for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 18:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789066220; cv=none; b=Pw3yeWEZwinx7hg8pQg0krpEpyY1W++5hse5EVwZu/3ie851AYDNFVYRJlJOXvqvtmSNyC+uOtIg6emQiEdSsOY4TZbcQPrBEoDIQx04AYp1UuO181cebGCq2bLIBdnG5NDKsI3D4cwohh5o8+prmTsuoVb29sm8bvR/PbeeSwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789066220; c=relaxed/simple;
	bh=dBVEB8W6tZrrzQ1Dhkw5kLm50RUEQVJt+KfMhG2rgk8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=C3RUK8PfGuc56P6UGxTGzPe1y3nEEW78rtld6Aai2Twucsmg2OFw99xlbwxKlYuTedl/FSmQwojCKRTKwc5r7iQtrroi6xnCBwb6aCzy2ExsxjnvY+nMwiB0kbTbhP+NlBniES1dcdhH9GMnWnea9qNzNEoMockCLFjchAt/XHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6b12abf0e49so263659eaf.0
        for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 11:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789066217; x=1789671017;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xfzJKTzPXmHPJG/xRhX1DAw1xWaK/xetHZfYC4W4eRY=;
        b=BdR4SeGpHzvpDojkCNTBdTxP9deP30/VaUgM7QqDO0r2CPnIMle9YMugKm7sy/GUEU
         zIZIiLKUzxhfS1I9AshBTD5ekYDALdK5u/H5jwGAPwX4pv8L6ZasyAId7vrFbhAsHFuE
         TTwZckt2nWOFOOVl2NI589MerzwEe2n7T4B5DSpDOQLcZ6IKEAU0QdrIR7o6dMdKCXDk
         lwN95lWwO1dtrrltxgRXbL/9D+GyaMRdvdeBetJ6CQyTr7yftWl2jdqwI1kk9Yx/brzL
         loB0M6NPq5rYdtd84C3oECieGIIupn5l8Lb1Ltw7uPHhQYYuLIMrux/NwhaOShClc5em
         QW3g==
X-Gm-Message-State: AFuF++mR0HwXlUO9zCZIOIhOCQJ1gwb33EfN4WgEtzCVlZd/fjcdvuAU
	3Ekz63JLOhKJi1juIxURRzNwgRdi4waXKz06/GCqjHMHeYRUWLJKodEx4VEBoLl4UeKmGwF6WR/
	doLJ7JgugkWOP7XTVdnK1OP0QFBXe9VkuVK+c2rIoSMaOxblz8ZHQ5MNE56E=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6ae7:b0:6be:4eb3:e1c6 with SMTP id
 006d021491bc7-6c0bbfdf631mr370834eaf.19.1789066217175; Thu, 10 Sep 2026
 11:50:17 -0700 (PDT)
Date: Thu, 10 Sep 2026 11:50:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa2fbe9.f2639fcc.29487d.001a.GAE@google.com>
Subject: [moderation/CI] Re: sched: Add support for long task name
From: syzbot ci <syzbot+cif33cbad46bbf0ec2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v6] sched: Add support for long task name
https://lore.kernel.org/all/20260910-tonyk-long_name-v6-0-d70afbf194c5@igal=
ia.com
* [PATCH v6 1/6] treewide: Get rid of get_task_comm()
* [PATCH v6 2/6] treewide: Replace memcpy(..., current->comm) with copy_tas=
k_comm()
* [PATCH v6 3/6] lib/string_kunit: Add test for copy_task_comm()
* [PATCH v6 4/6] sched: Extend task command name with TASK_COMM_EXT_LEN
* [PATCH v6 5/6] prctl: Add support for long user thread names
* [PATCH v6 6/6] selftests: prctl: Add test for long thread names

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/82558e77-0c89-4bfd-b82d-53143ea6a0d6

***

kernel build error

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      50d05c7c76c96b90462f24debacca971d2e86713
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/4b791023-c565-44b8-8a9b-dc4d3a1b195=
0/config

security/smack/smack_lsm.c:141:2: error: incompatible pointer types initial=
izing 'const char *' with an expression of type 'struct task_struct *' [-Wi=
ncompatible-pointer-types]

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
[akpm@linux-foundation.org andrealmeid@igalia.com andrii.nakryiko@gmail.com=
 arnaldo.melo@gmail.com brauner@kernel.org david.laight.linux@gmail.com jur=
i.lelli@redhat.com kees@kernel.org kernel-dev@igalia.com laoar.shao@gmail.c=
om linux-api@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.or=
g linux-trace-kernel@vger.kernel.org mathieu.desnoyers@efficios.com peterz@=
infradead.org pmladek@suse.com rostedt@goodmis.org shuah@kernel.org torvald=
s@linux-foundation.org vincent.guittot@linaro.org willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

