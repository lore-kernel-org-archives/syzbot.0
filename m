Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795064243;
	b=jQZKslVsJbZzU7e6t2/C9V6gCDwETz6mRBbHMRDsreBJSfxF6wq3K90FB6/4MwcI/svy
	 454n5GNOVuc2ljLm6rTcGeZvCMs0X8Akhk5IZCjzE0hfDFeu+Q4howyDBN4LkQuDYxR4x
	 qO66yWZLDwSR9cT/HvKYVw9mDEo+j3Q3XkuWb+Apw/Repl6h7lEVaGNYqN3TaLji89KYY
	 re1Lz7pat5Py/12Jfbx3pns5hnb3C9hdk1N3yXaSNxroKqaRpECG2T5xY2f0J8I/AC7BN
	 DWaT+/Al0h11wxANHikRs7X4O/hcUSv08czjiuTxv0Xj9rg0kTRvLU5iQrV8yo0PD+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795064243;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=YeCewVVxx1OMyqQsCRLHJTglKU5z/TxsSJFaK+ENLOk=;
	b=tziN+Q8/915ViurCWjOXYVzVTSsNC/a7A1kHTCxGgzx2rPxDkVZpf0PtrjpR/B2DtUw1
	 7Csr8GD2dlAc3qs/2zBpV9b3E77OJcn39jHlHBcR2SADrvSzTR/KJ5UY+rtk1Rg93Zi0v
	 lj5vVY2jj4v7muScGzEzyHpnEzn3qLQN5GRBhd9GMdHmrMp+UXeeq02PQImSCeu2mtL16
	 s+3mvPfmegrPSzDz0tkCPK8+nUlHwvIi8Db2YJ8hHZyEbQhshUGUyGiQMZ3QnjK8+rTSu
	 hDkRGJQOdVEra64BUccePAJ1zTkn9W8XPhth5cy9bjiBRtKaRZ2NGj6LJQKdXJOw8hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.160.71
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5DD606A320
	for <syzbot@lists.linux.dev>; Thu, 19 Nov 2026 04:57:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E5DD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-466d41a1d9aso1708505fac.0
        for <syzbot@lists.linux.dev>; Wed, 18 Nov 2026 20:57:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795064242; x=1795669042;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YeCewVVxx1OMyqQsCRLHJTglKU5z/TxsSJFaK+ENLOk=;
        b=VOoFxLhfgYztQ48oDQKjTGOFZ4tquj4I/dzdwFsx5PxHSemHCODNbiOoyvuRhbpsaY
         QYT5zivgqaGKC5pdxhl2porA+FH94xUW5PtVnUw0nl79GvyclDyQFQIzAZpIxbDjdrMD
         g9EcWuRJFw9rzxo1Y7KLGO2GeZ8/527896TJT/hmRzqg3QGxT5U+yY+R9088B7Y76Yo2
         qGg425Cn0u7Q62BeMNR2vuSqMavWSv/Fe7dzvIhU7ronVueub4knyJzDHGAvsjQ74UIk
         Ly8eUmJxHDI+hJYV9dGh1MzUnY/FkazDyodLtCn2rJcEcfEUrOVEkuoKIynYvPn9+8l1
         QB1A==
X-Gm-Message-State: APuU4Z9YHA0oGOr3EHuym7ZtYJBV8l8oI2dhwmCYeBXM2rv6vaDNrxrX
	cqQDYEgYn3j0yo/JvsoXuF9aIy5ZEC8jHcB9yFWnw4hocrz+ZxSDh6cEnS1oq/7rwQRonXH87nE
	zwHkgHktt0OuzOqHpUw5ep+9LBGz0x3U4rmqAH/dpczNDhLbTs5YL3eic3dE=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:bc5:b0:4b2:8d7b:41b8 with SMTP id
 5614622812f47-57741d1c614mr5330425b6e.18.1795064242275; Wed, 18 Nov 2026
 20:57:22 -0800 (PST)
Date: Wed, 18 Nov 2026 20:57:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afe81b2.902182b0.170f33.0002.GAE@google.com>
Subject: [moderation/CI] Re: mm/ksm: clean up scan_get_next_rmap_item() initialization
From: syzbot ci <syzbot+ci6274869ebbf20d77@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm/ksm: clean up scan_get_next_rmap_item() initialization
https://lore.kernel.org/all/20261115075832.132109-1-xu.xin@linux.dev
* [PATCH v2 1/2] mm/ksm: extract helper functions for scan cycle cleanup
* [PATCH v2 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()

and found the following issue:
general protection fault in ksm_do_scan

Full report is available here:
https://ci.syzbot.org/series/cc51d824-2b5d-4c6d-bd56-c5bdb2bf5e12

***

general protection fault in ksm_do_scan

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      3dfc09a9493ddaa5e7722a29165d8450b55b4d3f
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/6f9c12e2-f68e-40ee-bbac-84e33b709dfb/config
AI triage: https://ci.syzbot.org/findings/02a8022e-9e9a-4596-8a04-b8c4338b7e82/triage_trajectory

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 UID: 0 PID: 44 Comm: ksmd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ksm_do_scan+0x5da/0x6f40
Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 89 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8882a77fd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f15aa3f8c38 CR3: 0000000170aa2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ksm_scan_thread+0x114/0x520
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ksm_do_scan+0x5da/0x6f40
Code: c7 05 86 a2 b1 19 00 00 00 00 48 8d 43 28 48 89 05 9b a2 b1 19 48 89 4c 24 40 48 8d 59 20 48 89 d8 48 c1 e8 03 48 89 44 24 78 <42> 80 3c 28 00 74 08 48 89 df e8 47 3a 01 00 48 89 5c 24 30 48 8b
RSP: 0018:ffffc90000b47a60 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000b47c08
RBP: ffffc90000b47cd0 R08: ffffc90000b47c07 R09: 0000000000000000
R10: ffffc90000b47bb0 R11: fffff52000168f81 R12: 1ffff92000168f68
R13: dffffc0000000000 R14: ffffea00046aca00 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88818bdfd000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c27b575 CR3: 000000010233e000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[chengming.zhou@linux.dev david@kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org xu.xin@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

