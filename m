Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795071632;
	b=jK/maT3D6QXtmIS4qxQbhnc7o2QtJYIHKbLB38UxKjQgSot+qPGOnm2kGfMRLWrrIeW/
	 MQtdQTTwDnfuoDWPcNHNE8K9nCANUWPFWxsaQaNjXfDxwAzqZv0zVhBO8z+Y7AxuxXUDX
	 8VOyB6TMU6733OzEXDKiOiN8EkgKtpb5DwnS41ySXR04HV45soBKhWpAs4vul2IvvknUa
	 ajGMI0eyxTc42Zcik2/jZbtSbrDA8CWFSeXVfXkX+5cHUDm4tnOV3QXp6oP3Iyqf4Hk6j
	 es9aL3N0S1jHn4H0f6u6s5AQARplOE+2Zb+gRMVDoZvLeF/L2/1BB0/lHWMQO3DCMdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071632;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=43dOOzPr4kWGfR+oDKr9fjX9nu8m4LA8+j1vqIMP6kc=;
	b=02hQ/n0iJebVPRtqdqqtmdi4jfQUEv1/c4+WrrmcQZw6n7VnjhrsRzMtVg0QE2zbCvpu
	 7rNk1yh6JHZrwy9qbPlrfBe7GOnmnnzunEuqlOFEb8fShxgVUFpCUvfrm++dWEBb/clug
	 4F8/QOeOs9IU4xWWLR9ir3ttyegTGwdcTtGaf7zWbSLRQGzrC0yXGIBJ0GfO98FCE7A1O
	 PGJVArLloqHD5ZlsF+Obdg0oaV6ToLBd3U8/hMwvn8Q+b78VPdiGG4JweqkU5H1XAlOr6
	 CUwXbI1ZAPiqTzsjc4hlkEklm6KFKlDHZUHiP1IROUzs5SaqOi/nHPvC16MEFi/02+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF566606A33A
	for <syzbot@lists.linux.dev>; Thu, 19 Nov 2026 07:00:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF566606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-567e742f481so1186705b6e.3
        for <syzbot@lists.linux.dev>; Wed, 18 Nov 2026 23:00:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071630; x=1795676430;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=43dOOzPr4kWGfR+oDKr9fjX9nu8m4LA8+j1vqIMP6kc=;
        b=O8VOZM4M+PoJb4sJQHwWYhzmPuWJ1BKR3T8FZ6fxuJNZSuja+juj9lhnavhhC9M9DJ
         xz+CLeifuffIVPB3DfKtDLQ00NU7QJHtm65fwQo1JkPC1j2cuOzmlzZMs8UNNRHPY3wn
         qd88ArWtW6lrKXBMlPLt421xORX9+/pMUmxry1uIHnQ4+qwze5lDqTEkWcWHMgVUHU78
         lISpLFtbULneInkFptcJnkazbTQu3X4DI71pUdjlSqBbZtz53jbqabrzIds29QscMQPi
         C2PKggnvuVWP080icG7AhnBQ7CIq7t6L5Zn2pmsNndojPl4xBJdP+IfMHWVgYW5OG7WS
         F5ag==
X-Gm-Message-State: APuU4Z8swRMM0bvoEGngm+YgZGGfRXkvrB+gXwvk7YcnfcdLvNFoUy+5
	HMmdgA76zVWVrjKZ+58k2iVmcPwD3TLfIsZVk/6NOeZFff7Sp/r8QA/Oc1+EPkzKbv9TbQZPNF+
	s1skDJUI5i2ZIdvP5LOS+vHR8kI5XJfh4Bl6WV7Ha1vszMI/cN0aym2K4jqI=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:5088:b0:4a4:744:a4ff with SMTP id
 5614622812f47-5773db24bc2mr5642223b6e.4.1795071630660; Wed, 18 Nov 2026
 23:00:30 -0800 (PST)
Date: Wed, 18 Nov 2026 23:00:30 -0800
In-Reply-To: <20261115075832.132109-1-xu.xin@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afe9e8e.92f98041.20636d.0002.GAE@google.com>
Subject: [syzbot ci] Re: mm/ksm: clean up scan_get_next_rmap_item() initialization
From: syzbot ci <syzbot+ci7e1f981ab411668d@syzkaller.appspotmail.com>
To: chengming.zhou@linux.dev, david@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, xu.xin@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
