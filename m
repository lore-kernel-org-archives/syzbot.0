Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726D8212556
	for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 12:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758372881; cv=none; b=nVCcX+5wPm7z17XUAKAQHzIx7IbH44tWGIOHEpP+qfG8SUL5n3pVE1MXPFOuUsOr/GxFv23npaMO99nmAMwMC+kzG3zoXSnlchho+8o0B78IFKBB241M8GPs7AnyZylg5R+/wRKCR/gHLwh39eG3ehFb1el8gVKHNJQqSX39q0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758372881; c=relaxed/simple;
	bh=eoa1/a6SpVJsk6MEDd12oPLAInZuBrmaPrai+DSqxOI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=lG/UHRz7lumfYhFGBQf4RvXjRhLLJScFz1FLs5kAu4YsJNqzo8cRy8Hv1MPOmMuxIYwmJsXZ4Ymi57PqrlV2vB+6gRwzcMMNBI7oYzn/XdvhteAE0doosNDAD2heY5/A3CBD5LoOo1piAxTsNszd9Y6hZBsXajTmIuLL6zUbweo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-425703f5d96so1259275ab.1
        for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 05:54:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758372878; x=1758977678;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MusZ9Z+yy0lWWy7zRCSL3oWa/1YRSxQdMFFiAc5gIVg=;
        b=BFDq9OQekdAm0NRWUXCgBexeWSw+9lwi+geYJ8sxdnvr8eDTYRDNVrD+/YunH1nz8x
         MIPYzX/Ye9w5qr8oH9OQzBj8WygQ0ZAVqEwhDPaYbP1mZyeFwaD56oenhxPRWGIR28EI
         4u+lu7bznSooe/LYrOIq38qssSSriZO/Y040deMeMgpzV+JITp963oGWXF/xIM1S9mXH
         rJ4nU/kIpbMFJDJ3fkOwwXTl70VC4zd6y1nSzbiD2aqVMQd37IlOgYZNEhxnGjkwFLlw
         Rae/iXpYLlrpe+5xZ9W8KMRUZ+3uO7C4gTtAids0bDI87w/paMruJH6NicCJajefNmaw
         Madw==
X-Gm-Message-State: AOJu0YwOURp5eGXP991/zSeCmtaYCmA2wVngvcaZHWsW6FKXoVLCmhyL
	5Dne7NlD+eXV7z9TyQNHsRFQEyYShomVBNWF2BM3C0fNooYEQtlg+QQC4zAKgD6l9r1skGEAXU+
	zIAGCwIWbTAd4ui8Ghoe5VWW1ww+Ja9riTMmSofP7MVh7j7IrGDLnw9b4+jY=
X-Google-Smtp-Source: AGHT+IFzt9LROyI7Q1QQvwUbeOFnbb/XJCP0w+BfypAxcpD/PJJ3QKWVJ4CCjjEtLhf00C0bZzegs/fSnPDoEtrAGfcd7BS0rWPn
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:250c:b0:424:8405:349e with SMTP id
 e9e14a558f8ab-42484053555mr82252955ab.17.1758372878549; Sat, 20 Sep 2025
 05:54:38 -0700 (PDT)
Date: Sat, 20 Sep 2025 05:54:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cea40e.a00a0220.37dadf.0029.GAE@google.com>
Subject: [moderation/CI] Re: Add the the capability to load HW RX checsum in
 eBPF programs
From: syzbot ci <syzbot+ci6aacde40741e8774@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Add the the capability to load HW RX checsum in eBPF programs
https://lore.kernel.org/all/20250920-xdp-meta-rxcksum-v1-0-35e76a8a84e7@ker=
nel.org
* [PATCH RFC bpf-next 1/6] netlink: specs: Add XDP RX checksum capability t=
o XDP metadata specs
* [PATCH RFC bpf-next 2/6] net: xdp: Add xmo_rx_checksum callback
* [PATCH RFC bpf-next 3/6] veth: Add xmo_rx_checksum callback to veth drive=
r
* [PATCH RFC bpf-next 4/6] net: ice: Add xmo_rx_checksum callback
* [PATCH RFC bpf-next 5/6] selftests/bpf: Add selftest support for bpf_xdp_=
metadata_rx_checksum
* [PATCH RFC bpf-next 6/6] selftests/bpf: Add bpf_xdp_metadata_rx_checksum =
support to xdp_hw_metadat prog

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1d02d8ff-365c-49e0-9f30-2fda5557f41b

***

kernel build error

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      3547a61ee2fe8f1fc46d4326a9517d97ae3614cd
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/c558745c-6f16-46cc-bfd1-7c09bf928d3=
1/config

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
ba@kernel.org linux-kselftest@vger.kernel.org lorenzo@kernel.org martin.lau=
@linux.dev netdev@vger.kernel.org pabeni@redhat.com przemyslaw.kitszel@inte=
l.com sdf@fomichev.me shuah@kernel.org song@kernel.org yonghong.song@linux.=
dev]

If the report looks fine to you, reply with:
#syz upstream

