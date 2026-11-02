Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653990;
	b=m5Z7kAcFnIh9e8y9epw6Qe1SUgEpzvxviImoDwqnHy5lwr5rfw5/gVTxPRWVp/aVVjVa
	 RkQsWimAy5pCu89TPYZGYYTymsJU1A7EeRL+E3ykfZ5TEaz/UyYiMRuXsiwACT49M5tcC
	 f6c7zJhsdOXBBnvtFYpKbvIPJbc/OCUpCNkRQmSDBHyFPW03yoSCAMyZMgL8iUxn1B09P
	 P91K5lyyibc6mONN2p2uFEe+w7u1WEaGLx7AARzMPVxPGVRbtkHaaFcrZF4MCM0BY8mK5
	 aRC6899/ynrD2Vt8joES8zkksj6ICOrMEIqSJ/ikvEos9a/S0MzYOfIHuDdbU9X6cqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653990;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=oB0LuMTgYWe7cERHUJNalCn8pvEx3jy5zBcnWXkFrPA=;
	b=FwABLDGCcznxJnPNN5D+/V6EkjqbxukCuROVxbCEcTlLvIGA3eEu7aDgM+yMnaV5PDHQ
	 VAyrUt9c4a8aPcsBRQ9nIFfXIzHaWgfskjmkAQCRhBokukktchfnZbcsuCE1q09gKKSVT
	 cInYqhmldICLZhPsSElDljOuor54rhEo3tm4HIGBusFdBj9kBN/XhjJbdiJeHFta6bY5m
	 aNKBHlHZBtkW9ZYaNoJ4dHIzYQlJdEIJMmc2UB8Hc7pU8KEUPNA3NxkHly3GUo1eV3QCL
	 7/xs4LzU4VIwoQ9ARaxYIKA6HWLgJ1nbd5R+nNsWHNy8KksINdg3MDiCDvozxSsLwtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB554606A32D
	for <syzbot@lists.linux.dev>; Mon,  2 Nov 2026 21:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB554606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4dab94dc3e7so5298376b6e.0
        for <syzbot@lists.linux.dev>; Mon, 02 Nov 2026 13:13:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793653989; x=1794258789;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oB0LuMTgYWe7cERHUJNalCn8pvEx3jy5zBcnWXkFrPA=;
        b=Mh8Ak70+Y9GNifJV4I+vN5QWAtAxpf220VLJ8NAeNdit6R5VzRi6x8G1hIo6NFbWV8
         njQZuSTwRaXJwVYGpMn1TncuYdAHdjbET6xZQzg9CAAL0eNUvFcpMYydnDhOPdiKxQVk
         C/9oOeRKoT3NF9hmspcC85gsB/HFDY4g7/AkntwDPThE+8hwyebtqlXrmrgLyJng3Hlc
         EB5AO6uzhYqqn92aPgRo1GQqsCekV8agL8Y+ey2aLSi6BT7qj/Q/sTU3otwqF++KiBtP
         D2yAF3el0kVBJ8jCdAzjTjqgxavaW4TND4WphDpELt9yu5K0XaJKQ3RTKvUe8l9j6Y60
         jIkw==
X-Gm-Message-State: AFq9FYLFNv3v3GGn0UeYkmwtay10+vtbcVqvOxVm7Bj5rvpC18EVihzE
	9Ce90VUIuNIu7zUnTiWlk8P78zS2iuHdsG8xVSEM2IKl1HqHAwxTSz3aSXPgyQfk/s3wNJqbwY5
	EuVCLcUI3g6tXAsPDoYvvHC0nNWsXTRTmZ3YDdBBjwOqAmVZDlcb1hRSaMCk=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:151f:b0:4c3:6d56:77c2 with SMTP id
 5614622812f47-5640de7e3a9mr7794816b6e.41.1793653988723; Mon, 02 Nov 2026
 13:13:08 -0800 (PST)
Date: Mon, 02 Nov 2026 13:13:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae8fce4.52c4c7f9.b7231.0004.GAE@google.com>
Subject: [moderation/CI] Re: igmp: use copy-on-write RCU updates in ip_mc_source()
From: syzbot ci <syzbot+cia5e6e396ddec2565@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] igmp: use copy-on-write RCU updates in ip_mc_source()
https://lore.kernel.org/all/20261102095312.47767-1-18983559317@163.com
* [PATCH net v1] igmp: use copy-on-write RCU updates in ip_mc_source()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/03228251-9799-4e5a-8f98-a8e37eb3c89f

***

kernel build error

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      209108a5456171ab430e25b54b2dfe083455bfb6
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a8f5c308-a81f-4c46-8bef-b7d2c3d0efbc/config

net/ipv4/igmp.c:2646:1: error: function definition is not allowed here
net/ipv4/igmp.c:2737:1: error: function definition is not allowed here
net/ipv4/igmp.c:2797:1: error: function definition is not allowed here
net/ipv4/igmp.c:2846:1: error: function definition is not allowed here
net/ipv4/igmp.c:2893:1: error: function definition is not allowed here
net/ipv4/igmp.c:2919:1: error: function definition is not allowed here
net/ipv4/igmp.c:2972:1: error: function definition is not allowed here
net/ipv4/igmp.c:2994:1: error: function definition is not allowed here
net/ipv4/igmp.c:3013:1: error: function definition is not allowed here
net/ipv4/igmp.c:3023:1: error: function definition is not allowed here
net/ipv4/igmp.c:3029:1: error: function definition is not allowed here
net/ipv4/igmp.c:3041:1: error: function definition is not allowed here
net/ipv4/igmp.c:3050:1: error: function definition is not allowed here
net/ipv4/igmp.c:3089:11: error: use of undeclared identifier 'igmp_mc_seq_start'; did you mean 'mr_mfc_seq_start'?
net/ipv4/igmp.c:3090:10: error: use of undeclared identifier 'igmp_mc_seq_next'
net/ipv4/igmp.c:3091:10: error: use of undeclared identifier 'igmp_mc_seq_stop'; did you mean 'igmp_mc_seq_ops'?
net/ipv4/igmp.c:3092:10: error: use of undeclared identifier 'igmp_mc_seq_show'; did you mean 'igmp_mc_seq_ops'?
net/ipv4/igmp.c:3105:1: error: function definition is not allowed here
net/ipv4/igmp.c:3134:1: error: function definition is not allowed here

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
[18983559317@163.com davem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.org idosch@nvidia.com kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

