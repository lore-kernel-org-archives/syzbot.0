Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581199;
	b=TlOvzaUxT7HB4egwLRpwoWAX9Ytr/aaRPZi4a5bmH8jAa1+TfaAM5dOzSiKIUQb7+LPN
	 9ZJUwCxn0aPwJRAoLUt4C5QM4Q3Sxusw+PnFFfnRRvpxu+nhwIEZ13O6xgNT9s2MLUIPf
	 5GLMxfk6xFcG2pNM2tac/huW+o1n0dM3LNeg4OgzH5rmhwoKEz5OjKHNiVnuupBDyG40Q
	 8lVIWrgQyGm4mLdlz3uUdturJl3bwpp3KNgJSe4Hu8pHBFkcC0BKIavAU15jeAvnAkUX8
	 3kxuSIAVfUbBios0t4NSVjp4WcR0rehZQl9H8QxbAr/Dmec9bR+7Cw+/aMl/sZaSYZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581199;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=NB1aq9VnLv/CSz5nKP6XZR1rf1+9Nxa9bOZc6GxaMJA=;
	b=i+UPyfp2msosfwyOS1SESxZsq8BcGirFHvL4rootzUTh+nbmi/X1E9k01snj/54O5WfE
	 BOeg07m+edtX92j0GSWXpp/NA9jxhapj7/YYGyFZPjwdd4vL6TnK6KX4C8/60P8ylkfil
	 jzl1hSlbzCYIn6dlJAuVGc1Af/O9mdYKfOjtRj+V33XFvAGutKjiUFLKINx6Uq7a5lYId
	 2+3NHdfx3QTj1ZPqCJemwv51f0xXIyUZ3Rc9FMIBqPCyakP4YLfgEXXWyWA/eNUZDgyWn
	 6Vs/ERsiG3aVhxKH8QbGD+YlNAxIM0x2Zd4/kXrNvlQcAI2vLAaoAG5uWt3erU/HlIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85618606A324
	for <syzbot@lists.linux.dev>; Mon,  2 Nov 2026 00:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85618606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-540537f959fso3582028b6e.0
        for <syzbot@lists.linux.dev>; Sun, 01 Nov 2026 16:59:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793581197; x=1794185997;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NB1aq9VnLv/CSz5nKP6XZR1rf1+9Nxa9bOZc6GxaMJA=;
        b=o8pwSXhY792VpbxaVQQk1eFSg5NYDzyz90l2qKW2gzFSg2/S28C25kRjVLLrjjbkUi
         sl0keJYsxD0ZKeF9oMQIBuQ5VibotJdp0MYsn2vDx4o1iftPTBZULaZcyvfMylNGbhco
         txyqpHDCY8FL2RECZs/t2JzzZ+8opea7sAe0bY19xIctEo5CJr4wuhU8MhsBcxos6WQT
         lZ7TfGPZr4KzQ8jRcGrrAN0Au1ZZ+x8riVDeWIgHzJr8ZlOrAP4nPFig4laOvtfeXrJM
         Yir5ECVBjFuZlM2zvlGnrrh1vI1x3lA1If73fxTytMidjwNbbzgvz3qU5zN2DLkjACrn
         yDJQ==
X-Gm-Message-State: AFq9FYJ9ZtyyQYI4SXNXJOst5UfqPxmYks9WTMlFkbdliBE0K7ecTLt7
	MFW3ARDplA8UDrST5OkhzHsV3RBN7SyRvJg+6jGhvCDXY8YHtkWdeba1hTqIjU705DLcORTHLq+
	1cWPFsUMuMAHM097kJNDELLM/PgoOXUEwBtquv8nnr73z4ljxEsGO0Y2TA9Q=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fce:b0:4d6:9222:99f7 with SMTP id
 5614622812f47-5640dde6011mr6475755b6e.55.1793581197506; Sun, 01 Nov 2026
 16:59:57 -0800 (PST)
Date: Sun, 01 Nov 2026 16:59:57 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae7e08d.6552420f.2a0efc.00b1.GAE@google.com>
Subject: [moderation/CI] Re: mm/damon: misc improvements/cleanups for core,
 vaddr, sysfs and tests
From: syzbot ci <syzbot+cid6635130a31bd54c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm/damon: misc improvements/cleanups for core, vaddr, sysfs and tests
https://lore.kernel.org/all/20261101171630.81477-1-sj@kernel.org
* [RFC PATCH v2 1/6] mm/damon/vaddr: advance migration attempt in folio level for filter out
* [RFC PATCH v2 2/6] mm/damon/vaddr: use damos->last_applied for migrate action
* [RFC PATCH v2 3/6] mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
* [RFC PATCH v2 4/6] mm/damon/sysfs-schemes: drop redundant and racy zero target_value check
* [RFC PATCH v2 5/6] selftests/damon/damos_apply_interval: remove unused variables
* [RFC PATCH v2 6/6] selftests/damon: remove unused imports of os and sys modules

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/71de7a4b-c1c2-42ca-bb10-eea627deddc0

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      243e8cdab64129d6207c398f8cf5fbb1962ff7e1
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/f7c3cdf7-8d33-4608-b26d-34f4cae5dcfa/config

mm/damon/vaddr.c:870:54: error: use of undeclared identifier 'dests'
mm/damon/vaddr.c:899:54: error: use of undeclared identifier 'dests'

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
[akpm@linux-foundation.org damon@lists.linux.dev linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org linux-mm@kvack.org shuah@kernel.org sj@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

