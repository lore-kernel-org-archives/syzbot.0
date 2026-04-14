Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2C3320CBE
	for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 15:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776181606; cv=none; b=TsJH4Pmn1vTuodkG0H+8myR8xTYAEPBnra+g3zanFx1ra/+Dn538VpAV7TFOHUJq38ZVuVt67Is4zb4zUcwID6xOMnTO4SzJt6fThkiw0Hk5bfRfffQzwKsfUbdvLZ6HFa2dDEmQWtQyfJq+6K+LIm6TS+iNJ5jpeGH8I/wL+xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776181606; c=relaxed/simple;
	bh=lSu6Fko8+/Um4dW1hybcuw19dplLT36VU/USc4D97nA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=QQP5DhYfFaKh537wDZ0cnkpxMMMNeZdKm5RwQxbbLlN9fdF87LmEJazNZsBWyrMB7NhyK5VTfg7z7ooITcRR4CQPy8gg0IMD7BTBlzkCgU8QzVc5iRCoWV38UQWZuVLZRZnPmjgv8juhfJJ+iQn0ccSYIZDc/FqLrlaFwHjUKHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7dbb6b95836so14282619a34.3
        for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 08:46:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776181604; x=1776786404;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JYpVB9HArn+ebfzBzZZ7SygAmLWTrfL4bR8pDGhXKAo=;
        b=bunjLqag95wVHZ59sMr8GzFUyyc6aJUTBCLunk2tXK1xp/hZDgLmxDLZrRr9mM5eg/
         ZLQxY+umXc8DJMZoAO93vilufw6cyhumyAn+JUPr8JpuNhAdMD+mJLzQTBfKxJtIKPGU
         bXgTl35XscW8iI0Vq/ussN41XuBehZ4xhTVBSd3HDtvfgaSJuwvl9JBLRZgvd5pOgTv1
         +4J2OJcDCV6O3UAVmCjt3ZO3wgPVFAZpN0qynHzk3lu2SX25tM8VzZL6TQ29nf42i3WI
         /v+jPg802vqTE6rJfmIy2iGT0ZLsZ6YOUc/veaeKhpYpJnIb4UPyIVdJY9v4PK6mR7jn
         hieg==
X-Gm-Message-State: AOJu0YzVtTU3SDSR+NEao0xbdxPCuRrC98UoOcTB1t2RYMlwZc1ILhSH
	Uq0TVClIwvb0Qfq85B5EyqstMdHuheO+A1SaLUblaR1DMFIF0pdVWUPsFDZjL5QpbRlPVpkBjAB
	57KbAFMsgPHt7P+TtzAC0qwxnzCbqnIl/kMAoPlDBGG5zWedtqVuZ0/EZdeg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2908:b0:67e:1be4:d8c6 with SMTP id
 006d021491bc7-68be8ed06f2mr8947723eaf.58.1776181604318; Tue, 14 Apr 2026
 08:46:44 -0700 (PDT)
Date: Tue, 14 Apr 2026 08:46:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69de6164.a00a0220.475f0.0044.GAE@google.com>
Subject: [moderation/CI] Re: improve hw flow offload byte accounting
From: syzbot ci <syzbot+ci952bfe6f8f5a382d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] improve hw flow offload byte accounting
https://lore.kernel.org/all/cover.1775739840.git.daniel@makrotopia.org
* [PATCH RFC net-next 1/4] net: flow_offload: let drivers report byte count=
er semantics
* [PATCH RFC net-next 2/4] nf_flow_table: track sub-interface and bridge if=
index in flow tuple
* [PATCH RFC net-next 3/4] nf_flow_table: convert hw byte counts and update=
 sub-interface stats
* [PATCH RFC net-next 4/4] net: ethernet: mtk_eth_soc: report INGRESS_L2 by=
te_type in flow stats

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/899f81ea-a8f0-43e8-8f6c-33af90f00034

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      34e1a98ff2a87cf4b8de3ccebe9d45273f014aeb
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b380356e-e6d3-4c03-b57c-ca9a68acd04=
3/config

net/netfilter/nf_flow_table_offload.c:1080:38: error: passing 'possible_net=
_t' to parameter of incompatible type 'const struct net_device *'
net/netfilter/nf_flow_table_offload.c:1095:38: error: passing 'possible_net=
_t' to parameter of incompatible type 'const struct net_device *'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[andrew@lunn.ch angelogioacchino.delregno@collabora.com coreteam@netfilter.=
org daniel@makrotopia.org davem@davemloft.net edumazet@google.com fw@strlen=
.de horms@kernel.org john@phrozen.org kuba@kernel.org linux-arm-kernel@list=
s.infradead.org linux-kernel@vger.kernel.org linux-mediatek@lists.infradead=
.org lorenzo@kernel.org matthias.bgg@gmail.com nbd@nbd.name netdev@vger.ker=
nel.org netfilter-devel@vger.kernel.org pabeni@redhat.com pablo@netfilter.o=
rg phil@nwl.cc]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

