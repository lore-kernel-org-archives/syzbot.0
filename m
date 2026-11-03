Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793687261;
	b=Sb8kTcSaSCQ/qt2+3Wqc698FNl1xj81Sj+tfosGPxopLQCyMoya+ix8y+DVWSG9D2m3R
	 z+9OZZ2Keu3yGUVarF/gCcWSRMLCGRR3r8QSPWv/1trgn1aeMhjoPhMei/dC6dY2n4M+9
	 r8MBualHSbnic4PldDx+i7AwGOpeBWcf2wy4enB7VMGl4+d3pzw/HncKSE91tg13q6Nr1
	 EEY+R57431ZFhCA7d3KrszrK8DfWH+G00Iq52ccK2OILGVeQ/P590hhagqQoOT9t7S7qo
	 Qtr4vGG8vibgQXshBM09MR9xuQMJKWJAM7q5t6eYGODDYCaQaD9kEv7qHCHAmgHj5KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793687261;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=LV8/pxDuYDb3LiVfHb8BljkylG6lMtzHQWanEAuiuQc=;
	b=vsHSNAeASQe8x46TlEOz2SDdiRlTasPRTIpMuQ9v0qMVHuWMs97YGz/OxuyB0SCZRVqK
	 aAVN3zUC245UtCvRl4FL6FmpENSHGLDzMKfx8uP6L3TbvN+OGQm/wIwidY0thWkNH2VSD
	 Gi5AGVVZ8+aKZlF2leR6GICg8kzv9NGo7hXeE7TaZi1dRViA+pyBryDvmoBLvkQOnlU+R
	 I/kjUPL+fcBbS9Mmxu/wwkHNh5imuCp6pSLL8nSVuBps+iOdz7hjjGXCDu2ljaItMkBce
	 4XjsQJs0RO1l35/xW7a3iQKRNUIQNQgwVWEvwV470ZXbvbDaDydKapSJXPN4LfJqdFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CA4606A324
	for <syzbot@lists.linux.dev>; Tue,  3 Nov 2026 06:27:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7CA4606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4f2040e10d8so3034480b6e.3
        for <syzbot@lists.linux.dev>; Mon, 02 Nov 2026 22:27:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793687260; x=1794292060;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LV8/pxDuYDb3LiVfHb8BljkylG6lMtzHQWanEAuiuQc=;
        b=yVL/6WoEPvo4cMKOj4KS2E4Skz3G4tsFBGEdP3G2Lp4FAtpqQQDxF0GAEloBZ1YtLY
         NnVQp2aZ6ILHf/b9j5pQQlohkldJh7oOuSf7WDdQRmMafV5GO9J7DHxr3dVD7cEd00XC
         agP6Pqq4RoRW0VkNc2DP5ysUlAo+1f51N/TfEWtCX90suZ95TJCQhCwL9XpaDC8cUrjO
         FWawSDdRnXEJT/hHgv6snLWyuqKrHZfN0iwVl+IqG/hngJGuc6HYuY5Y9wZJ9ObYh3aE
         3iTziaBtCPZD8iys+htfDeoQ/MK5PCshHIEClkC2BcYXbCpsj59EzuSH8RlqBzVH25+W
         tiqA==
X-Gm-Message-State: AFq9FYIcAdE93sctJpb+70M/0v451voUJ4hK++SGaVXCYFygHjT55QmL
	DiQoxMjY8855/e8qAjDXxZg2TdVg4rrVKF3LbVjk4/j41IKMWDkNAOmXyk6GD/Mfsuj2BXqPtsU
	4NLHTD1Y30nHRDUBm1EuTDC7rb3rq4EvXQPRDDYNrVwG/KgAx1U89z0WB97w=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:250d:b0:53e:8376:dfbf with SMTP id
 5614622812f47-5640ddeb467mr7426570b6e.40.1793687259832; Mon, 02 Nov 2026
 22:27:39 -0800 (PST)
Date: Mon, 02 Nov 2026 22:27:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae97edb.39567162.178b6c.0000.GAE@google.com>
Subject: [moderation/CI] Re: Landlock: Restrict POSIX message queue creation
 and access
From: syzbot ci <syzbot+ci4c8cfb02fa7d05fa@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] Landlock: Restrict POSIX message queue creation and access
https://lore.kernel.org/all/20261102144708.920232-1-webprosto@gmail.com
* [PATCH v2 1/4] ipc: Move MQUEUE_MAGIC to a shared header
* [PATCH v2 2/4] Landlock: Enforce MAKE_REG for POSIX message queue creatio=
n
* [PATCH v2 3/4] Landlock: Add POSIX message queue scoping
* [PATCH v2 4/4] samples/landlock: Add POSIX message queue scoping to sandb=
oxer

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/808eb419-26c4-4ba7-9c41-6a93f2b03d56

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/75289b70-faad-474c-98fd-320942ebab4=
3/config

security/landlock/fs.c:2213:30: error: incompatible function pointer types =
initializing 'int (*)(const struct mnt_idmap *, struct inode *, struct dent=
ry *, umode_t)' (aka 'int (*)(const struct mnt_idmap *, struct inode *, str=
uct dentry *, unsigned short)') with an expression of type 'int (struct ino=
de *const, struct dentry *const, const umode_t)' (aka 'int (struct inode *c=
onst, struct dentry *const, const unsigned short)') [-Wincompatible-functio=
n-pointer-types]

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
[brauner@kernel.org gnoack@google.com landlock@lists.linux.dev linux-fsdeve=
l@vger.kernel.org linux-security-module@vger.kernel.org mic@digikod.net uti=
lityemal77@gmail.com viro@zeniv.linux.org.uk webprosto@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

