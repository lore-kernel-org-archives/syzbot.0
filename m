Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE843AA1B6
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 07:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780040270; cv=none; b=YhX9/FtqjHz4T9HHVamlZ8vxhFjXUvnvEYkrT1n4LbRkmchlZ352DizvzNKfX7OXvM8w/pRGpVYu7ViUiWb7UbyIdkFW7SGdeJ7j6Cmw9drBi/UvxBDQNm+bl4/GX93Jm0kNSzyXVVFkwO03ko6EQIo9KdLCn1047kMNObj3VuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780040270; c=relaxed/simple;
	bh=o9FFGmmzvKGeGlBCUepVUrqPRudOlFOZYWU+UC64Rbw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=VKWTYkls+ZhhDIImtb5R8FesVRVnFOesH8V4zT3jOeiyu+0uvansvptbJOgmgxx3knvRlmB6hbSJMzbOqXu0ppJVcDMz21RbY/675B+p8YfdzRRbvVQ58hwevY/jzS7YXYOnFAUfBhMj2r3ZiIOufXs9q2JSUOrghw7EfAx8WpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-69e0757d642so108393eaf.3
        for <syzbot@lists.linux.dev>; Fri, 29 May 2026 00:37:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780040268; x=1780645068;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i1p+0APlJE3xHuDJW4F3x2lobM8xVhqbhr5STcmqeRI=;
        b=L+kBKnoJ/mnHSsnPly/Lfs+N3FJQvm/I/bMddwfjbe+lKRRH8WBa5tNQ1dwkaOK57S
         WDt9TFcvQHv1V1nyVNx2OH8vuihOq+MlGUgd2fX/vgacPyl9JBlE/X38su6h1LC/X7eH
         +27Eo2UCQKi/SvnLkSmPBZisZPSepPhl+zkR1gmo2BDQUmpDA6X0Dq3PI+vOrIP9RZ0w
         9+yVdq2BgGFVD/7sXgEY+O/n9fy26nv73igSNOwr5CuG16FOQeMKcZRcD+xK9rzSTeIX
         TniLwniGcKowLfks0S3pUZg5X0W2U4764i4OSj6ZzjMuWw0vOkVmWnIz4qvAFbHFKur7
         tuRQ==
X-Gm-Message-State: AOJu0Yz+G9lsQh+mQc9fcMjeEO2RipiQZtlnkND7AnHkFJw7pq4yPUJE
	SAzwlnRHIasmUryegzZdfGr7Ed/ECejy0d6A30maoI8NbJpVRpN0B2oJDQUjedNZ1AE8j2XN68+
	WATwhTDB7skGjOInaOv9iTNaFTbx+FjqOAJnlG8ysJXO0GGlWwR3RN0UGiBI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4d48:b0:69d:8f47:f66e with SMTP id
 006d021491bc7-69e03fd5502mr767885eaf.35.1780040268211; Fri, 29 May 2026
 00:37:48 -0700 (PDT)
Date: Fri, 29 May 2026 00:37:48 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a19424c.c16d89a8.217f2c.0000.GAE@google.com>
Subject: [moderation/CI] Re: net: ethtool: let ops locked drivers run without rtnl_lock
From: syzbot ci <syzbot+ci25217633374424a6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: ethtool: let ops locked drivers run without rtnl_lock
https://lore.kernel.org/all/20260528231637.251822-1-kuba@kernel.org
* [PATCH net-next 01/14] net: ethtool: cmis_cdb: hold instance lock for ops=
 locked devices
* [PATCH net-next 02/14] net: ethtool: make sure __ethtool_get_link_ksettin=
gs() is ops-locked
* [PATCH net-next 03/14] net: ethtool: serialize broadcast notification seq=
uence allocation
* [PATCH net-next 04/14] net: ethtool: relax ethnl_req_get_phydev() locking=
 assertion
* [PATCH net-next 05/14] net: ethtool: make dev->hwprov ops-protected
* [PATCH net-next 06/14] net: ethtool: optionally skip rtnl_lock on Netlink=
 path for GET ops
* [PATCH net-next 07/14] net: ethtool: optionally skip rtnl_lock on Netlink=
 path for SET ops
* [PATCH net-next 08/14] net: ethtool: optionally skip rtnl_lock in cable t=
est handlers
* [PATCH net-next 09/14] net: ethtool: optionally skip rtnl_lock in ethnl_t=
sinfo_dumpit()
* [PATCH net-next 10/14] net: ethtool: optionally skip rtnl_lock in ethnl_a=
ct_module_fw_flash()
* [PATCH net-next 11/14] net: ethtool: optionally skip rtnl_lock in RSS con=
text handlers
* [PATCH net-next 12/14] net: ethtool: ioctl: concentrate the locking
* [PATCH net-next 13/14] net: ethtool: optionally skip rtnl_lock on IOCTL p=
ath
* [PATCH net-next 14/14] docs: net: ethtool: document ops-locked drivers an=
d op_needs_rtnl

and found the following issue:
possible deadlock in __ethtool_get_link_ksettings

Full report is available here:
https://ci.syzbot.org/series/ada8852f-9efd-4b85-87aa-2f5d8fe16040

***

possible deadlock in __ethtool_get_link_ksettings

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      9a82e387e27a4422a0d2d9d644180b7bd913e85a
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2968208d-6483-4d38-be45-de68d3b9477=
5/config
syz repro: https://ci.syzbot.org/findings/d8670aa1-9241-49be-8108-cdbed56dd=
4a5/syz_repro

dummy0: entered promiscuous mode
bridge0: port 3(dummy0) entered blocking state
bridge0: port 3(dummy0) entered forwarding state
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz.1.28/5852 is trying to acquire lock:
ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock in=
clude/linux/netdevice.h:2833 [inline]
ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock_op=
s include/net/netdev_lock.h:42 [inline]
ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: __ethtool_get_=
link_ksettings+0x12b/0x290 net/ethtool/ioctl.c:462

but task is already holding lock:
ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock in=
clude/linux/netdevice.h:2833 [inline]
ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock_op=
s include/net/netdev_lock.h:42 [inline]
ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: do_setlink+0x3=
d2/0x45a0 net/core/rtnetlink.c:3117
and the lock comparison function returns 0:

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&dev_instance_lock_key#3);
  lock(&dev_instance_lock_key#3);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz.1.28/5852:
 #0: ffffffff8fdd2d80 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtne=
tlink.c:80 [inline]
 #0: ffffffff8fdd2d80 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core=
/rtnetlink.c:341 [inline]
 #0: ffffffff8fdd2d80 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_setlink+0x6bb/0xb4=
0 net/core/rtnetlink.c:3527
 #1: ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lo=
ck include/linux/netdevice.h:2833 [inline]
 #1: ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lo=
ck_ops include/net/netdev_lock.h:42 [inline]
 #1: ffff888115f78dc8 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: do_setlin=
k+0x3d2/0x45a0 net/core/rtnetlink.c:3117

stack backtrace:
CPU: 0 UID: 0 PID: 5852 Comm: syz.1.28 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x1a3/0x1550 kernel/locking/mutex.c:820
 netdev_lock include/linux/netdevice.h:2833 [inline]
 netdev_lock_ops include/net/netdev_lock.h:42 [inline]
 __ethtool_get_link_ksettings+0x12b/0x290 net/ethtool/ioctl.c:462
 port_cost+0xc0/0x3a0 net/bridge/br_if.c:39
 br_port_carrier_check+0x12d/0x3f0 net/bridge/br_if.c:80
 br_device_event+0x65c/0x970 net/bridge/br.c:101
 notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
 __dev_notify_flags+0x248/0x310 net/core/dev.c:9804
 netif_change_flags+0xe8/0x1a0 net/core/dev.c:9819
 do_setlink+0xfa5/0x45a0 net/core/rtnetlink.c:3207
 rtnl_setlink+0x792/0xb40 net/core/rtnetlink.c:3537
 rtnetlink_rcv_msg+0x7d5/0xbe0 net/core/rtnetlink.c:7062
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f087ad9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f087bc25028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f087b015fa0 RCX: 00007f087ad9ce59
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000004
RBP: 00007f087ae32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f087b016038 R14: 00007f087b015fa0 R15: 00007ffcefdf0348
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[andrew@lunn.ch danieller@nvidia.com davem@davemloft.net edumazet@google.co=
m ernis@linux.microsoft.com haiyangz@microsoft.com horms@kernel.org idosch@=
nvidia.com joshwash@google.com kory.maincent@bootlin.com kuba@kernel.org li=
nux@armlinux.org.uk maxime.chevallier@bootlin.com michael.chan@broadcom.com=
 netdev@vger.kernel.org pabeni@redhat.com sdf.kernel@gmail.com tariqt@nvidi=
a.com willemb@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

