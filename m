Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8598D2FE066
	for <syzbot@lists.linux.dev>; Wed, 10 Dec 2025 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765390747; cv=none; b=fl+JEvdM8iKAprcWWyAUfE11L3ZfkLF1xJSOr0cFkQbYw2wko7t0qXezWQUaSzU3j9OanRBAYpM5SgrdszqmOFHcCWAK6UVBrKNNh0JgvDyfp/+C678vMPATW1KgL/akc99E63Ymhsx5ov6DUXMI6DRHKHKpZL1UWcIGqNRjvQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765390747; c=relaxed/simple;
	bh=0XjVtx781AmpnqrlWFeQwu1LXUihVhOOGjXtQRAvWTI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Hi8xGM8dWg0hF/meAceuZTZSeYishBHvfybOWkvp1Dh9922GmCQ/ybbyE5WnrwDi0yvlvBD9AtitdYod2LoN4xgPjyyUW52Wr5gicApDNNx/Lo3V8LrfbJNkF1RnAHGo9tf4zQ4FBCICdhb5Jl6Lv/lEXmdMf7F8BAeQM2vTbHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-65b349639dbso63848eaf.2
        for <syzbot@lists.linux.dev>; Wed, 10 Dec 2025 10:19:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765390743; x=1765995543;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WYSvdPvDlZo2WI582hhvFPnSu375uYjLfzOyiL+FTAk=;
        b=I7mnWZnGYbd0SGJk/pds51NUWdHqba1Z2hXAw1Z/UkjOslZlbm6rfN3uUlHiKRvHqL
         RrWhSggzcPSMa7I6gYB/LP/7MvNL2Ym24hUnsigW2oX9jMLKARGirsSBLS/9w7ufz6Sp
         WrFoTxFgvEnsJXAZ+CQrEpgkAGiSTgpG9M5WO1Aqw+Rk0YUQtI2I2/tNmXr5mduy2m+V
         SeCBIAx0wDvzG+XzJ+j7bhVJQrvAOejHQk59+A4iSY7SGcUj6y7g7N7uIq4tvGRzNP12
         9DsmA+nR7SgY+B+kag0zlwN756jODvQ77szE2gebjf3Eb5RJHOZu/gm7vR2qPnLr//x0
         KsSQ==
X-Gm-Message-State: AOJu0Yws9ciBxElJA0smbITJYhD9LhdASYZ16ToQZjaRFqVU+mstFgs4
	SUo9bFbbVf0FFM2Ob0/q3eTeSzKkD2b5wrshemBYc0/VE1RtOYH8WFIfCuQHVMVj/2LVUZSsffF
	U1MazJhldMliFbAcdaDAfFpmL//KCoagzxYKRh18kpkYdMgFyaCk0tE2FGYM=
X-Google-Smtp-Source: AGHT+IEhjZQqwhEHDzq1Yi0HHhg1WhYn8ErClpOvFCOADWa4wdz8XqqOCsQ3NJHApgZI4m0sOTxF0sQHzxtOoP1pP1uAL8H3V15a
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1509:b0:659:9a49:8e3f with SMTP id
 006d021491bc7-65b2abc2303mr2060051eaf.15.1765390743581; Wed, 10 Dec 2025
 10:19:03 -0800 (PST)
Date: Wed, 10 Dec 2025 10:19:03 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6939b997.050a0220.4004e.01c3.GAE@google.com>
Subject: [moderation/CI] Re: net: sched: Fix ethx:ingress -> ethy:egress ->
 ethx:ingress mirred loop
From: syzbot ci <syzbot+cib8d2bcab3a0987ad@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loo=
p
https://lore.kernel.org/all/20251210172554.1071864-1-jhs@mojatatu.com
* [PATCH RFC net 1/1] net: sched: Fix ethx:ingress -> ethy:egress -> ethx:i=
ngress mirred loop

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/785801a9-be3c-4519-8b86-36e6e4fe755f

***

kernel build error

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      8f7aa3d3c7323f4ca2768a9e74ebbe359c4f8f88
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6396437f-7fc3-43a9-8d8e-1cfd6ffca37=
b/config

drivers/net/wireguard/queueing.h:96:2: error: call to undeclared function '=
skb_reset_redirect'; ISO C99 and later do not support implicit function dec=
larations [-Wimplicit-function-declaration]
net/netfilter/nft_fwd_netdev.c:34:2: error: call to undeclared function 'sk=
b_set_redirected'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[daniel@iogearbox.net davem@davemloft.net dcaratti@redhat.com edumazet@goog=
le.com horms@kernel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org l=
ariel@nvidia.com netdev@vger.kernel.org pabeni@redhat.com pablo@netfilter.o=
rg victor@mojatatu.com xiyou.wangcong@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

