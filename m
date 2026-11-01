Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793551052;
	b=Cj1Z8peOCxMlQkoZ7J9zS7bTWHU4MJA3SqxrqaknDxa/MC6JDbJNRlRzSUFKl43Y5/HO
	 /CiCw9fbB6pXWD+pWRVjj/GBIPQMN45S7dyol3cWjNmLP5ut9tE43Gn0QgKbA2ozpECX5
	 ho+gv0CMqmubixmbYm2z+1l322RckMgf6wYodWXsa/IsmnwZvtQs15f9jY1/9YjyLKQTd
	 gyFbzkPpaGqvLR7/20hs5evR7GoCC8nK9WktKNzLe6GfKVpIZEZVqh7h9TaRhAdREwHV3
	 thAkj3UEsjqopElSVPo8NvYt6qDKaLLZ8aVM27mLauO5oO/6/J5n2Pnu/hA5UUTp7lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793551052;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=16mY9gWL33K5iVLvCLS6Zlcx3Ll6BDqdYb+dAG0TR2E=;
	b=lqa9asvZXW9Z3p+ao4vEPzhLJrrbrU+mIGskLugGDExYohIjA2Uq0xr6BJUcyZb9/BFb
	 T05GKJKmqkfgZZIyZU9nwr33/q6YcezJNo+/aIhzQwA17QRmQmQBODr7oIbTWaRcJgOhi
	 EpTKI8cdNDV9LcWvVLaRGV8348D4a4GQr1yup+jzGd1Mf9Hb7TADUlEEz56ezBhfAt6u9
	 uMnAzRxoFgOP/3vbJJf9KQlLq5RbRCvsy84LfL5MlkXygL1WHeQqSa1rlkJX5aLUR1EH3
	 +D6bhmfgSE2HEawasZ2FRwNHgYnx65MA0aJTtaxgQh/0a/FOu938NskamRQfBAWXJIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BECD606A324
	for <syzbot@lists.linux.dev>; Sun,  1 Nov 2026 16:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BECD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-83edc5c5ae9so1546662a34.1
        for <syzbot@lists.linux.dev>; Sun, 01 Nov 2026 08:37:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793551051; x=1794155851;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=16mY9gWL33K5iVLvCLS6Zlcx3Ll6BDqdYb+dAG0TR2E=;
        b=LvxGt+eovTW7zVgh9XmkTS4dZIk4ikgk7kbs+XJhHTKnz6e95r5wDo4NYLE71b4xkm
         pePLE9St8idQ18ekFjrOKaWbw4WSensijPCYaC5YCWXLFmLBAVLTJY4nmfRDJU8oXasX
         7kTL/n3V19pB8UmeXcI3rcLjKMTI8CfJ/4iIV3H8Zrpi9HZbCwk6ZPkITX7X0xhIdcIo
         or6fJYV6dTeW19LfPdbTntmkSIZqXx5T64fzorjcr2NUrJWrr88trGNXXYVxAbECqKnX
         r6VZNaQUI5d+Ky0G6mod8+QflWOB2howX0RmL2/6RKtLqBl9jZ4J4PIShRV4dxc+kgaV
         1cmw==
X-Gm-Message-State: AFq9FYJ7hcUTWp45FIGPGdTaGN0CcoOKTCfwZar7anRylV3jH3LoDrpP
	MBLm53q5Gp5lvIIcJ4u4NTFQVGQEtPDo15/TsotJ39phr8lPjNbW24TVa5IwIskFNBoHUvq9B0r
	F8hGU+NMrFopNuNW7BUABnAqX0bC8RWL1kcZdLLsfkr1n3KWjPtVjmthYl+8=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:244e:b0:4f4:73a9:f838 with SMTP id
 5614622812f47-5640dcea0camr5478585b6e.22.1793551051115; Sun, 01 Nov 2026
 08:37:31 -0800 (PST)
Date: Sun, 01 Nov 2026 08:37:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae76acb.7fe51036.1ecf7.002b.GAE@google.com>
Subject: [moderation/CI] Re: media: em28xx: fix v4l2 use-after-free after
 failed init
From: syzbot ci <syzbot+ciedcd9b7e9104cbc7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] media: em28xx: fix v4l2 use-after-free after failed init
https://lore.kernel.org/all/20261031204723.1415-1-drifabdelmalekmohamedsaid@gmail.com
* [PATCH] media: em28xx: fix v4l2 use-after-free after failed init

and found the following issue:
possible deadlock in em28xx_release_resources

Full report is available here:
https://ci.syzbot.org/series/92e27f7a-9ca9-4693-ad76-730262f6efd0

***

possible deadlock in em28xx_release_resources

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      cbbddb6b08cc9900a87cccaa9b22bbe06aa4f50a
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5e867cfe-3c44-46f3-be9a-3394e10312c7/config
syz repro: https://ci.syzbot.org/findings/de514af7-755a-455f-9075-91732cf09a76/syz_repro

em28xx 1-1:1.0: Closing video extension
em28xx 1-1:1.0: Closing input extension
============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
kworker/0:3/5059 is trying to acquire lock:
ffff88801cd25cf0 (&dev->lock#3){+.+.}-{4:4}, at: em28xx_release_resources+0x75/0x240 drivers/media/usb/em28xx/em28xx-cards.c:3796

but task is already holding lock:
ffff88801cd25cf0 (&dev->lock#3){+.+.}-{4:4}, at: em28xx_v4l2_fini+0xb7/0x3f0 drivers/media/usb/em28xx/em28xx-video.c:2431

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&dev->lock#3);
  lock(&dev->lock#3);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

locks held by kworker/0:3/5059: 6, last CPU#0:
 #0: ffff8881032cb948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff8881032cb948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff8881032cb948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #0: ffff8881032cb948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #1: ffffc900036cfc40 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc900036cfc40 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc900036cfc40 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #1: ffffc900036cfc40 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #2: ffff88816eeb71d8 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1109 [inline]
 #2: ffff88816eeb71d8 (&dev->mutex){....}-{4:4}, at: hub_event+0x184/0x4d30 drivers/usb/core/hub.c:5917
 #3: ffff88801cdfc1d8 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1109 [inline]
 #3: ffff88801cdfc1d8 (&dev->mutex){....}-{4:4}, at: usb_disconnect+0xfc/0x9a0 drivers/usb/core/hub.c:2346
 #4: ffff88801ce5a1a0 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1109 [inline]
 #4: ffff88801ce5a1a0 (&dev->mutex){....}-{4:4}, at: __device_driver_lock drivers/base/dd.c:1046 [inline]
 #4: ffff88801ce5a1a0 (&dev->mutex){....}-{4:4}, at: device_release_driver_internal+0xa9/0x7d0 drivers/base/dd.c:1377
 #5: ffff88801cd25cf0 (&dev->lock#3){+.+.}-{4:4}, at: em28xx_v4l2_fini+0xb7/0x3f0 drivers/media/usb/em28xx/em28xx-video.c:2431

stack backtrace:
CPU: 0 UID: 0 PID: 5059 Comm: kworker/0:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x27a/0x290 kernel/locking/lockdep.c:3085
 check_deadlock kernel/locking/lockdep.c:3137 [inline]
 validate_chain kernel/locking/lockdep.c:3939 [inline]
 __lock_acquire+0x25db/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
 em28xx_release_resources+0x75/0x240 drivers/media/usb/em28xx/em28xx-cards.c:3796
 em28xx_usb_disconnect+0x19f/0x2f0 drivers/media/usb/em28xx/em28xx-cards.c:4493
 usb_unbind_interface+0x295/0x9c0 drivers/usb/core/driver.c:460
 device_remove drivers/base/dd.c:619 [inline]
 __device_release_driver drivers/base/dd.c:1357 [inline]
 device_release_driver_internal+0x48d/0x7d0 drivers/base/dd.c:1380
 bus_remove_device+0x444/0x560 drivers/base/bus.c:678
 device_del+0x524/0x8f0 drivers/base/core.c:3967
 usb_disable_device+0x3d4/0x8d0 drivers/usb/core/message.c:1484
 usb_disconnect+0x346/0x9a0 drivers/usb/core/hub.c:2355
 hub_port_connect drivers/usb/core/hub.c:5425 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5725 [inline]
 port_event drivers/usb/core/hub.c:5889 [inline]
 hub_event+0x1bbb/0x4d30 drivers/usb/core/hub.c:5971
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
[drifabdelmalekmohamedsaid@gmail.com hverkuil@kernel.org linux-kernel@vger.kernel.org linux-media@vger.kernel.org linux-usb@vger.kernel.org mchehab@kernel.org stable@vger.kernel.org syzbot@syzkaller.appspotmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

