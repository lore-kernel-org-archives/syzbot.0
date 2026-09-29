Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D113E5EEA
	for <syzbot@lists.linux.dev>; Tue, 29 Sep 2026 15:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790697317; cv=none; b=ThHp/sGAkndmzxG4IJ4UcePat9zTgBIxOux27mpxnXjtCDtFaUigdrpmUkqxiAuvSqV5SPM6FO7FQUlkkEh1H7wrv/uTy28Q2uu5182awToKcyF7/synXOq02SMTq4WNUmyMIHTIoalQx8wfKPt76XZm96Se8zF7JeAXmm4Zp4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790697317; c=relaxed/simple;
	bh=X6N0LZu1+Aai4nuyKKIHDsKV1WugwgObY8vCtITAizs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gw6L5eIsNs9CLcOBhvlJBMWDfYroDwoSESDg7j6NcTFu61IP+RkglFeycBIf4cYFsoR5ETYX8t3eXVs2NK2cISjgbvZF1n3OlgSVpjTTvbcG8XwRcKq3cCxfSZO+JnJQKzV2F7yYQSH+w6Qg5tI8GPL7ZAqpWjfydIWhxzpCv2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b597558c4cso7334194b6e.1
        for <syzbot@lists.linux.dev>; Tue, 29 Sep 2026 08:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790697315; x=1791302115;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qk6BYAKiIlEgQiEHRoZIvb6PeqX9PGTBiDulezV07WM=;
        b=hN1nnRDV/NlOXvhqosNIjW0eJqGo5z2091McGaaEm0gwqXzgIyaDCWfUamzQYQXyYy
         QMy4msrYN53aePz2GdO5s+cIJQ65cC8zSnExGq2LwRJ2ZZZqg1scrBXyDLaROZSy3y/x
         wthnBxioHRghvWH48raNDo9Ij8dYKkoBWe4xw0PSxU4BWfezCxQtHOJ/VGdBEX/XwGUg
         80p9DRnFYU9szPD10cY0PdFAu2J6IafXBSXBGPJk6f9/NZHx4jWF7VTVMW21EcAO/YOH
         vLDo5aCkL8kAWP/gkcZ7It8ae5VJgh1/rZ7TR2tbVz9TAg46nAIJqSnDRjb7IxIb2b8f
         C49A==
X-Gm-Message-State: AFuF++lcvkcMKNBf+HVC+7ZTN+4s33QfzVCV3E/IUHcotxLJaW7at7PI
	eCiihJt5gYmtqGmdg/ZD8xe8UCEdmZ7XqN9/KVQLORX8sAsz8bLReYY4dzmGDKJoDLi2r4CtCKS
	uyNMP1nO+kH5mhsXVsMjOtFy2BOeVuZGeFI6QL/VzLxuO75E0ggRsjLi7lrI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6f94:b0:4cb:818f:d56f with SMTP id
 5614622812f47-4d7293204f4mr18217097b6e.23.1790697314758; Tue, 29 Sep 2026
 08:55:14 -0700 (PDT)
Date: Tue, 29 Sep 2026 08:55:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abbdf62.64639fcc.9812d.0006.GAE@google.com>
Subject: [moderation/CI] Re: hsr: Add additional info to send/ receive skbs
From: syzbot ci <syzbot+ci3d4ed50867fca5f4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v7] hsr: Add additional info to send/ receive skbs
https://lore.kernel.org/all/20260928-hsr_ptp-v7-0-d55d304d9a7e@linutronix.d=
e
* [PATCH net-next v7 1/8] hsr: Add header_ops::parse_protocol
* [PATCH net-next v7 2/8] hsr: Use skb_clone() while adding the HSR header
* [PATCH net-next v7 3/8] hsr: Add a magic header for sending PTP packets
* [PATCH net-next v7 4/8] hsr: Drop received PTP packets
* [PATCH net-next v7 5/8] hsr: Use the port and header information in hsr_f=
orward_skb()
* [PATCH net-next v7 6/8] hsr: Assign a socket for cloned skbs
* [PATCH net-next v7 7/8] hsr: Move struct hsr_ethhdr to a global header
* [PATCH net-next v7 8/8] selftests: hsr: Add test for the inline PTP heade=
r on HSR

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/49195b5c-63d1-47db-a41e-70e392d93ff4

***

kernel build error

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/l=
inux.git
base:      72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/b2ca0665-6838-493e-9938-989fa2b2a25=
f/config

./include/linux/if_hsr.h:43:16: error: field has incomplete type 'struct et=
hhdr'

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
[andrew@lunn.ch bigeasy@linutronix.de c-vankar@ti.com d-qiu@ti.com danishan=
war@ti.com davem@davemloft.net edumazet@google.com fmaurer@redhat.com horms=
@kernel.org j-rameshbabu@ti.com kuba@kernel.org neelima@ti.com netdev@vger.=
kernel.org pabeni@redhat.com praneeth@ti.com pratheesh@ti.com richardcochra=
n@gmail.com vigneshr@ti.com willemdebruijn.kernel@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

