Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792541440;
	b=WJpa2wrfhCEQRfhVr3KIXClyZ/RUhNWM/V4pYXfoinzGXakWJ4m4028w+vDyXRi4wnpv
	 8NMblW2fHe6pTOt7k+bPjIAezT9HTJqF7sTTahOWL4M0qa6XWXFpfIk9blqiPzhxuF8RV
	 LrvmX26pnjT1JTR8T4SSDLLFRlbanoYHVZaK1YQWoAlYQUytegofJxVrQfCB2r1IKzoJJ
	 tP8M3UzFslxg9iAXaMqmVO4cLKgWWBG83zIbgdq2uJnMde4IfwBJygttuC90FsRfLp6vm
	 XUtGWZiOie28ObCLkzDlGbosF5bDH/N/KD8MdlDQ6lz4jHhxVnTn3h9QrgJaG+13Lxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792541440;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=DaUC3hVOoDyoJw/alart1u8NCQtPkLuvlnm8SNRPYGc=;
	b=4PXTdO4kyf3ICjMOqM1YFwhrJm5EgNUTON3LW0v1Cq5qAQMpHiuYyflT+CPccU+4hMhc
	 si5WOo9EcDJoPcL5MgYAVActArAbLSJVVUjjVL8wj0mCeYZ8hmw9FRg7kRyq2lZZpfweL
	 pTElAUZcqc68xIe/RLnU9VpvUCoL1c9HIdbYcAgpWMCWA16qptsFcVa4jK/Dxmx4EEMsO
	 pDYf1JZAywjLqb0SBneQvSNb83FNJGoTAb66ceZcywU5+eIcNMJLgOYyS23a1kqEAJy7C
	 Gs6JFjOYaxQLsROaAPTNexSXIWnTp1t2YBNJGXVBR0UDKa9UpFdTIUmOnwc0zVrsjUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.72
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D50F606A319
	for <syzbot@lists.linux.dev>; Wed, 21 Oct 2026 00:10:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D50F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-81447a16061so476201a34.3
        for <syzbot@lists.linux.dev>; Tue, 20 Oct 2026 17:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792541439; x=1793146239;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DaUC3hVOoDyoJw/alart1u8NCQtPkLuvlnm8SNRPYGc=;
        b=QooIcLlkvvW1+Z+wHX2UvhHhhxHwmpO6uS4zIFb81CtxBllieA7gP6MEukZUXI8osH
         6Lvb63D8YMEAL0IfJStyD2tRYhs482RZRCcDcv/zcbw7dqx2+e9KNWQABsBxonHi3wbf
         uQk+uOF3Ru8LwfFzxWT+uUzNG4GAGUI017flse3Hodk7xXrUVJ3wUR/YVL22X6kxwA/f
         RRbtnf8gtnPmem3V3H5CjV7IOwegmIO3Nhvvlzq1p+qwwZIyI9Q4B/zso5Z8ymf4bj9Q
         RWV+SaXrOXOFX1UjU6Poq9upgRunXKVEU8d6ksv5OOuXDrs3Qyxq4XhxzZD+0Fbsj1wE
         uA1A==
X-Gm-Message-State: AFq9FYK/GSoZaaKhFsa2y+D/58ZE5ULx4BgKEdf1AkfpUidMhIaXeWE6
	PltyVmCCZ569LXZnbKqejwR/IjEAflbqB4ex6rOCm4MgypPcV1kS4K1Q2BW6XcKin+d40Is7LND
	j8IrAO3gFFKaQO2DJ9Pt09zQumQeQMFhIa/hXcPh/lBFrrmTzFj2xbxqupCs=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3094:b0:500:5e36:3a9d with SMTP id
 5614622812f47-5535ab467e8mr292804b6e.30.1792541439223; Tue, 20 Oct 2026
 17:10:39 -0700 (PDT)
Date: Tue, 20 Oct 2026 17:10:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad802ff.5c73e770.1a06c9.013d.GAE@google.com>
Subject: [moderation/CI] Re: KEYS: Return user session keyring on lookup
From: syzbot ci <syzbot+ci174dd4219b0034e2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] KEYS: Return user session keyring on lookup
https://lore.kernel.org/all/20261019145624.309790-1-jarkko@kernel.org
* [PATCH v2 1/2] KEYS: Return user session keyring on lookup
* [PATCH v2 2/2] KEYS: Reject keyring creation with overridden credentials

and found the following issue:
general protection fault in keyctl_session_to_parent

Full report is available here:
https://ci.syzbot.org/series/7566814a-52ba-4f0b-b506-d7adf67fda29

***

general protection fault in keyctl_session_to_parent

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      17a7501b9612a52b38bc57e33c7b64636d438bc0
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/eee373c7-f447-49cf-a350-83830580c7b=
2/config
AI triage: https://ci.syzbot.org/findings/38560df7-46ef-4e6d-b6fa-6e0718f03=
397/triage_trajectory

Oops: general protection fault, probably for non-canonical address 0xdffffc=
000000001b: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x00000000000000d8-0x00000000000000df]
CPU: 0 UID: 0 PID: 5730 Comm: syz.0.6 Not tainted syzkaller #0 PREEMPT(full=
)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:keyctl_session_to_parent+0x825/0xa30
Code: 35 3b fd e9 fe fa ff ff e8 38 35 3b fd e9 f4 fa ff ff e8 2e 35 3b fd =
48 8b 54 24 20 48 81 c2 d8 00 00 00 48 89 d0 48 c1 e8 03 <0f> b6 04 18 84 c=
0 0f 85 b2 01 00 00 8b 2a 89 ef 8b 5c 24 1c 89 de
RSP: 0018:ffffc9000621fc70 EFLAGS: 00010006
RAX: 000000000000001b RBX: dffffc0000000000 RCX: ffff88810b603c00
RDX: 00000000000000d8 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000c43f7c R12: ffff88811a010000
R13: 0000000000000000 R14: ffff88810c2631a8 R15: 0000000000000000
FS:  00007f7f2068b6c0(0000) GS:ffff88818c4bf000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7f2068aff8 CR3: 000000010cae8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __se_sys_keyctl+0x780/0x9d0
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7f1f79f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7f2068b028 EFLAGS: 00000246 ORIG_RAX: 00000000000000fa
RAX: ffffffffffffffda RBX: 00007f7f1fa26270 RCX: 00007f7f1f79f559
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000012
RBP: 00007f7f1f836b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7f1fa26308 R14: 00007f7f1fa26270 R15: 00007ffe789f59b8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:keyctl_session_to_parent+0x825/0xa30
Code: 35 3b fd e9 fe fa ff ff e8 38 35 3b fd e9 f4 fa ff ff e8 2e 35 3b fd =
48 8b 54 24 20 48 81 c2 d8 00 00 00 48 89 d0 48 c1 e8 03 <0f> b6 04 18 84 c=
0 0f 85 b2 01 00 00 8b 2a 89 ef 8b 5c 24 1c 89 de
RSP: 0018:ffffc9000621fc70 EFLAGS: 00010006
RAX: 000000000000001b RBX: dffffc0000000000 RCX: ffff88810b603c00
RDX: 00000000000000d8 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000c43f7c R12: ffff88811a010000
R13: 0000000000000000 R14: ffff88810c2631a8 R15: 0000000000000000
FS:  00007f7f2068b6c0(0000) GS:ffff88818c4bf000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7f2068aff8 CR3: 000000010cae8000 CR4: 00000000000006f0


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
[corbet@lwn.net dhowells@redhat.com ebiggers@kernel.org jannh@google.com ja=
rkko@kernel.org jmorris@namei.org keyrings@vger.kernel.org linux-doc@vger.k=
ernel.org linux-kernel@vger.kernel.org linux-security-module@vger.kernel.or=
g paul@paul-moore.com rdunlap@infradead.org serge@hallyn.com skhan@linuxfou=
ndation.org stable@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

