Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881A31FF7C7
	for <syzbot@lists.linux.dev>; Sat, 10 Oct 2026 00:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791593925; cv=none; b=P/HzdbHBx61tdYNowuHk7IvKlJqUi6AqAJ9B3EXXcoIpyrCoZuFpQPvVh27zu7Y3AmfPCZ7YGF5etsp6CVNqmi7SsjyFUhS7zC4Jajot7tX3oya3jiHBhuclcFOB/MC/BPezu8Gy+3h13E3m3v9pl+9eQRRJBwjRmImEgBkUM+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791593925; c=relaxed/simple;
	bh=b585rXM1jDsHHS0HTzUddtr/0WhgGrWd/6rvKrv10f4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=vAakD2j5bqzApnjRULDreoDQo8WwgpzWZxNo2SrMyWVPAmAiw8+ENWnEjM/5USt9bIQXIgvmbyAHTdIDf9aY36X0osYKwKOwBDVX4YukCqGNkoTqUqerNCTXHgLechFFJyH5eDQoOPG1UgzkdhnuXsBJlRb0ahctsEHiAv09N+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b28deb7ee3so705237b6e.0
        for <syzbot@lists.linux.dev>; Fri, 09 Oct 2026 17:58:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791593922; x=1792198722;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=m2fcWhldlDNR0HBhmhAkY6YtyEyA/avE76JXznZp7qY=;
        b=ez9yKXwYeoEIqaX1yLx8W3t9wl/7A0ASp6EBtWfBSsjQfkzWyzyc8W/xVhsO8uLj0W
         gSl4fXqJpQgS03Tv59Lfp7thrgOQNTa10PIgek/KkcACXJZ7tlvjsFaNDL4nyiR5BF/s
         0KDCfRPnrN+GQwVdCunRqxiuIPR2/Yr2/0J7Nyf+rXbwhz6tIj8mC7VatLpohuIKaWk/
         dJ1VlYaT/9aFnsKzTLEtbuM4l3RuaV/QI81CLKSPfB9K97iq+QEeKVL4BMCS/ReG1lWT
         Uxe+E4QO4VuQGctzTkA9EYFHsCi3qJEvaisI2pcGmOvQoQ22B9Rkhko6s/okwRKSHqSw
         pVtA==
X-Gm-Message-State: AFq9FYJwas2vI8cUn77+VRzj3/3xtsmGh58Igfyxf8n06R9LUAQgK30i
	APTv+lwX2oMnqaAD6MeadH1SJC8fiNaeyfnoC7TUlWf+Sbf5e6A9PcXtUavgx4T4RTHZ07J95V3
	RBsQaP2okUNu0EJY7Dn42Ew9j4GKXXKpVh+EEjEJ2kbureldoseQt18XhA10=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1183:b0:4f7:27ba:9db4 with SMTP id
 5614622812f47-50c574a306cmr2782844b6e.60.1791593922078; Fri, 09 Oct 2026
 17:58:42 -0700 (PDT)
Date: Fri, 09 Oct 2026 17:58:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac98dc2.70ed5d86.2ac85.008c.GAE@google.com>
Subject: [moderation/CI] Re: Extend drm_ras for qaic telemetry
From: syzbot ci <syzbot+ci75bba038493d80b5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Extend drm_ras for qaic telemetry
https://lore.kernel.org/all/20261009173152.2436195-1-zachary.mckevitt@oss.q=
ualcomm.com
* [PATCH 1/3] drm/drm_ras: Remove admin-perm flag from list-nodes operation
* [PATCH 2/3] drm/drm_ras: Extend DRM RAS interface to include telemetry no=
des
* [PATCH 3/3] accel/qaic: Add callbacks for DRM RAS netlink telemetry

and found the following issue:
general protection fault in drm_ras_nl_pre_telemetry

Full report is available here:
https://ci.syzbot.org/series/6915fb7c-08cd-48b4-b8a4-3834f3e60de5

***

general protection fault in drm_ras_nl_pre_telemetry

tree:      drm-next
URL:       https://gitlab.freedesktop.org/drm/kernel.git
base:      f2bf20011b95401f63e573d54134544c452c4117
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/d48f7944-a0fb-4983-a3c6-c037c81dd83=
2/config
syz repro: https://ci.syzbot.org/findings/c2ca90ba-3f79-4e56-94d4-b1ddc6405=
6e5/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5808 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:nla_get_u32 include/net/netlink.h:1734 [inline]
RIP: 0010:drm_ras_nl_pre_telemetry+0x60/0xe0 drivers/gpu/drm/drm_ras.c:656
Code: 8b 1b 48 83 c3 08 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df =
e8 3e 3c 9a fc 48 8b 1b 48 83 c3 04 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38 8=
4 c0 75 5b 8b 33 48 c7 c7 80 d3 6f 90 e8 c9 8c 49
RSP: 0018:ffffc9000379f420 EFLAGS: 00010247
RAX: 0000000000000000 RBX: 0000000000000004 RCX: ffff8881bf17bc00
RDX: 0000000000000000 RSI: ffff8881bf38d380 RDI: ffffc9000379f600
RBP: ffffc9000379f588 R08: ffffc9000379f4ff R09: 0000000000000000
R10: ffffc9000379f4d0 R11: ffffffff859eb380 R12: ffffc9000379f600
R13: dffffc0000000000 R14: ffff8881bf38d380 R15: dffffc0000000000
FS:  00007f2c256e36c0(0000) GS:ffff8882a7cb6000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000100 CR3: 000000016e7ee000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 genl_family_rcv_msg_doit+0x1db/0x340 net/netlink/genetlink.c:1109
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2575
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1338 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1364
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2c2479e1d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2c256e3028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2c24a25fa0 RCX: 00007f2c2479e1d9
RDX: 0000000000000000 RSI: 0000200000000100 RDI: 0000000000000004
RBP: 00007f2c24835888 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2c24a26038 R14: 00007f2c24a25fa0 R15: 00007ffc88247b58
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nla_get_u32 include/net/netlink.h:1734 [inline]
RIP: 0010:drm_ras_nl_pre_telemetry+0x60/0xe0 drivers/gpu/drm/drm_ras.c:656
Code: 8b 1b 48 83 c3 08 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 df =
e8 3e 3c 9a fc 48 8b 1b 48 83 c3 04 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38 8=
4 c0 75 5b 8b 33 48 c7 c7 80 d3 6f 90 e8 c9 8c 49
RSP: 0018:ffffc9000379f420 EFLAGS: 00010247
RAX: 0000000000000000 RBX: 0000000000000004 RCX: ffff8881bf17bc00
RDX: 0000000000000000 RSI: ffff8881bf38d380 RDI: ffffc9000379f600
RBP: ffffc9000379f588 R08: ffffc9000379f4ff R09: 0000000000000000
R10: ffffc9000379f4d0 R11: ffffffff859eb380 R12: ffffc9000379f600
R13: dffffc0000000000 R14: ffff8881bf38d380 R15: dffffc0000000000
FS:  00007f2c256e36c0(0000) GS:ffff8882a7cb6000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2c247eb8c0 CR3: 000000016e7ee000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	8b 1b                	mov    (%rbx),%ebx
   2:	48 83 c3 08          	add    $0x8,%rbx
   6:	48 89 d8             	mov    %rbx,%rax
   9:	48 c1 e8 03          	shr    $0x3,%rax
   d:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
  12:	74 08                	je     0x1c
  14:	48 89 df             	mov    %rbx,%rdi
  17:	e8 3e 3c 9a fc       	call   0xfc9a3c5a
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	48 83 c3 04          	add    $0x4,%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 38       	movzbl (%rax,%r15,1),%eax <-- trapping instruct=
ion
  2f:	84 c0                	test   %al,%al
  31:	75 5b                	jne    0x8e
  33:	8b 33                	mov    (%rbx),%esi
  35:	48 c7 c7 80 d3 6f 90 	mov    $0xffffffff906fd380,%rdi
  3c:	e8                   	.byte 0xe8
  3d:	c9                   	leave
  3e:	8c                   	.byte 0x8c
  3f:	49                   	rex.WB


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
[airlied@gmail.com aravind.iddamsetty@linux.intel.com carl.vanderlip@oss.qu=
alcomm.com dri-devel@lists.freedesktop.org jeff.hugo@oss.qualcomm.com karol=
.wachowski@linux.intel.com kuba@kernel.org lizhi.hou@amd.com netdev@vger.ke=
rnel.org ogabbay@kernel.org raag.jadav@intel.com riana.tauro@intel.com rodr=
igo.vivi@intel.com simona.vetter@ffwll.ch troy.hanson@oss.qualcomm.com yous=
sef.abdulrahman@oss.qualcomm.com zachary.mckevitt@oss.qualcomm.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

