Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795628635;
	b=LHEmZdlaTZE/2MncXfFW9txq4W0CxJ0RzEfns5D2ZAkcUrte8VxgiiRRfDVCAXCppguF
	 Xep10N3hXeCftRFfHMnsB/JAcUYEhSriiFX2D7I3+DP65twPWFQoKazK8iAmDP7pXuh0k
	 w7+JOA6+dP5LMDzPx57r5dJyyBWoU7Znw8O08OFK22diY6E2XbyoMyO2n2HgIPhgk0rEK
	 yoNcYDAxem18FtrNlgMV2B/Z6FY7dwG0bGq7wJ6J4POMa90Y42MJ6uePsFlUHbx9qmvxq
	 SPHkWi2FRpCwy9eScng1/UPFWU3f9A4bB7lPHXayK4hpTYaD4mDwWaxWmkeiDjYraVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795628635;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Jn8qgGiybEsswviapbQrOqkcvIudsmceJBCsEGH6ZCk=;
	b=47pgPfoaRaETsj5WwRiwHm8xPb2l5Pwb1fYfglu6bjze4WKfQAZF02RgThKnB/bl8/YH
	 WoPxkV57zm6OOD+E4QboKC9T14p6YFxS/wro155QledzOYpybp7Iw8SQQ0DNItWQV2CQu
	 DZwREJO1/hRzdytvIhq0/SqrMmatxjCcY7jlShFzGjJ5VBLo1bZufSVbtBrxWJOvBrtAa
	 0gWRik6JQLTQwdsdcCdGWDIFmCU5AXVagtHspDfyZBvNioos3+Sozu17ToaVlqyGsWuhp
	 2SourG0Ta9VWlYDg9GciAOPZELfyF5d1o9/wPXzL7TmnmeclqSn+g+D7iDPqzexsh0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.71
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C6606A31E
	for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 17:43:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA7C6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-862a2ece202so6737664a34.2
        for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 09:43:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795628633; x=1796233433;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jn8qgGiybEsswviapbQrOqkcvIudsmceJBCsEGH6ZCk=;
        b=DZpcVj5JgcjlfK7ly/jUizMRxoj/zy1Kz2ziMtScnx4XORVQeZvEC+Q5UB2Vsh3gKd
         rxFG8xdWVcDyP435aGwpP0mFNM3ROpT9WtEP+P+e2SfBsXKzklBxm88qVgCdUU7M1jDD
         B+rOtkyR7x6WE2NBigyLfW3rtXbAz1UIpbNPFMqSTK+QUxOIgxISM3aMy1lcuZ7XO4ff
         WkwfOV+syDONm56ad8BiYxdom+sGyHKqFX+8QZsYGVhCpfVusNB5JAMyyjv+mx0IPQJm
         ZV78hZgN9GUf7SSBo2CWMDL6uqsOogIyXB3WVkHqYMWONDpBdyJGX6+NVkseDJ4qYuLf
         z+RA==
X-Gm-Message-State: APuU4Z/9gdRlKrp66QEEpskYQNUbqjqp2LuWC2VMymePk2hblG28TNfl
	F+Z0UP6BDMXIGNUYab8fOEdsgoOB/Y2NFq12i5RGMpigdf4CTbL/0SouAY8LgQiuUy7nRTdEorW
	9T5oeXLxp6JjzDNIhOVUHAhbUI95IK0loeetKF1D3LiRsJf5FSQ9Hd262TP0=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:50a7:b0:573:8745:a983 with SMTP id
 5614622812f47-57a0a937f38mr20780564b6e.27.1795628633664; Wed, 25 Nov 2026
 09:43:53 -0800 (PST)
Date: Wed, 25 Nov 2026 09:43:53 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b071e59.2c88765f.302d8a.0001.GAE@google.com>
Subject: [moderation/CI] Re: fs-verity support for XFS with post EOF merkle tree
From: syzbot ci <syzbot+ciaac46f797c177517@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v19] fs-verity support for XFS with post EOF merkle tree
https://lore.kernel.org/all/20261120155752.192025-1-aalbersh@kernel.org
* [PATCH v19 01/15] xfs: introduce fsverity on-disk changes
* [PATCH v19 02/15] xfs: don't allow to enable DAX on fs-verity sealed inode
* [PATCH v19 03/15] xfs: disable direct read path for fs-verity files
* [PATCH v19 04/15] xfs: don't report dio_mem_align and dio_offset_align for fsverity files
* [PATCH v19 05/15] xfs: handle fsverity I/O in write/read path
* [PATCH v19 06/15] xfs: use read ioend for fsverity data verification
* [PATCH v19 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()
* [PATCH v19 08/15] xfs: don't remove written extents past EOF on fsverity inodes
* [PATCH v19 09/15] xfs: add fs-verity support
* [PATCH v19 10/15] xfs: initialize fs-verity on file open
* [PATCH v19 11/15] xfs: add fs-verity ioctls
* [PATCH v19 12/15] xfs: advertise fs-verity being available on filesystem
* [PATCH v19 13/15] xfs: check and repair the verity inode flag state
* [PATCH v19 14/15] xfs: introduce health state for corrupted fsverity metadata
* [PATCH v19 15/15] xfs: enable ro-compat fs-verity flag

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/51a6871f-fdc9-46b1-ada5-73423dad3e3e

***

kernel build error

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      631b746a8f3ed90c2518f52e228d910f658ad2d5
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/218f3c3e-ac5f-4046-b4cf-14571d02da93/config

fs/xfs/xfs_bmap_util.c:564:6: error: call to undeclared function 'fsverity_is_building'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/xfs/xfs_bmap_util.c:595:18: error: call to undeclared function 'fsverity_is_building'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/xfs/xfs_icache.c:1269:6: error: call to undeclared function 'fsverity_is_building'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/xfs/xfs_ioctl.c:571:7: error: call to undeclared function 'fsverity_is_building'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/xfs/xfs_ioctl.c:594:6: error: call to undeclared function 'fsverity_is_building'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/xfs/xfs_iomap.c:65:10: error: call to undeclared function 'fsverity_is_building'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aalbersh@kernel.org aalbersh@redhat.com cem@kernel.org david@fromorbit.com djwong@kernel.org ebiggers@kernel.org fsverity@lists.linux.dev hch@lst.de linux-fsdevel@vger.kernel.org linux-xfs@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

