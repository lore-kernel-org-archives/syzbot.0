Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220B63E3C48
	for <syzbot@lists.linux.dev>; Mon, 13 Apr 2026 19:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776109764; cv=none; b=Uvdewvs92aUnfwK2vBpqirl+cyYvTQps8B/IWCqkzFv3VYHe2nxE+PZ8U07T3+zMCLq4wHZNztBe3S9nSlJagkjQWUidUMeayuMkSSzp1ys0uNtDvmkNdDz0IhMrxQi6IRxYsfqswRu2xBOWvKCTvcYoe4+fjr10bgKgOxqt7zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776109764; c=relaxed/simple;
	bh=moVbajI93ylbX6Hc5sdUyOa//mRwUHngn4c2aF7DVXc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=HTBFEvIITUx/a7Yr1ozdAVS06z+E8IGedp6tTnwAT71ip2nMtcC5xlcTd2gR6iBhQLsvTKW2TciN77tqA6QzDbkF0p2HTr0//wYVU354W08eMC04P8GvfBQsEgs2POCOxQ05rldSVmpj8jIqkZ75sYIX7wwpMdZTM6mmD6u7cH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-42342b79ae4so8227184fac.1
        for <syzbot@lists.linux.dev>; Mon, 13 Apr 2026 12:49:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776109762; x=1776714562;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wwIjK5znXEGb3Qzj4YtcJUWny7RW6O0EuDhuQVd9AfU=;
        b=HBTriTTgw4G7Qq3WN0rYq4DCLYQTusEFeziGVsJOJm0etn/sHHV/0k2u9JlBlHSgHF
         j3Tntd2wQ6O19n4nFZjVu4CUN08b3GMJQlDIBR0r7lKZ+EvQNWqmyamCh3kCF/HCSx9W
         FHyp7KH9wk/w9py8YpAj7W9KJh5ui6A5kWyhaTYFxrOD91rew5S5YQXD6B3Vr3BeRi6m
         7bZkaAcmsEsj9Vrf5y18mwDVjKjWBt36aUCyWVrXwbXF0EYZJog+g1NzTR4Gn2Bt2p/M
         ji6lTJOBpkDVHWsIFAeEoAgSlx8OCq3uYKixjcmhSGURGXj62DmJFMFushBJxZt94pTo
         zsuA==
X-Gm-Message-State: AOJu0YwlRT7BD5LClesZ2ryYULJshxuWPInEbM6JVhxT/lApzfp0Ejwi
	AWNTi5RjDUhw/IQdX+NPQqHWSqvRcHUt9woQt3XESFJ8Rj6Djo7MLw1gPdOSeOhnNXsF3AwEe3Q
	X3cmIouAm5xp2xPSmBY8QORiOvnQv0tE3sQ9axa2voOWEV32J7zz108DAe3M=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2908:b0:67e:1887:34b4 with SMTP id
 006d021491bc7-68be8dd14dfmr7132661eaf.58.1776109762119; Mon, 13 Apr 2026
 12:49:22 -0700 (PDT)
Date: Mon, 13 Apr 2026 12:49:22 -0700
In-Reply-To: <20260413094442.1376022-1-hawk@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69dd48c2.a00a0220.468cb.004e.GAE@google.com>
Subject: [syzbot ci] Re: veth: add Byte Queue Limits (BQL) support
From: syzbot ci <syzbot+cib904ea9ebb647254@syzkaller.appspotmail.com>
To: andrew@lunn.ch, ast@kernel.org, bpf@vger.kernel.org, corbet@lwn.net, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	frederic@kernel.org, hawk@kernel.org, horms@kernel.org, 
	j.koeppeler@tu-berlin.de, jhs@mojatatu.com, jiri@resnulli.us, 
	john.fastabend@gmail.com, kernel-team@cloudflare.com, krikku@gmail.com, 
	kuba@kernel.org, kuniyu@google.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, sdf@fomichev.me, shuah@kernel.org, 
	skhan@linuxfoundation.org, yajun.deng@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] veth: add Byte Queue Limits (BQL) support
https://lore.kernel.org/all/20260413094442.1376022-1-hawk@kernel.org
* [PATCH net-next v2 1/5] net: add dev->bql flag to allow BQL sysfs for IFF_NO_QUEUE devices
* [PATCH net-next v2 2/5] veth: implement Byte Queue Limits (BQL) for latency reduction
* [PATCH net-next v2 3/5] veth: add tx_timeout watchdog as BQL safety net
* [PATCH net-next v2 4/5] net: sched: add timeout count to NETDEV WATCHDOG message
* [PATCH net-next v2 5/5] selftests: net: add veth BQL stress test

and found the following issue:
WARNING in veth_napi_del_range

Full report is available here:
https://ci.syzbot.org/series/ee732006-8545-4abd-a105-b4b1592a7baf

***

WARNING in veth_napi_del_range

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      8806d502e0a7e7d895b74afbd24e8550a65a2b17
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/90743a26-f003-44cf-abcc-5991c47588b2/config
syz repro: https://ci.syzbot.org/findings/d068bfb2-9f8b-466a-95b4-cd7e7b00006c/syz_repro

------------[ cut here ]------------
index >= dev->num_tx_queues
WARNING: ./include/linux/netdevice.h:2672 at netdev_get_tx_queue include/linux/netdevice.h:2672 [inline], CPU#0: syz.1.27/6002
WARNING: ./include/linux/netdevice.h:2672 at veth_napi_del_range+0x3b7/0x4e0 drivers/net/veth.c:1142, CPU#0: syz.1.27/6002
Modules linked in:
CPU: 0 UID: 0 PID: 6002 Comm: syz.1.27 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:netdev_get_tx_queue include/linux/netdevice.h:2672 [inline]
RIP: 0010:veth_napi_del_range+0x3b7/0x4e0 drivers/net/veth.c:1142
Code: 00 e8 ad 96 69 fe 44 39 6c 24 10 74 5e e8 41 61 44 fb 41 ff c5 49 bc 00 00 00 00 00 fc ff df e9 6d ff ff ff e8 2a 61 44 fb 90 <0f> 0b 90 42 80 3c 23 00 75 8e eb 94 48 8b 0c 24 80 e1 07 80 c1 03
RSP: 0018:ffffc90003adf918 EFLAGS: 00010293
RAX: ffffffff86814ec6 RBX: 1ffff110227a6c03 RCX: ffff888103a857c0
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000002
RBP: 1ffff110227a6c9a R08: ffff888113f01ab7 R09: 0000000000000000
R10: ffff888113f01a98 R11: ffffed10227e0357 R12: dffffc0000000000
R13: 0000000000000002 R14: 0000000000000002 R15: ffff888113d36018
FS:  000055555ea16500(0000) GS:ffff88818de4a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efc287456b8 CR3: 000000010cdd0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 veth_napi_del drivers/net/veth.c:1153 [inline]
 veth_disable_xdp+0x1b0/0x310 drivers/net/veth.c:1255
 veth_xdp_set drivers/net/veth.c:1693 [inline]
 veth_xdp+0x48e/0x730 drivers/net/veth.c:1717
 dev_xdp_propagate+0x125/0x260 net/core/dev_api.c:348
 bond_xdp_set drivers/net/bonding/bond_main.c:5715 [inline]
 bond_xdp+0x3ca/0x830 drivers/net/bonding/bond_main.c:5761
 dev_xdp_install+0x42c/0x600 net/core/dev.c:10387
 dev_xdp_detach_link net/core/dev.c:10579 [inline]
 bpf_xdp_link_release+0x362/0x540 net/core/dev.c:10595
 bpf_link_free+0x103/0x480 kernel/bpf/syscall.c:3292
 bpf_link_put_direct kernel/bpf/syscall.c:3344 [inline]
 bpf_link_release+0x6b/0x80 kernel/bpf/syscall.c:3351
 __fput+0x44f/0xa70 fs/file_table.c:469
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5bda39c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdca2969e8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007f5bda617da0 RCX: 00007f5bda39c819
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 00007f5bda617da0 R08: 00007f5bda616128 R09: 0000000000000000
R10: 000000000003fd78 R11: 0000000000000246 R12: 0000000000010fb8
R13: 00007f5bda61609c R14: 0000000000010cdd R15: 00007ffdca296af0
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
