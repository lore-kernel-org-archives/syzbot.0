Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F01322DCA
	for <syzbot@lists.linux.dev>; Tue,  9 Dec 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765283345; cv=none; b=HtywnVeGd5H4tLaD3FdJlaVyo1G4uqtAL486l8BGiECf91PFwTICL/sAL4Ns+FQDEyf4sn6MwsXUc/dm0rsWLKFPXgPbI7jlH9LAq1Wd5sjhFJRookyyguh+Nhx9mtpJT4O+r5AhM1/MZ2jrGHHlTcsQ3o1uMtvEaGIvZbDRqmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765283345; c=relaxed/simple;
	bh=ofQ7/KcmxQx+8et4AcFlChrPBD3wEY/Tnc4z5rADVoc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=GFI8u8XoUlhZDMTCXQ3XW3rvH2LHfVSU6uG6riLflR9w8wU1Iz8TtwUcOMsG6ZmYRgzRmjhtX9Dhw6qT0o8mENzss4jFzh3TNwm7vJdiXx99kJZihRD4iIcwrxNx8+QakvI8QxqAvla7DiqeVcIulQlMS/NgeWeApBb+1B/bdxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-65716511512so7016436eaf.1
        for <syzbot@lists.linux.dev>; Tue, 09 Dec 2025 04:28:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765283324; x=1765888124;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A+8Az7gObFcomcPcWK8zdMlM5oPcab4S3+ji/3nc8cc=;
        b=rGRgwkzRLx29g+Kt11H886ZptxZuhqPmscPRtrX85eeRs2GHoluLXh8MT7Ix17qtgf
         USmQ0iehD0waIUIiQlJDqvIJV2XHpWL/nbvc5Z4Eqs3A9owgDarQ9Dc5esd3blg778oc
         IMhG1twj4MQKUZvmfIHBhBscR7DP8/d7jqT0hghP9ca/XhlqmE/m6YgMWvcxkA0HeE5Z
         WedX1yNr8yQd4XGmgCeLn5P6GgpSm+bTUu7tMSbge+qMRdR4D97WDXl9wt2mZ0HQZdGi
         POPLqfem2LUSj4uEAw+N2si9Dx2PBjO0UixmcCS5Pl+PMeiEjusuzwwTj+hc+B91c32/
         Qqqw==
X-Gm-Message-State: AOJu0YzPgP5NdCJiSiQQqJm5fOiox7nwkmVEEJR9IKzBJOOqW68giE7I
	1fcC978afqWAIiDy3P9okd5m3yiHNgnMkELDYGb6thIblP3qBsYCDqKRkY8BXx/OgxLiJMvfiqE
	7Yi6UI5VUgHSZDbGL5+DHWTEdMEHRFMtG7w8UjGVhCVFJ5D17+aR7314ov4k=
X-Google-Smtp-Source: AGHT+IH1DsyN2yyFG6zR72o1ZE0EdV3FiFtXsZVQJGMd/zi3Wq1ZSyb/90aFX05+k+zl8YlV+smPg1uJXUhib8NQwj+toTkP385X
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1885:b0:659:9a49:9081 with SMTP id
 006d021491bc7-6599a995cecmr4032318eaf.76.1765283324404; Tue, 09 Dec 2025
 04:28:44 -0800 (PST)
Date: Tue, 09 Dec 2025 04:28:44 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <693815fc.050a0220.4004e.000d.GAE@google.com>
Subject: [moderation/CI] Re: net/handshake: Fix null-ptr-deref in handshake_complete()
From: syzbot ci <syzbot+ci1969116f2ce3ca74@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net/handshake: Fix null-ptr-deref in handshake_complete()
https://lore.kernel.org/all/20251209115852.3827876-1-wangliang74@huawei.com
* [PATCH net] net/handshake: Fix null-ptr-deref in handshake_complete()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/e63d7ca3-926c-4a4a-822d-6240f25d9f98

***

kernel build error

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      8f7aa3d3c7323f4ca2768a9e74ebbe359c4f8f88
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/59c3acc9-b321-4046-b43e-06ad739aed7=
b/config

net/handshake/netlink.c:110:3: error: cannot jump from this goto statement =
to its label
net/handshake/netlink.c:104:3: error: cannot jump from this goto statement =
to its label
net/handshake/netlink.c:100:3: error: cannot jump from this goto statement =
to its label

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org chuck.lever@oracle.com davem@davemloft.net edumazet@goo=
gle.com horms@kernel.org kernel-tls-handshake@lists.linux.dev kuba@kernel.o=
rg linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com wa=
ngliang74@huawei.com yuehaibing@huawei.com zhangchangzhong@huawei.com]

If the report looks fine to you, reply with:
#syz upstream

