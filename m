Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE74A33AD8B
	for <syzbot@lists.linux.dev>; Wed,  1 Jul 2026 03:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782875332; cv=none; b=GOMoPXFCHYnzkql7kRfBOd6EnhPsYiqSIqlqHmlUZiiqO2XfCkysSq2gdVyRoulf3StxcrsW5b4MlW4qMBPWunbgMMD8XTG97YgJqnyL6vbonsVOapVRkRAlQDcQdMuFg2jQCRL6aZJb7F4z3yOuKWMzLjgjF1VL+IIeTWy3xIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782875332; c=relaxed/simple;
	bh=F4eNRw6TNvYPOCmz9blVDu0j5Oi3+fgrtvGG9WILZ5Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=XIjcr8JYJe5G2C3b96o3etHfn6PzixLeq+60yBVF0AE1uM+UpsQMba1Q9fz9/tRqO1/tYL5zhYmk7M7BRy8FrsKZF00EuvTAREVZrKO9gsvpwe89zTYbyioHH9PidCtUafwGG/6y5oCFcvX/q+lNH49vMJVk//ncSybpBifITq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-448bb8bd2efso322640fac.0
        for <syzbot@lists.linux.dev>; Tue, 30 Jun 2026 20:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782875330; x=1783480130;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qzWc1YrY6N1Oc9IxDLZzOnsTRBj/gOil+eh3eYfBAL4=;
        b=P3MqT/NRINY8FjJXxAeLOlSlb6M33q82p1/Y5/GPxHDFpAg5n5D/UIgm4tphKw2tvg
         cTKfGARjPqfUaZmf+k06yOif0gEqdZvTGxFoHwPmcub62g1eF+67h5TX0UQfJ9zu21a6
         p6I9UGfUxnbK/eJITCYfT8PVhZlkayWSdOdRJ8N8hDq21U5324iR9xk2St/tektRDqhl
         HBXC5psYrOpXXpyVsekFKeDuTXLsY0djcRlSH3jhZRO/iNUTNKOmDjCk7EYsy8M79fue
         N9xo1pIanEaopBNUMRBwdr7W5j3u8xGZtr768MurAzmfi++iZ7lILsrh11RmHieVa+i7
         UXaA==
X-Gm-Message-State: AOJu0YxSwK6X+Z8Fay5muo+zhM5Q7leS7SYsp+D2HAAcBZqz71eG4/DW
	RKEx9v8odnLyTScKUNUqs8/Ec7A0jpgZYwbC8/02mIfqgryF6uYjrauohlThQzLzVvolk+QvXyW
	KtX144HplrUUD/HCpUYaxnDe56YFgz6C4btCuJ14SJ2yfd0LxGNFq3R8tNFU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c050:b0:495:f0b0:7543 with SMTP id
 5614622812f47-495f0b0ac98mr3085171b6e.1.1782875329855; Tue, 30 Jun 2026
 20:08:49 -0700 (PDT)
Date: Tue, 30 Jun 2026 20:08:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4484c1.6124255a.dd83.000b.GAE@google.com>
Subject: [moderation/CI] Re: xdp: RX checksum metadata hint and checksum
 assertion over redirect
From: syzbot ci <syzbot+ci45b4400a7c00010b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] xdp: RX checksum metadata hint and checksum assertion over redirect
https://lore.kernel.org/all/20260630191510.81402-1-deliran@verdict.gg
* [RFC PATCH bpf-next v1 1/7] xdp: let XDP programs assert the RX checksum over redirect
* [RFC PATCH bpf-next v1 2/7] selftests/bpf: add test for bpf_xdp_assert_rx_csum over cpumap
* [RFC PATCH bpf-next v1 3/7] xdp: add bpf_xdp_metadata_rx_csum() RX metadata kfunc
* [RFC PATCH bpf-next v1 4/7] net/mlx5e: support the rx_csum XDP metadata hint
* [RFC PATCH bpf-next v1 5/7] ice: support the rx_csum XDP metadata hint
* [RFC PATCH bpf-next v1 6/7] veth: support the rx_csum XDP metadata hint
* [RFC PATCH bpf-next v1 7/7] selftests/bpf: cover bpf_xdp_metadata_rx_csum in xdp_metadata

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/934c1801-592e-4efe-b829-7fb2af36a272

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      f456c1922c49e6be5ce407ddb74a6e61af5b65cf
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/ff08f58d-c28a-4b82-b8e6-4fda286f0e7d/config

drivers/net/ethernet/intel/ice/ice_txrx_lib.c:618:37: error: member reference base type 'const void' is not a structure or union

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
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net deliran@verdict.gg hawk@kernel.org john.fastabend@gmail.com kuba@kernel.org martin.lau@linux.dev netdev@vger.kernel.org sdf@fomichev.me]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

