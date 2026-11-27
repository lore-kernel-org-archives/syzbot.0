Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795760628;
	b=vbiV8/rrn0wrbQPiehaC/OykGj3ANy1YNDbOLcZt18/oIA/q6/4ISZAKr2O7/4csk89T
	 Cvl3xyBP9xGky6nq9Y9XV8MnL9/UFQif9cHzuF+Nhe/vnFL87kdiW9Wv62t5bp8gIrt9n
	 ARJURJ3nlcokNuDnIM0ftlPZooH4SprfTz2gbVtDSYypSF31XxNQEupFzfBr44CSPSm5b
	 U0e4J5pX1p71V5znIwaYA7jtATsW16UedzW4/fqZidOSpj9vpmQ4uZvbbGiU3dzphZfem
	 rxSnSgQ/YKPv1wsMuFP7S/g80VWWCdRuyjn1NUNFnEUQrgoza9LMIXSOkt4i/grrDWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795760628;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=xYgQga9u8hUjdEXzpEX9HRImBpLpNALqvIW917WJ9ec=;
	b=mLFP+1sySHKePjOkEFH/Wta8Mp3sGf++kl+anhUnnKMvlW0eFoEFyW4DpCKDqdXerwBv
	 INr3FXzXfQh6pqG17NBLKAGDnxSH7ZT0JSqjNtM7Vq5+mzea7nqrFg0bq2OdXSO8WtOm3
	 VFV1XkL3swS75D6SBk6indb/t1ZZ5OuPfU5FpblZvVp9uATIm6bg5QxtQzrbIz+IDS1QW
	 B4jK2kdkznLW77TyV5y8T6uEcIAEZviU3vvoSizPFT8jmyrBJ8vQO5WDMiw/b37zKbOaK
	 SYflV9UGU2haYSWmYE/bvqIhNCoLannINm6NzIkzHxZ7SDaRJeivzlty/ELhlPfwHBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37BF606A31E
	for <syzbot@lists.linux.dev>; Fri, 27 Nov 2026 06:23:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F37BF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4eb0b989f0eso9276554b6e.0
        for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 22:23:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795760627; x=1796365427;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xYgQga9u8hUjdEXzpEX9HRImBpLpNALqvIW917WJ9ec=;
        b=CQHLDcxBNLI/79Q/dqZLMSfzIGrfhEPdIgO1aP6bthBcS2WWVJxH113V+fmlWOp9ux
         vuIPDgPBAj0OIHFiXvVgEz+3rI/QCSGkxgsbGczlFg1i8aWivm2gxeRgjSdy0q/V4Eml
         ov+4wEJ1dtRw0N4Ajx0QxTE5mD02DoOk5VFh3c2uf99k5vS3goaIrXmhCZxke0E8bYJY
         O8y0B019TXICSNheX9U3+kSgtndPBkOiiTHLUloxXMi4rzglr7NDeAxY3qg3DROu4YnQ
         zaCUhS9n47RJrnv9KTXPh5rjZB1wEbdi2G5MptnFp5Z4wjL2Y66cAABwPkzB/gCzoES8
         X1Tg==
X-Gm-Message-State: APuU4Z9j2GYa1kUsJ/r/GxeCqEHRckp/eOIf1FwRQVBFCa0NB8pqXyO+
	wRvgV/ueORS3r+G0gtg9Un61ZN8I5YdNC3ZYbvVqB0DrJimZ8+Uya1lcvqXpoPXkg8OL+0eIqKH
	uO376Qc7j3tnJ64TdOpnUSS3G5IEDzU9VpUZXBAWvLt8h1digLdxYtnMfVCY=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4441:b0:568:195a:3ba8 with SMTP id
 5614622812f47-5797d0b44dbmr19422730b6e.29.1795760627077; Thu, 26 Nov 2026
 22:23:47 -0800 (PST)
Date: Thu, 26 Nov 2026 22:23:47 -0800
In-Reply-To: <20261122090454.6217-1-25031212351@stu.xidian.edu.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b0921f3.1492ceaa.187240.0078.GAE@google.com>
Subject: [syzbot ci] Re: ALSA: line6: Stop URBs synchronously via sync_stop callback
From: syzbot ci <syzbot+ci4a0a685a2ad8288a@syzkaller.appspotmail.com>
To: 25031212351@stu.xidian.edu.cn, byu@xidian.edu.cn, 
	linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org, perex@perex.cz, 
	stable@vger.kernel.org, tiwai@suse.de, wencheng@xidian.edu.cn
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] ALSA: line6: Stop URBs synchronously via sync_stop callback
https://lore.kernel.org/all/20261122090454.6217-1-25031212351@stu.xidian.edu.cn
* [PATCH v4] ALSA: line6: Stop URBs synchronously via sync_stop callback

and found the following issue:
general protection fault in line6_kill_audio_urbs

Full report is available here:
https://ci.syzbot.org/series/142062cf-1e2f-45f6-889f-e755c6f0dfc7

***

general protection fault in line6_kill_audio_urbs

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      9437ee8b6cf607e883b36e44bd755968daaebd48
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/fa7bddbf-e0c4-41e2-9f96-995d29f44c33/config
syz repro: https://ci.syzbot.org/findings/3b9dd218-32a8-4b85-8604-77328ada3c3e/syz_repro

snd_usb_toneport 1-1:0.0: cannot get proper max packet size
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 994 Comm: kworker/0:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: usb_hub_wq hub_event
RIP: 0010:line6_kill_audio_urbs+0x1eb/0x320 sound/usb/line6/pcm.c:133
Code: 4c 8b 24 24 4c 89 e5 48 c1 ed 03 42 80 7c 35 00 00 74 08 4c 89 e7 e8 d4 96 92 f8 4d 8b 24 24 4a 8d 3c 23 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00 74 05 e8 b9 96 92 f8 4d 8b 24 1c 4d 85 e4 74 0f e8
RSP: 0018:ffffc9000632ec10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88810d8e0000 RSI: 0000000000000010 RDI: 0000000000000000
RBP: 1ffff11023131427 R08: ffffffff91be37bf R09: 1ffffffff237c6f7
R10: dffffc0000000000 R11: fffffbfff237c6f8 R12: 0000000000000000
R13: 0000000000000001 R14: dffffc0000000000 R15: ffff88811898a000
FS:  0000000000000000(0000) GS:ffff88818bdf6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bf9470d0a0 CR3: 0000000117d14000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 line6_pcm_disconnect+0x1c/0x30 sound/usb/line6/pcm.c:515
 line6_disconnect+0x166/0x260 sound/usb/line6/driver.c:844
 line6_probe+0x9f5/0xcd0 sound/usb/line6/driver.c:818
 usb_probe_interface+0x751/0xe00 drivers/usb/core/driver.c:399
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:707
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:869
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:899
 __device_attach_driver+0x270/0x410 drivers/base/dd.c:1027
 bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
 __device_attach+0x2bd/0x430 drivers/base/dd.c:1131
 device_initial_probe+0x9c/0x100 drivers/base/dd.c:1190
 __bus_probe_device+0x126/0x220 drivers/base/bus.c:614
 device_add+0x7d7/0xb80 drivers/base/core.c:3778
 usb_set_configuration+0x1bb5/0x2260 drivers/usb/core/message.c:2280
 usb_generic_driver_probe+0x8d/0x150 drivers/usb/core/generic.c:250
 usb_probe_device+0x1c3/0x3b0 drivers/usb/core/driver.c:293
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x254/0xae0 drivers/base/dd.c:707
 __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:869
 driver_probe_device+0x4f/0x240 drivers/base/dd.c:899
 __device_attach_driver+0x270/0x410 drivers/base/dd.c:1027
 bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
 __device_attach+0x2bd/0x430 drivers/base/dd.c:1131
 device_initial_probe+0x9c/0x100 drivers/base/dd.c:1190
 __bus_probe_device+0x126/0x220 drivers/base/bus.c:614
 device_add+0x7d7/0xb80 drivers/base/core.c:3778
 usb_new_device+0x9aa/0x1690 drivers/usb/core/hub.c:2713
 hub_port_connect drivers/usb/core/hub.c:5585 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5725 [inline]
 port_event drivers/usb/core/hub.c:5889 [inline]
 hub_event+0x28e8/0x4d30 drivers/usb/core/hub.c:5971
 process_one_work kernel/workqueue.c:3497 [inline]
 process_scheduled_works+0xc5d/0x1650 kernel/workqueue.c:3580
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3661
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:line6_kill_audio_urbs+0x1eb/0x320 sound/usb/line6/pcm.c:133
Code: 4c 8b 24 24 4c 89 e5 48 c1 ed 03 42 80 7c 35 00 00 74 08 4c 89 e7 e8 d4 96 92 f8 4d 8b 24 24 4a 8d 3c 23 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00 74 05 e8 b9 96 92 f8 4d 8b 24 1c 4d 85 e4 74 0f e8
RSP: 0018:ffffc9000632ec10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88810d8e0000 RSI: 0000000000000010 RDI: 0000000000000000
RBP: 1ffff11023131427 R08: ffffffff91be37bf R09: 1ffffffff237c6f7
R10: dffffc0000000000 R11: fffffbfff237c6f8 R12: 0000000000000000
R13: 0000000000000001 R14: dffffc0000000000 R15: ffff88811898a000
FS:  0000000000000000(0000) GS:ffff88818bdf6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bf9470d0a0 CR3: 0000000117d14000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	4c 8b 24 24          	mov    (%rsp),%r12
   4:	4c 89 e5             	mov    %r12,%rbp
   7:	48 c1 ed 03          	shr    $0x3,%rbp
   b:	42 80 7c 35 00 00    	cmpb   $0x0,0x0(%rbp,%r14,1)
  11:	74 08                	je     0x1b
  13:	4c 89 e7             	mov    %r12,%rdi
  16:	e8 d4 96 92 f8       	call   0xf89296ef
  1b:	4d 8b 24 24          	mov    (%r12),%r12
  1f:	4a 8d 3c 23          	lea    (%rbx,%r12,1),%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1) <-- trapping instruction
  2f:	74 05                	je     0x36
  31:	e8 b9 96 92 f8       	call   0xf89296ef
  36:	4d 8b 24 1c          	mov    (%r12,%rbx,1),%r12
  3a:	4d 85 e4             	test   %r12,%r12
  3d:	74 0f                	je     0x4e
  3f:	e8                   	.byte 0xe8


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
