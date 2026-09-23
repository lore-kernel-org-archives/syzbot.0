Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9E1190462
	for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 23:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790207128; cv=none; b=JYiAg9PDwUOk43xSWt0l9RDOn47xh60ZCC9SvSis5ZleAeseUhwdXakrdgXOOusbjHOBNxdk30f8wwR7+GDaNQLtOTQW99O5GY9E5oC7x+z8RVENJZoKsU5EY0zBceo4HpOU9OBPABIAd8ISpHuubCe/f+T3eqUHCHswp6WADyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790207128; c=relaxed/simple;
	bh=u/+wDkGJltWumsjeaxDGBphgwn51/Et0KmVtqq6cS20=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Oy39P7yl/6MHWsSV/lFOi60M3+pbokg2aLAypm4hoTRkwDxUKKyhm1vjU3jUGQpp6OUSZb7i45ptYJjDI4hb8hW8M3IJRFrXVuGlGFrISdY+JeHNmtG2XRmfbK6xlAn0ydkjmlfsRr5h9xijh0grCBfRoYEv0pjUaCry5k5kbwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b597558c4cso2471666b6e.1
        for <syzbot@lists.linux.dev>; Wed, 23 Sep 2026 16:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790207125; x=1790811925;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wRJAAu0X6+FDi/eds3na8DnMlNEpAUQJgh7l9+DMlDU=;
        b=RNSNsLyUSl3RXW4yGXksLZ4PZWN0Il9oxomiitUuBbFmZoJutvT6yFu1fQfeHvsg8E
         vWEWeR6+6T1x1ZGb7XTpa1eHDsnC/xOqIXgJd3Z++0cQgKGYon6GVHdpRioEw3ru4ELD
         B7jN+5to3+wVFmKv44LUeqFh/Oiv5lVwL2ri4rHZT11nQswOvnWhWGtJ/cwftMah2aFW
         AKgxWVxvA3ogseNQPIVcNZho20eEmUZmX8zo+5KKZbqZ4+TtQbZac2csQ35NTglmHLK4
         7li51kH9eouZv6RPaeNfgBRqjvkFcy5o5Gse+jm3zs18vjEH9cpVN/cJnIVBlEX2WbJZ
         M3Dw==
X-Gm-Message-State: AFuF++lmgNlcF70pCrXmAgbOHAdKsc9VQZDDAwBFGu8jq7m6FlQEiCjP
	oTS6mBOhLJpQM+dGHEPigpmJIYbPbOyreDoKBvzWpALgZv1QXYYpv9GwW7wwnX5YcgJ2Du7Sd9e
	EAnotBtE5jC1MSgiYkOkexvWTYqSvZyuEHBVPlyAIuCtHMqavLh2HriwyL8s=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2396:b0:4c2:2fb4:3676 with SMTP id
 5614622812f47-4d729123773mr1046014b6e.16.1790207125382; Wed, 23 Sep 2026
 16:45:25 -0700 (PDT)
Date: Wed, 23 Sep 2026 16:45:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab46495.fb6b21f1.1b3075.0006.GAE@google.com>
Subject: [moderation/CI] Re: net: opt loopback into instance locking
From: syzbot ci <syzbot+ci2e26614b55697582@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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
AI triage: https://ci.syzbot.org/findings/6bb35d14-7fe7-4d73-9528-891c80cf7f1c/triage_trajectory

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

The email will later be sent to:
[andrew@lunn.ch davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

