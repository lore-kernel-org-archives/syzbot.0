Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792860517;
	b=kdJBdBIfckcnwHRGobPnFjoLEqo9MpDTPsn7zxrECjjv6YwSfbptr9w9FT49kw60jJjy
	 d7XqdIPkcWRZJKSIuYBptok13iDvAN2YJmd/yvWhe8jMPs2EeDd4A1LSGLdCCeNGJXXsJ
	 zOeWSUeySThu5KoNMPQUPZ9QNsOab3UggcJ8gbkSiJo8hNvCqbSQtx7typRW40Y11LkNr
	 BlVSCJdAg1UuxJJm9UY5qsuYxhLFP2R6q07QgUdVIa7zAlXtxY2p/vKLpoF/ZsWADrVpb
	 fHNsrF8UtRBQlNg8WN3ugNl/v4nRMDVzQ3/fP5GD1SFAj9Kb1uRw6qfwcT49fCiHE0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792860517;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=EBG7hWPI9bG2IR3Iy3z3AF79ebmwCYkWtp4P3+prSEI=;
	b=t/uSfJhSNRlIazqKzDiO4fmLRVY2L9BlJVkXuWjWri+2CjuznLgfB7OUDjZ7BS6Cyjk0
	 QqN5OuINRPJxOTvU8sXXVsiyqCTc3hKKVbB/kHyj9LrxE1pHdKoKVUBu1RjvhaBsqt1QT
	 ajBYFcMda6rPacG0QUamAh3DkmlpI7mbnR5Z8YgUH6tH6JPlQIMmiviqSiiw3kWroo/4L
	 olD2ghywgcREaQMuIpQzvfuQ+5Z9pzjyZVJJRQPZHaqfAyemXYftLO6r1ep66Yc3jYMW9
	 zA/n3xpXkN4Nn7SOMSQM3cdZa6Q+JTAcMTGXoO4mTayEIAO6iZAlYkIw92TwL1+1vFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDEA606A31A
	for <syzbot@lists.linux.dev>; Sat, 24 Oct 2026 16:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DDEA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4c55ba309c2so2984266b6e.1
        for <syzbot@lists.linux.dev>; Sat, 24 Oct 2026 09:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792860516; x=1793465316;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EBG7hWPI9bG2IR3Iy3z3AF79ebmwCYkWtp4P3+prSEI=;
        b=tp8SDtM45F9wWnd3OyP4G5sM/ieGd2nCdrB+v6wH9Zyro6EQK96J2PfCwjl+2rk2WR
         ja4L9CfSop2dNVyEDLIy5U6Gh7IxzugzWdfDdCGKErb2qSpgxBvZ/8e1C5W3v1ySrWrP
         vY24DTlAaSGvKRybj8Cq4c1tY8otV8gl1IS1MoX7XL8Asldz1zgaECb5I2HkLG3I3udI
         vJql+fdTciQg0efPxinoV1xz7DJIO84D1UeiJAy7WmjPc7rv5vk/mENuVks5eM7hX0fb
         tMOFSslJW3plw+mddMOid2HD65NOt0aD9hgd4f+tqnxiB2EgccGrPDlACzlb2ETh8NyU
         IfXA==
X-Gm-Message-State: AFq9FYIFgUe/nluMfXwCkZjRpri3P33H0zv8c48Ku6GnKs+x1jV0gS6H
	bhiyG/Z6eIrnFKPj8tqCUmmJnZKcVfiRUG63dtVczKiJnzeNMgllqVCx/IZbDLwkTrc+31ftr6Y
	DG6EvnEaPi/8kJJqAzK+sA0Om/LIl+2jQ0LPoHm0kUuZEfzPy1BxriGdVBEk=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:17a3:b0:4dd:18c7:5448 with SMTP id
 5614622812f47-55c003c01aamr1439797b6e.56.1792860516265; Sat, 24 Oct 2026
 09:48:36 -0700 (PDT)
Date: Sat, 24 Oct 2026 09:48:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adce164.3f6e6ada.1e998b.0084.GAE@google.com>
Subject: [moderation/CI] Re: mm: ppm: add PPM (Page-Plugger Under Memory) to
 Page Fault and Overcommit elimination
From: syzbot ci <syzbot+ci4d30b565bec50485@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm: ppm: add PPM (Page-Plugger Under Memory) to Page Fault and Overcommit elimination
https://lore.kernel.org/all/20261024104552.394-1-joaoanandalima@gmail.com
* [PATCH] mm: ppm: add PPM (Page-Plugger Under Memory) to Page Fault and Overcommit elimination

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d08588fe-a72b-41c9-a1fc-16209f588f76

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      2ce051dd658ff584d3cb580d7e3f5c4ceaaa56e6
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/562b84a7-4c0d-466f-afb9-7664aa2a245b/config

./include/linux/ppm/gfp_types.h:15:18: error: typedef redefinition with different types ('uint64_t' (aka 'unsigned long long') vs 'unsigned int')
./include/linux/ppm/gfp_types.h:29:23: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
./include/linux/ppm/gfp_types.h:63:34: error: initializer element is not a compile-time constant

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
[ardb@kernel.org joaoanandalima@gmail.com keescook@chromium.org linux-doc@vger.kernel.org linux-efi@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

