Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD69B3F20ED
	for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188030; cv=none; b=qX/FXkNsoIiGJnYv8wbhpg3ubm638//JhV9+l3YajcFH6cgOjuqmiG0GQgHwVUYUQzz0tSzj5iWFBBnwF+2vdEYpJJ291UYf2AVRl8GpXBN482yc0HsnEILqnVZnD0A3i8DeDjIp2bMO3CWPnoEA6oBA/gGhTk2STkofJMmZV10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188030; c=relaxed/simple;
	bh=vIKW4ZyyGcJCcpnwTQE6MYp/eNDUE7M5DYSo6grT0u4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=OSZRoKK3+1hLvIvUeCd4vetNXi/7RoLfKteGCinAMtkhnTTT76ooVFR3JcdktiCg7KwTdrjSprdOvTe3FL2Btrwhjbuzu9swx9clRiLqw7ycrZ6098PoMv5PX6cCms3OmWAr4alrn3zs1Mb7pHacmqvkNk+LCy/PXqacJugIPEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-81120824498so240534a34.0
        for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 11:27:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790188027; x=1790792827;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZVFW88t8tm8IkxioqXPHEVSOKyIy/da8bCmhRQzD2TY=;
        b=ip7XCwDEm6AFAzKpg8Hc4nwlZjqKkMOGUOew/oEy3DMkYLQY17ocEOJpRCdinof9zf
         ZJrkw2o+7xXW4pRn5Sptm5y2UNRXpmBahMlj8EkDHdQCuxqqQswEcOEJoB+iE+1EPAW0
         D0FDCtRrGd9FNpWQLdvjxlfkZGZe2EXLTbDeaPFnPipVpwfaAxpjMkL27GhpA8VqSG7d
         DmDC3i1frUjyGn2fPL7iAQ9B7sDi7j3Psgg3dcS0kqSsgua8KWLWTcIFeFJdHvcDR/88
         BYSupYJ2N3CwCXGNtSa1tffpF9EYaC2DSKmNLXFlUWFlm2OxdOiDFnXLi3KkQXUILlmG
         zUMw==
X-Gm-Message-State: AFuF++nlyof9nhu6sUSp55PoOTlHbBV6lYcDLIV17QRfE05ZJGaQ7YDM
	Q7P1CfuKa/opId218RSLcVogJDBnjEEZcbtCDd/vqh2oX4bEWt4iKlkPnBPFteIQVAiQFWNchuy
	9CD3BGSHnU0KI73P5S4XajE+Y+RjuLc4w7M+4U4D8yHupBEGPro6O2JGHkH0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:a0e:b0:6be:49c2:7be9 with SMTP id
 006d021491bc7-6d43eedd866mr71435eaf.5.1790188027603; Wed, 23 Sep 2026
 11:27:07 -0700 (PDT)
Date: Wed, 23 Sep 2026 11:27:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab419fb.71f81b7d.15fa6d.0051.GAE@google.com>
Subject: [moderation/CI] Re: Type2 multipf support
From: syzbot ci <syzbot+ciabc64b91bcf1d980@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Type2 multipf support
https://lore.kernel.org/all/20260921191239.4249-1-alucerop@amd.com
* [PATCH v1 1/4] driver core: Rely on supplier driver binding at link creation
* [PATCH v1 2/4] cxl/region: Add region reference in memdev attach
* [PATCH v1 3/4] cxl/memdev: Add support for multi PF devices
* [PATCH v1 4/4] sfc: add multipf support

and found the following issue:
WARNING: synchronous SCSI scan failed without making any progress, switching to async

Full report is available here:
https://ci.syzbot.org/series/cce74032-73a7-4071-a29e-65a7ec02c350

***

WARNING: synchronous SCSI scan failed without making any progress, switching to async

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      93f51579e7df248780214094418f205253383cc5
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/50697200-bc23-49c1-b943-c9c91049cf06/config

ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: Failed to create link to scsi device 0:0:0:0
scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
ata1: WARNING: synchronous SCSI scan failed without making any progress, switching to async


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
[alucerop@amd.com davem@davemloft.net ecree.xilinx@gmail.com edumazet@google.com icheng@nvidia.com kuba@kernel.org linux-cxl@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com rafael@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

