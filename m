Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D0F343886
	for <syzbot@lists.linux.dev>; Sat,  3 Oct 2026 03:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790999601; cv=none; b=AHMowDrFKXbbB3Nt82xROm8RVauRuRdEyLBTJzyOC7HBU7mDR3vEtQ9GB0ha80XrZoO57lJs437sm5DKM8nEW9tvgeCl4X+kNjoND2KW49s22NByu8iM7b+vjCpjhUI/7C2F160c6jvFIpvClyEc0KaFwjkWRalRVeDNPMBTjw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790999601; c=relaxed/simple;
	bh=xTifg/UWuFbNgw/FeyagbWsECawy6X7MbQSSWVd5A6o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=dogxaquaF9Y/0aWIDnMj8r9EuV6u4Vuy96WoVOSn7lbg2GAWwsMw03p0J160Q365jMMacit6lz0hrUTOtBewhpwjfWwlwV/EemsowudIsxi6tvT90HsRtftZvbY45ZFeQYJcXlHRsWhtxrVoQtRmZTOcAuKsSjZTooa+Dkg9C1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ab4f652f9bso70562b6e.0
        for <syzbot@lists.linux.dev>; Fri, 02 Oct 2026 20:53:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790999598; x=1791604398;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PmG0BQQxn2xoagNlovnoS9AGiuANaNCM1NHLmmxHAtA=;
        b=are85ONfF6JFo7H/37978ehNSkjYZPtvIjbd6qsy42wLIYKRSU4nGJzFjTeRzORxKv
         ZN52FL5RHwPlPdv/gNMl2KXYNMFjLfmJBcaBCFU2Ceh6Sxx1t44KkSB6FjD0Mxo0IxPt
         MAWMVnbUOtrpFBrxBbU0rhVv6cn34PY5By+jF7Ou2kUwzZHkXWSdJ9y961ruoDLZ7/yC
         16Y1TQzgnpW+nu9M8wHmcZxm1wdrLzfrv+mkf+G6HevhkEuz4YE9EdMDaqZ27mcjf45k
         Coo2m1YzfwZ17orRc/yn3m+Vwse84rTOSIm5EqDgljmqQMacYrU2xjULYy7BXC9lxO0T
         aN/Q==
X-Gm-Message-State: AFuF++mz+AEUiLcKzdpOZFAgm26yjAUnnp5YB3A7a+sUFI52+UL8bG7Y
	H+KkhflcvLPGQZoixKbTm/jLOMWMHZvRyyP4Atcq6cnEhRp5R77BFAFyd5GwWuLkLS2KKNT/iC8
	G2mx3j8NkhH9eHxs5xhCRuExfyMqkCkKigD1pJ/9i+r73Oc18roS3qSrZ/0I=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:508c:b0:4b3:7aeb:1b73 with SMTP id
 5614622812f47-4f5264452d0mr4927324b6e.2.1790999598256; Fri, 02 Oct 2026
 20:53:18 -0700 (PDT)
Date: Fri, 02 Oct 2026 20:53:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac07c2e.9ad129c8.3858c0.000d.GAE@google.com>
Subject: [moderation/CI] Re: Landlock: Namespace and capability control
From: syzbot ci <syzbot+ci019fd945e58678e6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] Landlock: Namespace and capability control
https://lore.kernel.org/all/20261002124409.1277970-1-mic@digikod.net
* [PATCH v4 1/8] landlock: Rename quiet_masks to quiet_access
* [PATCH v4 2/8] landlock: Wrap per-layer access masks in struct layer_conf=
ig
* [PATCH v4 3/8] landlock: Enforce namespace use restrictions
* [PATCH v4 4/8] landlock: Enforce capability restrictions
* [PATCH v4 5/8] selftests/landlock: Add namespace restriction tests
* [PATCH v4 6/8] selftests/landlock: Add capability restriction tests
* [PATCH v4 7/8] samples/landlock: Add capability and namespace restriction=
 support
* [PATCH v4 8/8] landlock: Add documentation for capability and namespace r=
estrictions

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/9cc05aa0-d89d-4de4-abda-a3fd563326a9

***

kernel build error

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs=
.git
base:      d238145f73edb59616ec9046fbb5438b2d9145a1
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/14cefb4c-a3a9-4cac-b36f-af801e6f133=
3/config

security/landlock/ns.c:39:60: error: no member named 'ns' in 'union common_=
audit_data::(unnamed at ./include/linux/lsm_audit.h:81:2)'
security/landlock/ns.c:120:23: error: use of undeclared identifier 'LSM_AUD=
IT_DATA_NS'
security/landlock/ns.c:142:16: error: no member named 'namespace_init' in '=
struct lsm_static_calls_table'
security/landlock/ns.c:143:16: error: no member named 'namespace_install' i=
n 'struct lsm_static_calls_table'

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
[brauner@kernel.org corbet@lwn.net danieldurning.work@gmail.com enlightened=
@google.com gnoack@google.com ivanov.mikhail1@huawei-partners.com kernel-te=
am@cloudflare.com lennart@poettering.net linux-fsdevel@vger.kernel.org linu=
x-kernel@vger.kernel.org linux-security-module@vger.kernel.org m@maowtm.org=
 mic@digikod.net nicolas.bouchinet@oss.cyber.gouv.fr paul@paul-moore.com se=
rge@hallyn.com utilityemal77@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

