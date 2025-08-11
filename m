Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30059213E90
	for <syzbot@lists.linux.dev>; Mon, 11 Aug 2025 21:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754947226; cv=none; b=Y7uh/RwFZ5LHbdHiFbwbHFNRR4i/b53f30an039gtXgQW/cItnvKLw0CX664WyMs8aYrAZ9oOmEaSlFGdHIzDI6PqwYemSpsh+2eyNUPNAU2VoKyRJivgxswlQecH5nd+sT13juWfEr8rtVgWvW8OEMogzSRDrzhH67d40NnGKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754947226; c=relaxed/simple;
	bh=TeQjZ417LtAAKg6A3PAt3iY6dKc+CdOLHYVefSK9a4o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=oVy+Ozb0bRKzZFoIUUoIbCwEV8BqfQRYIMren/EaZEdrlH/IU/5cZQbsPA9J3/LBa+1iVeiS3qSbIAgQx1tRlIMI0uIJg4vD3vsA27Fk8EbqK7V/7IHMtqOB7YdNDdicpa+SjvpCp95lb5WrWCCta0VrGmMNIf1ITltVCwggH98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8841d3db1a3so19661939f.3
        for <syzbot@lists.linux.dev>; Mon, 11 Aug 2025 14:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754947224; x=1755552024;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o8O74EWP5s7dJXPsA+EAHQJFwN2bAcXvpCbFN9bFo3w=;
        b=XQntzQsPlHpnacopdTUpcC87fevvRaJJGT4nYmbzcGCgWhDWmQNIRpo3aiyVyhbXoh
         x2PcOpKawJ3pfTzqgq6+ssrputH4aB8lG9atQ0s8uC3+4wQZYgS1hc227lq4hGQCnpaW
         31hE35ZmSl5+w0vwhuOnxXgUb758ZPW9Jlz+CQrUfpdKHyiLwqK/syH0nuKkbwJkKciy
         sE35yjvRT15+aiMEjMNf759xqFrwufaF4DGRlNeixaCYmiyGtD8KxKV/jiKoq9bNpjPi
         +NmL5Nrcg86vpSY70NRBnU0AfWqPNv5K5NKwp6dGt8MBFfuPT1KLhmQ57nC89FiBWTe/
         N20Q==
X-Gm-Message-State: AOJu0YwotdDyLq+SxMjHNk4XW9LuExG+4noG3DMqSc56/Qotu4CBu0CP
	i19IR2j5OO8ivueTreabJ1shnqHUgTDBEsYmiDn2Zi1v6q+oznkFxQBFBiE2pY9+XpJ5g2h3PNT
	uoESAs4AwDsQ5Bhnw9oUAPnXfZ8OT6B/NUrdiZA4ikbJOh6TlGk18n1PN7Ic=
X-Google-Smtp-Source: AGHT+IHIsjqcY9ZqZxOF5ruPRDIrB4U9RtyANyuKuHVetH0w3/3UT9kU5C/vAEuiEejZMkC1XZrY4QK2RAXdagMhg10a3+hdeh7A
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1485:b0:883:f8dc:df53 with SMTP id
 ca18e2360f4ac-8841be3997amr245980639f.3.1754947224201; Mon, 11 Aug 2025
 14:20:24 -0700 (PDT)
Date: Mon, 11 Aug 2025 14:20:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689a5e98.050a0220.7f033.0102.GAE@google.com>
Subject: [moderation/CI] Re: net-memcg: Decouple controlled memcg from sk->sk_prot->memory_allocated.
From: syzbot ci <syzbot+ci5c068abc2c1451ef@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] net-memcg: Decouple controlled memcg from sk->sk_prot->memory_allocate=
d.
https://lore.kernel.org/all/20250811173116.2829786-1-kuniyu@google.com
* [PATCH v2 net-next 01/12] mptcp: Fix up subflow's memcg when CONFIG_SOCK_=
CGROUP_DATA=3Dn.
* [PATCH v2 net-next 02/12] mptcp: Use tcp_under_memory_pressure() in mptcp=
_epollin_ready().
* [PATCH v2 net-next 03/12] tcp: Simplify error path in inet_csk_accept().
* [PATCH v2 net-next 04/12] net: Call trace_sock_exceed_buf_limit() for mem=
cg failure with SK_MEM_RECV.
* [PATCH v2 net-next 05/12] net: Clean up __sk_mem_raise_allocated().
* [PATCH v2 net-next 06/12] net-memcg: Introduce mem_cgroup_from_sk().
* [PATCH v2 net-next 07/12] net-memcg: Introduce mem_cgroup_sk_enabled().
* [PATCH v2 net-next 08/12] net-memcg: Pass struct sock to mem_cgroup_sk_(u=
n)?charge().
* [PATCH v2 net-next 09/12] net-memcg: Pass struct sock to mem_cgroup_sk_un=
der_memory_pressure().
* [PATCH v2 net-next 10/12] net: Define sk_memcg under CONFIG_MEMCG.
* [PATCH v2 net-next 11/12] net-memcg: Store MEMCG_SOCK_ISOLATED in sk->sk_=
memcg.
* [PATCH v2 net-next 12/12] net-memcg: Decouple controlled memcg from globa=
l protocol memory accounting.

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/6fc666d9-cfec-413c-a98c-75c91ad6c07d

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      37816488247ddddbc3de113c78c83572274b1e2e
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp=
1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/a5d5d856-2809-4eee-87ca-2cd1630214a=
e/config

net/tls/tls_device.c:374:8: error: call to undeclared function 'sk_should_e=
nter_memory_pressure'; ISO C99 and later do not support implicit function d=
eclarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org almasrymina@google.com cgroups@vger.kernel.org d=
avem@davemloft.net edumazet@google.com geliang@kernel.org hannes@cmpxchg.or=
g horms@kernel.org kuba@kernel.org kuni1840@gmail.com kuniyu@google.com lin=
ux-mm@kvack.org martineau@kernel.org matttbe@kernel.org mhocko@kernel.org m=
koutny@suse.com mptcp@lists.linux.dev muchun.song@linux.dev ncardwell@googl=
e.com netdev@vger.kernel.org pabeni@redhat.com roman.gushchin@linux.dev sha=
keel.butt@linux.dev tj@kernel.org willemb@google.com]

If the report looks fine to you, reply with:
#syz upstream

