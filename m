Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EF62E62A4
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 02:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790217607; cv=none; b=e8iFrTYypE6b16Ip9BSToI9VThDGwHSD/8o8NJfxyDARWXbB1VJNOa9Pr5qaoRcI765Gv3FUS5p14aaX9MFsCyjp07S1geZ9Mi7gy0l7/HG8jEzB7B0jL3hcYgAJjp+//78WEPHQM2Pqou4crwgb92Amr5pjW7Oj6xfbXLaprdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790217607; c=relaxed/simple;
	bh=yV6pjCSlYRT6JtcFhnQRGIxD8BtfoAZxB46rzsh1PxQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XC0rQf9/bjd8q04fgTsXgE3+/8pyXtvuEvWJ+WZ15v4hyrNTaiaKfVvZGYiaw9+I4bPcDo9XvFW6pxiENKkSEF47oyVLlRw8qfgchdKXT2MpJ00K42rjHj/yU8y0gec+nDPLA4FyO0YmudPuG5s4Pzx+UqxxweD2z1/S9I1W5lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b2d1eb484aso2378816b6e.2
        for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 19:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790217604; x=1790822404;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=StS9OIZCYw859A7arXPkaHNXNgNmFYZTu2EFx7mDAMA=;
        b=oZGW22N2f+4tAY5moBbBbPuv8hGExcOuw4gn0potLLPIQlZninYKG4FqgzEXJpf6ip
         16hfSCQd6p9VK8jZPcVqVDL2Hf40yZ4hxurh0AKgDmpOVcdiVUwbbWzjf0F+yFGwGEWN
         JnN01XWnBAQMv6uVvAUwjYyKrlZh2eD2MYn/hPC+qnxEWsK6SVliqveee5z4BHYT3sFK
         E7WE8vem4hh6bt1Vq+a8I+ASuuOIG7aSydw5E9MARdLmf17apwrJjslfBo+wZQJpUm9Z
         Nj5Yy/nfbW1/Q48r0GsXtIxJ0FvepKenLuORb2i3jKzjUvxL6DsJxZ3f9BjBzpWPT+ce
         +JlA==
X-Gm-Message-State: AFuF++lUvqLN7NktD4NhxaEznOZCJzyWwGOYR/5kELAdaOvGY1zGW6C4
	I6AVld1h3Ut13ITBnqmvg2VdBM13oYpCcRnM6LjNQ0a2mTdpl+wfqQxCzEUF4J7KcEE1qAoXbRt
	F2CcA95JrPLR6J264Bgi5y+robo7XkP+1tIZYQsapA+xUHWcz4lFa4Dl1t1I=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fc7:b0:4d6:9153:296a with SMTP id
 5614622812f47-4d72b93ddf9mr1428058b6e.59.1790217604658; Wed, 23 Sep 2026
 19:40:04 -0700 (PDT)
Date: Wed, 23 Sep 2026 19:40:04 -0700
In-Reply-To: <20260921190452.1467853-1-kuba@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab48d84.80e1c6cc.1e8e5f.0008.GAE@google.com>
Subject: [syzbot ci] Re: net: opt loopback into instance locking
From: syzbot ci <syzbot+ci1dad0f1efd4a4fc7@syzkaller.appspotmail.com>
To: andrew@lunn.ch, davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] net: opt loopback into instance locking
https://lore.kernel.org/all/20260921190452.1467853-1-kuba@kernel.org
* [PATCH net-next v2] net: opt loopback into instance locking

and found the following issue:
possible deadlock in default_device_exit_batch

Full report is available here:
https://ci.syzbot.org/series/23f51d46-5d1a-4839-a0a8-35d88361ffdb

***

possible deadlock in default_device_exit_batch

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      944ae66642b726bd6b25ae71b1e9ff88a0e0bdb0
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/014063b0-7001-43f1-aa04-57649607febc/config

batman_adv: batadv0: Removing interface: batadv_slave_0
batman_adv: batadv0: Removing interface: batadv_slave_1
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kworker/u8:3/5652 is trying to acquire lock:
ffff88811671ae70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: unregister_netdevice_many_notify+0x5bb/0x2140

but task is already holding lock:
ffff88816d8dae70 (&dev_instance_lock_key){+.+.}-{4:4}, at: unregister_netdevice_many_notify+0x5bb/0x2140

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&dev_instance_lock_key){+.+.}-{4:4}:
       __mutex_lock+0x19d/0x1550
       unregister_netdevice_many_notify+0x5bb/0x2140
       default_device_exit_batch+0x6d4/0x760
       ops_undo_list+0x4b4/0x8d0
       cleanup_net+0x572/0x810
       process_scheduled_works+0xc3d/0x1630
       worker_thread+0xa47/0xfb0
       kthread+0x38b/0x480
       ret_from_fork+0x514/0xb70
       ret_from_fork_asm+0x1a/0x30

-> #0 (&dev_instance_lock_key#3){+.+.}-{4:4}:
       __lock_acquire+0x164c/0x2de0
       lock_acquire+0x115/0x350
       __mutex_lock+0x19d/0x1550
       unregister_netdevice_many_notify+0x5bb/0x2140
       default_device_exit_batch+0x6d4/0x760
       ops_undo_list+0x4b4/0x8d0
       cleanup_net+0x572/0x810
       process_scheduled_works+0xc3d/0x1630
       worker_thread+0xa47/0xfb0
       kthread+0x38b/0x480
       ret_from_fork+0x514/0xb70
       ret_from_fork_asm+0x1a/0x30

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&dev_instance_lock_key);
                               lock(&dev_instance_lock_key#3);
                               lock(&dev_instance_lock_key);
  lock(&dev_instance_lock_key#3);

 *** DEADLOCK ***

locks held by kworker/u8:3/5652: 6, last CPU#1:
 #0: ffff8881012d5940 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc9000481fc40 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff90244f08 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf5/0x810
 #3: ffffffff90253760 (rtnl_mutex){+.+.}-{4:4}, at: default_device_exit_batch+0xd0/0x760
 #4: ffff888120c40e70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: unregister_netdevice_many_notify+0x5bb/0x2140
 #5: ffff88816d8dae70 (&dev_instance_lock_key){+.+.}-{4:4}, at: unregister_netdevice_many_notify+0x5bb/0x2140

stack backtrace:
CPU: 1 UID: 0 PID: 5652 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 print_circular_bug+0x2e2/0x300
 check_noncircular+0x12f/0x150
 __lock_acquire+0x164c/0x2de0
 lock_acquire+0x115/0x350
 __mutex_lock+0x19d/0x1550
 unregister_netdevice_many_notify+0x5bb/0x2140
 default_device_exit_batch+0x6d4/0x760
 ops_undo_list+0x4b4/0x8d0
 cleanup_net+0x572/0x810
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
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
