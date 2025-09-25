Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00312ECE94
	for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 10:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796620; cv=none; b=O1hduqZSoOJ/f72cRnSHQmvXPhndmSNEeQo2ecI9TAZ0RnJ7zhOaYjHy9vVtNyrVP/278ptBUCNccbEGjQCWQHt7/7i+pHFLG9dSLukrEW0oT5GrE2DxTZPy/kZHLXrcbHML2BOxnNHzc7P3gQ+L9Tny15ECp/e6jxoaRY5rjHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796620; c=relaxed/simple;
	bh=DnnCRKkdDHjuB4wCtLEQE24GMUt3RZRGH1BfQhjPUJU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=sGjuzqy9wrrSrALV1tG/PtaKBQjtxmbHQUuRvRMsHQWU09d4nxE9vbVG9cehz2PpTteRxIhoQFgvIAxaLaRWgi9At1JbOt/otLoZBlV7sBJLxkXJA1OsGpnNK4Ka+gMBYGKmZxMDZsXMBcx7RWqZrQE/Fco1A9GzXWnDCeWN27s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-425703f5d96so8948515ab.1
        for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 03:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758796618; x=1759401418;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F0P652rV5Qi+hnzMhQg/EjfkKj6u51Bii4uSWgkelE0=;
        b=QpcTW1Ub2KpEtWTIW0MLg8++35pm8Y5veMBZSLPBoArDe9b8uaXS5aEMJ1ngNCArc0
         /dzNx2I7un2gOXQ01xdfscpEx30VxV/+inA+pc0yq+CHoyeYNNNPOKPP8zYJueujL32E
         NHOb8WEekH3wMbj0876JIx4JzXDPzKR7F436TfH7Q0ATRQtPmCVTpFK5CFdipfq9FMl2
         scKuwReQ6KCtO8JIQRI8IjIw9XwLwO+KkwqLhY4pxlVk6TGz+N2CTOiHCCuXY9yqxP+q
         D8WdY8F+qdvZY3np2E0x81L3drIPmoblD5IIEDcKIs3kHdX0pqfOYCxwAAN/DolDfllg
         Dtgw==
X-Gm-Message-State: AOJu0Yw2zK3YeSWUAL14+M847O2b6ROtmVwE03BLJTpHvLn4w1SPEALN
	PgKxO0lM1F4Z8dff6xG6SDOcXry9ml0+rUD5iE/1O69N9NKXdUg9dMRdQq9JYS9FLGZ3yCs/kb0
	mdI1mmkxNcE2QWWMK2EJZRijPQiYvrLLqPzChIaURiS6AQp3Vpgq8b0gD9wM=
X-Google-Smtp-Source: AGHT+IFucwpI3Gb+PvknXyglGRu1P4xBQrbpPsYS3XU0LKCgzqBb5bAIZSvlPvzie2x+5tO3sJfdMacgloOF5GD8UzV7BUZjJW8w
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c87:b0:425:71bf:1148 with SMTP id
 e9e14a558f8ab-4259569078cmr43558525ab.30.1758796618018; Thu, 25 Sep 2025
 03:36:58 -0700 (PDT)
Date: Thu, 25 Sep 2025 03:36:58 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d51b4a.050a0220.25d7ab.0009.GAE@google.com>
Subject: [moderation/CI] Re: Add the the capability to load HW RX checsum in
 eBPF programs
From: syzbot ci <syzbot+ci9e3e9a66b6774b57@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] Add the the capability to load HW RX checsum in eBPF programs
https://lore.kernel.org/all/20250925-bpf-xdp-meta-rxcksum-v2-0-6b3fe987ce91=
@kernel.org
* [PATCH RFC bpf-next v2 1/5] netlink: specs: Add XDP RX checksum capabilit=
y to XDP metadata specs
* [PATCH RFC bpf-next v2 2/5] net: veth: Add xmo_rx_checksum callback to ve=
th driver
* [PATCH RFC bpf-next v2 3/5] net: ice: Add xmo_rx_checksum callback
* [PATCH RFC bpf-next v2 4/5] selftests/bpf: Add selftest support for bpf_x=
dp_metadata_rx_checksum
* [PATCH RFC bpf-next v2 5/5] selftests/bpf: Add bpf_xdp_metadata_rx_checks=
um support to xdp_hw_metadat prog

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/78ddd54f-1223-4988-a9c0-567175908ef4

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      d4680a11e14c7baf683cb8453d91d71d2e0b9d3e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/ee405b1d-3849-4def-bcc7-e6b23da5f79=
b/config

net/core/netdev-genl.c:50:1: error: use of undeclared identifier 'NETDEV_XD=
P_RX_METADATA_CHECKSUM'; did you mean 'NETDEV_XDP_RX_METADATA_HASH'?

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aleksander.lobakin@intel.com andrew@lunn.ch andrii@kernel.org anthony.l.ng=
uyen@intel.com ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.net dave=
m@davemloft.net donald.hunter@gmail.com eddyz87@gmail.com edumazet@google.c=
om haoluo@google.com hawk@kernel.org horms@kernel.org intel-wired-lan@lists=
.osuosl.org john.fastabend@gmail.com jolsa@kernel.org kpsingh@kernel.org ku=
ba@kernel.org linux-kselftest@vger.kernel.org lorenzo@kernel.org maciej.fij=
alkowski@intel.com martin.lau@linux.dev netdev@vger.kernel.org pabeni@redha=
t.com przemyslaw.kitszel@intel.com sdf@fomichev.me shuah@kernel.org song@ke=
rnel.org yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

