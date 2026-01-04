Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6776630FC15
	for <syzbot@lists.linux.dev>; Sun,  4 Jan 2026 19:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767554789; cv=none; b=YVsyqcU1LdFfTKdq4sxiPvf5qveUh5QS9pR3o5uUKB/9WQO74u8R+FwBL6Dvx23g+iqNCoLKTCoLw9hddB/ol3aJ1n3L5n7axx4nPRf1aDKExpAu/UH9M+3LQ4ffTKt46qsC+NJAl4KOpLy697JZY5yh3bftFSHBos4By1HoZr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767554789; c=relaxed/simple;
	bh=qIM+upIh6jSn/UuDSPw9a+PG54ubEGKEbPCAj4b7NxI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=trnDgQclZwhSIRWAkFQrkmck6OpxoI/9F7+HpCYX+AZtlsPId+QEW36cg55xM6bH4EtZYuQ4p1aDABp4HIobq42deY0bJf9BS+QvqKzyC/s3ek+9cn/CB8uaWQ95imZODoBK3QrG36DnSJW3Ws0dwWxT3GqJ/KBiirmsWbluX1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7c76977192eso53593741a34.3
        for <syzbot@lists.linux.dev>; Sun, 04 Jan 2026 11:26:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767554786; x=1768159586;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ydOLcZcYzbhWA9fuLZgfDw6jU5NDwDKwFyY4NZi5uv0=;
        b=uaqp5qlnW1rwmUH845OasgKfJHHUKZQZ33jnGzgg3OfNsVcBfRH2gOuuE6caYmsuBS
         1JCdcAwXrHeP+EXmHmkPKKaVFqjiB5DdxUgEnams3813qmuM8UAp5Dk08XM+lz4ulla2
         ZIZRohk2rD3L+p5sTPDcrlX94922/8SYq25xFrhAjgKTaXGrFxH1aJAJxVy3u0BL/InV
         s5KviCFB8wgyIhZGkIxNmZaPbfpS8zVXeQ3Gtx4MYQf0tD8E7PtiUZBBg4dXH/zHv2o6
         ydlTt3yXwu92ZlvCtmRniwgS3Qb+dwl5/MEyN9EgMG0Mv1JGvfREB6ns59DkOOSGChNL
         jylQ==
X-Gm-Message-State: AOJu0YzvhNM2Baw2jrrwor3izWKXESdSsb8lhK0RvyWl7lsJRCnRaGyJ
	OY5trK5qVpiPKzIt9Al/OdnN7U9FWBNjWHl2kB7IItATyfOvMs508wPTWJJCDZVJ720oe8pLmSM
	srSvq3mAJ6stGVTSqlmhL0g88LBuJWbuia9yPDILJIyL+7237x8FzFCttvJY=
X-Google-Smtp-Source: AGHT+IHOI5FH9xGoK55xxU6ddilFQGSmXsgoelX8J2jDPpz3jlG3xitC+kF9/y5PHeFVVZcP1IzIMsS6/INXzphAKipZexOJV56G
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:602:b0:65d:363:b869 with SMTP id
 006d021491bc7-65d0eb125c5mr20387817eaf.71.1767554786175; Sun, 04 Jan 2026
 11:26:26 -0800 (PST)
Date: Sun, 04 Jan 2026 11:26:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695abee2.050a0220.a1b6.0393.GAE@google.com>
Subject: [moderation/CI] Re: netconsole: support automatic target recovery
From: syzbot ci <syzbot+ci9e3f90472158f576@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v9] netconsole: support automatic target recovery
https://lore.kernel.org/all/20260104-netcons-retrigger-v9-0-38aa643d2283@gmail.com
* [PATCH net-next v9 1/6] netconsole: add target_state enum
* [PATCH net-next v9 2/6] netconsole: convert 'enabled' flag to enum for clearer state management
* [PATCH net-next v9 3/6] netconsole: add STATE_DEACTIVATED to track targets disabled by low level
* [PATCH net-next v9 4/6] netconsole: clear dev_name for devices bound by mac
* [PATCH net-next v9 5/6] netconsole: resume previously deactivated target
* [PATCH net-next v9 6/6] selftests: netconsole: validate target resume

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1cedc4df-715a-4d97-adf2-bc659b02a6c0

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      dbf8fe85a16a33d6b6bd01f2bc606fc017771465
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/37c79c1a-27b8-475e-a1ed-b14161757dfb/config

drivers/net/netconsole.c:299:14: error: use of undeclared identifier 'dynamic_netconsole_mutex'
drivers/net/netconsole.c:316:16: error: use of undeclared identifier 'dynamic_netconsole_mutex'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch asantostc@gmail.com davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org leitao@debian.org linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com shuah@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

