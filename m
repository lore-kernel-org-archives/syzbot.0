Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F8120E702
	for <syzbot@lists.linux.dev>; Fri,  3 Oct 2025 06:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759473537; cv=none; b=prZTnDThD0fVno/cXLnUkI6FXxEYDyc7TtIUcnXIuDKW29JFosNQbVXo/SNik9b4qPwdf6QI8mQc8yPa2tglkkAJp0feYMhLUoEdWjkVq8tQwg7Rezy0zn8bvHAN4xj3nYGeL0wdjeEUOydWsXekwGpEEVSRFCiITWd1Dk5EUEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759473537; c=relaxed/simple;
	bh=sS1ci1fRdSyD3bQx+U/qc6pnPlcVXnmRqmrpoymCKQ0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=bPYxfBIbEzyhPPnMGVWPGQZd2R6RUtq1tKekrhEW6f3Le60/GnReBmcQugiG2l96Mfeksag1NqANtZ+0YVWHgK3YmAzGaqVDXPIhhXQHtviMa9OXZb5jXSfaD9OuMp6PIP3XbjUzuk/IqxHtIeCd2cbPqmT7JRiAdaf7TC09sfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9143e8a4c5eso538585239f.3
        for <syzbot@lists.linux.dev>; Thu, 02 Oct 2025 23:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759473534; x=1760078334;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2436xm47D+NLByyO4GjfDPKkGJK+dE9wS00HxK9m1Q4=;
        b=apHazpAuC8Hm3wVvFbDE/3VpJbHpF7dsviF3trReHUBe3yNO7NydbjPyQLOo5XOeNr
         MgxTTOy718kmEil/X290rWhItR6X+ytN0usSYZdytZwUI3dsqobxDThK8JMV1ye1VG2J
         +mu1GOlm2HmYQZTGvAshEwFuBcse3vswqMTpndaPY0JkpaeArVvukkoAzDHp2zFLTGGv
         RXnxlhWDllE2tHN1BcqQwTPGwcbzE8b2JPNHnxGqNl4kw6M7ZHFYYK7SbXIgFjEJabrd
         jQon/aP7BpMVqPe0YQ/bbCJP5zH/MVronu8aW9pAP0fDl3r9zJr3vnR1ZTO34HR9qYCQ
         gJAg==
X-Gm-Message-State: AOJu0YwmEcq8/1YdmiSehWXJfyw8xRIxlKWjXJ5dMAJX3cSDYmqETL3I
	7+If1ocfJMr1+oQiCqFQI4jqh+jMl4wB3ikNRXirZIUth1cM+K+gt7ZfW551uaaXh62sQPVorjt
	p7upSmt7rZS0WbdkJw1UYLvEPiBHR3E48nh6LUowiPFOCegdOHUk/5aDWejE=
X-Google-Smtp-Source: AGHT+IG/YD4xfJmVJxex+ojRpvv3NkHtyFlOMf9aEVCMYEeDVC+l2sWH0rkeLI/I5EuD9MwrUuXhksVgqTLJ/p4cTvkqkCovoxWG
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6b:b0:427:a3ef:5701 with SMTP id
 e9e14a558f8ab-42e7ad2ba96mr26105215ab.14.1759473533863; Thu, 02 Oct 2025
 23:38:53 -0700 (PDT)
Date: Thu, 02 Oct 2025 23:38:53 -0700
In-Reply-To: <20251002154841.99348-1-leon.hwang@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68df6f7d.050a0220.2c17c1.001b.GAE@google.com>
Subject: [syzbot ci] Re: bpf: Extend bpf syscall with common attributes support
From: syzbot ci <syzbot+ci17fb38a78c944e07@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, leon.hwang@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] bpf: Extend bpf syscall with common attributes support
https://lore.kernel.org/all/20251002154841.99348-1-leon.hwang@linux.dev
* [RFC PATCH bpf-next v3 01/10] bpf: Extend bpf syscall with common attributes support
* [RFC PATCH bpf-next v3 02/10] libbpf: Add support for extended bpf syscall
* [RFC PATCH bpf-next v3 03/10] bpf: Refactor reporting log_true_size for prog_load
* [RFC PATCH bpf-next v3 04/10] bpf: Add common attr support for prog_load
* [RFC PATCH bpf-next v3 05/10] bpf: Refactor reporting btf_log_true_size for btf_load
* [RFC PATCH bpf-next v3 06/10] bpf: Add common attr support for btf_load
* [RFC PATCH bpf-next v3 07/10] bpf: Add warnings for internal bugs in map_create
* [RFC PATCH bpf-next v3 08/10] bpf: Add common attr support for map_create
* [RFC PATCH bpf-next v3 09/10] libbpf: Add common attr support for map_create
* [RFC PATCH bpf-next v3 10/10] selftests/bpf: Add cases to test map create failure log

and found the following issue:
WARNING in map_create

Full report is available here:
https://ci.syzbot.org/series/71cc3485-c0bb-4e81-ab58-5a3a9b5a785c

***

WARNING in map_create

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      4ef77dd584cfd915526328f516fec59e3a54d66e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/f37ac003-a816-47bc-ba46-fe604a617a93/config
C repro:   https://ci.syzbot.org/findings/bbf6cd34-205b-4dba-a0c6-10559caa70de/c_repro
syz repro: https://ci.syzbot.org/findings/bbf6cd34-205b-4dba-a0c6-10559caa70de/syz_repro

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5987 at kernel/bpf/syscall.c:1470 map_create+0x12b3/0x17a0 kernel/bpf/syscall.c:1470
Modules linked in:
CPU: 1 UID: 0 PID: 5987 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:map_create+0x12b3/0x17a0 kernel/bpf/syscall.c:1470
Code: e8 82 26 ef ff 85 ed 74 29 e8 39 22 ef ff 48 8b 1c 24 48 89 df e8 5d c7 ab 02 4c 8b 64 24 08 e9 7b ff ff ff e8 1e 22 ef ff 90 <0f> 0b 90 e9 d4 f3 ff ff 48 8b 1c 24 48 89 df e8 d9 db 00 00 48 8b
RSP: 0018:ffffc90002d2fc20 EFLAGS: 00010293
RAX: ffffffff81d0a382 RBX: 0000000000000001 RCX: ffff888020e55640
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffff888020e55640 R09: 0000000000000002
R10: 0000000000000021 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc90002d2fd00 R14: 0000000000000000 R15: ffffc90002d2fd40
FS:  0000555569a59500(0000) GS:ffff8881a3c0f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8bbc12acf0 CR3: 000000010cfb0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __sys_bpf+0x966/0xe00 kernel/bpf/syscall.c:6305
 __do_sys_bpf kernel/bpf/syscall.c:6450 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6447 [inline]
 __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6447
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8bbc18eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe6b9b55a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f8bbc3e5fa0 RCX: 00007f8bbc18eec9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007f8bbc211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8bbc3e5fa0 R14: 00007f8bbc3e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
