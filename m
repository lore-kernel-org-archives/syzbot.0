Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D136635F16F
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 14:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773325534; cv=none; b=pVhntaDLlhbqFan1kE+YKvQMAEr55hBjKsAdJsZzGoWCQs7X2ddFhBix8sIBQS+upmmm9YS5RgoPlFR79SGNzkZIWaED6BMBxgVnMhlSzjO0JCYojXaoDxUbwG6QNE/tvLMDBV9bJ94sw6oz6UcD9fe0G3PQIQpD6N47p3AWezQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773325534; c=relaxed/simple;
	bh=wEEX32HNF4eC6ZqK+UZyrhwFbD3xj9KBmKHoZcAA3Tg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=dLaqbTYf0iBl09lLw9tkeAhou8E7jGePsHZ8nRsSfgQVr3oM+/Baa+a7jS5ilfWh855vIKzlNDG/TADrSxo2lbeKogq4F2/6tiiJfo7KjHQei3XE5h1u/2sfncr16LqG+upJ9fogtKjYcsSN52sI8QeyTWvO3xKH67Je+6MMgz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67bbb4e5f24so8802284eaf.0
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 07:25:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773325531; x=1773930331;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vvi6o3jTpKg6DoplUul6SzeK3oqTYdsvs/NFs0n1/0I=;
        b=Xr7gfVzSQZ8yBqxCJWeiqnACOBMzyTPxhkAOtX8yQxW9hMkYlG7XvfT3vXVJVJX//K
         IC/TBKjFYJVtrJmLjX5+BFP0MdhZdH8ElTET6dwK5huFyBi0X0IUZZv9kwdGeoiPsVeW
         Q3avJS7b5AqzsaG4TZ/GJLY83TC+85hp4g4fiF3nRBy7G1eUKFOr8cgj915R7E+wo4bO
         E91QJjwexqB0/38i2yNs3pnZWpDsGcnEmDRmxmCNGMA+l6JnA5C9BUAL+Hxn7MExOaus
         t9QhuEUARU2gjaMMQtWz2mkXmxSAgzpsM4dCi1Jrk0tcsJVWIuka8B9IOEejVtXmvj+1
         k8UQ==
X-Gm-Message-State: AOJu0Ywfqz36syGFB+haavHku0/qZQL80hWOfkoE7Fs3jNIMFQTWVNbs
	JSA22LvzA+I3ytM1wj1eqNciXbCObKbK50lHQYD6WiZWC1l6qi4yKzEUjUkM7ZJkIZ7n9kHFUhT
	YKfyh0AF6PA/tBLAOU/ny141cw/sqXK7mqXa1wq5VtWsstfDjyueZoWrpt9c=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:174c:b0:679:e732:7bda with SMTP id
 006d021491bc7-67bc8892accmr3800871eaf.13.1773325531682; Thu, 12 Mar 2026
 07:25:31 -0700 (PDT)
Date: Thu, 12 Mar 2026 07:25:31 -0700
In-Reply-To: <20260311230730.163348-1-greearb@candelatech.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b2ccdb.a00a0220.707e5.0016.GAE@google.com>
Subject: [syzbot ci] Re: iwlwifi + mac80211 stability
From: syzbot ci <syzbot+cibf86f11719f1261d@syzkaller.appspotmail.com>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] iwlwifi + mac80211 stability
https://lore.kernel.org/all/20260311230730.163348-1-greearb@candelatech.com
* [PATCH wireless-next 01/28] wifi: iwlwifi: mld:  Check for NULL before lookup.
* [PATCH wireless-next 02/28] wifi: iwlwifi: mld: Fix un-set return value in error case.
* [PATCH wireless-next 03/28] wifi: iwlwifi: mld: Add check for null vif in stats callback.
* [PATCH wireless-next 04/28] wifi: mac80211:  Check debugfs creation return values.
* [PATCH wireless-next 05/28] wifi: mac80211: do not fail taking sta to lower state.
* [PATCH wireless-next 06/28] wifi: mac80211: Mark sta as uploaded if single transition succeeds.
* [PATCH wireless-next 07/28] wifi: mac80211:  Fix use-after-free of debugfs inodes.
* [PATCH wireless-next 08/28] wifi: mac80211: Debugfs safety checks.
* [PATCH wireless-next 09/28] wifi: mac80211: Use warn-on-once in drv_remove_chanctxt
* [PATCH wireless-next 10/28] wifi: mac80211: Ensure sta debugfs is not double-freed.
* [PATCH wireless-next 11/28] wifi: iwlwifi: mld: Fix stale reference in fw_id_to_link_sta
* [PATCH wireless-next 12/28] wifi: iwlwifi: mld:  Improve logging in error cases.
* [PATCH wireless-next 13/28] wifi: iwlwifi: mld: Remove warning about BAID.
* [PATCH wireless-next 14/28] wifi: mac80211: Add dmesg log regarding warn-on in drv-stop.
* [PATCH wireless-next 15/28] wifi: iwlwifi: mld: Fix use-after-free of bss_conf
* [PATCH wireless-next 16/28] wifi: iwlwifi: mld: Check for null in iwl_mld_wait_sta_txqs_empty
* [PATCH wireless-next 17/28] wifi: iwlwifi: mld: use warn-on-once in error path.
* [PATCH wireless-next 18/28] wifi: iwlwifi: mld: Use warn-on-once in emlsr exit logic.
* [PATCH wireless-next 19/28] wifi: iwlwifi: mld: Improve error message in rx path.
* [PATCH wireless-next 20/28] wifi: iwlwifi: mld: Improve logging message.
* [PATCH wireless-next 21/28] wifi: iwlwifi: mld: Protect from null mld_sta
* [PATCH wireless-next 22/28] wifi: mac80211: Add force-cleanup call to driver.
* [PATCH wireless-next 23/28] wifi: iwlwifi: mld: Support force-cleanup op
* [PATCH wireless-next 24/28] wifi: iwlwifi: mld: Fix NPE in flush logic.
* [PATCH wireless-next 25/28] wifi: iwlwifi: mld: Fix bad return address in tx code.
* [PATCH wireless-next 26/28] wifi: mac80211: Ensure link work-items are only initialized once.
* [PATCH wireless-next 27/28] wifi: iwlwifi: mld: Convert to WARN_ONCE in link removal path.
* [PATCH wireless-next 28/28] wifi: mac80211: Decrease WARN spam.

and found the following issue:
WARNING in drv_add_interface

Full report is available here:
https://ci.syzbot.org/series/d3986751-1907-410b-b80c-976f38583b8c

***

WARNING in drv_add_interface

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      97492c019da4b62df83255e968b23b81c0315530
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/acf234a5-5041-402a-ace9-5766b71cadb4/config
C repro:   https://ci.syzbot.org/findings/1533841d-c00d-4811-84c1-419f7bccc86a/c_repro
syz repro: https://ci.syzbot.org/findings/1533841d-c00d-4811-84c1-419f7bccc86a/syz_repro

------------[ cut here ]------------
!sdata->vif.debugfs_dir
WARNING: net/mac80211/driver-ops.h:510 at drv_vif_add_debugfs net/mac80211/driver-ops.h:510 [inline], CPU#1: dhcpcd/5553
WARNING: net/mac80211/driver-ops.h:510 at drv_add_interface+0x5e5/0x910 net/mac80211/driver-ops.c:84, CPU#1: dhcpcd/5553
Modules linked in:
CPU: 1 UID: 0 PID: 5553 Comm: dhcpcd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:drv_vif_add_debugfs net/mac80211/driver-ops.h:510 [inline]
RIP: 0010:drv_add_interface+0x5e5/0x910 net/mac80211/driver-ops.c:84
Code: f3 fa ff ff e8 9c 22 ae f6 48 8d 3d 85 f2 0a 05 67 48 0f b9 3a e9 c1 fc ff ff e8 86 22 ae f6 e9 19 fb ff ff e8 7c 22 ae f6 90 <0f> 0b 90 eb 94 e8 71 22 ae f6 4c 8d 35 7a f2 0a 05 49 8d bf 28 0a
RSP: 0018:ffffc90003b57678 EFLAGS: 00010293
RAX: ffffffff8b1776f4 RBX: ffff888172594dc0 RCX: ffff8881165657c0
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000006
RBP: 0000000000000000 R08: ffffffff901146b7 R09: 1ffffffff20228d6
R10: dffffc0000000000 R11: fffffbfff20228d7 R12: dffffc0000000000
R13: ffff888172597028 R14: ffff8881725957f8 R15: 0000000000000002
FS:  00007ff45a6f6740(0000) GS:ffff8882a9465000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d00b0c3161 CR3: 000000010017c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ieee80211_do_open+0x929/0x2490 net/mac80211/iface.c:1466
 ieee80211_open+0x15b/0x200 net/mac80211/iface.c:472
 __dev_open+0x44d/0x830 net/core/dev.c:1702
 __dev_change_flags+0x1f7/0x690 net/core/dev.c:9778
 netif_change_flags+0x88/0x1a0 net/core/dev.c:9841
 dev_change_flags+0x130/0x260 net/core/dev_api.c:68
 devinet_ioctl+0x9f2/0x1b30 net/ipv4/devinet.c:1199
 inet_ioctl+0x42a/0x560 net/ipv4/af_inet.c:1004
 sock_do_ioctl+0x101/0x320 net/socket.c:1253
 sock_ioctl+0x5c6/0x7f0 net/socket.c:1374
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff45a7c4d49
Code: 5c c3 48 8d 44 24 08 48 89 54 24 e0 48 89 44 24 c0 48 8d 44 24 d0 48 89 44 24 c8 b8 10 00 00 00 c7 44 24 b8 10 00 00 00 0f 05 <41> 89 c0 3d 00 f0 ff ff 76 10 48 8b 15 ae 60 0d 00 f7 d8 41 83 c8
RSP: 002b:00007ffff8603cd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ff45a6f66c0 RCX: 00007ff45a7c4d49
RDX: 00007ffff8613ec8 RSI: 0000000000008914 RDI: 0000000000000011
RBP: 00007ffff8624088 R08: 00007ffff8613e88 R09: 00007ffff8613e38
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffff8613ec8 R14: 0000000000000028 R15: 0000000000008914
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
