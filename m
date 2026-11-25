Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795567955;
	b=hN463qNlaXPg0LXoJqjsHNOX9YPbHrEbNYiMJIP944kUGsapguKyWSxsGDQm8rk9xN7T
	 IqU5/4j0Od2OcSgDSbOI5Hxi0QT6vGdXM0E8Iw85Z57909hf/6yEm56Qf07NIePxIB5um
	 zvwWiIPAKAzevrAPGxp4AjHpL0PfaLqeAKI/wXbbUT510plT9QVenhgveC+zZGHoEgxWd
	 bTD/dJDchR6y1ATdfu21mW31a+c4Mv4YRR92P8G6VAKGF9nu9p5r1E2aCkqPBKq89/JFs
	 QOhYRIIkPf7zrTAPijT2xMqBkwkydYjV32RYpIgT8BWJ+I/cN1oiyC8EAd7orQpjD2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795567955;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=H9N+y78ZHoOrUx5liGUXnWq9IV0j434fGGIg9bJMFew=;
	b=tgPUj9qr3db0hWTgMtOVbW4zCGYXrF6A4lP0cMdzS2anMD4Fp6YfWlcMQG6tedJEXZYJ
	 0ysMK2lPvtpSqVnQk7iPt1vFdSg3FrMQa1hcv72HGf11m73428R51hVnRXW49og7jyvdx
	 CXgoz1maHVkJwCam44brwuNR3PEOxSUL6/ML1dlZRK14SSHP/G9kZXoG9EvLVHh7xkle/
	 2ub2HVP3qRgT1YGf0H05dnBLYverzSdTKy5/fdWX499jM35KAEWaGRx+nSre1CpgyNnqr
	 iDuJ9bUD8hYY6BFMz2vdfw2sBrVJ5AM3JGSb9Q+EhJnR9Ns9P28DvDAVTBqaTJH7HOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D71606A31E
	for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 00:52:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4D71606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-571bc0b66d7so4726422b6e.3
        for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 16:52:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795567953; x=1796172753;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H9N+y78ZHoOrUx5liGUXnWq9IV0j434fGGIg9bJMFew=;
        b=Q5hDhaudVfDnNsM0Qyqpr+4A8D9kK6csXWAUW6QJ6P3apsy443wGYvg1pPwD8rP+Ip
         LPBHhabb764SBVHpU4GOPVIrSDUP2XJM1VSYaVhtiq5WtA46Z8/NjkHHe8bIDuIgLpiM
         AKJZwDopER6nyaRsu6PbofPo+bsNxcvNN3PAldFbloGvMK1FBE1G64LxQoxrDMX36W/p
         +dnmE6w4Kje3dKwyttZ6Et6bM39jpIANlKz1KtEbvVPAXzyZRhJRwj3iXbdfsMM/dJMk
         P9EW2SPWUB+3zJNDGIo8U6Gn1TMxkpv/RQ99NF64RWbPreQZ4MdOSTdTNrHEQX7zVG/o
         TOlw==
X-Gm-Message-State: APuU4Z+/OatX/dKuuYCuO1Uu3WRhzhGknlM6vT8Y6ffuo2h7UJaHL3x2
	DmxWERpRV7rM5DuJru3+/J2rxU1fPqbm4slQTH37tTvbQVK1vUXqsLf8/8pK6h9ZEi/sdgVlHLd
	rPjNwXdOoDSwmO53yJP1fRzACDYpnEeDTghDeW6IEkK7BWj0duAOTi9Ml9rM=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c12b:b0:572:86c8:6b4c with SMTP id
 5614622812f47-57a07d19c74mr17071939b6e.6.1795567953681; Tue, 24 Nov 2026
 16:52:33 -0800 (PST)
Date: Tue, 24 Nov 2026 16:52:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b063151.3f72aad1.34e135.0016.GAE@google.com>
Subject: [moderation/CI] Re: ceph: reject MDS dentry names longer than NAME_MAX
From: syzbot ci <syzbot+ci9f7e5bbf5d1db158@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ceph: reject MDS dentry names longer than NAME_MAX
https://lore.kernel.org/all/20261120-ceph-readdir-name-max-v1-1-ba7c434d4733@clyso.com
* [PATCH] ceph: reject MDS dentry names longer than NAME_MAX

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/f4a81eae-22cc-4b07-97bb-46ef43241d81

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      8d7fe9885c62fc9a95bf55d9db244d9672a8aadc
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/40abc327-2e40-493d-bc39-7bb1003a015f/config

fs/ceph/dir.c:430:5: error: call to undeclared function 'ceph_blog_exit'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
fs/ceph/dir.c:430:21: error: use of undeclared identifier '__ji'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[amarkuze@redhat.com devnull@kernel.org idryomov@gmail.com leograntquinn@gmail.com mchangir@redhat.com security@kernel.org slava@dubeyko.com stable@vger.kernel.org xiubo.li@clyso.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

